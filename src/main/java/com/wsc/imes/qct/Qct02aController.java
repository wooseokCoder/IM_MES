/*
 * ============================================================================
 * 화면명: QCT02A - 부적합/결품 현황
 * ============================================================================
 * 설명: 부적합/결품 데이터 조회 전용 화면
 *       내부 탭으로 조립(PLANTS=3603) / 가공(PLANTS=3605) 구분
 *       D0A: 사진보기 팝업 (이미지 4개)
 * 작성일: 2026-03-09
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

/**
 * 부적합/결품 현황 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/qct")
public class Qct02aController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(Qct02aController.class);

    @Autowired
    private Qct02aService service;

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
     * 부적합/결품 현황 화면 오픈 (내부 탭: 조립/가공)
     */
    @RequestMapping(value = "/qct02a.do")
    public String view(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/qct/qct02a";
    }

    /**
     * D0A 사진보기 팝업
     */
    @RequestMapping(value = "/qct02a_d0a.do")
    public String openD0a(HttpServletRequest request, Model model) {
        return "imes/qct/qct02a_d0a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 부적합/결품 목록 조회 (QCT02A_SER)
     */
    @RequestMapping(value = "/qct02a/QCT02A_SER.json")
    public String qct02aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct02aSer(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * 공정코드 목록 조회 (QCT02A_PROC)
     */
    @RequestMapping(value = "/qct02a/QCT02A_PROC.json")
    public String qct02aProc(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.qct02aProc(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 이미지
    // ========================================================================

    /**
     * 부적합 사진 바이너리 서빙 (QCT02A_IMG)
     * imgNo 파라미터(1~4)에 해당하는 이미지를 바이너리로 응답
     */
    @RequestMapping(value = "/qct02a/QCT02A_IMG.json")
    public void qct02aImg(HttpServletRequest request, HttpServletResponse response) {
        java.io.OutputStream os = null;
        try {
            ParamsMap params = getParams(request);
            String base64 = service.qct02aImgBase64(params);
            if (base64 != null && base64.length() > 0) {
                /* MySQL TO_BASE64()는 76자마다 줄바꿈을 삽입 — 제거 후 디코딩 */
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
            logger.error("QCT02A_IMG 오류: {}", e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            if (os != null) {
                try { os.close(); } catch (Exception ignored) {}
            }
        }
    }

}
