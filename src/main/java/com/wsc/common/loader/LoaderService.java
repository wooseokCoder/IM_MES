package com.wsc.common.loader;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.wsc.common.Consts;
import com.wsc.common.code.CacheComponent;
import com.wsc.common.code.CodeService;
import com.wsc.common.dao.CommonDao;
import com.wsc.common.model.Code;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.exception.ServiceException;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.framework.utils.BaseUtils;

@Service
@SuppressWarnings({ "unchecked", "rawtypes" })
public class LoaderService extends BaseService {
	
	
	@Autowired
	private CommonDao dao;
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	private Provider<SessionComponent> sessionProvider;
	
	@Autowired 
	private LoaderComponent component;
	
	@Autowired 
	private CacheComponent codeCache;
	
	@Autowired 
	private CodeService codeService;

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
	//콤보형 데이터 검색
	public Object searchCombo(Map params) {
		return searchByName("Combo", params);
	}
	
	//엑셀칼럼 목록조회
	public List searchItem(Map params) {
		return (List)searchByName("Item", params);
	}
	//엑셀칼럼 상세조회
	public LoaderItem selectItem(Map params) {
		return (LoaderItem)selectByName("Item", params);
	}
	//엑셀칼럼 등록
	@Transactional
	private void insertItem(Map params) {
		insertByName("Item", params);
	}
	//엑셀칼럼 수정
	@Transactional
	private void updateItem(Map params) {
		updateByName("Item", params);
	}
	//엑셀칼럼 삭제
	@Transactional
	private void deleteItem(Map params) {
		deleteByName("Item", params);
	}
	//엑셀칼럼 전체삭제
	@Transactional
	private void deleteItemAll(Map params) {
		deleteByName("ItemAll", params);
	}

