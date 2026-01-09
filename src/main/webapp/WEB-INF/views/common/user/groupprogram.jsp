<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)groupprogram.jsp 1.0 2014/08/19                                    --%>
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
<%-- 그룹별화면관리 화면이다.                                                  		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/19                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/include/system.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/common/user/groupprogram.js" />"></script>
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

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
        <fieldset class="Remake-div-line-new wd-100">
            <table cellpadding="7" class="search-table tableSearch-c">
            	<colgroup>
	           		<col width="7%" style="min-width: 127px;" />
	           		<col width="13%" style="min-width: 165px;" />
	           		<col width="*" />
            	</colgroup>
            	<tr class="topnav_sty">
            		<td colspan="3">
            			<div>
            				<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
            				<div>
								<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="">Search</a>
							    <a href="javascript:void(0)" style="width: 80px;" id="clear-button" class="easyui-linkbutton btn-clear" data-item="BTN_002" data-options="">Clear</a>
							</div>
            			</div>
            		</td>
            	</tr>

	            <tr>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_001"><span>Group Name </span></th>
					<td class="d">
						<select class="easyui-combobox" name="groupId" ID="groupId" data-options="width:150">
							<option value="">ALL</option>
							<c:forEach var="selectGroupList" items="${selectGroupList}">
								<option value="${selectGroupList.GROUP_ID}">${selectGroupList.GROUP_NAME}</option>
							</c:forEach>
						</select>
					</td>
					<td></td>
	            </tr>
	        </table>
	    </fieldset>
	   <fieldset class="div-line-new-sub grd-div-btn">
            <table cellpadding="7" class="search-table tableEtc-c wd-100">
                <tr>
                    <td class="h">
                    	<div class="dis_flex_gap4">
						    <!-- <a href="javascript:void(0)" class="easyui-linkbutton cgray" iconCls="icon-reload" id="reload-button">초기화</a> -->
						    <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" id="search-button">검색</a> -->
						    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}" >Add</a>
						    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}" >Del</a>
						    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"   data-item="BTN_004" data-options="disabled:${UPD}" >Save</a>
						    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button"  data-item="BTN_005">Excel Download <img src="<%=request.getContextPath() %>/resources/images/excel_download.png" style="width: 16px; height: 16px; margin-left: 5px;"></a>
						</div>
					</td>
	            </tr>
	        </table>

		</fieldset>
		<!-- <input type="hidden" name="groupId" id="s_groupId"/> -->
		<!-- <input type="hidden" name="progId"  id="s_progId" /> -->
	</form>
</div>


		<table id="search-grid">
			<thead>
				<tr>
					<th data-options="field:'groupId',  width:100, sortable:true,data_item:'GRD_001'">Group ID</th>
					<th data-options="field:'groupName',width:150, sortable:true,data_item:'GRD_002'">Group Name</th>
					<th data-options="field:'progId2', width:150, sortable:true,data_item:'GRD_003'">Prog ID</th>
					<th data-options="field:'progId',   width:200, sortable:true, editor:consts.combo.progId.editor(),formatter:consts.combo.progId.formatter(),data_item:'GRD_004'">Prog Name</th>
					<th data-options="field:'tranA',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_005'" formatter="formatCheck">BAS</th>
					<th data-options="field:'tranC',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_006'" formatter="formatCheck">INS</th>
					<th data-options="field:'tranR',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_007'" formatter="formatCheck">RET</th>
					<th data-options="field:'tranU',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_008'" formatter="formatCheck">UPD</th>
					<th data-options="field:'tranD',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_009'" formatter="formatCheck">DEL</th>
					<th data-options="field:'tranP',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_010'" formatter="formatCheck">AUP</th>
					<th data-options="field:'tranS',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_011'" formatter="formatCheck">AUS</th>
					<th data-options="field:'tran1',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_012'" formatter="formatCheck">AU1</th>
					<th data-options="field:'tran2',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_013'" formatter="formatCheck">AU2</th>
					<th data-options="field:'tran3',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_014'" formatter="formatCheck">AU3</th>
					<th data-options="field:'tran4',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_015'" formatter="formatCheck">AU4</th>
					<th data-options="field:'tran5',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_016'" formatter="formatCheck">AU5</th>
					<th data-options="field:'regiId',   width: 80,data_item:'GRD_017'">Regi ID</th>
					<th data-options="field:'regiDate', width:130,data_item:'GRD_018'">Regi Date</th>
					<th data-options="field:'chngId',   width: 80,data_item:'GRD_019'">Chng ID</th>
					<th data-options="field:'chngDate', width:130,data_item:'GRD_020'">Chng Date</th>
				</tr>
			</thead>
		</table>


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
