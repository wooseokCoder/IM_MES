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
<%-- Sample board management screen.                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/24                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<script type="text/javascript" src="<c:url value="/resources/jquery/columns-ext.js" />"></script>
<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/sample/sampleboard.js?v=251229d" />"></script>

<style>
.menu{border-style:none;}
.menu-line {
   border-left: none; 
   border-right: none; 
}
#menu-button5, #menu-button5 .l-btn-text { width: 100px; height: 32px;}
a[href*="reorderColumns"] .l-btn-text, a[href*="reorderColumns"] .l-btn-text, a[href*="reorderColumns"] .l-btn-text  { text-align: right; padding-left: 25px; padding-right: 25px;} 
a[href*="reorderColumns"], a[href*="reorderColumns"] .l-btn-text { width: 198px; border-radius:0px;}
#myView-create-button .l-btn-text, #myView-modify-button .l-btn-text { width: 198px; border-radius:0px; text-align: right; padding-right: 25px; }
#myView-create-button .l-btn-text:hover, #myView-modify-button .l-btn-text:hover { color: #202020;}
#myView-create-button, #myView-modify-button { width: 198px; border-radius:0px;}
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
				<th data-options="field:'bordNo' ,width:100,halign:'center',align:'center', data_item:'GRD_001'">No</th>
				<th data-options="field:'bordTitle',width:400 ,halign:'center',align:'left',editor:{type:'validatebox', options:{required:true}}, data_item:'GRD_002'">Title</th>
				<th data-options="field:'fileCnt',width:40 ,halign:'center',align:'center',formatter:jformat.filecnt, data_item:'GRD_003'">File</th>
				<th data-options="field:'readCnt'  ,width:80,halign:'center',align:'right', data_item:'GRD_004'">Views</th>
				<th data-options="field:'regiName',width:80 , halign:'center',align:'center', data_item:'GRD_005'">Registrant</th>
				<th data-options="field:'regiDate'  ,width:130 , halign:'center',align:'center', data_item:'GRD_006'">Regi Date</th>
				<th data-options="field:'chngName'  ,width:80, halign:'center',align:'center', data_item:'GRD_007'">Modifier</th>
				<th data-options="field:'chngDate'  ,width:130 , halign:'center',align:'center', data_item:'GRD_008'">Chng Date</th>
			</tr>
		</thead>
	</table>

	<div id="search-toolbar" class="wui-toolbar">

		<form id="search-form">
		<fieldset class="div-line-new">
			<input type="hidden" name="sysId"    id="s_sysId"    value="${model.sysId}"   />
			<input type="hidden" name="bordGrup" id="s_bordGrup" value="${bordGrup}"/>
			<input type="hidden" name="windId"   id="windId"     value="${progId}"/>
			<input type="hidden" name="myViewId" id="myViewId"   value="${myViewId}"/>
			<input type="hidden" name="vOper"   id="vOper"      value=""/>
			<table cellpadding="5" class="search-table tableSearch-c wd-100" >
				<colgroup>
					<col width="7%" style="min-width: 120px;" />
					<col width="18%" style="min-width: 165px;" />
					<col width="7%" style="min-width: 120px;" />
					<col width="13%" style="min-width: 165px;" />
					<col width="7%" style="min-width: 120px;" />
					<col width="13%" style="min-width: 165px;" />
					<col width="*" style="min-width: 120px;" />
				</colgroup>

				<tr class="topnav_sty">
					<td colspan="7" >
						<div style="display:flex; justify-content: space-between; align-items: center;">
							<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
							<div>
								<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001"><spring:message code="sampleboard.search"/><!-- Search --></a>
								<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton btn-clear" id="dreload-button" data-item="BTN_002">Clear</a>
							</div>
						</div>
					</td>
				</tr>

				<tr>
					<th class="h table-Search-h">
						<span data-item="LAB_001">Date (Datebox)</span>
					</th>
					<td class="d">
						<div style="display:flex; align-items: center;">
							<input class="easyui-datebox datebox-f combo-f textbox-f date-L" value="" style="" textboxname="SEARCH_DATE_FR" comboname="SEARCH_DATE_FR" id="SEARCH_DATE_FR" name="SEARCH_DATE_FR"/>
							<input class="easyui-datebox datebox-f combo-f textbox-f date-R" value="" style="" textboxname="SEARCH_DATE_TO" comboname="SEARCH_DATE_TO" id="SEARCH_DATE_TO" name="SEARCH_DATE_TO"/>
						</div>
					</td>
					<th class="h table-Search-h">
						<span data-item="LAB_002">Combobox</span>
					</th>
					<td class="d">
						<select class="easyui-combobox" name="SEARCH_COMBO" id="SEARCH_COMBO" data-options="panelHeight:'auto'">
							<option value="" data-item="LAB_003">ALL</option>
							<option value="1">Option1</option>
							<option value="2">Option2</option>
							<option value="3">Option3</option>
						</select>
					</td>
					<th class="h table-Search-h">
						<span data-item="LAB_004">Textbox</span>
					</th>
					<td class="d">
						<input class="easyui-textbox" name="SEARCH_TEXT" id="SEARCH_TEXT" value="" style="width:200px"/>
					</td>
					<td class="b"></td>
				</tr>

				<tr>
					<th class="h table-Search-h">
						<span data-item="LAB_005">Checkbox</span>
					</th>
					<td class="chk-label">
						<input type="hidden" value="" id="CheckKey" name="CheckKey"/>
						<div class="dis_flex" style="gap: 10px;">
							<div>
								<input onclick="fnChangeCheck(this)" style="display: inline-block; width: 15px;" type="checkbox" name="checkItem" id="ALL_C" value="" checked="checked"/>
								<label for="ALL_C" data-item="LAB_006">ALL</label>
							</div>
							<div>
								<input onclick="fnChangeCheck(this)" style="display: inline-block; width: 15px;" type="checkbox" name="checkItem" id="CHK1" value="1"/>
								<label for="CHK1" data-item="LAB_007">Check1</label>
							</div>
							<div>
								<input onclick="fnChangeCheck(this)" style="display: inline-block; width: 15px;" type="checkbox" name="checkItem" id="CHK2" value="2"/>
								<label for="CHK2" data-item="LAB_008">Check2</label>
							</div>
							<div>
								<input onclick="fnChangeCheck(this)" style="display: inline-block; width: 15px;" type="checkbox" name="checkItem" id="CHK3" value="3"/>
								<label for="CHK3" data-item="LAB_009">Check3</label>
							</div>
						</div>
					</td>
					<th class="h table-Search-h">
						<span data-item="LAB_010">Combogrid</span>
					</th>
					<td class="d">
						<input id="optionStat" name="optionStat" class="easyui-combogrid">
						<input type="hidden" name="h_optionStat" id="h_optionStat" value=""/>
						<input type="hidden" id="optionStatList" value='[{"value":"OPT1","text":"Option1"},{"value":"OPT2","text":"Option2"},{"value":"OPT3","text":"Option3"}]'>
					</td>
					<th class="h table-Search-h">
						<span data-item="LAB_011">Multi Dialog</span>
					</th>
					<td class="d">
						<input class="easyui-textbox textbox-list" style="min-width: 150px;" name="SEARCH_MULTI" id="SEARCH_MULTI" value="" />
						<input type="hidden" name="h_multiList" id="h_multiList" value=""/>
						<a href="javascript:void(0)" style="" id="multi-list-button" class="easyui-linkbutton c12 searchListA">
							<img id="multilist" style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/picklist_type.png" />
						</a>
					</td>
					<td class="b"></td>
				</tr>
			</table>

		</fieldset>
	</form>
	<fieldset class="div-line-new-sub">
		<table  cellpadding="5" class="search-table tableEtc-c" style="width: 100%">
			<tr >
				<td class="h" style="width:500px; min-width: 200px;">
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_013">Add</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_004">Save</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_005"><spring:message code="sampleboard.delete"/><!-- Delete --></a>
					<!-- JXLS 템플릿 방식 엑셀 다운로드 (엑셀 양식 필요)-->
					<a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_006">
						Excel Download 
						<img src="<%=request.getContextPath() %>/resources/images/excel_download.png" style="width: 16px; height: 16px; margin-left: 5px;"></a>
					<!-- POI 방식 엑셀 다운로드 (java에서 자체 생성성)-->
					<a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button2" data-item="BTN_006_2">
						Excel Download2 
						<img src="<%=request.getContextPath() %>/resources/images/excel_download.png" style="width: 16px; height: 16px; margin-left: 5px;"></a>
					<a href="javascript:void(0)" class="easyui-linkbutton c4" id="upload-excel-button" style="width: auto;" data-item="BTN_007">
						Excel Download for Upload&nbsp;
						<img src="<%=request.getContextPath() %>/resources/images/excel_download.png" style="width: 16px; height: 16px; margin-left: 5px;"></a>
					</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-upload-button" data-options="width:120" data-item="BTN_009">File Upload (BM)</a>
				</td>
				<td style="width: 132px; text-align: right;">
					<a href="javascript:void(0)" class="easyui-menubutton btn-grey" data-item="BTN_008" data-options="menu:'#mmm5'" id="menu-button5">
						<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/add.png" />
						&nbsp;My View
					</a>
					<div id="mmm5" style="width:200px; left:1638px; padding: 0px; padding-left:2px;">
					</div>
				</td>
			</tr>
		</table>
	</fieldset>
	<!-- </div> -->
