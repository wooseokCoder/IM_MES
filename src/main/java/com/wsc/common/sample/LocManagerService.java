package com.wsc.common.sample;

import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.framework.utils.BaseUtils;

/**
 * 위치 관리 서비스
 * 캔버스 박스 위치 관리 관련 비즈니스 로직 처리
 */
@Service
public class LocManagerService extends BaseService {
	
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
	
	/**
	 * 박스 위치 정보 조회
	 */
	public Object search(ParamsMap params) {
		return super.search(getNameSpace() + ".search", params);
	}
	
	/**
	 * 박스 위치 정보 저장
	 */
	@Override
	@org.springframework.transaction.annotation.Transactional
	public ResultMap save(Object obj) {
		ParamsMap params = (ParamsMap) obj;
		String boxListStr = params.getString("boxList");
		String wareHous = params.getString("wareHous");
		
		// 해당 wareHous의 기존 박스 목록 조회 (useFlag = 'Y'인 것만)
		ParamsMap searchParams = new ParamsMap();
		searchParams.put("sysId", params.getString("sysId"));
		searchParams.put("wareHous", wareHous);
		searchParams.put("useFlag", "Y");
		Object searchResult = search(searchParams);
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> existingBoxes = null;
		if (searchResult instanceof ResultMap) {
			ResultMap resultMap = (ResultMap) searchResult;
			existingBoxes = (List<Map<String, Object>>) resultMap.get("rows");
		} else if (searchResult instanceof Map) {
			Map<String, Object> resultMap = (Map<String, Object>) searchResult;
			existingBoxes = (List<Map<String, Object>>) resultMap.get("rows");
		} else if (searchResult instanceof List) {
			existingBoxes = (List<Map<String, Object>>) searchResult;
		}
		
		if (existingBoxes == null) {
			existingBoxes = new java.util.ArrayList<Map<String, Object>>();
		}
		
		// 현재 저장하려는 박스의 locNo 목록 생성
		java.util.Set<String> currentLocNos = new java.util.HashSet<String>();
		
		if (boxListStr != null && !boxListStr.isEmpty()) {
			// JSON 문자열을 List로 변환
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> boxList = BaseUtils.getJsonList(boxListStr);
			
			if (boxList != null) {
				// 각 박스를 저장
				for (Map<String, Object> box : boxList) {
					String locNo = (String) box.get("locNo");
					currentLocNos.add(locNo);
					
					ParamsMap boxParams = new ParamsMap();
					boxParams.putAll(params);
					boxParams.putAll(box);
					setBaseParams(params, boxParams);
					// useFlag를 항상 'Y'로 설정
					boxParams.put("useFlag", "Y");
					
					// 기존 데이터 존재 여부 확인
					ParamsMap checkParams = new ParamsMap();
					checkParams.put("sysId", params.getString("sysId"));
					checkParams.put("locNo", locNo);
					Object existResult = dao.select(getNameSpace() + ".select", checkParams);
					
					if (existResult != null) {
						// 기존 데이터가 있으면 update
						dao.update(getNameSpace() + ".update", boxParams);
					} else {
						// 없으면 insert
						dao.insert(getNameSpace() + ".insert", boxParams);
					}
				}
			}
		}
		
		// 기존 박스 중에서 현재 저장 목록에 없는 박스는 삭제
		if (existingBoxes != null) {
			for (Map<String, Object> existingBox : existingBoxes) {
				String existingLocNo = (String) existingBox.get("locNo");
				if (!currentLocNos.contains(existingLocNo)) {
					// 삭제 처리
					ParamsMap deleteParams = new ParamsMap();
					deleteParams.put("sysId", params.getString("sysId"));
					deleteParams.put("locNo", existingLocNo);
					dao.delete(getNameSpace() + ".delete", deleteParams);
				}
			}
		}
		
		return successStatus(params);
	}
	

	public Object checkSign(ParamsMap params) {
		setBaseParams(params, params);
		Object result = dao.select(getNameSpace() + ".checkSign", params);
		return result;
	}

}

