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
<script type="text/javascript" src="<c:url value="/resources/js/login.js" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css" />" /> 
<%-- <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css" />" /> --%>
<script type="text/javascript">
	 doInit({
		message: '${exception.message}'
	});
</script>

</head>
<!--<body bgcolor="#FFFFFF" text="#000000" background="<%=request.getContextPath() %>/resources/images/login/login_bkcolor.png" style=margin:0> -->
<body bgcolor="#FFFFFF" text="#000000"  style=margin:0>
<table width="100%" height="800" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top">
	  <table width="1262" height="800" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td background="<%=request.getContextPath() %>/resources/images/login/login_main.png">
 <%-- ----------- BBUG.ADD : 로그인 테이블 시작------------------------------------------------------------------ --%>     
 	<form name="login-form" id="login-form" method="post">
	    <fieldset>
            <table border="0" cellpadding="0" cellspacing="0" >
              <tr> 
                <td width="620" height="315"></td>
                <td colspan="2"> </td>
              </tr>
              <tr> 
                <td width="620" height="35"></td>
                <td colspan="2"> 
                  <input type="text" id="username" name="j_userid" style='border: #8c9aa7 0px solid; width: 195px; color: #004f4e; font-size: 10pt; ' tabindex="1">
                </td>
                <td rowspan="2" valign="middle">
                	 <!-- <input type="button" id="submit-button" value="로그인" style='width: 106px; height: 66px; color: #004f4e; font-size: 12pt; cursor: pointer '> -->
                	 <input type="button" id="submit-button" value="로그인" class="login_btn_new"> 
                	 </td>
              </tr>
              <tr> 
                <td width="620" height="35"></td>
                <td colspan="2"> 
                  <input type="password" id="password" name="j_password" style='border: #8c9aa7 0px solid; width: 195px; color: #004f4e; font-size: 10pt; ' tabindex="2">
                </td>
              </tr>
              <tr> 
                <td width="620" height="28"></td>
                <td width="100" style='font-size: 9pt; color: #004f4e; '> 
                  <input type="checkbox" name="j_remember" >아이디저장
                </td>
                <td width="110"> 
                  <select id="language" name="j_language" style='border: #8c9aa7 1px solid; width: 100px; color: #004f4e; font-size: 10pt; '>
                  	<option value="ko"><span>한국어</span></option>
                 	<option value="en"><span>English</span></option>
                 	<option value="vi"><span>Tiếng Việt</span></option>
                  </select>
                  <input id="system" name="j_system" type="hidden" value="<spring:eval expression="@app['default.system.id']" />" /> 
                </td>
              </tr>
              <tr> 
                <td width="620" height="107"></td>
                <td colspan="2"> </td>
              </tr>
            </table>
	    </fieldset>
   </form>
<%-- -----------로그인 테이블 끝------------------------------------------------------------------ --%>   
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>