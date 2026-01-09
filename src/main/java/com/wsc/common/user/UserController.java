package com.wsc.common.user;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.wsc.common.code.CodeService;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

@Controller
@RequestMapping("/common/user")
@SessionAttributes("user")
public class UserController extends BaseController {
	@Autowired 
	private UserService userService;
	@Autowired 	
	private CodeService codeService;
	@Autowired 
	private GroupService groupService;
	@Autowired 
	private UserSecureService userSecureService;
	@Autowired 
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseService getService() {
		return this.userService;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	@RequestMapping(value = "/user.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"USE_FLAG"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
		return super.open(request, model);
	}

	@RequestMapping(value = "/user/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/user/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/user/download2.do")
	public String download2(HttpServletRequest request, Model model) {
		return super.download(request, model, "search" , "UserList");
	}

	@RequestMapping(value = "/user/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/user/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/user/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	//관리자 자동로그인시 보안키 생성 및 반환
	@RequestMapping(value = "/user/secure.json")
	public String secure(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request);
        
        Object result = userSecureService.selectSecure(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
}
