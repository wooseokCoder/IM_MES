/*
 * ============================================================================
 * 화면명: ORD14A - 실적관리 가공
 * ============================================================================
 * 설명: 작업지시 조회 + 실적 상세 조회 서비스 (조회 전용)
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - ORD14A_SER  → ord14aSer  (작업지시 목록 조회)
 * - ORD14A_SER2 → ord14aSer2 (실적 상세 조회)
 *
 * BIZ 고정 파라미터:
 * - ORD14A_SER: dataFlag="0", plants="3605"
 *
 * 원본: ProActive ORD14A.cs, ORD14A_M0A.cs
 * 작성일: 2026-03-06
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
 * 실적관리 가공 서비스
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Ord14aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Ord14aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_WO_QUERY  = "com.wsc.imes.ord.TSHP_WORKORDER_QUERY";
    private static final String NS_ACT_QUERY = "com.wsc.imes.ord.TSHP_ACTUAL_QUERY";

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
    // 조회
    // ========================================================================

    /**
     * 작업지시 목록 조회 (ORD14A_SER)
     *
     * AS-IS BIZ 고정값:
     *   dataFlag = "0"  (활성 데이터만)
     *   plants   = "3605" (가공 공장)
     *
     * AS-IS 화면 전달 파라미터:
     *   pltCode  (세션), orderLike, procLike, sPlnDate, ePlnDate
     */
    public Object ord14aSer(ParamsMap params) {
        // BIZ 고정 파라미터
        params.put("dataFlag", "0");
        params.put("plants", "3605");

        return searchByMapper(NS_WO_QUERY, "TSHP_WORKORDER_QUERY12", params);
    }

    /**
     * 실적 상세 조회 (ORD14A_SER2)
     *
     * AS-IS 화면 전달 파라미터:
     *   pltCode (세션), woNo (상단 그리드 선택행)
     */
    public Object ord14aSer2(ParamsMap params) {
        return searchByMapper(NS_ACT_QUERY, "TSHP_ACTUAL_QUERY6", params);
    }

}
