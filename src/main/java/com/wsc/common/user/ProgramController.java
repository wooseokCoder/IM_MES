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
public class ProgramController extends BaseController {

	@Autowired
	private ProgramService service;

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
	// 화면관리
	//=====================================================//
	@RequestMapping(value = "/program.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model);
	}

	@RequestMapping(value = "/program/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/program/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/program/save.json")
	public String save(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
        Object result = service.saveLocal(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	//=====================================================//
	// 사용자화면관리
	//=====================================================//
	@RequestMapping(value = "/userprogram.do")
	public String openUserProgram(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = service.search("selectUserList", params);
		model.addAttribute("selectUserList",result);
		return super.open(request, model, "userprogram");
	}

	@RequestMapping(value = "/userprogram/search.json")
	public String searchUserProgram(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchUserProgram(params);

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

	@RequestMapping(value = "/userprogram/download.do")
	public String downloadUserProgram(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchAllUserProgram(params);

        //엑셀정보 정의
        setExcelParams(model, result, "UserProgram");

        // 뷰이름을 반환한다.
        return "jxlsView";
	}
	
	@RequestMapping(value = "/programlistuser/download.do")
	public String downloadProgramListUser(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchAllProgramListUser(params);

        //엑셀정보 정의
        setExcelParams(model, result, "ProgramListUser");

        // 뷰이름을 반환한다.
        return "jxlsView";
	}

	@RequestMapping(value = "/userprogram/save.json")
	public String saveUserProgram(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

        Object result = service.saveUserProgram(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	//=====================================================//
	// 사용자화면현황
	//=====================================================//
	@RequestMapping(value = "/userprogramlist.do")
	public String openUserProgramList(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = service.search("selectUserList", params);
		Object result2 = service.search("selectUserProgList", params);
		model.addAttribute("selectUserList",result);
		model.addAttribute("selectUserProgList",result2);
		return super.open(request, model, "userprogramlist");
	}
	
	@RequestMapping(value = "/programlistuser.do")
	public String openProgramListUser(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = service.search("selectUserProgList", params);
		model.addAttribute("selectUserProgList",result);
		return super.open(request, model, "programlistuser");
	}

	@RequestMapping(value = "/userprogramlist/search.json")
	public String searchUserProgramList(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchUserProgramList(params);

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
	
	@RequestMapping(value = "/programlistuser/search.json")
	public String searchProgramListUser(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchProgramListUser(params);

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

	@RequestMapping(value = "/userprogramlist/download.do")
	public String downloadUserProgramList(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchAllUserProgramList(params);

        //엑셀정보 정의
        setExcelParams(model, result, "UserProgramList");

        // 뷰이름을 반환한다.
        return "jxlsView";
	}

	//=====================================================//
	// 그룹화면관리
	//=====================================================//
	@RequestMapping(value = "/groupprogram.do")
	public String openGroupProgram(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = service.search("selectGroupList", params);
		model.addAttribute("selectGroupList",result);
		return super.open(request, model, "groupprogram");
	}

	@RequestMapping(value = "/groupprogram/search.json")
	public String searchGroupProgram(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchGroupProgram(params);

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

	@RequestMapping(value = "/groupprogram/download.do")
	public String downloadGroupProgram(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchAllGroupProgram(params);

        //엑셀정보 정의
        setExcelParams(model, result, "GroupProgram");

        // 뷰이름을 반환한다.
        return "jxlsView";
	}

	@RequestMapping(value = "/groupprogram/save.json")
	public String saveGroupProgram(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

        Object result = service.saveGroupProgram(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	@RequestMapping(value = "/groupprogram/selectProgList.json")
	public String selectGroupList(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("selectProgList",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/groupprogram/getWindowMsg.json")
	public String getWindowMsg(HttpServletRequest request, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getWindowMsg",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
}
