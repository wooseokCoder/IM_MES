/*
 * ============================================================================
 * 화면명: POP30A/POP30B - 생산실적 등록 (공통 서비스)
 * ============================================================================
 * 설명: 작업자 초기화, 규격서/도면 조회, 파일 조회, 휴일 조회,
 *       SAP 주간실적, 검사항목/결과 조회, 부적합 조회/등록
 * 원본: ProActive POP30A.cs (CUBIZ_BR\BPOP\POP30A.cs)
 * 작성일: 2026-03-18
 * ============================================================================
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - POP30A_SER_INIT_WORKER → pop30aSerInitWorker (작업자 초기화)
 * - POP30A_SER16           → pop30aSer16         (규격서/도면 조회)
 * - POP30A_SER17           → pop30aSer17         (작업지시서/설비제원 파일)
 * - POP30A_SER19           → pop30aSer19         (휴일 조회)
 * - POP30A_SER20           → pop30aSer20         (SAP 주간 실적)
 * - POP30A_SER21           → pop30aSer21         (검사항목 조회)
 * - POP30A_SER22           → pop30aSer22         (검사결과 조회)
 * - POP30A_SER_A           → pop30aSerA          (부적합 조회)
 * - POP30A_INS_A           → pop30aInsA          (부적합 등록)
 */
package com.wsc.imes.pop;

import java.util.HashMap;
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
import com.wsc.imes.common.UtilityService;

/**
 * 생산실적 등록 공통 서비스
 * <p>
 * POP30A/POP30B에서 공통으로 사용하는 서비스 메서드를 제공한다.
 * 작업자 초기화, 규격서/도면, 파일, 휴일, SAP실적, 검사, 부적합 관련 기능.
 * </p>
 *
 * @author MES
 * @since 2026-03-18
 */
