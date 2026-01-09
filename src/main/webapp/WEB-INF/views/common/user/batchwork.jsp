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
<script type="text/javascript" src="<c:url value="/resources/js/common/user/batchwork.js" />"></script>
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
			<th data-options="field:'jobId', halign:'center',width:100, data_item:'GRD_001', sortable:true, align:'center'">작업ID</th>
			<th data-options="field:'jobGrup', halign:'center',width:80, editor:consts.combo.grupType.editor(),formatter:consts.combo.grupType.formatter(),data_item:'GRD_002', sortable:true, align:'center'">작업구분</th>
			<th data-options="field:'jobType', halign:'center',width:80, editor:consts.combo.jobType.editor(),formatter:consts.combo.jobType.formatter(),data_item:'GRD_003', sortable:true, align:'center'">작업유형</th>
			<th data-options="field:'jobTerm', halign:'center',width:60, editor:consts.combo.cycleType.editor(),formatter:consts.combo.cycleType.formatter(),data_item:'GRD_004', sortable:true, align:'center'">작업주기</th>
			<th data-options="field:'jobTime', halign:'center',width:160, editor:{type:'validatebox'},data_item:'GRD_005', sortable:true, align:'center'">작업시간 분-시간-일-월-요일</th>
			<th data-options="field:'jobCmd', halign:'center',width:200, editor:{type:'validatebox'},data_item:'GRD_006', sortable:true">작업명령</th>
			<th data-options="field:'jobDesc', halign:'center',width:200, editor:{type:'validatebox'},data_item:'GRD_007', sortable:true">작업설명</th>
			<th data-options="field:'errProc', halign:'center',width:200, editor:consts.combo.errType.editor(),formatter:consts.combo.errType.formatter(),data_item:'GRD_008', sortable:true">오류 발생시 처리</th>
			<th data-options="field:'jobMng', halign:'center',width:150,data_item:'GRD_009', editor:{type:'validatebox'}, sortable:true, align:'center'">담당자</th>
			<th data-options="field:'useFlag', halign:'center',width:80, editor:consts.combo.useType.editor(),formatter:consts.combo.useType.formatter(),data_item:'GRD_010', sortable:true, align:'center'">사용(Y/N)</th>
			<th data-options="field:'jobRemk', halign:'center',width:200, editor:{type:'validatebox'},data_item:'GRD_011', sortable:true">비고</th>
			<th data-options="field:'regiId', halign:'center',width:80,data_item:'GRD_012', sortable:true, align:'center'">등록자</th>
			<th data-options="field:'regiDate', halign:'center',width:140, data_item:'GRD_013', sortable:true, align:'center'">등록일자</th>
			<th data-options="field:'chngId', halign:'center',width:80,data_item:'GRD_014', sortable:true, align:'center'">수정자</th>
			<th data-options="field:'chngDate', halign:'center',width:160,data_item:'GRD_015', sortable:true, align:'center'">수정일자</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<fieldset class="div-line-new" >
	        <table cellpadding="5" class="search-table tableSearch-c" >
	            <tr>
	            	
					<th class="h"  data-item="LAB_002"><span>작업구분</span></th>
					<td class="d">
						<select class="easyui-combobox" name="jobGrup" ID="jobGrup" data-options="mode:'remote'">
							<option value="" selected>전체</option>
							<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'JOB_GRUP' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
							</c:forEach>
						</select>
					</td>
					<th class="h" data-item="LAB_003"><span>작업주기</span></th>
					<td class="d">
						<select class="easyui-combobox" name="jobTerm" ID="jobTerm" data-options="mode:'remote'">
							<option value="" selected>전체</option>
							<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'JOB_CYCLE'}">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
							</c:forEach>
						</select>
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
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">추가</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"   data-item="BTN_004" data-options="disabled:${UPD}">저장</a>
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
