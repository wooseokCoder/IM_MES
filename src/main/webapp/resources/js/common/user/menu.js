/**
 * 메뉴관리를 처리하는 스크립트이다.
 *
 * 그리드 검색
 * 그리드 다중 편집
 * 그리드 다중 저장
 */
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	easygrid: false, //기본컨트롤
	combo: {
		procType: new jcombobox({params:{codeGrup: 'MENU_TYPE'}}),
		mobileType: new jcombobox({params:{codeGrup: 'MOBILE_TYPE'}})
	},
	url: {
		search: getUrl("/common/user/menu/search.json"),
		excel:  getUrl("/common/user/menu/download.do"),
		save:   getUrl("/common/user/menu/save.json")
	},
	init: function() {

		//콤보로딩
		this.combo.procType.load();
		this.combo.mobileType.load();

		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				excel:  getUrl("/common/user/menu/download.do"),
				save:   getUrl("/common/user/menu/save.json")
			},
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'menuKey',
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect: true,
			//그리드 편집이벤트 바인딩
			onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			onLoadSuccess:function(){
				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			}
		});

	}
};

//매출 등록 그리드 단가 팝업
var menu_popup = {
	sysId : gconsts.SYS_ID, //시스템ID (common.jsp)
	title : gconsts.TITLE, //화면제목 (common.jsp)
	pageSize : gconsts.PAGE_SIZE, //출력수  (common.jsp)
	easygrid : false, //기본컨트롤
	url : {
		search : getUrl("/common/user/menu/searchType.json"),
	},
	init : function() {

		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url : this.url,
			url: {search: null},
			gridKey : "#search-menu-grid",
			sformKey : "#search-menu-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit : true,
			pagination : false,
			pageSize : this.pageSize,
			toolbar : "#search-menu-toolbar",
			//idField : 'detailCode',
			onResize : doResize_Single,
			selectOnCheck:true,
			checkOnSelect: false,//김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
			onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
			onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
			onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
			onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트
			onLoadSuccess : function() {
				//오픈시 스크롤 내림 차단
				$("#search-menu-dialog").dialog('open');
				//Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item) {
					var itemid = $("#" + item.id);
					itemid.textbox('textbox').bind('keyup', function(e) {
						itemid.textbox('setValue', $(this).val());
					});
				});
			}
		});
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

	menu_popup.init();		//거래처 판매단가

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
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button"  ).bind("click", doSave);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);


//		$('#search-grid').datagrid('getPanel').panel('panel').attr('tabindex',1).bind('keydown',function(e){
//			var selectedrow = $('#search-grid').datagrid('getSelected');
//		    var rowIndex = $('#search-grid').datagrid("getRowIndex", selectedrow);
//		    var rowMaxlength = $('#search-grid').datagrid('getRows');
//			if(event.keyCode == 38){
//				if(!(rowIndex == 0)){
//					$('#search-grid').datagrid('selectRow',rowIndex - 1);
//				}
//			}else if(event.keyCode == 40){
//				if(!(rowIndex == rowMaxlength.length - 1)){
//					$('#search-grid').datagrid('selectRow',rowIndex + 1);
//				}
//			}
//		});	//end keydown

		//Enter 검색을 위한 추가
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keyup', function(e){
				itemid.textbox('setValue', $(this).val());
			});
		});

		//Enter 검색을 위한 추가
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

	}, 100);

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
	if(doubleSubmitCheck()){
		if($('#'+this.id).hasClass('l-btn-disabled')){
		      return false;
		   }
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
//초기화
function doReload(){
	$("#menuDesc").textbox('setValue','');
	$("#menuUrl").textbox('setValue','');
	$("#parentKey").textbox('setValue','');

}
function formatCheck(value,row,index){
	var d;
	if(value == '1' || value == 'Y' ) d = '<input type="checkbox" checked/>';
	else d = '<input type="checkbox" />';
	return d;
}

//등록 그리드 단가 팝업
function doOpenPopup( callback ) {
	var selectedRow = $('#search-grid').datagrid('getSelected');
	$("#menuType").val(selectedRow.itemCode);

	menu_popup.easygrid.search(menu_popup.url.search);

	var elm = $("#search-menu-dialog");

	// HTML 상에 해당 DOM 객체가 없을경우 경고메세지 처리
	if (elm.length == 0) {
       $.messager.alert('Warning',msg.MSG0116,'warning');
       return false;
	}

	// 팝업을 오픈한다.
	elm.dialog({
	    title: tit.TITLE0030,
	    width:  300,
	    height: 400,
	    closed: false,
	    cache:  false,
	    modal:  true,
	    buttons:[{
	    	text:'Ok',
			handler:function() {
				// 팝업내 선택그리드 가져오기
				var selectGrid = $("#search-menu-grid").datagrid('getChecked');

				var selVal = [];

				for(var j = 0; j < selectGrid.length; j++){
					selVal.push(selectGrid[j]['menuType']);
				}

				// 선택값셋팅 콜백함수 호출
				callback({
					value: selVal
				});

				// 팝업닫기
				elm.dialog('close');
				return true;
			}
		},{
			text:'Cancel',
			handler:function(){
				// 팝업닫기
				elm.dialog('close');
			}
		}]
	});
};

//체크박스 클릭 이벤트
function doCheckRow(rowIndex, rowData){
	var chkRow = $('#hdfChk').val();
	chkRow += "**" + rowIndex + ", ";
	$('#hdfChk').val(chkRow);
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
//체크박스 해제 이벤트
function doUnCheckRow(rowIndex, rowData){
	$("#search-menu-grid").datagrid('unselectRow', rowIndex);
	var chkRow = $('#hdfChk').val();
	chkRow = chkRow.replace("**" + rowIndex + ", ", "");
	$('#hdfChk').val(chkRow);
	$('#hdfIndex').val("-1");
}
//체크박스 전체 해제 이벤트
function doUnCheckAll(rowIndex, rowData){
	$("#search-menu-grid").datagrid('unselectAll');
	$('#hdfChk').val("");
	$('#hdfIndex').val("-1");
}