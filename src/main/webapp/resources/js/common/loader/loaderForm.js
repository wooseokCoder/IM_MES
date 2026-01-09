var consts = {
	sysId: gconsts.SYS_ID,    //시스템ID (common.jsp)
	title: gconsts.TITLE,     //화면제목 (common.jsp)
	url: {
		search: getUrl("/common/loader/search.json"),
		select: getUrl("/common/loader/select.json"),
		remove: getUrl("/common/loader/delete.json"),
		upload: getUrl("/common/loader/upload.json"),
		save:   getUrl("/common/loader/save.json")
	},
	itemurl: {
		search: getUrl("/common/loader/searchItem.json"),
		save:   getUrl("/common/loader/saveItem.json")
	},
	combo: {
		itemType: new jcombobox({
			combo: 'combobox',
			params: {codeGrup: 'EXCL_CTYPE'},
			autoload: true
		}),
		exclCode: new jcombobox({
			combo:  'combogrid',
			type:    9,
			params:  {},
			options: {
				panelWidth: 350,
				rownumbers: true,
				selectOnNavigation: true,
				idField:   'codeCd',
				valueField:'codeCd',
				textField: 'codeName',
				data: [],
				columns:[[
					{field:'codeCd'  ,width:120,title:'변수명'},
					{field:'codeName',width:150,title:'항목명칭'},
					{field:'sortSeq' ,width: 60,title:'순서'}
				]]
			}
		})
	},
	loadExclCode: function(group) {
		var c = this.combo.exclCode;
		var g = this.itemgrid;

		c.load({codeGrup:group});
		g.changeEditor('exclCode', c.editor());
	},
	formgrid: false,
	itemgrid: false,
	isformgrid: function(id) {
		if (id.indexOf("lform-") >= 0)
			return true;
		return false;
	},
	isitemgrid: function(id) {
		if (id.indexOf("litem-") >= 0)
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
	getformdata: function() {
	   	return consts.itemgrid.getSearchData();
	},
	init: function() {
		
		$("#r_exclGrup").combobox({
			width:   300,
			mode:   'remote',
			prompt: '양식종류선택',
			params: {extChr01:'EXCLFORM',useFlag:'Y'},
			loader: jcombo.loader,
			onSelect: doComboSelect
		});
		
		this.formgrid = new jeasygrid({
			url:      this.url,
			gridKey:  "#lform-grid",
			sformKey: "#lform-form",
			formKey:  "#litem-form"
		});
		//그리드 생성
		this.formgrid.init({
			fit:          true,
			rownumbers:   true,
			pagination:   false,
			singleSelect: true,
			title:   "엑셀양식목록",
			iconCls: "ui-icon ui-icon-gear",
			toolbar: "#lform-toolbar",
			columns: [[
			    {field:'formName', width:150, halign:'center', align:'left'  , title: '양식명칭'},
			    {field:'titleNo',  width: 50, halign:'center', align:'center', title: '제목행'},
			    {field:'startNo',  width: 50, halign:'center', align:'center', title: '시작행'},
			    {field:'pivotYn',  width: 50, halign:'center', align:'center', title: '피벗', formatter:jformat.yesno}
			]],
			onSelect:      doSelect,
			onClickRow:    this.formgrid.clickRowEdit,
			onBeforeEdit:  this.formgrid.beforeEdit,
			onAfterEdit :  this.formgrid.afterEdit, 
			onBeforeLoad:  doBeforeLoad,
			onLoadSuccess: doLoadSuccess
		});
		
		this.itemgrid = new jeasygrid({
			url:      this.itemurl,
			title:    "엑셀칼럼",
			gridKey:  "#litem-grid",
			sformKey: "#litem-form"
		});
		//그리드 생성
		this.itemgrid.init({
			fit:          true,
			rownumbers:   true,
			pagination:   false,
			singleSelect: true,
			idField: "itemCode",
			toolbar: "#litem-toolbar",
			footer:  "#litem-footer",
			columns: [[
			    {field:'itemCode', width: 60, halign:'center', align:'center', title: '번호', editor:{type:'validatebox',options:{required:true}}},
			    {field:'itemName', width:200, halign:'center', align:'left'  , title: '명칭', editor:{type:'validatebox',options:{required:true}}},
			    {field:'itemDesc', width:200, halign:'center', align:'left'  , title: '설명', editor:'text'},
			    {field:'itemType', width: 80, halign:'center', align:'center', title: '타입', 
			     editor:    consts.combo.itemType.editor(),
			     formatter: consts.combo.itemType.formatter()
			    },
			    {field:'exclCode', width:250, halign:'center', align:'left'  , title: '맵핑',
			     editor:    consts.combo.exclCode.editor(),
			     formatter: consts.combo.exclCode.formatter()
			    }
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
	
	$("#lform-save-button"  ).bind("click", doSave);
	$("#lform-clear-button" ).bind("click", doClear);
	$("#lform-remove-button").bind("click", doRemove);

	$("#litem-save-button"  ).bind("click", doSaveItem);
	$("#litem-append-button").bind("click", doAppendItem);
	$("#litem-remove-button").bind("click", doRemoveItem);
	$("#litem-upload-button").bind("click", doUploadItem);
});

//양식목록 검색
function doComboSelect(rec) {

	consts.loadExclCode(rec.value);
	
	doSearch();
}

function getExcelGroup() {
	return $("#r_exclGrup").combobox('getValue');
}

function doBeforeLoad(param) {
	if ( consts.isformgrid(this.id) && param.exclGrup )
		return true;
	if ( consts.isitemgrid(this.id) && param.exclGrup && param.formCode )
		return true;
	return false;
}

function doSelect(index, row) {
	
	var g = consts.itemgrid;
   	var f = g.sform;
	
   	//폼데이터 로드
	f.form('load', row);
	//수정상태 정의
	jstatus.update(f);
	doReadonly(true);

	var name = '[<font color=blue>'+row.formName+'</font>] 칼럼목록';

	g.clear();
	g.changeTitle(name);
	g.search();
}

function doLoadSuccess(data) {
	doClear();
}

function doSearch() {
	consts.formgrid.search();
}

function doRemove() {
	consts.formgrid.remove();
}

function doSave() {
	consts.formgrid.save();
}

function doClear() {
	var group = getExcelGroup();
	
	consts.formgrid.grid.datagrid('clearSelections');
	consts.itemgrid.reset();
	consts.itemgrid.resetData();
	consts.itemgrid.changeTitle("엑셀칼럼 검색");
	consts.itemgrid.sform.form('load', {
		oper: jstatus.INSERT, 
		exclGrup: group
	});
	$("#upload-form")[0].reset();
	
	doReadonly(false);
}

//PK칼럼의 Readonly 처리
function doReadonly( readonly ) {
	
	var obj = $("#o_formCode");
	var txt = "readonly";
	
	obj.textbox(txt, readonly);
	
	if (readonly)
		obj.textbox('textbox').addClass(txt);
	else
		obj.textbox('textbox').removeClass(txt);
}

function doSearchItem() {
	consts.itemgrid.search();
}

//칼럼목록이 편집가능한지 확인
function isEditableItem() {

	var v = consts.itemgrid.sform.getFormValue("formCode");
	if ( jutils.empty(v) ) {
		$.messager.alert('Warning',msg.MSG0088,'warning');
		return false;
	}
	return true;
}

//칼럼목록의 항목추가
function doAppendItem() {
	//편집가능여부 검증
	if (!isEditableItem())
		return;

	consts.itemgrid.appendEdit();
}

//칼럼목록의 항목삭제
function doRemoveItem() {
	//편집가능여부 검증
	if (!isEditableItem())
		return;

	consts.itemgrid.removeEdit();
}

//칼럼목록의 저장전 검증처리
function doValidateItem() {

	var g = consts.itemgrid;
	var f = g.sform;
	
	g.endEdit();
	
	var rows = g.getEditChanges();

	if (rows == null ||
		rows.length == 0) {
		$.messager.alert('Warning',msg.MSG0121,'warning');
		return false;
	}
	
	var arows = g.getRows();
	
	var chk1 = jutils.duplicateObject(arows, "itemCode");
	if (chk1) {
		$.messager.alert('Warning','번호('+$.toJSON(chk1)+')가 중복된 항목이 있습니다.','warning');
		return false;
	}
	var chk2 = jutils.duplicateObject(arows, "exclCode");
	if (chk2) {
		$.messager.alert('Warning','맵핑칼럼('+$.toJSON(chk2)+')이 중복된 항목이 있습니다.','warning');
		return false;
	}
	return rows;
}

//칼럼목록의 편집내용저장
function doSaveItem() {
	//편집가능여부 검증
	if (!isEditableItem())
		return;
	
	//저장전 항목검증
	var rows = doValidateItem();
	
	if (!rows)
		return;

	var grig = consts.itemgrid;
	var data = grig.sform.serializeObject();
	data['models'] = $.toJSON(rows);

	jlogic.save({
		url: consts.itemurl.save,
		data: data,
		success: grig.result
	});
}

//엑셀 양식파일을 업로드하여 해당 칼럼정보를 읽어온다.
function doUploadItem() {
	//편집가능여부 검증
	if (!isEditableItem())
		return;
	//2016/12/29 김영진 -- 파일박스 변경
	//if ($('#u_excelFile').filebox('getValue') == "") {
	if ($('#u_excelFile').val() == "") {
		$.messager.alert('Warning',msg.MSG0121,'warning');
		return;
	}
	
	var target =   "#upload-frame";
	var form   = $("#upload-form");
	var data   = consts.getformdata();
	//데이터로드
	form.toForm(data);
	
	if (form.getFormValue("formCode") == "") {
		$.messager.alert('Warning',msg.MSG0088,'warning');
		return;
	}
	
	var message = "When you upload the selected file " 
		        + "all existing registered columns are"
		        + "<font color=red><b> deleted </b></font> and " 
		        + "updated with the information you uploaded. <br/><br/>" 
		        + "Are you sure you want to run it?";
	var uploadFn = function() {
		form.ajaxForm({
	    	url:     consts.url.upload,
	    	target:  target,
	    	success: function() {
	    		var string = $(target).html();
	    		$(target).html("");
	    		jlogic.result(string, doSearchItem);
	    	}
	    }).submit();
	};

	$.messager.confirm(msg.MSG0123,message, function(r) {
		if (r) {
			uploadFn();
		}
	});
}
