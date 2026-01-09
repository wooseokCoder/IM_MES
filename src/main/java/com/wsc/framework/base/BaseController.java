/*
 * @(#)BaseController.java 1.0 2014/07/25
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.base;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.rmi.RemoteException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.ui.Model;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.model.Group;
import com.wsc.common.model.User;
import com.wsc.common.security.SessionComponent;
import com.wsc.common.user.ProgramService;
import com.wsc.common.user.UserLogListService;
import com.wsc.framework.exception.SystemException;
import com.wsc.framework.model.PagingMap;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.view.JxlsView;	
/**
 * 기본 컨트롤러 클래스이다.
 *
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public abstract class BaseController {

	protected final static String INSERT = "I";
	protected final static String UPDATE = "U";
	protected final static String DELETE = "D";

    /*************************************************************************
     * base request mappings
     *************************************************************************/

    protected abstract BaseService getService();

    @Autowired
    UserLogListService userloglistservice;

    @Autowired
    ProgramService programService;

    protected abstract SessionComponent getSessionComponent();

	protected String getViewName(String name) {
		String cname = getClass().getPackage().getName();
		String prefix = "com.wsc.";

		if (cname.startsWith(prefix))
			cname = cname.substring(prefix.length());

		cname = BaseUtils.replace(cname, ".", "/").toLowerCase();

		return cname + "/" + name;
	}

	protected String getViewName() {

		String cname = getName();

		if (cname == null)
			return null;

		return getViewName(cname.toLowerCase());
	}

	protected String getView(String name) {

		if (name == null)
			return getViewName();

		return getViewName(name);
	}

	protected String getName() {

		String cname  = getClass().getName();
		String posfix = "Controller";

		if (cname.endsWith(posfix))
			cname = cname.substring(cname.lastIndexOf(".")+1, cname.length() - posfix.length());

		return cname;
	}

	protected Object searchList(ParamsMap params) {

        Object result = null;

        if (params.containsKey(PagingMap.PAGE)) {
            int page = params.getInt(PagingMap.PAGE);
            int rows = params.getInt(PagingMap.ROWS);

            result = getService().search(params, page, rows);
        }
        else {
        	result = getService().search(params);
        }
        return result;
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
	protected Object searchList(ParamsMap params, String xmlid) {

        Object result = null;

        if (params.containsKey(PagingMap.PAGE)) {
            int page = params.getInt(PagingMap.PAGE);
            int rows = params.getInt(PagingMap.ROWS);

            result = getService().search(params, page, rows, xmlid);
        }
        else {
        	result = getService().search(params, xmlid);
        }
        return result;
	}


    // 페이지 오픈
    protected String open(HttpServletRequest request, Model model, String viewName) {

    	//[WSC2.0] [2015.04 LSH] 상단정보 설정
    	initParams(model);

    	//[2017.01 SJY] 로그등록
    	logSave(request, model);

    	//[2017.03.03 kwk] 권한 체크
    	programAuth(request, model);

    	System.out.println(getViewName());

    	if (viewName == null)
    		return getViewName();

    	return getViewName(viewName);
    }

    public void programAuth(HttpServletRequest request, Model model){
    	ParamsMap params = getParams(request, true);
    	String sysId  = request.getContextPath();
    	params.add("progId", request.getRequestURI().substring(sysId.length()));
    	RecordMap result = (RecordMap)programService.select("programAuth", params);
    	model.addAttribute("BAS", ((String)result.get("BAS")).equals("1") ? false : true); //기본
    	model.addAttribute("INS", ((String)result.get("INS")).equals("1") ? false : true); //등록
    	model.addAttribute("RET", ((String)result.get("RET")).equals("1") ? false : true); //조회
    	model.addAttribute("UPD", ((String)result.get("UPD")).equals("1") ? false : true); //수정
    	model.addAttribute("DEL", ((String)result.get("DEL")).equals("1") ? false : true); //삭제
    	model.addAttribute("AUP", ((String)result.get("AUP")).equals("1") ? false : true); //답글
    	model.addAttribute("AUS", ((String)result.get("AUS")).equals("1") ? false : true); //권한S
    	model.addAttribute("AU1", ((String)result.get("AU1")).equals("1") ? false : true); //권한1
    	model.addAttribute("AU2", ((String)result.get("AU2")).equals("1") ? false : true); //권한2
    	model.addAttribute("AU3", ((String)result.get("AU3")).equals("1") ? false : true); //권한3
    	model.addAttribute("AU4", ((String)result.get("AU4")).equals("1") ? false : true); //권한4
    	model.addAttribute("AU5", ((String)result.get("AU5")).equals("1") ? false : true); //권한5
    }

    /**
     * 사용자 로그등록
     * 작성일 : 20170120
     * 작성자 : 유서진
     * @param request
     * @param model
     * @param xmlid
     * @return String
     */
    protected void logSave(HttpServletRequest request, Model model) {

    	// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	User user = getUser();

    	String sysId  = request.getContextPath();

    	params.put("sysId",			user.getSysId());
    	params.put("userId",		user.getUserId());
    	params.put("menuSet",	user.getMenuSet());
        params.put("progId", 		request.getRequestURI().substring(sysId.length()));
    	params.put("clientIp",  	request.getRemoteAddr());
    	params.put("clientName",	request.getRemoteUser());
    	params.put("clientAgent",  	request.getHeader("User-Agent"));
    	params.put("userType",	user.getUserType());
    	params.put("orgAuthCode",	user.getOrgAuthCode());
    	params.put("spcAuthCode",	user.getSpcAuthCode());
    	params.add("oper", INSERT);

    	try {
    		userloglistservice.insert(params);
		} catch (Exception e) {
			// TODO: handle exception
		}

    }
    
    protected void logSaveSF(HttpServletRequest request, Model model) {

    	// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	User user = getUser();

    	String sysId  = request.getContextPath();

    	params.put("sysId",			user.getSysId());
    	params.put("userId",		user.getUserId());
    	params.put("menuSet",	user.getMenuSet());
    	if(params.get("progId") == null || params.getString("progId").isEmpty()) {
    		params.put("progId", 		request.getRequestURI().substring(sysId.length()));
    	}
        
    	params.put("clientIp",  	request.getRemoteAddr());
    	params.put("clientName",	request.getRemoteUser());
    	params.put("clientAgent",  	request.getHeader("User-Agent"));
    	params.put("userType",	user.getUserType());
    	params.put("orgAuthCode",	user.getOrgAuthCode());
    	params.put("spcAuthCode",	user.getSpcAuthCode());
    	params.add("oper", INSERT);

    	try {
    		userloglistservice.insert(params);
		} catch (Exception e) {
			// TODO: handle exception
		}

    }

    protected String Taxopen(HttpServletRequest request, Model model) throws RemoteException {
    	return open(request, model, null);
    }

    protected String open(HttpServletRequest request, Model model) {
    	return open(request, model, null);
    }

    // 목록 요청 (AJAX)
    protected String search(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = searchList(params);

        //TODO 김원국 수정
        HttpSession sessionS = request.getSession();

        if(sessionS.getAttribute("rows") != null){
            if(params.getRows() != Integer.parseInt((sessionS.getAttribute("rows")).toString())){
            	sessionS.setAttribute("rows", params.getRows());
            }
        }else{
        	sessionS.setAttribute("rows", params.getRows());
        }
        params.add("rows", sessionS.getAttribute("rows"));

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
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
    protected String search(HttpServletRequest request, Model model, String xmlid) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = searchList(params,xmlid);

        //TODO 김원국 수정
        HttpSession sessionS = request.getSession();

        if(sessionS.getAttribute("rows") != null){
            if(params.getRows() != Integer.parseInt((sessionS.getAttribute("rows")).toString())){
            	sessionS.setAttribute("rows", params.getRows());
            }
        }else{
        	sessionS.setAttribute("rows", params.getRows());
        }
        params.add("rows", sessionS.getAttribute("rows"));

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
    }

    //엑셀 기본정보 정의
    protected void setExcelParams(Model model, Object result, String templateName, String downloadName) {
        model.addAttribute(JxlsView.TEMPLATE_NAME, templateName);
        model.addAttribute(JxlsView.DOWNLOAD_NAME, downloadName);
        model.addAttribute(BaseConstants.DATA, result);
        
    }
    protected void setExcelParams(Model model, Object result, String fileName) {
    	Date d = new Date();
        
        String s = d.toString();
        
        SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyy");
        
        String nowDate = sdf.format(d);
        
    	setExcelParams(model, result, fileName+"_Template.xlsx", fileName+"_"+nowDate+".xlsx");
    }
    protected void setExcelParams(Model model, Object result) {
    	Date d = new Date();
        
        String s = d.toString();
        
        SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyy");
        
        String nowDate = sdf.format(d);
        
    	setExcelParams(model, result, getName()+"_Template.xlsx", getName()+"_"+nowDate+".xlsx");
    }

    // 엑셀 다운로드
    protected String download(HttpServletRequest request, Model model) {


        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        // 파라메타 한글 깨짐 20180202 박민혁
        Enumeration params1 = request.getParameterNames();
    	while (params1.hasMoreElements()){
    	    String name = (String)params1.nextElement();
    	    try {
    	    	params.put(name, new String(request.getParameter(name).getBytes("iso-8859-1"), "utf-8"));
    	    } catch (Exception e) {
    			// TODO: handle exception
    			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
    			e.printStackTrace();
    		}
    	}

        Object result = getService().search(params);

        setExcelParams(model, result);

        // 뷰이름을 반환한다.
        return "jxlsView";
    }

    // 엑셀 다운로드(sql명, 파일명)    --2016/09/19 김영진
    protected String download(HttpServletRequest request, Model model, String sqlId, String fileName) {
    	if(fileName == "" || fileName == null){
    		fileName = sqlId;
    	}

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = getService().search2(params, sqlId);
        
        setExcelParams(model, result, fileName);

        // 뷰이름을 반환한다.
        return "jxlsView";
    }

    // 상세 조회 (AJAX)
    protected String select(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request);

        Object result = getService().select(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
    }


    // 등록
    protected String insert(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	params.add("oper", INSERT);

        int result = getService().insert(params);

        // 모델에 객체를 추가한다.
        addObject(model, getResult(INSERT, result));

        // 뷰이름을 반환한다.
        return "jsonView";
    }
    // 수정
    protected String update(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	params.add("oper", UPDATE);

        int result = getService().update(params);

        // 모델에 객체를 추가한다.
        addObject(model, getResult(UPDATE, result));

        // 뷰이름을 반환한다.
        return "jsonView";
    }

    // 삭제
    protected String delete(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	params.add("oper", DELETE);

        int result = getService().delete(params);

        // 모델에 객체를 추가한다.
        addObject(model, getResult(DELETE, result));

        // 뷰이름을 반환한다.
        return "jsonView";
    }

    // 저장 (등록, 수정, 삭제)
    protected String save(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

        Object result = getService().save(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
    }


    protected ResultMap getResult(String oper, int result) {

    	String  key  = "";
    	boolean ret = false;

    	if (result > 0) {
    		ret = true;
    		if      (INSERT.equals(oper)) key = "success.insert";
    		else if (UPDATE.equals(oper)) key = "success.update";
    		else if (DELETE.equals(oper)) key = "success.delete";
    		else                          key = "success.save";
    	}
    	else {
    		ret = false;
    		if      (INSERT.equals(oper)) key = "error.insert";
    		else if (UPDATE.equals(oper)) key = "error.update";
    		else if (DELETE.equals(oper)) key = "error.delete";
    		else                          key = "error.save";
    	}

    	ResultMap  res = new ResultMap();
        res.put(ResultMap.SUCCESS, ret);
        res.put(ResultMap.MESSAGE, getMessage(key));

        return res;
    }


    /**
     * HTTP 요청을 반환한다.
     *
     * @return HTTP 요청
     */
    protected HttpServletRequest getRequest() {
        return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
    }

    /**
     * HTTP 세션을 반환한다.
     *
     * @return HTTP 세션
     */
    protected HttpSession getSession() {
        return getSession(getRequest(), true);
    }

    /**
     * HTTP 세션을 반환한다.
     *
     * @param request HTTP 요청
     * @return HTTP 세션
     */
    protected HttpSession getSession(HttpServletRequest request) {
        return getSession(request, true);
    }

    /**
     * HTTP 세션을 반환한다.
     *
     * @param create 생성여부
     * @return HTTP 세션
     */
    protected HttpSession getSession(boolean create) {
        return getSession(getRequest(), create);
    }

    /**
     * HTTP 세션을 반환한다.
     *
     * @param request HTTP 요청
     * @param create 생성여부
     * @return HTTP 세션
     */
    protected HttpSession getSession(HttpServletRequest request, boolean create) {
        return request.getSession(create);
    }

    /**
     * 사용자를 반환한다.
     *
     * @return 사용자
     */
    protected User getUser() {
        return (User) getSessionComponent().getUser();
    }

    /**
     * 파마메터를 반환한다.
     *
     * @return 파라메터
     */
    protected ParamsMap getParams() {
        return getParams(getRequest(), true);
    }

    /**
     * 파라메터를 반환한다.
     *
     * @param request HTTP 요청
     * @return 파라메터
     */
    protected ParamsMap getParams(HttpServletRequest request) {
        return getParams(request, true);
    }

    /**
     * 파라메터를 반환한다.
     *
     * @param session 세션정보
     * @return 파라메터
     */
    protected ParamsMap getParams(boolean session) {
        return getParams(getRequest(), session);
    }

    /**
     * 파라메터를 반환한다.
     *
     * @param request HTTP 요청
     * @param session 세션정보
     * @return 파라메터
     */
    protected ParamsMap getParams(HttpServletRequest request, boolean session) {
        ParamsMap params = new ParamsMap();

        // 텍스트 파라메터를 추가한다.
        addTextParameter(params, request);

        if (params.containsKey(ParamsMap.MODELS)) {
        	params.put(ParamsMap.MODEL_LIST, BaseUtils.getJsonList(params, ParamsMap.MODELS));
        }

        if (request instanceof MultipartHttpServletRequest) {
            // 파일 파라메터를 추가한다.
            addFileParameter(params, (MultipartHttpServletRequest) request);
        }

        if (session) {
            // 사용자 파라메터를 추가한다.
            addUserParameter(params);
        }

        // 속성 파라메터를 추가한다.
        //addAttrParameter(params, request);

        debug("Request parameters: " + params);

        return params;
    }

    /**
     * 모델에 객체를 추가한다.
     *
     * @param model 모델
     * @param object 객체
     */
    protected void addObject(Model model, Object object) {

    	debug("Processing results: " + object);

        if (object instanceof ResultMap) {
            addResult(model, (ResultMap) object);
        }
        else {
            addData(model, object);
        }
    }

    /**
     * 텍스트 파라메터를 추가한다.
     *
     * @param params 파라메터
     * @param request HTTP 요청
     */
    private void addTextParameter(ParamsMap params, HttpServletRequest request) {
        Enumeration<?> enumeration = request.getParameterNames();

        while (enumeration.hasMoreElements()) {
            String name = (String) enumeration.nextElement();

            params.add(getParameterName(name), getTextParameter(request, name));
        }
    }

    /**
     * 파일 파라메터를 추가한다.
     *
     * @param params 파라메터
     * @param request HTTP 요청
     */
    private void addFileParameter(ParamsMap params, MultipartHttpServletRequest request) {
        Iterator<String> iterator = request.getFileNames();

        while (iterator.hasNext()) {
            String name = iterator.next();

            params.add(getParameterName(name), getFileParameter(request, name));
        }
    }

    /**
     * 사용자 파라메터를 추가한다.
     *
     * @param params 파라메터
     */
    private void addUserParameter(ParamsMap params) {

        User user = getUser();

        if (user == null)
        	return;

        params.put(ParamsMap.GS_SYS_ID,    user.getSysId());
        params.put(ParamsMap.GS_USER_ID,   user.getUserId());
        params.put(ParamsMap.GS_MENU_SET,   user.getMenuSet());
        params.put(ParamsMap.GS_MENU_TYPE,   user.getMenuType());
        params.put(ParamsMap.GS_MOBILE_TYPE,   user.getMobileType());
        params.put(ParamsMap.GS_USER_NAME, user.getUserName());
        params.put(ParamsMap.GS_GROUPS,    user.getGroups());
        params.put(ParamsMap.GS_ADMIN,     user.isAdmin());
        params.put(ParamsMap.GS_USER_TYPE,     user.getUserType());
        params.put(ParamsMap.GS_ORG_AUTH_CODE,     user.getOrgAuthCode());
        params.put(ParamsMap.GS_SPC_AUTH_CODE,     user.getSpcAuthCode());
        params.put(ParamsMap.GS_DASH_TYPE,     user.getDashType());
        try {
        	params.put(ParamsMap.GS_LANG,      getSessionComponent().getLocale().toString());
		} catch (NullPointerException e) {
			params.put(ParamsMap.GS_LANG,      "ko");
		}


        if (!params.containsKey(ParamsMap.SYS_ID))
        	params.put(ParamsMap.SYS_ID, params.get(ParamsMap.GS_SYS_ID));
        if (BaseUtils.empty(params.get(ParamsMap.SYS_ID)))
        	params.put(ParamsMap.SYS_ID, params.get(ParamsMap.GS_SYS_ID));

        Group[] groups = user.getGroups();

        if (groups == null)
        	return;

        for (Group group : groups) {
        	params.put("is_" + group.getGroupId().toLowerCase(), true);
        }
    }

    /**
     * 파라메터 이름을 반환한다.
     *
     * @param name 파라메터 이름
     * @return 파라메터 이름
     */
    private String getParameterName(String name) {
        if (name.endsWith("[]")) {
            return name.substring(0, name.lastIndexOf("[]"));
        }

        return name;
    }

    /**
     * 텍스트 파라메터를 반환한다.
     *
     * @param request HTTP 요청
     * @param name 파라메터 이름
     * @return 텍스트 파라메터
     */
    private String[] getTextParameter(HttpServletRequest request, String name) {
        return request.getParameterValues(name);
    }

    /**
     * 파일 파라메터를 반환한다.
     *
     * @param request HTTP 요청
     * @param name 파라메터 이름
     * @return 파일 파라메터
     */
    private MultipartFile[] getFileParameter(MultipartHttpServletRequest request, String name) {
        Object[] source = request.getFiles(name).toArray();

        MultipartFile[] destination = new MultipartFile[source.length];

        System.arraycopy(source, 0, destination, 0, destination.length);

        return destination;
    }

    /**
     * 모델에 데이터를 추가한다.
     *
     * @param model 모델
     * @param data 데이터
     */
    private void addData(Model model, Object data) {
        if (data instanceof PagingMap) {
            PagingMap paging = (PagingMap) data;

            model.addAttribute(PagingMap.PAGE,  paging.getPage());
            model.addAttribute(PagingMap.COUNT, paging.getCount());
            model.addAttribute(PagingMap.TOTAL, paging.getTotal());
            model.addAttribute(PagingMap.PAGES, paging.getPages());
            model.addAttribute(BaseConstants.DATA,  paging.getData());
        }
        else if (data instanceof List) {
            model.addAttribute(BaseConstants.DATA,  data);
        }
        else {
            model.addAttribute(BaseConstants.DATA,  data);
        }
    }

    /**
     * 모델에 결과를 추가한다.
     *
     * @param model 모델
     * @param result 결과
     */
    private void addResult(Model model, ResultMap result) {
        if (result.getSuccess()) {
            model.addAttribute(BaseConstants.SUCCESS, result.getMessage());

            ResultMap r = new ResultMap();

            r.put(ResultMap.CODE,    0);
            r.put(ResultMap.MESSAGE, result.getMessage());

            model.addAttribute(BaseConstants.RESULT,  r);
        }
        else {
            model.addAttribute(BaseConstants.ERROR,   result.getMessage());

            ResultMap r = new ResultMap();

            r.put(ResultMap.CODE,    -1);
            r.put(ResultMap.MESSAGE, result.getMessage());

            model.addAttribute(BaseConstants.RESULT,  r);
        }
    }


    /**
     * 디폴트 생성자이다.
     */
    protected BaseController() {
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

    @Autowired
    protected MessageSource messageSource;

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
        return messageSource.getMessage(code, arguments, defaultMessage, getSessionComponent().getLocale());
    }

    /**
     * 브라우저를 반환한다.
     *
     * @return 브라우저
     */
    protected String getBrowser() {
        return getBrowser(getRequest());
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
     * IP를 반환한다.
     *
     * @return IP
     */
    protected String getIp() {
        return getIp(getRequest());
    }

    /**
     * IP를 반환한다.
     *
     * @param request HTTP 요청
     * @return IP
     */
    protected String getIp(HttpServletRequest request) {
        return (String) request.getAttribute(BaseConstants.IP);
    }

    /**
     * 컨텍스트를 반환한다.
     *
     * @return 컨텍스트
     */
    protected String getContext() {
        return getContext(getRequest());
    }

    /**
     * 컨텍스트를 반환한다.
     *
     * @param request HTTP 요청
     * @return 컨텍스트
     */
    protected String getContext(HttpServletRequest request) {
        return (String) request.getAttribute(BaseConstants.CONTEXT);
    }

    /**
     * URI를 반환한다.
     *
     * @return URI
     */
    protected String getUri() {
        return getUri(getRequest());
    }

    /**
     * URI를 반환한다.
     *
     * @param request HTTP 요청
     * @return URI
     */
    protected String getUri(HttpServletRequest request) {
        return (String) request.getAttribute(BaseConstants.URI);
    }

    //[WSC2.0] [2015.04 LSH] IE9에서 첨부파일 업로드버그 해결을 위한 반환함수
    protected ResponseEntity<String> getResponseEntiry(Object value) throws JsonGenerationException, JsonMappingException, IOException {
		ObjectMapper mapper = new ObjectMapper();
		HttpHeaders headers = new HttpHeaders();
		//headers.setContentType(MediaType.TEXT_HTML);
		headers.add("Content-Type", "text/html; charset=UTF-8");

	    return new ResponseEntity<String>(mapper.writeValueAsString(value), headers, HttpStatus.CREATED);
    }

    //공통파라메터 정의
    protected ParamsMap initParams(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
        Group[] group = (Group[])params.get("gsGroups");
        String groupIdC = group[0].getGroupId();
		if (params.containsKey(BaseConstants.MENU_KEY)) {
			model.addAttribute(BaseConstants.MENU_NAME, params.get(BaseConstants.MENU_NAME));
			model.addAttribute(BaseConstants.MENU_KEY , params.get(BaseConstants.MENU_KEY));
			model.addAttribute(BaseConstants.MENU_URL , params.get(BaseConstants.MENU_URL));
			model.addAttribute(BaseConstants.PARENT_DESC , params.get(BaseConstants.PARENT_DESC));
			model.addAttribute("groupIdC" , groupIdC);
			params.put("windowId",  params.get(BaseConstants.MENU_KEY));
		}
		else {
			//세션에서 메뉴정보를 가져오도록 처리
			model.addAttribute(BaseConstants.MENU_NAME, getSessionComponent().getMenuDesc());
			model.addAttribute(BaseConstants.MENU_KEY , getSessionComponent().getMenuKey());
			model.addAttribute(BaseConstants.MENU_URL , getSessionComponent().getMenuUrl());
			model.addAttribute(BaseConstants.PARENT_DESC , getSessionComponent().getParentDesc());
			model.addAttribute("groupIdC" , groupIdC);
			params.put("windowId", getSessionComponent().getMenuKey());

		}
		model.addAttribute("user", getSessionComponent().getUser());
		
		//BLOCK USER 메세지표시
		params.put("eventId", "OPEN");
		params.put("initMsg", "");
		params.put("targetUserId", params.get("gsUserId"));
		
		
    	RecordMap result = (RecordMap)programService.select("getWindowMsg", params);
    	if("Y".equals((String)result.get("Dsp_Yn"))) {
    		model.addAttribute(BaseConstants.MENU_MSG, (String)result.get("Dsp_Msg"));
    		model.addAttribute(BaseConstants.MSG_FONT_COLOR, (String)result.get("Font_Color"));
    		model.addAttribute(BaseConstants.MSG_BACK_COLOR, (String)result.get("Back_Color"));
    	} else {
    		model.addAttribute(BaseConstants.MENU_MSG, "");
    	}
    	
    	RecordMap paypalResult = (RecordMap)programService.select("getPaypalYn", params);
    	model.addAttribute("paypalYn",   (String)paypalResult.get("paypalYn"));
    	model.addAttribute("paypalMeYn", (String)paypalResult.get("paypalMeYn"));
    	
    	model.addAttribute("iconCls" , getSessionComponent().getMenu().getIconCls()); //메뉴 아이콘
    	
    	RecordMap promoNameResult = (RecordMap)programService.select("getPromoName", params);
    	model.addAttribute("exhbnName",   (String)promoNameResult.get("exhbnName"));
    	model.addAttribute("exhbnBgnDate", (String) promoNameResult.get("exhbnBgnDate"));
    	model.addAttribute("exhbnEndDate", (String) promoNameResult.get("exhbnEndDate"));
    	model.addAttribute("todayDate",    (String) promoNameResult.get("todayDate"));
		
		return params;
    }

    protected ParamsMap initParams(Model model) {
    	return initParams(getRequest(), model);
    }

    // 엑셀 다운로드
    protected String excelDownload(HttpServletRequest request, HttpServletResponse response, Model model) throws IOException, SQLException {
    	ParamsMap params = getParams(request);

    	Date d = new Date();
    	SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyy");
    	String nowDate = sdf.format(d);

    	String fileNM = getName();

    	if ("Return".equals(fileNM) && "TO".equals(params.get("roType"))) {
    		fileNM = "Transfer";
    	}

    	// myViewId가 ORG가 아닌 경우, 앞에 추가
    	if(params.containsKey("myViewId") && !"ORG".equals(params.get("myViewId").toString())) {
    	    List<HashMap<String, String>> myViewName = getService().getMyViewName(params);
    	    if(myViewName != null && !myViewName.isEmpty()) {
    	        String myViewPrefix = myViewName.get(0).get("myViewName");  // 컬럼명 확인 필요
    	        if(myViewPrefix != null && !"".equals(myViewPrefix.trim())) {
    	            // ⬇ 금지 문자 제거: \ / : * ? " < > |
    	            myViewPrefix = myViewPrefix.replaceAll("[\\\\/:*?\"<>|]", "_");
    	            fileNM = myViewPrefix + "_" + fileNM;
    	        }
    	    }
    	}

    	// 엑셀 선택 옵션 처리
    	if (params.containsKey("excelSelect") && "N".equals(params.get("excelSelect"))) {
    		fileNM = fileNM + "All";
    	}

    	params.put("fileNM", fileNM);

    	if (params.containsKey("h_poList") && !"".equals(params.get("h_poList").toString())) {
    		String[] poList = params.get("h_poList").toString().split(",");
    		params.put("poList", poList);
    	}

    	if (params.containsKey("h_sapList") && !"".equals(params.get("h_sapList").toString())) {
    		String[] sapList = params.get("h_sapList").toString().split(",");
    		params.put("sapList", sapList);
    	}

    	if (params.containsKey("h_seriList") && !"".equals(params.get("h_seriList").toString())) {
    		String[] seriList = params.get("h_seriList").toString().split(",");
    		params.put("seriList", seriList);
    	}

    	// ⬇ 한글 파일명 처리
    	String finalFileName = fileNM + "_" + nowDate + ".xlsx";
    	String encodedFileName = URLEncoder.encode(finalFileName, "UTF-8").replaceAll("\\+", "%20");
    	response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFileName);

    	// 엑셀 파일 생성
    	setRecordSetXLSX(response, params, finalFileName);

    	return "jsonView";
    }
    
    // 엑셀 다운로드
    protected String excelDownloadPost(String data, HttpServletResponse response, Model model) throws IOException, SQLException {
    	
        ParamsMap params = new ParamsMap();
        JSONParser jsonParser = new JSONParser();

		try {
			JSONObject jsonObject = (JSONObject) jsonParser.parse(data);
			Map<String, Object> paramList = new ObjectMapper().readValue(jsonObject.toJSONString(), Map.class);
			
			params.put("sysId", "IMMES");
			for(String MapKey : paramList.keySet() ) {
				params.put(MapKey, paramList.get(MapKey));
				System.out.println("★★★★★★★"+MapKey+"★★★★★★"+paramList.get(MapKey));
			}
			
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}catch (JsonParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			/*result = "error";*/
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			/*result = "error";*/
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			/*result = "error";*/
		}
	
		if(params.containsKey("h_poList") && !"".equals(params.get("h_poList").toString())){
			String[] poList = params.get("h_poList").toString().split(",");
			params.put("poList", poList);
		}
		
		if(params.containsKey("h_sapList") && !"".equals(params.get("h_sapList").toString())){
			String[] sapList = params.get("h_sapList").toString().split(",");
			params.put("sapList", sapList);
		}
		
		if(params.containsKey("h_seriList") && !"".equals(params.get("h_seriList").toString())){
			String[] seriList = params.get("h_seriList").toString().split(",");
			params.put("seriList", seriList);
		}
		
        // 뷰이름을 반환한다.
        return excelDownload2(params, response, model);
    	
    }
    
    // 엑셀 다운로드
    protected String excelDownload2(ParamsMap params, HttpServletResponse response, Model model) throws IOException, SQLException {
        
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyy");
        String nowDate = sdf.format(d);
        
        String fileNM = getName();
        
        // myViewId가 ORG가 아닌 경우, 앞에 추가
        if(params.containsKey("myViewId") && !"ORG".equals(params.get("myViewId").toString())) {
            List<HashMap<String, String>> myViewName = getService().getMyViewName(params);
            if(myViewName != null && !myViewName.isEmpty()) {
                String myViewPrefix = myViewName.get(0).get("myViewName");  // 컬럼명 확인 필요
                if(myViewPrefix != null && !"".equals(myViewPrefix.trim())) {
                    // ⬇ 금지 문자 제거: \ / : * ? " < > |
                    myViewPrefix = myViewPrefix.replaceAll("[\\\\/:*?\"<>|]", "_");
                    fileNM = myViewPrefix + "_" + fileNM;
                }
            }
        }

        // 엑셀 선택 옵션 처리
        if(params.containsKey("excelSelect") && "N".equals(params.get("excelSelect"))) {
            fileNM = fileNM + "All";
        }

        params.put("fileNM", fileNM);

    	// ⬇ 한글 파일명 처리
    	String finalFileName = fileNM + "_" + nowDate + ".xlsx";
    	String encodedFileName = URLEncoder.encode(finalFileName, "UTF-8").replaceAll("\\+", "%20");
    	response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFileName);

    	// 엑셀 파일 생성
    	setRecordSetXLSX(response, params, finalFileName);

        return "jsonView";
    }
    
	@SuppressWarnings("deprecation")
	private int setRecordSetXLSX(HttpServletResponse response, ParamsMap params, String fileName) throws IOException, SQLException {
	    
		//header정보
		List<HashMap<String, String>> header = getService().searchHd(params);
		
		if(header.size() == 0){
			throw new SystemException("no download column information !");
		}
		
		//lavel, value정보
		ArrayList<String> label = new ArrayList<String>();
		ArrayList<String> key = new ArrayList<String>();
		ArrayList<String> colStyle = new ArrayList<String>();
		for (HashMap<String, String> target : header) {
			label.add(target.get("COL_LVL"));
			key.add(target.get("COL_VAL"));
			colStyle.add(target.get("STYLE"));
		}
		
		//date정보
		List<HashMap<String, String>> result = getService().search(params);
		
	    int rowCount = 0;
	    
		Cookie setCookie = new Cookie("fileDownload", "true");
		setCookie.setPath("/");
        setCookie.setMaxAge(60*60*24); // 기간을 하루로 지정
        response.addCookie(setCookie);
        
    	response.setContentType("application/octet-stream;");
	    response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes(), "ISO-8859-1") + "\"");
	    response.setHeader("Pragma", "no-cache;");
	    response.setHeader("Expires", "-1;");
	    
	    SXSSFWorkbook workbook = new SXSSFWorkbook();
	    SXSSFSheet sheet = workbook.createSheet();		
	    OutputStream os = response.getOutputStream();
	    int c = 0;
	    
	    //제일위에 헤더
	    Row row = sheet.createRow(rowCount);
	    Cell headerCell = row.createCell(c);
	    CellStyle style_header = workbook.createCellStyle();
