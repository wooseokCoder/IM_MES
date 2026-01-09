package com.wsc.business.item;

import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.code.CodeService;
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
@RequestMapping("/business/item")
public class ProductsUploadController extends BaseController {
	
	@Autowired 
	private ProductsUploadService service;
	
	@Autowired 
	private CodeService codeService;
	
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
	
	
	@RequestMapping(value = "/productsupload.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model, "productsupload");
	}

	//코드엑셀 업로드
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/productsupload/upload.json")
	public String uploadLoader(MultipartHttpServletRequest request, Model model) {

    	//엑셀 업로드
		MultipartFile file = request.getFile("excelFile");
		
		if (file != null && 
			file.isEmpty() == false) {
			Map result = loader.load(file, "jxls-product.xml");
			
			addObject(model, result.get("list"));
		}
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	//코드엑셀 저장
	@RequestMapping(value = "/productsupload/save.json")
	public String saveLoader(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
        
        Object result = service.saveExcel(params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

}