</div>



<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</div>

<!-- 멀티검색 팝업창 -->
<div id="multi-serach-pop" style="display: none; position: absolute; background: #ffffff; border: 1px solid #808080; padding: 5px;">
	<div>
		<textarea rows="9" style="width:100%; border-color: #e2dddd; padding: 5px;" name="s_multiNo" id="s_multiNo"></textarea>
	</div>
	<div class="dis_flex_gap4">
		<a href="javascript:void(0)" class="easyui-linkbutton c6" id="multiList-button1" data-item="BTN_016" data-options="width:50" >Save</a>
        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="multiList-button2" data-item="BTN_017" data-options="width:50">Del</a>
        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="multiList-button3" data-options="width:50" data-item="BTN_018">Close</a>
	</div>
</div>

<!-- My View 팝업 -->
<div id="myView-popup" class="easyui-dialog" data-options="
	width: 820,
	height: 624,
	closed: true,
	modal: true,
	title:'My View Setting',
	iconCls:''">
	<iframe id="myView-iframe" src="" style="width:100%;height:100%;border:0;"></iframe>
</div>

<!-- 파일업로드 팝업 -->
<div id="regist-upload-dialog" class="wui-dialog" style="overflow:scroll;height:850px;border-top-width:1px;display:none">
	<div data-options="region:'center',border:false" style="height: 258px;">
		<div class="div-line-new file-div-line">
			<form id="search-upload-form" method="post" enctype="multipart/form-data">	
		        <table cellpadding="5" class="search-table tableSearch-c">
		            <tr>
						<th class="h table-Search-h tal"><span data-item="LAB_012">File Name</span></th>
						<td class="d">
							<input type="file" name="excelFile" id="s_excelFile" size="40"/>
						</td>
		            </tr>
		        </table>
	        </form>
	   </div>
	  
	   <div class="file-btn-div">
		   	<div>
		   		<span class="totalCount">Total : <span id="totalCnt">0</span></span>
		   		<span class="errorCount">Error : <span id="errorCnt">0</span></span>
		   	</div>
	   		<div class="dis_flex_gap10">
		 		<a href="javascript:void(0)" class="easyui-linkbutton c6" id="cl-upload-btn" data-options="width:100" data-item="BTN_010">Close</a>
		 		<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-upload-button" data-item="BTN_011">Save</a>
				<a href="javascript:void(0)" class="easyui-linkbutton c6" id="upload-button" data-options="width:100" data-item="BTN_012">Upload</a>
			</div>
	   </div>
	   <table id="search-upload-grid">
				<thead>
					<tr>
						<th data-options="field:'bordNo',   halign:'center', width: 100, align:'center', sortable:true, data_item:'GRD_009'">No</th>
						<th data-options="field:'bordTitle', halign:'center', width: 300, align:'left', sortable:true, data_item:'GRD_010'">Title</th>
						<th data-options="field:'readCnt',   halign:'center', width: 80, align:'right', sortable:true, data_item:'GRD_011'">Views</th>
						<th data-options="field:'regiName',  halign:'center', width: 100, align:'center', sortable:true, data_item:'GRD_012'">Registrant</th>
						<th data-options="field:'regiDate', halign:'center', width: 130, align:'center', sortable:true, data_item:'GRD_013'">Regi Date</th>
						<th data-options="field:'chngName', halign:'center', width: 100, align:'center', sortable:true, data_item:'GRD_014'">Modifier</th>
						<th data-options="field:'chngDate', halign:'center', width: 130, align:'center', sortable:true, data_item:'GRD_015'">Chng Date</th>
						<th data-options="field:'CHECK_MSG', halign:'center', width: 200, align:'center', sortable:true, data_item:'GRD_016'">Check Message</th>
					</tr>
				</thead>
			</table>
	</div>
</div>

<!-- 엑셀 진행상태 -->
<div id="progress-popup" class="easyui-dialog">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- 업로드 진행상태 -->
<div id="progress-popup2" class="easyui-dialog">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

</html>

