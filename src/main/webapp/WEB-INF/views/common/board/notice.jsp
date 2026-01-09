<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)notice.jsp 1.0 2015/04/27                                          --%>
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
<%-- 공지사항 화면(페이지 이동형태의 게시판).                                    --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2015/04/27                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/notice.js" />"></script>
<script type="text/javascript">
	 doInit({
		sysId:    '${model.sysId}',
		title:    '${model.bordName}',
		bordGrup: '${model.bordGrup}',
		bordType: '${model.bordType}',
		rows:     '${model.rows}',
		page:     '${model.page}'
	});
</script>
<style>
#account-layout{min-width:500px !important;}
.panel-header{color:#000 !important;border-bottom:1px solid #ccc !important;}
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

<table id="search-grid"></table>

<div id="search-toolbar" class="wui-toolbar">

	<form id="search-form">
		<fieldset class="div-line-new" style="border-top:0px;">
			<input type="hidden" name="sysId"    id="s_sysId"    value="${model.sysId}"   />
			<input type="hidden" name="bordGrup" id="s_bordGrup" value="${model.bordGrup}"/>
			<table cellpadding="5" class="search-table tableSearch-c" >
				<td>
					<input class="easyui-combobox" name="searchKey"  id="s_searchKey"  value="${model.searchKey}"  codeGrup="BORD_STYPE" data-options="mode:'remote',width:100,editable:false,loader:jcombo.loader,panelHeight:'auto'"/>
					<input class="easyui-textbox"  name="searchText" id="r_searchText" value="${model.searchText}" style="width:300px"/>
				</td>
				<td class="b">
					<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001">Select</a>

				</td>
			</table>
		</fieldset>
	</form>

    <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"    id="regist-button">등록</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" id="remove-button">삭제</a> -->
	<fieldset class="div-line-new-sub">
		<table  cellpadding="5" class="search-table tableEtc-c" style="width:100%;">
			<tr>
				<td class="h" style="width:500px; min-width: 200px;">
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="regist-button" data-item="BTN_002">Write</a>
				    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003">Delete</a>
				    <a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel"  id="excel-button" data-item="BTN_004">Excel Download</a>
				</td>
				<td class="h etctext" style="text-align:right;" data-item="TXT_001"><span>For more information, double click on the line.</span></td>
			</tr>
		</table>
	</fieldset>
</div>

<form id="hidden-form" method="post">
	<input type="hidden" name="oper"       id="h_oper"       value=""/>
	<input type="hidden" name="bordNo"     id="h_bordNo"     value=""/>
	<input type="hidden" name="sysId"      id="h_sysId"      value="${model.sysId}"/>
	<input type="hidden" name="bordGrup"   id="h_bordGrup"   value="${model.bordGrup}"/>
	<input type="hidden" name="bordType"   id="h_bordType"   value="${model.bordType}"/>
	<input type="hidden" name="searchKey"  id="h_searchKey"  value="${model.searchKey}"/>
	<input type="hidden" name="searchText" id="h_searchText" value="${model.searchText}"/>
	<input type="hidden" name="rows"       id="h_rows"       value="${model.rows}"/>
	<input type="hidden" name="page"       id="h_page"       value="${model.page}"/>
</form>


<!-- [LAYOUT] end -->
</div>
<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
