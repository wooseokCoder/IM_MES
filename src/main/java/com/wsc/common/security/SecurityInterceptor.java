/*
 * @(#)SecurityInterceptor.java 1.0 2014/07/25
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.common.security;

import java.io.IOException;
import java.io.PrintWriter;

import javax.inject.Provider;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;

import com.wsc.common.model.Menu;
import com.wsc.common.model.Program;
import com.wsc.common.model.User;
import com.wsc.common.user.MenuService;
import com.wsc.common.user.ProgramService;
import com.wsc.common.user.UserLogService;
import com.wsc.common.user.UserSecureService;
import com.wsc.common.user.UserService;
import com.wsc.framework.base.BaseConstants;
import com.wsc.framework.base.BaseInterceptor;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

/**
 * 보안을 처리하는 인터셉터 클래스이다.
 *
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class SecurityInterceptor extends BaseInterceptor {

    @Autowired
    private UserService userService;
    @Autowired
    private MenuService menuService;
    @Autowired
    private ProgramService programService;
    @Autowired
    private UserLogService userLogService;
    @Autowired
    private UserSecureService userSecureService;
    @Autowired
	private Provider<SessionComponent> sessionObject;

	@Autowired
	private MessageSource messageSource;

	@Override
	protected MessageSource getMessageSource() {
		return this.messageSource;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionObject.get();
	}


    @Value("#{app['loggable.userLog']}")
    private boolean LOGGABLE_USERLOG;

    @Value("#{app['usable.tabPanel']}")
    private boolean USABLE_TABPANEL;

    @Value("#{app['default.system.id']}")
    private String DEF_SYSTEMID;

    @Value("#{app['default.page.size']}")
    private int DEF_PAGESIZE;

    @Value("#{app['security.form.system']}")
    private String SYSTEM;
    @Value("#{app['security.form.username']}")
    private String USERNAME;
    @Value("#{app['security.form.password']}")
    private String PASSWORD;
    @Value("#{app['security.form.targeturl']}")
    private String TARGET;
    @Value("#{app['security.form.remember']}")
    private String REMEMBER;
    @Value("#{app['security.form.language']}")
    private String LANGUAGE;
    @Value("#{app['security.form.secure']}")
    private String SECURE;

    @Value("#{app['security.page.submit']}")
    private String SUBMIT;
    @Value("#{app['security.page.login']}")
    private String LOGIN;
    @Value("#{app['security.page.logout']}")
    private String LOGOUT;
    @Value("#{app['security.page.default']}")
    private String INDEX;
    @Value("#{app['security.page.error']}")
    private String ERROR;
    @Value("#{app['security.guest.id']}")
    private String GUEST;
    @Value("#{app['security.page.smsreturn']}")
    private String SMSRETURN;
    @Value("#{app['security.page.loginhelp']}")
    private String LOGINHELP;
    @Value("#{app['security.page.loginTableau']}")
    private String LOGINHTABLEAU;

    @Value("#{app['report.addr']}")
    private String REPORT_URL;

    //비인증페이지의 경우 관리화면목록에 존재하면 반드시 인증체크가 되어야함.
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws IOException {

		//동일한 URL인 경우 RESET
    	sessionObject.get().refresh(request);

        setRequestAttribute(request);

    	String ctx  = request.getContextPath();
    	String uri  = request.getRequestURI();
    	String path = request.getPathInfo();
    	String url  = uri.substring(ctx.length());

    	//"/"로 들어온 URL인 경우 INDEX와 동일하게 처리
    	if ("/".equals(url))
    		url = INDEX;

		if ("/".equals(url) && path != null)
			url = path;
		
		if (url.endsWith(LOGIN)) {
			return true;
		}
		else if (url.endsWith(SUBMIT)) {
			if (processLogin(request, response)) {

				//로그인 후엔 반드시 INDEX로 가도록 처리함.
				String sendUrl = ctx + INDEX;
				
				//NDM으로 접속해서 로그인 했을 때 
				Object ndmIdx = request.getParameter("ndmIdx");
				// null 체크 및 빈 문자열 체크
				String ndmYn = (ndmIdx == null || ndmIdx.toString().trim().isEmpty())
				        ? "N"
				        : ndmIdx.toString();
				
				if (ndmYn.equals("Y")) {
					sendUrl = ctx + "/ndm";
				}
				//System.out.println("send URL : " + sendUrl);

				/* 로그인 후 해당 페이지로 이동시 사용할 항목
				String savedUrl = sessionObject.get().getSavedUrl();
				String sendUrl  = savedUrl;

				if (sendUrl == null) {
					sendUrl = ctx + INDEX;
				}
				*/
				String lang = request.getParameter(LANGUAGE);
				if (lang != null) {
					sendUrl += (sendUrl.indexOf("?") > 0 ? "&" : "?")
							+ "lang="+lang;
				}
				
		        //TODO 김원국
		        HttpSession sessionS = request.getSession();
		        sessionS.setAttribute("rows",100);

		        response.sendRedirect(response.encodeRedirectURL(sendUrl));
				return false;
			}
		}
		else if (url.endsWith(LOGOUT)) {
			sessionObject.get().remove();
			sessionObject.get().saveUrl(request);
			response.sendRedirect(response.encodeRedirectURL(ctx + LOGIN));
			return false;
		}

		Program security = null;
		Program program  = null;
		Menu menu  = null;

		ParamsMap params = new ParamsMap();
		params.put("sysId",  DEF_SYSTEMID);
		params.put("progId", url);
		params.put("uri",    url);

		program = (Program)programService.select(params);

		//비인증사용자의 경우 관리화면인지 확인
		if (sessionObject.get().isLoggedIn() == false) {

			if (program == null)
				return true;

			params.put("userId", GUEST);
		}
		else {
			User user = sessionObject.get().getUser();
			//사용자 Attribute 정의
			setUserAttribute(request, user);
			params.put("sysId",  user.getSysId());
			params.put("menuSet", user.getMenuSet());
			params.put("userId", user.getUserId());
			params.put("groups", user.getGroups());
	        try {
	        	request.setAttribute(ParamsMap.GS_LANG,      getSessionComponent().getLocale().toString());
	        	params.put(ParamsMap.GS_LANG,      getSessionComponent().getLocale().toString());
			} catch (NullPointerException e) {
				request.setAttribute(ParamsMap.GS_LANG,      "ko");
				params.put(ParamsMap.GS_LANG,      "ko");
			}

		}

		//관리프로그램이 아닌 경우
		if (program == null)
			return true;

        sessionObject.get().saveProgram(program);
        //프로그램 Attribute 정의
        setProgramAttribute(request, program);

        // Accessible Program Check
		security = programService.selectSecurity(params);

		if (security != null) {
	        sessionObject.get().saveProgram(security);
	        //프로그램 Attribute 정의
	        setProgramAttribute(request, security);

	        String menuKey = security.getMenuKey();

	        if (menuKey != null) {
	        	params.put("menuKey", menuKey);
	        	menu = (Menu)menuService.select(params);

	        	sessionObject.get().saveMenu(menu);
	            //메뉴 Attribute 정의
	            setMenuAttribute(request, menu);
	        }
		}

        //사용자접근 로깅 사용시
        if (LOGGABLE_USERLOG) {
            params.put("loginDate",    sessionObject.get().formatLoginTime());
            params.put("clientIp",     request.getRemoteAddr());
            params.put("clientAgent",  request.getHeader("User-Agent"));
            params.put("clientName",   request.getRemoteUser()); //TODO 맞는지 확인해야함

            //사용자 화면접근 로그 저장
            userLogService.insert(params);
        }
        if (security == null ||
        	security.enable() == false) {
        	sessionObject.get().saveUrl(request);
        	
        	if (url.endsWith("ndm") || url.startsWith("/ndm")) {
        		response.sendRedirect(response.encodeRedirectURL(ctx + "/ndm/ndmlogin"));
    			return false;
    		}
        	
        	if (sessionObject.get().isLoggedIn() == false) {
    			response.sendRedirect(response.encodeRedirectURL(ctx + LOGIN));
    			return false;
        	}

        	//비정상적인 접근 사용자
			String errMsg = getMessage("error.authority.program.notaccess");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('" + errMsg + "');</script>");
			out.flush();

			return false;
        	//throw new AuthorityException( getMessage("error.authority.program.notaccess") );
		}
    	return true;
    }

    private void setUserAttribute(HttpServletRequest request, User user) {
    	if (user == null)
    		return;
        //시스템ID
        request.setAttribute(BaseConstants.SYS_ID, user.getSysId());
        //사용자ID
        request.setAttribute(BaseConstants.USER_ID, user.getUserId());
        //사용자명
        request.setAttribute(BaseConstants.USER_NAME, user.getUserName());
        //부서코드
        request.setAttribute(BaseConstants.DEPT_CODE, user.getDeptCode());
        //상위부서코드
        request.setAttribute(BaseConstants.UPPR_DEPT_CODE, user.getUpprDeptCode());
        //관리자 여부
        request.setAttribute(BaseConstants.ADMIN, user.isAdmin() ? "Y" : "N");
        //페이징 출력수
        request.setAttribute(BaseConstants.PAGE_SIZE, DEF_PAGESIZE);
        //레포트 URL
        request.setAttribute(BaseConstants.REPORT_URL, REPORT_URL);
    }

    private void setProgramAttribute(HttpServletRequest request, Program prog) {
    	if (prog == null)
    		return;
        //프로그램ID
        request.setAttribute(BaseConstants.PROG_ID, prog.getProgId());
        //프로그램명
        request.setAttribute(BaseConstants.PROG_NAME, prog.getProgName());
        //메뉴KEY
        //request.setAttribute(BaseConstants.MENU_KEY, prog.getMenuKey());
    }

    private void setMenuAttribute(HttpServletRequest request, Menu menu) {
    	if (menu == null)
    		return;
        //메뉴KEY
        request.setAttribute(BaseConstants.MENU_KEY, menu.getMenuKey());
        //메뉴명
        request.setAttribute(BaseConstants.MENU_NAME, menu.getMenuDesc());
        //메뉴URL
        request.setAttribute(BaseConstants.MENU_URL, menu.getMenuUrl());
        //메뉴URL
        request.setAttribute(BaseConstants.PARENT_DESC, menu.getParentDesc());
    }

    private void setRequestAttribute(HttpServletRequest request) {

        String agent     = request.getHeader("User-Agent");
        String ip        = request.getRemoteAddr();
        String context   = request.getContextPath();
        String uri       = request.getRequestURI();
        String browser   = "Unknown";

        // 에이전트 헤더가 있는 경우
        if (agent != null) {
            // 순서를 바꾸지 마시오.
            // Opera
            if (agent.contains("Opera")) {
                browser = "Opera";
            }
            // Chrome
            else if (agent.contains("Chrome")) {
                browser = "Chrome";
            }
            // MSIE
            else if (agent.contains("MSIE")) {
                browser = "MSIE";
            }
            // Firefox
            else if (agent.contains("Firefox")) {
                browser = "Firefox";
            }
            // Safari
            else if (agent.contains("Safari")) {
                browser = "Safari";
            }
        }

        // IP가 로컬 호스트인 경우
        if (BaseConstants.LOCALHOST.containsKey(ip)) {
            ip = (String) BaseConstants.LOCALHOST.get(ip);
        }
        // 컨텍스트 경로가 루트가 아닌 경우
        if (!"".equals(context)) {
            uri = uri.substring(context.length());
        }
        request.setAttribute(BaseConstants.BROWSER,   browser);
        request.setAttribute(BaseConstants.CONTEXT,   context);
        request.setAttribute(BaseConstants.IP,        ip);
        request.setAttribute(BaseConstants.URI,       uri);
        //탭패널 사용여부
        request.setAttribute(BaseConstants.TABPANEL,  USABLE_TABPANEL ? "Y" : "N");
    }

    //로그인 처리
	private boolean processLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {

		ParamsMap params = new ParamsMap();
		params.put("sysId",     request.getParameter(SYSTEM));
		params.put("userId",    request.getParameter(USERNAME));
		params.put("userPwd",   request.getParameter(PASSWORD));
		params.put("secureKey", request.getParameter(SECURE));

        User user = (User)userService.select(params);

        //해당 아이디가 존재하지 않음.
        if (user == null) {
        	sessionObject.get().saveUserNotexist();


        	//로그인 실패시 카운트 증가
			userService.updateFailure(params);

        	//패스워드 불일치
			String errMsg = getMessage("error.authority.username.notexist");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('" + errMsg + "');</script>");
			out.flush();


			return false;


        	// throw new AuthorityException( getMessage("error.authority.username.notexist") );
        }

		//관리자가 사용자로 자동로그인시 처리
		if (!BaseUtils.empty(params.getString("secureKey"))) {


			//보안키에 해당되는 자동로그인 정보
			Object secure = userSecureService.select(params);

			if (secure == null) {

				//비정상적인 접근 사용자
				String errMsg = getMessage("error.authority.secure.incorrect");
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.println("<script>alert('" + errMsg + "');</script>");
				out.flush();

				return false;

				//throw new AuthorityException( getMessage("error.authority.secure.incorrect") );
			}

			//자동로그인정보 업데이트
			userSecureService.update(params);

    		//사용자정보 세션 저장
            sessionObject.get().saveUser(user);

            //로그인 성공
        	return true;
		}
		else {
			String rtnValue = userService.checkPassword(params);
			
			//SSO 처리
			if("Y".equals(request.getParameter("j_token"))) {
				rtnValue = "O";
			}

			if (rtnValue != null) {

				if ("X".equals(rtnValue)) {

					//로그인 실패시 카운트 증가
					userService.updateFailure(params);

		        	//패스워드 불일치
					String errMsg = getMessage("error.authority.password.incorrect");
					response.setContentType("text/html;charset=utf-8");
					PrintWriter out = response.getWriter();
					out.println("<script>alert('" + errMsg + "');</script>");
					out.flush();


					return false;
					//BBUG.CHK
					//throw new AuthorityException( getMessage("error.authority.password.incorrect") );
				}
				if ("O".equals(rtnValue)) {

					//로그인 성공시 실패카운트 리셋 및 최종로그인일시 업데이트
					userService.updateSuccess(params);

		    		//사용자정보 세션 저장
		            sessionObject.get().saveUser(user);
		            
		          //SSO 처리
		            String rtnValue2 = "";
		            String rtnValue3 = "";
					if("Y".equals(request.getParameter("j_token"))) {
						rtnValue2 = "O";
						rtnValue3 = "U";
					}else {
						rtnValue2 = userService.check90days(params);
						rtnValue3 = userService.checkBankUser(params);
					}
					
					if("B".equals(rtnValue3)) {
						
						if("X".equals(rtnValue2)) {
			    			// ROOT메뉴
			    			String rtnRootMenu = userService.checkRootMenu(params);
			    			
			    			//Cookie
			    			if("LSTA2".equals(rtnRootMenu)) {
							Cookie setCookie = new Cookie("im_mesMenu", "TA601");
			    				setCookie.setPath("/");
				    			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
				    			response.addCookie(setCookie);
			    			} else {
							Cookie setCookie = new Cookie("im_mesMenu", "LS601");
			    				setCookie.setPath("/");
				    			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
				    			response.addCookie(setCookie);
			    			}
			    			
			    		}else {
			    			// ROOT메뉴
			    			String rtnRootMenu = userService.checkRootMenu(params);
			    			
			    			//Cookie
			    			if("LSTA2".equals(rtnRootMenu)) {
							Cookie setCookie = new Cookie("im_mesMenu", "LS841");
			    				setCookie.setPath("/");
				    			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
				    			response.addCookie(setCookie);
			    			} else {
							Cookie setCookie = new Cookie("im_mesMenu", "LS841");
			    				setCookie.setPath("/");
				    			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
				    			response.addCookie(setCookie);
			    			}
			    		}
		    			
		    		}else {
		    			if("X".equals(rtnValue2)) {
			    			// ROOT메뉴
			    			String rtnRootMenu = userService.checkRootMenu(params);
			    			
			    			//Cookie
			    			if("LSTA2".equals(rtnRootMenu)) {
							Cookie setCookie = new Cookie("im_mesMenu", "TA601");
			    				setCookie.setPath("/");
				    			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
				    			response.addCookie(setCookie);
			    			} else {
							Cookie setCookie = new Cookie("im_mesMenu", "LS601");
			    				setCookie.setPath("/");
				    			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
				    			response.addCookie(setCookie);
			    			}
			    			
			    		}
		    		}
		    		
		            //로그인 성공
		        	return true;
				}
			}
		}

		//로그인 실패
		sessionObject.get().saveLoginFailure();

		String errMsg = getMessage("error.authority.login.failure");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + errMsg + "');</script>");
		out.flush();

		return false;
		//throw new AuthorityException( getMessage("error.authority.login.failure") );
	}
}