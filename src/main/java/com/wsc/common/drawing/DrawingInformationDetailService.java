package com.wsc.common.drawing;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.apache.commons.collections.map.LinkedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.file.FileService;
import com.wsc.common.model.PhoneBook;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.exception.ServiceException;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.framework.utils.BaseUtils;

@Service
public class DrawingInformationDetailService extends BaseService {

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
	
	@Autowired
	private FileService fileService;

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
	
	public Object submit(ParamsMap params) {
		Object result = "";
		try {
			saveOne(params);
			result = "Success";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	private void saveOne(ParamsMap params) {
		String NDA_NO = "";
		String LIST_NO = "";
		if (isUpdate(params) || isInsert(params)){
			if (isInsert(params)){
				NDA_NO = (String)select("getNdaFileNo2", params).toString();
				params.put("bordNo",   NDA_NO);
				
				//화면상 기본데이터 등록
				LIST_NO = (String)select("drawListInsert", params).toString();
				params.put("listNo", LIST_NO);
				
				String[] itemType = (String[])params.get("itemType");
				String[] itemCode = (String[])params.get("itemCode");
				String[] itemName = (String[])params.get("itemName");
				String[] num = (String[])params.get("num");
				String[] boxX = (String[])params.get("boxX");
				String[] boxY = (String[])params.get("boxY");
				String[] toolX = (String[])params.get("toolX");
				String[] toolY = (String[])params.get("toolY");
				String[] itemUse = (String[])params.get("itemUse");
				
				for(int i = 0; i < itemType.length; i++){
					params.put("itemType", itemType[i]);
					params.put("itemCode", itemCode[i]);
					params.put("itemName", itemName[i]);
					params.put("num", num[i]);
					params.put("boxX", boxX[i]);
					params.put("boxY", boxY[i]);
					params.put("toolX", toolX[i]);
					params.put("toolY", toolY[i]);
					params.put("itemUse", itemUse[i]);
					dao.insert("drawItemInsert", params);
				}
			} else {
				if(params.get("atchNo") == null){
					NDA_NO = (String)select("getNdaFileNo2", params).toString();
				} else {
					NDA_NO = params.get("atchNo").toString();
				}
				params.put("bordNo", NDA_NO);
				
				dao.update("drawListUpdate", params);
				
				String[] itemType = (String[])params.get("itemType");
				String[] itemCode = (String[])params.get("itemCode");
				String[] itemName = (String[])params.get("itemName");
				String[] num = (String[])params.get("num");
				String[] boxX = (String[])params.get("boxX");
				String[] boxY = (String[])params.get("boxY");
				String[] toolX = (String[])params.get("toolX");
				String[] toolY = (String[])params.get("toolY");
				String[] itemUse = (String[])params.get("itemUse");
				
				for(int i = 0; i < itemType.length; i++){
					params.put("itemType", itemType[i]);
					params.put("itemCode", itemCode[i]);
					params.put("itemName", itemName[i]);
					params.put("num", num[i]);
					params.put("boxX", boxX[i]);
					params.put("boxY", boxY[i]);
					params.put("toolX", toolX[i]);
					params.put("toolY", toolY[i]);
					params.put("itemUse", itemUse[i]);
					dao.update("drawItemUpdate", params);
				}
			}
		}
		
//		if (isDelete(params)) {
//			if (delete(params) <= 0)
//				throw new ServiceException(getResultMessage("error", params));
//		}
		
//		//공유대상 저장처리
		params.put("atchGrup", params.get("bordGrup"));
		params.put("atchNo",   params.get("bordNo"));
		
//		//파일 등록,수정,삭제 처리
		params.put("fileList", BaseUtils.getJsonList(params, "files"));
		fileService.saveFile(params);
	}

	@Cacheable(value="codeCache")
	public Map<String, LinkedMap> searchCodes(String sysId) {
		
		ParamsMap params = new ParamsMap();
		params.put("sysId", sysId);
		
        try {
        	params.put(ParamsMap.GS_LANG,      getSessionComponent().getLocale().toString());
		} catch (NullPointerException e) {
			params.put(ParamsMap.GS_LANG,      "ko");
		}
		
		//그룹이 먼저 검색되도록 설정되어 있어야 함.
		List<PhoneBook> list = searchAll(params);
		
		Map<String, LinkedMap> map = new HashMap<String, LinkedMap>();
		
		map.put("0", new LinkedMap());
		return map;
		}
	
	@CacheEvict(value="codeCache", allEntries=true)
	public ResultMap saveExcel(ParamsMap params) {
		
		List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);
		
		for (Map model : list) {

			ParamsMap m = new ParamsMap();
			m.putAll(model);

			setBaseParams(params, m);
			
			//삭제인 경우
			if (isDelete(params)) {
				delete(m);
			}
			else {
				if (select(m) == null)
					insert(m);
				else
					update(m);
			}
		}
		// 결과를 반환한다.
        return successStatus(params);
	}
}
