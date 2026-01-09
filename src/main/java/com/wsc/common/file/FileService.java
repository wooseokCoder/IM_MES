/*
 * @(#)FileService.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.common.file;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.model.FileInfo;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.utils.FileUtils;

/**
 * 파일 서비스 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
@Service
public class FileService extends BaseService {
	
	@Autowired
	private CommonDao dao;
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseDao getDao() {
		return this.dao;
	}

	@Override
	protected MessageSource getMessageSource() {
		return this.messageSource;
	}

	@Override
	protected SessionComponent getSessionComponent() {
		return sessionProvider.get();
	}
	
    @SuppressWarnings("unchecked")
	public List<FileInfo> search(Object params) {
    	
    	List<FileInfo> result = (List<FileInfo>)super.search(params);
        
        if (result == null)
        	return null;
        
        int index = 0;
        
    	for (FileInfo f : result) {
    		
    		f.setIndex(index++);
    		f.setUpload(true);
    		f.setOper(STATUS_READ);
    		f.setAtchDirectory();
			
    		try {
    			File fo = new File(f.getPhysicalRealName());
    			
    			if (fo.exists()) {
    				//f.setBytes (FileCopyUtils.copyToByteArray(fo));
    				f.setExist(true);
    			}
    			else {
    				error("File Not found error : ["+f.getPhysicalRealName()+"]");
    			}
			} catch (Exception e) {
				e.printStackTrace();
			}
    	}
    	return result;
	}
    
    @SuppressWarnings("unchecked")
	public List<FileInfo> search2(Object params) {
    	
    	List<FileInfo> result = (List<FileInfo>)search(params, "getNdaFileInfo");
        
        if (result == null)
        	return null;
        
        int index = 0;
        
    	for (FileInfo f : result) {
    		
    		f.setIndex(index++);
    		f.setUpload(true);
    		f.setOper(STATUS_READ);
    		f.setAtchDirectory();
			
    		try {
    			File fo = new File(f.getPhysicalRealName());
    			
    			if (fo.exists()) {
    				f.setBytes (FileCopyUtils.copyToByteArray(fo));
    				f.setExist(true);
    			}
    			else {
    				error("File Not found error : ["+f.getPhysicalRealName()+"]");
    			}
			} catch (IOException e) {
				e.printStackTrace();
			}
    	}
    	return result;
	}

	//단일파일 임시경로에 업로드 처리
	public FileInfo uploadFile(MultipartHttpServletRequest request) {
		
		List<FileInfo> files = upload(request, 0);
		
		if (files == null)
			return null;
		
		return files.get(0);
	}
	
	//다중파일 임시경로에 업로드 처리
	public List<FileInfo> upload(MultipartHttpServletRequest request, int index) {
		
		List<FileInfo> files = new LinkedList<FileInfo>();
		
		String atchGrup = request.getParameter("atchGrup");
		
		//1. build an iterator
		Iterator<String> itr =  request.getFileNames();
		MultipartFile mpf = null;
		//2. get each file
		while(itr.hasNext()){
			//2.1 get next MultipartFile
			mpf = request.getFile(itr.next()); 
			System.out.println(mpf.getOriginalFilename() +" uploaded! "+files.size());			
			//2.3 create new fileMeta
			FileInfo f = new FileInfo();
			f.setIndex(index++);
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
			f.setUpload(false);

			try {
				f.setBytes(mpf.getBytes());
				//임시경로 생성
				//new File(f.getTempPath()).mkdir();

				// copy file to local disk (make sure the path "e.g. D:/temp/files" exists)
				//FileCopyUtils.copy(mpf.getBytes(), new FileOutputStream(f.getSaveName()));
				mpf.transferTo(new File(f.getPhysicalTempName()));
			} 
			catch (IOException e) {
				e.printStackTrace();
			}
			//2.4 add to files
			files.add(f);
		}
		// result will be like this
		// [{"fileName":"app_engine-85x77.png","fileSize":"8 Kb","fileType":"image/png"},...]
		return files.size() == 0 ? null : files;
	}

	@Transactional
	public int deleteAll(Object params) {
		return delete(getNameSpace() + ".delete", params);
	}
	
	@Transactional
	private void deleteFiles(ParamsMap map) {
		
		List<FileInfo> files = (List<FileInfo>)search(map);
		
		if (files == null)
			return;
		
		for (FileInfo file : files) {
			//파일정보 삭제
			delete(file);
		}
		for (FileInfo file : files) {
			//물리적파일 삭제
			FileUtils.deleteFile(file.getPhysicalRealName());
		}
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Transactional
	public void saveFile(ParamsMap params) {
		System.out.println("save File!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");		
		String oper = params.getString(STATUS_NAME);
		
		if (STATUS_DELETE.equals(oper)) {
			//파일정보 검색 후 삭제처리
			deleteFiles(params);
			return;
		}
		
		if (!STATUS_INSERT.equals(oper) &&
			!STATUS_UPDATE.equals(oper))
			return;
		
		List<Map> files = (List<Map>)params.getList("fileList");
		if (files == null)
			return;
		if (files.size() == 0)
			return;
		
		List<FileInfo> list = new ArrayList<FileInfo>();
		System.out.println("save File@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");		
		for (Map map : files) {
			
			FileInfo file = new FileInfo();
			
			file.setFileSize(BaseUtils.getLong(map, "fileSize"));
			file.setFileType((String)map.get("fileType"));
			file.setFilePath((String)map.get("filePath"));
			file.setFileName((String)map.get("fileName"));
			file.setSaveName((String)map.get("saveName"));
			file.setOper    ((String)map.get("oper"));
			file.setFileNo  ((String)map.get("fileNo"));
			file.setComment ((String)map.get("comment"));
			file.setSysId   (params.getString("sysId"));
			file.setAtchNo  (params.getString("atchNo"));
			file.setAtchGrup(params.getString("atchGrup"));
			file.setGsUserId(params.getString("gsUserId"));
			file.setAtchDirectory();
			
			if (STATUS_INSERT.equals(file.getOper())) {
				File _file1 = new File(file.getPhysicalTempName());
				File _file2 = new File(file.getPhysicalRealName());
				boolean isExists1 = _file1.exists();
				boolean isExists2 = _file2.exists();
				if(isExists1 || isExists2) {
					//등록 처리
					insert(file);
					
					list.add(file);
					
					//코멘트 처리
					if(params.containsKey("bordGrup") && (params.get("bordGrup").toString().equals("DA"))) {
						System.out.println("comment Update1############");
						System.out.println((String)map.get("comment"));	
						params.put("fileOper", (String)map.get("oper"));
						params.put("comment", (String)map.get("comment"));
						params.put("updateNo", (String)map.get("fileNo"));
						params.put("tempId", params.getString("tempId"));
						params.put("applId", params.getString("applId"));
						params.put("fileName", (String)map.get("fileName"));
						insert("insertFileChngHist", params);
						update("updateFileComment", params);
					}
				} else {
					System.out.println("No, there is not a no file.1");
				}
			}
			else if (STATUS_DELETE.equals(file.getOper())) {
				//삭제 처리
				delete(file);
				
				list.add(file);
				
				//History Check
				if(params.containsKey("bordGrup") && (params.get("bordGrup").toString().equals("DA"))) {
					System.out.println("file Delete############");
					params.put("fileOper", (String)map.get("oper"));
					params.put("updateNo", (String)map.get("fileNo"));
					params.put("tempId", params.getString("tempId"));
					params.put("applId", params.getString("applId"));
					params.put("fileName", (String)map.get("fileName"));
					insert("insertFileChngHist", params);
				}
			}
			else {
				//코멘트 처리
				if(params.containsKey("bordGrup") && (params.get("bordGrup").toString().equals("DA"))) {
					System.out.println("comment Update2############");
					System.out.println((String)map.get("comment"));	
					params.put("fileOper", (String)map.get("oper"));
					params.put("comment", (String)map.get("comment"));
					params.put("updateNo", (String)map.get("fileNo"));
					params.put("fileName", (String)map.get("fileName"));
					insert("insertFileChngHist", params);
					update("updateFileComment", params);
				}
			}
		}

		//썸네일 업데이트
		if(params.containsKey("bordGrup")&& (params.get("bordGrup").toString().equals("B18") 
				|| params.get("bordGrup").toString().equals("B17"))){
			update("updateThumbNailNull", params);
			update("updateThumbNail", params);
		}
		
		for (FileInfo file : list) {
			
			//등록인 경우 해당 파일 이동처리
			if (STATUS_INSERT.equals(file.getOper())) {
				File _file1 = new File(file.getPhysicalTempName());
				File _file2 = new File(file.getPhysicalRealName());
				boolean isExists1 = _file1.exists();
				boolean isExists2 = _file2.exists();
				if(isExists1 || isExists2) {
					//경로가 없을 경우 경로생성
					FileUtils.mkdirs(file.getDirectory().getRealPath());
					
					//파일이동 처리
					FileUtils.moveFile(
						file.getPhysicalTempName(), 
						file.getPhysicalRealName()
					);
					
					//index화면에 썸네일 지정
					if(params.containsKey("bordGrup")&&(params.get("bordGrup").toString().equals("B18")
							|| params.get("bordGrup").toString().equals("B17"))){
						
						//pdf파일이면 이미지 저장
						if(!".pdf".equals(file.getPhysicalRealName().substring(file.getPhysicalRealName().length()-4))){
							continue;
						}
						try {
							String thumbNail = file.getPhysicalRealName().substring(0, file.getPhysicalRealName().length()-4);
							PDDocument document = PDDocument.load(new File(file.getPhysicalRealName()));
							PDFRenderer pdfRenderer = new PDFRenderer(document);
							//int pageCounter = 0;
							BufferedImage bim = pdfRenderer.renderImageWithDPI(0, 300, ImageType.RGB);
							ImageIOUtil.writeImage(bim, thumbNail+"-ThumbNail.png", 300);
							document.close();
							/*
						for (PDPage page : document.getPages()){
							BufferedImage bim = pdfRenderer.renderImageWithDPI(pageCounter, 300, ImageType.RGB);
							ImageIOUtil.writeImage(bim, thumbNail+"-ThumbNail.png", 300);
							break;
						}*/
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				} else {
					System.out.println("No, there is not a no file.2");
				}
			}
			//삭제인 경우 물리 파일 삭제처리
			else if (STATUS_DELETE.equals(file.getOper())) {
				//물리파일 삭제
				FileUtils.deleteFile(
					file.getPhysicalRealName()
				);
			}
			
		}
	}
}