package com.wsc.business.item;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

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
@RequestMapping("/business/item")
public class CommodityMaterialCodeController extends BaseController {

	@Autowired
	private CommodityMaterialCodeService service;

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

	@RequestMapping(value = "/commoditymaterialcode.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model, "commoditymaterialcode");
	}

	@RequestMapping(value = "/commoditymaterialcode/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/commoditymaterialcode/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/commoditymaterialcode/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/commoditymaterialcode/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/commoditymaterialcode/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	/*@RequestMapping(value = "/productmanagement/updatePrceAll.json")
	public String updatePrceAll(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.update("updatePrceAll", params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

	@RequestMapping(value = "/productmanagement/copyItemAll.json")
	public String copyItemAll(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.insert("copyItemAll", params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}*/
}

