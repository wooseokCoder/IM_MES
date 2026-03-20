/*
 * ============================================================================
 * 화면명: POB32A - 비가동 현황 (조립)
 * ============================================================================
 * 설명: 비가동(설비 정지) 이력 조회, 논리 삭제
 * 원본: ProActive POP32A.cs (CUBIZ_BR\BPOP\POP32A.cs)
 *       TSHP_IDLETIME.cs (UDE)
 *       TSHP_IDLETIME_QUERY.cs (QUERY2)
 * 작성일: 2026-03-04
 * ============================================================================
 * 참고: D0A(등록팝업)/D2A(수정팝업) 관련 서비스는 별도 개발자가 담당
 *       본 클래스에는 메인 화면 전용 서비스만 포함
 * ============================================================================
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - POP32A_SER  → pop32aSer  (비가동 현황 조회)
 * - POP32A_DEL  → pop32aDel  (논리 삭제)
 */
package com.wsc.imes.pop;

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
import com.wsc.imes.common.UtilityService;

/**
 * 비가동 현황 (조립) 서비스
 * <p>
 * 메인 그리드: 비가동 이력 조회 (날짜 범위 검색)
 * 삭제: 논리 삭제 (DATA_FLAG = 2)
 * </p>
 *
 * @author MES
 * @since 2026-03-04
 */
@Service
public class Pop32aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Pop32aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    /** TSHP_IDLETIME CRUD 매퍼 (UDE) */
    private static final String NS = "com.wsc.imes.pop.TSHP_IDLETIME";
    /** TSHP_IDLETIME_QUERY 조회 매퍼 (QUERY2) */
    private static final String NS_QUERY = "com.wsc.imes.pop.TSHP_IDLETIME_QUERY";
    
//    private static final String NS_TSHP_IDLETIME = "com.wsc.imes.pop.TSHP_IDLETIME";
//    private static final String NS_TSHP_IDLETIME_QUERY = "com.wsc.imes.pop.TSHP_IDLETIME_QUERY";
    private static final String NS_TSTD_EMPLOYEE_QUERY = "com.wsc.imes.std.TSTD_EMPLOYEE_QUERY";
    private static final String NS_TSTD_IDLECODE = "com.wsc.imes.std.TSTD_IDLECODE";

    @Autowired
    private CommonDao dao;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private Provider<SessionComponent> sessionProvider;
    
    @Autowired
    private UtilityService utilityService;

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
    // POP32A_SER: 비가동 현황 조회
    // 원본: POP32A.POP32A_SER() → TSHP_IDLETIME_QUERY.TSHP_IDLETIME_QUERY2()
    // JOIN: LSE_MACHINE(설비명), TSTD_EMPLOYEE(작업자명/등록자명), TSTD_IDLECODE(비가동명)
    // 검색조건: 날짜 범위 (startDate ~ endDate)
    // ========================================================================

    /**
     * 비가동 현황 조회 (메인 그리드)
     * <p>
     * AS-IS BR 로직:
     *   UTIL.SetBizAddColumnToValue(RQSTDT, "MC_GROUP", "PLANTS") → MC_GROUP = 공장코드
     *   UTIL.SetBizAddColumnToValue(RQSTDT, "DATA_FLAG", 0)       → 활성 데이터만 조회
     * </p>
     *
     * @param params startDate (시작일, yyyyMMdd), endDate (종료일, yyyyMMdd)
     * @return 비가동 목록 (설비명, 작업자명, 비가동명, 등록자명 JOIN)
     */
    public Object pop32aSer(ParamsMap params) {
        logger.debug("POP32A_SER: startDate={}, endDate={}",
                params.get("startDate"), params.get("endDate"));

        // AS-IS: DATA_FLAG = 0 (활성 데이터만 조회, 삭제(2) 제외)
        // MC_GROUP은 Mapper에서 gsPltCode를 그대로 사용 (AS-IS: PLANTS 값 복사)
//        params.put("dataFlag", Integer.valueOf(0));
        
        // 기본값 설정
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }
        // MC_GROUP = PLANTS 매핑
        if (params.get("plants") != null && params.get("mcGroup") == null) {
            params.put("mcGroup", params.get("plants"));
        }

        return searchByMapper(NS_QUERY, "TSHP_IDLETIME_QUERY2", params);
    }

    // ========================================================================
    // POP32A_DEL: 비가동 삭제 (논리삭제)
    // 원본: POP32A.POP32A_DEL() → TSHP_IDLETIME.TSHP_IDLETIME_UDE()
    // 삭제 방식: DATA_FLAG = 2로 논리 삭제 (물리 삭제 아님)
    // ========================================================================

    /**
     * 비가동 삭제 (논리 삭제)
     *
     * @param params idleId (삭제 대상 비가동ID)
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap pop32aDel(ParamsMap params) {
        try {
            String idleId = params.getString("idleId");

            if (idleId == null || idleId.isEmpty()) {
                return failure("삭제할 비가동 데이터를 선택하세요.");
            }

            // 논리 삭제 (DATA_FLAG = 2)
            updateByMapper(NS, "TSHP_IDLETIME_UDE", params);
            logger.info("POP32A_DEL 완료: idleId={}", idleId);

            return success("삭제되었습니다.");

        } catch (Exception e) {
            logger.error("POP32A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }
    
    
    /**
     * 비가동시간 목록 조회
     *
     * @param params sIdleDate (시작일), eIdleDate (종료일), plants (공장코드)
     * @return 목록 조회 결과
     */
