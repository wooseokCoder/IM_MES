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
<script type="text/javascript" src="<c:url value="/resources/js/common/mail/userlist.js" />"></script>

</head>

<body class="easyui-layout" id="main-layout">
<input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>
	<!-- [LAYOUT2] start -->
	<div class="easyui-layout" data-options="width:372,height:410">
	    <!-- [WEST] start -->
	    <div data-options="region:'west',border:false,width:372,height:410">
			<table id="search-grid" data-options="width:372,height:410">
				<thead>
					<tr>
						<th data-options="field:'userId',   width:180, halign:'center', align:'left', sortable:true, data_popup:'POP_GRD_001'">아이디</th>
						<th data-options="field:'userName', width:150, halign:'center', align:'left', sortable:true, data_popup:'POP_GRD_002'">수신자명</th>
					</tr>
				</thead>
			</table>
			<div id="search-toolbar" class="wui-toolbar">
				<form id="search-form">
					<fieldset>
						<input type="hidden" name="hdfIndex" id="hdfIndex" value="" />
						<input class="easyui-combobox" name="searchKey"  id="s_searchKey"  value="S01" codeGrup="ADDR_STYPE" data-options="mode:'remote',width:100,editable:false,loader:jcombo.loader"/>
						<input class="easyui-textbox"  name="searchText" id="r_searchText" style="width:150px"/>
						<a href="javascript:void(0)" class="easyui-linkbutton cgray l-btn l-btn-small" id="search-button" data-popup="POP_BTN_002">검색</a>
					</fieldset>
				</form>
			</div>
		</div>
	    <!-- [CENTER] start -->
	    <div data-options="region:'center',border:false" style="width:310px;height:407px;">
	    	<div id="adder-toolbar" class="wui-toolbar datagrid-toolbar" style="padding-top:1px;">
				<form id="search-form"></form>
				<fieldset>
			        <table cellpadding="5" class="search-table  tableEtc-c" style="width:95%;">
			            <tr>
							<td >
								<a href="javascript:void(0)" class="easyui-linkbutton c6" id="submit-button" style="float:right;" data-popup="POP_BTN_003">확인</a>
							</td>
			            </tr>
			        </table>
				</fieldset>
			</div>
	    	<div data-options="region:'noth',border:false" style="width:310px;height:187px;">
	    		<div data-options="region:'west',border:false" style="width:60px;height:187px;position:relative;display:inline-block;">
	    			<div style="position:absolute;top:50%;left:0;transform:translateY(-50%);">
		    			<a href="javascript:void(0)" id="to_right_arow" style="padding:0 18px 0 18px;">
		    				<img src="<%=request.getContextPath() %>/resources/images/addr_right-arrow.jpg" style="width:26px;"></img>
		    			</a>
		    			<a href="javascript:void(0)" id="to_left_arow" style="padding:0 18px 0 18px;">
		    				<img src="<%=request.getContextPath() %>/resources/images/addr_left-arrow.jpg" style="width:26px;margin-top:15px;"></img>
		    			</a>
	    			</div>
	    		</div>
	    		<div data-options="region:'center', border:false" style="width:230px;height:187px;display:inline-block;">
	    			<p style="width:100%;height:20px;float:left;margin:0;" data-popup="POP_LAB_007">수신</p>
	    			<div style="border:1px solid #eee;width:100%;height:167px;overflow-y:auto;">
		    			<table id="to_list" style="width:100%;">
		    				
		    			</table>
	    			</div>
	    		</div>
	    	</div>
	    	<div data-options="region:'center',border:false" style="width:310px;height:181px;">
	    		<div data-options="region:'west',border:false" style="width:60px;height:181px;position:relative;display:inline-block;">
	    			<div style="position:absolute;top:50%;left:0;transform:translateY(-50%);">
		    			<a href="javascript:void(0)" id="cc_right_arow" style="padding:0 18px 0 18px;">
		    				<img src="<%=request.getContextPath() %>/resources/images/addr_right-arrow.jpg" style="width:26px;"></img>
		    			</a>
		    			<a href="javascript:void(0)" id="cc_left_arow" style="padding:0 18px 0 18px;">
		    				<img src="<%=request.getContextPath() %>/resources/images/addr_left-arrow.jpg" style="width:26px;margin-top:15px;"></img>
		    			</a>
	    			</div>
	    		</div>
	    		<div data-options="region:'center',border:false" style="width:230px;height:181px;display:inline-block;">
	    			<p style="width:100%;height:20px;float:left;margin:0;" data-popup="POP_LAB_008">참조</p>
	    			<div style="border:1px solid #eee;width:100%;height:161px;overflow-y:auto;">
		    			<table id="cc_list" style="width:100%;">
		    				
		    			</table>
	    			</div>
	    		</div>
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
