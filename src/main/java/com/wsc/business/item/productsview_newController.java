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
public class productsview_newController extends BaseController {

	@Autowired
	private productsview_newService service;

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


	@RequestMapping(value = "/productsview_new.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"ITEM_TYPE1","ITEM_TYPE2","CUST_TYPE","STRG_TYPE"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
//		return super.open(request, model, "productsview_new");
		return super.open(request, model); 
	}
	@RequestMapping(value = "/productsview_new/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}
	@RequestMapping(value = "/productsview_new/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/productsview_new/searchCount.json")
	public String searchCount(HttpServletRequest request, Model model) {
		return super.search(request, model,"searchCount");
	}

	@RequestMapping(value = "/productsview_new/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/productsview_new/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request, true);
		service.deleteInvtMast(params);
		return super.save(request, model);
	}

	@RequestMapping(value = "/productsview_new/save.json")
	public String save(HttpServletRequest request, Model model) {
		
		
		return super.save(request, model);
	}

	@RequestMapping(value = "/productsview_new/getitemname.json")
	public String getItemName(HttpServletRequest request, Model model){

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request);

		Object result = service.search("getProductsItemName_new", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/productsview_new/searchitem.json")
	public String searchitem(HttpServletRequest request, Model model) {
		return super.search(request, model,"item");
	}

	@RequestMapping(value = "/productsview_new/selectItemTypeCode.json")
	public String selectItemTypeCode(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getSelecItemType_new",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	@RequestMapping(value = "/productsview_new/selectItemTypeCode2.json")
	public String selectItemTypeCode2(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getSelecItemType2_new",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

	@RequestMapping(value = "/productsview_new/saveItem.json")
	public String saveItem(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.saveItem(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/productsview_new/getModelNo.json")
	public String getModelNo(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getModelNo_new",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

}
