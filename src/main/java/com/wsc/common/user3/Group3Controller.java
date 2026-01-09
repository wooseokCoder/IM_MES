package com.wsc.common.user3;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/user3")
public class Group3Controller extends BaseController {
	
	@Autowired 
	private Group3Service service;
	
	@Autowired 
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseService getService() {
		return this.service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	//=====================================================//
	// 사용자그룹관리
	//=====================================================//
	@RequestMapping(value = "/usergroup3.do")
	public String openUserGroup(HttpServletRequest request, Model model) {
		return super.open(request, model, "usergroup3");
	}

	@RequestMapping(value = "/usergroup3/search.json")
	public String searchUserGroup(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchUserGroup(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/usergroup3/download.do")
	public String downloadUserGroup(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchAllUserGroup(params);
        
        //엑셀정보 정의
        setExcelParams(model, result, "UserGroup");
        
        // 뷰이름을 반환한다.
        return "jxlsView";
	}

	@RequestMapping(value = "/usergroup3/save.json")
	public String saveUserGroup(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
        
        Object result = service.saveUserGroup(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
}
