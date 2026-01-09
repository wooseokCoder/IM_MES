/**
 * 게시판관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 팝업 상세조회
 * 폼 팝업 등록,수정,삭제
 */

//화면 컨트롤 객체
var consts = {};
//그리드 설정
var jgrid  = {};

$(function() {

	using("../../js/module/jupload.js", function() {
		using("../../js/module/jeditor.js", function() {
			using("../../js/module/jboard.js", function() {
				consts.init();
			});
		});
	});

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
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click",  doExcel);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

	}, 100);

	doLangSettingTable();

});

//그리드 설정
jgrid = {
	grid: false,
	//args.params   필수
	//args.title    필수
	//args.pageSize 필수
	//args.doSelect 필수
	init: function(args) {
		//2016/12/20 김영진 -- 메일 삭제기능 추가
		var cols = [{field:'check',    halign:'center',align:'center',checkbox:true},
		            {field:'bordTitle',halign:'center',align:'left',  width:400, title:'제목', data_item:'GRD_001', sortable:true},
		            {field:'regiId',   halign:'center',align:'left',  width:180, title:'보낸사람', data_item:'GRD_002'},
		            {field:'fileCnt',  halign:'center',align:'center',width: 80, title:'첨부파일', data_item:'GRD_003', formatter:jformat.filecnt}, //2016/12/22 김영진 -- 파일첨부 이미지
		            {field:'regiDate', halign:'center',align:'center',width:130, title:'발송일자', data_item:'GRD_004'},
		            {field:'bordNo',   halign:'center',align:'center',width:130, title:'메일번호', data_item:'GRD_005'},
		            {field:'mailType', halign:'center',align:'center',width:130, title:'메일타입', data_item:'GRD_006'}];

		//그리드 컨트롤 초기화
		this.grid = new jeasygrid({
			url:      args.url,
			//title:    args.title,
			gridKey:  "#search-grid",
			sformKey: "#search-form",
			gridOptions: {
				pageSize:     args.pageSize,
				queryParams:  $.extend({}, args.params),
				columns:      [cols],
				toolbar:      "#search-toolbar",
				onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
				idField:      'bordNo',
				fit:          true,
				selectOnCheck:true,
				checkOnSelect: false,//TODO 김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
				onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
				onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
				onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
				onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트
				onSelect: doSelectRow, //2016/09/19 김영진 수정 --행 클릭 이벤트
				//그리드 행더블클릭시 상세조회팝업 오픈
				onDblClickRow:function(index, row) {
					args.doSelect(row);

					adjustCheck();

				},
				onLoadSuccess:function(){
					//Enter 검색을 위한 추가
					$(".easyui-textbox").each(function(index, item){
						var itemid = $("#"+item.id);
						itemid.textbox('textbox').bind('keyup', function(e){
							itemid.textbox('setValue', $(this).val());
						});
					});
					//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
					$("#search-grid").datagrid('uncheckAll');
					$("#search-grid").datagrid('clearChecked');
				}
			}
		});

		$('#search-grid').datagrid('hideColumn', 'bordNo');
		$('#search-grid').datagrid('hideColumn', 'mailType');
	},
	search: function() {
		this.grid.search();
	},
	download: function() {
		this.grid.download();
	},
	remove: function() {
		this.grid.removeAll();
	},
	result: function(res, callback) {
		this.grid.reload();
		if (callback)
			callback();
	}
};

