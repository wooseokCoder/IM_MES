/*
 * ============================================================================
 * 화면명: REP10A - 작업자현황
 * ============================================================================
 * 설명: 작업자 현재 상태 조회 (조회 전용, 검색조건 없음)
 *       진행/중지/퇴근 상태를 실시간 표시
 * 작성자: 송우석
 * 작성일: 2026-03-16
 * ============================================================================
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - REP10A_SER → rep10aSer (메인 그리드 조회)
 */
package com.wsc.imes.rep;

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
 * 작업자현황 서비스
 *
 * @author 송우석
 * @since 2026-03-16
 */
@Service
public class Rep10aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Rep10aService.class);

    /** TSHP_ACTUAL_QUERY 조회 (QUERY17) */
    private static final String NS = "com.wsc.imes.pop.TSHP_ACTUAL_QUERY";

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
        return sessionProvider.get();
    }

    // ========================================================================
    // REP10A_SER: 메인 그리드 조회
    // TSHP_ACTUAL_QUERY17 호출 (검색조건 없음, PLT_CODE + ORG_CODE만 전달)
    // ========================================================================

    /**
     * 작업자현황 메인 그리드 조회
     *
     * @param params gsPltCode(공장코드)
     * @return 작업자현황 목록
     */
    public Object rep10aSer(ParamsMap params) {
        logger.debug("REP10A_SER: gsPltCode={}", params.get("gsPltCode"));

        // ORG_CODE 고정값 (AS-IS 하드코딩: A005ORG50010900)
        params.put("orgCode", "A005ORG50010900");

        return searchByMapper(NS, "TSHP_ACTUAL_QUERY17", params);
    }
}
