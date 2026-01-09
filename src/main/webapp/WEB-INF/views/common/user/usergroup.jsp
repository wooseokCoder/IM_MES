<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)usergroup.jsp 1.0 2014/08/19                                       --%>
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
<%-- 사용자그룹관리 화면이다.                                                  		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/19                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/include/system.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/common/user/usergroup.js?v=0626A" />"></script>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- [LAYOUT1] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<fieldset class="div-line-new" >
	        <table cellpadding="7" class="search-table tableSearch-c" >
	        	<colgroup>
	        		<col width="7%" style="min-width: 120px;" />
	        		<col width="13%" style="min-width: 165px;" />
	        		<col width="7%" style="min-width: 120px;" />
	        		<col width="13%" style="min-width: 165px;" />
	        		<col width="*" style="min-width: 120px;" />
	        	</colgroup>
	        	<tr class="topnav_sty">
	        		<td colspan="5" >
	        			<div>
	            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
	            			<div>
	            			<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="">Search</a>
	                        <a href="javascript:void(0)" style="width: 80px;" id="clear-button" class="easyui-linkbutton btn-clear" data-item="BTN_002" data-options="">Clear</a>
	                        </div>
                       </div>
	        		</td>
	        	</tr>
	            <tr>
					<th class="h table-Search-h search-label-h2" data-item="LAB_001"><span>User Name </span></th>
					<td class="d">
						<select class="easyui-combobox textbox-list" name="userId" ID="userId" data-options="width:150,height:30">
							<option value="">ALL</option>
							<c:forEach var="selectUserList" items="${selectUserList}">
								<option value="${selectUserList.USER_ID}">${selectUserList.USER_ID} - ${selectUserList.USER_NAME}</option>
							</c:forEach>
						</select>
					</td>
                    <th class="h table-Search-h search-label-h2" data-item="LAB_002"><span>Group Name </span></th>
                    <td class="d">
                        <select class="easyui-combobox textbox-list" name="groupId" ID="groupId" data-options="width:150">
                            <option value="">ALL</option>
                            <c:forEach var="selectGroupList" items="${selectGroupList}">
                                <option value="${selectGroupList.GROUP_ID}">${selectGroupList.GROUP_NAME}</option>
                            </c:forEach>
                        </select>
                    </td>
					<td class="b">
					</td>
	            </tr>
	        </table>
	     </fieldset>
	     <fieldset class="div-line-new-sub grd-div-btn">
	        <table cellpadding="5" class="search-table tableEtc-c wd-100">
	            <tr>
					<td class="h">
					    <div class="dis_flex_gap4">
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_003" data-options="disabled:${INS}" >Add</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_004" data-options="disabled:${DEL}" >Del</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"   data-item="BTN_005" data-options="disabled:${UPD}" >Save</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button"  data-item="BTN_006">
					    		Excel Download&nbsp;
						    	<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/excel_download.png" />
					    	</a>
					    </div>
						<!-- <input type="hidden" name="userId"  id="s_userId"  /> -->
						<!-- <input type="hidden" name="groupId" id="s_groupId" /> -->
					</td>
	            </tr>
	        </table>
		</fieldset>
	</form>
</div>


		<table id="search-grid">
			<thead>
				<tr>
					<th data-options="field:'userId',   width:100, sortable:true, data_item:'GRD_001'">User ID</th>
					<th data-options="field:'userName', width:150, sortable:true, data_item:'GRD_002'">User Name</th>
					<th data-options="field:'groupId2', width:150, sortable:true, data_item:'GRD_003'">Group ID</th>
					<th data-options="field:'groupId',  width:150, sortable:true, editor:consts.combo.groupId.editor(),formatter:consts.combo.groupId.formatter(), data_item:'GRD_004'">Group Name</th>
					<th data-options="field:'regiId',   width: 80, data_item:'GRD_005'">Regi ID</th>
					<th data-options="field:'regiDate', width:130, data_item:'GRD_006'">Regi Date</th>
					<th data-options="field:'chngId',   width: 80, data_item:'GRD_007'">Chng ID</th>
					<th data-options="field:'chngDate', width:130, data_item:'GRD_008'">Chng Date</th>
				</tr>
			</thead>
		</table>


<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="easyui-dialog" >
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
