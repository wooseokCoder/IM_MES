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
<%-- Conf. for Mail Send  Y/N 화면이다.                                       --%>
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
<script type="text/javascript" src="<c:url value="/resources/js/common/lstractor/dashboardreg.js?v=0626" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/datagrid-detailview.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/common/user/pdiupdate.js" />"></script>
<script type="text/javascript" src="https://public.tableau.com/javascripts/api/tableau-2.min.js"></script>
<script type="text/javascript">
      doInitPdi({
        domain: '<spring:eval expression="@app['pdi.addr']"/>'
    });
</script>
<style>
#account-layout{min-width:1200px !important;}
/* .datagrid-body {height:60px !important;} */
.search-label-h2 {
    width: 90px;
}
#Progress_Loading{
 position: absolute;
 left: 50%;
 z-index:99;
 transform: translate(-50%, -50%);
}
.textbox-button {background: #c8c8c8;}
.textbox-button .l-btn:hover {background:#1e65bd;}
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
			<input type="hidden" name="bordNo"   id="r_bordNo"   value="${model.bordNo}"  />
            <input type="hidden" name="bordGrup" id="r_bordGrup" value="${model.bordGrup}"/>

	<table id="search-grid">
	    <thead data-options="frozen:true">
		     <tr>
				<th data-options="field:'EXT_CHR01', halign:'center', width:150, align:'left', data_item:'GRD_001', sortable:true, editor:{type:'validatebox',options:{required:true}}">Category</th>
				<th data-options="field:'EXT_CHR02', halign:'center', width:180, align:'left', data_item:'GRD_002', sortable:true, sorter:dateReSort, styler:cellStyler2, editor:{type:'validatebox',options:{required:true}}">Name</th>
				<th data-options="field:'EXT_CHR03', halign:'center', width:380, align:'left', data_item:'GRD_003', sortable:true, sorter:dateReSort, editor:{type:'validatebox'}">Description</th>
			</tr>
		</thead>
		<thead>
			<tr>
				<th data-options="field:'SORT_SEQ',  halign:'center', width:50,  align:'center', data_item:'GRD_004', sortable:true, editor:{type:'validatebox'}" >Seq</th>
				<th data-options="field:'USE_FLAG',  halign:'center', width:50,  align:'center', data_item:'GRD_005', editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.useflag" formatter="formatCheck">Use</th>
				<th data-options="field:'EXT_CHR05', halign:'center', width:600, align:'left',   data_item:'GRD_006', sortable:true, editor:{type:'validatebox'}" >Link</th>
				<th data-options="field:'icon05',    halign:'center', width:50,  align:'center', data_item:'GRD_007', sortable:true, styler:cellStyler2, formatter:formatAttribute2" ></th>
				<th data-options="field:'EXT_TEXT',  halign:'center', width:150, align:'left',   data_item:'GRD_008', sortable:true, styler:cellStyler2" >Image</th>
				<th data-options="field:'CODE_CD',   halign:'center', width:50,  align:'center', data_item:'GRD_009', sortable:true, styler:cellStyler, formatter:formatAttribute" ></th>
				<th data-options="field:'EXT_CHR10', halign:'center', width:450, align:'left',   data_item:'GRD_010', sortable:true, editor:{type:'validatebox'}">Remark</th>
				<th data-options="field:'EXT_CHR04', halign:'center', width:100, align:'center', data_item:'GRD_011', sortable:true" >Date</th>
				<th data-options="field:'CHNG_ID',   halign:'center', width:100, align:'center', data_item:'GRD_012', sortable:true" >Chng Id</th>
				<th data-options="field:'CHNG_DATE', halign:'center', width:120, align:'center', data_item:'GRD_013', sortable:true" >Chng Date</th>
			</tr>
	    </thead>
	</table>
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <fieldset class="div-line4-new Remake-div-line-new" >
            <table cellpadding="5" class="search-table tableSearch-c" >
                <tr>
                	<th class="h table-Search-c"><span data-item="LAB_001">Category</span></th>
                    <td class="d">
                        <select class="easyui-combobox" name="EXT_CHR01" ID="EXT_CHR01" data-options="width:200, height: 26">
                            <option value="" data-item="LAB_002">ALL</option>
                            <c:forEach var ="item" items="${getCategory}">
                                <option value="${item.EXT_CHR01}">${item.EXT_CHR01}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th class="h table-Search-c"><span data-item="LAB_003">Search Index</span></th>
                    <td class="d">
                        <input class="easyui-textbox" name="CODE_DESC" id="CODE_DESC" value="" style="width: 200px; height: 26px;"/>
                    </td>
                    <th class="h table-Search-c search-label-h2"><span data-item="LAB_004">Use Flag</span></th>
                    <td class="d">
                        <select class="easyui-combobox" name="USE_FLAG" ID="USE_FLAG" data-options="width:50, height: 26, panelHeight:'auto'">
                           <option value="" data-item="LAB_005">ALL</option>
                            <option value="Y" data-item="LAB_006">Y</option>
                            <option value="N" data-item="LAB_007">N</option>
                        </select>
                    </td>
                    <td class="b w-a" colspan="2" style="text-align: right;">
                        <a href="javascript:void(0)" style="width: 80px; height: 26px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="">Search</a>
                        <a href="javascript:void(0)" style="width: 80px;  height: 26px;" id="clear-button" class="easyui-linkbutton c12" data-item="BTN_002" data-options="">Clear</a>
                    </td>
                </tr>
            </table>
       </fieldset>
       <fieldset class="div-line-new-sub div-line-new-sub-left">
	        <table cellpadding="5" class="search-table tableEtc-c">
	            <tr>
					<td class="h">
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_003" data-options="disabled:${INS}" >Add</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_004" data-options="disabled:${UPD}" >Save</a>
<!-- 						<a href="javascript:void(0)" style="margin-left: 10px;" class="easyui-linkbutton c4" iconCls="icon-excel" id="excel-button" data-item="BTN_008">Excel Download</a> -->
					</td>
	            </tr>
	        </table>
		</fieldset>
    </form>
</div>
<!-- [LAYOUT] end -->
</div>

<div id="img-dialog" class="wui-dialog" style="border-top-width:1px;">
	<form id="search-create-form">
				<input type="hidden" id="cOper" name="oper" value="I" />
		<fieldset class="div-line-new-sub" style="padding-left: 0px;">
			<div class="popup-table-alignCenter">
				<table class="popup-search-table"> <!--  style="width:100%;" -->
					<tr>
						<td style="width:100%; position: relative;">
							<img id="imgCloseBtn1" style= "width:500px; height:375px"></img>
						</td>
					</tr>
					<tr style="height:5px;">
					</tr>
		            <tr style="border-top-style:inset;border-top-color:#00000;border-top-width:2px;">
						<td class="d popup-table-alignCenter" colspan="2" style="padding-top: 10px;">
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="close-img-button" data-item="BTN_005">Close</a>
						</td>
		            </tr>
		        </table>
			</div>
		</fieldset>
	</form>
</div>

<div id="report-dialog" class="wui-dialog" style="border-top-width:1px;display:none;">
	<div class="easyui-layout"  data-options="fit:true" onload="initViz();" style="overflow-y:scroll;height:600px;">
		<div id="vizContainer" style="width:1400px; height: 750px;"></div> <!-- style="width:100%;" -->
	</div>
</div>

<div id="regist-dialog" class="wui-dialog" style="overflow:scroll;height:850px;border-top-width:1px;display:none">
	<div data-options="region:'center',border:false">
		<div  style="height: 25px;">
	        <table cellpadding="5" class="search-table tableSearch-c">
	        	<thead>
		            <tr>
						<th class="h table-Search-h"><span data-item="LAB_008"> </span></th>
					</tr>
				</thead>
	        </table>
	   </div>
		<div>
			<form id="search-form2" method="post" enctype="multipart/form-data">
				<input type="hidden" id="h_codeCd" name="codeCd" value="" />
				<input type="hidden" id="h_codeGrup" name="codeGrup" value="" />
				<input type="hidden" id="h_atchGrup" name="atchGrup" value="DB" />
				<input type="hidden" id="h_atchNo" name="atchNo" value="" />
				<input type="hidden" id="h_oper" name="oper" value="I" />
		        <table cellpadding="5" class="search-table tableSearch-c" style="margin-left:12px;">
			        <tr>
						<th class="d">
							<span class="textbox"style="width: 100%;">
								<input class="easyui-filebox" name="excelFile" id="s_excelFile" style="width:300px"/>
								<span id="upload-frame"></span>
							</span>
						</td>
				    </tr>
		        </table>
	        </form>
	   </div>
		   <div style="text-align: center; margin-top: 25px;">
		   		<a href="javascript:void(0)" style="margin-right: 5px;" class="easyui-linkbutton c6" id="save-button2" data-item="BTN_006"  >Add</a>
		 		<a href="javascript:void(0)" class="easyui-linkbutton c6" id="cl-btn" data-item="BTN_007" data-options="width:100">Cancel</a>
		   </div>
	</div>
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div id="temp-popup" style="display:none">
	<canvas id="imgTemp" width="500" height="375"></canvas>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
</html>