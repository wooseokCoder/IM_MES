/*
 * ============================================================================
 * FtpDownloadService.java
 * ============================================================================
 * 설명: FTP 파일 다운로드 공통 서비스 (Apache Commons Net FTPClient)
 *       TSYS_FILELIST_MASTER에서 파일 메타정보 조회 후 FTP 접속하여 파일 스트리밍
 *
 * 의존: commons-net-3.x.jar (WEB-INF/lib/)
 *       ※ 사용자가 라이브러리를 추가해야 합니다.
 *
 * 설정: TSYS_CONF 테이블 (세션에서 조회)
 *       - FTP_ADDRESS  : FTP 서버 주소 (165.244.33.234)
 *       - FTP_PORT     : FTP 포트 (7900)
 *       - FTP_USERID   : FTP 접속 ID (active)
 *       - FTP_PASSWORD : FTP 접속 PW (init00!!)
 * ============================================================================
 */
package com.wsc.imes.common;

import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;

/**
 * FTP 파일 다운로드 서비스 (Apache Commons Net FTPClient)
 *
 * TO-BE: SessionComponent.getSysConfig("FTP_*") 로 세션에서 FTP 접속 정보 조회
 *        CommonDao로 TSYS_FILELIST_MASTER 메타정보 조회
 *        Apache Commons Net FTPClient로 파일 스트리밍
 */
@Service
public class FtpDownloadService {

    private static final Log logger = LogFactory.getLog(FtpDownloadService.class);

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Autowired
    private CommonDao commonDao;

    // ========================================================================
    // Public API
    // ========================================================================

    /**
     * FTP 파일 다운로드
     *
     * FTP 경로 구조: /{pltCode}/{regDate(yyyy-MM-dd)}/{fileId}{extension}
     *
     * @param fileId   TSYS_FILELIST_MASTER.FILE_ID
     * @param pltCode  PLT_CODE (공장코드)
     * @param request  HttpServletRequest (User-Agent 파일명 인코딩)
     * @param response HttpServletResponse (파일 스트리밍 대상)
     */
    public void download(String fileId, String pltCode,
                         HttpServletRequest request,
                         HttpServletResponse response) throws Exception {

        // 1. 세션에서 FTP 설정 조회
        SessionComponent sc = sessionProvider.get();
        String ftpAddress  = sc.getSysConfig("FTP_ADDRESS");
        String ftpPortStr  = sc.getSysConfig("FTP_PORT");
        String ftpUserId   = sc.getSysConfig("FTP_USERID");
        String ftpPassword = sc.getSysConfig("FTP_PASSWORD");

        int ftpPort = 21;  // 기본 FTP 포트
        try {
            ftpPort = Integer.parseInt(ftpPortStr);
        } catch (Exception e) {
            logger.warn("FTP_PORT 파싱 실패, 기본값 21 사용: " + ftpPortStr);
        }

        // 2. TSYS_FILELIST_MASTER에서 파일 메타정보 조회
        ParamsMap params = new ParamsMap();
        params.put("gsPltCode", pltCode);
        params.put("fileId", fileId);

        RecordMap fileInfo = (RecordMap) commonDao.select(
            "com.wsc.imes.common.TSYS_FILELIST_MASTER.SER", params);

        if (fileInfo == null || fileInfo.isEmpty()) {
            throw new RuntimeException("파일 정보를 찾을 수 없습니다: " + fileId);
        }

        String fileName = fileInfo.getString("fileName");
        String regDate  = fileInfo.getString("regDate");  // yyyy-MM-dd 형식

        if (fileName == null || fileName.isEmpty()) {
            throw new RuntimeException("파일명이 없습니다.");
        }

        // 확장자 추출
        String extension = "";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = fileName.substring(dotIndex);  // ".jpg"
        }

        // FTP 경로: /{pltCode}/{regDate(yyyy-MM-dd)}/{fileId}{extension}
        // 예: /3603/2026-03-07/FILE001.jpg
        String ftpFilePath = "/" + pltCode + "/" + regDate + "/" + fileId + extension;

