/*
 * ============================================================================
 * AttachFileControlService.java
 * ============================================================================
 * 설명: 파일 첨부 컨트롤 서비스 (acAttachFileControl 웹 전환)
 *       원본: ProActive acAttachFileControl.cs
 *             - LINK_KEY 기준으로 TSYS_FILELIST_MASTER에 파일 목록 관리
 *
 * DB 테이블: TSYS_FILELIST_MASTER
 *   FILE_ID     = 채번된 파일 식별자 (FL + yyMMdd + - + ####)
 *   LINK_KEY    = 트리 노드 CODE (공정그룹 코드)
 *   UPLOAD_MENU = 'STD47A' 등 화면 구분
 *   FILE_NAME   = 원본 파일명 (표시용)
 *
 * 파일 저장 경로: ${file.upload.real}/ATTACH/{UPLOAD_MENU}/{safeDir}/{yyyyMMdd}_{uuid}.{ext}
 * ※ FILE_PATH 컬럼 없음 — 물리 경로는 서비스 내부에서 FILE_ID 기반 재구성
 *
 * 작성일: 2026-03-09
 * ============================================================================
 */
package com.wsc.imes.common;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.utils.FileUtils;

/**
 * 파일 첨부 컨트롤 서비스
 * acAttachFileControl.cs 웹 전환 대응
 */
@Service
public class AttachFileControlService extends BaseService {

    // ========================================================================
    // MyBatis 매퍼 네임스페이스
    // ========================================================================
    private static final String NS = "com.wsc.imes.sys.TSYS_FILELIST_MASTER_QUERY";

    /** 파일 업로드 실제 경로 (app.properties: file.upload.real) */
    @Value("${file.upload.real}")
    private String uploadRealPath;

    @Autowired
    private CommonDao dao;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Override
    protected BaseDao getDao() {
        return this.dao;
    }

    @Override
    protected MessageSource getMessageSource() {
        return this.messageSource;
    }

    @Override
    protected SessionComponent getSessionComponent() {
        return sessionProvider.get();
    }

    // ========================================================================
    // 파일 목록 조회
    // ========================================================================

    /**
     * LINK_KEY 에 연결된 파일 목록 조회 (활성 파일, DATA_FLAG=0)
     * 원본: ATTACH_FILE_MASTER_SER / GetList() → RSLTDT
     *
     * @param params gsPltCode, uploadMenu, linkKey 포함
     * @return 파일 목록 RecordMap 리스트
     */
    @SuppressWarnings("unchecked")
    public List<RecordMap> searchFileList(ParamsMap params) {
        params.put("dataFlag", 0);
        return (List<RecordMap>) searchByMapper(NS, "ATTACH_FILE_SER", params);
    }

    /**
     * LINK_KEY 에 연결된 삭제이력 조회 (DATA_FLAG=2)
     * 원본: TSYS_FILELIST_MASTER_QUERY3 → WHERE DATA_FLAG=2
     *       ATTACH_FILE_MASTER_SER / RefreshFile() → RSLTDT2 (FileDelHistoryGridView)
     *
     * @param params gsPltCode, uploadMenu, linkKey 포함
     * @return 삭제이력 RecordMap 리스트
     */
    @SuppressWarnings("unchecked")
    public List<RecordMap> searchDelHistoryList(ParamsMap params) {
        return (List<RecordMap>) searchByMapper(NS, "ATTACH_FILE_DEL_HISTORY_SER", params);
    }

    // ========================================================================
    // 파일 업로드
    // ========================================================================

    /**
     * 파일 업로드 처리
     * 원본: ATTACH_FILE_MASTER_SER3 / UploadFile()
     *   1) 물리 파일을 서버에 저장
     *   2) TSYS_FILELIST_MASTER에 메타 정보 INSERT
     *
     * @param request  MultipartHttpServletRequest
     * @param params   getParams(request) 로 구성된 ParamsMap (gsPltCode, gsUserId, uploadMenu, linkKey, accLevel 포함)
     * @return 업로드된 파일의 RecordMap
     * @throws IOException 파일 저장 오류
     */
    @Transactional
    public RecordMap uploadFile(MultipartHttpServletRequest request, ParamsMap params) throws IOException {
        String pltCode   = params.getString("gsPltCode");
        String userId    = params.getString("gsUserId");
        String uploadMenu = params.getString("uploadMenu");
        String linkKey   = params.getString("linkKey");
        String accLevel  = params.getString("accLevel");
        if (BaseUtils.empty(accLevel)) accLevel = "PUBLIC";

        // 다음 FILE_SEQ 조회
        int nextSeq = getNextFileSeq(pltCode, uploadMenu, linkKey);

        // Multipart 파일 처리
        Iterator<String> iter = request.getFileNames();
        if (!iter.hasNext()) {
            throw new IOException("업로드할 파일이 없습니다.");
        }

        MultipartFile mpf = request.getFile(iter.next());
        if (mpf == null || mpf.isEmpty()) {
            throw new IOException("업로드 파일이 비어있습니다.");
        }

        String originalName = mpf.getOriginalFilename();
        // FILE_NAME = 원본 파일명 그대로 사용
        // 서버 저장명은 UUID 기반으로 생성하여 충돌 방지
        String ext = FileUtils.getFileExtension(originalName != null ? originalName : "").toLowerCase();
        String saveName = BaseUtils.formatCurDate("yyyyMMdd") + "_" + UUID.randomUUID().toString()
                        + (ext.isEmpty() ? "" : "." + ext);

        // 저장 디렉토리: {uploadRealPath}/ATTACH/{uploadMenu}/{safeDir}/
        String safeDir = sanitizePath(linkKey);
        String dirPath = uploadRealPath
                       + File.separator + "ATTACH"
                       + File.separator + (BaseUtils.empty(uploadMenu) ? "COMMON" : uploadMenu)
                       + File.separator + safeDir;

        FileUtils.mkdirs(dirPath);

        String physicalPath = dirPath + File.separator + saveName;
        mpf.transferTo(new File(physicalPath));

        // DB INSERT
        // ※ FILE_PATH 컬럼 없음 — filePath 파라미터 제거
        ParamsMap insertParams = new ParamsMap();
        insertParams.put("gsPltCode",   pltCode);
        insertParams.put("gsUserId",    userId);
        insertParams.put("uploadMenu",  uploadMenu);
        insertParams.put("linkKey",     linkKey);
        insertParams.put("fileName",    originalName != null ? originalName : saveName);
        insertParams.put("fileSize",    mpf.getSize());
        insertParams.put("fileSeq",     nextSeq);
        insertParams.put("accLevel",    accLevel);
        insertParams.put("dataFlag",    0);
        insertParams.put("fileId",      null);   // OUT 파라미터 (FL + yyMMdd + - + ####)

        insertByMapper(NS, "ATTACH_FILE_INS", insertParams);

        // 결과 반환
        RecordMap result = new RecordMap();
        result.put("FILE_ID",     insertParams.get("fileId"));
        result.put("FILE_SEQ",    nextSeq);
        result.put("FILE_NAME",   originalName != null ? originalName : saveName);
        result.put("FILE_SIZE",   mpf.getSize());
        result.put("ACC_LEVEL",   accLevel);
        result.put("LINK_KEY",    linkKey);
        result.put("UPLOAD_MENU", uploadMenu);
        return result;
    }

