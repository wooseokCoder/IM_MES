<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)code.jsp 1.0 2014/08/05                                            --%>
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
<%-- 코드관리 화면이다.                                                             --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/excelinfo.js" />"></script>
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
	            <th data-options="field:'fileNm', halign:'center', width:150, editor:{type:'textbox'}, sortable:true,data_item:'GRD_001'">FILE Name</th>
	            <th data-options="field:'viewNo', halign:'center', width:100,  editor:{type:'textbox'}, sortable:true, align:'center',data_item:'GRD_004'">VIEW NO</th>
	            <th data-options="field:'colLvl', halign:'center', align:'left', width:200, editor:{type:'textbox'}, sortable:true,data_item:'GRD_002'">COL Label</th>
	            <th data-options="field:'colVal', halign:'center', align:'left', width:200, editor:{type:'textbox'}, sortable:true,data_item:'GRD_003'">COL Value</th>
                <th data-options="field:'align',  halign:'center', align:'center', width:200, editor:consts.combo.Align.editor(), sortable:true,data_item:'GRD_003'">STYLE</th>
                <th data-options="field:'SEQ',    halign:'center', width:120, align:'center', data_item:'GRD_113', hidden:true"></th>
                <hidden 
	        </tr>
	    </thead>
	</table>
	
	<div id="search-toolbar" class="wui-toolbar">
	    <form id="search-form">
	        <fieldset class="Remake-div-line-new wd-100">
	            <table cellpadding="7" class="search-table tableSearch-c">
	            	<colgroup>
	            		<col width="7%">
	            		<col width="13%">
	            		<col width="*">
	            	</colgroup>
	            	<tr class="topnav_sty">
	            		<td colspan="3">
	            			<div>
	            				<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
	            				<div>
	            					<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}">Search</a>
	            				</div>
	            			</div>
	            		</td>
	            	</tr>
	                <tr>
	                    <th class="h table-Search-h search-label-h2" style="min-width: 127px;" data-item="LAB_001"><span>FILE_NM </span></th>
	                    <td class="d" style="min-width: 165px;">
	                        <select class="easyui-combobox" name="s_fileNm" ID="s_fileNm" data-options="width:180,height:30">
	                            <option value="" selected>ALL</option>
	                            <c:forEach var="selectCode" items="${selectCode}">
	                                <option value="${selectCode.fileNm}" >${selectCode.fileNm}</option>
	                            </c:forEach>
	                        </select>
	                    </td>
	                    <td class="b w-a" style="text-align: right;">
	                        <!-- Search 버튼은 topnav_sty로 이동됨 -->
	                    </td>
	                </tr>
	            </table>
	        </fieldset>
	        <fieldset class="div-line-new-sub grd-div-btn">
	            <table cellpadding="7" class="search-table tableEtc-c wd-100">
	                <tr>
	                    <td class="h">
	                    	<div class="dis_flex_gap4">
	                        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_003" data-options="disabled:${INS}" >Add</a>
	                        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_004" data-options="disabled:${DEL}" >Del</a>
	                        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_005" data-options="disabled:${UPD}" >Save</a>
	                    	</div>
	                    </td>
	                </tr>
	            </table>
	        </fieldset>
	    </form>
	</div>
</div>


<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>
<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
</html>