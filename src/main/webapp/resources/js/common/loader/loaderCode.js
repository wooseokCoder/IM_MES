var consts = {
	sysId: gconsts.SYS_ID,    //시스템ID (common.jsp)
	title: gconsts.TITLE,     //화면제목 (common.jsp)
	url: {
		search: getUrl("/common/code/search.json"),
		select: getUrl("/common/code/select.json"),
		save:   getUrl("/common/loader/saveCode.json")
	},
	formgrid: false,
	itemgrid: false,
	isformgrid: function(id) {
		if (id.indexOf("cform-") >= 0)
			return true;
		return false;
		
		
		
		
	},
	isitemgrid: function(id) {
		if (id.indexOf("citem-") >= 0)
			return true;
		return false;
	},
	getgrid: function(id) {
		if (this.isformgrid(id))
			return this.formgrid;
		if (this.isitemgrid(id))
			return this.itemgrid;
		return false;
	},
	init: function() {

		this.formgrid = new jeasygrid({
			url:      this.url,
			gridKey:  "#cform-grid",
			sformKey: "#cform-form",
			formKey:  "#citem-form"
		});
		//그리드 생성
		this.formgrid.init({
			fit:          true,
			rownumbers:   true,
			pagination:   false,
			singleSelect: true,
			idField: "codeCd",
			title:   "양식종류목록",
			iconCls: "ui-icon ui-icon-wrench",
			toolbar: "#cform-toolbar",
			columns: [[
			    {field:'codeCd',   width:120, halign:'center', align:'left', title: '코드', editor:{type:'validatebox',options:{required:true}}},
			    {field:'codeNameKr', width:200, halign:'center', align:'left', title: '명칭', editor:{type:'validatebox',options:{required:true}}},
			    {field:'codeNameEn', width:200, halign:'center', align:'left', title: '명칭(영문)', editor:{type:'validatebox',options:{required:true}}}
			]],
			onClickRow:   this.formgrid.clickRowEdit,
			onBeforeEdit: this.formgrid.beforeEdit,
			onAfterEdit : this.formgrid.afterEdit, 
			onBeforeLoad: doBeforeLoad,
			onSelect: doSelect
		});
		
		this.itemgrid = new jeasygrid({
			url:      this.url,
			gridKey:  "#citem-grid",
			sformKey: "#citem-form"
		});
		//그리드 생성
		this.itemgrid.init({
			fit:          true,
			rownumbers:   true,
			pagination:   false,
			singleSelect: true,
			idField: "codeCd",
			title:   "양식항목목록",
			iconCls: "ui-icon ui-icon-wrench",
			toolbar: "#citem-toolbar",
			columns: [[
			    {field:'codeCd',   width:150, halign:'center', align:'left'  , title: '코드'  , editor:{type:'validatebox',options:{required:true}}},
			    {field:'codeNameKr', width:250, halign:'center', align:'left'  , title: '항목명칭', editor:{type:'validatebox',options:{required:true}}},
			    {field:'codeNameEn', width:250, halign:'center', align:'left'  , title: '항목명칭(영문)', editor:{type:'validatebox',options:{required:true}}},
			    {field:'codeDesc', width:200, halign:'center', align:'left'  , title: '항목설명', editor:'text'},
			    {field:'sortSeq',  width: 60, halign:'center', align:'center', title: '순서'   , editor:'numberbox'}
			]],
			onClickRow:   this.itemgrid.clickRowEdit,
			onBeforeEdit: this.itemgrid.beforeEdit,
			onAfterEdit : this.itemgrid.afterEdit, 
			onBeforeLoad: doBeforeLoad
		});
	}
};

$(function() {
	
	consts.init();
	
	$("#cform-save-button"  ).bind("click", doSave);
	$("#cform-add-button"   ).bind("click", doAppend);
	$("#cform-remove-button").bind("click", doRemove);

	$("#citem-save-button"  ).bind("click", doSave);
	$("#citem-add-button"   ).bind("click", doAppend);
	$("#citem-remove-button").bind("click", doRemove);
	
	doSearch();

});

function doBeforeLoad(param) {
	if ( consts.isformgrid(this.id) && param.extChr01 )
		return true;
	
	if ( consts.isitemgrid(this.id) && param.codeGrup )
		return true;
	return false;
}

function doSelect(index, row) {
	
	var g = consts.itemgrid;
   	var f = g.sform;
   	
   	var obj  = {};
   	var name = "양식항목목록";
   	if (row.codeCd) {
   		obj  = {codeGrup: row.codeCd};
   		name ='[<font color=blue>'+row.codeName+'</font>] 항목검색';
   	}
	//폼데이터 로드
	f.form('load', obj);
	g.clear();
	g.changeTitle(name);
	
	if (jstatus.isInsert(row))
		return;

	//칼럼그리드 로드
	g.search();
}

function doSearch() {
	consts.formgrid.search();
}

//추가 처리
function doAppend() {
	var id = this.id;
	var g  = consts.getgrid(id);
	
	if ( consts.isitemgrid(id) ) {
		var v = g.sform.getFormValue("codeGrup");
		if ( jutils.empty(v) ) {
			$.messager.alert('Warning',msg.MSG0088,'warning');
			return;
		}
	}
	g.appendEdit();
}
//삭제 처리
function doRemove() {
	var g = consts.getgrid(this.id);
	g.removeEdit();
}

//저장전 검증처리
function doValidate(id) {

	var g = consts.getgrid(id);
	var c = consts.isformgrid(id);
	
	g.endEdit();
	
	var rows = g.getEditChanges();

	if (rows == null ||
		rows.length == 0) {
		$.messager.alert('Warning',msg.MSG0121,'warning');
		return false;
	}
	
	if (c)
		return rows;

	var arows = g.getRows();
	
	var chk1 = jutils.duplicateObject(arows, "codeCd");
	if (chk1) {
		$.messager.alert('Warning','변수명('+$.toJSON(chk1)+')이 중복된 항목이 있습니다.','warning');
		return false;
	}
	return rows;
}

//저장 처리
function doSave() {
	
	//저장전 항목검증
	var rows = doValidate(this.id);
	
	if (!rows)
		return;
	
	var grid = consts.getgrid(this.id);
	var data = grid.sform.serializeObject();
	data['models'] = $.toJSON(rows);

	jlogic.save({
		url: consts.url.save,
		data: data,
		success: grid.result
	});
}
