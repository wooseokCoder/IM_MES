/**
 * Sales Program을 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 등록,수정,삭제 페이지이동 처리
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

});

$(window).load(function() {

	setTimeout(function (){

		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click",  doExcel);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//등록버튼 클릭시 이벤트 바인딩
		$("#regist-button").bind("click", doRegist);
		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});
		
		$("#s_searchKey").combobox({
			onChange:function(newValue,oldValue){
				if(newValue == "S05") {
					$("#searchExt").hide();
					$("#writeDate").show();
				}
				else {
					$("#writeDate").hide();
					$("#searchExt").show();
				}
			}
		});

		doSearch();

	}, 100);

	doLangSettingTable();

});

//그리드 설정
jgrid = {
	grid: false,
	//args.params   필수
	//args.title    필수
	//args.rows     필수
	//args.doSelect 필수
	init: function(args) {

		var cols = [{field:'check',     halign:'center',align:'center',checkbox:true},
					{field:'BORDNO1',   halign:'center',align:'center',width:100, title:'No', sortable:true, data_item:"GRD_001"},
		            {field:'BORDTITLE1',halign:'center',align:'left',  width:640, title:'Title', sortable:true, data_item:"GRD_002"},
		            {field:'bordNo',    halign:'center',align:'center',width:100, title:'No', sortable:true,hidden:true},
		            {field:'bordTitle', halign:'center',align:'left',  width:640, title:'Title', sortable:true,hidden:true},
		            {field:'readCnt',   halign:'center',align:'center',width: 80, title:'View', data_item:"GRD_003"},
		            {field:'regiName',  halign:'center',align:'center',width:120, title:'Writer', data_item:"GRD_004"},
		            {field:'regiDate',  halign:'center',align:'center',width:130, title:'Write date', data_item:"GRD_005"},
		            {field:'chngName',  halign:'center',align:'center',width:120, title:'Updater', data_item:"GRD_006"},
		            {field:'chngDate',  halign:'center',align:'center',width:130, title:'Update date', data_item:"GRD_007"},
		            {field:'fileCnt',   halign:'center',align:'center',width:50,  title:'Att', data_item:'GRD_008', formatter:jformat.filecnt}];
					/*{field:'bordBgn',  halign:'center',align:'center',width:120, title:'Start date', data_item:"GRD_008"},
			        {field:'bordEnd',  halign:'center',align:'center',width:120, title:'End date', data_item:"GRD_009"}*/

		//그리드 컨트롤 초기화
		this.grid = new jeasygrid({
			url:      args.url,
			title:    false,	//args.title,
			gridKey:  "#search-grid",
			sformKey: "#search-form",
			gridOptions: {
				pageSize:     args.rows,
				pageNumber:   args.page,
				queryParams:  $.extend({}, args.params),
				columns:      [cols],
				toolbar:      "#search-toolbar",
				idField:      'bordNo',
				rownumbers:	  false,
				onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
				fit:          true,
				selectOnCheck:true,
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
	get: function() {
		return this.grid.grid;
	},
	getSearchObject: function() {
		return this.grid.getSearchObject();
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
	sysId:    false, //시스템ID
	title:    false, //제목
	rows:     false, //출력수
	page:     false, //페이지
	bordGrup: false, //게시판그룹
	bordType: false, //게시판게시타입
	formKey: "hidden-form",
	url: {
		search: getUrl("/common/board/salebulletin/search.json"),
		excel:  getUrl("/common/board/salebulletin/download.do"),
		select: getUrl("/common/board/salebulletin/select.json"),
		remove: getUrl("/common/board/salebulletin/delete.json"),
		form:   getUrl("/common/board/salebulletin/form.do"),
		view:   getUrl("/common/board/salebulletin/view.do")
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

		//게시판 초기화
		jboard.init({
			consts: this,
			url:    this.url,
			params: this.params,
			title:  this.title,
			//등록폼 KEY (#포함)
			formKey: "#"+this.formKey
		});
	},
	setParams: function(args) {
		for(var p in args) {
			this.params[p] = args[p];
		}
	},
	doResult: function(res, callback) {
		jgrid.result(res, callback);
	},
	//검색데이터 설정하기
	setSearchObject: function() {
		//검색데이터 가져오기
		var data = jgrid.getSearchObject();
		//히든폼 가져오기
		var form = jboard.form;
		//히든폼에 검색데이터 셋팅하기
		form.toForm(data);
	},
	//상세조회 페이지로 이동
	doSelect: function(row) {
		this.setSearchObject();
		jboard.doSelect(row);
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
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	jgrid.remove();
}
//등록버튼 클릭시 등록페이지로 이동
function doRegist() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	consts.setSearchObject();
	jboard.doRegist();
}
