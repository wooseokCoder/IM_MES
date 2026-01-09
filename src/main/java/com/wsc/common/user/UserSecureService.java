package com.wsc.common.user;

import java.util.UUID;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

@Service
public class UserSecureService extends BaseService {
    
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
		return sessionProvider.get();
	}
	
	//보안키 생성 및 결과 반환
	public Object selectSecure(ParamsMap params) {
		
		UUID uuid = UUID.randomUUID();
		
		params.put("secureKey", uuid.toString());
		
		if (insert(params) > 0) {
			return select(params);
		}
		return null;
	}
}
