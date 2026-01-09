package com.wsc.business.employee;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.wsc.common.security.SessionComponent;
import com.wsc.common.code.CodeService;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.utils.DateUtils;

/**
 * Handles requests for the application home page.
 */

@Controller
@RequestMapping("/business/employee")
//@SessionAttributes("user")
public class EmployeeController extends BaseController {
	@Autowired
	private EmployeeService service;

	@Autowired
	private Provider<SessionComponent> sessionProvider;
	
	@Autowired 
	private CodeService codeService;

	@Override
	protected BaseService getService() {
		return this.service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}

	@RequestMapping(value = "/employee.do")
	public String open(HttpServletRequest request, Model model) {
		
		
		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"EXIT_YN"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
		return super.open(request, model);
	}

	@RequestMapping(value = "/employee/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);

	}


	@RequestMapping(value = "/employee/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/employee/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/employee/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/employee/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/employee/getEmplNo.json")
	public String getNo(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.search("getEmplNo", params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

}
