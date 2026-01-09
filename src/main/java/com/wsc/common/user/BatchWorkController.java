package com.wsc.common.user;

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
import com.wsc.framework.utils.DateUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/user")
public class BatchWorkController extends BaseController {
	
	@Autowired 
	private BatchWorkService service;
	
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
	
	@RequestMapping(value = "/batchwork.do")
	public String open(HttpServletRequest request, Model model) {
		model.addAttribute("accTimeBgn", DateUtils.getToDate(10, 0, 0, -1));
		model.addAttribute("accTimeEnd", DateUtils.getToDate(10, 0, 0, 0));
		
		String[] codeGrupList =  {"JOB_GRUP","JOB_CYCLE"};
		ParamsMap params = getParams(request);
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
		return super.open(request, model);
		
		
	}

	@RequestMapping(value = "/batchwork/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	
	@RequestMapping(value = "/batchwork/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/batchwork/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

}
