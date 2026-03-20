/*
 * ============================================================================
 * 화면명: ORD15A - 실적/비가동 현황
 * ============================================================================
 * 설명: 실적/비가동 UNION ALL 조회 + 퇴근 로그 조회
 *       조회 전용 서비스 (CRUD 없음)
 * 작성자: 송우석
 * 작성일: 2026-03-16
 * ============================================================================
 */
package com.wsc.imes.ord;

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

/**
 * 실적/비가동 현황 서비스
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class Ord15aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Ord15aService.class);

    private static final String NS_TSHP_ACTUAL_QUERY = "com.wsc.imes.ord.TSHP_ACTUAL_QUERY";
    private static final String NS_TSYS_OFF_LOG_QUERY = "com.wsc.imes.ord.TSYS_OFF_LOG_QUERY";

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
    // TSHP_ACTUAL_QUERY15_4: 실적/비가동 목록 조회
    // ========================================================================

    /**
     * 실적/비가동 UNION ALL 조회
     *
     * @param params sWorkDate, eWorkDate, sWoDate, eWoDate,
     *               orderLike, hogiLike, cvndLike, mcNoLike
     * @return 목록 조회 결과
     */
    public Object ord15aSer(ParamsMap params) {
        logger.debug("TSHP_ACTUAL_QUERY15_4: sWorkDate={}, eWorkDate={}",
                params.get("sWorkDate"), params.get("eWorkDate"));

        return searchByMapper(NS_TSHP_ACTUAL_QUERY, "TSHP_ACTUAL_QUERY15_4", params);
    }

    // ========================================================================
    // TSYS_OFF_LOG_QUERY1: 퇴근 로그 조회
    // ========================================================================

    /**
     * 퇴근 로그 조회
     *
     * @param params sDate, eDate
     * @return 퇴근 로그 목록
     */
    public Object ord15aSerOff(ParamsMap params) {
        logger.debug("TSYS_OFF_LOG_QUERY1: sDate={}, eDate={}",
                params.get("sDate"), params.get("eDate"));

        return searchByMapper(NS_TSYS_OFF_LOG_QUERY, "TSYS_OFF_LOG_QUERY1", params);
    }
}
