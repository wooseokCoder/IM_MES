/*
 * ============================================================================
 * 화면명: STD04A - 표준 자원 관리
 * ============================================================================
 * 설명: 설비(자원) 목록 조회, 등록, 수정, 삭제, 가용사원 관리
 * 작성자: 송우석
 * 작성일: 2026-02-23
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
 * 표준 자원 관리 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/std")
public class Std04aController extends BaseController {

    @Autowired
    private Std04aService service;

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
     * 표준 자원 관리 화면 오픈
     */
    @RequestMapping(value = "/std04a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/std/std04a";
    }

    /**
     * D0A 팝업 - 설비 상세 편집
     */
    @RequestMapping(value = "/std04a_d0a.do")
    public String openD0a(HttpServletRequest request, Model model) {
        return "imes/std/std04a_d0a";
    }

    /**
     * D1A 팝업 - 엑셀 임포트
     */
    @RequestMapping(value = "/std04a_d1a.do")
    public String openD1a(HttpServletRequest request, Model model) {
        return "imes/std/std04a_d1a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 설비 목록 조회 (STD04A_SER)
     */
    @RequestMapping(value = "/std04a/STD04A_SER.json")
    public String std04aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std04aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 설비별 작업시간 조회 (STD04A_SER2)
     */
    @RequestMapping(value = "/std04a/STD04A_SER2.json")
    public String std04aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std04aSer2(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 특정 설비의 가용사원 조회 (STD06A_SER2)
     */
    @RequestMapping(value = "/std04a/STD06A_SER2.json")
    public String std06aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std06aSer2(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 전체 사원 목록 조회 (STD06A_SER3)
     */
    @RequestMapping(value = "/std04a/STD06A_SER3.json")
    public String std06aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std06aSer3(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 공정 콤보 데이터 조회 (STD04A_STD_PROC)
     */
    @RequestMapping(value = "/std04a/STD04A_STD_PROC.json")
    public String std04aStdProc(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std04aStdProc(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 설비 등록/수정 - UPSERT (STD04A_INS)
     */
    @RequestMapping(value = "/std04a/STD04A_INS.json")
    public String std04aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        ResultMap result = service.std04aIns(params);

        addObject(model, result);

        // OVERWRITE 처리를 위한 커스텀 필드 전달
        if (result.get("errorCode") != null) {
            model.addAttribute("errorCode", result.get("errorCode"));
        }
        if (result.get("delDate") != null) {
            model.addAttribute("delDate", result.get("delDate"));
        }
        if (result.get("delEmp") != null) {
            model.addAttribute("delEmp", result.get("delEmp"));
        }
        if (result.get("delReason") != null) {
            model.addAttribute("delReason", result.get("delReason"));
        }

        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 설비 삭제 - 논리삭제 (STD04A_DEL)
     */
    @RequestMapping(value = "/std04a/STD04A_DEL.json")
    public String std04aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.std04aDel(params);

        addObject(model, result);

        return "jsonView";
    }

}
