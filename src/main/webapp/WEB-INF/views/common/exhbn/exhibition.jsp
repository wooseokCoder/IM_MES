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
<%-- 코드관리 화면이다.                                                       		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/exhbn/exhibition.js?v=0626A" />"></script>

<style>
#report-button-pdf .l-btn-text{
	width: 100px;
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

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

<table id="search-grid">
	<thead data-options="frozen:true">
		<tr>
			<th data-options="field:'seq'      , halign:'center', width:150, hidden:true, data_item:'GRD_000'">SEQ</th>
			<th data-options="field:'exhbnCode', halign:'center', width:170, editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_001'">Promotion Code (Max. 20)</th>
			<th data-options="field:'exhbnYear', align:'center', halign:'center', width:80 , editor:{type:'validatebox', type:'numberbox'}, sortable:true,data_item:'GRD_002'">Year</th>
			<th data-options="field:'exhbnName', halign:'center', width:350, editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_003'">Name</th>
		</tr>
	</thead>
	<thead>
		<tr>
			<th data-options="field:'exhbnBgnDate', halign:'center',width:120, align:'center', editor:{type:'datebox'},data_item:'GRD_004'">Begin Date</th>
			<th data-options="field:'exhbnEndDate', halign:'center',width:120, align:'center', editor:{type:'datebox'},data_item:'GRD_005'">Complete Date</th>
			<th data-options="field:'exhbnLoc',     halign:'center',width: 80, align:'center', editor:{type:'validatebox'},data_item:'GRD_006'">Location</th>
			<th data-options="field:'maxNum',       halign:'center',width: 80, align:'center', editor:{type:'validatebox', type:'numberbox'},data_item:'GRD_007'">Max number</th>			
			<!-- <th data-options="field:'fileName',     halign:'center',width: 80, align:'center', data_item:'GRD_008'">File name</th> -->
			<th data-options="field:'useFlag',     halign:'center',width: 80, editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.yesno, align:'center',data_item:'GRD_009'" formatter="formatCheck">Coupon</th>
			<th data-options="field:'activeYn',     halign:'center',width: 80, editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.useflag, align:'center',data_item:'GRD_009'" formatter="formatCheck">Active</th>
			<!-- <th data-options="field:'useFlag',   	halign:'center', width:50, align:'center', editor:{type:'validatebox'}, data_item:'GRD_033', sortable:true">Coupon</th>
			<th data-options="field:'activeYn',   	halign:'center', width:50, align:'center', editor:{type:'validatebox'}, data_item:'GRD_033', sortable:true">Active</th>-->
			 <th data-options="field:'regiId',       halign:'center',width: 80, align:'center', data_item:'GRD_010'">Regi ID</th>
			<th data-options="field:'regiDate',     halign:'center',width:140, align:'center', data_item:'GRD_011'">Regi Date</th>
			<th data-options="field:'chngId',       halign:'center',width: 80, align:'center', data_item:'GRD_012'">Chng ID</th>
			<th data-options="field:'chngDate',     halign:'center',width:140, align:'center', data_item:'GRD_013'">Chng Date</th>
		</tr>
	</thead>
</table>

<!-- fieldset 구분 변경  20160928 박소현 -->
<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<fieldset class="Remake-div-line-new" >
            <table cellpadding="4" class="search-table tableSearch-c wd-100" >
            	<colgroup>
            		<col width="10%" style="min-width: 80px;" />
            		<col width="15%" style="min-width: 110px;" />
            		<col width="10%" style="min-width: 80px;" />
            		<col width="15%" style="min-width: 110px;" />
            		<col width="10%" style="min-width: 80px;" />
            		<col width="15%" style="min-width: 110px;" />
            		<col width="10%" style="min-width: 80px;" />
            		<col width="15%" style="min-width: 110px;" />
            	</colgroup>
				
				<tr class="topnav_sty">
            		<td colspan="8" >
            			<div>
	            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
	            			<div>
		                        <a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}">Search</a>
		                        <input type="hidden" name="sortValue" id="sortValue" value=""/>
	                        </div>
                        </div>
            		</td>
            	</tr>
            	
	            <tr>
					<%-- <th class="h table-Search-h-right search-label-h" data-item="LAB_001"><span>Code Group </span></th>
					<td class="d">
						<select class="easyui-combobox" name="codeGrup" ID="s_codeGrup" data-options="width:180">
							<option value="ALL">ALL</option>
							<c:forEach var="selectCode" items="${selectCode}">
								<option value="${selectCode.codeCd}" >${selectCode.codeName}</option>
							</c:forEach>
							<option value="0" selected>Code Group</option>
						</select>
					</td> --%>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_001"><span>Promotion Code</span></th>
					<td class="d">
						<input class="easyui-textbox" name="exhbnCode" id="s_exhbnCode"  data-options="width:180"/>
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_002"><span>Year</span></th>
					<td class="d">
						<input class="easyui-textbox" name="exhbnYear" id="s_exhbnYear"  data-options="width:180"/>
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_003"><span>Active</span></th>
					<td class="d">
						<select class="easyui-combobox" name="exhbnActive" ID="s_exhbnActive" data-options="width:50,panelHeight:'auto'">
							<option value="">ALL</option>
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</td>
					<%-- <td class="b">
						<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}">Search</a>
						<input type="hidden" name="sortValue" id="sortValue" value=""/>
					</td> --%>
	            </tr>
	        </table>
	   </fieldset>
	        <!-- <div class="div-line-new"></div>  -->
	    <fieldset class="div-line-new-sub grd-div-btn">
	            <table cellpadding="5" class="search-table tableEtc-c wd-100" >
	                <tr>
	                    <td class="h">
	                    	<div class="dis_flex_gap4" >
								<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}" >Add</a>
								<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}" >Del</a>
						    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_004" data-options="disabled:${UPD}" >Save</a>
						    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="img-button"  data-item="BTN_005" data-options="disabled:${UPD}" >Image File</a>
					    	</div>
					</td>
	            </tr>
	        </table>
	        <!--  <div class="div-line"></div> -->
		</fieldset>
	</form>
