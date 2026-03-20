/*
 * ============================================================================
 * 화면명: ORD18A - 실적삭제/삭제현황/오더완료일수정
 * ============================================================================
 * 설명: 3-Tab 구조 (실적삭제 / 삭제현황 / 오더완료일수정)
 *       Tab1: 실적삭제 조회 + 삭제
 *       Tab2: 삭제현황 조회 + 삭제취소
 *       Tab3: 오더완료일 조회 + D0A 팝업 수정
 * 원본: ProActive ORD18A.cs, ORD18A_M0A.cs, ORD18A_D0A.cs
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - ORD18A_SER  → ord18aSer  (Tab1 실적삭제 조회)
 * - ORD18A_SER2 → ord18aSer2 (Tab2 삭제현황 조회)
 * - ORD18A_SER3 → ord18aSer3 (Tab3 오더완료일 조회)
 * - ORD18A_UPD  → ord18aUpd  (D0A 오더완료일 수정)
 * - ORD18A_DEL  → ord18aDel  (Tab1 삭제)
 * - ORD18A_DEL_CANCEL → ord18aDelCancel (Tab2 삭제취소)
 *
 * @author Claude
 * @since 2026-03-06
 * ============================================================================
 */
package com.wsc.imes.ord;

import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * 실적삭제/삭제현황/오더완료일수정 컨트롤러
 */
@Controller
@RequestMapping("/imes/ord")
public class Ord18aController extends BaseController {

    @Autowired
    private Ord18aService service;

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
     * 메인 화면 (3-Tab)
     */
    @RequestMapping(value = "/ord18a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/ord/ord18a";
    }

    /**
     * D0A 팝업 (오더완료일 수정)
     * 팝업은 super.open() 호출 안 함 (SYS_PROG 미등록, 권한체크 불필요)
     */
    @RequestMapping(value = "/ord18a_d0a.do")
    public String openD0a(HttpServletRequest request, Model model) {
        return "imes/ord/ord18a_d0a";
    }

    // ========================================================================
    // Tab1: 실적삭제 조회 (ORD18A_SER)
    // ========================================================================

    @RequestMapping(value = "/ord18a/ORD18A_SER.json")
    public String ord18aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.ord18aSer(params);
        model.addAttribute("rows", result);
        return "jsonView";
    }

    // ========================================================================
    // Tab2: 삭제현황 조회 (ORD18A_SER2)
    // ========================================================================

    @RequestMapping(value = "/ord18a/ORD18A_SER2.json")
    public String ord18aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.ord18aSer2(params);
        model.addAttribute("rows", result);
        return "jsonView";
    }

    // ========================================================================
    // Tab3: 오더완료일 조회 (ORD18A_SER3)
    // ========================================================================

    @RequestMapping(value = "/ord18a/ORD18A_SER3.json")
    public String ord18aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.ord18aSer3(params);
        model.addAttribute("rows", result);
        return "jsonView";
    }

    // ========================================================================
    // D0A: 오더완료일 수정 (ORD18A_UPD)
    // ========================================================================

    @RequestMapping(value = "/ord18a/ORD18A_UPD.json")
    public String ord18aUpd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.ord18aUpd(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // Tab1: 삭제 (ORD18A_DEL)
    // ========================================================================

    @RequestMapping(value = "/ord18a/ORD18A_DEL.json")
    public String ord18aDel(@RequestBody Map<String, Object> body,
                            HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        Object result = service.ord18aDel(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // Tab2: 삭제취소 (ORD18A_DEL_CANCEL)
    // ========================================================================

    @RequestMapping(value = "/ord18a/ORD18A_DEL_CANCEL.json")
    public String ord18aDelCancel(@RequestBody Map<String, Object> body,
                                  HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        Object result = service.ord18aDelCancel(params);
        addObject(model, result);
        return "jsonView";
    }

}
