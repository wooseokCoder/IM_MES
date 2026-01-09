<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)modelmanagement.jsp 1.0 2014/08/05                                 --%>
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
<%-- 모델관리 화면이다.                                                       		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2017/03/22                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/business/item/modelmanagement.js" />"></script>
<style>
#account-layout{min-width:1000px !important;}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<table id="search-grid">
	<thead>
		<tr>
			<th data-options="field:'modelNo'  , halign:'center', width:120, editor:{type:'validatebox',options:{required:true}}, data_item:'GRD_001', align:'center', sortable:true">모델번호</th>
			<th data-options="field:'modelName', halign:'center', width:200, editor:{type:'validatebox',options:{required:true}}, data_item:'GRD_002', align:'center', sortable:true">모델명</th>
			<th data-options="field:'barCode'  , halign:'center', width:200, editor:{type:'numberbox'}, data_item:'GRD_003', align:'left'  , sortable:true">바코드</th>
			<th data-options="field:'admIdx'   , halign:'center', width:160, editor:consts.combo.admIdx.editor(),formatter:consts.combo.admIdx.formatter(), data_item:'GRD_004', align:'center', sortable:true">관리구분</th>
			<th data-options="field:'modelLoc' , halign:'center', width:160, editor:consts.combo.modelLoc.editor(),formatter:consts.combo.modelLoc.formatter(), data_item:'GRD_005', align:'center', sortable:true">저장위치</th>
			<th data-options="field:'stafName' , halign:'center', width:120, editor:{type:'validatebox'}, data_item:'GRD_006', align:'center', sortable:true">담당자</th>
			<th data-options="field:'modelRemk', halign:'center', width:300, editor:{type:'validatebox'}, data_item:'GRD_007', align:'left' , sortable:true ">비고</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<fieldset class="div-line-new" >
	        <table cellpadding="5" class="search-table tableSearch-c" style="margin-left:20px;" >
	            <tr>
	            	<th class="h table-Search-h" data-item="LAB_001"><span>모델 </span></th>
					<td class="d">
						<input class="easyui-textbox"  name="modelName" id="modelName" style="width:120px"/>
					</td>
	            	<th class="h table-Search-h" data-item="LAB_002"><span>관리부분</span></th>
					<td class="d">
						<select class="easyui-combobox" name="admIdx" ID="admIdx" data-options="width:100">
							<option value="">전체</option>
							<c:forEach var="item" items="${result}">
								<c:if test="${item.CODE_GRUP eq 'ADM_IDX' }">
									<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
	            	<th class="h table-Search-h" data-item="LAB_003"><span>저장위치 </span></th>
					<td class="d">
						<select class="easyui-combobox" name="modelLoc" ID="modelLoc" data-options="width:100">
							<option value="">전체</option>
							<c:forEach var="item" items="${result}">
								<c:if test="${item.CODE_GRUP eq 'STRG_TYPE' }">
									<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
	            	<th class="h table-Search-h" data-item="LAB_004"><span>담당자 </span></th>
					<td class="d">
						<input class="easyui-textbox"  name="stafName" id="stafName" style="width:100px"/>
					</td>
					<td class="b"><a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001" data-options="disabled:${RET}">검색</a></td>
	            </tr>
	        </table>
	   </fieldset>
	   <fieldset class="div-line-new-sub">
	        <table cellpadding="5" class="search-table tableEtc-c" style="width:100%;">
	            <tr>
					<td class="h">
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">추가</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003"  data-options="disabled:${DEL}">삭제</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_004" data-options="disabled:${UPD}">저장</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_005" >초기화</a>
					</td>
	            </tr>
	        </table>
		</fieldset>
	</form>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
