<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)codeLoader.jsp 1.0 2014/09/29                                      --%>
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
<%-- 코드엑셀로더 화면이다.                                                    --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/09/29                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/code/codeLoader.js" />"></script>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>

<table id="search-grid">
	<thead>
		<tr>
			<th data-options="field:'codeGrup',width:100,halign:'center',align:'center',editor:{type:'validatebox',options:{required:true}}">코드그룹</th>
			<th data-options="field:'codeCd',  width:100,halign:'center',align:'center',editor:{type:'validatebox',options:{required:true}}">코드</th>
			<th data-options="field:'codeName',width:150,halign:'center',align:  'left',editor:{type:'validatebox',options:{required:true}}">코드명칭</th>
			<th data-options="field:'sortSeq', width: 50,halign:'center',align: 'right',editor:'numberbox'">순서</th>
			<th data-options="field:'codeDesc',width:250,halign:'center',align:  'left',editor:'text'">코드설명</th>
			<th data-options="field:'extChr01',width:100,halign:'center',align:  'left',editor:'text'">문자속성01</th>
			<th data-options="field:'extChr02',width:100,halign:'center',align:  'left',editor:'text'">문자속성02</th>
			<th data-options="field:'extChr03',width:100,halign:'center',align:  'left',editor:'text'">문자속성03</th>
			<th data-options="field:'extChr04',width:100,halign:'center',align:  'left',editor:'text'">문자속성04</th>
			<th data-options="field:'extChr05',width:100,halign:'center',align:  'left',editor:'text'">문자속성05</th>
			<th data-options="field:'extChr06',width:100,halign:'center',align:  'left',editor:'text'">문자속성06</th>
			<th data-options="field:'extChr07',width:100,halign:'center',align:  'left',editor:'text'">문자속성07</th>
			<th data-options="field:'extChr08',width:100,halign:'center',align:  'left',editor:'text'">문자속성08</th>
			<th data-options="field:'extChr09',width:100,halign:'center',align:  'left',editor:'text'">문자속성09</th>
			<th data-options="field:'extChr10',width:100,halign:'center',align:  'left',editor:'text'">문자속성10</th>
			<th data-options="field:'extNum01',width:100,halign:'center',align: 'right',editor:'numberbox'">숫자속성01</th>
			<th data-options="field:'extNum02',width:100,halign:'center',align: 'right',editor:'numberbox'">숫자속성02</th>
			<th data-options="field:'extNum03',width:100,halign:'center',align: 'right',editor:'numberbox'">숫자속성03</th>
			<th data-options="field:'extNum04',width:100,halign:'center',align: 'right',editor:'numberbox'">숫자속성04</th>
			<th data-options="field:'extNum05',width:100,halign:'center',align: 'right',editor:'numberbox'">숫자속성05</th>
			<th data-options="field:'extText' ,width:250,halign:'center',align:  'left',editor:'text'">기타정보</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form" method="post" enctype="multipart/form-data">
		<fieldset>
	        <table cellpadding="5" class="search-table">
	            <tr>
					<th class="h"><span>엑셀파일선택:</span></th>
					<td class="d">
						<input type="file" name="excelFile" id="s_excelFile" size="40"/>
					</td>
	            </tr>
	        </table>
		</fieldset>
		<fieldset class="div-line-new-sub">
	        <table cellpadding="5" class="search-table  tableEtc-c" >
	            <tr>
					<td class="h">
					    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="upload-button">업로드</a>
					    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="clear-button" >초기화</a>
					    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button">삭제</a>
					    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  >저장</a>
					</td>
				</tr>
			</table>
		</fieldset>
	</form>
</div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
