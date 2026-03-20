/*
 * ============================================================================
 * 화면명: POP43A - 수리수선 이력관리
 * ============================================================================
 * 설명: 수리수선 이력 조회, 등록, 수정, 삭제
 * 원본: ProActive POP43A.cs, POP43A_M0A.cs, POP43A_D0A.cs
 *       TMCM_REPAIR.cs, TMCM_REPAIR_QUERY.cs
 * 작성일: 2026-03-11
 * ============================================================================
 */
package com.wsc.imes.pop;

import java.text.SimpleDateFormat;
import java.util.Date;
import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
 * 수리수선 이력관리 서비스
 *
 * 원본 ProActive 구조:
 * - POP43A.cs: 비즈니스 로직 (POP43A_SER, POP43A_INS, POP43A_DEL)
 * - TMCM_REPAIR.cs: 데이터 접근 (CRUD)
 * - TMCM_REPAIR_QUERY.cs: 조회 전용 (QUERY1 목록)
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Pop43aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Pop43aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_TMCM_REPAIR = "com.wsc.imes.pop.TMCM_REPAIR";
    private static final String NS_TMCM_REPAIR_QUERY = "com.wsc.imes.pop.TMCM_REPAIR_QUERY";

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
    // POP43A_SER: 수리수선 목록 조회
    // 원본: POP43A.POP43A_SER() → TMCM_REPAIR_QUERY.TMCM_REPAIR_QUERY1()
    // ========================================================================

    /**
     * 수리수선 목록 조회
     *
     * @param params sRepairDate, eRepairDate, repairVendorLike, repairMcLike
     * @return 목록 조회 결과
     */
    public Object pop43aSer(ParamsMap params) {
        logger.debug("POP43A_SER: sRepairDate={}, eRepairDate={}",
                params.get("sRepairDate"), params.get("eRepairDate"));

        // BIZ 고정값: dataFlag=0 (활성 데이터만 조회)
        params.put("dataFlag", 0);

        return searchByMapper(NS_TMCM_REPAIR_QUERY, "TMCM_REPAIR_QUERY1", params);
    }

    // ========================================================================
    // POP43A_INS: 수리수선 등록/수정 (UPSERT)
    // 원본: POP43A.POP43A_INS()
    // 로직:
    //   1. MCR_ID 존재 시 → UPDATE
    //   2. MCR_ID 없음 → 채번 후 INSERT
    // ========================================================================

    /**
     * 수리수선 등록/수정 (POP43A_INS)
     *
     * @param params 단건 데이터 (팝업에서 저장)
     * @return 저장 결과 (ResultMap)
     */
    @Transactional
    public ResultMap pop43aIns(ParamsMap params) {
        try {
            String mcrId = params.getString("mcrId");

            // 기존 레코드 확인
            if (mcrId != null && !mcrId.isEmpty()) {
                RecordMap existRecord = (RecordMap) selectByMapper(
                        NS_TMCM_REPAIR, "TMCM_REPAIR_SER", params);

                if (existRecord != null && !existRecord.isEmpty()) {
                    // UPDATE
                    updateByMapper(NS_TMCM_REPAIR, "TMCM_REPAIR_UPD", params);
                    logger.info("TMCM_REPAIR_UPD 완료: mcrId={}", mcrId);
                    return success("저장되었습니다.");
                }
            }

            // 신규 INSERT: MCR_ID 자동생성
            // AS-IS: UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "", YYYYMMDD, 4)
            // 결과: 20260311-0001
            String gsPltCode = params.getString("gsPltCode");
            String today = new SimpleDateFormat("yyyyMMdd").format(new Date());
            String newMcrId = utilityService.getSerialNo(gsPltCode, "", today, 4);
            params.put("mcrId", newMcrId);

            insertByMapper(NS_TMCM_REPAIR, "TMCM_REPAIR_INS", params);
            logger.info("TMCM_REPAIR_INS 완료: mcrId={}", newMcrId);
            return success("저장되었습니다.");

        } catch (Exception e) {
            logger.error("POP43A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP43A_DEL: 수리수선 삭제 (논리삭제, 다건)
    // 원본: POP43A.POP43A_DEL() → TMCM_REPAIR.TMCM_REPAIR_UDE()
    // ========================================================================

    /**
     * 수리수선 다건 삭제
     *
     * @param params models (JSON 문자열: [{pltCode, mcrId}, ...])
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap pop43aDel(ParamsMap params) {
        try {
            String modelsStr = params.getString("models");
            if (modelsStr == null || modelsStr.isEmpty()) {
                return failure("삭제할 항목을 선택하세요.");
            }

            JSONParser parser = new JSONParser();
            JSONArray models = (JSONArray) parser.parse(modelsStr);

            for (int i = 0; i < models.size(); i++) {
                JSONObject row = (JSONObject) models.get(i);

                ParamsMap rowParams = new ParamsMap();
                rowParams.put("gsPltCode", String.valueOf(row.get("pltCode")));
                rowParams.put("mcrId", String.valueOf(row.get("mcrId")));
                rowParams.put("gsUserId", params.getString("gsUserId"));

                updateByMapper(NS_TMCM_REPAIR, "TMCM_REPAIR_UDE", rowParams);
                logger.info("TMCM_REPAIR_UDE 완료: mcrId={}", row.get("mcrId"));
            }

            return success("삭제되었습니다.");

        } catch (Exception e) {
            logger.error("POP43A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

}
