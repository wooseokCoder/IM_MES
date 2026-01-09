/**
 * 화면관리를 처리하는 스크립트이다.
 *
 * 그리드 검색
 * 그리드 다중 편집
 * 그리드 다중 저장
 */

jcombo.load = function(args, flg) {
	var flag   = (flg ? flg : 1);
	var items  = [];
	var params = {};

    items.push({value:'Normal', text:'Normal'});
    items.push({value:'Board', text:'Board'});
    
    return items;
};

var consts = {
	sysId: false,    //시스템ID
	title: false,    //제목
	pageSize: false, //출력수
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/common/user/program/search.json"),
		excel:  getUrl("/common/user/program/download.do"),
		save:   getUrl("/common/user/program/save.json")
	},
	combo: {
		Pattern : new jcombobox({params : {codeGrup : ''}
		}) 
	},
	init: function() {
		this.combo.Pattern.load();
		
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				excel:  getUrl("/common/user/program/download.do"),
				save:   getUrl("/common/user/program/save.json")
			},
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'progId',
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect: true,
			//그리드 편집이벤트 바인딩
			onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			onLoadSuccess:function(){
				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			}
		});

	}
};

$(function() {

	consts.init();

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
		
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					doSearch();
				}
			});
		});
		
		$(".easyui-combobox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.combobox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					doSearch();
				}
			});
		});

		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button"  ).bind("click", doSave);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);

		//Enter 검색을 위한 추가
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keyup', function(e){
				itemid.textbox('setValue', $(this).val());
			});
		});

		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			$(".easyui-textbox").each(function(index, item){
				var itemid = $("#"+item.id);
				itemid.textbox('textbox').bind('keyup', function(e){
					itemid.textbox('setValue', $(this).val());
				});
			});
			if(events.keyCode == 13){
				doSearch();
			}
		});

	}, 100);

	doLangSettingTable();

});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//검색 처리
function doSearch() {
	//consts.easygrid.search();
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.search(consts.url.search);
}



//엑셀 다운로드
function doExcel() {
	   $('#progress-popup').dialog('open');

	   consts.easygrid.download();

	   $(document).ready(function() {
	       $(window).blur(function() {
	          $('#progress-popup').dialog('close');
	       });
	   });
}

//초기화 처리
function doClear() {
	consts.easygrid.clear();
}
//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.appendEdit();
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
	if(doubleSubmitCheck()){
		if($('#'+this.id).hasClass('l-btn-disabled')){
		      return false;
		   }
		consts.easygrid.saveEdit();
	}
}
//중복 submit 방지
var doubleSubmitFlag = true;
function doubleSubmitCheck(){
    if(doubleSubmitFlag){
    	
    	doubleSubmitFlag = false;
    	setTimeout(function () {
    		doubleSubmitFlag = true;
        }, 3000)
        return true;
    }else{
    	
        return false;
    }
}


//초기화
function doReload(){

	$("#progId").textbox('setValue','');
	$("#progName").textbox('setValue','');


}
function formatCheck(value,row,index){
	var d;
	if(value == '1' || value == 'Y' ) d = '<input type="checkbox" checked/>';
	else d = '<input type="checkbox" />';
	return d;
}
