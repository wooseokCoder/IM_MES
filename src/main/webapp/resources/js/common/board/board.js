/**
 * 게시판관리를 처리하는 스크립트이다.
 * 
 * 그리드 검색 및 페이징
 * 폼 팝업 상세조회
 * 폼 팝업 등록,수정,삭제
 */

//화면 컨트롤 객체
var consts = {};
//그리드 설정
var jgrid  = {};

$(function() {
	
	using("../../js/module/jupload.js", function() {
		using("../../js/module/jeditor.js", function() {
			using("../../js/module/jboard.js", function() {
				consts.init();
			});
		});
	});
	
	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	//엑셀버튼 클릭시 이벤트 바인딩
	$("#excel-button").bind("click",  doExcel);
	//삭제버튼 클릭시 이벤트 바인딩
	$("#remove-button").bind("click", doRemove);
	//추가버튼 클릭시 이벤트 바인딩
	$("#append-button").bind("click", doAppend);
	//Enter 검색을 위한 추가
	$("#search-form").bind('keydown',function(events){
		if(events.keyCode == 13){
			doSearch();
		}
	});
});

//그리드 설정
jgrid = {
	grid: false,
	//args.params   필수
	//args.title    필수
	//args.pageSize 필수
	//args.doSelect 필수
	init: function(args) {
		
		var cols = [{field:'check',    halign:'center',align:'center',checkbox:true},
		            {field:'bordNo',   halign:'center',align:'center',width:100, title:'번호', sortable:true},
		            {field:'bordTitle',halign:'center',align:'left',  width:400, title:'제목', sortable:true},
		            //{field:'bordBgn',  align:'center',width: 120, title:'시작일'},
		            //{field:'bordEnd',  align:'center',width: 120, title:'종료일'},
		            {field:'readCnt',  halign:'center',align:'right', width: 80, title:'조회수'},
		            {field:'regiName', halign:'center',align:'center',width: 80, title:'등록자'},
		            {field:'regiDate', halign:'center',align:'center',width:130, title:'등록일자'},
		            {field:'chngName', halign:'center',align:'center',width: 80, title:'수정자'},
		            {field:'chngDate', halign:'center',align:'center',width:130, title:'수정일자'}];
		
		//그리드 컨트롤 초기화
		this.grid = new jeasygrid({
			url:      args.url,
			title:    args.title,
			gridKey:  "#search-grid",
			sformKey: "#search-form",
			gridOptions: {
				pageSize:     args.pageSize,
				queryParams:  $.extend({}, args.params),
				columns:      [cols],
				toolbar:      "#search-toolbar",
				onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
				idField:      'bordNo', 
				fit:          true,
				selectOnCheck:true, 
				checkOnSelect:true,
				//그리드 행더블클릭시 상세조회팝업 오픈
				onDblClickRow:function(index, row) {
					args.doSelect(row);
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
			}
		});
	},
	search: function() {
		this.grid.search();
	},
	download: function() {
		this.grid.download();
	},
	remove: function() {
		this.grid.removeAll();
	},
	result: function(res, callback) {
		this.grid.reload();
		if (callback)
			callback();
	}
};

//화면컨트롤
consts = {
	sysId: false,    //시스템ID
	title: false,    //제목
	pageSize: false, //출력수
	bordGrup: false, //게시판그룹
	bordType: false, //게시판게시타입
	url: {
		search: getUrl("/common/board/search.json"),
		excel:  getUrl("/common/board/download.do"),
		select: getUrl("/common/board/select.json"),
		remove: getUrl("/common/board/delete.json"),
		save:   getUrl("/common/board/save.json"),
		form:   getUrl("/common/board/form.do"),
		view:   getUrl("/common/board/view.do")
	},
	params: {
		oper: jstatus.INSERT,
		sysId:    null,
		bordGrup: null,
		bordType: null,
		bordNo:   null
	},
	init: function() {
		//그리드 초기화
		jgrid.init(this);
		//팝업폼 초기화
		jsystemboard.init(this);
		
	},
	//등록상태로 변경(params 변경)
	setInsert: function() {
		this.params.oper  = jstatus.INSERT;
		this.params.bordNo = null;
	},
	//수정상태로 변경(params 변경)
	setUpdate: function() {
		
		this.params.oper  = jstatus.UPDATE;
	},
	setParams: function(args) {
		for(var p in args) {
			this.params[p] = args[p];
		}
	},
	getParams: function() {
		return this.params;
	},
	getTitle: function() {
		return this.title;
	},
	doResult: function(res, callback) {
		jgrid.result(res, callback);
	},
	doSelect: function(row) {
		$.extend(this.params, row);
		jsystemboard.open(jstatus.READ);
	}
};

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
		
		consts.setParams({
			sysId:    consts.sysId,
			bordGrup: consts.bordGrup,
			bordType: consts.bordType
		});
	}
}
//검색버튼 클릭시 그리드 검색
function doSearch() {
	jgrid.search();
}
//엑셀 다운로드
function doExcel() {
	jgrid.download();
}
//삭제버튼 클릭시 그리드 다중행삭제
function doRemove() {
	jgrid.remove();
}
//추가버튼 클릭시 등록폼 오픈
function doAppend() {
	jsystemboard.open(jstatus.INSERT);
}
