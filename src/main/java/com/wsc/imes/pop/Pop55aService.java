/*
 * ============================================================================
 * 화면명: POP55A - NAM공정 NG파일배포 확인
 * ============================================================================
 * 설명: NAM공정 NG파일 배포 확인 상태 조회, 확인 저장, cascade 삭제
 * 원본: ProActive POP55A.cs (CUBIZ_BR\BPOP\POP55A.cs)
 * 작성일: 2026-03-07
 * ============================================================================
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - POP55A_SER  → pop55aSer  (Grid1 메인 조회, QUERY22)
 * - POP55A_SER2 → pop55aSer2 (Grid2 상세 조회, QUERY23)
 * - POP55A_INS  → pop55aIns  (확인 저장: 마스터 UPSERT + 상세 INS)
 * - POP55A_UDE  → pop55aUde  (cascade 삭제: CHK + MASTER + WORK)
 */
package com.wsc.imes.pop;

import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.model.ResultMap;

/**
 * NAM공정 NG파일배포 확인 서비스
 * <p>
 * 2-Grid Master-Detail 구조:
 * Grid1(제품 목록 + 확인 상태) → Grid2(파일 상세)
 * </p>
 *
 * @author MES
 * @since 2026-03-07
 */
@Service
public class Pop55aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Pop55aService.class);

    // ========================================================================
    // Namespace 상수
    // ========================================================================
    /** TSHP_NG_FILE_CHK (QUERY22, QUERY23, DEL) */
    private static final String NS_CHK = "com.wsc.imes.pop.TSHP_NG_FILE_CHK";
    /** TSHP_NG_FILE_WORK_MASTER CRUD (SER, INS, UPD, DEL) */
    private static final String NS_WORK_MASTER = "com.wsc.imes.pop.TSHP_NG_FILE_WORK_MASTER";
    /** TSHP_NG_FILE_WORK (SER, INS, DEL) */
    private static final String NS_WORK = "com.wsc.imes.pop.TSHP_NG_FILE_WORK";

    @Autowired
    private CommonDao dao;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Override
    protected BaseDao getDao() {
        return this.dao;
    }

    @Override
    protected MessageSource getMessageSource() {
        return this.messageSource;
    }

    @Override
    protected SessionComponent getSessionComponent() {
        return sessionProvider.get();
    }

    // ========================================================================
    // POP55A_SER: Grid1 메인 조회 (QUERY22)
    // 원본: POP55A.POP55A_SER() → QUERY22
    // NG파일배포 제품 목록 + 확인 상태, NAM 공정 여부, MC번호
    // ========================================================================

    /**
     * Grid1 메인 조회 - NG파일배포 제품 목록
     * <p>
     * QUERY22 호출: 제품별 확인 상태, NAM 공정 여부, MC번호 포함
     * 동적 조건: 납기일, 호기, 오더, 고객, 제품코드, 제품유형, MC번호
     * </p>
     *
     * @param params gsPltCode, sIndueDate, eIndueDate, hogiLike, orderLike,
     *               customerLike, prodCode, prodType, mcNoLike
     * @return 제품 목록
     */
    public Object pop55aSer(ParamsMap params) {
        logger.debug("POP55A_SER: pltCode={}, sIndueDate={}, eIndueDate={}",
                new Object[]{params.get("gsPltCode"), params.get("sIndueDate"), params.get("eIndueDate")});

        return searchByMapper(NS_CHK, "QUERY22", params);
    }

    // ========================================================================
    // POP55A_SER2: Grid2 상세 조회 (QUERY23)
    // 원본: POP55A.POP55A_SER2() → QUERY23
    // 선택된 제품의 NG파일 목록 + 확인자/등록자 정보
    // ========================================================================

    /**
     * Grid2 상세 조회 - 선택 제품의 파일 목록
     * <p>
     * QUERY23 호출: 파일명, 공정, 확인자, 등록자, 등록일 포함
     * </p>
     *
     * @param params gsPltCode, prodCode, model
     * @return 파일 목록
     */
    public Object pop55aSer2(ParamsMap params) {
        logger.debug("POP55A_SER2: prodCode={}, model={}", params.get("prodCode"), params.get("model"));

        return searchByMapper(NS_CHK, "QUERY23", params);
    }

    // ========================================================================
    // POP55A_INS: 확인 저장
    // 원본: POP55A.POP55A_INS()
    // (1) TSHP_NG_FILE_WORK_MASTER UPSERT (SER→INS/UPD)
    // (2) detailRows 루프: TSHP_NG_FILE_WORK SER→INS (중복 방지)
    // ========================================================================

    /**
     * 확인 저장
     * <p>
     * 처리 흐름:
     * 1. TSHP_NG_FILE_WORK_MASTER 존재 여부 확인 (SER)
     * 2-a. 없으면 → INSERT (INS)
     * 2-b. 있으면 → UPDATE (UPD)
     * 3. detailRows 루프: 각 행 SER → 미존재 시 INS
     * </p>
     *
     * @param params gsPltCode, gsUserId, prodCode, workFlag, scomment, detailRows
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap pop55aIns(ParamsMap params) {
        try {
            String prodCode = params.getString("prodCode");
            if (prodCode == null || prodCode.isEmpty()) {
                return failure("제품코드가 없습니다.");
            }

            // (1) TSHP_NG_FILE_WORK_MASTER UPSERT
            RecordMap master = (RecordMap) selectByMapper(NS_WORK_MASTER, "SER", params);
            if (master == null || master.isEmpty()) {
                // 신규 등록
                insertByMapper(NS_WORK_MASTER, "INS", params);
                logger.debug("POP55A_INS: WORK_MASTER 신규 등록 prodCode={}", prodCode);
            } else {
                // 수정
                updateByMapper(NS_WORK_MASTER, "UPD", params);
                logger.debug("POP55A_INS: WORK_MASTER 수정 prodCode={}", prodCode);
            }

            // (2) detailRows 루프: TSHP_NG_FILE_WORK SER→INS (중복 방지)
            List<Map<String, Object>> detailRows = (List<Map<String, Object>>) params.get("detailRows");
            int insertCount = 0;
            if (detailRows != null && !detailRows.isEmpty()) {
                for (int i = 0; i < detailRows.size(); i++) {
                    Map<String, Object> row = detailRows.get(i);
                    ParamsMap rowParams = new ParamsMap();
                    rowParams.putAll(row);
                    rowParams.put("gsPltCode", params.get("gsPltCode"));
                    rowParams.put("gsUserId", params.get("gsUserId"));

                    // 중복 확인
                    RecordMap existing = (RecordMap) selectByMapper(NS_WORK, "SER", rowParams);
                    if (existing == null || existing.isEmpty()) {
                        insertByMapper(NS_WORK, "INS", rowParams);
                        insertCount++;
                    }
                }
            }

            logger.info("POP55A_INS 완료: prodCode={}, 상세 {} 건 등록",
                    prodCode, Integer.valueOf(insertCount));
            return success("저장되었습니다.");
        } catch (Exception e) {
            logger.error("POP55A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP55A_UDE: cascade 삭제
    // 원본: POP55A.POP55A_UDE()
    // (1) TSHP_NG_FILE_CHK DEL
    // (2) TSHP_NG_FILE_WORK_MASTER DEL
    // (3) TSHP_NG_FILE_WORK DEL
    // 모두 PROD_CODE 기반 일괄 삭제
    // ========================================================================

    /**
     * cascade 삭제
     * <p>
     * 처리 흐름 (순서 중요: FK 관계 고려):
     * 1. TSHP_NG_FILE_CHK 삭제 (PROD_CODE 기반)
     * 2. TSHP_NG_FILE_WORK_MASTER 삭제
     * 3. TSHP_NG_FILE_WORK 삭제 (PROD_CODE 기반)
     * </p>
     *
     * @param params gsPltCode, prodCode
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap pop55aUde(ParamsMap params) {
        try {
            String prodCode = params.getString("prodCode");
            if (prodCode == null || prodCode.isEmpty()) {
                return failure("제품코드가 없습니다.");
            }

            // (1) TSHP_NG_FILE_CHK 삭제
            deleteByMapper(NS_CHK, "DEL", params);

            // (2) TSHP_NG_FILE_WORK_MASTER 삭제
            deleteByMapper(NS_WORK_MASTER, "DEL", params);

            // (3) TSHP_NG_FILE_WORK 삭제
            deleteByMapper(NS_WORK, "DEL", params);

            logger.info("POP55A_UDE cascade 삭제 완료: prodCode={}", prodCode);
            return success("삭제되었습니다.");
        } catch (Exception e) {
            logger.error("POP55A_UDE 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }
}
