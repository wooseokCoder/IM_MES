/*
 * ============================================================================
 * 화면명: QCT05A - 자주검사 그룹 관리
 * ============================================================================
 * 설명: 검사그룹 목록 조회, 등록, 수정
 *       검사그룹-검사항목 매핑 관리
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 공용 JSP
 *       D0A: 검사항목 추가 팝업
 * 작성일: 2026-03-04
 * ============================================================================
 */
package com.wsc.imes.qct;

import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
 * 자주검사 그룹 관리 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/qct")
public class Qct05aController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(Qct05aController.class);

    @Autowired
    private Qct05aService service;

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
     * 자주검사 그룹 관리 화면 오픈
     * 내부 탭(조립/가공)으로 전환
     */
    @RequestMapping(value = "/qct05a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/qct/qct05a";
    }

    /**
     * D0A 검사항목 추가 팝업 (href)
     */
    @RequestMapping(value = "/qct05a_d0a.do")
    public String openD0a(HttpServletRequest request, Model model) {
        return "imes/qct/qct05a_d0a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 검사그룹 목록 조회 (QCT05A_SER)
     */
    @RequestMapping(value = "/qct05a/QCT05A_SER.json")
    public String qct05aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct05aSer(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * 선택 그룹의 검사항목 조회 (QCT05A_SER2)
     */
    @RequestMapping(value = "/qct05a/QCT05A_SER2.json")
    public String qct05aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct05aSer2(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * D0A: 초기 로드 - 매핑 항목 + 미매핑 항목 (QCT05A_SER3)
     */
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/qct05a/QCT05A_SER3.json")
    public String qct05aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Map<String, Object> result = service.qct05aSer3(params);
        model.addAttribute("mappedRows", result.get("mappedRows"));
        model.addAttribute("unmappedRows", result.get("unmappedRows"));
        return "jsonView";
    }

    /**
     * D0A: 전체항목 검색 (QCT05A_SER4)
     */
    @RequestMapping(value = "/qct05a/QCT05A_SER4.json")
    public String qct05aSer4(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct05aSer4(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * 공정코드 콤보 조회 (QCT05A_PROC)
     */
    @RequestMapping(value = "/qct05a/QCT05A_PROC.json")
    public String qct05aProc(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct05aProc(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 검사그룹 저장 - UPSERT (QCT05A_INS)
     */
    @RequestMapping(value = "/qct05a/QCT05A_INS.json")
    public String qct05aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        ResultMap result = service.qct05aIns(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * D0A: 검사항목 매핑 저장 (QCT05A_INS2)
     */
    @RequestMapping(value = "/qct05a/QCT05A_INS2.json")
    public String qct05aIns2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        ResultMap result = service.qct05aIns2(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 검사항목 매핑 개별 삭제 (QCT05A_DEL)
     */
    @RequestMapping(value = "/qct05a/QCT05A_DEL.json")
    public String qct05aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        ResultMap result = service.qct05aDel(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 이미지
    // ========================================================================

    /**
     * 검사그룹 이미지 조회 - base64 JSON 응답 (QCT05A_IMG)
     */
    @RequestMapping(value = "/qct05a/QCT05A_IMG.json")
    public String qct05aImg(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        String base64 = service.qct05aImgBase64(params);
        if (base64 != null) {
            model.addAttribute("imgData", base64);
        }
        return "jsonView";
    }

    /**
     * 검사그룹 이미지 저장 (QCT05A_IMG_SAVE)
     */
    @RequestMapping(value = "/qct05a/QCT05A_IMG_SAVE.json")
    public String qct05aImgSave(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        ResultMap result = service.qct05aImgSave(params);
        addObject(model, result);
        return "jsonView";
    }

}
