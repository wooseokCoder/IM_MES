var consts = {
	message: null,
	login: "login-area"
};
function doInit(args) {
	$.extend(consts, args);
}

//2016/12/06 김영진 -- 쿠키로 한영전환
function checkLanguage(){
	var cName = getCookie('culture');
	if (cName == 'ko') {
    	$('#language').val("ko");
        koClick();
    } else if (cName == 'zh') {
    	$('#language').val("zh");
    	zhClick();
    } else if (cName == 'en') {
    	$('#language').val("en");
        enClick();
    } else {
    	$('#language').val("ko");
        koClick();
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
function koClick() {
	devWidth = $("body").width();
	if(devWidth > 460){
		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main.png') no-repeat");
	}else{
		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form.png') no-repeat");
	}
	$('input:text').attr('placeholder','아이디');
	$('input:password').attr('placeholder','비밀번호');
	$('#deal-title').html("사출 MES");
	$('#submit-button').val("로그인");
	$('#id_save').html("아이디 저장");
	$('#changePassword-button').html("비밀번호 재설정 메일 발송");
	setCookie("culture", "ko", 30);
}
//2016/12/06 김영진 -- 영문화
//function enClick() {
//	devWidth = $("body").width();
//	if(devWidth > 460){
//		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main_en.png') no-repeat");
//	}else{
//		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form_en.png') no-repeat");
//	}
//	$('#submit-button').val("Login");
//	$('#id_save').html("ID Save");
//	setCookie("culture", "en", 30);
//}

//function viClick() {
//	devWidth = $("body").width();
//	if(devWidth > 460){
//		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main_en.png') no-repeat");
//	}else{
//		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form_en.png') no-repeat");
//	}
//	$('#submit-button').val("Đăng nhập");
//	$('#id_save').html("Lưu ID");
//	setCookie("culture", "vi", 30);
//}

//2020/01/10 김경환 -- 영어
function enClick() {
	devWidth = $("body").width();
	if(devWidth > 460){
		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main_en.png') no-repeat");
	}else{
		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form_en.png') no-repeat");
	}
	$('input:text').attr('placeholder','ID');
	$('input:password').attr('placeholder','PASSWORD');
	$('#deal-title').html("Injection MES");
	$('#submit-button').val("Login");
	$('#id_save').html("ID Save");
	$('#changePassword-button').html("Send mail for password reset");
	setCookie("culture", "en", 30);
}

//2020/01/10 김경환 -- 중국어
function zhClick() {
	devWidth = $("body").width();
	if(devWidth > 460){
		$('.lg-login-pg .login-pg-img').css("background", "url('"+context+"/resources/images/login/login_main_en.png') no-repeat");
	}else{
		//$('.login-form-table').css("background", "url('"+context+"/resources/images/login/login_main_bg_form_en.png') no-repeat");
	}
	$('input:text').attr('placeholder','用户名');
	$('input:password').attr('placeholder','密码');
	$('#deal-title').html("注塑MES");
	$('#submit-button').val("登录");
	$('#id_save').html("保存ID");
	$('#changePassword-button').html("发送邮件重置密码");
	setCookie("culture", "zh", 30);
}
//2016/12/06 김영진 -- 언어변경
//function doLanguage(){
//	var selected = $('#language').val();
//	if(selected == "en"){
//		enClick();
//	}else if(selected == "vi"){
//		viClick();
//	}else{
//		krClick();
//	}
//}
function doLanguage(){
	var selected = $('#language').val();
	if(selected == "ko"){
		koClick();
	}else if(selected == "zh"){
		zhClick();
	}else{
		enClick();
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

$(function() {

	var msg = consts.message;
	var url = window.location;

	if (window.parent &&
		window.location != window.parent.location) {
		//alert('parent');
		window.parent.location = url;
		return;
	}
//	if (window.opener) {
//		alert('opener');
//		window.opener.location = url;
//		window.close();
//		return;
//	}

	if (msg.length > 0) {
		alert(msg);

	    if (window.opener) {
	        window.close();
	    }
		return;
	}

	$("#"+consts.login).show();

	// 컴포넌트를 초기화한다.
    initComp();

    // 이벤트를 바인딩한다.
    bindEvent();

    //쿠키에 저장된 값 불러오기
    doIdLoad();

    checkLanguage();
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


	/*
	if(rslt != "XX") {
		 if (rslt == "E1") {
			 alert('접속실패!!!!! 아이디를 정확히 확인바랍니다.');
		 } else if (rslt == "E2") {
			 alert('죄송합니다.해당사용자의 패스워드를 변경한지 30일이 지났습니다. \n 비밀 번호 변경 화면을 클릭하시고 비밀번호 변경후 접속하시기 바랍니다.\n비밀번호 변경은 바로정비시스템에서 사용하시면 됩니다.');
		 } else if (rslt == "E3") {
			 alert('접속실패!!!!! 패스워드를 확인바랍니다.');
		 } else if (rslt == "E5") {
			 alert('해당사용자가 정확히 확인이 되지 않습니다(위즈빌로 연락바랍니다).');
		 } else if (rslt == "E6") {
			 alert('접속실패!!!!! 패스워드 오입력 3회 이상 실패로 자동으로 접속이 중단되었습니다.\n위즈빌로 연락바랍니다.');
		 }
	 }
	 */
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
 * 로딩 오버레이 표시
 */
function showLoginLoading() {
	$('#login-loading-overlay').addClass('show');
}

/**
 * 로딩 오버레이 숨기기
 */
function hideLoginLoading() {
	$('#login-loading-overlay').removeClass('show');
}

/**
 * 로그인을 처리한다.
 */
function doLogin() {

	if (doValidation() == false)
		return;

	// 로딩 오버레이 표시
	showLoginLoading();

	setCookie("reportLogin", "N", 30);

	var errMsg;
	//아이디 대소문자 처리
	$.ajax({
        url: getUrl('/common/password/chkUserChar.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {sysId:'IMMES'
        	 , userId:$("#username").val()},
        success: function(data){
        	const rows = data.rows;
        	const hasRows = rows != null;
        	const inputUsername = $("#username").val();
        	const isOldUserIdEmpty = hasRows && rows.oldUserId === "";
        	const isMatchingUserId = hasRows && (rows.USER_ID).toLowerCase() === inputUsername.toLowerCase();

        	if (hasRows && (isOldUserIdEmpty || isMatchingUserId)) {
        	    $("#username").val(rows.USER_ID);
        	    errMsg = rows.LockYn;
        	} else if (!hasRows) {
        	    errMsg = 'NoID';
        	} else if (rows.oldUserId !== "" && rows.orgAuthCode === "DEAL" && rows.USER_ID !== inputUsername) {
        	    errMsg = 'OldID';
        	}
        },
        error: function(){
        	hideLoginLoading();
        }
    });

	if(errMsg == 'NoID'){
		hideLoginLoading();
		if($('#language').val() == 'en'){
			$.messager.alert('Warning',"This is an unregistered ID.",'Warning');
		}else if($('#language').val() == 'ko'){
			$.messager.alert('경고',"등록되지 않은 아이디입니다.",'경고');
    	}else{
    		$.messager.alert('警告',"此ID未注册。",'警告');
    	}
		return false;
	}

	if(errMsg == 'OldID') {
		location.href=getUrl("/changeoldid.do?lang="+$('#language').val()+"&userId=" + encodeURIComponent($("#username").val()));
		return false;
	}

	if(errMsg != 'Y' && errMsg != 'OldID'){
		hideLoginLoading();
		if($('#language').val() == 'en'){
			$.messager.alert('Warning',"Please contact your System Manager.",'Warning');
		}else if($('#language').val() == 'ko'){
			$.messager.alert('경고',"시스템 관리자에게 문의하세요.",'경고');
    	}else{
    		$.messager.alert('警告',"请联系系统管理员。",'警告');
    	}
		return false;
	}




	//아이디저장 처리
	if ($("#remember").is(":checked")){
		setCookie(COOKIE_NAME, $("#username").val(), 30);
	}else{
		deleteCookie(COOKIE_NAME);
	}

	sessionStorage.setItem("currStat","Y");
	sessionStorage.setItem("userId",$("#username").val());

	//sso 로그인 한 시간 초기화
	sessionStorage.setItem('ssoTime', 0);

    // 로그인을 처리한다.
	$.ajax({
        url: getUrl('/common/password/userPwChk2.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {sysId:'IMMES'
        	 , gsUserId:$("#username").val()
        	 , oldPw:$("#password").val()},
        success: function(data){
        	if(data.rows != null){
        		goSubmit({
        	        form: "login-form",
        	        url:  "/security_check.do"
        	    });
        	}else {
        		hideLoginLoading();
        		if($('#language').val() == 'en'){
        			$.messager.alert('Warning',"Password doesn't match.",'Warning');
        		}else if($('#language').val() == 'ko'){
        			$.messager.alert('경고',"비밀번호가 일치하지 않습니다.",'경고');
            	}else{
            		$.messager.alert('警告',"密码不匹配。",'警告');
            	}
        	}
        },
        error: function(){
        	hideLoginLoading();
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
    	if($('#language').val() == 'en'){
    		alert("Please enter your ID.");
    	}else if($('#language').val() == 'ko'){
    		alert("아이디를 입력하세요.");
    	}else{
    		alert("请输入您的ID。");
    	}

        $("#username").focus();

        return false;
    }

    if ($("#password").val().isBlank()) {
    	if($('#language').val() == 'en'){
    		alert("Please enter your password.");
    	}else if($('#language').val() == 'ko'){
    		alert("비밀번호를 입력하세요.");
    	}else{
    		alert("请输入您的密码。");
    	}

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