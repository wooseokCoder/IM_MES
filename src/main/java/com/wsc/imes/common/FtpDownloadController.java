/*
 * ============================================================================
 * FtpDownloadController.java
 * ============================================================================
 * 설명: FTP 파일 다운로드 공통 컨트롤러
 *       URL: /imes/common/ftpFile/download.do?fileId=xxx&pltCode=xxx
 *       파일 메타정보는 TSYS_FILELIST_MASTER에서 조회
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
 * FTP 파일 다운로드 컨트롤러 (FTP 공통)
 */
@Controller
@RequestMapping("/imes/common")
public class FtpDownloadController extends BaseController {

    private static final Log logger = LogFactory.getLog(FtpDownloadController.class);

    @Autowired
    private FtpDownloadService ftpDownloadService;

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
     * FTP 파일 다운로드
     *
     * 파라미터:
     *   fileId  - TSYS_FILELIST_MASTER.FILE_ID
     *   pltCode - PLT_CODE (공장코드)
     *
     * 호출: JavaScript에서 직접 호출 (hidden iframe src 또는 window.open)
     *
     * 오류 처리:
     *   정상: Content-Disposition:inline 응답 → 브라우저에서 파일 뷰어 표시
     *   오류: parent._ftpDownloadError(msg) 스크립트 반환 → 현재 화면 유지 + 알림
     */
    @RequestMapping("/ftpFile/download.do")
    public void download(HttpServletRequest request, HttpServletResponse response) {
        String fileId = request.getParameter("fileId");
        String pltCode = request.getParameter("pltCode");

        if (fileId == null || fileId.trim().isEmpty()) {
            writeErrorScript(response, "파일 ID가 입력되지 않았습니다.");
            return;
        }

        if (pltCode == null || pltCode.trim().isEmpty()) {
            writeErrorScript(response, "공장 코드가 입력되지 않았습니다.");
            return;
        }

        try {
            ftpDownloadService.download(fileId.trim(), pltCode.trim(), request, response);
        } catch (Exception e) {
            logger.error("FTP 파일 다운로드 오류 [" + fileId + "]: " + e.getClass().getName() + " - " + e.getMessage(), e);
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
                "<script>if(parent&&parent._ftpDownloadError)"
                + "{parent._ftpDownloadError('" + message.replace("'", "\\'") + "');}</script>"
            );
        } catch (Exception ignore) {}
    }
}
