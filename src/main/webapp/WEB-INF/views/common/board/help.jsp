<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)board.jsp 1.0 2014/08/24                                           --%>
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
<%-- 게시판관리 화면이다.                                                      --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/24                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/help.js" />"></script>
<script type="text/javascript">
	 doInit({
		sysId:    '${model.sysId}',
		title:    '${model.bordName}',
		bordGrup: '${model.bordGrup}',
		bordType: '${model.bordType}',
		pageSize: '${sessionScope.rows}'
	});
</script>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<table id="search-grid"></table>

<div id="search-toolbar" class="wui-toolbar">

	<form id="search-form">
		<fieldset class="div-line-new">
			<input type="hidden" name="sysId"    id="s_sysId"    value="${model.sysId}"   />
			<input type="hidden" name="bordGrup" id="s_bordGrup" value="${model.bordGrup}"/>
			<table cellpadding="5" class="search-table tableSearch-c" >
				<td class="d">
					<input class="easyui-combobox" name="searchKey"  id="s_searchKey"  value="S01" codeGrup="BORD_STYPE" data-options="mode:'remote',width:100,editable:false,loader:jcombo.loader,panelHeight:'auto'"/>
					<input class="easyui-textbox"  name="searchText" id="r_searchText" style="width:300px"/>
				</td>
				<td class="b">
					<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001">검색</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel"  id="excel-button" data-item="BTN_002">엑셀</a>
				</td>
			</table>
		</fieldset>
			<input type="hidden" id="hdfIndex" value="-1" />
			<input type="hidden" id="hdfChk" value="" />
	</form>

    <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"    id="append-button">등록</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" id="remove-button">삭제</a> -->

	<div>
	<fieldset class="div-line-new-sub">
		<table  cellpadding="5" class="search-table tableEtc-c">
			<tr >
				<td class="h" style="width:500px; min-width: 200px">
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_003">등록</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_004">삭제</a>
				</td>
				<td class="h etctext" style="width:80%;" data-item="TXT_001"><span>상세 정보는 해당 행을 더블클릭하시면 확인 할수 있습니다.</span></td>
			</tr>
		</table>
	</fieldset>
	</div>
</div>

<!-- 등록 레이어 -->
<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;"></div>
<!-- 조회 레이어 -->
<div id="select-dialog" class="wui-dialog" style="border-top-width:1px;"></div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
