<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)projectmanagement.jsp 1.0 2014/08/05								--%>
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
<%-- 프로젝트관리 화면이다.                                                      		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2017/08/07                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/business/item/projectmanagement.js" />"></script>

<style>
	#account-layout{min-width:1200px !important;}
	/* 오른쪽 테이블 그리드 강제 넓이 고정 */
	.sub-table-height26 > .easyui-fluid > .panel-header{height:26px;line-height:26px;padding:0;}
	.sub-table-height26 > .easyui-fluid > .panel-header > .panel-title{height:26px !important;line-height:26px !important;padding-left:25px;}
	.sub-table-height26 .select-table th{text-align:center;}

	.adjust-table1 .textbox{width:100% !important;height:25px !important;}

	@media screen and (max-width:1400px){

		.pagination-info{display:none;}
	}

	.r_date1 .datebox, .r_date2 .datebox{
		width: 150px !important;
	}

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
	<div data-options="region:'north',border:false">
		<div id="search-toolbar" class="wui-toolbar">
			<form id="search-form">
				<fieldset class="div-line-new" >
			        <table cellpadding="5" class="search-table tableSearch-c" >
			            <tr><th class="h table-Search-h" data-item="LAB_001"><span>Project Year</span></th>
							<td class="d">
								<input class="easyui-combobox" name="searchPjtYear" id="searchPjtYear" codeGrup="PJT_YEAR" data-options="mode:'remote',editable:false,loader:jcombo.loader,width:90"/>
							</td>

							<th class="h" data-item="LAB_002"><span>Project No</span></th>
							<td class="d">
								<input class="easyui-textbox" name="searchPjtNo" id="searchPjtNo" style="width:120px"/>
								<input type="hidden" name="searchModel" id="searchModel" />
			            	</td>
							<th class="h" data-item="LAB_003"><span>모델명/규격</span></th>
			            	<td class="d">
			            		<input class="easyui-textbox" name="searchmodelName" id="searchmodelName"  data-options="width:90"/>
								<input class="easyui-textbox" name="searchmodelSpec" id="searchmodelSpec" data-options="width:90"/>
								<a onclick="javascript:void(0)"><img id="search-model-button" style="cursor: pointer;" src="<c:url value="/resources/images/searchCust.png"/>"/></a>
			            	</td>
							<th class="h" data-item="LAB_004"><span>구분</span></th>
			            	<td class="d">
			            		<input class="easyui-combobox" name="searchPjtGb" id="searchPjtGb" codeGrup="PJT_GB" data-options="mode:'remote',editable:false,loader:jcombo.loader,width:90"/>
			            	</td>
			            	<th class="h" data-item="LAB_005"><span>담당자</span></th>
			            	<td class="d">
				            	<input class="easyui-textbox"  name="searchStafName" id="searchStafName" style="width:100px"/>
			            	</td>
			            	<td class="b"><a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001" data-options="disabled:${RET}" >검색</a></td>
						</tr>
					</table>
				</fieldset>
			   	<fieldset class="div-line-new-sub">
			        <table cellpadding="5" class="search-table tableEtc-c" style="width:100%;">
			            <tr>
				            <td class="h" style="width:405px;">
						        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">추가</a>
						        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003"  data-options="disabled:${DEL}">삭제</a>
						        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_004" data-options="disabled:${UPD}">저장</a>
								<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel" id="excel-button" data-item="BTN_005">엑셀</a>
								<a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_006">초기화</a>
							</td>
			            </tr>
			        </table>
				</fieldset>
			</form>
		</div>
    </div>

    <!-- [CENTER] start -->
    <div data-options="region:'center',border:false">
		<table id="search-grid">
			<thead>
				<tr>
					<th data-options="field:'pjtYear', halign:'center', width:80, data_item:'GRD_001', align:'center', sortable:true">Project Year</th>
					<th data-options="field:'pjtNo', halign:'center', width:120, data_item:'GRD_002', align:'left', sortable:true ">Project No</th>
					<th data-options="field:'pjtName', halign:'center', width:120, data_item:'GRD_003', align:'left', sortable:true ">Project Name</th>
					<th data-options="field:'modelNo', halign:'center', width:100, data_item:'GRD_004', align:'left', sortable:true ">Model No</th>
					<th data-options="field:'stafName', halign:'center', width:80, data_item:'GRD_005', align:'center', sortable:true ">담당자</th>
					<th data-options="field:'startDate', halign:'center', width:100, data_item:'GRD_006', align:'center', sortable:true ">시작일</th>
					<th data-options="field:'endDate', halign:'center', width:100, data_item:'GRD_007', align:'center', sortable:true ">종료일</th>
					<th data-options="field:'curtStatName', halign:'center', width:100, data_item:'GRD_008', align:'center', sortable:true ">진행상태</th>
					<th data-options="field:'curtStat', halign:'center', width:100, data_item:'GRD_009', align:'center', sortable:true,hidden:true ">진행상태</th>
					<th data-options="field:'pjtRemk',halign:'center', width:220, data_item:'GRD_010', align:'left' , sortable:true ">비고</th>
				</tr>
			</thead>
		</table>
	</div>

	<!-- [EAST] start -->
    <div data-options="region:'east',border:false" style="padding-top:24px; padding-bottom:40px;width:580px;">
		<div class="accountInfo-header" style="border-bottom:1px solid #8a8a8a;margin-left:10px;width:570px;"><span data-item="LAB_006">BOM정보</span></div>

		<!-- 2016/12/05 김영진 -- title 한영변환 재검토 -->
		<div class="easyui-panel" style="overflow:auto;" data-options="fit:true" >
		    <form id="regist-form" method="post">
		    	<fieldset style="border-right:1px solid #dadada;">
		    		<input type="hidden" name="sysId"       id="r_sysId" />
		    		<input type="hidden" name="oper"        id="r_oper"  />
		    		<input type="hidden" name="hdfCustCode" id="r_hdfCustCode" />

			        <table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
						<tr class="first-tr" style="display:none;">
						</tr>
			            <tr style="border-collapse:collapse; border:none;">
							<th><span data-item="LAB_007" >Project Year</span></th>
							<td class="textfix" style="border-right:1px solid #ccc;">
								<input class="easyui-combobox" name="pjtYear" id="r_pjtYear" codeGrup="PJT_YEAR" data-options="mode:'remote',editable:false,loader:jcombo.loader"/></span>
							</td>
			          		<th><span data-item="LAB_008">진행상태</span></th>
							<td style="border-right:1px solid #ccc;">
								<input class="easyui-combobox" name="curtStat" id="r_curtStat" codeGrup="PJT_CURT_STAT" data-options="mode:'remote',editable:false,loader:jcombo.loader"/></span>
							</td>
			            </tr>
			            <tr >
			            	<th><span data-item="LAB_009">Project No</span></th>
							<td>
								<span class="textbox" ><input type="text" class="easyui-textbox txt-center" name="pjtNo" id="r_pjtNo" data-options="readonly:true"/></span>
							</td>
							<th><span data-item="LAB_010">Project Name</span></th>
							<td >
								<span class="textbox" ><input class="textbox-text" name="pjtName" id="r_pjtName" /></span>
							</td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_011">구분</span></th>
							<td>
								<input class="easyui-combobox" name="pjtGb" id="r_pjtGb" codeGrup="PJT_GB" data-options="mode:'remote',editable:false,loader:jcombo.loader"/></span>
							</td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_012">Model No</span></th>
							<td colspan="3">
								<span class="textbox" style="width:150px !important"><input class="textbox-text" name="modelNo" id="r_modelNo" /></span>
								<span class="modelIcon"><a onclick="javascript:void(0)"><img id="search-model-button2" style="cursor: pointer;" src="<c:url value="/resources/images/searchCust.png"/>"/></a></span>
							</td>
			            </tr>
			            <tr>
			            	<th><span data-item="LAB_013">모델명</span></th>
			            	<td>
								<spa class="textbox" ><input class="textbox-text" name="modelName" id="r_modelName"/></span>
							</td>
							<th><span data-item="LAB_014">규격</span></th>
							<td style="border-right:1px solid #ccc;">
								<span class="textbox" ><input class="textbox-text" name="modelSpec" id="r_modelSpec"/></span>
							</td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_015">담당</span></th>
							<td>
								<span class="textbox" ><input class="textbox-text" name="stafName" id="r_stafName" /></span>
							</td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_016">진행일정</span></th>
							<td colspan="3">
								<span class="r_date1"><input class="easyui-datebox" name="startDate" id="r_startDate" value=""/></span>~
								<span class="r_date2"><input class="easyui-datebox" name="endDate" id="r_endDate" value=""/></span>
							</td>
			            </tr>
			            <tr>
							<th ><span data-item="LAB_017">비고</span></th>
							<td colspan="3" style="height:200px "><span class="textbox" style="height:200px !important;"><textarea class="textbox-text" name="pjtRemk" id="r_pjtRemk" style="width:100%;height:100%;"></textarea></span></td>
			            </tr>
			        </table>
		    	</fieldset>
		    </form>
		</div>

    	<div style="position:absolute;height:37px; background-color:#fafafa;bottom:0px;width:570px;margin-left:10px;border-top:1px solid #e1e8ed;"></div>
    <!-- [EAST] end -->
	</div>
