/*
 * @(#)FileView.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.view;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;

import com.wsc.framework.base.BaseConstants;
import com.wsc.framework.model.RecordMap;

/**
 * 파일 뷰 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class FileView extends DownloadView {
    /**
     * 파일 경로
     */
    public static final String FILE_PATH = "FILE_PATH";
    
    /**
     * 파일 이름
     */
    public static final String FILE_NAME = "FILE_NAME";
    
    /**
     * 파일 크기
     */
    public static final String FILE_SIZE = "FILE_SIZE";
    
    /**
     * 파일 경로를 반환한다.
     * 
     * @param model 모델
     * @return 파일 경로
     */
    private String getFilePath(Map<String, Object> model) {
        return ((RecordMap) model.get(BaseConstants.DATA)).getString(FILE_PATH).replaceAll("\\\\", "/");
    }
    
    /**
     * 파일 이름을 반환한다.
     * 
     * @param model 모델
     * @return 파일 이름
     */
    private String getFileName(Map<String, Object> model) {
        return ((RecordMap) model.get(BaseConstants.DATA)).getString(FILE_NAME);
    }
    
    /**
     * 파일 크기를 반환한다.
     * 
     * @param model 모델
     * @return 파일 크기
     */
    private int getFileSize(Map<String, Object> model) {
        return ((RecordMap) model.get(BaseConstants.DATA)).getInt(FILE_SIZE);
    }
    
    /* 
     * (non-Javadoc)
     * @see org.springframework.web.servlet.view.AbstractView#renderMergedOutputModel(java.util.Map, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        InputStream is = null;
        
        try {
            is = new FileInputStream(getFilePath(model));
            
            response.setContentType(getContentType());
            response.setContentLength(getFileSize(model));
            response.setHeader("Content-Transfer-Encoding", "binary");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + getEncodedFileName(getFileName(model), getBrowser(request)) + "\";");
            
            OutputStream os = response.getOutputStream();
            
            FileCopyUtils.copy(is, os);
        }
        catch (FileNotFoundException fnfe) {
            error("Detected exception: ", fnfe);
            
            handleError(request, response, fnfe);
        }
        catch (IOException ioe) {
            error("Detected exception: ", ioe);
            
            handleError(request, response, ioe);
        }
        finally {
            if (is != null) {
                try {
                    is.close();
                }
                catch (IOException ioe) {
                    warn("Detected exception: ", ioe);
                }
            }
        }
    }
}