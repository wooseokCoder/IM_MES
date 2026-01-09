/**
 * 모델관리를 처리하는 스크립트이다.
 * 
 * 그리드 검색 및 페이징
 * 폼 패널 상세조회
 * 폼 패널 등록,수정,삭제
 */

var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	combo: {
		admIdx: new jcombobox({params:{codeGrup: 'ADM_IDX'}}),
		modelLoc: new jcombobox({params:{codeGrup: 'STRG_TYPE'}})
	},
	url: {
		search: getUrl("/business/item/modelmanagement/search.json"),
		save:   getUrl("/business/item/modelmanagement/save.json")
	},
	init: function() {
		
		//콤보로딩
		this.combo.admIdx.load();
		this.combo.modelLoc.load();
		
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				save:   getUrl("/business/item/modelmanagement/save.json")
			},
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			singleSelect: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'modelNo',
			idField2:  'modelName',
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect: true,
			//그리드 편집이벤트 바인딩
			onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEditTwofield,
			onAfterEdit : this.easygrid.afterEdit,
			onLoadSuccess:function(){
				//Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item){
					var itemid = $("#"+item.id);
					itemid.textbox('textbox').bind('keyup', function(e){
						itemid.textbox('setValue', $(this).val());
					});
				});
				//doLangSettingTable();

				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화 
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			}
		});
	}
};

$(function() {

	consts.init();
	
	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	//추가버튼 클릭시 이벤트 바인딩
	$("#append-button").bind("click", doAppend);
	//삭제버튼 클릭시 이벤트 바인딩
	$("#remove-button").bind("click", doRemove);
	//저장버튼 클릭시 이벤트 바인딩
	$("#save-button").bind("click", doSave);
	//초기화버튼 클릭시 이벤트바인딩
	$("#dreload-button"  ).bind("click", doReload);
	
	//Enter 검색을 위한 추가
	$("#search-form").bind('keydown',function(events){
		if(events.keyCode == 13){
			doSearch();
		}
	});

	//최종
	setTimeout(function (){
		
			$("#admIdx").combobox('textbox').unbind('keydown').bind('keydown', function(e){					
				if (e.which === 13 ) {		
					doSearch();							
			    }	
			});
			$("#modelLoc").combobox('textbox').unbind('keydown').bind('keydown', function(e){					
				if (e.which === 13 ) {		
					doSearch();							
			    }	
			});
			
		},1000);
	
});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//검색 처리
function doSearch() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	//consts.easygrid.search();
	consts.easygrid.search(consts.url.search);
}
//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.appendEdit();
	//consts.easygrid.search(consts.url.search);
}
//삭제 처리
function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.removeEdit();
}
//저장 처리
function doSave() {	
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.saveEditCustom();
}

function doReload(){
	
		$("#modelName").textbox('setValue','');
		$("#admIdx").combobox('setValue','');
		$("#modelLoc").combobox('setValue','');	
		$("#stafName").textbox('setValue','');
		
	}
