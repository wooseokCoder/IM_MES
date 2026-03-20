/*
 * ============================================================================
 * 화면명: ORD06A - 생산오더 확정 관리
 * ============================================================================
 * 설명: 작업지시 조회, 계획시간/설비 저장, 확정/확정취소, 확정이력 조회
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - ORD06A_MC   → ord06aMc   (설비 목록)
 * - ORD06A_SER  → ord06aSer  (작업지시 조회)
 * - ORD06A_UPD2 → ord06aUpd2 (계획저장)
 * - ORD06A_UPD  → ord06aUpd  (확정/확정취소)
 * - ORD06A_SER2 → ord06aSer2 (확정이력 조회)
 *
 * 원본: ProActive ORD06A.cs, ORD06A_M0A.cs
 * 작성일: 2026-02-24
 * ============================================================================
 */
package com.wsc.imes.ord;

import java.text.SimpleDateFormat;
import java.util.Date;
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
 * 생산오더 확정 관리 서비스
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Ord06aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Ord06aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS = "com.wsc.imes.ord.TSHP_WORKORDER";
    private static final String NS_QUERY = "com.wsc.imes.ord.TSHP_WORKORDER_QUERY";
    private static final String NS_HIS = "com.wsc.imes.ord.TSHP_WORKORDER_HIS";
    private static final String NS_PLN_HIS = "com.wsc.imes.ord.TSHP_WORKORDER_PLN_HIS";
    private static final String NS_PRODUCT = "com.wsc.imes.ord.TORD_PRODUCT";
    private static final String NS_MC_QUERY = "com.wsc.imes.std.LSE_MACHINE_QUERY";

    @Autowired
    private CommonDao dao;

    // AS-IS: UTIL.UTILITY_GET_SERIALNO 공통 채번 서비스
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
    // ORD06A_MC: 설비 목록 조회
    // LSE_MACHINE_QUERY.LSE_MACHINE_QUERY1 호출
    // MC_GROUP='3605', DATA_FLAG='0' 고정
    // ========================================================================

    /**
     * 설비 목록 조회 (MC_CODE 콤보용)
     *
     * @param params gsPltCode
     * @return 설비 목록 (mcCode, mcName, mcDisp)
     */
    public Object ord06aMc(ParamsMap params) {
        params.put("mcGroup", "3605");
        params.put("dataFlag", "0");
        return searchByMapper(NS_MC_QUERY, "LSE_MACHINE_QUERY1", params);
    }

    // ========================================================================
    // ORD06A_SER: 작업지시 조회
    // TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY5 호출
    // PLANTS='3605' 고정
    // ========================================================================

    /**
     * 작업지시 조회
     *
     * @param params modelLike, procLike, partLike, sapWoLike,
     *               sPlnDate, ePlnDate, sRegDate, eRegDate, isZero
     * @return 작업지시 목록
     */
    public Object ord06aSer(ParamsMap params) {
        params.put("plants", "3605");
        return searchByMapper(NS_QUERY, "TSHP_WORKORDER_QUERY5", params);
    }

    // ========================================================================
    // ORD06A_SER2: 확정이력 조회
    // TSHP_WORKORDER_HIS.TSHP_WORKORDER_HIS_SER 호출
    // ========================================================================

    /**
     * 확정이력 조회 (팝업)
     *
     * @param params gsPltCode, woNo
     * @return 확정이력 목록
     */
    public Object ord06aSer2(ParamsMap params) {
        return searchByMapper(NS_HIS, "TSHP_WORKORDER_HIS_SER", params);
    }

    // ========================================================================
    // ORD06A_UPD2: 계획시간/설비 저장
    // 각 행에 대해:
    //   1. TSHP_WORKORDER_SER → 현재 상태 조회
    //   2. WO_FLAG != '0'이면: PLN 시간 변경 시 PLN_HIS_INS
    //   3. TSHP_WORKORDER_UPD28_1 (PLN 시간 + MC_CODE 업데이트)
    //   4. TSHP_WORKORDER_UPD28_2 (MCT_VEN_NAME 업데이트)
    // ========================================================================

    /**
     * 계획시간/설비 저장 (다건)
     *
     * @param params modelList [{woNo, plnStartTime, plnEndTime, mcCode,
     *                           sapWoNo, mctVenName}, ...]
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord06aUpd2(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("저장할 데이터가 없습니다.");
            }

            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");

            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                String woNo = (String) row.get("woNo");
                String plnStartTime = (String) row.get("plnStartTime");
                String plnEndTime = (String) row.get("plnEndTime");
                String mcCode = (String) row.get("mcCode");
                String sapWoNo = (String) row.get("sapWoNo");
                String mctVenName = (String) row.get("mctVenName");

                // 1. 현재 상태 조회
                ParamsMap serParams = new ParamsMap();
                serParams.put("gsPltCode", gsPltCode);
                serParams.put("woNo", woNo);
                List woList = searchByMapper(NS, "TSHP_WORKORDER_SER", serParams);

                if (woList != null && !woList.isEmpty()) {
                    Map woData = (Map) woList.get(0);
                    String woFlag = (String) woData.get("woFlag");

                    // 2. WO_FLAG != '0'이면 계획시간 변경 이력 기록
                    if (woFlag != null && !"0".equals(woFlag)) {
                        String dbPlnStart = (String) woData.get("plnStartTime");
                        String dbPlnEnd = (String) woData.get("plnEndTime");

                        boolean startChanged = !equalsNullSafe(dbPlnStart, plnStartTime);
                        boolean endChanged = !equalsNullSafe(dbPlnEnd, plnEndTime);

                        if (startChanged || endChanged) {
                            // AS-IS: UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "WPH", YYYYMMDD)
                            String today = new SimpleDateFormat("yyyyMMdd").format(new Date());
                            String wphId = utilityService.getSerialNo(gsPltCode, "WPH", today, null);

                            ParamsMap plnHisParams = new ParamsMap();
                            plnHisParams.put("gsPltCode", gsPltCode);
                            plnHisParams.put("wphId", wphId);
                            plnHisParams.put("woNo", woNo);
                            plnHisParams.put("bfPlnStartTime", dbPlnStart);
                            plnHisParams.put("bfPlnEndTime", dbPlnEnd);
                            plnHisParams.put("plnStartTime", plnStartTime);
                            plnHisParams.put("plnEndTime", plnEndTime);
                            plnHisParams.put("gsUserId", gsUserId);

                            insertByMapper(NS_PLN_HIS, "TSHP_WORKORDER_PLN_HIS_INS", plnHisParams);
                            logger.debug("PLN_HIS_INS: wphId={}, woNo={}", wphId, woNo);
                        }
                    }
                }

                // 3. 계획시간 + 설비 업데이트 (UPD28_1)
                ParamsMap upd281Params = new ParamsMap();
                upd281Params.put("gsPltCode", gsPltCode);
                upd281Params.put("woNo", woNo);
                upd281Params.put("plnStartTime", plnStartTime);
                upd281Params.put("plnEndTime", plnEndTime);
                upd281Params.put("bfPlnStartTime", plnStartTime);
                upd281Params.put("bfPlnEndTime", plnEndTime);
                upd281Params.put("mcCode", mcCode);
                upd281Params.put("gsUserId", gsUserId);

                updateByMapper(NS, "TSHP_WORKORDER_UPD28_1", upd281Params);

                // 4. 고객명 업데이트 (UPD28_2, SAP_WO_NO 단위)
                if (mctVenName != null) {
                    ParamsMap upd282Params = new ParamsMap();
                    upd282Params.put("gsPltCode", gsPltCode);
                    upd282Params.put("sapWoNo", sapWoNo);
                    upd282Params.put("mctVenName", mctVenName);
                    upd282Params.put("gsUserId", gsUserId);

                    updateByMapper(NS, "TSHP_WORKORDER_UPD28_2", upd282Params);
                }

                logger.debug("ORD06A_UPD2: woNo={}", woNo);
            }

            logger.info("ORD06A_UPD2 완료: {}건", rows.size());
            return success("저장되었습니다.");

        } catch (Exception e) {
            logger.error("ORD06A_UPD2 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // ORD06A_UPD: 확정/확정취소
    // AS-IS 흐름:
    //   각 선택 행에 대해:
    //     1. TSHP_WORKORDER_SER → 상태 검증
    //     2. WO_FLAG 0,1만 허용 (2,3,4 수정 불가)
    //     [확정취소 (woFlag=0)]
    //       3a. UPD4_1 (BF_PLN 초기화)
    //       3b. PLN_HIS_DEL (계획이력 삭제)
    //       3c. UPD4 (WO_FLAG=0, CONFIRM_DATE=null)
    //       3d. SER4 → 다른 확정 WO 없으면 PRODUCT_UPD3('WK')
    //     [확정 (woFlag=1)]
    //       3a. PLN 시간 변경 시 PLN_HIS_INS
    //       3b. UPD28_1 (PLN + MC_CODE 업데이트)
    //       3c. UPD4 (WO_FLAG=1, CONFIRM_DATE=현재시간)
    //       3d. PRODUCT_UPD3('PG')
    //     4. HIS_INS (확정이력 기록)
    // ========================================================================

    /**
     * 확정/확정취소 (다건)
     *
     * @param params woFlag ("1"=확정, "0"=확정취소),
     *               modelList [{woNo, procCode, prodCode, sapWoNo,
     *                           plnStartTime, plnEndTime, mcCode}, ...]
     * @return 처리 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord06aUpd(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("처리할 데이터가 없습니다.");
            }

            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");
            String targetWoFlag = params.getString("woFlag"); // "1"=확정, "0"=확정취소

            // 확정 시 사용할 CONFIRM_DATE (현재 시간)
            String confirmDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                String woNo = (String) row.get("woNo");
                String procCode = (String) row.get("procCode");
                String prodCode = (String) row.get("prodCode");
                String sapWoNo = (String) row.get("sapWoNo");

                // ============================================================
                // STEP 1: 현재 상태 조회 및 검증
                // ============================================================
                ParamsMap serParams = new ParamsMap();
                serParams.put("gsPltCode", gsPltCode);
                serParams.put("woNo", woNo);
                List woList = searchByMapper(NS, "TSHP_WORKORDER_SER", serParams);

                if (woList == null || woList.isEmpty()) {
                    return failure("이미 처리되었거나 유효하지 않는 데이터입니다.");
                }

                Map woData = (Map) woList.get(0);
                String currentWoFlag = (String) woData.get("woFlag");

                // 상태 검증: 진행중(2), 일시정지(3), 완료(4)는 수정 불가
                if (!"0".equals(currentWoFlag) && !"1".equals(currentWoFlag)) {
                    return failure("작업지시 상태가 진행, 완료일 경우는 수정하거나 삭제할 수 없습니다.");
                }

                // ============================================================
                // STEP 2: 확정취소 (targetWoFlag = "0")
                // ============================================================
                if ("0".equals(targetWoFlag)) {

                    // 2a. BF_PLN 시간 초기화
                    ParamsMap upd41Params = new ParamsMap();
                    upd41Params.put("gsPltCode", gsPltCode);
                    upd41Params.put("woNo", woNo);
                    upd41Params.put("bfPlnStartTime", null);
                    upd41Params.put("bfPlnEndTime", null);
                    updateByMapper(NS, "TSHP_WORKORDER_UPD4_1", upd41Params);

                    // 2b. 계획이력 삭제
                    ParamsMap plnDelParams = new ParamsMap();
                    plnDelParams.put("gsPltCode", gsPltCode);
                    plnDelParams.put("woNo", woNo);
                    deleteByMapper(NS_PLN_HIS, "TSHP_WORKORDER_PLN_HIS_DEL", plnDelParams);

                    // 2c. WO_FLAG=0, CONFIRM_DATE=null
                    ParamsMap upd4Params = new ParamsMap();
                    upd4Params.put("gsPltCode", gsPltCode);
                    upd4Params.put("woNo", woNo);
                    upd4Params.put("woFlag", "0");
                    upd4Params.put("confirmDate", null);
                    upd4Params.put("gsUserId", gsUserId);
                    updateByMapper(NS, "TSHP_WORKORDER_UPD4", upd4Params);

                    // 2d. 다른 확정 WO가 없으면 PROD_STATE='WK'
                    if (prodCode != null && !prodCode.isEmpty()) {
                        ParamsMap ser4Params = new ParamsMap();
                        ser4Params.put("gsPltCode", gsPltCode);
                        ser4Params.put("prodCode", prodCode);
                        ser4Params.put("woNo", woNo);
                        List ser4Result = searchByMapper(NS, "TSHP_WORKORDER_SER4", ser4Params);

                        if (ser4Result != null && !ser4Result.isEmpty()) {
                            Map countMap = (Map) ser4Result.get(0);
                            Object cntObj = countMap.get("cnt");
                            int cnt = (cntObj instanceof Number) ? ((Number) cntObj).intValue() : 0;

                            if (cnt == 0) {
                                ParamsMap prodParams = new ParamsMap();
                                prodParams.put("gsPltCode", gsPltCode);
                                prodParams.put("prodCode", prodCode);
                                prodParams.put("prodState", "WK");
                                prodParams.put("gsUserId", gsUserId);
                                updateByMapper(NS_PRODUCT, "TORD_PRODUCT_UPD3", prodParams);
                                logger.debug("PRODUCT_UPD3: prodCode={}, prodState=WK", prodCode);
                            }
                        }
                    }
                }
                // ============================================================
                // STEP 3: 확정 (targetWoFlag = "1")
                // ============================================================
                else if ("1".equals(targetWoFlag)) {
                    String plnStartTime = (String) row.get("plnStartTime");
                    String plnEndTime = (String) row.get("plnEndTime");
                    String mcCode = (String) row.get("mcCode");

                    // 3a. 기존 WO_FLAG != '0'이고 PLN 시간 변경 시 이력 기록
                    if (!"0".equals(currentWoFlag)) {
                        String dbPlnStart = (String) woData.get("plnStartTime");
                        String dbPlnEnd = (String) woData.get("plnEndTime");

                        boolean startChanged = !equalsNullSafe(dbPlnStart, plnStartTime);
                        boolean endChanged = !equalsNullSafe(dbPlnEnd, plnEndTime);

                        if (startChanged || endChanged) {
                            // AS-IS: UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "WPH", YYYYMMDD)
                            String today = new SimpleDateFormat("yyyyMMdd").format(new Date());
                            String wphId = utilityService.getSerialNo(gsPltCode, "WPH", today, null);

                            ParamsMap plnHisParams = new ParamsMap();
                            plnHisParams.put("gsPltCode", gsPltCode);
                            plnHisParams.put("wphId", wphId);
                            plnHisParams.put("woNo", woNo);
                            plnHisParams.put("bfPlnStartTime", dbPlnStart);
                            plnHisParams.put("bfPlnEndTime", dbPlnEnd);
                            plnHisParams.put("plnStartTime", plnStartTime);
                            plnHisParams.put("plnEndTime", plnEndTime);
                            plnHisParams.put("gsUserId", gsUserId);

                            insertByMapper(NS_PLN_HIS, "TSHP_WORKORDER_PLN_HIS_INS", plnHisParams);
                            logger.debug("PLN_HIS_INS: wphId={}, woNo={}", wphId, woNo);
                        }
                    }

                    // 3b. 계획시간 + 설비 업데이트 (UPD28_1)
                    ParamsMap upd281Params = new ParamsMap();
                    upd281Params.put("gsPltCode", gsPltCode);
                    upd281Params.put("woNo", woNo);
                    upd281Params.put("plnStartTime", plnStartTime);
                    upd281Params.put("plnEndTime", plnEndTime);
                    upd281Params.put("bfPlnStartTime", plnStartTime);
                    upd281Params.put("bfPlnEndTime", plnEndTime);
                    upd281Params.put("mcCode", mcCode);
                    upd281Params.put("gsUserId", gsUserId);
                    updateByMapper(NS, "TSHP_WORKORDER_UPD28_1", upd281Params);

                    // 3c. WO_FLAG=1, CONFIRM_DATE=현재시간
                    ParamsMap upd4Params = new ParamsMap();
                    upd4Params.put("gsPltCode", gsPltCode);
                    upd4Params.put("woNo", woNo);
                    upd4Params.put("woFlag", "1");
                    upd4Params.put("confirmDate", confirmDate);
                    upd4Params.put("gsUserId", gsUserId);
                    updateByMapper(NS, "TSHP_WORKORDER_UPD4", upd4Params);

                    // 3d. PROD_STATE='PG' (진행)
                    if (prodCode != null && !prodCode.isEmpty()) {
                        ParamsMap prodParams = new ParamsMap();
                        prodParams.put("gsPltCode", gsPltCode);
                        prodParams.put("prodCode", prodCode);
                        prodParams.put("prodState", "PG");
                        prodParams.put("gsUserId", gsUserId);
                        updateByMapper(NS_PRODUCT, "TORD_PRODUCT_UPD3", prodParams);
                        logger.debug("PRODUCT_UPD3: prodCode={}, prodState=PG", prodCode);
                    }
                }

                // ============================================================
                // STEP 4: 확정이력 기록 (모든 경우)
                // ============================================================
                ParamsMap hisParams = new ParamsMap();
                hisParams.put("gsPltCode", gsPltCode);
                hisParams.put("woNo", woNo);
                hisParams.put("procCode", procCode);
                hisParams.put("prodHogi", sapWoNo);
                hisParams.put("woFlag", targetWoFlag);
                hisParams.put("gsUserId", gsUserId);
                insertByMapper(NS_HIS, "TSHP_WORKORDER_HIS_INS", hisParams);

                logger.debug("ORD06A_UPD: woNo={}, woFlag={}", woNo, targetWoFlag);
            }

            String msg = "1".equals(targetWoFlag) ? "확정되었습니다." : "확정 취소되었습니다.";
            logger.info("ORD06A_UPD 완료: {}건 (woFlag={})", rows.size(), targetWoFlag);
            return success(msg);

        } catch (Exception e) {
            logger.error("ORD06A_UPD 실패", e);
            return failure(e.getMessage());
        }
    }

    // ========================================================================
    // 유틸리티
    // ========================================================================

    /**
     * Null-safe 문자열 비교
     */
    private boolean equalsNullSafe(String a, String b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.equals(b);
    }

}
