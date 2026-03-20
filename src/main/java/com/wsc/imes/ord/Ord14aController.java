/*
 * ============================================================================
 * 화면명: ORD14A - 실적관리 가공
 * ============================================================================
 * 설명: 작업지시 조회 + 작업지시별 실적 상세 조회 (조회 전용, Master-Detail)
 * 원본: ProActive ORD14A.cs, ORD14A_M0A.cs
 * 작성일: 2026-03-06
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
 * 실적관리 가공 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/ord")
public class Ord14aController extends BaseController {

    @Autowired
    private Ord14aService service;

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
     * 실적관리 가공 메인 화면
     */
    @RequestMapping(value = "/ord14a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/ord/ord14a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 작업지시 목록 조회 (ORD14A_SER)
     * QUERY12: 검색조건에 따른 작업지시 목록
     */
    @RequestMapping(value = "/ord14a/ORD14A_SER.json")
    public String ord14aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord14aSer(params);

        model.addAttribute("rows", result);

        return "jsonView";
    }

    /**
     * 실적 상세 조회 (ORD14A_SER2)
     * QUERY6: 작업지시번호(WO_NO)별 실적 상세
     */
    @RequestMapping(value = "/ord14a/ORD14A_SER2.json")
    public String ord14aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord14aSer2(params);

        model.addAttribute("rows", result);

        return "jsonView";
    }

}
