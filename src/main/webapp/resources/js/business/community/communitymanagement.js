/**
 *
 * 동호회 관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 패널 상세조회
 * 폼 패널 등록,수정,삭제
 */
var editorObj = "";

var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/business/community/communitymanagement/search.json"),
		excel:  getUrl("/business/community/communitymanagement/download.do"),
		select: getUrl("/business/community/communitymanagement/select.json"),
		remove: getUrl("/business/community/communitymanagement/delete.json"),
		save:   getUrl("/business/community/communitymanagement/save.json")
	},
	init: function() {
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url:	{
				search: null,
				excel:  getUrl("/business/community/communitymanagement/download.do"),
				select: getUrl("/business/community/communitymanagement/select.json"),
				remove: getUrl("/business/community/communitymanagement/delete.json"),
				save:   getUrl("/business/community/communitymanagement/save.json")}
		,
		
		//title:    this.title,
		gridKey:  "#search-grid",		
		sformKey: "#search-form",
		formKey:  "#regist-form"
				
		});


		//그리드 생성
		this.easygrid.init({
			fit: true,
			singleSelect: true,
			pageSize: this.pageSize,
			//toolbar:  "#search-toolbar",
			//행선택시 상세조회 이벤트 바인딩
			//onBeforeSelect:checkYn,
			idField: 'custCode',
			//onSelect:this.easygrid.select,	
			onClickRow: doClickRow,
			onBeginEdit : doBeginEdit, //필수
			OnBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
				
			
			/*onSelect: doSelectRow,*/
			/*onDblClickRow:function(index, row) {
					
					(row.tempRele=='Y' ? ("#s_tempRele").attr("checked", true) : $("#s_tempRele").attr("checked", false));
					(row.stopTrad=='Y' ? $("#s_stopTrad").attr("checked", true) : $("#s_stopTrad").attr("checked", false));

			},*/
			onLoadSuccess:function(){
				//Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item){
					var itemid = $("#"+item.id);
					itemid.textbox('textbox').bind('keyup', function(e){
						itemid.textbox('setValue', $(this).val());
					});
				});

				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			}
		});

		$("#s_searchCustType").combobox({
			  onChange:function(newValue,oldValue){
				  doSearch();
			    }
		    });

		
	}
};

