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
<script type="text/javascript" src="<c:url value="/resources/js/login.js?v=250910" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css?v=250425A" />" />
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
	location.href=getUrl("/changePassword.do?lang="+$('#language').val());
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
.login-body {
	margin: 0;
	/* background: #0A1E5A; */
	/* background-image: url(resources/images/login_new/login_background_mobile.png); */
	background-position: center center;
	background-repeat: no-repeat;
	background-size: cover;
	min-height: 100vh;
	display: grid;
	place-items: center;
}

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
	text-align: center;
}

.custom-button1 {
	text-align: right;
	padding: 6px 27px 7px;
	color: #444;
	letter-spacing: -1px;
	border: 0;
	background: #f1f1f1;
}

.login_btn_new {
	background-color: #002658;
	border: none;
	height: 40px;
	border-radius: 8px;
	font-size: 16px;
	margin-top: 20px;
}

.login_btn_new2 {
	background-color: #002658;
	border: none;
	height: 40px;
	border-radius: 8px;
	font-size: 16px;
	width: 100%;
	color: #fff;
	margin-top: 35px;
	margin-bottom: 5px;
} 

input[type=button]:hover, button:hover {
	background-color: #e3e7ee !important;
	background: #e3e7ee !important;
	border: none !important;
	height: 40px;
/* 	border-radius: 8px;
	font-size: 16px; */
    color: #002658 !important;
}

.login-body .login-section {
	/* width: 400px; */
	width: 100%;
	height: 565px;
	padding: 20px;
	/* position: static; */
	/* background-image: url(resources/images/login_new/ls-tractor-image-7.jpg); */
	background-size: 100% 60%;  */
	background: #fff;
	position: relative;
	overflow: hidden;
	/* border-radius: 0 !important; */
	left: 0;
}

.login-section::before { /* 상단에만 이미지 */
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 70%;
  background: url(resources/images/login_new/bg_tractor.jpg) top center / cover no-repeat;
  z-index: 0;
}

.login-form {
  position: relative;
  z-index: 1;
  text-align: center;
}

.login-box {
  width: 100%;
  margin: 0 auto;
  background: #fff;
  /* box-shadow: 0 4px 12px rgba(0,0,0,0.2); */
  position: relative;
  top: 8px;
  padding: 10px;
  left: 0 !important;
  border-radius: 5px;
}

.login-box input, 
.login-box button {
  display: block;
  /* width: 100%;
  margin: 10px 0;
  padding: 10px; */
}

.loginBox {
	width: 100% !important;
    height: 45px;
    margin-top: 20px;
}

.loginInputSelect {
	width: 100%;
	height: 43px;
	border-radius: 22px;
	font-size: 15px;
	background-color: rgba(255, 255, 255, 0.8);
	text-indent: 20px;
}

.id_save {
	font-size: 15px;
	font-weight: 600;
}


.login-cont {
    /* 반응형 크기 설정 */
    width: 90%;          /* 화면이 작아지면 자동 줄어듦 */
    max-width: 400px;    /* 최대 400px까지만 */
    min-width: 280px;    /* 너무 작아지지 않도록 최소 보장 */
}

.login-maing-text {
	/* margin-top: 10rem;  */
	margin-top: 5vh; 
	text-align: center; 
	color: #000; 
	font-size: 12px; 
	font-weight: 500;
	border-top: 1px solid #99a6bb;
	padding-top: 10px;
}

.login-maing-text11 {
	/* margin-top: 10rem;  */
	/* margin-top: 10vh; */ 
	text-align: center; 
	color: #fff; 
	font-size: 45px; 
	font-weight: 700;
}

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


@media screen and (max-width: 460px) {
	.login-body .login-section{
		padding: 0 !important;
	}
	
	.login-box {
		padding: 25px 20px !important;
		border-radius: 10px !important;
	}
}

