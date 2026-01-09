package com.wsc.common.user;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.util.StringUtils;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

@Service
public class BatchWorkReviseService extends BaseService {
	
	
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
	
	public Object searchUserGroup(ParamsMap params) {
		return searchByName("UserGroup", params);
	}
	
	String NameSpaceId = "BatchWorkRevise";
	
	@Transactional
	public Object saveJob(ParamsMap params) { // ajax 통신기법 해당 함수
		Object result = "";

		try {

			String crud = params.get("crud").toString();

			if(crud.equals("i")){
				dao.insert(NameSpaceId+"insertJob", params);			
			} else if(crud.equals("u")){
				dao.update(NameSpaceId+"updateJob", params);
			}

		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}		
}
