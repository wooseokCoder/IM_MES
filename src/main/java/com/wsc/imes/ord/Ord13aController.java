/*
 * ============================================================================
 * 화면명: ORD13A - 생산오더 일정 관리
 * ============================================================================
 * 설명: 주간 단위 생산 작업지시 조회, 동적 공정 컬럼 + 상태별 셀 색상,
 *       비고(SCOMMENT) 저장, 공정명(PROC_CODE) 저장
 * 원본: ProActive ORD13A.cs, ORD13A_M0A.cs
 * 작성일: 2026-02-23
 * ============================================================================
 */
package com.wsc.imes.ord;

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

/**
 * 생산오더 일정 관리 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/ord")
public class Ord13aController extends BaseController {

    @Autowired
    private Ord13aService service;

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
     * 생산오더 일정 관리 메인 화면
     */
    @RequestMapping(value = "/ord13a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/ord/ord13a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 생산오더 일정 조회 (ORD13A_SER)
     * 2개 결과셋 반환: summary (QUERY6), detail (QUERY5)
     */
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/ord13a/ORD13A_SER.json")
    public String ord13aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Map<String, Object> result = service.ord13aSer(params);

        model.addAttribute("summary", result.get("summary"));
        model.addAttribute("detail", result.get("detail"));

        return "jsonView";
    }

    // ========================================================================
    // 수정
    // ========================================================================

    /**
     * 비고 저장 (ORD13A_UPD)
     * 다건: SAP_WO_NO 단위로 SCOMMENT 업데이트
     */
    @RequestMapping(value = "/ord13a/ORD13A_UPD.json")
    public String ord13aUpd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord13aUpd(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 공정명 저장 (ORD13A_UPD2)
     * 다건: SAP_WO_NO + WO_SEQ 단위로 PROC_CODE 업데이트
     */
    @RequestMapping(value = "/ord13a/ORD13A_UPD2.json")
    public String ord13aUpd2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord13aUpd2(params);

        addObject(model, result);

        return "jsonView";
    }

}
