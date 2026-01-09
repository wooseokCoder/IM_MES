/*
 * @(#)SecurityService.java 1.0 2014/07/25
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.common.user;

import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.model.Program;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.exception.ServiceException;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

/**
 * 화면정보 및 화면권한을 처리하는 서비스 클래스이다.
 *
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
@Service
public class ProgramService extends BaseService {

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

	//화면별 그룹권한이 있는 목록 검색
	public Object searchGroupProgram(ParamsMap params) {
		return searchByName("GroupProgram", params);
	}
	public Object searchAllGroupProgram(ParamsMap params) {
		//무조건 페이징 안함
		return searchByName("GroupProgram", params, false);
	}

	//화면별 그룹권한 저장
	@Transactional
	public ResultMap saveGroupProgram(Object params) {
		
		//todo
		//return saveFirstDelete("GroupProgram", params);
		
		String postKey = "GroupProgram";
		
		ParamsMap map = (ParamsMap)params;
		String code = getMessageKey("success", map);

		List<Map> list = (List<Map>)map.get(ParamsMap.MODEL_LIST);

		//기본 파라메터 셋팅 및 삭제 먼저 처리
		for (Map model : list) {

			//기본 파라메터 셋팅
			setBaseParams(map, model);

			String sql = getQueryName(postKey, model);

			//삭제 처리
			if (isDelete(model))
				delete(sql, model);
		}

		//상세조회용 SQL
		String viewSql = getNameSpace() + ".select"+postKey;

		//등록 및 수정 처리
		for (Map model : list) {

			String sql = getQueryName(postKey, model);

			//등록
			if (isInsert(model)) {
				if (select(viewSql, model) != null)
					throw new ServiceException(getMessage("error.exist"));

				//board유뮤 검색
				Object boardYn = select("selectBoardYN",model);
				if("Y".equals(boardYn)){
					String progId =  model.get("progId").toString();
					int idx = progId.lastIndexOf("/");
					String progIdCm = progId.substring(0, idx);
					insert(sql, model);
					model.put("progId", progIdCm.concat("/form.do"));               
					insert(sql, model);
					model.put("progId", progIdCm.concat("/view.do"));
					insert(sql, model);
				} else{
					insert(sql, model);
				}
				
			}
			//수정
			else if (isUpdate(model)){
				//TODO 20160928 김원국 추가
				if (select(viewSql, model) != null)
					throw new ServiceException(getMessage("error.exist"));

				update(sql, model);
			}

		}

        // 결과를 반환한다.
        return success(getMessage(code));
		
		
	}

	//화면별 사용자권한이 있는 목록 검색
	public Object searchUserProgram(ParamsMap params) {
		return searchByName("UserProgram", params);
	}
	public Object searchAllUserProgram(ParamsMap params) {
		//무조건 페이징 안함
		return searchByName("UserProgram", params, false);
	}
	
	//화면별 사용자권한이 있는 목록 검색
	public Object searchProgramListUser(ParamsMap params) {
		return searchByName("ProgramListUser", params);
	}
	public Object searchAllProgramListUser(ParamsMap params) {
		//무조건 페이징 안함
		return searchByName("ProgramListUser", params, false);
	}

	//화면별 그룹권한 저장
	@Transactional
	public ResultMap saveUserProgram(Object params) {
		return saveFirstDelete("UserProgram", params);
	}

	//화면별 사용자권한이 있는 목록 검색
	public Object searchUserProgramList(ParamsMap params) {
		return searchByName("UserProgramList", params);
	}
	public Object searchAllUserProgramList(ParamsMap params) {
		//무조건 페이징 안함
		return searchByName("UserProgramList", params, false);
	}

	//로그인사용자의 화면정보 조회
	public Program selectSecurity(ParamsMap params) {
		return (Program)selectByName("Security", params);
	}
	
    public ResultMap saveLocal(ParamsMap params) {
		String postKey = "";
		ParamsMap map = (ParamsMap)params;

		String code = getMessageKey("success", map);

		if (!map.containsKey(ParamsMap.MODEL_LIST)) {

			saveModel(postKey, map);

	        // 결과를 반환한다.
	        return success(getMessage(code));
		}

		Object data = map.get(ParamsMap.MODEL_LIST);
		if (data instanceof List) {
			List<Map> list = (List<Map>)data;
			for(Map model : list) {
				setBaseParams(map, model);

				if("I".equals(model.get("oper")) 
						&& "Board".equals(model.get("pattern"))){
					String progId =  model.get("progId").toString();
					int idx = progId.lastIndexOf("/");
					String progIdCm = progId.substring(0, idx);
					String progNm = model.get("progName").toString();
					saveModel(postKey, model);
					model.put("progId", progIdCm.concat("/form.do"));               
					model.put("progName", progNm.concat(" FORM"));       
					saveModel(postKey, model);
					model.put("progId", progIdCm.concat("/view.do"));
					model.put("progName", progNm.concat(" VIEW")); 
					saveModel(postKey, model);
					
				} else{
					saveModel(postKey, model);
				}
			}
		}
        // 결과를 반환한다.
        return success(getMessage(code));
        
    }
}