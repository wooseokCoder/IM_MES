package com.wsc.common.code3;

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

import com.wsc.common.Consts;
import com.wsc.common.dao.CommonDao;
import com.wsc.common.model.Code;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

@SuppressWarnings({ "unchecked", "rawtypes" })
@Service
public class Code3Service extends BaseService {
	
	
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

	@Cacheable(value="codeCache")
	public Map<String, LinkedMap> searchCodes(String sysId) {
		
		ParamsMap params = new ParamsMap();
		params.put("sysId", sysId);
		
        try {
        	System.out.println("★" + getSessionComponent().getLocale().toString());
        	params.put(ParamsMap.GS_LANG,      getSessionComponent().getLocale().toString());
		} catch (NullPointerException e) {
			params.put(ParamsMap.GS_LANG,      "ko");
		}
		
		//그룹이 먼저 검색되도록 설정되어 있어야 함.
		List<Code> list = searchAll(params);
		
		Map<String, LinkedMap> map = new HashMap<String, LinkedMap>();
		
		map.put("0", new LinkedMap());
		
		for (Code c : list) {
			if ("0".equals(c.getCodeGrup())) {
				map.put(c.getCodeCd(), new LinkedMap());
			}
			LinkedMap lmap = map.get(c.getCodeGrup());
			if (lmap != null) {
				lmap.put(c.getCodeCd(), c);
			}
		}
		return map;
	}

/*	@Override
	@CacheEvict(value="codeCache", allEntries=true)
	public ResultMap save(Object params) {
		
		ParamsMap map = (ParamsMap)params;
		String code = getMessageKey("success", map);

		if (!map.containsKey(ParamsMap.MODEL_LIST)) {

			saveCode(map);
			
	        // 결과를 반환한다.
	        return success(getMessage(code));
		}
		
		Object data = map.get(ParamsMap.MODEL_LIST);
		if (data instanceof List) {
			List<Map> list = (List<Map>)data;
			for(Map model : list) {

				setBaseParams(map, model);
				saveCode(model);
			}
		}
        // 결과를 반환한다.
        return success(getMessage(code));
	}
	
	protected void saveCode(Map model) {
		
		//삭제일 경우
		if (super.isDelete(model)) {
			//코드그룹인 경우 해당 하위코드도 삭제헤야 함.
			if (Consts.ROOT_CODE.equals(model.get("codeGrup"))) {
				
				ParamsMap params = new ParamsMap();
				params.put("sysId",     model.get("sysId"));
				params.put("codeGrup",  model.get("codeCd"));
				params.put(STATUS_NAME, STATUS_DELETE);
				
				super.deleteByName("All", params);
			}
		}
		super.saveModel(model);
	}*/
	
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