@Service
public class Pop30aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Pop30aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    /** TSTD_EMPLOYEE_QUERY 작업자 조회 (QUERY8) */
    private static final String NS_EMPLOYEE_QUERY = "com.wsc.imes.std.TSTD_EMPLOYEE_QUERY";
    /** TSTD_MC_AVAILEMP 설비 가용 작업자 (SER2) */
    private static final String NS_MC_AVAILEMP = "com.wsc.imes.pop.TSTD_MC_AVAILEMP";
    /** IF_PLM_FILE_INFO_QUERY PLM 파일 정보 (QUERY1) */
    private static final String NS_PLM_FILE_QUERY = "com.wsc.imes.pop.IF_PLM_FILE_INFO_QUERY";
    /** TSYS_FILELIST_MASTER_QUERY 파일목록 마스터 (QUERY1) */
    private static final String NS_FILELIST_MASTER_QUERY = "com.wsc.imes.pop.TSYS_FILELIST_MASTER_QUERY";
    /** LSE_HOLIDAY 휴일 (SER) */
    private static final String NS_HOLIDAY = "com.wsc.imes.pop.LSE_HOLIDAY";
    /** IF_SAP_ACTUAL_QUERY SAP 실적 (QUERY2) */
    private static final String NS_SAP_ACTUAL_QUERY = "com.wsc.imes.pop.IF_SAP_ACTUAL_QUERY";
    /** TSTD_INS_GRP 검사그룹 (QUERY2) */
    private static final String NS_INS_GRP_QUERY = "com.wsc.imes.pop.TSTD_INS_GRP";
    /** TSHP_INS_RESULT_MASTER 검사결과 마스터 (SER4) */
    private static final String NS_INS_RESULT_MASTER = "com.wsc.imes.pop.TSHP_INS_RESULT_MASTER";
    /** TSHP_INS_RESULT_QUERY 검사결과 조회 (QUERY1) */
    private static final String NS_INS_RESULT_QUERY = "com.wsc.imes.pop.TSHP_INS_RESULT_QUERY";
    /** TSTD_PROC_INS_QUERY 공정검사 템플릿 (QUERY3) */
    private static final String NS_PROC_INS_QUERY = "com.wsc.imes.pop.TSTD_PROC_INS_QUERY";
    /** TSHP_WORK_MNG 부적합 CRUD (INS) */
    private static final String NS_WORK_MNG = "com.wsc.imes.pop.TSHP_WORK_MNG";
    /** TSHP_WORK_MNG_QUERY 부적합 조회 (QUERY1) */
    private static final String NS_WORK_MNG_QUERY = "com.wsc.imes.pop.TSHP_WORK_MNG_QUERY";

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
    // POP30A_SER_INIT_WORKER: 작업자 초기화
    // 원본: POP30A.POP30A_SER_INIT_WORKER()
    //   → TSTD_EMPLOYEE_QUERY8 (작업자 목록)
    //   → TSTD_MC_AVAILEMP_SER2 (설비 가용 작업자)
    // ========================================================================

    /**
     * 작업자 초기화
     * <p>
     * 작업자 목록과 설비 가용 작업자 목록을 동시에 조회한다.
     * </p>
     *
     * @param params plants(공장코드), mcCode(설비코드) 등
     * @return Map with "rows" (작업자 목록), "rows2" (설비 가용 작업자)
     */
    public Map<String, Object> pop30aSerInitWorker(ParamsMap params) {
        logger.debug("POP30A_SER_INIT_WORKER: gsUserId={}",
                params.get("gsUserId"));

        // AS-IS: DATA_FLAG = 0 (활성 데이터만)
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }
        // AS-IS: EMP_CODE = acInfo.UserID (로그인 사용자 ID로 사원 조회)
        if (params.get("empCode") == null && params.get("gsUserId") != null) {
            params.put("empCode", params.get("gsUserId"));
        }

        List rows = searchByMapper(NS_EMPLOYEE_QUERY, "TSTD_EMPLOYEE_QUERY8", params);
        List rows2 = searchByMapper(NS_MC_AVAILEMP, "TSTD_MC_AVAILEMP_SER2", params);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("rows", rows);
        result.put("rows2", rows2);
        return result;
    }

    // ========================================================================
    // POP30A_SER16: 규격서/도면 조회
    // 원본: POP30A.POP30A_SER16() → IF_PLM_FILE_INFO_QUERY1
    // ========================================================================

    /**
     * 규격서/도면 조회
     *
     * @param params itemCode(품목코드) 등
     * @return PLM 파일 정보 목록
     */
    public Object pop30aSer16(ParamsMap params) {
        logger.debug("POP30A_SER16: itemCode={}", params.get("itemCode"));

        return searchByMapper(NS_PLM_FILE_QUERY, "IF_PLM_FILE_INFO_QUERY1", params);
    }

    // ========================================================================
    // POP30A_SER17: 작업지시서/설비제원 파일 조회
    // 원본: POP30A.POP30A_SER17() → TSYS_FILELIST_MASTER_QUERY1
    // AS-IS: DATA_FLAG = 0
    // ========================================================================

    /**
     * 작업지시서/설비제원 파일 조회
     *
     * @param params fileType(파일유형) 등
     * @return 파일목록 마스터 조회 결과
     */
    public Object pop30aSer17(ParamsMap params) {
        logger.debug("POP30A_SER17: fileType={}", params.get("fileType"));

        // AS-IS: DATA_FLAG = 0
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_FILELIST_MASTER_QUERY, "TSYS_FILELIST_MASTER_QUERY1", params);
    }

    // ========================================================================
    // POP30A_SER19: 휴일 조회
    // 원본: POP30A.POP30A_SER19() → LSE_HOLIDAY_SER
    // ========================================================================

    /**
     * 휴일 조회
     *
     * @param params year(연도), month(월) 등
     * @return 휴일 목록
     */
    public Object pop30aSer19(ParamsMap params) {
        logger.debug("POP30A_SER19: year={}, month={}", params.get("year"), params.get("month"));

        return searchByMapper(NS_HOLIDAY, "LSE_HOLIDAY_SER", params);
    }

    // ========================================================================
    // POP30A_SER20: SAP 주간 실적 조회
    // 원본: POP30A.POP30A_SER20() → IF_SAP_ACTUAL_QUERY2
    // ========================================================================

    /**
     * SAP 주간 실적 조회
     *
     * @param params workDate(작업일), woNo(작업오더번호) 등
     * @return SAP 실적 목록
     */
    public Object pop30aSer20(ParamsMap params) {
        logger.debug("POP30A_SER20: workDate={}, woNo={}", params.get("workDate"), params.get("woNo"));

        return searchByMapper(NS_SAP_ACTUAL_QUERY, "IF_SAP_ACTUAL_QUERY2", params);
    }

    // ========================================================================
    // POP30A_SER21: 검사항목 조회
    // 원본: POP30A.POP30A_SER21() → TSTD_INS_GRP_QUERY2
    // AS-IS BIZ: USE_FLAG='1', PLANTS=gsPltCode(AS-IS '3605'), DATA_FLAG=0
    // ========================================================================

    /**
     * 검사항목 조회
     * <p>
     * AS-IS BR 로직:
     *   USE_FLAG='1' (사용중인 검사항목만)
     *   PLANTS=공장코드 (AS-IS에서는 BIZ가 '3605' 고정 세팅)
     *   DATA_FLAG=0
     * </p>
     *
     * @param params procCode(공정코드) 등
     * @return 검사항목 목록
     */
    public Object pop30aSer21(ParamsMap params) {
        logger.debug("POP30A_SER21: procCode={}", params.get("procCode"));

        // AS-IS BIZ: USE_FLAG='1' 고정
        params.put("useFlag", "1");
        // AS-IS BIZ: PLANTS 설정 (없으면 gsPltCode 사용)
        if (params.get("plants") == null) {
            params.put("plants", params.get("gsPltCode"));
        }
        // AS-IS: DATA_FLAG = 0
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_INS_GRP_QUERY, "TSTD_INS_GRP_QUERY2", params);
    }

    // ========================================================================
    // POP30A_SER22: 검사결과 조회
    // 원본: POP30A.POP30A_SER22()
    //   1. TSHP_INS_RESULT_MASTER_SER4 → 마스터 존재 확인
    //   2-A. 존재(1건): INSM_NO 추출 → TSHP_INS_RESULT_QUERY1 (검사결과)
    //   2-B. 미존재: TSTD_PROC_INS_QUERY3 (검사항목 템플릿)
    // ========================================================================

    /**
     * 검사결과 조회
     * <p>
     * 검사결과 마스터가 존재하면 기존 검사결과를 조회하고,
     * 존재하지 않으면 공정검사 템플릿을 조회하여 신규 입력 화면을 제공한다.
     * </p>
     *
     * @param params woNo(작업오더번호), procCode(공정코드) 등
     * @return Map with "rows" (검사항목), "hasMaster" (마스터 존재 여부),
     *         "insmNo" (마스터 번호, 존재 시), "insGrpCode" (검사그룹코드, 존재 시)
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> pop30aSer22(ParamsMap params) {
        logger.debug("POP30A_SER22: woNo={}, procCode={}", params.get("woNo"), params.get("procCode"));

        // AS-IS: DATA_FLAG = 0
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        List masterList = searchByMapper(NS_INS_RESULT_MASTER, "TSHP_INS_RESULT_MASTER_SER4", params);

        Map<String, Object> result = new HashMap<String, Object>();
        List rows;

        if (masterList != null && masterList.size() == 1) {
            // 마스터 존재 → 기존 검사결과 조회
            Map<String, Object> master = (Map<String, Object>) masterList.get(0);
            params.put("insmNo", master.get("insmNo"));
            rows = searchByMapper(NS_INS_RESULT_QUERY, "TSHP_INS_RESULT_QUERY1", params);
            result.put("hasMaster", Boolean.TRUE);
            result.put("insmNo", master.get("insmNo"));
            result.put("insGrpCode", master.get("insGrpCode"));
        } else {
            // 마스터 미존재 → 공정검사 템플릿 조회
            rows = searchByMapper(NS_PROC_INS_QUERY, "TSTD_PROC_INS_QUERY3", params);
            result.put("hasMaster", Boolean.FALSE);
        }

        result.put("rows", rows);
        return result;
    }

    // ========================================================================
    // POP30A_SER_A: 부적합 조회 (Type A, B)
    // 원본: POP30A.POP30A_SER_A()
    //   → TSHP_WORK_MNG_QUERY1 (MNG_TYPE='A') → RSLTDT  (부적합A)
    //   → TSHP_WORK_MNG_QUERY1 (MNG_TYPE='B') → RSLTDT2 (부적합B)
    // ========================================================================

    /**
     * 부적합 조회 (Type A, B)
     * <p>
     * 동일 쿼리를 MNG_TYPE 파라미터를 변경하여 2회 호출한다.
     * </p>
     *
     * @param params woNo(작업오더번호), procCode(공정코드) 등
     * @return Map with "rows" (부적합A), "rows2" (부적합B)
     */
    public Map<String, Object> pop30aSerA(ParamsMap params) {
        logger.debug("POP30A_SER_A: woNo={}, procCode={}", params.get("woNo"), params.get("procCode"));

        // Type A 조회
        params.put("mngType", "A");
        List rowsA = searchByMapper(NS_WORK_MNG_QUERY, "TSHP_WORK_MNG_QUERY1", params);

        // Type B 조회
        params.put("mngType", "B");
        List rowsB = searchByMapper(NS_WORK_MNG_QUERY, "TSHP_WORK_MNG_QUERY1", params);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("rows", rowsA);
        result.put("rows2", rowsB);
        return result;
    }

    // ========================================================================
    // POP30A_INS_A: 부적합 등록
    // 원본: POP30A.POP30A_INS_A()
    //   → UTILITY_GET_SERIALNO("RA") → REQ_CODE 채번
    //   → TSHP_WORK_MNG_INS
    // MNG_TYPE='A' 고정 (BIZ 계층 세팅)
    // ========================================================================

    /**
     * 부적합 등록
     * <p>
     * AS-IS BR 로직:
     *   MNG_TYPE='A' 고정 (BIZ 계층)
     *   REQ_CODE 채번: UTILITY_GET_SERIALNO("RA")
     * </p>
     *
     * @param params 부적합 등록 데이터 (woNo, procCode, itemCode, defectCode 등)
     * @return 등록 결과
     */
    @Transactional
    public ResultMap pop30aInsA(ParamsMap params) {
        try {
            String pltCode = params.getString("gsPltCode");
            logger.debug("POP30A_INS_A: pltCode={}", pltCode);

            // AS-IS BIZ: MNG_TYPE='A' 고정
            params.put("mngType", "A");

            // REQ_CODE 채번 (RA + YYYYMMDD 형식)
            String reqCode = utilityService.getSerialNo(pltCode, "RA");
            params.put("reqCode", reqCode);

            // INSERT 실행
            insertByMapper(NS_WORK_MNG, "TSHP_WORK_MNG_INS", params);
            logger.info("POP30A_INS_A 완료: reqCode={}", reqCode);

            return success("등록되었습니다.");

        } catch (Exception e) {
            logger.error("POP30A_INS_A 실패", e);
            return failure("등록 실패: " + e.getMessage());
        }
    }

}
