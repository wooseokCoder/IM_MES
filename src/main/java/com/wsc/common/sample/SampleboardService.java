package com.wsc.common.sample;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.exception.ServiceException;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.framework.utils.BaseUtils;

@Service
@SuppressWarnings({ "unchecked", "rawtypes" })
public class SampleboardService extends BaseService {
	
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
	
	//엑셀 업로드 검증
	public List<Map<String, String>> upload(ParamsMap params) {
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		Map<String, Object> resultMap = (Map<String, Object>) dao.select("excelUpload", params);
		// 프로시저에서 반환된 v_MSG를 result에 추가
		Map<String, String> resultItem = new java.util.HashMap<String, String>();
		if (resultMap != null && resultMap.containsKey("v_MSG")) {
			resultItem.put("v_MSG", (String) resultMap.get("v_MSG"));
		} else {
			resultItem.put("v_MSG", "Success");
		}
		result.add(resultItem);
		return result;
	}
	
	//엑셀 업로드 저장
	@Transactional
	public ResultMap saveExcel(ParamsMap params) {
		List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);
		for (Map model : list) {
			ParamsMap m = new ParamsMap();
			m.putAll(model);
			setBaseParams(params, m);
			// bordGrup 기본값 설정
			if (!m.containsKey("bordGrup") || m.get("bordGrup") == null) {
				m.put("bordGrup", "B12");
			}
			dao.select("excelUpdate", m);
		}
		return successStatus(params);
	}
	
}

