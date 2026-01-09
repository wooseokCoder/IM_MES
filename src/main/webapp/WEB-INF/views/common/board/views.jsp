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
<script type="text/javascript" src="<c:url value="/resources/js/common/board/views.js" />"></script>
<script>
$(function(){

	if(window.innerWidth<1100){
		$(".window").addClass("forcedLeft");
		$(".window-shadow").addClass("forcedLeft");
		
	}
	
})


</script>
<style>
.forcedLeft{left:2px !important;}

</style>
</head>

<body class="easyui-layout" id="main-layout">
<input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>
	<table id="search-grid">
		<thead>
			<tr>
				<th data-options="field:'tgtUserId', width:120, halign:'center', align:'center', sortable:true, data_popup:'POP_GRD_001'">사용자ID</th>
				<th data-options="field:'vndrCode',  width:100, halign:'center', align:'center', sortable:true, data_popup:'POP_GRD_002'">업체코드</th>
				<th data-options="field:'vndrName',  width:200, halign:'center', align:'left', sortable:true, data_popup:'POP_GRD_003'">업체명</th>
				<th data-options="field:'readDate',  width:150, halign:'center', align:'center', sortable:true, data_popup:'POP_GRD_004'">확인일시</th>
			</tr>
		</thead>
	</table>
	<div id="search-toolbar" class="wui-toolbar">
		<form id="search-form" >
			<fieldset class="div-line-new" style="padding-top:8px ;padding-bottom:10px;padding-left:10px;">
				<input type="hidden" name="bordNo"   id="r_bordNo"   value="${bordNo}" />
				<input type="hidden" name="bordGrup" id="r_bordGrup" value="${bordGrup}" />
				<input class="easyui-combobox" name="searchKey"  id="s_searchKey"  value="S01" codeGrup="VIEWS_STYPE" data-options="mode:'remote',width:100,editable:false,loader:jcombo.loader"/>
				<input class="easyui-textbox"  name="searchText" id="r_searchText" style="width:150px"/>
				<a href="javascript:void(0)" class="easyui-linkbutton cgray l-btn l-btn-small" id="search-button" data-popup="POP_BTN_001">검색</a>
			</fieldset>
		</form>
	</div>
<script type="text/javascript">

$(function() {
	doSearch();
	doLangSettingPopTable();
});
</script>
</body>
</html>
