package com.wsc.common.file;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.model.FileInfo;
import com.wsc.framework.exception.SystemException;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.utils.FileUtils;

@Component 
public class FileManager {

	protected static final Log log = LogFactory.getLog(FileManager.class);
	
	//다중파일 임시경로에 업로드 처리
	public static List<FileInfo> uploadFiles(MultipartHttpServletRequest request, FileDirectory fd) {
		
		List<FileInfo> files = new LinkedList<FileInfo>();
		
		//1. build an iterator
		Iterator<String> itr =  request.getFileNames();
		MultipartFile mpf = null;
		String name = null;
		String path = null;
		
		//2. get each file
		while(itr.hasNext()){
			//2.1 get next MultipartFile
			mpf = request.getFile(itr.next()); 

			//2.3 create new fileMeta
			FileInfo f = new FileInfo();
			
			f.setDirectory (fd);
			f.setUpload    (true);
			//f.setRandomName();
			
			f.setFileName  (mpf.getOriginalFilename());
			f.setSaveName  (mpf.getOriginalFilename());
			f.setFileSize  (mpf.getSize());
			f.setFileType  (mpf.getContentType());
    		f.setFilePath  (fd.getPath());
    		
    		name = f.getPhysicalRealName();
    		path = fd.getRealPath();

			try {
				f.setBytes(mpf.getBytes());
				
				//경로가 없을 경우 경로생성
				FileUtils.mkdirs(path);

				// copy file to local disk
				mpf.transferTo(new File(name));
			} 
			catch (IOException e) {
				e.printStackTrace();
			}
			System.out.println(mpf.getOriginalFilename() +" uploaded! "+files.size());
			//2.4 add to files
			files.add(f);
		}
		// result will be like this
		// [{"fileName":"app_engine-85x77.png","fileSize":"8 Kb","fileType":"image/png"},...]
		return files.size() == 0 ? null : files;
	}
	
	//이미지경로에 업로드 처리
	public static List<FileInfo> uploadFilesImg(MultipartHttpServletRequest request, FileDirectory fd) {
		
		List<FileInfo> files = new LinkedList<FileInfo>();
		
		//1. build an iterator
		Iterator<String> itr =  request.getFileNames();
		MultipartFile mpf = null;
		String name = null;
		String path = null;
		
		//2. get each file
		while(itr.hasNext()){
			//2.1 get next MultipartFile
			mpf = request.getFile(itr.next()); 

			//2.3 create new fileMeta
			FileInfo f = new FileInfo();
			
			f.setDirectory (fd);
			f.setUpload    (true);
			//f.setRandomName();
			
			f.setFileName  (mpf.getOriginalFilename());
			f.setSaveName  (mpf.getOriginalFilename());
			f.setFileSize  (mpf.getSize());
			f.setFileType  (mpf.getContentType());
    		f.setFilePath  (fd.getPath());
    		
    		name = f.getPhysicalImageName();
    		path = fd.getImagePath();

			try {
				f.setBytes(mpf.getBytes());
				
				//경로가 없을 경우 경로생성
				FileUtils.mkdirs(path);

				// copy file to local disk
				mpf.transferTo(new File(name));
			} 
			catch (IOException e) {
				e.printStackTrace();
			}
			System.out.println(mpf.getOriginalFilename() +" uploaded! "+files.size());
			//2.4 add to files
			files.add(f);
		}
		// result will be like this
		// [{"fileName":"app_engine-85x77.png","fileSize":"8 Kb","fileType":"image/png"},...]
		return files.size() == 0 ? null : files;
	}
	
	//업로드된 첨부파일 다운로드
	public static void download(
			HttpServletRequest request, 
			HttpServletResponse response,
			FileDirectory fd) throws IOException {
		
		String name = request.getParameter("name");
		
		if (BaseUtils.empty(name))
			throw new SystemException("다운로드할 파일명이 입력되지 않았습니다.");
		
		FileInfo fobj = new FileInfo();
		fobj.setDirectory(fd);
		fobj.setFilePath(fd.getPath());
		fobj.setFileName(name);
		fobj.setSaveName(name);
		
		String fileName = fobj.getPhysicalFileName();
		
		log.info("download file name : " + fileName);
		
		
		File f = new File(fileName);

		if (f.exists()) {
			log.info("response charset : " + response.getCharacterEncoding());
		}
		else {
			log.error("FILE DOWNLOAD ERROR : file("+fileName+") not found!");
			log.error("===============================================================================");
			throw new SystemException("다운로드할 파일을 찾을 수 없습니다.");
		}
		
		//encoding file name
		
		String downName = (request.getHeader("User-Agent").indexOf("MSIE") == -1) ?
				new String(name.getBytes(), "8859_1") : // FF KSC5601
                URLEncoder.encode(name,     "UTF-8");       // IE
		
		log.info("disposition file name : " + downName);
		
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + downName + "\"");
		response.setHeader("Content-Transfer-Encoding", "binary;");

		byte[] buffer = new byte[1024];
		BufferedInputStream  in  = new BufferedInputStream(new FileInputStream(f));
		BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());

		try {
			int read = 0;
			while ((read = in.read(buffer)) != -1) {
				out.write(buffer, 0, read);
			}
			out.close();
			in.close();
		} 
		catch (IOException e) {
			log.error("FILE DOWNLOAD ERROR : ", e);
			log.error("===============================================================================");
			throw new SystemException("다운로드 중 오류가 발생하였습니다.");
		} 
		finally {
			if (out != null) 
				out.close();
			if (in  != null) 
				in.close();
		}
	}
	
}
