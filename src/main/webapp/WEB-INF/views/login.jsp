<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)login.jsp 1.0 2014/07/30                                           --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 로그인 화면이다.                                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<script type="text/javascript">
	 var context = "<c:out value="${pageContext.request.contextPath}" />";
</script>
<script type="text/javascript" src="<c:url value="/resources/js/login.js?v=251121A" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css?v=251110A" />" />
<%-- <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css" />" /> --%>
<%
	session.removeAttribute("tempId");
%>
<script type="text/javascript">
	 doInit({
		message: '${exception.message}'
	});

</script>
<script>

$(function() {

	$('#help-dialog').dialog({
		title : '로그인 사용자 아이디',// 샘플게시판 등록
		top : 10,
		width : 310,
		height : 400,
		closed : true,
		modal : true,
		resizable : true
	});

	$('#help-button').bind('click', doOpenPopup);


	$('#help-prod-dialog').dialog({
		title : '생산 로그인 사용자 아이디',// 샘플게시판 등록
		top : 10,
		width : 310,
		height : 400,
		closed : true,
		modal : true,
		resizable : true
	});

	$('#help-prod-button').bind('click', doOpenPopupProd);
// 	$('#changePassword-button').bind('click', doChangePassword);
$(function() {
	$('#changePassword-button').bind('click', doChangePassword);
})

	$('#language').on('change', function() {
		doLanguage();
	});
});

$(window).load(function() {
	$(".wui-dialog").show();
	


	const video = document.getElementById("mainVideo");
	const logoImg = document.getElementById("logo-white");

	video.addEventListener("timeupdate", () => {
	  const t = video.currentTime;

	  // 예: 5초~7초 구간에서 이미지 보이기
	  if (t >= 25.5) { 
		  //console.log("시간 : " + t);
		  //logoImg.style.display = "none";
		  logoImg.style.opacity = "0";
	  } else {
		  //console.log("시간 : " + t);
		  //logoImg.style.display = "block";
		  logoImg.style.opacity = "1";
	  }
	});


});

function openPopup(){
	console.log("openPOPup");
	 var url='http://cnode.iptime.org:8110/wsc/loginhelp.do'

	 PopupCenter(url, '로그인 도움', 400, 400)

}

function doOpenPopup() {
	$("#help-dialog").dialog('center');
	$("#help-dialog").dialog('open');
}

function doClosePopup() {
	$("#help-dialog").dialog('close');
}

function doOpenPopupProd() {
	$("#help-prod-dialog").dialog('center');
	$("#help-prod-dialog").dialog('open');
}

function doClosePopupProd() {
	$("#help-prod-dialog").dialog('close');
}

function doChangePassword() {
	location.href=getUrl("/changepassword.do?lang="+$('#language').val());
}


