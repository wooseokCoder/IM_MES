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
	}
};

$(function() {

	consts.init();
	//저장버튼 클릭시 이벤트 바인딩
	$("#save-button").bind("click", doSave);
	doLangSettingPage();

});

$(window).load(function() {
	setTimeout(function (){
		$("#account-layout").fadeIn(300);
	}, 100);
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



//저장 처리
function doSave() {
//	debugger;
	var newPw = $('#newPw').val(); //이메일 pw
	var userId = $('#userId').val()+$('#userEmail').val(); // 이메일 id

	//lstractorusa.com
	if(newPw == '') {
		$.messager.alert('Information',msg.MSG0123,'info');
	}
	else{
		$.ajax({
	        url: getUrl('/common/emailinsert/save.json'),
	        dataType: 'json',
	        async: true,
	        type: 'post',
	        data: {SMTP_MAIL:userId
	        	 ,SMTP_PW:newPw
			 ,sysId:'IMMES'
	        	 ,userId:$("#userId").val()},
	        success: function(data){
	        	$.messager.alert('Information',msg.MSG0103,'info');
	        },
	        error: function(){
	        }
	    });
	}
}