/*
 * @(#)BaseView.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.base;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.view.AbstractView;

/**
 * 기본 뷰 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public abstract class BaseView extends AbstractView {

    /**
     * 디폴트 생성자이다.
     */
    protected BaseView() {
        // 로그를 생성한다.
    	log = LoggerFactory.getLogger(getClass());
    }
	
    /**
     * 로그
     */
    protected Logger log;

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