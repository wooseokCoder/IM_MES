/*
 * ============================================================================
 * 화면명: QCT04A - 자주검사 항목 관리
 * ============================================================================
 * 설명: 검사항목 목록 조회, 등록, 수정, 삭제
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 화면 분리
 *       D1A: 검사그룹 관리 팝업
 * 작성일: 2026-02-27
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
import com.wsc.imes.common.UtilityService;

/**
 * 자주검사 항목 관리 서비스
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class Qct04aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Qct04aService.class);

    // Namespace 상수
    private static final String NS_TSTD_PROC_INS = "com.wsc.imes.qct.TSTD_PROC_INS";
    private static final String NS_TSTD_PROC_INS_QUERY = "com.wsc.imes.qct.TSTD_PROC_INS_QUERY";
    private static final String NS_TSTD_INS_GRP_LIST = "com.wsc.imes.qct.TSTD_INS_GRP_LIST";
    private static final String NS_TSTD_INS_GRP_LIST_QUERY = "com.wsc.imes.qct.TSTD_INS_GRP_LIST_QUERY";

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
    // QCT04A_SER: 검사항목 목록 조회
    // ========================================================================

    /**
     * 검사항목 목록 조회
     *
     * @param params plants (공장코드)
     * @return 목록 조회 결과
     */
    public Object qct04aSer(ParamsMap params) {
        logger.debug("QCT04A_SER: plants={}", params.get("plants"));

        return searchByMapper(NS_TSTD_PROC_INS_QUERY, "TSTD_PROC_INS_QUERY1", params);
    }

    // ========================================================================
    // QCT04A_INS: 검사항목 저장 (UPSERT) - 다건 처리
    // INS_CODE 빈값 → 채번 + INSERT, 있으면 → UPDATE
    // ========================================================================

    /**
     * 검사항목 저장 (UPSERT)
     *
     * @param params models (JSON 배열)
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap qct04aIns(ParamsMap params) {
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

                String insCode = (String) row.get("insCode");

                if (insCode == null || insCode.isEmpty()) {
                    // 신규: 채번 후 INSERT
                    String newInsCode = utilityService.getSerialNo(gsPltCode, "INS");
                    rowParams.put("insCode", newInsCode);
                    insertByMapper(NS_TSTD_PROC_INS, "TSTD_PROC_INS_INS", rowParams);
                    logger.debug("TSTD_PROC_INS_INS: insCode={}", newInsCode);
                } else {
                    // 기존: UPDATE
                    updateByMapper(NS_TSTD_PROC_INS, "TSTD_PROC_INS_UPD", rowParams);
                    logger.debug("TSTD_PROC_INS_UPD: insCode={}", insCode);
                }
                count++;
            }

            logger.info("QCT04A_INS 완료: {}건", count);
            return success(count + "건이 저장되었습니다.");

        } catch (Exception e) {
            logger.error("QCT04A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // QCT04A_DEL: 검사항목 삭제 (논리삭제)
    // ========================================================================

    /**
     * 검사항목 삭제
     *
     * @param params models (삭제 대상 행 목록)
     * @return 삭제 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap qct04aDel(ParamsMap params) {
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
                delParams.put("insCode", row.get("insCode"));
                delParams.put("gsUserId", params.get("gsUserId"));

                updateByMapper(NS_TSTD_PROC_INS, "TSTD_PROC_INS_UDE", delParams);
                count++;
            }

            logger.info("QCT04A_DEL 완료: {}건", count);
            return success(count + "건이 삭제되었습니다.");

        } catch (Exception e) {
            logger.error("QCT04A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // QCT04A_SER2: D1A 할당/미할당 그룹 조회
    // ========================================================================

    /**
     * D1A: 할당그룹 + 미할당그룹 조회
     *
     * @param params insCode (검사항목코드)
     * @return {assignedRows: [...], unassignedRows: [...]}
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> qct04aSer2(ParamsMap params) {
        logger.debug("QCT04A_SER2: insCode={}", params.get("insCode"));

        List<Map<String, Object>> assigned = (List<Map<String, Object>>) searchByMapper(
                NS_TSTD_INS_GRP_LIST_QUERY, "TSTD_INS_GRP_LIST_QUERY1", params);

        params.put("searchKeyword", "");
        List<Map<String, Object>> unassigned = (List<Map<String, Object>>) searchByMapper(
                NS_TSTD_INS_GRP_LIST_QUERY, "TSTD_INS_GRP_LIST_QUERY2", params);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("assignedRows", assigned);
        result.put("unassignedRows", unassigned);
        return result;
    }

    // ========================================================================
    // QCT04A_SER3: D1A 미할당 그룹 키워드 검색
    // ========================================================================

    /**
     * D1A: 미할당 그룹 키워드 검색
     *
     * @param params insCode, searchKeyword
     * @return 미할당 그룹 목록
     */
    public Object qct04aSer3(ParamsMap params) {
        logger.debug("QCT04A_SER3: insCode={}, keyword={}", params.get("insCode"), params.get("searchKeyword"));

        return searchByMapper(NS_TSTD_INS_GRP_LIST_QUERY, "TSTD_INS_GRP_LIST_QUERY2", params);
    }

    // ========================================================================
    // QCT04A_INS2: D1A 그룹 저장 (Delete-Insert)
    // ========================================================================

    /**
     * D1A: 그룹 저장 (기존 전부 삭제 → 선택 목록 재INSERT)
     *
     * @param params insCode, models (좌측 그리드 전체 행)
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap qct04aIns2(ParamsMap params) {
        try {
            String insCode = params.getString("insCode");
            String gsPltCode = params.getString("gsPltCode");
            String gsUserId = params.getString("gsUserId");

            // 1. 기존 연결 전체 삭제
            ParamsMap delParams = new ParamsMap();
            delParams.put("gsPltCode", gsPltCode);
            delParams.put("insCode", insCode);
            deleteByMapper(NS_TSTD_INS_GRP_LIST, "TSTD_INS_GRP_LIST_DEL3", delParams);

            // 2. 좌측 그리드 행 재INSERT
            JSONArray rows = (JSONArray) params.get("modelList");
            int count = 0;
            if (rows != null) {
                for (int i = 0; i < rows.size(); i++) {
                    JSONObject row = (JSONObject) rows.get(i);
                    ParamsMap insParams = new ParamsMap();
                    insParams.put("gsPltCode", gsPltCode);
                    insParams.put("insGrpCode", row.get("insGrpCode"));
                    insParams.put("insCode", insCode);
                    insParams.put("insSeq", i + 1);
                    insParams.put("gsUserId", gsUserId);

                    insertByMapper(NS_TSTD_INS_GRP_LIST, "TSTD_INS_GRP_LIST_INS", insParams);
                    count++;
                }
            }

            logger.info("QCT04A_INS2 완료: {}건", count);
            return success("저장되었습니다.");

        } catch (Exception e) {
            logger.error("QCT04A_INS2 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // QCT04A_IMG: 이미지 base64 조회
    // ========================================================================

    /**
     * 검사항목 이미지 base64 문자열 조회
     * SP 내부 TO_BASE64()로 변환 (RecordMap byte[]→String 자동변환 회피)
     *
     * @param params insCode (검사항목코드)
     * @return base64 문자열 (없으면 null)
     */
    @SuppressWarnings("unchecked")
    public String qct04aImgBase64(ParamsMap params) {
        Map<String, Object> result = (Map<String, Object>) selectByMapper(
                NS_TSTD_PROC_INS_QUERY, "TSTD_PROC_INS_IMG", params);
        if (result != null && result.get("insImgBase64") != null) {
            return result.get("insImgBase64").toString();
        }
        return null;
    }

    // ========================================================================
    // QCT04A_IMG_BATCH: 이미지 base64 일괄 조회
    // ========================================================================

    /**
     * 검사항목 이미지 썸네일 일괄 조회
     * 원본 이미지를 서버에서 썸네일(60px)로 축소 후 base64 반환
     * 원본 수백KB → 썸네일 2~5KB (성능 최적화)
     *
     * @param params insCodes (쉼표 구분 검사항목코드 목록)
     * @return [{insCode, insImgBase64(썸네일)}, ...]
     */
    @SuppressWarnings("unchecked")
    public Object qct04aImgBatch(ParamsMap params) {
        logger.debug("QCT04A_IMG_BATCH: insCodes={}", params.get("insCodes"));
        // SP에서 TO_BASE64로 반환한 결과를 그대로 전달 (썸네일 변환 제거 — heap 소진 방지)
        // 이미지 크기 제한은 클라이언트 CSS max-width로 처리
        return searchByMapper(
                NS_TSTD_PROC_INS_QUERY, "TSTD_PROC_INS_IMG_BATCH", params);
    }

    // ========================================================================
    // QCT04A_PROC: 공정코드 콤보 조회
    // ========================================================================

    /**
     * 공정코드 콤보박스 데이터 조회
     *
     * @param params lprocCode (ASSY 또는 PROC 필터)
     * @return 공정 목록
     */
    public Object qct04aProc(ParamsMap params) {
        logger.debug("QCT04A_PROC: lprocCode={}", params.get("lprocCode"));

        return searchByMapper(NS_TSTD_PROC_INS_QUERY, "LSE_STD_PROC_SER2", params);
    }

}
