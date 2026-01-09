<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)userprogram.jsp 1.0 2014/08/19                                     --%>
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
<%-- 사용자화면조회 화면이다.                                                  		--%>
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
<script type="text/javascript" src="<c:url value="/resources/js/common/user/userprogramlist.js" />"></script>
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
		<fieldset class="Remake-div-line-new">
            <table cellpadding="7" class="search-table tableSearch-c wd-100">
            	<colgroup>
            		<col width="10%">
	        		<col width="20%">
	        		<col width="10%">
	        		<col width="15%">
	        		<col width="10%">
	        		<col width="15%">
	        		<col width="10%">
	        		<col width="10%">
            	</colgroup>
            	<!-- topnav2 영역 -->
            	<tr class="topnav_sty">
            		<td colspan="8">
            			<div>
            				<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
            				<div>
								<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton cgray" id="search-button"  data-item="BTN_001" data-options="disabled:${RET}" >Search</a>
								<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton btn-clear" id="dreload-button" data-item="BTN_003">Clear</a>
							</div>
            			</div>
            		</td>
            	</tr>
	            <tr>
					<th class="h table-Search-h" data-item="LAB_001"><span>User Name</span></th>
					<td class="d">
						<select class="easyui-combobox" name="userId" ID="userId" data-options="width:150">
							<option value="">ALL</option>
							<c:forEach var="selectUserList" items="${selectUserList}">
								<option value="${selectUserList.USER_ID}">${selectUserList.USER_ID} - ${selectUserList.USER_NAME}</option>
							</c:forEach>
						</select>
					</td>
					<th class="h table-Search-h" data-item="LAB_001"><span>Prog Name</span></th>
					<td class="d">
						<input class="easyui-textbox" name="progId" id="progId" data-options="width:100" />
						<%-- <select class="easyui-combobox" name="progId" ID="progId" data-options="width:400">
							<option value="">ALL</option>
							<c:forEach var="selectUserProgList" items="${selectUserProgList}">
								<option value="${selectUserProgList.PROG_ID}">${selectUserProgList.PROG_NAME}</option>
							</c:forEach>
						</select> --%>
					</td>
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
						    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_002">Excel Download <img src="<%=request.getContextPath() %>/resources/images/excel_download.png" style="width: 16px; height: 16px; margin-left: 5px;"></a>
	
							<!-- <input type="hidden" name="userId" id="s_userId"  />
							<input type="hidden" name="progId" id="s_progId" /> -->
						</div>
					</td>
	            </tr>
	        </table>

		</fieldset>
	</form>
</div>

		<table id="search-grid">
			<thead>
				<tr>
					<th data-options="field:'userId',   width:100, sortable:true,data_item:'GRD_001'">User ID</th>
					<th data-options="field:'userName', width:100, sortable:true,data_item:'GRD_002'">User Name</th>
					<th data-options="field:'progId2', width:300, sortable:true,data_item:'GRD_003'">Prog ID</th>
					<th data-options="field:'progId',   width:200, sortable:true, editor:consts.combo.progId.editor(),formatter:consts.combo.progId.formatter(),data_item:'GRD_004'">Prog Name</th>
					<th data-options="field:'tranA',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_005'" formatter="formatCheck">BAS</th>
					<th data-options="field:'tranC',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_006'" formatter="formatCheck">INS</th>
					<th data-options="field:'tranR',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_007'" formatter="formatCheck">RET</th>
					<th data-options="field:'tranU',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_008'" formatter="formatCheck">UPD</th>
					<th data-options="field:'tranD',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_009'" formatter="formatCheck">DEL</th>
					<th data-options="field:'tranP',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_010'" formatter="formatCheck">ASP</th>
					<th data-options="field:'tranS',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran,data_item:'GRD_011'" formatter="formatCheck">ASS</th>
					<th data-options="field:'regiId',   width: 80,data_item:'GRD_012'">Regi ID</th>
					<th data-options="field:'regiDate', width:130,data_item:'GRD_013'">Regi Date</th>
					<th data-options="field:'chngId',   width: 80,data_item:'GRD_014'">Chng ID</th>
					<th data-options="field:'chngDate', width:130,data_item:'GRD_015'">Chng Date</th>
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
