/*
 * ============================================================================
 * 화면명: STD47A - 작업표준서(조립)
 * ============================================================================
 * 설명: 작업표준서 등록 및 조회
 * 원본: ProActive STD47A.cs
 *       - STD47A_SER: TSTD_MODEL_QUERY2, QUERY2_1, QUERY2_2 (트리 데이터)
 *       - STD47A_SER2: TSYS_FILELIST_MASTER_QUERY6 (리스트 데이터)
 * 작성일: 2026-03-03
 * ============================================================================
 */
package com.wsc.imes.std;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.model.ResultMap;

/**
 * 작업표준서(조립) 서비스
 *
 * @author AI Assistant
 * @version 1.0
 */
@Service
public class Std47aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std47aService.class);

    // ========================================================================
    // Namespace 상수
    // ========================================================================
    private static final String NS_TSTD_MODEL_QUERY = "com.wsc.imes.std.TSTD_MODEL_QUERY";
    private static final String NS_TSYS_FILELIST_MASTER_QUERY = "com.wsc.imes.sys.TSYS_FILELIST_MASTER_QUERY";

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
    // STD47A_SER: 모델 트리 조회
    // 원본: STD47A.STD47A_SER() → TSTD_MODEL_QUERY2, QUERY2_1, QUERY2_2 Merge
    // ========================================================================

    /**
     * 모델 트리 조회 (LEVEL1 + LEVEL2 만 반환 — LEVEL3는 Lazy Load)
     * LEVEL3(공정그룹)를 초기 로드에서 제외하여 N×M 곱집합 전송 문제를 해결.
     * LEVEL3는 LEVEL2 노드 펼치기 시 std47aSerLevel3() 로 별도 조회.
     *
     * @param params plants, modelLike
     * @return 트리 구조 데이터 (구분·시리즈 → 모델번호)
     */
    public Object std47aSer(ParamsMap params) {
        try {
            // DATA_FLAG = 0 설정 (원본: UTIL.SetBizAddColumnToValue)
            params.put("dataFlag", 0);

            // TSTD_MODEL_QUERY2 호출 (트리1: 모델번호 노드, P_CODE = MODEL_TYPE-MODEL_SERISE)
            List<RecordMap> list1 = searchByMapper(NS_TSTD_MODEL_QUERY, "TSTD_MODEL_QUERY2", params);
            for (RecordMap row : list1) {
                row.put("SEL", "");
            }

            // TSTD_MODEL_QUERY2_1 호출 (트리0: 루트 노드, P_CODE = '')
            List<RecordMap> list2 = searchByMapper(NS_TSTD_MODEL_QUERY, "TSTD_MODEL_QUERY2_1", params);
            for (RecordMap row : list2) {
                row.put("SEL", "");
            }

            // LEVEL3(공정그룹)는 Lazy Load 로 분리 — 초기 로드에서 제외
            // SAFE_CODE / SAFE_P_CODE 는 SQL 프로시저에서 REPLACE 로 생성됨
            List<RecordMap> merged = new ArrayList<RecordMap>();
            merged.addAll(list1);
            merged.addAll(list2);

            return merged;

        } catch (Exception e) {
            logger.error("STD47A_SER 오류", e);
            throw new RuntimeException("모델 트리 조회 중 오류가 발생했습니다.", e);
        }
    }

    // ========================================================================
    // STD47A_SER_LEVEL3: LEVEL2 노드 Lazy Load — 특정 모델의 공정그룹 조회
    // LEVEL2 노드(모델번호)를 펼칠 때 해당 MODEL_NO 의 공정그룹만 반환
    // ========================================================================

    /**
     * 특정 모델번호의 공정그룹(LEVEL3) 조회
     * LEVEL2 노드 펼치기(onBeforeExpand) 시점에 호출되어 해당 모델의 LEVEL3 노드만 반환.
     * 기존 sp_imes_tstd_model_query2_2 의 전체 조회를 MODEL_NO 단위로 분리하여
     * 불필요한 N×M 곱집합 전송을 방지한다.
     *
     * @param params plants, modelNo
     * @return 해당 모델의 공정그룹 LEVEL3 노드 목록
     */
    public Object std47aSerLevel3(ParamsMap params) {
        try {
            // DATA_FLAG = 0 설정
            params.put("dataFlag", 0);

            List<RecordMap> list = searchByMapper(NS_TSTD_MODEL_QUERY, "TSTD_MODEL_QUERY2_2_BY_MODEL", params);
            for (RecordMap row : list) {
                row.put("SEL", "");
            }
            return list;

        } catch (Exception e) {
            logger.error("STD47A_SER_LEVEL3 오류", e);
            throw new RuntimeException("공정그룹 조회 중 오류가 발생했습니다.", e);
        }
    }

    // ========================================================================
    // STD47A_SER2: 작업표준서 리스트 조회
    // 원본: STD47A.STD47A_SER2() → TSYS_FILELIST_MASTER_QUERY6
    // ========================================================================

    /**
     * 작업표준서 리스트 조회
     *
     * @param params plants, modelLike, uploadMenu
     * @return 작업표준서 리스트
     */
    public Object std47aSer2(ParamsMap params) {
        try {
            // DATA_FLAG = 0 설정 (원본: UTIL.SetBizAddColumnToValue)
            params.put("dataFlag", 0);

            // TSYS_FILELIST_MASTER_QUERY6 호출
            List<RecordMap> list = searchByMapper(NS_TSYS_FILELIST_MASTER_QUERY, "TSYS_FILELIST_MASTER_QUERY6", params);
            for (RecordMap row : list) {
                row.put("SEL", "");
            }

//            ResultMap result = new ResultMap();
//            result.put("rows", list);
//            result.put("total", list.size());

            return list;

        } catch (Exception e) {
            logger.error("STD47A_SER2 오류", e);
            throw new RuntimeException("작업표준서 리스트 조회 중 오류가 발생했습니다.", e);
        }
    }
}
