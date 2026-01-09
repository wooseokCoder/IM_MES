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
	// 메일 버튼에 클릭 이벤트를 바인딩한다.
    $("#submit-button").bind("click", function(event) {
        // 메일을 처리한다.
        doChangePassword();
    });
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

function doChangePassword() {
	if ($("#username").val().isBlank()) {
		if($("#gsLang").val() == "en"){
			alert("Please enter your ID.");
		}else if($("#gsLang").val() == "pt"){
			alert("Por favor, insira seu ID.");
		}
        $("#username").focus();
        return false;
    }
    if ($("#email").val().isBlank()) {
    	if($("#gsLang").val() == "en"){
    		alert("Please enter your E-Mail.");
		}else if($("#gsLang").val() == "pt"){
			alert("Por favor introduza o seu e-mail.");
		}
        
        $("#email").focus();
        return false;
    }
    if($("#gsLang").val() == "en"){
		var bordTitle = 'Alerts - Your password has been changed.'
	}else if($("#gsLang").val() == "pt"){
		var bordTitle = 'Alertas - Sua senha foi mudada.'
	}
	
    
    $.ajax({
        url: getUrl('/common/password/emailCheck.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {sysId:'IMMES'
        	 , userId:$("#username").val()
        	 , email:$("#email").val()
        	 , mail_to:$("#email").val()
        	 , mail_cc:''
        	 , bordTitle:bordTitle
        	 , bordText:''},
        success: function(data){
        	if(data.rows != null){
//        		$.messager.show({
//          			title: 'Information',
//          			msg: "Your password has been sent."
//          		});
        		if($("#gsLang").val() == "en"){
        			$.messager.alert('Warning',"e-mail was sent,<br> Please reset your password from <br>your e-mail.",null, function(){location.href=getUrl("/login.do");});
        		}else if($("#gsLang").val() == "pt"){
        			$.messager.alert('Aviso',"e-mail foi enviado, <br> Por favor redefina sua senha de <br>seu e-mail.",null, function(){location.href=getUrl("/login.do");});
        		}
        		
//        		$.messager.alert({
//        			title: 'Warning',
//        			msg: 'e-mail was sent, Please reset your password from your e-mail.',
//        			fn: function(){ 
//        				location.href=getUrl("/login.do");
//        			}
//        		});
        		
        	}
        	else {
        		if($("#gsLang").val() == "en"){
        			$.messager.alert('Warning',"Please check your ID or E-mail.",'Warning');
        		}else if($("#gsLang").val() == "pt"){
        			$.messager.alert('Aviso',"Por favor, verifique sua identidade ou e-mail.",'Aviso');
        		}
        		
        	}
        },
        error: function(){
        }
    });
}