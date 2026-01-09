package com.wsc.common.board;

import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.Consts;
import com.wsc.common.code.CacheComponent;
import com.wsc.common.dao.CommonDao;
import com.wsc.common.file.FileService;
import com.wsc.common.model.Code;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.exception.ServiceException;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.framework.utils.BaseUtils;

@Service
@SuppressWarnings({ "unchecked", "rawtypes" })
public class NavHelpService extends BaseService {
	
	@Autowired
	private CommonDao dao;
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	private CacheComponent cache;
	
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
	
	@Autowired
	private FileService fileService;
	
	public Object selectView(ParamsMap params) {
		
		//게시물 조회
		RecordMap board = (RecordMap)selectNavHelpByMenuUrl(params);
		
		// 조회 결과
		RecordMap result = null;
		
		if(board.get("BORD_NO") != null) { //없는 게시물
			//읽기상태일 경우 게시대상 업데이트
			updateView(params);
			
			// 사용여부조건 설정
	        // params.put("useFlag", "Y");

	    	// 게시대상자 정보가 있는경우 해당정보 조회
	    	if (params.containsKey("tgtUserId")) {
	        	result = (RecordMap)selectTarget(params);
	    	}
	    	else {
	    		result = (RecordMap)select(params);
	    	}
		}
		else {
			result = (RecordMap)select(params);
		}
        
        //게시글 수정,삭제가 가능한지 확인
        if (result != null) {
        	
        	String regiId = result.getRegiId();
        	String userId = params.getString(ParamsMap.GS_USER_ID);
        	boolean admin = params.getBoolean(ParamsMap.GS_ADMIN);
        	String editYN = (String) select("editCheck", params);
        	
        	if (admin)
        		result.put("editable", true);
        	else if (BaseUtils.equal(userId, regiId))
        		result.put("editable", true);
        	else if ("1".equals(editYN))
        		result.put("editable", true);
	        //팝업의 오픈타입이 있을 경우 해당 값 조회
        	setOpenTypeCode(result);
        }
        return result;
	}
	
	//팝업의 오픈타입이 있을경우 해당코드 조회 및 값 정의
	public void setOpenTypeCode(RecordMap result) {
		if (result == null)
			return;
		if (result.get("openType") == null)
			return;
		
		String sysId    = result.getSysId();
		String codeCd   = result.getString("openType");
		String codeGrup = Consts.OPEN_TYPE_CODE;
		
		Code c = cache.getCode(sysId, codeGrup, codeCd);
		
		if (c == null)
			return;
		
		result.put("openName", c.getCodeName());
		result.put("width" , c.getExtNum01()); //팝업의 너비
		result.put("height", c.getExtNum02()); //팝업의 높이
		result.put("pointX", c.getExtNum03()); //팝업의 X좌표
		result.put("pointY", c.getExtNum04()); //팝업의 Y좌표
	}
	
	/**
	 * 게시판 상세조회시 조회수 처리
	 * 게시대상이 ALL인 경우 게시대상에 저장
	 * 게시대상에 있을 경우 조회카운트 증가안함.
	 * 
	 * @param params(ParamsMap) 화면에서받은 데이터
	 */
	@Transactional
	private void updateView(ParamsMap params) {

		//상세조회일 경우에만 조회수 처리
		if (isRead(params) == false)
			return;
		
		//저장대상 객체 생성
		ParamsMap obj = new ParamsMap();
		obj.putAll(params);
		
		//게시타입
		String bordType = obj.getString("bordType");

		//게시대상자 정의
		obj.put("tgtUserId", obj.get("gsUserId"));
		
		//게시대상 조회
		RecordMap data = (RecordMap)selectTarget(obj);
		System.out.println("!!!!!!!!!!!!!!!!!!!!!게시대상확인용!!!!!!!!!!!!!!!!!!!!!!!!");
		System.out.println(obj);
		//게시대상이 전체일 경우
		if ("ALL".equals(bordType)) {
			
			//게시대상으로 이미 기록되어 있다면 SKIP
			if (data != null)
				return;

			//조회수 증가
			updateReadCnt(obj);
			
			//확인일자 기록
			obj.put("readYn",   "Y");
			obj.put(STATUS_NAME, STATUS_INSERT);
			
			//게시대상 저장
			//팝업게시판은 제외
			if("B06".equals(obj.getString("bordGrup")))
				return;
			insertTarget(obj);
		}
		//게시대상이 사용자지정일 경우
		else if ("USR".equals(bordType)) {
			
			//게시대상이 아닌경우 SKIP
			if (data == null)
				return;
			
			//확인일자가 없는 경우
			if (BaseUtils.empty(data.get("readDate"))) {
				//게시대상 확인일자 업데이트
				updateTargetRead(obj);
			}
		}
	}
	
	//게시대상 확인일자 업데이트
	@Transactional
	private void updateTargetRead(ParamsMap params) {
		updateByName("TargetRead", params);
	}
	
	//조회수 증가
	@Transactional
	private void updateReadCnt(ParamsMap params) {
		updateByName("ReadCnt", params);
	}

	//게시판 저장
	@Transactional
	public ResultMap save(Object params) {
		
		ParamsMap map = (ParamsMap)params;
		
		//TODO 게시판 수정,삭제시 작성가능 권한 확인해야함.
		
		//다중삭제인 경우
		if (map.containsKey(ParamsMap.MODEL_LIST)) {

			List<Map> list = (List<Map>)map.get(ParamsMap.MODEL_LIST);
			
			for(Map model : list) {
				
				ParamsMap m = new ParamsMap();
				m.putAll(model);

				setBaseParams(map, m);
				
				saveOne(m);
			}
		}
		else {
			saveOne(map);
		}
        // 결과를 반환한다.
        return success(getResultMessage("success", map));
	}
	
