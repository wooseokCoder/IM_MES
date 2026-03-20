/*
 * ============================================================================
 * 화면명: ORD18A - 실적삭제/삭제현황/오더완료일수정
 * ============================================================================
 * 설명: 3-Tab 구조
 *   Tab1 (ACT): 실적삭제 조회 (QUERY15) + 삭제 (래퍼 SP)
 *   Tab2 (ACTD): 삭제현황 조회 (QUERY15_3) + 삭제취소 (래퍼 SP)
 *   Tab3 (WO): 오더완료일 조회 (QUERY32) + D0A 수정 (UPD36)
 *
 * DEL/DEL_CANCEL: 래퍼 SP로 통합 (sp_imes_tshp_actual_idletime_del/_del_restore)
 *   ACT 접두어 → INSERT...SELECT * 방식으로 ACTUAL↔ACTUAL_DEL 이동 (44컬럼 전체)
 *   IL 접두어 → 기존 SP 호출 (ude/ude_restore)
 *
 * 원본: ProActive ORD18A.cs
 * @author Claude
 * @since 2026-03-06
 * ============================================================================
 */
package com.wsc.imes.ord;

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
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

/**
 * 실적삭제/삭제현황/오더완료일수정 서비스
 */
@Service
public class Ord18aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Ord18aService.class);

    // ========================================================================
    // Namespace 상수
    // ========================================================================

    /** TSHP_WORKORDER CUD */
    private static final String NS = "com.wsc.imes.ord.TSHP_WORKORDER";

    /** TSHP_WORKORDER_QUERY 조회 */
    private static final String NS_WO_QUERY = "com.wsc.imes.ord.TSHP_WORKORDER_QUERY";

    /** TSHP_ACTUAL_QUERY 조회 (ord 모듈) */
    private static final String NS_ACT_QUERY = "com.wsc.imes.ord.TSHP_ACTUAL_QUERY";

    /** TSHP_ACTUAL CUD (pop 모듈 공유) */
    private static final String NS_ACT = "com.wsc.imes.pop.TSHP_ACTUAL";

    // NS_ACT_DEL, NS_IDLE: 래퍼 SP(sp_imes_tshp_actual_idletime_del/_del_restore)로
    // 통합되어 더 이상 개별 mapper 호출 불필요

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
    // ORD18A_SER: Tab1 실적삭제 조회
    // TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY15 호출
    // AS-IS: _strPlants="3603" 하드코딩, dateType 분기
    // ========================================================================

    public Object ord18aSer(ParamsMap params) {
        logger.debug("ORD18A_SER: sWorkDate={}, eWorkDate={}, sWoDate={}, eWoDate={}",
                new Object[]{params.get("sWorkDate"), params.get("eWorkDate"),
                             params.get("sWoDate"), params.get("eWoDate")});
        return searchByMapper(NS_ACT_QUERY, "TSHP_ACTUAL_QUERY15", params);
    }

    // ========================================================================
    // ORD18A_SER2: Tab2 삭제현황 조회
    // TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY15_3 호출
    // ========================================================================

    public Object ord18aSer2(ParamsMap params) {
        logger.debug("ORD18A_SER2: sWorkDate={}, eWorkDate={}", params.get("sWorkDate"), params.get("eWorkDate"));
        return searchByMapper(NS_ACT_QUERY, "TSHP_ACTUAL_QUERY15_3", params);
    }

    // ========================================================================
    // ORD18A_SER3: Tab3 오더완료일 조회
    // TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY32 호출
    // AS-IS: WO_FLAG=4 하드코딩 (SP 내부)
    // ========================================================================

    public Object ord18aSer3(ParamsMap params) {
        logger.debug("ORD18A_SER3: plants={}, sWoDate={}, eWoDate={}",
                new Object[]{params.get("plants"), params.get("sWoDate"), params.get("eWoDate")});
        return searchByMapper(NS_WO_QUERY, "TSHP_WORKORDER_QUERY32", params);
    }

    // ========================================================================
    // ORD18A_UPD: D0A 오더완료일 수정
    // TSHP_WORKORDER.TSHP_WORKORDER_UPD36 호출 (foreach)
    // AS-IS: 단일 행 또는 다건 처리
    // ========================================================================

    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord18aUpd(ParamsMap params) {
        try {
            // modelList가 전달된 경우 (다건)
            Object modelListObj = params.get("modelList");
            if (modelListObj != null) {
                JSONArray rows;
                if (modelListObj instanceof JSONArray) {
                    rows = (JSONArray) modelListObj;
                } else {
                    JSONParser parser = new JSONParser();
                    rows = (JSONArray) parser.parse(modelListObj.toString());
                }

                for (int i = 0; i < rows.size(); i++) {
                    JSONObject row = (JSONObject) rows.get(i);
                    ParamsMap updParams = new ParamsMap();
                    updParams.put("gsPltCode", params.getString("gsPltCode"));
                    updParams.put("woNo", row.get("woNo") != null ? row.get("woNo").toString() : "");
                    updParams.put("actStartTime", row.get("actStartTime") != null ? row.get("actStartTime").toString() : "");
                    updParams.put("actEndTime", row.get("actEndTime") != null ? row.get("actEndTime").toString() : "");
                    updParams.put("gsUserId", params.getString("gsUserId"));
                    updateByMapper(NS, "TSHP_WORKORDER_UPD36", updParams);
                }
            } else {
                // 단건 (D0A 팝업에서 직접 전달)
                updateByMapper(NS, "TSHP_WORKORDER_UPD36", params);
            }

            logger.info("ORD18A_UPD 완료");
            return success("저장되었습니다.");
        } catch (Exception e) {
            logger.error("ORD18A_UPD 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // ORD18A_DEL: Tab1 삭제
    // AS-IS 흐름: KEY 접두어 분기
    //   ACT: SER2(조회)→DEL_INS(백업)→DEL(삭제)
    //   IL: SER2(조회)→UDE(DATA_FLAG=2, 논리삭제)
    // POP33A.pop33aDel과 동일한 패턴
    // ========================================================================

    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord18aDel(ParamsMap params) {
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
                updateByMapper(NS_ACT, "TSHP_ACTUAL_IDLETIME_DEL", rowParams);
            }

            logger.info("ORD18A_DEL 완료: {} 건 삭제", Integer.valueOf(rows.size()));
            return success("삭제되었습니다.");
        } catch (Exception e) {
            logger.error("ORD18A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // ORD18A_DEL_CANCEL: Tab2 삭제취소
    // AS-IS 흐름: KEY 접두어 분기
    //   ACT: DEL_SER(백업조회)→INS3(원본복원)→DEL_DEL(백업삭제)
    //   IL: SER2(조회)→UDE_RESTORE(DATA_FLAG=0, 복원)
    // POP33A.pop33aDelCancel과 동일한 패턴
    // ========================================================================

    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord18aDelCancel(ParamsMap params) {
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
                updateByMapper(NS_ACT, "TSHP_ACTUAL_IDLETIME_DEL_RESTORE", rowParams);
            }

            logger.info("ORD18A_DEL_CANCEL 완료: {} 건 복원", Integer.valueOf(rows.size()));
            return success("삭제가 취소되었습니다.");
        } catch (Exception e) {
            logger.error("ORD18A_DEL_CANCEL 실패", e);
            return failure("삭제 취소 실패: " + e.getMessage());
        }
    }

}
