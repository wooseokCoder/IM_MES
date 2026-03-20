/*
 * ============================================================================
 * 화면명: ORD07A - 일련번호 관리
 * ============================================================================
 * 설명: 일련번호 목록 조회, 순번 수정
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - ORD07A_SER → ord07aSer
 * - ORD07A_UPD → ord07aUpd
 *
 * 작성자: 송우석
 * 작성일: 2026-02-10
 * ============================================================================
 */
package com.wsc.imes.ord;

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
import com.wsc.framework.model.ResultMap;

/**
 * 일련번호 관리 서비스
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class Ord07aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Ord07aService.class);

    // ========================================================================
    // Namespace 상수 (테이블 기반 매퍼)
    // ========================================================================
    private static final String NS_TSYS_SERIAL = "com.wsc.imes.ord.TSYS_SERIAL";
    private static final String NS_TSYS_SERIAL_QUERY = "com.wsc.imes.ord.TSYS_SERIAL_QUERY";

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
    // ORD07A_SER: 일련번호 목록 조회
    // TSYS_SERIAL_QUERY.TSYS_SERIAL_QUERY1 호출
    // ========================================================================

    /**
     * 일련번호 목록 조회
     *
     * @param params modelLike (모델 검색어)
     * @return 목록 조회 결과
     */
    public Object ord07aSer(ParamsMap params) {
        logger.debug("ORD07A_SER: modelLike={}", params.get("modelLike"));

        // IS_HOGI 고정값 (M0A에서 하드코딩)
        params.put("isHogi", "1");

        return searchByMapper(NS_TSYS_SERIAL_QUERY, "TSYS_SERIAL_QUERY1", params);
    }

    // ========================================================================
    // ORD07A_UPD: 일련번호 순번 수정
    // TSYS_SERIAL.TSYS_SERIAL_UPD 호출
    // ========================================================================

    /**
     * 일련번호 순번 수정
     *
     * @param params srCode (모델), srKey (년도), srNo (순번)
     * @return 저장 결과
     */
    @Transactional
    public ResultMap ord07aUpd(ParamsMap params) {
        try {
            updateByMapper(NS_TSYS_SERIAL, "TSYS_SERIAL_UPD", params);
            logger.info("ORD07A_UPD 완료: srCode={}, srKey={}", params.get("srCode"), params.get("srKey"));
            return success("저장되었습니다.");
        } catch (Exception e) {
            logger.error("ORD07A_UPD 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

}
