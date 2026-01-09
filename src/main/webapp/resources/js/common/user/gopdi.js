/**
 * Parts(LSPO)를 처리하는 스크립트이다.
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
	url: {
	},
	init: function() {
		//등록폼 초기화
		doClear();
		doLink(consts.domain + 'login_sso.do');
	}
};

$(function() {

	consts.init();
	doLangSettingPage();

});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//초기화 처리
function doClear() {
	
}

function doLink(url) {
    
    var userId = "";
    
    $.ajax({
	    url: getUrl('/order/ordering/getIdWgbc.json'),
	    dataType: 'json',
	    async: false,
	    type: 'post',
	    data: {},
	    success: function(data){
	    	if(data.rows.length > 0) {
        		if(data.rows[0] == null) ;
        		else userId = data.rows[0].userId;
        	}
	    },
	    error: function(){
	    }
	});
    
    if(userId == "") {
    	$.messager.alert('Warning',"No WGBC Id.",'warning');	//$.messager.alert('Warning',msg.MSG0086,'warning');
    	return false;
    }
    
    var base64Str = btoa("USER_ID="+userId);
    
	$.ajax({
	    url: consts.domain + 'common/ftk/issuelsdp.do',
	    dataType: 'json',
	    async: false,
	    type: 'post',
	    data: {auth:base64Str},
	    success: function(data){
	      if(data.result == "SUCCESS") {
	    	var token = "USER_ID="+userId+"&TOKEN_NO="+data.TOKEN_NO+"&MENU=LS411";
    		var baseToken = btoa(token);
    		var win = window.open(url+"?auth="+baseToken, '_blank');
    		
    		$(window.parent.document.getElementsByClassName('tabs-selected')).children('.tabs-close')[0].click();
    	    win.focus();
	      }
	    },
	    error: function(){
	    }
	});
}

