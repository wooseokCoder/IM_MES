<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)productsview.jsp 1.0 2014/08/05                     	            --%>
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
<%-- 상품관리 화면이다.                                                      		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/business/item/productsview_new.js" />"></script>
<script>
var getParameters="";
var limitNo="";
var printType="";
var printNotNull=false;

function openPrintDetail(){
	//console.log(printType);

	switch(printType){

	case 'itemCode':
		if($("#r_itemCode").val()!=""){
			$("#PbarcodeNo").textbox('setValue',$("#r_itemCode").val());
		}else{
			$.messager.alert('Warning',msg.MSG0084,'warning');
			return;
		}


		break;
	case 'modelNo':
		if($("#r_modelNo").combobox("getValue") != ""){
			$("#PbarcodeNo").textbox('setValue',$("#r_modelNo").combobox("getValue"));
		}else{
			$.messager.alert('Warning',msg.MSG0047,'warning');
			return;
		}

		break;
	case 'itemBar':
		if($("#r_itemBar").val()!=""){
			$("#PbarcodeNo").textbox('setValue',$("#r_itemBar").val());
		}else{
			$.messager.alert('Warning',msg.MSG0047,'warning');
			return;
		}
		break;
	default:
		break;
	}


	$("#print-dialog").dialog('center');
	$("#print-dialog").dialog('open');
}

function printPdf(){
	//console.log(printType);

	if($("#PbarcodeNo").val()==""){
		$.messager.alert('Warning',msg.MSG0111,'warning');
		return;
	}


	if($("#PprintPos").val()==""){
		$.messager.alert('Warning',msg.MSG0110,'warning');
		return;
	}

	if($("#PlimitNo").val()==""){
		$.messager.alert('Warning',msg.MSG0047,'warning');
		return;
	}

	if($("#PbarcodeNo").val()!="" && $("#PlimitNo").val()!="" &&$("#PprintPos").val()!="" ){
		printNotNull=true;
	}


	switch(printType){
		case 'itemCode':
			PrintItemCode();
			break;
		case 'modelNo':
			PrintModelNo();
			break;
		case 'itemBar':
			PrintBarcode();
			break;
		default:
			break;
	}
}
function PrintItemCode(){
/* 	$("#PlimitNo").val();
	$("#PprintPos").val(); */

	var itemCode=$("#r_itemCode").val();
	var barcodeType="itemCode";
	var barcodeNo=$("#r_itemCode").val();
	getParameters="&SYS_ID=WSC&itemCode="+itemCode+"&barcodeType="+barcodeType+"&barcodeNo="+barcodeNo
	+"&limitNo="+$("#PlimitNo").val()
	+"&printPos="+$("#PprintPos").val();

	if(printNotNull==true){
		$("#pdf-dialog").dialog('center');
		$("#pdf-dialog").dialog('open');
		$("#pdf-redirect").attr('src',$("#reportUrl").val()+"/jasperserver/flow.html?_flowId=viewReportFlow&_flowId=viewReportFlow&ParentFolderUri=%2Freports%2FeasyWSC_"+locale
				+"&reportUnit=%2Freports%2FeasyWSC_"+locale+"%2FprintBarcode&standAlone=true&j_username=easyframeuser&j_password=1234&decorate=no&output=pdf"
				+getParameters);
		printNotNull=false;
	}
}

