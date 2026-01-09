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
import com.wsc.framework.utils.DateUtils;
import com.wsc.framework.utils.SoapUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/user")
public class UserLogListController extends BaseController {
	
	@Autowired 
	private UserLogListService service;
	
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
	
	@RequestMapping(value = "/userloglist.do")
	public String open(HttpServletRequest request, Model model) {
		//SoapUtils.zWpcRecevOrdinfo();
		ParamsMap params = getParams(request);
		model.addAttribute("accTimeBgn", DateUtils.getToDate(10, 0, 0, 0));
		model.addAttribute("accTimeEnd", DateUtils.getToDate(10, 0, 0, 0));
		model.addAttribute("getUserType1", service.search(params, "getUserType1"));
		return super.open(request, model);
	}

	@RequestMapping(value = "/userloglist/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	
	@RequestMapping(value = "/userloglist/download.do")
	public String download(HttpServletRequest request, Model model) {
		String fileName = "UserLogList";
		ParamsMap params = getParams(request);
		Object result = searchList(params);
		setExcelParams(model, result, fileName);
		return "jxlsView";
	}
	
	@RequestMapping(value = "/userloglist/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/soapCount.json")
	public String soapCount(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		System.out.println(params);
	    // 모델에 객체를 추가한다.
	    addObject(model, SoapUtils.zWpcRecevOrdinfo(params));
	    return "jsonView";
	}

}