$(function() {

	using("../../js/module/jeditor.js");
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

	consts.init();

	setTimeout(function (){

		$(".wui-dialog").show();

		$("#account-layout").fadeIn(300);
		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//리포트버튼 클릭시 이벤트 바인딩
		//$("#report-button-pdf").bind("click", doReport);
		//$("#report-button-xls").bind("click", doReport);
		//$("#report-button-htm").bind("click", doReport);

		//추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//초기화버튼 클릭시 이벤트 바인딩
		//$("#clear-button").bind("click", doClear);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);

		//목록열기 버튼 클릭시 이벤트 바인딩
		$('#open-button').bind("click", doOpenTable);
		//목록닫기 버튼 클릭시 이벤트 바인딩
		$('#close-button').bind("click", doCloseTable);
		$('#open-button').css("display", "none");

		doSearch();

		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

		//등록폼 초기화
		doClear();
		$("#r_comuInfoName").val('동호회 소개');
		$("#r_comuInfo").val('동호회 소개');
		$("#r_comuNoticeName").val('공지사항');
		$("#r_comuNotice").val('공지사항');
		$("#r_comuFreeBoardName").val('자유게시판');
		$("#r_comuFreeBoard").val('자유게시판');
		$("#r_comuAlbumName").val('앨범게시판');
		$("#r_comuAlbum").val('앨범게시판');
		$("#r_comuVideoName").val('동영상게시판');
		$("#r_comuVideo").val('동영상게시판');
		$("#r_comuMaketName").val('장터게시판');
		$("#r_comuMaket").val('장터게시판');
		
		//에디터 사용
		editorObj = new jeditor({
			//웹에디터 레이어 ID
			editorLayer: "editor-area",
			//웹에디터 텍스트박스 ID
			editorBox:   "r_comuTerm",
			//웹에디터 폼 ID
			editorForm:  "regist-form"
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

	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	doClear();
	
	//consts.easygrid.search();
	consts.easygrid.search(consts.url.search);
}

//TODO 엑셀 다운로드
function doExcel() {

	var rows = 0;

	$.ajax({
	      url: getUrl('/business/community/communitymanagement/searchCount.json'),
	      dataType: 'json',
	      async: false,
	      type: 'post',
	      data: {searchCustName:$("#searchCustName").textbox("getValue")
	     	 	   ,searchCustCode:$("#searchCustCode").textbox("getValue")
	      	 	   ,searchCustType:$("#s_searchCustType").combobox("getValue")
	      	 	   ,searchOwnName:$("#searchOwnName").textbox("getValue")
	      	 	   ,searchDepositor1:$("#searchDepositor1").textbox("getValue")
	      	 	   ,searchBizNo:$("#searchBizNo").textbox("getValue")
	      	 },
	      success: function(data){
	    	  rows = data.rows;
	      },
	      error: function(){
	      }
	  });

	var msg  = ''
	     + '검색된 데이터가 많아서 엑셀기능 사용시<br>'
         + '작업시간이 오래 걸릴 수 있으며,<br>'
         + '시스템 성능을 저하시킬 수 있습니다.<br><br>'
		 + '&emsp;&emsp;&emsp;&nbsp; 계속해서 작업을 진행하시겠습니까?';

		if(rows >= 1000) {
			$.messager.confirm('알림', msg, function(r) {

				if (!r)
					return;

				doExcelEvent();

			});
		} else {

			doExcelEvent();

		}

}

function doExcelEvent(){
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
	var now = new Date();
    var year= now.getFullYear();
    var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
    var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
    var cunt_val = year + '-' + mon + '-' + day; // today
	
	consts.easygrid.clear();
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('clearSelections');
	
	$("#r_comuName").val('');
	$("#r_comuId").val('');
	$("#r_comuSlog").val('');
	$("#r_comuFondDay").datebox('setValue',cunt_val);
	$("#r_comuGb").combobox('setValue','');
	
	$("#r_comuInfoName").val('동호회 소개');
	$("#r_comuInfo").val('동호회 소개');
	$("input:checkbox[id='comuInfoYn']").prop("checked", true);
	$("#r_comuNoticeName").val('공지사항');
	$("#r_comuNotice").val('공지사항');
	$("input:checkbox[id='comuNoticeYn']").prop("checked", true);
	$("#r_comuFreeBoardName").val('자유게시판');
	$("#r_comuFreeBoard").val('자유게시판');
	$("input:checkbox[id='comuFreeBoardYn']").prop("checked", true);
	$("#r_comuAlbumName").val('앨범게시판');
	$("#r_comuAlbum").val('앨범게시판');
	$("input:checkbox[id='comuAlbumYn']").prop("checked", false);
	$("#r_comuVideoName").val('동영상게시판');
	$("#r_comuVideo").val('동영상게시판');
	$("input:checkbox[id='comuVideoYn']").prop("checked", false);
	$("#r_comuMaketName").val('장터게시판');
	$("#r_comuMaket").val('장터게시판');
	$("input:checkbox[id='comuMaketYn']").prop("checked", false);
}

//삭제 처리
function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	//consts.easygrid.remove();
	var selectRow = $('#search-grid').datagrid('getSelected');
	if (selectRow === undefined || selectRow === null) {
		$.messager.alert('Warning','행을 선택하세요.','warning');
		return false;
	}
	var comuId = selectRow.comuId;
	$.ajax({
		url: getUrl('/business/community/communitymanagement/deleteComu.json'),
		dataType: 'json',
		async: false,
		type: 'post',
		data: {
				 comuId:comuId
		},
		success: function(data){
			$.messager.show({
				title: 'Information',
				msg: "삭제되었습니다."
			});
			doSearch();
		},
		error: function(){
			$.messager.show({
				title: 'Information',
				msg: "에러가 발생했습니다."
			});
		}
	});
}
//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	doClear();
	var text = "<p></p>";
	editorObj.set(text);
	$('#r_oper').val("I");
	$('#r_hdfComuId').val("CM");
}
//저장 처리
function doSave() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	
	if($("#r_comuName").val() == ""){
		$.messager.alert('Warning',msg.MSG0109,'warning');
		return;
	}

	var comuId = $('#r_hdfComuId').val();
	var comuMenuId1 = $('#comuMenuId1').val();
	var comuMenuId2 = $('#comuMenuId2').val();
	var comuMenuId3 = $('#comuMenuId3').val();
	var comuMenuId4 = $('#comuMenuId4').val();
	var comuMenuId5 = $('#comuMenuId5').val();
	var comuMenuId6 = $('#comuMenuId6').val();
	
	if(comuId == "" || comuId == null){
		$('#r_hdfComuId').val("CM");
		comuId = 'CM';
		comuMenuId1 = 'MU';
		comuMenuId2 = 'MU';
		comuMenuId3 = 'MU';
		comuMenuId4 = 'MU';
		comuMenuId5 = 'MU';
		comuMenuId6 = 'MU';
	}

	$.ajax({
		url: getUrl('/business/community/communitymanagement/saveComu.json'),
		dataType: 'json',
		async: false,
		type: 'post',
		data: {
				 comuName:$("#r_comuName").val()
				,comuId:comuId
				,comuSlog:$("#r_comuSlog").val()
				,comuFondDay:$("#r_comuFondDay").datebox("getValue")
				,comuGb:$("#r_comuGb").combobox("getValue")
				,comuMenu1Yn: $("#comuInfoYn").is(":checked")? 'Y':'N'
				,comuMenu1:$("#r_comuInfo").val()
				,comuMenuId1:comuMenuId1
				,comuMenu2Yn: $("#comuNoticeYn").is(":checked")? 'Y':'N'
				,comuMenu2:$("#r_comuNotice").val()
				,comuMenuId2:comuMenuId2
				,comuMenu3Yn: $("#comuFreeBoardYn").is(":checked")? 'Y':'N'
				,comuMenu3:$("#r_comuFreeBoard").val()
				,comuMenuId3:comuMenuId3
				,comuMenu4Yn: $("#comuAlbumYn").is(":checked")? 'Y':'N'
				,comuMenu4:$("#r_comuAlbum").val()
				,comuMenuId4:comuMenuId4
				,comuMenu5Yn: $("#comuVideoYn").is(":checked")? 'Y':'N'
				,comuMenu5:$("#r_comuVideo").val()
				,comuMenuId5:comuMenuId5
				,comuMenu6Yn: $("#comuMaketYn").is(":checked")? 'Y':'N'
				,comuMenu6:$("#r_comuMaket").val()
				,comuMenuId6:comuMenuId6
				,comuTerm:editorObj.get()
				,oper:$("#r_oper").val()
		},
		success: function(data){
			$.messager.show({
				title: 'Information',
				msg: "Save is complete."
			});
			doSearch();
		},
		error: function(){
			$.messager.show({
				title: 'Information',
				msg: "This is registered data."
			});
		}
	});
}

function doReload(){
	$("#searchComuName").textbox('setValue','');
	$("#searchComuId").textbox('setValue','');
}


function doEnterKey(){

}

function doCloseTable(){
	$("#account-layout").layout('collapse', 'east');
	$('#close-button').css("display", "none");
	$('#open-button').css("display", "inline-block");
}

function doOpenTable(){
	$("#account-layout").layout('expand', 'east');
	$('#open-button').css("display", "none");
	$('#close-button').css("display", "inline-block");
}

//에디트 시작
function doBeginEdit(rowIndex, rowData) {
	var editors = $('#search-grid').datagrid('getEditors', rowIndex);
}

//[행클릭] 행클릭 이벤트
function doClickRow(index, row){	
	//consts.easygrid.clickRowEdit(index);
	$('#r_hdfComuId').val(row.comuId);
	$("#r_comuName").val(row.comuName);
	$("#r_comuId").val(row.comuId);
	$("#r_comuSlog").val(row.comuSlog);
	$("#r_comuFondDay").datebox('setValue',row.comuFondDay);
	$("#r_comuGb").combobox('setValue',row.comuGb);
	editorObj.set(row.comuTerm);
	
	$.ajax({
        url: getUrl('/business/community/communitymanagement/getComuMenu.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {comuId:row.comuId},
        success: function(data){
        	if(data.rows.length != 0){
        		$("#comuMenuId1").val(data.rows[0].menuId);
        		$("#r_comuInfo").val(data.rows[0].menuName);
        		if(data.rows[0].useYn == "Y") $("input:checkbox[id='comuInfoYn']").prop("checked", true);
        		else $("input:checkbox[id='comuInfoYn']").prop("checked", false);
        		$("#comuMenuId2").val(data.rows[1].menuId);
        		$("#r_comuNotice").val(data.rows[1].menuName);
        		if(data.rows[1].useYn == "Y") $("input:checkbox[id='comuNoticeYn']").prop("checked", true);
        		else $("input:checkbox[id='comuNoticeYn']").prop("checked", false);
        		$("#comuMenuId3").val(data.rows[2].menuId);
        		$("#r_comuFreeBoard").val(data.rows[2].menuName);
        		if(data.rows[2].useYn == "Y") $("input:checkbox[id='comuFreeBoardYn']").prop("checked", true);
        		else $("input:checkbox[id='comuFreeBoardYn']").prop("checked", false);
        		$("#comuMenuId4").val(data.rows[3].menuId);
        		$("#r_comuAlbum").val(data.rows[3].menuName);
        		if(data.rows[3].useYn == "Y") $("input:checkbox[id='comuAlbumYn']").prop("checked", true);
        		else $("input:checkbox[id='comuAlbumYn']").prop("checked", false);
        		$("#comuMenuId5").val(data.rows[4].menuId);
        		$("#r_comuVideo").val(data.rows[4].menuName);
        		if(data.rows[4].useYn == "Y") $("input:checkbox[id='comuVideoYn']").prop("checked", true);
        		else $("input:checkbox[id='comuVideoYn']").prop("checked", false);
        		$("#comuMenuId6").val(data.rows[5].menuId);
        		$("#r_comuMaket").val(data.rows[5].menuName);
        		if(data.rows[5].useYn == "Y") $("input:checkbox[id='comuMaketYn']").prop("checked", true);
        		else $("input:checkbox[id='comuMaketYn']").prop("checked", false);
        	}else{
        		
        	}
        },
        error: function(){
        }
    });
	$("#r_comuInfoName").val('동호회 소개');
	$("#r_comuNoticeName").val('공지사항');
	$("#r_comuFreeBoardName").val('자유게시판');
	$("#r_comuAlbumName").val('앨범게시판');
	$("#r_comuVideoName").val('동영상게시판');
	$("#r_comuMaketName").val('장터게시판');
	$('#r_oper').val("U");
}