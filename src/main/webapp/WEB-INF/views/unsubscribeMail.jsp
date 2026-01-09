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
<script type="text/javascript" src="<c:url value="/resources/js/changePassword.js" />"></script>
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
function fnUpdate(type,userId,sysId){
	var type = type;
	console.log(type,userId,sysId);
	
	$.ajax({
        url: getUrl("/update_main"),
        dataType: "text",
        type: 'post',
        data: {	  type:type,
        	      USER_ID:userId,
        	      sysId:sysId
        		},
        success: function(result) {
//        	var obj = JSON.parse(result);
//        	rows = obj.rows;
//        	console.log("OK");
			window.close();
        },
        error:  function(result) {
        },
        complete : function () {	
	    }
	});
	
}

function fnClose(){
	window.close();
}

$(window).load(function() {
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

.login-section {height:380px !important;}

.unsubs_btn_new{
	margin-top:50px;
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
</style>
</head>
<!--<body bgcolor="#FFFFFF" text="#000000" background="<%=request.getContextPath() %>/resources/images/login/login_bkcolor.png" style=margin:0> -->
<body class="login-body" style="margin:0; >
<div class="backg">
</div>

<div class="login-section">
	 <%-- ----------- BBUG.ADD : 로그인 테이블 시작------------------------------------------------------------------ --%>
 	
    <fieldset>
         <h1 style="text-align:center;margin-top:20px;">
         	<img src="<%=request.getContextPath() %>/resources/images/login/lsta_logo2.png" style="width:280px;height:61px;">
         </h1>
         <p class="login-maing-text1">Dealer Portal</p>
         <p class="login-maing-text4" style="text-align:center; margin-top:30px;">
         	Are you sure </br>
			you don't want to receive the email? </br>
			Contact your administrator  </br>
			to receive mail later. </br>
         </p>
        	 <input type="button" id="unsubs-button" value="Ok" class="unsubs_btn_new" onclick="fnUpdate('${type}','${userId}','${sysId}')">
        	 <input type="button" id="cancle-button" value="Cancle" class="unsubs_btn_new" onclick="fnClose()">
    </fieldset>
	<%-- -----------로그인 테이블 끝------------------------------------------------------------------ --%>
	<div>
		<!-- <p class="login-maing-text" style="margin-top:25px; text-align:center; padding-top:5px; color:#ffffff;">
		<a href="javascript:history.back()"><span style="color: #000000; font-weight: 600; font-size: 15px;">← Back to LS Tractor Dealer Portal</span></a>
		</p> -->
	</div>
</div>

</body>
</html>