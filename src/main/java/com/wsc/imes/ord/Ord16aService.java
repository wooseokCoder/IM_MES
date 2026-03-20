/*
 * ============================================================================
 * 화면명: ORD16A - 생산오더 완료처리
 * ============================================================================
 * 설명: 작업지시 조회 및 생산오더 완료 처리
 *
 * 비즈니스 로직 흐름:
 *   1. 선택된 작업지시(WO_NO)별로 순회
 *   2. 진행중(PROC_STAT=2) + 일시중단(PROC_STAT=3) 작업자 실적 조회
 *   3. 각 작업자 실적을 완료(PROC_STAT=4)로 변경 (UPD9)
 *   4. 완료 실적 레코드 INSERT (INS2)
 *   5. 활성 비가동(IDLE_STATE=1) 종료 처리
 *   6. 작업지시 완료(WO_FLAG=2) 상태 변경 (UPD31)
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - ORD16A_SER → ord16aSer (작업지시 조회)
 * - ORD16A_UPD → ord16aUpd (완료 처리)
 *
 * 원본: ProActive ORD16A.cs
 *
 * @author Claude
 * @since 2026-03-04
 * ============================================================================
 */
package com.wsc.imes.ord;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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
 * 생산오더 완료처리 서비스
 *
 * @author Claude
 * @version 1.0
 */
