/*
 * ============================================================================
 * 화면명: STD13A - 부서/사원 관리
 * ============================================================================
 * 설명: 부서 트리 조회, 사원 목록 조회(읽기전용), 부서 CRUD
 * 원본: ProActive STD13A.cs
 *       TSTD_ORG.cs, TSTD_ORG_QUERY.cs, TSTD_EMPLOYEE_QUERY.cs
 * 작성일: 2026-02-11
 * ============================================================================
 * TSTD_EMPLOYEE → sys_user 전환 적용
 * ============================================================================
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - STD13A_SER → std13aSer
 * - STD13A_SER2 → std13aSer2
 * - STD13A_INS → std13aIns
 * - STD13A_DEL → std13aDel
 */
package com.wsc.imes.std;

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
 * 부서/사원 관리 서비스
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Std13aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std13aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS = "com.wsc.imes.std.TSTD_ORG";
    private static final String NS_QUERY = "com.wsc.imes.std.TSTD_ORG_QUERY";

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
        return this.sessionProvider.get();
    }

    // ========================================================================
    // STD13A_SER: 부서 트리 조회
    // 원본: STD13A.STD13A_SER() → TSTD_ORG_QUERY.TSTD_ORG_QUERY2()
    // ========================================================================

    /**
     * 부서 트리 조회
     *
     * @param params empType (사원유형 필터), empLike (사원 검색어)
     * @return 부서 목록 (treegrid용)
     */
    public Object std13aSer(ParamsMap params) {
        logger.debug("STD13A_SER: empType={}, empLike={}",
                params.get("empType"), params.get("empLike"));

        // 기본값: 정상 데이터만 조회
        params.put("dataFlag", 0);

        return searchByMapper(NS_QUERY, "TSTD_ORG_QUERY2", params);
    }

    // ========================================================================
    // STD13A_SER2: 사원 목록 조회 (읽기전용)
    // 원본: STD13A.STD13A_SER2() → TSTD_EMPLOYEE_QUERY.TSTD_EMPLOYEE_QUERY1()
    // 변환: sys_user 기반 조회
    // ========================================================================

    /**
     * 사원 목록 조회 (읽기전용)
     *
     * @param params orgCode (부서코드), empLike (사원 검색어)
     * @return 사원 목록
     */
    public Object std13aSer2(ParamsMap params) {
        logger.debug("STD13A_SER2: orgCode={}, empLike={}",
                params.get("orgCode"), params.get("empLike"));

        return searchByMapper(NS_QUERY, "SYSUSER_QUERY1", params);
    }

    // ========================================================================
    // STD13A_INS: 부서 저장 (UPSERT) - OVERWRITE 패턴
    // 원본: STD13A.STD13A_INS() → TSTD_ORG.TSTD_ORG_SER/INS/UPD
    // ========================================================================

    /**
     * 부서 저장 - UPSERT
     *
     * OVERWRITE 처리:
     * - orgCode 존재 + dataFlag=0 + overwrite!=1: 정상 수정 (UPD)
     * - orgCode 존재 + dataFlag=2 + overwrite!=1: errorCode=DELETED 반환
     * - orgCode 존재 + overwrite=1: 복원 (UPD, DATA_FLAG→0)
     * - orgCode 미존재: 신규 등록 (INS)
     *
     * @param params orgCode, orgName, orgParent, orgLeader, orgSeq, costCenter, overwrite
     * @return 저장 결과
     */
    @Transactional
    public ResultMap std13aIns(ParamsMap params) {
        try {
            String orgCode = params.getString("orgCode");
            String overwrite = params.getString("overwrite");

            if (orgCode == null || orgCode.isEmpty()) {
                return failure("부서코드를 입력하세요.");
            }

            // 존재 여부 확인
            RecordMap existing = (RecordMap) selectByMapper(NS, "TSTD_ORG_SER", params);

            if (existing != null && !existing.isEmpty()) {
                String dataFlag = String.valueOf(existing.get("dataFlag"));

                if (!"1".equals(overwrite)) {
                    if ("2".equals(dataFlag)) {
                        // 삭제된 부서 → errorCode=DELETED 반환 (복원 확인)
                        ResultMap result = failure("삭제된 부서코드입니다. 복원하시겠습니까?");
                        result.put("errorCode", "DELETED");
                        result.put("delDate", existing.get("delDate"));
                        result.put("delEmp", existing.get("delEmp"));
                        logger.debug("부서코드 삭제됨: orgCode={}", orgCode);
                        return result;
                    }
                    // dataFlag=0: 정상 수정
                }

                // UPDATE (수정 또는 복원)
                updateByMapper(NS, "TSTD_ORG_UPD", params);
                logger.info("TSTD_ORG_UPD 완료: orgCode={}", orgCode);
                return success("저장되었습니다.");
            }

            // 신규 INSERT
            insertByMapper(NS, "TSTD_ORG_INS", params);
            logger.info("TSTD_ORG_INS 완료: orgCode={}", orgCode);
            return success("저장되었습니다.");

        } catch (Exception e) {
            logger.error("STD13A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // STD13A_DEL: 부서 삭제 (논리삭제) - 사원 존재 시 차단
    // 원본: STD13A.STD13A_DEL() → TSTD_ORG.TSTD_ORG_UDE()
    // ========================================================================

    /**
     * 부서 삭제
     * 소속 사원이 존재하면 삭제를 차단한다.
     *
     * @param params orgCode (삭제 대상 부서코드)
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap std13aDel(ParamsMap params) {
        try {
            String orgCode = params.getString("orgCode");

            if (orgCode == null || orgCode.isEmpty()) {
                return failure("삭제할 부서를 선택하세요.");
            }

            // 소속 사원 수 확인
            RecordMap countResult = (RecordMap) selectByMapper(
                    NS_QUERY, "SYSUSER_EMP_COUNT", params);

            if (countResult != null) {
                int cnt = Integer.parseInt(String.valueOf(countResult.get("cnt")));
                if (cnt > 0) {
                    return failure("해당 부서에 사원이 " + cnt + "명 존재합니다. 사원을 먼저 이동하세요.");
                }
            }

            // 논리삭제
            updateByMapper(NS, "TSTD_ORG_UDE", params);
            logger.info("STD13A_DEL 완료: orgCode={}", orgCode);
            return success("삭제되었습니다.");

        } catch (Exception e) {
            logger.error("STD13A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

}
