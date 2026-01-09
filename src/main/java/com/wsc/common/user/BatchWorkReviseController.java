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
public class BatchWorkReviseController extends BaseController {
	
	@Autowired 
	private BatchWorkReviseService service;
	
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
	
	@RequestMapping(value = "/batchworkrevise.do")
	public String open(HttpServletRequest request, Model model) {
		model.addAttribute("accTimeBgn", DateUtils.getToDate(10, 0, 0, -1));
		model.addAttribute("accTimeEnd", DateUtils.getToDate(10, 0, 0, 0));
		
		String[] codeGrupList =  {"JOB_GRUP","JOB_CYCLE","JOB_TYPE","USE_FLAG","ERR_PROC"};
		ParamsMap params = getParams(request);
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
		return super.open(request, model);
		
		
	}
	
	@RequestMapping(value = "/batchworkrevise/saveJob.json")
	public String saveJob(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.saveJob(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/batchworkrevise/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	
	@RequestMapping(value = "/batchworkrevise/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/batchworkrevise/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

}
