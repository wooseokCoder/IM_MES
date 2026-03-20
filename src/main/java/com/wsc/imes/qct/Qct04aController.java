/*
 * ============================================================================
 * 화면명: QCT04A - 자주검사 항목 관리
 * ============================================================================
 * 설명: 검사항목 목록 조회, 등록, 수정, 삭제
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 공용 JSP
 *       D1A: 검사그룹 관리 팝업
 * 작성일: 2026-02-27
 * ============================================================================
 */
package com.wsc.imes.qct;

import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

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
 * 자주검사 항목 관리 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/qct")
public class Qct04aController extends BaseController {

    @Autowired
    private Qct04aService service;

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
     * 자주검사 항목 관리 화면 오픈
     * 내부 탭(조립/가공)으로 전환
     */
    @RequestMapping(value = "/qct04a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/qct/qct04a";
    }

    /**
     * D1A 검사그룹 관리 팝업 (href)
     */
    @RequestMapping(value = "/qct04a_d1a.do")
    public String openD1a(HttpServletRequest request, Model model) {
        return "imes/qct/qct04a_d1a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 검사항목 목록 조회 (QCT04A_SER)
     */
    @RequestMapping(value = "/qct04a/QCT04A_SER.json")
    public String qct04aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct04aSer(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * D1A: 할당/미할당 그룹 조회 (QCT04A_SER2)
     */
    @RequestMapping(value = "/qct04a/QCT04A_SER2.json")
    public String qct04aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Map<String, Object> result = service.qct04aSer2(params);
        model.addAttribute("assignedRows", result.get("assignedRows"));
        model.addAttribute("unassignedRows", result.get("unassignedRows"));
        return "jsonView";
    }

    /**
     * D1A: 미할당 그룹 키워드 검색 (QCT04A_SER3)
     */
    @RequestMapping(value = "/qct04a/QCT04A_SER3.json")
    public String qct04aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct04aSer3(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * 공정코드 콤보 조회 (QCT04A_PROC)
     */
    @RequestMapping(value = "/qct04a/QCT04A_PROC.json")
    public String qct04aProc(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct04aProc(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    /**
     * 검사항목 저장 - UPSERT (QCT04A_INS)
     */
    @RequestMapping(value = "/qct04a/QCT04A_INS.json")
    public String qct04aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        ResultMap result = service.qct04aIns(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * D1A: 그룹 저장 (QCT04A_INS2)
     */
    @RequestMapping(value = "/qct04a/QCT04A_INS2.json")
    public String qct04aIns2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        ResultMap result = service.qct04aIns2(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    /**
     * 검사항목 삭제 (QCT04A_DEL)
     */
    @RequestMapping(value = "/qct04a/QCT04A_DEL.json")
    public String qct04aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        ResultMap result = service.qct04aDel(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 이미지
    // ========================================================================

    /**
     * 검사항목 이미지 base64 일괄 조회 (QCT04A_IMG_BATCH)
     * 그리드 로드 후 hasImg=1인 행들의 이미지를 1회 요청으로 조회
     */
    @RequestMapping(value = "/qct04a/QCT04A_IMG_BATCH.json")
    public String qct04aImgBatch(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct04aImgBatch(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * 검사항목 이미지 바이너리 서빙 (QCT04A_IMG) - 단건 (다운로드용)
     * SP에서 TO_BASE64로 반환 → base64 디코딩 → 바이너리 응답
     */
    @RequestMapping(value = "/qct04a/QCT04A_IMG.json")
    public void qct04aImg(HttpServletRequest request, HttpServletResponse response) {
        java.io.OutputStream os = null;
        try {
            ParamsMap params = getParams(request);
            String base64 = service.qct04aImgBase64(params);
            if (base64 != null && base64.length() > 0) {
                base64 = base64.replaceAll("\\s", "");  // TO_BASE64 줄바꿈 제거
                byte[] imgData = DatatypeConverter.parseBase64Binary(base64);
                base64 = null; // GC 대상으로 즉시 전환
                response.setContentType("image/png");
                response.setContentLength(imgData.length);
                response.setHeader("Cache-Control", "no-cache, no-store");
                os = response.getOutputStream();
                os.write(imgData);
                os.flush();
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            if (os != null) {
                try { os.close(); } catch (Exception ignored) {}
            }
        }
    }

}
