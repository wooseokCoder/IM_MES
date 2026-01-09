/*
 * @(#)Result.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.model;

import com.wsc.framework.base.BaseMap;

/**
 * 결과 모델 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class ResultMap extends BaseMap {
    /**
     * 시리얼 버전 아이디
     */
    private static final long serialVersionUID = 1L;
    
    /**
     * 처리결과
     */
    public static final String SUCCESS = "success";
    
    /**
     * 코드
     */
    public static final String CODE = "code";
    
    /**
     * 메시지
     */
    public static final String MESSAGE = "message";
    
    /**
     * 처리결과를 반환한다.
     * 
     * @return 처리결과
     */
    public boolean getSuccess() {
        return getBoolean(SUCCESS);
    }
    
    /**
     * 코드를 반환한다.
     * 
     * @return 코드
     */
    public int getCode() {
        return getInt(CODE);
    }
    
    /**
     * 메시지를 반환한다.
     * 
     * @return 메시지
     */
    public String getMessage() {
        return getString(MESSAGE);
    }
}