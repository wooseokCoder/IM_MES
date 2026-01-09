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
<%-- 게시판관리 화면이다.                                                      		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/24                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/boardmanagement.js?v=0626A" />"></script>
<script type="text/javascript">
	 doInit({
		sysId:    '${model.sysId}',
		title:    '${model.bordName}',
		bordGrup: '${model.bordGrup}',
		bordType: '${model.bordType}',
		pageSize: '${sessionScope.rows}'
	});
</script>
<style>
#account-layout{min-width:1200px !important;}
.search-label-h2 {
    width: 128px;
}
table.search-table td.d {
    padding-right: 20px;
}
#menu-button, #menu-button .l-btn-text { width: 100px; height: 32px;}
#excel-button3, #excel-button3 .l-btn-text { width: 218px; text-align: left; border-radius:0px;}
#excel-button3 .l-btn-text, #excel-button4 .l-btn-text { padding-left: 25px;} 
.menu{border-style:none;}
.menu-line {
   border-left: none; 
   border-right: none; 
}
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
	<thead>
		<tr>
			<th data-options="field:'bordNo',   width:100,halign:'center',align:'center', sortable:true, data_item:'GRD_001'">Bord No</th>
			<th data-options="field:'bordGrup' , halign:'center',align:'center',width: 100, data_item:'GRD_002'">Bord ID</th>
			<th data-options="field:'codeName' , halign:'center',align:'center',width: 100, data_item:'GRD_003'">Bord Name</th>
			<th data-options="field:'bordTitle', width:350, halign:'center',align:'left', sortable:true, data_item:'GRD_004'">Title</th>
			<th data-options="field:'bordSeq' , halign:'center',align:'center',width: 100, editor:{type:'validatebox',options:{required:true}}, sortable:true, data_item:'GRD_005'">Seq</th>
			<!-- <th data-options="field:'readCnt', halign:'center',align:'right', width: 80"  >조회수</th> -->
			<th data-options="field:'regiId' , halign:'center',align:'center',width: 150, data_item:'GRD_006'">Regi ID</th>
			<th data-options="field:'regiDate' , halign:'center',align:'center',width: 150, data_item:'GRD_007'">Regi Date</th>
			<th data-options="field:'chngId' , halign:'center',align:'center',width: 150, data_item:'GRD_008'">Chng ID</th>
			<th data-options="field:'chngDate' , halign:'center',align:'center',width: 150, data_item:'GRD_009'">Chng Date</th>

		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<fieldset class="Remake-div-line-new">
		<input type="hidden" name="sysId"    id="s_sysId"    value="${model.sysId}"   />
			<table cellpadding="5" class="search-table tableSearch-c wd-100">
				<colgroup>
					<col width="7%" style="min-width: 120px;" />
					<col width="18%" style="min-width: 150px;" />
					<col width="7%" style="min-width: 120px;" />
					<col width="25%" style="min-width: 150px;" />
					<col width="*%" style="min-width: 200px;" />
				</colgroup>
				<tr class="topnav_sty">
					<td colspan="5">
						<div>
							<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
							<div>
								<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001">Search</a>
							</div>
						</div>
					</td>
				</tr>
	            <tr>
					<th class="h table-Search-h" data-item="LAB_001"><span>Bord Type</span></th>
					<td class="d">
						<select class="easyui-combobox" name="codeGrup" ID="s_codeGrup" data-options="width:150,height:30">
							<option value="ALL">ALL</option>
							<c:forEach var="bordTypeCode" items="${bordTypeCode}">
								<option value="${bordTypeCode.codeCd}" >${bordTypeCode.codeName}</option>
							</c:forEach>
						</select>
					</td>
					<th class="h table-Search-h" data-item="LAB_002"><span>Condition</span></th>
					<td class="d">
						<div class="dis_flex_gap5">
							<div style="width: 100px;">
								<input class="easyui-combobox" name="searchKey"  id="s_searchKey"  value="S01" codeGrup="BORD_STYPE" data-options="width:100,editable:false,loader:jcombo.loader,panelHeight:'auto'"/>
							</div>
							<div style="width: calc(100% - 100px);">
								<input class="easyui-textbox"  name="searchText" id="r_searchText" style="width:400px;"/>
							</div>
						</div>
					</td>
					<td class="b"></td>
				</tr>
			</table>
		</fieldset>
			<input type="hidden" id="hdfIndex" value="-1" />
			<input type="hidden" id="hdfChk" value="" />
	</form>

    <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"    id="append-button">등록</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" id="remove-button">삭제</a> -->

	<!-- <div> -->
	<fieldset class="div-line-new-sub grd-div-btn">
		<table cellpadding="5" class="search-table tableEtc-c wd-100">
			<tr>
				<td class="h">
					<div class="dis_flex_gap4">
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_002">Save</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003">Del</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_004">Excel Download&nbsp;
							<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/excel_download.png" />
						</a>
					</div>
				</td>
			</tr>
		</table>
	</fieldset>
	<!-- </div> -->
</div>

<!-- 등록 레이어 -->
<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;"></div>
<!-- 조회 레이어 -->
<div id="select-dialog" class="wui-dialog" style="border-top-width:1px;"></div>


<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="easyui-dialog" >
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
