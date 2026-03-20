/*
 * ============================================================================
 * 화면명: POP32B - 비가동현황 (가공)
 * ============================================================================
 * 설명: 비가동현황 조회, 삭제, 상세원인 수정 및 확인
 * 작성자: AI Assistant
 * 작성일: 2026-03-03
 * ============================================================================
 * 참고: POP32A의 서비스를 재사용 (POP32A_SER, POP32A_DEL, POP32A_INS3)
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
 * 비가동현황 (가공) 컨트롤러
 *
 * @author AI Assistant
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/pop")
public class Pop32bController extends BaseController {

    @Autowired
    private Pop32aService service;  // POP32A 서비스 재사용

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
     * 비가동현황 (가공) 화면 오픈
     */
    @RequestMapping(value = "/pop32b.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);  // 권한 변수 설정 (RET, INS, UPD, DEL)
        return "imes/pop/pop32b";
    }

    // ========================================================================
    // 조회 (POP32A_SER 재사용)
    // ========================================================================

    /**
     * 비가동현황 목록 조회 (POP32A_SER 재사용)
     */
    @RequestMapping(value = "/pop32b/POP32A_SER.json")
    public String pop32aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop32aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 삭제 (POP32A_DEL 재사용)
    // ========================================================================

    /**
     * 비가동시간 삭제 - 논리삭제 (POP32A_DEL 재사용)
     */
    @RequestMapping(value = "/pop32b/POP32A_DEL.json")
    public String pop32aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.pop32aDel(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장 (POP32A_INS3 재사용)
    // ========================================================================

    /**
     * 상세원인 수정 및 확인 (POP32A_INS3 재사용)
     */
    @RequestMapping(value = "/pop32b/POP32A_INS3.json")
    public String pop32aIns3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop32aIns3(params);

        addObject(model, result);

        return "jsonView";
    }

}
