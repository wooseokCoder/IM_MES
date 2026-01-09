<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)user.jsp 1.0 2014/08/12                                            --%>
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
<%-- 사용자관리 화면이다.                                                      --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/code/barcode.js" />"></script>
<script type="text/javascript">
	 doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
</script>
<script type="text/javascript" src="<c:url value="/resources/js/business/company/phonebook.js" />"></script>
<script>
/**
 *  제목		: [유틸리티]-[전화번호부]를 처리하는 스크립트
 *  작성자	: 김연주
 *  날짜		: 2017-03-14
 */
</script>
<style>
#account-layout{min-width:1200px !important;}
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
<table id="search-grid">

	<thead data-options="frozen:true">
		<tr>
			<th data-options="field:'SEQ',sortable:true, halign:'center', width:150,hidden:true,data_item:'GRD_001'">CODE</th>
			<th data-options="field:'custName',   halign:'center', width:150, editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_002'">거래처명</th>
		</tr>
	</thead>
	<thead>
		<tr>
			<th data-options="field:'custTel', halign:'center', width:150, editor:{type:'validatebox'}, data_item:'GRD_003', sortable:true">전화번호</th>
			<th data-options="field:'custFax', halign:'center', width:150, editor:{type:'validatebox'}, data_item:'GRD_004', sortable:true">FAX</th>
			<th data-options="field:'custHP',  halign:'center', width:150, editor:{type:'validatebox'}, data_item:'GRD_005', sortable:true">HP</th>
			<th data-options="field:'remark',  halign:'center', width:250,  editor:{type:'validatebox'},data_item:'GRD_006', sortable:true">참고사항</th>
			<th data-options="field:'stafDept', halign:'center',  width:200, sortable:true,editor:consts.combo.stafDept.editor(),formatter:consts.combo.stafDept.formatter(), data_item:'GRD_007'" >입력부서</th>
			<th data-options="field:'regiId',   halign:'center', width: 80, align:'center',data_item:'GRD_008', sortable:true">입력담당</th>
		</tr>
	</thead>
</table>


<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<fieldset class="div-line-new" >
	        <table cellpadding="5" class="search-table tableSearch-c" >
	            <tr>
					<th class="h table-Search-h"><span data-item="LAB_001">거래처명</span></th>
					<td class="d"><input class="easyui-textbox"  name="searchCustName" id="searchCustName" style="width:150px"/></td>

					<th class="h" data-item="LAB_002"><span>입력부서 </span></th>
					<td class="d">
					<select class="easyui-combobox" name="searchStafDept" ID="searchStafDept" data-options="width:100">
							<option value="">전체</option>
							<c:forEach var="item" items="${result}">
								<c:if test="${item.CODE_GRUP eq 'DEPT_CODE' }">
									<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
								</c:if>
							</c:forEach>
						</select>
					</td>

					<th class="h table-Search-h"><span data-item="LAB_003">입력담당 </span></th>
					<td class="d"><input class="easyui-textbox"  name="searchRegiId" id="searchRegiId" style="width:150px"/></td>

					<td class="b">
						<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}">검색</a>
					</td>
	            </tr>
	        </table>
	   </fieldset>

	    <fieldset class="div-line-new-sub">
	        <table cellpadding="5" class="search-table tableEtc-c">
	            <tr>
					<td class="h">
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}" >추가</a>
				    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_003" data-options="disabled:${UPD}" >저장</a>
				    	<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel"  id="excel-button" data-item="BTN_004">엑셀</a>
					    <a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_005">초기화</a>
					</td>
	            </tr>
	        </table>
		</fieldset>
	</form>
</div>
<!-- [LAYOUT] end -->
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>



<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>