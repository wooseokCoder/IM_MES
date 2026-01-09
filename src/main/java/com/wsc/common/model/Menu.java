package com.wsc.common.model;

import java.util.List;

import com.wsc.framework.base.BaseModel;

public class Menu extends BaseModel {
	
	private static final long serialVersionUID = 5664906657361014366L;
	
	private String menuKey;     // 메뉴ID
	private String menuDesc;    // 메뉴명
	private String menuDescKr;  // 메뉴명(국문)
	private String menuDescEn;  // 메뉴명(영문)
	private String menuDir;     // 메뉴DIR
	private String menuUrl;     // 메뉴URL
	private String parentKey;   // 상위메뉴ID
	private String parentDesc;  // 상위메뉴명 20160921 김원국
	private String procType;    // 화면구현여부
	private String iconCls;     // 아이콘클래스
	private String sepaText;    // 구분자
	private String childYn;     // 하위보유여부
	private String actionYn;    // 페이지유무
	private String enableYn;    // 활성화여부
	private String sfdcYn;      // Salesforce여부
	private String menuPath;    // 메뉴경로
	private String helpYn;      // 도움말여부
	private long menuLevel;     // 메뉴레벨
	private long menuSeq;       // 메뉴순서
	
	private List<Menu> subs;    // 하위메뉴목록

	//메뉴구성정보
	private String userId;      // 사용자 ID( COMM or ID)
	private long sortSeq;       // 순서

	private String progAuth;    // 화면권한
	private String childCnt;    // 하위권한여부
	
	public String getMenuKey() {
		return menuKey;
	}
	public void setMenuKey(String menuKey) {
		this.menuKey = menuKey;
	}
	public String getMenuDesc() {
		return menuDesc;
	}
	public void setMenuDesc(String menuDesc) {
		this.menuDesc = menuDesc;
	}
	public String getMenuDir() {
		return menuDir;
	}
	public void setMenuDir(String menuDir) {
		this.menuDir = menuDir;
	}
	public String getMenuUrl() {
		return menuUrl;
	}
	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}
	public String getParentKey() {
		return parentKey;
	}
	public void setParentKey(String parentKey) {
		this.parentKey = parentKey;
	}
	public String getParentDesc() {
		return parentDesc;
	}
	public void setParentDesc(String parentDesc) {
		this.parentDesc = parentDesc;
	}
	public String getProcType() {
		return procType;
	}
	public void setProcType(String procType) {
		this.procType = procType;
	}
	public String getIconCls() {
		return iconCls;
	}
	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}
	public String getSepaText() {
		return sepaText;
	}
	public void setSepaText(String sepaText) {
		this.sepaText = sepaText;
	}
	public String getChildYn() {
		return childYn;
	}
	public void setChildYn(String childYn) {
		this.childYn = childYn;
	}
	public String getActionYn() {
		return actionYn;
	}
	public void setActionYn(String actionYn) {
		this.actionYn = actionYn;
	}
	public String getEnableYn() {
		return enableYn;
	}
	public void setEnableYn(String enableYn) {
		this.enableYn = enableYn;
	}
	public long getMenuLevel() {
		return menuLevel;
	}
	public void setMenuLevel(long menuLevel) {
		this.menuLevel = menuLevel;
	}
	public long getMenuSeq() {
		return menuSeq;
	}
	public void setMenuSeq(long menuSeq) {
		this.menuSeq = menuSeq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public long getSortSeq() {
		return sortSeq;
	}
	public void setSortSeq(long sortSeq) {
		this.sortSeq = sortSeq;
	}
	public List<Menu> getSubs() {
		return subs;
	}
	public void setSubs(List<Menu> subs) {
		this.subs = subs;
	}
	public String getProgAuth() {
		return progAuth;
	}
	public void setProgAuth(String progAuth) {
		this.progAuth = progAuth;
	}
	public String getChileCnt() {
		return childCnt;
	}
	public void setChildCnt(String childCnt) {
		this.childCnt = childCnt;
	}
	public String getMenuDescEn() {
		return menuDescEn;
	}
	public void setMenuDescEn(String menuDescEn) {
		this.menuDescEn = menuDescEn;
	}
	public String getMenuDescKr() {
		return menuDescKr;
	}
	public void setMenuDescKr(String menuDescKr) {
		this.menuDescKr = menuDescKr;
	}
	public String getSfdcYn() {
		return sfdcYn;
	}
	public void setSfdcYn(String sfdcYn) {
		this.sfdcYn = sfdcYn;
	}
	public String getMenuPath() {
		return menuPath;
	}
	public void setMenuPath(String menuPath) {
		this.menuPath = menuPath;
	}
	public String getHelpYn() {
		return helpYn;
	}
	public void setHelpYn(String helpYn) {
		this.helpYn = helpYn;
	}
	
}
