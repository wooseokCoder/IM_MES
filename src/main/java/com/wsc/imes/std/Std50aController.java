/*
 * ============================================================================
 * 화면명: STD50A - 작업자 그룹 관리
 * ============================================================================
 * 설명: 작업자 그룹 목록 조회, 등록, 수정, 삭제
 *       마스터(TSTD_WORKGROUP) + 자식(TSTD_WORKGROUP_MC, TSTD_WORKGROUP_EMP)
 * 원본: ProActive STD50A.cs, STD50A_M0A.cs, STD50A_D0A.cs
 * 작성일: 2026-02-10
 * ============================================================================
 */
package com.wsc.imes.std;

import java.util.Map;

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
 * 작업자 그룹 관리 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/std")
public class Std50aController extends BaseController {

    @Autowired
    private Std50aService service;

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
     * 작업자 그룹 관리 화면 오픈
     * 조립/가공 분기 없음 (TSTD_WORKGROUP에 PLANTS 컬럼 없음)
     */
    @RequestMapping(value = "/std50a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/std/std50a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 그룹 목록 조회 (STD50A_SER)
     * 메인 그리드용
     */
    @RequestMapping(value = "/std50a/STD50A_SER.json")
    public String std50aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std50aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 그룹 상세 조회 (STD50A_SER2)
     * 소속 작업장 + 소속 작업자 목록 반환
     */
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/std50a/STD50A_SER2.json")
    public String std50aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Map<String, Object> detail = service.std50aSer2(params);

        model.addAttribute("mcList", detail.get("mcList"));
        model.addAttribute("empList", detail.get("empList"));

        return "jsonView";
    }

    /**
     * 전체 작업장/작업자 목록 조회 (STD50A_SER3)
     * 다이얼로그에서 전환(Transfer) UI용
     */
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/std50a/STD50A_SER3.json")
    public String std50aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Map<String, Object> allData = service.std50aSer3(params);

        model.addAttribute("mcAllList", allData.get("mcAllList"));
        model.addAttribute("empAllList", allData.get("empAllList"));

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 그룹 저장 (STD50A_INS)
     * 마스터 UPSERT + 자식 차분 저장 (mcInsList/mcDelList/empInsList/empDelList)
     */
    @RequestMapping(value = "/std50a/STD50A_INS.json")
    public String std50aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        ResultMap result = service.std50aIns(params);

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
     * 그룹 삭제 - 마스터 + 자식 전체 논리삭제 (STD50A_DEL)
     */
    @RequestMapping(value = "/std50a/STD50A_DEL.json")
    public String std50aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std50aDel(params);

        addObject(model, result);

        return "jsonView";
    }

}
