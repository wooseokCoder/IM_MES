package com.wsc.common.user;

import java.util.List;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.model.Menu;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/user")
public class MenuController extends BaseController {

	@Autowired
	private MenuService service;

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

	@RequestMapping(value = "/menu.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model);
	}

	@RequestMapping(value = "/menu/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/menu/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/menu/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/menu/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/hotmenu/search.json")
	@SuppressWarnings("unchecked")
	public String searchHot(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        params.put("userId", params.get(ParamsMap.GS_USER_ID));

        Object result = null;

		//세션에 있는 경우 세션의 핫메뉴정보를 가져옴.
		if (getSessionComponent().getHotMenus() != null) {
			result = getSessionComponent().getHotMenus();
		}
		//세션에 없는 경우 메뉴검색 후 세션에 저장
		else {
			result = service.searchHot(params);
	    	getSessionComponent().saveHotMenus((List<Menu>)result);
		}

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/hotmenu/select.json")
	public String selectHot(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request);

		if (params.containsKey("userId") == false)
			params.put("userId", params.get(ParamsMap.GS_USER_ID));

        Object result = service.selectHot(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/hotmenu/save.json")
	public String saveHot(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

		if (params.containsKey("userId") == false)
			params.put("userId", params.get(ParamsMap.GS_USER_ID));

        Object result = service.saveHot(params);

        // 저장후 세션의 핫메뉴를 리셋한다.
        getSessionComponent().removeHotMenus();

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/menu/searchType.json")
	public String searchType(HttpServletRequest request, Model model) {
		return super.search(request, model,"searchType");
	}

}
