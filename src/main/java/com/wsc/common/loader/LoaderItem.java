package com.wsc.common.loader;

import java.util.Map;

import com.wsc.common.model.Code;
import com.wsc.framework.base.BaseModel;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.utils.BaseUtils;

//엑셀칼럼정보
public class LoaderItem extends BaseModel {

	private static final long serialVersionUID = -2596875477286126962L;

	//엑셀양식정보
	private String exclGrup;    // 엑셀그룹
	private String formCode;    // 엑셀양식코드
	
	//칼럼정보
	private String itemCode;    // 맵핑칼럼번호
	private String itemName;    // 맵핑칼럼제목
	private String itemType;    // 맵핑칼럼타입
	private String itemDesc;    // 맵핑칼럼설명
	private String itemDef;     // 맵핑칼럼초기값
	private int itemSeq;        // 맵핑칼럼순번
	
	//변수정보(공통코드정보)
	private String exclCode;    // 엑셀칼럼변수(DB저장시 사용하는 변수명)
	private String exclName;    // 엑셀칼럼명칭(참고용)
	private int exclSeq;        // 엑셀칼럼순번(참고용)
	
	//해당 칼럼정보의 활성여부 설정
	//양식그룹의 칼럼정보가 없을 경우 비활성됨.
	//해당 칼럼데이터가 존재하지 않을 경우 비활성됨.
	private boolean enable = true;

	public void mergeField(Code column) {
		
		//칼럼정보가 없는 경우 비활성처리
		if (column == null) {
			this.enable = false;
			return;
		}
		this.enable   = true;
		this.exclCode = column.getCodeCd();
		this.exclName = column.getCodeName();
		this.exclSeq  = BaseUtils.toInt(column.getSortSeq()+"");
	}
	
	//easyui datagrid column 객체 형태로 변환하여 반환한다.
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map createGridColumn() {
		
		//셀양식에 맵핑된 칼럼변수명이 없으면 SKIP한다.
		if (BaseUtils.empty(this.exclCode))
			return null;
		
		Map obj = new RecordMap();
		
		String align  = "left";
		
		if ("N".equals(this.itemType)) {
			align = "right";
			//format = "jformat.number";
		}
		obj.put("field", this.exclCode);
		obj.put("title", this.itemName + "("+this.itemCode+")");
		obj.put("align", align);
		//if (format != null)
		//	obj.put("formatter", format);
		//obj.put("width", 100);
		return obj;
	}
	public String getExclGrup() {
		return exclGrup;
	}
	public void setExclGrup(String exclGrup) {
		this.exclGrup = exclGrup;
	}
	public String getFormCode() {
		return formCode;
	}
	public void setFormCode(String formCode) {
		this.formCode = formCode;
	}
	public String getExclCode() {
		return exclCode;
	}
	public void setExclCode(String exclCode) {
		this.exclCode = exclCode;
	}
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public String getItemType() {
		return itemType;
	}
	public void setItemType(String itemType) {
		this.itemType = itemType;
	}
	public String getItemDesc() {
		return itemDesc;
	}
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}
	public String getItemDef() {
		return itemDef;
	}
	public void setItemDef(String itemDef) {
		this.itemDef = itemDef;
	}
	public int getItemSeq() {
		return itemSeq;
	}
	public void setItemSeq(int itemSeq) {
		this.itemSeq = itemSeq;
	}
	public boolean isEnable() {
		return enable;
	}
	public void setEnable(boolean enable) {
		this.enable = enable;
	}
	public String getExclName() {
		return exclName;
	}
	public void setExclName(String exclName) {
		this.exclName = exclName;
	}
	public int getExclSeq() {
		return exclSeq;
	}
	public void setExclSeq(int exclSeq) {
		this.exclSeq = exclSeq;
	}
}
