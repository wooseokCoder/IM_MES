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

@Controller
@RequestMapping("/common/board/reply/")
public class ReplyController extends BaseController {
	
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
	private BoardGroup group = BoardGroup.QNA;
	
	private String openReply(HttpServletRequest request, Model model, String name) {
		
		//[WSC2.0] [2015.04 LSH] 상단정보 설정
		ParamsMap params = super.initParams(request, model);
		
		//게시판 기본셋팅
		group.bindParams(params, cache);
		
		model.addAttribute("model", params);
		
		return super.getView(name);
	}
	
	//답변게시판 오픈
	@RequestMapping(value = "/reply.do")
	public String open(HttpServletRequest request, Model model) {
		return openReply(request, model, null);
	}

	//작성화면 오픈
	@RequestMapping(value = "/form.do")
	public String openForm(HttpServletRequest request, Model model) {
		return openReply(request, model, "replyForm");
	}
	
	//상세조회 오픈
	@RequestMapping(value = "/view.do")
	public String openView(HttpServletRequest request, Model model) {
		return openReply(request, model, "replyView");
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

	//삭제시엔 해당 글의 게시대상 사용여부만 변경한다.
	@RequestMapping(value = "/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
}
