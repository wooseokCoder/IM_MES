/*
 * ============================================================================
 * SysConfigService.java
 * ============================================================================
 * 설명: 시스템 설정 서비스 (TSYS_CONF)
 *       AS-IS: acSysConfig.cs - 로그인 시 전체 로딩, 메모리에서 조회
 *
 * 사용법:
 *   로그인 시 searchSysConfig(pltCode) 호출 → SessionComponent에 저장
 *   이후 SessionComponent.getSysConfig("DRAW2D_FILE_DIR") 로 조회
 *
 * 작성일: 2026-03-04
 * ============================================================================
 */
package com.wsc.imes.common;

import java.util.HashMap;
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

/**
 * 시스템 설정 서비스
 *
 * AS-IS: acSysConfig(DataTable dt) → Dictionary 로딩
 *        GetSysConfigByMemory(configName) → Dictionary에서 조회
 */
@Service
public class SysConfigService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(SysConfigService.class);

    private static final String NS = "com.wsc.imes.common.SysConfig";

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
     * 공장코드별 시스템 설정 전체 조회
     *
     * AS-IS: MAINFORM_INIT_SYSTEM → SYS_CONF DataTable → Dictionary
     *
     * @param pltCode 공장코드
     * @return Map(CONF_NAME → CONF_VALUE)
     */
    @SuppressWarnings("unchecked")
    public Map<String, String> searchSysConfig(String pltCode) {
        logger.debug("시스템 설정 로딩: pltCode={}", pltCode);

        ParamsMap params = new ParamsMap();
        params.put("gsPltCode", pltCode);

        List<RecordMap> list = searchByMapper(NS, "search", params);

        Map<String, String> configMap = new HashMap<String, String>();
        if (list != null) {
            for (RecordMap rec : list) {
                String name  = rec.getString("confName");
                String value = rec.getString("confValue");
                if (name != null) {
                    configMap.put(name, value);
                }
            }
        }

        logger.debug("시스템 설정 로딩 완료: {}건", configMap.size());
        return configMap;
    }
}
