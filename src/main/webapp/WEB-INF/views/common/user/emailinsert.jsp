<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)user.jsp 1.0 2014/08/12                                            --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 패스워드 초기화 화면이다.                                                      	--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/emailinsert.js?v=0717" />"></script>
<script type="text/javascript">
	 doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
</script>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<input type="hidden" name="gsUserId" id="gsUserId" value="${gsUserId}"/>

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">
	<table cellpadding="5" class="search-table tableSearch-c wd-100" >
		<tr class="topnav_sty">
       		<td>
       			<div>
        			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
            	</div>
			</td>
		</tr>
    </table>
    
	<div class="changePw-div">
		<table class="changePw-table">
			<tr style="background:#0e4f87">
				<td colspan="2" class="changePw-title">
					<span data-item="LAB_001">My Email Account</span>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="changePw-center changePw-img">
					<span data-item="LAB_002" style="font-weight: 600;font-size: 22px;color: red;">
						1. It is used to send emails to dealers.<br>
						2. Please set it up if necessary.<br>
					</span>
					<span data-item="LAB_002" style="font-weight: 600;font-size: 22px;color: blue;">
						3. You must allow SMTP sending in your email account. <br>
						*Contact your IT manager.
					</span>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="changePw-tdH changePw-tdPd"><span data-item="LAB_005">User ID (Name)</span></td>
			</tr>
			<tr>
				<td colspan="2" class="changePw-tdH changePw-tdPd">
					<input type="text" name="userAccount" value="<c:out value='${user.userId}'/> &#40;<c:out value='${user.userName}'/>&#41;" readonly style="width:100%;" />
				</td>
			</tr>
			<tr>
				<td colspan="2" class="changePw-tdH changePw-tdPd"><span data-item="LAB_002">User Email</span><span style="color:red;">*</span></td>
			</tr>
			<tr>
				<td style="padding-left: 10%; padding-right: 3px;"><input type="text" name="userId" id="userId" value="${gsSmtpMail}" style="width:100%;" /></td>
				<td style="padding-right: 10%;"><input type="text" name="userEmail" id="userEmail" value ="@lstractorusa.com" readonly style="width:100%;" /></td>
			</tr>
			<tr>
				<td colspan="2" class="changePw-tdH changePw-tdPd"><span data-item="LAB_003">Email Password</span><span style="color:red;">*</span>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="changePw-tdH changePw-tdPd"><input type="password" name="newPw" id="newPw" style="width:100%;" /></td>
			</tr>
		<!-- 	<tr>
				<td class="changePw-tdH changePw-tdPd"> <span data-item="LAB_004">Confirm New Password</span><span style="color:red;">*</span></td>
			</tr>
			<tr>
				<td class="changePw-tdH changePw-tdPd"><input type="password" name="chkPw" id="chkPw" style="width:100%;" /></td>
			</tr>
			<tr> -->
				<td colspan="2" class="changePw-center" style="padding-top:10px;">
			    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_001">Save</a>
				</td>
			</tr>
		</table>
	</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

<!-- [LAYOUT] end -->
</div>
</html>
