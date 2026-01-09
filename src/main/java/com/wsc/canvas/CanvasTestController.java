package com.wsc.canvas;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class CanvasTestController {
	
	@Autowired 
	private CanvasService Service;
	
	@RequestMapping(value="/canvasSave.json")
	public ModelAndView canvasSave(HttpServletRequest request) throws IOException {
		ModelAndView mav = new ModelAndView();
		MultipartHttpServletRequest multi = (MultipartHttpServletRequest) request;
		MultipartFile file = multi.getFile("fileNm");
		
		String path = "";
		UUID randomUUID = UUID.randomUUID();
		
		if(file != null) {
			path = "c:/upload/";
			InputStream inputStream = null;
			OutputStream outputStream = null;
			
			String organizedfilePath = "";
			
			try {
				if(file.getSize() > 0){
					inputStream = file.getInputStream();
					File realUploadDir = new File(path);
					
					if(!realUploadDir.exists()){
						realUploadDir.mkdirs();
					}
					
					organizedfilePath = path + randomUUID + "_" + file.getOriginalFilename();
					outputStream = new FileOutputStream(organizedfilePath);
					int readByte = 0;
					byte[] buffer = new byte[8192];
					
					while((readByte = inputStream.read(buffer, 0, 8120)) != -1){
						outputStream.write(buffer, 0, readByte);
					}
				}
			} catch(Exception e){
				e.printStackTrace();
			} finally {
				outputStream.close();
				inputStream.close();
			}
		}
		mav.setViewName("fileUpload");
		return mav;
	}
}
