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
public class PhoneBookController extends BaseController {
	@Autowired 
	private PhoneBookService Service;
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
	
	@RequestMapping(value = "/phonebook.do")
	public String open(HttpServletRequest request, Model model) {

		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"DEPT_CODE","CUST_TYPE"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);	

			
		ParamsMap params2 = getParams(request);
		Object result2 = Service.search("getSelectdata", params2);
		model.addAttribute("getSelectdata",result2);
		return super.open(request, model);
	}
	

	@RequestMapping(value = "/phonebook/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/phonebook/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/phonebook/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/phonebook/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/phonebook/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	//코드 검색
	@RequestMapping(value = "/phonebook/code.json")
	public String code(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        System.out.println("★"+params);
        model.addAttribute("rows", cache.getCodeList(params));
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/phonebook/getSelectdata.json")
	public String selectGroupList(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = Service.search("getSelectdata",params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}	
}
