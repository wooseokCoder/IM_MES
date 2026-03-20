/*
 * ============================================================================
 * 화면명: MAT01A - 과부족정보 조회
 * ============================================================================
 * 설명: 과부족정보 조회 (조회 전용)
 * 원본: ProActive MAT01A.cs, MAT01A_M0A.cs
 * 작성일: 2026-03-03
 * ============================================================================
 */
package com.wsc.imes.mat;

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
 * 과부족정보 조회 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/mat")
public class Mat01aController extends BaseController {

    @Autowired
    private Mat01aService service;

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
     * 과부족정보 조회 메인 화면
     */
    @RequestMapping(value = "/mat01a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/mat/mat01a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 과부족정보 조회 (MAT01A_SER)
     * AS-IS: MAT01A.MAT01A_SER → TSAP_MORE_LESS_QUERY.TSAP_MORE_LESS_QUERY2
     */
    @RequestMapping(value = "/mat01a/MAT01A_SER.json")
    public String mat01aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.mat01aSer(params);

        model.addAttribute("rows", result);

        return "jsonView";
    }

}
