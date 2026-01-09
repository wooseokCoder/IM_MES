/**
 * 사용자관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 팝업 상세조회
 * 폼 팝업 등록,수정,삭제
 */

var jcomboProg  = {};
jcomboProg.load = function(args, flg) {
	var flag   = (flg ? flg : 1);
	var items  = [];
	var params = {};

	/*if (typeof args == 'string') {
		params.codeGrup = args;
	}
	else {
		params = args;
	}
*/
    $.ajax({
        url: getUrl('/common/code/screenterm/selectProgKeyList.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: params,
        success: function(data){

        	if (!data)
        		return;
        	if (!data.rows)
        		return;

            items = $.map(data.rows, function(item) {

            	if (flag == 9)
            		return item;

            	var obj = {value:'', text:''};

            	switch(flag) {
            		case 1: obj = {value: item.PROG_ID,   text: item.PROG_NAME}; break;
            		/*case 2: obj = {value: item.codeCd,   text: item.codeName+ '['+item.codeCd+']'};   break;
            		case 3: obj = {value: item.codeCd,   text: item.codeCd};   break;
            		case 4: obj = {value: item.codeName, text: item.codeName}; break;*/
            	}
            	return obj;
            });
        },
        error: function(){
        }
    });
    return items;
};

jcomboboxProg = function(args) {

	var objects   = this;

	var config = {
		combo:   'combobox',
		type:     1,
		params:   {},
		data:     [],
		autoload: false,
		options:  {}
	};

	if (args)
		$.extend(true, config, args);

	this.editor = function() {
		var ret = {
			type:    config.combo,
			options: config.options
		};
		ret.options['data'] = config.data;
		return ret;
	};
	this.formatter = function() {
		var p = this;
		return function(value) {
			return p.getItem(value);
		};
	};

	this.getData = function() {
		return config.data;
	},
	this.getItem = function(id) {

		var d  = config.data;
		var vf = config.options.valueField || 'value';
		var tf = config.options.textField  || 'text';

		for (var i=0; i<d.length; i++) {
			if (d[i][vf] == id) {
				return d[i][tf];
			}
		}
		return '';
	};
	this.load = function( params ) {

		if (config == false)
			return;

		if (params)
			config.params = params;

		config.data = jcomboProg.load(
			config.params,
			config.type
		);
	};

	if (config.autoload)
		this.load();

	return objects;
};

var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	admin:    gconsts.ADMIN,     //관리자  (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	domain:   false,   //사용자로그인용 도메인
	easygrid: false,   //기본컨트롤
	dialog:   false,   //팝업다이얼로그 컨트롤
/*	cellEdit: true,
	viewrecords: true,
	forceFit : true,*/
	url: {
		search: getUrl("/common/code/screenterm/search.json"),
		excel:  getUrl("/common/code/screenterm/download.do"),
		remove: getUrl("/common/code/screenterm/delete.json"),
		save:   getUrl("/common/code/screenterm/save.json")
	},
	combo: {
		progId : new jcomboboxProg({params:{'': ''}})
	},
	init: function() {
		
		$("#account-layout").fadeIn(300);

		this.combo.progId.load();

		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url:      this.url,
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form",
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'itemGrp',
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			//그리드 편집이벤트 바인딩
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

			}
		});

		//등록폼 초기화
		doClear();
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

	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	//추가버튼 클릭시 이벤트 바인딩
	$("#append-button").bind("click", doAppend);
	//저장버튼 클릭시 이벤트 바인딩
	$("#save-button"  ).bind("click", doSave);
	//삭제버튼 클릭시 이벤트 바인딩
	$("#remove-button").bind("click", doRemove);
	//엑셀다운로드
	$("#excel-button").bind("click", doExcel);


	//Enter 검색을 위한 추가
	$("#search-form").bind('keydown',function(events){
		if(events.keyCode == 13){
			doSearch();
		}
	});

	doLangSettingTable();

});

$(window).load(function() {

	setTimeout(function (){
		$("#account-layout").fadeIn(300);
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

	}, 100);
});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}

}

function doSave() {
	if(doubleSubmitCheck()){
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

//추가 처리
function doAppend() {
	consts.easygrid.appendEdit();
}

//검색 처리
function doSearch() {
	consts.easygrid.search();
}
//초기화 처리
function doClear() {
	consts.easygrid.clear();
}
//삭제 처리
function doRemove() {
	consts.easygrid.removeEdit();
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