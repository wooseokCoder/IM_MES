/*
 * @(#)BaseException.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.base;

/**
 * 기본 오류 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class BaseException extends RuntimeException {
    /**
     * 시리얼 버전 아이디
     */
    private static final long serialVersionUID = 1L;
    
    /**
     * 코드
     */
    private String code;
    
    /**
     * 메시지를 인자로 가지는 생성자이다.
     * 
     * @param message 메시지
     */
    protected BaseException(String message) {
        super(message);
    }
    
    /**
     * 코드와 메시지를 인자로 가지는 생성자이다.
     * 
     * @param code 코드
     * @param message 메시지
     */
    protected BaseException(String code, String message) {
        super(message);
        
        this.code = code;
    }
    
    /**
     * 코드를 반환한다.
     * 
     * @return 코드
     */
    public String getCode() {
        return code;
    }
}