/*
 * @(#)BaseDao.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.base;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.ResultHandler;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import com.wsc.framework.model.PagingMap;
import com.wsc.framework.model.ParamsMap;

/**
 * 기본 DAO 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 * 
 * 
 */
public abstract class BaseDao extends SqlSessionDaoSupport {
	
    /**
     * 상단 데이터 접미어
     */
    public static final String SUFFIX_UPPER = "Upper";
    
    /**
     * 검색 카운트 접미어
     */
    public static final String SUFFIX_COUNT = "Count";
    
    /**
     * 전체 카운트 접미어
     */
    public static final String SUFFIX_TOTAL = "Total";
    
    /**
     * 매뉴얼 페이징 모드
     */
    public static final int PAGING_MANUAL = 0;
    
    /**
     * 스크롤 페이징 모드
     */
    public static final int PAGING_SCROLL = 1;

    
    /**
     * 정렬 정보를 설정한다.
     * 
     * @param params 파라메터
     */
    protected void setSort(ParamsMap params) {
    	
        String sort  = params.getString(ParamsMap.SORT);
        String order = params.getString(ParamsMap.ORDER);
        
        if (sort.length() > 0) {
        	
            String[] names  = sort.split(",");
            String[] orders = order.split(",");
            
            List<String> sorts = new ArrayList<String>(names.length);
            
            for (int i = 0; i < names.length; i++) {
                //if (names[i].matches(".*[a-z].*")) {
            	//    continue;
            	//}
                sorts.add("\"" + names[i] + "\" " + orders[i]);
            }
            params.put(ParamsMap.GS_SORTS, sorts);
        }
    }
    
    /**
     * 데이터를 검색한다.
     * 
     * @param id 아이디
     * @return 검색결과
     */
    public List<?> search(String id) {
    	return getSqlSession().selectList(id);
    }
    
    /**
     * 데이터를 검색한다.
     * 
     * @param id 아이디
     * @param params 파라메터
     * @return 검색결과
     */
    public List<?> search(String id, Object params) {
        if (params instanceof ParamsMap) {
            setSort((ParamsMap) params);
        }
        
        return getSqlSession().selectList(id, params);
    }
    
    
    /**
     * 데이터를 검색한다.
     * 
     * @param id 아이디
     * @param handler 핸들러
     */
    public void search(String id, ResultHandler handler) {
        getSqlSession().select(id, handler);
    }

    /**
     * 데이터를 검색한다.
     * 
     * @param id 아이디
     * @param handler 핸들러
     */
    public void search(String id, Object params, ResultHandler handler) {
        if (params instanceof ParamsMap) {
            setSort((ParamsMap) params);
        }
        getSqlSession().select(id, params, handler);
    }
    
    /**
     * 데이터를 검색한다.
     * 
     * @param id 아이디
     * @param page 페이지 번호
     * @param rows 페이지 크기
     * @return 검색결과
     */
    public PagingMap search(String id, int page, int rows) {
        return search(id, null, page, rows);
    }
    
    /**
     * 데이터를 검색한다.
     * 
     * @param id 아이디
     * @param params 파라메터
     * @param page 페이지 번호
     * @param rows 페이지 크기
     * @return 검색결과
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public PagingMap search(String id, Object params, int page, int rows) {

        if (params instanceof ParamsMap) {
            setSort((ParamsMap) params);
        }
        
        List data = new ArrayList();
        
        // 검색 카운트를 조회한다.
        int total  = ((Integer) getSqlSession().selectOne(id + SUFFIX_COUNT, params)).intValue();
        int pages  = 0;
        int index  = 0;
        int start  = 0;
        int end    = 0;
        //int offset = 0;
        //int limit  = 0;
        
        if (total > 0) {
            pages  = (total / rows) + (total % rows > 0 ? 1 : 0);
            index  = (page > pages ? pages : page) - 1;

            //(index * rows) + 1
            //(index + 1) * rows

            //offset = (index * rows);
        	//limit  = (index + 1) * rows;
            
            start = (index * rows) + 1; 
            end   = (index + 1) * rows + 1; 

        	Object parameters = params != null ? params : new ParamsMap();
            
            if (parameters instanceof ParamsMap) {
                ((ParamsMap) parameters).put(PagingMap.START,  start);
                ((ParamsMap) parameters).put(PagingMap.END,    end);
            }
            
            //RowBounds rowBounds = new RowBounds(offset, limit);
            
            // 데이터를 검색한다.
            //data.addAll(getSqlSession().selectList(id, parameters, rowBounds));
            data.addAll(getSqlSession().selectList(id, parameters));
        }
        
        PagingMap paging = new PagingMap();
        
        paging.put(PagingMap.PAGE,  index + 1);
        paging.put(PagingMap.COUNT, data.size());
        paging.put(PagingMap.TOTAL, total);
        paging.put(PagingMap.PAGES, pages);
        paging.put(BaseConstants.DATA,  data);
        
        return paging;
    }
    
    /**
     * 데이터를 등록한다.
     * 
     * @param id 아이디
     * @return 등록결과
     */
    public int insert(String id) {
        return getSqlSession().insert(id);
    }
    
    /**
     * 데이터를 등록한다.
     * 
     * @param id 아이디
     * @param params 파라메터
     * @return 등록결과
     */
    public int insert(String id, Object params) {
        return getSqlSession().insert(id, params);
    }
    
    /**
     * 데이터를 조회한다.
     * 
     * @param id 아이디
     * @return 조회결과
     */
    public Object select(String id) {
        return getSqlSession().selectOne(id);
    }
    
    /**
     * 데이터를 조회한다.
     * 
     * @param id 아이디
     * @param params 파라메터
     * @return 조회결과
     */
    public Object select(String id, Object params) {
        return getSqlSession().selectOne(id, params);
    }
    
    /**
     * 데이터를 수정한다.
     * 
     * @param id 아이디
     * @return 수정결과
     */
    public int update(String id) {
        return getSqlSession().update(id);
    }
    
    /**
     * 데이터를 수정한다.
     * 
     * @param id 아이디
     * @param params 파라메터
     * @return 수정결과
     */
    public int update(String id, Object params) {
        return getSqlSession().update(id, params);
    }
    
    /**
     * 데이터를 삭제한다.
     * 
     * @param id 아이디
     * @return 삭제결과
     */
    public int delete(String id) {
        return getSqlSession().delete(id);
    }
    
    /**
     * 데이터를 삭제한다.
     * 
     * @param id 아이디
     * @param params 파라메터
     * @return 삭제결과
     */
    public int delete(String id, Object params) {
        return getSqlSession().delete(id, params);
    }
    
}