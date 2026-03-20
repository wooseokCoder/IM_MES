/*
 * ============================================================================
 * 화면명: POP57A - 설비별 표준문서(검사)
 * ============================================================================
 * 설명: 설비별 표준문서(검사) 조회
 * 원본: ProActive POP57A.cs
 *       - POP57A_SER: LSE_MACHINE_QUERY1 (그리드 데이터)
 * 작성일: 2026-03-12
 * ============================================================================
 */
package com.wsc.imes.pop;

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
 * 설비별 표준문서(검사) 서비스
 */
@Service
public class Pop57aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Pop57aService.class);

    private static final String NS_LSE_MACHINE_POP57A_QUERY = "com.wsc.imes.pop.LSE_MACHINE_POP57A_QUERY";

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
     * 설비 목록 조회 (POP57A_SER)
     * 원본: POP57A.POP57A_SER() → LSE_MACHINE_QUERY1
     *
     * @param params gsPltCode (세션에서 자동 설정)
     * @return 설비 목록 (MC_GROUP='3605', DATA_FLAG=0)
     */
    public Object pop57aSer(ParamsMap params) {
        try {
            List<RecordMap> list = searchByMapper(NS_LSE_MACHINE_POP57A_QUERY, "LSE_MACHINE_QUERY_POP57A", params);

            return list;

        } catch (Exception e) {
            logger.error("POP57A_SER 오류", e);
            throw new RuntimeException("설비별 표준문서 조회 중 오류가 발생했습니다.", e);
        }
    }
}
