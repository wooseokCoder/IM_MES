package com.wsc.business.item;

import java.util.List;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;

@Service
public class CommodityMaterialCodeService extends BaseService {
	
	
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

	public List searchAll(Object params) {
		return super.search(getNameSpace()+".searchAll", params);
	}
}
