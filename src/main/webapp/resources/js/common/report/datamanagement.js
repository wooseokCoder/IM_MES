/**
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
	combo: {
		userType: new jcombobox({params:{codeGrup: 'USER_TYPE'}}),
		permissionControl: new jcombobox({params:{codeGrup: 'PERMISSION_CONTROL'}}),
		useYn: new jcombobox({params:{codeGrup: 'USE_FLAG'}})
	},
	url: {
		search: getUrl("/common/report/datamanagement/search.json"),
		excel:  getUrl("/common/report/datamanagement/download.do"),
		remove: getUrl("/common/report/datamanagement/delete.json"),
		save:   getUrl("/common/report/datamanagement/save.json")
	},
	init: function() {
		this.combo.userType.load();
		this.combo.permissionControl.load();
		this.combo.useYn.load();
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				excel:  getUrl("/common/report/datamanagement/download.do"),
				remove: getUrl("/common/report/datamanagement/delete.json"),
				save:   getUrl("/common/report/datamanagement/save.json")
			},
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form",
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.PAGE_SIZE,
			toolbar:  null,
			idField:  'jobNo',
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect: false,
			pagination: false,
			//striped: true,
			selectOnCheck: true,
			checkOnSelect: false,//TODO 김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
			onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
			onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
			onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
			onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트
			onSelect: doSelectRow, //2016/09/19 김영진 수정 --행 클릭 이벤트
			onClickRow:  function(rowIndex){
				$("#parentRowIndex").val(rowIndex);
				consts.easygrid.clickRowEditCustom(rowIndex);
		    },
		    onAfterEdit : this.easygrid.afterEdit,
			onLoadSuccess:function(data){
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
		});
	}
};

var consts_sub = {
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
			search: getUrl("/common/report/datamanagement/searchDetl.json"),
		},
		init: function() {
			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				//url:      this.url,
				url: {
					search: null
				},
				//title:    this.title, //20160921 김원국
				gridKey:  "#search-sub-grid",
				sformKey: "#search-sub-form",
			});

			//그리드 생성
			this.easygrid.init({
				fit: true,
				pageSize: this.pageSize,
				toolbar:  "#search-sub-toolbar",
				idField:  'jobNo',
				onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
				singleSelect: true,
				pagination: false,
				onAfterEdit : this.easygrid.afterEdit,
				onClickRow:  function(rowIndex){
					consts_sub.easygrid.clickRowEditCustom(rowIndex);
			    },
				onLoadSuccess:function(){

				}
			});
		}
	};

var group_popup = {
		sysId : gconsts.SYS_ID, //시스템ID (common.jsp)
		title : gconsts.TITLE, //화면제목 (common.jsp)
		pageSize : gconsts.PAGE_SIZE, //출력수  (common.jsp)
		easygrid : false, //기본컨트롤
		url : {
			search : getUrl("/common/report/datamanagement/group.json"),
		},
		init : function() {

			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				//url : this.url,
				url: {search: getUrl("/common/report/datamanagement/group.json")},
				gridKey : "#group-grid",
				sformKey: "#group-form",
			});

			//그리드 생성
			this.easygrid.init({
				fit : true,
				pagination : false,
				pageSize : this.pageSize,
				//idField : 'detailCode',
				onResize : doResize_Single,
				selectOnCheck:true,
				pagination: false,
				checkOnSelect: false,//김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
				onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
				onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
				onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
				onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트
				onLoadSuccess : function() {
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

var groupTargetIndex;
var groupTarget_popup = {
		sysId : gconsts.SYS_ID, //시스템ID (common.jsp)
		title : gconsts.TITLE, //화면제목 (common.jsp)
		pageSize : gconsts.PAGE_SIZE, //출력수  (common.jsp)
		easygrid : false, //기본컨트롤
		url : {
			search : getUrl("/common/report/datamanagement/groupTarget.json"),
		},
		init : function() {

			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				//url : this.url,
				url: {search: getUrl("/common/report/datamanagement/groupTarget.json")},
				gridKey : "#group-target-grid",
				sformKey: "#group-target-form",
			});

			//그리드 생성
			this.easygrid.init({
				fit : true,
				pagination : false,
				pageSize : this.pageSize,
				//idField : 'detailCode',
				onResize : doResize_Single,
				singleSelect: true,
				onClickRow:  function(rowIndex){
					groupTargetIndex = rowIndex;
			    },
				onLoadSuccess : function() {
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

var userId_popup = {
		sysId : gconsts.SYS_ID, //시스템ID (common.jsp)
		title : gconsts.TITLE, //화면제목 (common.jsp)
		pageSize : gconsts.PAGE_SIZE, //출력수  (common.jsp)
		easygrid : false, //기본컨트롤
		url : {
			search : getUrl("/common/report/datamanagement/userId.json"),
		},
		init : function() {

			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				//url : this.url,
				url: {search: getUrl("/common/report/datamanagement/userId.json")},
				gridKey : "#user-id-grid",
				sformKey: "#user-id-form",
			});

			//그리드 생성
			this.easygrid.init({
				fit : true,
				pagination : false,
				pageSize : this.pageSize,
				//idField : 'detailCode',
				onResize : doResize_Single,
				selectOnCheck:true,
				checkOnSelect: false,//김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
				onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
				onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
				onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
				onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트
				onLoadSuccess : function() {
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

var userIdTargetIndex;
var userIdTarget_popup = {
		sysId : gconsts.SYS_ID, //시스템ID (common.jsp)
		title : gconsts.TITLE, //화면제목 (common.jsp)
		pageSize : gconsts.PAGE_SIZE, //출력수  (common.jsp)
		easygrid : false, //기본컨트롤
		url : {
			search : getUrl("/common/report/datamanagement/userIdTarget.json"),
		},
		init : function() {

			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				//url : this.url,
				url: {search: getUrl("/common/report/datamanagement/userIdTarget.json")},
				gridKey : "#user-id-target-grid",
				sformKey: "#user-id-target-form",
			});

			//그리드 생성
			this.easygrid.init({
				fit : true,
				pagination : false,
				pageSize : this.pageSize,
				//idField : 'detailCode',
				onResize : doResize_Single,
				singleSelect: true,
				onClickRow:  function(rowIndex){
					userIdTargetIndex = rowIndex;
			    },
				onLoadSuccess : function() {
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
	consts_sub.init();

	$('#user-type-dialog').dialog({
		 closed: true
	   });

	$('#group-dialog').dialog({
		 closed: true
	   });

	$('#user-id-dialog').dialog({
	       closed: true
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

	group_popup.init();
	groupTarget_popup.init();

	userId_popup.init();
	userIdTarget_popup.init();

	setTimeout(function (){

		$(".wui-dialog").show();

		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);

		//추가버튼 클릭시 이벤트 바인딩
		$("#append-detl-button").bind("click", doAppendDetl);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-detl-button").bind("click", doSaveDetl);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-detl-button").bind("click", doRemoveDetl);

		//저장버튼 클릭시 이벤트 바인딩
		$("#save-sql-button").bind("click", doSaveSql);

		//취소버튼(팝업) 클릭시 이벤트 바인딩
		$("#cancel-button").bind("click", doClose);

		//권한그룹팝업 right button
		$("#group_right_arow").bind("click", doGroupRight);
		//권한그룹팝업 left button
		$("#group_left_arow").bind("click", doGroupLeft);

		//사용자팝업 right button
		$("#userId_right_arow").bind("click", doUserIdRight);
		//사용자팝업 left button
		$("#userId_left_arow").bind("click", doUserIdLeft);

		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

		$("#s_exitYn").combobox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
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
	//consts.easygrid.search();

	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	$('#search-sub-grid').datagrid('loadData', []);

	$('#cSql').val('');

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
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('uncheckAll');
	$('#hdfIndex').val("-1");
	$('#hdfChk').val("");
}
//삭제 처리
function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.removeCheckAll();
}
function doRemoveDetl() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts_sub.easygrid.removeCheckAll();
}
//저장 처리
function doSave() {
	if(doubleSubmitCheck()){
		if($('#'+this.id).hasClass('l-btn-disabled')){
		      return false;
		   }
	
		var cgridRow = $('#search-grid').datagrid('getRows');
		if(cgridRow.length  <= 0){
			$.messager.alert('Warning',msg.MSG0121,'warning');
			return;
		}
	
		for(var i=0; i < cgridRow.length; i++ ){
			$('#search-grid').datagrid('endEdit',i);
		}
	
		var row = $('#search-grid').datagrid('getChanges');
	
		$.ajax({
	        url: getUrl('/common/report/datamanagement/save.json'),
	        dataType: 'json',
	        async: false,
	        type: 'post',
	        data: {rows:JSON.stringify(row)},
	        success: function(data){
	        	$.messager.show({
					title: msg.MSG0122,
					msg: msg.MSG0120
				});
	
				doSearch();
	        },
	        error: function(){
	
	        }
	    });
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
//TODO
function doSaveDetl() {
		if(doubleSubmitCheck()){
		if($('#'+this.id).hasClass('l-btn-disabled')){
		      return false;
		   }
	
		var cgridRow = $('#search-sub-grid').datagrid('getRows');
		if(cgridRow.length  <= 0){
			$.messager.alert('Warning',msg.MSG0121,'warning');
			return;
		}
	
		for(var i=0; i < cgridRow.length; i++ ){
			$('#search-sub-grid').datagrid('endEdit',i);
		}
	
		var row = $('#search-sub-grid').datagrid('getChanges');
	
		$.ajax({
	        url: getUrl('/common/report/datamanagement/saveDetl.json'),
	        dataType: 'json',
	        async: false,
	        type: 'post',
	        data: {rows:JSON.stringify(row)},
	        success: function(data){
	        	$.messager.show({
					title: msg.MSG0122,
					msg: msg.MSG0120
				});
	
				doSearch();
	        },
	        error: function(){
	
	        }
	    });
	}
}
//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.appendEdit();
}
function doAppendDetl() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	var param = {
			jobNo:$("#jobNo").val()
	};

	consts_sub.easygrid.appendEdit(param);
}

//초기화
function doReload(){
	$("#searchJobNo").textbox('setValue','');
	$("#searchDesc").textbox('setValue','');
}

//취소 처리
function doClose() {
	$("#imgCompMark").attr("src", "");
	$("#imgCompMark").hide();
	$(".imgCompMark").show();
	consts.dialog.close();
}

//[행클릭] 행클릭 이벤트
function doSelectRow(rowIndex, rowData){
	if($('#hdfChk').val().indexOf("**"+rowIndex+", ") == -1){
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

	$("#jobNo").val(rowData.jobNo);
	$("#cSql").val(rowData.jobSql);

	$("#search-sub-grid").datagrid('unselectAll');
	$("#search-sub-grid").datagrid('uncheckAll');

//	$("#search-sub-grid").datagrid('uncheckAll');
//	$("#search-sub-grid").datagrid('clearChecked');

	consts_sub.easygrid.search(consts_sub.url.search);

}

function doSaveSql() {
	if(doubleSubmitCheck()){
		$.ajax({
		      url: getUrl('/common/report/datamanagement/saveSql.json'),
		      dataType: 'json',
		      async: false,
		      type: 'post',
		      data: {jobNo:$("#jobNo").val()
		     	 	   ,jobSql:$("#cSql").val()
		      	 },
		      success: function(data){
	
					$.messager.show({
						title: msg.MSG0122,
						msg: msg.MSG0120
					});
	
					doSearch();
	
		      },
		      error: function(){
		      }
		  });
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

/*이미지 등록 처리스크립트*/
function doImgClick(fileId){
	$('#'+fileId).click();

}

