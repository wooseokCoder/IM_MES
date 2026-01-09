package com.wsc.business.community;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

@Service
public class CommunityManagementService extends BaseService {
	
	
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

	@Transactional
	public Object saveComu(ParamsMap params) {
		Object result = "";
		try {
			String r_oper = params.get("oper").toString();
			Object comuId = "";
			Object bordNo = "";
			if(params.get("comuId").equals("CM")){
				comuId = dao.select("getComuId", params);
				params.add("comuId", comuId);
			}
			if(r_oper.equals("I")){				
				dao.insert("comuInsert", params);
				bordNo = dao.select("getBordNo", params);
				params.add("bordNo", bordNo);
				dao.insert("comuMenu1Insert", params);
				bordNo = dao.select("getBordNo", params);
				params.add("bordNo", bordNo);
				dao.insert("comuMenu2Insert", params);
				bordNo = dao.select("getBordNo", params);
				params.add("bordNo", bordNo);
				dao.insert("comuMenu3Insert", params);
				bordNo = dao.select("getBordNo", params);
				params.add("bordNo", bordNo);
				dao.insert("comuMenu4Insert", params);
				bordNo = dao.select("getBordNo", params);
				params.add("bordNo", bordNo);
				dao.insert("comuMenu5Insert", params);
				bordNo = dao.select("getBordNo", params);
				params.add("bordNo", bordNo);
				dao.insert("comuMenu6Insert", params);
			}else{				
				dao.insert("comuUpdate", params);
				dao.insert("comuMenu1Update", params);
				dao.insert("comuMenu2Update", params);
				dao.insert("comuMenu3Update", params);
				dao.insert("comuMenu4Update", params);
				dao.insert("comuMenu5Update", params);
				dao.insert("comuMenu6Update", params);
			}
		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}
	
	@Transactional
	public Object deleteComu(ParamsMap params) {
		Object result = "";
		try {
			dao.delete("comuDelete", params);
			dao.delete("comuMenuDelete", params);
		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}
}
