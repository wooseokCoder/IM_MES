/*
 * ============================================================================
 * 화면명: ORD15A - 실적/비가동 현황
 * ============================================================================
 * 설명: 실적(TSHP_ACTUAL)과 비가동(TSHP_IDLETIME) UNION ALL 조회
 *       조회 전용 (CRUD 없음)
 * 작성자: 송우석
 * 작성일: 2026-03-16
 * ============================================================================
 */
package com.wsc.imes.ord;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * 실적/비가동 현황 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/ord")
public class Ord15aController extends BaseController {

    @Autowired
    private Ord15aService service;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Override
    protected BaseService getService() {
        return this.service;
    }

    @Override
    protected SessionComponent getSessionComponent() {
        return this.sessionProvider.get();
    }

    // ========================================================================
    // 화면 열기
    // ========================================================================

    /**
     * 실적/비가동 현황 화면 오픈
     */
    @RequestMapping(value = "/ord15a.do")
    public String view(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/ord/ord15a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 실적/비가동 목록 조회 (TSHP_ACTUAL_QUERY15_4)
     */
    @RequestMapping(value = "/ord15a/TSHP_ACTUAL_QUERY15_4.json")
    public String ord15aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord15aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 퇴근 로그 조회 (TSYS_OFF_LOG_QUERY1)
     */
    @RequestMapping(value = "/ord15a/TSYS_OFF_LOG_QUERY1.json")
    public String ord15aSerOff(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord15aSerOff(params);

        addObject(model, result);

        return "jsonView";
    }
}
