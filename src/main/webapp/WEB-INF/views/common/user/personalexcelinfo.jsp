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
<%-- 코드관리 화면이다.                                                             --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/personalexcelinfo.js" />"></script>
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

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">
	<table id="search-grid">
	    <thead>
	        <tr>
	            <th data-options="field:'windId',  width:220 , halign:'center', editor:{type:'textbox'}, sortable:true, data_item:'GRD_001'">Window Id</th>
	            <th data-options="field:'windName', width:150, halign:'center', sortable:true, data_item:'GRD_002'">Window Name</th>
	            <th data-options="field:'viewSeq',  width:80,  halign:'center', align:'center', editor:{type:'textbox'}, sortable:true, data_item:'GRD_003'">VIEW SEQ</th>
	            <th data-options="field:'viewType', width:80, halign:'center', align:'center', editor:{type:'textbox'}, sortable:true, data_item:'GRD_004'">VIEW Type</th>
	            <th data-options="field:'colDesc',  width:200, halign:'center', align:'left',   editor:{type:'textbox'}, sortable:true, data_item:'GRD_005'">COL Label</th>
	            <th data-options="field:'colId',    width:200, halign:'center', align:'left',   editor:{type:'textbox'}, sortable:true, data_item:'GRD_006'">COL Value</th>
	            <th data-options="field:'exceColId',width:200, halign:'center', align:'left',   editor:{type:'textbox'}, sortable:true, data_item:'GRD_007'">Excel Column Id</th>
	            <th data-options="field:'style',    width:100, halign:'center', align:'left',   editor:consts.combo.Align.editor(), sortable:true,data_item:'GRD_008'">Style</th>
	            <th data-options="field:'excelDown',width:60,  halign:'center', align:'center', editor:{type:'textbox'}, data_item:'GRD_009', sortable:true"  >Excel Y/N</th>
	            <th data-options="field:'mergCode' ,width:80,  halign:'center', align:'center', editor:{type:'textbox'}, data_item:'GRD_010', sortable:true"  >Merge Code</th>
	            <th data-options="field:'useYn',    width:60,  halign:'center', align:'center', editor:{type:'textbox'}, data_item:'GRD_011', sortable:true"  >Use Flag</th>
				<th data-options="field:'useRemk',	width:500, halign:'center', align:'left',	editor:{type:'textbox'}, data_item:'GRD_012', sortable:true">Remark</th>
	        </tr>
	    </thead>
	</table>
	
	<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <fieldset class="Remake-div-line-new wd-100">
            <table cellpadding="7" class="search-table tableSearch-c wd-100">
            	<colgroup>
            		<col width="7%">
            		<col width="13%">
            		<col width="*">
            	</colgroup>
            	<tr class="topnav_sty">
            		<td colspan="3">
            			<div>
            				<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
            				<div>
            					<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}">Search</a>
            				</div>
            			</div>
            		</td>
            	</tr>
	                <tr>
	                    <th class="h table-Search-h search-label-h2" style="min-width: 127px;" data-item="LAB_001"><span>FILE_NM </span></th>
	                    <td class="d" style="min-width: 165px;">
	                        <select class="easyui-combobox" name="s_windId" ID="s_windId" data-options="width:180,height:30">
	                            <option value="" selected>ALL</option>
	                            <c:forEach var="selectCode" items="${selectCode}">
	                                <option value="${selectCode.windId}" >${selectCode.windName}</option>
	                            </c:forEach>
	                        </select>
	                    </td>
	                    <td class="b w-a" style="text-align: right;">
	                        <!-- Search 버튼은 topnav_sty로 이동됨 -->
	                    </td>
	                </tr>
	            </table>
	        </fieldset>
        <fieldset class="div-line-new-sub grd-div-btn">
            <table cellpadding="7" class="search-table tableEtc-c wd-100">
                <tr>
                    <td class="h">
						<div class="dis_flex_gap4">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_003" data-options="disabled:${INS}" >Add</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_004" data-options="disabled:${DEL}" >Del</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_005" data-options="disabled:${UPD}" >Save</a>
						</div>
                    </td>
                </tr>
            </table>
        </fieldset>
	    </form>
	</div>
</div>


<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>
<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
</html>