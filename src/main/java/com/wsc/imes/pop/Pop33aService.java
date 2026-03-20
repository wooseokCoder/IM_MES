/*
 * ============================================================================
 * 화면명: POP33A - SAP실적처리
 * ============================================================================
 * 설명: 일별 공수 현황 조회, 실적/삭제 현황 관리, SAP 전송, 제외 처리
 * 원본: ProActive POP33A.cs (CUBIZ_BR\BPOP\POP33A.cs)
 * 작성일: 2026-03-05
 * ============================================================================
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - POP33A_SER  → pop33aSer  (Grid1 일별 공수 조회)
 * - POP33A_SER2 → pop33aSer2 (Grid2 실적현황 조회)
 * - POP33A_SER3 → pop33aSer3 (Grid3 삭제현황 조회)
 * - POP33A_INS  → pop33aIns  (IF_SEL_FLAG 저장)
 * - POP33A_INS2 → pop33aIns2 (SAP 전송)
 * - POP33A_DEL  → pop33aDel  (실적 삭제)
 * - POP33A_DEL_CANCEL → pop33aDelCancel (삭제 취소/복원)
 * - POP33A_INS3 → pop33aIns3 (제외 여부 저장)
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
import com.wsc.framework.model.ResultMap;

/**
 * 공수오류현황 서비스
 * <p>
 * 3-Grid Master-Detail 구조:
 * Grid1(일별 공수) → Grid2(실적현황 탭) / Grid3(삭제현황 탭)
 * </p>
 *
 * @author MES
 * @since 2026-03-05
 */
