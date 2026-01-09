package com.wsc.common.loader;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.map.LinkedMap;

import com.wsc.common.model.Code;
import com.wsc.framework.base.BaseModel;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.utils.BaseUtils;

//엑셀양식정보
@SuppressWarnings({ "rawtypes", "unchecked" })
public class LoaderForm extends BaseModel {
	/**
	 * 
	 */
	private static final long serialVersionUID = -4419652396856626087L;

	//엑셀양식정보
	private String exclGrup;    // 엑셀그룹
	private String formCode;    // 엑셀양식코드
	private String formName;    // 엑셀양식명칭
	private String formDesc;    // 엑셀양식설명
	private int titleNo;        // 제목행번호
	private int startNo;        // 시작행번호
	private String pivotYn;     // 피벗여부
	
	//엑셀양식의 변수목록
	private List<Code> codes;
	//엑셀칼럼목록
	private List<LoaderItem> items;

	//엑셀 알파벳코드를 KEY로 하는 칼럼맵
	private LinkedMap imap;

	public List<LoaderItem> getItems() {
		return items;
	}
	
	public List<Code> getCodes() {
		return codes;
	}
	public void setCodes(List<Code> codes) {
		this.codes = codes;
	}
	
	private Code findCode(String exclCode) {
		if (exclCode == null)
			return null;
		
		if (this.codes == null)
			return null;
		
		for (Code c : this.codes) {
			if (exclCode.equals(c.getCodeCd()))
				return c;
		}
		return null;
	}

	//엑셀양식그룹의 칼럼정보와 현재양식의 칼럼정보를 병합한다.
	//현재양식의 칼럼정보를 기준으로 한다.
	public void initItems(List<LoaderItem> items) {
		
		if (items == null)
			return;
		
		this.items = items;
		this.imap  = new LinkedMap();
		
		//칼럼양식과 맵핑정보를 병합
		for (LoaderItem item : items) {
			
			Code column = findCode(item.getExclCode());
			
			//칼럼양식과 맵핑칼럼 병합
			item.mergeField(column);
			
			//Map에 추가
			imap.put(item.getItemCode(), item);
		}
	}
	
	//제목칼럼목록 반환
	public List loadColumns() {
		
		List list = new ArrayList();
		
		//칼럼양식과 맵핑정보를 병합
		for (LoaderItem item : this.items) {
			Map obj = item.createGridColumn();
			if (obj != null)
				list.add(obj);
		}
		return list;
	}
	
	//데이터목록 반환
	public List loadDataList(List rows) {
		
		if (rows == null)
			return null;

		List data = new ArrayList();
		
		//행단위 LOOP
		for (List cols : (List<List>)rows) {
			LinkedMap row = createDataColumn(cols);
			
			if (row == null)
				continue;
			
			data.add( row );
		}
		return data;
	}
	
	//셀양식에 맞는 데이터칼럼 생성
	private LinkedMap createDataColumn(List cols) {
		
		//칼럼맵
		LinkedMap column = new LinkedMap();
		
		//열단위 LOOP
		for (int c = 0; c < cols.size(); c++) {
			
			//INDEX에 해당하는 엑셀 알파벳코드
			String code = BaseUtils.getExcelField(c, true);
			
			//셀데이터(itemType, itemValue, itemSeq)
			RecordMap col = (RecordMap)cols.get(c);
			//셀양식
			LoaderItem item = (LoaderItem)this.imap.get(code);
			
			//셀양식에 있는 칼럼만 READ한다.
			if (item == null)
				continue;
			//셀양식에 맵핑된 칼럼변수명이 없으면 SKIP한다.
			if (BaseUtils.empty(item.getExclCode()))
				continue;
			
			//칼럼타입
			String type = item.getItemType();
			//칼럼정보
			Object value = col.get("itemValue");
			
			//TODO 빈행도 필요한 경우엔 이부분을 제외할 것.
			//첫번째 셀데이터가 없는 경우 
			//해당 행은 데이터가 없는것으로 간주함.
			if (c == 0 && BaseUtils.empty(value))
				return null;
			
			if ("N".equals(type) && 
				value instanceof String) {
				value = BaseUtils.strToDouble(value.toString());
			} 
			column.put(item.getExclCode(), value);
		}
		return column;
	}
	
	public boolean isPivot() {
		return "Y".equals(pivotYn);
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
	public String getFormName() {
		return formName;
	}
	public void setFormName(String formName) {
		this.formName = formName;
	}
	public String getFormDesc() {
		return formDesc;
	}
	public void setFormDesc(String formDesc) {
		this.formDesc = formDesc;
	}
	public int getTitleNo() {
		return titleNo;
	}
	public void setTitleNo(int titleNo) {
		this.titleNo = titleNo;
	}
	public int getStartNo() {
		return startNo;
	}
	public void setStartNo(int startNo) {
		this.startNo = startNo;
	}
	public String getPivotYn() {
		return pivotYn;
	}
	public void setPivotYn(String pivotYn) {
		this.pivotYn = pivotYn;
	}
}
