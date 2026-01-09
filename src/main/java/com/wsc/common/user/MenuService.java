/*
 * @(#)SecurityService.java 1.0 2014/07/25
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.common.user;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.model.Menu;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

/**
 * 메뉴정보 및 메뉴권한을 처리하는 서비스 클래스이다.
 *
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
@Service
public class MenuService extends BaseService {

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

	//핫메뉴 목록 검색
	public Object searchHot(ParamsMap params) {
		return searchByName("Hot", params);
	}
	//핫메뉴 조회
	public Menu selectHot(ParamsMap params) {
		return (Menu)selectByName("Hot", params);
	}

	//핫메뉴 등록
	@Transactional
	public int insertHot(ParamsMap params) {
		if (selectHot(params) != null)
			return 0;
		return insertByName("Hot", params);
	}
	//핫메뉴 수정
	@Transactional
	public int updateHot(ParamsMap params) {
		return updateByName("Hot", params);
	}
	//핫메뉴 삭제
	@Transactional
	public int deleteHot(ParamsMap params) {
		return deleteByName("Hot", params);
	}

	//핫메뉴 저장
	@Transactional
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ResultMap saveHot(ParamsMap params) {

		//등록인 경우 (단일등록)
		if (isInsert(params)) {
			insertHot(params);
		}
		//삭제인 경우 (다중삭제)
		else if (isDelete(params)) {
			List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);

			for (Map json : list) {

				ParamsMap model = new ParamsMap();
				model.putAll(json);
				//기본데이터 설정
				setBaseParams(params, model);
				//사용자 설정
				model.put("userId", params.get("userId"));

				deleteHot(model);
			}
		}
		//수정인 경우 (다중수정: 순서변경)
		else if (isUpdate(params)) {
			List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);
			int sort = 1;

			for (Map json : list) {

				ParamsMap model = new ParamsMap();
				model.putAll(json);

				//기본데이터 설정
				setBaseParams(params, model);
				//사용자 설정
				model.put("userId", params.get("userId"));
				//순서 설정
				model.put("sortSeq", sort++);

				updateHot(model);
			}
		}
        return successStatus(params);
	}

	//권한있는 메뉴 목록 검색
	@SuppressWarnings("unchecked")
	public List<Menu> searchAuthorized(ParamsMap params) {
		return (List<Menu>)searchByName("Authorized", params);
	}

	//계층구조메뉴의 권한있는 메뉴검색
	public List<Menu> searchMenuTree(ParamsMap params) {

		List<Menu> result = new ArrayList<Menu>();
		List<Menu> list   = searchAuthorized(params);

		String rootKey    = "00000"; //최상위 메뉴KEY

		if(!params.getMenuSet().isEmpty()){
			rootKey = params.getMenuSet();
		}

    	for (Menu m : list) {

    		String parent = m.getParentKey();

    		//최상위인 경우
    		if (rootKey.equals(parent)) {
    			result.add(m);
    		}
    		else {
    			buildMenuTree(result, m, parent);
    		}
    	}
		return result;
	}

	//메뉴의 계층구조 생성
	private void buildMenuTree(List<Menu> menus, Menu target, String parent) {

		if (menus == null)
			return;

		for (Menu h : menus) {
			String menuKey  = h.getMenuKey();
			List<Menu> subs = h.getSubs();

			if (menuKey.equals(parent)) {
				if (subs == null) {
					subs = new ArrayList<Menu>();
					h.setSubs(subs);
				}
				subs.add(target);
				return;
			}
			else {
				buildMenuTree(subs, target, parent);
			}
		}
	}

}
