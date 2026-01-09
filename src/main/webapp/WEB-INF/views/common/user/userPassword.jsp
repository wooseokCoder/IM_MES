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
<%-- 비밀번호 변경 화면이다.                                                      	--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/userpassword.js?v=0627A" />"></script>
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
       		<td colspan="" >
       			<div>
        			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
            	</div>
			</td>
		</tr>
    </table>  
    
	<div class="changePw-div">
		<table class="changePw-table">
			<tr style="background:#0e4f87">
				<td class="changePw-title">
					<span data-item="LAB_001">Change Password</span>
				</td>
			</tr>
			<tr>
				<td class="changePw-center changePw-img">
					<img src="<c:url value="/resources/images/password.jpg" />" alt="Password"  style="width:90px;height:110px;" />
				</td>
			</tr>
			<tr>
				<td class="changePw-tdH changePw-tdPd"><span data-item="LAB_002">Current Password</span><span style="color:red;">*</span></td>
			</tr>
			<tr>
				<td class="changePw-tdH changePw-tdPd"><input type="password" name="oldPw" id="oldPw" style="width:100%;" /></td>
			</tr>
			<tr>
				<td class="changePw-tdH changePw-tdPd"><span data-item="LAB_003">New Password</span><span style="color:red;">*</span></br>
				<span data-item="LAB_004" style="color: #1440bd;">Password should be included Upper/lower case, Number, Special symbol(~,!,@,#,$,%,^,&,*,?)</span></td>
			</tr>
			<tr>
				<td class="changePw-tdH changePw-tdPd"><input type="password" name="newPw" id="newPw" style="width:100%;" /></td>
			</tr>
			<tr>
				<td class="changePw-tdH changePw-tdPd"> <span data-item="LAB_005">Confirm New Password</span><span style="color:red;">*</span></td>
			</tr>
			<tr>
				<td class="changePw-tdH changePw-tdPd"><input type="password" name="chkPw" id="chkPw" style="width:100%;" /></td>
			</tr>
			<tr>
				<td class="changePw-center" style="padding-top:10px;">
			    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_001" style="width;100%">Save</a>
				</td>
			</tr>
		</table>
	</div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

<!-- [LAYOUT] end -->
</div>

</html>
