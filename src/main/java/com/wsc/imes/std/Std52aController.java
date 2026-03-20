/*
 * ============================================================================
 * 화면명: STD52A - 설비점검항목 관리
 * ============================================================================
 * 설명: 설비 일일점검항목 목록 조회, 등록, 수정, 삭제
 * 작성자: 송우석
 * 작성일: 2026-02-06
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
 * 설비점검항목 관리 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/std")
public class Std52aController extends BaseController {

    @Autowired
    private Std52aService service;

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
     * 설비점검항목 관리 화면 오픈
     */
    @RequestMapping(value = "/std52a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);  // 권한 변수 설정 (RET, INS, UPD, DEL)
        return "imes/std/std52a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 점검항목 목록 조회 (STD52A_SER)
     */
    @RequestMapping(value = "/std52a/STD52A_SER.json")
    public String std52aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std52aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 점검항목 신규/수정 - UPSERT (STD52A_INS)
     */
    @RequestMapping(value = "/std52a/STD52A_INS.json")
    public String std52aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std52aIns(params);

        addObject(model, result);

        // OVERWRITE 에러 처리를 위한 커스텀 필드 전달 (addObject에서 유실되므로 별도 추가)
        if (result instanceof ResultMap) {
            ResultMap rm = (ResultMap) result;
            if (rm.get("code") != null) {
                model.addAttribute("code", rm.get("code"));
            }
            if (rm.get("message") != null) {
                model.addAttribute("message", rm.get("message"));
            }
            if (rm.get("delDate") != null) {
                model.addAttribute("delDate", rm.get("delDate"));
            }
            if (rm.get("delEmp") != null) {
                model.addAttribute("delEmp", rm.get("delEmp"));
            }
        }

        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 점검항목 삭제 - 논리삭제 (STD52A_DEL)
     */
    @RequestMapping(value = "/std52a/STD52A_DEL.json")
    public String std52aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);

        Object result = service.std52aDel(params);

        addObject(model, result);

        return "jsonView";
    }

}