</style>
</head>
<body class="login-body">

	<div class="login-cont" >
		<div class="login-section">
			<%-- ----------- BBUG.ADD : 로그인 테이블 시작------------------------------------------------------------------ --%>
			<div class="login-form">
			<form name="login-form" id="login-form" method="post">
				<fieldset>
					<h1 style="text-align: left; margin: 0; margin-bottom: 8px;">
						<img src="<%=request.getContextPath()%>/resources/images/login_new/LSTA_Logos_Blue_White.png" style="height: 45px;">
					</h1>
					<p id="deal-title" class="login-maing-text11" style="margin-bottom: 100px;">Dealer Portal</p>
	
					<div class="login-box">
						<div class="loginBox dis_flex">
							<div class="tac login-icon">
								<!-- <i class="fa fa-user fa-2x vati" aria-hidden="true"></i> -->
								<img src="<%=request.getContextPath()%>/resources/images/login_new/user.png">
							</div>
							<div class="login-input">
								<input type="text" id="username" class="loginInputSelect" name="j_userid" style="color: #333333;" placeholder="ID">
							</div>
						</div>
							
						<div class="loginBox dis_flex">
							<div class="tac login-icon">
								<!-- <i class="fa fa-lock fa-2x vati" aria-hidden="true"></i> -->
								<img src="<%=request.getContextPath()%>/resources/images/login_new/lock.png">
							</div>
							<div class="login-input">
								<input type="password" id="password" name="j_password" class="loginInputSelect" style="color: #333333;" placeholder="PASSWORD">
							</div>
						</div>

						<%-- <div class="loginBox dis_flex">
							<div class="tac login-icon">
								<img src="<%=request.getContextPath()%>/resources/images/login_new/global.png" >
							</div>
							<div class="login-input">
								<select id="language" name="j_language" class="loginInputSelect sel-appr" onchange="doLanguage()">
									<option value="en">English</option>
									<option value="pt">Portuguese</option>
								</select>
							</div>
						</div> --%>
		
						<input type="button" id="submit-button" value="Login" class="login_btn_new2" style="border-radius: 20px;">
		
						<div class="div-center">
							<div class="div-right" style="text-align: right; margin-top: 18px">
								<input id="language" name="j_language" type="hidden" value="en">
							</div>
		
							<div class="div-left" style="text-align: left; margin-top: 10px; display: inline-block;">
								<label class="dis_flex">
									<input type="checkbox" id="remember" name="j_remember" style="margin: 0px 0px 0px 0px;">
									&nbsp;&nbsp;<span id="id_save" class="id_save">ID Save</span>
								</label>
							</div>
						</div>
		
						<div class="tac" style="margin-top: 5px;">
							<a href="javascript:void(0)" id="changePassword-button" style="color: #000000; font-weight: 600; font-size: 16px;">Send mail for password reset</a>
						</div>
						
						<%-- <div class="tac" style="margin-top: 5px; font-size: 14px; color: red">
							This app is connected to the development server.<br>
							Please download the latest version from the store to continue using the service.
						</div> --%>
					</div>
	
					<input id="system" name="j_system" type="hidden" value="<spring:eval expression="@app['default.system.id']" />" />
					<input id="system" name="j_type"   type="hidden" value="M" />
              		<input id="system" name="j_returl" type="hidden" value="${retURL}" />
				</fieldset>
			</form>
			</div>
		</div>
	
		<%-- -----------로그인 테이블 끝------------------------------------------------------------------ --%>
		<div>
			<!-- <p class="login-maing-text" style="margin-top: 45px; text-align: center; padding-top: 5px; border-top: 1px solid #99a6bb; color: #ffffff;">ⓒ 2019 LS Tractor USA</p> -->
			<p class="login-maing-text" >ⓒ 2025 LS Tractor USA</p>
		</div>
		

		<!-- help -->
		<div id="help-dialog" class="wui-dialog" style="border-top-width: 1px; display: none;">
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

				<div class="custom-content1">
					비밀번호는 모두
					<span style='color: red'> pwd123! </span>
					입니다.
				</div>

				<div class="custom-button">
					<input class="custom-button1" type="button" onclick="doClosePopup()" value="닫기">
				</div>
			</div>
		</div>

		<!-- help -->
		<div id="help-prod-dialog" class="wui-dialog" style="border-top-width: 1px; display: none;">
			<div class="custom-popup">

				<div class="custom-id">userap</div>
				<div class="custom-content">&emsp;- 사용자AP ( 생산 기본형 )</div>

				<div class="custom-id">userbp</div>
				<div class="custom-content">&emsp;- 사용자BP ( 생산 기본형+외주관리 )</div>

				<div class="custom-id">usercp</div>
				<div class="custom-content">&emsp;- 사용자CP ( 생산 계획형 )</div>

				<div class="custom-id">userdp</div>
				<div class="custom-content">&emsp;- 사용자DP ( 생산 계획형+외주관리 )</div>

				<div class="custom-id">usermp</div>
				<div class="custom-content">&emsp;- 사용자MP ( 모바일 사용자 )</div>
				<br>

				<div class="custom-content1">
					비밀번호는 모두
					<span style='color: red'> pwd123! </span>
					입니다.
				</div>

				<div class="custom-button">
					<input class="custom-button1" type="button" onclick="doClosePopupProd()" value="닫기">
				</div>

			</div>
		</div>
	</div>

</body>
</html>