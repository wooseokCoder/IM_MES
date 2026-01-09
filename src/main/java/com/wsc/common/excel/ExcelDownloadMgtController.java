package com.wsc.common.excel;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.file.FileDirectory;
import com.wsc.common.file.FileManager;
import com.wsc.common.file.FileService;
import com.wsc.common.model.FileInfo;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.utils.FileUtils;

@Controller
@RequestMapping("/common/excel/")
public class ExcelDownloadMgtController extends BaseController {
	@Autowired 
	private ExcelDownloadMgtService Service;
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	
	@Autowired 
	private FileService fileService;
	
	@Override
	protected BaseService getService() {
		return this.Service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	@RequestMapping(value = "/exceldownloadmgt.do")
	public String open(HttpServletRequest request, Model model) {

		ParamsMap params = getParams(request);
		params.put("codeGrup", "'ORDR_STAT'");
		
		model.addAttribute("gsUserId", params.get("gsUserId"));
		return super.open(request, model);
	}
	
	@RequestMapping(value = "/exceldownloadmgt/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/exceldownloadmgt/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}
	
	@RequestMapping(value = "/exceldownloadmgt/save.json")
	public String save(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    Object result =  Service.save(params);
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/exceldownloadmgt/formfile.json")
	public String formfile(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    System.out.println("params"+params);
	    Object result = Service.search("formfile",params);
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/exceldownloadmgt/getNdaAtchNo3.json")
	public String getNdaAtchNo(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

        Object result = Service.select("getNdaAtchNo3", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	  //업로드
		@RequestMapping(method = RequestMethod.POST, value="/exceldownloadmgt/upload.do")
		@ResponseBody
		public String upload(MultipartHttpServletRequest request) throws IOException {
			//List<FileInfo> result = fileService.upload(request, 0);
			// 파라메터를 가져온다.
	    	ParamsMap params = getParams(request, true);
	    	
			//System.out.println(result.get);
			int index = 0;
			String atchGrup = request.getParameter("atchGrup");
			
			//1. build an iterator
			Iterator<String> itr =  request.getFileNames();
			MultipartFile mpf = null;
			//2. get each file
			while(itr.hasNext()){
				
				//2.1 get next MultipartFile
				mpf = request.getFile(itr.next()); 
				System.out.println(mpf.getOriginalFilename() +" uploaded! "+ 0);			
				//2.3 create new fileMeta
				FileInfo f = new FileInfo();
				f.setIndex(index++);
				f.setSysId   ("IMMES");
				f.setAtchNo  (params.getString("atchNo"));
				f.setGsUserId(params.getString("gsUserId"));
				f.setFileName(mpf.getOriginalFilename());
				f.setFileSize(mpf.getSize());
				f.setFileType(mpf.getContentType());
				f.setAtchGrup(atchGrup);
				f.setAtchDirectory();			
				f.setRandomName(FileUtils.getFileExtension(mpf.getOriginalFilename()).toLowerCase());
				/*f.setRandomName();*/
				System.out.println("**********************************");
				System.out.println(f.getDirectory().getPath());
	    		f.setFilePath(f.getDirectory().getPath());
	    		System.out.println(f.getFilePath());
				f.setUpload(false);

				try {
					f.setBytes(mpf.getBytes());
					//임시경로 생성
					//new File(f.getTempPath()).mkdir();

					// copy file to local disk (make sure the path "e.g. D:/temp/files" exists)
					//FileCopyUtils.copy(mpf.getBytes(), new FileOutputStream(f.getSaveName()));
					mpf.transferTo(new File(f.getPhysicalTempName()));
					
					//파일정보 삭제
					Service.delete(f);
					//물리적파일 삭제
					FileUtils.deleteFile(f.getPhysicalRealName());
					
					Service.insert(f);
					
					//경로가 없을 경우 경로생성
					FileUtils.mkdirs(f.getDirectory().getRealPath());
					
					//파일이동 처리
					FileUtils.moveFile(
						f.getPhysicalTempName(), 
						f.getPhysicalRealName()
					);
				} 
				catch (IOException e) {
					e.printStackTrace();
				}
				//2.4 add to files
				//files.add(f);
			}
			
			/*// 파라메터를 가져온다.
	    	ParamsMap params = getParams(request, true);
			
			params.put("fileList", result);

			fileService.saveFile(params);*/

			//if (result != null)
				//files.addAll(result);

			//[WSC2.0] [2015.04.19 LSH] IE9에서 첨부파일 업로드버그 해결
			//return getResponseEntiry(result);
			// 뷰이름을 반환한다.
	        return "jsonView";
		}
}
