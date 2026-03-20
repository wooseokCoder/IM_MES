/*
 * ============================================================================
 * 화면명: STD44A - 모델군 관리
 * ============================================================================
 * 설명: 모델군 목록 조회, 등록, 수정, 삭제
 *       TSTD_MODEL 테이블 단일 사용, DATA_TYPE(B/M/S)로 계층 구분
 * 작성자: 송우석
 * 작성일: 2026-02-20
 * ============================================================================
 */
package com.wsc.imes.std;

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
 * 모델군 관리 서비스
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class Std44aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std44aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_TSTD_MODEL = "com.wsc.imes.std.TSTD_MODEL";
    private static final String NS_TSTD_MODEL_QUERY = "com.wsc.imes.std.TSTD_MODEL_QUERY";

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
    // STD44A_SER: 모델군 목록 조회
    // ========================================================================

    /**
     * 모델군 목록 조회
     *
     * @param params dataType (B/M/S), pScode (부모 SCODE)
     * @return 목록 조회 결과
     */
    public Object std44aSer(ParamsMap params) {
        logger.debug("STD44A_SER: dataType={}, pScode={}",
                params.get("dataType"), params.get("pScode"));

        // 기본값 설정 (DATA_FLAG=0)
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_TSTD_MODEL_QUERY, "TSTD_MODEL_QUERY1", params);
    }

    // ========================================================================
    // STD44A_INS: 모델군 저장 (UPSERT) - 다건 처리
    // AS-IS 로직:
    //   foreach row:
    //     1. DATA_TYPE에 따라 SER_B/SER_M/SER_S 중복 체크
    //     2. 존재 시 → UPD_B/UPD_M/UPD_S 수정
    //     3. 미존재 시 → SCODE 채번 후 INS 등록
    // ========================================================================

    /**
     * 모델군 저장 - UPSERT (STD44A_INS)
     *
     * @param params models (JSON 배열), dataType (B/M/S)
     * @return 저장 결과
     */
    @Transactional
    public ResultMap std44aIns(ParamsMap params) {
        try {
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("저장할 데이터가 없습니다.");
            }

            String dataType = params.getString("dataType");
            int count = 0;

            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                ParamsMap rowParams = new ParamsMap();
                rowParams.putAll(row);
                rowParams.put("gsPltCode", params.get("gsPltCode"));
                rowParams.put("gsUserId", params.get("gsUserId"));
                rowParams.put("dataType", dataType);

                processUpsert(rowParams, dataType);
                count++;
            }

            logger.info("STD44A_INS 완료: {}건 (dataType={})", count, dataType);
            return success(count + "건이 저장되었습니다.");

        } catch (Exception e) {
            logger.error("STD44A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    /**
     * 단건 UPSERT 처리 (내부 메서드)
     *
     * 1. DATA_TYPE에 따라 SER_B/M/S 중복 체크
     * 2. 존재 → UPD_B/M/S 수정
     * 3. 미존재 → SCODE 채번 후 INS 등록
     */
    private void processUpsert(ParamsMap params, String dataType) {
        RecordMap exist = null;

        // 1. DATA_TYPE별 중복 체크
        if ("B".equals(dataType)) {
            exist = (RecordMap) selectByMapper(NS_TSTD_MODEL, "TSTD_MODEL_SER_B", params);
        } else if ("M".equals(dataType)) {
            exist = (RecordMap) selectByMapper(NS_TSTD_MODEL, "TSTD_MODEL_SER_M", params);
        } else if ("S".equals(dataType)) {
            exist = (RecordMap) selectByMapper(NS_TSTD_MODEL, "TSTD_MODEL_SER_S", params);
        }

        if (exist != null && !exist.isEmpty()) {
            // 2. 존재 → 수정
            if ("B".equals(dataType)) {
                updateByMapper(NS_TSTD_MODEL, "TSTD_MODEL_UPD_B", params);
                logger.debug("TSTD_MODEL_UPD_B: modelType={}", params.get("modelType"));
            } else if ("M".equals(dataType)) {
                updateByMapper(NS_TSTD_MODEL, "TSTD_MODEL_UPD_M", params);
                logger.debug("TSTD_MODEL_UPD_M: modelType={}, modelSerise={}",
                        params.get("modelType"), params.get("modelSerise"));
            } else if ("S".equals(dataType)) {
                updateByMapper(NS_TSTD_MODEL, "TSTD_MODEL_UPD_S", params);
                logger.debug("TSTD_MODEL_UPD_S: modelNo={}", params.get("modelNo"));
            }
        } else {
            // 3. 미존재 → SCODE 채번 후 등록
            String gsPltCode = params.getString("gsPltCode");
            String newScode = utilityService.getSerialNo(gsPltCode, "S");
            params.put("scode", newScode);

            insertByMapper(NS_TSTD_MODEL, "TSTD_MODEL_INS", params);
            logger.info("TSTD_MODEL_INS: scode={}, dataType={}", newScode, dataType);
        }
    }

    // ========================================================================
    // STD44A_DEL: 모델군 삭제 (논리삭제)
    // ========================================================================

    /**
     * 모델군 삭제 - 논리삭제 (DATA_FLAG=2)
     *
     * @param params scode (삭제 대상 SCODE)
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap std44aDel(ParamsMap params) {
        try {
            String scode = params.getString("scode");
            if (scode == null || scode.isEmpty()) {
                return failure("삭제할 항목을 선택하세요.");
            }

            updateByMapper(NS_TSTD_MODEL, "TSTD_MODEL_UDE", params);
            logger.info("STD44A_DEL 완료: scode={}", scode);

            return success("삭제되었습니다.");

        } catch (Exception e) {
            logger.error("STD44A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

}
