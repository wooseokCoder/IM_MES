/**
 *  제목		: [기본정보관리]-[마감관리]를 처리하는 스크립트
 *  작성자	: 김연주
 *  날짜		: 2017-03-23
 */


//초기 선언해 주는 부분
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/business/company/closemanagement/search.json"),
		remove: getUrl("/business/company/closemanagement/delete.json"),
		save:   getUrl("/business/company/closemanagement/save.json"),
		excel:  getUrl("/business/company/closemanagement/download.do"),
		report: getUrl("/common/report/code.")
	},
	combo: {
		
		closeYear : new jcombobox({
			params : {
				codeGrup : 'CLOSE_YEAR'
			}
		}),
		closeMonth : new jcombobox({
			params : {
				codeGrup : 'CLOSE_MONTH'
			}
		}),
		closeYN : new jcombobox({
			params : {
				codeGrup : 'CLOSE_YN'
			}
		})
	},
	init: function() {
		this.combo.closeYear.load();
		this.combo.closeMonth.load();
		this.combo.closeYN.load();


		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				remove: getUrl("/business/company/closemanagement/delete.json"),
				save:   getUrl("/business/company/closemanagement/save.json"),
				excel:  getUrl("/business/company/closemanagement/download.do"),
				report: getUrl("/common/report/code.")
			},
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			singleSelect: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			/*idField:  'closeYN',*/
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			//행선택시 상세조회 이벤트 바인딩
			//onSelect: this.easygrid.select,
			singleSelect: true,
			//그리드 편집이벤트 바인딩
			onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			onBeginEdit: doBeginEdit,
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

});

$(window).load(function() {

	setTimeout(function (){
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

		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

		$("#closedYear").combobox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
				doSearch();
		    }
		});

		// 정렬기능 기본 셋팅
		var sortContentParame = [{"sortText":"마감년도","sortValue":"YEAR"}
	      ,{"sortText":"마감월","sortValue":"MONTH"}
		  ,{"sortText":"마감구분","sortValue":"closeYN"}
		  ];
		jSortInit(sortContentParame);

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
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	//consts.easygrid.search();

	consts.easygrid.search(consts.url.search);
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
	consts.easygrid.saveEditCustom();
}

function doReload(){

		$("#closedYear").combobox('setValue','');

	}


function monthValChk(){
	var cnt = 0;
	var row = $('#search-grid').datagrid('getRows');

	for(var i=0; i < row.length; i++){
		if(row[i].month < 0 || row[i].month > 12 ) cnt++;
	}
	if(cnt == 0) return true;
	else return false;
}


function duplicateChk(){

	var cnt = 0;
	var row = $('#search-grid').datagrid('getRows');
	for(var i=0; i < row.length; i++){
		for(var j=0; j < row.length; j++){
			if(i != j){
				if(row[i].year == row[j].year && row[i].month == row[j].month) cnt++;
			}
		}
	}
	if(cnt == 0) return true;
	else return false;
}

function doEnterKey(){

}

//검색영역 코드그룹 변경 이벤트
function doGrupChange(newValue,oldValue){
	doSearch();
}



