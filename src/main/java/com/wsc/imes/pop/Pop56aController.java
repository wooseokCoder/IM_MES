/*
 * ============================================================================
 * 화면명: POP56A - 불량메일 발신자 관리
 * ============================================================================
 * 설명: 불량메일 수신자 목록 관리 (전동E / 유압P 구분)
 *       발신자 설정 저장 (TSYS_CONF)
 * 원본: ProActive POP56A_M0A.cs (메인 화면)
 * 작성일: 2026-03-07
 * ============================================================================
 *
 * URL 매핑:
 * - 화면 오픈: /imes/pop/pop56a.do
 * - 수신자 조회: /imes/pop/pop56a/POP56A_SER.json
 * - 수신자 등록: /imes/pop/pop56a/POP56A_INS.json
 * - 수신자 삭제: /imes/pop/pop56a/POP56A_DEL.json
 * - 발신자 설정 저장: /imes/pop/pop56a/POP56A_SAVE_CONFIG.json
 */
package com.wsc.imes.pop;

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
import com.wsc.framework.model.ResultMap;

/**
 * 불량메일 발신자 관리 컨트롤러
 *
 * @author MES
 * @since 2026-03-07
 */
@Controller
@RequestMapping("/imes/pop")
public class Pop56aController extends BaseController {

    @Autowired
    private Pop56aService service;

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
     * 불량메일 발신자 관리 화면 오픈
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return JSP 뷰 경로
     */
    @RequestMapping(value = "/pop56a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);

        // 발신자 설정값 로딩 (TSYS_CONF: NG_MAIL_E, NG_MAIL_P)
        ParamsMap params = getParams(request);
        Map<String, String> configMap = service.loadNgMailConfig(params);
        model.addAttribute("ngMailE", configMap.get("NG_MAIL_E"));
        model.addAttribute("ngMailP", configMap.get("NG_MAIL_P"));
        model.addAttribute("ngMailEName", configMap.get("NG_MAIL_E_NAME"));
        model.addAttribute("ngMailPName", configMap.get("NG_MAIL_P_NAME"));

        return "imes/pop/pop56a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 수신자 목록 조회 (POP56A_SER)
     * <p>
     * 전동(E) + 유압(P) 전체 수신자 목록을 조회하여 반환.
     * JS에서 prodType 기준으로 Grid1/Grid2에 분배.
     * </p>
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop56a/POP56A_SER.json")
    public String pop56aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.pop56aSer(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 등록
    // ========================================================================

    /**
     * 수신자 등록 (POP56A_INS)
     * <p>
     * 사원코드로 중복 확인 후 신규 등록 또는 재활성화 처리.
     * JS에서 JSON.stringify({ empCode, prodType })로 전송.
     * </p>
     *
     * @param body JSON 요청 본문 (empCode, prodType 포함)
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop56a/POP56A_INS.json")
    public String pop56aIns(@RequestBody Map<String, Object> body,
                            HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        ResultMap result = service.pop56aIns(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 수신자 삭제 (POP56A_DEL)
     * <p>
     * 논리삭제 (DATA_FLAG=2).
     * JS에서 JSON.stringify({ empCode, prodType })로 전송.
     * </p>
     *
     * @param body JSON 요청 본문 (empCode, prodType 포함)
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop56a/POP56A_DEL.json")
    public String pop56aDel(@RequestBody Map<String, Object> body,
                            HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        ResultMap result = service.pop56aDel(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 발신자 설정 저장
    // ========================================================================

    /**
     * 발신자 설정 저장 (POP56A_SAVE_CONFIG)
     * <p>
     * TSYS_CONF에 NG_MAIL_E, NG_MAIL_P 값을 UPSERT.
     * JS에서 JSON.stringify({ empE, empP })로 전송.
     * </p>
     *
     * @param body JSON 요청 본문 (empE, empP 포함)
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop56a/POP56A_SAVE_CONFIG.json")
    public String pop56aSaveConfig(@RequestBody Map<String, Object> body,
                                   HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        ResultMap result = service.pop56aSaveConfig(params);
        addObject(model, result);
        return "jsonView";
    }
}
