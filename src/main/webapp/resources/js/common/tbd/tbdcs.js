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
	var newPw = $('#newPw').val();
	var chkPw = $('#chkPw').val();

	if(newPw == chkPw){
		var saveParams = new FormData();
		saveParams.append("userId", $('#userId').val());
		saveParams.append("newPw", newPw);

		$.ajax({
	        url: getUrl('/common/password/save.json'),
	        dataType: 'json',
	        async: false,
			processData: false,
	        contentType: false,
	        type: 'post',
	        data: saveParams,
	        success: function(data){
	        	$.messager.alert('Information',msg.MSG0117,'info');
	        },
	        error: function(){
	        }
	    });
	}else{
		$.messager.alert('Warning',msg.MSG0123,'warning');
	}
}