package com.wsc.common.loader;

import java.io.IOException;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.Consts;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/loader")
public class LoaderController extends BaseController {
	
	@Autowired 
	private LoaderService service;
	
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
	
	//엑셀양식관리 오픈
	@RequestMapping(value = "/form.do")
	public String openForm(HttpServletRequest request, Model model) {
		return super.open(request, model, "loaderForm");
	}
	
	//양식종류관리 오픈
	@RequestMapping(value = "/code.do")
	public String openCode(HttpServletRequest request, Model model) {
    	
    	//[WSC2.0] [2015.04 LSH] 상단정보 설정
    	ParamsMap params = super.initParams(model);
    	
    	//양식종류 코드그룹 설정
    	params.put("codeGrup", Consts.ROOT_CODE);
    	params.put("extChr01", Consts.LOADER_CODE);

    	model.addAttribute("model", params);
    	
    	return super.getView("loaderCode");
	}

	@RequestMapping(value = "/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	//엑셀양식종류 - 콤보형 검색
	@RequestMapping(value = "/combo.json")
	public String combo(HttpServletRequest request, Model model) {
    	
        ParamsMap params = getParams(request);
        
        model.addAttribute("rows", service.searchCombo(params));
        
        return "jsonView";
	}

	//엑셀양식관리 - 칼럼목록 검색
	@RequestMapping(value = "/searchItem.json")
	public String searchItem(HttpServletRequest request, Model model) {
		
        ParamsMap params = getParams(request);

        addObject(model, service.searchItem(params));
        
        return "jsonView";
	}

	//양식종류관리 - 저장처리
	@RequestMapping(value = "/saveCode.json")
	public String saveCode(HttpServletRequest request, Model model) {
    	
    	ParamsMap params = getParams(request, true);
        
        Object result = service.saveCode(params);
        
        addObject(model, result);
        
        return "jsonView";
	}
	
	//엑셀양식관리 - 칼럼목록 업로드
	@RequestMapping(value = "/upload.json")
	@ResponseBody
	public ResponseEntity<String> uploadItem(MultipartHttpServletRequest request) throws IOException {
		
		ParamsMap params = getParams(request);
		
		MultipartFile file = request.getFile("excelFile");
		
		Object result = service.upload(params, file);
		
		return getResponseEntiry(result);
	}

	//엑셀양식관리 - 칼럼목록 저장처리
	@RequestMapping(value = "/saveItem.json")
	public String saveItem(HttpServletRequest request, Model model) {
    	
    	ParamsMap params = getParams(request, true);
        
        Object result = service.saveItem(params);
        
        addObject(model, result);
        
        return "jsonView";
	}
}
