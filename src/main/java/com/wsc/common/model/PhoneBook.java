package com.wsc.common.model;

import java.util.List;

import com.wsc.framework.base.BaseModel;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;



public class PhoneBook extends BaseModel {

	private static final long serialVersionUID = 2917997859473742590L;
	
	private String custName;   
	private String custTel;     
	private String custFax;    
	private String custHp;    
	private String remark;    
	private String stafDept;    
	private String regi_id;    	

	private long sortSeq;      
	private String histDate;    
	private String histType;    
	private String codeDate;    
	private List<PhoneBook> codes;

	
/*	
	public boolean equalCode(ParamsMap params) {
		
		String[] names = {
			 "extChr01","extChr02","extChr03","extChr04","extChr05"
			,"extChr06","extChr07","extChr08","extChr09","extChr10"
			,"extNum01","extNum02","extNum03","extNum04","extNum05"
			,"useFlag" //[2015.06.03] ��뿩������ �߰���
		};
		return BaseUtils.equalObject(this, params, names);
	}*/

	
	public String getcustName() {
		return custName;
	}

	public void setcustName(String custName) {
		this.custName = custName;
	}
	
	public String getcustTel() {
		return custTel;
	}

	public void setcustTel(String custTel) {
		this.custTel = custTel;
	}	
	public String getcustFax() {
		return custFax;
	}

	public void setcustFax(String custFax) {
		this.custFax = custFax;
	}
	
	public String getcustHp() {
		return custHp;
	}

	public void setcustHp(String custHp) {
		this.custHp = custHp;
	}
	
	public String getremark() {
		return remark;
	}

	public void setremark(String remark) {
		this.remark = remark;
	}
	
	public String getstafDept() {
		return stafDept;
	}

	public void setstafDept(String stafDept) {
		this.stafDept = stafDept;
	}

	public void setregi_id(String regi_id) {
		this.regi_id = regi_id;
	}
	public String getregi_id() {
		return regi_id;
	}

	public long getSortSeq() {
		return sortSeq;
	}
	public void setSortSeq(long sortSeq) {
		this.sortSeq = sortSeq;
	}
	public String getHistDate() {
		return histDate;
	}
	public void setHistDate(String histDate) {
		this.histDate = histDate;
	}
	public String getHistType() {
		return histType;
	}
	public void setHistType(String histType) {
		this.histType = histType;
	}
	public String getCodeDate() {
		return codeDate;
	}
	public void setCodeDate(String codeDate) {
		this.codeDate = codeDate;
	}
	public List<PhoneBook> getCodes() {
		return codes;
	}
	public void setCodes(List<PhoneBook> codes) {
		this.codes = codes;
	}


}
