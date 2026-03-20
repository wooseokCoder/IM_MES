/*
 * ============================================================================
 * SmbDownloadService.java
 * ============================================================================
 * 설명: PLM 도면 파일 SMB 다운로드 공통 서비스 (smbj  SMB2-3)
 *       AS-IS: DRAW2D_FILE_DIR 네트워크 경로 접속 후 파일 스트리밍
 *
 * 의존: smbj-0.11.1.jar, asn-one-0.5.0.jar, mbassador-1.3.0.jar (WEB-INF/lib/)
 * 설정: TSYS_CONF 테이블 (세션에서 조회)
 *       - DRAW2D_FILE_DIR    : UNC 경로 (예: \\165.244.33.234\e\FTP\PLM\2)
 *       - DRAW2D_FILE_DIR_ID : 접속 ID (domain username)
 *       - DRAW2D_FILE_DIR_PW : 접속 PW
 * ============================================================================
 */
package com.wsc.imes.common;

import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.EnumSet;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hierynomus.msdtyp.AccessMask;
import com.hierynomus.mssmb2.SMB2CreateDisposition;
import com.hierynomus.mssmb2.SMB2Dialect;
import com.hierynomus.mssmb2.SMB2ShareAccess;
import com.hierynomus.smbj.SMBClient;
import com.hierynomus.smbj.SmbConfig;
import com.hierynomus.smbj.auth.AuthenticationContext;
import com.hierynomus.smbj.connection.Connection;
import com.hierynomus.smbj.session.Session;
import com.hierynomus.smbj.share.DiskShare;
import com.hierynomus.smbj.share.File;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.wsc.common.security.SessionComponent;

/**
 * PLM 도면 파일 SMB 다운로드 서비스 (smbj / SMB2-3)
 *
 * AS-IS: acInfo.SysConfig.GetSysConfigByMemory("DRAW2D_FILE_DIR") 로 접속 정보 조회
 *        IFModule로 네트워크 인증 후 파일 열기
 *
 * TO-BE: SessionComponent.getSysConfig("DRAW2D_FILE_DIR") 로 세션에서 조회
 *        smbj 라이브러리로 SMB2 파일 스트리밍
 */
@Service
public class SmbDownloadService {

    private static final Log logger = LogFactory.getLog(SmbDownloadService.class);

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    // ========================================================================
    // Public API
    // ========================================================================

