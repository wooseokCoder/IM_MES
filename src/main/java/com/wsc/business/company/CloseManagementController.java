package com.wsc.business.company;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.code.CacheComponent;
import com.wsc.common.code.CodeService;
import com.wsc.common.file.FileService;
import com.wsc.common.loader.LoaderComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

@Controller
@RequestMapping("/business/company")
public class CloseManagementController extends BaseController {
	@Autowired 
	private CloseManagementService Service;
	@Autowired 
	private FileService fileService;
	
	@Autowired 
	private CodeService codeService;
	
	@Autowired 
	private CacheComponent cache;
	
	@Autowired 
	private LoaderComponent loader;
	@Autowired 
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseService getService() {
		return this.Service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	@RequestMapping(value = "/closemanagement.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"CLOSE_YEAR","CLOSE_MONTH","CLOSE_YN","CUST_TYPE"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		return super.open(request, model);
	}
	

	@RequestMapping(value = "/closemanagement/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/closemanagement/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/closemanagement/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/closemanagement/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/closemanagement/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	//코드 검색
	@RequestMapping(value = "/closemanagement/code.json")
	public String code(HttpServletRequest request, Model model) {    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        System.out.println("★"+params);
        model.addAttribute("rows", cache.getCodeList(params));        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	/*@RequestMapping(value = "/closemanagement/getSelectdatas.json")
	public String selectGroupList(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = Service.search("getSelectdatas",params);	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}	*/
	
	@RequestMapping(value = "/closemanagement/getIdxdatas.json")
	public String getIdxdata(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = Service.search("getIdxdatas2",params);	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}	
	
	
}
