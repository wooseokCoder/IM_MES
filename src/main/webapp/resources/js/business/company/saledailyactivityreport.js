/**
 *
 * 그리드 검색
 * 그리드 다중 편집
 * 그리드 다중 저장
 */

/**
 * 메인화면 처리 스크립트
 */
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/business/company/saledailyactivityreport/search.json"),
		remove: getUrl("/business/company/saledailyactivityreport/delete.json"),
		excel:  getUrl("/business/company/saledailyactivityreport/download.do")
	},
	init: function() {

		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      consts.url,
			url: {
				search: null,
				remove: getUrl("/business/company/saledailyactivityreport/delete.json"),
				excel:  getUrl("/business/company/saledailyactivityreport/download.do")
			},
			//title:    consts.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'shetNoType',
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			//그리드 편집이벤트 바인딩
			/*onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,*/
			fit:          true,
			selectOnCheck:true,
			checkOnSelect: false,//TODO 김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
			onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
			onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
			onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
			onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트
			//onSelect: doSelectRow, //2016/09/19 김영진 수정 --행 클릭 이벤트
			onSelect:function(index, row) {
				$("#dShetType").val($("#cShetType").val());
				$("#dShetNo").val(row.shetNo);
				doSelectDetail(row);
			},
			onDblClickRow:function(index, row) {
				doSelect(row);
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
				//setTimeout('doAppendClear1()', 10);
			}
		});

	}
};
/**
 * 메인화면 서브 처리 스크립트
 */
var consts_sub = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/business/sale/saleregister/searchdetal.json")
	},
	init: function() {
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url: {
				search: null
			},
			gridKey:  "#detail-grid",
			sformKey: "#detail-form"
		});
		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#detail-toolbar",
			pagination:false,
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect: true,
			selectOnCheck:true,
			onLoadSuccess:function(){
				$("#detail-grid").datagrid('uncheckAll');
				$("#detail-grid").datagrid('clearChecked');
			}
		});
		}
	};

/**
 * 등록화면 처리 스크립트
 */
var consts_create = {
		sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
		title:    gconsts.TITLE,     //화면제목 (common.jsp)
		pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
		easygrid: false, //기본컨트롤
		url: {
			search: getUrl("/business/company/saledailyactivityreport/searchfoot.json"),
			save:   getUrl("/business/sale/estimate/item/save.json")
		},
		init: function() {
			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				url: {
					search: null,
					save:   getUrl("/business/sale/estimate/item/save.json")
				},
				//title:    this.title, //20160921 김원국
				gridKey:  "#search-create-grid",
				sformKey: "#search-create-form"
			});

			//그리드 생성
			this.easygrid.init({
				fit: true,
				pageSize: this.pageSize,
				toolbar:  "#search-create-toolbar",
				idField:  'shetNoSeq',
				pagination:false,
				onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
				singleSelect: true,
				//그리드 편집이벤트 바인딩
				onClickRow:   this.easygrid.clickRowEditCustom,
				onBeforeEdit: this.easygrid.beforeEdit,
				onAfterEdit : this.easygrid.afterEdit,
				onLoadSuccess:function(){
					//Enter 검색을 위한 추가
					$(".easyui-textbox").each(function(index, item){
						var itemid = $("#"+item.id);
						itemid.textbox('textbox').bind('keyup', function(e){
							itemid.textbox('setValue', $(this).val());
						});
					});


					//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
					$("#search-create-grid").datagrid('unselectAll');
					$("#search-create-grid").datagrid('clearSelections');
				}
			});


			$("#cShetDate").datebox({
				  onChange:function(newValue,oldValue){
						/*console.log("onChange");
						console.log($("#cShetDate").datebox("getValue"));*/
					  var cgridRow = $('#search-create-grid').datagrid('getRows');
					  for(i=0;i<cgridRow.length;i++){

							$('#search-create-grid').datagrid('beginEdit', i);
							$('#search-create-grid').datagrid('getEditor', {index:i, field:'shetDate'});
							$('#search-create-grid').datagrid('endEdit', i);

							 $('#search-create-grid').datagrid('updateRow',{
								  index:i,
								  row:{
									  shetDate:newValue
								  }
							  });
					}
				}
			});
		}
};

/**
 * 거래처 조회 처리 스크립트
 */
