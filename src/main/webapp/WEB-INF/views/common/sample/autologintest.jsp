<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)autologintest.jsp 1.0 2025/01/XX                                   --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2025 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- Auto Login Test Screen.                                                --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2025/01/XX                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/sample/autologintest.js?v=250110A" />"></script>

<style>
.test-section {
    margin: 20px 0;
    padding: 20px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #f9f9f9;
}
.test-section h3 {
    margin-top: 0;
    color: #002658;
    border-bottom: 2px solid #002658;
    padding-bottom: 10px;
}
.form-group {
    margin: 15px 0;
}
.form-group label {
    display: inline-block;
    width: 150px;
    font-weight: bold;
}
.form-group input {
    width: 300px;
    padding: 5px;
}
.result-area {
    margin-top: 15px;
    padding: 10px;
    background-color: #fff;
    border: 1px solid #ccc;
    border-radius: 3px;
    min-height: 50px;
    word-break: break-all;
}
.result-success {
    color: #28a745;
    font-weight: bold;
}
.result-error {
    color: #dc3545;
    font-weight: bold;
}
.token-link {
    display: block;
    margin-top: 10px;
    padding: 10px;
    background-color: #e7f3ff;
    border: 1px solid #b3d9ff;
    border-radius: 3px;
    word-break: break-all;
}
</style>

</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
	<fieldset class="div-line-new">
		<table cellpadding="5" class="search-table tableSearch-c wd-100">
			<tr class="topnav_sty">
				<td colspan="10">
					<div style="display:flex; justify-content: space-between; align-items: center;">
						<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
					</div>
				</td>
			</tr>
		</table>
	</fieldset>
	</form>
</div>

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div class="easyui-layout" data-options="fit:true" id="autologin-layout" style="display:none; padding: 20px;">

    <div style="margin-bottom: 30px;">
        <h1 style="color: #002658; margin-bottom: 10px;">Auto Login Test</h1>
        <p style="color: #666;">Send auto login email with token-based authentication.</p>
    </div>

    <!-- Send Auto Login Email -->
    <div class="test-section">
        <h3>Send Auto Login Email</h3>
        <form id="send-email-form">
            <div class="form-group">
                <label>User ID:</label>
                <input type="text" id="email-userId" name="userId" value="" />
            </div>
            <div class="form-group">
                <label>Email Address:</label>
                <input type="text" id="email-address" name="emailAddress" value="" />
            </div>
            <div class="form-group">
                <label>Target Page URL:</label>
                <input type="text" id="email-targetUrl" name="targetUrl" value="/common/sample/autologintest.do" />
            </div>
            <div class="form-group">
                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="send-email-button">Send Email</a>
            </div>
            <div class="result-area" id="send-email-result"></div>
        </form>
    </div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
