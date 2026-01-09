/**
 * 직원관리를 처리하는 스크립트이다.
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
	easygrid: false,   //기본컨트롤
/*	cellEdit: true,
	viewrecords: true,
	forceFit : true,*/
	url: {
		search: getUrl("/common/report/datasearch/search.json"),
		excel:  getUrl("/common/report/datasearch/download.do")
	},
	init: function() {
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				excel:  getUrl("/common/report/datasearch/download.do")
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
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect: false,
			//striped: true,
			selectOnCheck: true,
			checkOnSelect: false,//TODO 김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
			onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
			onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
			onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
			onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트
			onSelect: doSelectRow, //2016/09/19 김영진 수정 --행 클릭 이벤트
			onDblClickRow: doDblClickRow, //그리드 더블클릭시 이벤트 바인딩
			//onClickCell:   doClickButton,  //그리드 셀클릭시 이벤트 바인딩
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
		pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
		easygrid: false,   //기본컨트롤
		url: {
			search: getUrl("/common/report/datasearch/searchSub.json")
		},
		init: function() {
			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				//url:      this.url,
				url: {
					search: null,
					excel:  getUrl("/common/report/datasearch/download.do")
				},
				gridKey:  "#parameter-grid",
				sformKey: "#parameter-form",
			});

			//그리드 생성
			this.easygrid.init({
				fit: true,
				pageSize: this.pageSize,
				pagination:false,
				toolbar:  "#parameter-toolbar",
				onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
				singleSelect: true,
				onClickRow:  function(rowIndex){
					consts_sub.easygrid.clickRowEditCustom(rowIndex);
			    },
				onLoadSuccess:function(data){
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

	consts.init();
	consts_sub.init();

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
		$("#excel-button").bind("click", doExcel);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//추가버튼(팝업) 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);

		//취소버튼(팝업) 클릭시 이벤트 바인딩
		$("#cancel-button").bind("click", doClose);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

		$("#s_JobType").on('change', function(){

			$("#jobNo, #d_jobNo").val(this.value);


			$('#search-grid').datagrid('loadData', []);

	    	var colStruct = [];
	    	var colItems = [];

	    	$.ajax({
	            url: getUrl('/common/report/datasearch/getFieldTitle.json'),
	            dataType: 'json',
	            async: false,
	            type: 'post',
	            data: {jobNo:this.value},
	            success: function(data){
	            	// 파라미터 셋팅 시작

	            	consts_sub.easygrid.search(consts_sub.url.search);
	            	// 파라미터 셋팅 종료

	            	if(data.rows.ColumnCnt > 0) {
	            		for(var i = 1; i <= data.rows.ColumnCnt; i++){
	            			//console.log("id : " + data.rows.ColumnData[i]["id"] + " name : " + data.rows.ColumnData[i]["name"]);
							if(data.rows.ColumnCnt == 1) {
								var menuItem = {
									field: data.rows.ColumnData[i]["id"],
									title: data.rows.ColumnData[i]["name"],
									align: 'left',
									width:1000
								};
							}
							else {
								var menuItem = {
									field: data.rows.ColumnData[i]["id"],
									title: data.rows.ColumnData[i]["name"],
									align: 'left',
									width:100
								};
							}
								
							colItems.push(menuItem);
	            		}
	            	}

					colStruct.push(colItems);
					// 컬럼 헤더 셋팅 종료

	            },
	            error: function(){
	            }
	        });

			$('#search-grid').datagrid({
				url: null,
			    columns:colStruct
			});

		});
		SystemToJobType();

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

	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	var dgridRow = $('#parameter-grid').datagrid('getRows');
	for(var i=0; i < dgridRow.length; i++ ){
		$('#parameter-grid').datagrid('endEdit',i);
	}

	for(var i=0; i < dgridRow.length; i++ ){
//		console.log(dgridRow[i].parameterCode);
		$("#data" + i).attr("name", dgridRow[i].parameterCode);
		$("#data" + i).attr("value", dgridRow[i].parameterValue);
	}

	consts.easygrid.search(consts.url.search);

}

//엑셀 다운로드
function doExcel() {
	   $('#progress-popup').dialog('open');

	   $("#search-grid").tableExport();

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
//저장 처리
function doSave() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.dialog.save();
}
//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.dialog.append();
}

//초기화
function doReload(){

  	$("#deptCode").combobox('setValue','');
	$("#searchEmplName").textbox('setValue','');
	$("#searchEmplNo").textbox('setValue','');

}
//취소 처리
function doClose() {
	$("#imgCompMark").attr("src", "");
	$("#imgCompMark").hide();
	$(".imgCompMark").show();
	consts.dialog.close();
}

//그리드 더블클릭시 이벤트 바인딩
function doDblClickRow(idx, row) {
	if (!row)
		return;
	//다이얼로그 수정폼 오픈
	consts.dialog.update(row);
}

/*//[자동로그인] 그리드의 로그인버튼 클릭시 이벤트 처리
function doClickButton(index, field, value) {

	if (consts.admin == 'N')
		return;

	if (field != 'userLogin')
		return;

	var rows = $(this).datagrid('getRows');
	var row  = rows[index];
	var msg  = '[아이디   :'
		     + '<font color="green"><b>'  + row.userId   + '</b></font>,'
	         + ' 사용자명 :'
	         + '<font color="orange"><b>' + row.userName + '</b></font>]'
	         + ' 로 자동 로그인하시겠습니까?';
	var win  = 'userwin';

	$.messager.confirm(msg.MSG0123, msg, function(r) {

		if (!r)
			return;

		//새탭열기
		window.open('', win);

		var f = $("#login-form");
		f.form('clear');

		//보안키 생성 및 결과가져오기
		jlogic.select({
			url: consts.url.secure,
			data: {userId: row.userId},
			success: function(res) {
				//새탭으로 로그인 처리
				doAutoLogin(f, win, res.rows);
			}
		});

	});
}*/

//[행클릭] 행클릭 이벤트
function doSelectRow(rowIndex, rowData){
	//console.log($(this).datagrid('getChecked'));
	if($('#hdfChk').val().indexOf("**"+rowIndex+", ") == -1){
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

/*//[자동로그인] 새탭에서 자동로그인 실행
function doAutoLogin(f, tabwin, data) {
	$("#j_system").val (data.sysId);
	$("#j_userid").val (data.userId);
	$("#j_secure").val (data.secureKey);

	var url = "http://"
		    + consts.domain
		    + consts.url.login;

	f.attr('target', tabwin);
	f.attr('action', url);
	f.submit();
}


//사용자유형값 포맷처리 (코드대신 명칭표시)
jformat.userType = function(val, row) {
	//사용자 유형칼럼의 콤보텍스트 표시
	if (jutils.empty(row.userTypeDesc))
		return val;
	return row.userTypeDesc;
}*/

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

function SystemToJobType(){
	//var itemType = $("#s_SystemType").combobox('getValue');
	var itemType = "IMMES";
	var itemName = "";

	$("#sysId, #d_sysId").val(itemType);

	if(itemType !=""){
			$.ajax({
	        url: getUrl('/common/report/datasearch/searchJobType.json'),
	        dataType: 'json',
	        async: false,
	        type: 'post',
	        data: {sysId:itemType},
	        success: function(data){
	        	var combodata = [];
	        	if(data.rows.length != 0){
	        		for(var i=0; i < data.rows.length; i++){
	    				$('#s_JobType').append($('<option/>', {
	    			        value: data.rows[i].jobNo,
	    			        text : data.rows[i].jobType
	    			    }));
	    			}
	        	} else {
	        		$("#s_JobType").empty();
	        	}
	        },
	        error: function(){
	        }
	    });
	}else{
		$("#s_JobType").empty();
	}
}
