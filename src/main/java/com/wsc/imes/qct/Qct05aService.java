/*
 * ============================================================================
 * 화면명: QCT05A - 자주검사 그룹 관리
 * ============================================================================
 * 설명: 검사그룹 CRUD, 검사항목 매핑 관리
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 공통 서비스
 *       D0A: 검사항목 추가 (좌우 이동) 로직
 * 작성일: 2026-03-04
 * ============================================================================
 */
package com.wsc.imes.qct;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;
import javax.xml.bind.DatatypeConverter;

import com.wsc.imes.common.UtilityService;

/**
 * 자주검사 그룹 관리 서비스
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class Qct05aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Qct05aService.class);

    private static final String NS_TSTD_INS_GRP = "com.wsc.imes.qct.TSTD_INS_GRP";
    private static final String NS_TSTD_INS_GRP_QUERY = "com.wsc.imes.qct.TSTD_INS_GRP_QUERY";
    private static final String NS_PROC_INS_QUERY = "com.wsc.imes.qct.TSTD_PROC_INS_QUERY";

    @Autowired
    private CommonDao dao;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Autowired
    private UtilityService utilityService;

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
        return this.sessionProvider.get();
    }

    // ========================================================================
    // QCT05A_SER: 검사그룹 목록 조회
    // ========================================================================

    /**
     * 검사그룹 목록 조회 (PLANTS별)
     */
    public Object qct05aSer(ParamsMap params) {
        logger.debug("QCT05A_SER: plants={}", params.get("plants"));
        return searchByMapper(NS_TSTD_INS_GRP, "TSTD_INS_GRP_SER2", params);
    }

    // ========================================================================
    // QCT05A_SER2: 선택 그룹의 검사항목 조회 (디테일)
    // ========================================================================

    /**
     * 선택된 검사그룹의 연결 검사항목 목록 조회
     */
    public Object qct05aSer2(ParamsMap params) {
        logger.debug("QCT05A_SER2: insGrpCode={}", params.get("insGrpCode"));
        return searchByMapper(NS_TSTD_INS_GRP_QUERY, "TSTD_INS_GRP_LIST_SER", params);
    }

    // ========================================================================
    // QCT05A_SER3: D0A 초기 로드 (매핑 + 미매핑)
    // ========================================================================

    /**
     * D0A: 매핑된 항목 + 미매핑 항목 동시 조회
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> qct05aSer3(ParamsMap params) {
        logger.debug("QCT05A_SER3: insGrpCode={}", params.get("insGrpCode"));

        List<Map<String, Object>> mapped = (List<Map<String, Object>>) searchByMapper(
                NS_TSTD_INS_GRP_QUERY, "TSTD_INS_GRP_LIST_SER", params);

        List<Map<String, Object>> unmapped = (List<Map<String, Object>>) searchByMapper(
                NS_TSTD_INS_GRP_QUERY, "TSTD_PROC_INS_SER2", params);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("mappedRows", mapped);
        result.put("unmappedRows", unmapped);
        return result;
    }

    // ========================================================================
    // QCT05A_SER4: D0A 전체항목 검색
    // ========================================================================

    /**
     * D0A: 전체 검사항목 검색 (공정/키워드)
     */
    public Object qct05aSer4(ParamsMap params) {
        logger.debug("QCT05A_SER4: procCode={}, searchLike={}", params.get("procCode"), params.get("searchLike"));
        return searchByMapper(NS_TSTD_INS_GRP_QUERY, "TSTD_PROC_INS_D0A_SEARCH", params);
    }

    // ========================================================================
    // QCT05A_PROC: 공정코드 콤보 조회
    // ========================================================================

    /**
     * 공정코드 콤보박스 데이터 조회
     *
     * @param params lprocCode (ASSY 또는 PROC 필터)
     * @return 공정 목록
     */
    public Object qct05aProc(ParamsMap params) {
        logger.debug("QCT05A_PROC: lprocCode={}", params.get("lprocCode"));
        return searchByMapper(NS_PROC_INS_QUERY, "LSE_STD_PROC_SER2", params);
    }

    // ========================================================================
    // QCT05A_INS: 검사그룹 저장 (UPSERT)
    // ========================================================================

    /**
     * 검사그룹 저장 (INS_GRP_CODE 빈값=신규 채번+INSERT, 있으면=UPDATE)
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap qct05aIns(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("저장할 데이터가 없습니다.");
            }

            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");
            int count = 0;

            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                ParamsMap rowParams = new ParamsMap();
                rowParams.putAll(row);
                rowParams.put("gsPltCode", gsPltCode);
                rowParams.put("gsUserId", gsUserId);
                rowParams.put("plants", params.get("plants"));

                String insGrpCode = (String) row.get("insGrpCode");

                if (insGrpCode == null || insGrpCode.isEmpty()) {
                    String newCode = utilityService.getSerialNo(gsPltCode, "INSGRP");
                    rowParams.put("insGrpCode", newCode);
                    insertByMapper(NS_TSTD_INS_GRP, "TSTD_INS_GRP_INS", rowParams);
                    logger.debug("TSTD_INS_GRP_INS: insGrpCode={}", newCode);
                } else {
                    updateByMapper(NS_TSTD_INS_GRP, "TSTD_INS_GRP_UPD", rowParams);
                    logger.debug("TSTD_INS_GRP_UPD: insGrpCode={}", insGrpCode);
                }
                count++;
            }

            logger.info("QCT05A_INS 완료: {}건", count);
            return success(count + "건이 저장되었습니다.");

        } catch (Exception e) {
            logger.error("QCT05A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // QCT05A_INS2: D0A 검사항목 매핑 저장 (Delete-Insert)
    // ========================================================================

    /**
     * D0A: 검사항목 매핑 저장 (기존 전부 삭제 → 좌측 그리드 전체 재INSERT)
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap qct05aIns2(ParamsMap params) {
        try {
            String insGrpCode = params.getString("insGrpCode");
            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");

            // 1. 기존 매핑 전체 삭제
            ParamsMap delParams = new ParamsMap();
            delParams.put("gsPltCode", gsPltCode);
            delParams.put("insGrpCode", insGrpCode);
            deleteByMapper(NS_TSTD_INS_GRP_QUERY, "TSTD_INS_GRP_LIST_DEL2", delParams);

            // 2. 좌측 그리드 행 재INSERT
            JSONArray rows = (JSONArray) params.get("modelList");
            int count = 0;
            if (rows != null) {
                for (int i = 0; i < rows.size(); i++) {
                    JSONObject row = (JSONObject) rows.get(i);
                    ParamsMap insParams = new ParamsMap();
                    insParams.put("gsPltCode", gsPltCode);
                    insParams.put("insGrpCode", insGrpCode);
                    insParams.put("insCode", row.get("insCode"));

                    Object insSeqObj = row.get("insSeq");
                    int insSeq = i + 1;
                    if (insSeqObj != null) {
                        try {
                            insSeq = Integer.parseInt(insSeqObj.toString());
                        } catch (NumberFormatException ex) {
                            insSeq = i + 1;
                        }
                    }
                    insParams.put("insSeq", insSeq);
                    insParams.put("gsUserId", gsUserId);

                    insertByMapper(NS_TSTD_INS_GRP_QUERY, "TSTD_INS_GRP_LIST_INS2", insParams);
                    count++;
                }
            }

            logger.info("QCT05A_INS2 완료: {}건", count);
            return success("저장되었습니다.");

        } catch (Exception e) {
            logger.error("QCT05A_INS2 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // QCT05A_DEL: 검사항목 매핑 개별 삭제
    // ========================================================================

    /**
     * 디테일 그리드에서 선택 항목 매핑 삭제
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap qct05aDel(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("삭제할 항목을 선택하세요.");
            }

            int count = 0;
            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                ParamsMap delParams = new ParamsMap();
                delParams.put("gsPltCode", params.get("gsPltCode"));
                delParams.put("insGrpCode", row.get("insGrpCode"));
                delParams.put("insCode", row.get("insCode"));

                deleteByMapper(NS_TSTD_INS_GRP_QUERY, "TSTD_INS_GRP_LIST_DEL", delParams);
                count++;
            }

            logger.info("QCT05A_DEL 완료: {}건", count);
            return success(count + "건이 삭제되었습니다.");

        } catch (Exception e) {
            logger.error("QCT05A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // QCT05A_IMG: 이미지 바이너리 조회
    // ========================================================================

    /**
     * 검사그룹 이미지 바이너리 조회
     */
    /**
     * 검사그룹 이미지 base64 문자열 조회 (프로시저에서 TO_BASE64로 반환)
     */
    @SuppressWarnings("unchecked")
    public String qct05aImgBase64(ParamsMap params) {
        Map<String, Object> result = (Map<String, Object>) selectByMapper(
                NS_TSTD_INS_GRP, "TSTD_INS_GRP_IMG_SER", params);
        if (result != null && result.get("insImgBase64") != null) {
            return result.get("insImgBase64").toString();
        }
        return null;
    }

    // ========================================================================
    // QCT05A_IMG_SAVE: 이미지 저장 (base64 → BLOB)
    // ========================================================================

    /**
     * 검사그룹 이미지 저장 (클라이언트 base64 → 서버 byte[] → DB BLOB)
     */
    @Transactional
    public ResultMap qct05aImgSave(ParamsMap params) {
        try {
            String insGrpCode = params.getString("insGrpCode");
            String base64Data = params.getString("imgData");

            if (insGrpCode == null || insGrpCode.isEmpty()) {
                return failure("검사그룹코드가 없습니다.");
            }

            // 이미지 데이터가 비어있으면 null 저장 (이미지 삭제 — AS-IS 동일)
            byte[] imgBytes = null;
            if (base64Data != null && !base64Data.isEmpty()) {
                base64Data = base64Data.replaceAll("\\s", "");
                imgBytes = DatatypeConverter.parseBase64Binary(base64Data);
                base64Data = null;
            }

            ParamsMap updParams = new ParamsMap();
            updParams.put("gsPltCode", params.get("gsPltCode"));
            updParams.put("insGrpCode", insGrpCode);
            updParams.put("insImg", imgBytes);
            updParams.put("gsUserId", params.get("gsUserId"));

            updateByMapper(NS_TSTD_INS_GRP, "TSTD_INS_GRP_UPD2", updParams);

            String msg = (imgBytes != null) ? "이미지가 저장되었습니다." : "이미지가 삭제되었습니다.";
            logger.info("QCT05A_IMG_SAVE 완료: insGrpCode={}", insGrpCode);
            return success(msg);

        } catch (Exception e) {
            logger.error("QCT05A_IMG_SAVE 실패", e);
            return failure("이미지 저장 실패: " + e.getMessage());
        }
    }

}
