package com.wsc.business.item;

import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
public class ProductsUploadService extends BaseService {

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
	
	public ResultMap saveExcel(ParamsMap params) {
		
		List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);
		
		for (Map model : list) {

			ParamsMap m = new ParamsMap();
			m.putAll(model);

			setBaseParams(params, m);
			
			insert(m);
			
			//삭제인 경우
			/*if (isDelete(params)) {
				delete(m);
			}
			else {
				if (select(m) == null)
					insert(m);
				else
					update(m);
			}*/
		}
		// 결과를 반환한다.
        return successStatus(params);
	}
	
}
