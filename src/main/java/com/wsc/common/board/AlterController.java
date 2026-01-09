package com.wsc.common.board;

import java.util.List;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.code.CacheComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseConstants;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.PagingMap;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.framework.utils.DateUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/board/alter")
public class AlterController extends BaseController {
	
	@Autowired 
	private AlterService service;
	
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
	private BoardGroup group = BoardGroup.ALTER;
	
	private String openBoard(HttpServletRequest request, Model model, String name) {
		
		//[WSC2.0] [2015.04 LSH] 상단정보 설정
		ParamsMap params = super.initParams(request, model);
		
		//[2017.05 SJY]권한체크
    	programAuth(request, model);
		
		//게시판 기본셋팅
		group.bindParams(params, cache);
		
		model.addAttribute("model", params);
		
		return super.getView(name);
	}
	
	//관리화면 오픈
	@RequestMapping(value = "/alter.do")
	public String open(HttpServletRequest request, Model model) {
		//2016/12/13 김영진 -- 유저 타입 모델객체에 추가
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	
    	Object result = service.search("getUserType", params);
    	//System.out.println("result::::::::::" + result.toString());
    	String sobj = result.toString();
    	sobj = sobj.replace("[", "");
    	sobj = sobj.replace("]", "");
    
		model.addAttribute("userType", sobj);
    	
		return openBoard(request, model, null);
	}
	
	//등록,수정화면 오픈
	@RequestMapping(value = "/form.do")
	public String openForm(HttpServletRequest request, Model model) {
		model.addAttribute("bordBgn", DateUtils.getToDate(10, 0, -1, 0));
		model.addAttribute("bordEnd","9999-12-31");
		return openBoard(request, model, "alterForm");
	}
	
	//상세조회화면 오픈
	@RequestMapping(value = "/view.do")
	public String openView(HttpServletRequest request, Model model) {
		return openBoard(request, model, "alterView");
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
	
}
