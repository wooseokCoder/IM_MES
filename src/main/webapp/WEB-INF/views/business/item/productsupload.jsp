<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)productsupload.jsp 1.0 2014/09/29                                  --%>
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
<%-- 상품업로드 화면이다.                                                    		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/09/29                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/business/item/productsupload.js" />"></script>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<table id="search-grid">
	<thead>
		<tr>
			<th data-options="field:'itemName',width:200, data_item:'GRD_001',halign:'center',align:  'left',editor:'text'">품명</th>
			<th data-options="field:'itemNameAlt',width:150, data_item:'GRD_002',halign:'center',align:  'left',editor:'text'">품명(약어)</th>
			<th data-options="field:'itemSpec',width:300, data_item:'GRD_003',halign:'center',align:  'left',editor:'text'">규격</th>
			<th data-options="field:'itemUnit',width:60, data_item:'GRD_004',halign:'center',align:  'center',editor:'text'">단위</th>
			<th data-options="field:'itemUnitQty',width:100, data_item:'GRD_005',halign:'center',align:  'right',editor:'numberbox'">단위수량</th>
			<th data-options="field:'purcPrce',width:100, data_item:'GRD_006',halign:'center',align:  'right',editor:'numberbox'">매입단가</th>
			<th data-options="field:'salePrce',width:100, data_item:'GRD_007',halign:'center',align:  'right',editor:'numberbox'">매출단가</th>
			<th data-options="field:'itemType1',width:100, data_item:'GRD_008',halign:'center',align:  'center',editor:'text'">1차구분</th>
			<th data-options="field:'itemType1Name',width:140, data_item:'GRD_009',halign:'center',align:  'center',editor:'text'">1차구분명</th>
			<th data-options="field:'itemType2',width:100, data_item:'GRD_010',halign:'center',align:  'center',editor:'text'">2차구분</th>
			<th data-options="field:'itemType2Name',width:140, data_item:'GRD_011',halign:'center',align:  'center',editor:'text'">2차구분명</th>
			<th data-options="field:'itemBar',width:120, data_item:'GRD_012',halign:'center',align:  'center',editor:'text'">바코드</th>
			<th data-options="field:'modelNo',width:120, data_item:'GRD_013',halign:'center',align:  'center',editor:'text'">모델번호</th>
			<th data-options="field:'modelName',width:100, data_item:'GRD_014',halign:'center',align:  'left',editor:'text'">모델명</th>
			<th data-options="field:'siNo',width:100, data_item:'GRD_015',halign:'center',align:  'center',editor:'text'">시리얼</th>
			<th data-options="field:'saftQty',width:100, data_item:'GRD_016',halign:'center',align:  'right',editor:'numberbox'">안정재고</th>
			<th data-options="field:'onHandQty',width:100, data_item:'GRD_017',halign:'center',align:  'right',editor:'numberbox'">현재고</th>
			<th data-options="field:'handQty',width:100, data_item:'GRD_018',halign:'center',align:  'right',editor:'numberbox'">가용재고</th>
			<th data-options="field:'stocLoc',width:150, data_item:'GRD_019',halign:'center',align:  'left',editor:'text'">저장위치</th>
			<th data-options="field:'goodsGP',width:150, data_item:'GRD_020',halign:'center',align:  'left',editor:'text'">상품구분</th>
			<th data-options="field:'AS_GP',width:60, data_item:'GRD_021',halign:'center',align:  'center',editor:'text'">AS</th>
			<th data-options="field:'itemRemk',width:250, data_item:'GRD_022',halign:'center',align:  'left',editor:'text'">비고</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form" method="post" enctype="multipart/form-data">
		<fieldset class="div-line-new" style="padding-top:8px;padding-bottom:10px;">
	        <table cellpadding="5" class="search-table">
	            <tr>
					<th class="h"><span data-item="LAB_001">엑셀파일선택:</span></th>
					<td class="d">
						<input type="file" name="excelFile" id="s_excelFile" size="40"/>
					</td>
	            </tr>
	        </table>
		</fieldset>
		<fieldset class="div-line-new-sub">
	        <table cellpadding="5" class="search-table  tableEtc-c" >
	            <tr>
					<td class="h">
					    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="upload-button" data-item="BTN_001">업로드</a>
					    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="clear-button" data-item="BTN_002" >초기화</a>
					    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003">삭제</a>
					    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_004"  >저장</a>
					</td>
				</tr>
			</table>
		</fieldset>
	</form>
</div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