<!-- [LAYOUT] end -->
</div>

<!-- 모델조회 -->
<div id="model-search-dialog" class="wui-dialog" style="border-top-width:1px;display:none">
	<table id="search-model-grid">
		<thead>
			<tr>
				<th data-options="field:'modelNo', halign:'center', width:100, data_item:'GRD_011'">모델번호</th>
				<th data-options="field:'modelName', halign:'center', width:150, data_item:'GRD_012'">모델명</th>
				<th data-options="field:'modelSpec', halign:'center', align:'center', width:150, data_item:'GRD_013'">규격</th>
			</tr>
		</thead>
	</table>

	<!-- fieldset 구분 변경  20160928 박소현 -->
	<div id="search-model-toolbar" class="wui-toolbar">
		<form id="search-model-form">
			<fieldset class="div-line-new" >
				<input type="hidden" name="pModelType" id="pModelType" value="0" />
		        <table cellpadding="5" class="search-table tableSearch-c" >
		            <tr>
						<th class="h table-Search-h" data-item="LAB_018"><span>모델명 </span></th>
						<td class="d">
							<input class="easyui-textbox" name="pModelName" id="pModelName" style="width:120px"/>
						</td>
						<th class="h table-Search-h" data-item="LAB_019"><span>규격 </span></th>
						<td class="d">
							<input class="easyui-textbox" name="pModelSpec" id="pModelSpec" style="width:150px"/>
						</td>
						<td class="b">
							<a href="javascript:void(0)" id="search-model-pop-button" class="easyui-linkbutton cgray" data-item="BTN_007">검색</a>
						</td>
		            </tr>
		        </table>
		   	</fieldset>
		    <fieldset class="div-line-new-sub">
		        <table cellpadding="5" class="search-table tableEtc-c">
		        </table>
			</fieldset>
		</form>
	</div>
