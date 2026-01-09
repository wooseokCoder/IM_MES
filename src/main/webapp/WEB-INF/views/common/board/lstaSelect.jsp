<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)index.jsp 1.0 2014/07/30                                           --%>
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
<%-- 인덱스 화면이다.                                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/lstaSelect.js?v=1022A" />"></script>

<style>
	.l-btn-small > .l-btn-left{
		margin-top:0px!important;
		
	}
	.textbox.combo > input.textbox-text{
		padding-top:6px!important;
		padding-bottom:6px!important;
	}
	.div-line-new {
	/* background-color:#ecf6ff; */
	background-color:#fff;
	height :45px;
	}
	.datagrid-header {
    border-top: 1px solid #000000;
    height: 40px !important;
    }
	.textbox > input.textbox-text{
		padding-top: 6px!important;
	}
    
</style>

</head>

<body>
    <input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>
    <input type="hidden" name="text_menuKey" id="r_mail_to" value="${r_mail_to}"/>

	<!-- [LAYOUT2] start -->

	<div class="easyui-layout" data-options="fit:true" id="search-dealer-layout" >
	    <!-- [WEST] start -->
	    <div data-options="region:'west',border:false,width:400">
			<table id="search-lsta-grid" class="easyui-datagrid">
				<thead>
					<tr>
						<th data-options="field:'USER_ID',   width:120, halign:'center', align:'left',sortable:true, data_popup:'POP_GRD_001'">ID</th>
						<th data-options="field:'USER_NAME', width:240, halign:'center', align:'left',sortable:true, data_popup:'POP_GRD_002'">Name</th>
					</tr>
				</thead> 
			</table>
			<div id="search-lsta-toolbar" class="wui-toolbar">
				<form id="search-lsta-form">
					<fieldset class="div-line-new" style="padding:8px 0px 10px 5px;">
						<input type="hidden" name="hdfIndex" id="hdfIndex" value="-1" />
						<table class="wd-100">
							<td>
								<div class="dis_flex_gap5" style="justify-content: space-between;">
									<span id="searchBm">
										<select class="easyui-combobox" name="s_userId" ID="s_userId" data-options="width:150,height:30">
											<option value="">Select.</option>
											<c:forEach var="selectLstaList" items="${selectLstaList}">
												<option value="${selectLstaList.USER_ID}">${selectLstaList.USER_NAME}</option>
											</c:forEach>
										</select>								
									</span>
									<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-popup="POP_BTN_002" data-options="width:90">Select</a>
								</div>
							</td>
						</table>
					</fieldset>
				</form>
			</div>
		</div>
	    <!-- [CENTER] start -->
	    <%-- <div data-options="region:'center',border:false" style="width:50px;">
    		<div style="position:absolute;top:45%;left:-11px;;transform:translateY(-50%);">
    			<a href="javascript:void(0)" id="to_right_arow" style="padding:0 18px 0 18px;">
    				<img src="<c:url value="/resources/images/addr_right-arrow.jpg" />" style="width:26px;"></img>
    			</a>
    			<a href="javascript:void(0)" id="to_left_arow" style="padding:0 18px 0 18px;">
    				<img src="<c:url value="/resources/images/addr_left-arrow.jpg" />" style="width:26px;margin-top:15px;"></img>
    			</a>
   			</div>
	    </div> --%>
	    
	    <div data-options="region:'center',border:false" style="width:50px;height:360px; display: flex; flex-direction: column; justify-content: center; align-items: center;">
    		<div class="centerImg" style="">
    			<a href="javascript:void(0)" id="to_right_arow" style="">
    				<img class="trs_180" src="<c:url value="/resources/images/icon_new/fa-solid_angle-right.png" />" ></img>
    			</a>
    		</div>
    		<div class="centerImg" style="margin-top: 16px;">
    			<a href="javascript:void(0)" id="to_left_arow" style="">
    				<img src="<c:url value="/resources/images/icon_new/fa-solid_angle-right.png" />" ></img>
    			</a>
   			</div>
   		</div>
   		
   		
	    <div data-options="region:'east',border:false" style="width:310px;height:420px;">
	    	<div id="adder-toolbar" class="wui-toolbar datagrid-toolbar" >
				<form id="search-form"></form>
				<fieldset class="div-line-new-sub" style="padding: 4px 0; background-color: #fff;">
			        <table cellpadding="5" class="search-table  tableEtc-c" style="width:95%;">
			            <tr>
							<td >
								<a href="javascript:void(0)" class="easyui-linkbutton c6" id="submit-button" style="float:right;" data-popup="POP_BTN_006">Save</a>
							</td>
			            </tr>
			        </table>
				</fieldset>
			</div>
   			<p style="width:100%;height:25px;margin:0;font-weight:600;background-color:#ecf6ff;padding:3px 0px 3px 10px;" data-popup="POP_LAB_007">Selected</p>
   			<div style="border:1px solid #eee;width:100%;height:394px;overflow-y:auto;border-bottom:1px solid #8a8a8a;margin-bottom:9px;scrollbar-width: thin;">
    			<table id="to_list" style="width:100%;"></table>
   			</div>
    	</div>
    </div>
<script type="text/javascript">

$(function() {
	doLangSettingPopTable();
});
</script>
</body>
</html>
