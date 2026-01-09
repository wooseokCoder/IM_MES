package com.wsc.common.user2;

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
@RequestMapping("/common/user2")
public class Program2Controller extends BaseController {
	
	@Autowired 
	private Program2Service service;
	
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
	// 사용자화면관리
	//=====================================================//
	@RequestMapping(value = "/userprogram2.do")
	public String openUserProgram(HttpServletRequest request, Model model) {
		return super.open(request, model, "userprogram2");
	}

	@RequestMapping(value = "/userprogram2/search.json")
	public String searchUserProgram(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchUserProgram(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/userprogram2/download.do")
	public String downloadUserProgram(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchAllUserProgram(params);
        
        //엑셀정보 정의
        setExcelParams(model, result, "UserProgram");
        
        // 뷰이름을 반환한다.
        return "jxlsView";
	}

	@RequestMapping(value = "/userprogram2/save.json")
	public String saveUserProgram(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
        
        Object result = service.saveUserProgram(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	//=====================================================//
	// 그룹화면관리
	//=====================================================//
	@RequestMapping(value = "/groupprogram2.do")
	public String openGroupProgram(HttpServletRequest request, Model model) {
		return super.open(request, model, "groupprogram2");
	}

	@RequestMapping(value = "/groupprogram2/search.json")
	public String searchGroupProgram(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchGroupProgram(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/groupprogram2/download.do")
	public String downloadGroupProgram(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchAllGroupProgram(params);
        
        //엑셀정보 정의
        setExcelParams(model, result, "GroupProgram");
        
        // 뷰이름을 반환한다.
        return "jxlsView";
	}

	@RequestMapping(value = "/groupprogram2/save.json")
	public String saveGroupProgram(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
        
        Object result = service.saveGroupProgram(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

}
