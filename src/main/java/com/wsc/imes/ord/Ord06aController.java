/*
 * ============================================================================
 * 화면명: ORD06A - 생산오더 확정 관리
 * ============================================================================
 * 설명: 작업지시 조회, 계획시간/설비 저장, 확정/확정취소, 확정이력 조회
 * 원본: ProActive ORD06A.cs, ORD06A_M0A.cs
 * 작성일: 2026-02-24
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
 * 생산오더 확정 관리 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/ord")
public class Ord06aController extends BaseController {

    @Autowired
    private Ord06aService service;

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
     * 생산오더 확정 관리 메인 화면
     */
    @RequestMapping(value = "/ord06a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/ord/ord06a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 설비 목록 조회 (ORD06A_MC)
     * MC_GROUP='3605' 기준 설비 콤보 데이터
     */
    @RequestMapping(value = "/ord06a/ORD06A_MC.json")
    public String ord06aMc(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord06aMc(params);

        model.addAttribute("rows", result);

        return "jsonView";
    }

    /**
     * 작업지시 조회 (ORD06A_SER)
     * QUERY5: 검색조건에 따른 작업지시 목록
     */
    @RequestMapping(value = "/ord06a/ORD06A_SER.json")
    public String ord06aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord06aSer(params);

        model.addAttribute("rows", result);

        return "jsonView";
    }

    /**
     * 확정이력 조회 (ORD06A_SER2)
     * WO_NO별 확정/취소 이력
     */
    @RequestMapping(value = "/ord06a/ORD06A_SER2.json")
    public String ord06aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord06aSer2(params);

        model.addAttribute("rows", result);

        return "jsonView";
    }

    // ========================================================================
    // 수정
    // ========================================================================

    /**
     * 계획시간/설비 저장 (ORD06A_UPD2)
     * 다건: PLN_START_TIME, PLN_END_TIME, MC_CODE, MCT_VEN_NAME 업데이트
     */
    @RequestMapping(value = "/ord06a/ORD06A_UPD2.json")
    public String ord06aUpd2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord06aUpd2(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 확정/확정취소 (ORD06A_UPD)
     * woFlag="1": 확정, woFlag="0": 확정취소
     */
    @RequestMapping(value = "/ord06a/ORD06A_UPD.json")
    public String ord06aUpd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord06aUpd(params);

        addObject(model, result);

        return "jsonView";
    }

}
