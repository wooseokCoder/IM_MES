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
		search: getUrl("/common/board/dealerSearch/search.json")
	},
	init: function() {
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url:      this.url,
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-dealer-grid",
			sformKey: "#search-dealer-form",
			gridOptions: {
				onDblClickRow:function(index, row) {
					addTrList(row);
				}
			}
		});
	
		//그리드 생성
		this.easygrid.init({
			fit: true,
			//pageSize: this.pageSize,
			pagination: false,
			toolbar:  "#search-dealer-toolbar",
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
				$("#search-dealer-grid").datagrid('uncheckAll');
				$("#search-dealer-grid").datagrid('clearChecked');
				loading('end');
			}
		});
		
		//등록폼 초기화
		doClear();
		
	}
};


$(function() {

});

$(window).load(function() {
	
	setTimeout(function (){
		
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
		//$("#cc_right_arow").bind("click", doCcRight);
		//수신 삭제 이벤트 바인딩
		//$("#cc_left_arow").bind("click", doCcLeft);
		
		$("#s_searchKey").combobox('setValue','S01');
		
		$("#r_searchText").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});
		
	}, 100);
});

//화면 상수값 초기화
function doInit(args) {
	$("#search-dealer-grid").datagrid('unselectAll');
	$("#search-dealer-grid").datagrid('uncheckAll');
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
	var dealerList = "";
	for(var i = 0;i<$("#to_list tr").length;i++){
		if(i == $("#to_list tr").length -1){
			dealerList += $("#to_list tr").eq(i).children().children().html();
		}else{
			dealerList += $("#to_list tr").eq(i).children().children().html() + ",";
		}
	}

	parent.doDialogClose(dealerList);

	$("#search-dealer-grid").datagrid('unselectAll');
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

	var count = 0;
	$.each(arr,function(index, item){
		count = 0;
    	$('#to_list tr').each(function(){ //to_list
		    var tr_cd = $(this)[0].id;
		    if (tr_cd == item){
		    	count++;
		    }
	    });

	    if (count == 0){
	    	var toListTr = "<tr id='" + item + "' style='height:25px;'>";
	    	toListTr += "<td style='padding:5px;'><a herf='javascript:void(0)' onclick='doFlag(this);'>"
	    		+ item + "</a></td>";
	    	toListTr += "</tr>"
	    	$("#to_list").append(toListTr);
	    }
	    //console.log(item +": count"+count);
// 		if($.inArray(item, toArr) == -1){
// 			var toListTr = "<tr id='" + item + "' style='height:25px;'>";
// 			toListTr += "<td style='padding:5px;'><a herf='javascript:void(0)' onclick='doFlag(this);'>"
// 				+ item + "</a></td>";
// 			toListTr += "</tr>"
// 				$("#to_list").append(toListTr);
// 			toArr.push(item);
// 		}
	})
	
	arr = new Array();
	$("#search-dealer-grid").datagrid('unselectAll');
}

//수신 삭제
function doToLeft(){
	$("#to_list tr .selected-row").parent().parent().remove();
}
var arr = new Array();

function doSelectRow(rowIndex, rowData){
	
	if(arr.length == 0){
		arr.push(rowData.DEAL_CODE);
	} else{
		
		if($.inArray(rowData.DEAL_CODE, arr) != -1){
		    arr.splice(arr.indexOf(rowData.DEAL_CODE),1);
		    $(this).datagrid('uncheckRow', rowIndex).datagrid('unselectRow', rowIndex);
		} else {
			arr.push(rowData.DEAL_CODE);
		}
	}
}


function loading(flag){
}

function doKeyChange(val){
	$("#r_searchText").textbox("setValue",'');
	$("#CHAR_BM").combobox('setValue','');
	$("#SERV_MGR").combobox('setValue','');
	$("#ADDR_CNTY").combobox('setValue','');
	
	if(val == "S01"){
		$("#searchExt").show();
		$("#searchBm").hide();
		$("#searchSm").hide();
		$("#searchCt").hide();
		
	} else if(val == "S02"){
		$("#searchExt").hide();
		$("#searchBm").show();
		$("#searchSm").hide();
		$("#searchCt").hide();
	} else if(val == "S03"){
		$("#searchExt").hide();
		$("#searchBm").hide();
		$("#searchSm").show();
		$("#searchCt").hide();
	} else{
		$("#searchExt").hide();
		$("#searchBm").hide();
		$("#searchSm").hide();
		$("#searchCt").show();
	}
}
function setTrList(){
	var list = parent.getTarger().split(',');
	for (var i in list){
		if (list[i] != ""){
			arr.push(list[i]);
		}
    }
	doToRight();
}
function addTrList(row){
	arr.push(row.DEAL_CODE);
	doToRight();
}
