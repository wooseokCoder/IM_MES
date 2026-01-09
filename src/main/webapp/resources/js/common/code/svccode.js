/**
 * 코드관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 패널 상세조회
 * 폼 패널 등록,수정,삭제
 */
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/common/code/svccode/search.json"),
		excel:  getUrl("/common/code/svccode/download.do"),
		report: getUrl("/common/code/svccode/report/code."),
		//select: getUrl("/common/svccode/select.json"),
		remove: getUrl("/common/code/svccode/delete.json"),
		save:   getUrl("/common/code/svccode/save.json")
	},
	init: function() {

		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				excel:  getUrl("/common/code/svccode/download.do"),
				report: getUrl("/common/code/svccode/report/code."),
				//select: getUrl("/common/code/svccode/select.json"),
				remove: getUrl("/common/code/svccode/delete.json"),
				save:   getUrl("/common/code/svccode/save.json")
			},
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			//formKey:  "#regist-form",
			sformKey: "#search-form"
			/*fn: {
				//저장,삭제 후 콤보값 리로드
				result: function() {
					$("#s_codeGrup").combobox('reload');
					$("#r_codeGrup").combobox('reload');
				}
			}*/
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			singleSelect: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'codeCd',
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			//행선택시 상세조회 이벤트 바인딩
			//onSelect: this.easygrid.select,
			singleSelect: true,
			//그리드 편집이벤트 바인딩
			onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			onBeginEdit: doBeginEdit,
			onDblClickRow: doDblClickRow, //그리드 더블클릭시 이벤트 바인딩
			onLoadSuccess:function(){
				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');

			}
		});

		$('#search-grid').datagrid('hideColumn', 'codeGrup');
		$('#search-grid').datagrid('hideColumn', 'extChr01');
		$('#search-grid').datagrid('hideColumn', 'extChr02');
		$('#search-grid').datagrid('hideColumn', 'extChr03');
		$('#search-grid').datagrid('hideColumn', 'extChr04');
		$('#search-grid').datagrid('hideColumn', 'extChr05');
		$('#search-grid').datagrid('hideColumn', 'extChr06');
		$('#search-grid').datagrid('hideColumn', 'extChr07');
		$('#search-grid').datagrid('hideColumn', 'extChr08');
		$('#search-grid').datagrid('hideColumn', 'extChr09');
		$('#search-grid').datagrid('hideColumn', 'extChr10');
		$('#search-grid').datagrid('hideColumn', 'extNum01');
		$('#search-grid').datagrid('hideColumn', 'extNum02');
		$('#search-grid').datagrid('hideColumn', 'extNum03');
		$('#search-grid').datagrid('hideColumn', 'extNum04');
		$('#search-grid').datagrid('hideColumn', 'extNum05');

		//등록폼 초기화
		doClear();






	}
};

$(function() {

	consts.init();

	$('#progress-popup').dialog({
       title: tit.TITLE0009,
       top:     100,
       width: 200,
       height: 200,
       closed: true,
       modal: true,
       resizable: false
	});
	
	$('#regist-dialog').dialog({
	    //title: tit.TITLE0029,//샘플게시판 등록
		title: 'Ext. Text',
	    iconCls: 'icon-search',
	    top:    10,
	    width: 590,
	    height: 455,
	    closed: true,
	    modal: true,
	    resizable: true
	});	
	
	$('#regist-dialog2').dialog({
	    //title: tit.TITLE0029,//샘플게시판 등록
		title: 'Ext. Number',
	    iconCls: 'icon-search',
	    top:    10,
	    width: 590,
	    height: 270,
	    closed: true,
	    modal: true,
	    resizable: true
	});	
	
});

