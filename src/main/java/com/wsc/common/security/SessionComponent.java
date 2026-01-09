package com.wsc.common.security;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.wsc.common.model.Menu;
import com.wsc.common.model.Program;
import com.wsc.common.model.User;
import com.wsc.framework.utils.BaseUtils;

@Component
@Scope("session")
public class SessionComponent implements Serializable {
	
	private static final long serialVersionUID = 4186876614140555702L;
	
	private User    userInfo;
	private Program progInfo;
	private Menu    menuInfo;
	private List<Menu> menuList;
	private List<Menu> mhotList; //핫메뉴목록
	private Locale  locale;
	
	private int     loginCount = -1;
	private Date    loginTime;
	private String  loginReturn;
	private String  savedUrl;
	private String  systemId;
	//private String  menuKey;

	public User getUser() {
		return this.userInfo;
	}
	public Date getLoginTime() {
		return this.loginTime;
	}
	public String formatLoginTime() {
		return BaseUtils.formatDate("yyyy-MM-dd HH:mm:ss", this.loginTime);
	}
	public String getLoginReturn() {
		return this.loginReturn;
	}
	public Program getProgram() {
		return this.progInfo;
	}
	public Menu getMenu() {
		return this.menuInfo;
	}
	public List<Menu> getMenus() {
		return this.menuList;
	}
	public List<Menu> getHotMenus() {
		return this.mhotList;
	}
	
	public int getLoginCount() {
		return loginCount;
	}

	public String getSavedUrl() {
		return savedUrl;
	}
	public Locale getLocale() {
		return locale;
	}
	public String getSystemId() {
		return systemId;
	}
	public String getMenuKey() {
		if (menuInfo == null)
			return null;
		return menuInfo.getMenuKey();
	}
	public String getMenuDesc() {
		if (menuInfo == null)
			return null;
		return menuInfo.getMenuDesc();
	}
	public String getMenuUrl() {
		if (menuInfo == null)
			return null;
		return menuInfo.getMenuUrl();
	}
	public String getParentDesc() {
		if (menuInfo == null)
			return null;
		return menuInfo.getParentDesc();
	}
	
	
	public boolean isLoggedIn() {
		return (this.userInfo != null);
	}
	
	public void remove() {
		this.userInfo  = null;
		this.progInfo  = null;
		this.menuInfo  = null;
		this.menuList  = null;
		this.mhotList  = null;

		this.loginCount   = -1;
		this.loginTime    = null;
		this.loginReturn  = null;
		this.savedUrl     = null;
		this.systemId     = null;
	}

	public void saveUser(User user) {
		this.userInfo     = user;
		this.loginTime    = new Date();
		this.loginCount   = 0;
		this.loginReturn  = "OO";
		this.systemId     = user.getSysId();
	}
	
	public void saveUserDashType(String dashType) {
		this.userInfo.setDashType(dashType);
	}

	public void saveProgram(Program progInfo) {
		this.progInfo = progInfo;
		
		//String progId = progInfo.getProgId();
		
		//if (progId.indexOf(".do?") > 0 ||
		//	progId.endsWith(".do")) {
		//	this.menuKey = progInfo.getMenuKey();
		//}
	}
	public void saveMenu(Menu menuInfo) {
		this.menuInfo = menuInfo;
	}
	public void saveMenus(List<Menu> menuList) {
		this.menuList = menuList;
	}
	public void saveHotMenus(List<Menu> mhotList) {
		this.mhotList = mhotList;
	}
	public void removeHotMenus() {
		this.mhotList = null;
	}
	
	//전체 URL 가져오기
	private String _getUrl(HttpServletRequest request) {
        String url = request.getRequestURL().toString();
        if (request.getQueryString() != null)
        	url += "?" + request.getQueryString();
        return url;
	}
	
	//LOCALE 세션에서 읽어오기
	private Locale _getLocale(HttpServletRequest request) {
		return (Locale)request.getSession().getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);
	}
	
	public void refresh(HttpServletRequest request) {
		//LOCALE 읽어오기
		this.locale = _getLocale(request);
		
		//현재 URL과 저장된 URL이 같은 경우 SKIP
		if (this.savedUrl != null &&
			this.savedUrl.equals(_getUrl(request))) {
			this.savedUrl = null;
		}
	}
	
	//현재 URL SESSION 저장
	public void saveUrl(HttpServletRequest request) {
        this.savedUrl = _getUrl(request);
	}
	
	//비밀번호 오류시 카운트 증가
	public void savePasswordFailure() {
		this.loginCount++;
		this.loginReturn = "E3";
	}
	
	//해당 아이디가 존재하지 않음
	public void saveUserNotexist() {
		this.loginReturn = "E1";
	}
	
	//사용자 로그인 실패
	public void saveLoginFailure() {
		this.loginReturn = "E4";
	}
	
}
