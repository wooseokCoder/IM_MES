/*
 * ============================================================================
 * 화면명: QCT08A - 자주검사 현황
 * ============================================================================
 * 설명: 자주검사 결과 조회 전용 화면
 *       내부 탭으로 조립(PLANTS=1000) / 가공(PLANTS=2000) 구분
 *       QMS 전송 기능 포함
 * 작성일: 2026-03-17
 * ============================================================================
 */
package com.wsc.imes.qct;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

import java.util.Map;

/**
 * 자주검사 현황 컨트롤러
 *
 * @author 송우석
 * @version 1.1
 */
@Controller
@RequestMapping("/imes/qct")
public class Qct08aController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(Qct08aController.class);

    @Autowired
    private Qct08aService service;

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
     * 자주검사 현황 화면 오픈 (내부 탭: 조립/가공)
     */
    @RequestMapping(value = "/qct08a.do")
    public String view(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/qct/qct08a";
    }

    /**
     * 검사 이미지 팝업 (D0A)
     */
    @RequestMapping(value = "/qct08a_d0a.do")
    public String viewD0a(HttpServletRequest request, Model model) {
        return "imes/qct/qct08a_d0a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 조립 검사결과 조회 (QCT08A_SER) — 서버사이드 페이징
     */
    @RequestMapping(value = "/qct08a/QCT08A_SER.json")
    public String qct08aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Map<String, Object> result = service.qct08aSer(params);
        model.addAttribute("total", result.get("total"));
        model.addAttribute("rows", result.get("rows"));
        return "jsonView";
    }

    /**
     * 가공 검사결과 조회 (QCT08A_SER2) — 서버사이드 페이징
     */
    @RequestMapping(value = "/qct08a/QCT08A_SER2.json")
    public String qct08aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Map<String, Object> result = service.qct08aSer2(params);
        model.addAttribute("total", result.get("total"));
        model.addAttribute("rows", result.get("rows"));
        return "jsonView";
    }

    // ========================================================================
    // 공정 조회
    // ========================================================================

    /**
     * 공정코드 목록 조회 (QCT08A_PROC) - acProcForm용
     */
    @RequestMapping(value = "/qct08a/QCT08A_PROC.json")
    public String qct08aProc(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct08aProc(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 이미지
    // ========================================================================

    /**
     * 검사 이미지 바이너리 서빙 (QCT08A_IMG)
     */
    @RequestMapping(value = "/qct08a/QCT08A_IMG.json")
    public void qct08aImg(HttpServletRequest request, HttpServletResponse response) {
        java.io.OutputStream os = null;
        try {
            ParamsMap params = getParams(request);
            String base64 = service.qct08aImgBase64(params);
            if (base64 != null && base64.length() > 0) {
                base64 = base64.replaceAll("\\s", "");
                byte[] imgData = DatatypeConverter.parseBase64Binary(base64);
                base64 = null;
                response.setContentType("image/png");
                response.setContentLength(imgData.length);
                response.setHeader("Cache-Control", "max-age=86400");
                os = response.getOutputStream();
                os.write(imgData);
                os.flush();
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            logger.error("QCT08A_IMG 오류: {}", e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            if (os != null) {
                try { os.close(); } catch (Exception ignored) {}
            }
        }
    }

    // ========================================================================
    // QMS 전송
    // ========================================================================

    /**
     * QMS 전송 (QCT08A_UPD) - 조립
     */
    @RequestMapping(value = "/qct08a/QCT08A_UPD.json")
    public String qct08aUpd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct08aUpd(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * QMS 전송 (QCT08A_UPD2) - 가공
     */
    @RequestMapping(value = "/qct08a/QCT08A_UPD2.json")
    public String qct08aUpd2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct08aUpd2(params);
        addObject(model, result);
        return "jsonView";
    }

}
