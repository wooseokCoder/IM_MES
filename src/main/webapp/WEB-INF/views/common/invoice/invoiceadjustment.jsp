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
<%@ page import="java.util.*, java.text.*"  %>

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

<%
	 java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
	 String today = formatter.format(new java.util.Date());
 %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/invoice/invoiceadjustment.js?v=251110" />"></script>
<style>
#account-layout{min-width:1200px !important;}
.search-label-h2 {
    width: 128px;
}
table.search-table td.d {
    padding-right: 20px;
}
#menu-button, #menu-button .l-btn-text { width: 100px; height: 32px;}
#excel-button3, #excel-button3 .l-btn-text { width: 218px; text-align: left; border-radius:0px;}
#excel-button3 .l-btn-text, #excel-button4 .l-btn-text { padding-left: 25px;} 
.menu{border-style:none;}
.menu-line {
   border-left: none; 
   border-right: none; 
}
.tableEtc-c {padding-left: 0px;}
input{ line-height: 18px;}
.company-info-table td{ width: 100%; }
.datagrid-btable tbody tr { cursor: pointer; }
#excel-button, #excel-button .l-btn-text { width: 130px;}
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
    <table id="search-grid">
       	<thead data-options="frozen:true">
			<tr>
				<th data-options="field:'ck',           halign:'center', checkbox:true, align:'center'"></th> 
				<th data-options="field:'ordrNo',     halign:'center', width:100, align:'center',data_item:'GRD_001', sortable:true, styler:cellStyler">Order No</th>
				<th data-options="field:'itemType',   halign:'center', width:50, align:'center', data_item:'GRD_002', sortable:true">Type</th>
				<th data-options="field:'itemCode',   halign:'center', width:80, align:'center',data_item:'GRD_003', sortable:true">Item Code</th>
				<th data-options="field:'itemName',   halign:'center', width:250, align:'left', data_item:'GRD_004', sortable:true">Item Name</th>
				<th data-options="field:'shipSeriNo', halign:'center', width:100, align:'center', data_item:'GRD_005', sortable:true">Ship Serial No</th>
				<th data-options="field:'vinNo', 	  halign:'center', width:150, align:'center', data_item:'GRD_005', sortable:true">VIN No</th>
            </tr>
        </thead>
       	<thead>
       		<tr>
       			<th data-options="field:'shipLoc', 		halign:'center', width:60, align:'center', data_item:'GRD_006', sortable:true">Ship W/H</th>
				<th data-options="field:'dealCode', 	halign:'center', width:70, align:'center', data_item:'GRD_007', sortable:true">Dealer</th>
       			<th data-options="field:'bolNo',   		halign:'center', width:100, align:'center',data_item:'GRD_008', sortable:true, styler:cellStyler">BOL No</th>
				<!-- <th data-options="field:'bolStat', 		halign:'center', width:80, align:'center', data_item:'GRD_009', sortable:true">BOL Status</th> -->
				<th data-options="field:'actShipDate', 	halign:'center', width:100, align:'center', data_item:'GRD_010', sortable:true ">Act Ship Date</th>
				<th data-options="field:'shipPostDate', halign:'center', width:100, align:'center', data_item:'GRD_011', sortable:true">Ship Post Date</th>
				<th data-options="field:'ordrNoSap', 	halign:'center', width:100, align:'center', data_item:'GRD_012', sortable:true">Order No(SAP)</th>
				<th data-options="field:'deliNoSap', 	halign:'center', width:100, align:'center', data_item:'GRD_013', sortable:true">Deli. No(SAP)</th>
				<th data-options="field:'invNoWgos', 	halign:'center', width:100, align:'center', data_item:'GRD_014', sortable:true, styler:cellStyler">Inv. No(WGOS)</th>
				<th data-options="field:'eqChkMark', halign:'center', width:80, align:'center', formatter:eqChkMarkFormatter"></th>
				<th data-options="field:'soNoSap',		halign:'center', width:100, align:'center', data_item:'GRD_015', sortable:true, styler:cellStyler2">So No(SAP)</th>
				<th data-options="field:'invNoSap', 	halign:'center', width:100, align:'center', data_item:'GRD_016', sortable:true, styler:cellStyler3">Inv. No(SAP)</th>
				<th data-options="field:'billDateSap',  halign:'center', width:100, align:'center',data_item:'GRD_017', sortable:true, styler:cellStyler2">Bill Date(SAP)</th>
				<th data-options="field:'dealCodeSap',  halign:'center', width:80,  align:'center',data_item:'GRD_003', sortable:true,styler:cellStyler2">Dealer (SAP)</th>
				<th data-options="field:'invWhSap',		halign:'center', width:110, align:'center',data_item:'GRD_018', sortable:true, styler:cellStyler2">Inv. WH(SAP)</th>
				<th data-options="field:'itemCodeSap',		halign:'center', width:100, align:'center', data_item:'GRD_015', sortable:true, styler:cellStyler2">Item Code(SAP)</th>
				<th data-options="field:'shipSeriNoSap',		halign:'center', width:100, align:'center', data_item:'GRD_015', sortable:true, styler:cellStyler2">Serial No(SAP)</th>
				<th data-options="field:'ordrStat',		halign:'center', width:50, align:'center',data_item:'GRD_019', hidden:true">Order State</th>
				<th data-options="field:'eqChk',   	    halign:'center', width:50, align:'center',data_item:'GRD_019', hidden:true"></th>
           </tr>
       </thead>
    </table>
	<div id="search-toolbar" class="wui-toolbar">
		<form id="search-form">
			<fieldset class="Remake-div-line-new">
		        <table cellpadding="7" class="search-table tableSearch-c wd-100">
		        	<colgroup>
		        		<col width="7%" style="min-width: 120px;" />
		        		<col width="18%" style="min-width: 150px;" />
		        		<col width="14%" style="min-width: 150px;" />
		        		<col width="18%" style="min-width: 150px;" />
		        		<col width="*" style="min-width: 200px;" />
		        	</colgroup>
		        	<tr class="topnav_sty">
		        		<td colspan="5">
		        			<div>
		        				<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
		        				<div>
		        					<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="">Search</a>
		        					<a href="javascript:void(0)" style="width: 80px;" id="clear-button" class="easyui-linkbutton btn-clear" data-item="BTN_002" data-options="">Clear</a>
		                           <a href="javascript:void(0)" id="updown-button" class="easyui-linkbutton c12">
		                            	<img id="arrow-icon" class="fa-rotate-180" src="<%=request.getContextPath() %>/resources/images/icon_new/arrowdown.png" />
		                        	</a>
		        				</div>
		        			</div>
		        		</td>
		        	</tr>
		        	<tr>
		        		<th class="h table-Search-h search-label-h2"><span data-item="LAB_001">Status</span></th>
						<td colspan="3" class="chk-label">
							<input style="display:inline-block;width:10px;" type="radio" name="ordrStat" id="ordrStat_550" value="550" checked onchange="doSearch();" />
							<label for="ordrStat_550" style="font-weight:600;font-size:11px;" data-item="LAB_013">Shipped</label>
							
							<input style="display:inline-block;width:10px;" type="radio" name="ordrStat" id="ordrStat_600" value="600" onchange="doSearch();" />
							<label for="ordrStat_600" style="font-weight:600;font-size:11px;" data-item="LAB_014">Complete</label>
						</td>
						<td class="b"></td>
		        	</tr>
		        	<tr>
			        	<th class="h table-Search-h search-label-h2"><span data-item="LAB_002">PO No.</span></th>
						<td class="d">
							<input class="easyui-textbox textbox-list" name="ordrNo" id="ordrNo" value="" style="width: 120px; height: 26px;"/>
						</td>
		        		<th class="h table-Search-h selectdate" style="min-width: 145px;">
		        			<div id="selectDateForm1" style="display:none">
			        			<select class="easyui-combobox" name="selectDate" ID="selectDate" data-options="width:130, height: 26,panelHeight:'auto'">
									<option value="act">Actual Ship Date</option>
									<option value="post">Ship Post Date</option>
								</select>
		        			</div>
		            	</th>
						<td class="d" style="min-width: 290px;">
							<div id="selectDateForm2" style="display:none">
								<input type="hidden" value="${nowFr}" id="date1"/>
								<input type="hidden" value="${nowTo}" id="date2"/>
								<div style="display: flex; align-items: center;">
									<input class="easyui-datebox datebox-f combo-f textbox-f date-L" value="${nowFr}" style="" textboxname="shipDateFr" comboname="shipDateFr" id="shipDateFr" name="shipDateFr"/>
									<input class="easyui-datebox datebox-f combo-f textbox-f date-R" value="${nowTo}" style="" textboxname="shipDateTo" comboname="shipDateTo" id="shipDateTo" name="shipDateTo"/>
								</div>
							</div>
						</td>
						<td class="b"></td>
		        	</tr>
		        </table>
		    </fieldset>
		    <fieldset class="div-line-new-sub grd-div-btn">
	            <table cellpadding="7" class="search-table tableEtc-c wd-100">
	                <tr>
	                    <td class="h">
	                    	<div class="dis_flex_gap4">
	                            <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_005">
	                            	Excel Download&nbsp;
									<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/excel_download.png" />
								</a>
	                            <a href="javascript:void(0)" style="width: 130px;" class="easyui-linkbutton c6" id="update-stat-button"  data-item="BTN_005" data-options="disabled:${UPD}" >Change to complete</a>
				    			<a href="javascript:void(0)" style="width: 130px;" class="easyui-linkbutton c6" id="update-inv-button" data-item="BTN_006" data-options="disabled:${UPD}">Update Invoice</a>
	                    	</div>
	                    </td>
	                </tr>
	            </table>
	        </fieldset>
	    </form>
	</div>
