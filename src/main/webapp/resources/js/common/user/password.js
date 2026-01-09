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

function checkPw(pw){
	
    var num  = pw.search(/[0-9]/g);
    var eng  = pw.search(/[a-z]/g);
    var engU = pw.search(/[A-Z]/g);
    var spe  = pw.search(/[#?!@$%^&*-]/gi);

    if(pw.search(/\s/) != -1){
        alert("No Space Input!");
        return false;
    }
    
    var cnt = 0;
    if(num >= 0) cnt++;
    if(eng >= 0) cnt++;
    if(engU >= 0) cnt++;
    if(spe >= 0) cnt++;
    
    if(cnt < 2){
        alert(msg.MSG0132);
        return false;
    }
    
    if(cnt == 2 && pw.length < 10){
        alert(msg.MSG0132);
        return false;
    }else if(cnt > 2 && pw.length < 8){
        alert(msg.MSG0133);
        return false;
    }else {
    	return true;
    }
}

//저장 처리
function doSave() {
	var newPw = $('#newPw').val();
	var chkPw = $('#chkPw').val();
	var userId = $('#userId').val();
	if(userId == "") {
		$.messager.alert(msg.MSG0122,msg.MSG0120,msg.MSG0122);
		return;
	}else if(chkPw == "" || newPw == "") {
		$.messager.alert(msg.MSG0122,msg.MSG0123,msg.MSG0122);
		return;
	}
	
	if(userId.substring(0,3) == "dev" && $('#gsUserId').val().substring(0,3) != "dev") {
		$.messager.alert(msg.MSG0122,msg.MSG0121,msg.MSG0122);
		return;
	}

	if(newPw == chkPw){
		
		//password Check
		if(!checkPw(newPw)){
			return;
		}
		
		var saveParams = new FormData();
		saveParams.append("userId", userId);
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
	        	$.messager.alert(msg.MSG0122,msg.MSG0117,msg.MSG0122);
	        },
	        error: function(){
	        }
	    });
	}else{
		$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
	}
}