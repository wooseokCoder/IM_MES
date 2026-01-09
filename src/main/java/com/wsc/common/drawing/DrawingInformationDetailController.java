package com.wsc.common.drawing;

import java.util.List;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.board.BoardGroup;
import com.wsc.common.code.CacheComponent;
import com.wsc.common.file.FileService;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

@Controller
@RequestMapping("/common/drawing")
public class DrawingInformationDetailController extends BaseController {
	@Autowired 
	private DrawingInformationDetailService Service;
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	@Autowired 
	private FileService fileService;
	@Autowired 
	private CacheComponent cache;
	@Override
	protected BaseService getService() {
		return this.Service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	@RequestMapping(value = "/drawinginformationdetail.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		model.addAttribute("model", params);
		model.addAttribute("gsUserId", params.get("gsUserId"));
		return super.open(request, model);
	}
	
	@RequestMapping(value = "/drawinginformationdetail/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}
	
	@RequestMapping(value = "/drawinginformationdetail/getItemList.json")
	public String getItemList(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request, true);
		List<Object> result = Service.search("getDrawItemList", params);
		addObject(model, result);
		return "jsonView";
	}
	
	@RequestMapping(value = "/drawinginformationdetail/submit.json")
	public String drawListSubmit(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request, true);
		Object result = Service.submit(params);
		addObject(model, result);
		return "jsonView";
	}

}
