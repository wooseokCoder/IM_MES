package com.wsc.common.model;

import com.wsc.framework.base.BaseModel;

public class Program extends BaseModel {

	/**
	 *
	 */
	private static final long serialVersionUID = 5852727952289190937L;

	private String progId;    // 화면ID
	private String progId2;    // 화면ID
	private String progName;  // 화면명
	private String progType;  // 유형
	private String menuSet;  // 최상위 메뉴 구분
	private String menuType;  // 메뉴유형
	private String mobileType;  // 모바일구분
	private String tranA;     // 기본
	private String tranC;     // 등록
	private String tranR;     // 조회
	private String tranU;     // 수정
	private String tranD;     // 삭제
	private String tranP;     // 권한P
	private String tranS;     // 권한S
	private String tran1;     // 권한1
	private String tran2;     // 권한2
	private String tran3;     // 권한3
	private String tran4;     // 권한4
	private String tran5;     // 권한5
	private String sysLoc;    // 상태
	private String pattern;   // Normal or Board

	private int upgmCnt;      // 사용자의 화면접근 가능건수
	private int gpgmCnt;      // 사용자그룹의 화면접근 가능건수

	private String userId;
	private String userName;
	private String groupId;
	private String groupName;
	private String menuKey;

	//접근가능여부
	public boolean enable() {
		//if (upgmCnt > 0 || gpgmCnt > 0)
		//	return true;

		if ("1".equals(tranA))
			return true;

		return false;
	}

	public String getProgId() {
		return progId;
	}
	public void setProgId(String progId) {
		this.progId = progId;
	}
	public String getProgId2() {
		return progId2;
	}
	public void setProgId2(String progId2) {
		this.progId2 = progId2;
	}
	public String getProgName() {
		return progName;
	}
	public void setProgName(String progName) {
		this.progName = progName;
	}
	public String getProgType() {
		return progType;
	}
	public void setProgType(String progType) {
		this.progType = progType;
	}
	public String getTranA() {
		return tranA;
	}
	public void setTranA(String tranA) {
		this.tranA = tranA;
	}
	public String getTranC() {
		return tranC;
	}
	public void setTranC(String tranC) {
		this.tranC = tranC;
	}
	public String getTranR() {
		return tranR;
	}
	public void setTranR(String tranR) {
		this.tranR = tranR;
	}
	public String getTranU() {
		return tranU;
	}
	public void setTranU(String tranU) {
		this.tranU = tranU;
	}
	public String getTranD() {
		return tranD;
	}
	public void setTranD(String tranD) {
		this.tranD = tranD;
	}
	public String getTranP() {
		return tranP;
	}
	public void setTranP(String tranP) {
		this.tranP = tranP;
	}
	public String getTranS() {
		return tranS;
	}
	public void setTranS(String tranS) {
		this.tranS = tranS;
	}
	public String getTran1() {
		return tran1;
	}
	public void setTran1(String tran1) {
		this.tran1 = tran1;
	}
	public String getTran2() {
		return tran2;
	}
	public void setTran2(String tran2) {
		this.tran2 = tran2;
	}
	public String getTran3() {
		return tran3;
	}
	public void setTran3(String tran3) {
		this.tran3 = tran3;
	}
	public String getTran4() {
		return tran4;
	}
	public void setTran4(String tran4) {
		this.tran4 = tran4;
	}
	public String getTran5() {
		return tran5;
	}
	public void setTran5(String tran5) {
		this.tran5 = tran5;
	}
	public String getSysLoc() {
		return sysLoc;
	}
	public void setSysLoc(String sysLoc) {
		this.sysLoc = sysLoc;
	}
	public int getUpgmCnt() {
		return upgmCnt;
	}
	public void setUpgmCnt(int upgmCnt) {
		this.upgmCnt = upgmCnt;
	}
	public int getGpgmCnt() {
		return gpgmCnt;
	}
	public void setGpgmCnt(int gpgmCnt) {
		this.gpgmCnt = gpgmCnt;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
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
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public String getMenuKey() {
		return menuKey;
	}

	public void setMenuKey(String menuKey) {
		this.menuKey = menuKey;
	}

	public String getPattern() {
		return pattern;
	}

	public void setPattern(String pattern) {
		this.pattern = pattern;
	}

}