function readURL(input, fileId){
	//alert("call")
	if(input.files && input.files[0]){
		var reader = new FileReader();
		reader.onload = function(e){
			$('#'+fileId).attr("src", e.target.result);
		}
		reader.readAsDataURL(input.files[0]);

		$('.'+fileId).hide();
		$('#'+fileId).fadeIn(300);

	}
}
// TODO

function doGroupRight() {
	var deleteGrid = $('#group-grid');
	var selectGrid = $("#group-grid").datagrid('getChecked');
	var targetGrid = $("#group-target-grid").datagrid('getRows');
	var selVal = [];

	for(var j = selectGrid.length - 1; j >= 0; j--){
		var compare = false;
		for(var t = 0; t < targetGrid.length; t++) {
			if(selectGrid[j]["groupId"] == targetGrid[t]["groupId"]) compare = true;
		}
		if(!compare) {
			groupTarget_popup.easygrid.appendEdit(selectGrid[j]);
			var index = deleteGrid.datagrid('getRowIndex', selectGrid[j]);
			deleteGrid.datagrid('deleteRow',index);
		}
	}

	$("#group-grid").datagrid('unselectAll');
	$("#group-grid").datagrid('uncheckAll');
	$("#group-target-grid").datagrid('unselectAll');
}

function doGroupLeft() {
	var deleteGrid = $('#group-target-grid');
	var selectGrid = $("#group-target-grid").datagrid('getSelected');

	if(selectGrid != null) group_popup.easygrid.appendEdit(selectGrid);

	deleteGrid.datagrid('deleteRow',groupTargetIndex);

	groupTargetIndex = null;

	$("#group-grid").datagrid('unselectAll');
	$("#group-grid").datagrid('uncheckAll');
	$("#group-target-grid").datagrid('unselectAll');
}