@Service
public class Pop33aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Pop33aService.class);

    // ========================================================================
    // Namespace 상수
    // ========================================================================
    /** TSHP_ACTUAL CRUD (UPD11, SER2, DEL, INS3) */
    private static final String NS_ACTUAL = "com.wsc.imes.pop.TSHP_ACTUAL";
    /** TSHP_ACTUAL_QUERY 조회 (QUERY22, QUERY15_1, QUERY15_2) */
    private static final String NS_ACTUAL_QUERY = "com.wsc.imes.pop.TSHP_ACTUAL_QUERY";
    // NS_ACTUAL_DEL, NS_IDLETIME: 래퍼 SP(sp_imes_tshp_actual_idletime_del/_del_restore)로
    // 통합되어 더 이상 개별 mapper 호출 불필요
    /** TSHP_SAP_ACT_SEND_LOG (SER, INS, UPD) */
    private static final String NS_SAP_LOG = "com.wsc.imes.pop.TSHP_SAP_ACT_SEND_LOG";
    /** TSHP_WORK_EXCEPT (SER, INS, UPD) */
    private static final String NS_WORK_EXCEPT = "com.wsc.imes.pop.TSHP_WORK_EXCEPT";

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
    // POP33A_SER: Grid1 일별 공수 조회
    // 원본: POP33A.POP33A_SER() → QUERY22
    // SAP_TIME=0→ACT_TIME 대체 로직은 SP(QUERY22) 내 CASE문으로 처리
    // ========================================================================

    /**
     * Grid1 일별 공수 조회
     * <p>
     * SAP_TIME=0이면 ACT_TIME 대체 로직은 SP(sp_imes_tshp_actual_query22)에서 처리
     * </p>
     *
     * @param params sWorkDate(시작일), eWorkDate(종료일), empLike(작업자명/번호), empGubun2(구분)
     * @return 일별 공수 목록
     */
    public Object pop33aSer(ParamsMap params) {
        logger.debug("POP33A_SER: sWorkDate={}, eWorkDate={}", params.get("sWorkDate"), params.get("eWorkDate"));

        // QUERY22 호출 (SAP_TIME 대체 로직 SP 내 CASE문 처리)
        return searchByMapper(NS_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY22", params);
    }

    // ========================================================================
    // POP33A_SER2: Grid2 실적현황 조회
    // 원본: POP33A.POP33A_SER2() → QUERY15_1
    // SEL 컬럼 로직은 SP(QUERY15_1) 내 윈도우 함수 CASE문으로 처리
    // ========================================================================

    /**
     * Grid2 실적현황 조회
     * <p>
     * SEL 컬럼 로직(IF_SEL_FLAG 분기 + 전체 0건→전부 '1')은
     * SP(sp_imes_tshp_actual_query15_1)에서 윈도우 함수로 처리
     * </p>
     *
     * @param params pltCode(공장코드), empCode(사원코드), workDate(작업일)
     * @return 실적현황 목록 (SEL 컬럼 포함)
     */
    public Object pop33aSer2(ParamsMap params) {
        logger.debug("POP33A_SER2: empCode={}, workDate={}", params.get("empCode"), params.get("workDate"));

        // QUERY15_1 호출 (SEL 컬럼 로직 SP 내 윈도우 함수 처리)
        return searchByMapper(NS_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY15_1", params);
    }

    // ========================================================================
    // POP33A_SER3: Grid3 삭제현황 조회
    // 원본: POP33A.POP33A_SER3() → QUERY15_2
    // SEL 컬럼은 SP(QUERY15_2)에서 빈값으로 처리
    // ========================================================================

    /**
     * Grid3 삭제현황 조회
     * <p>
     * SEL 컬럼(빈값)은 SP(sp_imes_tshp_actual_query15_2)에서 처리
     * </p>
     *
     * @param params pltCode(공장코드), empCode(사원코드), workDate(작업일)
     * @return 삭제현황 목록 (SEL 컬럼 포함)
     */
    public Object pop33aSer3(ParamsMap params) {
        logger.debug("POP33A_SER3: empCode={}, workDate={}", params.get("empCode"), params.get("workDate"));

        // QUERY15_2 호출 (SEL 컬럼 SP 내 빈값 처리)
        return searchByMapper(NS_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY15_2", params);
    }

    // ========================================================================
    // POP33A_INS: IF_SEL_FLAG 저장
    // 원본: POP33A.POP33A_INS()
    // rows 반복, KEY 앞자리 분기 (ACT→UPD11, IL→UPD8)
    // ========================================================================

    /**
     * IF_SEL_FLAG 저장
     * <p>
     * KEY 앞자리로 분기: ACT→TSHP_ACTUAL_UPD11, IL→TSHP_IDLETIME_UPD8
     * </p>
     *
     * @param params rows (저장 대상 행 목록: KEY, IF_SEL_FLAG)
     * @return 저장 결과
     */
    @Transactional
    @SuppressWarnings("unchecked")
    public ResultMap pop33aIns(ParamsMap params) {
        try {
            List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
            if (rows == null || rows.isEmpty()) {
                return failure("저장할 데이터가 없습니다.");
            }

            for (int i = 0; i < rows.size(); i++) {
                Map<String, Object> row = rows.get(i);
                ParamsMap rowParams = new ParamsMap();
                rowParams.putAll(row);
                rowParams.put("gsPltCode", params.get("gsPltCode"));
                rowParams.put("gsUserId", params.get("gsUserId"));

                String key = rowParams.getString("key");
                if (key == null) key = rowParams.getString("KEY");
                if (key == null) continue;

                // IF_SEL_FLAG 업데이트 (SP 내에서 ACT/IL 분기 처리)
                rowParams.put("key", key);
                updateByMapper(NS_ACTUAL, "POP33A_UPD_SEL_FLAG", rowParams);
            }

            logger.info("POP33A_INS 완료: {} 건 처리", Integer.valueOf(rows.size()));
            return success("저장되었습니다.");
        } catch (Exception e) {
            logger.error("POP33A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP33A_INS2: SAP 전송
    // 원본: POP33A.POP33A_INS2()
    // (1) SAP 로그 UPSERT (SER→INS/UPD)
    // (2) rows 반복 UPD11/UPD8
    // ========================================================================

    /**
     * SAP 전송
     * <p>
     * 1. SAP 전송 로그 UPSERT (INSERT ON DUPLICATE KEY UPDATE, SP에서 1회 처리)
     * 2. 각 행의 IF_SEL_FLAG 업데이트 (ACT→UPD11, IL→UPD8)
     * </p>
     *
     * @param params empCode(사원코드), workDate(작업일), sendFlag(전송상태), rows(상세행)
     * @return 전송 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap pop33aIns2(ParamsMap params) {
        try {
            // (1) SAP 전송 로그 UPSERT (INSERT ON DUPLICATE KEY UPDATE)
            insertByMapper(NS_SAP_LOG, "TSHP_SAP_ACT_SEND_LOG_SAVE", params);

            // (2) 상세 행 IF_SEL_FLAG 업데이트 (SP 내에서 ACT/IL 분기 처리)
            List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
            if (rows != null) {
                for (int i = 0; i < rows.size(); i++) {
                    Map<String, Object> row = rows.get(i);
                    ParamsMap rowParams = new ParamsMap();
                    rowParams.putAll(row);
                    rowParams.put("gsPltCode", params.get("gsPltCode"));
                    rowParams.put("gsUserId", params.get("gsUserId"));

                    String key = rowParams.getString("key");
                    if (key == null) key = rowParams.getString("KEY");
                    if (key == null) continue;

                    rowParams.put("key", key);
                    updateByMapper(NS_ACTUAL, "POP33A_UPD_SEL_FLAG", rowParams);
                }
            }

            logger.info("POP33A_INS2 SAP전송 완료: empCode={}, workDate={}",
                    params.get("empCode"), params.get("workDate"));
            return success("SAP 전송되었습니다.");
        } catch (Exception e) {
            logger.error("POP33A_INS2 실패", e);
            return failure("SAP 전송 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP33A_DEL: 실적 삭제
    // 원본: POP33A.POP33A_DEL()
    // rows 반복, KEY 분기:
    //   ACT: SER2(조회)→DEL_INS(백업)→DEL(삭제)
    //   IL: UDE(DATA_FLAG=2, 논리삭제)
    // ========================================================================

    /**
     * 실적 삭제
     * <p>
     * ACT: TSHP_ACTUAL → TSHP_ACTUAL_DEL 백업 후 물리 삭제
     * IL: TSHP_IDLETIME → DATA_FLAG=2 논리 삭제
     * </p>
     *
     * @param params rows (삭제 대상 행 목록: KEY)
     * @return 삭제 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap pop33aDel(ParamsMap params) {
        try {
            List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
            if (rows == null || rows.isEmpty()) {
                return failure("삭제할 데이터가 없습니다.");
            }

            for (int i = 0; i < rows.size(); i++) {
                Map<String, Object> row = rows.get(i);
                String key = (String) row.get("key");
                if (key == null) key = (String) row.get("KEY");
                if (key == null) continue;

                // SP 내부에서 ACT/IL 분기 처리 (백업+삭제 / 논리삭제)
                ParamsMap rowParams = new ParamsMap();
                rowParams.put("gsPltCode", params.get("gsPltCode"));
                rowParams.put("gsUserId", params.get("gsUserId"));
                rowParams.put("key", key);
                updateByMapper(NS_ACTUAL, "TSHP_ACTUAL_IDLETIME_DEL", rowParams);
            }

            logger.info("POP33A_DEL 완료: {} 건 삭제", Integer.valueOf(rows.size()));
            return success("삭제되었습니다.");
        } catch (Exception e) {
            logger.error("POP33A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP33A_DEL_CANCEL: 삭제 취소 (복원)
    // 원본: POP33A.POP33A_DEL_CANCEL()
    // rows 반복, KEY 분기:
    //   ACT: DEL_SER(백업조회)→INS3(원본복원)→DEL_DEL(백업삭제)
    //   IL: UDE_RESTORE(DATA_FLAG=0, 복원)
    // ========================================================================

    /**
     * 삭제 취소 (복원)
     * <p>
     * ACT: TSHP_ACTUAL_DEL에서 복원 → TSHP_ACTUAL로 INSERT 후 백업 삭제
     * IL: TSHP_IDLETIME → DATA_FLAG=0 복원 (sp_imes_tshp_idletime_ude_restore 호출)
     * </p>
     * <p>
     * 주의: IL 복원 시 기존 UDE SP(DATA_FLAG=2 하드코딩)를 사용할 수 없으므로,
     * 별도의 TSHP_IDLETIME_UDE_RESTORE mapper + sp_imes_tshp_idletime_ude_restore SP를 사용한다.
     * </p>
     *
     * @param params rows (복원 대상 행 목록: KEY)
     * @return 복원 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap pop33aDelCancel(ParamsMap params) {
        try {
            List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
            if (rows == null || rows.isEmpty()) {
                return failure("복원할 데이터가 없습니다.");
            }

            for (int i = 0; i < rows.size(); i++) {
                Map<String, Object> row = rows.get(i);
                String key = (String) row.get("key");
                if (key == null) key = (String) row.get("KEY");
                if (key == null) continue;

                // SP 내부에서 ACT/IL 분기 처리 (복원+백업삭제 / DATA_FLAG=0)
                ParamsMap rowParams = new ParamsMap();
                rowParams.put("gsPltCode", params.get("gsPltCode"));
                rowParams.put("gsUserId", params.get("gsUserId"));
                rowParams.put("key", key);
                updateByMapper(NS_ACTUAL, "TSHP_ACTUAL_IDLETIME_DEL_RESTORE", rowParams);
            }

            logger.info("POP33A_DEL_CANCEL 완료: {} 건 복원", Integer.valueOf(rows.size()));
            return success("삭제가 취소되었습니다.");
        } catch (Exception e) {
            logger.error("POP33A_DEL_CANCEL 실패", e);
            return failure("삭제 취소 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP33A_INS3: 제외 여부 저장
    // 원본: POP33A.POP33A_INS3()
    // rows 반복, WORK_EXCEPT UPSERT (SER→INS/UPD)
    // ========================================================================

    /**
     * 제외 여부 저장
     * <p>
     * TSHP_WORK_EXCEPT UPSERT: INSERT ... ON DUPLICATE KEY UPDATE
     * SP(sp_imes_tshp_work_except_save)에서 1회 호출로 처리
     * </p>
     *
     * @param params rows (저장 대상 행 목록: WORK_DATE, EMP_CODE, IS_EXCEPT)
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap pop33aIns3(ParamsMap params) {
        try {
            List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
            if (rows == null || rows.isEmpty()) {
                return failure("저장할 데이터가 없습니다.");
            }

            for (int i = 0; i < rows.size(); i++) {
                Map<String, Object> row = rows.get(i);
                ParamsMap rowParams = new ParamsMap();
                rowParams.putAll(row);
                rowParams.put("gsPltCode", params.get("gsPltCode"));
                rowParams.put("gsUserId", params.get("gsUserId"));

                // WORK_EXCEPT UPSERT (INSERT ON DUPLICATE KEY UPDATE)
                insertByMapper(NS_WORK_EXCEPT, "TSHP_WORK_EXCEPT_SAVE", rowParams);
            }

            logger.info("POP33A_INS3 제외 저장 완료: {} 건", Integer.valueOf(rows.size()));
            return success("저장되었습니다.");
        } catch (Exception e) {
            logger.error("POP33A_INS3 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }
}
