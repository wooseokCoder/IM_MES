/*
 * @(#)DownloadView.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.view;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.wsc.framework.base.BaseConstants;
import com.wsc.framework.base.BaseView;

/**
 * 다운로드 뷰 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public abstract class DownloadView extends BaseView {
    /**
     * 디폴트 생성자이다.
     */
    public DownloadView() {
        setContentType("application/octet-stream");
    }
    
    /**
     * 브라우저를 반환한다.
     * 
     * @param request HTTP 요청
     * @return 브라우저
     */
    protected String getBrowser(HttpServletRequest request) {
        return (String) request.getAttribute(BaseConstants.BROWSER);
    }
    
    /**
     * 파일 이름을 인코딩한다.
     * 
     * @param name 파일 이름
     * @param browser 브라우저
     * @return 파일 이름
     */
    protected String getEncodedFileName(String name, String browser) {
        try {
            if ("MSIE".equals(browser)) {
                return URLEncoder.encode(name, "UTF-8").replaceAll("\\+", " ");
            }
            else {
                return new String(name.getBytes("UTF-8"), "ISO-8859-1"); 
            }
        }
        catch (UnsupportedEncodingException uee) {
            warn("Detected exception: ", uee);
            
            return name;
        }
    }
    
    /**
     * 오류를 처리한다.
     * 
     * @param request HTTP 요청
     * @param response HTTP 응답
     * @param exception 오류
     */
    protected void handleError(HttpServletRequest request, HttpServletResponse response, Exception exception) {
        try {
            response.reset();
            
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            response.setContentType("text/html; charset=UTF-8");
            
            PrintWriter writer = response.getWriter();
            
            writer.println("<script type=\"text/javascript\">");
            writer.println("(function() {");
            
            if (exception instanceof FileNotFoundException) {
                //TODO. writer.println("    alert(\"" + getMessage("error.notfound.file") + "\");");
            }
            else {
                //TODO. writer.println("    alert(\"" + getMessage("error.system") + "\");");
            }
            
            writer.println("})();");
            writer.println("</script>");
        }
        catch (IOException ioe) {
            warn("Detected exception: ", ioe);
        }
    }
}