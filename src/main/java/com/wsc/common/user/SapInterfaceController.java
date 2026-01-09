package com.wsc.common.user;

import java.io.IOException;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.mail.MailService;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.SoapUtils;

import kr.co.lscns.SD.WGBC.DT_SD1890_WGBC_response;

@Controller
@RequestMapping("/common/user/sapinterface")
public class SapInterfaceController extends BaseController {
	@Autowired 
	private SapInterfaceService Service;
	
	@Autowired 
	private MailService mailService;
	
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
	
	@RequestMapping(value = "/sapinterface.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model);
	}
	
	@RequestMapping(value = "/userpassword.do")
	public String userOpen(HttpServletRequest request, Model model) {
		return super.open(request, model, "userPassword");
	}
	
	@RequestMapping(value = "/outbSand.json")
	public String outbSand(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
		ParamsMap params = getParams(request);

        DT_SD1890_WGBC_response outSap = null;
		outSap = SoapUtils.zMmRfcLstaWgbcShipconf(params);
		params.add("deliNoSap", outSap.getDELI_NO_SAP());
		params.add("grReltSap", outSap.getO_RESULT());
		params.add("grMeseSap", outSap.getO_MESSAGE());
		
	    // 모델에 객체를 추가한다.
	    addObject(model, params);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/save.json")
	public String save(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	
    	Object result = Service.update("updateUserPw", params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
}
