package com.wsc.common.model;

import com.wsc.framework.base.BaseConstants;
import com.wsc.framework.base.BaseModel;

public class User extends BaseModel {

	private static final long serialVersionUID = -1428993743099630050L;

	private String userId;        // 사용자 ID
	private String userName;      // 사용자명
	private String userPwd;       // 비밀번호
	private String userType;      // 사용자유형(내부/업체)
	private String menuSet;      // 최상위 메뉴 구분
	private String menuType;      // 메뉴유형
	private String mobileType;      // 모바일구분
	private String userTel;       // 전화번호
	private String userHp;        // 핸드폰
	private String userMail;      // 이메일
	private String userRemk;      // 비고

	private String emplNo;        // 사번
	private String comCode;       // 회사코드
	private String comName;       // 회사명
	private String deptCode;      // 부서
	private String deptName;      // 부서명
	private String upprDeptCode;  // 상위부서
	private String orgAuthCode;   // 기본권한
	private String spcAuthCode;   // 특별권한
	private String dashType;   // 특별권한

	private long loginFailCnt;    // 로그인실패횟수
	private String pwdChngDate;   // 비밀번호변경일자
	private String lastLoginDate; // 최종로그인일자
	private String userTypeDesc;  // 사용자유형(내부/업체)
	
	private String idSfdc;        // Salesforce 계정
	private String sfdcFlag;		//Salesforce 계정 여부
	
	private String notiAllreadYn; //알림 전체읽음처리 사용여부
	
	private Group[] groups;

    public void setDefault(String sysId) {
    	setSysId    (sysId);
    	setUserId   (BaseConstants.DEFAULT_USER_ID);
    	setUserName (BaseConstants.DEFAULT_USER_NAME);

    	Group g = new Group();
    	g.setDefault();

    	setGroups (new Group[] { g } );
    }

	//관리자인지 확인
	public boolean isAdmin() {
		if (groups == null)
			return false;

		for (Group g : groups) {
			if (g.isAdmin())
				return true;
		}
		return false;
	}

	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserPwd() {
		return userPwd;
	}
	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	public String getMenuSet() {
		return menuSet;
	}
	public void setMenuSet(String menuSet) {
		this.menuSet = menuSet;
	}
	public String getMenuType() {
		return menuType;
	}
	public void setMenuType(String menuType) {
		this.menuType = menuType;
	}
	public String getMobileType() {
		return mobileType;
	}
	public void setMobileType(String mobileType) {
		this.mobileType = mobileType;
	}

	public String getUserTel() {
		return userTel;
	}
	public void setUserTel(String userTel) {
		this.userTel = userTel;
	}
	public String getUserHp() {
		return userHp;
	}
	public void setUserHp(String userHp) {
		this.userHp = userHp;
	}
	public String getUserMail() {
		return userMail;
	}
	public void setUserMail(String userMail) {
		this.userMail = userMail;
	}
	public String getUserRemk() {
		return userRemk;
	}
	public void setUserRemk(String userRemk) {
		this.userRemk = userRemk;
	}
	public String getEmplNo() {
		return emplNo;
	}
	public void setEmplNo(String emplNo) {
		this.emplNo = emplNo;
	}
	public String getComCode() {
		return comCode;
	}
	public void setComCode(String comCode) {
		this.comCode = comCode;
	}
	public String getComName() {
		return comName;
	}
	public void setComName(String comName) {
		this.comName = comName;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getUpprDeptCode() {
		return upprDeptCode;
	}
	public void setUpprDeptCode(String upprDeptCode) {
		this.upprDeptCode = upprDeptCode;
	}
	public String getOrgAuthCode() {
		return orgAuthCode;
	}
	public void setOrgAuthCode(String orgAuthCode) {
		this.orgAuthCode = orgAuthCode;
	}
	public String getSpcAuthCode() {
		return spcAuthCode;
	}
	public void setSpcAuthCode(String spcAuthCode) {
		this.spcAuthCode = spcAuthCode;
	}
	public String getDashType() {
		return dashType;
	}
	public void setDashType(String dashType) {
		this.dashType = dashType;
	}
	public long getLoginFailCnt() {
		return loginFailCnt;
	}
	public void setLoginFailCnt(long loginFailCnt) {
		this.loginFailCnt = loginFailCnt;
	}
	public String getPwdChngDate() {
		return pwdChngDate;
	}
	public void setPwdChngDate(String pwdChngDate) {
		this.pwdChngDate = pwdChngDate;
	}
	public String getLastLoginDate() {
		return lastLoginDate;
	}
	public void setLastLoginDate(String lastLoginDate) {
		this.lastLoginDate = lastLoginDate;
	}
	public Group[] getGroups() {
		return groups;
	}
	public void setGroups(Group[] groups) {
		this.groups = groups;
	}

	public String getUserTypeDesc() {
		return userTypeDesc;
	}

	public void setUserTypeDesc(String userTypeDesc) {
		this.userTypeDesc = userTypeDesc;
	}

	public String getIdSfdc() {
		return idSfdc;
	}
	public void setIdSfdc(String idSfdc) {
		this.idSfdc = idSfdc;
	}
	
	public String getSfdcFlag() {
		return sfdcFlag;
	}
	public void setSfdcFlag(String sfdcFlag) {
		this.sfdcFlag = sfdcFlag;
	}

	public String getNotiAllreadYn() {
		return notiAllreadYn;
	}

	public void setNotiAllreadYn(String notiAllreadYn) {
		this.notiAllreadYn = notiAllreadYn;
	}
	
	

}
