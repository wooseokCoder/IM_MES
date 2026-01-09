package com.wsc.common.file;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.model.FileInfo;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.utils.FileUtils;


@Controller
@RequestMapping("/common/file")
@SessionAttributes("files")
public class FileController extends BaseController {
	
	@Autowired 
	private FileService service;
	
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
	
	@ModelAttribute("files")
	public List<FileInfo> createFiles() {
		return new LinkedList<FileInfo>();
	}
	
    //검색
	@RequestMapping(value = "/search.json")
	public String search(@ModelAttribute("files") List<FileInfo> files,
			HttpServletRequest request, 
			Model model) {
		
        ParamsMap params = getParams(request);
        
        files.clear();
        
        if (BaseUtils.empty(params.getString("atchGrup")) == false &&
        	BaseUtils.empty(params.getString("atchNo"))   == false ) {

        	List<FileInfo> result = service.search(params);
            
        	if (result != null) {
        		files.addAll(result);
        	}
        }
        addObject(model, files);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	//검색
	@RequestMapping(value = "/search2.json")
	public String search2(@ModelAttribute("files") List<FileInfo> files,
			HttpServletRequest request, 
			Model model) {
		
        ParamsMap params = getParams(request);
        
        files.clear();
        
        if (BaseUtils.empty(params.getString("atchGrup")) == false &&
        	BaseUtils.empty(params.getString("atchNo"))   == false ) {

        	List<FileInfo> result = service.search2(params);
            
        	if (result != null) {
        		files.addAll(result);
        	}
        }
        addObject(model, files);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}

	//업로드
	@RequestMapping(method = RequestMethod.POST, value="/upload.json")
	@ResponseBody
	public ResponseEntity<String> upload(@ModelAttribute("files") List<FileInfo> files,
			MultipartHttpServletRequest request) throws IOException {
		
		List<FileInfo> result = service.upload(request, files.size());

		if (result != null)
			files.addAll(result);

		//[WSC2.0] [2015.04.19 LSH] IE9에서 첨부파일 업로드버그 해결
		return getResponseEntiry(result);
	}

	//다운로드
	@RequestMapping(value = "/download.do")
	public void download(@ModelAttribute("files") List<FileInfo> files,
			@RequestParam("index") int index,
			HttpServletResponse response) {

		if (files == null)
			return;
		
		for (FileInfo file : files) {
			
			if (file.getIndex() == index) {
				FileInfo f = files.get(index);
				
				String type = f.getFileType();
				String name = f.getFileName();

				try {
					response.setContentType(type);
					response.setHeader("Content-disposition", 
							           "attachment; filename=\""+BaseUtils.toAsc(name)+"\"");
					FileCopyUtils.copy(f.getBytes(), response.getOutputStream());
				}
				catch (IOException e) {
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}
				return;
			}
		}
	}
	
	//임시저장 첨부파일 삭제
	@RequestMapping(value = "/remove.json")
	public String remove(@ModelAttribute("files") List<FileInfo> files,
			@RequestParam("index") int index) {
		
		if (files.size() >= index) {
			FileInfo f = files.get(index);
			
			if (f != null) {
				FileUtils.deleteFile(f.getPhysicalTempName());
				
				files.remove(index);
			}
		}
		return "jsonView";
	}

	//처리세션 리셋
	@RequestMapping(value = "/complete.json", method = RequestMethod.GET)
	public String complete(SessionStatus status) {
		status.setComplete();
		
		return "jsonView";
	}
}
