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
@RequestMapping("/common/jobhist")
public class JobHistController extends BaseController {
	
	@Autowired 
	private JobHistService service;
	
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
	
	@RequestMapping(value = "/jobhist.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		//SoapUtils.zWpcRecevOrdinfo();
		model.addAttribute("accTimeBgn", DateUtils.getToDate(10, 0, 0, 0));
		model.addAttribute("accTimeEnd", DateUtils.getToDate(10, 0, 0, 0));
		Object result = service.search("selectJobRsltList", params);
		Object result2 = service.search("selectJobIdList", params);
		model.addAttribute("selectJobRsltList",result);
		model.addAttribute("selectJobIdList",result2);
		
		return super.open(request, model);
	}

	@RequestMapping(value = "/jobhist/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	
	@RequestMapping(value = "/jobhist/save.json")
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
	
	@RequestMapping(value = "/jobhist/selectJobIdList.json")
	public String selectJobIdList(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("selectJobIdList",params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}	
	@RequestMapping(value = "/jobhist/download.do")
	public String downloadJobHistGroup(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchAllJobHistGroup(params);
        
        //엑셀정보 정의
        setExcelParams(model, result, "JobHist");
        
        // 뷰이름을 반환한다.
        return "jxlsView";
	}

}
