package com.wsc.business.company;

import java.util.Calendar;

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
import com.wsc.framework.utils.DateUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/business/company")
public class SaledailyactivityreportController extends BaseController {

	@Autowired
	private SaledailyactivityreportService service;

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

	//=====================================================//
	// 그룹관리
	//=====================================================//
	@RequestMapping(value = "/saledailyactivityreport.do")
	public String open(HttpServletRequest request, Model model) {
		Calendar c = Calendar.getInstance();
		int dayOfYear = c.get(Calendar.DATE);
		ParamsMap params = getParams(request);
		//String[] codeGrupList =  {"STRG_TYPE","SITE_DEPT","SAL_EPLY_TYPE", "DEPT_CODE","PAY_TYPE","BILL_TYPE","SEND_TYPE","BSNS_PT_TYPE","TAX_TYPE","ITEM_TYPE1","ITEM_TYPE2"};
		String[] codeGrupList =   {"SAL_EPLY_TYPE", "DEPT_CODE"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);
		model.addAttribute("date1", DateUtils.getToDate(10, 0, 0, -dayOfYear+1));
		model.addAttribute("date2", DateUtils.getToDate(10, 0, 0, 0));
		model.addAttribute("datecreate", DateUtils.getToDate(10, 0, 0, 0));
		model.addAttribute("userName", params.get("gsUserName"));
		return super.open(request, model);
	}

	@RequestMapping(value = "/saledailyactivityreport/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	@RequestMapping(value = "/saledailyactivityreport/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request, true);
		service.saveDelete(params);
		return super.save(request, model);
	}
	@RequestMapping(value = "/saledailyactivityreport/searchfoot.json")
	public String searchfoot(HttpServletRequest request, Model model) {
		return super.search(request, model,"foot");
	}

	@RequestMapping(value = "/saledailyactivityreport/searchcust.json")
	public String searchcust(HttpServletRequest request, Model model) {
		return super.search(request, model,"cust");
	}

	@RequestMapping(value = "/saledailyactivityreport/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/saledailyactivityreport/saveShetDetl.json")
	public String saveShetDetl(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.saveShetDetl(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

}
