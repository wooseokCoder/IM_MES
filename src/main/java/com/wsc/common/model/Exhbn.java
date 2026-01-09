package com.wsc.common.model;

import java.util.List;

import com.wsc.framework.base.BaseModel;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

//코드
//코드변경이력
//코드기간관리

public class Exhbn extends BaseModel {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2917997859473742590L;
	
	private String exhbnCode;
	private String exhbnYear;
	private String exhbnName;
	private String exhbnBgnDate;
	private String exhbnEndDate;
	private String exhbnLoc;
	private String maxNum;
	private String activeYn;
	private String fileName;
	private String useYn;
	private String seq;

	public String getExhbnCode() {
		return exhbnCode;
	}

	public void setExhbnCode(String exhbnCode) {
		this.exhbnCode = exhbnCode;
	}

	public String getExhbnYear() {
		return exhbnYear;
	}

	public void setExhbnYear(String exhbnYear) {
		this.exhbnYear = exhbnYear;
	}

	public String getExhbnName() {
		return exhbnName;
	}

	public void setExhbnName(String exhbnName) {
		this.exhbnName = exhbnName;
	}

	public String getExhbnBgnDate() {
		return exhbnBgnDate;
	}

	public void setExhbnBgnDate(String exhbnBgnDate) {
		this.exhbnBgnDate = exhbnBgnDate;
	}

	public String getExhbnEndDate() {
		return exhbnEndDate;
	}

	public void setExhbnEndDate(String exhbnEndDate) {
		this.exhbnEndDate = exhbnEndDate;
	}

	public String getExhbnLoc() {
		return exhbnLoc;
	}

	public void setExhbnLoc(String exhbnLoc) {
		this.exhbnLoc = exhbnLoc;
	}

	public String getMaxNum() {
		return maxNum;
	}

	public void setMaxNum(String maxNum) {
		this.maxNum = maxNum;
	}

	public String getActiveYn() {
		return activeYn;
	}

	public void setActiveYn(String activeYn) {
		this.activeYn = activeYn;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	
	
}