var consts_cust = {
		sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
		title:    gconsts.TITLE,     //화면제목 (common.jsp)
		pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
		easygrid: false, //기본컨트롤
		url: {
			search: getUrl("/business/sale/estimate/searchcust.json")
		},
		init: function() {


			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				url :{search:null },
				//title:    this.title, //20160921 김원국
				gridKey:  "#search-cust-grid",
				sformKey: "#search-cust-form"
			});

			//그리드 생성
			this.easygrid.init({
				fit: true,
				pageSize: this.pageSize,
				toolbar:  "#search-cust-toolbar",
				idField:  'custCode',
				onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
				singleSelect: true,
				onDblClickRow:function(index, row) {

					var param = {
							custCode:row.custCode,
							custName:row.custName
						};

					consts_create.easygrid.appendEdit(param);

					$("#cust-search-dialog").dialog('close');
				},
				onLoadSuccess:function(){
					//Enter 검색을 위한 추가
					$(".easyui-textbox").each(function(index, item){
						var itemid = $("#"+item.id);
						itemid.textbox('textbox').bind('keyup', function(e){
							itemid.textbox('setValue', $(this).val());
						});
					});
				}
			});
		}
};

$(function() {

	consts.init();			//주문서관리 메인
	consts_sub.init();		//주문서서브 메인

	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	//엑셀버튼 클릭시 이벤트 바인딩
	$("#excel-button").bind("click", doExcel);
	//삭제버튼 클릭시 이벤트 바인딩
	$("#remove-button").bind("click", doRemove);
	//추가버튼 클릭시 이벤트 바인딩
	$("#append-button").bind("click", doAppend);

	//업체검색 검색버튼
	$("#search-cust_pop-button").bind("click",doSearchCust);

	//전표등록 삭제 저장
	$("#save-create-button").bind('click',doSaveCreate);
	//전표등록 상세 추가
	$("#append-create-button").bind("click",doAppendCreate);
	//전표등록 상세 삭제
	$("#remove-create-button").bind("click",doRemoveCreate);

	$('#regist-dialog').dialog({
	    title: tit.TITLE0010,//샘플게시판 등록
	    iconCls: 'icon-search',
	    top:     10,
	    width: 1024,
	    height: 700,
	    closed: true,
	    modal: true,
	    resizable: true
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

	consts_create.init();	//등록시
	consts_cust.init();		//업체조회

	setTimeout(function (){

		$(".wui-dialog").show();

		$("#account-layout").fadeIn(300);

		$("#date1").datebox({
			onChange:function(newValue,oldValue){
				if(newValue > $("#date2").datebox("getValue")) {
	            $("#date2").datebox("setValue", newValue);
	        }
	      }
		});

		$("#date2").datebox({
			onChange:function(newValue,oldValue){
				if(newValue < $("#date1").datebox("getValue")) {
					$("#date1").datebox("setValue", newValue);
				}
			}
		});

		//리스트 조회
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

		$('#search-create-grid').datagrid('getPanel').panel('panel').attr('tabindex',1).bind('keydown',function(e){
			if (e.which === 13 ) {
				var dgridRow = $('#search-create-grid').datagrid('getRows');
				for(var i=0; i < dgridRow.length; i++ ){
					$('#search-create-grid').datagrid('endEdit',i);
				}
		    }
		});

		$("#date1").datebox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
				doSearch();
		    }
		});

		$("#date2").datebox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
				doSearch();
		    }
		});
		$("#salEply").combobox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
				doSearch();
		    }
		});

			doAppendClear1();

		//업체조회 팝업
		$("#search-create-form").bind('keydown',function(events){
			/*if(events.keyCode == 13){
				doCustSearch("cCustName","cCustCode","pCustName");
			}*/
		});

		$('#regist-dialog').window({
		    onClose: function (){
		      setTimeout('doAppendClear1()', 10);
		    }
		  });

		$("#cShetDate").datebox({
			  onChange:function(newValue,oldValue){
					//console.log("onChange");
					//console.log($("#cShetDate").datebox("getValue"));
				  var cgridRow = $('#search-create-grid').datagrid('getRows');
				  for(i=0;i<cgridRow.length;i++){

						$('#search-create-grid').datagrid('beginEdit', i);
						$('#search-create-grid').datagrid('getEditor', {index:i, field:'totTax'});
						$('#search-create-grid').datagrid('endEdit', i);

						$('#search-create-grid').datagrid('updateRow',{
							index:i,
							row:{
								shetDate:newValue
							}
						});
				}
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
	consts.easygrid.search(consts.url.search);
	$('#dShetType').val("");
	$('#dShetNo').val("");
	$('#remk1').val("");
	$('#remk3').val("");
	$('#detail-grid').datagrid('loadData', []);
}
//업체검색 처리
function doSearchCust() {
	consts_cust.easygrid.search(consts_cust.url.search);
}
//메인서브 조회
function doSelectDetail(row){
	$("#search-grid").datagrid('unselectAll');
	$('#hdfChk').val("");
	$('#hdfIndex').val("-1");
	$("#d_remk1").val(row.remk1);
	$("#d_remk3").val(row.remk3);
	consts_sub.easygrid.search(consts_sub.url.search);
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
//등록
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}

	$("#regist-dialog").dialog('center');
	$("#regist-dialog").dialog('open');
}

function doAppendCreate(){

	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	doPopUpCust();

}


//더블클릭시 상세조회
function doSelect(row) {
	$("#cShetDate").datebox("setValue",row.shetDate);
	$("#hShetType").val(row.shetType);
	$("#hShetNo").val(row.shetNo);
	$("#shetNT").html(row.shetNT);
	$("#r_remk1").val(row.remk1);
	$("#r_remk3").val(row.remk3);
	$("#cStafDept").combobox("setValue", row.stafDept);
	$("#userName").html(row.userName);

	consts_create.easygrid.search(consts_create.url.search);

	$("#regist-dialog").dialog('center');
	$("#regist-dialog").dialog('open');
}
function doPopUpCust(){
	doCustSearch("t_custName","t_custCode","");

	$(".easyui-textbox").each(function(index, item){
		var itemid = $("#"+item.id);
		//console.log(itemid);
		itemid.textbox('textbox').bind('keyup', function(e){
			if (e.which === 13 ) {
				itemid.textbox('setValue', $(this).val());
				consts_cust.easygrid.search(consts_cust.url.search);

			}
		});
	});
}

//삭제 처리
function doRemove() {
	var rows = $("#search-grid").datagrid('getChecked');
	consts.easygrid.removeCheckAll();
	$('#dShetType').val("");
	$('#dShetNo').val("");
	$('#d_remk1').val("");
	$('#d_remk3').val("");
	$('#detail-grid').datagrid('loadData', []);
}

//전표등록 저장
function doSaveCreate(){
	var cgridRow = $('#search-create-grid').datagrid('getRows');
	for(var i=0; i < cgridRow.length; i++ ){
		$('#search-create-grid').datagrid('endEdit',i);
	}
	var row = $('#search-create-grid').datagrid('getChanges');
    $.ajax({
        url: getUrl('/business/company/saledailyactivityreport/saveShetDetl.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {rows:JSON.stringify(row)
        	  ,shetType:$("#cShetType").val()						//타입
        	  ,useIdx:"Y"											//사용여부
        	  ,remk1:$("#r_remk1").val()							//전일업무 보고사항
              ,remk3:$("#r_remk3").val()							//오늘업무 예정사항
        	  ,shetNo:$("#hShetNo").val()							//shetNo 번호
        	  ,shetDate:$("#cShetDate").datebox("getValue")			//등록일자
        	  ,stafDept:$("#cStafDept").datebox("getValue")			//담당부서
        	  ,stafName:$("#userName").html()
        	  },
        success: function(data){
        	 $.messager.show({
    			title: 'Information',
    			msg: "Save is complete."
        	 });
        },
        error: function(){
        }
    });

    $('#regist-dialog').dialog('close');
    doSearch();
}

function doRemoveCreate(){
	consts_create.easygrid.removeEdit();
}

/**
 * 행 클릭에 대한 이벤트
 */
//[행클릭] 행클릭 이벤트
function doSelectRow(rowIndex, rowData){
	//console.log($(this).datagrid('getChecked'));
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

function doAppendClear1(){
	$('#search-create-grid').datagrid('loadData', []);
	var dt = new Date();
	var month = dt.getMonth()+1;
	var day = dt.getDate();
	var year = dt.getFullYear();
	$("#cShetDate").datebox("setValue",year + '-' + month + '-' + day);
	$("#shetNT").html("");
	$("#cStafDept").combobox("setValue", "");
	$("#userName").html($("#hUserName").val());
	$("#r_remk1").val("");
	$("#r_remk3").val("");
	$("#hShetType").val("");
	$("#hShetNo").val("000000");
}