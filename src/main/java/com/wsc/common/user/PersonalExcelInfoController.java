package com.wsc.common.user;

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
@RequestMapping("/common/user")
public class PersonalExcelInfoController extends BaseController {
	
	@Autowired 	
	private PersonalExcelInfoService service;	
	
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
	
	@RequestMapping(value = "/personalexcelinfo.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = service.search("getSelectPersonalExcelGroup", params);
		model.addAttribute("selectCode",result);
		return super.open(request, model);
	}

	@RequestMapping(value = "/personalexcelinfo/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/personalexcelinfo/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/personalexcelinfo/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/personalexcelinfo/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
}
