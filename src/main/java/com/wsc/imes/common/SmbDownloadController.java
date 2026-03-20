/*
 * ============================================================================
 * SmbDownloadController.java
 * ============================================================================
 * 설명: PLM 도면 파일 SMB 다운로드 공통 컨트롤러
 *       URL: /imes/common/smbFile/download.do?fileName=xxx
 *       acFileForm.js의 선택 버튼 클릭 시 호출
 * ============================================================================
 */
package com.wsc.imes.common;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;

/**
 * PLM 도면 파일 다운로드 컨트롤러 (SMB 공통)
 */
@Controller
@RequestMapping("/imes/common")
public class SmbDownloadController extends BaseController {

    private static final Log logger = LogFactory.getLog(SmbDownloadController.class);

    @Autowired
    private SmbDownloadService smbDownloadService;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Override
    protected BaseService getService() {
        return null;  // DB 조회 없음
    }

    @Override
    protected SessionComponent getSessionComponent() {
        return this.sessionProvider.get();
    }

    // ========================================================================
    // 다운로드
    // ========================================================================

    /**
     * PLM 도면 파일 다운로드 (SMB)
     *
     * 파라미터:
     *   fileName - IF_PLM_FILE_INFO.FILE_NAME
     *   partCode - 자재번호 (하위 폴더명)
     *
     * 호출: acFileForm.js _doSelect → hidden iframe src
     *
     * 오류 처리:
     *   정상: Content-Disposition:attachment 응답 → 브라우저 저장 다이얼로그
     *   오류: parent._smbDownloadError(msg) 스크립트 반환 → 현재 화면 유지 + 알림
     */
    @RequestMapping("/smbFile/download.do")
    public void download(HttpServletRequest request, HttpServletResponse response) {
        String fileName = request.getParameter("fileName");
        String partCode = request.getParameter("partCode");

        if (fileName == null || fileName.trim().isEmpty()) {
            writeErrorScript(response, "파일명이 입력되지 않았습니다.");
            return;
        }

        try {
            smbDownloadService.download(fileName.trim(), partCode, request, response);
        } catch (Exception e) {
            logger.error("SMB 파일 다운로드 오류 [" + fileName + "]: " + e.getClass().getName() + " - " + e.getMessage(), e);
            writeErrorScript(response, "파일 다운로드 중 오류가 발생했습니다.");
        }
    }

    /**
     * 숨겨진 iframe → 부모 창 에러 핸들러 호출 스크립트 응답
     * 서버 오류 시 현재 화면 유지 + 사용자 알림
     */
    private void writeErrorScript(HttpServletResponse response, String message) {
        try {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(
                "<script>if(parent&&parent._smbDownloadError)"
                + "{parent._smbDownloadError('" + message.replace("'", "\\'") + "');}</script>"
            );
        } catch (Exception ignore) {}
    }
}
