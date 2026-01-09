package com.wsc.common.user3;

import javax.inject.Provider;

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

@Service
public class Group3Service extends BaseService {
	
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
	
	//그룹별 사용자 목록 검색
	public Object searchUserGroup(ParamsMap params) {
		return searchByName("UserGroup", params);
	}
	public Object searchAllUserGroup(ParamsMap params) {
		//무조건 페이징 안함
		return searchByName("UserGroup", params, false);
	}
	
	//그룹별 사용자 저장
	@Transactional
	public ResultMap saveUserGroup(Object params) {
		return saveFirstDelete("UserGroup", params);
	}
}
