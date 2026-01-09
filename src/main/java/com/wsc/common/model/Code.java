package com.wsc.common.model;

import java.util.List;

import com.wsc.framework.base.BaseModel;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

//코드
//코드변경이력
//코드기간관리

public class Code extends BaseModel {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2917997859473742590L;
	
	private String codeGrup;    // 코드그룹
	private String codeCd;      // 코드
	private String codeName;    // 코드명칭
	private String codeNameKr;    // 코드명칭
	private String codeNameEn;    // 코드명칭
	private String codeDesc;    // 코드설명
	private String extChr01;    // 문자속성01
	private String extChr02;    // 문자속성02
	private String extChr03;    // 문자속성03
	private String extChr04;    // 문자속성04
	private String extChr05;    // 문자속성05
	private String extChr06;    // 문자속성06
	private String extChr07;    // 문자속성07
	private String extChr08;    // 문자속성08
	private String extChr09;    // 문자속성09
	private String extChr10;    // 문자속성10
	private double extNum01;    // 숫자속성01
	private double extNum02;    // 숫자속성02
	private double extNum03;    // 숫자속성03
	private double extNum04;    // 숫자속성04
	private double extNum05;    // 숫자속성05
	private String extText;     // 기타정보
	private long sortSeq;       // 순서
	
	private String exhbnCode;
	private String exhbnYear;
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

	private String exhbnName;
	private String exhbnBgnDate;
	private String exhbnEndDate;
	private String exhbnLoc;
	private String maxNum;
	private String activeYn;
	private String fileName;
	private String useYn;
	private String seq;

	private String histDate;    // 변경 HISTORY 일자
	private String histType;    // 변경 HISTORY 구분

	private String codeDate;    // 적용일자
	
	private List<Code> codes;
	
	public boolean equalCode(ParamsMap params) {
		
		String[] names = {
			 "extChr01","extChr02","extChr03","extChr04","extChr05"
			,"extChr06","extChr07","extChr08","extChr09","extChr10"
			,"extNum01","extNum02","extNum03","extNum04","extNum05"
			,"useFlag" //[2015.06.03] 사용여부조건 추가함
		};
		return BaseUtils.equalObject(this, params, names);
	}

	public String getCodeKey() {
		return this.codeGrup + "#" + this.codeCd;
	}

	public String getCodeGrup() {
		return codeGrup;
	}

	public void setCodeGrup(String codeGrup) {
		this.codeGrup = codeGrup;
	}

	public String getCodeCd() {
		return codeCd;
	}

	public void setCodeCd(String codeCd) {
		this.codeCd = codeCd;
	}

	public String getCodeName() {
		return codeName;
	}

	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}

	public String getCodeDesc() {
		return codeDesc;
	}

	public void setCodeDesc(String codeDesc) {
		this.codeDesc = codeDesc;
	}

	public String getExtChr01() {
		return extChr01;
	}

	public void setExtChr01(String extChr01) {
		this.extChr01 = extChr01;
	}

	public String getExtChr02() {
		return extChr02;
	}

	public void setExtChr02(String extChr02) {
		this.extChr02 = extChr02;
	}

	public String getExtChr03() {
		return extChr03;
	}

	public void setExtChr03(String extChr03) {
		this.extChr03 = extChr03;
	}

	public String getExtChr04() {
		return extChr04;
	}

	public void setExtChr04(String extChr04) {
		this.extChr04 = extChr04;
	}

	public String getExtChr05() {
		return extChr05;
	}

	public void setExtChr05(String extChr05) {
		this.extChr05 = extChr05;
	}

	public String getExtChr06() {
		return extChr06;
	}

	public void setExtChr06(String extChr06) {
		this.extChr06 = extChr06;
	}

	public String getExtChr07() {
		return extChr07;
	}

	public void setExtChr07(String extChr07) {
		this.extChr07 = extChr07;
	}

	public String getExtChr08() {
		return extChr08;
	}

	public void setExtChr08(String extChr08) {
		this.extChr08 = extChr08;
	}

	public String getExtChr09() {
		return extChr09;
	}

	public void setExtChr09(String extChr09) {
		this.extChr09 = extChr09;
	}

	public String getExtChr10() {
		return extChr10;
	}

	public void setExtChr10(String extChr10) {
		this.extChr10 = extChr10;
	}

	public double getExtNum01() {
		return extNum01;
	}

	public void setExtNum01(double extNum01) {
		this.extNum01 = extNum01;
	}

	public double getExtNum02() {
		return extNum02;
	}

	public void setExtNum02(double extNum02) {
		this.extNum02 = extNum02;
	}

	public double getExtNum03() {
		return extNum03;
	}

	public void setExtNum03(double extNum03) {
		this.extNum03 = extNum03;
	}

	public double getExtNum04() {
		return extNum04;
	}

	public void setExtNum04(double extNum04) {
		this.extNum04 = extNum04;
	}

	public double getExtNum05() {
		return extNum05;
	}

	public void setExtNum05(double extNum05) {
		this.extNum05 = extNum05;
	}

	public String getExtText() {
		return extText;
	}

	public void setExtText(String extText) {
		this.extText = extText;
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

	public List<Code> getCodes() {
		return codes;
	}

	public void setCodes(List<Code> codes) {
		this.codes = codes;
	}

	public String getCodeNameKr() {
		return codeNameKr;
	}

	public void setCodeNameKr(String codeNameKr) {
		this.codeNameKr = codeNameKr;
	}

	public String getCodeNameEn() {
		return codeNameEn;
	}

	public void setCodeNameEn(String codeNameEn) {
		this.codeNameEn = codeNameEn;
	}
	
	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}
}
