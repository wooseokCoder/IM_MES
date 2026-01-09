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
<script type="text/javascript">
	 /* doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	}); */
</script>
<script type="text/javascript" src="<c:url value="/resources/js/common/lstractor/mdpboard.js?v=0525" />"></script>
<script>
/**
 *  제목		: [유틸리티]-[전화번호부]를 처리하는 스크립트
 *  작성자	: 김연주
 *  날짜		: 2017-03-14
 */
</script>
<script type="text/javascript" src="https://public.tableau.com/javascripts/api/tableau-2.min.js"></script>
<style>
#account-layout{min-width:1200px !important;}
.selectdate span.textbox > input.textbox-text{
    background-color: #E6EBF1;
}
#viz-client-container {
    height: 68vh !important;
}
::-webkit-scrollbar {
    width: 15px!important;
}
.datagrid-cell.datagrid-cell-c1-EXT_CHR05{
    font-size : 20px;
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

<!-- <button id="auto_login"> TEST </button> -->

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">
<table id="search-grid">
	<thead data-options="frozen:true">
		<tr>
			<th data-options="field:'EXT_CHR01', halign:'center', width:100, align:'center', data_item:'GRD_001', sortable:true">Area</th>
			<th data-options="field:'EXT_CHR02', halign:'center', width:300, align:'center', data_item:'GRD_002', sortable:true, sorter:dateReSort, styler:cellStyler">KPI</th>
			<th data-options="field:'EXT_CHR03', halign:'center', width:500, align:'center', data_item:'GRD_003', sortable:true, sorter:dateReSort">Purpose</th>
			<th data-options="field:'EXT_CHR04', halign:'center', width:200, align:'center', data_item:'GRD_004', sortable:true" >Create Date</th>
			<th data-options="field:'EXT_CHR05', halign:'center', width:100, align:'center', data_item:'GRD_005', sortable:true, styler:cellStyler, formatter:formatAttribute">Link</th>
		</tr>
	</thead>
</table>

<!-- [LAYOUT] end -->
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;display:none;">
	<div class="easyui-layout"  data-options="fit:true" onload="initViz();" style="overflow-y:scroll;height:600px;">
		<div id="vizContainer" style="width:1400px; height: 750px;"></div> <!-- style="width:100%;" -->
	</div>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>