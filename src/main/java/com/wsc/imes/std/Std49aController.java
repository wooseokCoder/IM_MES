/*
 * ============================================================================
 * 화면명: STD49A - 비가동 관리
 * ============================================================================
 * 설명: 비가동시간 목록 조회, 등록, 수정, 삭제
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 화면 분리
 * 원본: ProActive STD49A.cs, STD49A_M0A.cs, STD49A_D0A.cs
 * 작성일: 2026-02-10
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
 * 비가동 관리 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/std")
public class Std49aController extends BaseController {

    @Autowired
    private Std49aService service;

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
     * 비가동 관리 - 조립 화면 오픈
     * PLANTS = 3603
     */
    @RequestMapping(value = "/std49a_assy.do")
    public String openAssy(HttpServletRequest request, Model model) {
        super.open(request, model);
        model.addAttribute("plants", "3603");
        model.addAttribute("plantsName", "조립");
        return "imes/std/std49a_assy";
    }

    /**
     * 비가동 관리 - 가공 화면 오픈
     * PLANTS = 3605
     */
    @RequestMapping(value = "/std49a_mach.do")
    public String openMach(HttpServletRequest request, Model model) {
        super.open(request, model);
        model.addAttribute("plants", "3605");
        model.addAttribute("plantsName", "가공");
        return "imes/std/std49a_mach";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 비가동시간 목록 조회 (STD49A_SER)
     */
    @RequestMapping(value = "/std49a/STD49A_SER.json")
    public String std49aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std49aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 비가동코드 Lookup 조회 (STD49A_IDLE)
     * 콤보박스/LookUpEdit용 비가동코드 목록
     */
    @RequestMapping(value = "/std49a/STD49A_IDLE.json")
    public String std49aIdle(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std49aIdle(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 비가동시간 등록/수정 (STD49A_INS)
     * 시간 중복 체크 + OVERWRITE 처리
     */
    @RequestMapping(value = "/std49a/STD49A_INS.json")
    public String std49aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        ResultMap result = service.std49aIns(params);

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
     * 비가동시간 삭제 - 논리삭제 + 삭제사유 (STD49A_DEL)
     */
    @RequestMapping(value = "/std49a/STD49A_DEL.json")
    public String std49aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std49aDel(params);

        addObject(model, result);

        return "jsonView";
    }

}