        logger.info("FTP 파일 다운로드 시작: " + ftpAddress + ":" + ftpPort + ftpFilePath);

        // 3. FTP 접속 및 파일 다운로드
        FTPClient ftpClient = new FTPClient();

        try {
            // FTP 연결
            ftpClient.connect(ftpAddress, ftpPort);
            boolean loginSuccess = ftpClient.login(ftpUserId, ftpPassword);

            if (!loginSuccess) {
                throw new RuntimeException("FTP 로그인 실패: " + ftpClient.getReplyString());
            }

            // Binary 모드 설정
            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

            // Passive 모드 설정 (방화벽 통과)
            ftpClient.enterLocalPassiveMode();

            // 파일 존재 여부 확인
            InputStream inputStream = ftpClient.retrieveFileStream(ftpFilePath);
            if (inputStream == null) {
                throw new RuntimeException("파일을 찾을 수 없습니다: " + fileName);
            }

            // 4. 응답 헤더 설정 (Content-Type, Content-Disposition)
            String contentType = getContentType(extension);
            response.setContentType(contentType);

            // 파일명 인코딩 (IE/non-IE 분기)
            String userAgent = request.getHeader("User-Agent");
            String downName = (userAgent != null && userAgent.indexOf("MSIE") == -1)
                    ? new String(fileName.getBytes("UTF-8"), "8859_1")
                    : URLEncoder.encode(fileName, "UTF-8");

            // Content-Disposition: inline (브라우저에서 직접 열기)
            response.setHeader("Content-Disposition",
                    "inline; filename=\"" + downName + "\"");
            response.setHeader("Content-Transfer-Encoding", "binary;");

            // 5. 파일 스트리밍
            byte[] buffer = new byte[4096];
            BufferedOutputStream out = new BufferedOutputStream(
                    response.getOutputStream());

            try {
                int read;
                while ((read = inputStream.read(buffer)) != -1) {
                    out.write(buffer, 0, read);
                }
                out.flush();
            } finally {
                if (inputStream != null) try { inputStream.close(); } catch (Exception ignore) {}
                if (out != null) try { out.close(); } catch (Exception ignore) {}
            }

            // FTP completePendingCommand 호출 (필수)
            ftpClient.completePendingCommand();

            logger.info("FTP 파일 다운로드 완료: " + fileName);

        } catch (Exception e) {
            logger.error("FTP 파일 다운로드 오류 [" + fileId + "]: " + e.getClass().getName() + " - " + e.getMessage(), e);
            throw e;
        } finally {
            // FTP 연결 종료
            if (ftpClient.isConnected()) {
                try {
                    ftpClient.logout();
                    ftpClient.disconnect();
                } catch (Exception ignore) {}
            }
        }
    }

    // ========================================================================
    // Private
    // ========================================================================

    /**
     * 파일 확장자 기반 Content-Type 반환
     *
     * @param extension 확장자 (예: ".jpg", ".pdf")
     * @return MIME 타입
     */
    private String getContentType(String extension) {
        if (extension == null) {
            return "application/octet-stream";
        }

        String ext = extension.toLowerCase();

        if (ext.equals(".jpg") || ext.equals(".jpeg")) {
            return "image/jpeg";
        } else if (ext.equals(".png")) {
            return "image/png";
        } else if (ext.equals(".gif")) {
            return "image/gif";
        } else if (ext.equals(".pdf")) {
            return "application/pdf";
        } else if (ext.equals(".doc")) {
            return "application/msword";
        } else if (ext.equals(".docx")) {
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        } else if (ext.equals(".xls")) {
            return "application/vnd.ms-excel";
        } else if (ext.equals(".xlsx")) {
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        } else if (ext.equals(".zip")) {
            return "application/zip";
        } else {
            return "application/octet-stream";
        }
    }
}
