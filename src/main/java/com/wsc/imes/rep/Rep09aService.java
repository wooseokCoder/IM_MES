/*
 * ============================================================================
 * 화면명: REP09A - 가공 진행현황
 * ============================================================================
 * 설명: 메인 그리드(동적 컬럼) 조회, D0A/D1A 팝업 상세 조회
 * 원본: ProActive REP09A.cs (BREP)
 * 작성일: 2026-03-16
 * ============================================================================
 */
package com.wsc.imes.rep;

import java.util.HashMap;
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

/**
 * 가공 진행현황 서비스
 */
@Service
public class Rep09aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Rep09aService.class);

    private static final String NS = "com.wsc.imes.rep.TSHP_WORKORDER_QUERY";

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
    // REP09A_SER: 메인 조회 (그룹 요약 + WO 공정 상세 + 작업자)
    // 3개 SP 결과를 Map으로 반환하여 JS에서 동적 컬럼 구성
    // ========================================================================
    @SuppressWarnings("unchecked")
    public Object rep09aSer(ParamsMap params) {

        setDefault(params);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("rows",    searchByMapper(NS, "REP09A_SER", params));
        result.put("woRows",  searchByMapper(NS, "REP09A_SER_WO", params));
        result.put("empRows", searchByMapper(NS, "REP09A_SER_EMP", params));
        return result;
    }

    // ========================================================================
    // REP09A_SER2: D0A 팝업 조회 (공정 + 실적 + NG + 검사)
    // ========================================================================
    @SuppressWarnings("unchecked")
    public Object rep09aSer2(ParamsMap params) {
        logger.debug("REP09A_SER2: sapWoNo={}", params.get("sapWoNo"));

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("procRows", searchByMapper(NS, "REP09A_SER2_PROC", params));
        result.put("actRows",  searchByMapper(NS, "REP09A_SER2_ACT", params));
        result.put("ngRows",   searchByMapper(NS, "REP09A_SER2_NG", params));
        result.put("insRows",  searchByMapper(NS, "REP09A_SER2_INS", params));
        return result;
    }

    // ========================================================================
    // REP09A_SER3: D1A 완료공정 목록
    // ========================================================================
    public Object rep09aSer3(ParamsMap params) {
        logger.debug("REP09A_SER3: plants={}", params.get("plants"));

        setDefault(params);

        return searchByMapper(NS, "REP09A_SER3", params);
    }

    // ========================================================================
    // REP09A_SER4: D1A 상세 조회 (실적 + NG + 검사)
    // ========================================================================
    @SuppressWarnings("unchecked")
    public Object rep09aSer4(ParamsMap params) {
        logger.debug("REP09A_SER4: sapWoNo={}, woSeq={}", params.get("sapWoNo"), params.get("woSeq"));

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("actRows", searchByMapper(NS, "REP09A_SER4_ACT", params));
        result.put("ngRows",  searchByMapper(NS, "REP09A_SER2_NG", params));
        result.put("insRows", searchByMapper(NS, "REP09A_SER2_INS", params));
        return result;
    }

    // ========================================================================
    // 기본값 설정
    // ========================================================================
    private void setDefault(ParamsMap params) {
        if (params.get("sapWoLike") == null) params.put("sapWoLike", "");
        if (params.get("modelLike") == null) params.put("modelLike", "");
        if (params.get("partLike") == null)  params.put("partLike", "");
    }
}