	//게시판 저장 및 파일,게시대상 저장 처리
	private void saveOne(ParamsMap params) {
		
		//파일목록
		params.put("fileList", BaseUtils.getJsonList(params, "files"));

		if (!isSaveStatus(params))
			throw new ServiceException(getMessage("error.unknown"));

		//게시판 등록,수정,삭제 처리
		if (isInsert(params) && select(params) != null)
			throw new ServiceException(getMessage("error.exist"));
		
		if (isInsert(params) && insert(params) <= 0)
			throw new ServiceException(getResultMessage("error", params));
		
		if (isUpdate(params) && update(params) <= 0)
			throw new ServiceException(getResultMessage("error", params));
		
		if (isDelete(params)) {
			//비활성변경타입인 경우
			if (Consts.isDiableBoard(params.getString("bordGrup"))) {
				if (updateDisable(params) <= 0)
					throw new ServiceException(getResultMessage("error", params));
			}
			//일반삭제타입인 경우
			else {
				if (delete(params) <= 0)
					throw new ServiceException(getResultMessage("error", params));
			}
		}
		
		//게시대상 저장처리
		saveTarget(params);
		
		params.put("atchGrup", params.get("bordGrup"));
		params.put("atchNo",   params.get("bordNo"));

		//파일 등록,수정,삭제 처리
		fileService.saveFile(params);
	}
	
	//게시판 비활성처리(보낸메일함에서 삭제시 사용됨)
	@Transactional
	public int updateDisable(Map params) {
		return updateByName("Disable", params);
	}
	
	//게시대상 목록 검색
	public Object searchTarget(ParamsMap params) {
		return searchByName("Target", params);
	}
	
	//게시대상 상세 조회
	public Object selectTarget(ParamsMap params) {
		return selectByName("Target", params);
	}

	//게시대상 저장 처리
	@Transactional
	private void saveTarget(ParamsMap params) {
		
		//게시대상정보가 있을 경우에만 처리한다.
		if (params.containsKey("targetValue") == false)
			return;
		
		String oper = params.getString(STATUS_NAME);
		
		//등록인 경우
		if (isInsert(oper)) {
			//게시대상 사용자ID 배열설정
			params.put("targets", BaseUtils.split(params.getString("targetValue"), "|"));
			//게시대상 저장
			insertTarget(params);
		}
		//삭제인 경우(전체삭제)
		else if (isDelete(oper)) {
			//게시대상 삭제
			deleteTarget(params);
		}
		
		// popup화면 딜러업데이트
		if (isUpdate(oper) && "B06".equals(params.get("bordGrup"))){
			if ("USR".equals(params.get("typeKey"))){
				
				//게시대상 삭제
				deleteTarget(params);
				//게시대상 사용자ID 배열설정
				params.put("targets", BaseUtils.split(params.getString("targetValue"), "|"));
				//게시대상 저장
				insertTarget(params);
			}else{
				//게시대상 저장
				deleteTarget(params);
			}
		}
	}
	
	//게시대상 등록
	@Transactional
	private void insertTarget(ParamsMap params) {
		//게시대상 저장
		insertByName("Target", params);
	}
	
	//게시대상 삭제
	@Transactional
	private void deleteTarget(ParamsMap params) {
		deleteByName("TargetAll", params);
	}
	
	//게시대상 비활성처리(받은메일함에서 삭제시 사용됨)
	@Transactional
	public void updateTargetDisable(Map params) {
		updateByName("TargetDisable", params);
	}
	
	//전자메일 삭제처리
	@Transactional
	public ResultMap deleteEmail(ParamsMap params) {
		
    	//화면타입
    	String type = params.getString("pageType");
		//삭제대상목록
		List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);
    	
		for (Map model : list) {
			
			setBaseParams(params, model);
			
	    	// 받은메일함인 경우 게시대상 비활성
	    	if (Consts.EMAIL_RECEIVE_TYPE.equals(type)) {
	    		updateTargetDisable(model);
	    	}
	    	// 보낸메일함인 경우 게시판 비활성
	    	else {
	    		updateDisable(model);
	    	}
		}
        // 결과를 반환한다.
        return successStatus(params);
	}
	
	//조회자목록 검색
	public Object searchViewsList(ParamsMap params) {
		return searchByName("ViewsList", params);
	}
	
	//팝업 더이상안보기
	public void popupTarget(ParamsMap params) {
		
		String bordType = params.getString("bordType");
		
		if ("ALL".equals(bordType) || "DLR".equals(bordType) || "LSA".equals(bordType)) {
			params.put("readYn","Y");
			insertTarget(params);
		}
		//게시대상이 사용자지정일 경우
		else if ("USR".equals(bordType)) {
			params.put("tgtUserId", params.get("gsUserId"));
			updateTargetRead(params);
		}
			
	}
	
	public Object selectNavHelpByMenuKey(ParamsMap params) {
		return selectByName("NavHelpByMenuKey", params);
	}
	
	public Object selectNavHelpByMenuUrl(ParamsMap params) {
		return selectByName("NavHelpByMenuUrl", params);
	}
	
	public Object selectNavHelpExistsByMenuUrl(ParamsMap params) {
		return selectByName("NavHelpExistsByMenuUrl", params);
	}
	
}