function PopupCenter(url, title, w, h) {
    // Fixes dual-screen position                         Most browsers      Firefox
    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : window.screenY;

    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var newWindow = window.open(url, title, 'scrollbars=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);

    // Puts focus on the newWindow
    if (window.focus) {
        newWindow.focus();
    }
}



</script>
<style>
.custom-id {
	font-weight: bold;
	padding-left: 25px;
	font-size: 15px;
}
.custom-content {
	font-size: 13px;
	padding-bottom: 3px;
	padding-left: 25px;
	color: #676767;
}
.custom-content1 {
	font-size: 13px;
	padding-left: 25px;
	padding-bottom: 20px;
}
.panel-title {
    font-weight: bold;
    height: 30px;
    line-height: 30px;
    color: #2985db;
	font-size: 17px;
	padding-bottom: 21px;
	padding-left: 18px;
}
.window {
    background-color: #ffffff;
}
.window, .window .window-body {
    border-color: #ffffff;
}
.custom-button {
	text-align:center;
}
.custom-button1 {
	text-align:right;
    padding: 6px 27px 7px;
    color: #444;
    letter-spacing: -1px;
    border: 0;
    background: #f1f1f1;
}

.login-body {
	margin: 0;
	min-height: 100vh;
	display: flex;
	align-items: center;
} 

.login-logo {
	display: flex;
	align-items: center;
	justify-content: center;
}

.login_btn_new2 {
	background-color: #002658;
	border: none;
	height: 40px;
	border-radius: 8px;
	font-size: 16px;
	width: 100%;
	color: #fff;
	margin-top: 25px;
	margin-bottom: 5px;
} 

input[type=button]:hover, button:hover, button:focus, button:active {
	background-color: #0057c9 !important;
	background: #0057c9 !important;
	border: none !important;
	height: 40px;
	color: #fff !important;
}

.login-body .login-section {
	width: 400px;
	height: 450px;;
	padding: 25px 30px;
	position: static;
	border-radius: 10px;
	/* opacity: 0.8; */
	background-color: rgba(255, 255, 255, 0.65);
}

.loginBox {
	width: 100% !important;
    height: 45px;
    margin-top: 10px;
}
/* 
.loginBox .box_icon {
	width: 40px;
}

.loginBox .box_ele {
	width: calc(100% - 40px);
}
 */
 
.loginInputSelect {
	width: 100%;
	height: 43px;
	border-radius: 22px;
	font-size: 15px;
	background-color: rgba(255, 255, 255, 0.8);
	text-indent: 20px;
}

.id_save {
	font-size: 14px;
	font-weight: 600;
}

.login-cont {
	z-index: 999;
	justify-content: center;
	align-items: center;
	width: 100%;
}

.login-cont-login {
	display: flex;
	height: 450px;
	width: 800px;
	min-width: 280px;
	width: 100%;
}

.login-maing-text {
	text-align: center;
	color: #8e95aa;
	font-size: 14px;
	font-weight: 400;
}

.login-body-back {
	background-color: #0a1e59;
	height: 50%;
	position: absolute;
	bottom: 0;
	left: 0;
	width: 100%;
}

.hrStyle {
	border: 1px solid #2d519a;
	margin-top: 30px;
	margin-bottom: 10px;
	width: 400px;
}

.login-section .login-maing-text1 {
	text-align: center;
	line-height: 1.1em;
	font-size: 40px;
	letter-spacing: -.01em;
	overflow: hidden;
	font-weight: 700;
	margin-bottom: 35px;
}

.login-width {
	width: 50%;
}

/* 배경 동영상 */
.bg-video {
	position: absolute;
	top: 0;
	left: 0;
	height: 100%;
	width: 100%;
	z-index: -1;
}

.bg-video_content {
	height: 100%;
	min-height: 500px;
	width: 100%;
	object-fit: cover;
}
/* 
.login_icon {
	height: 18px;
}
 */
.login-icon {
	width: 40px;
    height: 40px;
    display: flex;
    border-radius: 50%;
    border: 1px solid #c8c8c8;
    align-items: center;
    justify-content: center;
    /* background-color: #fff; */
    background-color: rgba(255, 255, 255, 0.8);
}

.login-icon img {
	height: 18px;
}

.login-input {
	border-radius: 22px;
	border: 1px solid #c8c8c8;
	width: calc(100% - 48px);
	margin-left: 8px;
	text-align: center;
    /* background-color: #fff; */
}

.sel-appr {
	appearance: none;
	line-height: 43px;
}

.logo-white {
   	display: block;
   	transition: opacity 3s ease; 
}
   
.logo-org {
   	display: none;
}


@media ( max-width : 768px) {
	.login-cont-login {
		flex-direction: column;
		height: 100%;
		align-items: center;
	}
	.login-width {
		width: 100%;
	}
	
	.login-logo {
    	margin-bottom: 20px;
    }
    
    .logo-white {
    	display: none;
    }
    
    .logo-org {
    	display: block;
    }
    
    .bg-video {
    	display: none;
    }
}

</style>
</head>

<body class="login-body">
	<div class="bg-video">
		<video id="mainVideo" class="bg-video_content" autoplay muted loop>
			<!-- <source src="https://monitoring.lstractor.co.kr/lsmd_data/upload/real/DASH/20250915_79057f20-023d-49e8-852f-34b587dad760.mp4" type="video/mp4" /> -->
			<source src="https://dealerportaldev.lstractorusa.com/lsdp_data/upload/real/COMM/login.mp4" type="video/mp4" />
			Your browser is not supported!
		</video>
	</div>

	<div class="login-cont">
		<div class="login-cont-login">
			<div class="tal login-logo login-width">
				<img id="logo-white" class="logo-white" src="<%=request.getContextPath()%>/resources/images/login_new/lsta_logo_white.png" style="height: 80px;">
				<img id="logo-org" class="logo-org" src="<%=request.getContextPath()%>/resources/images/login_new/lsta_Logo_Full.png" style="height: 80px;">
			</div>
			<div class="login-width" style="display: flex; justify-content: center; flex-direction: column; align-items: center;">
				<div class="login-section">
					<form name="login-form" id="login-form" method="post">
						<fieldset>
							<p id="deal-title" class="login-maing-text1">Dealer Portal</p>

							<div class="loginBox dis_flex">
								<div class="tac login-icon">
									<img class="" src="<%=request.getContextPath()%>/resources/images/login_new/user.png" >
								</div>
								<div class="login-input">
									<input type="text" id="username" class="loginInputSelect" name="j_userid" style="color: #333333;" placeholder="ID">
								</div>
							</div>

							<div class="loginBox dis_flex">
								<div class="tac login-icon">
									<img class="" src="<%=request.getContextPath()%>/resources/images/login_new/lock.png" >
								</div>
								<div class="login-input">
									<input type="password" id="password" name="j_password" class="loginInputSelect" style="color: #333333;" placeholder="PASSWORD">
								</div>
							</div> 
							<div class="loginBox dis_flex">
								<div class="tac login-icon">
									<img class="" src="<%=request.getContextPath()%>/resources/images/login_new/global.png" >
								</div>
								<div class="login-input">
									<select id="language" name="j_language" class="loginInputSelect sel-appr" onchange="doLanguage()">
										<option value="en">English</option>
										<option value="pt">Portuguese</option>
									</select>
								</div>
							</div>

							<input type="button" id="submit-button" value="Login" class="login_btn_new2" style="border-radius: 20px;">

							<div class="div-center">
								<div class="div-right" style="text-align: right; margin-top: 18px">
									<input id="language" name="j_language" type="hidden" value="en">
								</div>

								<div class="div-left" style="text-align: left; margin-top: 10px; display: inline-block;">
									<label>
										<input type="checkbox" id="remember" name="j_remember" style="margin: 0px 0px 0px 0px;"> &nbsp;&nbsp; <span id="id_save" class="id_save">ID Save</span>
									</label>
								</div>
							</div>

							<div class="tac" style="margin-top: 10px;">
								<a href="javascript:void(0)" id="changePassword-button" style="color: #000000; font-weight: 600; font-size: 16px;">Send mail for password reset</a>
							</div>

							<input id="system" name="j_system" type="hidden" value="<spring:eval expression="@app['default.system.id']" />" />
							<input id="system" name="j_type" type="hidden" value="W" />
							<input id="system" name="ndmIdx"   type="hidden" value="N" />
						</fieldset>
					</form>
				</div>

				<hr class="hrStyle" />
				<div>
					<!-- <p class="login-maing-text">ⓒ 2019 LS Tractor USA</p> -->
					<p class="login-maing-text">ⓒ 2025 LS Tractor USA</p>
				</div>
			</div>
		</div>
	   
		<!-- help -->
		<div id="help-dialog" class="wui-dialog" style="border-top-width:1px;display:none;">
			<div class="custom-popup">
		
				<div class="custom-id">user1</div>
				<div class="custom-content">&emsp;- 사용자1 ( 생산 미포함 )</div>
	
				<div class="custom-id">usera</div>
				<div class="custom-content">&emsp;- 사용자A ( 생산 기본형 )</div>
	
				<div class="custom-id">userb</div>
				<div class="custom-content">&emsp;- 사용자B ( 생산 기본형+외주관리 )</div>
	
				<div class="custom-id">userc</div>
				<div class="custom-content">&emsp;- 사용자C ( 생산 계획형 )</div>
	
				<div class="custom-id">userd</div>
				<div class="custom-content">&emsp;- 사용자D ( 생산 계획형+외주관리 )</div>
	
				<div class="custom-id">userm</div>
				<div class="custom-content">&emsp;- 사용자M ( 모바일 사용자 )</div>
				<br>
	
				<div class="custom-content1">비밀번호는 모두<span style='color:red'> pwd123! </span>입니다.</div>
	
				<div class="custom-button">
					<input class="custom-button1" type="button" onclick="doClosePopup()" value="닫기">
				</div>
		
			</div>
		</div>
		
		
		<!-- help -->
		<div id="help-prod-dialog" class="wui-dialog" style="border-top-width:1px;display:none;">
			<div class="custom-popup">
		
				<div class="custom-id">userap </div>
				<div class="custom-content">&emsp;- 사용자AP ( 생산 기본형 )  </div>
	
				<div class="custom-id">userbp </div>
				<div class="custom-content">&emsp;- 사용자BP ( 생산 기본형+외주관리 )  </div>
	
				<div class="custom-id">usercp </div>
				<div class="custom-content">&emsp;- 사용자CP ( 생산 계획형 )  </div>
	
				<div class="custom-id">userdp </div>
				<div class="custom-content">&emsp;- 사용자DP ( 생산 계획형+외주관리 )  </div>
	
				<div class="custom-id">usermp </div>
				<div class="custom-content">&emsp;- 사용자MP ( 모바일 사용자 )  </div>
				<br>
	
				<div class="custom-content1">비밀번호는 모두<span style='color:red'> pwd123! </span>입니다.</div>
	
				<div class="custom-button">
					<input class="custom-button1" type="button" onclick="doClosePopupProd()" value="닫기">
				</div>
		
			</div>
		</div>
	</div>

</body>
</html>