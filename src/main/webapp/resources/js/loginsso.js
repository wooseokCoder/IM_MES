var consts = {
	message: null,
	login: "login-area"
};
function doInit(args) {
	$.extend(consts, args);
}

$(function() {
	sessionStorage.setItem("currStat","Y");
	sessionStorage.setItem("userId",$("#username").val());
	
	//sso 로그인 한 시간 초기화
	sessionStorage.setItem('ssoTime', 0);
	setCookie("reportLogin", "N", 30);
	
	goSubmit({
        form: "login-form",
        url:  "/security_check.do"
    });
});


//2016/12/06 김영진 -- 쿠키로 한영전환
function checkLanguage(){
	var cName = getCookie('culture');
	cName = 'ko';
	//console.log(cName);
    if (cName == 'en') {
    	$('#language').val("en");
        enClick();
    } else  if (cName == 'vi') {
    	$('#language').val("vi");
    	viClick();
    } else {
    	$('#language').val("ko");
        krClick();
    }
}
//2016/12/06 김영진 -- 쿠키읽기
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if (start != -1) {
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if (end == -1) end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}
//2016/12/06 김영진 -- 한글화
function krClick() {
	devWidth = $("body").width();
	if(devWidth > 460){
		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main.png') no-repeat");
	}else{
		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form.png') no-repeat");
	}
	$('#submit-button').val("로그인");
	$('#id_save').html("아이디저장");
	setCookie("culture", "kr", 30);
}
//2020/01/10 김경환 -- 중어
function cnClick() {
	devWidth = $("body").width();
	if(devWidth > 460){
		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main.png') no-repeat");
	}else{
		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form.png') no-repeat");
	}
	$('#submit-button').val("登录");
	$('#id_save').html("存储用户名");
	$('#changePassword-button').html("发送密码复位");
	setCookie("culture", "cn", 30);
}
//2016/12/06 김영진 -- 영문화
function enClick() {
	devWidth = $("body").width();
	if(devWidth > 460){
		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main_en.png') no-repeat");
	}else{
		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form_en.png') no-repeat");
	}
	$('#submit-button').val("Login");
	$('#id_save').html("ID Save");
	setCookie("culture", "en", 30);
}
//2020/01/10 김경환 -- 포르투갈어
function ptClick() {
	devWidth = $("body").width();
	if(devWidth > 460){
		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main_en.png') no-repeat");
	}else{
		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form_en.png') no-repeat");
	}
	$('#submit-button').val("Login");
	$('#id_save').html("ID Salvar");
	$('#changePassword-button').html("Mande e-mail para restaurar a senha.");
	setCookie("culture", "pt", 30);
}

function viClick() {
	devWidth = $("body").width();
	if(devWidth > 460){
		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main_en.png') no-repeat");
	}else{
		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form_en.png') no-repeat");
	}
	$('#submit-button').val("Đăng nhập");
	$('#id_save').html("Lưu ID");
	setCookie("culture", "vi", 30);
}
//2016/12/06 김영진 -- 언어변경
function doLanguage(){
	var selected = $('#language').val();
	if(selected == "en"){
		enClick();
	}else if(selected == "cn"){
		cnClick();
	}else{
		ptClick();
	}
}
//2016/12/06 김영진 -- pc, mobile 화면전환
$(window).resize(function () { //resize는 브라우저 크기가 바뀔떄마다 발생되는 이벤트
    devWidth = $("body").width();
    var selected = $('#language').val();

    if (devWidth > 460) {
        if(selected == "en"){
        	$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main_en.png') no-repeat");
        }else{
    		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main.png') no-repeat");
        }
		$('.login-form-table').css("background", "");
    } else {
        /*if(selected == "en"){
    		$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form_en.png') no-repeat");
        }else{
    		$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form.png') no-repeat");
        }*/
		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main_sbg.png') no-repeat center top");
    }
});

////////////////////////////////////////////////////////////////////////////////
// 초기화 함수
////////////////////////////////////////////////////////////////////////////////
var COOKIE_NAME;
var cooKieValue = getCookie(COOKIE_NAME);
/**
 * 컴포넌트를 초기화한다.
 */
function initComp() {

    $("#username").val( getCookie("COOKIE_NAME") );

    // 아이디 필드를 포커스 한다.
    $("#username").focus();

}

/**
 * 이벤트를 바인딩한다.
 */
function bindEvent() {

    // 아이디 필드에 키다운 이벤트를 바인딩한다.
    $("#username").bind("keydown", function(event) {
        // 엔터키인 경우
        if (event.which == 13) {
            // 로그인을 처리한다.
            doLogin();
        }
    });

    // 비밀번호 필드에 키다운 이벤트를 바인딩한다.
    $("#password").bind("keydown", function(event) {
        // 엔터키인 경우
        if (event.which == 13) {
            // 로그인을 처리한다.
            doLogin();
        }
    });

    // 로그인 버튼에 클릭 이벤트를 바인딩한다.
    $("#submit-button").bind("click", function(event) {
        // 로그인을 처리한다.
        doLogin();
    });
}

/**
 * 로그인을 처리한다.
 */
function doLogin() {

	if (doValidation() == false)
		return;

	//아이디 대소문자 처리
	$.ajax({
        url: getUrl('/common/password/chkUserChar.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {sysId:'DPS'
        	 , userId:$("#username").val()},
        success: function(data){
        	if(data.rows != null){
        		$("#username").val(data.rows.USER_ID);
        	}
        },
        error: function(){
        }
    });
	
	//아이디저장 처리
	if ($("#remember").is(":checked")){
		setCookie(COOKIE_NAME, $("#username").val(), 30);
	}else{
		deleteCookie(COOKIE_NAME);
	}
	
	sessionStorage.setItem("currStat","Y");
	sessionStorage.setItem("userId",$("#username").val());

    // 로그인을 처리한다.
	$.ajax({
        url: getUrl('/common/password/userPwChk.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {sysId:'DPS'
        	 , gsUserId:$("#username").val()
        	 , oldPw:$("#password").val()},
        success: function(data){
        	if(data.rows != null){
        		goSubmit({
        	        form: "login-form",
        	        url:  "/security_check.do"
        	    });
        	}
        	else $.messager.alert('Warning',"Password doesn't match.",'Warning');
        },
        error: function(){
        }
    });
}

/**
 * 로그인시 VALIDATION
 *
 * @param options {Object} 옵션
 * @returns {Boolean} 검증결과
 */
function doValidation() {
    if ($("#username").val().isBlank()) {
        alert("Please enter your ID.");

        $("#username").focus();

        return false;
    }

    if ($("#password").val().isBlank()) {
        alert("Please enter your password.");

        $("#password").focus();

        return false;
    }

    return true;
}

//쿠키저장후 불러오기
function doIdLoad(){

	if(cooKieValue != ""){
		$("#username").val(cooKieValue);
		$("input:checkbox[id='remember']").prop("checked", true);
		$("#password").focus();
	}
}