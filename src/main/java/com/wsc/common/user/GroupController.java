package com.wsc.common.user;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/user")
public class GroupController extends BaseController {
	
	@Autowired 
	private GroupService service;
	
	@Autowired
	private ProgramService programService;
	
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

	//=====================================================//
	// 그룹관리
	//=====================================================//
	@RequestMapping(value = "/group.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model);
	}

	@RequestMapping(value = "/group/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/group/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/group/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	//=====================================================//
	// 사용자그룹관리
	//=====================================================//
	@RequestMapping(value = "/usergroup.do")
	public String openUserGroup(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = service.search("selectUserList", params);
		model.addAttribute("selectUserList",result);
		
		Object result2 = programService.search("selectGroupList", params);
		model.addAttribute("selectGroupList",result2);
		
		return super.open(request, model, "usergroup");
	}

	@RequestMapping(value = "/usergroup/search.json")
	public String searchUserGroup(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchUserGroup(params);
        
        HttpSession sessionS = request.getSession();
        
        if(sessionS.getAttribute("rows") != null){
            if(params.getRows() != Integer.parseInt((sessionS.getAttribute("rows")).toString())){
            	sessionS.setAttribute("rows", params.getRows());
            }
        }else{
        	sessionS.setAttribute("rows", params.getRows());
        }
        params.add("rows", sessionS.getAttribute("rows"));
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/usergroup/download.do")
	public String downloadUserGroup(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchAllUserGroup(params);
        
        //엑셀정보 정의
        setExcelParams(model, result, "UserGroup");
        
        // 뷰이름을 반환한다.
        return "jxlsView";
	}

	@RequestMapping(value = "/usergroup/save.json")
	public String saveUserGroup(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
        
        Object result = service.saveUserGroup(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/usergroup/selectGroupList.json")
	public String selectGroupList(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("selectGroupList",params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}	
}