	//엑셀로더 저장
	@Transactional
	public ResultMap save(Object obj) {
		
		ParamsMap params = (ParamsMap)obj;
		
		//다중삭제인 경우
		if (params.containsKey(ParamsMap.MODEL_LIST)) {

			List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);
			
			for(Map model : list) {
				
				ParamsMap m = new ParamsMap();
				m.putAll(model);

				setBaseParams(params, m);
				
				saveOne(m);
			}
		}
		else {
			saveOne(params);
		}
        // 결과를 반환한다.
        return successStatus(params);
	}
	
	//엑셀로더 및 칼럼 저장
	private void saveOne(ParamsMap params) {

		if (!isSaveStatus(params))
			throw new ServiceException(getMessage("error.unknown"));

		//등록,수정,삭제 처리
		if (isInsert(params) && select(params) != null)
			throw new ServiceException(getMessage("error.exist"));
		
		if (isInsert(params) && insert(params) <= 0)
			throw new ServiceException(getResultMessage("error", params));
		
		if (isUpdate(params) && update(params) <= 0)
			throw new ServiceException(getResultMessage("error", params));
		
		if (isDelete(params) && delete(params) <= 0)
			throw new ServiceException(getResultMessage("error", params));
	}
	
 	//특정 KEY에 대한 항목이 중복되어 있는지 체크한다.
 	private boolean duplicateItem(ParamsMap params) {
 		
 		//항목 검색
 		List list = searchItem(params);
 		
 		if (list == null)
 			return false;

 		List<LoaderItem> sorts = new ArrayList<LoaderItem>();
 		sorts.addAll(list);
		
 		Collections.sort(sorts, new Comparator<LoaderItem>() {
 		    @Override
 		    public int compare(LoaderItem a, LoaderItem b) {
 		    	String v1 = a.getExclCode();
 		    	String v2 = b.getExclCode();
 		        return v1.compareToIgnoreCase(v2);
 		    }
 		});
		
		List<LoaderItem> dups = new ArrayList<LoaderItem>();
		int i = 0;
		for (LoaderItem o : sorts) {
			if (i == (sorts.size()-1))
				break;
			if (o.getExclCode().equals(((LoaderItem)sorts.get(i+1)).getExclCode()))
				dups.add(o);
			i++;
		}
		return dups.size() > 0;
 	}

	//엑셀칼럼 저장처리
	@Transactional
	public ResultMap saveItem(ParamsMap params) {
		
		String code = getMessageKey("success", params);
		
		List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);
		
		//기본 파라메터 셋팅 및 삭제 먼저 처리
		for (Map model : list) {
			
			setBaseParams(params, model);
			
			model.put("exclGrup", params.get("exclGrup"));
			model.put("formCode", params.get("formCode"));
			
			//삭제 처리
			if (isDelete(model)) {
				deleteItem(model);
			}
		}
		//등록 및 수정 처리
		for(Map model : list) {
			
			//등록
			if (isInsert(model)) {
				if (selectItem(model) != null)
					throw new ServiceException(getMessage("error.exist"));
				
				insertItem(model);
			}
			//수정
			else if (isUpdate(model))
				updateItem(model);
		}
		//맵핑칼럼 중복체크
		if (duplicateItem(params))
			throw new ServiceException("맵핑칼럼이 중복된 항목이 있습니다.");
		
        // 결과를 반환한다.
        return success(getMessage(code));
	}
	
	//엑셀양식 조회 및 칼럼정의
	private LoaderForm selectForm(ParamsMap params) {
		
		String exclGrup = params.getString("exclGrup");
		
		if (BaseUtils.empty(exclGrup))
			throw new ServiceException("엑셀양식그룹이 입력되지 않았습니다.");

		//사용여부 조건설정
		params.put("useFlag", "Y");
		
		//주문정보 엑셀양식의 칼럼목록 가져오기
		List<Code> codes = codeCache.getCodeList(
			params.getString("sysId"), 
			params.getString("exclGrup")
		);
		
		//엑셀양식 조회
		LoaderForm form = (LoaderForm)select(params);
		
		if (form == null)
			throw new ServiceException("해당되는 엑셀양식을 조회할 수 없습니다.");
		
		//엑셀양식 변수목록 설정
		form.setCodes(codes);
		//엑셀양식 칼럼정의
		form.initItems(searchItem(params));
		
		return form;
	}
	
	//엑셀파일을 엑셀양식에 따라 읽어 ResultMap("columns", "data") 으로 반환하기
	public Map read(ParamsMap params, MultipartFile file, String exclGrup) {
		
		Map result = new ResultMap();
		
		if (file == null)
			return result;
		if (file.isEmpty())
			return result;
		
		try {
			params.put("exclGrup", exclGrup);
			
			//엑셀양식 및 칼럼목록 조회
			LoaderForm form = selectForm(params);

			//POI를 이용한 데이터 로드
			List rows  = component.read(file, form);
			
			if (rows == null)
				throw new ServiceException("처리할 데이터가 없습니다.");
			
			//그리드 데이터 목록
			result.put("data",     form.loadDataList(rows));
			//그리드 칼럼헤더 목록
			result.put("columns",  form.loadColumns());
			//양식명칭
			result.put("formName", form.getFormName());
			//파일명칭
			result.put("fileName", file.getOriginalFilename());
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}

	//엑셀양식 종류 저장
	public Object saveCode(ParamsMap params) {
		
		List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);
		
		if (list == null)
			return failureStatus(params);
			
		for (Map model : list) {
			model.put("codeGrup", params.get("codeGrup"));
			model.put("extChr01", params.get("extChr01"));
			
			if (!model.containsKey("sortSeq"))
				model.put("sortSeq", 1);
		}
		return codeService.save(params);
	}
	
	//엑셀파일을 엑셀양식에 따라 읽은 후 타이틀정보를 저장하기
	@Transactional
	public Map upload(ParamsMap params, MultipartFile file) {
		
		Map result = new ResultMap();
		
		if (file == null)
			return result;
		if (file.isEmpty())
			return result;
		
		try {
			//엑셀양식 및 칼럼목록 조회
			LoaderForm form = selectForm(params);
			
			//이전의 칼럼들이 있는 경우 삭제처리
			if (form.getItems() != null) {
				deleteItemAll(params);
			}
			//POI를 이용한 타이틀 로드
			List titles  = component.readTitle(file, form);
			
			if (titles == null)
				throw new ServiceException("처리할 데이터가 없습니다.");
			
			int count = 0;

			for (Map map : (List<Map>)titles) {
				
				int seq = BaseUtils.getInt(map, "itemSeq");
				
				map.putAll(params);
				map.put("itemCode", BaseUtils.getExcelField(seq, true));
				map.put("itemType", Consts.LOADER_STRING);
				map.put("itemName", map.get("itemValue"));
				
				//칼럼 저장
				insertItem(map);
				
				count++;
			}
			//처리결과
			params.put(STATUS_NAME, STATUS_INSERT);
			result = successStatus(params);
			//저장건수
			result.put("count", count);
			//양식명칭
			result.put("formName", form.getFormName());
			//파일명칭
			result.put("fileName", file.getOriginalFilename());
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
}
