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
		search: getUrl("/common/code/search.json")
	},
	init: function() {
		
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url:      this.url,
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
			onDblClickRow: doDblClickRow, //그리드 더블클릭시 이벤트 바인딩
			//그리드 편집이벤트 바인딩
			onLoadSuccess:function(){
				//Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item){
					var itemid = $("#"+item.id);
					itemid.textbox('textbox').bind('keyup', function(e){
						itemid.textbox('setValue', $(this).val());
					});
				});
				doLangSettingTable();

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
	
	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	
	//Enter 검색을 위한 추가
	$("#search-form").bind('keydown',function(events){
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keyup', function(e){
				itemid.textbox('setValue', $(this).val());
			});
		});
		if(events.keyCode == 13){
			doSearch();
		}
	});

});

//화면 상수값 초기화
function doInit(args) {
	$('#button-addr').bind("click", function(){
		$("#address-popup").dialog('open');
	});
	
	if (args) {
		$.extend(consts, args);
	}
}

//검색 처리
function doSearch() {
	consts.easygrid.search();
}
//초기화 처리
function doClear() {
	consts.easygrid.clear();
}

function doEnterKey(){
	
}

//검색영역 코드그룹 변경 이벤트
function doGrupChange(newValue,oldValue){
	doSearch();
}

//그리드 더블클릭시 이벤트 바인딩
function doDblClickRow(idx, row) {
	if (!row)
		return;
	
	//
	
	var params = {};
	var reportUrl = "";
	$.ajax({
        url: getUrl('/common/report/reportUrl.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: params,
        success: function(data){
        	//
        	if (!data)
        		return;
        	
        	reportUrl = data.reportUrl + "&reportUnit=/reports/easyFrame/reportView"
			  + "&P_SYS_ID=" + data.sysId
			  + "&P_CODE_GRUP=" + row.codeGrup
			  + "&P_CODE_CD=" + row.codeCd;
        },
        error: function(){
        }
    });
	
	document.getElementById("report-iframe").src = reportUrl;
	$("#report-popup").dialog('open');
}