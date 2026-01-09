/**
 * 사용자관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 팝업 상세조회
 * 폼 팝업 등록,수정,삭제
 */
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	admin:    gconsts.ADMIN,     //관리자  (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	domain:   false,   //사용자로그인용 도메인
	easygrid: false,   //기본컨트롤
	dialog:   false,   //팝업다이얼로그 컨트롤
/*	cellEdit: true,
	viewrecords: true,
	forceFit : true,*/
	url: {
		search: getUrl("/common/board/management/search.json"),
		excel:  getUrl("/common/board/management/download.do"),
		save:   getUrl("/common/board/management/save.json")
	},
	init: function() {
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url: {
				search: null,
				excel:  getUrl("/common/board/management/download.do"),
				save:   getUrl("/common/board/management/save.json")
			},
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form",
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'bordNo',
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			//그리드 편집이벤트 바인딩
			onClickRow:   this.easygrid.clickRowEditCustom, //clickRowEdit -> clickRowEditCustom 으로 변경
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			singleSelect: true,
			onLoadSuccess:function(){
				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('uncheckAll');
				$("#search-grid").datagrid('clearChecked');
				doLangSettingTable();
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

		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
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

	}, 100);

	doLangSettingTable();

});

//화면 상수값 초기화
function doInit(args) {
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('uncheckAll');
	$('#hdfIndex').val("-1");
	$('#hdfChk').val("");
	if (args) {
		$.extend(consts, args);
	}
}

//검색 처리
function doSearch() {
	consts.easygrid.search(consts.url.search);
}
//초기화 처리
function doClear() {
	consts.easygrid.clear();
}
//삭제 처리
function doRemove() {
	consts.easygrid.removeEdit();
}
//저장 처리
function doSave() {
	if(doubleSubmitCheck()){
		consts.easygrid.saveEdit();
	}
}

//중복 submit 방지
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


//[행클릭] 행클릭 이벤트
function doSelectRow(rowIndex, rowData){
	//console.log($(this).datagrid('getChecked'));
	if($('#hdfChk').val().indexOf(+"**"+rowIndex+", ") == -1){
		if($('#hdfIndex').val() == rowIndex){
			//$(this).datagrid('unselectRow', rowIndex);
			//$(this).css("background-color", "#FFF");
			//$(this).datagrid('unselectRow', rowIndex);
			//console.log("row=index");
			//console.log("old");
			//console.log(this);
		}else{
			//$(this).datagrid('unselectRow', $('#hdfIndex').val());
			//$("#search-grid").datagrid('selectRow', rowIndex);
			//$(this).css("background-color", "#F6D8CE");
			if($('#hdfIndex').val() != "-1"){
				$(this).datagrid('unselectRow', $('#hdfIndex').val());
			}
			$('#hdfIndex').val(rowIndex);
			//console.log("row<>index");
			//var chkRow = $(this).datagrid('getChecked');
			//var chkId = "";
			/*for(var j = 0; j <= chkRow.length; j++){
				chkId += chkRow[j]['userId'];
			}*/

			//console.log(chkRow);
			//console.log(chkRow[0]['userId']);
			//$(this).datagrid('selectRow', rowIndex);
			//console.log("new");
			//console.log(this);
		}
	}else{
		$(this).datagrid('unselectRow', $('#hdfIndex').val());
		$('#hdfIndex').val("-1");
		//console.log("check row click");
	}
	//consts.easygrid.clickRowEdit();
	//console.log(rowData);
	//console.log(rowIndex);
}
//체크박스 클릭 이벤트
function doCheckRow(rowIndex, rowData){
	var chkRow = $('#hdfChk').val();
	chkRow += "**" + rowIndex + ", ";
	$('#hdfChk').val(chkRow);
	/*if($('#hdfChk').val().indexOf(rowIndex) == -1){
		if(rowIndex != $('#hdfIndex').val()){
			$(this).datagrid('unselectRow', $('#hdfIndex').val());
			$('#hdfIndex').val("-1");
		}
	}*/
	//console.log("check in");
}
//체크박스 해제 이벤트
function doUnCheckRow(rowIndex, rowData){
	$("#search-grid").datagrid('unselectRow', rowIndex);
	var chkRow = $('#hdfChk').val();
	chkRow = chkRow.replace("**" + rowIndex + ", ", "");
	$('#hdfChk').val(chkRow);
	$('#hdfIndex').val("-1");
	//console.log("check out");
}
//체크박스 전체 선택 이벤트
function doCheckAll(rowIndex, rowData){
	var rowCnt = $(this).datagrid('getRows').length;
	var rows = "";
	for(var i = 0; i < rowCnt; i++){
		rows += "**" + i + ", ";
	}
	$('#hdfChk').val(rows);
	//console.log("check all in");
}
//체크박스 전체 해제 이벤트
function doUnCheckAll(rowIndex, rowData){
	$("#search-grid").datagrid('unselectAll');
	$('#hdfChk').val("");
	$('#hdfIndex').val("-1");
	//console.log("check all out");
}


//사용자유형값 포맷처리 (코드대신 명칭표시)
jformat.userType = function(val, row) {
	//사용자 유형칼럼의 콤보텍스트 표시
	if (jutils.empty(row.userTypeDesc))
		return val;
	return row.userTypeDesc;
};

//검색영역 코드그룹 변경 이벤트
function doGrupChange(newValue,oldValue){
	doSearch();
}
