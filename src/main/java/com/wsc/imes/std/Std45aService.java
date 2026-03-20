/*
 * ============================================================================
 * 화면명: STD45A - 비가동코드 관리
 * ============================================================================
 * 설명: 비가동코드 목록 조회, 등록, 수정, 삭제
 * 원본: ProActive STD45A.cs, STD45A_M0A.cs, STD45A_D0A.cs
 *       TSTD_IDLECODE.cs, TSTD_IDLECODE_QUERY.cs
 * 작성일: 2026-02-05
 * ============================================================================
 */
package com.wsc.imes.std;

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
 * 비가동코드 관리 서비스
 *
 * 원본 ProActive 구조:
 * - STD45A.cs: 비즈니스 로직 (STD45A_SER, STD45A_INS, STD45A_UPD, STD45A_DEL)
 * - TSTD_IDLECODE.cs: 데이터 접근 (CRUD)
 * - TSTD_IDLECODE_QUERY.cs: 조회 전용 (QUERY1)
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - STD45A_SER → std45aSer
 * - STD45A_INS → std45aIns
 * - STD45A_UPD → std45aUpd
 * - STD45A_DEL → std45aDel
 *
 * @author MES
 * @version 2.0
 */
@Service
public class Std45aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std45aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_TSTD_IDLECODE = "com.wsc.imes.std.TSTD_IDLECODE";
    private static final String NS_TSTD_IDLECODE_QUERY = "com.wsc.imes.std.TSTD_IDLECODE_QUERY";

    @Autowired
    private CommonDao dao;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    // AS-IS: UTIL.UTILITY_GET_SERIALNO 공통 채번 서비스
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
    // STD45A_SER: 비가동코드 목록 조회
    // 원본: STD45A.STD45A_SER() → TSTD_IDLECODE_QUERY.TSTD_IDLECODE_QUERY1()
    // ========================================================================

    /**
     * 비가동코드 목록 조회
     *
     * @param params plants (공장), idleLike (검색어), dataFlag (데이터상태)
     * @return 목록 조회 결과
     */
    public Object std45aSer(ParamsMap params) {
        logger.debug("STD45A_SER: plants={}, idleLike={}",
                params.get("plants"), params.get("idleLike"));

        // 기본값 설정
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_TSTD_IDLECODE_QUERY, "TSTD_IDLECODE_QUERY1", params);
    }

    // ========================================================================
    // STD45A_INS: 비가동코드 신규/수정 (UPSERT) - 다건 처리
    // 원본: STD45A.STD45A_INS()
    // 로직: foreach (DataRow row in paramDS.Tables["RQSTDT"].Rows)
    //       1. TSTD_IDLECODE_SER로 존재 여부 확인
    //       2. 있으면 TSTD_IDLECODE_UPD (수정)
    //       3. 없으면 SCODE 자동생성 후 TSTD_IDLECODE_INS (등록)
    //       4. return STD45A_SER (저장 후 목록 재조회)
    // ========================================================================

    /**
     * 비가동코드 신규/수정 - UPSERT (STD45A_INS)
     * AS-IS: STD45A.STD45A_INS()
     *
     * OVERWRITE 처리:
     * - IDLE_CODE 중복 (DATA_FLAG=0): errorCode=DUPLICATE 반환
     * - IDLE_CODE 삭제됨 (DATA_FLAG=2): errorCode=DELETED 반환 + 삭제이력
     * - overwrite=1 전달 시: 기존 레코드 덮어쓰기 (복원)
     *
     * @param params 단건 데이터 (팝업에서 저장)
     * @return 저장 결과 (ResultMap)
     */
    @Transactional
    public ResultMap std45aIns(ParamsMap params) {
        try {
            return processUpsert(params);
        } catch (Exception e) {
            logger.error("STD45A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    /**
     * 단건 UPSERT 처리 (내부 메서드)
     * AS-IS 로직:
     * 1. SCODE 있으면 → UPDATE (수정)
     * 2. SCODE 없으면 → IDLE_CODE 중복 체크
     *    - 중복(DATA_FLAG=0) & overwrite!=1 → 에러 100001 (DUPLICATE)
     *    - 삭제(DATA_FLAG=2) & overwrite!=1 → 에러 100002 (DELETED)
     *    - overwrite=1 → 기존 레코드 UPDATE (복원/덮어쓰기)
     *    - 신규 → SCODE 생성 후 INSERT
     */
    private ResultMap processUpsert(ParamsMap params) {
        String scode = params.getString("scode");
        String overwrite = params.getString("overwrite");


        // EDIT 모드: SCODE가 있으면 바로 UPDATE
        if (scode != null && !scode.isEmpty()) {
            updateByMapper(NS_TSTD_IDLECODE, "TSTD_IDLECODE_UPD", params);
            logger.debug("TSTD_IDLECODE_UPD 완료: scode={}", scode);
            return success("저장되었습니다.");
        }

        // NEW 모드: IDLE_CODE 중복 체크 (AS-IS: TSTD_IDLECODE_SER3)
        RecordMap existByCode = (RecordMap) selectByMapper(
                NS_TSTD_IDLECODE, "TSTD_IDLECODE_SER3", params);

        if (existByCode != null && !existByCode.isEmpty()) {
            String dataFlag = String.valueOf(existByCode.get("dataFlag"));

            if (!"1".equals(overwrite)) {
                // OVERWRITE 미요청 → 에러 반환
                if ("0".equals(dataFlag)) {
                    // AS-IS: 에러 100001 (중복)
                    ResultMap result = failure("이미 존재하는 MES코드입니다. 덮어쓰시겠습니까?");
                    result.put("errorCode", "DUPLICATE");
                    logger.debug("IDLE_CODE 중복: idleCode={}", params.get("idleCode"));
                    return result;

                } else if ("2".equals(dataFlag)) {
                    // AS-IS: 에러 100002 (삭제됨) → 삭제이력 포함
                    ResultMap result = failure("삭제된 MES코드입니다. 복원하시겠습니까?");
                    result.put("errorCode", "DELETED");

                    // 삭제이력 조회 (SER 프로시저에서 DEL_DATE, DEL_EMP 반환)
                    ParamsMap serParams = new ParamsMap();
                    serParams.put("gsPltCode", params.get("gsPltCode"));
                    serParams.put("scode", existByCode.get("scode"));
                    RecordMap fullRecord = (RecordMap) selectByMapper(
                            NS_TSTD_IDLECODE, "TSTD_IDLECODE_SER", serParams);
                    if (fullRecord != null) {
                        result.put("delDate", fullRecord.get("delDate"));
                        result.put("delEmp", fullRecord.get("delEmp"));
                    }

                    logger.debug("IDLE_CODE 삭제됨: idleCode={}", params.get("idleCode"));
                    return result;
                }
            }

            // OVERWRITE 요청 → 기존 레코드 UPDATE (복원/덮어쓰기)
            params.put("scode", existByCode.get("scode"));
            updateByMapper(NS_TSTD_IDLECODE, "TSTD_IDLECODE_UPD", params);
            logger.info("OVERWRITE 완료: scode={}, idleCode={}",
                    existByCode.get("scode"), params.get("idleCode"));
            return success("저장되었습니다.");
        }

        // 신규 INSERT: SCODE 자동생성
        String gsPltCode = params.getString("gsPltCode");
        String newScode = utilityService.getSerialNo(gsPltCode, "S");
        params.put("scode", newScode);

        insertByMapper(NS_TSTD_IDLECODE, "TSTD_IDLECODE_INS", params);
        logger.info("TSTD_IDLECODE_INS 완료: scode={}, idleCode={}",
                newScode, params.get("idleCode"));
        return success("저장되었습니다.");
    }

    // ========================================================================
    // STD45A_UPD: 비가동코드 그리드 일괄 수정
    // 원본: STD45A.STD45A_UPD() → TSTD_IDLECODE.TSTD_IDLECODE_UPD2()
    // 그리드에서 수정된 행들의 일부 필드만 업데이트
    // (USE_FLAG, IDLE_SEQ, IS_NG, IS_SAP, IS_RPT, IS_MCT_SCOMMENT)
    // ========================================================================

    /**
     * 비가동코드 그리드 일괄 수정
     *
     * @param params rows (수정 대상 행 목록)
     * @return 저장 결과
     */
    @Transactional
    public ResultMap std45aUpd(ParamsMap params) {
        try {
            // 프레임워크 models 패턴: JS에서 models=JSON.stringify(rows)로 전송
            // → getParams()에서 자동 파싱 → params.get("modelList")로 접근
            JSONArray rows = (JSONArray) params.get("modelList");

            if (rows == null || rows.size() == 0) {
                return failure("저장할 데이터가 없습니다.");
            }

            int count = 0;
            for (int i = 0; i < rows.size(); i++) {
                JSONObject row = (JSONObject) rows.get(i);
                ParamsMap rowParams = new ParamsMap();
                rowParams.putAll(row);
                rowParams.put("gsPltCode", params.get("gsPltCode"));
                rowParams.put("gsUserId", params.get("gsUserId"));

                // TSTD_IDLECODE_UPD2 호출
                updateByMapper(NS_TSTD_IDLECODE, "TSTD_IDLECODE_UPD2", rowParams);
                count++;
            }

            logger.info("STD45A_UPD 완료: {}건", count);

            return success(count + "건이 저장되었습니다.");

        } catch (Exception e) {
            logger.error("STD45A_UPD 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // STD45A_DEL: 비가동코드 삭제 (논리삭제)
    // 원본: STD45A.STD45A_DEL() → TSTD_IDLECODE.TSTD_IDLECODE_UDE()
    // DATA_FLAG = 2로 설정 (논리 삭제)
    // ========================================================================

    /**
     * 비가동코드 삭제
     *
     * @param params scodes (삭제 대상 SCODE 목록) 또는 scode (단건)
     * @return 삭제 결과
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap std45aDel(ParamsMap params) {
        try {
            List<String> scodes = (List<String>) params.get("scodes");

            if (scodes == null || scodes.isEmpty()) {
                // 단건 삭제 시도
                String scode = params.getString("scode");
                if (scode != null && !scode.isEmpty()) {
                    updateByMapper(NS_TSTD_IDLECODE, "TSTD_IDLECODE_UDE", params);
                    logger.info("STD45A_DEL 완료: scode={}", scode);
                    return success("삭제되었습니다.");
                }
                return failure("삭제할 항목을 선택하세요.");
            }

            // 다건 삭제
            int count = 0;
            for (String scode : scodes) {
                ParamsMap delParams = new ParamsMap();
                delParams.put("gsPltCode", params.get("gsPltCode"));
                delParams.put("scode", scode);
                delParams.put("gsUserId", params.get("gsUserId"));

                updateByMapper(NS_TSTD_IDLECODE, "TSTD_IDLECODE_UDE", delParams);
                count++;
            }

            logger.info("STD45A_DEL 완료: {}건", count);

            return success(count + "건이 삭제되었습니다.");

        } catch (Exception e) {
            logger.error("STD45A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

}
