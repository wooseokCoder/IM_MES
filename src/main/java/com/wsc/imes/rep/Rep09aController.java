/*
 * ============================================================================
 * 화면명: REP09A - 가공 진행현황
 * ============================================================================
 * 설명: 메인 그리드(동적 컬럼) + D0A 상세 팝업 + D1A 완료공정 팝업
 * 원본: ProActive REP09A (BREP)
 * 작성일: 2026-03-16
 * ============================================================================
 */
package com.wsc.imes.rep;

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
 * 가공 진행현황 컨트롤러
 */
@Controller
@RequestMapping("/imes/rep")
public class Rep09aController extends BaseController {

    @Autowired
    private Rep09aService service;

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

    /** 가공 진행현황 메인 화면 */
    @RequestMapping(value = "/rep09a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/rep/rep09a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /** 메인 조회: 그룹 요약 + WO 공정 + 작업자 (REP09A_SER) */
    @RequestMapping(value = "/rep09a/REP09A_SER.json")
    public String rep09aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.rep09aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    /** D0A 팝업 조회: 공정 + 실적 + NG + 검사 (REP09A_SER2) */
    @RequestMapping(value = "/rep09a/REP09A_SER2.json")
    public String rep09aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.rep09aSer2(params);

        addObject(model, result);

        return "jsonView";
    }

    /** D1A 완료공정 목록 (REP09A_SER3) */
    @RequestMapping(value = "/rep09a/REP09A_SER3.json")
    public String rep09aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.rep09aSer3(params);

        addObject(model, result);

        return "jsonView";
    }

    /** D1A 상세 조회: 실적 + NG + 검사 (REP09A_SER4) */
    @RequestMapping(value = "/rep09a/REP09A_SER4.json")
    public String rep09aSer4(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.rep09aSer4(params);

        addObject(model, result);

        return "jsonView";
    }
}
