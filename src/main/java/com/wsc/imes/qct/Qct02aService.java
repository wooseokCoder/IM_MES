/*
 * ============================================================================
 * 화면명: QCT02A - 부적합/결품 현황
 * ============================================================================
 * 설명: 부적합/결품 데이터 조회 전용
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 화면 분리
 *       D0A: 사진보기 (이미지 4개)
 * 작성일: 2026-03-09
 * ============================================================================
 */
package com.wsc.imes.qct;

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

/**
 * 부적합/결품 현황 서비스
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class Qct02aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Qct02aService.class);

    private static final String NS_TSHP_NG_QUERY = "com.wsc.imes.qct.TSHP_NG_QUERY";
    private static final String NS_PROC_INS_QUERY = "com.wsc.imes.qct.TSTD_PROC_INS_QUERY";

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
     * 부적합/결품 목록 조회
     */
    public Object qct02aSer(ParamsMap params) {
        logger.debug("QCT02A_SER: plants={}", params.get("plants"));
        return searchByMapper(NS_TSHP_NG_QUERY, "TSHP_NG_QUERY3", params);
    }

    /**
     * 공정코드 목록 조회 (acProcForm용)
     */
    public Object qct02aProc(ParamsMap params) {
        logger.debug("QCT02A_PROC: lprocCode={}", params.get("lprocCode"));
        return searchByMapper(NS_PROC_INS_QUERY, "LSE_STD_PROC_SER2", params);
    }

    // ========================================================================
    // 이미지
    // ========================================================================

    /**
     * 부적합 사진 base64 단건 조회
     * imgNo(1~4)에 해당하는 이미지 반환
     */
    @SuppressWarnings("unchecked")
    public String qct02aImgBase64(ParamsMap params) {
        Object obj = selectByMapper(NS_TSHP_NG_QUERY, "TSHP_NG_IMG", params);
        if (obj != null) {
            java.util.Map<String, Object> result = (java.util.Map<String, Object>) obj;
            if (result.get("imgBase64") != null) {
                return result.get("imgBase64").toString();
            }
        }
        return null;
    }

}