function doUserIdRight() {
	var deleteGrid = $('#user-id-grid');
	var selectGrid = $("#user-id-grid").datagrid('getChecked');
	var targetGrid = $("#user-id-target-grid").datagrid('getRows');
	var selVal = [];

	for(var j = selectGrid.length - 1; j >= 0; j--){
		var compare = false;
		for(var t = 0; t < targetGrid.length; t++) {
			if(selectGrid[j]["userId"] == targetGrid[t]["userId"]) compare = true;
		}
		if(!compare) {
			userIdTarget_popup.easygrid.appendEdit(selectGrid[j]);
			var index = deleteGrid.datagrid('getRowIndex', selectGrid[j]);
			deleteGrid.datagrid('deleteRow',index);
		}
	}

	$("#user-id-grid").datagrid('unselectAll');
	$("#user-id-grid").datagrid('uncheckAll');
	$("#user-id-target-grid").datagrid('unselectAll');
}

function doUserIdLeft() {
	var deleteGrid = $('#user-id-target-grid');
	var selectGrid = $("#user-id-target-grid").datagrid('getSelected');

	if(selectGrid != null) userId_popup.easygrid.appendEdit(selectGrid);

	deleteGrid.datagrid('deleteRow',userIdTargetIndex);

	userIdTargetIndex = null;

	$("#user-id-grid").datagrid('unselectAll');
	$("#user-id-grid").datagrid('uncheckAll');
	$("#user-id-target-grid").datagrid('unselectAll');
}

