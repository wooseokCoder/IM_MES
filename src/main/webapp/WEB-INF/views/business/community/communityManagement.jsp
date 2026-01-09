<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)code.jsp 1.0 2014/08/05                                            --%>
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
<%-- 동호회 관리 화면이다.                                                       		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/business/community/communitymanagement.js" />"></script>

<style>
	/* .sub-table-height26{margin-top:10px;border-top:2px solid #3879D9;} */
	.sub-table-height26 > .easyui-fluid > .panel-header{height:26px;line-height:26px;padding:0;}
	.sub-table-height26 > .easyui-fluid > .panel-header > .panel-title{height:26px !important;line-height:26px !important;padding-left:25px;}
	.sub-table-height26 .select-table th{text-align:center;}

	#account-layout{min-width:1200px !important;}
	/* 오른쪽 테이블 그리드 강제 넓이 고정 */
	.adjust-table1 .textbox{width:100% !important;height:25px !important;}

	@media screen and (max-width:1100px){
		.pagination table td:nth-child(-n+3){display:none;}
		.pagination table td:nth-child(11){display:none;}
		.pagination table td:nth-child(12){display:none;}
		.pagination table td:nth-child(13){display:none;}
		.pagination-info{display:none;}
	}

	.table-customPage-inputBox .textbox{width:100px !important;}
	.table-customPage-inputBox2 .textbox{width:86px !important;}
    .company-info-table th{width: 110px;}

    .numberbox .textbox-text{
	  text-align: right;
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
			            <tr>
			            	<th class="h table-Search-h"><span data-item="LAB_001">동호회명</span></td>
							<td class="d"><input class="easyui-textbox"  name="searchComuName" id="searchComuName" style="width:150px"/></td>
			            	<th class="h table-Search-h"><span data-item="LAB_002">동호회 ID</span></td>
							<td class="d"><input class="easyui-textbox"  name="searchComuId" id="searchComuId" style="width:100px"/></td>
			            	<!-- <th class="h table-Search-h"><span data-item="LAB_003">거래처구분</span></td>
			            	<td class="d">
			            	<select class="easyui-combobox" name="searchCustType" id="s_searchCustType" data-options="width:100">
								<option value="" data-item = 'LAB_004'>전체</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'CUST_TYPE' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
									</c:if>
								</c:forEach>
							</select>
			            	</td>
			            	<th class="h table-Search-h"><span data-item="LAB_005">대표자</span></td>
							<td class="d"><input class="easyui-textbox"  name="searchOwnName" id="searchOwnName" style="width:100px"/></td>
							<th class="h table-Search-h"><span data-item="LAB_006">입금자</span></td>
							<td class="d"><input class="easyui-textbox"  name="searchDepositor1" id="searchDepositor1" style="width:100px"/></td>
							<th class="h table-Search-h"><span data-item="LAB_007">사업자번호</span></td>
							<td class="d"><input class="easyui-textbox"  name="searchBizNo" id="searchBizNo" style="width:100px"/></td> -->
							<td class="b"><a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001" data-options="disabled:${RET}" >검색</a></td>
			            </tr>
			        </table>
			   </fieldset>
			   <fieldset class="div-line-new-sub">
			        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">추가</a>
			        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
			        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_004"  data-options="disabled:${UPD}">저장</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel" data-item="BTN_005" id="excel-button" >엑셀</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_006" >초기화</a>
		
				<!-- 테이블 가운데 보더 안보이게 하는 강제 공간 -->
				</fieldset>
			</form>
		</div>
	</div>

	<!-- [CENTER] start -->
    <div data-options="region:'center',border:false">
		<table id="search-grid">
			<thead>
				<tr>
					<th data-options="field:'comuId'     , halign:'center', width:100, data_item:'GRD_000', align:'center', sortable:true">동호회 ID</th>				
					<th data-options="field:'comuName'   , halign:'center', width:200, data_item:'GRD_000', align:'left', sortable:true">동호회명</th>
					<th data-options="field:'comuSlog'   , halign:'center', width:250, data_item:'GRD_000', align:'left', sortable:true">동호회 슬로건</th>
					<th data-options="field:'comuFondDay', halign:'center', width:100, data_item:'GRD_000', align:'center', sortable:true">창립일</th>					
					<th data-options="field:'useYn'      , halign:'center', width:60,  data_item:'GRD_000', align:'center', sortable:true">사용유무</th>
					<th data-options="field:'regiDate'   , halign:'center', width:150, data_item:'GRD_000', align:'center', sortable:true">등록일자</th>
				</tr>
			</thead>
		</table>

    <!-- [CENTER] end -->
	</div>

	<!-- [EAST] start -->
	<div data-options="region:'east',border:false" style="padding-top:24px; padding-bottom:40px;width:860px;">
		<div class="accountInfo-header" style="border-bottom:1px solid #8a8a8a;margin-left:10px;width:850px;"><span data-item="LAB_004">상세정보</span></div>
		<!-- <div class="accountInfo-header" style="border-bottom:1px solid #8a8a8a;margin-left:10px;width:550px;position:relative !important;"><span data-item="LAB_045">상세정보</span></div> -->
		<div class="easyui-panel" style="overflow:hidden" data-options="fit:true" >
		    <form id="regist-form" method="post">
	    		<input type="hidden" name="sysId" id="r_sysId" />
	    		<input type="hidden" name="oper"  id="r_oper" value="I" />
	    		<input type="hidden" name="sysId" id="r_hdfComuId" />						
	            <table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
	            	<tr>
						<th style="width:101px;"><span data-item="LAB_009">동호회명</span></th>
						<td style="width:320px;">
							<span class="textbox"><input class="textbox-text" name="comuName" id="r_comuName" data-options="required:true" /></span>
						</td>
						<th  style="width:99px;"><span data-item="LAB_010">동호회 ID</span></th>
						<td style="width:320px;">
							<span class="textbox"><input class="textbox-text" name="comuId" id="r_comuId" readonly/></span>
						</td>								
		            </tr>
		            <tr>
		            	<th><span data-item="LAB_030">슬로건</span></th>
						<td colspan="3" ><span class="textbox"><input type="text" class="textbox-text" name="comuSlog" id="r_comuSlog" /></span></td>
		            </tr>
		            <tr>
						<th><span data-item="LAB_025">창립일</span></th>
						<td><input class="easyui-datebox" name="comuFondDay" id="r_comuFondDay" /></td>
						<th style="width:99px;">
							<span data-item="LAB_012">구분</span>
						</th>
						<td>
							<select class="easyui-combobox" name="comuGb" ID="r_comuGb" data-options="width:100">
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'COMU_GB' }">
									<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
									</c:if>
								</c:forEach>
							</select>
						</td> 
		            </tr>
		            <tr>
						<td class="table-subtitle" colspan="4" style="padding: 0px !important;" >사용메뉴관리</td>
		            </tr> 
		            <tr>
		            	<th><span data-item="LAB_030">기본</span></th>
						<td colspan="3" >
							<input type="text" class="textbox-text" name="comuInfoName" id="r_comuInfoName" style="width:200px!important;" readonly ></input>
							<span data-item="LAB_011">▷</span>
							<input type="hidden" name="comuMenuId1" id="comuMenuId1" />
							<input type="text" class="textbox-text" name="comuInfo" id="r_comuInfo" style="width:200px!important;" />
							<input type="checkbox" name="comuInfoYn" id='comuInfoYn'  style="width:15px!important;margin-left:10px;" />
							<label for='comuInfoYn' style="margin-bottom:0"  data-item="LAB_037" >사용유무</label>
						</td>
		            </tr>
		            <tr>
		            	<th><span data-item="LAB_030">기본</span></th>
						<td colspan="3" >
							<input type="text" class="textbox-text" name="comuNoticeName" id="r_comuNoticeName" style="width:200px!important;" readonly ></input>
							<span data-item="LAB_011">▷</span>
							<input type="hidden" name="comuMenuId2" id="comuMenuId2" />
							<input type="text" class="textbox-text" name="comuNotice" id="r_comuNotice" style="width:200px!important;" />
							<input type="checkbox" name="comuNoticeYn" id='comuNoticeYn'  style="width:15px!important;margin-left:10px;"/>
							<label for='comuNoticeYn' style="margin-bottom:0"  data-item="LAB_037" >사용유무</label>
						</td>
		            </tr>
		            <tr>
		            	<th><span data-item="LAB_030">기본</span></th>
						<td colspan="3" >
							<input type="text" class="textbox-text" name="comuFreeBoardName" id="r_comuFreeBoardName" style="width:200px!important;" readonly ></input>
							<span data-item="LAB_011">▷</span>
							<input type="hidden" name="comuMenuId3" id="comuMenuId3" />
							<input type="text" class="textbox-text" name="comuFreeBoard" id="r_comuFreeBoard" style="width:200px!important;" />
							<input type="checkbox" name="comuFreeBoardYn" id='comuFreeBoardYn'  style="width:15px!important;margin-left:10px;"/>
							<label for='comuFreeBoardYn' style="margin-bottom:0"  data-item="LAB_037" >사용유무</label>
						</td>
		            </tr>
		            <tr>
		            	<th><span data-item="LAB_030">추가</span></th>
						<td colspan="3" >
							<input type="text" class="textbox-text" name="comuAlbumName" id="r_comuAlbumName" style="width:200px!important;" readonly ></input>
							<span data-item="LAB_011">▷</span>
							<input type="hidden" name="comuMenuId4" id="comuMenuId4" />
							<input type="text" class="textbox-text" name="comuAlbum" id="r_comuAlbum" style="width:200px!important;" />
							<input type="checkbox" name="comuAlbumYn" id='comuAlbumYn'  style="width:15px!important;margin-left:10px;"/>
							<label for='comuAlbumYn' style="margin-bottom:0"  data-item="LAB_037" >사용유무</label>
						</td>
		            </tr>
		            <tr>
		            	<th><span data-item="LAB_030">추가</span></th>
						<td colspan="3" >
							<input type="text" class="textbox-text" name="comuVideo" id="r_comuVideoName" style="width:200px!important;" readonly ></input>
							<span data-item="LAB_011">▷</span>
							<input type="hidden" name="comuMenuId5" id="comuMenuId5" />
							<input type="text" class="textbox-text" name="comuVideo" id="r_comuVideo" style="width:200px!important;" />
							<input type="checkbox" name="comuVideoYn" id='comuVideoYn'  style="width:15px!important;margin-left:10px;"/>
							<label for='comuVideoYn' style="margin-bottom:0"  data-item="LAB_037" >사용유무</label>
						</td>
		            </tr>
		            <tr>
		            	<th><span data-item="LAB_030">추가</span></th>
						<td colspan="3" >
							<input type="text" class="textbox-text" name="comuMaket" id="r_comuMaketName" style="width:200px!important;" readonly ></input>
							<span data-item="LAB_011">▷</span>
							<input type="hidden" name="comuMenuId6" id="comuMenuId6" />
							<input type="text" class="textbox-text" name="comuMaket" id="r_comuMaket" style="width:200px!important;" />
							<input type="checkbox" name="comuMaketYn" id='comuMaketYn'  style="width:15px!important;margin-left:10px;"/>
							<label for='comuMaketYn' style="margin-bottom:0"  data-item="LAB_037" >사용유무</label>
						</td>
		            </tr>
				</table>
				<table class="community-terms-table" style="margin-left:10px;border-left:1px solid #dadada">
					<tr>
						<th><span data-item="LAB_030">약관</span></th>
		            	<td id="editor-area">
							<textarea rows="5" cols="30"  name="comuTerm" id="r_comuTerm" class="sceditor wui-editor" style="width:100%; height:150px;border-radius:5px 5px 5px 5px;border:1px solid #cccccc;resize: none;filter:none !important;"></textarea>
						</td>
		            </tr>
				</table>
					       
			</form>
		</div>
		
		<div style="position:absolute;height:37px; background-color:#fafafa;bottom:0px;width:570px;margin-left:10px;border-top:1px solid #e1e8ed;"></div>
 	<!-- [EAST] end -->
	</div>

<!-- [LAYOUT] end -->
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