    // ========================================================================
    // 파일 삭제
    // ========================================================================

    /**
     * 파일 논리 삭제
     * 원본: ATTACH_FILE_MASTER_SER4 / DeleteFile()
     * ※ FILE_PATH 컬럼 없음 — DB 논리 삭제(DATA_FLAG=2)만 처리
     *
     * @param params gsPltCode, gsUserId, fileId 포함
     */
    @Transactional
    public void deleteFile(ParamsMap params) {
        // 논리 삭제 (DATA_FLAG = 2, DEL_EMP/DEL_DATE 기록)
        updateByMapper(NS, "ATTACH_FILE_DEL", params);
    }

    // ========================================================================
    // 파일명 변경 (이름 바꾸기)
    // ========================================================================

    /**
     * 파일명 변경 (이름 바꾸기)
     * 원본: btnRename_ItemClick → ATTACH_FILE_MASTER_SER4 → inline cell edit
     *
     * @param params gsPltCode, gsUserId, fileNo, fileName 포함
     */
    @Transactional
    public void renameFile(ParamsMap params) {
        updateByMapper(NS, "ATTACH_FILE_RENAME", params);
    }

    // ========================================================================
    // 공개형태 변경
    // ========================================================================

    /**
     * 선택 파일의 공개형태(ACC_LEVEL) 변경
     * 원본: AccLevelChange_ItemClick → ATTACH_FILE_MASTER_UPD2
     *
     * @param params gsPltCode, gsUserId, fileNo, accLevel 포함
     */
    @Transactional
    public void updateAccLevel(ParamsMap params) {
        updateByMapper(NS, "ATTACH_FILE_ACC_LEVEL_UPD", params);
    }

    // ========================================================================
    // 파일 단건 조회 (다운로드용)
    // ========================================================================

    /**
     * FILE_ID 로 파일 정보 단건 조회
     * 컨트롤러에서 스트리밍 처리에 사용
     *
     * @param params gsPltCode, uploadMenu, linkKey, fileId 포함
     * @return RecordMap (FILE_NAME 등) 또는 null
     */
    @SuppressWarnings("unchecked")
    public RecordMap getFileInfo(ParamsMap params) {
        params.put("dataFlag", 0);

        List<RecordMap> list = (List<RecordMap>) searchByMapper(NS, "ATTACH_FILE_SER", params);
        if (list == null || list.isEmpty()) return null;

        String fileId = params.getString("fileId");
        for (RecordMap row : list) {
            Object id = row.get("FILE_ID");
            if (id != null && id.toString().equals(fileId)) {
                return row;
            }
        }
        return null;
    }

    // ========================================================================
    // 내부 유틸리티
    // ========================================================================

    /**
     * 다음 FILE_SEQ 조회 (MAX+1)
     */
    private int getNextFileSeq(String pltCode, String uploadMenu, String linkKey) {
        ParamsMap p = new ParamsMap();
        p.put("gsPltCode",  pltCode);
        p.put("uploadMenu", uploadMenu);
        p.put("linkKey",    linkKey);
        p.put("nextSeq",    1);

        try {
            searchByMapper(NS, "ATTACH_FILE_GET_SEQ", p);
            Object nextSeq = p.get("nextSeq");
            if (nextSeq != null) {
                return Integer.parseInt(nextSeq.toString());
            }
        } catch (Exception e) {
            // 조회 실패 시 기본값 1 반환
        }
        return 1;
    }

    /**
     * 파일 경로에 사용할 수 없는 특수문자 치환 (디렉토리명 안전화)
     * 원본: SQL REPLACE 함수와 동일한 규칙
     */
    private String sanitizePath(String value) {
        if (value == null) return "_";
        return value
            .replace(" ", "_")
            .replace(".", "_")
            .replace("(", "_")
            .replace(")", "_")
            .replace("/", "_")
            .replace(",", "_")
            .replace(":", "_")
            .replace(";", "_")
            .replace("\\", "_");
    }
}
