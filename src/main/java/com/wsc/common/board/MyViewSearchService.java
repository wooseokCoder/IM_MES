package com.wsc.common.board;

import java.util.List;
import java.util.Map;

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
import com.wsc.common.file.FileService;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.exception.ServiceException;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.framework.utils.BaseUtils;


@Service
public class MyViewSearchService extends BaseService {
    
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
	
	
	@Transactional
	public Object saveViewColList(ParamsMap params) {
		Object result = "";
		try {
			//System.out.println(params);
			String windId = params.get("windId").toString();
			String viewId = params.get("viewId").toString();
			
			// 수정일 경우 기존 column list 삭제 후 다시 저장 
			if(params.get("oper").toString().equals("U")) {
				dao.update("deleteMyViewColList", params);
			}
			
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
			
			for (int i = 0; i < rows.size(); i++) {
		        Map<String, Object> row = rows.get(i);
		        params.add("windId",     windId);
				params.add("viewId",     viewId);
				params.add("colId",      row.get("COL_ID"));
				params.add("colDesc",    row.get("COL_DESC"));
				params.add("viewSeq",    row.get("VIEW_SEQ"));
				params.add("viewType",   row.get("VIEW_TYPE"));
				params.add("exceColId",  row.get("EXCE_COL_ID"));
				params.add("style",      row.get("STYLE"));
				params.add("exceDownYn", row.get("EXCE_DOWN_YN"));
				params.add("mergCode",   row.get("MERG_CODE"));
				
				dao.insert("saveMyViewColList", params);
		    }
			
		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}
	
}
