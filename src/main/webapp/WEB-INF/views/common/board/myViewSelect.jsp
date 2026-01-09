<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)index.jsp 1.0 2014/07/30                                           --%>
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
<%-- 인덱스 화면이다.                                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/myViewSelect.js?v=0522F" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/datagrid-dnd.js" />"></script>

<style>
	.l-btn-small > .l-btn-left{
		margin-top:0px!important;
	}
	.textbox.combo > input.textbox-text{
		padding-top:4px!important;
		padding-bottom:6px!important;
	}
	.div-line-new {
		background-color:#ffffff;
		height :50px;
		padding:8px 0px 10px 5px;
		font-size: 13px;
		border-radius: 0;
		border: none;
		border-bottom: 1px solid #D6DFE8;
		
	}
	.datagrid-header {
	    height: 40px !important;
    }
	.textbox > input.textbox-text{
		padding-top: 12px!important;
	}
	.div-line-new th {
		width: 85px;
	}
    .tblTitle {
    	padding: 5px 0 7px 10px;
    	font-weight: 500;
    	font-size: 16px;
    	height: 42px;
    }
    .txt {
    	display:none;
    }
    #create-button, #create-button .l-btn-text { width: 80px; height: 26px; margin: 0; line-height: 26px; color: #fff;}
	#cancel-button, #cancel-button .l-btn-text { width: 80px; height: 26px; margin: 0; line-height: 26px;}
	a.cgray { color: #fff; border-color: #9c9c9c; background: #8c8c8c;}
    #Progress_Loading{
		position: absolute;
		top: 50%;
		left: 50%;
		z-index:99;
		transform: translate(-50%, -50%);
	}
	
	.datagrid-row-selected {
	    background: #86baf1d1 !important;
	}
	
	label {
    	margin-bottom: 0 !important;
	}
	
	.dis_flex > div > span, .dis_flex label  {
		color: #696969;
		font-weight: 700 !important;
		font-size: 14px;
		line-height: 22.4px;
	}
	
	.centerImg {
		display: flex;
	    justify-content: center;
	    align-items: center;
	}
	
	.centerImg > a {
		width: 24px;
	    height: 24px;
	    background-color: #747474;
	    display: block;
	    padding: 1px;
	    border-radius: 4px;
	    text-align: center;
	}
	
	.centerImg > a > img {
		width: 12px;
    	object-fit: contain;
	}
	
	.datagrid-header .datagrid-cell span {
		font-size: 14px;
		font-weight: 700;
		line-height: 22.4px;
		color: #696969;
	}
	
	.datagrid-cell {
		font-weight: 400;
		font-size: 14px;
		line-height: 22.4px;
	}

	.datagrid-view {
		border: 1px solid #E1E1E1;
	}
	
	 .popup-bottom-areaTable {
	 	height: 42px;
	 }
</style>

</head>

<body>
	<div id = "Progress_Loading"><!-- 로딩바 -->
	    <br></br>
	    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
	</div>