</div>

</div>

<!-- 정렬팝업창 -->
<div id="sort-dialog" class="wui-dialog" style="border-top-width:1px;display:none">
	<div id = "sort-div" class="sortlistLeft">
	</div>
	<div class="sortmove">
		<img onclick="javascript:doMove('right')" src="<c:url value="/resources/images/addr_right-arrow.jpg" />" style="width:26px; cursor: pointer;"><br/><br/>
		<img onclick="javascript:doMove('left')" src="<c:url value="/resources/images/addr_left-arrow.jpg" />" style="width:26px; cursor: pointer;">
	</div>
	<div id = "sort-order" class="sortlistRight">
		<ul class="sortul">
		</ul>
	</div>
	<div class="dialog-button">
		<input type="checkbox" id="moveChk" onClick="javascript:doSortCookie()"/><label for="moveChk" data-item="LAB_004">Save for one day</label>
	</div>
	<!-- <div class="dialog-button">
			<a href="javascript:void(0)" id="popup-close-button" class="easyui-linkbutton c6" style="margin-left: 10px">닫기</a>
	</div> -->
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

<!-- 등록화면 -->
<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;">
	<form id="search-create-form">
				<input type="hidden" id="cOper" name="oper" value="I" />
		<fieldset class="div-line-new-sub" style="padding-left: 0px;">
			<div class="popup-table-alignCenter">
				<table class="popup-search-table"> <!--  style="width:100%;" -->
					<tr>
						<td><input type="file" style="width:100%;" name="uploadImg1" id="uploadImg1" onchange="setCanvImg(this.id)" /></td>
					</tr>
					<tr>
						<td style="width:100%; position: relative;"><canvas id="canvas1" style="background-color:aliceblue" width="500" height="375" ></canvas> <!-- onclick = "javascript:popupImage(this.id);" -->
							<span id="imgCloseBtn1" style="position:absolute; top: 0px; right: 10px; font-size: 22px; z-index: 5; display: none;">
								<a href="javascript:deleteImg()"><i class="fa fa-times"></i></a>
							</span>
						</td>
					</tr>
					<tr style="height:5px;">
					</tr>
		            <tr style="border-top-style:inset;border-top-color:#00000;border-top-width:2px;">
						<td class="d popup-table-alignCenter" colspan="2" style="padding-top: 10px;">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-img-button" data-item="BTN_006" data-options="disabled:${UPD}" >Save</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="close-img-button" data-item="BTN_007">Close</a>
						</td>
		            </tr>
		        </table>
			</div>
		</fieldset>
	</form>
</div>

<div id="regist-dialog2" class="wui-dialog" style="border-top-width:1px;">
	<form id="search-create-form2">
		<input type="hidden" id="r_codeGrup2" name="codeGrup" value="" />
		<input type="hidden" id="r_codeCd2" name="codeCd" value="" />
		<fieldset class="div-line-new-sub">
			<div class="popup-table-alignCenter">
				<table class="popup-search-table">
					<tr>
						<th class="h"><span>Ext. 01</span></th>
						<td class="d">
							<input class="easyui-numberbox" name="extNum01" id="r_extNum01" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 02</span></th>
						<td class="d">
							<input class="easyui-numberbox" name="extNum02" id="r_extNum02" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 03</span></th>
						<td class="d">
							<input class="easyui-numberbox" name="extNum03" id="r_extNum03" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 04</span></th>
						<td class="d">
							<input class="easyui-numberbox" name="extNum04" id="r_extNum04" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 05</span></th>
						<td class="d">
							<input class="easyui-numberbox" name="extNum05" id="r_extNum05" value="" style="width:300px"/>
						</td>
					</tr>
					<tr style="height:5px;">
					</tr>
		            <tr style="border-top-style:inset;border-top-color:#00000;border-top-width:2px;">
						<td class="d popup-table-alignCenter" colspan="2" style="padding-top: 10px;">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-create-button2" data-item="BTN_008" data-options="disabled:${UPD}" >Save</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="close-create-button2" data-item="BTN_009">Close</a>
						</td>
		            </tr>
		        </table>
			</div>
		</fieldset>
	</form>
</div>

<!-- 이미지 임시 -->
<div id="temp-popup" style="display:none">
	<canvas id="imgTemp" width="500" height="375"></canvas>
</div>
</html>