@Service
public class Ord16aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Ord16aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================

    /** 작업지시 테이블 */
    private static final String NS = "com.wsc.imes.ord.TSHP_WORKORDER";

    /** 작업지시 조회 쿼리 */
    private static final String NS_QUERY = "com.wsc.imes.ord.TSHP_WORKORDER_QUERY";

    /** 공정 실적 테이블 */
    private static final String NS_ACT = "com.wsc.imes.ord.TSHP_ACTUAL";

    /** 공정 실적 조회 쿼리 */
    private static final String NS_ACT_QUERY = "com.wsc.imes.ord.TSHP_ACTUAL_QUERY";

    /** 비가동 테이블 (pop 모듈 공유) */
    private static final String NS_IDLE = "com.wsc.imes.pop.TSHP_IDLETIME";

    /** 비가동 조회 쿼리 (pop 모듈 공유) */
    private static final String NS_IDLE_QUERY = "com.wsc.imes.pop.TSHP_IDLETIME_QUERY";

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
    // ORD16A_SER: 작업지시 조회
    // TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY29 호출
    // IS_SIM=1, DATA_FLAG=0 고정 조건
    // ========================================================================

    /**
     * 작업지시 조회 (완료 처리 대상)
     *
     * <p>AS-IS ORD16A_SER: 15개 파라미터를 SP에 전달하여
     * 검색조건에 맞는 작업지시 목록을 조회한다.</p>
     *
     * @param params 검색 조건 (gsPltCode, 일자구분별 날짜범위, orderLike 등)
     * @return 작업지시 목록 (IS_SIM=1, DATA_FLAG=0 하드코딩)
     */
    public Object ord16aSer(ParamsMap params) {
        // AS-IS: IS_SIM=1 (시뮬레이터 생성 작업지시만)
        // DATA_FLAG=0 은 SP 내부에서 하드코딩

        ParamsMap queryParams = new ParamsMap();
        queryParams.put("gsPltCode", params.getString("gsPltCode"));
        queryParams.put("isSim", "1");

        // 검색조건: 생산오더번호, 호기, 수주처, 공장
        queryParams.put("orderLike", params.getString("orderLike"));
        queryParams.put("hogiLike", params.getString("hogiLike"));
        queryParams.put("customerLike", params.getString("customerLike"));
        queryParams.put("plants", params.getString("plants"));

        // 검색조건: 일자구분별 날짜범위 (JS에서 dateType에 따라 분기하여 전달)
        queryParams.put("sDueDate", params.getString("sDueDate"));
        queryParams.put("eDueDate", params.getString("eDueDate"));
        queryParams.put("sIndueDate", params.getString("sIndueDate"));
        queryParams.put("eIndueDate", params.getString("eIndueDate"));
        queryParams.put("sSapDueDate", params.getString("sSapDueDate"));
        queryParams.put("eSapDueDate", params.getString("eSapDueDate"));
        queryParams.put("sPlnDate", params.getString("sPlnDate"));
        queryParams.put("ePlnDate", params.getString("ePlnDate"));

        // 검색조건: 모델유형 (hidden, 현재 미사용)
        queryParams.put("prodType", params.getString("prodType"));

        return searchByMapper(NS_QUERY, "TSHP_WORKORDER_QUERY29", queryParams);
    }

    // ========================================================================
    // ORD16A_UPD: 생산오더 완료 처리
    // AS-IS 흐름:
    //   선택된 각 작업지시(WO_NO)에 대해:
    //     1. 진행중(PROC_STAT=2) 작업자 조회 → TSHP_ACTUAL_QUERY19
    //     2. 일시중단(PROC_STAT=3) 작업자 조회 → TSHP_ACTUAL_QUERY19
    //     3. 활성 비가동(IDLE_STATE=1) 조회 → TSHP_IDLETIME_QUERY7
    //     4. 진행중+일시중단 작업자 실적 종료 (UPD9) + 완료 실적 INSERT (INS2)
    //     5. 활성 비가동 종료 (TSHP_IDLETIME_UPD)
    //     6. 작업지시 완료 (TSHP_WORKORDER_UPD31, WO_FLAG=2)
    // ========================================================================

    /**
     * 생산오더 완료 처리 (다건)
     *
     * <p>선택된 작업지시 목록에 대해 일괄 완료 처리를 수행한다.
     * 각 작업지시에 대해 진행중/일시중단 상태의 작업자 실적을 종료하고,
     * 활성 비가동을 종료한 후, 작업지시를 완료 상태로 변경한다.</p>
     *
     * @param params modelList (JSONArray: 선택된 작업지시 행 목록),
     *               gsPltCode (공장 코드), gsUserId (사용자 ID)
     * @return 완료 처리 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord16aUpd(ParamsMap params) {
        try {
            // modelList는 프론트엔드에서 JSON 문자열로 전달되므로 파싱 필요
            Object modelListObj = params.get("modelList");
            JSONArray rows;
            if (modelListObj instanceof JSONArray) {
                rows = (JSONArray) modelListObj;
            } else {
                JSONParser parser = new JSONParser();
                rows = (JSONArray) parser.parse(modelListObj.toString());
            }

            if (rows == null || rows.size() == 0) {
                return failure("처리할 데이터가 없습니다.");
            }

            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");

            // 현재 시간 (yyyyMMddHHmmss 형식)
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
            String currentTime = sdf.format(new Date());
            String currentDate = currentTime.substring(0, 8); // yyyyMMdd

            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);

                // 행 데이터에서 필수값 추출
                String woNo = row.get("woNo") != null ? row.get("woNo").toString() : "";
                String mcCode = row.get("mcCode") != null ? row.get("mcCode").toString() : "";
                String actStartTime = row.get("actStartTime") != null ? row.get("actStartTime").toString() : null;

                // ============================================================
                // STEP 1: 진행중 작업자 조회 (PROC_STAT=2)
                // ============================================================
                ParamsMap queryParams = new ParamsMap();
                queryParams.put("gsPltCode", gsPltCode);
                queryParams.put("woNo", woNo);
                queryParams.put("procStat", "2");
                List ingList = searchByMapper(NS_ACT_QUERY, "TSHP_ACTUAL_QUERY19", queryParams);

                // ============================================================
                // STEP 2: 일시중단 작업자 조회 (PROC_STAT=3)
                // ============================================================
                queryParams.put("procStat", "3");
                List stopList = searchByMapper(NS_ACT_QUERY, "TSHP_ACTUAL_QUERY19", queryParams);

                // ============================================================
                // STEP 3: 활성 비가동 조회 (IDLE_STATE=1)
                // ============================================================
                ParamsMap idleParams = new ParamsMap();
                idleParams.put("gsPltCode", gsPltCode);
                idleParams.put("woNo", woNo);
                idleParams.put("idleState", "1");
                List idleList = searchByMapper(NS_IDLE_QUERY, "TSHP_IDLETIME_QUERY7", idleParams);

                // ============================================================
                // STEP 4: 진행중 + 일시중단 작업자 합산
                // ============================================================
                List allList = new ArrayList<Map<String, Object>>();
                if (ingList != null) {
                    allList.addAll(ingList);
                }
                if (stopList != null) {
                    allList.addAll(stopList);
                }

                // ============================================================
                // STEP 5: 각 작업자의 기존 실적 종료 + 완료 실적 INSERT
                // ============================================================
                for (int j = 0; j < allList.size(); j++) {
                    Map worker = (Map) allList.get(j);

                    // ---------------------------------------------------------
                    // 5a. 기존 실적 완료 처리 (TSHP_ACTUAL_UPD9)
                    //     PROC_STAT=4 (완료), ACT_END_TIME=현재시간
                    // ---------------------------------------------------------
                    ParamsMap updParams = new ParamsMap();
                    updParams.put("gsPltCode", gsPltCode);
                    updParams.put("actualId", worker.get("actualId"));
                    updParams.put("procStat", "4");
                    updParams.put("actEndTime", currentTime);
                    updParams.put("gsUserId", gsUserId);
                    updateByMapper(NS_ACT, "TSHP_ACTUAL_UPD9", updParams);

                    // ---------------------------------------------------------
                    // 5b. 완료 실적 레코드 INSERT (TSHP_ACTUAL_INS2)
                    //     새 PROC_STAT=4 레코드를 기록
                    //     시간/수량 모두 0으로 설정 (완료 마커 역할)
                    // ---------------------------------------------------------
                    ParamsMap insParams = new ParamsMap();
                    insParams.put("gsPltCode", gsPltCode);
                    insParams.put("actualId", ""); // 새 ID는 SP에서 자동 생성
                    insParams.put("workDate", currentDate);
                    insParams.put("woNo", woNo);
                    insParams.put("empCode", worker.get("empCode") != null ? worker.get("empCode").toString() : "");
                    insParams.put("mcCode", worker.get("mcCode") != null ? worker.get("mcCode").toString() : mcCode);
                    insParams.put("mcNmCheck", "");
                    insParams.put("procStat", "4");
                    insParams.put("panelStat", worker.get("panelStat") != null ? worker.get("panelStat").toString() : "");
                    insParams.put("actStartTime", currentTime);
                    insParams.put("actEndTime", currentTime);
                    insParams.put("selfTime", "0");
                    insParams.put("manTime", "0");
                    insParams.put("otTime", "0");
                    insParams.put("okQty", "0");
                    insParams.put("ngQty", "0");
                    insParams.put("multiStartCnt", "0");
                    insParams.put("inputFlag", "");
                    insParams.put("gsUserId", gsUserId);
                    insertByMapper(NS_ACT, "TSHP_ACTUAL_INS2", insParams);

                    logger.debug("ORD16A_UPD: 작업자 실적 완료 처리 - woNo={}, empCode={}", woNo, worker.get("empCode"));
                }

                // ============================================================
                // STEP 6: 활성 비가동 종료 처리
                // ============================================================
                if (idleList != null) {
                    for (int k = 0; k < idleList.size(); k++) {
                        Map idle = (Map) idleList.get(k);

                        // 비가동 종료 (IDLE_STATE=2, END_TIME=현재시간)
                        ParamsMap idleUpdParams = new ParamsMap();
                        idleUpdParams.put("gsPltCode", gsPltCode);
                        idleUpdParams.put("idleId", idle.get("idleId"));
                        idleUpdParams.put("idleState", "2");
                        idleUpdParams.put("endTime", currentTime);
                        updateByMapper(NS_IDLE, "TSHP_IDLETIME_UPD", idleUpdParams);

                        logger.debug("ORD16A_UPD: 비가동 종료 - woNo={}, idleId={}", woNo, idle.get("idleId"));
                    }
                }

                // ============================================================
                // STEP 7: 작업지시 완료 처리 (TSHP_WORKORDER_UPD31)
                //         WO_FLAG=2 (완료), ACT_END_TIME=현재시간
                // ============================================================
                ParamsMap woParams = new ParamsMap();
                woParams.put("gsPltCode", gsPltCode);
                woParams.put("woNo", woNo);
                woParams.put("woFlag", "2");
                // ACT_START_TIME: 기존 시작시간이 있으면 유지, 없으면 현재시간
                woParams.put("actStartTime", actStartTime != null ? actStartTime : currentTime);
                woParams.put("actEndTime", currentTime);
                woParams.put("gsUserId", gsUserId);
                updateByMapper(NS, "TSHP_WORKORDER_UPD31", woParams);

                logger.debug("ORD16A_UPD: 작업지시 완료 - woNo={}, workers={}, idles={}",
                        new Object[]{woNo, allList.size(), (idleList != null ? idleList.size() : 0)});
            }

            logger.info("ORD16A_UPD 완료: {}건", rows.size());
            return success("완료 처리되었습니다.");

        } catch (Exception e) {
            logger.error("ORD16A_UPD 실패", e);
            return failure("완료 처리 실패: " + e.getMessage());
        }
    }

}
