<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)menu.jsp 1.0 2014/08/18                                            --%>
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
<%-- 메뉴관리 화면이다.                                                       		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/18                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/menu.js?v=0210" />"></script>

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
			<th data-options="field:'parentType'  ,width:80 ,align:'center',editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_022'">Root Menu</th>
			<th data-options="field:'menuKey'  ,width:80 ,align:'center',editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_001'">Menu ID</th>
			<th data-options="field:'menuDescKr' ,width:200,align:'left'  ,editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_002'">Menu Desc</th>
			<th data-options="field:'menuDescEn' ,width:200,align:'left'  ,editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_003'">Menu Desc(En)</th>
			<th data-options="field:'menuDescPort',width:200,align:'left'  ,editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_003'">Menu Desc(Port)</th>
			<th data-options="field:'parentKey',width:120 ,align:'center',editor:{type:'validatebox',options:{required:true}},data_item:'GRD_004'">Uppr Menu ID</th>
			<th data-options="field:'menuUrl'  ,width:250,align:'left'  ,editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_005'">Menu URL</th>
			<th data-options="field:'menuLevel',width:60 ,align:'center',editor:{type:'numberbox',options:{required:true}},   sortable:true,data_item:'GRD_006'">Menu Lv</th>
			<th data-options="field:'menuSeq'  ,width:60 ,align:'center',editor:{type:'numberbox',options:{required:true}},   sortable:true,data_item:'GRD_007'">Menu Seq</th>
			<th data-options="field:'menuDir'  ,width:100,align:'center',editor:'text',editor:{type:'popupbox',options:{editable:true,onOpen:doOpenPopup}},data_item:'GRD_008'">Menu Type</th>
			<th data-options="field:'mobileType'  ,width:100,align:'center',editor:'text',editor:consts.combo.mobileType.editor(),formatter:consts.combo.mobileType.formatter(),data_item:'GRD_009'">Mobile Type</th>
			<th data-options="field:'iconCls'  ,width:60 ,align:'center',editor:'text',data_item:'GRD_010'">Icon Cls</th>
			<th data-options="field:'sepaText' ,width:60 ,align:'center',editor:'text',data_item:'GRD_011'">Sepa</th>
			<th data-options="field:'procType' ,width:80 ,align:'center',editor:consts.combo.procType.editor(),formatter:consts.combo.procType.formatter(),data_item:'GRD_012'">Prog Type</th>
			<th data-options="field:'childYn'  ,width:60 ,align:'center',editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.yesno,data_item:'GRD_013'" formatter="formatCheck">Child Yn</th>
			<th data-options="field:'actionYn' ,width:60 ,align:'center',editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.yesno,data_item:'GRD_014'" formatter="formatCheck">Page Yn</th>
			<th data-options="field:'useFlag' ,width:60 ,align:'center',editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.enable,data_item:'GRD_015'" formatter="formatCheck">Use Yn</th>
			<th data-options="field:'enableYn' ,width:60 ,align:'center',editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.enable,data_item:'GRD_015'" formatter="formatCheck">Enable Yn</th>
			<th data-options="field:'regiId',data_item:'GRD_016'"  >Regi ID</th>
			<th data-options="field:'regiDate',data_item:'GRD_017'">Regi Date</th>
			<th data-options="field:'chngId',data_item:'GRD_018'"  >Chng ID</th>
			<th data-options="field:'chngDate',data_item:'GRD_019'">Chng Date</th>
		</tr>
	</thead>
</table>

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
								<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}">Search</a>
								<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton btn-clear" id="dreload-button" data-item="BTN_006">Clear</a>
	                        </div>
                        </div>
            		</td>
            	</tr>
            	
	            <tr>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_004"><span>Root Menu</span></th>
					<td class="d">
						<input class="easyui-textbox" name="parentType" id="parentType" data-options="width:100" />
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_001"><span>Menu Desc</span></th>
					<td class="d">
						<input class="easyui-textbox" name="menuDesc" id="menuDesc" data-options="width:100" />
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_002"><span>Menu URL</span></th>
					<td class="d">
						<input class="easyui-textbox" name="menuUrl" id="menuUrl" data-options="width:150" />
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_003"><span>Uppr Menu ID</span></th>
					<td class="d">
						<input class="easyui-textbox" name="parentKey" id="parentKey" data-options="width:150" />
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
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}" >Add</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}" >Del</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_004" data-options="disabled:${UPD}" >Save</a>
						    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_005">
						    	Excel Download&nbsp;
						    	<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/excel_download.png" />
						    </a>
						</div>
					</td>
	            </tr>
	        </table>
	        <!--  <div class="div-line"></div> -->
		</fieldset>
	</form>

	<!-- 메뉴타입 팝업 -->
	<div id="search-menu-dialog" class="wui-dialog"	style="border-top-width: 1px;display:none">
		<table id="search-menu-grid">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true,halign:'center',align:'center'"></th>
					<th	data-options="field:'menuType', halign:'center', align:'center',width:80,data_item:'GRD_020'">Code</th>
					<th	data-options="field:'menuTypeName', halign:'center', align:'center',width:100,data_item:'GRD_021'">Menu Type</th>
				</tr>
			</thead>
		</table>

		<!-- fieldset 구분 변경  20160928 박소현 -->
		<div id="search-menu-toolbar" class="wui-toolbar">
			<form id="search-menu-form">
				<input type="hidden" name="menuType" id="menuType" value="" />
			</form>
		</div>
		<input type="hidden" id="hdfIndex" value="-1" />
		<input type="hidden" id="hdfChk" value="" />
	</div>

</div>



<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="easyui-dialog" >
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