function PrintModelNo(){
	var itemCode=$("#r_itemCode").val();
	var barcodeType="modelNo";
	var barcodeNo=$("#r_modelNo").combobox("getValue");
	getParameters="&SYS_ID=WSC&itemCode="+itemCode+"&barcodeType="+barcodeType+"&barcodeNo="+barcodeNo
	+"&limitNo="+$("#PlimitNo").val()
	+"&printPos="+$("#PprintPos").val();

	if(printNotNull==true){
		$("#pdf-dialog").dialog('center');
		$("#pdf-dialog").dialog('open');
		$("#pdf-redirect").attr('src',$("#reportUrl").val()+"/jasperserver/flow.html?_flowId=viewReportFlow&_flowId=viewReportFlow&ParentFolderUri=%2Freports%2FeasyWSC_"+locale
				+"&reportUnit=%2Freports%2FeasyWSC_"+locale+"%2FprintBarcode&standAlone=true&j_username=easyframeuser&j_password=1234&decorate=no&output=pdf"
				+getParameters);
		printNotNull=false;
	}
}
function PrintBarcode(){
	var itemCode=$("#r_itemCode").val();
	var barcodeType="itemBar";
	var barcodeNo=$("#r_itemBar").val();
	getParameters="&SYS_ID=WSC&itemCode="+itemCode+"&barcodeType="+barcodeType+"&barcodeNo="+barcodeNo
	+"&limitNo="+$("#PlimitNo").val()
	+"&printPos="+$("#PprintPos").val();

	if(printNotNull==true){
		$("#pdf-dialog").dialog('center');
		$("#pdf-dialog").dialog('open');
		$("#pdf-redirect").attr('src',$("#reportUrl").val()+"/jasperserver/flow.html?_flowId=viewReportFlow&_flowId=viewReportFlow&ParentFolderUri=%2Freports%2FeasyWSC_"+locale
				+"&reportUnit=%2Freports%2FeasyWSC_"+locale+"%2FprintItemBar&standAlone=true&j_username=easyframeuser&j_password=1234&decorate=no&output=pdf"
				+getParameters);

/* 	window.open($("#reportUrl").val()+"/jasperserver/flow.html?_flowId=viewReportFlow&_flowId=viewReportFlow&ParentFolderUri=%2Freports%2FeasyWSC_"+locale
			+"&reportUnit=%2Freports%2FeasyWSC_"+locale+"%2FprintItemBar&standAlone=true&j_username=easyframeuser&j_password=1234&decorate=no&output=pdf"
			+getParameters,"_blank");
	 */

		 var itemBarMaxInt=0;
		 if( $("#r_itemBarMax").val() != ""){
			 itemBarMaxInt = $("#r_itemBarMax").val();

		 }

		 for(var i=0;i<parseInt($("#PlimitNo").val());i++){
				 itemBarMaxInt++;
		    	itemBarMaxInt=parseInt(itemBarMaxInt);
		    	itemBarMaxInt=fillzero(itemBarMaxInt,5);
				itemBarMaxInt=parseInt(itemBarMaxInt);
		  }



		 $.ajax({
	         url: getUrl('/business/sale/saleregister/updateItemBarMax.json'),
	         dataType: 'json',
	         async: false,
	         type: 'post',
	         data: {
	         		sysId: $("#r_sysId").val()
	         	  ,itemCode: $("#r_itemCode").val()
	         	  ,itemBarMax: fillzero(itemBarMaxInt,5)
	         	},
	         success: function(data){

	         },
	         error: function(){
	         }
	     });
		 printNotNull=false;
	}

}
</script>
<style>
#account-layout{min-width:1200px !important;}
/* 오른쪽 테이블 그리드 강제 넓이 고정 */
	.sub-table-height26 > .easyui-fluid > .panel-header{height:26px;line-height:26px;padding:0;}
	.sub-table-height26 > .easyui-fluid > .panel-header > .panel-title{height:26px !important;line-height:26px !important;padding-left:25px;}
	.sub-table-height26 .select-table th{text-align:center;}

	.adjust-table1 .textbox{width:100% !important;height:25px !important;}
	.numberbox input{text-align:right;}
	@media screen and (max-width:1400px){

		.pagination-info{display:none;}
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
<div class="easyui-layout" data-options="fit:true" id="account-layout">

<div data-options="region:'north',border:false">
		<div id="search-toolbar" class="wui-toolbar">
			<form id="search-form">


			<fieldset  class="div-line-new" style="padding-top:8px;padding-bottom:10px;">
				<table>
				<tr>
					<td>
						<div class="search-table-react">
							<div class="search-table-category">
								<span class="search-table-h" data-item="LAB_001">품명/재질/규격</span>
								<input class="easyui-textbox" name="searchitemName" id="searchitemName"  data-options="width:100"/>
								<input class="easyui-textbox" name="searchitemMaterial" id="searchitemMaterial" data-options="width:100"/>
								<input class="easyui-textbox" name="searchitemSpec" id="searchitemSpec" data-options="width:100"/>
								<a onclick="javascript:void(0)"><img id="search-item-button" style="cursor: pointer;" src="<c:url value="/resources/images/searchCust.png"/>"/></a>
							</div>
							<div class="search-table-category">
								<span class="search-table-h" data-item="LAB_002">품목코드</span>
								<input class="easyui-textbox" name="searchitemCode" id="searchitemCode" style="width:140px"/>
							</div>

							<!-- <div class="search-table-category">
								<span class="search-table-h" data-item="LAB_003">1차 구분명</span>
								<input class="easyui-combobox" name="searchitemType1" ID="searchitemType1"  data-options="width:150,
								                                                                                          mode:'remote',
								                                                                                         loader:jcombo.loader,
								                                                                                         params:{codeGrup:'ITEM_TYPE1'},
																														 onChange: selectItemType"/></div>
							 <div class="search-table-category">
							 	<span class="search-table-h" data-item="LAB_004">2차 구분명</span>
								<select class="easyui-combobox" name="searchitemType2" ID="searchitemType2" data-options="width:150"></select></div> -->
					</td>
					<td style="vertical-align:top;">
						<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001" data-options="disabled:${RET}" >검색</a>
					</td>
				</tr>
				</table>
			</fieldset>		  
		</form>
		</div>
    </div>
    
     <!-- [CENTER] start -->
    <div data-options="region:'center',border:false">
     <fieldset class="div-line-new-sub">
		        <table cellpadding="5" class="search-table tableEtc-c" style="width:100%;">
		            <tr>
			            <td class="h" style="width:200px;">
					        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">추가</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003"  data-options="disabled:${DEL}" >삭제</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_004" data-options="disabled:${UPD}" >저장</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel" id="excel-button" data-item="BTN_005">엑셀</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_006">초기화</a>
						</td>
		            </tr>
		        </table>
	</fieldset>
	<table id="search-grid">
		<thead>
				<tr>
				<th data-options="field:'itemCode'     , halign:'center',width:100, data_item:'GRD_001', align:'center', sortable:true">품목코드</th>
				<th data-options="field:'itemName'     , halign:'center',width:250, data_item:'GRD_002', align:'left', sortable:true ">품명</th>
				<th data-options="field:'itemSpec'     , halign:'center',width:300, data_item:'GRD_003', align:'left', sortable:true ">규격</th>
				<th data-options="field:'itemMaterial' , halign:'center',width:100, data_item:'GRD_013', align:'left', sortable:true ">재질</th>
				<!-- <th data-options="field:'itemType1Name', halign:'center', width:100, data_item:'GRD_004', align:'center',sortable:true">1차</th>
				<th data-options="field:'itemType2Name', halign:'center', width:100, data_item:'GRD_005', align:'center',sortable:true">2차</th> -->
			</tr>
		</thead>
	</table>
	</div>
	
    

<!-- [EAST] start -->
   <div data-options="region:'east',border:false" style="width:580px;height:auto;">

				<div class="easyui-tabs">
				<!-- style='padding-top:5px;border-bottom:2px solid #4d4d4d;padding-bottom:6px;padding-left:6px' -->
				
				<!-- "공통사항" 탭 시작 -->
				<div title="공통사항"  style="padding:10px" >
					<div class="accountInfo-header" style="border-bottom:1px solid #8a8a8a;margin-left:10px;width:550px;position:relative !important;"><span data-item="LAB_045">상세정보</span></div>
			
					<div class="easyui-panel" style="overflow:hidden;" data-options="fit:true" >
					    <form id="regist-form" method="post">
					    	<fieldset style="border-right:1px solid #dadada;">
					    		<input type="hidden" name="sysId"       id="r_sysId" />
					    		<input type="hidden" name="oper"        id="r_oper"  />
		
					    		<input type="hidden" name="hdfCustCode" id="r_hdfCustCode" />
		
						         <table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
									<tr class="first-tr" style="display:none;">
		
									</tr>
						            <tr style="border-collapse:collapse; border:none;">
										<th>
										<span >
										<a onclick="javascript:printType='itemCode';openPrintDetail(); ">
										<img style="cursor: pointer;" src="<c:url value='/resources/images/printer.png'/>"</img></a>
										<span data-item="LAB_006">품목코드</span>
										</span>
										</th>
										<td class="textfix" style="border-right:1px solid #ccc;">
											<span class="textbox" >
											<input type='text' class="textbox-text" name="itemCode" id="r_itemCode" ></input>
											</span>
										</td>
						          		<td colspan="2" >
						          			<span data-item="LAB_007"> * 품목코드은 자동으로 생성됩니다.</span>									
										</td>
						            </tr>
						          
						            <tr>
						            	<th><span data-item="LAB_008">품명/약어</span></th>
										<td colspan="2">
											<span class="textbox" ><input class="textbox-text" name="itemName" id="r_itemName"/></span>
										</td>
										<td >
											<span class="textbox" ><input class="textbox-text" name="itemNameAlt" id="r_itemNameAlt" /></span>
										</td>
						            </tr>
						            <tr>
										<th><span data-item="LAB_009">* 규격</span></th>
										<td>
											<span class="textbox"><input class="textbox-text" name="itemSpec" id="r_itemSpec" /></span>
										</td>
										<th><span data-item="LAB_030"> 재질</span></th>
										<td>
											<span class="textbox"><input class="textbox-text" name="itemMaterial" id="r_itemMaterial" /></span>
										</td>
										
						            </tr>
						            <tr>
						            	<th><span data-item="LAB_010">단위</span></th>
						            	<td>
											<spa class="textbox" ><input class="textbox-text" name="itemUnit" id="r_itemUnit"/></span>
										</td>
										<th><span data-item="LAB_011">단위수량</span></th>
										<td style="border-right:1px solid #ccc;">
											<span class="textbox" ><input class="textbox-text" name="itemUnitQty" id="r_itemUnitQty"/></span>
										</td>
						            </tr>
		
						            <tr>
										<!-- <th><span data-item="LAB_012">1차 구분명</span></th>
										<td class="d">
											<input class="easyui-combobox" name="itemType1" ID="r_itemType1"  data-options="width:150,
													                                                                                          mode:'remote',
													                                                                                         loader:jcombo.loader,
													                                                                                         params:{codeGrup:'ITEM_TYPE1'},
																																			 onChange: selectItemType2"/></div>
										</td>
										<th><span data-item="LAB_013">2차 구분명</span></th>
										<td class="d">
											<select class="easyui-combobox" name="itemType2" ID="r_itemType2" data-options="width:150"></select></div>
										</td> -->
						            </tr>
						             <tr>
										<th>
										<a onclick="javascript:printType='modelNo';openPrintDetail();">
										<img style="cursor: pointer;" src="<c:url value='/resources/images/printer.png'/>"</img></a>
										<span data-item="LAB_014">모델번호</span></th>
										<td>
											<!-- <span class="textbox" ><input class="textbox-text" name="modelNo" id="r_modelNo" /></span> -->
											<select class="easyui-combobox" name="modelNo" ID="r_modelNo" data-options="width:150, onChange: getModelName"></select>
										</td>
										<th><span data-item="LAB_015">모델명</span></th>
										<td>
											<span class="textbox" ><input class="textbox-text" name="modelName" id="r_modelName" /></span>
										</td>
						            </tr>
						           <tr>
										<th>
										<a onclick="javascript:printType='itemBar';openPrintDetail();">
										<img style="cursor: pointer;" src="<c:url value='/resources/images/printer.png'/>"</img></a>
										<span data-item="LAB_016">바코드PreFix</span></th>
										<td style="border-right:1px solid #ccc;">
											<span class="textbox" ><input class="textbox-text" name="itemBar" id="r_itemBar" /></span>
										</td>
										<th><span data-item="LAB_017">바코드Max</span></th>
										<td style="border-right:1px solid #ccc;">
											<span class="textbox" ><input class="textbox-text" name="itemBarMax" id="r_itemBarMax" /></span>
										</td>
						            </tr>
						            <tr>
										<th><span data-item="LAB_018">매입단가</span></th>
										<td>
											<input type="text" class="easyui-numberbox cashType-input-text" style="text-align:right !important;" name="purcPrce" id="r_purcPrce" data-options="groupSeparator:','"  />
										</td>
										<th><span data-item="LAB_019">판매기준가</span></th>
										<td>
											<input type="text" class="easyui-numberbox cashType-input-text" style="text-align:right !important;" name="salePrce" id="r_salePrce" data-options="groupSeparator:','"  />
										</td>
						            </tr>
		
		
						            <tr>
										<th><span data-item="LAB_020">안정재고</span></th>
										<td>
											<input type="text" class="easyui-numberbox cashType-input-text" style="text-align:right !important;" name="saftQty" id="r_saftQty" data-options="groupSeparator:','"  />
										</td>
										<th><span data-item="LAB_021">현재고</span></th>
										<td>
											<input type="text" class="easyui-numberbox cashType-input-text" style="text-align:right !important;" name="onHandQty" id="r_onHandQty" data-options="groupSeparator:','"  />
										</td>
						            </tr>
						            <tr>
										<th><span data-item="LAB_022">가용재고</span></th>
										<td>
											<input type="text" class="easyui-numberbox cashType-input-text" style="text-align:right !important;" name="handQty" id="r_handQty" data-options="groupSeparator:','"  />
										</td>
										<th><span data-item="LAB_023">기본저장위치</span></th>
										<td>
											<input class="easyui-combobox" name="stocLoc" id="r_stocLoc" codeGrup="STRG_TYPE" data-options="mode:'remote',editable:false,loader:jcombo.loader"/></span>
										</td>
						            </tr>
						            <tr>
										<th><span data-item="LAB_024">상품구분</span></th>
										<td>
											<input class="easyui-combobox" name="goodsGP" id="r_goodsGP" codeGrup="ADM_IDX" data-options="mode:'remote',editable:false,loader:jcombo.loader,panelHeight:'auto'"/></span>
										</td>
									</tr>
						            <tr>
										<th ><span data-item="LAB_025">비고</span></th>
										<td colspan="3" style="height:62px "><span class="textbox" style="height:62px !important;"><textarea class="textbox-text" name="itemRemk" id="r_itemRemk" style="width:100%;height:100%;"></textarea></span></td>
						            </tr>
						        </table>
					    	</fieldset>
					    </form>
					</div>
		
			    	<!-- <div style="position:absolute;height:37px; background-color:#fafafa;bottom:0px;width:550px;margin-left:10px;border-top:1px solid #e1e8ed;"></div> -->
						
				</div>
				<!-- "공통사항" 탭 끝 -->
				
				<!-- 생산정보 탭 시작 -->
				<div title="생산정보"  style="padding:10px">
					<div class="accountInfo-header" style="border-bottom:1px solid #8a8a8a;margin-left:10px;width:550px;position:relative !important;"><span data-item="LAB_046">상세정보</span></div>
			
					<div class="easyui-panel" style="overflow:;" data-options="fit:true" >
					    <form id="regist-form" method="post">
					    	<fieldset style="border-right:1px solid #dadada;">
					    		<input type="hidden" name="sysId"       id="r_sysId" />
					    		<input type="hidden" name="oper"        id="r_oper"  />
		
					    		<input type="hidden" name="hdfCustCode" id="r_hdfCustCode" />
		
						         <table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
									<tr class="first-tr" style="display:none;">
		
									</tr>
						            <tr style="border-collapse:collapse; border:none;">
										<th>
										<span>
										<a onclick="javascript:printType='itemCode';openPrintDetail(); ">
										<img style="cursor: pointer;" src="<c:url value='/resources/images/printer.png'/>"</img></a>
										<span data-item="LAB_031">품목코드</span>
										</span>
										</th>
										<td>
											<span class="textbox" >
											<input type='text' class="textbox-text" name="itemCode2" id="r_itemCode2" readonly></input>
											</span>
										</td>
										
						          		<td colspan="2" >
						          			<span data-item="LAB_032"> * 품목코드는 자동으로 생성됩니다.</span>									
										</td>
						            </tr>
						          
						            <tr>
						            	<th><span data-item="LAB_033">품명/약어</span></th>
										<td colspan="2">
											<span class="textbox" >
											<input type="text" class="textbox-text" name="itemName2" id="r_itemName2" readonly></input>
											
											</span>
										</td>
										<td >
											<span class="textbox" >
											<input type="text" class="textbox-text" name="itemNameAlt2" id="r_itemNameAlt2" readonly></input>
											</span>
										</td>
						            </tr>
						            <tr>
										<th><span data-item="LAB_034">* 규격</span></th>
										<td>
											<span class="textbox">
											<input type="text" class="textbox-text" name="itemSpec2" id="r_itemSpec2" readonly></input>
											</span>
										</td>
										<th><span data-item="LAB_035"> 재질</span></th>
										<td>
											<span class="textbox">
											<input type="text" class="textbox-text" name="itemMaterial2" id="r_itemMaterial2" readonly></input>
											</span>
										</td>
										
						            </tr>
						            <tr>
										<th><span data-item="LAB_034">금형</span></th>
										<td>
											<span class="textbox">
											<input type="text" class="textbox-text" name="moldNo" id="r_moldNo" ></input>
											</span>
										</td>
										<th><span data-item="LAB_035">공장</span></th>
										<td>
											<select class="easyui-combobox" name="factory" ID="r_factory" data-options="width:100">
											<c:forEach var="item" items="${result}">
												<c:if test="${item.CODE_GRUP eq 'STRG_TYPE' }">
												<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
												</c:if>
											</c:forEach>
											</select>		
										</td>
										
						            </tr>
						           <tr>
										<th><span data-item="LAB_036">속성</span></th>
										<td colspan="3">
											<input type="checkbox" name="checkProdType" id='01' value="01" style='width:20px !important'/><label for='01' style="margin-bottom:0"  data-item="LAB_037" >특별특성</label>
											<input type="checkbox" name="checkProdType" id='02' value="02" style='width:20px !important'/><label for='02' style="margin-bottom:0"  data-item="LAB_038">사내구분</label>
											<input type="checkbox" name="checkProdType" id='03' value="03" style='width:20px !important'/><label for='03' style="margin-bottom:0"  data-item="LAB_039">사상여부</label>
											<input type="checkbox" name="checkProdType" id='04' value="04" style='width:20px !important'/><label for='04' style="margin-bottom:0"  data-item="LAB_040">외주검사</label><br>
											<input type="checkbox" name="checkProdType" id='05' value="05" style='width:20px !important'/><label for='05' style="margin-bottom:0"  data-item="LAB_041" >품질검사</label>
											<input type="checkbox" name="checkProdType" id='06' value="06" style='width:20px !important'/><label for='06' style="margin-bottom:0"  data-item="LAB_042">개발검사</label>
											<input type="checkbox" name="checkProdType" id='07' value="07" style='width:20px !important'/><label for='07' style="margin-bottom:0"  data-item="LAB_043">컷팅구분</label>
											<input type="checkbox" name="checkProdType" id='08' value="08" style='width:20px !important'/><label for='08' style="margin-bottom:0"  data-item="LAB_044">포장구분</label>
											<input type='textbox' name="prodType" id="r_prodType" style='visibility: hidden;display:none;'/>
										</td>
						            </tr>
						        </table>
					    	</fieldset>
					    </form>
					</div>
						
				</div>
				<!-- - 생산정보 탭 끝 -->
				
				
				</div>				
			
	<!-- [EAST] end -->
	</div>		
			
<!-- [LAYOUT] end -->
</div>










<!-- 상품조회 -->
<div id="item-search-dialog" class="wui-dialog" style="border-top-width:1px;display:none">
	<table id="search-item-grid">
		<thead>
			<tr>
				<th data-options="field:'itemCode', halign:'center', align:'center', width:100, data_item:'GRD_006'">품목코드</th>
				<th data-options="field:'itemName', halign:'center', width:120, data_item:'GRD_007'">품명</th>
				<th data-options="field:'itemMaterial', halign:'center', align:'left', width:80, data_item:'GRD_008'">재질</th>
				<th data-options="field:'itemSpec', halign:'center', align:'left', width:120, data_item:'GRD_008'">규격</th>				
				<th data-options="field:'itemQty',  halign:'center', align:'right',  width:105, data_item:'GRD_009', hidden:true" style="text-align: right">수량</th>
				<th data-options="field:'itemUnit', halign:'center', align:'center', width:40, data_item:'GRD_010'">단위</th>
				<th data-options="field:'salePrce', halign:'center', align:'center', hidden:true, data_item:'GRD_011'">판매가</th>
				<th data-options="field:'itemAlt',  halign:'center', align:'center', hidden:true, data_item:'GRD_012'">약식명</th>
			</tr>
		</thead>
	</table>


	<!-- fieldset 구분 변경  20160928 박소현 -->
	<div id="search-item-toolbar" class="wui-toolbar">
		<form id="search-item-form">
			<fieldset class="div-line-new" style="text-align:center;">
		        <table cellpadding="5" class="search-table tableSearch-c" style="display:inline-block;">
		            <tr>
						<th class="h table-Search-h" data-item = 'LAB_026'><span>품목코드</span></th>
						<td class="d">
							<input class="easyui-textbox" name="pItemCode" id="pItemCode" style="width:150px"/>							
						</td>						
						
						<th class="h table-Search-h" data-item = 'LAB_026'><span>품명 </span></th>
						<td class="d">
							<input class="easyui-textbox" name="pItemName" id="pItemName" style="width:150px"/>
							<input type="hidden" name="pItemSearchType" id="pItemSearchType" value="0" />
						</td>
						<td class="b">
							<a href="javascript:void(0)" id="search-item-pop-button" class="easyui-linkbutton cgray" data-item = 'BTN_007'>검색</a>
						</td>
					<tr>
						<th class="h table-Search-h" data-item = 'LAB_027'><span>재질 </span></th>
						<td class="d">
							<input class="easyui-textbox" name="pItemMaterial" id="pItemMaterial" style="width:150px"/>
						</td>
						<th class="h table-Search-h" data-item = 'LAB_027'><span>규격 </span></th>
						<td class="d">
							<input class="easyui-textbox" name="pItemSpec" id="pItemSpec" style="width:150px"/>
						</td>
						
						<!-- <th><span data-item = 'LAB_028'>1차 구분명</span></th>
						<td class="d">
				            <input class="easyui-combobox" name="searchitemType1_2" ID="searchitemType1_2"  data-options="width:150,mode:'remote',loader:jcombo.loader,params:{codeGrup:'ITEM_TYPE1'},onChange: selectItemTypePop"/></div>
						</td>
						<th><span data-item = 'LAB_029'>2차 구분명</span></th>
						<td class="d">
							<select class="easyui-combobox" name="searchitemType2_2" ID="searchitemType2_2" data-options="width:150"></select></div>
						</td> -->
					</tr>
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
					<th class="h"><span>출력코드</span></th>
					<td class="d" >
						<input class="easyui-textbox" name="PbarcodeNo" id="PbarcodeNo" value=""  style="width:130px;" data-options="readonly:true"/>
					</td>
				</tr>
				<tr>
					<th class="h"><span>출력위치</span></th>
					<td class="d" >
						<input class="easyui-numberbox" name="PprintPos" id="PprintPos" value=""  style="width:130px"/>
					</td>
				</tr>
				<tr>
					<th class="h"><span>수량</span></th>
					<td class="d" >
						<input class="easyui-numberbox" name="PlimitNo" id="PlimitNo" value=""  style="width:130px"/>
					</td>
				</tr>

			</table>
	   </fieldset>

	        <!-- <div class="div-line-new"></div>  -->
	    <fieldset class="div-line-new-sub" >
	        <table cellpadding="5" class="search-table tableEtc-c" style="margin-left:55px !important;">
	            <tr>
					<td class="h" >
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
