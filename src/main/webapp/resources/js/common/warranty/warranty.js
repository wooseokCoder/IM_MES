/**
 * 코드관리를 처리하는 스크립트이다.
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
		//save:   getUrl("/common/code/save.json")
	},
	init: function() {
		//등록폼 초기화
		doClear();
		doLink('https://lws.lsmtron.com/');
	}
};

$(function() {

	consts.init();
	//저장버튼 클릭시 이벤트 바인딩
	//$("#save-button").bind("click", doSave);
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
	;
}

/*function doLink(url) {
    var win = window.open(url, '_blank');
    console.log($(window.parent.document.getElementsByClassName('tabs-selected')).children('.tabs-close'));
    $(window.parent.document.getElementsByClassName('tabs-selected')).children('.tabs-close')[0].click();
    win.focus();
}*/
function doLink(url) {
	//$.messager.alert('Warning','LS Warranty system is under maintanance until 03/17/2020','warning');
	var now = new Date();
    var year= now.getFullYear();
    var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
    var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
    var hour = now.getHours();
    var min = now.getMinutes();
    var snd = now.getSeconds();
    
    var userId = "";
    $.ajax({
	    url: getUrl('/order/ordering/getIdLws.json'),
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
    /*if(userId == "") {
    	$.messager.alert('Warning',"No Lspo Id.",'warning');	//$.messager.alert('Warning',msg.MSG0086,'warning');
    	return false;
    }*/
    
	//var userId = $("#hUserId").val();
	var reqDate = year+mon+day+hour+min+snd;
	var param = "USER_ID="+userId+"&RQST_URL="+url+"&RQST_DTTM="+reqDate;
	var base64Str = btoa(param);
	$.ajax({
	    url: getUrl('/common/ftk/issue.do'),
	    dataType: 'json',
	    async: false,
	    type: 'post',
	    data: {auth:base64Str},
	    success: function(data){
	    	if(data.RESULT == "SUCCESS") {
	    		var token = "USER_ID="+userId+"&FTOKEN_NO="+data.TOKEN_NO;
	    		var baseToken = btoa(token);
	    		var win = window.open(url+"?auth="+baseToken, '_blank');
	    		console.log("url",url+"?auth="+baseToken);
	    		$(window.parent.document.getElementsByClassName('tabs-selected')).children('.tabs-close')[0].click();
	    	    win.focus();
	    	}
	    },
	    error: function(){
	    }
	});
}

