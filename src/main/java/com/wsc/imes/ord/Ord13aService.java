/*
 * ============================================================================
 * 화면명: ORD13A - 생산오더 일정 관리
 * ============================================================================
 * 설명: 주간 단위 생산 작업지시 조회 (요약 + 상세), 비고/공정명 다건 수정
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - ORD13A_SER  → ord13aSer  (QUERY6 + QUERY5 동시 호출)
 * - ORD13A_UPD  → ord13aUpd  (UPD32 다건)
 * - ORD13A_UPD2 → ord13aUpd2 (UPD35 다건)
 *
 * 원본: ProActive ORD13A.cs, TSHP_WORKORDER.cs, TSHP_WORKORDER_QUERY.cs
 * 작성일: 2026-02-23
 * ============================================================================
 */
package com.wsc.imes.ord;

import java.util.HashMap;
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
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

/**
 * 생산오더 일정 관리 서비스
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Ord13aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Ord13aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS = "com.wsc.imes.ord.TSHP_WORKORDER";
    private static final String NS_QUERY = "com.wsc.imes.ord.TSHP_WORKORDER_QUERY";

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
    // ORD13A_SER: 생산오더 일정 조회
    // TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY6 (요약) +
    // TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY5 (상세) 동시 호출
    // ========================================================================

    /**
     * 생산오더 일정 조회 (요약 + 상세)
     *
     * @param params modelLike, procLike, partLike, sPlnDate, ePlnDate
     * @return Map("summary" → QUERY6 결과, "detail" → QUERY5 결과)
     */
    public Map<String, Object> ord13aSer(ParamsMap params) {

        // PLANTS 고정값 (AS-IS M0A에서 하드코딩)
        params.put("plants", "3605");

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("summary", searchByMapper(NS_QUERY, "TSHP_WORKORDER_QUERY6", params));
        result.put("detail", searchByMapper(NS_QUERY, "TSHP_WORKORDER_QUERY5", params));
        return result;
    }

    // ========================================================================
    // ORD13A_UPD: 비고(SCOMMENT) 저장 - 다건
    // TSHP_WORKORDER.TSHP_WORKORDER_UPD32 반복 호출
    // ========================================================================

    /**
     * 비고 저장 (다건)
     *
     * @param params modelList [{sapWoNo, scomment}, ...]
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord13aUpd(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("저장할 데이터가 없습니다.");
            }

            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");
            int count = 0;

            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                ParamsMap rowParams = new ParamsMap();
                rowParams.putAll(row);
                rowParams.put("gsPltCode", gsPltCode);
                rowParams.put("gsUserId", gsUserId);

                updateByMapper(NS, "TSHP_WORKORDER_UPD32", rowParams);
                logger.debug("TSHP_WORKORDER_UPD32: sapWoNo={}", row.get("sapWoNo"));
                count++;
            }

            logger.info("ORD13A_UPD 완료: {}건", count);
            return success("저장되었습니다.");

        } catch (Exception e) {
            logger.error("ORD13A_UPD 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // ORD13A_UPD2: 공정명(PROC_CODE) 저장 - 다건
    // TSHP_WORKORDER.TSHP_WORKORDER_UPD35 반복 호출
    // ========================================================================

    /**
     * 공정명 저장 (다건)
     *
     * @param params modelList [{sapWoNo, woSeq, procCode}, ...]
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord13aUpd2(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("저장할 데이터가 없습니다.");
            }

            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");
            int count = 0;

            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                ParamsMap rowParams = new ParamsMap();
                rowParams.putAll(row);
                rowParams.put("gsPltCode", gsPltCode);
                rowParams.put("gsUserId", gsUserId);

                updateByMapper(NS, "TSHP_WORKORDER_UPD35", rowParams);
                logger.debug("TSHP_WORKORDER_UPD35: sapWoNo={}, woSeq={}",
                        row.get("sapWoNo"), row.get("woSeq"));
                count++;
            }

            logger.info("ORD13A_UPD2 완료: {}건", count);
            return success("저장되었습니다.");

        } catch (Exception e) {
            logger.error("ORD13A_UPD2 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

}