</div>

<!--시리얼 등록화면 -->
<div id="print-dialog" class="wui-dialog" style="border-top-width:1px;display:none">
	<div id="search-create-toolbar4" class="wui-toolbar">
		<form id="search-create-form">
		<fieldset class="div-line-new" >
			<table cellpadding="5" class="popup-search-table" >

				<tr>
					<th class="h" data-item="LAB_020"><span>출력코드</span></th>
					<td class="d" >
						<input class="easyui-textbox" name="PbarcodeNo" id="PbarcodeNo" value=""  style="width:130px;" data-options="readonly:true"/>
					</td>
				</tr>

				<tr>
					<th class="h" data-item="LAB_021"><span>수량개수</span></th>
					<td class="d" >
						<input class="easyui-numberbox" name="PlimitNo" id="PlimitNo" value=""  style="width:130px"/>
					</td>
				</tr>
			</table>
	   </fieldset>

	        <!-- <div class="div-line-new"></div>  -->
	    <fieldset class="div-line-new-sub">
	        <table cellpadding="5" class="search-table tableEtc-c">
	            <tr>
					<td class="h">
						<a href="javascript:printPdf()" onclick="PrintItemCode()"class="easyui-linkbutton c4" iconCls="icon-print" id="report-button-pdf2" data-item="BTN_008">인쇄</a>
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

<!-- PDF 출력 조회 -->
<div id="pdf-dialog" class="easyui-layout" style="width:1024px;height:720px">
<iframe id="pdf-redirect" src=""  frameborder="0" style="width:100%;height:672px"></iframe>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
