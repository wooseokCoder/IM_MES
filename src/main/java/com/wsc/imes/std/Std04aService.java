/*
 * ============================================================================
 * 화면명: STD04A - 표준 자원 관리
 * ============================================================================
 * 설명: 설비(자원) 목록 조회, 등록, 수정, 삭제, 가용사원 관리
 * 작성자: 송우석
 * 작성일: 2026-02-23
 * ============================================================================
 */
package com.wsc.imes.std;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

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

/**
 * 표준 자원 관리 서비스
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class Std04aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std04aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_LSE_MACHINE = "com.wsc.imes.std.LSE_MACHINE";
    private static final String NS_LSE_MACHINE_QUERY = "com.wsc.imes.std.LSE_MACHINE_QUERY";
    private static final String NS_LSE_MC_WORKTIME = "com.wsc.imes.std.LSE_MC_WORKTIME";
    private static final String NS_TSTD_MC_AVAILEMP = "com.wsc.imes.std.TSTD_MC_AVAILEMP";
    private static final String NS_TSTD_MC_AVAILEMP_QUERY = "com.wsc.imes.std.TSTD_MC_AVAILEMP_QUERY";
    private static final String NS_LSE_STD_AVAILMC = "com.wsc.imes.std.LSE_STD_AVAILMC";
    private static final String NS_LSE_STD_PROC_QUERY = "com.wsc.imes.std.LSE_STD_PROC_QUERY";
    private static final String NS_EMP_SEARCH = "com.wsc.common.board.EmpSearch";

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
        return this.sessionProvider.get();
    }

    // ========================================================================
    // STD04A_SER: 설비 목록 조회
    // ========================================================================

    /**
     * 설비 목록 조회
     *
     * @param params mcLike (검색어)
     * @return 목록 조회 결과
     */
    public Object std04aSer(ParamsMap params) {
        logger.debug("STD04A_SER: mcLike={}", params.get("mcLike"));
        return searchByMapper(NS_LSE_MACHINE_QUERY, "LSE_MACHINE_QUERY3", params);
    }

    // ========================================================================
    // STD04A_INS: 설비 등록/수정 (UPSERT + 가용사원 교체)
    // 로직:
    // 1. LSE_MACHINE_SER로 MC_CODE 존재 여부 확인
    // 2. 존재 + OVERWRITE!=1 + DATA_FLAG=2 → 에러 100002 (삭제됨)
    // 3. 존재 + OVERWRITE!=1 → 에러 100001 (중복)
    // 4. 존재 + OVERWRITE=1 → LSE_MACHINE_UPD
    // 5. 미존재 → LSE_MACHINE_INS + 기본 작업시간 생성 (1440분)
    // 6. 가용사원 교체: TSTD_MC_AVAILEMP_DEL + INS (다건)
    // ========================================================================

    /**
     * 설비 등록/수정 (UPSERT)
     *
     * @param params 설비 데이터 + models (가용사원 JSON배열)
     * @return 저장 결과
     */
    @Transactional
    public ResultMap std04aIns(ParamsMap params) {
        try {
            return processUpsert(params);
        } catch (Exception e) {
            logger.error("STD04A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    /**
     * UPSERT 처리 (내부 메서드)
     */
    private ResultMap processUpsert(ParamsMap params) {
        String mcCode = params.getString("mcCode");
        String overwrite = params.getString("overwrite");

        // 1. MC_CODE 존재 여부 확인
        RecordMap existing = (RecordMap) selectByMapper(
                NS_LSE_MACHINE, "LSE_MACHINE_SER", params);

        if (existing != null && !existing.isEmpty()) {
            // 존재하는 경우
            if (!"1".equals(overwrite)) {
                String dataFlag = String.valueOf(existing.get("dataFlag"));

                if ("2".equals(dataFlag)) {
                    // 삭제된 레코드 존재 → 에러 100002
                    ResultMap result = failure("삭제된 데이터가 존재합니다. 복원하시겠습니까?");
                    result.put("errorCode", "DELETED");
                    result.put("delDate", existing.get("delDate"));
                    result.put("delEmp", existing.get("delEmp"));
                    result.put("delReason", existing.get("delReason"));
                    logger.debug("MC_CODE 삭제됨: mcCode={}", mcCode);
                    return result;
                }

                // 활성 레코드 존재 → 에러 100001
                ResultMap result = failure("동일 자원코드가 존재합니다. 덮어쓰시겠습니까?");
                result.put("errorCode", "DUPLICATE");
                logger.debug("MC_CODE 중복: mcCode={}", mcCode);
                return result;
            }

            // OVERWRITE=1 → UPDATE
            updateByMapper(NS_LSE_MACHINE, "LSE_MACHINE_UPD", params);
            logger.debug("LSE_MACHINE_UPD 완료: mcCode={}", mcCode);
        } else {
            // 미존재 → INSERT + 기본 작업시간 생성
            insertByMapper(NS_LSE_MACHINE, "LSE_MACHINE_INS", params);
            logger.debug("LSE_MACHINE_INS 완료: mcCode={}", mcCode);

            // 기존 작업시간 삭제 (안전)
            deleteByMapper(NS_LSE_MC_WORKTIME, "LSE_MC_WORKTIME_DEL2", params);

            // 기본 작업시간 생성 (MC_SHIFT=1, 모든 요일 1440분)
            ParamsMap wtParams = new ParamsMap();
            wtParams.put("gsPltCode", params.get("gsPltCode"));
            wtParams.put("mcCode", mcCode);
            wtParams.put("mcShift", 1);
            wtParams.put("monTime", 1440);
            wtParams.put("tueTime", 1440);
            wtParams.put("wedTime", 1440);
            wtParams.put("thrTime", 1440);
            wtParams.put("friTime", 1440);
            wtParams.put("satTime", 1440);
            wtParams.put("sunTime", 1440);
            insertByMapper(NS_LSE_MC_WORKTIME, "LSE_MC_WORKTIME_INS", wtParams);
            logger.debug("기본 작업시간 생성: mcCode={}", mcCode);
        }

        // 가용사원 교체: DEL + INS
        replaceAvailEmp(params);

        return success("저장되었습니다.");
    }

    /**
     * 가용사원 교체 (DEL + 다건 INS)
     */
    private void replaceAvailEmp(ParamsMap params) {
        String mcCode = params.getString("mcCode");

        // 기존 가용사원 전체 삭제
        deleteByMapper(NS_TSTD_MC_AVAILEMP, "TSTD_MC_AVAILEMP_DEL", params);

        // 새 가용사원 등록 (form param에서 JSON 문자열로 전달됨)
        JSONArray empRows = null;
        Object modelListObj = params.get("modelList");
        if (modelListObj instanceof String) {
            String modelListStr = (String) modelListObj;
            if (modelListStr != null && !modelListStr.isEmpty()) {
                try {
                    JSONParser parser = new JSONParser();
                    empRows = (JSONArray) parser.parse(modelListStr);
                } catch (ParseException e) {
                    logger.error("modelList JSON 파싱 실패", e);
                }
            }
        } else if (modelListObj instanceof JSONArray) {
            empRows = (JSONArray) modelListObj;
        }
        if (empRows != null && empRows.size() > 0) {
            for (int i = 0; i < empRows.size(); i++) {
                JSONObject row = (JSONObject) empRows.get(i);
                ParamsMap empParams = new ParamsMap();
                empParams.put("gsPltCode", params.get("gsPltCode"));
                empParams.put("mcCode", mcCode);
                empParams.put("empCode", row.get("empCode"));
                empParams.put("empSeq", i);

                insertByMapper(NS_TSTD_MC_AVAILEMP, "TSTD_MC_AVAILEMP_INS", empParams);
            }
            logger.debug("가용사원 등록: mcCode={}, {}건", mcCode, empRows.size());
        }
    }

    // ========================================================================
    // STD04A_DEL: 설비 삭제 (논리삭제 + 연관 데이터 정리)
    // 순서: 작업시간 삭제 → 설비 UDE → 가용설비매핑 삭제 → 가용사원 삭제
    // ========================================================================

    /**
     * 설비 삭제 (단건/다건)
     *
     * @param params mcCodes (삭제 대상 MC_CODE 목록) 또는 mcCode (단건)
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap std04aDel(ParamsMap params) {
        try {
            // JS에서 mcCodes[0], mcCodes[1] ... 형태로 전송 → 개별 키로 추출
            List<String> mcCodes = new ArrayList<String>();
            for (int i = 0; ; i++) {
                String mc = params.getString("mcCodes[" + i + "]");
                if (mc == null || mc.isEmpty()) break;
                mcCodes.add(mc);
            }

            if (mcCodes.isEmpty()) {
                // 단건 삭제 (mcCode 단일 키)
                String mcCode = params.getString("mcCode");
                if (mcCode != null && !mcCode.isEmpty()) {
                    deleteMachine(params);
                    logger.info("STD04A_DEL 완료: mcCode={}", mcCode);
                    return success("삭제되었습니다.");
                }
                return failure("삭제할 항목을 선택하세요.");
            }

            // 다건 삭제
            int count = 0;
            for (int i = 0; i < mcCodes.size(); i++) {
                String mcCode = mcCodes.get(i);
                ParamsMap delParams = new ParamsMap();
                delParams.put("gsPltCode", params.get("gsPltCode"));
                delParams.put("gsUserId", params.get("gsUserId"));
                delParams.put("mcCode", mcCode);
                delParams.put("delReason", params.get("delReason"));

                deleteMachine(delParams);
                count++;
            }

            logger.info("STD04A_DEL 완료: {}건", count);
            return success(count + "건이 삭제되었습니다.");

        } catch (Exception e) {
            logger.error("STD04A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

    /**
     * 단건 설비 삭제 (연관 데이터 cascade 삭제)
     */
    private void deleteMachine(ParamsMap params) {
        // 1. 작업시간 삭제
        deleteByMapper(NS_LSE_MC_WORKTIME, "LSE_MC_WORKTIME_DEL2", params);
        // 2. 설비 논리삭제 (DATA_FLAG=2)
        updateByMapper(NS_LSE_MACHINE, "LSE_MACHINE_UDE", params);
        // 3. 가용설비매핑 삭제
        deleteByMapper(NS_LSE_STD_AVAILMC, "LSE_STD_AVAILMC_DEL2", params);
        // 4. 가용사원 삭제
        deleteByMapper(NS_TSTD_MC_AVAILEMP, "TSTD_MC_AVAILEMP_DEL", params);
    }

    // ========================================================================
    // STD04A_SER2: 설비별 작업시간 조회
    // ========================================================================

    /**
     * 설비별 작업시간 조회
     *
     * @param params mcCode (설비코드)
     * @return 작업시간 목록
     */
    public Object std04aSer2(ParamsMap params) {
        logger.debug("STD04A_SER2: mcCode={}", params.get("mcCode"));
        return searchByMapper(NS_LSE_MC_WORKTIME, "LSE_MC_WORKTIME_SER2", params);
    }

    // ========================================================================
    // STD06A_SER2: 특정 설비의 가용사원 조회
    // ========================================================================

    /**
     * 특정 설비의 가용사원 목록 조회
     *
     * @param params mcCode (설비코드)
     * @return 가용사원 목록
     */
    public Object std06aSer2(ParamsMap params) {
        logger.debug("STD06A_SER2: mcCode={}", params.get("mcCode"));
        return searchByMapper(NS_TSTD_MC_AVAILEMP_QUERY, "TSTD_MC_AVAILEMP_QUERY1", params);
    }

    // ========================================================================
    // STD06A_SER3: 전체 사원 목록 조회 (D0A 우측 그리드용)
    // ========================================================================

    /**
     * 전체 사원 목록 조회
     *
     * @param params pltCode (공장코드)
     * @return 사원 목록
     */
    public Object std06aSer3(ParamsMap params) {
        logger.debug("STD06A_SER3");
        ParamsMap searchParams = new ParamsMap();
        searchParams.put("pltCode", params.get("gsPltCode"));
        searchParams.put("empLike", "");
        return searchByMapper(NS_EMP_SEARCH, "search", searchParams);
    }

    // ========================================================================
    // STD04A_STD_PROC: 공정 콤보 데이터 조회
    // ========================================================================

    /**
     * 공정 콤보 데이터 조회 (MPROC_CODE 중복 제거)
     *
     * @param params (공장코드는 세션에서)
     * @return 공정 목록
     */
    public Object std04aStdProc(ParamsMap params) {
        logger.debug("STD04A_STD_PROC");
        params.put("dataFlag", "0");
        return searchByMapper(NS_LSE_STD_PROC_QUERY, "LSE_STD_PROC_QUERY10", params);
    }

}
