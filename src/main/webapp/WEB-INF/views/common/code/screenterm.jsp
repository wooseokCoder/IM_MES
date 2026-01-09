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
<%-- 화면/용어관리 화면이다.                                                       	--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/code/screenterm.js" />"></script>

<style>
#report-button-pdf .l-btn-text{
	width: 100px;
}
.search-label-h {width:10%;}
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
			<th data-options="field:'itemGrp', halign:'center',width:100, editor:consts.combo.progId.editor(),formatter:consts.combo.progId.formatter(),data_item:'GRD_001'" >Prog Kind</th>
			<th data-options="field:'itemId', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_002'">Term ID</th>
			<th data-options="field:'itemNm', halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_003'">Term Name</th>
			<th data-options="field:'itemNmKor', halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_004'">Term Name(Kr)</th>
			<th data-options="field:'itemNmEng', halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_005'">Term Name(En)</th>
			<th data-options="field:'itemNmViet', halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_012'">Term Name(Vi)</th>
			<th data-options="field:'itemNmPort', halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_014'">Term Name(Port)</th>
			<th data-options="field:'itemNmEtc', halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_013'">Term Name(Etc)</th>
			<th data-options="field:'itemDesc', halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_006'">용어설명</th>
			<th data-options="field:'useFlag', halign:'center', align:'center' ,width:100, editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.useflag,data_item:'GRD_007'">Use Flag</th>
			<th data-options="field:'regiId', halign:'center',width:100,data_item:'GRD_008'">Regi ID</th>
			<th data-options="field:'regiDate', halign:'center',width:120,data_item:'GRD_009'">Regi Date</th>
			<th data-options="field:'chngId', halign:'center',width:100,data_item:'GRD_010'">Chng ID</th>
			<th data-options="field:'chngDate', halign:'center',width:120,data_item:'GRD_011'">Chng Date</th>
		</tr>
	</thead>
</table>

<!-- fieldset 구분 변경  20160928 박소현 -->
<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<!-- <fieldset class="div-line-new" > -->
		<fieldset class="Remake-div-line-new" >
	        <table cellpadding="5" class="search-table tableSearch-c wd-100" >
	        	<tr class="topnav_sty">
            		<td colspan="10" >
            			<div>
	            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
	            			<div>
								<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001">Search</a>
	                        </div>
                        </div>
            		</td>
            	</tr>
            	
	            <tr>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_001"><span>Prog Kind</span></th>
					<td class="d">
						<select class="easyui-combobox" name="itemGrpKey" id="s_itemGrpKey" data-options="">
							<option value="ALL">ALL</option>
							<c:forEach var="itemGrpList" items="${itemGrpList}">
								<option value="${itemGrpList.PROG_ID}" >${itemGrpList.PROG_NAME}</option>
							</c:forEach>
						</select>
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_002"><span>Use Flag</span></th>
					<td class="d">
						<select class="easyui-combobox" name="useFlag" ID="s_useFlag" data-options="width:80,panelHeight:'auto'">
						<option value="ALL">ALL</option>
							<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'USE_FLAG' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
							</c:forEach>
						</select>
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_003"><span>Term ID</span></th>
					<td class="d">
						<input class="easyui-textbox"  name="itemId" id="itemId" style="width:100px"/>
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_004"><span>Term Name</span></th>
					<td class="d">
						<input class="easyui-textbox"  name="itemNm" id="itemNm" style="width:100px"/>
					</td>
	            </tr>
	        </table>
	   </fieldset>
	        <!-- <div class="div-line-new"></div>  -->
	    <fieldset class="div-line-new-sub grd-div-btn">
	        <table cellpadding="5" class="search-table tableEtc-c wd-100" >
	            <tr>
					<td class="h">
						<div class="dis_flex_gap4" >
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002">Add</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003">Del</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_004" >Save</a>
						    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_005">
						    	Excel Download&nbsp;
						    	<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/excel_download.png" />
						    </a>
						    <a href="javascript:void(0)" class="easyui-linkbutton c4"  id="report-button-pdf" data-item="BTN_006" >
						    	Print&nbsp;
		                		<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/print.png" />
		                	</a>
						</div>
					</td>
	            </tr>
	        </table>
	        <!--  <div class="div-line"></div> -->
		</fieldset>
	</form>
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="easyui-dialog" >
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

<!-- [LAYOUT] end -->
</div>
</html>
