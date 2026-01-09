/*
 * @(#)BaseConstants.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.base;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.wsc.framework.exception.SystemException;

/**
 * 기본 상수 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class BaseConstants extends HashMap<Object, Object> {
    /**
     * 시리얼 버전 아이디
     */
    private static final long serialVersionUID = 1L;
    
    /**
     * 데이터(결과목록)
     */
    public static final String DATA = "rows";
    
    /**
     * 완료
     */
    public static final String SUCCESS = "success";
    
    /**
     * 오류
     */
    public static final String ERROR = "error";
    
    /**
     * 결과
     */
    public static final String RESULT = "Result";
    
    /**
     * 로컬 호스트
     */
    public static final Map<String, String> LOCALHOST = new HashMap<String, String>();
    
    /**
     * 브라우저
     */
    public static final String BROWSER = "browser";
    
    /**
     * IP
     */
    public static final String IP = "ip";
    
    /**
     * 컨텍스트
     */
    public static final String CONTEXT = "context";
    
    /**
     * URI
     */
    public static final String URI = "uri";
    
    /**
     * 메뉴
     */
    public static final String MENU = "menu";
    
    /**
     * 메뉴키
     */
    public static final String MENU_KEY = "menuKey";
    
    /**
     * 메뉴명
     */
    public static final String MENU_NAME = "menuDesc";
    
    /**
     * 메뉴URL
     */
    public static final String MENU_URL = "menuUrl";
 
    /**
     * 메뉴MSG
     */
    public static final String MENU_MSG = "menuMsg";
    
    /**
     * 메뉴MSG 폰트color
     */
    public static final String MSG_FONT_COLOR = "msgFontColor";
    
    /**
     * 메뉴MSG 배경color
     */
    public static final String MSG_BACK_COLOR = "msgbackColor";
    
    /**
     * 상위메뉴명
     */
    public static final String PARENT_DESC = "parentDesc";
    
    /**
     * 프로그램ID
     */
    public static final String PROG_ID = "progId";
    
    /**
     * 프로그램명
     */
    public static final String PROG_NAME = "progName";
    
    /**
     * 시스템ID
     */
    public static final String SYS_ID = "sysId";
    
    /**
     * 페이징 출력수
     */
    public static final String PAGE_SIZE = "pageSize";
    
    /**
     * 사용자ID
     */
    public static final String USER_ID = "userId";
    
    /**
     * 사용자명
     */
    public static final String USER_NAME = "userName";
    
    /**
     * 상위부서명
     */
    public static final String UPPR_DEPT_CODE = "userUpprDeptCode";    
    
    /**
     * 부서명
     */
    public static final String DEPT_CODE = "userDeptCode";
    
    /**
     * 관리자 
     */
    public static final String ADMIN = "admin";
    
    /**
     * 레포트 URL 
     */
    public static final String REPORT_URL = "reportUrl";
    
    
    /**
     * 탭패널 사용여부
     */
    public static final String TABPANEL = "tabPanel";
	
    public static final String DEFAULT_USER_ID = "guest";
    
    public static final String DEFAULT_USER_NAME = "손님";
    
    public static final String DEFAULT_USER_TYPE = "A"; //A:내부,C:업체
	
    public static final String DEFAULT_GROUP_ID   = "ANONYMOUS";

    public static final String DEFAULT_GROUP_NAME = "비인증 사용자 그룹";
    
    public static final String[] ADMIN_GROUPS = {"SYSTEM"};
    
    /*
     * 클래스 필드를 초기화한다.
     */
    static {
        // 로컬 호스트
        LOCALHOST.put("::1",             "127.0.0.1");
        LOCALHOST.put("0:0:0:0:0:0:0:1", "127.0.0.1");
    }
    
    /**
     * 로그
     */
    protected Logger log;
    
    /**
     * 디폴트 생성자이다.
     */
    protected BaseConstants() {
        // 로그를 생성한다.
        log = LoggerFactory.getLogger(getClass());
        
        // 상수를 초기화한다.
        initConstants();
    }
    
    /**
     * 상수를 초기화한다.
     */
    private void initConstants() {
        try {
            Field[] fields = getClass().getDeclaredFields();
            
            for (int i = 0; i < fields.length; i++) {
                int modifiers = fields[i].getModifiers();
                
                if (Modifier.isPublic(modifiers) && Modifier.isStatic(modifiers) && Modifier.isFinal(modifiers)) {
                    put(fields[i].getName(), fields[i].get(this));
                }
            }
        }
        catch (IllegalAccessException iae) {
            error("Detected exception: ", iae);
            
            throw new SystemException("error.system", iae.getMessage());
        }
    }
    

    protected final void trace(String message) {
        if (log.isTraceEnabled()) {
            log.trace(message);
        }
    }
    protected final void trace(String message, Throwable throwable) {
        if (log.isTraceEnabled()) {
            log.trace(message, throwable);
        }
    }
    protected final void debug(String message) {
        if (log.isDebugEnabled()) {
            log.debug(message);
        }
    }
    protected final void debug(String message, Throwable throwable) {
        if (log.isDebugEnabled()) {
            log.debug(message, throwable);
        }
    }
    protected final void info(String message) {
        if (log.isInfoEnabled()) {
            log.info(message);
        }
    }
    protected final void info(String message, Throwable throwable) {
        if (log.isInfoEnabled()) {
            log.info(message, throwable);
        }
    }
    protected final void warn(String message) {
        if (log.isWarnEnabled()) {
            log.warn(message);
        }
    }
    protected final void warn(String message, Throwable throwable) {
        if (log.isWarnEnabled()) {
            log.warn(message, throwable);
        }
    }
    protected final void error(String message) {
        if (log.isErrorEnabled()) {
            log.error(message);
        }
    }
    protected final void error(String message, Throwable throwable) {
        if (log.isErrorEnabled()) {
            log.error(message, throwable);
        }
    }
}