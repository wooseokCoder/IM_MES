/*
 * ============================================================================
 * 화면명: POP30B - 생산실적 등록 (가공)
 * ============================================================================
 * 설명: 생산오더 조회, 작업 상태 변경(시작/종료/중지/재시작),
 *       검사결과 임시저장/완료, 비가동 입력, 일일검사 등록
 * 원본: ProActive POP30B.cs (CUBIZ_BR\BPOP\POP30B.cs)
 * 작성일: 2026-03-18
 * ============================================================================
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - POP30B_SER     → pop30bSer     (생산오더+비가동 조회)
 * - POP30B_SER2    → pop30bSer2    (추가 오더 조회)
 * - POP30B_SER3    → pop30bSer3    (실적+비가동 통합 조회)
 * - POP30B_SER4    → pop30bSer4    (검사그룹 조회)
 * - POP30B_SER5    → pop30bSer5    (일일검사 결과 조회)
 * - POP30B_SER6    → pop30bSer6    (일일검사 상세 조회)
 * - POP30B_UPD     → pop30bUpd     (작업 상태 변경)
 * - POP30B_INS     → pop30bIns     (검사결과 임시저장)
 * - POP30B_INS_1   → pop30bIns1    (검사결과 완료/QMS)
 * - POP30B_INS2    → pop30bIns2    (비가동 입력)
 * - POP30B_INS3    → pop30bIns3    (일일검사 등록)
 */
package com.wsc.imes.pop;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
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
 * 생산실적 등록 (가공) 서비스
 * <p>
 * 메인 그리드: 생산오더+비가동 조회
 * 작업 상태 변경: 시작(START), 종료(END), 중지(STOP), 재시작(RESTART), 사전시작(PRE_START)
 * 검사결과: 임시저장/완료(QMS전송)
 * 비가동: 수동 입력
 * 일일검사: 설비 일일점검 결과 등록
 * </p>
 *
 * @author MES
 * @since 2026-03-18
 */
