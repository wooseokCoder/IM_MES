package com.wsc.common.code;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.code.CodeService;
import com.wsc.common.security.SessionComponent;
import com.wsc.common.user.GroupService;
import com.wsc.common.user.ProgramService;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

@Controller
@RequestMapping("/common/code")
public class ScreentermController extends BaseController {
	@Autowired 
	private ScreentermService Service;
	@Autowired 
	private ProgramService programService;
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	@Autowired 	
	private CodeService codeService;
	@Override
	protected BaseService getService() {
		return this.Service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	@RequestMapping(value = "/screenterm.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = Service.search("selectProgKeyList",params);
		model.addAttribute("itemGrpList", result);
		
		
		String[] codeGrupList =  {"USE_FLAG"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result2 = codeService.search("searchCode", params);
		model.addAttribute("result",result2);
		return super.open(request, model);
	}
	
	@RequestMapping(value = "/screenterm/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	
	@RequestMapping(value = "/screenterm/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/screenterm/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/screenterm/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/screenterm/selectProgKeyList.json")
	public String selectGroupList(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = Service.search("selectProgKeyList",params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/screenterm/screenInsert.json")
	public String screenInsert(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	    String result = Service.saveTerm(params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}	
	
	@RequestMapping(value = "/screenterm/selectLangNm.json")
	public String selectLangNm(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	    Object result = Service.search("selectLangNm",params);
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}	
}
