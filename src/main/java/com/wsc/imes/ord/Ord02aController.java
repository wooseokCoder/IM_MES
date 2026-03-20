/*
 * ============================================================================
 * 화면명: ORD02A - 이메일 수신자그룹 관리
 * ============================================================================
 * 설명: 수신자그룹/사원 조회, 등록, 수정, 삭제, 엑셀업로드
 * 작성자: 송우석
 * 작성일: 2026-02-10
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
 * 이메일 수신자그룹 관리 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/ord")
public class Ord02aController extends BaseController {

    @Autowired
    private Ord02aService service;

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
     * 이메일 수신자그룹 관리 메인 화면
     */
    @RequestMapping(value = "/ord02a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/ord/ord02a";
    }

    /**
     * 엑셀업로드 팝업 화면
     */
    @RequestMapping(value = "/ord02a_d0a.do")
    public String openD0a(HttpServletRequest request, Model model) {
        return "imes/ord/ord02a_d0a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 수신자그룹 목록 조회 (ORD02A_SER)
     */
    @RequestMapping(value = "/ord02a/ORD02A_SER.json")
    public String ord02aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord02aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 그룹별 사원 목록 조회 (ORD02A_SER2)
     */
    @RequestMapping(value = "/ord02a/ORD02A_SER2.json")
    public String ord02aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord02aSer2(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 수신자그룹 저장 - UPSERT 다건 (ORD02A_INS)
     */
    @RequestMapping(value = "/ord02a/ORD02A_INS.json")
    public String ord02aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.ord02aIns(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 사원 저장 - UPSERT 다건 (ORD02A_INS2)
     */
    @RequestMapping(value = "/ord02a/ORD02A_INS2.json")
    public String ord02aIns2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.ord02aIns2(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 엑셀업로드 저장 - 다건 (ORD02A_INS3)
     */
    @RequestMapping(value = "/ord02a/ORD02A_INS3.json")
    public String ord02aIns3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.ord02aIns3(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 수신자그룹 삭제 - 논리삭제 다건 (ORD02A_DEL)
     */
    @RequestMapping(value = "/ord02a/ORD02A_DEL.json")
    public String ord02aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.ord02aDel(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 사원 삭제 - 논리삭제 다건 (ORD02A_DEL2)
     */
    @RequestMapping(value = "/ord02a/ORD02A_DEL2.json")
    public String ord02aDel2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.ord02aDel2(params);

        addObject(model, result);

        return "jsonView";
    }

}
