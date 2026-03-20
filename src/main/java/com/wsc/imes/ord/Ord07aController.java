/*
 * ============================================================================
 * 화면명: ORD07A - 일련번호 관리
 * ============================================================================
 * 설명: 일련번호 목록 조회, 순번 수정 (D0A 팝업)
 * 작성자: 송우석
 * 작성일: 2026-02-10
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
 * 일련번호 관리 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/ord")
public class Ord07aController extends BaseController {

    @Autowired
    private Ord07aService service;

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
     * 일련번호 관리 메인 화면
     */
    @RequestMapping(value = "/ord07a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/ord/ord07a";
    }

    /**
     * 일련번호 수정 팝업 (D0A)
     */
    @RequestMapping(value = "/ord07a_d0a.do")
    public String openD0a(HttpServletRequest request, Model model) {
        return "imes/ord/ord07a_d0a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 일련번호 목록 조회 (ORD07A_SER)
     */
    @RequestMapping(value = "/ord07a/ORD07A_SER.json")
    public String ord07aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord07aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 수정
    // ========================================================================

    /**
     * 일련번호 순번 수정 (ORD07A_UPD)
     */
    @RequestMapping(value = "/ord07a/ORD07A_UPD.json")
    public String ord07aUpd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord07aUpd(params);

        addObject(model, result);

        return "jsonView";
    }

}
