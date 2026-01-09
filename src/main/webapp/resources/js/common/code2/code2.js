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
		search: getUrl("/common/code2/search.json"),
		excel:  getUrl("/common/code2/download.do"),
		report: getUrl("/common/report/code."),
		select: getUrl("/common/code2/select.json"),
		remove: getUrl("/common/code2/delete.json"),
		save:   getUrl("/common/code2/save.json")
	},
	init: function() {
		
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url:      this.url,
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			formKey:  "#regist-form",
			sformKey: "#search-form",
			fn: {
				//저장,삭제 후 콤보값 리로드
				result: function() {
					$("#s_codeGrup").combobox('reload');
					$("#r_codeGrup").combobox('reload');
				}
			}
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			singleSelect: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			//행선택시 상세조회 이벤트 바인딩
			onSelect: this.easygrid.select,
			onLoadSuccess:function(){
				//Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item){
					var itemid = $("#"+item.id);
					itemid.textbox('textbox').bind('keyup', function(e){
						itemid.textbox('setValue', $(this).val());
					});
				});
				

				 
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
	
	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	//엑셀버튼 클릭시 이벤트 바인딩
	$("#excel-button").bind("click", doExcel);
	//리포트버튼 클릭시 이벤트 바인딩
	//$("#report-button-pdf").bind("click", doReport);
	//$("#report-button-xls").bind("click", doReport);
	//$("#report-button-htm").bind("click", doReport);
	
	//삭제버튼 클릭시 이벤트 바인딩
	$("#remove-button").bind("click", doRemove);
	//초기화버튼 클릭시 이벤트 바인딩
	//$("#clear-button").bind("click", doClear);
	//저장버튼 클릭시 이벤트 바인딩
	$("#save-button").bind("click", doSave);
	
	//Enter 검색을 위한 추가
	$("#search-form").bind('keydown',function(events){
		if(events.keyCode == 13){
			doSearch();
		}
	});
	doLangSettingTable();
	
	
});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//검색 처리
function doSearch() {
	doClear();
	consts.easygrid.search();
}
//엑셀 다운로드
function doExcel() {
	consts.easygrid.download();
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
//삭제 처리
function doRemove() {
	consts.easygrid.remove();
}
//저장 처리
function doSave() {
	consts.easygrid.save();
}

function doEnterKey(){
	
}