/**
 *  제목		: [유틸리티]-[전화번호부]를 처리하는 스크립트
 *  작성자	: 김연주
 *  날짜		: 2017-03-14
 */

//초기 선언해 주는 부분
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/business/company/phonebook/search.json"),
		remove: getUrl("/business/company/phonebook/delete.json"),
		save:   getUrl("/business/company/phonebook/save.json"),
		excel:  getUrl("/business/company/phonebook/download.do"),
		report: getUrl("/common/report/code.")
	},
	combo: {
		stafDept : new jcombobox({
			params : {
				codeGrup : 'DEPT_CODE'
			}
		}),
	},
	init: function() {
		this.combo.stafDept.load();
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				remove: getUrl("/business/company/phonebook/delete.json"),
				save:   getUrl("/business/company/phonebook/save.json"),
				excel:  getUrl("/business/company/phonebook/download.do"),
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
			idField:  'SEQ',
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

		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

		// 정렬기능 기본 셋팅
		var sortContentParame = [{"sortText":"CODE","sortValue":"SEQ"}
	      ,{"sortText":"거래처명","sortValue":"CUST_NAME"}
	/*	  ,{"sortText":"전화번호","sortValue":"CUST_TEL"}
		  ,{"sortText":"FAX","sortValue":"CUST_FAX"}
		  ,{"sortText":"HP","sortValue":"CUST_HP"}
		  ,{"sortText":"참고사항","sortValue":"REMARK"}*/
		  ,{"sortText":"입력부서","sortValue":"STAF_DEPT"}
		  ,{"sortText":"입력담당","sortValue":"REGI_ID"}
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
	consts.easygrid.saveEditCustom(); // consts.easygrid.save() -> consts.easygrid.saveEditCustom() 변경 김원국
}

//초기화
function doReload(){

	$("#searchCustName").textbox('setValue','');
	$("#searchStafDept").combobox('setValue','');
	$("#searchRegiId").textbox('setValue','');
}

function doEnterKey(){

}

//검색영역 코드그룹 변경 이벤트
function doGrupChange(newValue,oldValue){
	doSearch();
}



