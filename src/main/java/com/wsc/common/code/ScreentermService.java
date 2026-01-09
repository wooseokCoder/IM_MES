package com.wsc.common.code;

import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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
public class ScreentermService extends BaseService {
    
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
	public String saveTerm(ParamsMap params) {
		String resultType = "OK";
		int insertCnt = 0;
	    String str = "{\"data\":"+params.get("data")+"}";
	    JSONParser jsonParser = new JSONParser();
	    try {
			JSONObject jsonObject = (JSONObject) jsonParser.parse(str);
			JSONArray termInfo = (JSONArray) jsonObject.get("data");
			for(int i=0; i < termInfo.size(); i++){
				JSONObject model = (JSONObject)termInfo.get(i);
				params.add("itemGrp", model.get("itemGrp"));
				params.add("itemId", model.get("itemId"));
				params.add("itemNm", model.get("itemNm"));
				params.add("useFlag", "Y");
				if(select(params) == null){
					insert(params);
					insertCnt++;
				}
			}
			if(insertCnt < 1 ){
				resultType = "ZERO";
			}
			
		} catch (Exception e) {
			resultType = "ERR";
		}
		
		return resultType;
	}
	
}
