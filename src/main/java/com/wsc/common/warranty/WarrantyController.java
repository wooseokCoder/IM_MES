package com.wsc.common.warranty;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.code.CacheComponent;
import com.wsc.common.code.CodeService;
import com.wsc.common.file.FileService;
import com.wsc.common.loader.LoaderComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

@Controller
@RequestMapping("/common/warranty")
public class WarrantyController extends BaseController {
	@Autowired 
	private FileService fileService;
	@Autowired 
	private CodeService codeService;
	@Autowired 
	private CacheComponent cache;
	
	@Autowired 
	private LoaderComponent loader;
	@Autowired 
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseService getService() {
		return null;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	@RequestMapping(value = "/warranty.do")
	public String open(HttpServletRequest request, Model model) {

		/*ParamsMap params = getParams(request);
		String[] codeGrupList =  {"DEPT_CODE","CUST_TYPE"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		model.addAttribute("result",result);	

			
		ParamsMap params2 = getParams(request);
		Object result2 = Service.search("getSelectdata", params2);
		model.addAttribute("getSelectdata",result2);*/
		return super.open(request, model);
	}
	
}
