package com.wsc.business.item;

import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
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
public class ProductsViewService extends BaseService {

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

	String NameSpaceId = "Item";
	@Transactional
	public Object saveItem(ParamsMap params) {
		Object result = "";
		try {
			Object itemCode = "";
			Object chkItem = "";
			Object itemCodeV="";
			String incomeSeqTemp = params.get("itemCode").toString();
			if(incomeSeqTemp.equals("")){
				itemCodeV = dao.select("getItemCode", params);

				params.add("itemCode_a", itemCodeV);
				dao.insert(NameSpaceId+"insert", params);
				result = itemCode;
				dao.insert(NameSpaceId+"insertInvt", params);
			}else{
				dao.insert(NameSpaceId+"update", params);
				result = incomeSeqTemp;
				chkItem = dao.select("selectInvt", params);
				System.out.println(chkItem+"@@@@@chkItem@@@@@@@@@");
				//System.out.println(chkItem.equals(chkItem));
				//System.out.println(chkItem.toString().isEmpty());
				if(null == chkItem){
					params.add("itemCode_a", incomeSeqTemp);
					dao.insert(NameSpaceId+"insertInvt", params);
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}

	@Transactional
	public void deleteInvtMast(ParamsMap params) {
		try {
			System.out.println("params::"+params);
			dao.delete("deleteInvtMast", params);
		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
	}

}
