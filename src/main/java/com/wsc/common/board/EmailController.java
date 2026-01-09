 package com.wsc.common.board;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.Consts;
import com.wsc.common.code.CacheComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

@Controller
@RequestMapping("/common/board/email/")
public class EmailController extends BaseController {
	
	@Autowired 
	private BoardService service;
	
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
	private BoardGroup group = BoardGroup.EMAIL;
	
	private String openEmail(HttpServletRequest request, Model model, String name) {
		
		//[WSC2.0] [2015.04 LSH] 상단정보 설정
		ParamsMap params = super.initParams(request, model);
		String view = name;
		
		//게시판 기본셋팅
		group.bindParams(params, cache);
		
		
		//검색타입 정의(R:받은메일함,S:보낸메일함)
		if (Consts.EMAIL_RECEIVE_TYPE.equals (name) ||
			Consts.EMAIL_DISPATCH_TYPE.equals(name)) {
			params.put("pageType", name);
			
			view = "email";
		}
		
		model.addAttribute("model", params);
		
		return super.getView(view);
	}
	
	//받은메일함 오픈
	@RequestMapping(value = "/receive.do")
	public String receive(HttpServletRequest request, Model model) {
		return openEmail(request, model, Consts.EMAIL_RECEIVE_TYPE);
	}
	
	//보낸메일함 오픈
	@RequestMapping(value = "/dispatch.do")
	public String dispatch(HttpServletRequest request, Model model) {
		return openEmail(request, model, Consts.EMAIL_DISPATCH_TYPE);
	}

	//작성화면 오픈
	@RequestMapping(value = "/form.do")
	public String openForm(HttpServletRequest request, Model model) {
		return openEmail(request, model, "emailForm");
	}
	
	//상세조회 오픈
	@RequestMapping(value = "/view.do")
	public String openView(HttpServletRequest request, Model model) {
		return openEmail(request, model, "emailView");
	}
	
	//수신자설정화면 오픈
	@RequestMapping(value = "/target.do")
	public String openTarget(HttpServletRequest request, Model model) {
		return openEmail(request, model, "emailTarget");
	}
	
	@RequestMapping(value = "/search.json")
	public String search(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        // 검색결과
        Object result = null;
    	// 화면타입
    	String type = params.getString("pageType");
    	
    	// 받은메일함인 경우
    	if (Consts.EMAIL_RECEIVE_TYPE.equals(type)) {
    		params.put("useFlag", "Y");
    		
    		result = service.searchTarget(params);
    	}
    	// 보낸메일함인 경우
    	else {
    		params.put("useFlag", "Y");
    		params.put("regiId", params.get(ParamsMap.GS_USER_ID));
    		result = service.search(params);
    	}
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/searchItem.json")
	public String searchItem(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        // 검색결과
        Object result = service.searchTarget(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/download.do")
	public String download(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.searchTarget(params);
        
        setExcelParams(model, result);
        
        // 뷰이름을 반환한다.
        return "jxlsView";
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

	//삭제시엔 해당 글의 게시대상 사용여부만 변경한다.
	@RequestMapping(value = "/delete.json")
	public String delete(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	
    	// 게시대상 사용여부만 변경한다.
        Object result = service.deleteEmail(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
}
