/*
 * ============================================================================
 * 화면명: POP33A - SAP실적처리
 * ============================================================================
 * 설명: 일별 공수 현황 조회, 실적/삭제 현황 관리, SAP 전송
 * 원본: ProActive POP33A_M0A.cs (메인 화면)
 * 작성일: 2026-03-05
 * ============================================================================
 *
 * URL 매핑:
 * - 화면 오픈: /imes/pop/pop33a.do
 * - Grid1 조회: /imes/pop/pop33a/POP33A_SER.json
 * - Grid2 조회: /imes/pop/pop33a/POP33A_SER2.json
 * - Grid3 조회: /imes/pop/pop33a/POP33A_SER3.json
 * - IF_SEL_FLAG 저장: /imes/pop/pop33a/POP33A_INS.json
 * - SAP 전송: /imes/pop/pop33a/POP33A_INS2.json
 * - 실적 삭제: /imes/pop/pop33a/POP33A_DEL.json
 * - 삭제 취소: /imes/pop/pop33a/POP33A_DEL_CANCEL.json
 * - 제외 여부 저장: /imes/pop/pop33a/POP33A_INS3.json
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
import com.wsc.framework.model.ResultMap;

import java.util.Map;
import org.springframework.web.bind.annotation.RequestBody;

/**
 * 공수오류현황 컨트롤러
 *
 * @author MES
 * @since 2026-03-05
 */
@Controller
@RequestMapping("/imes/pop")
public class Pop33aController extends BaseController {

    @Autowired
    private Pop33aService service;

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
     * 공수오류현황 화면 오픈
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return JSP 뷰 경로
     */
    @RequestMapping(value = "/pop33a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/pop/pop33a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * Grid1 일별 공수 조회 (POP33A_SER)
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop33a/POP33A_SER.json")
    public String pop33aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.pop33aSer(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * Grid2 실적현황 조회 (POP33A_SER2)
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop33a/POP33A_SER2.json")
    public String pop33aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.pop33aSer2(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * Grid3 삭제현황 조회 (POP33A_SER3)
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop33a/POP33A_SER3.json")
    public String pop33aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.pop33aSer3(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 저장 / SAP 전송
    // ========================================================================

    /**
     * IF_SEL_FLAG 저장 (POP33A_INS)
     * <p>
     * JS에서 JSON.stringify({ rows: [...] })로 전송하므로
     * @RequestBody로 JSON body를 파싱하여 세션 파라미터와 병합
     * </p>
     *
     * @param body JSON 요청 본문 (rows 배열 포함)
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop33a/POP33A_INS.json")
    public String pop33aIns(@RequestBody Map<String, Object> body,
                            HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        ResultMap result = service.pop33aIns(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * SAP 전송 (POP33A_INS2)
     * <p>
     * JS에서 JSON.stringify({ empCode, workDate, sendFlag, rows })로 전송
     * </p>
     *
     * @param body JSON 요청 본문 (empCode, workDate, sendFlag, rows 포함)
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop33a/POP33A_INS2.json")
    public String pop33aIns2(@RequestBody Map<String, Object> body,
                             HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        ResultMap result = service.pop33aIns2(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 삭제 / 삭제취소
    // ========================================================================

    /**
     * 실적 삭제 (POP33A_DEL)
     * <p>
     * JS에서 JSON.stringify({ rows: [...] })로 전송
     * </p>
     *
     * @param body JSON 요청 본문 (rows 배열 포함)
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop33a/POP33A_DEL.json")
    public String pop33aDel(@RequestBody Map<String, Object> body,
                            HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        ResultMap result = service.pop33aDel(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * 삭제 취소 - 복원 (POP33A_DEL_CANCEL)
     * <p>
     * JS에서 JSON.stringify({ rows: [...] })로 전송
     * </p>
     *
     * @param body JSON 요청 본문 (rows 배열 포함)
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop33a/POP33A_DEL_CANCEL.json")
    public String pop33aDelCancel(@RequestBody Map<String, Object> body,
                                  HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        ResultMap result = service.pop33aDelCancel(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 제외 여부
    // ========================================================================

    /**
     * 제외 여부 저장 (POP33A_INS3)
     * <p>
     * JS에서 JSON.stringify({ rows: [...] })로 전송
     * </p>
     *
     * @param body JSON 요청 본문 (rows 배열 포함)
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop33a/POP33A_INS3.json")
    public String pop33aIns3(@RequestBody Map<String, Object> body,
                             HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        ResultMap result = service.pop33aIns3(params);
        addObject(model, result);
        return "jsonView";
    }
}
