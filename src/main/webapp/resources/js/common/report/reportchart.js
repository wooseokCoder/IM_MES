/**
 * 사용자관리를 처리하는 스크립트이다.
 * 
 * 그리드 검색 및 페이징
 * 폼 팝업 상세조회
 * 폼 팝업 등록,수정,삭제
 */

var jcomboType  = {};
jcomboType.load = function(args, flg) {
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
        url: getUrl('/common/user2/user2/selectUserType.json'),
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
            		case 1: obj = {value: item.codeCd,   text: item.codeNm}; break;
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

jcomboboxType = function(args) {
	
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
		
		config.data = jcomboType.load(
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
	combo: {
		userType : new jcomboboxType({params:{'': ''}})
	},
	init: function() {
		this.combo.userType.load();
		
		//등록폼 초기화
		doClear();
	}
};

$(function() {
	consts.init();
	
	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	//Enter 검색을 위한 추가
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
	doLangSettingPage();
});

//화면 상수값 초기화
function doInit(args) {
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('uncheckAll');
	$('#hdfIndex').val("-1");
	$('#hdfChk').val("");
	
	//doIframe();
	
	if (args) {
		$.extend(consts, args);
	}
}

//iframe초기화
/*function doIframe(){
	var params = {};
	var reportUrl = "";
	$.ajax({
        url: getUrl('/common/report/reportUrl.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: params,
        success: function(data){
        	console.log(data.reportUrl);
        	if (!data)
        		return;
        	
        	reportUrl = data.reportUrl + "&reportUnit=/reports/easyFrame/reportCh"
        },
        error: function(){
        }
    });

    console.log(reportUrl);
    document.getElementById('iReport').src = ""+reportUrl;
}*/

//검색 처리
function doSearch() {
	var userType = $('#s_userType').next().find('input.textbox-value').val();
	if(userType == "" || userType == null || userType == "undefined") userType = "";
	
	var useFlag = $('#s_useFlag').next().find('input.textbox-value').val();
	if(useFlag == "" || useFlag == null || useFlag == "undefined") useFlag = "";
	
	var userId = $('#s_userId').next().find('input.textbox-value').val();
	if(userId == "" || userId == null || userId == "undefined") userId = "";
	
	var userName = $('#s_userName').next().find('input.textbox-value').val();
	if(userName == "" || userName == null || userName == "undefined") userName = "";

	var params = {};
	var reportUrl = "";
	$.ajax({
        url: getUrl('/common/report/reportUrl.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: params,
        success: function(data){
        	//
        	if (!data)
        		return;
        	
        	reportUrl = data.reportUrl + "&reportUnit=/reports/easyFrame/reportCh"
			  + "&P_SYS_ID=" + data.sysId
			  + "&P_USER_ID=" + userId
			  + "&P_USER_NAME=" + userName
			  + "&P_USER_TYPE=" + userType
			  + "&P_USE_FLAG=" + useFlag;
        },
        error: function(){
        }
    });

    //console.log(reportUrl);
    document.getElementById('iReport').src = reportUrl;
}
//초기화 처리
function doClear() {
	//consts.easygrid.clear();
}

//사용자유형값 포맷처리 (코드대신 명칭표시)
jformat.userType = function(val, row) {
	//사용자 유형칼럼의 콤보텍스트 표시
	if (jutils.empty(row.userTypeDesc))
		return val;
	return row.userTypeDesc;
};


