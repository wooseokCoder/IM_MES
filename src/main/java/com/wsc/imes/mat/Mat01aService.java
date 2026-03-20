/*
 * ============================================================================
 * 화면명: MAT01A - 과부족정보 조회
 * ============================================================================
 * 설명: 과부족정보 조회 서비스 (조회 전용)
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - MAT01A_SER → mat01aSer (과부족정보 조회)
 *
 * 원본: ProActive MAT01A.cs
 * 작성일: 2026-03-03
 * ============================================================================
 */
package com.wsc.imes.mat;

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
 * 과부족정보 조회 서비스
 *
 * @author MES
 * @version 1.0
 */
@Service
public class Mat01aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Mat01aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_QUERY = "com.wsc.imes.mat.TSAP_MORE_LESS_QUERY";

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
     * 과부족정보 조회 (MAT01A_SER)
     *
     * AS-IS: MAT01A.MAT01A_SER
     *   → TSAP_MORE_LESS_QUERY.TSAP_MORE_LESS_QUERY2(paramDS, bizExecute)
     *
     * 파라미터:
     *   - orderLike: 판매오더 (LIKE 검색)
     *   - partLike: 구성부품 (LIKE 검색)
     *   - sIndueDate: 생산완료일 시작
     *   - eIndueDate: 생산완료일 종료
     *   - plants: 공장 (콤마 구분)
     *
     * @param params 검색 조건
     * @return 과부족정보 목록
     */
    public List<RecordMap> mat01aSer(ParamsMap params) {
        return searchByMapper(NS_QUERY, "TSAP_MORE_LESS_QUERY2", params);
    }

}
