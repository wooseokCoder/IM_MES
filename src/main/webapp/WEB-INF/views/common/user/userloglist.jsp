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
<script type="text/javascript" src="<c:url value="/resources/js/common/user/userloglist.js?v=1024c" />"></script>

<style>
#account-layout{min-width:1000px !important;}
#report-button-pdf .l-btn-text{
	width: 100px;
}
.search-label-h {width:10%;}

#accTimeBgn + .datebox, #accTimeEnd + .datebox {
	width: 45% !important;
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
			<th data-options="field:'sysId', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_001', sortable:true">System</th>
			<th data-options="field:'userId', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_002', sortable:true">User ID</th>
			<th data-options="field:'clientName', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_003', sortable:true">User Name</th>
			<th data-options="field:'accTime', halign:'center',width:150, editor:{type:'validatebox'},data_item:'GRD_004', sortable:true">Access Time</th>
			<th data-options="field:'clientIp', halign:'center',width:150, editor:{type:'validatebox'},data_item:'GRD_005', sortable:true">Client IP</th>
			<th data-options="field:'progId', halign:'center',width:300, editor:{type:'validatebox'},data_item:'GRD_006', sortable:true">Prog ID</th>
			<th data-options="field:'clientAgent', halign:'center',width:700, editor:{type:'validatebox'},data_item:'GRD_007', sortable:true">Web Browser</th>
			<th data-options="field:'logRemk', halign:'center',width:300,data_item:'GRD_008', sortable:true">Remark</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<!-- <fieldset class="div-line-new" > -->
		<fieldset class="Remake-div-line-new" >
	        <table cellpadding="5" class="search-table tableSearch-c wd-100" style="table-layout: auto;">
	        	<tr class="topnav_sty">
            		<td colspan="12" >
            			<div>
	            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
	            			<div>
								<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}">Search</a>
								<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton btn-clear" id="dreload-button" data-item="BTN_002">Clear</a>
	                        </div>
                        </div>
            		</td>
            	</tr>
            	
	            <tr>
	            	<th class="h table-Search-h-right search-label-h" data-item="LAB_001" style="width:7% !important; min-width:0px;"><span>Access Time</span></th>
	            	<td class="d" style="width:19% !important;">
	            		<input class="easyui-datebox"  name="accTimeBgn" id="accTimeBgn" value="${accTimeBgn}"/>
	            		<span style="margin: 0 5px;"></span>
	            		<input class="easyui-datebox"  name="accTimeEnd" id="accTimeEnd" value="${accTimeEnd}"/>
	            	</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_002" style="width:7% !important; min-width:0px;"><span>User ID</span></th>
					<td class="d" style="width:12% !important;">
						<input class="easyui-textbox"  name="userId" id="userId" style="width:100px"/>
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_003" style="width:7% !important; min-width:0px;"><span>User Name</span></th>
					<td class="d" style="width:12% !important;">
						<input class="easyui-textbox"  name="clientName" id="clientName" style="width:100px"/>
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_004" style="width:7% !important; min-width:0px;"><span>Prog ID</span></th>
					<td class="d" style="width:12% !important;">
						<input class="easyui-textbox"  name="progId" id="progId" style="width:100px"/>
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_005" style="width:7% !important; min-width:0px;"><span>User Type</span></th>
                    <td class="d" style="width:12% !important;">
                        <select class="easyui-combobox" name="userType" ID="userType" data-options="width:150, height: 26, panelHeight:'auto'">
                            <option value="">ALL</option>
                            <c:forEach var ="item" items="${getUserType1}">
                                <option value="${item.CODE_NAME}">${item.CODE_NAME}</option>
                            </c:forEach>
                        </select>
                    </td>
	            </tr>
	        </table>
	   </fieldset>
	   
	   <fieldset class="div-line-new-sub grd-div-btn">
            <table cellpadding="5" class="search-table tableEtc-c wd-100" >
                <tr>
                    <td class="h">
                    	<div class="dis_flex_gap4" >
							<a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_003">
								Excel Download&nbsp;
								<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/excel_download.png" />
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
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
