package com.wsc.common.user2;

import java.util.List;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.model.Group;
import com.wsc.common.model.User;
import com.wsc.common.security.SessionComponent;
import com.wsc.common.user.GroupService;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;

@Service
public class User2Service extends BaseService {
    
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
    
	@Autowired
	private GroupService groupService;

	//인증 체크
	public String checkPassword(ParamsMap params) {
		return getString(getNameSpace()+".checkPassword", params);
	}

	//비밀번호 변경 처리
	@Transactional
	public int updatePassword(ParamsMap params) {
		return updateByName("Password", params);
	}

	//로그인 실패시 카운트 증가
	@Transactional
	public int updateFailure(ParamsMap params) {
		return updateByName("Failure", params);
	}

	//로그인 성공시 실패카운트 리셋 및 최종로그인일시 업데이트
	@Transactional
	public int updateSuccess(ParamsMap params) {
		return updateByName("Success", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object select(Object params) {
		
		User result = (User)super.select(params);
		
		if (result != null) {
			ParamsMap p = (ParamsMap)params;

			List<RecordMap> list = (List<RecordMap>)groupService.searchUserGroup(p);
			
			if (list != null) {
				
				Group[] groups = new Group[list.size()];
				int i = 0;
				
				for (RecordMap r : list) {
					Group group = new Group();
					group.setGroupId  (r.getString("groupId"));
					group.setGroupName(r.getString("groupName"));
					groups[i++] = group;
				}
				result.setGroups(groups);
			}
		}
		return result;
	}
	
	@Transactional
	public Object saveDealUser(ParamsMap params) {
		Object result = "";
		try {
			if(params.get("oper").equals("I")) {
				dao.insert("saveDealer", params);
				dao.insert("saveDealerUser", params);
			}
			else {
				dao.update("updateDealer", params);
				dao.update("updateDealerUser", params);
			}
		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}
	
	@Transactional
	public Object updateDealUser(ParamsMap params) {
		Object result = "";
		try {
			dao.update("updateDealer", params);
			dao.update("updateDealerUser", params);

		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}
	
}
