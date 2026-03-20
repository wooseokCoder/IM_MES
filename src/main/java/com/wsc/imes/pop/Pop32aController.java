/*
 * ============================================================================
 * 화면명: POP32A - 비가동 현황 (조립)
 * ============================================================================
 * 설명: 비가동(설비 정지) 이력 조회, 논리 삭제
 * 원본: ProActive POP32A_M0A.cs (메인 화면)
 * 작성일: 2026-03-04
 * ============================================================================
 * 참고: D0A(등록팝업)/D2A(수정팝업) 관련 엔드포인트는 별도 개발자가 담당
 *       본 컨트롤러에는 메인 화면 전용 엔드포인트만 포함
 * ============================================================================
 *
 * URL 매핑:
 * - 화면 오픈: /imes/pop/pop32a.do
 * - 조회:     /imes/pop/pop32a/POP32A_SER.json
 * - 삭제:     /imes/pop/pop32a/POP32A_DEL.json
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
import com.wsc.framework.model.ResultMap;

/**
 * 비가동 현황 (조립) 컨트롤러
 *
 * @author MES
 * @since 2026-03-04
 */
@Controller
@RequestMapping("/imes/pop")
public class Pop32aController extends BaseController {

    @Autowired
    private Pop32aService service;

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
     * 비가동 현황 (조립) 화면 오픈
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return JSP 뷰 경로
     */
    @RequestMapping(value = "/pop32a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/pop/pop32a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 비가동 현황 조회 (POP32A_SER)
     * <p>
     * 메인 그리드 데이터 조회.
     * 검색조건: 시작일(startDate) ~ 종료일(endDate)
     * </p>
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop32a/POP32A_SER.json")
    public String pop32aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop32aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 비가동 삭제 - 논리삭제 (POP32A_DEL)
     * <p>
     * DATA_FLAG = 2로 논리 삭제 (물리 삭제 아님)
     * </p>
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop32a/POP32A_DEL.json")
    public String pop32aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        ResultMap result = service.pop32aDel(params);

        addObject(model, result);

        return "jsonView";
    }
    

    /**
     * 작업자 목록 조회 (POP32A_SER2)
     */
    @RequestMapping(value = "/pop32a/POP32A_SER2.json")
    public String pop32aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop32aSer2(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 비가동코드 목록 조회 (POP32A_IDLE)
     */
    @RequestMapping(value = "/pop32a/POP32A_IDLE.json")
    public String pop32aIdle(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop32aIdle(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 비가동시간 등록 (POP32A_INS)
     */
    @RequestMapping(value = "/pop32a/POP32A_INS.json")
    public String pop32aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop32aIns(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 비가동시간 수정 (POP32A_INS2)
     */
    @RequestMapping(value = "/pop32a/POP32A_INS2.json")
    public String pop32aIns2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop32aIns2(params);

        addObject(model, result);

        return "jsonView";
    }

   

    /**
     * 상세원인 수정 및 확인 (POP32A_INS3)
     */
    @RequestMapping(value = "/pop32a/POP32A_INS3.json")
    public String pop32aIns3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop32aIns3(params);

        addObject(model, result);

        return "jsonView";
    }

}
