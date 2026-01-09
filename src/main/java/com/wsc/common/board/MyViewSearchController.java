 package com.wsc.common.board;

import java.util.List;
import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.Consts;
import com.wsc.common.code.CacheComponent;
import com.wsc.common.code.CodeService;
import com.wsc.common.security.SessionComponent;
import com.wsc.common.user2.User2Service;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.PagingMap;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/board/myViewSearch/")
public class MyViewSearchController extends BaseController {
	
	@Autowired 
	private MyViewSearchService service;
	
	@Autowired
	private CodeService codeService;
	
	
	@Autowired 
	private CacheComponent cache;
	
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	
	@Autowired
	private User2Service userService;	
	
	@Override
	protected BaseService getService() {
		return this.service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	@RequestMapping(value = "/myViewSelect.do")
	public String open(HttpServletRequest request, Model model) {
        ParamsMap params = getDefaultParams(request);
        
		//String[] codeGrupList =  {};
		//params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		
		//Object codeList = codeService.search("searchCode", params);
		Object myViewList = service.search("getMyViewList", params);
		//model.addAttribute("getBmList", service.search(params, "getBmList"));
		model.addAttribute("getMyViewList",myViewList);
		//model.addAttribute("getCodeLists",codeList);
        return super.open(request, model,"myViewSelect");
	}
	
	private ParamsMap getDefaultParams(HttpServletRequest request) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        if (params.containsKey("userId") == false)
        	params.put("userId", params.get("gsUserId"));
        
        String addrType = params.getString("addrType");
        
        params.put("isUsers", Consts.isAddressUsersType(addrType));
        params.put("isGroup", Consts.isAddressGroupType(addrType));
        
        return params;
	}
/*
	@RequestMapping(value = "/search.json")
	public String search(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        params.remove(PagingMap.PAGE);
        Object result = searchList(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
      //  return super.search(request, model);
	}*/
	
	//검색
	@RequestMapping(value = "/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	//검색2
	@RequestMapping(value = "/search2.json")
	public String search2(HttpServletRequest request, Model model) {
		return super.search(request, model,"search2");
	}
	//저장
	@RequestMapping(value = "/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/getMyViewList.json")
	public String getMyViewList(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("getMyViewList", params);
		
        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/saveMyViewMast.json")
	public String saveMyViewMast(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("saveMyViewMast", params);
		
        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/saveMyViewColList.json")
	public String saveMyViewColList(HttpServletRequest request, @RequestBody Map<String, Object> map, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        List<Map<String, Object>> rows = (List<Map<String, Object>>) map.get("rows");
        params.put("rows", rows);
        params.put("windId", map.get("windId"));
        params.put("viewId", map.get("viewId"));
        params.put("oper", map.get("oper"));
        
        //System.out.println("##### request : " + request);
        //System.out.println("##### params: " + params);
        Object result = service.saveViewColList(params);
		
        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/getMyViewMastInfo.json")
	public String getMyViewMastInfo(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("getMyViewMastInfo", params);
		
        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/deleteMyView.json")
	public String deleteMyView(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("deleteMyView", params);
		
        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
}
