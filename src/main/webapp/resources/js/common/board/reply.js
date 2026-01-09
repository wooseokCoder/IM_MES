/**
 * 답변게시판을 처리하는 스크립트이다.
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
	//추가버튼 클릭시 이벤트 바인딩
	$("#append-button").bind("click", doAppend);
	//펼침버튼 클릭시 이벤트 바인딩
	$("#expand-button").bind("click", doExpand);
});

//비활성인 경우 게시판제목 변경
jformat.bordTitle = function(val, row) {
	if (row.useFlag == 'N')
		return '<font color="gray">(삭제된 글입니다.)</font>';
	return val;
};

//그리드 설정
jgrid = {
	grid: false,
	//args.params   필수
	//args.title    필수
	//args.pageSize 필수
	//args.doSelect 필수
	init: function(args) {
		
		var cols = [{field:'bordTitle',halign:'center',align:'left',  width:400, title:'제목', sortable:true, formatter:jformat.bordTitle},
		            {field:'readCnt',  halign:'center',align:'right', width: 80, title:'조회수'},
		            {field:'regiName', halign:'center',align:'center',width: 80, title:'등록자'},
		            {field:'regiDate', halign:'center',align:'center',width:130, title:'등록일자'},
		            {field:'chngName', halign:'center',align:'center',width: 80, title:'수정자'},
		            {field:'chngDate', halign:'center',align:'center',width:130, title:'수정일자'}];
		
		//그리드 컨트롤 초기화
		this.grid = new jeasytree({
			url:      args.url,
			title:    args.title,
			gridKey:  "#search-grid",
			sformKey: "#search-form",
			gridOptions: {
				pageSize:     args.pageSize,
				queryParams:  $.extend({}, args.params),
				columns:      [cols],
				toolbar:      "#search-toolbar",
				idField:      'bordNo',
				treeField:    'bordTitle',
				fit:          true,
				onBeforeLoad:function(row, param) {
					if (row) {
						param.bordPno = row.bordNo;
					}
				},
				onLoadSuccess: function(row, data) {
					if (row && data.rows) {
						$(this).treegrid('append',{
							parent: row.id,
							data: data.rows
						});
					}
				}, 
				//그리드 행더블클릭시 상세조회팝업 오픈
				onDblClickRow:function(row) {
					args.doSelect(row);
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
	expandAll: function() {
		this.grid.expandAll();
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
	viewData: false, //상세조회 데이터
	url: {
		search: getUrl("/common/board/reply/search.json"),
		excel:  getUrl("/common/board/reply/download.do"),
		select: getUrl("/common/board/reply/select.json"),
		remove: getUrl("/common/board/reply/delete.json"),
		save:   getUrl("/common/board/reply/save.json"),
		form:   getUrl("/common/board/reply/form.do"),
		view:   getUrl("/common/board/reply/view.do")
	},
	params: {
		oper: jstatus.INSERT,
		sysId:    null,
		bordGrup: null,
		bordType: null,
		bordNo:   null,
		bordPno:  null,
		bordTitle:null
	},
	//사용가능기능 설정
	usable: {
		save:   true, //저장기능 사용여부
		update: true, //수정기능 사용여부
		remove: true, //삭제기능 사용여부
		reply:  true
	},
	init: function() {
		//그리드 초기화
		jgrid.init(this);
		//팝업폼 초기화
		jsystemboard.init(this);
		
	},
	//등록상태로 변경(params 변경)
	setInsert: function() {
		this.params.oper      = jstatus.INSERT;
		this.params.bordNo    = null;
		this.params.bordTitle = null;
		this.params.bordPno   = null;
	},
	//수정상태로 변경(params 변경)
	setUpdate: function() {
		this.params.oper  = jstatus.UPDATE;
	},
	//답변상태로 변경(params 변경)
	setReply: function() {
		this.params.oper  = jstatus.INSERT;
		this.params.bordNo    = null;
		this.params.bordTitle = '[답변]' 
			                  + this.viewData.bordTitle;
		this.params.bordPno   = this.viewData.bordNo;
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
		if (row.useFlag == 'N')
			return;
		
		this.viewData = row;
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
//추가버튼 클릭시 등록폼 오픈
function doAppend() {
	jsystemboard.open(jstatus.INSERT);
}
//펼침버튼 클릭시 그리드항목 모두 펼치기
function doExpand() {
	jgrid.expandAll();
}
