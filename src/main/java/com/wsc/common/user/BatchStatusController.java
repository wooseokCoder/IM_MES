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
public class BatchStatusController extends BaseController {
	
	@Autowired 
	private BatchStatusService service; //
	
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	
	@Autowired 	
	private CodeService codeService; //

	@Override
	protected BaseService getService() {
		return this.service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	@RequestMapping(value = "/batchstatus.do")
	public String open(HttpServletRequest request, Model model) {
		model.addAttribute("accTimeBgn", DateUtils.getToDate(10, 0, 0, -1));
		model.addAttribute("accTimeEnd", DateUtils.getToDate(10, 0, 0, 0));
		
		ParamsMap params = getParams(request); //
		Object result = service.search("getSelectJobId", params); //
		model.addAttribute("selectJobId",result); //
				
		String[] codeGrupList =  {"JOB_RSLT"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result2 = codeService.search("searchCode", params);
		model.addAttribute("result",result2);

		return super.open(request, model);
	}

	@RequestMapping(value = "/batchstatus/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	
	@RequestMapping(value = "/batchstatus/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/batchstatus/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

}
