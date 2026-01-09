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
<script type="text/javascript">
	 var context = "<c:out value="${pageContext.request.contextPath}" />";
</script>
<script type="text/javascript" src="<c:url value="/resources/js/rejectEmail.js?v=1214C" />"></script>
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
// 	$("#text1").html("Dealer Portal");
// 	$("#text2").html("Please enter the reason for rejection.");
// 	$("#text3").html("Reason");
	if($("#gsLang").val() == "en"){
		$("#text1").html("Dealer Portal");
		$("#text2").html("Please enter the reason for rejection.");
		$("#text3").html("Reason");
	}else if($("#gsLang").val() == "pt"){
		$("#text1").html("Portal do Revendedor");
		$("#text2").html("Insira o motivo da rejeição.");
		$("#text3").html("razão");
		$('#text3').text('textbox').prop('placeholder', 'razão');
		$('#cancle-button').val('Cancelar');
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

.unsubs_btn_new{
	margin-top:25px;
	width: 49%;
    height: 30px;
    color: #fff;
    font-size: 15px;
    cursor: pointer;
    border: 1px solid #c8c8c8;
    background-color: #002658;
}
.unsubs_btn_new:hover, .unsubs_btn_new:focus {
	width: 49%;
    height: 30px;
    color: #fff;
    font-size: 15px;
    cursor: pointer;
    border: 1px solid #c8c8c8;
    background-color: #006DBB;
}

.login-section {height:350px !important;}

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
	    	<input type="hidden" name="gsLang"    id="gsLang"     value="${gsLang}"    />
	    	<input type="hidden" name="ftokenNo"  id="ftokenNo"   value="${ftokenNo}"    />
	    	<input type="hidden" name="Cmail"     id="Cmail"      value="${Cmail}"    />
	    	<input type="hidden" name="passTitle" id="passTitle"  value="${passTitle}"    />
	    	<input type="hidden" name="gpNo"      id="gpNo"       value="${gpNo}"    />
	    	<input type="hidden" name="bolNo"     id="bolNo"      value="${bolNo}"    />
	    	<input type="hidden" name="PassDate"  id="PassDate"   value="${PassDate}"    />
	    	<input type="hidden" name="PassTime"  id="PassTime"   value="${PassTime}"    />
	    	<input type="hidden" name="GateToUse" id="GateToUse"  value="${GateToUse}"    />
	    	<input type="hidden" name="userId"    id="userId"     value="${userId}"    />
	         <h1 style="text-align:center;margin-top:20px;">
	         	<img src="<%=request.getContextPath() %>/resources/images/login/lsta_logo2.png" style="width:280px;height:61px;">
	         </h1>
	         <p class="login-maing-text1"><span id= "text1"></span></p>
	         <p class="login-maing-text4"><span id= "text2"></span></p>
	         <p class="login-maing-text2"><span id= "text3"></span></p>
	         <input type="text" id="Reason" class="login-input-wsc" name="Reason" style="color:#333333;" placeholder="Reason">
             <input type="button" id="submit-button" value="Ok" class="unsubs_btn_new">
        	 <input type="button" id="cancle-button" value="Cancle" class="unsubs_btn_new">
             <input id="system" name="j_system" type="hidden" value="<spring:eval expression="@app['default.system.id']" />" />
	    </fieldset>
   	</form>
</div>

</body>
</html>