//    public Object pop32aSer(ParamsMap params) {
//        logger.debug("POP32A_SER: sIdleDate={}, eIdleDate={}, plants={}", 
//        		 new Object[]{ params.get("sIdleDate"), params.get("eIdleDate"), params.get("plants") });
//
//        // 기본값 설정
//        if (params.get("dataFlag") == null) {
//            params.put("dataFlag", 0);
//        }
//        // MC_GROUP = PLANTS 매핑
//        if (params.get("plants") != null && params.get("mcGroup") == null) {
//            params.put("mcGroup", params.get("plants"));
//        }
//
//        return searchByMapper(NS_TSHP_IDLETIME_QUERY, "TSHP_IDLETIME_QUERY2", params);
//    }

    // ========================================================================
    // POP32A_SER2: 작업자 목록 조회
    // TSTD_EMPLOYEE_QUERY.TSTD_EMPLOYEE_QUERY6 호출
    // ========================================================================

    /**
     * 작업자 목록 조회
     *
     * @param params plants (공장코드)
     * @return 작업자 목록 조회 결과
     */
    public Object pop32aSer2(ParamsMap params) {
        logger.debug("POP32A_SER2: plants={}", params.get("plants"));

        // PLANTS = MC_GROUP 매핑
        if (params.get("plants") != null && params.get("mcGroup") == null) {
            params.put("mcGroup", params.get("plants"));
        }

        return searchByMapper(NS_TSTD_EMPLOYEE_QUERY, "TSTD_EMPLOYEE_QUERY6", params);
    }

    // ========================================================================
    // POP32A_IDLE: 비가동코드 목록 조회
    // TSTD_IDLECODE.TSTD_IDLECODE_SER2 호출
    // ========================================================================

    /**
     * 비가동코드 목록 조회
     *
     * @param params pltCode (공장코드)
     * @return 비가동코드 목록 조회 결과
     */
    public Object pop32aIdle(ParamsMap params) {
        logger.debug("POP32A_IDLE: pltCode={}", params.get("pltCode"));

        return searchByMapper(NS_TSTD_IDLECODE, "TSTD_IDLECODE_SER2", params);
    }

    // ========================================================================
    // POP32A_INS: 비가동시간 등록
    // TSHP_IDLETIME.TSHP_IDLETIME_INS 호출
    // ========================================================================

    /**
     * 비가동시간 등록
     *
     * @param params 저장 데이터 (workDate, mcCode, empCode, idleCode, startTime, endTime, idleTime, scomment 등)
     * @return 저장 결과
     */
    @Transactional
    public Object pop32aIns(ParamsMap params) {
        try {
            String pltCode = params.getString("gsPltCode");
            logger.debug("POP32A_INS: pltCode={}", pltCode);

            // IDLE_ID 채번 (IL + YYYYMMDD 형식)
            String newIdleId = utilityService.getSerialNo(pltCode, "IL");
            params.put("idleId", newIdleId);

            // INSERT 실행
            insertByMapper(NS, "TSHP_IDLETIME_INS", params);
            logger.info("POP32A_INS 완료: idleId={}", newIdleId);

            return success("등록되었습니다.");

        } catch (Exception e) {
            logger.error("POP32A_INS 실패", e);
            return failure("등록 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP32A_INS2: 비가동시간 수정
    // TSHP_IDLETIME.TSHP_IDLETIME_UPD3 호출
    // ========================================================================

    /**
     * 비가동시간 수정
     *
     * @param params 수정 데이터 (idleId, idleState 등)
     * @return 수정 후 목록 재조회 결과 또는 에러코드
     */
    @Transactional
    public Object pop32aIns2(ParamsMap params) {
        try {
            String idleId = params.getString("idleId");
            logger.debug("POP32A_INS2: idleId={}", idleId);

            if (idleId == null || idleId.isEmpty()) {
                return failure("수정할 항목을 선택하세요.");
            }

            // 기존 데이터 조회 (IF_FLAG 확인용)
            RecordMap existing = (RecordMap) selectByMapper(NS, "TSHP_IDLETIME_SER2", params);

            if (existing != null && !existing.isEmpty()) {
                String ifFlag = existing.getString("ifFlag");
                if ("2".equals(ifFlag)) {
                    // SAP 전송 완료된 경우 수정 불가
                    return failure("해당 비가동은 SAP전송이 완료되어 수정할 수 없습니다.");
                }
            }

            // 기본값 설정
            if (params.get("idleState") == null) {
                params.put("idleState", 0);
            }

            // UPDATE 실행
            updateByMapper(NS, "TSHP_IDLETIME_UPD3", params);
            logger.info("POP32A_INS2 완료: idleId={}", idleId);

            return success("수정되었습니다.");

        } catch (Exception e) {
            logger.error("POP32A_INS2 실패", e);
            return failure("수정 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP32A_DEL: 비가동시간 삭제 (논리삭제)
    // DATA_FLAG = 2로 설정
    // ========================================================================

    /**
     * 비가동시간 삭제 - 논리삭제
     *
     * @param params idleId (삭제 대상 IDLE_ID)
     * @return 삭제 결과
     */
//    @Transactional
//    public ResultMap pop32aDel(ParamsMap params) {
//        try {
//            String idleId = params.getString("idleId");
//
//            if (idleId == null || idleId.isEmpty()) {
//                return failure("삭제할 항목을 선택하세요.");
//            }
//
//            // 논리삭제 실행 (DATA_FLAG = 2)
//            updateByMapper(NS_TSHP_IDLETIME, "TSHP_IDLETIME_UDE", params);
//
//            logger.info("POP32A_DEL 완료: idleId={}", idleId);
//
//            return success("삭제되었습니다.");
//
//        } catch (Exception e) {
//            logger.error("POP32A_DEL 실패", e);
//            return failure("삭제 실패: " + e.getMessage());
//        }
//    }

    // ========================================================================
    // POP32A_INS3: 상세원인 수정 (MCT_SCOMMENT, MCT_SCOMMENT_RESULT)
    // TSHP_IDLETIME.TSHP_IDLETIME_UPD9 호출
    // ========================================================================

    /**
     * 상세원인 수정 및 확인
     *
     * @param params idleId, mctScomment (발생원인), mctScommentResult (처리내용)
     * @return 수정 후 목록 재조회 결과
     */
    @Transactional
    public Object pop32aIns3(ParamsMap params) {
        try {
            String idleId = params.getString("idleId");
            logger.debug("POP32A_INS3: idleId={}", idleId);

            if (idleId == null || idleId.isEmpty()) {
                return failure("수정할 항목을 선택하세요.");
            }

            // UPDATE 실행 (MCT_SCOMMENT, MCT_SCOMMENT_RESULT)
            updateByMapper(NS, "TSHP_IDLETIME_UPD9", params);
            logger.info("POP32A_INS3 완료: idleId={}", idleId);

            // 저장 후 목록 재조회
            return success("success");

        } catch (Exception e) {
            logger.error("POP32A_INS3 실패", e);
            return failure("수정 실패: " + e.getMessage());
        }
    }

}


