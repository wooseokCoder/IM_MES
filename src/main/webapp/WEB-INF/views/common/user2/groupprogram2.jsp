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
<%-- 그룹별화면관리 화면이다.                                                  --%>
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
<script type="text/javascript" src="<c:url value="/resources/js/common/user2/groupprogram2.js" />"></script>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- [LAYOUT1] start -->
<div class="easyui-layout" data-options="fit:true">
    
    <!-- [NORTH1] start -->
    <div data-options="region:'north',border:false,height:250">
    
		<!-- [LAYOUT2] start -->
		<div class="easyui-layout" data-options="fit:true">
		    
		    <!-- [WEST2] start -->
		    <div data-options="region:'west',border:false" style="width:50%;">
    
		    	<!-- 그룹 목록 -->
				<table id="group-grid">
					<thead>
						<tr>
							<th data-options="field:'groupId',  width:100, data_item:'GRD_001', sortable:true">그룹ID</th>
							<th data-options="field:'groupName',width:150, data_item:'GRD_002', sortable:true">그룹명</th>
							<th data-options="field:'regiId',   width: 80, data_item:'GRD_003'">등록자ID</th>
							<th data-options="field:'regiDate', width:130, data_item:'GRD_004'">등록일시</th>
							<th data-options="field:'chngId',   width: 80, data_item:'GRD_005'">수정자ID</th>
							<th data-options="field:'chngDate', width:130, data_item:'GRD_006'">수정일시</th>
						</tr>
					</thead>
				</table>
				<div id="group-toolbar" class="wui-toolbar">
					<form id="group-form">
					<fieldset class="div-line-new" style="margin-bottom:0px" >
					        <table  cellpadding="5" cellspacing="2" class="search-table   tableSearch-c">
					            <tr>
									<th class="h table-Search-h"><span data-item="LAB_001">그룹ID </span></th>
									<td class="d"><input class="easyui-textbox"   name="groupId" id="groupId" data-options="width:100" /></td> 
									<th class="h"><span data-item="LAB_002">그룹명 </span></th>
									<td class="d"><input class="easyui-textbox"   name="groupName" id="groupName" data-options="width:150" /></td>
									<td class="b">
										<a href="javascript:void(0)" class="easyui-linkbutton cgray"  id="group-button" data-item="BTN_001">검색</a>
									</td> 
					            </tr>
					        </table>
					  </fieldset>
					  <fieldset class="div-line-new-sub" style="padding:0;"></fieldset>
					</form>
				</div>
		    
		    <!-- [WEST2] end -->
			</div>
		
		    <!-- [CENTER2] start -->
		    <div data-options="region:'center',border:false">
		
				<!-- 화면 목록 -->
				<table id="prog-grid">
					<thead>
						<tr>
							<th data-options="field:'progId',   width:200, data_item:'GRD_007', sortable:true">화면ID</th>
							<th data-options="field:'progName', width:150, data_item:'GRD_008', sortable:true">화면명</th>
							<th data-options="field:'regiId',   width: 80, data_item:'GRD_009'">등록자ID</th>
							<th data-options="field:'regiDate', width:130, data_item:'GRD_010'">등록일시</th>
							<th data-options="field:'chngId',   width: 80, data_item:'GRD_011'">수정자ID</th>
							<th data-options="field:'chngDate', width:130, data_item:'GRD_012'">수정일시</th>
						</tr>
					</thead>
				</table>
				<div id="prog-toolbar" class="wui-toolbar">
					<form id="prog-form">
					<fieldset class="div-line-new" style="margin-bottom:0px" >
					        <table  cellpadding="5" cellspacing="2" class="search-table tableSearch-c">
					            <tr>
									<th class="h table-Search-h"><span data-item="LAB_003">화면ID </span></th>
									<td class="d"><input class="easyui-textbox"   name="progId" id="progId" data-options="width:100" /></td> 
									<th class="h"><span data-item="LAB_004">화면명 </span></th>
									<td class="d"><input class="easyui-textbox"   name="progName" id="progName" data-options="width:150" /></td>
									<td class="b">
										<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="prog-button" data-item="BTN_002">검색</a>
									</td> 
					            </tr>
					        </table>
					        </fieldset>
					  	<fieldset class="div-line-new-sub" style="padding:0;"></fieldset>
					</form>
				</div>
		
		    <!-- [CENTER2] end -->
			</div>
		
		<!-- [LAYOUT2] end -->
		</div>
    
    <!-- [NORTH1] end -->
	</div>

    <!-- [CENTER1] start -->
    <div data-options="region:'center',border:false">

		<table id="search-grid">
			<thead>
				<tr>
					<th data-options="field:'groupId',  width:100, data_item:'GRD_013', sortable:true">그룹ID</th>
					<th data-options="field:'groupName',width:150, data_item:'GRD_014', sortable:true">그룹명</th>
					<th data-options="field:'progId',   width:200, data_item:'GRD_015', sortable:true">화면ID</th>
					<th data-options="field:'progName', width:150, data_item:'GRD_016', sortable:true">화면명</th>
					<th data-options="field:'tranA',    width: 45, data_item:'GRD_017', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">기본</th>
					<th data-options="field:'tranC',    width: 45, data_item:'GRD_018', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">등록</th>
					<th data-options="field:'tranR',    width: 45, data_item:'GRD_019', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">조회</th>
					<th data-options="field:'tranU',    width: 45, data_item:'GRD_020', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">수정</th>
					<th data-options="field:'tranD',    width: 45, data_item:'GRD_021', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">삭제</th>
					<th data-options="field:'tranP',    width: 45, data_item:'GRD_022', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">권한P</th>
					<th data-options="field:'tranS',    width: 45, data_item:'GRD_023', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">권한S</th>
					<th data-options="field:'tran1',    width: 45, data_item:'GRD_024', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">권한1</th>
					<th data-options="field:'tran2',    width: 45, data_item:'GRD_025', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">권한2</th>
					<th data-options="field:'tran3',    width: 45, data_item:'GRD_026', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">권한3</th>
					<th data-options="field:'tran4',    width: 45, data_item:'GRD_027', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">권한4</th>
					<th data-options="field:'tran5',    width: 45, data_item:'GRD_028', align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran">권한5</th>
					<th data-options="field:'regiId',   width: 80, data_item:'GRD_029'">등록자ID</th>
					<th data-options="field:'regiDate', width:130, data_item:'GRD_030'">등록일시</th>
					<th data-options="field:'chngId',   width: 80, data_item:'GRD_031'">수정자ID</th>
					<th data-options="field:'chngDate', width:130, data_item:'GRD_032'">수정일시</th>
				</tr>
			</thead>
		</table>
		
		<div id="search-toolbar" class="wui-toolbar  tableEtc-c div-line-new-sub" style="padding-top:10px;">
		    <a href="javascript:void(0)" class="easyui-linkbutton c8"id="reload-button" data-item="BTN_003">초기화</a>
		    <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" id="search-button">검색</a> -->
		    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_004">추가</a>
		    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_005">삭제</a>
		    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_006">저장</a>
		    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" iconCls="icon-excel" data-item="BTN_007">엑셀</a>
			<form id="search-form">
				<input type="hidden" name="groupId" id="s_groupId"/>
				<input type="hidden" name="progId"  id="s_progId" />
			</form>
			
		</div>

    <!-- [CENTER1] end -->
	</div>

<!-- [LAYOUT1] end -->
</div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
