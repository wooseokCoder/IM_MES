/*
 * ============================================================================
 * 화면명: STD49A - 비가동 관리
 * ============================================================================
 * 설명: 비가동시간 목록 조회, 등록, 수정, 삭제
 * 원본: ProActive STD49A.cs, STD49A_M0A.cs, STD49A_D0A.cs
 *       TSTD_IDLETIME.cs, TSTD_IDLETIME_QUERY.cs
 * 작성일: 2026-02-10
 * ============================================================================
 */
package com.wsc.imes.std;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.inject.Provider;

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
 * 비가동 관리 서비스
 *
 * 원본 ProActive 구조:
 * - STD49A.cs: 비즈니스 로직 (STD49A_SER, STD49A_IDLE, STD49A_INS, STD49A_DEL)
 * - TSTD_IDLETIME.cs: 데이터 접근 (CRUD)
 * - TSTD_IDLETIME_QUERY.cs: 조회 전용 (QUERY1 목록, QUERY2 중복체크)
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - STD49A_SER  → std49aSer
 * - STD49A_IDLE → std49aIdle
 * - STD49A_INS  → std49aIns
 * - STD49A_DEL  → std49aDel
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Std49aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std49aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_TSTD_IDLETIME = "com.wsc.imes.std.TSTD_IDLETIME";
    private static final String NS_TSTD_IDLETIME_QUERY = "com.wsc.imes.std.TSTD_IDLETIME_QUERY";
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
    // STD49A_SER: 비가동시간 목록 조회
    // 원본: STD49A.STD49A_SER() → TSTD_IDLETIME_QUERY.TSTD_IDLETIME_QUERY1()
    // ========================================================================

    /**
     * 비가동시간 목록 조회
     *
     * @param params plants (공장), idleLike (검색어)
     * @return 목록 조회 결과
     */
    public Object std49aSer(ParamsMap params) {
        logger.debug("STD49A_SER: plants={}, idleLike={}",
                params.get("plants"), params.get("idleLike"));

        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_TSTD_IDLETIME_QUERY, "TSTD_IDLETIME_QUERY1", params);
    }

    // ========================================================================
    // STD49A_IDLE: 비가동코드 Lookup 조회
    // 원본: STD49A.STD49A_IDLE() → TSTD_IDLECODE_QUERY.TSTD_IDLECODE_QUERY1()
    // STD45A의 TSTD_IDLECODE_QUERY 매퍼 재사용 (xxxByMapper)
    // ========================================================================

    /**
     * 비가동코드 Lookup 조회 (콤보박스/LookUpEdit용)
     *
     * @param params plants (공장)
     * @return 비가동코드 목록 (scode, idleName 등)
     */
    public Object std49aIdle(ParamsMap params) {
        logger.debug("STD49A_IDLE: plants={}", params.get("plants"));

        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_TSTD_IDLECODE_QUERY, "TSTD_IDLECODE_QUERY1", params);
    }

    // ========================================================================
    // STD49A_INS: 비가동시간 등록/수정
    // 원본: STD49A.STD49A_INS()
    // 로직:
    //   1. 시간 중복 체크 (TSTD_IDLETIME_QUERY2)
    //   2. 기존 레코드 확인 (TSTD_IDLETIME_SER)
    //   3. 있으면 UPDATE, 없으면 IDLE_NO 생성 후 INSERT
    // ========================================================================

    /**
     * 비가동시간 등록/수정 (STD49A_INS)
     *
     * AS-IS 에러코드:
     * - 100009: 시간 중복 → errorCode=OVERLAP
     * - 100001: 동일 데이터 존재 → errorCode=DUPLICATE
     * - 100002: 삭제 이력 존재 → errorCode=DELETED
     *
     * @param params 단건 데이터 (팝업에서 저장)
     * @return 저장 결과 (ResultMap)
     */
    @Transactional
    public ResultMap std49aIns(ParamsMap params) {
        try {
            return processInsert(params);
        } catch (Exception e) {
            logger.error("STD49A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    /**
     * 등록/수정 처리 (내부 메서드)
     *
     * AS-IS 로직 (STD49A.cs):
     * 1. TSTD_IDLETIME_SER로 기존 레코드 확인
     * 2. NOT_IDLE_NO 설정 (자기 자신 제외)
     * 3. TSTD_IDLETIME_QUERY2로 시간 중복 체크
     * 4. 중복 시 에러 100009 (OVERLAP)
     * 5. 기존 레코드 있으면:
     *    - OVERWRITE != 1 → 에러 100001(DUPLICATE) 또는 100002(DELETED)
     *    - OVERWRITE = 1 → UPDATE
     * 6. 신규 → IDLE_NO 생성 후 INSERT
     */
    @SuppressWarnings("unchecked")
    private ResultMap processInsert(ParamsMap params) {
        String idleNo = params.getString("idleNo");
        String overwrite = params.getString("overwrite");
        String plants = params.getString("plants");
        String idleStartTime = params.getString("idleStartTime");
        String idleEndTime = params.getString("idleEndTime");

        // ----------------------------------------------------------------
        // 1. 시간 중복 체크 (AS-IS: TSTD_IDLETIME_QUERY2)
        // ----------------------------------------------------------------
        ParamsMap queryParams = new ParamsMap();
        queryParams.put("gsPltCode", params.get("gsPltCode"));
        queryParams.put("plants", plants);
        queryParams.put("notIdleNo", idleNo);  // EDIT시 자기 자신 제외
        queryParams.put("dataFlag", 0);

        List<RecordMap> existingTimes = (List<RecordMap>) searchByMapper(
                NS_TSTD_IDLETIME_QUERY, "TSTD_IDLETIME_QUERY2", queryParams);

        int newStart = Integer.parseInt(idleStartTime);
        int newEnd = Integer.parseInt(idleEndTime);

        if (existingTimes != null) {
            for (RecordMap existing : existingTimes) {
                int exStart = Integer.parseInt(String.valueOf(existing.get("idleStartTime")));
                int exEnd = Integer.parseInt(String.valueOf(existing.get("idleEndTime")));

                // AS-IS: 5가지 겹침 시나리오 → 단순화: newStart < exEnd && newEnd > exStart
                if (isTimeOverlap(newStart, newEnd, exStart, exEnd)) {
                    ResultMap result = failure("기존등록된 비가동 시간과 겹칩니다.");
                    result.put("errorCode", "OVERLAP");
                    
                    return result;
                }
            }
        }

        // ----------------------------------------------------------------
        // 2. 기존 레코드 확인 (AS-IS: TSTD_IDLETIME_SER)
        // ----------------------------------------------------------------
        if (idleNo != null && !idleNo.isEmpty()) {
            RecordMap existRecord = (RecordMap) selectByMapper(
                    NS_TSTD_IDLETIME, "TSTD_IDLETIME_SER", params);

            if (existRecord != null && !existRecord.isEmpty()) {
                String dataFlag = String.valueOf(existRecord.get("dataFlag"));

                if (!"1".equals(overwrite)) {
                    if ("2".equals(dataFlag)) {
                        // AS-IS: 에러 100002 (삭제 이력 존재)
                        ResultMap result = failure("삭제된 데이터입니다. 복원하시겠습니까?");
                        result.put("errorCode", "DELETED");
                        result.put("delDate", existRecord.get("delDate"));
                        result.put("delEmp", existRecord.get("delEmp"));
                        logger.debug("삭제 이력 존재: idleNo={}", idleNo);
                        return result;
                    }
                    // DATA_FLAG=0 (활성): 정상 수정 진행
                }

                // UPDATE (수정 또는 OVERWRITE 복원)
                updateByMapper(NS_TSTD_IDLETIME, "TSTD_IDLETIME_UPD", params);
                logger.info("TSTD_IDLETIME_UPD 완료: idleNo={}", idleNo);
                return success("저장되었습니다.");
            }
        }

        // ----------------------------------------------------------------
        // 3. 신규 INSERT: IDLE_NO 자동생성
        // AS-IS: UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "IDT", YYYYMMDD)
        // 결과: IDT20260210-0001
        // ----------------------------------------------------------------
        String gsPltCode = params.getString("gsPltCode");
        String today = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String newIdleNo = utilityService.getSerialNo(gsPltCode, "IDT", today, 4);
        params.put("idleNo", newIdleNo);

        insertByMapper(NS_TSTD_IDLETIME, "TSTD_IDLETIME_INS", params);
        logger.info("TSTD_IDLETIME_INS 완료: idleNo={}, scode={}", newIdleNo, params.get("scode"));
        return success("저장되었습니다.");
    }

    /**
     * 시간 중복 판정
     * AS-IS: 5가지 조건 → 단순화 (범위 겹침의 일반 공식)
     * 두 구간 [a,b)와 [c,d)가 겹치는 조건: a < d AND b > c
     */
    private boolean isTimeOverlap(int newStart, int newEnd, int exStart, int exEnd) {
        return newStart < exEnd && newEnd > exStart;
    }

    // ========================================================================
    // STD49A_DEL: 비가동시간 삭제 (논리삭제 + 삭제사유)
    // 원본: STD49A.STD49A_DEL() → TSTD_IDLETIME.TSTD_IDLETIME_UDE()
    // DATA_FLAG = 2, DEL_REASON 저장
    // ========================================================================

    /**
     * 비가동시간 삭제
     *
     * @param params idleNo (삭제 대상), delReason (삭제사유)
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap std49aDel(ParamsMap params) {
        try {
            String idleNo = params.getString("idleNo");
            if (idleNo == null || idleNo.isEmpty()) {
                return failure("삭제할 항목을 선택하세요.");
            }

            updateByMapper(NS_TSTD_IDLETIME, "TSTD_IDLETIME_UDE", params);
            logger.info("STD49A_DEL 완료: idleNo={}, delReason={}",
                    idleNo, params.get("delReason"));
            return success("삭제되었습니다.");

        } catch (Exception e) {
            logger.error("STD49A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

}
