/*
 * ============================================================================
 * 화면명: STD52A - 설비점검항목 관리
 * ============================================================================
 * 설명: 설비 일일점검항목 목록 조회, 등록, 수정, 삭제
 * 작성자: 송우석
 * 작성일: 2026-02-06
 * ============================================================================
 */
package com.wsc.imes.std;

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
 * 설비점검항목 관리 서비스
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class Std52aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std52aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_TSTD_MC_DAILY_CHECK = "com.wsc.imes.std.TSTD_MC_DAILY_CHECK";
    private static final String NS_TSTD_MC_DAILY_CHECK_QUERY = "com.wsc.imes.std.TSTD_MC_DAILY_CHECK_QUERY";

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
    // STD52A_SER: 점검항목 목록 조회
    // ========================================================================

    /**
     * 점검항목 목록 조회
     *
     * @param params typeLike (구분 검색), contentsLike (점검항목 검색), dataFlag (데이터상태)
     * @return 목록 조회 결과
     */
    public Object std52aSer(ParamsMap params) {
        logger.debug("STD52A_SER: typeLike={}, contentsLike={}",
                params.get("typeLike"), params.get("contentsLike"));

        // 기본값 설정
        if (params.get("dataFlag") == null) {
            params.put("dataFlag", 0);
        }

        return searchByMapper(NS_TSTD_MC_DAILY_CHECK_QUERY, "TSTD_MC_DAILY_CHECK_QUERY1", params);
    }

    // ========================================================================
    // STD52A_INS: 점검항목 신규/수정 (UPSERT) - 단건 처리
    // 로직:
    //   1. SER로 존재 확인
    //   2. 존재 + overwrite='1' → UPD 실행
    //   3. 존재 + overwrite!='1' → errorCode 반환 (100001 또는 100002)
    //   4. 미존재 → SMDC 채번 → INS
    //   5. 성공 시 std52aSer() 재조회 반환
    // 참고: EDIT 모드(저장&닫기)에서는 JS가 overwrite='1'을 항상 전송
    // ========================================================================

    /**
     * 점검항목 신규/수정 (UPSERT)
     *
     * @param params 저장 데이터 (smdcNo, smdcType, smdcNum, smdcContents, smdcCheck, smdcMeans, smdcSeq, overwrite)
     * @return 저장 후 목록 재조회 결과 또는 에러코드
     */
    @Transactional
    public Object std52aIns(ParamsMap params) {
        try {
            String smdcNo = params.getString("smdcNo");
            String overwrite = params.getString("overwrite");

            logger.debug("STD52A_INS: smdcNo={}, overwrite={}", smdcNo, overwrite);

            // SER로 존재 여부 확인 (smdcNo가 있는 경우)
            if (smdcNo != null && !smdcNo.isEmpty()) {
                RecordMap existing = (RecordMap) selectByMapper(NS_TSTD_MC_DAILY_CHECK, "TSTD_MC_DAILY_CHECK_SER", params);

                if (existing != null && !existing.isEmpty()) {
                    // 데이터가 존재하는 경우
                    if ("1".equals(overwrite)) {
                        // overwrite 모드 → UPDATE (EDIT 모드에서 항상 overwrite='1' 전송)
                        updateByMapper(NS_TSTD_MC_DAILY_CHECK, "TSTD_MC_DAILY_CHECK_UPD", params);
                        logger.info("STD52A_INS (UPD) 완료: smdcNo={}", smdcNo);

                        // 저장 후 목록 재조회
                        return std52aSer(params);
                    } else {
                        // 중복 에러 반환
                        Object dataFlag = existing.get("dataFlag");
                        int dataFlagInt = 0;
                        if (dataFlag != null) {
                            dataFlagInt = Integer.parseInt(dataFlag.toString());
                        }

                        ResultMap result = new ResultMap();
                        result.put("success", false);

                        if (dataFlagInt == 2) {
                            // 삭제된 데이터 존재 (errorCode 100002)
                            result.put("code", 100002);
                            result.put("message", "삭제된 이력이 존재합니다. 덮어쓰시겠습니까?");
                            result.put("delDate", existing.get("delDate"));
                            result.put("delEmp", existing.get("delEmp"));
                        } else {
                            // 활성 데이터 존재 (errorCode 100001)
                            result.put("code", 100001);
                            result.put("message", "동일한 데이터가 존재합니다. 덮어쓰시겠습니까?");
                        }

                        return result;
                    }
                }
            }

            // 신규 등록: SMDC_NO 채번
            String gsPltCode = params.getString("gsPltCode");
            String newSmdcNo = utilityService.getSerialNo(gsPltCode, "SMDC");
            params.put("smdcNo", newSmdcNo);

            // INSERT 실행
            insertByMapper(NS_TSTD_MC_DAILY_CHECK, "TSTD_MC_DAILY_CHECK_INS", params);
            logger.info("STD52A_INS (INS) 완료: smdcNo={}", newSmdcNo);

            // 저장 후 목록 재조회
            return std52aSer(params);

        } catch (Exception e) {
            logger.error("STD52A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // STD52A_DEL: 점검항목 삭제 (논리삭제) - 다건 처리
    // DATA_FLAG = 2로 설정
    // ========================================================================

    /**
     * 점검항목 삭제 - 단건 (STD45A 패턴 동일)
     *
     * @param params smdcNo (삭제 대상 SMDC_NO)
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap std52aDel(ParamsMap params) {
        try {
            String smdcNo = params.getString("smdcNo");

            if (smdcNo == null || smdcNo.isEmpty()) {
                return failure("삭제할 항목을 선택하세요.");
            }

            updateByMapper(NS_TSTD_MC_DAILY_CHECK, "TSTD_MC_DAILY_CHECK_UDE", params);

            logger.info("STD52A_DEL 완료: smdcNo={}", smdcNo);

            return success("삭제되었습니다.");

        } catch (Exception e) {
            logger.error("STD52A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

}
