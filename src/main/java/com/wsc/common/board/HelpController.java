package com.wsc.common.board;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.code.CacheComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.DateUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/board/help")
public class HelpController extends BaseController {
	
	@Autowired 
	private HelpService service;
	
	@Autowired 
	private CacheComponent cache;
	
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

	//게시판그룹
	private BoardGroup group = BoardGroup.HELP;
	
	private String openBoard(HttpServletRequest request, Model model, String name) {
		
		//[WSC2.0] [2015.04 LSH] 상단정보 설정
		ParamsMap params = super.initParams(request, model);
		
		//게시판 기본셋팅
		group.bindParams(params, cache);
		
		Object result = service.search("getMenuList", params);
		
		
		model.addAttribute("model", params);
		model.addAttribute("getMenuList", result);
		
		return super.getView(name);
	}
	
	//관리화면 오픈
	@RequestMapping(value = "/help.do")
	public String open(HttpServletRequest request, Model model) {
		return openBoard(request, model, null);
	}
	
	//등록,수정화면 오픈
	@RequestMapping(value = "/form.do")
	public String openForm(HttpServletRequest request, Model model) {
		model.addAttribute("bordBgn", DateUtils.getToDate(10, 0, -1, 0));
		model.addAttribute("bordEnd","9999-12-31");
		return openBoard(request, model, "helpForm");
	}
	
	//상세조회화면 오픈
	@RequestMapping(value = "/view.do")
	public String openView(HttpServletRequest request, Model model) {
		return openBoard(request, model, "helpView");
	}

	//등록,수정화면 오픈
	@RequestMapping(value = "/form2.do")
	public String openCForm(HttpServletRequest request, Model model) {
		return openBoard(request, model, "helpCForm");
	}
	
	//상세조회화면 오픈
	@RequestMapping(value = "/view2.do")
	public String openCView(HttpServletRequest request, Model model) {
		return openBoard(request, model, "helpCView");
	}
	
	@RequestMapping(value = "/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/select.json")
	public String select(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request);
		
		// 상세조회
    	Object result = service.selectView(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/insertchk.json")
	public String insertchk(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.search("getInsertChk", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/getHelpList.json")
	public String getHelpList(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.search("getHelpList", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
}
