<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)group.jsp 1.0 2014/08/11                                           --%>
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
<%-- 그룹관리 화면이다.                                                       		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/11                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/group.js?v=1023A" />"></script>
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
	<thead>
		<tr>
			<th data-options="field:'groupId',    width:150, editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_001'">Group ID</th>
			<th data-options="field:'groupName',  width:200, editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_002'">Group Name</th>
			<th data-options="field:'useFlag', width:55,align:'center',editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.yesno,data_item:'GRD_007'" formatter="formatCheck">Blue Y/N</th>
			<th data-options="field:'regiId',data_item:'GRD_003'"  >Regi ID</th>
			<th data-options="field:'regiDate',data_item:'GRD_004'">Regi Date</th>
			<th data-options="field:'chngId',data_item:'GRD_005'"  >Chng ID</th>
			<th data-options="field:'chngDate',data_item:'GRD_006'">Chng Date</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<fieldset class="div-line3-new Remake-div-line-new" >
	        <table cellpadding="4" class="search-table tableSearch-c wd-100" >
	        	<tr class="topnav_sty">
	           		<td colspan="8" >
	           			<div>
	           				<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
	           				<div>
		           				<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton cgray" id="search-button"  data-item="BTN_001" data-options="disabled:${RET}" >Search</a>
								<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton btn-clear" id="dreload-button" data-item="BTN_006">Clear</a>
	                       </div>
	                    </div>
	           		</td>
	           	</tr>

	            <tr>
					<th class="h table-Search-h-right search-label-h"  data-item="LAB_001"><span>Group ID </span></th>
					<td class="d"><input class="easyui-textbox"   name="groupId" id="groupId" /></td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_002"><span>Group Name</span></th>
					<td class="d"><input class="easyui-textbox"   name="groupName" id="groupName"/></td>
					<%-- <td class="b">
						<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001" data-options="disabled:${RET}" >Search</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c12" id="dreload-button" data-item="BTN_006">Clear</a>
					</td> --%>
	            </tr>
	        </table>
	</fieldset>
	        <!--  <div class="div-line"></div> -->
	<fieldset class="div-line-new-sub grd-div-btn">
	        <table cellpadding="5" class="search-table tableEtc-c wd-100" >
	            <tr>
					<td class="h">
						<div class="dis_flex_gap4" >
						    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">Add</a>
						    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}">Del</a>
						    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_004" data-options="disabled:${UPD}" >Save</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_005">
						    	Excel&nbsp;
						    	<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/excel_download.png" />
						    </a>
						</div>
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

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
