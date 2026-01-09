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
<%-- 사용자로그조회 화면.                                                   --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2017/01/18                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/batchstatus.js" />"></script>
<style>
#account-layout{min-width:1000px !important;}
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
			<th data-options="field:'jobId', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_001', sortable:true, align:'center'">작업ID</th>
			<th data-options="field:'jobDesc', halign:'center',width:170, editor:{type:'validatebox'},data_item:'GRD_002', sortable:true">작업설명</th>
			<th data-options="field:'jobTerm', halign:'center',width:60, editor:{type:'validatebox'},data_item:'GRD_003', sortable:true, align:'center'">작업주기</th>
			<th data-options="field:'jobTime', halign:'center',width:200, editor:{type:'validatebox'},data_item:'GRD_004', sortable:true, align:'center'">작업시간 분-시간-일-월-요일</th>
			<th data-options="field:'bgnDate', halign:'center',width:140, editor:{type:'validatebox'},data_item:'GRD_005', sortable:true, align:'center'">시작일시</th>
			<th data-options="field:'endDate', halign:'center',width:140, editor:{type:'validatebox'},data_item:'GRD_006', sortable:true, align:'center'">종료일시</th>
			<th data-options="field:'fileSeq', halign:'center',width:60, editor:{type:'validatebox'},data_item:'GRD_007', sortable:true, align:'center'">파일SEQ</th>
			<th data-options="field:'jobRslt', halign:'center',width:60, editor:{type:'validatebox'},data_item:'GRD_008', sortable:true, align:'center'">작업결과</th>
			<th data-options="field:'rsltDesc', halign:'center',width:170, editor:{type:'validatebox'},data_item:'GRD_009', sortable:true">결과설명</th>
			<th data-options="field:'jobFile', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_010', sortable:true">작업파일</th>
			<th data-options="field:'jobRemk', halign:'center',width:200, editor:{type:'validatebox'},data_item:'GRD_011', sortable:true">비고</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<fieldset class="div-line-new" >
	        <table cellpadding="5" class="search-table tableSearch-c" >
	            <tr>
	            	
					<th class="h"  data-item="LAB_002"><span> 작업 ID </span></th>
					<td class="d">
						<select class="easyui-combobox" name="jobId" ID="jobId" data-options="mode:'remote'">
							<option value="" selected>전체</option>
							
							<c:forEach var="selectJobId" items="${selectJobId}">
								<option value="${selectJobId.JOB_ID}" >${selectJobId.JOB_ID}</option>
							</c:forEach>
							
						</select>
					</td>
					<th class="h" data-item="LAB_003"><span>성공/실패 </span></th>
					<td class="d">
						<select class="easyui-combobox" name="succFail" ID="succFail" data-options="mode:'remote'">
							<option value="" selected>전체</option>
							
							<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'JOB_RSLT' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
							</c:forEach>
						</select>
					</td>
					<th class="h table-Search-h"  data-item="LAB_001"><span>실행기간</span></th>
	            	<td class="d">
	            		<input class="easyui-datebox"  name="accTimeBgn" id="accTimeBgn" style="width:100px" value="${accTimeBgn}"/>~
	            		<input class="easyui-datebox"  name="accTimeEnd" id="accTimeEnd" style="width:100px" value="${accTimeEnd}"/>
	            	</td>
					<td class="b">
						<!-- <a href="javascript:void(0)" class="easyui-linkbutton cgray" iconCls="icon-search" id="search-button">검색</a> -->
						<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}" >검색</a>
					<!-- 	<a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_002">초기화</a>  -->
					</td>
	            </tr>
	        </table>
	   </fieldset>
	   
	   <fieldset class="div-line-new-sub">
	        <table cellpadding="5" class="search-table tableEtc-c">
	            <tr>
					<td class="h">
					    <a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel" id="excel-button"  data-item="BTN_005">엑셀</a>
					</td>
	            </tr>
	        </table>
		</fieldset>
	</form>
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="easyui-dialog" >
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- [LAYOUT] end -->



</div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