<!-- [LAYOUT] end -->
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


<!-- 수정 팝업 -->
<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px; display:none;">
<div class="panel datagrid easyui-fluid">
    <form id="update-form">
    <input type="hidden" id="r_oper" name="oper" value="I" />
		<fieldset class="div-line-new-sub" >
			<div class="popup-table-alignCenter">
				<table class="popup-search-table">
					<tr>
						<th class="h"><span data-item="LAB_003">Order No</span></th>
						<td class="d">
							<input class="easyui-textbox" name="ordrNo" id="r_ordrNo" value="" style="width:150px"/>
						</td>
						<th class="h"><span data-item="LAB_004">Item Code</span></th>
						<td class="d">
							<input class="easyui-textbox" name="r_itemCode" id="r_itemCode" value="" style="width:150px"/>
						</td>
						<!-- <th class="h"><span data-item="LAB_004">Item Type</span></th>
						<td class="d">
							<input class="easyui-textbox" name="itemType" id="r_itemType" value="" style="width:150px"/>
						</td> -->
						
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_005">Ship Serial No</span></th>
						<td class="d">
							<input class="easyui-textbox" name="shipSeriNo" id="r_shipSeriNo" value="" style="width:150px"/>
						</td>
						
						<th class="h"><span data-item="LAB_005">VIN No</span></th>
						<td class="d">
							<input class="easyui-textbox" name="vinNo" id="r_vinNo" value="" style="width:150px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_006">Item Name</span></th>
						<td class="d" colspan="3">
							<input class="easyui-textbox" name="r_itemName" id="r_itemName" value="" style="width:410px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_007">Dealer Code</span></th>
						<td class="d">
							<input class="easyui-textbox" name="dealCode" id="r_dealCode" value="" style="width:150px"/>
						</td>
						<th class="h"><span data-item="LAB_008">Ship W/H</span></th>
						<td class="d">
							<input class="easyui-textbox" name="shipLoc" id="r_shipLoc" value="" style="width:150px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_009">Dealer Name</span></th>
						<td class="d" colspan="3">
							<input class="easyui-textbox" name="dealName" id="r_dealName" value="" style="width:410px"/>
						</td>
					</tr>
					
					<tr>
						<th class="h"><span data-item="LAB_010">Act Ship Date</span></th>
						<td class="d">
							<input class="easyui-textbox" name="actShipDate" id="r_actShipDate" value="" style="width:150px"/>
						</td>
						<th class="h"><span data-item="LAB_011">Ship Post Date</span></th>
						<td class="d">
							<input class="easyui-textbox" name="shipPostDate" id="r_shipPostDate" value="" style="width:150px"/>
						</td>
					</tr>
					
					<tr style="border-bottom-style:inset;border-bottom-color:#00000;border-bottom-width:2px;"><td style="height:1px;"></td><td style="height:1px;"></td></tr>
					
					<tr>
						<th class="h" colspan="2" style="text-align:center;padding:5px"><span data-item="LAB_100">Order</span></th>
						<th class="h" colspan="2" style="text-align:center;padding:5px"><span data-item="LAB_200">Invoice</span></th>
					</tr>
					
					<tr>
						<th class="h"><span data-item="LAB_012">Order No (SAP)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="ordrNoSap" id="r_ordrNoSap" value="" style="width:150px"/>
						</td>
						<th class="h"><span data-item="LAB_013">SO NO</span></th>
						<td class="d">
							<input class="easyui-textbox" name="soNoSap" id="r_soNoSap" value="" style="width:150px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_014">Deli No (SAP)</span></th>
						<td class="d" colspan="3">
							<input class="easyui-textbox" name="deliNoSap" id="r_deliNoSap" value="" style="width:150px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_015">Invoice No (SAP)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="invNoWgos" id="r_invNoWgos" value="" style="width:150px"/>
						</td>
						<th class="h"><span data-item="LAB_016">Invoice No</span></th>
						<td class="d">
							<input class="easyui-textbox" name="invNoSap" id="r_invNoSap" value="" style="width:150px"/>
						</td>
					</tr>
					
					<tr>
						<td style="color:#ff3a00; vertical-align: top; text-align: left;">* Reason :</td>
						<td class="d" colspan="3">
							<textarea rows="3" cols="30"  name="invChgRemk" id="r_invChgRemk" style="width: 400px; margin-top: 2px;"></textarea>
							<input type="hidden" id="r_ordrStat" name="r_ordrStat" value="" />
						</td>
					</tr>
					
					<!-- <tr>
						<th class="h"><span data-item="LAB_012">BOL No(SAP)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="bolNo" id="r_bolNo" value="" style="width:150px"/>
						</td>
						<th class="h"><span data-item="LAB_013">BOL Status</span></th>
						<td class="d">
							<input class="easyui-textbox" name="bolStat" id="r_bolStat" value="" style="width:150px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_018">Billing Date(SAP)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="billDateSap" id="r_billDateSap" value="" style="width:150px"/>
						</td>
						<th class="h"><span data-item="LAB_019">Sales Order No.(SAP)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="soNoSap" id="r_soNoSap" value="" style="width:150px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_020">Invoice Ware House(SAP)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="invWhSap" id="r_invWhSap" value="" style="width:150px"/>
						</td>
					</tr>
					
					<tr>
						<th class="h"><span data-item="LAB_010">Order No(SAP)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="ordrNoSap" id="r_ordrNoSap" value="" style="width:150px"/>
						</td>
						<th class="h"><span data-item="LAB_011">Deli No(SAP)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="deliNoSap" id="r_deliNoSap" value="" style="width:150px"/>
						</td>
					</tr>
					
					<tr>
						<th class="h"><span data-item="LAB_016">Invoice File Info</span></th>
						<td class="d">
							<input class="easyui-textbox" name="invNoWgos" id="r_invNoWgos" value="" style="width:150px"/>
						</td>
						<th class="h"><span data-item="LAB_017">Invoice No.(SAP)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="invNoSap" id="r_invNoSap" value="" style="width:150px"/>
						</td>
					</tr> -->
					
		            <tr style="border-bottom-style:dashed; border-bottom-color:#00000;border-bottom-width:2px;"><td style="height:10px;"></td><td style="height:10px;"></td></tr>
		            
		            <tr>
						<td class="d popup-table-alignCenter" style="padding-top: 15px;" colspan="4">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_006" data-options="disabled:${INS}" >Save</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="cl-btn" data-item="BTN_007">Close</a>
						</td>
		            </tr>
		        </table>
			</div>
		</fieldset>
	</form>
</div>
</div>
</html>
