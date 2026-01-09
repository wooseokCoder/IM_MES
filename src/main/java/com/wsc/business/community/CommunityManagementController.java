package com.wsc.business.community;

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
@RequestMapping("/business/community")
public class CommunityManagementController extends BaseController {

	@Autowired
	private CommunityManagementService service;
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

	@RequestMapping(value = "/communitymanagement.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"CUST_TYPE","COMP_GRADE","SITE_DEPT","COMU_GB"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
		return super.open(request, model, "communityManagement");
	}

	@RequestMapping(value = "/communitymanagement/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/communitymanagement/searchCount.json")
	public String searchCount(HttpServletRequest request, Model model) {
		return super.search(request, model,"searchCount");
	}
	@RequestMapping(value = "/communitymanagement/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/communitymanagement/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/communitymanagement/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	
	@RequestMapping(value = "/communitymanagement/saveComu.json")
	public String saveComu(HttpServletRequest request, Model model) {
		
		//return super.save(request, model);
		
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.saveComu(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/communitymanagement/deleteComu.json")
	public String deleteComu(HttpServletRequest request, Model model) {
		
		//return super.save(request, model);
		
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.deleteComu(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/communitymanagement/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/communitymanagement/getComuMenu.json")
	public String getComuMenu(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getComuMenu",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
}
