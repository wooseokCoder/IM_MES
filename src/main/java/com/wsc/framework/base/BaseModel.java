/*
 * @(#)BaseModel.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.base;

import java.io.Serializable;

/**
 * 기본 모델 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public abstract class BaseModel implements Serializable {
    /**
     * 시리얼 버전 아이디
     */
    private static final long serialVersionUID = 1L;

	protected String sysId;
	protected String regiId;
	protected String regiDate;
	protected String chngId;
	protected String chngDate;
	protected String useFlag;
	protected String oper;
	protected String gsUserId;
	protected String regiName;
	protected String chngName;
	
	public String getSysId() {
		return sysId;
	}
	public void setSysId(String sysId) {
		this.sysId = sysId;
	}
	public String getRegiId() {
		return regiId;
	}
	public void setRegiId(String regiId) {
		this.regiId = regiId;
	}
	public String getRegiDate() {
		return regiDate;
	}
	public void setRegiDate(String regiDate) {
		this.regiDate = regiDate;
	}
	public String getChngId() {
		return chngId;
	}
	public void setChngId(String chngId) {
		this.chngId = chngId;
	}
	public String getChngDate() {
		return chngDate;
	}
	public void setChngDate(String chngDate) {
		this.chngDate = chngDate;
	}
	public String getUseFlag() {
		return useFlag;
	}
	public void setUseFlag(String useFlag) {
		this.useFlag = useFlag;
	}
	public String getOper() {
		return oper;
	}
	public void setOper(String oper) {
		this.oper = oper;
	}
	public String getGsUserId() {
		return gsUserId;
	}
	public void setGsUserId(String gsUserId) {
		this.gsUserId = gsUserId;
	}
	public String getRegiName() {
		return regiName;
	}
	public void setRegiName(String regiName) {
		this.regiName = regiName;
	}
	public String getChngName() {
		return chngName;
	}
	public void setChngName(String chngName) {
		this.chngName = chngName;
	}
	
}