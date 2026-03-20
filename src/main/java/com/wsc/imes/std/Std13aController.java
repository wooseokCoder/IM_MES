/*
 * ============================================================================
 * 화면명: STD13A - 부서/사원 관리
 * ============================================================================
 * 설명: 부서 트리 조회, 사원 목록 조회(읽기전용), 부서 CRUD
 *       사원 등록/수정/삭제는 제외 (부서 CRUD + 사원 조회만)
 * 원본: ProActive STD13A.cs, STD13A_M0A.cs, STD13A_D0A.cs
 * 작성일: 2026-02-11
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
 * 부서/사원 관리 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/std")
public class Std13aController extends BaseController {

    @Autowired
    private Std13aService service;

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
     * 부서/사원 관리 화면 오픈
     */
    @RequestMapping(value = "/std13a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/std/std13a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 부서 트리 조회 (STD13A_SER)
     */
    @RequestMapping(value = "/std13a/STD13A_SER.json")
    public String std13aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std13aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 사원 목록 조회 (STD13A_SER2)
     */
    @RequestMapping(value = "/std13a/STD13A_SER2.json")
    public String std13aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std13aSer2(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 부서 저장 - UPSERT (STD13A_INS)
     */
    @RequestMapping(value = "/std13a/STD13A_INS.json")
    public String std13aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        ResultMap result = service.std13aIns(params);

        addObject(model, result);

        // OVERWRITE 처리를 위한 커스텀 필드 전달 (addResult에서 유실되므로 별도 추가)
        if (result.get("errorCode") != null) {
            model.addAttribute("errorCode", result.get("errorCode"));
        }
        if (result.get("delDate") != null) {
            model.addAttribute("delDate", result.get("delDate"));
        }
        if (result.get("delEmp") != null) {
            model.addAttribute("delEmp", result.get("delEmp"));
        }

        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 부서 삭제 - 논리삭제 (STD13A_DEL)
     * 소속 사원 존재 시 차단
     */
    @RequestMapping(value = "/std13a/STD13A_DEL.json")
    public String std13aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        ResultMap result = service.std13aDel(params);

        addObject(model, result);

        return "jsonView";
    }

}
