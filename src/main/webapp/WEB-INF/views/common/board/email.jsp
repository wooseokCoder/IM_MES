<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)emailReceive.jsp 1.0 2014/09/12                                    --%>
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
<%-- 전자메일 받은메일함 화면이다.                                              --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/09/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/email.js" />"></script>
<script type="text/javascript">
	 doInit({
		sysId:    '${model.sysId}',
		title:    '${progName}',
		bordName: '${model.bordName}',
		bordGrup: '${model.bordGrup}',
		bordType: '${model.bordType}',
		pageType: '${model.pageType}',
		pageSize: '${pageSize}'
	});
</script>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>

<table id="search-grid"></table>

<div id="search-toolbar" class="wui-toolbar">

	<form id="search-form">
		<fieldset>
			<input type="hidden" name="sysId"    id="s_sysId"    value="${model.sysId}"   />
			<input type="hidden" name="bordGrup" id="s_bordGrup" value="${model.bordGrup}"/>
			<input type="hidden" name="pageType" id="s_pageType" value="${model.pageType}"/>
			<input class="easyui-combobox" name="searchKey"  id="s_searchKey"  value="S01" codeGrup="BORD_STYPE" data-options="mode:'remote',width:100,editable:false,loader:jcombo.loader"/>
			<input class="easyui-textbox"  name="searchText" id="r_searchText" style="width:300px"/>
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" id="search-button">검색</a>
		</fieldset>
	</form>
	
    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true"   id="append-button">메일작성</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" id="remove-button">삭제</a>
</div>

<!-- 등록 레이어 -->
<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;"></div>
<!-- 조회 레이어 -->
<div id="select-dialog" class="wui-dialog" style="border-top-width:1px;"></div>
<!-- 수신자설정 레이어 -->
<div id="address-dialog" class="wui-dialog"></div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
