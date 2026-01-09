package com.wsc.common.invoice;

import java.util.Calendar;
import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.code.CodeService;
import com.wsc.common.loader.LoaderComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.utils.DateUtils;



/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/invoice")
public class InvoiceAdjustmentController extends BaseController {

	@Autowired
	private InvoiceAdjustmentService service;

	@Autowired
	private CodeService codeService;
	
	@Autowired 
	private LoaderComponent loader;

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


	@RequestMapping(value = "/invoiceadjustment.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Calendar c = Calendar.getInstance();
		int dayOfYear = c.get(Calendar.DATE);
		String[] codeGrupList =  {"DISC_TYPE","APPL_ITEM_TYPE","APPL_TYPE","DISC_VALU","SERI_TYPE","DISC_BASE"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
		model.addAttribute("date1", DateUtils.getToDate(10, 0, 0, -dayOfYear+1));
		return super.open(request, model, "invoiceadjustment");
	}
	@RequestMapping(value = "/invoiceadjustment/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}
	@RequestMapping(value = "/invoiceadjustment/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/invoiceadjustment/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/invoiceadjustment/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		/*ParamsMap params = getParams(request, true);
		service.deleteInvtMast(params);*/
		return super.delete(request, model);
	}

	@RequestMapping(value = "/invoiceadjustment/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	@RequestMapping(value = "/invoiceadjustment/selectInfo.json")
	public String selectInfo(HttpServletRequest request, Model model) {
		return super.search(request, model,"selectInfo");
	}
	
	
	//ADD팝업 아이템 저장
	@RequestMapping(value = "/invoiceadjustment/saveItem.json")
	public String saveItem(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.saveItem(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	@RequestMapping(value = "/invoiceadjustment/updateSapStat.json")
	public String updateSapStat(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.update("updateSapStat",params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
		
	}
	
	@RequestMapping(value = "/invoiceadjustment/updateSapInv.json")
	public String updateSapInv(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
		ParamsMap params = getParams(request);
		Object result = service.update("updateSapInv",params);
		
		// 모델에 객체를 추가한다.
		addObject(model, result);
		
		// 뷰이름을 반환한다.
		return "jsonView";
		
	}

}
