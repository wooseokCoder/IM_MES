package com.wsc.business.company;

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
public class SaledailyactivityreportService extends BaseService {

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

	String NameSpaceId = "Saledailyactivityreport";

	@Transactional
	public Object saveShetDetl(ParamsMap params) {
		Object result = "";

		try {
			Object obj = JSONValue.parseWithException(params.get("rows").toString());

			JSONArray array = (JSONArray)obj;
			JSONObject jobj = null;
			Object ShetNo = "";
			String shetNoTemp = params.get("shetNo").toString();

			if(params.get("shetNo").equals("000000")){
				ShetNo = dao.select("getShetNo", params);
				params.add("shetNo", ShetNo);
			}

			//전표등록 상세
			for(int i=0; i < array.size(); i++){
				String oper=null;
				jobj = (JSONObject)array.get(i);
				params.add("shetNoSeq", jobj.get("shetNoSeq"));
				params.add("custCode", jobj.get("custCode"));
				params.add("custName", jobj.get("custName"));
				params.add("totAmt", jobj.get("totAmt"));
				params.add("itemPrce", jobj.get("itemPrce"));
				params.add("itemCost", jobj.get("itemCost"));
				params.add("totPrce", jobj.get("totPrce"));
				params.add("totTax", jobj.get("totTax"));
				params.add("remk", jobj.get("remk"));

				oper=(String) jobj.get("oper");
				if(oper==null){
					System.out.println("null");
				}else if(jobj.get("oper").equals("I")){
					dao.insert(NameSpaceId+"insertShetMastDetl", params);
				}else if(jobj.get("oper").equals("U")){
					dao.insert(NameSpaceId+"updateShetMastDetl", params);
				}else{
					dao.delete(NameSpaceId+"deleteShetMastDetl", params);
				}
				/*System.out.println(ShetNo);
				System.out.println(jobj);*/
			}

			//전표마스터 저장 및 업데이트
			if(shetNoTemp.equals("000000")){
				dao.insert(NameSpaceId+"insertShetMast", params);
			}else{
				dao.insert(NameSpaceId+"updateShetMast", params);
			}

		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}

	@Transactional
	public void saveDelete(ParamsMap params) {
		try {
			JSONArray array = (JSONArray)params.get("modelList");
			JSONObject jobj = null;
			for(int i=0; i < array.size(); i++){
				jobj = (JSONObject)array.get(i);
				System.out.println("jobj::"+jobj);
				params.add("shetNo", jobj.get("shetNo"));
				params.add("shetType", jobj.get("shetType"));
				dao.insert(NameSpaceId+"inserDeleteShetMast", params);
				dao.insert(NameSpaceId+"inserDeleteShetDetl", params);
				dao.delete(NameSpaceId+"deleteShetDetl", params);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
