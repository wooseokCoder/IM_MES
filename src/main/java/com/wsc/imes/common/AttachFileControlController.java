/*
 * ============================================================================
 * AttachFileControlController.java
 * ============================================================================
 * 설명: 파일 첨부 컨트롤 컨트롤러 (acAttachFileControl 웹 전환)
 *       원본: ProActive acAttachFileControl.cs
 *
 * 엔드포인트:
 *   GET  /imes/com/acAttachFile/ATTACH_FILE_SER.json         — 파일 목록 조회
 *   POST /imes/com/acAttachFile/ATTACH_FILE_UPD.json         — 파일 업로드 (multipart)
 *   POST /imes/com/acAttachFile/ATTACH_FILE_DEL.json         — 파일 삭제 (논리+물리)
 *   GET  /imes/com/acAttachFile/ATTACH_FILE_DOWN.do          — 파일 다운로드 (스트리밍)
 *   POST /imes/com/acAttachFile/ATTACH_FILE_RENAME.json      — 파일명 변경
 *   POST /imes/com/acAttachFile/ATTACH_FILE_ACC_LEVEL_UPD.json — 공개형태 변경
 *
 * 작성일: 2026-03-09
 * ============================================================================
 */
package com.wsc.imes.common;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.framework.utils.BaseUtils;

/**
 * 파일 첨부 컨트롤 컨트롤러
 */
