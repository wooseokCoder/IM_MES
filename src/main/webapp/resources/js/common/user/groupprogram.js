/**
 * 그룹별화면관리를 처리하는 스크립트이다.
 *
 * 그리드 검색
 * 그리드 다중 편집
 * 그리드 다중 저장
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
        url: getUrl('/common/user/groupprogram/selectProgList.json'),
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
	/*title:    gconsts.TITLE,     //화면제목 (common.jsp)*/
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/common/user/groupprogram/search.json"),
		excel:  getUrl("/common/user/groupprogram/download.do"),
		save:   getUrl("/common/user/groupprogram/save.json")
	},
	combo: {
		progId : new jcomboboxProg({params:{'': ''}})
	},
	init: function() {

		this.combo.progId.load();

		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				excel:  getUrl("/common/user/groupprogram/download.do"),
				save:   getUrl("/common/user/groupprogram/save.json")
			},
			title:    this.title,
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			//onResize: doResize_Multi, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect: true,
			idField:  'progId',
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

				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			}
		});

		$('#progress-popup').dialog({
				       title: tit.TITLE0009,
				       top:     100,
				       width: 200,
				       height: 200,
				       closed: true,
				       modal: true,
				       resizable: false
				   });


		//시스템그리드 초기화
		jsystem.init("GP", this.pageSize);
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
	//그룹목록 검색 TODO 김원국 수정
	$("#group-button").bind("click", doGroupSearch);
	//화면목록 검색 TODO 김원국 수정
	$("#prog-button").bind("click", doProgSearch);
	//초기화버튼 클릭시 이벤트바인딩
	$("#dreload-button"  ).bind("click", doReload);

	//Enter 검색을 위한 추가
	$("#group-form").bind('keydown',function(events){
		if(events.keyCode == 13){
			doGroupSearch();
		}
	});

	//Enter 검색을 위한 추가
	$("#prog-form").bind('keydown',function(events){
		if(events.keyCode == 13){
			doProgSearch();
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

	});
});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}
//모든 그리드 초기화
/*BBUG.KWK 20150729
 * this.easygrid.reload(); -> consts.easygrid.reload(); 오류가 있어서 수정
 * jsystem.unbind(); 추가
 * consts.easygrid.search(); 추가
 */
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
	//jsystem.bind();
	//consts.easygrid.search();

	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.search(consts.url.search);
}

//그룹목록 검색 처리
//TODO 김원국 수정
function doGroupSearch(){
	jsystem.ggrid.search();
}

//그룹목록 검색 처리
//TODO 김원국 수정
function doProgSearch(){
	jsystem.pgrid.search();
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
//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

/*	//현재 모든 행
	var rows = consts.easygrid.getRows();
	

	//추가데이터 가져오기
	var obj = jsystem.append(rows);

	if (obj == null)
		return;

	consts.easygrid.appendRow(obj);*/
	if($("#groupId").combobox('getValue') == ''){
		$.messager.alert('Warning',msg.MSG0031,'warning');
		return;
	}

	param = {groupId:$("#groupId").combobox('getValue')
			,groupName:$("#groupId").combobox('getText')}
	consts.easygrid.appendEdit(param);
}

//초기화
function doReload(){

	$("#groupId").combobox('setValue','');

}
//검색영역 코드그룹 변경 이벤트
function doGrupChange(){
	doSearch();
}

function formatCheck(value,row,index){
	var d;
	if(value == '1' || value == 'Y' ) d = '<input type="checkbox" checked/>';
	else d = '<input type="checkbox" />';
	return d;
}