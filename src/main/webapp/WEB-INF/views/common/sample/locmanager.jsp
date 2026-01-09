<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)locmanager.jsp 1.0 2024/12/20                                      --%>
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
<%-- 위치 관리 화면 - 캔버스에 박스를 드래그하여 배치할 수 있는 기능            --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2024/12/20                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/sample/locmanager.js?v=251210D" />"></script>
<style>
html, body {
	height: 100%;
	overflow: hidden;
}

#locmanager-layout {
	height: 100%;
}

.canvasWrap {
	position: relative;
	overflow: hidden; 
	border: 1px solid #ccc;
	padding: 10px;
	margin: 0;
	width: 100%;
	height: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
	box-sizing: border-box;
}

#myCanvas {
	background-color: #f5f5f5;
	margin: 0 auto;
	display: block;
	width: 1000px;
	height: 700px;
	max-width: 100%;
	max-height: 100%;
}

.pointer {
	cursor: pointer;
}

#search-toolbar {
	padding: 5px;
}

#search-toolbar .div-line-new {
	margin: 0;
	padding: 5px;
}

#search-toolbar table {
	margin: 0;
}

.easyui-panel {
	padding: 10px !important;
	overflow: hidden;
}
</style>
</head>
<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<div class="easyui-layout" data-options="fit:true" id="locmanager-layout">
	
	<div data-options="region:'north',border:false" style="height:auto;overflow:hidden;">
		<div id="search-toolbar" class="wui-toolbar">
			<form id="search-form">
			<fieldset class="div-line-new">
				<table cellpadding="5" class="search-table tableSearch-c wd-100">
					<tr class="topnav_sty">
						<td colspan="10">
							<div style="display:flex; justify-content: space-between; align-items: center;">
								<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
								<div>
									<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="">Search</a>
									<a href="javascript:void(0)" style="width: 80px;" id="reset-button" class="easyui-linkbutton btn-clear" data-item="BTN_002">Reset Location</a>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th class="h table-Search-h">
							<span>Shipping W/H</span>
						</th>
						<td class="d">
							<select class="easyui-combobox" name="WARE_HOUS" id="WARE_HOUS" data-options="width:120, panelHeight:'auto'">
								<c:forEach var="item" items="${getCodeLists}">
									<c:if test="${item.CODE_GRUP eq 'WARE_HOUS'}">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>
						<td></td>
					</tr>
				</table>
			</fieldset>
			<fieldset class="div-line-new-sub grd-div-btn">
				<table cellpadding="5" class="search-table tableEtc-c wd-100">
					<tr>
						<td>
							<div class="dis_flex_gap4">
								<a href="javascript:void(0)" class="easyui-linkbutton c6" id="add-button" data-item="BTN_003" data-options="">Add</a>
								<a href="javascript:void(0)" class="easyui-linkbutton c6" id="confirm-location-button" data-item="BTN_004" data-options="">Location Confirmed</a>
								<a href="javascript:void(0)" class="easyui-linkbutton c6" id="check-sign-button" data-item="BTN_005" data-options="">Check Sign</a>
							</div>
						</td>
					</tr>
				</table>
			</fieldset>
			</form>
		</div>
	</div>
	
	<div data-options="region:'center',border:false" style="overflow:hidden;">
		<div class="easyui-panel" data-options="fit:true,border:false">
			<div class="canvasWrap">
				<div style="position: absolute; top: 10px; right: 10px; color: red; font-size: 11px; z-index: 1000;">
					Double-click to remove box
				</div>
				<canvas id="myCanvas" width="1000" height="700"></canvas>
			</div>
		</div>
	</div>
</div>

<!-- 서명 창 -->
<div id="sign-dialog" class="wui-dialog" style="border-top-width:1px; display:none;">
	<div class="easyui-layout" data-options="fit:true">
		<div data-options="region:'center',border:false" style="overflow: auto;">
			<div style="text-align: center;">
				<a class="refresh-button" href="javascript:doSignClear()"><i class="fa fa-refresh" aria-hidden="true"></i></a>
				<canvas id="sign-canvas" style="background-color:#ffffff;" width="535" height="220"></canvas>
			</div>
		</div>
		<div data-options="region:'south',border:false" style="height:60px;text-align:center;">
			<table class="popup-bottom-areaTable">
				<tr>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-sign-button">Save</a>&nbsp;&nbsp;&nbsp;
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="close-sign-button">Cancel</a>
				</tr>
			</table>
		</div>
	</div>
</div>

<!-- 저장된 사인 확인 창 -->
<div id="check-sign-dialog" class="wui-dialog" style="border-top-width:1px; display:none;">
	<div class="easyui-layout" data-options="fit:true">
		<div data-options="region:'center',border:false" style="overflow: auto; padding: 20px;">
			<div style="text-align: center;">
				<img id="check-sign-image" src="" alt="Saved Signature" style="max-width: 100%; max-height: 400px; border: 1px solid #ccc; background-color: #ffffff;" />
			</div>
		</div>
		<div data-options="region:'south',border:false" style="height:60px;text-align:center;">
			<table class="popup-bottom-areaTable">
				<tr>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="close-check-sign-button">Close</a>
				</tr>
			</table>
		</div>
	</div>
</div>

<input type="hidden" name="signTemp" id="signTemp" value="" />

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>

