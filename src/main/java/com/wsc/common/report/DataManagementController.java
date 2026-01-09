package com.wsc.common.report;

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
@RequestMapping("/common/report")
//@SessionAttributes("user")
public class DataManagementController extends BaseController {
	@Autowired
	private DataManagementService service;

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

	@RequestMapping(value = "/datamanagement.do")
	public String open(HttpServletRequest request, Model model) {


		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"EXIT_YN","USER_TYPE","PERMISSION_CONTROL"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
		return super.open(request, model);
	}

	@RequestMapping(value = "/datamanagement/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/datamanagement/searchDetl.json")
	public String searchDetl(HttpServletRequest request, Model model) {
		return super.search(request, model, "searchDetl");
	}

	@RequestMapping(value = "/datamanagement/userType.json")
	public String userType(HttpServletRequest request, Model model) {
		return super.search(request, model, "userType");
	}

	@RequestMapping(value = "/datamanagement/userTypeTarget.json")
	public String userTypeTarget(HttpServletRequest request, Model model) {
		return super.search(request, model, "userTypeTarget");
	}

	@RequestMapping(value = "/datamanagement/group.json")
	public String group(HttpServletRequest request, Model model) {
		return super.search(request, model, "groupList");
	}

	@RequestMapping(value = "/datamanagement/groupTarget.json")
	public String groupTarget(HttpServletRequest request, Model model) {
		return super.search(request, model, "groupTarget");
	}

	@RequestMapping(value = "/datamanagement/userId.json")
	public String userId(HttpServletRequest request, Model model) {
		return super.search(request, model, "userIdList");
	}

	@RequestMapping(value = "/datamanagement/userIdTarget.json")
	public String userIdTarget(HttpServletRequest request, Model model) {
		return super.search(request, model, "userIdTarget");
	}

	@RequestMapping(value = "/datamanagement/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/datamanagement/save.json")
	public String save(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.save(params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

	@RequestMapping(value = "/datamanagement/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/datamanagement/saveDetl.json")
	public String saveDetl(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.saveDetl(params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

	@RequestMapping(value = "/datamanagement/saveSql.json")
	public String saveSql(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.saveSql(params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

	@RequestMapping(value = "/datamanagement/getEmplNo.json")
	public String getNo(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.search("getEmplNo", params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

	@RequestMapping(value = "/datamanagement/getFieldTitle.json")
	public String getFieldTitle(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	ParamsMap result = service.getFieldTitle(params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
}
