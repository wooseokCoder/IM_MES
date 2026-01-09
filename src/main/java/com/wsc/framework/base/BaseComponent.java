/*
 * @(#)BaseComponent.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.base;

import org.springframework.context.MessageSource;

import com.wsc.common.security.SessionComponent;

/**
 * 기본 컴포넌트 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public abstract class BaseComponent {
	
	protected abstract MessageSource getMessageSource();
	
	protected abstract SessionComponent getSessionComponent();

    protected String getMessage(String code) {
        return getMessage(code, null, code);
    }
    protected String getMessage(String code, Object[] arguments) {
        return getMessage(code, arguments, code);
    }
    protected String getMessage(String code, String defaultMessage) {
        return getMessage(code, null, defaultMessage);
    }
    protected String getMessage(String code, Object[] arguments, String defaultMessage) {
        return getMessageSource().getMessage(code, arguments, defaultMessage, getSessionComponent().getLocale());
    }
}