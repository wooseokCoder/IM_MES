/*
 * ============================================================================
 * 화면명: STD51A - 검사그룹
 * ============================================================================
 * 설명: 검사그룹 조회
 * 원본: ProActive STD51A.cs, STD51A_M0A.cs
 * 작성일: 2026-03-11
 * ============================================================================
 */
package com.wsc.imes.std;

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
 * 검사그룹 컨트롤러
 */
@Controller
@RequestMapping("/imes/std")
public class Std51aController extends BaseController {

    @Autowired
    private Std51aService service;

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

    /**
     * 검사그룹 화면 오픈
     */
    @RequestMapping(value = "/std51a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/std/std51a";
    }

    /**
     * 검사그룹 목록 조회 (STD51A_SER)
     */
    @RequestMapping(value = "/std51a/STD51A_SER.json")
    public String std51aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std51aSer(params);

        addObject(model, result);

        return "jsonView";
    }
}
