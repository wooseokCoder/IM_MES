/**
 * 사용자그룹관리를 처리하는 스크립트이다.
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
	url: {
		search: getUrl("/common/user2/usergroup2/search.json"),
		excel:  getUrl("/common/user2/usergroup2/download.do"),
		save:   getUrl("/common/user2/usergroup2/save.json")
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
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			singleSelect: true,
			//그리드 편집이벤트 바인딩
			onClickRow:   this.easygrid.clickRowEdit,
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
				doLangSettingTable();

				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화 
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			} 			
		});
		
		//시스템그리드 초기화
		jsystem.init("UG", this.pageSize);
	}
};

$(function() {

	consts.init();
	
	//초기화버튼 클릭시 이벤트 바인딩
	$("#reload-button").bind("click", doReload);
	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	//엑셀버튼 클릭시 이벤트 바인딩
	$("#excel-button").bind("click", doExcel);
	//추가버튼 클릭시 이벤트 바인딩
	$("#append-button").bind("click", doAppend);
	//삭제버튼 클릭시 이벤트 바인딩
	$("#remove-button").bind("click", doRemove);
	//저장버튼 클릭시 이벤트 바인딩
	$("#save-button"  ).bind("click", doSave);
	//사용자목록 검색 TODO 김원국 수정
	$("#user-button").bind("click", doUserSearch);
	//그룹목록 검색 TODO 김원국 수정
	$("#group-button").bind("click", doGroupSearch);
	
	//Enter 검색을 위한 추가
	$("#user-form").bind('keydown',function(events){
		if(events.keyCode == 13){
			doUserSearch();
		}
	});
	
	//Enter 검색을 위한 추가
	$("#group-form").bind('keydown',function(events){
		if(events.keyCode == 13){
			doGroupSearch();
		}
	});
});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}
//모든 그리드 초기화
//BBUG.KWK this.easygrid.reload() -> consts.easygrid.reload() 으로 변경
//jsystem.unbind 추가
//consts.easygrid.search(); 추가
function doReload() {
	//그리드 RELOAD
	jsystem.unbind();
	jsystem.reload();
	consts.easygrid.reload();
	consts.easygrid.search();
}
//검색 처리
function doSearch() {
	//검색값 바인딩
	jsystem.bind();
	consts.easygrid.search();
}

//사용자목록 검색 처리 
//TODO 김원국 수정
function doUserSearch(){
	jsystem.ugrid.search();
}

//그룹목록 검색 처리
//TODO 김원국 수정
function doGroupSearch(){
	jsystem.ggrid.search();
}
//엑셀 다운로드
function doExcel() {
	//검색값 바인딩
	jsystem.bind();
	consts.easygrid.download();
}
//삭제 처리
function doRemove() {
	consts.easygrid.removeEdit();
}
//저장 처리
function doSave() {
	consts.easygrid.saveEdit();
}
//추가 처리
function doAppend() {
	
	//현재 모든 행
	var rows = consts.easygrid.getRows();
	
	//추가데이터 가져오기
	var obj = jsystem.append(rows);
	
	if (obj == null)
		return;
	
	consts.easygrid.appendRow(obj);
}
