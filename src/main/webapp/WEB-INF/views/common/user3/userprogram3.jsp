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
<%-- 사용자화면관리 화면이다.                                                  --%>
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
<script type="text/javascript" src="<c:url value="/resources/js/common/user3/userprogram3.js" />"></script>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
<!-- [LAYOUT1] start -->
<div class="easyui-layout" data-options="fit:true">
    
    <!-- [NORTH1] start -->
    <div data-options="region:'north',border:false,height:250">
    
		    	<!-- 사용자 목록 -->
				<table id="user-grid">
					<thead>
						<tr>
							<th data-options="field:'userId',   width:100, sortable:true" data-item="GRD_001">사용자ID</th>
							<th data-options="field:'userName', width:100, sortable:true" data-item="GRD_002">사용자명</th>
							<th data-options="field:'regiId',   width: 80" data-item="GRD_003">등록자ID</th>
							<th data-options="field:'regiDate', width:130" data-item="GRD_004">등록일시</th>
							<th data-options="field:'chngId',   width: 80" data-item="GRD_005">수정자ID</th>
							<th data-options="field:'chngDate', width:130" data-item="GRD_006">수정일시</th>
						</tr>
					</thead>
				</table>
				<div id="user-toolbar" class="wui-toolbar">
					<form id="user-form">
						<fieldset class="div-line-new" style="margin-bottom:0px" >
					        <table  cellpadding="5" cellspacing="2" class="search-table tableSearch-c">
					            <tr>
									<th class="h table-Search-h"><span data-item="LAB_001">사용자ID </span></th>
									<td class="d"><input class="easyui-textbox"   name="userId" id="userId" data-options="width:100" /></td> 
									<th class="h"><span data-item="LAB_002">사용자명 </span></th>
									<td class="d"><input class="easyui-textbox"   name="userName" id="userName" data-options="width:150" /></td>
									<td class="b">
										<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="user-button" data-item="BTN_001">검색</a>
									</td> 
					            </tr>
					        </table>
					    </fieldset>
					    <fieldset class="div-line-new-sub" style="padding:0;"></fieldset>
					</form>
				</div>
    
    <!-- [NORTH1] end -->
	</div>

    <!-- [CENTER1] start -->
    <div data-options="region:'center',border:false">

		<table id="search-grid">
			<thead>
				<tr>
					<th data-options="field:'userId',   width:100, sortable:true" data-item="GRD_007">사용자ID</th>
					<th data-options="field:'userName', width:100, sortable:true" data-item="GRD_008">사용자명</th>
					<th data-options="field:'progId2', width:150, sortable:true" data-item="GRD_009">화면ID</th>
					<th data-options="field:'progId',   width:200, sortable:true, editor:consts.combo.progId.editor(),formatter:consts.combo.progId.formatter()" data-item="GRD_010">화면명</th>
					<th data-options="field:'tranA',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_011">기본</th>
					<th data-options="field:'tranC',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_012">등록</th>
					<th data-options="field:'tranR',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_013">조회</th>
					<th data-options="field:'tranU',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_014">수정</th>
					<th data-options="field:'tranD',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_015">삭제</th>
					<th data-options="field:'tranP',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_016">권한P</th>
					<th data-options="field:'tranS',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_017">권한S</th>
					<th data-options="field:'tran1',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_018">권한1</th>
					<th data-options="field:'tran2',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_019">권한2</th>
					<th data-options="field:'tran3',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_020">권한3</th>
					<th data-options="field:'tran4',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_021">권한4</th>
					<th data-options="field:'tran5',    width:45,align:'center',editor:{type:'checkbox',options:{on:'1',off:'0'}},formatter:jformat.tran" data-item="GRD_022">권한5</th>
					<th data-options="field:'regiId',   width: 80" data-item="GRD_023">등록자ID</th>
					<th data-options="field:'regiDate', width:130" data-item="GRD_024">등록일시</th>
					<th data-options="field:'chngId',   width: 80" data-item="GRD_025">수정자ID</th>
					<th data-options="field:'chngDate', width:130" data-item="GRD_026">수정일시</th>
				</tr>
			</thead>
		</table>
		
		<div id="search-toolbar" class="wui-toolbar tableEtc-c div-line-new-sub" style="padding-top:10px;">
		    <a href="javascript:void(0)" class="easyui-linkbutton c8" id="reload-button" data-item="BTN_002">초기화</a>
		    <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" id="search-button">검색</a> -->
		    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_003">추가</a>
		    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_004">삭제</a>
		    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_005">저장</a>
			<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel"  id="excel-button" data-item="BTN_006">엑셀</a>
			<form id="search-form">
				<input type="hidden" name="userId" id="s_userId"  />
				<input type="hidden" name="progId" id="s_progId" />
			</form>
			
		</div>

    <!-- [CENTER1] end -->
	</div>

<!-- [LAYOUT1] end -->
</div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
