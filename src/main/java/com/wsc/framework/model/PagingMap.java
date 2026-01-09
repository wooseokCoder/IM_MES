/*
 * @(#)Paging.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.model;

import com.wsc.framework.base.BaseConstants;
import com.wsc.framework.base.BaseMap;

/**
 * 페이징 모델 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class PagingMap extends BaseMap {
    /**
     * 시리얼 버전 아이디
     */
    private static final long serialVersionUID = 1L;
    
    /**
     * 페이지 번호
     */
    public static final String PAGE = "page";
    
    /**
     * 페이지 크기(입력값)
     */
    public static final String ROWS = "rows";
    
    /**
     * 검색 카운트
     */
    public static final String COUNT = "count";
    
    /**
     * 전체 카운트
     */
    public static final String TOTAL = "total";
    
    /**
     * 전체 페이지
     */
    public static final String PAGES = "pages";
    
    /**
     * 시작 행번호
     */
    public static final String START = "start";
    
    /**
     * 종료 행번호
     */
    public static final String END = "end";
    
    /**
     * 페이지 번호를 반환한다.
     * 
     * @return 페이지 번호
     */
    public int getPage() {
        return getInt(PAGE);
    }
    
    /**
     * 페이지 크기를 반환한다.
     * 
     * @return 페이지 크기
     */
    public int getRows() {
        return getInt(ROWS);
    }
    
    /**
     * 데이터를 반환한다.
     * 
     * @return 데이터
     */
    public Object getData() {
        return get(BaseConstants.DATA);
    }
    
    /**
     * 검색 카운트를 반환한다.
     * 
     * @return 검색 카운트
     */
    public int getCount() {
        return getInt(COUNT);
    }
    
    /**
     * 전체 카운트를 반환한다.
     * 
     * @return 전체 카운트
     */
    public int getTotal() {
        return getInt(TOTAL);
    }
    
    /**
     * 전체 페이지를 반환한다.
     * 
     * @return 전체 페이지
     */
    public int getPages() {
        return getInt(PAGES);
    }
}