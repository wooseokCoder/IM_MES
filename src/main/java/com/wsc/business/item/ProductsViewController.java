package com.wsc.business.item;

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
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/business/item")
public class ProductsViewController extends BaseController {

	@Autowired
	private ProductsViewService service;

	@Autowired
	private CodeService codeService;

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


	@RequestMapping(value = "/productsview.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"ITEM_TYPE1","ITEM_TYPE2","CUST_TYPE"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
		return super.open(request, model, "productsview");
	}
	@RequestMapping(value = "/productsview/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}
	@RequestMapping(value = "/productsview/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/productsview/searchCount.json")
	public String searchCount(HttpServletRequest request, Model model) {
		return super.search(request, model,"searchCount");
	}

	@RequestMapping(value = "/productsview/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/productsview/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request, true);
		service.deleteInvtMast(params);
		return super.save(request, model);
	}

	@RequestMapping(value = "/productsview/save.json")
	public String save(HttpServletRequest request, Model model) {

		return super.save(request, model);
	}

	@RequestMapping(value = "/productsview/getitemname.json")
	public String getItemName(HttpServletRequest request, Model model){

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request);

		Object result = service.search("getProductsItemName", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/productsview/searchitem.json")
	public String searchitem(HttpServletRequest request, Model model) {
		return super.search(request, model,"item");
	}

	@RequestMapping(value = "/productsview/selectItemTypeCode.json")
	public String selectItemTypeCode(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getSelecItemType",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	@RequestMapping(value = "/productsview/selectItemTypeCode2.json")
	public String selectItemTypeCode2(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getSelecItemType2",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

	@RequestMapping(value = "/productsview/saveItem.json")
	public String saveItem(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.saveItem(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

}