function doOpenPopupGroup(callback) {

	var parentGrid = $("#search-grid").datagrid('getRows');
	var parentGridIndex = $("#parentRowIndex").val();

	var parentValue = [];
	parentValue = parentGrid[parentGridIndex]['authGroups'].split(',');

	for(var i = 0; i < parentValue.length; i++) {
		parentValue[i] = "'" + parentValue[i] + "'";
	}

	$("#jobNo_target2").val(parentGrid[parentGridIndex]['jobNo']);
	$("#group, #groupTarget").val(parentValue);

	var elm = $("#group-dialog");

	// HTML 상에 해당 DOM 객체가 없을경우 경고메세지 처리
	if (elm.length == 0) {
       $.messager.alert('Warning',msg.MSG0116,'warning');
       return false;
	}

	// 팝업을 오픈한다.
	elm.dialog({
	    title: "Auth Group",
	    left:(window.innerWidth / 3),
	    width:  550,
	    height: 400,
	    closed: false,
	    cache:  false,
	    modal:  true,
	    buttons:[{
	    	text:'Ok',
			handler:function() {
				// 팝업내 선택그리드 가져오기
				var selectGrid = $("#group-target-grid").datagrid('getRows');

				var selVal = [];

				for(var j = 0; j < selectGrid.length; j++){
					selVal.push(selectGrid[j]['groupId']);
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

	group_popup.easygrid.search(group_popup.url.search);

	groupTarget_popup.easygrid.search(groupTarget_popup.url.search);

}

function doOpenPopupUserId(callback) {

	var parentGrid = $("#search-grid").datagrid('getRows');
	var parentGridIndex = $("#parentRowIndex").val();

	var parentValue = [];
	parentValue = parentGrid[parentGridIndex]['authUsers'].split(',');

	for(var i = 0; i < parentValue.length; i++) {
		parentValue[i] = "'" + parentValue[i] + "'";
	}

	$("#userId, #userIdTarget").val(parentValue);

	var elm = $("#user-id-dialog");

	// HTML 상에 해당 DOM 객체가 없을경우 경고메세지 처리
	if (elm.length == 0) {
       $.messager.alert('Warning',msg.MSG0116,'warning');
       return false;
	}

	// 팝업을 오픈한다.
	elm.dialog({
	    title: "User",
	    left:(window.innerWidth / 3),
	    width:  550,
	    height: 400,
	    closed: false,
	    cache:  false,
	    modal:  true,
	    buttons:[{
	    	text:'Ok',
			handler:function() {
				// 팝업내 선택그리드 가져오기
				var selectGrid = $("#user-id-target-grid").datagrid('getRows');

				var selVal = [];

				for(var j = 0; j < selectGrid.length; j++){
					selVal.push(selectGrid[j]['userId']);
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

	userId_popup.easygrid.search(userId_popup.url.search);

	userIdTarget_popup.easygrid.search(userIdTarget_popup.url.search);

}
