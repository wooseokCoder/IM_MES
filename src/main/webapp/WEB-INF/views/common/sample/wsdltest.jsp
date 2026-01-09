<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)wsdltest.jsp 1.0 2025/01/XX                                      --%>
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
<%-- WSDL Test Screen.                                                     --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2025/01/XX                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/sample/wsdltest.js?v=250110A" />"></script>

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
    width: 160px;
    font-weight: bold;
}
.form-group input, .form-group select, .form-group textarea {
    width: 300px;
    padding: 5px;
}
.form-group textarea {
    width: 600px;
    height: 200px;
    font-family: monospace;
}
.result-area {
    margin-top: 15px;
    padding: 10px;
    background-color: #fff;
    border: 1px solid #ccc;
    border-radius: 3px;
    min-height: 50px;
    word-break: break-all;
    white-space: pre-wrap;
    font-family: monospace;
    font-size: 12px;
}
.result-success {
    color: #28a745;
    font-weight: bold;
}
.result-error {
    color: #dc3545;
    font-weight: bold;
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

<div class="easyui-layout" data-options="fit:true" id="wsdltest-layout" style="display:none; padding: 20px;">

    <div style="margin-bottom: 30px;">
        <h1 style="color: #002658; margin-bottom: 10px;">WSDL Service Test</h1>
        <p style="color: #666;">Test WSDL web services by sending SOAP requests.</p>
    </div>

    <!-- WSDL Service Test -->
    <div class="test-section">
        <h3>Call WSDL Service</h3>
        <form id="wsdl-test-form">
            <div class="form-group">
                <label>Service Name:</label>
                <select id="service-name" name="serviceName">
                    <option value="">-- Select Service --</option>
                    <option value="IF_SFDC_DEALER_LSTA_038">IF_SFDC_DEALER_LSTA_038</option>
                    <option value="IF_SFDC_DEALER_LSTA_040">IF_SFDC_DEALER_LSTA_040</option>
                    <option value="IF_SFDC_DEALER_LSTA_041">IF_SFDC_DEALER_LSTA_041</option>
                    <option value="IF_SFDC_DEALER_LSTA_044">IF_SFDC_DEALER_LSTA_044</option>
                    <option value="IF_SFDC_DEALER_LSTA_046">IF_SFDC_DEALER_LSTA_046</option>
                </select>
            </div>
            <div class="form-group" style="display: flex;">
                    <label>Request Data (SOAP XML):</label>
                    <textarea id="request-data" name="requestData" placeholder="SOAP XML format"></textarea>
            </div>
            <div class="form-group">
                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="call-service-button">Call Service</a>
            </div>
            <div class="result-area" id="wsdl-test-result"></div>
        </form>
    </div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>