$(window).load(function() {

	setTimeout(function (){
		
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					doSearch();
				}
			});
		});
		
		$(".easyui-combobox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.combobox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					doSearch();
				}
			});
		});

		$(".wui-dialog").show();

		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		//추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);
		

		//리포트버튼 클릭시 이벤트 바인딩
		$("#report-button-pdf").bind("click", doReport);
		$("#report-button-xls").bind("click", doReport);
		$("#report-button-htm").bind("click", doReport);

		//정렬버튼
		$("#sort-button"  ).bind("click", doSortPopup);
		
		//Ext.Text 버튼(팝업) 클릭시 이벤트 바인딩
		$("#extChr-button").bind("click", doExtChr);
		//Ext.Text2 버튼(팝업) 클릭시 이벤트 바인딩
		$("#extNum-button").bind("click", doExtNum);
		
		//Ext.Text 저장
		$("#save-create-button").bind('click',doSaveCreate);
		//Ext.Text 닫기버튼 클릭시 이벤트바인딩
		$("#close-create-button").bind("click", doCloseCreat);

		//Ext.Number 저장
		$("#save-create-button2").bind('click',doSaveCreate2);
		//Ext.Number 닫기버튼 클릭시 이벤트바인딩
		$("#close-create-button2").bind("click", doCloseCreat2);
		
		//Enter 검색을 위한 추가
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keyup', function(e){
				itemid.textbox('setValue', $(this).val());
			});
		});

		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

		/* 정렬기능 기본 셋팅 */
		var sortContentParame = [{"sortText":"Code","sortValue":"CODE_CD"}
		  ,{"sortText":"Code Name","sortValue":"CODE_NAME"}
		  ,{"sortText":"Code Name(En)","sortValue":"CODE_NAME_EN"}
		  ,{"sortText":"Seq","sortValue":"SORT_SEQ"}
		  ,{"sortText":"Use Flag","sortValue":"USE_FLAG"}
		  ,{"sortText":"Code Desc","sortValue":"CODE_DESC"}
		  ,{"sortText":"Ext Text","sortValue":"EXT_TEXT"}];
		jSortInit(sortContentParame);
		//console.log($("#sortValue").val());
		if($("#sortValue").val() != ""){
			doSearch();
		}

	}, 100);

	doLangSettingTable();

});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//에디트 시작
function doBeginEdit(rowIndex, rowData){
	var editors = $('#search-grid').datagrid('getEditors', rowIndex);
	 //var n1 = $(editors[0].target);
    // var n2 = $(editors[1].target);
     var n3 = $(editors[1].target);
     var selGrup = "SERVICE_M";

     if(rowData.oper == "I"){
    	 n3 = $(editors[2].target);
     }
     n3.textbox('setValue', 'SERVICE_M');
}

//검색 처리
function doSearch() {
	//consts.easygrid.search();
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.search(consts.url.search);
}

//엑셀 다운로드
function doExcel() {
	   $('#progress-popup').dialog('open');

	   consts.easygrid.download();

	   $(document).ready(function() {
	       $(window).blur(function() {
	          $('#progress-popup').dialog('close');
	       });
	   });
}

//리포트 출력
function doReport() {
	var id  = this.id;
	var ext = 'pdf';

	if      (id == 'report-button-pdf') ext = 'pdf';
	else if (id == 'report-button-xls') ext = 'xls';
	else if (id == 'report-button-htm') ext = 'html';

	jlogic.report({
		url: consts.url.report+ext
	});
}
//초기화 처리
function doClear() {
	consts.easygrid.clear();
}
//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
/*	if($('input[name=codeGrup]').val() == "" || $('input[name=codeGrup]').val() == null){
		$.messager.alert('Warning',msg.MSG0112,'warning');
		return;
	}*/
	consts.easygrid.appendEdit();
}
//삭제 처리
function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.removeEdit();
}

//저장 처리
function doSave() {
	
		if($('#'+this.id).hasClass('l-btn-disabled')){
		      return false;
		   }
		consts.easygrid.saveEdit(); // consts.easygrid.save() -> consts.easygrid.saveEditCustom() 변경 김원국
	/*	if(doubleSubmitCheck()){}*/
}



function docheck() {
	var rows = $('#search-create-grid').datagrid('getRows');

		$.ajax({
			url: getUrl('/common/code/codecheck.json'),
			dataType: 'json',
			async: false,
			type: 'post',
			data: data,
			success: function(data){
				$.messager.show({
					title: 'Information',
					msg: msg.MSG0103
				});
			},
			error: function(){
			}
		});
}


//초기화
function doReload(){

	$("#s_codeGrup").combobox('setValue','ALL');
	$("#s_codeCd").textbox('setValue','');
	$("#s_codeDesc").textbox('setValue','');
	$("#s_useFlag").combobox('setValue','ALL');

}
function doEnterKey(){

}

// 중복 submit 방지
var doubleSubmitFlag = true;
function doubleSubmitCheck(){
    if(doubleSubmitFlag){
    	
    	doubleSubmitFlag = false;
    	setTimeout(function () {
    		doubleSubmitFlag = true;
        }, 3000)
        return true;
    }else{
    	
        return false;
    }
}


//검색영역 코드그룹 변경 이벤트
function doGrupChange(newValue,oldValue){
	doSearch();
}

function formatCheck(value,row,index){
	var d;
	if(value == '1' || value == 'Y' ) d = '<input type="checkbox" checked/>';
	else d = '<input type="checkbox" />';
	return d;
}

