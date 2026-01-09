package com.wsc.common.sample;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.code.CodeService;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

/**
 * 위치 관리 화면 컨트롤러
 * 캔버스에 박스를 드래그하여 배치할 수 있는 기능 제공
 */
@Controller
@RequestMapping("/common/sample")
public class LocManagerController extends BaseController {
	
	@Autowired 
	private LocManagerService service;
	
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	
	@Autowired
	private CodeService codeService;

	@Override
	protected BaseService getService() {
		return this.service;
	}
	
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}

	/**
	 * 위치 관리 화면 오픈
	 */
	@RequestMapping(value = "/locmanager.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
		// 창고 코드 리스트 조회
		String[] codeGrupList = {"WARE_HOUS"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("getCodeLists", result);
		
		return super.open(request, model, "locmanager");
	}
	
	/**
	 * 위치 관리 검색
	 */
	@RequestMapping(value = "/locmanager/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	
	/**
	 * 위치 관리 검색 카운트
	 */
	@RequestMapping(value = "/locmanager/searchCount.json")
	public String searchCount(HttpServletRequest request, Model model) {
		return super.search(request, model, "searchCount");
	}
	
	/**
	 * 위치 관리 저장
	 */
	@RequestMapping(value = "/locmanager/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	/**
	 * 저장된 사인 확인
	 */
	@RequestMapping(value = "/locmanager/checkSign.json")
	public String checkSign(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = service.checkSign(params);
		model.addAttribute("result", result);
		return "jsonView";
	}

}