<!-- [LAYOUT] start -->
    <input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>
    
	<!-- [LAYOUT2] start -->
	<div data-options="region:'north',border:false,width:100%">
		<fieldset class="div-line-new">
		<input type="hidden" name="hdfIndex" id="hdfIndex" value="-1" />
		
		<div class="dis_flex" style="gap: 10px; padding: 3px 12px;">
			<div>
				<span data-item="LAB_050">My View Title</span>
			</div>
			<div class="dis_flex_gap5">
				<div class="comb">
					<select class="easyui-combobox" name="viewList" ID="viewList" data-options="panelHeight:'auto',onChange:doChngViewList">
                       <option value="" data-item="LAB_004"></option>
                       <c:forEach var="item" items="${getMyViewList}">
                       	<option value="${item.VIEW_ID}">${item.VIEW_DESC}</option>
                       </c:forEach>
                   </select>
				</div>
				<div class="txt">
                    <input class="easyui-textbox" name="rViewName" id="rViewName" value="" data-options="width:200"  maxlength="100"/>
               	</div>
			</div>
			<div>
				<span data-item="LAB_051">Seq. # : </span>
			</div>
			<div style="width: 10%">
				<input class="easyui-textbox" name="rViewSeq" id="rViewSeq" value="" data-options="width:50"/>
			</div>
			<div>
				<label>
					<input type="checkbox" name="rViewDefa" id="rViewDefa" value="Y" />&nbsp;&nbsp;Default
				</label>
			</div>
		</div>
		
		<%-- <table>
			<tr>
				<th><span data-item="LAB_050">My View Title</span></th>
                <td class="view" style="width:210px">
                	<div class="comb">
	                    <select class="easyui-combobox" name="viewList" ID="viewList" data-options="width:200, height: 26,panelHeight:'auto',onChange:doChngViewList">
	                        <option value="" data-item="LAB_004"></option>
	                        <c:forEach var="item" items="${getMyViewList}">
	                        	<option value="${item.VIEW_ID}">${item.VIEW_DESC}</option>
	                        </c:forEach>
	                    </select>
                	</div>
                    
                	<div class="txt">
	                    <input class="easyui-textbox" name="rViewName" id="rViewName" value="" data-options="width:200, height: 26"  maxlength="100"/>
                	</div>
                </td>
                <th style="width:50px;text-align:right"><span data-item="LAB_051">Seq. # : </span></th>
                <td>
                    <input class="easyui-textbox" name="rViewSeq" id="rViewSeq" value="" data-options="width:50, height: 26"/>
                </td>
                <th style="padding-left:10px">    
                    <input type="checkbox" name="rViewDefa" id="rViewDefa" value="Y" /> <span>Default</span>
                </td>
                <td>
                	<!-- <a href="javascript:void(0)" class="easyui-linkbutton c4 cgray" id="create-button"  data-item="BTN_011">Create</a>
                	<a href="javascript:doModify()" class="easyui-linkbutton c4" id="modify-button"  data-item="BTN_012">-</a>
                    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="cancel-button" data-item="BTN_013">Cancel</a> -->
                </td>
			</tr>
		</table> --%>
		</fieldset>
	</div>
	
	<div class="easyui-layout" data-options="fit:true" id="search-dealer-layout" style="height:400px;overflow:hidden;position:fixed">
	    <!-- [WEST] start -->
	    <div data-options="region:'west',border:false,width:370" style="height:360px">
	    	<div class="tblTitle dis_flex" style="justify-content: space-between; ">
	    		<div>▣ Available Columns</div>
	    		<div class="dis_flex" style="gap:2px">
	    			<div>
			    		<a href="javascript:void(0)" class="easyui-linkbutton btn_sel brdl-rd-4" style="min-width: 85px;" id="all-select-button" data-item="BTN_014"><span>Select All</span></a>
	    			</div>
	    			<div>
			    		<a href="javascript:void(0)" class="easyui-linkbutton btn_sel brdr-rd-4" style="min-width: 85px;" id="unselect-button"   data-item="BTN_015"><span>Deselect</span></a>
	    			</div>
	    		</div>
	    	</div>

			<table id="search-view-grid" class="easyui-datagrid">
				<thead>
					<tr>
						<th data-options="field:'COL_ID',   width:150, halign:'center', align:'left',sortable:true, styler:cellStyler">Columns</th>
						<th data-options="field:'COL_DESC', width:180, halign:'center', align:'left',sortable:true">Description</th>
						<th data-options="field:'VIEW_SEQ', width:100, halign:'center', align:'center',sortable:true, hidden:true"></th>
						<th data-options="field:'VIEW_TYPE', width:100, halign:'center', align:'center',sortable:true, hidden:true"></th>
					</tr>
				</thead> 
			</table>
			<!-- <div id="search-view-toolbar" class="wui-toolbar"> -->
			<div id="search-view-toolbar" class="" style="height: 0; border: none; padding: 0;">
				<form id="search-view-form">
					<input type="hidden" name="windId"  id="windId"    value="" />
					<input type="hidden" name="viewId"  id="myViewId"  value="" />
					<input type="hidden" name="oper"    id="oper" />
				</form>
			</div>
			<%-- <div id="search-view-toolbar" class="wui-toolbar">
				<form id="search-view-form">
					<fieldset class="div-line-new" style="padding:8px 0px 10px 5px;">
						<input type="hidden" name="hdfIndex" id="hdfIndex" value="-1" />
						<table>
							<td>
								<span id="searchBm">
									<select class="easyui-combobox" name="s_userId" ID="s_userId" data-options="width:150,height:30">
									<option value="">Select.</option>
									<c:forEach var="selectviewList" items="${selectLstaList}">
										<option value="${selectLstaList.USER_ID}">${selectLstaList.USER_NAME}</option>
									</c:forEach>
									</select>								
								</span>
								<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-popup="POP_BTN_002" data-options="width:90">Select</a>
							</td>
						</table>
					</fieldset>
				</form>
			</div> --%>
			
		</div>
	    <!-- [CENTER] start -->
	    <div data-options="region:'center',border:false" style="width:50px;height:360px; display: flex; flex-direction: column; justify-content: center; align-items: center;">
    		<div class="centerImg" style="">
    			<a href="javascript:void(0)" id="to_right_arow" style="">
    				<img class="trs_180" src="<c:url value="/resources/images/icon_new/fa-solid_angle-right.png" />" ></img>
    			</a>
    		</div>
    		<div class="centerImg" style="margin-top: 16px;">
    			<a href="javascript:void(0)" id="to_left_arow" style="">
    				<img src="<c:url value="/resources/images/icon_new/fa-solid_angle-right.png" />" ></img>
    			</a>
   			</div>
   		</div>
	    <%-- <div data-options="region:'east',border:false" style="width:310px;height:420px;">
	    	<div id="adder-toolbar" class="wui-toolbar datagrid-toolbar" >
				<form id="search-form"></form>
				<fieldset class="div-line-new-sub" style="padding-top:8px;">
			        <table cellpadding="5" class="search-table  tableEtc-c" style="width:95%;">
			            <tr>
							<td >
								<a href="javascript:void(0)" class="easyui-linkbutton c6" id="submit-button" style="float:right;" data-popup="POP_BTN_006">Save</a>
							</td>
			            </tr>
			        </table>
				</fieldset>
			</div>
   			<p style="width:100%;height:25px;margin:0;font-weight:600;background-color:#ecf6ff;padding:3px 0px 3px 10px;" data-popup="POP_LAB_007">Selected</p>
   			<div style="border:1px solid #eee;width:100%;height:326px;overflow-y:auto;border-bottom:1px solid #8a8a8a;margin-bottom:9px;">
    			<table id="to_list" style="width:100%;"></table>
   			</div>
    	</div> --%>
    	<div data-options="region:'east',border:false,width:370" style="height:360px">
    		<div class="tblTitle dis_flex">▣ Selected Columns</div>
			<table id="search-view-grid2" class="easyui-datagrid">
				<thead>
					<tr>
						<th data-options="field:'COL_ID',      width:150, halign:'center', align:'left',sortable:true, styler:cellStyler">Columns</th>
						<th data-options="field:'COL_DESC',    width:180, halign:'center', align:'left',sortable:true">Description</th>
						<th data-options="field:'VIEW_SEQ',    width:100, halign:'center', align:'center',sortable:true, hidden:true"></th>
						<th data-options="field:'VIEW_TYPE',   width:100, halign:'center', align:'center',sortable:true, hidden:true"></th>
						<th data-options="field:'EXCE_COL_ID', width:100, halign:'center', align:'center',sortable:true, hidden:true"></th>
					</tr>
				</thead> 
			</table>
		</div>
		<div data-options="region:'south',border:false,width:800" style="height:60px;text-align:center; border-top: 1px solid #E1E1E1;">
           <!-- <div class="popup-bottom-areaBackground" style="margin-bottom:5px;height:1px;"></div> -->
           <table class="popup-bottom-areaTable">
               <tr>
               	<td style="text-align: center;">
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_038">Save</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="delete-button" data-item="BTN_039">Delete</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="close-button" data-item="BTN_010">Close</a>
				</td>
               </tr>
           </table>
       </div>
	</div>

<script type="text/javascript">

$(function() {
	doLangSettingPopTable();
});
</script>
</body>
</html>
