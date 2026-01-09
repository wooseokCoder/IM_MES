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
<%-- 사용자관리 화면이다.                                                      --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/code/barcode.js" />"></script>
<script type="text/javascript">
	 doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
</script>
<script type="text/javascript" src="<c:url value="/resources/js/business/company/closemanagement.js" />"></script>
<script>
/**
 *  제목		: [기본정보관리]-[마감관리]를 처리하는 스크립트
 *  작성자	: 김연주
 *  날짜		: 2017-03-23
 */
</script>
<style>
#account-layout{min-width:1200px !important;}
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

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">
	<table id="search-grid">
		<thead data-options="frozen:true">
			<tr>

				<th data-options="field:'year',   width:80, align:'center',sortable:true,editor:consts.combo.closeYear.editor(),formatter:consts.combo.closeYear.formatter(), data_item:'GRD_001', required:true, sortable:true " >마감년도</th>
				<th data-options="field:'month',   width:80, align:'center',sortable:true,editor:consts.combo.closeMonth.editor(),formatter:consts.combo.closeMonth.formatter(), data_item:'GRD_002', required:true, sortable:true " >마감월</th>
				<th data-options="field:'closeYN',   width:80, align:'center',sortable:true,editor:consts.combo.closeYN.editor(),formatter:consts.combo.closeYN.formatter(), data_item:'GRD_003', required:true, sortable:true " >마감구분</th>
			</tr>
		</thead>
		<thead>
			<tr>
				<th data-options="field:'remark',  halign:'center', width:200, editor:{type:'validatebox'}, data_item:'GRD_004', sortable:true">비고</th>
				<th data-options="field:'regiID',  align:'center',halign:'center', width:100,data_item:'GRD_005', sortable:true">등록자</th>
				<th data-options="field:'regiDate',  halign:'center', width:140,data_item:'GRD_006', sortable:true">등록일</th>
				<th data-options="field:'chngID',  align:'center',halign:'center', width:100,data_item:'GRD_007', sortable:true">수정자</th>
				<th data-options="field:'chngDate',  halign:'center', width:140,data_item:'GRD_008', sortable:true">수정일</th>
			</tr>
		</thead>
	</table>


	<div id="search-toolbar" class="wui-toolbar">
		<form id="search-form">
			<fieldset class="div-line-new" >
		        <table cellpadding="5" class="search-table tableSearch-c" >
		            <tr>
		            <th class="h table-Search-h" ><span data-item="LAB_001">마감년도 </span></th>
								<td class="d">
									<select class="easyui-combobox" name="closedYear" ID="closedYear" data-options="width:80">
 									<option value=""><span data-item='LAB_002'>전체</span></option> 
						            	<c:set var="today" value="<%=new java.util.Date()%>" />
								        <fmt:formatDate value="${today}" pattern="yyyy" var="start"/>
								        <option value="${start}">${start}</option>
								        <c:forEach begin="1" end="10" var="idx" step="1">
								        	<option value="<c:out value="${start + idx}" />"><c:out value="${start + idx}" /></option>
								        </c:forEach>
						            </select>
								</td>
						<td class="b">
							<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}" >검색</a>
						</td>
		            </tr>
		        </table>
		   </fieldset>

		    <fieldset class="div-line-new-sub">
		        <table cellpadding="5" class="search-table tableEtc-c">
		            <tr>
						<td class="h">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">추가</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_004" data-options="disabled:${UPD}">저장</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_005" >초기화</a>
						</td>
		            </tr>
		        </table>
			</fieldset>
		</form>
	</div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>