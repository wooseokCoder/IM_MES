/*
 * ============================================================================
 * 화면명: POP43A - 수리수선 이력관리
 * ============================================================================
 * 설명: 수리수선 이력 조회, 등록, 수정, 삭제
 * 원본: ProActive POP43A.cs, POP43A_M0A.cs, POP43A_D0A.cs
 *       TMCM_REPAIR.cs, TMCM_REPAIR_QUERY.cs
 * 작성일: 2026-03-11
 * ============================================================================
 *
 * URL 매핑:
 * - 화면 오픈:     /imes/pop/pop43a.do
 * - 목록 조회:     /imes/pop/pop43a/POP43A_SER.json
 * - 단건 저장:     /imes/pop/pop43a/POP43A_INS.json
 * - 다건 삭제:     /imes/pop/pop43a/POP43A_DEL.json
 */
package com.wsc.imes.pop;

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
 * 수리수선 이력관리 컨트롤러
 *
 * @author MES
 * @since 2026-03-11
 */
@Controller
@RequestMapping("/imes/pop")
public class Pop43aController extends BaseController {

    @Autowired
    private Pop43aService service;

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
     * 수리수선 이력관리 화면 오픈
     */
    @RequestMapping(value = "/pop43a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/pop/pop43a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 수리수선 목록 조회 (POP43A_SER)
     */
    @RequestMapping(value = "/pop43a/POP43A_SER.json")
    public String pop43aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop43aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 수리수선 단건 저장 - UPSERT (POP43A_INS)
     */
    @RequestMapping(value = "/pop43a/POP43A_INS.json")
    public String pop43aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop43aIns(params);

        addObject(model, result);

        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 수리수선 다건 삭제 (POP43A_DEL)
     */
    @RequestMapping(value = "/pop43a/POP43A_DEL.json")
    public String pop43aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.pop43aDel(params);

        addObject(model, result);

        return "jsonView";
    }

}
