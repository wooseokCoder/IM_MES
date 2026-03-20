/*
 * ============================================================================
 * 화면명: POP57A - 설비별 표준문서(검사)
 * ============================================================================
 * 설명: 설비별 표준문서(검사) 조회
 * 원본: ProActive POP57A.cs, POP57A_M0A.cs
 * 작성일: 2026-03-12
 * ============================================================================
 */
package com.wsc.imes.pop;

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
 * 설비별 표준문서(검사) 컨트롤러
 */
@Controller
@RequestMapping("/imes/pop")
public class Pop57aController extends BaseController {

    @Autowired
    private Pop57aService service;

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
     * 설비별 표준문서(검사) 화면 오픈
     */
    @RequestMapping(value = "/pop57a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/pop/pop57a";
    }

    /**
     * 설비 목록 조회 (POP57A_SER)
     */
    @RequestMapping(value = "/pop57a/POP57A_SER.json")
    public String pop57aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop57aSer(params);

        addObject(model, result);

        return "jsonView";
    }
}
