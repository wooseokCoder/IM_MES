package com.wsc.business.item;

import java.util.Calendar;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.utils.DateUtils;



/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/business/item")
public class ProjectManagementController extends BaseController {

	@Autowired
	private ProjectManagementService service;

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


	@RequestMapping(value = "/projectmanagement.do")
	public String open(HttpServletRequest request, Model model) {
		Calendar c = Calendar.getInstance();
		int dayOfYear = c.get(Calendar.DATE);
		model.addAttribute("date1", DateUtils.getToDate(10, 0, 0, -dayOfYear+1));
		model.addAttribute("date2", DateUtils.getToDate(10, 0, 0, 0));
		return super.open(request, model, "projectmanagement");
	}
	@RequestMapping(value = "/projectmanagement/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}
	@RequestMapping(value = "/projectmanagement/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/projectmanagement/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/projectmanagement/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/projectmanagement/save.json")
	public String save(HttpServletRequest request, Model model) {

		return super.save(request, model);
	}

	@RequestMapping(value = "/projectmanagement/searchmodel.json")
	public String searchitem(HttpServletRequest request, Model model) {
		return super.search(request, model,"model");
	}
}
