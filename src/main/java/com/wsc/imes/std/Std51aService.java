/*
 * ============================================================================
 * 화면명: STD51A - 검사그룹
 * ============================================================================
 * 설명: 검사그룹 조회
 * 원본: ProActive STD51A.cs
 *       - STD51A_SER: TSTD_INS_GRP_QUERY1 (그리드 데이터)
 * 작성일: 2026-03-11
 * ============================================================================
 */
package com.wsc.imes.std;

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
 * 검사그룹 서비스
 */
@Service
public class Std51aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std51aService.class);

    private static final String NS_TSTD_INS_GRP_QUERY = "com.wsc.imes.std.TSTD_INS_GRP_QUERY";

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

    /**
     * 검사그룹 목록 조회 (STD51A_SER)
     * 원본: STD51A.STD51A_SER() → TSTD_INS_GRP_QUERY1
     *
     * @param params plants, searchLike
     * @return 검사그룹 목록
     */
    public Object std51aSer(ParamsMap params) {
        try {
            params.put("dataFlag", 0);

            List<RecordMap> list = searchByMapper(NS_TSTD_INS_GRP_QUERY, "TSTD_INS_GRP_QUERY1", params);

            return list;

        } catch (Exception e) {
            logger.error("STD51A_SER 오류", e);
            throw new RuntimeException("검사그룹 조회 중 오류가 발생했습니다.", e);
        }
    }
}
