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
<%-- 비밀번호 변경 화면이다.                                                       	--%>
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
<script type="text/javascript" src="<c:url value="/resources/js/changePassword.js?v=0623A" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css" />" />

<script type="text/javascript">
	 doInit({
		message: '${exception.message}'
	});

</script>
<script>

$(function() {

	$('#language').on('change', function() {
		doLanguage();
	});
});

$(window).load(function() {
	if($("#gsLang").val() == "en"){
		$("#text1").html("Dealer Portal");
		$("#text2").html("A one-time password will be sent to the registered mail.</br>If your email address is different, please contact your administrator.");
		$("#text3").html("ID");
		$("#text4").html("E-Mail");
		$("#text5").html("← Back to LS Tractor Dealer Portal");
	}else if($("#gsLang").val() == "pt"){
		$("#text1").html("Portal do Revendedor");
		$("#text2").html("Uma senha de uso único será enviada para o e-mail registrado.</br>Se o seu endereço de e-mail for diferente, entre em contato com o administrador.");
		$("#text3").html("EU IA");
		$("#text4").html("E-mail");
		$("#text5").html("← Voltar ao Portal do Concessionário LS Tractor");
		$('#username').text('textbox').prop('placeholder', 'EU IA');
		$('#email').text('textbox').prop('placeholder', 'E-mail');
	}
	//$(".wui-dialog").show();
});

</script>
<style>
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

.login-section {height:510px !important;}

</style>
</head>
<!--<body bgcolor="#FFFFFF" text="#000000" background="<%=request.getContextPath() %>/resources/images/login/login_bkcolor.png" style=margin:0> -->
<body class="login-body" style="margin:0; >
<div class="backg">
</div>

<div class="login-section">
	 <%-- ----------- BBUG.ADD : 로그인 테이블 시작------------------------------------------------------------------ --%>
 	<form name="login-form" id="login-form" method="post">
	    <fieldset>
	    	<input type="hidden" name="gsLang"     id="gsLang"     value="${gsLang}"    />
	         <h1 style="text-align:center;margin-top:20px;">
	         	<img src="<%=request.getContextPath() %>/resources/images/login/lsta_logo2.png" style="width:280px;height:61px;">
	         </h1>
	         <p class="login-maing-text1"><span id= "text1"></span></p>
	         <p class="login-maing-text4"><span id= "text2"></span></p>
	         <p class="login-maing-text2"><span id= "text3"></span></p>
             <input type="text" id="username" class="login-input-wsc" name="j_userid" style="color:#333333;" placeholder="ID"  value="${getSelectOldId.userId}">
             <p class="login-maing-text2" style="margin-top:10px;"><span id= "text4"></span></p>
             <input type="text" id="email" name="j_email" class="login-input-wsc" style="color:#333333;" placeholder="E-Mail"  value="${getSelectOldId.userMail}">
              
         	 <input type="button" id="submit-button" value="Send Mail" class="login_btn_new">
             <input id="system" name="j_system" type="hidden" value="<spring:eval expression="@app['default.system.id']" />" />
	    </fieldset>
   	</form>
	<%-- -----------로그인 테이블 끝------------------------------------------------------------------ --%>
	<div>
		<p class="login-maing-text" style="margin-top:25px; text-align:center; padding-top:5px; color:#ffffff;">
		<a href="javascript:history.back()"><span id= "text5" style="color: #000000; font-weight: 600; font-size: 15px;"></span></a>
		</p>
	</div>
</div>

</body>
</html>