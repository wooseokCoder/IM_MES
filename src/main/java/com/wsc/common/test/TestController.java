package com.wsc.common.test;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;

@Controller
@RequestMapping("/common/test")
public class TestController extends BaseController {

	@Autowired
	private TestService service;

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

	@RequestMapping(value = "/test.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model);
	}

	@RequestMapping(value = "/test/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/test/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
}
