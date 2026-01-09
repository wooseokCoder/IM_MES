/*
 * @(#)SecurityService.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.common.user2;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.model.Program;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

/**
 * 화면정보 및 화면권한을 처리하는 서비스 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
@Service
public class Program2Service extends BaseService {
    
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
	
	//화면별 그룹권한이 있는 목록 검색
	public Object searchGroupProgram(ParamsMap params) {
		return searchByName("GroupProgram", params);
	}
	public Object searchAllGroupProgram(ParamsMap params) {
		//무조건 페이징 안함
		return searchByName("GroupProgram", params, false);
	}
	
	//화면별 그룹권한 저장
	@Transactional
	public ResultMap saveGroupProgram(Object params) {
		return saveFirstDelete("GroupProgram", params);
	}
	
	//화면별 사용자권한이 있는 목록 검색
	public Object searchUserProgram(ParamsMap params) {
		return searchByName("UserProgram", params);
	}
	public Object searchAllUserProgram(ParamsMap params) {
		//무조건 페이징 안함
		return searchByName("UserProgram", params, false);
	}
	
	//화면별 그룹권한 저장
	@Transactional
	public ResultMap saveUserProgram(Object params) {
		return saveFirstDelete("UserProgram", params);
	}
	
	//로그인사용자의 화면정보 조회
	public Program selectSecurity(ParamsMap params) {
		return (Program)selectByName("Security", params);
	}
}