/*
 * ============================================================================
 * 화면명: STD45A - 비가동코드 관리
 * ============================================================================
 * 설명: 비가동코드 목록 조회, 등록, 수정, 삭제
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 화면 분리
 * 원본: ProActive STD45A.cs, STD45A_M0A.cs, STD45A_D0A.cs
 * 작성일: 2026-02-05
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
 * 비가동코드 관리 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/std")
public class Std45aController extends BaseController {

    @Autowired
    private Std45aService service;

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
     * 비가동코드 관리 - 조립 화면 오픈
     * PLANTS = 3603
     */
    @RequestMapping(value = "/std45a_assy.do")
    public String openAssy(HttpServletRequest request, Model model) {
        super.open(request, model);  // 권한 변수 설정 (RET, INS, UPD, DEL)
        model.addAttribute("plants", "3603");
        model.addAttribute("plantsName", "조립");
        return "imes/std/std45a_assy";
    }

    /**
     * 비가동코드 관리 - 가공 화면 오픈
     * PLANTS = 3605
     */
    @RequestMapping(value = "/std45a_mach.do")
    public String openMach(HttpServletRequest request, Model model) {
        super.open(request, model);  // 권한 변수 설정 (RET, INS, UPD, DEL)
        model.addAttribute("plants", "3605");
        model.addAttribute("plantsName", "가공");
        return "imes/std/std45a_mach";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 비가동코드 목록 조회 (STD45A_SER)
     */
    @RequestMapping(value = "/std45a/STD45A_SER.json")
    public String std45aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std45aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 비가동코드 신규/수정 - UPSERT (STD45A_INS)
     */
    @RequestMapping(value = "/std45a/STD45A_INS.json")
    public String std45aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        ResultMap result = service.std45aIns(params);

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

    /**
     * 비가동코드 그리드 일괄 수정 (STD45A_UPD)
     */
    @RequestMapping(value = "/std45a/STD45A_UPD.json")
    public String std45aUpd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.std45aUpd(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 비가동코드 삭제 - 논리삭제 (STD45A_DEL)
     */
    @RequestMapping(value = "/std45a/STD45A_DEL.json")
    public String std45aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.std45aDel(params);

        addObject(model, result);

        return "jsonView";
    }

}
