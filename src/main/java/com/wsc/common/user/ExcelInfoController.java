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
public class ExcelInfoController extends BaseController {
	
	@Autowired 	
	private ExcelInfoService service;	
	
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
	
	@RequestMapping(value = "/excelinfo.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = service.search("getSelectExcelGroup", params);
		model.addAttribute("selectCode",result);
		return super.open(request, model);
	}

	@RequestMapping(value = "/excelinfo/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/excelinfo/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/excelinfo/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/excelinfo/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
}
