/**
 * 코드관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 패널 상세조회
 * 폼 패널 등록,수정,삭제
 */
jcombo.load = function(args, flg) {
	var flag   = (flg ? flg : 1);
	var items  = [];
	var params = {};

    items.push({value:'CENTER', text:'CENTER'});
    items.push({value:'LEFT',   text:'LEFT'});
    items.push({value:'RIGHT',  text:'RIGHT'});
    return items;
};
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/common/user/excelinfo/search.json"),
		excel:  getUrl("/common/user/excelinfo/download.do"),
		//select: getUrl("/common/excelinfo/select.json"),
		remove: getUrl("/common/user/excelinfo/delete.json"),
		save:   getUrl("/common/user/excelinfo/save.json")
	},
	combo: {
		Align : new jcombobox({params : {codeGrup : ''}
		}) 
	},
	init: function() {
		this.combo.Align.load();
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				excel:  getUrl("/common/user/excelinfo/download.do"),
				//select: getUrl("/common/excelinfo/select.json"),
				remove: getUrl("/common/user/excelinfo/delete.json"),
				save:   getUrl("/common/user/excelinfo/save.json")
			},
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form"
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
			onClickRow : this.easygrid.clickRowEdit,
			selectOnCheck:false,			
		    checkOnSelect: false,//TODO 김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
			onBeginEdit : doBeginEdit, //필수
			OnBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			//onDblClickRow: doDblClickRow, //그리드 더블클릭시 이벤트 바인딩
			onLoadSuccess:function(){
				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');

			}
		});
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
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);

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
}

//검색 처리
function doSearch() {
	//consts.easygrid.search();
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.search(consts.url.search);
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
	$("#s_codeName").textbox('setValue','');
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
}