    /**
     * PLM 도면 파일 다운로드
     *
     * AS-IS 경로 구조: DRAW2D_FILE_DIR \ PART_CODE \ FILE_NAME
     *
     * @param fileName IF_PLM_FILE_INFO.FILE_NAME
     * @param partCode 자재번호 (하위 폴더명)
     * @param request  HttpServletRequest (User-Agent 파일명 인코딩)
     * @param response HttpServletResponse (파일 스트리밍 대상)
     */
    public void download(String fileName, String partCode,
                         HttpServletRequest request,
                         HttpServletResponse response) throws Exception {

        // 세션에서 설정 조회 (AS-IS: acInfo.SysConfig.GetSysConfigByMemory)
        SessionComponent sc = sessionProvider.get();
        String drawDir  = sc.getSysConfig("DRAW2D_FILE_DIR");
        String drawId   = sc.getSysConfig("DRAW2D_FILE_DIR_ID");
        String drawPw   = sc.getSysConfig("DRAW2D_FILE_DIR_PW");

        // ID에서 domain username 분리
        String domain   = "";
        String username = drawId;
        if (drawId != null && drawId.contains("\\")) {
            String[] idParts = drawId.split("\\\\", 2);
            domain   = idParts[0];
            username = idParts[1];
        }
        String password = drawPw;

        // UNC 경로 파싱: \\host\share\sub\path → host, share, subPath
        String[] parsed = parseUncPath(drawDir);
        String host     = parsed[0];
        String share    = parsed[1];
        String subPath  = parsed[2];

        // 파일 전체 경로: subPath \ partCode \ fileName
        // AS-IS: DRAW2D_FILE_DIR \ PART_CODE \ FILE_NAME
        StringBuilder pathBuilder = new StringBuilder();
        if (!subPath.isEmpty()) {
            pathBuilder.append(subPath);
        }
        if (partCode != null && !partCode.trim().isEmpty()) {
            if (pathBuilder.length() > 0) pathBuilder.append("\\");
            pathBuilder.append(partCode.trim());
        }
        if (pathBuilder.length() > 0) pathBuilder.append("\\");
        pathBuilder.append(fileName);
        String filePath = pathBuilder.toString();

        logger.info("SMB 파일 다운로드 시작: \\\\" + host + "\\" + share + "\\" + filePath);

        // Java 8 JCE는 SMB3 키 파생(SP800-108 KDF) 미지원 → SMB2로 제한
        SmbConfig config = SmbConfig.builder()
                .withDialects(SMB2Dialect.SMB_2_0_2, SMB2Dialect.SMB_2_1)
                .build();
        SMBClient client = new SMBClient(config);
        Connection connection = null;
        Session session = null;
        DiskShare diskShare = null;
        File smbFile = null;

        try {
            connection = client.connect(host);
            AuthenticationContext ac = new AuthenticationContext(
                    username, password.toCharArray(), domain);
            session = connection.authenticate(ac);
            diskShare = (DiskShare) session.connectShare(share);

            if (!diskShare.fileExists(filePath)) {
                logger.warn("SMB 파일 없음: " + filePath);
                throw new RuntimeException("파일을 찾을 수 없습니다: " + fileName);
            }

            smbFile = diskShare.openFile(filePath,
                    EnumSet.of(AccessMask.GENERIC_READ),
                    null,
                    EnumSet.of(SMB2ShareAccess.FILE_SHARE_READ),
                    SMB2CreateDisposition.FILE_OPEN,
                    null);

            long fileSize = smbFile.getFileInformation().getStandardInformation().getEndOfFile();

            // 파일명 인코딩 (IE/non-IE 분기)
            String userAgent = request.getHeader("User-Agent");
            String downName = (userAgent != null && userAgent.indexOf("MSIE") == -1)
                    ? new String(fileName.getBytes("UTF-8"), "8859_1")
                    : URLEncoder.encode(fileName, "UTF-8");

            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + downName + "\"");
            response.setHeader("Content-Transfer-Encoding", "binary;");
            response.setContentLength((int) fileSize);

            byte[] buffer = new byte[4096];
            InputStream in = smbFile.getInputStream();
            BufferedOutputStream out = new BufferedOutputStream(
                    response.getOutputStream());

            try {
                int read;
                while ((read = in.read(buffer)) != -1) {
                    out.write(buffer, 0, read);
                }
                out.flush();
            } finally {
                if (in  != null) try { in.close();  } catch (Exception ignore) {}
                if (out != null) try { out.close(); } catch (Exception ignore) {}
            }

            logger.info("SMB 파일 다운로드 완료: " + fileName);

        } catch (Exception e) {
            logger.error("SMB 파일 다운로드 오류 [" + fileName + "]: " + e.getClass().getName() + " - " + e.getMessage(), e);
            throw e;
        } finally {
            if (smbFile   != null) try { smbFile.close();   } catch (Exception ignore) {}
            if (diskShare  != null) try { diskShare.close();  } catch (Exception ignore) {}
            if (session    != null) try { session.close();    } catch (Exception ignore) {}
            if (connection != null) try { connection.close(); } catch (Exception ignore) {}
            client.close();
        }
    }

    // ========================================================================
    // Private
    // ========================================================================

    /**
     * UNC 경로 파싱
     *
     * 입력: \\165.244.33.234\e\FTP\PLM\2
     * 출력: [0]="165.244.33.234", [1]="e", [2]="FTP\\PLM\\2"
     */
    private String[] parseUncPath(String uncPath) {
        String path = uncPath;
        // 앞의 \\ 제거
        while (path.startsWith("\\")) {
            path = path.substring(1);
        }
        // \ 기준 분리
        String[] parts = path.split("\\\\");

        String host = parts[0];
        String share = (parts.length > 1) ? parts[1] : "";
        StringBuilder subPath = new StringBuilder();
        for (int i = 2; i < parts.length; i++) {
            if (subPath.length() > 0) subPath.append("\\");
            subPath.append(parts[i]);
        }
        return new String[] { host, share, subPath.toString() };
    }
}
