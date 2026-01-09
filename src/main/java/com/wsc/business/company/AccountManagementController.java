package com.wsc.business.company;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.code.CodeService;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/business/company")
public class AccountManagementController extends BaseController {

	@Autowired
	private AccountManagementService service;
	@Autowired
	private CodeService codeService;
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

	@RequestMapping(value = "/accountmanagement.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"CUST_TYPE","COMP_GRADE","SITE_DEPT","TAX_TYPE","SAL_EPLY_TYPE","PAY_ACC_TYPE","TAX_BILL_CLASS","BILL_ISSUE","TAX_CLASS"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);

		Object result2 = service.search("getSelectCode2", params);
		model.addAttribute("selectCode2",result2);
		return super.open(request, model, "accountManagement");
	}

	@RequestMapping(value = "/accountmanagement/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/accountmanagement/searchCount.json")
	public String searchCount(HttpServletRequest request, Model model) {
		return super.search(request, model,"searchCount");
	}
	@RequestMapping(value = "/accountmanagement/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/accountmanagement/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/accountmanagement/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	
	@RequestMapping(value = "/accountmanagement/saveItem.json")
	public String saveItem(HttpServletRequest request, Model model) {
		
		//return super.save(request, model);
		
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.saveItem(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/accountmanagement/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/accountmanagement/getCustCode.json")
	public String getNo(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.search("getCustCode", params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
}
