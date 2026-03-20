/*
 * ============================================================================
 * 화면명: POP42A - 일일점검 이력 조회
 * ============================================================================
 * 설명: 설비별 일일점검 이력 조회 (조회 전용, 마스터-디테일)
 * 작성자: 송우석
 * 작성일: 2026-03-10
 * ============================================================================
 *
 * URL 매핑:
 * - 화면 오픈:     /imes/pop/pop42a.do
 * - 마스터 조회:   /imes/pop/pop42a/POP42A_SER.json
 * - 디테일 조회:   /imes/pop/pop42a/POP42A_SER2.json
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
 * 일일점검 이력 조회 컨트롤러
 *
 * @author 송우석
 * @since 2026-03-10
 */
@Controller
@RequestMapping("/imes/pop")
public class Pop42aController extends BaseController {

    @Autowired
    private Pop42aService service;

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
     * 일일점검 이력 조회 화면 오픈
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return JSP 뷰 경로
     */
    @RequestMapping(value = "/pop42a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/pop/pop42a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 마스터 그리드 조회 - 설비별 점검일 목록 (POP42A_SER)
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop42a/POP42A_SER.json")
    public String pop42aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop42aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 디테일 그리드 조회 - 점검항목 상세 (POP42A_SER2)
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop42a/POP42A_SER2.json")
    public String pop42aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop42aSer2(params);

        addObject(model, result);

        return "jsonView";
    }

}
