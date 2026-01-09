package com.wsc.common.sample;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.loader.LoaderComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/sample")
public class SampleboardController extends BaseController {
	
	@Autowired 
	private SampleboardService service;
	
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	
	@Autowired 
	private LoaderComponent loader;

	@Override
	protected BaseService getService() {
		return this.service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}

	
	//관리화면 오픈
	@RequestMapping(value = "/sampleboard.do")
	public String open(HttpServletRequest request, Model model) {
		// bordGrup 기본값 설정
		model.addAttribute("bordGrup", "B12");
		
		return super.open(request, model);
	}
	
	@RequestMapping(value = "/sampleboard/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/sampleboard/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/sampleboard/download2.do")
	public String download2(HttpServletRequest request, HttpServletResponse response, Model model) {
		try {
			return super.excelDownload(request, response, model);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return "jsonView";
	}

	@RequestMapping(value = "/sampleboard/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/sampleboard/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/sampleboard/listReorder.json")
	public String listReorder(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getListReorder", params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/sampleboard/listReorderDefault.json")
	public String listReorderDefault(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getListReorderDefault", params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/sampleboard/listReorderList.json")
	public String listReorderList(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result = service.search("getListReorderList", params);
	    
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/sampleboard/download3.do")
	public String download3(HttpServletRequest request, Model model) {
		String fileName = "SampleboardUpload";
		ParamsMap params = getParams(request);
		Object result = searchList(params);
		
		setExcelParams(model, result, fileName);
		
		return "jxlsView";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/sampleboard/upload.json")
	public String uploadLoader(MultipartHttpServletRequest request, Model model) {
		MultipartFile file = request.getFile("excelFile");
		if (file != null && file.isEmpty() == false) {
			Map result = loader.load(file, "jxls-sampleboard.xml");
			Map<String, Object> HeadRow= (Map<String, Object>) result.get("header");
			int cnt = 0;
			for(String key:HeadRow.keySet()) {
				String headValue = (String) HeadRow.get(key);
				try {
					if(headValue.isEmpty()) {
						cnt++;
					}
				} catch (Exception e) {
					cnt++;
				}
			}
			if(cnt == 0) {
				addObject(model, result.get("list"));	
			}else {
				result.put("list", "error");
				addObject(model, result.get("list"));
			}
		}
		return "jsonView";
	}
	
	@RequestMapping(value = "/sampleboard/upload2.json")
	public String upload2(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request, true);
		Object result = service.upload(params);
		model.addAttribute("result", result);
		return "jsonView";
	}
	
	@RequestMapping(value = "/sampleboard/excelsave.json")
	public String saveLoader(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request, true);
		Object result = service.saveExcel(params);
		addObject(model, result);
		return "jsonView";
	}
}
