<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)commodityMaterialCode.jsp 1.0 2014/08/05                           --%>
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
<%-- 코드관리 화면이다.                                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/business/item/commoditymaterialcode.js" />"></script>
<!-- 2016/12/02 김영진 -- 하단 상세화면 타이틀 크기 조절 -->
<style>
	/* .sub-table-height26{margin-top:10px;border-top:2px solid #3879D9;} */
	.sub-table-height26 > .easyui-fluid > .panel-header{height:26px;line-height:26px;padding:0;}
	.sub-table-height26 > .easyui-fluid > .panel-header > .panel-title{height:26px !important;line-height:26px !important;padding-left:25px;}
	.sub-table-height26 .select-table th{text-align:center;}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout">
		<div data-options="region:'north',border:false">
			<div id="search-toolbar" class="wui-toolbar">
				<form id="search-form">
					<fieldset class="div-line-new" >
				        <table cellpadding="5" class="search-table tableSearch-c" >
				            <tr>
				            	<th class="h table-Search-h" data-item="LAB_001"><span>품명 </span></th>
								<td class="d">
									<span class="textbox"><input class="textbox-text" name="searchText" id="r_searchText" style="width:150px" /></span>
								</td>
								<td class="b"><a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001">검색</a></td>
				            </tr>
				        </table>
				   </fieldset>
				   <fieldset class="div-line-new-sub">
				   <!-- <div class="div-line"></div> -->
				        <table cellpadding="5" class="search-table tableEtc-c" style="width:100%;">
				            <tr>
								<td class="h" style="width:405px;">
							        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002">추가</a>
							        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_003">저장</a>
							        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_004">삭제</a>
									<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel" id="excel-button" data-item="BTN_005">엑셀</a>
								</td>
								<td class="h">
									<span class="textbox"><input class="textbox-text" name="purcPrceRate" id="v_purcPrceRate" style="width:97px;height:22px;text-align:right;" /></span>
									<span class="textbox"><input class="textbox-text" name="salePrceRate" id="v_salePrceRate" style="width:97px;height:22px;text-align:right;" /></span>
								</td>
								<td class="h" style="float:right;padding-right:10px;">
									<a href="javascript:void(0)" class="easyui-linkbutton cgray linkbutton-120" id="copy-button"  data-item="BTN_006">동일품명 전체복사</a>
									<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="close-button" data-item="BTN_007">상세닫기</a>
									<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="open-button"  data-item="BTN_008">상세보기</a>
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
					<th data-options="field:'itemName'    , halign:'center',width:200, data_item:'GRD_001', align:'left'  , editor:{type:'textbox'}">품명</th>
					<th data-options="field:'itemSpec'    , halign:'center',width:120, data_item:'GRD_002', align:'left'  , editor:{type:'textbox'}">규격</th>
					<th data-options="field:'itemUnit'    , halign:'center',width:60,  data_item:'GRD_003', align:'center', editor:{type:'textbox'}">단위</th>
					<th data-options="field:'purcPrce'    , halign:'center',width:100, data_item:'GRD_004', align:'right' , editor:{type:'textbox'},formatter:formatNumber">매입단가</th>
					<th data-options="field:'salePrce'    , halign:'center',width:100, data_item:'GRD_005', align:'right' , editor:{type:'textbox'},formatter:formatNumber">판매단가</th>
					<th data-options="field:'basePrce'    , halign:'center',width:100, data_item:'GRD_006', align:'right' , editor:{type:'textbox'},formatter:formatNumber">협정가</th>
					<th data-options="field:'lastPurcDate', halign:'center',width:100, data_item:'GRD_007', align:'center'">최종구입</th>
					<th data-options="field:'itemRemk'    , halign:'center',width:300, data_item:'GRD_008', align:'left'  , editor:{type:'textbox'}">비고</th>
					<th data-options="field:'updtDate'    , halign:'center',width:180, data_item:'GRD_009', align:'center'">수정일자</th>
					<th data-options="field:'itemCode'    , halign:'center',width:100, data_item:'GRD_010', align:'center'">상품코드</th>
				</tr>
			</thead>
		</table>

    <!-- [CENTER] end -->
	</div>
		
		<!-- [EAST] start -->
	    <div data-options="region:'east',border:false,split:true,width:500" class="sub-table-height26" style="min-width:450px;position:relative;padding-top:30px;">
			<div class="accountInfo-header">상세정보</div>
	     
			<!-- 2016/12/05 김영진 -- title 한영변환 재검토 -->
			<div class="easyui-panel" style="overflow:auto;" data-options="fit:true">
			    <form id="regist-form" method="post">
			    	<fieldset>
			    		<input type="hidden" name="sysId"        id="r_sysId" />
			    		<input type="hidden" name="oper"         id="r_oper"  />
			    		<input type="hidden" name="itemCode"     id="r_itemCode" />
			    		<input type="hidden" name="purcPrceRate" id="r_purcPrceRate" />
			    		<input type="hidden" name="salePrceRate" id="r_salePrceRate" />
			    		<input type="hidden" name="updateFlag"   id="r_updateFlag" />
			    		
				        <table cellpadding="5" cellspacing="2" id="compInfo" class="select-table accountInfo">
							<tr class="first-tr">
								<td style="width:90px;"></td>
								<td style="width:30%;"></td>
								<td style="width:90px"></td>
								<td></td>
							</tr>
				            <tr>
								<th class="h"><span data-item="LAB_002">픔명</span></th>
								<td colspan="3" class="d">
									<span class="textbox"><input class="textbox-text" name="itemName" id="r_itemName" onChange="doTableUpdate();" /></span>
								</td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_003">다른품명</span></th>
								<td colspan="3" class="d"><span class="textbox"><input class="textbox-text" name="itemNameAlt" id="r_itemNameAlt" onChange="doTableUpdate();" /></span></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_004">규격</span></th>
								<td colspan="3" class="d"><span class="textbox"><input class="textbox-text" name="itemSpec" id="r_itemSpec" onChange="doTableUpdate();" /></span></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_005">단위</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text txt-center" name="itemUnit" id="r_itemUnit" onChange="doTableUpdate();" /></span></td>
								<td colspan="2" class="emptyColumn"></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_006">판매단가</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text txt-right" name="salePrce" id="r_salePrce" onChange="doOnChange(this);doTableUpdate();" onfocus="doOnNumberFocus(this);" onblur="doOnNumberBlur(this);" /></span></td>
								<th class="h"><span data-item="LAB_007">참조가격</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text txt-right" name="ref1Prce" id="r_ref1Prce" disabled="disabled" /></span></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_008">매입가</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text txt-right" name="purcPrce" id="r_purcPrce" onChange="doOnChange(this);doTableUpdate();" onfocus="doOnNumberFocus(this);" onblur="doOnNumberBlur(this);" /></span></td>
								<td class="emptyColumn"></td>
								<td class="d"><span class="textbox"><input class="textbox-text txt-right" name="ref2Prce" id="r_ref2Prce" disabled="disabled" /></span></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_009">협정가</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text txt-right" name="basePrce" id="r_basePrce" onChange="doOnChange(this);doTableUpdate();" onfocus="doOnNumberFocus(this);" onblur="doOnNumberBlur(this);" /></span></td>
								<td class="emptyColumn"></td>
								<td class="d"><span class="textbox"><input class="textbox-text txt-right" name="ref3Prce" id="r_ref3Prce" disabled="disabled" /></span></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_010">관리구분</span></th>
								<td class="d">
									<!-- <span class="textbox"><input class="textbox-text txt-center" name="mngType" id="r_mngType" /></span> -->
									<input class="easyui-combobox" name="mngType"  id="r_mngType"  value="Y" codeGrup="MNG_TYPE" data-options="mode:'remote',editable:false,loader:jcombo.loader,onSelect:doTableUpdate" />
								</td>
								<td colspan="2" class="emptyColumn"></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_011">저장위치</span></th>
								<td colspan="3" class="d"><span class="textbox"><input class="textbox-text" name="stocLoc" id="r_stocLoc" onChange="doTableUpdate();" /></span></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_012">재고관리여부</span></th>
								<td class="d">
									<!-- <span class="textbox"><input class="textbox-text" name="stocAdmIdx" id="r_stocAdmIdx" /></span> -->
									<input class="easyui-combobox" name="stocAdmIdx"  id="r_stocAdmIdx"  value="Y" codeGrup="USE_FLAG" data-options="mode:'remote',editable:false,loader:jcombo.loader,onSelect:doTableUpdate"/>
								</td>
								<th class="h"><span data-item="LAB_013">관리비율</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text txt-center" name="stocAdmRate" id="r_stocAdmRate" onChange="doOnChange(this);doTableUpdate();" onfocus="doOnNumberFocus(this);" onblur="doOnNumberBlur(this);" /></span></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_014">적정재고</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text txt-center" name="saftQty" id="r_saftQty" onChange="doOnChange(this);doTableUpdate();" onfocus="doOnNumberFocus(this);" onblur="doOnNumberBlur(this);" /></span></td>
								<td colspan="2" class="emptyColumn"></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_015">현재고</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text txt-center" name="onHandQty" id="r_onHandQty" onChange="doOnChange(this);doTableUpdate();" onfocus="doOnNumberFocus(this);" onblur="doOnNumberBlur(this);" /></span></td>
								<td colspan="2" class="emptyColumn"></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_016">(이월)재고</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text txt-center" name="carryQty" id="r_carryQty" onChange="doOnChange(this);doTableUpdate();" onfocus="doOnNumberFocus(this);" onblur="doOnNumberBlur(this);" /></span></td>
								<th class="h"><span data-item="LAB_017">재고기준일</span></th>
								<td class="d">
									<input class="easyui-datebox" name="carryDate" id="r_carryDate" data-options="onSelect:doTableUpdate" />
								</td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_018">최종구매일</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text" name="lastPurcDate" id="r_lastPurcDate" disabled="disabled" /></span></td>
								<th class="h"><span data-item="LAB_019">최종판매일</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text" name="lastSaleDate" id="r_lastSaleDate" disabled="disabled" /></span></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_020">등록일</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text" name="regiDate" id="r_regiDate" disabled="disabled" /></span></td>
								<th class="h"><span data-item="LAB_021">수정일</span></th>
								<td class="d"><span class="textbox"><input class="textbox-text" name="updtDate" id="r_updtDate" disabled="disabled" /></span></td>
				            </tr>
				            <tr>
								<th class="h"><span data-item="LAB_022">비고</span></th>
								<td colspan="4" class="d" style="height:62px;">
									<span class="textbox" style="height:62px;"><textarea class="textbox-text" name="itemRemk" id="r_itemRemk" onChange="doTableUpdate();"></textarea></span>
								</td>
				            </tr>
				        </table>
			    	</fieldset>
			    </form>
			</div>
	    
	    <!-- [EAST] end -->
		</div>
	

<!-- [LAYOUT] end -->
</div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