@Controller
@RequestMapping("/imes/com/acAttachFile")
public class AttachFileControlController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(AttachFileControlController.class);

    @Autowired
    private AttachFileControlService service;

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
    // 파일 목록 조회
    // ========================================================================

    /**
     * LINK_KEY 에 연결된 파일 목록 조회
     * 원본: ATTACH_FILE_MASTER_SER → RSLTDT(활성) + RSLTDT2(삭제이력)
     *
     * 파라미터: uploadMenu, linkKey
     * 응답 구조:
     *   {
     *     total: N,  rows: [...],            ← Tab1 첨부파일목록 (활성)
     *     delHistory: { total: M, rows: [...] }  ← Tab3 삭제이력
     *   }
     */
    @RequestMapping(value = "/ATTACH_FILE_SER.json")
    public String attachFileSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        // Tab1: 활성 파일 목록 (DATA_FLAG=0)
        List<RecordMap> files = service.searchFileList(params);

        // Tab3: 삭제이력 (DATA_FLAG=2) — params 재사용(dataFlag 덮어쓰기 없음, 프로시저 내부에서 DATA_FLAG=2 고정)
        List<RecordMap> delHistory = service.searchDelHistoryList(params);

        // 활성 파일 목록은 기존 addObject 방식으로 반환 (rows/total 구조)
        addObject(model, files);

        // 삭제이력은 별도 키로 추가
        Map<String, Object> delMap = new HashMap<String, Object>();
        delMap.put("total", delHistory != null ? delHistory.size() : 0);
        delMap.put("rows",  delHistory);
        model.addAttribute("delHistory", delMap);

        return "jsonView";
    }

    // ========================================================================
    // 파일 업로드
    // ========================================================================

    /**
     * 파일 업로드 (Multipart POST)
     * 원본: ATTACH_FILE_MASTER_SER3
     *
     * 파라미터(form-data): uploadMenu, linkKey, accLevel, file(파일 바이너리)
     */
    @RequestMapping(method = RequestMethod.POST, value = "/ATTACH_FILE_UPD.json")
    @ResponseBody
    public ResponseEntity<String> attachFileUpd(
            MultipartHttpServletRequest request) throws IOException {

        ParamsMap params = getParams(request);

        RecordMap result = service.uploadFile(request, params);

        // EasyUI fileupload / IE9 대응 - ContentType text/html 반환
        return getResponseEntiry(result);
    }

    // ========================================================================
    // 파일 삭제
    // ========================================================================

    /**
     * 파일 삭제 (논리 삭제)
     * 원본: ATTACH_FILE_MASTER_SER4
     * ※ FILE_PATH 컬럼 없음 — DB 논리 삭제(DATA_FLAG=2)만 처리
     *
     * 파라미터: fileId, uploadMenu, linkKey
     */
    @RequestMapping(value = "/ATTACH_FILE_DEL.json")
    public String attachFileDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        try {
            service.deleteFile(params);
            ResultMap result = new ResultMap();
            result.put(ResultMap.SUCCESS, true);
            result.put(ResultMap.MESSAGE, "파일이 삭제되었습니다.");
            addObject(model, result);
        } catch (Exception e) {
            logger.error("파일 삭제 오류", e);
            ResultMap result = new ResultMap();
            result.put(ResultMap.SUCCESS, false);
            result.put(ResultMap.MESSAGE, "파일 삭제 중 오류가 발생했습니다: " + e.getMessage());
            addObject(model, result);
        }

        return "jsonView";
    }

    // ========================================================================
    // 파일명 변경 (이름 바꾸기)
    // ========================================================================

    /**
     * 파일명 변경
     * 원본: btnRename_ItemClick → ATTACH_FILE_MASTER_SER4 → inline cell edit
     *
     * 파라미터: fileId, fileName
     */
    @RequestMapping(value = "/ATTACH_FILE_RENAME.json")
    public String attachFileRename(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        try {
            service.renameFile(params);
            ResultMap result = new ResultMap();
            result.put(ResultMap.SUCCESS, true);
            result.put(ResultMap.MESSAGE, "파일명이 변경되었습니다.");
            addObject(model, result);
        } catch (Exception e) {
            logger.error("파일명 변경 오류", e);
            ResultMap result = new ResultMap();
            result.put(ResultMap.SUCCESS, false);
            result.put(ResultMap.MESSAGE, "파일명 변경 중 오류가 발생했습니다: " + e.getMessage());
            addObject(model, result);
        }

        return "jsonView";
    }

    // ========================================================================
    // 공개형태 변경
    // ========================================================================

    /**
     * 공개형태(ACC_LEVEL) 변경
     * 원본: AccLevelChange_ItemClick → ATTACH_FILE_MASTER_UPD2
     *
     * 파라미터: fileId, accLevel (PUBLIC / PRIVATE)
     */
    @RequestMapping(value = "/ATTACH_FILE_ACC_LEVEL_UPD.json")
    public String attachFileAccLevelUpd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        try {
            service.updateAccLevel(params);
            ResultMap result = new ResultMap();
            result.put(ResultMap.SUCCESS, true);
            result.put(ResultMap.MESSAGE, "공개형태가 변경되었습니다.");
            addObject(model, result);
        } catch (Exception e) {
            logger.error("공개형태 변경 오류", e);
            ResultMap result = new ResultMap();
            result.put(ResultMap.SUCCESS, false);
            result.put(ResultMap.MESSAGE, "공개형태 변경 중 오류가 발생했습니다: " + e.getMessage());
            addObject(model, result);
        }

        return "jsonView";
    }

    // ========================================================================
    // 파일 다운로드
    // ========================================================================

    /**
     * 파일 다운로드 (스트리밍)
     * 원본: ATTACH_FILE_MASTER_SER2 / DownloadFile()
     *
     * 파라미터: fileId, uploadMenu, linkKey
     */
    @RequestMapping(value = "/ATTACH_FILE_DOWN.do")
    public void attachFileDown(HttpServletRequest request, HttpServletResponse response) {
        ParamsMap params = getParams(request);

        RecordMap fileInfo = service.getFileInfo(params);
        if (fileInfo == null) {
            try {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("파일을 찾을 수 없습니다.");
            } catch (IOException e) {
                logger.error("응답 오류", e);
            }
            return;
        }

        // FILE_NAME = 원본 파일명 (표시용 / 다운로드 헤더에 사용)
        String fileName = (String) fileInfo.get("FILE_NAME");
        if (fileName == null || fileName.isEmpty()) {
            fileName = "download";
        }

        // ※ TSYS_FILELIST_MASTER 에 FILE_PATH 컬럼 없음
        //    물리 경로 재구성: {uploadRealPath}/ATTACH/{uploadMenu}/{safeDir}/{FILE_ID}.*
        //    TODO: 파일 저장 시 물리 경로 복원 가능하도록 설계 필요
        //          현재는 FILE_NAME 으로 404 응답만 처리
        try {
            response.setStatus(HttpServletResponse.SC_NOT_IMPLEMENTED);
            response.getWriter().write("다운로드 기능 준비 중입니다. (FILE_PATH 컬럼 부재)");
        } catch (IOException e) {
            logger.error("응답 오류", e);
        }
    }
}
