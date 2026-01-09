/*
 * @(#)JxlsView.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.view;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jxls.exception.ParsePropertyException;
import net.sf.jxls.transformer.XLSTransformer;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.springframework.beans.factory.annotation.Value;

import com.wsc.framework.utils.FileUtils;

/**
 * JXLS 뷰 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class JxlsView extends DownloadView {
	
    /**
     * 템플릿 경로
     */
    @Value("#{app['excel.template.path']}")
    private String TEMPLATE_PATH;
	
    /**
     * 엑셀파일 임시경로
     */
    @Value("#{app['excel.template.temp']}")
    private String DOWNLOAD_TEMP;
        
    /**
     * 템플릿 파일명
     */
    public static final String TEMPLATE_NAME = "templateName";
    
    /**
     * 다운로드 파일명
     */
    public static final String DOWNLOAD_NAME = "downloadName";
    
    /* 
     * (non-Javadoc)
     * @see org.springframework.web.servlet.view.AbstractView#renderMergedOutputModel(java.util.Map, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
    	String templateName = (String)model.get(TEMPLATE_NAME);
    	String downloadName = (String)model.get(DOWNLOAD_NAME);
    	String templateFile = FileUtils.getFileName(TEMPLATE_PATH, templateName);
    	String downloadFile = FileUtils.getFileName(DOWNLOAD_TEMP, downloadName);
    	
    	XLSTransformer transformer = null;
		BufferedInputStream  ins   = null;
		BufferedOutputStream outs  = null;
		File f = null;
    	try {
    		transformer = new XLSTransformer();
    		transformer.transformXLS(templateFile, model, downloadFile);
    		
    		// File Download
    		f = new File(downloadFile);

    		if (f.exists()) {
    			
    			Cookie setCookie = new Cookie("fileDownload", "true");
    			setCookie.setPath("/");
    	        setCookie.setMaxAge(60*60*24); // 기간을 하루로 지정
    	        response.addCookie(setCookie);
    			
                response.setContentType(getContentType());
                response.setHeader("Content-Transfer-Encoding", "binary");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + getEncodedFileName(downloadName, getBrowser(request)) + "\";");

				ins  = new BufferedInputStream(new FileInputStream(f));
				outs = new BufferedOutputStream(response.getOutputStream());
				
				byte[] buffer = new byte[1024];

				int read = 0;
				while ((read = ins.read(buffer)) != -1) {
					outs.write(buffer, 0, read);
				}
    		}
        }
        catch (FileNotFoundException e) {
            error("Detected exception: ", e);
            throw (e);
        }
        catch (IOException e) {
            error("Detected exception: ", e);
            throw (e);
        } catch (ParsePropertyException e) {
            error("Detected exception: ", e);
            throw (e);
		} catch (InvalidFormatException e) {
            error("Detected exception: ", e);
            throw (e);
		}
		finally {
			try { outs.close(); } catch(Exception ignored) {}
			try { ins.close();  } catch(Exception ignored) {}
			
			if (f != null) {
				// Download Excel 파일 삭제
				FileUtils.deleteFile(downloadFile);
			}
		}
    }
}