//화면컨트롤
consts = {
	sysId: false,    //시스템ID
	title: false,    //제목
	pageSize: false, //출력수
	bordGrup: false, //게시판그룹
	bordType: false, //게시판게시타입
	url: {
		search: getUrl("/common/mail/internalList/search.json"),
		excel:  getUrl("/common/mail/download3.do"),
		select: getUrl("/common/mail/select.json"),
		remove: getUrl("/common/mail/delete2.json"),
		view:   getUrl("/common/mail/mailview2.do")
	},
	params: {
		oper: jstatus.INSERT,
		sysId:    null,
		bordGrup: null,
		bordType: null,
		bordNo:   null
	},
	init: function() {
		//그리드 초기화
		jgrid.init(this);
		//팝업폼 초기화
		jsystemboard.init(this);

	},
	//등록상태로 변경(params 변경)
	setInsert: function() {
		this.params.oper  = jstatus.INSERT;
		this.params.bordNo = null;
	},
	//수정상태로 변경(params 변경)
	setUpdate: function() {

		this.params.oper  = jstatus.UPDATE;
	},
	setParams: function(args) {
		for(var p in args) {
			this.params[p] = args[p];
		}
	},
	getParams: function() {
		return this.params;
	},
	getTitle: function() {
		return this.title;
	},
	doResult: function(res, callback) {
		jgrid.result(res, callback);
	},
	doSelect: function(row) {
		$.extend(this.params, row);
		jsystemboard.open(jstatus.READ);
	},
	doUpdate: function(row) {
		$.extend(this.params, row);
		jsystemboard.open(jstatus.UPDATE);
	}
};

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);

		consts.setParams({
			sysId:    consts.sysId,
			bordGrup: consts.bordGrup,
			bordType: consts.bordType
		});
	}
}
//검색버튼 클릭시 그리드 검색
function doSearch() {
	jgrid.search();
}
/*//엑셀 다운로드
function doExcel() {
	jgrid.download();
}*/



//엑셀 다운로드
function doExcel() {
	   $('#progress-popup').dialog('open');

	   jgrid.download();

	   $(document).ready(function() {
	       $(window).blur(function() {
	          $('#progress-popup').dialog('close');
	       });
	   });
}

//삭제버튼 클릭시 그리드 다중행삭제
function doRemove() {
	jgrid.remove();
}
//[행클릭] 행클릭 이벤트
function doSelectRow(rowIndex, rowData){
	if($('#hdfChk').val().indexOf(+"**"+rowIndex+", ") == -1){
		if($('#hdfIndex').val() == rowIndex){
		}else{
			if($('#hdfIndex').val() != "-1"){
				$(this).datagrid('unselectRow', $('#hdfIndex').val());
			}
			$('#hdfIndex').val(rowIndex);
		}
	}else{
		$(this).datagrid('unselectRow', $('#hdfIndex').val());
		$('#hdfIndex').val("-1");
	}
}
//체크박스 클릭 이벤트
function doCheckRow(rowIndex, rowData){
	var chkRow = $('#hdfChk').val();
	chkRow += "**" + rowIndex + ", ";
	$('#hdfChk').val(chkRow);
}
//체크박스 해제 이벤트
function doUnCheckRow(rowIndex, rowData){
	$("#search-grid").datagrid('unselectRow', rowIndex);
	var chkRow = $('#hdfChk').val();
	chkRow = chkRow.replace("**" + rowIndex + ", ", "");
	$('#hdfChk').val(chkRow);
	$('#hdfIndex').val("-1");
}
//체크박스 전체 선택 이벤트
function doCheckAll(rowIndex, rowData){
	var rowCnt = $(this).datagrid('getRows').length;
	var rows = "";
	for(var i = 0; i < rowCnt; i++){
		rows += "**" + i + ", ";
	}
	$('#hdfChk').val(rows);
}
//체크박스 전체 해제 이벤트
function doUnCheckAll(rowIndex, rowData){
	$("#search-grid").datagrid('unselectAll');
	$('#hdfChk').val("");
	$('#hdfIndex').val("-1");
}

function adjustCheck(){

	if(window.innerWidth<1400){
		//regist-dialog2\
		//alert("call")
			$(".window #select-dialog").css("height",390);
			$("#select-dialog #select-form fieldset").css("height",370);
			$(".window-shadow").css("height",390);
			$("#select-dialog #select-form fieldset").css("overflow-y","scroll");
			$("#select-dialog #select-form fieldset").css("overflow-x","hidden");
			$(".window").addClass("forcedLeft");
			$(".window-shadow").addClass("forcedLeft");
	 }

}