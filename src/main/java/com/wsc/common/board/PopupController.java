 package com.wsc.common.board;

import java.util.Calendar;
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
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.utils.DateUtils;

@Controller
@RequestMapping("/common/board/popup/")
public class PopupController extends BaseController {
	
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
	private BoardGroup group = BoardGroup.POPUP;
	
	private String openPopup(HttpServletRequest request, Model model, String name) {
		
		//[WSC2.0] [2015.04 LSH] 상단정보 설정
		ParamsMap params = super.initParams(request, model);
		
		//게시판 기본셋팅
		group.bindParams(params, cache);
		
		//게시기간 기본설정 (현재부터 한달간)
		String bgn = BaseUtils.formatDate();
		String end = BaseUtils.formatDate(BaseUtils.addMonths(bgn, 1));
		params.put("bordBgn", bgn);
		params.put("bordEnd", end);
		
		//검색타입 기본설정
		if (params.containsKey("searchKey") == false) {
			params.put("searchKey", "S01"); //제목
		}
		
		//출력수 기본설정
		if (params.containsKey("rows") == false) {
			params.put("rows", request.getAttribute(BaseConstants.PAGE_SIZE));
		}
		//페이지 기본설정
		if (params.containsKey("page") == false) {
			params.put("page", 1);
		}
		
		Calendar c = Calendar.getInstance();
		int dayOfYear = c.get(Calendar.DATE);
		model.addAttribute("date1", DateUtils.getToDate(10, 0, 0, -dayOfYear+1));
		model.addAttribute("date2", DateUtils.getToDate(10, 0, 0, 0));
		
		model.addAttribute("model", params);
		
		return super.getView(name);
	}
	
	//팝업관리 오픈
	@RequestMapping(value = "/popup.do")
	public String open(HttpServletRequest request, Model model) {
		return openPopup(request, model, null);
	}

	//작성화면 오픈
	@RequestMapping(value = "/form.do")
	public String openForm(HttpServletRequest request, Model model) {
		return openPopup(request, model, "popupForm");
	}
	
	//상세조회 오픈
	@RequestMapping(value = "/view.do")
	public String openView(HttpServletRequest request, Model model) {
		return openPopup(request, model, "popupView");
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
    	RecordMap result = (RecordMap)service.selectView(params);

    	// 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/save.json")
	public String save(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
		//게시대상정보가 있을 경우에만 처리한다.
		if ( "USR".equals(params.get("typeKey")) && params.containsKey("targetValue")){
			if (params.get("targetValue").toString().length() != 0){
				
				String targetValue = params.get("targetValue").toString().replaceAll(",", "|");
				params.put("bordType", "USR");
				params.put("targetValue", targetValue);
			}				
		}else{
			params.put("bordType", params.get("typeKey").toString());
			//params.remove("targetValue");
		}
		
		
		Object result = service.save(params);
		
        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	//삭제시엔 해당 글의 게시대상 사용여부만 변경한다.
	@RequestMapping(value = "/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	//메인페이지에서 현재 활성팝업 목록 로딩
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/load.json")
	public String load(HttpServletRequest request, Model model) {

    	ParamsMap params = getParams(request);
    	params.put("useFlag", "Y"); //활성기준
    	params.put("todayYn", "Y"); //현재기준
		
		//게시판 기본셋팅
		group.bindParams(params, cache);
        
        List<RecordMap> result = (List<RecordMap>)service.search(params);
        
        if (result != null) {
        	
        	int index = 0;
        	
        	for (RecordMap record : result) {
        		//상세조회
        		record = (RecordMap)service.select(record);
        		
        		//팝업의 오픈타입이 있을 경우 해당 값 조회
        		service.setOpenTypeCode(record);
        		
        		result.set(index++, record);
        	}
        }

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/insertTarget.json")
	public String insertTarget(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		service.popupTarget(params);
		return "jsonView";
	}
	
	@RequestMapping(value = "/dealerCheck.json")
	public String dealerCheck(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
		
		String[] dealerList = params.get("dealerList").toString().split(",");
		params.put("dealerList", dealerList);
        int resultCnt = service.searchCount("dealerCheck", params);
        
        // 모델에 객체를 추가한다.
        addObject(model, resultCnt);
        
        return "jsonView";
	}
	
}
