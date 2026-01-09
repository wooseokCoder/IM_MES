<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)userlog.jsp 1.0 2017/01/18                                         --%>
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
<%-- 사용자로그조회 화면.                                                   			--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2017/01/18                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/jobhist.js" />"></script>
<style>
#account-layout{min-width:1000px !important;}
#report-button-pdf .l-btn-text{
	width: 100px;
}
.search-label-h {width:10%;}

/* EasyUI datebox 실제 input 요소 너비 조정 */
#accTimeBgn + .datebox, #accTimeEnd + .datebox {
    width: 47% !important;
}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">
<table id="search-grid">
	<thead>
		<tr>
			<th data-options="field:'jobId',    halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_001', sortable:true">Job ID</th>
			<th data-options="field:'jobDesc',  halign:'center',width:150, editor:{type:'validatebox'},data_item:'GRD_002', sortable:true">Job Name</th>
			<th data-options="field:'jobRslt',  halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_003', sortable:true">Result</th>
			<th data-options="field:'bgnDate',  halign:'center',width:150, editor:{type:'validatebox'},data_item:'GRD_004', sortable:true">Begin Date</th>
			<th data-options="field:'endDate',  halign:'center',width:150, editor:{type:'validatebox'},data_item:'GRD_005', sortable:true">End Date</th>
			<th data-options="field:'rsltDesc', halign:'center',width:450, editor:{type:'validatebox'},data_item:'GRD_006', sortable:true">Result DESC</th>
			<th data-options="field:'jobFile',  halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_007', sortable:true">Job File</th>
			<th data-options="field:'fileSeq',  halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_008', sortable:true">File Seq</th>
			

		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
<!-- topnav2 영역 -->
<div class="topnav_sty" style="background-color: #f0f0f0; border-radius: 5px; padding: 5px 10px; margin-bottom: 10px;">
	<div style="display: flex; justify-content: space-between; align-items: center;">
		<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
		<div>
			<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}" >Search</a>
			<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton btn-clear" id="dreload-button" data-item="BTN_002">Clear</a>
		</div>
	</div>
</div>

	<form id="search-form">
		<fieldset class="Remake-div-line-new wd-100">
        <table cellpadding="7" class="search-table tableSearch-c wd-100">
        	<colgroup>
        		<col width="7%">
        		<col width="15%">
        		<col width="7%">
        		<col width="13%">
        		<col width="7%">
        		<col width="13%">
        		<col width="*">
        	</colgroup>
            <tr>
            	<th class="h table-Search-h search-label-h2" style="min-width: 127px;" data-item="LAB_001"><span>Begin Date</span></th>
            	<td class="d" style="min-width: 165px;">
            		<div style="display: flex; align-items: center;">
            			<input class="easyui-datebox"  name="accTimeBgn" id="accTimeBgn" style="width:100px" value="${accTimeBgn}"/>
            			<span style="margin: 0 5px;"></span>
            			<input class="easyui-datebox"  name="accTimeEnd" id="accTimeEnd" style="width:100px" value="${accTimeEnd}"/>
            		</div>
            	</td>
				<th class="h table-Search-h search-label-h2" style="min-width: 125px;" data-item="LAB_002"><span>Job Name </span></th>
				<td class="d" style="min-width: 165px;">
					<select class="easyui-combobox" name="jobId" ID="jobId" data-options="width:150">
						<option value="">ALL</option>
						<c:forEach var="selectJobIdList" items="${selectJobIdList}">
							<option value="${selectJobIdList.JOB_ID}">${selectJobIdList.JOB_DESC}</option>
						</c:forEach>
					</select>
				</td>
				<th class="h table-Search-h search-label-h2" style="min-width: 100px;" data-item="LAB_003"><span>Result </span></th>
				<td class="d" style="min-width: 165px;">
					<select class="easyui-combobox" name="jobRslt" ID="jobRslt" data-options="width:150">
						<option value="">ALL</option>
						<c:forEach var="selectJobRsltList" items="${selectJobRsltList}">
							<option value="${selectJobRsltList.JOB_RSLT}">${selectJobRsltList.JOB_RSLT}</option>
						</c:forEach>
					</select>
				</td>
            </tr>
        </table>
   </fieldset>
    <fieldset class="div-line-new-sub grd-div-btn">
        <table cellpadding="7" class="search-table tableEtc-c wd-100">
            <tr>
				<td class="h">
					<div class="dis_flex_gap4">
						<a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_005">
							Excel Download&nbsp;
							<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/excel_download.png" />
						</a>
					</div>
				</td>
            </tr>
        </table>

	</fieldset>
	</form>
</div>


<!-- [LAYOUT] end -->
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="easyui-dialog" >
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
