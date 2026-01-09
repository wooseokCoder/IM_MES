/**
 *  제목		: [기본정보관리]-[프로젝트관리]를 처리하는 스크립트
 *  작성자	: 박민혁
 *  날짜		: 2017-08-07
 */
var consts = {
	sysId : gconsts.SYS_ID, // 시스템ID (common.jsp)
	title : gconsts.TITLE, // 화면제목 (common.jsp)
	pageSize : gconsts.PAGE_SIZE, // 출력수 (common.jsp)
	easygrid : false, // 기본컨트롤
	url : {
		select: getUrl("/business/item/projectmanagement/select.json"),
		search : getUrl("/business/item/projectmanagement/search.json"),
		excel : getUrl("/business/item/projectmanagement/download.do"),
		remove : getUrl("/business/item/projectmanagement/delete.json"),
		save : getUrl("/business/item/projectmanagement/save.json"),
	},
	init : function() {

		// 기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url : this.url,
			url: {
				search: null,
				select: getUrl("/business/item/projectmanagement/select.json"),
				excel : getUrl("/business/item/projectmanagement/download.do"),
				remove : getUrl("/business/item/projectmanagement/delete.json"),
				save : getUrl("/business/item/projectmanagement/save.json")
			},

			// title: this.title, //20160921 김원국
			gridKey : "#search-grid",
			sformKey : "#search-form"
		});

		// 그리드 생성
		this.easygrid.init({
			fit : true,
			singleSelect : true,
			pageSize : this.pageSize,
			//toolbar : "#search-toolbar",
			idField: 'pjtNo',
			onResize : doResize_Single, // 2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect : true,
			//행선택시 상세조회 이벤트 바인딩
			//onSelect : this.easygrid.select,
			// 그리드 편집이벤트 바인딩
			onClickRow : doClickRow,
			onBeginEdit : doBeginEdit, //필수
			OnBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			//그리드 동적콤보를 위한 이벤트바인딩
			//onEndEdit   : doEndEdit,
			onSelect: this.easygrid.select,
			onLoadSuccess : function() {
				// Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item) {
					var itemid = $("#" + item.id);
					itemid.textbox('textbox').bind('keyup', function(e) {
						itemid.textbox('setValue', $(this).val());
					});
				});

				// 2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');

				//doLangSettingTable();
			}
		});

		// 등록폼 초기화
		doClear();
	}
};

/**
 * 모델 조회 처리 스크립트
 */
var modelSelect = new Array();
var consts_model = {
	sysId : gconsts.SYS_ID, // 시스템ID (common.jsp)
	title : gconsts.TITLE, // 화면제목 (common.jsp)
	pageSize : gconsts.PAGE_SIZE, // 출력수 (common.jsp)
	easygrid : false, // 기본컨트롤
	url : {
		search : getUrl("/business/item/projectmanagement/searchmodel.json")
	},
	init : function() {

		// 기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url :{search:null },
			// title: this.title, //20160921 김원국
			gridKey : "#search-model-grid",
			sformKey : "#search-model-form"
		});

		// 그리드 생성
		this.easygrid.init({
			fit : true,
			pageSize : this.pageSize,
			toolbar : "#search-model-toolbar",
			idField : 'modelNo',
			onResize : doResize_Single, // 2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect : true,
			// 그리드 편집이벤트 바인딩
			onClickRow : this.easygrid.clickRowEdit,
			onBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			onBeginEdit : doBeginEdit,
			onDblClickRow : function(index, row) {
				if($("#pModelType").val() == "0") {
					//$('#searchmodelNo').textbox('setValue', row.modelNo);
					$('#searchmodelName').textbox('setValue', row.modelName);
					$('#searchmodelSpec').textbox('setValue', row.modelSpec);
				} else {
					$('#r_modelNo').val(row.modelNo);
					$('#r_modelName').val(row.modelName);
					$('#r_modelSpec').val(row.modelSpec);
				}
				$("#model-search-dialog").dialog('close');
			},
			onLoadSuccess : function() {
				// Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item) {
					var itemid = $("#" + item.id);
					itemid.textbox('textbox').bind('keyup', function(e) {
						itemid.textbox('setValue', $(this).val());
					});
				});

				// 2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-item-grid").datagrid('unselectAll');
				$("#search-item-grid").datagrid('clearSelections');
				// //doLangSettingTable();
			}
		});
	}
};

