package com.wsc.common.report;

import java.util.List;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.code.CodeService;
import com.wsc.common.code3.Code3Service;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * Handles requests for the application home page.
 */
@Controller
@SuppressWarnings("rawtypes")
@RequestMapping("/common/report")
public class ReportController extends BaseController {
	@Value("#{app['report.addr']}")
    public String reportUrl;
	
	@Autowired 
	private CodeService service;
	
	@Autowired
	private Code3Service service3;
	
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
	
	@RequestMapping("/code.{format}")
	public String reportCode(HttpServletRequest request, Model model, @PathVariable("format") String format) throws Exception {
		
        ParamsMap params = getParams(request);

        Object data = service.search(params);

        JRDataSource JRdataSource = new JRBeanCollectionDataSource((List) data);
        
        model.addAttribute("datasource", JRdataSource);
        model.addAttribute("format",     format);
		//TODO HTML, CSV 출력시 한글문제 해결해야함.
		return "codeReport";
	}
	
	@RequestMapping("/code3.{format}")
	public String reportCode3(HttpServletRequest request, Model model, @PathVariable("format") String format) throws Exception {
		
        ParamsMap params = getParams(request);

        Object data = service3.search(params);

        JRDataSource JRdataSource = new JRBeanCollectionDataSource((List) data);
        
        model.addAttribute("datasource", JRdataSource);
        model.addAttribute("format",     format);
		//TODO HTML, CSV 출력시 한글문제 해결해야함.
		return "codeReport";
	}
	

	//2016/11/23 김영진 iReport 추가
	@RequestMapping(value = "/reportchart.do")
	public String chartOpen(HttpServletRequest request, Model model) {
		return super.open(request, model, "reportChart");
	}
	@RequestMapping(value = "/reportview.do")
	public String viewOpen(HttpServletRequest request, Model model) {
		return super.open(request, model, "reportView");
	}
	
	@RequestMapping(value = "/reportUrl.json")
	public String getNo(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
		//System.out.println("on:://///" + reportUrl);
		
		model.addAttribute("reportUrl", reportUrl);
		model.addAttribute("sysId", params.getString("gsSysId"));
		return "jsonView";
	}
}
