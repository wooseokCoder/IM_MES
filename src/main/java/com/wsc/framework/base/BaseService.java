/*
 * @(#)BaseService.java 1.0 2014/07/25
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.base;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.exception.ServiceException;
import com.wsc.framework.model.PagingMap;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

/**
 * 기본 서비스 클래스이다.
 *
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
@SuppressWarnings({ "unchecked", "rawtypes" })
public abstract class BaseService {

	protected abstract BaseDao getDao();

	protected abstract MessageSource getMessageSource();

	protected abstract SessionComponent getSessionComponent();


    public static final String STATUS_NAME = "oper";
    /**
     * 등록 상태
     */
    public static final String STATUS_INSERT = "I";

    /**
     * 수정 상태
     */
    public static final String STATUS_UPDATE = "U";

    /**
     * 삭제 상태
     */
    public static final String STATUS_DELETE = "D";

    /**
     * 조회 상태
     */
    public static final String STATUS_READ = "R";

    private String _getStatus(Object o) {
    	String status = null;

    	if (o instanceof String)
    		status = (String)o;
    	else if (o instanceof ParamsMap)
    		status = ((ParamsMap)o).getString(STATUS_NAME);
    	else if (o instanceof Map)
    		status = (String)((Map)o).get(STATUS_NAME);

    	return status;
    }

    protected boolean isInsert(Object o) {
    	String status = _getStatus(o);
    	return STATUS_INSERT.equals(status);
    }
    protected boolean isUpdate(Object o) {
    	String status = _getStatus(o);
    	return STATUS_UPDATE.equals(status);
    }
    protected boolean isDelete(Object o) {
    	String status = _getStatus(o);
    	return STATUS_DELETE.equals(status);
    }
    protected boolean isRead(Object o) {
    	String status = _getStatus(o);
    	return STATUS_READ.equals(status);
    }
    protected boolean isSaveStatus(Object o) {
    	String status = _getStatus(o);

    	return STATUS_INSERT.equals(status) ||
    		   STATUS_UPDATE.equals(status) ||
    	       STATUS_DELETE.equals(status);
    }

    /**
     * 처리결과를 반환한다.
     *
     * @param message 메시지
     * @return 처리결과
     */
    protected ResultMap success(String message) {
        ResultMap result = new ResultMap();
        result.put(ResultMap.SUCCESS, true);
        result.put(ResultMap.MESSAGE, message);
        return result;
    }
    protected ResultMap successStatus(ParamsMap params) {

		String code = getMessageKey("success", params);
    	ResultMap result = new ResultMap();
        result.put(ResultMap.SUCCESS, true);
        result.put(ResultMap.MESSAGE, getMessage(code));
        return result;
    }

    /**
     * 처리결과를 반환한다.
     *
     * @param message 메시지
     * @return 처리결과
     */
    protected ResultMap failure(String message) {
        ResultMap result = new ResultMap();
        result.put(ResultMap.SUCCESS, false);
        result.put(ResultMap.MESSAGE, message);
        return result;
    }
    protected ResultMap failureStatus(ParamsMap params) {

		String code = getMessageKey("error", params);
    	ResultMap result = new ResultMap();
        result.put(ResultMap.SUCCESS, false);
        result.put(ResultMap.MESSAGE, getMessage(code));
        return result;
    }

    /**
     * 상태값에 따라 해당 메세지 KEY를 반환한다.
     *
     * @param params 파라메터맵
     * @return 메세지 KEY
     */
    protected String getMessageKey(String prefix, Map params) {

		String code = "save";
		if      (isInsert(params)) code = "insert";
		else if (isUpdate(params)) code = "update";
		else if (isDelete(params)) code = "delete";

		return prefix + "."+code;
    }
    protected String getResultMessage(String prefix, Map params) {
    	String key = getMessageKey(prefix, params);
    	return getMessage(key);
    }

	public String getString(String id, Object params) {
		return (String)getDao().select(id, params);
	}
	public boolean getBoolean(String id, Object params) {
		Boolean obj = (Boolean)getDao().select(id, params);
		return (obj != null ? obj.booleanValue() : false);
	}
	public long getLong(String id, Object params) {
		Long obj = (Long)getDao().select(id, params);
		return (obj != null ? obj.longValue() : 0);
	}
	public int getInt(String id, Object params) {
		Integer obj = (Integer)getDao().select(id, params);
		return (obj != null ? obj.intValue() : 0);
	}
	public Map getMap(String id, Object params) {
		return (Map)getDao().select(id, params);
	}
	@Transactional
	public int insert(String id, Object params) {
		return getDao().insert(id, params);
	}
	@Transactional
	public int update(String id, Object params) {
		return getDao().update(id, params);
	}
	@Transactional
	public int delete(String id, Object params) {
		return getDao().delete(id, params);
	}
	// C, U, D
	@Transactional
	public int execute(String id, Object params) {
		return update(id, params);
	}
	public boolean exist(String id, Object params) {
		return getBoolean(id, params);
	}
	public Object select(String id, Object params) {
		return getDao().select(id, params);
	}
	public int searchCount(String id, Object params) {
		return getInt(id, params);
	}

	public List search(String id, Object params) {
		return getDao().search(id, params);
	}
	public PagingMap search(String id, Object params, int page, int rows) {
		return getDao().search(id, params, page, rows);
	}

	@Transactional
	public int insert(Object params) {
		return insert(getNameSpace() + ".insert", params);
	}
	@Transactional
	public int update(Object params) {
		return update(getNameSpace() + ".update", params);
	}
	@Transactional
	public int delete(Object params) {
		return delete(getNameSpace() + ".delete", params);
	}
	public boolean exist(Object params) {
		return exist(getNameSpace() + ".exist", params);
	}
	public Object select(Object params) {
		return select(getNameSpace() + ".select", params);
	}
	public List search(Object params) {
		return search(getNameSpace() + ".search", params);
	}
	@Transactional
	public int reset(Object params) {
		return delete(getNameSpace() + ".reset", params);
	}
	public List searchHd(Object params) {
		return search("com.wsc.framework.Base.searchHd", params);
	}
	public List getMyViewName(Object params) {
		return search("com.wsc.framework.Base.getMyViewName", params);
	}
    /**
     * 목록 요청 (AJAX)
     * 수정일 : 20160919
     * 수정자 : 김원국
     * 내   용 : xmlid 더 붙여서 추가적인 컨트롤 단 및 서비스 단을 수정을 안하여도 된다.
     * @param request
     * @param model
     * @param xmlid
     * @return String
     */
	public List search(Object params, String xmlid) {
		return search(getNameSpace() + "."+xmlid, params);
	}
	public List search2(Object params, String sqlId) {     //2016/09/19 김영진
		return search(getNameSpace() + "." + sqlId, params);
	}
	public int searchCount(Object params) {
		return searchCount(getNameSpace() + ".searchCount", params);
	}
	public PagingMap search(Object params, int page, int rows) {
		return search(getNameSpace() + ".search", params, page, rows);
	}
    /**
     * 목록 요청 (AJAX)
     * 수정일 : 20160919
     * 수정자 : 김원국
     * 내   용 : xmlid 더 붙여서 추가적인 컨트롤 단 및 서비스 단을 수정을 안하여도 된다.
     * @param request
     * @param model
     * @param xmlid
     * @return String
     */
	public PagingMap search(Object params, int page, int rows, String xmlid) {
		return search(getNameSpace() + "."+xmlid, params, page, rows);
	}

	@Transactional
	public ResultMap save(Object params) {
		return saveByName("", params);
	}
	@Transactional
	protected void saveModel(Map model) {
		saveModel("", model);
	}

	/**
	 * 맵객체를 "oper" 상태값에 따라 등록,수정,삭제 처리한다.
	 *
	 * @param model   저장할 맵객체
	 * @param postKey CRUD SQL ID의 POSTFIX
	 *                ex) SQL ID가 "insertCode" 인 경우 => "Code"
	 */
	@Transactional
	protected void saveModel(String postKey, Map model) {

		String sql = getQueryName(postKey, model);

		//상세조회용 SQL
		String viewSql = getNameSpace() + ".select"+postKey;

		if (sql == null)
			throw new ServiceException(getMessage("error.status", new String[] {STATUS_NAME}));

		if (isInsert(model) &&
			select(viewSql, model) != null) {
			throw new ServiceException(getMessage("error.exist"));
		}
		else if (update(sql, model) <= 0) {

			if (isSaveStatus(model))
				throw new ServiceException(getResultMessage("error", model));
			else
				throw new ServiceException(getMessage("error.unknown"));
		}
	}

	/**
	 * 목록 저장 시 삭제를 먼저 처리한 후에 저장 처리한다.
	 *
	 * @param params
	 * @param postKey
	 * @return 처리결과
	 */
	@Transactional
	protected ResultMap saveFirstDelete(String postKey, Object params) {

		ParamsMap map = (ParamsMap)params;
		String code = getMessageKey("success", map);

		List<Map> list = (List<Map>)map.get(ParamsMap.MODEL_LIST);

		//기본 파라메터 셋팅 및 삭제 먼저 처리
		for (Map model : list) {

			//기본 파라메터 셋팅
			setBaseParams(map, model);

			String sql = getQueryName(postKey, model);

			//삭제 처리
			if (isDelete(model))
				delete(sql, model);
		}

		//상세조회용 SQL
		String viewSql = getNameSpace() + ".select"+postKey;

		//등록 및 수정 처리
		for (Map model : list) {

			String sql = getQueryName(postKey, model);

			//등록
			if (isInsert(model)) {
				if (select(viewSql, model) != null)
					throw new ServiceException(getMessage("error.exist"));

				insert(sql, model);
			}
			//수정
			else if (isUpdate(model)){
				//TODO 20160928 김원국 추가
				if (select(viewSql, model) != null)
					throw new ServiceException(getMessage("error.exist"));

				update(sql, model);
			}

		}

        // 결과를 반환한다.
        return success(getMessage(code));
	}

	//page 파라메터가 있을 경우 페이징 처리 그외엔 일반 검색
	protected Object searchByName(String postKey, Object params) {
		return searchByName(postKey, params, true);
	}

	//paging = false 인 경우엔 일반 검색
	//paging = true  인 경우엔 page 파라메터가 있을 경우 페이징 처리 그외엔 일반 검색
	protected Object searchByName(String postKey, Object params, boolean paging) {

		if (postKey == null)
			postKey = "";

        if (paging == false)
        	return search(getNameSpace()+".search" + postKey, params);

        Object result = null;

        if (params instanceof ParamsMap) {
        	ParamsMap p = (ParamsMap)params;

            if (p.containsKey(PagingMap.PAGE)) {
                int page = p.getInt(PagingMap.PAGE);
                int rows = p.getInt(PagingMap.ROWS);
                result = search(getNameSpace()+".search" + postKey, params, page, rows);
            }
            else {
            	result = search(getNameSpace()+".search" + postKey, params);
            }
        }
        else {
        	result = search(getNameSpace()+".search" + postKey, params);
        }
        return result;
	}

	protected Object selectByName(String postKey, Object params) {
		if (postKey == null)
			postKey = "";
		return select(getNameSpace()+".select" + postKey, params);
	}
	protected int insertByName(String postKey, Object params) {
		if (postKey == null)
			postKey = "";
		return insert(getNameSpace()+".insert" + postKey, params);
	}
	protected int updateByName(String postKey, Object params) {
		if (postKey == null)
			postKey = "";
		return update(getNameSpace()+".update" + postKey, params);
	}
	protected int deleteByName(String postKey, Object params) {
		if (postKey == null)
			postKey = "";
		return delete(getNameSpace()+".delete" + postKey, params);
	}

	@Transactional
	protected ResultMap saveByName(String postKey, Object params) {
		if (postKey == null)
			postKey = "";
		ParamsMap map = (ParamsMap)params;

		String code = getMessageKey("success", map);

		if (!map.containsKey(ParamsMap.MODEL_LIST)) {

			saveModel(postKey, map);

	        // 결과를 반환한다.
	        return success(getMessage(code));
		}

		Object data = map.get(ParamsMap.MODEL_LIST);
		if (data instanceof List) {
			List<Map> list = (List<Map>)data;
			for(Map model : list) {
				setBaseParams(map, model);

				saveModel(postKey, model);
			}
		}
        // 결과를 반환한다.
        return success(getMessage(code));
	}


	protected String getQueryName(String postKey, Object params) {

		String code = "";
		if      (isInsert(params)) code = "insert";
		else if (isUpdate(params)) code = "update";
		else if (isDelete(params)) code = "delete";

		return getNameSpace() + "." + code + postKey;
	}

	/**
	 * 로그인ID 및 시스템ID 등의 기본 파라메터를 대입한다.
	 *
	 * @param params 컨트롤러에서 넘어온 파라메터맵
	 * @param model  저장할 맵객체
	 */
	protected void setBaseParams(ParamsMap params, Map model) {
		model.put(ParamsMap.GS_USER_ID, params.get(ParamsMap.GS_USER_ID));
		model.put(ParamsMap.GS_MENU_SET, params.get(ParamsMap.GS_MENU_SET));
		model.put(ParamsMap.GS_MENU_TYPE, params.get(ParamsMap.GS_MENU_TYPE));
		model.put(ParamsMap.GS_MOBILE_TYPE, params.get(ParamsMap.GS_MOBILE_TYPE));
		model.put(ParamsMap.GS_SYS_ID,  params.get(ParamsMap.GS_SYS_ID));
		model.put(ParamsMap.SYS_ID,     params.get(ParamsMap.SYS_ID));
		model.put(ParamsMap.GS_LANG,    getSessionComponent().getLocale().toString());
	}

	protected String getNameSpace() {
		String cname = getClass().getName();
		if (cname.endsWith("Service")) {
			return cname.substring(0, cname.length() - "Service".length());
		} else {
			return cname;
		}
	}

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


    /**
     * 디폴트 생성자이다.
     */
    protected BaseService() {
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