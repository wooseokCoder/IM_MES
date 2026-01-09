<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)program.jsp 1.0 2014/08/18                                         --%>
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
<%-- 화면관리 화면이다.                                                       		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/18                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/program.js" />"></script>
<script type="text/javascript">
	 doInit({
		sysId: '${sysId}',
		title: '${progName}',
		pageSize: '${sessionScope.rows}'
	});
</script>
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
			<th data-options="field:'progId'    ,width:250,editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_001'">Prog ID</th>
			<th data-options="field:'progName'  ,width:200,editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_002'">Prog Menu</th>
			<th data-options="field:'tranA'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_003'" formatter="formatCheck">BAS</th>
			<th data-options="field:'tranC'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_004'" formatter="formatCheck">INS</th>
			<th data-options="field:'tranR'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_005'" formatter="formatCheck">RET</th>
			<th data-options="field:'tranU'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_006'" formatter="formatCheck">UPD</th>
			<th data-options="field:'tranD'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_007'" formatter="formatCheck">DEL</th>
			<th data-options="field:'tranP'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_008'" formatter="formatCheck">AUP</th>
			<th data-options="field:'tranS'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_009'" formatter="formatCheck">AUS</th>
			<th data-options="field:'tran1'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_010'" formatter="formatCheck">AU1</th>
			<th data-options="field:'tran2'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_011'" formatter="formatCheck">AU2</th>
			<th data-options="field:'tran3'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_012'" formatter="formatCheck">AU3</th>
			<th data-options="field:'tran4'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_013'" formatter="formatCheck">AU4</th>
			<th data-options="field:'tran5'     ,width:60,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_014'" formatter="formatCheck">AU5</th>
			<th data-options="field:'progType'  ,width:100,align:'center',editor:'text',data_item:'GRD_015'">Type</th>
			<th data-options="field:'sysLoc'    ,width:60,editor:'text',data_item:'GRD_016'">Loc</th>
			<th data-options="field:'pattern'  ,width:100,align:'center',editor:consts.combo.Pattern.editor(),data_item:'GRD_015'">Pattern</th>
			<th data-options="field:'regiId',data_item:'GRD_017'"    >Regi ID</th>
			<th data-options="field:'regiDate',data_item:'GRD_018'"  >Regi Date</th>
			<th data-options="field:'chngId',data_item:'GRD_019'"    >Chng ID</th>
			<th data-options="field:'chngDate',data_item:'GRD_020'"  >Chng Date</th>
		</tr>
	</thead>
</table>
<div id="search-toolbar" class="wui-toolbar">
<!-- topnav2 영역 -->
<div class="topnav_sty" style="background-color: #f0f0f0; border-radius: 5px; padding: 5px 10px; margin-bottom: 10px;">
	<div style="display: flex; justify-content: space-between; align-items: center;">
		<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
		<div>
			<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001" data-options="disabled:${RET}" >Search</a>
			<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton btn-clear" id="dreload-button"  data-item="BTN_006">Clear</a>
		</div>
	</div>
</div>

	<form id="search-form">
	<fieldset class="div-line-new" >
		<table  cellpadding="5" cellspacing="2" class="search-table  tableSearch-c">
			<tr>
				<th class="h table-Search-h" data-item="LAB_001"><span>Prog ID </span></th>
				<td class="d"><input class="easyui-textbox"   name="progId" id="progId" data-options="width:100" /></td>
				<th class="h" data-item="LAB_002"><span>Prog Name </span></th>
				<td class="d"><input class="easyui-textbox"   name="progName" id="progName" data-options="width:150" /></td>
			</tr>
		</table>
	</fieldset>
	 <fieldset class="div-line-new-sub">
	        <table  cellpadding="5" cellspacing="2" class="search-table  tableEtc-c">
	            <tr>
					<td class="b">
				    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">Add</a>
				    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}">Del</a>
				    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"   data-item="BTN_004" data-options="disabled:${UPD}" >Save</a>
				    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button"  data-item="BTN_005">Excel Download <img src="<%=request.getContextPath() %>/resources/images/excel_download.png" style="width: 16px; height: 16px; margin-left: 5px;"></a>
					</td>
	            </tr>
	        </table>
	  </fieldset>
	</form>
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