$(function() {

	consts.init();

	$('#model-search-dialog').dialog({
		title : '모델조회',
		iconCls : 'icon-search',
		top : 10,
		width : 500,
		height : 463,
		closed : true,
		modal : true,
		resizable : true
	});

	$('#pdf-dialog').dialog({
	    title: tit.TITLE0029,
	    iconCls: 'icon-search',
	    top:     10,
	    bottom:  10,
	    width: 1024,
	    height: 730,
	    closed: true,
	    modal: true,
	    panel: true,
	    resizable: true
	});

	$('#print-dialog').dialog({
	    title: tit.TITLE0005,
	    iconCls: 'icon-search',
	    top:     10,
	    bottom:  10,
	    width: 260,
	    height: 212,
	    closed: true,
	    modal: true,
	    panel: true,
	    resizable: true
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

	consts_model.init(); // 모델조회

	setTimeout(function (){

		$(".wui-dialog").show();

		$("#account-layout").fadeIn(300);

		// 검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		// 추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		// 삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		// 저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
		// 엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);

		// 모델팝업
		$("#search-model-button").bind("click", doOpenModel);
		$("#search-model-button2").bind("click", doOpenModel2);
		// 모델조회
		$("#search-model-pop-button").bind('click', doSearchModel);
		// 모델조회
		$("#search-model-form").bind('keydown', function(events) {
			if (events.keyCode == 13) {
				doSearchModel();
			}
		});

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

		$("#searchPjtYear").combobox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
				doSearch();
		    }
		});
		$("#searchPjtGb").combobox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
				doSearch();
		    }
		});

	}, 100);

	doLangSettingTable();

});

// 화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}
// 에디트 시작
function doBeginEdit(rowIndex, rowData) {
	var editors = $('#search-grid').datagrid('getEditors', rowIndex);
}
// 검색 처리
function doSearch() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	doClear();
	consts.easygrid.search(consts.url.search);
}

// 추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	doClear();
	//consts.easygrid.appendEdit();
}
// 삭제 처리
function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	consts.easygrid.remove();
}
// 저장 처리
function doSave() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.save();
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

// 초기화 처리
function doClear() {
	consts.easygrid.clear();
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('clearSelections');
}
function doReload(){
	$("#searchPjtNo").textbox('setValue','');
	$("#searchModel").textbox('setValue','');
	$("#searchmodelName").textbox('setValue','');
	$("#searchmodelSpec").textbox('setValue','');
	$("#searchPjtYear").combobox('setValue','');
	$("#searchPjtGb").combobox('setValue','');
	$("#searchStafName").textbox('setValue','');
}

//행클릭이벤트
function doClickRow(index, row){
	consts.easygrid.clickRowEdit(index);
}

//모델 팝업
function doOpenModel() {
	$("#pModelType").val("0");
	$("#pModelName").textbox("setValue", "");
	$("#pModelSpec").textbox("setValue", "");

	modelSelect = [];
	$("#model-search-dialog").dialog('center');
	$("#model-search-dialog").dialog('open');
}
function doOpenModel2() {
	$("#pModelType").val("1");
	$("#pModelName").textbox("setValue", "");
	$("#pModelSpec").textbox("setValue", "");

	modelSelect = [];
	$("#model-search-dialog").dialog('center');
	$("#model-search-dialog").dialog('open');
}
// 모델조회
function doSearchModel() {
	consts_model.easygrid.search(consts_model.url.search);
}

function doEndEdit(index, row) {
	for(var i=0; i < row.length; i++ ){
		$('#search-grid').datagrid('endEdit',i);
	}
}