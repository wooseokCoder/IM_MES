/*
 * ============================================================================
 * 화면명: POP42A - 일일점검 이력 조회
 * ============================================================================
 * 설명: 설비별 일일점검 이력 조회 (조회 전용)
 *       마스터: 설비+점검일 목록, 디테일: 점검항목 상세
 * 작성자: 송우석
 * 작성일: 2026-03-10
 * ============================================================================
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - POP42A_SER   → pop42aSer   (마스터 조회)
 * - POP42A_SER2  → pop42aSer2  (디테일 조회)
 */
package com.wsc.imes.pop;

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
 * 일일점검 이력 조회 서비스
 * <p>
 * 조회 전용 화면 (CUD 없음)
 * 마스터 그리드: 설비별 점검일 목록
 * 디테일 그리드: 점검항목 상세
 * </p>
 *
 * @author 송우석
 * @since 2026-03-10
 */
@Service
public class Pop42aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Pop42aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    /** TPOP_MC_DAILY_CHECK_RESULT_QUERY 조회 매퍼 */
    private static final String NS_QUERY = "com.wsc.imes.pop.TPOP_MC_DAILY_CHECK_RESULT_QUERY";

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
    // POP42A_SER: 마스터 조회 (설비별 점검일 목록)
    // TPOP_MC_DAILY_CHECK_RESULT_QUERY.TPOP_MC_DAILY_CHECK_RESULT_QUERY2 호출
    // JOIN: LSE_MACHINE (설비명)
    // 검색조건: 설비명 LIKE, 점검일 범위
    // ========================================================================

    /**
     * 마스터 그리드 조회 (설비별 점검일 목록)
     *
     * @param params mdcrMcLike (설비명 검색), sMdcrDate (시작일), eMdcrDate (종료일)
     * @return 설비코드+설비명+점검일 목록
     */
    public Object pop42aSer(ParamsMap params) {
        logger.debug("POP42A_SER: sMdcrDate={}, eMdcrDate={}",
                params.get("sMdcrDate"), params.get("eMdcrDate"));

        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_QUERY, "TPOP_MC_DAILY_CHECK_RESULT_QUERY2", params);
    }

    // ========================================================================
    // POP42A_SER2: 디테일 조회 (점검항목 상세)
    // TPOP_MC_DAILY_CHECK_RESULT_QUERY.TPOP_MC_DAILY_CHECK_RESULT_QUERY1 호출
    // 파라미터: 마스터에서 선택된 설비코드 + 점검일
    // ========================================================================

    /**
     * 디테일 그리드 조회 (점검항목 상세)
     *
     * @param params mdcrMcCode (설비코드), mdcrDate (점검일)
     * @return 점검항목 상세 목록
     */
    public Object pop42aSer2(ParamsMap params) {
        logger.debug("POP42A_SER2: mdcrMcCode={}, mdcrDate={}",
                params.get("mdcrMcCode"), params.get("mdcrDate"));

        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_QUERY, "TPOP_MC_DAILY_CHECK_RESULT_QUERY1", params);
    }

}
