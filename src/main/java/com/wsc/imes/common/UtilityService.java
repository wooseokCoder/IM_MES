/*
 * ============================================================================
 * 파일명: UtilityService.java
 * 설명: IMES 공통 유틸리티 서비스 (시리얼 채번 등)
 * 원본: ProActive UTIL.cs
 * 작성일: 2026-02-05
 * ============================================================================
 */
package com.wsc.imes.common;

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
 * IMES 공통 유틸리티 서비스
 *
 * AS-IS의 UTIL.cs 공통 유틸리티 함수들을 Java로 구현
 *
 * 사용법:
 * <pre>
 * &#64;Autowired
 * private UtilityService utilityService;
 *
 * // AS-IS: UTIL.UTILITY_GET_SERIALNO(plt_code, "S", bizExecute)
 * String scode = utilityService.getSerialNo(gsPltCode, "S");
 * // 결과: S260205-0001
 * </pre>
 *
 * @author MES
 * @version 1.0
 */
@Service
public class UtilityService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(UtilityService.class);

    private static final String NS = "com.wsc.imes.common.Utility";

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
    // UTILITY_GET_SERIALNO: 시리얼 번호 채번
    // 원본: UTIL.UTILITY_GET_SERIALNO(plt_code, sr_code, bizExecute)
    // ========================================================================

    /**
     * 시리얼 번호 채번 (날짜 기반)
     *
     * AS-IS 동일 호출: UTIL.UTILITY_GET_SERIALNO(plt_code, sr_code, bizExecute)
     *
     * @param pltCode 공장코드
     * @param srCode 시리얼 타입 (S, O, M 등)
     * @return 시리얼 번호 (예: S260205-0001)
     */
    public String getSerialNo(String pltCode, String srCode) {
        logger.debug("UTILITY_GET_SERIALNO: pltCode={}, srCode={}", pltCode, srCode);

        ParamsMap params = new ParamsMap();
        params.put("gsPltCode", pltCode);
        params.put("srCode", srCode);

        RecordMap result = (RecordMap) selectByMapper(NS, "UTILITY_GET_SERIALNO_YYMMDD", params);

        if (result != null && result.getString("serialNo") != null) {
            String serialNo = result.getString("serialNo");
            logger.debug("UTILITY_GET_SERIALNO 결과: {}", serialNo);
            return serialNo;
        }

        logger.warn("UTILITY_GET_SERIALNO 실패: pltCode={}, srCode={}", pltCode, srCode);
        return null;
    }

    /**
     * 시리얼 번호 채번 (키 지정)
     *
     * AS-IS 동일 호출: UTIL.UTILITY_GET_SERIALNO(plt_code, sr_code, sr_key, sep, bizExecute)
     *
     * @param pltCode 공장코드
     * @param srCode 시리얼 타입 (S, O, M 등)
     * @param srKey 시리얼 키 (NULL이면 현재 날짜 YYMMDD)
     * @param sep 순번 자릿수 (기본 4)
     * @return 시리얼 번호 (예: S260205-0001)
     */
    public String getSerialNo(String pltCode, String srCode, String srKey, Integer sep) {
        

        ParamsMap params = new ParamsMap();
        params.put("gsPltCode", pltCode);
        params.put("srCode", srCode);
        params.put("srKey", srKey);
        params.put("sep", sep != null ? sep : 4);

        RecordMap result = (RecordMap) selectByMapper(NS, "UTILITY_GET_SERIALNO", params);

        if (result != null && result.getString("serialNo") != null) {
            String serialNo = result.getString("serialNo");
            logger.debug("UTILITY_GET_SERIALNO 결과: {}", serialNo);
            return serialNo;
        }

        
        return null;
    }

}
