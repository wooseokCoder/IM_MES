/**
 * 전자메일관리를 처리하는 스크립트이다.
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
});

//그리드 설정
jgrid = {
	grid: false,
	//args.params   필수
	//args.title    필수
	//args.pageSize 필수
	//args.doSelect 필수
	init: function(args) {
		
		var type = args.params.pageType;
		var cols = [{field:'check',    halign:'center',align:'center',checkbox:true},
		            {field:'bordNo',   halign:'center',align:'center',width:100, title:'번호', sortable:true},
		            {field:'bordTitle',halign:'center',align:'left',  width:500, title:'제목', sortable:true}];
		
		var gcfg = {
			url:      args.url,
			title:    args.title,
			gridKey:  "#search-grid",
			sformKey: "#search-form",
			gridOptions: {
				pageSize:     args.pageSize,
				queryParams:  $.extend({}, args.params),
				toolbar:      "#search-toolbar",
				idField:      'bordNo', 
				onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
				fit:           true,
				selectOnCheck: true, 
				checkOnSelect: true
			}
		};
		
		//받은메일함인 경우
		if (type == 'R') {
			cols.push({field:'regiName', halign:'center',align:'center',width:100, title:'보낸사람', sortable:true});
			cols.push({field:'regiDate', halign:'center',align:'center',width:150, title:'발송일'  , sortable:true});
			cols.push({field:'readDate', halign:'center',align:'center',width:150, title:'확인일'  , sortable:true});
			
			$.extend(true, gcfg.gridOptions, {
				//칼럼정보 설정
				columns: [cols],
				//그리드 행더블클릭시 상세조회팝업 오픈
				onDblClickRow: function(index,row) {
					args.doSelect(row);
				}
			});

		}
		//보낸메일함인 경우
		else if (type == 'S') {
			cols.push({field:'regiDate', halign:'center',align:'center',width:150, title:'발송일', sortable:true});

			$.extend(true, gcfg.gridOptions, {
				//칼럼정보 설정
				columns: [cols],
				//서브그리드 설정
				view: detailview,
				detailFormatter:function(index,row){
					return '<div style="padding:2px"><table class="board-ddv"></table></div>';
				},
				onSelect: function(index, row) {
					$(this).datagrid('expandRow',index);
				},
				onExpandRow: function(index,row){
					var ggrid = $(this);
					var dgrid = $(this).datagrid('getRowDetail',index).find('table.board-ddv');
					dgrid.datagrid({
						url: args.url.item,
						queryParams: {
							sysId:     row.sysId,
							bordNo:    row.bordNo,
							bordGrup:  row.bordGrup
						},
						singleSelect: true,
						rownumbers: true,
						height:    'auto',
						columns:[[
						    {field:'tgtName'  ,align:'center',width: 80,title:'받는사람'},
						    {field:'tgtUserId',align:'center',width: 80,title:'받는사람ID'},
						    {field:'vndrName' ,align:'left'  ,width:150,title:'부서명'},
						    {field:'readDate' ,align:'center',width:150,title:'확인일'}
						]],
						onSelect: function(index,row) {
							args.doSelect(row);
						},
						onResize:function(){
							ggrid.datagrid('fixDetailRowHeight',index);
						},
						onLoadSuccess:function(){
							setTimeout(function(){
								ggrid.datagrid('fixDetailRowHeight',index);
							},0);
						}
					});
					ggrid.datagrid('fixDetailRowHeight',index);
				}
			});
		}

		//그리드 컨트롤 초기화
		this.grid = new jeasygrid(gcfg);
		
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

//화면 컨트롤 객체
consts = {
	sysId: false,    //시스템ID
	title: false,    //제목
	pageSize: false, //출력수
	bordName: false, //게시판 명칭
	bordGrup: false, //게시판그룹
	bordType: false, //게시판게시타입
	pageType: false, //화면타입(R:받은메일함,S:보낸메일함)
	url: {
		search: getUrl("/common/board/email/search.json"),
		excel:  getUrl("/common/board/email/download.do"),
		select: getUrl("/common/board/email/select.json"),
		remove: getUrl("/common/board/email/delete.json"),
		save:   getUrl("/common/board/email/save.json"),
		form:   getUrl("/common/board/email/form.do"),
		view:   getUrl("/common/board/email/view.do"),
		item:   getUrl("/common/board/email/searchItem.json")
	},
	params: {
		oper: jstatus.INSERT,
		sysId:    null,
		bordGrup: null,
		bordType: null,
		pageType: null,
		bordNo:   null
	},
	//사용가능기능 설정
	usable: {
		save:   true,  //저장기능 사용여부
		update: false, //수정기능 사용여부
		remove: false  //삭제기능 사용여부
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
			bordType: consts.bordType,
			pageType: consts.pageType
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
	jsystemboard.open(jstatus.INSERT, '작성하기');
}
