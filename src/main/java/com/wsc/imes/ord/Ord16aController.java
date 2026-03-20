/*
 * ============================================================================
 * 화면명: ORD16A - 생산오더 완료처리
 * ============================================================================
 * 설명: 작업지시 조회 및 생산오더 완료 처리
 *       - 진행중/일시중단 작업자 실적 종료
 *       - 비가동 시간 종료
 *       - 작업지시 완료 상태 변경
 * 원본: ProActive ORD16A.cs, ORD16A_M0A.cs
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - ORD16A_SER → ord16aSer (작업지시 조회)
 * - ORD16A_UPD → ord16aUpd (완료 처리)
 *
 * @author Claude
 * @since 2026-03-04
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
 * 생산오더 완료처리 컨트롤러
 *
 * @author Claude
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/ord")
public class Ord16aController extends BaseController {

    @Autowired
    private Ord16aService service;

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
     * 생산오더 완료처리 메인 화면
     */
    @RequestMapping(value = "/ord16a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/ord/ord16a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 작업지시 조회 (ORD16A_SER)
     * TSHP_WORKORDER_QUERY29: IS_SIM=1, DATA_FLAG=0 기준 작업지시 목록
     */
    @RequestMapping(value = "/ord16a/ORD16A_SER.json")
    public String ord16aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord16aSer(params);

        model.addAttribute("rows", result);

        return "jsonView";
    }

    // ========================================================================
    // 완료 처리
    // ========================================================================

    /**
     * 생산오더 완료 처리 (ORD16A_UPD)
     * 선택된 작업지시에 대해:
     *   1. 진행중/일시중단 작업자 실적 종료 (PROC_STAT=4)
     *   2. 완료 실적 INSERT
     *   3. 활성 비가동 종료
     *   4. 작업지시 완료 상태 변경 (WO_FLAG=2)
     */
    @RequestMapping(value = "/ord16a/ORD16A_UPD.json")
    public String ord16aUpd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.ord16aUpd(params);

        addObject(model, result);

        return "jsonView";
    }

}
