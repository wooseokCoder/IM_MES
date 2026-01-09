package com.wsc.common.drawing;

import java.util.List;

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

@Controller
@RequestMapping("/common/drawing")
public class DrawingInformationController extends BaseController {
	@Autowired 
	private DrawingInformationService Service;
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	@Override
	protected BaseService getService() {
		return this.Service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	@RequestMapping(value = "/drawinginformation.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model);
	}
	
	@RequestMapping(value = "/drawinginformation/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}
	
	@RequestMapping(value = "/drawinginformation/getDrawListView.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}
	
	@RequestMapping(value = "/drawinginformation/getDrawItemView.json")
	public String getItemList(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request, true);
		List<Object> result = Service.search("getDrawItemList", params);
		addObject(model, result);
		return "jsonView";
	}
	
	@RequestMapping(value = "/drawinginformation/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.delete(request, model);
	}
}
