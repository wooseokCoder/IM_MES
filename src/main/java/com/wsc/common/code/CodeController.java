package com.wsc.common.code;

import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.file.FileService;
import com.wsc.common.loader.LoaderComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/code")
public class CodeController extends BaseController {
	
	@Autowired 
	private CodeService service;
	
	@Autowired 	
	private CodeService codeService;
	
	@Autowired 
	private FileService fileService;
	
	@Autowired 
	private CacheComponent cache;
	
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
	
	@RequestMapping(value = "/code.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		Object result = service.search("com.wsc.common.code.Code.getSelectCode", params);
		Object result2 = service.search("com.wsc.common.code.Code.getSelectCodeSort", params);
		model.addAttribute("selectCode",result);
		model.addAttribute("selectCodeSort",result2);
		

		
		String[] codeGrupList =  {"USE_FLAG"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result3 = service.search("com.wsc.common.code.Code.searchCode", params);
		model.addAttribute("result",result3);
		return super.open(request, model);
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

	//코드 검색
	@RequestMapping(value = "/code.json")
	public String code(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        model.addAttribute("rows", cache.getCodeList(params));
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	//코드엑셀 로더화면오픈
	@RequestMapping(value = "/loader/open.do")
	public String openLoader(HttpServletRequest request, Model model) {
		return super.open(request, model, "codeLoader");
	}

	//코드엑셀 업로드
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/loader/upload.json")
	public String uploadLoader(MultipartHttpServletRequest request, Model model) {

    	//엑셀 업로드
		MultipartFile file = request.getFile("excelFile");
		
		if (file != null && 
			file.isEmpty() == false) {
			Map result = loader.load(file, "jxls-code.xml");
			
			addObject(model, result.get("list"));
		}
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	//코드엑셀 저장
	@RequestMapping(value = "/loader/save.json")
	public String saveLoader(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
        
        Object result = service.saveExcel(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/updateExtChr.json")
	public String selectDealerInfo(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	    Object result = service.insert("updateExtChr",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	@RequestMapping(value = "/updateExtNum.json")
	public String selectDealerInfo2(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	    Object result = service.insert("updateExtNum",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
}
