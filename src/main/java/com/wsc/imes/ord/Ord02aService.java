/*
 * ============================================================================
 * 화면명: ORD02A - 이메일 수신자그룹 관리
 * ============================================================================
 * 설명: 수신자그룹/사원 조회, 등록, 수정, 삭제, 엑셀업로드
 * 작성자: 송우석
 * 작성일: 2026-02-10
 * ============================================================================
 */
package com.wsc.imes.ord;

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
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.imes.common.UtilityService;

/**
 * 이메일 수신자그룹 관리 서비스
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class Ord02aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Ord02aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_TORD_EMAIL_GROUP = "com.wsc.imes.ord.TORD_EMAIL_GROUP";
    private static final String NS_TORD_EMAIL_GROUP_QUERY = "com.wsc.imes.ord.TORD_EMAIL_GROUP_QUERY";
    private static final String NS_TORD_EMAIL_GROUP_EMP = "com.wsc.imes.ord.TORD_EMAIL_GROUP_EMP";
    private static final String NS_TORD_EMAIL_GROUP_EMP_QUERY = "com.wsc.imes.ord.TORD_EMAIL_GROUP_EMP_QUERY";
    private static final String NS_TSTD_EMPLOYEE = "com.wsc.imes.std.TSTD_EMPLOYEE";

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
    // ORD02A_SER: 수신자그룹 목록 조회
    // TORD_EMAIL_GROUP_QUERY1 호출, GROUP_TYPE='A' 고정
    // ========================================================================

    /**
     * 수신자그룹 목록 조회
     *
     * @param params gsPltCode (공장코드), groupType (그룹유형, 기본값 'A'), dataFlag (데이터상태)
     * @return 그룹 목록
     */
    public Object ord02aSer(ParamsMap params) {
        logger.debug("ORD02A_SER: gsPltCode={}", params.get("gsPltCode"));

        // 기본값 설정
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }
        if (params.get("groupType") == null) {
            params.put("groupType", "A");
        }

        return searchByMapper(NS_TORD_EMAIL_GROUP_QUERY, "TORD_EMAIL_GROUP_QUERY1", params);
    }

    // ========================================================================
    // ORD02A_SER2: 그룹별 사원 목록 조회
    // TORD_EMAIL_GROUP_EMP_QUERY1 호출
    // ========================================================================

    /**
     * 그룹별 사원 목록 조회
     *
     * @param params gsPltCode (공장코드), mcode (그룹코드), dataFlag (데이터상태)
     * @return 사원 목록
     */
    public Object ord02aSer2(ParamsMap params) {
        logger.debug("ORD02A_SER2: mcode={}", params.get("mcode"));

        // 기본값 설정
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_TORD_EMAIL_GROUP_EMP_QUERY, "TORD_EMAIL_GROUP_EMP_QUERY1", params);
    }

    // ========================================================================
    // ORD02A_INS: 수신자그룹 저장 (UPSERT) - 다건 처리
    // 로직: foreach row
    //   1. TORD_EMAIL_GROUP_SER로 존재 여부 확인
    //   2. 있으면 → UPD (수정)
    //   3. 없으면 → MCODE 채번 "EG" → INS (등록)
    //   4. 완료 후 그룹 목록 재조회 반환
    // ========================================================================

    /**
     * 수신자그룹 저장 (UPSERT) - 다건
     *
     * @param params modelList (그리드 수정 행 목록)
     * @return 저장 후 그룹 목록 재조회 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public Object ord02aIns(ParamsMap params) {
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

                String mcode = (String) row.get("mcode");

                // MCODE가 있으면 기존 데이터 → SER로 존재 확인
                if (mcode != null && !mcode.isEmpty()) {
                    RecordMap existing = (RecordMap) selectByMapper(
                            NS_TORD_EMAIL_GROUP, "TORD_EMAIL_GROUP_SER", rowParams);

                    if (existing != null && !existing.isEmpty()) {
                        // 존재 → UPDATE
                        updateByMapper(NS_TORD_EMAIL_GROUP, "TORD_EMAIL_GROUP_UPD", rowParams);
                        logger.debug("TORD_EMAIL_GROUP_UPD: mcode={}", mcode);
                    } else {
                        // MCODE가 있지만 DB에 없는 경우 (비정상) → INSERT
                        insertByMapper(NS_TORD_EMAIL_GROUP, "TORD_EMAIL_GROUP_INS", rowParams);
                        logger.debug("TORD_EMAIL_GROUP_INS (기존코드): mcode={}", mcode);
                    }
                } else {
                    // 신규 행: MCODE 채번
                    String newMcode = utilityService.getSerialNo(gsPltCode, "EG");
                    rowParams.put("mcode", newMcode);

                    insertByMapper(NS_TORD_EMAIL_GROUP, "TORD_EMAIL_GROUP_INS", rowParams);
                    logger.info("TORD_EMAIL_GROUP_INS: mcode={}", newMcode);
                }

                count++;
            }

            logger.info("ORD02A_INS 완료: {}건", count);

            // 저장 후 그룹 목록 재조회
            return ord02aSer(params);

        } catch (Exception e) {
            logger.error("ORD02A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // ORD02A_INS2: 사원 저장 (UPSERT) - 다건 처리
    // 로직: foreach row
    //   1. TORD_EMAIL_GROUP_EMP_SER로 존재 여부 확인
    //   2. 있으면 → UPD (수정)
    //   3. 없으면 → INS (등록)
    // ========================================================================

    /**
     * 사원 저장 (UPSERT) - 다건
     *
     * @param params modelList (그리드 수정 행 목록)
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord02aIns2(ParamsMap params) {
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

                // 존재 여부 확인
                RecordMap existing = (RecordMap) selectByMapper(
                        NS_TORD_EMAIL_GROUP_EMP, "TORD_EMAIL_GROUP_EMP_SER", rowParams);

                if (existing != null && !existing.isEmpty()) {
                    // 존재 → UPDATE
                    updateByMapper(NS_TORD_EMAIL_GROUP_EMP, "TORD_EMAIL_GROUP_EMP_UPD", rowParams);
                    logger.debug("TORD_EMAIL_GROUP_EMP_UPD: mcode={}, empCode={}",
                            row.get("mcode"), row.get("empCode"));
                } else {
                    // 미존재 → INSERT
                    insertByMapper(NS_TORD_EMAIL_GROUP_EMP, "TORD_EMAIL_GROUP_EMP_INS", rowParams);
                    logger.debug("TORD_EMAIL_GROUP_EMP_INS: mcode={}, empCode={}",
                            row.get("mcode"), row.get("empCode"));
                }

                count++;
            }

            logger.info("ORD02A_INS2 완료: {}건", count);

            return success(count + "건이 저장되었습니다.");

        } catch (Exception e) {
            logger.error("ORD02A_INS2 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // ORD02A_INS3: 엑셀업로드 저장 - 다건 처리
    // 로직: foreach row
    //   1. TORD_EMAIL_GROUP_SER2 → GROUP_NAME으로 MCODE 조회
    //   2. 그룹 미존재 → 에러
    //   3. TSTD_EMPLOYEE_SER → 사원코드 검증 (SYS_USER 기반)
    //   4. 사원 미존재 → 에러
    //   5. TORD_EMAIL_GROUP_EMP_SER → UPSERT (UPD 또는 INS)
    // ========================================================================

    /**
     * 엑셀업로드 저장 - 다건
     *
     * @param params modelList (엑셀 데이터 행 목록)
     * @return 저장 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord02aIns3(ParamsMap params) {
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
                rowParams.put("groupType", "A");

                // 1. GROUP_NAME으로 MCODE 조회
                RecordMap groupInfo = (RecordMap) selectByMapper(
                        NS_TORD_EMAIL_GROUP, "TORD_EMAIL_GROUP_SER2", rowParams);

                if (groupInfo == null || groupInfo.isEmpty()) {
                    return failure("[" + row.get("groupName") + "]의 그룹을 찾을 수 없습니다. 다시 확인하여 주십시오.");
                }

                // 2. 사원코드 검증
                RecordMap empInfo = (RecordMap) selectByMapper(
                        NS_TSTD_EMPLOYEE, "TSTD_EMPLOYEE_SER", rowParams);

                if (empInfo == null || empInfo.isEmpty()) {
                    return failure("[" + row.get("empCode") + "]의 사원을 찾을 수 없습니다. 다시 확인하여 주십시오.");
                }

                // 3. 그룹코드(MCODE) 설정
                rowParams.put("mcode", groupInfo.get("mcode"));

                // 4. UPSERT: 존재 여부 확인 후 UPD 또는 INS
                RecordMap existing = (RecordMap) selectByMapper(
                        NS_TORD_EMAIL_GROUP_EMP, "TORD_EMAIL_GROUP_EMP_SER", rowParams);

                if (existing != null && !existing.isEmpty()) {
                    // 덮어쓰기 체크된 행만 업데이트, 미체크 시 건너뜀
                    String overwrite = (String) row.get("overwrite");
                    if ("1".equals(overwrite)) {
                        updateByMapper(NS_TORD_EMAIL_GROUP_EMP, "TORD_EMAIL_GROUP_EMP_UPD", rowParams);
                        logger.debug("엑셀업로드 UPD: mcode={}, empCode={}",
                                groupInfo.get("mcode"), row.get("empCode"));
                        count++;
                    } else {
                        logger.debug("엑셀업로드 SKIP (덮어쓰기 미체크): mcode={}, empCode={}",
                                groupInfo.get("mcode"), row.get("empCode"));
                    }
                } else {
                    insertByMapper(NS_TORD_EMAIL_GROUP_EMP, "TORD_EMAIL_GROUP_EMP_INS", rowParams);
                    logger.debug("엑셀업로드 INS: mcode={}, empCode={}",
                            groupInfo.get("mcode"), row.get("empCode"));
                    count++;
                }
            }

            logger.info("ORD02A_INS3 완료: {}건", count);

            return success(count + "건이 저장되었습니다.");

        } catch (Exception e) {
            logger.error("ORD02A_INS3 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // ORD02A_DEL: 수신자그룹 삭제 (논리삭제) - 다건 처리
    // DATA_FLAG = 2로 설정
    // ========================================================================

    /**
     * 수신자그룹 삭제 - 다건
     *
     * @param params modelList (삭제 대상 행 목록)
     * @return 삭제 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord02aDel(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("삭제할 항목을 선택하세요.");
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

                updateByMapper(NS_TORD_EMAIL_GROUP, "TORD_EMAIL_GROUP_UDE", rowParams);
                count++;
            }

            logger.info("ORD02A_DEL 완료: {}건", count);

            return success(count + "건이 삭제되었습니다.");

        } catch (Exception e) {
            logger.error("ORD02A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // ORD02A_DEL2: 사원 삭제 (논리삭제) - 다건 처리
    // DATA_FLAG = 2로 설정
    // ========================================================================

    /**
     * 사원 삭제 - 다건
     *
     * @param params modelList (삭제 대상 행 목록)
     * @return 삭제 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord02aDel2(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("삭제할 항목을 선택하세요.");
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

                updateByMapper(NS_TORD_EMAIL_GROUP_EMP, "TORD_EMAIL_GROUP_EMP_UDE", rowParams);
                count++;
            }

            logger.info("ORD02A_DEL2 완료: {}건", count);

            return success(count + "건이 삭제되었습니다.");

        } catch (Exception e) {
            logger.error("ORD02A_DEL2 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

}
