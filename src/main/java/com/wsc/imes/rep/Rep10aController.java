/*
 * ============================================================================
 * 화면명: REP10A - 작업자현황
 * ============================================================================
 * 설명: 작업자 현재 상태 조회 (조회 전용, 검색조건 없음)
 *       진행/중지/퇴근 상태를 실시간 표시
 * 작성자: 송우석
 * 작성일: 2026-03-16
 * ============================================================================
 *
 * URL 매핑:
 * - 화면 오픈: /imes/rep/rep10a.do
 * - 조회:     /imes/rep/rep10a/REP10A_SER.json
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
 * 작업자현황 컨트롤러
 *
 * @author 송우석
 * @since 2026-03-16
 */
@Controller
@RequestMapping("/imes/rep")
public class Rep10aController extends BaseController {

    @Autowired
    private Rep10aService service;

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
     * 작업자현황 화면 오픈
     */
    @RequestMapping(value = "/rep10a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/rep/rep10a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 작업자현황 메인 그리드 조회
     */
    @RequestMapping(value = "/rep10a/REP10A_SER.json")
    public String rep10aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.rep10aSer(params);
        addObject(model, result);
        return "jsonView";
    }
}
