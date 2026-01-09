package com.wsc.common.tbd;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.common.user.PasswordService;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

@Controller
@RequestMapping("/common/tbdcs")
public class TbdCSController extends BaseController {
	@Autowired 
	private PasswordService passwordService;
	@Autowired 
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseService getService() {
		return this.passwordService;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	@RequestMapping(value = "/tbdcs.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model);
	}
	
	@RequestMapping(value = "/userpassword.do")
	public String userOpen(HttpServletRequest request, Model model) {
		return super.open(request, model, "userPassword");
	}
	
	@RequestMapping(value = "/save.json")
	public String save(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	
    	Object result = passwordService.update("updateUserPw", params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/userPwChk.json")
	public String chkPw(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	
    	Object result = passwordService.select("chkUserPw", params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/saveUserPw.json")
	public String saveUserPw(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	
    	Object result = passwordService.update("updateUserPw-user", params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
}