//추가 처리
function doExtChr() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	doCloseCreat();
	var row = $('#search-grid').datagrid('getSelected');
	if(row == null || row == ""){
		$.messager.alert('Warning',msg.MSG0114,'warning');
		return;
	}
	$("#r_codeCd").val(row.codeCd);
	$("#r_codeGrup").val(row.codeGrup);
	$("#r_extChr01").textbox("setValue",row.extChr01);
	$("#r_extChr02").textbox("setValue",row.extChr02);
	$("#r_extChr03").textbox("setValue",row.extChr03);
	$("#r_extChr04").textbox("setValue",row.extChr04);
	$("#r_extChr05").textbox("setValue",row.extChr05);
	$("#r_extChr06").textbox("setValue",row.extChr06);
	$("#r_extChr07").textbox("setValue",row.extChr07);
	$("#r_extChr08").textbox("setValue",row.extChr08);
	$("#r_extChr09").textbox("setValue",row.extChr09);
	$("#r_extChr10").textbox("setValue",row.extChr10);
	$("#regist-dialog").dialog('center');
	$("#regist-dialog").dialog('open');
}
function doExtNum(){
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	doCloseCreat2();
	var row = $('#search-grid').datagrid('getSelected');
	if(row == null || row == ""){
		$.messager.alert('Warning',msg.MSG0114,'warning');
		return;
	}
	$("#r_codeCd2").val(row.codeCd);
	$("#r_codeGrup2").val(row.codeGrup);
	$("#r_extNum01").textbox("setValue",row.extNum01);
	$("#r_extNum02").textbox("setValue",row.extNum02);
	$("#r_extNum03").textbox("setValue",row.extNum03);
	$("#r_extNum04").textbox("setValue",row.extNum04);
	$("#r_extNum05").textbox("setValue",row.extNum05);
	$("#regist-dialog2").dialog('center');
	$("#regist-dialog2").dialog('open');
}
//그리드 더블클릭시 이벤트 바인딩
function doDblClickRow(idx, row) {
	//
	if (!row) return;
	$("#r_codeCd").val(row.codeCd);
	$("#r_codeGrup").val(row.codeGrup);
	$("#r_extChr01").textbox("setValue",row.extChr01);
	$("#r_extChr02").textbox("setValue",row.extChr02);
	$("#r_extChr03").textbox("setValue",row.extChr03);
	$("#r_extChr04").textbox("setValue",row.extChr04);
	$("#r_extChr05").textbox("setValue",row.extChr05);
	$("#r_extChr06").textbox("setValue",row.extChr06);
	$("#r_extChr07").textbox("setValue",row.extChr07);
	$("#r_extChr08").textbox("setValue",row.extChr08);
	$("#r_extChr09").textbox("setValue",row.extChr09);
	$("#r_extChr10").textbox("setValue",row.extChr10);
	$("#regist-dialog").dialog('center');
	$("#regist-dialog").dialog('open');
}

function doSaveCreate() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	
	var data = $("#search-create-form").serializeObject();
	$.ajax({
		url: getUrl('/common/code/updateExtChr.json'),
		dataType: 'json',
		async: false,
		type: 'post',
		data: data,
		success: function(data){
			$.messager.show({
				title: 'Information',
				msg: msg.MSG0103
			});
		},
		error: function(){
		}
	});
	doCloseCreat();
	doSearch();
}
function doSaveCreate2() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	
	var data = $("#search-create-form2").serializeObject();
	$.ajax({
		url: getUrl('/common/code/updateExtNum.json'),
		dataType: 'json',
		async: false,
		type: 'post',
		data: data,
		success: function(data){
			$.messager.show({
				title: 'Information',
				msg: msg.MSG0103
			});
		},
		error: function(){
		}
	});
	doCloseCreat2();
	doSearch();
}
function doCloseCreat() {
	$('#regist-dialog').dialog('close');
	$("#r_codeCd").val("");
	$("#r_codeGrup").val("");
	$("#r_extChr01").textbox("setValue","");
	$("#r_extChr02").textbox("setValue","");
	$("#r_extChr03").textbox("setValue","");
	$("#r_extChr04").textbox("setValue","");
	$("#r_extChr05").textbox("setValue","");
	$("#r_extChr06").textbox("setValue","");
	$("#r_extChr07").textbox("setValue","");
	$("#r_extChr08").textbox("setValue","");
	$("#r_extChr09").textbox("setValue","");
	$("#r_extChr10").textbox("setValue","");
}
function doCloseCreat2() {
	$('#regist-dialog2').dialog('close');
	$("#r_codeCd2").val("");
	$("#r_codeGrup2").val("");
	$("#r_extNum01").textbox("setValue","");
	$("#r_extNum02").textbox("setValue","");
	$("#r_extNum03").textbox("setValue","");
	$("#r_extNum04").textbox("setValue","");
	$("#r_extNum05").textbox("setValue","");
}