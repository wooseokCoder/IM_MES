var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	admin:    gconsts.ADMIN,     //관리자  (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	domain:   false,   //사용자로그인용 도메인
	easygrid: false,   //기본컨트롤
	dialog:   false,   //팝업다이얼로그 컨트롤
	cellEdit: true,
	viewrecords: true,
	forceFit : true,
	url: {
		search: getUrl("/common/mail/address/search.json"),
		save:   getUrl("/common/mail/address/save.json")
	},
	init: function() {
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url:      this.url,
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});
	
		//그리드 생성
		this.easygrid.init({
			fit: true,
			//pageSize: this.pageSize,
			pagination: false,
			toolbar:  "#search-toolbar",
			idField:  'tgtUserId',
			//onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect: false,
			//onSelect: doSelectRow,
			onClickRow:   doSelectRow,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			//striped: true,
			onLoadSuccess:function(){

				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화 
				$("#search-grid").datagrid('uncheckAll');
				$("#search-grid").datagrid('clearChecked');
			}
		});
		
		//등록폼 초기화
		doClear();
	}
};


$(function() {
	consts.init();

	//추가버튼 클릭시 이벤트 바인딩
	$("#append-button").bind("click", doAppend);
	//삭제버튼 클릭시 이벤트 바인딩
	$("#remove-button").bind("click", doDelete);
	//저장버튼 클릭시 이벤트 바인딩
	$("#save-button").bind("click", doSave);
	//확인버튼 클릭시 이벤트 바인딩
	$("#submit-button").bind("click", doSubmit);
	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);

	//수신 추가 이벤트 바인딩
	$("#to_right_arow").bind("click", doToRight);
	//수신 삭제 이벤트 바인딩
	$("#to_left_arow").bind("click", doToLeft);

	//수신 추가 이벤트 바인딩
	$("#cc_right_arow").bind("click", doCcRight);
	//수신 삭제 이벤트 바인딩
	$("#cc_left_arow").bind("click", doCcLeft);
});

//화면 상수값 초기화
function doInit(args) {
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('uncheckAll');
	if (args) {
		$.extend(consts, args);
	}
}
//검색버튼 클릭시 그리드 검색
function doSearch() {
	consts.easygrid.search();
}
//초기화 처리
function doClear() {
	consts.easygrid.clear();
}

//저장 처리
function doSave() {
	consts.easygrid.saveEdit();
}

//삭제 처리
function doDelete() {
	consts.easygrid.removeEdit();
}

//추가 처리
function doAppend() {
	consts.easygrid.appendEdit();
}

//수신/참조 추가처리
function doSubmit() {
	var toList = "";
	for(var i = 0;i<$("#to_list tr").length;i++){
		if(i == $("#to_list tr").length -1){
			toList += $("#to_list tr").eq(i).children().children().html();
		}else{
			toList += $("#to_list tr").eq(i).children().children().html() + ", ";
		}
	}
	var ccList = "";
	for(var i = 0;i<$("#cc_list tr").length;i++){
		if(i == $("#cc_list tr").length -1){
			ccList += $("#cc_list tr").eq(i).children().children().html();
		}else{
			ccList += $("#cc_list tr").eq(i).children().children().html() + ", ";
		}
	}

	//$("#r_mail_to", parent.document).next().children().val(toList);
	//$("#r_mail_cc", parent.document).next().children().val(ccList);
	parent.doDialogClose(toList, ccList);
	//console.log($("#r_mail_to", parent.document).next().children()[1]);
	
	//$("#address-popup").dialog('close');
}

//수신/참조 행클릭
function doFlag(flag){
	if($(flag).hasClass("selected-row")){
		$(flag).removeClass("selected-row");
	}else{
		$(flag).addClass("selected-row");
	}
}

//수신 추가
function doToRight(){
	/*var toListTr = "<tr style='height:25px;'>";
	toListTr += "<td style='padding:5px;'><a herf='javascript:void(0)'>" +  + "</a></td>";
	$("#to_list").append();*/

	var selectGrid = $("#search-grid").datagrid('getSelections');
	//console.log(selectGrid);
	
	for(var i=0;i<selectGrid.length;i++){
		//console.log($("#to_list").find("#to_" + selectGrid[i].tgtUserId));
		if(document.getElementById('to_' + selectGrid[i].tgtUserId)){
			;
		}else{
			
			var toListTr = "<tr id='to_" + selectGrid[i].tgtUserId + "' style='height:25px;'>";
			toListTr += "<td style='padding:5px;'><a herf='javascript:void(0)' onclick='doFlag(this);'>" + selectGrid[i].tgtUserId + "</a></td>";
			toListTr += "</tr>"
			$("#to_list").append(toListTr);
		}
		//console.log(i+" :: " + selectGrid[i].tgtUserId);
	}
}
//수신 삭제
function doToLeft(){
	$("#to_list tr .selected-row").parent().parent().remove();
}

//참조 추가
function doCcRight(){
	/*var toListTr = "<tr style='height:25px;'>";
	toListTr += "<td style='padding:5px;'><a herf='javascript:void(0)'>" +  + "</a></td>";
	$("#to_list").append();*/

	var selectGrid = $("#search-grid").datagrid('getSelections');
	//console.log(selectGrid);
	
	for(var i=0;i<selectGrid.length;i++){
		//console.log($("#to_list").find("#to_" + selectGrid[i].tgtUserId));
		if(document.getElementById('cc_' + selectGrid[i].tgtUserId)){
			;
		}else{
			
			var toListTr = "<tr id='cc_" + selectGrid[i].tgtUserId + "' style='height:25px;'>";
			toListTr += "<td style='padding:5px;'><a herf='javascript:void(0)' onclick='doFlag(this);'>" + selectGrid[i].tgtUserId + "</a></td>";
			toListTr += "</tr>"
			$("#cc_list").append(toListTr);
		}
		//console.log(i+" :: " + selectGrid[i].tgtUserId);
	}
}
//참조 삭제
function doCcLeft(){
	$("#cc_list tr .selected-row").parent().parent().remove();
}

function doSelectRow(rowIndex, rowData){
	var oldRow = $("#hdfIndex").val();
	//console.log(oldRow + ", " + rowIndex);
	if(oldRow == rowIndex){
		//console.log("out");
		consts.easygrid.endEdit();
		$(this).datagrid('uncheckRow', rowIndex).datagrid('unselectRow', rowIndex);
		$("#hdfIndex").val("-1");
	}else{
		//console.log("in");
		consts.easygrid.clickRowEdit(rowIndex);
		$("#hdfIndex").val(rowIndex);
	}
}