//	    style_header.setVerticalAlignment(VerticalAlignment.CENTER);
//	    style_header.setAlignment(HorizontalAlignment.CENTER);
//	    style_header.setBorderBottom(BorderStyle.THIN);
//	    style_header.setBorderTop(BorderStyle.THIN);
//	    style_header.setBorderRight(BorderStyle.THIN);
//	    style_header.setBorderLeft(BorderStyle.THIN);
//	    style_header.setFillForegroundColor(IndexedColors.DARK_TEAL.getIndex());  // 배경색
//	    style_header.setFillPattern(FillPatternType.SOLID_FOREGROUND);
	    
	    //폰트 설정
//	    Font hdF = workbook.createFont();
//	    hdF.setFontName("맑은 고딕"); //글씨체
//	    hdF.setColor(HSSFColor.HSSFColorPredefined.WHITE.getIndex());
//	    hdF.setFontHeight((short)(14*20)); //사이즈
//	    hdF.setBold(true); //볼드 (굵게)
//	    style_header.setFont(hdF);
//	    row.setHeight((short) 720);
//
//	    headerCell.setCellType(CellType.STRING);
//	    headerCell.setCellValue(getName());
//	    headerCell.setCellStyle(style_header);
//	    sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, label.size()-1));
//	    rowCount++;

	    //컬럼라벨
	    CellStyle style_title = workbook.createCellStyle();
		style_title.setVerticalAlignment(VerticalAlignment.CENTER);
		style_title.setAlignment(HorizontalAlignment.CENTER);
		style_title.setBorderBottom(BorderStyle.THIN);
		style_title.setBorderTop(BorderStyle.THIN);
		style_title.setBorderRight(BorderStyle.THIN);
		style_title.setBorderLeft(BorderStyle.THIN);
		style_title.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex());  // 배경색
		style_title.setFillPattern(FillPatternType.SOLID_FOREGROUND);
	    
	    //폰트 설정
	    Font labF = workbook.createFont();
	    labF.setFontName("맑은 고딕"); //글씨체
	    labF.setFontHeight((short)(10*20)); //사이즈
	    labF.setBold(true); //볼드 (굵게)
	    style_title.setFont(labF);
	    
		row = sheet.createRow(rowCount);
		row.setHeight((short) 600);
		for(String t : label){
			Cell cell = row.createCell(c);
			cell.setCellType(CellType.STRING);
			cell.setCellValue(t);
			cell.setCellStyle(style_title);
			c++;
		}
		rowCount++;
		
		CellStyle style = workbook.createCellStyle();
		style.setBorderBottom(BorderStyle.THIN);
		style.setBorderTop(BorderStyle.THIN);
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderLeft(BorderStyle.THIN);
		style.setAlignment(HorizontalAlignment.CENTER);
		
		CellStyle styleL = workbook.createCellStyle();
		styleL.setBorderBottom(BorderStyle.THIN);
		styleL.setBorderTop(BorderStyle.THIN);
		styleL.setBorderRight(BorderStyle.THIN);
		styleL.setBorderLeft(BorderStyle.THIN);
		styleL.setAlignment(HorizontalAlignment.LEFT);
		
		// 숫자에 사용 xxxx,xx0
		CellStyle styleR = workbook.createCellStyle();
		styleR.setBorderBottom(BorderStyle.THIN);
		styleR.setBorderTop(BorderStyle.THIN);
		styleR.setBorderRight(BorderStyle.THIN);
		styleR.setBorderLeft(BorderStyle.THIN);
		styleR.setAlignment(HorizontalAlignment.RIGHT);
		styleR.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0.00"));
		
		
		sheet.trackAllColumnsForAutoSizing();
		for (int idx = 0; idx < result.size(); idx++) {
	        row = sheet.createRow(rowCount);
			int c2 = 0;
			for(int i = 0; i< key.size() ;i++){
				Cell cell = row.createCell(c2);
				Object value = result.get(idx).get(key.get(i));
				if (value == null) {
					cell.setCellType(CellType.STRING);
					cell.setCellValue("");
				}
				else if ((value instanceof Number)) {
					cell.setCellType(CellType.NUMERIC);
					cell.setCellValue(Double.valueOf(value.toString()).doubleValue());
				} else {
					cell.setCellType(CellType.STRING);
					cell.setCellValue(getHtmlStrCnvr(value.toString()));
				}
				if("LEFT".equals(colStyle.get(i))){
					cell.setCellStyle(styleL);
				} else if("RIGHT".equals(colStyle.get(i))){
					cell.setCellStyle(styleR);
				} else {
					cell.setCellStyle(style);
				}
				c2++;
			}
	        rowCount++;
	    }
		
		
	    for (int i=0;i < label.size();i++)
		{ 
	    	sheet.autoSizeColumn(i);
		}
	    workbook.write(os);
	    return rowCount;
	}
	
	private static String getHtmlStrCnvr(String srcString) {

		String tmpString = srcString;

		tmpString = tmpString.replaceAll("&lt;", "<");
		tmpString = tmpString.replaceAll("&gt;", ">");
		tmpString = tmpString.replaceAll("&amp;", "&");
		tmpString = tmpString.replaceAll("&nbsp;", " ");
		tmpString = tmpString.replaceAll("&apos;", "\'");
		tmpString = tmpString.replaceAll("&quot;", "\"");
		tmpString = tmpString.replaceAll("&#37;", "%");
		tmpString = tmpString.replaceAll("&#59;", ";");
		tmpString = tmpString.replaceAll("&#40;", "(");
		tmpString = tmpString.replaceAll("&#41;", ")");
		tmpString = tmpString.replaceAll("&#43;", "+");

		return tmpString;

	}
	
}