@Service
public class Pop30bService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Pop30bService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    /** LSE_MACHINE_QUERY 설비 조회 (QUERY2 - 팝업 검색) */
    private static final String NS_MC_QUERY = "com.wsc.imes.std.LSE_MACHINE_QUERY";
    /** TSTD_EMPLOYEE_QUERY 작업자 조회 (QUERY6 - 팝업 검색) */
    private static final String NS_EMP_QUERY = "com.wsc.imes.std.TSTD_EMPLOYEE_QUERY";
    /** TSHP_WORKORDER_QUERY 작업오더 조회 (QUERY27, QUERY28) */
    private static final String NS_WO_QUERY = "com.wsc.imes.ord.TSHP_WORKORDER_QUERY";
    /** TSHP_WORKORDER CRUD (UPD15, UPD34, UPD30, UPD5_5) */
    private static final String NS_WO = "com.wsc.imes.ord.TSHP_WORKORDER";
    /** TSHP_ACTUAL_QUERY 실적 조회 (QUERY40, QUERY41_2) - pop 네임스페이스 */
    private static final String NS_ACTUAL_QUERY = "com.wsc.imes.pop.TSHP_ACTUAL_QUERY";
    /** TSHP_ACTUAL_QUERY 실적 조회 (QUERY42) - ord 네임스페이스 */
    private static final String NS_ACTUAL_QUERY_ORD = "com.wsc.imes.ord.TSHP_ACTUAL_QUERY";
    /** TSHP_ACTUAL CRUD (INS_POP30B, INS2_POP30B, UPD8, UPD9) */
    private static final String NS_ACTUAL = "com.wsc.imes.pop.TSHP_ACTUAL";
    /** TSHP_IDLETIME CRUD (INS, UPD4, SER4, SER4_2) */
    private static final String NS_IDLE = "com.wsc.imes.pop.TSHP_IDLETIME";
    /** TSHP_IDLETIME_QUERY 비가동 조회 (QUERY2_1) */
    private static final String NS_IDLE_QUERY = "com.wsc.imes.pop.TSHP_IDLETIME_QUERY";
    /** TSTD_INS_GRP 검사그룹 (SER2) */
    private static final String NS_INS_GRP = "com.wsc.imes.pop.TSTD_INS_GRP";
    /** TSTD_IDLECODE 비가동코드 (SER2) */
    private static final String NS_IDLE_CODE = "com.wsc.imes.std.TSTD_IDLECODE";
    /** TSHP_INS_RESULT_MASTER 검사결과 마스터 (SER3, INS2, UPD, UPD2) */
    private static final String NS_INS_RESULT_MASTER = "com.wsc.imes.pop.TSHP_INS_RESULT_MASTER";
    /** TSHP_INS_RESULT 검사결과 상세 (SER, INS, UPD) */
    private static final String NS_INS_RESULT = "com.wsc.imes.pop.TSHP_INS_RESULT";
    /** TSHP_INS_RESULT_QUERY 검사결과 조회 (QUERY1) */
    private static final String NS_INS_RESULT_QUERY = "com.wsc.imes.pop.TSHP_INS_RESULT_QUERY";
    /** TPOP_MC_DAILY_CHECK_RESULT 일일검사 결과 (SER, INS, UPD) */
    private static final String NS_MC_DAILY_CHECK_RESULT = "com.wsc.imes.pop.TPOP_MC_DAILY_CHECK_RESULT";
    /** TSTD_MC_DAILY_CHECK_QUERY 일일검사 템플릿 (QUERY2) */
    private static final String NS_MC_DAILY_CHECK_QUERY = "com.wsc.imes.pop.TSTD_MC_DAILY_CHECK_QUERY";
    /** TPOP_MC_DAILY_CHECK_RESULT_QUERY 일일검사 결과 조회 (QUERY1, QUERY2) */
    private static final String NS_MC_DAILY_CHECK_RESULT_QUERY = "com.wsc.imes.pop.TPOP_MC_DAILY_CHECK_RESULT_QUERY";
    // AS-IS: POP30B_SER5/SER6에서 TPOP_MC_DAILY_CHECK_RESULT_QUERY1 사용 (전체 12컬럼)
    /** IF_QMS_DAILY_INS QMS 일일 검사 전송 */
    private static final String NS_QMS = "com.wsc.imes.pop.IF_QMS_DAILY_INS";
    /** TSHP_IDLE_TIMER 비가동 타이머 (INS) */
    private static final String NS_IDLE_TIMER = "com.wsc.imes.pop.TSHP_IDLE_TIMER";

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
    // POP30B_SER: 생산오더+비가동 조회 (메인 그리드)
    // 원본: POP30B.POP30B_SER()
    //   → TSHP_WORKORDER_QUERY27 (오더 목록, WO_FLAG='0' 제거)
    //   → TSHP_IDLETIME_QUERY2_1 (비가동 정보)
    // ========================================================================

    /**
     * 생산오더+비가동 조회 (메인 그리드)
     * <p>
     * AS-IS BR 로직:
     *   DATA_FLAG=0 설정
     *   TSHP_WORKORDER_QUERY27 호출 → WO_FLAG='0' 행 제거
     *   TSHP_IDLETIME_QUERY2_1 호출 → 비가동 정보
     * </p>
     *
     * @param params plants(공장코드), mcCode(설비코드) 등
     * @return Map with "rows" (오더 목록), "idleRows" (비가동 목록)
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> pop30bSer(ParamsMap params) {
        logger.debug("POP30B_SER: plants={}, mcCode={}", params.get("plants"), params.get("mcCode"));

        // AS-IS: DATA_FLAG = 0 (활성 데이터만)
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        // TSHP_WORKORDER_QUERY27: 오더 목록 (SP에서 WO_FLAG IN ('1','2','3','5') 필터링)
        List rows = searchByMapper(NS_WO_QUERY, "TSHP_WORKORDER_QUERY27", params);

        // AS-IS BIZ: IDLE_STATE='1' (진행중인 비가동만 조회)
        params.put("idleState", "1");
        // TSHP_IDLETIME_QUERY2_1: 비가동 정보 (MC_CODE 기준)
        List idleRows = searchByMapper(NS_IDLE_QUERY, "TSHP_IDLETIME_QUERY2_1", params);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("rows", rows);
        result.put("idleRows", idleRows);
        return result;
    }

    // ========================================================================
    // POP30B_SER2: 추가 오더 조회
    // 원본: POP30B.POP30B_SER2() → TSHP_WORKORDER_QUERY28
    // ========================================================================

    /**
     * 추가 오더 조회
     *
     * @param params 검색 조건
     * @return 추가 오더 목록
     */
    public Object pop30bSer2(ParamsMap params) {
        logger.debug("POP30B_SER2: plants={}", params.get("plants"));

        return searchByMapper(NS_WO_QUERY, "TSHP_WORKORDER_QUERY28", params);
    }

    // ========================================================================
    // POP30B_SER3: 실적+비가동 통합 조회
    // 원본: POP30B.POP30B_SER3() → TSHP_ACTUAL_QUERY41_2
    // ========================================================================

    /**
     * 실적+비가동 통합 조회
     *
     * @param params 검색 조건
     * @return 실적+비가동 통합 목록
     */
    public Object pop30bSer3(ParamsMap params) {
        logger.debug("POP30B_SER3: woNo={}", params.get("woNo"));

        return searchByMapper(NS_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY41_2", params);
    }

    // ========================================================================
    // POP30B_SER4: 검사그룹 조회
    // 원본: POP30B.POP30B_SER4() → TSTD_INS_GRP_SER2
    // ========================================================================

    /**
     * 검사그룹 조회
     *
     * @param params 검색 조건
     * @return 검사그룹 목록
     */
    public Object pop30bSer4(ParamsMap params) {
        logger.debug("POP30B_SER4: plants={}", params.get("plants"));

        return searchByMapper(NS_INS_GRP, "TSTD_INS_GRP_SER2", params);
    }

    // ========================================================================
    // POP30B_SER5: 일일검사 결과 조회 (기존/신규 구분)
    // 원본: POP30B.POP30B_SER5()
    //   → TPOP_MC_DAILY_CHECK_RESULT_SER (기존 결과 확인)
    //   → 없으면: TSTD_MC_DAILY_CHECK_QUERY2 (템플릿)
    // ========================================================================

    /**
     * 일일검사 결과 조회
     * <p>
     * 해당 날짜+설비코드로 기존 검사결과가 있으면 기존 데이터를 반환하고,
     * 없으면 일일검사 템플릿을 반환하여 신규 입력 화면을 제공한다.
     * </p>
     *
     * @param params checkDate(점검일), mcCode(설비코드) 등
     * @return Map with "rows" (검사 데이터), "isNew" (신규 여부)
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> pop30bSer5(ParamsMap params) {
        logger.debug("POP30B_SER5: checkDate={}, mcCode={}", params.get("checkDate"), params.get("mcCode"));

        // AS-IS: DATA_FLAG = 0
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        // AS-IS: TPOP_MC_DAILY_CHECK_RESULT_QUERY1 (전체 12컬럼 반환)
        // 파라미터 매핑: mcCode → mdcrMcCode, 날짜 미전달 시 오늘
        if (params.get("mcCode") != null && params.get("mdcrMcCode") == null) {
            params.put("mdcrMcCode", params.get("mcCode"));
        }
        if (params.get("mdcrDate") == null) {
            params.put("mdcrDate", new SimpleDateFormat("yyyyMMdd").format(new Date()));
        }
        List existingRows = searchByMapper(NS_MC_DAILY_CHECK_RESULT_QUERY, "TPOP_MC_DAILY_CHECK_RESULT_QUERY1", params);

        Map<String, Object> result = new HashMap<String, Object>();
        if (existingRows != null && !existingRows.isEmpty()) {
            // 기존 결과 존재 → 기존 데이터 반환
            result.put("rows", existingRows);
            result.put("isNew", Boolean.FALSE);
        } else {
            // 기존 결과 없음 → 템플릿 반환
            List templateRows = searchByMapper(NS_MC_DAILY_CHECK_QUERY, "TSTD_MC_DAILY_CHECK_QUERY2", params);
            result.put("rows", templateRows);
            result.put("isNew", Boolean.TRUE);
        }
        return result;
    }

    // ========================================================================
    // POP30B_SER6: 일일검사 상세 조회 (기존만)
    // 원본: POP30B.POP30B_SER6() → TPOP_MC_DAILY_CHECK_RESULT_SER
    // ========================================================================

    /**
     * 일일검사 상세 조회
     *
     * @param params checkDate(점검일), mcCode(설비코드) 등
     * @return 기존 일일검사 결과 목록
     */
    public Object pop30bSer6(ParamsMap params) {
        logger.debug("POP30B_SER6: checkDate={}, mcCode={}", params.get("checkDate"), params.get("mcCode"));

        // AS-IS: DATA_FLAG = 0
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        // AS-IS: TPOP_MC_DAILY_CHECK_RESULT_QUERY1 (전체 12컬럼 반환)
        if (params.get("mcCode") != null && params.get("mdcrMcCode") == null) {
            params.put("mdcrMcCode", params.get("mcCode"));
        }
        if (params.get("mdcrDate") == null) {
            params.put("mdcrDate", new SimpleDateFormat("yyyyMMdd").format(new Date()));
        }
        return searchByMapper(NS_MC_DAILY_CHECK_RESULT_QUERY, "TPOP_MC_DAILY_CHECK_RESULT_QUERY1", params);
    }

    // ========================================================================
    // POP30B_UPD: 작업 상태 변경 (가장 복잡한 메서드)
    // 원본: POP30B.POP30B_UPD()
    // TYPE_CODE에 따라 분기:
    //   START/RESTART/PRE_START: 시작 처리
    //   END: 종료 처리
    //   STOP: 중지 처리 (비가동 시작)
    // ========================================================================

    /**
     * 작업 상태 변경
     * <p>
     * TYPE_CODE별 분기:
     * <ul>
     *   <li>START/RESTART/PRE_START: 기존 진행 중 실적 중지 → 새 실적 등록 → WO 상태 변경</li>
     *   <li>END: 실적 종료 → 비가동 종료 → WO 완료 상태</li>
     *   <li>STOP: 실적 중지 → 비가동 시작 → WO 중지 상태</li>
     * </ul>
     * </p>
     *
     * @param params typeCode(START/END/STOP/RESTART/PRE_START), woNo, mcCode, empCode 등
     * @return 처리 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public ResultMap pop30bUpd(ParamsMap params) {
        try {
            String typeCode = params.getString("typeCode");
            String pltCode = params.getString("gsPltCode");
            String woNo = params.getString("woNo");
            String mcCode = params.getString("mcCode");
            String empCode = params.getString("empCode");

            logger.info("POP30B_UPD 시작: typeCode={}, woNo={}, mcCode={}, empCode={}",
                    new Object[]{typeCode, woNo, mcCode, empCode});

            if (typeCode == null || typeCode.isEmpty()) {
                return failure("작업 유형(typeCode)이 지정되지 않았습니다.");
            }

            String now = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String workDate = new SimpleDateFormat("yyyyMMdd").format(new Date());

            if ("START".equals(typeCode) || "RESTART".equals(typeCode) || "PRE_START".equals(typeCode)) {
                // ============================================================
                // START / RESTART / PRE_START 처리
                // ============================================================

                // (1) 진행 중 실적 조회 (PROC_STAT='2')
                ParamsMap actParams = new ParamsMap();
                actParams.put("gsPltCode", pltCode);
                actParams.put("mcCode", mcCode);
                actParams.put("procStat", "2");
                List runningActuals = searchByMapper(NS_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY40", actParams);

                if (runningActuals != null && !runningActuals.isEmpty()) {
                    // (2) 기존 진행 중 실적 중지 (PROC_STAT='3')
                    for (int i = 0; i < runningActuals.size(); i++) {
                        Map<String, Object> runAct = (Map<String, Object>) runningActuals.get(i);
                        ParamsMap stopParams = new ParamsMap();
                        stopParams.put("gsPltCode", pltCode);
                        stopParams.put("gsUserId", params.get("gsUserId"));
                        stopParams.put("actualId", runAct.get("actualId"));
                        stopParams.put("procStat", "3");
                        stopParams.put("actEndTime", now);
                        updateByMapper(NS_ACTUAL, "TSHP_ACTUAL_UPD9", stopParams);
                        logger.debug("기존 실적 중지: actualId={}", runAct.get("actualId"));

                        // 이전 WO 상태 중지 (woFlag='3')
                        String prevWoNo = (String) runAct.get("woNo");
                        if (prevWoNo != null && !prevWoNo.equals(woNo)) {
                            ParamsMap prevWoParams = new ParamsMap();
                            prevWoParams.put("gsPltCode", pltCode);
                            prevWoParams.put("gsUserId", params.get("gsUserId"));
                            prevWoParams.put("woNo", prevWoNo);
                            prevWoParams.put("woFlag", "3");
                            updateByMapper(NS_WO, "TSHP_WORKORDER_UPD15", prevWoParams);
                            logger.debug("이전 WO 중지: woNo={}", prevWoNo);
                        }
                    }
                }

                // (3) 진행 중 비가동 확인 (idleState='1')
                ParamsMap idleParams = new ParamsMap();
                idleParams.put("gsPltCode", pltCode);
                idleParams.put("mcCode", mcCode);
                idleParams.put("idleState", "1");
                List runningIdles = searchByMapper(NS_IDLE, "TSHP_IDLETIME_SER4_2", idleParams);

                if (runningIdles != null && !runningIdles.isEmpty()) {
                    // (4) 진행 중 비가동 종료 + 해당 WO 상태 중지
                    for (int i = 0; i < runningIdles.size(); i++) {
                        Map<String, Object> runIdle = (Map<String, Object>) runningIdles.get(i);
                        ParamsMap endIdleParams = new ParamsMap();
                        endIdleParams.put("gsPltCode", pltCode);
                        endIdleParams.put("gsUserId", params.get("gsUserId"));
                        endIdleParams.put("idleId", runIdle.get("idleId"));
                        endIdleParams.put("endTime", now);
                        endIdleParams.put("idleState", "0");
                        updateByMapper(NS_IDLE, "TSHP_IDLETIME_UPD4", endIdleParams);
                        logger.debug("비가동 종료: idleId={}", runIdle.get("idleId"));

                        // AS-IS Line 191: 비가동 WO에도 UPD15(WO_FLAG='3')
                        String idleWoNo = (String) runIdle.get("woNo");
                        if (idleWoNo != null && !idleWoNo.isEmpty()) {
                            ParamsMap idleWoParams = new ParamsMap();
                            idleWoParams.put("gsPltCode", pltCode);
                            idleWoParams.put("gsUserId", params.get("gsUserId"));
                            idleWoParams.put("woNo", idleWoNo);
                            idleWoParams.put("woFlag", "3");
                            updateByMapper(NS_WO, "TSHP_WORKORDER_UPD15", idleWoParams);
                        }
                    }
                }

                // (5) 새 실적 등록 (ACTUAL_ID 채번)
                // AS-IS: row에 ACTUAL_ID, PROC_STAT, ACT_START_TIME 세팅 후 TSHP_ACTUAL_INS 호출
                String actualId = utilityService.getSerialNo(pltCode, "ACT");
                ParamsMap insParams = new ParamsMap();
                insParams.put("gsPltCode", pltCode);
                insParams.put("gsUserId", params.get("gsUserId"));
                insParams.put("actualId", actualId);
                insParams.put("woNo", woNo);
                insParams.put("mcCode", mcCode);
                insParams.put("empCode", empCode);
                insParams.put("procStat", "2");
                insParams.put("actStartTime", now);
                insParams.put("workDate", workDate);
                insParams.put("panelStat", params.get("panelStat"));
                insParams.put("inputFlag", params.get("inputFlag"));
                // PRE_START일 때 IS_PRE_WORK='1', 그 외 '0'
                insParams.put("isPreWork", "PRE_START".equals(typeCode) ? "1" : "0");
                insertByMapper(NS_ACTUAL, "TSHP_ACTUAL_INS_POP30B", insParams);
                logger.info("새 실적 등록: actualId={}, woNo={}", actualId, woNo);

                // (6) WO 상태 '진행' (woFlag='2')
                ParamsMap woParams = new ParamsMap();
                woParams.put("gsPltCode", pltCode);
                woParams.put("gsUserId", params.get("gsUserId"));
                woParams.put("woNo", woNo);
                woParams.put("woFlag", "2");
                updateByMapper(NS_WO, "TSHP_WORKORDER_UPD15", woParams);

                // (7) ACT_EMP_CODE, ACT_MC_CODE 업데이트
                ParamsMap woUpdParams = new ParamsMap();
                woUpdParams.put("gsPltCode", pltCode);
                woUpdParams.put("gsUserId", params.get("gsUserId"));
                woUpdParams.put("woNo", woNo);
                woUpdParams.put("actEmpCode", empCode);
                woUpdParams.put("actMcCode", mcCode);
                updateByMapper(NS_WO, "TSHP_WORKORDER_UPD34", woUpdParams);

                // AS-IS Line 211: TSHP_ACTUAL_UPD10 (IS_AUTO_IDLE_FLAG 리셋)
                ParamsMap upd10Params = new ParamsMap();
                upd10Params.put("gsPltCode", pltCode);
                upd10Params.put("gsUserId", params.get("gsUserId"));
                upd10Params.put("empCode", empCode);
                upd10Params.put("workDate", workDate);
                updateByMapper(NS_ACTUAL, "TSHP_ACTUAL_UPD10", upd10Params);

                logger.info("POP30B_UPD {} 완료: woNo={}", typeCode, woNo);

            } else if ("END".equals(typeCode)) {
                // ============================================================
                // END 처리
                // ============================================================

                // (1) 진행 중 실적 조회 (PROC_STAT='2')
                ParamsMap actParams = new ParamsMap();
                actParams.put("gsPltCode", pltCode);
                actParams.put("mcCode", mcCode);
                actParams.put("woNo", woNo);
                actParams.put("procStat", "2");
                List runningActuals = searchByMapper(NS_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY40", actParams);

                if (runningActuals == null || runningActuals.isEmpty()) {
                    // (2) 진행 중 실적 없음
                    // AS-IS Line 218-270: 비가동 조회 → 종료 → 새 비가동 등록 → 실적 등록
                    ParamsMap idleSer4Params = new ParamsMap();
                    idleSer4Params.put("gsPltCode", pltCode);
                    idleSer4Params.put("woNo", woNo);
                    idleSer4Params.put("idleState", "1");
                    List endIdles = searchByMapper(NS_IDLE, "TSHP_IDLETIME_SER4", idleSer4Params);

                    if (endIdles != null && !endIdles.isEmpty()) {
                        // AS-IS Line 228-244: 진행중 비가동 종료
                        for (int i = 0; i < endIdles.size(); i++) {
                            Map<String, Object> idle = (Map<String, Object>) endIdles.get(i);
                            ParamsMap endIdleP = new ParamsMap();
                            endIdleP.put("gsPltCode", pltCode);
                            endIdleP.put("gsUserId", params.get("gsUserId"));
                            endIdleP.put("idleId", idle.get("idleId"));
                            endIdleP.put("endTime", now);
                            endIdleP.put("idleState", "0");
                            updateByMapper(NS_IDLE, "TSHP_IDLETIME_UPD4", endIdleP);
                        }
                        // AS-IS Line 245-269: 새 비가동 등록 (기존 비가동 정보 복사)
                        Map<String, Object> firstIdle = (Map<String, Object>) endIdles.get(0);
                        String newIdleId = utilityService.getSerialNo(pltCode, "IL");
                        ParamsMap newIdleP = new ParamsMap();
                        newIdleP.put("gsPltCode", pltCode);
                        newIdleP.put("gsUserId", params.get("gsUserId"));
                        newIdleP.put("idleId", newIdleId);
                        newIdleP.put("mcCode", firstIdle.get("mcCode"));
                        newIdleP.put("empCode", firstIdle.get("empCode"));
                        newIdleP.put("idleCode", firstIdle.get("idleCode"));
                        newIdleP.put("woNo", firstIdle.get("woNo"));
                        newIdleP.put("idleTime", 0);
                        newIdleP.put("idleState", "1");
                        newIdleP.put("startTime", now);
                        newIdleP.put("workDate", workDate);
                        insertByMapper(NS_IDLE, "TSHP_IDLETIME_INS", newIdleP);
                    }

                    // AS-IS Line 271-275: 단순 종료 실적 등록
                    String actualId = utilityService.getSerialNo(pltCode, "ACT");
                    ParamsMap insParams = new ParamsMap();
                    insParams.put("gsPltCode", pltCode);
                    insParams.put("gsUserId", params.get("gsUserId"));
                    insParams.put("actualId", actualId);
                    insParams.put("woNo", woNo);
                    insParams.put("mcCode", mcCode);
                    insParams.put("empCode", empCode);
                    insParams.put("procStat", "4");
                    insParams.put("actStartTime", now);
                    insParams.put("actEndTime", now);
                    insParams.put("workDate", workDate);
                    insParams.put("panelStat", params.get("panelStat"));
                    insParams.put("inputFlag", params.get("inputFlag"));
                    insParams.put("okQty", params.get("okQty"));
                    insParams.put("ngQty", params.get("ngQty"));
                    insertByMapper(NS_ACTUAL, "TSHP_ACTUAL_INS2_POP30B", insParams);
                    logger.info("단순 종료 실적 등록: actualId={}", actualId);
                } else {
                    // (3) 진행 중 실적 있음 → 기존 실적 종료 (PROC_STAT='4')
                    for (int i = 0; i < runningActuals.size(); i++) {
                        Map<String, Object> runAct = (Map<String, Object>) runningActuals.get(i);
                        ParamsMap endParams = new ParamsMap();
                        endParams.put("gsPltCode", pltCode);
                        endParams.put("gsUserId", params.get("gsUserId"));
                        endParams.put("actualId", runAct.get("actualId"));
                        endParams.put("procStat", "4");
                        endParams.put("actEndTime", now);
                        endParams.put("okQty", params.get("okQty"));
                        endParams.put("ngQty", params.get("ngQty"));
                        updateByMapper(NS_ACTUAL, "TSHP_ACTUAL_UPD8", endParams);
                        logger.debug("실적 종료: actualId={}", runAct.get("actualId"));
                    }
                }

                // (4) 진행 중 비가동 종료
                ParamsMap idleParams = new ParamsMap();
                idleParams.put("gsPltCode", pltCode);
                idleParams.put("woNo", woNo);
                idleParams.put("idleState", "1");
                List runningIdles = searchByMapper(NS_IDLE, "TSHP_IDLETIME_SER4", idleParams);

                if (runningIdles != null && !runningIdles.isEmpty()) {
                    for (int i = 0; i < runningIdles.size(); i++) {
                        Map<String, Object> runIdle = (Map<String, Object>) runningIdles.get(i);
                        ParamsMap endIdleParams = new ParamsMap();
                        endIdleParams.put("gsPltCode", pltCode);
                        endIdleParams.put("gsUserId", params.get("gsUserId"));
                        endIdleParams.put("idleId", runIdle.get("idleId"));
                        endIdleParams.put("endTime", now);
                        endIdleParams.put("idleState", "0");
                        updateByMapper(NS_IDLE, "TSHP_IDLETIME_UPD4", endIdleParams);
                        logger.debug("비가동 종료: idleId={}", runIdle.get("idleId"));
                    }
                }

                // AS-IS Line 284-289: SER4 + SER5 → UPD10 (IS_AUTO_IDLE_FLAG 리셋)
                ParamsMap ser4Params = new ParamsMap();
                ser4Params.put("gsPltCode", pltCode);
                ser4Params.put("woNo", woNo);
                ser4Params.put("empCode", empCode);
                List actSer4 = searchByMapper(NS_ACTUAL, "TSHP_ACTUAL_SER4", ser4Params);
                List idleSer5 = searchByMapper(NS_IDLE, "TSHP_IDLETIME_SER5", ser4Params);
                if ((actSer4 != null && !actSer4.isEmpty()) || (idleSer5 != null && !idleSer5.isEmpty())) {
                    ParamsMap upd10Params = new ParamsMap();
                    upd10Params.put("gsPltCode", pltCode);
                    upd10Params.put("gsUserId", params.get("gsUserId"));
                    upd10Params.put("empCode", empCode);
                    upd10Params.put("workDate", workDate);
                    updateByMapper(NS_ACTUAL, "TSHP_ACTUAL_UPD10", upd10Params);
                }

                // (5) ACT_EMP_CODE, ACT_MC_CODE 업데이트
                ParamsMap woUpdParams = new ParamsMap();
                woUpdParams.put("gsPltCode", pltCode);
                woUpdParams.put("gsUserId", params.get("gsUserId"));
                woUpdParams.put("woNo", woNo);
                woUpdParams.put("actEmpCode", empCode);
                woUpdParams.put("actMcCode", mcCode);
                updateByMapper(NS_WO, "TSHP_WORKORDER_UPD34", woUpdParams);

                logger.info("POP30B_UPD END 완료: woNo={}", woNo);

            } else if ("STOP".equals(typeCode)) {
                // ============================================================
                // STOP 처리 (AS-IS Line 292-312)
                // ============================================================

                // (1) 진행 중 실적 조회 (PROC_STAT='2')
                ParamsMap actParams = new ParamsMap();
                actParams.put("gsPltCode", pltCode);
                actParams.put("mcCode", mcCode);
                actParams.put("woNo", woNo);
                actParams.put("procStat", "2");
                List runningActuals = searchByMapper(NS_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY40", actParams);

                // AS-IS Line 296-298: 실적 없으면 에러
                if (runningActuals == null || runningActuals.isEmpty()) {
                    return failure("해당 작업지시의 실적은 중지할 수 없습니다.");
                }

                // (2) 실적 중지 (PROC_STAT='3')
                for (int i = 0; i < runningActuals.size(); i++) {
                    Map<String, Object> runAct = (Map<String, Object>) runningActuals.get(i);
                    ParamsMap stopParams = new ParamsMap();
                    stopParams.put("gsPltCode", pltCode);
                    stopParams.put("gsUserId", params.get("gsUserId"));
                    stopParams.put("actualId", runAct.get("actualId"));
                    stopParams.put("procStat", "3");
                    stopParams.put("actEndTime", now);
                    updateByMapper(NS_ACTUAL, "TSHP_ACTUAL_UPD8", stopParams);
                    logger.debug("실적 중지: actualId={}", runAct.get("actualId"));
                }

                // (3) 비가동 시작 (IDLE_ID 채번)
                String idleId = utilityService.getSerialNo(pltCode, "IL");
                ParamsMap idleInsParams = new ParamsMap();
                idleInsParams.put("gsPltCode", pltCode);
                idleInsParams.put("gsUserId", params.get("gsUserId"));
                idleInsParams.put("idleId", idleId);
                idleInsParams.put("woNo", woNo);
                idleInsParams.put("mcCode", mcCode);
                idleInsParams.put("empCode", empCode);
                idleInsParams.put("startTime", now);
                idleInsParams.put("workDate", workDate);
                idleInsParams.put("idleState", "1");
                idleInsParams.put("idleCode", params.get("idleCode"));
                idleInsParams.put("scomment", params.get("scomment"));
                insertByMapper(NS_IDLE, "TSHP_IDLETIME_INS", idleInsParams);
                logger.info("비가동 시작: idleId={}", idleId);

                // (4) WO 상태 '중지' (woFlag='5')
                ParamsMap woParams = new ParamsMap();
                woParams.put("gsPltCode", pltCode);
                woParams.put("gsUserId", params.get("gsUserId"));
                woParams.put("woNo", woNo);
                woParams.put("woFlag", "5");
                updateByMapper(NS_WO, "TSHP_WORKORDER_UPD5_5", woParams);

                // AS-IS Line 311: TSHP_ACTUAL_UPD10 (IS_AUTO_IDLE_FLAG 리셋)
                ParamsMap upd10Params = new ParamsMap();
                upd10Params.put("gsPltCode", pltCode);
                upd10Params.put("gsUserId", params.get("gsUserId"));
                upd10Params.put("empCode", empCode);
                upd10Params.put("workDate", workDate);
                updateByMapper(NS_ACTUAL, "TSHP_ACTUAL_UPD10", upd10Params);

                logger.info("POP30B_UPD STOP 완료: woNo={}", woNo);

            } else {
                return failure("알 수 없는 작업 유형입니다: " + typeCode);
            }

            // ============================================================
            // AS-IS 공통 후처리 (POP30B.cs Line 313-367)
            // START/END/STOP 모든 분기 후 공통 실행
            // 1. TSHP_ACTUAL_QUERY42_2 → 전체 실적 상태 조회
            // 2. WO_FLAG 동적 결정 (2=진행/3=중지/4=완료)
            // 3. TSHP_WORKORDER_UPD31 → WO 상태 업데이트
            // ============================================================
            // AS-IS Line 320: TSHP_ACTUAL_QUERY42_2 (pop 네임스페이스)
            ParamsMap woQueryParams = new ParamsMap();
            woQueryParams.put("gsPltCode", pltCode);
            woQueryParams.put("woNo", woNo);
            List allActuals = searchByMapper(NS_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY42_2", woQueryParams);

            // AS-IS Line 321: TSHP_WORKORDER_SER → 기존 ACT_START_TIME 조회
            Object woSer = selectByMapper(NS_WO, "TSHP_WORKORDER_SER", woQueryParams);
            String existingStartTime = null;
            if (woSer != null) {
                Map<String, Object> woSerMap = (Map<String, Object>) woSer;
                Object startObj = woSerMap.get("actStartTime");
                if (startObj != null && !"".equals(startObj.toString())) {
                    existingStartTime = startObj.toString();
                }
            }

            // AS-IS Line 322-348: WO_FLAG 동적 결정
            String woFlag = "2";
            boolean hasRunning = false;
            boolean hasStopped = false;
            boolean hasCompleted = false;

            if (allActuals != null) {
                for (int j = 0; j < allActuals.size(); j++) {
                    Map<String, Object> act = (Map<String, Object>) allActuals.get(j);
                    String stat = String.valueOf(act.get("procStat"));
                    if ("2".equals(stat)) hasRunning = true;
                    else if ("3".equals(stat)) hasStopped = true;
                    else if ("4".equals(stat)) hasCompleted = true;
                }
            }

            if (hasRunning) {
                woFlag = "2";
            } else if (hasStopped) {
                woFlag = "3";
            } else if (hasCompleted) {
                woFlag = "4";
            }

            // AS-IS Line 349-367: TSHP_WORKORDER_UPD31
            // ACT_START_TIME: 기존 값 있으면 기존 값 유지, 없으면 현재시간 (AS-IS Line 327-329)
            ParamsMap woFlagParams = new ParamsMap();
            woFlagParams.put("gsPltCode", pltCode);
            woFlagParams.put("gsUserId", params.get("gsUserId"));
            woFlagParams.put("woNo", woNo);
            woFlagParams.put("woFlag", woFlag);
            woFlagParams.put("actStartTime", existingStartTime != null ? existingStartTime : now);
            woFlagParams.put("actEndTime", "4".equals(woFlag) ? now : null);
            updateByMapper(NS_WO, "TSHP_WORKORDER_UPD31", woFlagParams);
            logger.info("POP30B_UPD 공통 후처리: woNo={}, woFlag={}", woNo, woFlag);

            return success("처리되었습니다.");

        } catch (Exception e) {
            logger.error("POP30B_UPD 실패", e);
            throw new RuntimeException(e);
        }
    }

    // ========================================================================
    // POP30B_INS: 검사결과 임시저장
    // 원본: POP30B.POP30B_INS()
    //   마스터 확인/생성 → 상세 행 UPSERT → WO isInsChk 업데이트
    // ========================================================================

    /**
     * 검사결과 임시저장
     * <p>
     * AS-IS BR 로직:
     *   1. 검사결과 마스터 확인 (TSHP_INS_RESULT_MASTER_SER3)
     *   2. 마스터 없으면 생성 (INS_RESULT_MASTER_INS2, INSM_NO 채번 "IRM")
     *   3. 마스터 있으면 수정 (INS_RESULT_MASTER_UPD)
     *   4. 각 상세 행: 존재 확인 (INS_RESULT_SER) → INSERT/UPDATE
     *   5. WO 업데이트: isInsChk='1' (TSHP_WORKORDER_UPD30)
     * </p>
     *
     * @param params woNo, sapWoNo, insGrpCode, empCode + models(JSON 상세 행)
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public ResultMap pop30bIns(ParamsMap params) {
        try {
            String pltCode = params.getString("gsPltCode");
            String woNo = params.getString("woNo");
            logger.info("POP30B_INS 시작: woNo={}", woNo);

            // (1) 마스터 존재 확인
            String insmNo = saveInspectionMaster(params, pltCode);

            // (2) 상세 행 처리
            saveInspectionDetails(params, pltCode, insmNo);

            // (3) WO isInsChk 업데이트
            ParamsMap woParams = new ParamsMap();
            woParams.put("gsPltCode", pltCode);
            woParams.put("gsUserId", params.get("gsUserId"));
            woParams.put("woNo", woNo);
            woParams.put("isInsChk", "1");
            updateByMapper(NS_WO, "TSHP_WORKORDER_UPD30", woParams);

            logger.info("POP30B_INS 완료: woNo={}, insmNo={}", woNo, insmNo);
            return success("임시저장되었습니다.");

        } catch (Exception e) {
            logger.error("POP30B_INS 실패", e);
            throw new RuntimeException(e);
        }
    }

    // ========================================================================
    // POP30B_INS_1: 검사결과 완료/QMS 전송
    // 원본: POP30B.POP30B_INS_1()
    //   POP30B_INS 로직 + QMS 전송 + 마스터 상태 업데이트
    // ========================================================================

    /**
     * 검사결과 완료/QMS 전송
     * <p>
     * pop30bIns와 동일한 저장 로직 수행 후 추가로:
     *   1. IF_QMS_DAILY_INS 테이블에 QMS 전송 데이터 등록
     *   2. TSHP_INS_RESULT_MASTER qmsState='1' 업데이트
     * </p>
     *
     * @param params woNo, sapWoNo, insGrpCode, empCode + models(JSON 상세 행)
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public ResultMap pop30bIns1(ParamsMap params) {
        try {
            String pltCode = params.getString("gsPltCode");
            String woNo = params.getString("woNo");
            logger.info("POP30B_INS_1 시작: woNo={}", woNo);

            // (1) 마스터 존재 확인/생성
            String insmNo = saveInspectionMaster(params, pltCode);

            // (2) 상세 행 처리
            saveInspectionDetails(params, pltCode, insmNo);

            // (3) WO isInsChk 업데이트
            ParamsMap woParams = new ParamsMap();
            woParams.put("gsPltCode", pltCode);
            woParams.put("gsUserId", params.get("gsUserId"));
            woParams.put("woNo", woNo);
            woParams.put("isInsChk", "1");
            updateByMapper(NS_WO, "TSHP_WORKORDER_UPD30", woParams);

            // (4) QMS 전송
            ParamsMap qmsParams = new ParamsMap();
            qmsParams.put("gsPltCode", pltCode);
            qmsParams.put("gsUserId", params.get("gsUserId"));
            qmsParams.put("insmNo", insmNo);
            qmsParams.put("woNo", woNo);
            qmsParams.put("sapWoNo", params.get("sapWoNo"));
            insertByMapper(NS_QMS, "IF_QMS_DAILY_INS", qmsParams);
            logger.info("QMS 전송 등록: insmNo={}", insmNo);

            // (5) 마스터 qmsState 업데이트
            ParamsMap masterParams = new ParamsMap();
            masterParams.put("gsPltCode", pltCode);
            masterParams.put("gsUserId", params.get("gsUserId"));
            masterParams.put("insmNo", insmNo);
            masterParams.put("qmsState", "1");
            updateByMapper(NS_INS_RESULT_MASTER, "TSHP_INS_RESULT_MASTER_UPD2", masterParams);

            logger.info("POP30B_INS_1 완료: woNo={}, insmNo={}", woNo, insmNo);
            return success("검사결과가 완료 처리되었습니다.");

        } catch (Exception e) {
            logger.error("POP30B_INS_1 실패", e);
            throw new RuntimeException(e);
        }
    }

    // ========================================================================
    // POP30B_INS2: 비가동 입력
    // 원본: POP30B.POP30B_INS2()
    //   → IDLE_ID 채번 "IL"
    //   → TSHP_IDLETIME_INS
    //   → TSHP_WORKORDER_UPD5_5 (woFlag='5')
    // ========================================================================

    /**
     * 비가동 입력/종료
     * <p>
     * AS-IS: POP30A_INS2 - DB 기반으로 시작/종료 자동 판별
     *   1. TSHP_IDLETIME_QUERY2 (MC_CODE 기준 진행중 idle 조회)
     *   2-A. 결과 없음 → 비가동 시작
     *        - IDLE INSERT → 진행중 실적 중지 → WO_FLAG 동적 결정 → UPD31
     *   2-B. 결과 있음 → 비가동 종료
     *        - IDLE UPD (END_TIME, STATE=0) → WO_FLAG='3' → UPD15
     * </p>
     *
     * @param params 시작: woNo, mcCode, empCode, idleCode, idleMinute, scomment, plants
     *               종료: idleId, mcCode, empCode, plants
     * @return 처리 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public ResultMap pop30bIns2(ParamsMap params) {
        try {
            String pltCode = params.getString("gsPltCode");
            String mcCode = params.getString("mcCode");
            String empCode = params.getString("empCode");
            String plantsParam = params.getString("plants");

            String now = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String workDate = new SimpleDateFormat("yyyyMMdd").format(new Date());

            // ============================================================
            // AS-IS Step 1: DB에서 진행중 비가동 조회 (TSHP_IDLETIME_QUERY2)
            // AS-IS: MC_CODE=null + EMP_CODE + IDLE_STATE='1' → 해당 사원의 진행중 idle 확인
            // ============================================================
            ParamsMap idleQueryParams = new ParamsMap();
            idleQueryParams.put("gsPltCode", pltCode);
            idleQueryParams.put("empCode", empCode);
            idleQueryParams.put("idleState", "1");
            // AS-IS: MC_CODE=null (사원 기준으로만 조회, 설비 무관)
            List existingIdles = searchByMapper(NS_IDLE_QUERY, "TSHP_IDLETIME_QUERY2", idleQueryParams);

            if (existingIdles == null || existingIdles.isEmpty()) {
                // ============================================================
                // 비가동 시작 (AS-IS: dataTable.Rows.Count == 0)
                // ============================================================
                String woNo = params.getString("woNo");
                logger.info("POP30B_INS2 비가동 시작: woNo={}, mcCode={}", woNo, mcCode);

                // (1) IDLE_ID 채번 + INSERT
                String idleId = utilityService.getSerialNo(pltCode, "IL");
                ParamsMap idleInsParams = new ParamsMap();
                idleInsParams.put("gsPltCode", pltCode);
                idleInsParams.put("gsUserId", params.get("gsUserId"));
                idleInsParams.put("idleId", idleId);
                idleInsParams.put("mcCode", mcCode);
                idleInsParams.put("empCode", empCode);
                idleInsParams.put("idleCode", params.get("idleCode"));
                idleInsParams.put("idleTime", 0);
                idleInsParams.put("idleState", "1");
                idleInsParams.put("woNo", woNo);
                idleInsParams.put("scomment", params.get("scomment"));
                idleInsParams.put("startTime", now);
                idleInsParams.put("workDate", workDate);
                idleInsParams.put("plants", plantsParam);
                insertByMapper(NS_IDLE, "TSHP_IDLETIME_INS", idleInsParams);
                logger.info("비가동 등록: idleId={}", idleId);

                // (2) 진행중 실적 조회 (PROC_STAT='2')
                // AS-IS: 3605 → MC_CODE 기준, 3603 → EMP_CODE 기준
                ParamsMap actParams = new ParamsMap();
                actParams.put("gsPltCode", pltCode);
                actParams.put("procStat", "2");
                if ("3605".equals(plantsParam)) {
                    actParams.put("mcCode", mcCode);
                } else if ("3603".equals(plantsParam)) {
                    actParams.put("empCode", empCode);
                }
                List runningActuals = searchByMapper(NS_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY40", actParams);
                logger.debug("POP30B_INS2 QUERY40: mcCode={}, 건수={}", mcCode,
                        Integer.valueOf(runningActuals != null ? runningActuals.size() : 0));

                // (3) 진행중 실적 중지 + WO_FLAG 동적 결정
                if (runningActuals != null && !runningActuals.isEmpty()) {
                    for (int i = 0; i < runningActuals.size(); i++) {
                        Map<String, Object> runAct = (Map<String, Object>) runningActuals.get(i);

                        // 실적 중지 (PROC_STAT='3', END_TIME)
                        ParamsMap stopParams = new ParamsMap();
                        stopParams.put("gsPltCode", pltCode);
                        stopParams.put("gsUserId", params.get("gsUserId"));
                        stopParams.put("actualId", runAct.get("actualId"));
                        stopParams.put("procStat", "3");
                        stopParams.put("actEndTime", now);
                        updateByMapper(NS_ACTUAL, "TSHP_ACTUAL_UPD8", stopParams);
                        logger.debug("실적 중지: actualId={}", runAct.get("actualId"));

                        // AS-IS: 해당 WO의 전체 실적 상태 조회 (QUERY42)
                        String actWoNo = (String) runAct.get("woNo");
                        ParamsMap woQueryParams = new ParamsMap();
                        woQueryParams.put("gsPltCode", pltCode);
                        woQueryParams.put("woNo", actWoNo);
                        List allActuals = searchByMapper(NS_ACTUAL_QUERY_ORD, "TSHP_ACTUAL_QUERY42", woQueryParams);

                        // AS-IS: 실적 상태 기반 WO_FLAG 동적 결정
                        String woFlag = "2";
                        boolean hasRunning = false;  // PROC_STAT='2'
                        boolean hasStopped = false;  // PROC_STAT='3'
                        boolean hasCompleted = false; // PROC_STAT='4'

                        if (allActuals != null) {
                            for (int j = 0; j < allActuals.size(); j++) {
                                Map<String, Object> act = (Map<String, Object>) allActuals.get(j);
                                String stat = String.valueOf(act.get("procStat"));
                                if ("2".equals(stat)) hasRunning = true;
                                else if ("3".equals(stat)) hasStopped = true;
                                else if ("4".equals(stat)) hasCompleted = true;
                            }
                        }

                        if (hasRunning) {
                            woFlag = "2";
                        } else if (hasStopped) {
                            woFlag = "3";
                        } else if (hasCompleted) {
                            woFlag = "4";
                        }

                        // WO 상태 업데이트 (UPD31)
                        // AS-IS: ACT_START_TIME, ACT_END_TIME도 전달
                        ParamsMap woUpdParams = new ParamsMap();
                        woUpdParams.put("gsPltCode", pltCode);
                        woUpdParams.put("gsUserId", params.get("gsUserId"));
                        woUpdParams.put("woNo", actWoNo);
                        woUpdParams.put("woFlag", woFlag);
                        woUpdParams.put("actStartTime", now);
                        woUpdParams.put("actEndTime", now);
                        updateByMapper(NS_WO, "TSHP_WORKORDER_UPD31", woUpdParams);
                        logger.debug("WO 상태 업데이트: woNo={}, woFlag={}", actWoNo, woFlag);
                    }
                }

                // (4) AS-IS: IDLE_MINUTE 있으면 TSHP_IDLE_TIMER_INS
                String idleMinuteStr = params.getString("idleMinute");
                if (idleMinuteStr != null && !idleMinuteStr.isEmpty()) {
                    try {
                        int idleMinute = Integer.parseInt(idleMinuteStr);
                        if (idleMinute > 0) {
                            String idtId = utilityService.getSerialNo(pltCode, "IDT");
                            ParamsMap timerParams = new ParamsMap();
                            timerParams.put("gsPltCode", pltCode);
                            timerParams.put("gsUserId", params.get("gsUserId"));
                            timerParams.put("idtId", idtId);
                            timerParams.put("mcCode", mcCode);
                            timerParams.put("empCode", empCode);
                            timerParams.put("idleCode", params.get("idleCode"));
                            timerParams.put("woNo", woNo);
                            timerParams.put("startTime", now);
                            timerParams.put("timerUpdateTime", now);
                            timerParams.put("idleMinute", idleMinute);
                            timerParams.put("remainMinute", idleMinute);
                            timerParams.put("ingMinute", 0);
                            timerParams.put("scomment", params.get("scomment"));
                            timerParams.put("dataFlag", 0);
                            insertByMapper(NS_IDLE_TIMER, "TSHP_IDLE_TIMER_INS", timerParams);
                            logger.debug("비가동 타이머 등록: idtId={}, idleMinute={}", idtId, Integer.valueOf(idleMinute));
                        }
                    } catch (NumberFormatException e) {
                        // IDLE_MINUTE가 숫자가 아니면 무시 (AS-IS: isNumeric() 체크)
                        logger.debug("IDLE_MINUTE 숫자 아님: {}", idleMinuteStr);
                    }
                }

                // (5) AS-IS: TSHP_IDLETIME_UPD6 (IS_AUTO_IDLE_FLAG='0')
                ParamsMap upd6Params = new ParamsMap();
                upd6Params.put("gsPltCode", pltCode);
                upd6Params.put("gsUserId", params.get("gsUserId"));
                upd6Params.put("empCode", empCode);
                upd6Params.put("workDate", workDate);
                updateByMapper(NS_IDLE, "TSHP_IDLETIME_UPD6", upd6Params);

                logger.info("POP30B_INS2 비가동 시작 완료: idleId={}, woNo={}", idleId, woNo);
                return success("비가동이 등록되었습니다.");

            } else {
                // ============================================================
                // 비가동 종료 (AS-IS: dataTable.Rows.Count > 0)
                // ============================================================
                Map<String, Object> existingIdle = (Map<String, Object>) existingIdles.get(0);
                String existingIdleId = (String) existingIdle.get("idleId");
                logger.info("POP30B_INS2 비가동 종료: idleId={}", existingIdleId);

                // (1) 비가동 레코드 종료 (END_TIME, STATE=0) → AS-IS: TSHP_IDLETIME_UPD
                ParamsMap endParams = new ParamsMap();
                endParams.put("gsPltCode", pltCode);
                endParams.put("gsUserId", params.get("gsUserId"));
                endParams.put("idleId", existingIdleId);
                endParams.put("endTime", now);
                endParams.put("idleState", "0");
                updateByMapper(NS_IDLE, "TSHP_IDLETIME_UPD", endParams);

                // (2) AS-IS: 3605 → idle 레코드에서 WO_NO 조회 → WO_FLAG='3' 업데이트
                if ("3605".equals(plantsParam)) {
                    ParamsMap idleSer2Params = new ParamsMap();
                    idleSer2Params.put("gsPltCode", pltCode);
                    idleSer2Params.put("idleId", existingIdleId);
                    Object idleDetail = selectByMapper(NS_IDLE, "TSHP_IDLETIME_SER2", idleSer2Params);

                    if (idleDetail != null) {
                        Map<String, Object> idleMap = (Map<String, Object>) idleDetail;
                        String idleWoNo = (String) idleMap.get("woNo");
                        if (idleWoNo != null && !idleWoNo.isEmpty()) {
                            ParamsMap woUpdParams = new ParamsMap();
                            woUpdParams.put("gsPltCode", pltCode);
                            woUpdParams.put("gsUserId", params.get("gsUserId"));
                            woUpdParams.put("woNo", idleWoNo);
                            woUpdParams.put("woFlag", "3");
                            updateByMapper(NS_WO, "TSHP_WORKORDER_UPD15", woUpdParams);
                            logger.debug("WO 상태 중지: woNo={}", idleWoNo);
                        }
                    }
                }

                // (3) AS-IS: TSHP_IDLETIME_UPD6 (IS_AUTO_IDLE_FLAG='0')
                ParamsMap upd6Params = new ParamsMap();
                upd6Params.put("gsPltCode", pltCode);
                upd6Params.put("gsUserId", params.get("gsUserId"));
                upd6Params.put("empCode", empCode);
                upd6Params.put("workDate", workDate);
                updateByMapper(NS_IDLE, "TSHP_IDLETIME_UPD6", upd6Params);

                logger.info("POP30B_INS2 비가동 종료 완료: idleId={}", existingIdleId);
                return success("비가동이 종료되었습니다.");
            }

        } catch (Exception e) {
            logger.error("POP30B_INS2 실패", e);
            throw new RuntimeException(e);
        }
    }

    // ========================================================================
    // POP30B_INS3: 일일검사 등록
    // 원본: POP30B.POP30B_INS3()
    //   각 행: 기존 확인 (SER) → INSERT/UPDATE
    //   INSERT 시 MDCR_NO 채번 "MDC"
    // ========================================================================

    /**
     * 일일검사 등록
     * <p>
     * 각 행에 대해 기존 데이터 존재 여부를 확인하고 INSERT/UPDATE를 수행한다.
     * 신규 행은 MDCR_NO를 채번(MDC)하여 등록한다.
     * </p>
     *
     * @param params models(JSON 상세 행: checkDate, mcCode, checkItem, checkResult 등)
     * @return 등록 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public ResultMap pop30bIns3(ParamsMap params) {
        try {
            String pltCode = params.getString("gsPltCode");
            logger.info("POP30B_INS3 시작");

            String modelsStr = params.getString("models");
            if (modelsStr == null || modelsStr.isEmpty()) {
                return failure("저장할 일일검사 데이터가 없습니다.");
            }

            JSONParser parser = new JSONParser();
            JSONArray models = (JSONArray) parser.parse(modelsStr);

            for (int i = 0; i < models.size(); i++) {
                JSONObject row = (JSONObject) models.get(i);

                ParamsMap rowParams = new ParamsMap();
                rowParams.put("gsPltCode", pltCode);
                rowParams.put("gsUserId", params.get("gsUserId"));
                // JSON 객체의 필드를 ParamsMap에 복사
                for (Object key : row.keySet()) {
                    rowParams.put((String) key, row.get(key));
                }
                // AS-IS: SAVE() Line 178-181 - 각 행에 DATE, MC_CODE 세팅
                // linkData["DATE"] → 오늘 날짜, linkData["MC_CODE"] → 선택 설비
                String mcCode = params.getString("mcCode");
                String workDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
                rowParams.put("mdcrDate", workDate);
                rowParams.put("mdcrMcCode", mcCode);

                // AS-IS: TPOP_MC_DAILY_CHECK_RESULT_SER (PLT_CODE + MDCR_NO) 로 존재 확인
                // McDailyCheck.cs Line 683: SER(GetRowToDt(row)) → WHERE PLT_CODE AND MDCR_NO
                // mdcrNo가 빈값(신규)이면 null 반환 → INSERT
                // mdcrNo가 값 있으면(기존) → 결과 있으면 UPDATE
                String mdcrNo = rowParams.getString("mdcrNo");
                Object existing = null;
                if (mdcrNo != null && !mdcrNo.isEmpty()) {
                    List existList = searchByMapper(NS_MC_DAILY_CHECK_RESULT, "TPOP_MC_DAILY_CHECK_RESULT_SER", rowParams);
                    existing = (existList != null && !existList.isEmpty()) ? existList.get(0) : null;
                }

                if (existing == null) {
                    // 신규: MDCR_NO 채번
                    String newMdcrNo = utilityService.getSerialNo(pltCode, "MDC");
                    rowParams.put("mdcrNo", newMdcrNo);
                    insertByMapper(NS_MC_DAILY_CHECK_RESULT, "TPOP_MC_DAILY_CHECK_RESULT_INS", rowParams);
                    logger.debug("일일검사 등록: mdcrNo={}", newMdcrNo);
                } else {
                    // 기존: 수정
                    updateByMapper(NS_MC_DAILY_CHECK_RESULT, "TPOP_MC_DAILY_CHECK_RESULT_UPD", rowParams);
                    logger.debug("일일검사 수정: row={}", Integer.valueOf(i));
                }
            }

            logger.info("POP30B_INS3 완료: {} 건 처리", Integer.valueOf(models.size()));
            return success("일일검사가 등록되었습니다.");

        } catch (Exception e) {
            logger.error("POP30B_INS3 실패", e);
            throw new RuntimeException(e);
        }
    }

    // ========================================================================
    // Private Helper Methods
    // ========================================================================

    /**
     * 검사결과 마스터 확인/생성 (POP30B_INS, POP30B_INS_1 공통)
     * <p>
     * 마스터 존재 여부를 확인하고, 없으면 신규 생성(INSM_NO 채번 "IRM"),
     * 있으면 업데이트한다.
     * </p>
     *
     * @param params 원본 파라미터 (woNo, sapWoNo, insGrpCode, empCode 등)
     * @param pltCode 공장코드
     * @return insmNo (검사결과 마스터 번호)
     */
    @SuppressWarnings("unchecked")
    private String saveInspectionMaster(ParamsMap params, String pltCode) {
        // 마스터 존재 확인
        ParamsMap masterParams = new ParamsMap();
        masterParams.put("gsPltCode", pltCode);
        masterParams.put("woNo", params.get("woNo"));
        masterParams.put("insGrpCode", params.get("insGrpCode"));
        masterParams.put("dataFlag", Integer.valueOf(0));
        List masterList = searchByMapper(NS_INS_RESULT_MASTER, "TSHP_INS_RESULT_MASTER_SER3", masterParams);

        String insmNo;
        if (masterList == null || masterList.isEmpty()) {
            // 마스터 신규 생성
            insmNo = utilityService.getSerialNo(pltCode, "IRM");
            ParamsMap insParams = new ParamsMap();
            insParams.put("gsPltCode", pltCode);
            insParams.put("gsUserId", params.get("gsUserId"));
            insParams.put("insmNo", insmNo);
            insParams.put("woNo", params.get("woNo"));
            insParams.put("sapWoNo", params.get("sapWoNo"));
            insParams.put("insGrpCode", params.get("insGrpCode"));
            insParams.put("empCode", params.get("empCode"));
            insertByMapper(NS_INS_RESULT_MASTER, "TSHP_INS_RESULT_MASTER_INS2", insParams);
            logger.info("검사결과 마스터 생성: insmNo={}", insmNo);
        } else {
            // 마스터 수정
            Map<String, Object> master = (Map<String, Object>) masterList.get(0);
            insmNo = (String) master.get("insmNo");
            ParamsMap updParams = new ParamsMap();
            updParams.put("gsPltCode", pltCode);
            updParams.put("gsUserId", params.get("gsUserId"));
            updParams.put("insmNo", insmNo);
            updParams.put("empCode", params.get("empCode"));
            updateByMapper(NS_INS_RESULT_MASTER, "TSHP_INS_RESULT_MASTER_UPD", updParams);
            logger.debug("검사결과 마스터 수정: insmNo={}", insmNo);
        }

        return insmNo;
    }

    /**
     * 검사결과 상세 행 처리 (POP30B_INS, POP30B_INS_1 공통)
     * <p>
     * 각 상세 행에 대해 존재 여부를 확인하고 INSERT/UPDATE를 수행한다.
     * INSERT 시 INS_NO를 채번("IR")한다.
     * </p>
     *
     * @param params 원본 파라미터 (models JSON 포함)
     * @param pltCode 공장코드
     * @param insmNo 검사결과 마스터 번호
     * @throws Exception JSON 파싱 또는 DB 오류 시
     */
    @SuppressWarnings("unchecked")
    private void saveInspectionDetails(ParamsMap params, String pltCode, String insmNo) throws Exception {
        String modelsStr = params.getString("models");
        if (modelsStr == null || modelsStr.isEmpty()) {
            return;
        }

        JSONParser parser = new JSONParser();
        JSONArray models = (JSONArray) parser.parse(modelsStr);

        for (int i = 0; i < models.size(); i++) {
            JSONObject row = (JSONObject) models.get(i);

            ParamsMap rowParams = new ParamsMap();
            rowParams.put("gsPltCode", pltCode);
            rowParams.put("gsUserId", params.get("gsUserId"));
            rowParams.put("insmNo", insmNo);
            // JSON 객체의 필드를 ParamsMap에 복사
            for (Object key : row.keySet()) {
                rowParams.put((String) key, row.get(key));
            }

            // 기존 데이터 확인
            Object existing = selectByMapper(NS_INS_RESULT, "TSHP_INS_RESULT_SER", rowParams);

            if (existing == null) {
                // 신규: INS_NO 채번
                String insNo = utilityService.getSerialNo(pltCode, "IR");
                rowParams.put("insNo", insNo);
                insertByMapper(NS_INS_RESULT, "TSHP_INS_RESULT_INS", rowParams);
                logger.debug("검사결과 상세 등록: insNo={}", insNo);
            } else {
                // 기존: 수정
                updateByMapper(NS_INS_RESULT, "TSHP_INS_RESULT_UPD", rowParams);
                logger.debug("검사결과 상세 수정: row={}", Integer.valueOf(i));
            }
        }
    }

    // ========================================================================
    // 13. 팝업 검색 (POP30B 전용)
    // ========================================================================

    /**
     * 비가동코드 목록 조회
     * AS-IS: POP32A_IDLE → TSTD_IDLECODE_SER2
     *
     * @param params plants(공장코드) 등
     * @return 비가동코드 목록
     */
    public Object pop30bIdleCodeSearch(ParamsMap params) {
        logger.debug("TSTD_IDLECODE_SER2: plants={}", params.get("plants"));
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }
        return searchByMapper(NS_IDLE_CODE, "TSTD_IDLECODE_SER2", params);
    }

    /**
     * 작업장(설비) 검색
     * AS-IS: ChangeCellMc → CONTROL_MACHINE_SEARCH → LSE_MACHINE_QUERY2
     */
    public Object pop30bMcSearch(ParamsMap params) {
        logger.debug("LSE_MACHINE_QUERY2: mcGroup={}", params.get("mcGroup"));
        return searchByMapper(NS_MC_QUERY, "LSE_MACHINE_QUERY2", params);
    }

    /**
     * 작업자(사원) 검색
     * AS-IS: ChangeEmp → CONTROL_EMP_SEARCH → TSTD_EMPLOYEE_QUERY6
     * BIZ 계층: IS_MC='1' (기계 작업자), DATA_FLAG=0
     */
    public Object pop30bEmpSearch(ParamsMap params) {
        logger.debug("TSTD_EMPLOYEE_QUERY6: isMc={}", params.get("isMc"));
        if (params.get("isMc") == null) {
            params.put("isMc", "1");
        }
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }
        return searchByMapper(NS_EMP_QUERY, "TSTD_EMPLOYEE_QUERY6", params);
    }

    // ========================================================================
    // POP30B_D4A 자주검사 팝업 전용
    // ========================================================================

    /** D4A 네임스페이스 */
    private static final String NS_D4A_QUERY = "com.wsc.imes.pop.POP30B_D4A_QUERY";

    /**
     * D4A 작업지시 정보 조회 (팝업 상단 라벨용)
     *
     * @param params woNo(작업오더번호)
     * @return 작업지시 정보 (sapWoNo, procCode, mcCode, model, partCode, partName)
     */
    public Object pop30bD4aWoInfo(ParamsMap params) {
        logger.debug("POP30B_D4A_WO_INFO: woNo={}", params.get("woNo"));
        return selectByMapper(NS_D4A_QUERY, "POP30B_D4A_WO_INFO", params);
    }

    /**
     * D4A 검사그룹 이미지 조회 (QCT05A 방식 — TO_BASE64)
     *
     * @param params insGrpCode, gsPltCode
     * @return Map with insImgBase64 or null
     */
    public Object selectInsGrpImg(ParamsMap params) {
        return selectByMapper(NS_INS_GRP, "TSTD_INS_GRP_IMG_SER", params);
    }

}
