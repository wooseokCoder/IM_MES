/*
 * ============================================================================
 * 화면명: MAT05A - 자재불출현황
 * ============================================================================
 * 설명: 생산지시별 자재 불출 조회, 현장불출, 불출취소
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - MAT05A_SER  → mat05aSer  (Tab1 메인 조회)
 * - MAT05A_SER2 → mat05aSer2 (Tab1 디테일)
 * - MAT05A_SER3 → mat05aSer3 (D0A 담당자 목록)
 * - MAT05A_SER4 → mat05aSer4 (D0A/D1A 자재 목록)
 * - MAT05A_SER6 → mat05aSer6 (D1A 출고건 목록)
 * - MAT05A_SER8 → mat05aSer8 (Tab2/Tab3)
 * - MAT05A_INS  → mat05aIns  (현장불출 저장)
 * - MAT05A_DEL  → mat05aDel  (불출취소)
 *
 * 원본: ProActive MAT05A.cs
 * 작성일: 2026-03-04
 * ============================================================================
 */
package com.wsc.imes.mat;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.imes.common.UtilityService;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

/**
 * 자재불출현황 서비스
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Mat05aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Mat05aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_WORKORDER_QUERY = "com.wsc.imes.ord.TSHP_WORKORDER_QUERY";
    private static final String NS_WORKORDER = "com.wsc.imes.ord.TSHP_WORKORDER";
    private static final String NS_PART_USE_QUERY = "com.wsc.imes.mat.TSHP_PART_USE_QUERY";
    private static final String NS_PART_SHIP_RATE_QUERY = "com.wsc.imes.mat.TSHP_PART_SHIP_RATE_QUERY";
    private static final String NS_STK_OUT = "com.wsc.imes.mat.TSHP_STK_OUT";
    private static final String NS_STK_OUT_PART = "com.wsc.imes.mat.TSHP_STK_OUT_PART";
    private static final String NS_STK_OUT_PART_QUERY = "com.wsc.imes.mat.TSHP_STK_OUT_PART_QUERY";
    private static final String NS_STD_PROC_QUERY = "com.wsc.imes.std.LSE_STD_PROC_QUERY";

    @Autowired
    private CommonDao dao;

    @Autowired
    private UtilityService utilityService;

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
    // MAT05A_SER: Tab1 메인 조회 (3개 결과셋)
    // WORKORDER_QUERY1_2_1 + PART_USE_QUERY4 + PART_SHIP_RATE_QUERY1
    // ========================================================================

    /**
     * Tab1 메인 조회 (생산지시 + MRP 담당자 + 불출율)
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> mat05aSer(ParamsMap params) {
        // AS-IS: BIZ에서 IS_SIM=1 고정 (WO_FLAG_IN은 UI에서 전달)
        params.put("isSim", "1");

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("rows", searchByMapper(NS_WORKORDER_QUERY, "TSHP_WORKORDER_QUERY1_2_1", params));
        result.put("empList", searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY4", params));
        result.put("rateList", searchByMapper(NS_PART_SHIP_RATE_QUERY, "TSHP_PART_SHIP_RATE_QUERY1", params));
        return result;
    }

    // ========================================================================
    // MAT05A_SER2: Tab1 디테일 (소요자재)
    // PART_USE_QUERY3
    // ========================================================================

    /**
     * Tab1 디테일 조회 (소요자재) - 단건
     */
    public Object mat05aSer2(ParamsMap params) {
        return searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY3", params);
    }

    /**
     * Tab1 디테일 조회 (소요자재) - 다건 (선택공정 자재조회)
     * AS-IS: RQSTDT 각 행에 대해 QUERY3 반복 실행 후 결과 Merge
     */
    @SuppressWarnings("unchecked")
    public Object mat05aSer2Multi(ParamsMap params) {
        JSONArray models = (JSONArray) params.get("modelList");
        if (models == null || models.size() == 0) {
            return java.util.Collections.emptyList();
        }

        String gsPltCode = params.getString("gsPltCode");
        List allRows = new java.util.ArrayList();

        for (int i = 0; i < models.size(); i++) {
            JSONObject row = (JSONObject) models.get(i);
            ParamsMap queryParams = new ParamsMap();
            queryParams.put("gsPltCode", gsPltCode);
            queryParams.put("sapWoNo", row.get("sapWoNo"));
            queryParams.put("orderNo", row.get("orderNo"));
            queryParams.put("orderLine", row.get("orderLine"));
            queryParams.put("partCode", row.get("partCode"));

            List result = searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY3", queryParams);
            if (result != null) {
                allRows.addAll(result);
            }
        }

        return allRows;
    }

    // ========================================================================
    // MAT05A_SER3: D0A 담당자 목록
    // PART_USE_QUERY5
    // ========================================================================

    /**
     * D0A 담당자 목록 조회
     */
    public Object mat05aSer3(ParamsMap params) {
        return searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY5", params);
    }

    // ========================================================================
    // MAT05A_SER4: D0A/D1A 자재 목록
    // PART_USE_QUERY6
    // ========================================================================

    /**
     * D0A/D1A 자재 상세 조회
     */
    public Object mat05aSer4(ParamsMap params) {
        return searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY6", params);
    }

    // ========================================================================
    // MAT05A_SER6: D1A 출고건 목록
    // STK_OUT_SER3
    // ========================================================================

    /**
     * D1A 출고건 목록 조회
     */
    public Object mat05aSer6(ParamsMap params) {
        return searchByMapper(NS_STK_OUT, "TSHP_STK_OUT_SER3", params);
    }

    // ========================================================================
    // MAT05A_SER8: Tab2/Tab3
    // WORKORDER_QUERY1_3
    // ========================================================================

    /**
     * Tab2/Tab3 결합 조회 (작업지시+소요자재)
     */
    public Object mat05aSer8(ParamsMap params) {
        // AS-IS: BIZ에서 IS_SIM=1 고정 (WO_FLAG_IN은 UI에서 전달)
        params.put("isSim", "1");
        return searchByMapper(NS_WORKORDER_QUERY, "TSHP_WORKORDER_QUERY1_3", params);
    }

    // ========================================================================
    // ORD04A_PROC: 마스터 공정 목록 (Tab3 동적 컬럼용)
    // LSE_STD_PROC_QUERY8
    // ========================================================================

    /**
     * 마스터 공정 목록 (ORD04A_PROC)
     * BIZ 고정값: DATA_FLAG=0, LPROC_CODE='ASSY', USE_FLAG='1'
     * 화면 전달값: PLT_CODE(세션 gsPltCode), isFirstProc
     */
    public Object ord04aProc(ParamsMap params) {
        params.put("dataFlag", "0");
        params.put("lprocCode", "ASSY");
        params.put("useFlag", "1");
        return searchByMapper(NS_STD_PROC_QUERY, "LSE_STD_PROC_QUERY8", params);
    }

    // ========================================================================
    // MAT05A_INS: 현장불출 저장
    // @Transactional
    // ========================================================================

    /**
     * 현장불출 저장
     *
     * AS-IS 로직:
     * 1. STK_OUT_NO 결정 (기존 or 신규 채번)
     * 2. TSHP_STK_OUT 존재 확인 → 없으면 INSERT
     * 3. 각 자재별 TSHP_STK_OUT_PART 존재 확인 → INSERT or UPDATE
     * 4. 불출율 계산 및 UPDATE
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap mat05aIns(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("불출할 자재가 없습니다.");
            }

            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");

            // 첫 번째 행에서 공통 정보 추출
            JSONObject firstRow = (JSONObject) rows.get(0);
            String stkOutNo = String.valueOf(firstRow.get("stkOutNo"));
            String prodCode = String.valueOf(firstRow.get("prodCode"));
            String woNo = String.valueOf(firstRow.get("woNo"));
            String procCode = String.valueOf(firstRow.get("procCode"));
            String sapWoNo = String.valueOf(firstRow.get("sapWoNo"));
            String mrpEmp = String.valueOf(firstRow.get("mrpEmp"));
            String banPartCode = String.valueOf(firstRow.get("banPartCode"));
            String orderNo = String.valueOf(firstRow.get("orderNo"));
            String orderLine = String.valueOf(firstRow.get("orderLine"));

            // 1. STK_OUT_NO 결정
            if (stkOutNo == null || stkOutNo.isEmpty()) {
                stkOutNo = utilityService.getSerialNo(gsPltCode, "SO");
                if (stkOutNo == null) {
                    return failure("출고번호 채번에 실패했습니다.");
                }
            }

            // 2. TSHP_STK_OUT 존재 확인 → 없으면 INSERT
            ParamsMap soSerParams = new ParamsMap();
            soSerParams.put("gsPltCode", gsPltCode);
            soSerParams.put("stkOutNo", stkOutNo);
            List soList = searchByMapper(NS_STK_OUT, "TSHP_STK_OUT_SER", soSerParams);

            if (soList == null || soList.isEmpty()) {
                ParamsMap soInsParams = new ParamsMap();
                soInsParams.put("gsPltCode", gsPltCode);
                soInsParams.put("stkOutNo", stkOutNo);
                soInsParams.put("prodCode", prodCode);
                soInsParams.put("woNo", woNo);
                soInsParams.put("procCode", procCode);
                soInsParams.put("sapWoNo", sapWoNo);
                soInsParams.put("mrpEmp", mrpEmp);
                soInsParams.put("gsUserId", gsUserId);
                insertByMapper(NS_STK_OUT, "TSHP_STK_OUT_INS", soInsParams);
                logger.debug("STK_OUT_INS: stkOutNo={}", stkOutNo);
            }

            // 3. 각 자재별 TSHP_STK_OUT_PART 처리
            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                String stkOutPartNo = String.valueOf(row.get("stkOutPartNo"));
                String partCode = String.valueOf(row.get("partCode"));
                String outFlag = String.valueOf(row.get("outFlag"));

                if (outFlag == null || outFlag.isEmpty()) {
                    outFlag = "1";
                }

                if (stkOutPartNo != null && !stkOutPartNo.isEmpty()) {
                    // 기존 존재 → UPDATE
                    ParamsMap sopUpdParams = new ParamsMap();
                    sopUpdParams.put("gsPltCode", gsPltCode);
                    sopUpdParams.put("stkOutNo", stkOutNo);
                    sopUpdParams.put("stkOutPartNo", stkOutPartNo);
                    sopUpdParams.put("partCode", partCode);
                    sopUpdParams.put("outFlag", outFlag);
                    updateByMapper(NS_STK_OUT_PART, "TSHP_STK_OUT_PART_UPD", sopUpdParams);
                } else {
                    // 신규 → 채번 + INSERT
                    stkOutPartNo = utilityService.getSerialNo(gsPltCode, "SOP");
                    if (stkOutPartNo == null) {
                        return failure("불출자재번호 채번에 실패했습니다.");
                    }
                    ParamsMap sopInsParams = new ParamsMap();
                    sopInsParams.put("gsPltCode", gsPltCode);
                    sopInsParams.put("stkOutNo", stkOutNo);
                    sopInsParams.put("stkOutPartNo", stkOutPartNo);
                    sopInsParams.put("partCode", partCode);
                    sopInsParams.put("outFlag", outFlag);
                    sopInsParams.put("gsUserId", gsUserId);
                    insertByMapper(NS_STK_OUT_PART, "TSHP_STK_OUT_PART_INS", sopInsParams);
                }
                logger.debug("STK_OUT_PART: stkOutNo={}, stkOutPartNo={}, outFlag={}", new Object[]{stkOutNo, stkOutPartNo, outFlag});
            }

            // 4. 불출율 계산
            calculateAndUpdateRates(gsPltCode, gsUserId, stkOutNo, sapWoNo,
                    orderNo, orderLine, banPartCode, woNo, mrpEmp, true);

            logger.info("MAT05A_INS 완료: stkOutNo={}, {}건", stkOutNo, rows.size());

            // 5. MAT05A_SER5 호출 (AS-IS 동일: 부모그리드 갱신 데이터)
            ParamsMap ser5Params = new ParamsMap();
            ser5Params.put("gsPltCode", gsPltCode);
            ser5Params.put("gsUserId", gsUserId);
            ser5Params.put("gsLang", params.getString("gsLang"));
            ser5Params.put("gsSysId", params.getString("gsSysId"));
            ser5Params.put("sapWoNo", sapWoNo);
            ser5Params.put("orderNo", orderNo);
            ser5Params.put("orderLine", orderLine);
            ser5Params.put("partCode", banPartCode);
            ser5Params.put("mrpEmp", mrpEmp);

            ResultMap result = success(mrpEmp + " 담당 자재가 불출되었습니다.");
            result.put("updatedRow", mat05aSer5(ser5Params));
            return result;

        } catch (Exception e) {
            logger.error("MAT05A_INS 실패", e);
            return failure("불출 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // MAT05A_DEL: 불출취소
    // @Transactional
    // ========================================================================

    /**
     * 불출취소
     *
     * AS-IS 로직:
     * 1. 각 자재별 TSHP_STK_OUT_PART UPDATE (OUT_FLAG='0')
     * 2. 불출율 재계산
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap mat05aDel(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("취소할 자재가 없습니다.");
            }

            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");

            // 첫 번째 행에서 공통 정보 추출
            JSONObject firstRow = (JSONObject) rows.get(0);
            String stkOutNo = String.valueOf(firstRow.get("stkOutNo"));
            String sapWoNo = String.valueOf(firstRow.get("sapWoNo"));
            String banPartCode = String.valueOf(firstRow.get("banPartCode"));
            String orderNo = String.valueOf(firstRow.get("orderNo"));
            String orderLine = String.valueOf(firstRow.get("orderLine"));
            String woNo = String.valueOf(firstRow.get("woNo"));
            String mrpEmp = String.valueOf(firstRow.get("mrpEmp"));

            // 1. 각 자재별 OUT_FLAG='0' UPDATE
            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                String stkOutPartNo = String.valueOf(row.get("stkOutPartNo"));
                String partCode = String.valueOf(row.get("partCode"));

                ParamsMap sopUpdParams = new ParamsMap();
                sopUpdParams.put("gsPltCode", gsPltCode);
                sopUpdParams.put("stkOutNo", stkOutNo);
                sopUpdParams.put("stkOutPartNo", stkOutPartNo);
                sopUpdParams.put("partCode", partCode);
                sopUpdParams.put("outFlag", "0");
                updateByMapper(NS_STK_OUT_PART, "TSHP_STK_OUT_PART_UPD", sopUpdParams);
                logger.debug("STK_OUT_PART_UPD(취소): stkOutPartNo={}", stkOutPartNo);
            }

            // 2. 불출율 재계산 (AS-IS DEL: 개별 OUT_RATE 계산 안함, MAT_OUT_RATE_MES/MAT_OUT_STK_RATE만 계산)
            calculateAndUpdateRates(gsPltCode, gsUserId, stkOutNo, sapWoNo,
                    orderNo, orderLine, banPartCode, woNo, mrpEmp, false);

            logger.info("MAT05A_DEL 완료: stkOutNo={}, {}건", stkOutNo, rows.size());

            // 3. MAT05A_SER5 호출 (AS-IS 동일: 부모그리드 갱신 데이터)
            ParamsMap ser5Params = new ParamsMap();
            ser5Params.put("gsPltCode", gsPltCode);
            ser5Params.put("gsUserId", gsUserId);
            ser5Params.put("gsLang", params.getString("gsLang"));
            ser5Params.put("gsSysId", params.getString("gsSysId"));
            ser5Params.put("sapWoNo", sapWoNo);
            ser5Params.put("orderNo", orderNo);
            ser5Params.put("orderLine", orderLine);
            ser5Params.put("partCode", banPartCode);
            ser5Params.put("mrpEmp", mrpEmp);

            ResultMap result = success(mrpEmp + " 담당 자재가 불출취소 되었습니다.");
            result.put("updatedRow", mat05aSer5(ser5Params));
            return result;

        } catch (Exception e) {
            logger.error("MAT05A_DEL 실패", e);
            return failure("불출취소 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // 불출율 계산 공통 메서드
    // ========================================================================

    // ========================================================================
    // MAT05A_SER5: 불출/취소 후 갱신 데이터 조회
    // AS-IS: MAT05A_INS BIZ 내부에서 호출
    // ========================================================================

    /**
     * MAT05A_SER5: 불출/취소 후 갱신 데이터 조회
     *
     * AS-IS 파라미터 (RQSTDT):
     *   PLT_CODE, SAP_WO_NO, ORDER_NO, ORDER_LINE, PART_CODE(=BAN_PART_CODE),
     *   MRP_EMP, WO_FLAG_IN="('1','2','3','4')", PLANTS=PLT_CODE, IS_SIM=1
     *
     * AS-IS 반환 (4개 결과셋):
     *   RSLTDT      - 부모 그리드 행 (QUERY1_2_1 + sapWoNo 필터)
     *   RSLTDT_EMP  - 담당자 목록 (QUERY4)
     *   RSLTDT_RATE - 불출율 (RATE_QUERY1)
     *   RSLTDT_PART - 자재 상세 (QUERY6, SEL 설정 포함)
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> mat05aSer5(ParamsMap params) {
        // AS-IS BIZ 고정값
        params.put("isSim", "1");
        params.put("woFlagIn", "1,2,3,4");
        params.put("plants", "3603");

        Map<String, Object> result = new HashMap<String, Object>();

        // 1. RSLTDT: 부모 그리드 행 (AS-IS: QUERY1_2 — ORDER_NO/ORDER_LINE 등호 비교)
        result.put("rows", searchByMapper(NS_WORKORDER_QUERY, "TSHP_WORKORDER_QUERY1_2", params));

        // 2. RSLTDT_EMP: 담당자 목록 (QUERY4)
        result.put("empList", searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY4", params));

        // 3. RSLTDT_RATE: 불출율 (RATE_QUERY1)
        result.put("rateList", searchByMapper(NS_PART_SHIP_RATE_QUERY, "TSHP_PART_SHIP_RATE_QUERY1", params));

        // 4. RSLTDT_PART: 자재 상세 (QUERY6, OUT_FLAG/STK_OUT_NO 필터 없이)
        List partList = searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY6", params);
        // AS-IS SEL 설정: USE_QTY != 0 → "0"(미선택), USE_QTY == 0 → "1"(선택)
        if (partList != null) {
            for (Object obj : partList) {
                Map m = (Map) obj;
                Object useQtyObj = m.get("useQty");
                BigDecimal useQty = BigDecimal.ZERO;
                if (useQtyObj != null) {
                    useQty = new BigDecimal(String.valueOf(useQtyObj));
                }
                m.put("sel", useQty.compareTo(BigDecimal.ZERO) != 0 ? "0" : "1");
            }
        }
        result.put("partList", partList);

        return result;
    }

    /**
     * 불출율 계산 및 TSHP_STK_OUT, TSHP_WORKORDER 업데이트
     *
     * @param updateOutRate true: INS (OUT_RATE도 갱신), false: DEL (OUT_RATE 갱신 안함)
     */
    @SuppressWarnings("unchecked")
    private void calculateAndUpdateRates(String gsPltCode, String gsUserId,
            String stkOutNo, String sapWoNo, String orderNo, String orderLine,
            String banPartCode, String woNo, String mrpEmp, boolean updateOutRate) {

        // --- (A) OUT_RATE 계산 (INS 전용) ---
        if (updateOutRate) {
            ParamsMap q8Params = new ParamsMap();
            q8Params.put("gsPltCode", gsPltCode);
            q8Params.put("sapWoNo", sapWoNo);
            q8Params.put("orderNo", orderNo);
            q8Params.put("orderLine", orderLine);
            q8Params.put("partCode", banPartCode);
            q8Params.put("mrpEmp", mrpEmp);
            List q8List = searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY8", q8Params);

            ParamsMap sopqParams = new ParamsMap();
            sopqParams.put("gsPltCode", gsPltCode);
            sopqParams.put("stkOutNo", stkOutNo);
            List sopqList = searchByMapper(NS_STK_OUT_PART_QUERY, "TSHP_STK_OUT_PART_QUERY1", sopqParams);

            int totalCount = (q8List != null) ? q8List.size() : 0;
            int issuedCount = 0;
            if (sopqList != null) {
                for (Object obj : sopqList) {
                    Map m = (Map) obj;
                    if ("1".equals(m.get("outFlag"))) issuedCount++;
                }
            }

            BigDecimal outRate = BigDecimal.ZERO;
            if (totalCount > 0) {
                outRate = new BigDecimal(issuedCount)
                        .multiply(new BigDecimal(100))
                        .divide(new BigDecimal(totalCount), 2, RoundingMode.HALF_UP);
            }

            ParamsMap soUpdParams = new ParamsMap();
            soUpdParams.put("gsPltCode", gsPltCode);
            soUpdParams.put("stkOutNo", stkOutNo);
            soUpdParams.put("outRate", outRate);
            updateByMapper(NS_STK_OUT, "TSHP_STK_OUT_UPD", soUpdParams);
            logger.debug("OUT_RATE: {}/{} = {}", new Object[]{issuedCount, totalCount, outRate});
        }

        // --- (B) MAT_OUT_RATE_MES 계산 (전체 WO 대비) ---
        // AS-IS: STK_OUT_SER2(WO_NO) → STK_OUT_PART_SER2(STK_OUT_NO) → OUT_FLAG='1' 카운트
        //        분모: PART_USE_QUERY6(전체 자재 건수)
        ParamsMap soSer2Params = new ParamsMap();
        soSer2Params.put("gsPltCode", gsPltCode);
        soSer2Params.put("woNo", woNo);
        List soSer2List = searchByMapper(NS_STK_OUT, "TSHP_STK_OUT_SER2", soSer2Params);

        int q6Issued = 0;
        if (soSer2List != null) {
            for (Object soObj : soSer2List) {
                Map soMap = (Map) soObj;
                String curStkOutNo = String.valueOf(soMap.get("stkOutNo"));

                ParamsMap sopSer2Params = new ParamsMap();
                sopSer2Params.put("gsPltCode", gsPltCode);
                sopSer2Params.put("stkOutNo", curStkOutNo);
                List sopSer2List = searchByMapper(NS_STK_OUT_PART, "TSHP_STK_OUT_PART_SER2", sopSer2Params);

                if (sopSer2List != null) {
                    for (Object obj : sopSer2List) {
                        Map m = (Map) obj;
                        if ("1".equals(m.get("outFlag"))) q6Issued++;
                    }
                }
            }
        }

        ParamsMap q6AllParams = new ParamsMap();
        q6AllParams.put("gsPltCode", gsPltCode);
        q6AllParams.put("sapWoNo", sapWoNo);
        q6AllParams.put("orderNo", orderNo);
        q6AllParams.put("orderLine", orderLine);
        q6AllParams.put("partCode", banPartCode);
        List q6AllList = searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY6", q6AllParams);

        int q6Total = (q6AllList != null) ? q6AllList.size() : 0;

        BigDecimal matOutRateMes = BigDecimal.ZERO;
        if (q6Total > 0) {
            matOutRateMes = new BigDecimal(q6Issued)
                    .multiply(new BigDecimal(100))
                    .divide(new BigDecimal(q6Total), 2, RoundingMode.HALF_UP);
        }

        String isOutMes = matOutRateMes.compareTo(new BigDecimal(100)) >= 0 ? "1" : "0";

        // --- (C) MAT_OUT_STK_RATE 계산 (필터 적용) ---
        // AS-IS: STK_OUT_SER2(WO_NO) → STK_OUT_PART_QUERY1(STK_OUT_NO) → OUT_FLAG='1' 카운트
        //        분모: PART_USE_QUERY8(MRP_EMP 없이)
        ParamsMap q8AllParams = new ParamsMap();
        q8AllParams.put("gsPltCode", gsPltCode);
        q8AllParams.put("sapWoNo", sapWoNo);
        q8AllParams.put("orderNo", orderNo);
        q8AllParams.put("orderLine", orderLine);
        q8AllParams.put("partCode", banPartCode);
        List q8AllList = searchByMapper(NS_PART_USE_QUERY, "TSHP_PART_USE_QUERY8", q8AllParams);

        // AS-IS: STK_OUT_SER2(WO_NO)로 해당 WO의 모든 STK_OUT 조회
        int stkIssuedCount = 0;
        if (soSer2List != null) {
            for (Object soObj : soSer2List) {
                Map soMap = (Map) soObj;
                String curStkOutNo = String.valueOf(soMap.get("stkOutNo"));

                ParamsMap sopqParams2 = new ParamsMap();
                sopqParams2.put("gsPltCode", gsPltCode);
                sopqParams2.put("stkOutNo", curStkOutNo);
                List sopqList2 = searchByMapper(NS_STK_OUT_PART_QUERY, "TSHP_STK_OUT_PART_QUERY1", sopqParams2);

                if (sopqList2 != null) {
                    for (Object obj : sopqList2) {
                        Map m = (Map) obj;
                        if ("1".equals(m.get("outFlag"))) stkIssuedCount++;
                    }
                }
            }
        }

        int q8AllTotal = (q8AllList != null) ? q8AllList.size() : 0;
        BigDecimal matOutStkRate = BigDecimal.ZERO;
        if (q8AllTotal > 0) {
            matOutStkRate = new BigDecimal(stkIssuedCount)
                    .multiply(new BigDecimal(100))
                    .divide(new BigDecimal(q8AllTotal), 2, RoundingMode.HALF_UP);
        }

        // --- (D) TSHP_WORKORDER UPD17 ---
        ParamsMap updParams = new ParamsMap();
        updParams.put("gsPltCode", gsPltCode);
        updParams.put("woNo", woNo);
        updParams.put("matOutRateMes", matOutRateMes);
        updParams.put("isOutMes", isOutMes);
        updParams.put("matOutStkRate", matOutStkRate);
        updParams.put("gsUserId", gsUserId);
        updateByMapper(NS_WORKORDER, "TSHP_WORKORDER_UPD17", updParams);

        logger.debug("WO UPD17: woNo={}, matOutRateMes={}, isOutMes={}, matOutStkRate={}",
                new Object[]{woNo, matOutRateMes, isOutMes, matOutStkRate});
    }

}
