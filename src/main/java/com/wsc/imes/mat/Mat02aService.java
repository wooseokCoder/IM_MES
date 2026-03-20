/*
 * ============================================================================
 * 화면명: MAT02A - 재고정보 조회
 * ============================================================================
 * 설명: 재고정보 조회 서비스 (조회 전용)
 *       4종 재고 DA 파일을 선택적으로 호출 후 Java에서 합산 반환
 *       AS-IS의 DataSet.Merge() 방식과 동일
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - MAT02A_SER → mat02aSer (재고정보 조회)
 *
 * 원본: ProActive MAT02A.cs
 * 작성일: 2026-03-03
 * ============================================================================
 */
package com.wsc.imes.mat;

import java.util.ArrayList;
import java.util.List;

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

/**
 * 재고정보 조회 서비스
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Mat02aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Mat02aService.class);

    // ========================================================================
    // Namespace 상수 (DA 파일 기반 매퍼)
    // ========================================================================
    private static final String NS_COMM     = "com.wsc.imes.mat.TSAP_STOCK_COMM_QUERY";
    private static final String NS_ORDER    = "com.wsc.imes.mat.TSAP_STOCK_ORDER_QUERY";
    private static final String NS_CVND     = "com.wsc.imes.mat.TSAP_STOCK_CVND_QUERY";
    private static final String NS_MVND     = "com.wsc.imes.mat.TSAP_STOCK_MVND_QUERY";
    private static final String NS_PLM_FILE = "com.wsc.imes.pop.IF_PLM_FILE_INFO_QUERY";

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
    // 조회
    // ========================================================================

    /**
     * 재고정보 조회 (MAT02A_SER)
     *
     * AS-IS: MAT02A.MAT02A_SER
     *   선택된 재고 타입별 DA 호출 후 DataSet.Merge()
     *   → 선택된 타입만 호출 후 Java List.addAll()로 통합
     *
     * 파라미터:
     *   - stockTypes: 조회할 재고 타입 (콤마 구분, 예: "COMM,ORDER,CVND,MVND")
     *   - partLike: 자재번호/명 (LIKE 검색)
     *
     * @param params 검색 조건
     * @return 재고정보 목록 (4종 통합)
     */
    public List<RecordMap> mat02aSer(ParamsMap params) {
        List<RecordMap> result = new ArrayList<RecordMap>();
        String stockTypes = (String) params.get("stockTypes");

        if (stockTypes == null || stockTypes.trim().isEmpty()) {
            return result;
        }

        if (stockTypes.contains("COMM")) {
            result.addAll(searchByMapper(NS_COMM,  "TSAP_STOCK_COMM_QUERY1",  params));
        }
        if (stockTypes.contains("ORDER")) {
            result.addAll(searchByMapper(NS_ORDER, "TSAP_STOCK_ORDER_QUERY1", params));
        }
        if (stockTypes.contains("CVND")) {
            result.addAll(searchByMapper(NS_CVND,  "TSAP_STOCK_CVND_QUERY1",  params));
        }
        if (stockTypes.contains("MVND")) {
            result.addAll(searchByMapper(NS_MVND,  "TSAP_STOCK_MVND_QUERY1",  params));
        }

        return result;
    }

    /**
     * 도면 파일 목록 조회
     * AS-IS: POP30A_SER16 → IF_PLM_FILE_INFO_QUERY.IF_PLM_FILE_INFO_QUERY1
     *   PLT_CODE='3603', CAT_CODE='2', ORD_NO=PART_CODE
     *
     * 파라미터:
     *   - partCode: 자재번호 (ORD_NO 매핑)
     *
     * @param params 검색 조건
     * @return 도면 파일 목록
     */
    public List<RecordMap> drawFileList(ParamsMap params) {
        // AS-IS: PLT_CODE='3603' 고정, CAT_CODE='2' (도면)
        params.put("pltCode",  "3603");
        params.put("catCode",  "2");
        params.put("ordNo",    params.get("partCode"));
        params.put("lineNo",   null);
        params.put("procStat", null);
        return searchByMapper(NS_PLM_FILE, "IF_PLM_FILE_INFO_QUERY1", params);
    }

}
