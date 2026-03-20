/*
 * ============================================================================
 * 화면명: QCT08A - 자주검사 현황
 * ============================================================================
 * 설명: 자주검사 결과 조회 전용
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 화면 분리
 *       서버사이드 페이징 지원
 *       QMS 전송 기능 포함
 * 작성일: 2026-03-17
 * ============================================================================
 */
package com.wsc.imes.qct;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;

/**
 * 자주검사 현황 서비스
 *
 * @author 송우석
 * @version 1.1
 */
@Service
public class Qct08aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Qct08aService.class);

    private static final String NS_QUERY = "com.wsc.imes.qct.TSHP_INS_RESULT_MASTER_QUERY";
    private static final String NS_RESULT = "com.wsc.imes.qct.TSHP_INS_RESULT";
    private static final String NS_RESULT_QUERY = "com.wsc.imes.qct.TSHP_INS_RESULT_QUERY";
    private static final String NS_MASTER = "com.wsc.imes.qct.TSHP_INS_RESULT_MASTER";
    private static final String NS_QMS = "com.wsc.imes.qct.IF_QMS_DAILY_INS";
    private static final String NS_PROC_INS_QUERY = "com.wsc.imes.qct.TSTD_PROC_INS_QUERY";

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
    // 조회 (서버사이드 페이징)
    // ========================================================================

    /**
     * 조립 검사결과 페이징 조회
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> qct08aSer(ParamsMap params) {
        logger.debug("QCT08A_SER: plants={}, page={}", params.get("plants"), params.get("page"));
        return searchWithPaging(params);
    }

    /**
     * 가공 검사결과 페이징 조회
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> qct08aSer2(ParamsMap params) {
        logger.debug("QCT08A_SER2: plants={}, page={}", params.get("plants"), params.get("page"));
        return searchWithPaging(params);
    }

    /**
     * 페이징 공통 처리
     * 1. 카운트 SP 호출 → total
     * 2. page/rows로 offset/limit 계산
     * 3. 데이터 SP 호출 (LIMIT/OFFSET)
     * 4. {total, rows} 형태로 반환
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> searchWithPaging(ParamsMap params) {
        int page = 1;
        int rows = 100;
        if (params.get("page") != null) {
            try { page = Integer.parseInt(params.get("page").toString()); } catch (NumberFormatException e) { /* 기본값 */ }
        }
        if (params.get("rows") != null) {
            try { rows = Integer.parseInt(params.get("rows").toString()); } catch (NumberFormatException e) { /* 기본값 */ }
        }
        if (page < 1) page = 1;
        if (rows < 1) rows = 100;

        /* 1. 카운트 조회 */
        Object countObj = selectByMapper(NS_QUERY, "TSHP_INS_RESULT_MASTER_QUERY1_COUNT", params);
        int total = 0;
        if (countObj != null) {
            Map<String, Object> countMap = (Map<String, Object>) countObj;
            if (countMap.get("total") != null) {
                total = Integer.parseInt(countMap.get("total").toString());
            }
        }

        /* 2. offset/limit 계산 */
        int offset = (page - 1) * rows;
        params.put("offset", offset);
        params.put("limit", rows);

        /* 3. 데이터 조회 */
        List dataList = searchByMapper(NS_QUERY, "TSHP_INS_RESULT_MASTER_QUERY1", params);

        /* 4. EasyUI datagrid 형식으로 반환 */
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("total", total);
        result.put("rows", dataList);
        return result;
    }

    // ========================================================================
    // 공정 조회
    // ========================================================================

    /**
     * 공정코드 목록 조회 (acProcForm용)
     */
    public Object qct08aProc(ParamsMap params) {
        logger.debug("QCT08A_PROC: lprocCode={}", params.get("lprocCode"));
        return searchByMapper(NS_PROC_INS_QUERY, "LSE_STD_PROC_SER2", params);
    }

    // ========================================================================
    // 이미지
    // ========================================================================

    /**
     * 검사 이미지 base64 단건 조회
     */
    @SuppressWarnings("unchecked")
    public String qct08aImgBase64(ParamsMap params) {
        Object obj = selectByMapper(NS_RESULT, "TSHP_INS_RESULT_SER2", params);
        if (obj != null) {
            java.util.Map<String, Object> result = (java.util.Map<String, Object>) obj;
            if (result.get("imgBase64") != null) {
                return result.get("imgBase64").toString();
            }
        }
        return null;
    }

    // ========================================================================
    // QMS 전송
    // ========================================================================

    /**
     * QMS 전송 - 조립 (QCT08A_UPD)
     */
    public Object qct08aUpd(ParamsMap params) {
        logger.debug("QCT08A_UPD: insmNo={}", params.get("insmNo"));
        return updateByMapper(NS_MASTER, "TSHP_INS_RESULT_MASTER_QMS_SEND", params);
    }

    /**
     * QMS 전송 - 가공 (QCT08A_UPD2)
     */
    public Object qct08aUpd2(ParamsMap params) {
        logger.debug("QCT08A_UPD2: insmNo={}", params.get("insmNo"));
        return updateByMapper(NS_MASTER, "TSHP_INS_RESULT_MASTER_QMS_SEND", params);
    }

}
