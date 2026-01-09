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
<%-- 로그인 화면이다.                                                       		--%>
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
<script type="text/javascript" src="<c:url value="/resources/js/loginsso.js" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css" />" />
<%-- <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css" />" /> --%>
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
	$('#changePassword-button').bind('click', doChangePassword);
	$('#regiUser-button').bind('click', doRegiUser);

	
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
	location.href=getUrl("/changepassword.do");
}

function doRegiUser() {
	location.href=getUrl("/regiuser.do");
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
#regiUser-button{
	margin-top: 10px;
}
</style>
</head>
<!--<body bgcolor="#FFFFFF" text="#000000" background="<%=request.getContextPath() %>/resources/images/login/dps_logo.png" style=margin:0> -->
<body class="login-body" style="margin:0; background: #002658;display:none;" onload="checkLanguage();">
<div class="backg">
</div>

<div class="login-section">
	 <%-- ----------- BBUG.ADD : 로그인 테이블 시작------------------------------------------------------------------ --%>
	 	<form name="login-form" id="login-form" method="post">
		    <fieldset>
	          <h1 style="text-align:center;margin-top:20px;">
	          	<img src="<%=request.getContextPath() %>/resources/images/login/dps_logo.png" style="height:50px;">
	          </h1>
	          <p class="login-maing-text1" style="font-size:20px;">Diagnosis Portal System</p>
	          
	          <p class="login-maing-text2">ID</p>
              <input type="text" id="username" class="login-input-wsc" name="j_userid" style="color:#333333;" placeholder="ID" value="${ssoUserId}">
              <p class="login-maing-text2" style="margin-top:10px;">Password</p>
              <input type="password" autocomplete="off" id="password" name="j_password" class="login-input-wsc" style="color:#333333;" placeholder="PASSWORD">
              
         	  <input type="button" id="submit-button" value="Login" class="login_btn_new">
         	  
         	  <div class="div-center">
         	  <div class="div-right" style="text-align:right; margin-top:10px">
			  <!-- 	<a href="javascript:void(0)" style="cursor:pointer" id="help-button">Help</a> /  -->
			  <!--	<a href="javascript:void(0)" style="cursor:pointer" id="help-prod-button">Help(Prod)</a> -->
					<!-- <select id="language" name="j_language" style='border:1px solid #cdcdcd; width: 100px; padding:0px 0 0px 0;border-radius:4px;color: #004f4e; font-size: 13pt; display: inline-block; '>
	                 	<option value="en"><span>English</span></option>
	                 	<option value="ko"><span>한국어</span></option>
	                 	<option value="vi"><span>Tiếng Vi?t</span></option>
					</select> -->
					<!-- <select id="language" name="j_language" class="loginInputSelect" onchange="doLanguage()">
	                	<option value="en">English</option>
	                	<option value="pt">Portuguese</option>
	                	<option value="cn">Chinese</option>
	                </select> -->
					<input id="language" name="j_language" type="hidden" value="en" >
			  </div>
			  
         	  <div class="div-left" style="text-align:left; margin-top:10px; display: inline-block;">
         	  <input type="checkbox" id="remember" name="j_remember" style="margin:0px 0px 0px 0px;">&nbsp;&nbsp;<span id="id_save">ID Save</span>
         	  </div>
         	  </div>
         	  
         	  <div style="text-align:center!important; margin-top:10px; display: block;">
         	  	<a href="javascript:void(0)" id="changePassword-button" ><span style="color: #000000; font-weight: 600; font-size: 15px;">Send mail for password reset</span></a>
         	  </div>
         	  
			  <input type="button" id="regiUser-button" value="사용자 등록 신청" class="login_btn_new">
			  
              <input id="system" name="j_system" type="hidden" value="<spring:eval expression="@app['default.system.id']" />" />
			  <input id="token" name="j_token" type="hidden" value="${token}" />
			  <input id="targetUrl" name="targetUrl" type="hidden" value="${targetUrl}" />
		    </fieldset>
	   </form>
	   

	<%-- -----------로그인 테이블 끝------------------------------------------------------------------ --%>
<div>
<p class="login-maing-text" style="margin-top:45px; text-align:center; padding-top:5px; border-top:1px solid #99a6bb; color:#ffffff;">
ⓒ 2019 LS Cable & System Ltd. All Rights Reserved
</p>
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