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
		search: getUrl("/common/board/views/search.json")
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

	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);

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
	if($('#r_bordNo').val() == "" || $('#r_bordNo').val() == null) return;
	if($('#r_bordGrup').val() == "" || $('#r_bordGrup').val() == null) return;
	
	consts.easygrid.search();
}
//초기화 처리
function doClear() {
	consts.easygrid.clear();
}
