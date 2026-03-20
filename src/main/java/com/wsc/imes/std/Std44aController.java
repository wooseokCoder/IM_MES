/*
 * ============================================================================
 * 화면명: STD44A - 모델군 관리
 * ============================================================================
 * 설명: 모델군 목록 조회, 등록, 수정, 삭제
 *       3단 수평 분할 (구분(B) → 시리즈(M) → 모델(S))
 * 작성자: 송우석
 * 작성일: 2026-02-20
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
import com.wsc.framework.model.ResultMap;

/**
 * 모델군 관리 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/std")
public class Std44aController extends BaseController {

    @Autowired
    private Std44aService service;

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
     * 모델군 관리 화면 오픈
     */
    @RequestMapping(value = "/std44a.do")
    public String openStd44a(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/std/std44a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 모델군 목록 조회 (STD44A_SER)
     */
    @RequestMapping(value = "/std44a/STD44A_SER.json")
    public String std44aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std44aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 모델군 저장 - UPSERT (STD44A_INS)
     */
    @RequestMapping(value = "/std44a/STD44A_INS.json")
    public String std44aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        ResultMap result = service.std44aIns(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 모델군 삭제 - 논리삭제 (STD44A_DEL)
     */
    @RequestMapping(value = "/std44a/STD44A_DEL.json")
    public String std44aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        ResultMap result = service.std44aDel(params);

        addObject(model, result);

        return "jsonView";
    }

}
