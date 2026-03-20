/*
 * ============================================================================
 * 화면명: POP55A - NAM공정 NG파일배포 확인
 * ============================================================================
 * 설명: NAM공정 NG파일 배포 확인 상태 조회, 확인 저장, cascade 삭제
 * 원본: ProActive POP55A_M0A.cs (메인 화면)
 * 작성일: 2026-03-07
 * ============================================================================
 *
 * URL 매핑:
 * - 화면 오픈: /imes/pop/pop55a.do
 * - Grid1 조회: /imes/pop/pop55a/POP55A_SER.json    (QUERY22 메인 제품 목록)
 * - Grid2 조회: /imes/pop/pop55a/POP55A_SER2.json   (QUERY23 파일 상세)
 * - 확인 저장:  /imes/pop/pop55a/POP55A_INS.json    (마스터 UPSERT + 상세 INS)
 * - cascade 삭제: /imes/pop/pop55a/POP55A_UDE.json   (CHK + MASTER + WORK 일괄 삭제)
 */
package com.wsc.imes.pop;

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

import java.util.Map;

/**
 * NAM공정 NG파일배포 확인 컨트롤러
 *
 * @author MES
 * @since 2026-03-07
 */
@Controller
@RequestMapping("/imes/pop")
public class Pop55aController extends BaseController {

    @Autowired
    private Pop55aService service;

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
     * NAM공정 NG파일배포 확인 화면 오픈
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return JSP 뷰 경로
     */
    @RequestMapping(value = "/pop55a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/pop/pop55a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * Grid1 메인 조회 - NG파일배포 제품 목록 (POP55A_SER)
     * <p>
     * QUERY22: 제품별 NG파일 확인 상태, NAM 공정 여부, MC번호 포함
     * </p>
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop55a/POP55A_SER.json")
    public String pop55aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.pop55aSer(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * Grid2 상세 조회 - 선택 제품의 파일 목록 (POP55A_SER2)
     * <p>
     * QUERY23: 선택된 제품의 NG파일 목록 + 확인자/등록자 정보
     * </p>
     *
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop55a/POP55A_SER2.json")
    public String pop55aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.pop55aSer2(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 확인 저장 (POP55A_INS)
     * <p>
     * JS에서 JSON.stringify({ prodCode, workFlag, scomment, detailRows: [...] })로 전송하므로
     * @RequestBody로 JSON body를 파싱하여 세션 파라미터와 병합
     * </p>
     * <p>
     * 처리 흐름:
     * 1. TSHP_NG_FILE_WORK_MASTER UPSERT (SER→INS/UPD)
     * 2. detailRows 루프: TSHP_NG_FILE_WORK SER→INS (중복 방지)
     * </p>
     *
     * @param body JSON 요청 본문 (prodCode, workFlag, scomment, detailRows 포함)
     * @param request HTTP 요청 객체
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop55a/POP55A_INS.json")
    public String pop55aIns(@RequestBody Map<String, Object> body,
                            HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        ResultMap result = service.pop55aIns(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * cascade 삭제 (POP55A_UDE)
     * <p>
     * 처리 흐름 (cascade):
     * 1. TSHP_NG_FILE_CHK DEL (PROD_CODE 기반)
     * 2. TSHP_NG_FILE_WORK_MASTER DEL
     * 3. TSHP_NG_FILE_WORK DEL (PROD_CODE 기반)
     * </p>
     *
     * @param request HTTP 요청 객체 (prodCode 파라미터)
     * @param model 모델 객체
     * @return jsonView
     */
    @RequestMapping(value = "/pop55a/POP55A_UDE.json")
    public String pop55aUde(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        ResultMap result = service.pop55aUde(params);
        addObject(model, result);
        return "jsonView";
    }
}
