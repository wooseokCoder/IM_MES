/*
 * ============================================================================
 * 화면명: MAT05A - 자재불출현황
 * ============================================================================
 * 설명: 생산지시별 자재 불출 조회, 현장불출, 불출취소
 * 원본: ProActive MAT05A.cs, MAT05A_M0A.cs
 * 작성일: 2026-03-04
 * ============================================================================
 */
package com.wsc.imes.mat;

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
 * 자재불출현황 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/mat")
public class Mat05aController extends BaseController {

    @Autowired
    private Mat05aService service;

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
     * 자재불출현황 메인 화면
     */
    @RequestMapping(value = "/mat05a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/mat/mat05a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * Tab1 메인 조회 (MAT05A_SER) - 3개 결과셋 반환
     */
    @RequestMapping(value = "/mat05a/MAT05A_SER.json")
    public String mat05aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Map<String, Object> result = service.mat05aSer(params);
        model.addAttribute("rows", result.get("rows"));
        model.addAttribute("empList", result.get("empList"));
        model.addAttribute("rateList", result.get("rateList"));
        return "jsonView";
    }

    /**
     * Tab1 디테일 조회 (MAT05A_SER2) - 단건
     */
    @RequestMapping(value = "/mat05a/MAT05A_SER2.json")
    public String mat05aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        model.addAttribute("rows", service.mat05aSer2(params));
        return "jsonView";
    }

    /**
     * Tab1 디테일 조회 (MAT05A_SER2) - 다건 (선택공정 자재조회)
     * AS-IS: 선택된 행 각각에 대해 QUERY3 반복 실행 후 결과 Merge
     */
    @RequestMapping(value = "/mat05a/MAT05A_SER2_MULTI.json")
    public String mat05aSer2Multi(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        model.addAttribute("rows", service.mat05aSer2Multi(params));
        return "jsonView";
    }

    /**
     * D0A 담당자 목록 조회 (MAT05A_SER3)
     */
    @RequestMapping(value = "/mat05a/MAT05A_SER3.json")
    public String mat05aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        model.addAttribute("rows", service.mat05aSer3(params));
        return "jsonView";
    }

    /**
     * D0A/D1A 자재 상세 조회 (MAT05A_SER4)
     */
    @RequestMapping(value = "/mat05a/MAT05A_SER4.json")
    public String mat05aSer4(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        model.addAttribute("rows", service.mat05aSer4(params));
        return "jsonView";
    }

    /**
     * D1A 출고건 목록 조회 (MAT05A_SER6)
     */
    @RequestMapping(value = "/mat05a/MAT05A_SER6.json")
    public String mat05aSer6(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        model.addAttribute("rows", service.mat05aSer6(params));
        return "jsonView";
    }

    /**
     * Tab2/Tab3 결합 조회 (MAT05A_SER8)
     */
    @RequestMapping(value = "/mat05a/MAT05A_SER8.json")
    public String mat05aSer8(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        model.addAttribute("rows", service.mat05aSer8(params));
        return "jsonView";
    }

    /**
     * 마스터 공정 목록 조회 (ORD04A_PROC)
     * AS-IS: ORD04A.cs BIZ → LSE_STD_PROC_QUERY8
     */
    @RequestMapping(value = "/mat05a/ORD04A_PROC.json")
    public String ord04aProc(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        model.addAttribute("rows", service.ord04aProc(params));
        return "jsonView";
    }

    // ========================================================================
    // CUD
    // ========================================================================

    /**
     * 현장불출 저장 (MAT05A_INS)
     */
    @RequestMapping(value = "/mat05a/MAT05A_INS.json")
    public String mat05aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        ResultMap result = service.mat05aIns(params);
        addObject(model, result);
        // addObject는 커스텀 필드 유실 → updatedRow 별도 추가
        if (result.get("updatedRow") != null) {
            model.addAttribute("updatedRow", result.get("updatedRow"));
        }
        return "jsonView";
    }

    /**
     * 불출취소 (MAT05A_DEL)
     */
    @RequestMapping(value = "/mat05a/MAT05A_DEL.json")
    public String mat05aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        ResultMap result = service.mat05aDel(params);
        addObject(model, result);
        if (result.get("updatedRow") != null) {
            model.addAttribute("updatedRow", result.get("updatedRow"));
        }
        return "jsonView";
    }

}
