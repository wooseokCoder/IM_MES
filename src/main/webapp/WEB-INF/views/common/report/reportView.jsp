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
<%-- 코드관리 화면이다.                                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/report/reportview.js" />"></script>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<table id="search-grid">
	<thead data-options="frozen:true">
		<tr>
			<th data-options="field:'codeCd',   halign:'center', width:100, data_item:'GRD_001', editor:{type:'validatebox',options:{required:true}}, sortable:true">코드</th>
			<th data-options="field:'codeName', halign:'center', width:150, data_item:'GRD_002', editor:{type:'validatebox',options:{required:true}}, sortable:true">코드명칭</th>
			<th data-options="field:'sortSeq',  halign:'center', width: 50, data_item:'GRD_003',  editor:{type:'validatebox',options:{required:true}}, sortable:true, align:'center'">순서</th>
		</tr>
	</thead>
	<thead>
		<tr>
			<th data-options="field:'codeGrup', width:100"></th>
			<th data-options="field:'useFlag',  halign:'center',width: 80, data_item:'GRD_004', formatter:jformat.useflag, align:'center'">사용유무</th>
			<th data-options="field:'codeDesc', halign:'center',width:250, data_item:'GRD_005'">코드설명</th>
			<th data-options="field:'extChr01', halign:'center',width:100, data_item:'GRD_006'">문자속성01</th>
			<th data-options="field:'extChr02', halign:'center',width:100, data_item:'GRD_007'">문자속성02</th>
			<th data-options="field:'extChr03', halign:'center',width:100, data_item:'GRD_008'">문자속성03</th>
			<th data-options="field:'extChr04', halign:'center',width:100, data_item:'GRD_009'">문자속성04</th>
			<th data-options="field:'extChr05', halign:'center',width:100, data_item:'GRD_010'">문자속성05</th>
			<th data-options="field:'extChr06', halign:'center',width:100, data_item:'GRD_011'">문자속성06</th>
			<th data-options="field:'extChr07', halign:'center',width:100, data_item:'GRD_012'">문자속성07</th>
			<th data-options="field:'extChr08', halign:'center',width:100, data_item:'GRD_013'">문자속성08</th>
			<th data-options="field:'extChr09', halign:'center',width:100, data_item:'GRD_014'">문자속성09</th>
			<th data-options="field:'extChr10', halign:'center',width:100, data_item:'GRD_015'">문자속성10</th>
			<th data-options="field:'extNum01', halign:'center',width:100, data_item:'GRD_016', align:'right'">숫자속성01</th>
			<th data-options="field:'extNum02', halign:'center',width:100, data_item:'GRD_017', align:'right'">숫자속성02</th>
			<th data-options="field:'extNum03', halign:'center',width:100, data_item:'GRD_018', align:'right'">숫자속성03</th>
			<th data-options="field:'extNum04', halign:'center',width:100, data_item:'GRD_019', align:'right'">숫자속성04</th>
			<th data-options="field:'extNum05', halign:'center',width:100, data_item:'GRD_020', align:'right'">숫자속성05</th>
			<th data-options="field:'extText' , halign:'center',width:250, data_item:'GRD_021'">기타정보</th>
			<th data-options="field:'regiId',   halign:'center',width: 80, data_item:'GRD_022', align:'center'">등록자ID</th>
			<th data-options="field:'regiDate', halign:'center',width:140, data_item:'GRD_023', align:'center'">등록일시</th>
			<th data-options="field:'chngId',   halign:'center',width: 80, data_item:'GRD_024', align:'center'">수정자ID</th>
			<th data-options="field:'chngDate', halign:'center',width:140, data_item:'GRD_025', align:'center'">수정일시</th>
		</tr>
	</thead>
</table>

<!-- fieldset 구분 변경  20160928 박소현 -->
<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<fieldset class="div-line-new" >
	        <table cellpadding="5" class="search-table tableSearch-c" >
	            <tr>
					<th class="h table-Search-h"><span data-item="LAB_001">코드그룹 </span></th>
					<td class="d">
						<select class="easyui-combobox" name="codeGrup" ID="s_codeGrup" data-options="mode:'remote',onChange:doGrupChange">
							<option value="ALL">전체</option>
							<c:forEach var="selectCode" items="${selectCode}">
								<option value="${selectCode.codeCd}" >${selectCode.codeName}</option>
							</c:forEach>
							<option value="0" selected>코드그룹</option>
						</select>
					</td>
					<th class="h"><span data-item="LAB_002">사용여부 </span></th>
					<td class="d">
						<select class="easyui-combobox" name="useFlag" ID="s_useFlag" data-options="mode:'remote',onChange:doGrupChange">
							<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'USE_FLAG' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
							</c:forEach>
						</select>
					<!-- span class 추가 20160928 박소현 -->
						<!-- <span class="radio-span">
							<input name="useFlag" type="radio" value="Y" id="s_useFlag1"/><label for="s_useFlag1">사용중</label>
							<input name="useFlag" type="radio" value="N" id="s_useFlag2"/><label for="s_useFlag2">중지</label>
						</span> -->
					</td>
					<th class="h"><span data-item="LAB_003">정렬선택 </span></th>
					<td class="d">
						<select class="easyui-combobox" name="sort" ID="s_sort" data-options="mode:'remote',width:85,onChange:doGrupChange">
							<c:forEach var="selectCodeSort" items="${selectCodeSort}">
								<option value="${selectCodeSort.codeCd}" <c:if test="${selectCodeSort.codeCd eq 'codeName'}">selected</c:if>>${selectCodeSort.codeName}</option>
							</c:forEach>
						</select>
					<!-- <input class="easyui-combobox" name="sort" id="s_sort" codeGrup="CODE_SORT" data-options="mode:'remote',width:100,loader:jcombo.loader"/> -->
					</td>
					<td class="b">
						<!-- <a href="javascript:void(0)" class="easyui-linkbutton cgray" iconCls="icon-search" id="search-button">검색</a> -->
						<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001">검색</a> 
					</td>
	            </tr>
	        </table>
	   </fieldset>
	</form>

	<div id="report-popup" class="easyui-dialog" data-options="
		    top:     10,
		    width: 1024,
		    height: 768,
		 	closed: true,
		 	title: false,
		 	iconCls:'icon-edit',
		    modal: true,
		    resizable: true
		 ">
		 <iframe id="report-iframe" frameborder="0" src="" style="width:100%;height:100%;"></iframe>
	</div>
</div>
<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
