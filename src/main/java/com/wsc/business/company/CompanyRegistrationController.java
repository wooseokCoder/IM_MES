package com.wsc.business.company;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.code.CacheComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/business/company")
@SessionAttributes("files")
public class CompanyRegistrationController extends BaseController {  
	
	@Autowired 
	private CompanyRegistrationService service;
	
	@Autowired 
	private CacheComponent cache;
	
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
	
	@RequestMapping(value = "/companyRegistration.do")
	public String addrOpen(HttpServletRequest request, Model model) {
		return super.open(request, model, "companyRegistration");
	}

	@RequestMapping(value = "/registration/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/registration/save.json")
	public String save(MultipartHttpServletRequest request, Model model) throws IOException {
		ParamsMap params = getParams(request);
		
		String uploadPath = "/company";
		
		File dir = new File(uploadPath);
		if(!dir.isDirectory()){
			dir.mkdirs();
		}
		
		Iterator<String> iter = request.getFileNames();
		System.out.println("params ::::::::::");
		System.out.println(params);
		
		while(iter.hasNext()){
			MultipartFile multipartFile = request.getFile(iter.next());
			
			if(multipartFile.isEmpty() == false){
				String originalFileName = multipartFile.getOriginalFilename();
				String originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
				String savedFileName = originalFileName;
				
				File file = new File(uploadPath + savedFileName);
				multipartFile.transferTo(file);
				
				System.out.println("fileName :::::::::::" + originalFileName);
			}
		}
		
		return super.save(request, model);
	}
}
