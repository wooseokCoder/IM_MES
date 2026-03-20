/*
 * ============================================================================
 * 화면명: STD50A - 작업자 그룹 관리
 * ============================================================================
 * 설명: 작업자 그룹 목록 조회, 등록, 수정, 삭제
 * 원본: ProActive STD50A.cs
 *       TSTD_WORKGROUP.cs, TSTD_WORKGROUP_MC.cs, TSTD_WORKGROUP_EMP.cs
 *       TSTD_WORKGROUP_QUERY.cs, TSTD_WORKGROUP_MC_QUERY.cs, TSTD_WORKGROUP_EMP_QUERY.cs
 * 작성일: 2026-02-10
 * ============================================================================
 */
package com.wsc.imes.std;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

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
 * 작업자 그룹 관리 서비스
 *
 * 원본 ProActive 구조:
 * - STD50A.cs: 비즈니스 로직 (STD50A_SER, STD50A_SER2, STD50A_SER3, STD50A_INS, STD50A_DEL)
 * - TSTD_WORKGROUP.cs: 데이터 접근 (마스터 CRUD)
 * - TSTD_WORKGROUP_MC.cs: 데이터 접근 (자식 작업장 CRUD)
 * - TSTD_WORKGROUP_EMP.cs: 데이터 접근 (자식 작업자 CRUD)
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Std50aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std50aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS = "com.wsc.imes.std.TSTD_WORKGROUP";
    private static final String NS_QUERY = "com.wsc.imes.std.TSTD_WORKGROUP_QUERY";

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
    // STD50A_SER: 그룹 목록 조회
    // 원본: STD50A.STD50A_SER() → TSTD_WORKGROUP_QUERY.TSTD_WORKGROUP_QUERY1()
    // ========================================================================

    /**
     * 그룹 목록 조회 (메인 그리드)
     *
     * @param params groupLike (검색어)
     * @return 목록 조회 결과
     */
    public Object std50aSer(ParamsMap params) {
        logger.debug("STD50A_SER: groupLike={}", params.get("groupLike"));

        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_QUERY, "TSTD_WORKGROUP_QUERY1", params);
    }

    // ========================================================================
    // STD50A_SER2: 그룹 상세 조회 (소속 작업장 + 작업자)
    // 원본: STD50A.STD50A_SER2()
    // ========================================================================

    /**
     * 그룹 상세 조회 - 소속 작업장 + 작업자 목록
     *
     * @param params groupNo (그룹번호)
     * @return mcList (소속 작업장), empList (소속 작업자)
     */
    public Map<String, Object> std50aSer2(ParamsMap params) {
        logger.debug("STD50A_SER2: groupNo={}", params.get("groupNo"));

        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("mcList", searchByMapper(NS_QUERY, "TSTD_WORKGROUP_MC_QUERY1", params));
        result.put("empList", searchByMapper(NS_QUERY, "TSTD_WORKGROUP_EMP_QUERY1", params));
        return result;
    }

    // ========================================================================
    // STD50A_SER3: 전체 작업장/작업자 목록 (다이얼로그 전환 UI용)
    // 원본: STD50A.STD50A_SER3()
    // ========================================================================

    /**
     * 전체 작업장/작업자 목록 조회 (다이얼로그용)
     *
     * @param params (세션 파라미터)
     * @return mcAllList (전체 작업장), empAllList (전체 작업자)
     */
    public Map<String, Object> std50aSer3(ParamsMap params) {
        logger.debug("STD50A_SER3");

        // AS-IS 하드코딩: DATA_FLAG=0, MC_GROUP='9999', IS_ASSY=1
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }
        params.put("mcGroup", "9999");
        params.put("isAssy", 1);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("mcAllList", searchByMapper(NS_QUERY, "LSE_MACHINE_QUERY8", params));
        result.put("empAllList", searchByMapper(NS_QUERY, "TSTD_EMPLOYEE_QUERY9", params));
        return result;
    }

    // ========================================================================
    // STD50A_INS: 그룹 저장 (마스터 UPSERT + 자식 차분 저장)
    // 원본: STD50A.STD50A_INS()
    // ========================================================================

    /**
     * 그룹 저장
     *
     * 로직:
     * 1. groupNo 유무 판별 → 있으면 기존 확인 (OVERWRITE 체크), 없으면 채번 후 INSERT
     * 2. 자식 처리: empDelList/empInsList/mcDelList/mcInsList (JSONArray)
     *    - 각 row: SER 확인 → 없으면 INS, 있으면 UPD 또는 UDE
     *
     * @param params 마스터 필드 + 자식 JSON 배열
     * @return 저장 결과 (ResultMap)
     */
    @Transactional
    public ResultMap std50aIns(ParamsMap params) {
        try {
            return processInsert(params);
        } catch (Exception e) {
            logger.error("STD50A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    /**
     * 등록/수정 처리 (내부 메서드)
     */
    private ResultMap processInsert(ParamsMap params) throws Exception {
        String groupNo = params.getString("groupNo");
        String overwrite = params.getString("overwrite");

        // ----------------------------------------------------------------
        // 1. 마스터 처리
        // ----------------------------------------------------------------
        if (groupNo != null && !groupNo.isEmpty()) {
            // 기존 레코드 확인
            RecordMap existRecord = (RecordMap) selectByMapper(
                    NS, "TSTD_WORKGROUP_SER", params);

            if (existRecord != null && !existRecord.isEmpty()) {
                String dataFlag = String.valueOf(existRecord.get("dataFlag"));

                if (!"1".equals(overwrite)) {
                    if ("2".equals(dataFlag)) {
                        // 삭제된 데이터 → OVERWRITE 확인 필요
                        ResultMap result = failure("삭제된 데이터입니다. 복원하시겠습니까?");
                        result.put("errorCode", "DELETED");
                        result.put("delDate", existRecord.get("delDate"));
                        result.put("delEmp", existRecord.get("delEmp"));
                        logger.debug("삭제 이력 존재: groupNo={}", groupNo);
                        return result;
                    }
                    // DATA_FLAG=0 (활성): 동일 데이터 존재 → OVERWRITE 확인 필요
                    ResultMap result = failure("동일 데이터가 존재합니다. 덮어쓰시겠습니까?");
                    result.put("errorCode", "DUPLICATE");
                    logger.debug("중복 데이터 존재: groupNo={}", groupNo);
                    return result;
                }

                // UPDATE (수정 또는 OVERWRITE 복원)
                updateByMapper(NS, "TSTD_WORKGROUP_UPD", params);
                logger.info("TSTD_WORKGROUP_UPD 완료: groupNo={}", groupNo);
            } else {
                // 레코드 없음 → INSERT
                insertByMapper(NS, "TSTD_WORKGROUP_INS", params);
                logger.info("TSTD_WORKGROUP_INS 완료: groupNo={}", groupNo);
            }
        } else {
            // 신규: GROUP_NO 자동생성
            String gsPltCode = params.getString("gsPltCode");
            String today = new SimpleDateFormat("yyyyMMdd").format(new Date());
            String newGroupNo = utilityService.getSerialNo(gsPltCode, "GRP", today, 4);
            params.put("groupNo", newGroupNo);
            groupNo = newGroupNo;

            insertByMapper(NS, "TSTD_WORKGROUP_INS", params);
            logger.info("TSTD_WORKGROUP_INS 완료: groupNo={}", groupNo);
        }

        // ----------------------------------------------------------------
        // 2. 자식 처리: 작업자 삭제
        // ----------------------------------------------------------------
        String empDelListStr = params.getString("empDelList");
        if (empDelListStr != null && !empDelListStr.isEmpty() && !"[]".equals(empDelListStr)) {
            JSONParser parser = new JSONParser();
            JSONArray empDelList = (JSONArray) parser.parse(empDelListStr);

            for (int i = 0; i < empDelList.size(); i++) {
                JSONObject row = (JSONObject) empDelList.get(i);
                ParamsMap childParams = new ParamsMap();
                childParams.put("gsPltCode", params.get("gsPltCode"));
                childParams.put("gsUserId", params.get("gsUserId"));
                childParams.put("groupNo", groupNo);
                childParams.put("empCode", String.valueOf(row.get("empCode")));

                // SER 확인 → 있으면 UDE
                RecordMap exist = (RecordMap) selectByMapper(NS, "TSTD_WORKGROUP_EMP_SER", childParams);
                if (exist != null && !exist.isEmpty()) {
                    updateByMapper(NS, "TSTD_WORKGROUP_EMP_UDE", childParams);
                }
            }
        }

        // ----------------------------------------------------------------
        // 3. 자식 처리: 작업자 추가
        // ----------------------------------------------------------------
        String empInsListStr = params.getString("empInsList");
        if (empInsListStr != null && !empInsListStr.isEmpty() && !"[]".equals(empInsListStr)) {
            JSONParser parser = new JSONParser();
            JSONArray empInsList = (JSONArray) parser.parse(empInsListStr);

            for (int i = 0; i < empInsList.size(); i++) {
                JSONObject row = (JSONObject) empInsList.get(i);
                ParamsMap childParams = new ParamsMap();
                childParams.put("gsPltCode", params.get("gsPltCode"));
                childParams.put("gsUserId", params.get("gsUserId"));
                childParams.put("groupNo", groupNo);
                childParams.put("empCode", String.valueOf(row.get("empCode")));
                childParams.put("empSeq", row.get("empSeq") != null ? Integer.parseInt(String.valueOf(row.get("empSeq"))) : i + 1);

                // SER 확인 → 없으면 INS, 있으면 UPD (복원)
                RecordMap exist = (RecordMap) selectByMapper(NS, "TSTD_WORKGROUP_EMP_SER", childParams);
                if (exist == null || exist.isEmpty()) {
                    insertByMapper(NS, "TSTD_WORKGROUP_EMP_INS", childParams);
                } else {
                    updateByMapper(NS, "TSTD_WORKGROUP_EMP_UPD", childParams);
                }
            }
        }

        // ----------------------------------------------------------------
        // 4. 자식 처리: 작업장 삭제
        // ----------------------------------------------------------------
        String mcDelListStr = params.getString("mcDelList");
        if (mcDelListStr != null && !mcDelListStr.isEmpty() && !"[]".equals(mcDelListStr)) {
            JSONParser parser = new JSONParser();
            JSONArray mcDelList = (JSONArray) parser.parse(mcDelListStr);

            for (int i = 0; i < mcDelList.size(); i++) {
                JSONObject row = (JSONObject) mcDelList.get(i);
                ParamsMap childParams = new ParamsMap();
                childParams.put("gsPltCode", params.get("gsPltCode"));
                childParams.put("gsUserId", params.get("gsUserId"));
                childParams.put("groupNo", groupNo);
                childParams.put("mcCode", String.valueOf(row.get("mcCode")));

                // SER 확인 → 있으면 UDE
                RecordMap exist = (RecordMap) selectByMapper(NS, "TSTD_WORKGROUP_MC_SER", childParams);
                if (exist != null && !exist.isEmpty()) {
                    updateByMapper(NS, "TSTD_WORKGROUP_MC_UDE", childParams);
                }
            }
        }

        // ----------------------------------------------------------------
        // 5. 자식 처리: 작업장 추가
        // ----------------------------------------------------------------
        String mcInsListStr = params.getString("mcInsList");
        if (mcInsListStr != null && !mcInsListStr.isEmpty() && !"[]".equals(mcInsListStr)) {
            JSONParser parser = new JSONParser();
            JSONArray mcInsList = (JSONArray) parser.parse(mcInsListStr);

            for (int i = 0; i < mcInsList.size(); i++) {
                JSONObject row = (JSONObject) mcInsList.get(i);
                ParamsMap childParams = new ParamsMap();
                childParams.put("gsPltCode", params.get("gsPltCode"));
                childParams.put("gsUserId", params.get("gsUserId"));
                childParams.put("groupNo", groupNo);
                childParams.put("mcCode", String.valueOf(row.get("mcCode")));
                childParams.put("mcSeq", row.get("mcSeq") != null ? Integer.parseInt(String.valueOf(row.get("mcSeq"))) : i + 1);

                // SER 확인 → 없으면 INS, 있으면 UPD (복원)
                RecordMap exist = (RecordMap) selectByMapper(NS, "TSTD_WORKGROUP_MC_SER", childParams);
                if (exist == null || exist.isEmpty()) {
                    insertByMapper(NS, "TSTD_WORKGROUP_MC_INS", childParams);
                } else {
                    updateByMapper(NS, "TSTD_WORKGROUP_MC_UPD", childParams);
                }
            }
        }

        logger.info("STD50A_INS 완료: groupNo={}", groupNo);
        return success("저장되었습니다.");
    }

    // ========================================================================
    // STD50A_DEL: 그룹 삭제 (마스터 + 자식 전체 논리삭제)
    // 원본: STD50A.STD50A_DEL()
    // ========================================================================

    /**
     * 그룹 삭제
     *
     * @param params groupNo (삭제 대상), delReason (삭제사유 - UI에서 수집)
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap std50aDel(ParamsMap params) {
        try {
            String groupNo = params.getString("groupNo");
            if (groupNo == null || groupNo.isEmpty()) {
                return failure("삭제할 항목을 선택하세요.");
            }

            // 1. 마스터 논리삭제
            updateByMapper(NS, "TSTD_WORKGROUP_UDE", params);

            // 2. 자식 전체 논리삭제 (작업자)
            updateByMapper(NS, "TSTD_WORKGROUP_EMP_UDE2", params);

            // 3. 자식 전체 논리삭제 (작업장)
            updateByMapper(NS, "TSTD_WORKGROUP_MC_UDE2", params);

            logger.info("STD50A_DEL 완료: groupNo={}", groupNo);
            return success("삭제되었습니다.");

        } catch (Exception e) {
            logger.error("STD50A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

}
