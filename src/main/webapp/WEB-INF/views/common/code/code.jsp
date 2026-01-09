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
<script type="text/javascript" src="<c:url value="/resources/js/common/code/code.js?v=0925A" />"></script>

<style>
#report-button-pdf .l-btn-text{
	width: 100px;
}
.search-label-h {width:10%;}
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
			<th data-options="field:'codeCd',   halign:'center', width:100, editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_001'">Code</th>
			<th data-options="field:'codeNameKr', halign:'center', width:150, editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_002'">Code Name</th>
			<th data-options="field:'codeNameEn', halign:'center', width:150, editor:{type:'validatebox',options:{required:true}}, sortable:true,data_item:'GRD_003'">Code Name(En)</th>
			<th data-options="field:'sortSeq',  halign:'center', width:50,  editor:{type:'validatebox',options:{required:true}}, sortable:true, align:'center',data_item:'GRD_004'">Seq</th>
		</tr>
	</thead>
	<thead>
		<tr>
			<th data-options="field:'codeGrup', width:100, editor:{type:'textbox'}"></th>
			<th data-options="field:'useFlag',  halign:'center',width:80,  editor:{type:'checkbox',options:{on:'Y',off:'N'}},formatter:jformat.useflag, align:'center',data_item:'GRD_005'" formatter="formatCheck">Use Flag</th>
			<th data-options="field:'codeDesc', halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_006'">Code Desc</th>
			<th data-options="field:'extChr01', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_007'">문자속성01</th>
			<th data-options="field:'extChr02', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_008'">문자속성02</th>
			<th data-options="field:'extChr03', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_009'">문자속성03</th>
			<th data-options="field:'extChr04', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_010'">문자속성04</th>
			<th data-options="field:'extChr05', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_011'">문자속성05</th>
			<th data-options="field:'extChr06', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_012'">문자속성06</th>
			<th data-options="field:'extChr07', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_013'">문자속성07</th>
			<th data-options="field:'extChr08', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_014'">문자속성08</th>
			<th data-options="field:'extChr09', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_015'">문자속성09</th>
			<th data-options="field:'extChr10', halign:'center',width:100, editor:{type:'validatebox'},data_item:'GRD_016'">문자속성10</th>
			<th data-options="field:'extNum01', halign:'center',width:100, editor:{type:'validatebox'}, align:'right',data_item:'GRD_017'">숫자속성01</th>
			<th data-options="field:'extNum02', halign:'center',width:100, editor:{type:'validatebox'}, align:'right',data_item:'GRD_018'">숫자속성02</th>
			<th data-options="field:'extNum03', halign:'center',width:100, editor:{type:'validatebox'}, align:'right',data_item:'GRD_019'">숫자속성03</th>
			<th data-options="field:'extNum04', halign:'center',width:100, editor:{type:'validatebox'}, align:'right',data_item:'GRD_020'">숫자속성04</th>
			<th data-options="field:'extNum05', halign:'center',width:100, editor:{type:'validatebox'}, align:'right',data_item:'GRD_021'">숫자속성05</th>
			<th data-options="field:'extText' , halign:'center',width:250, editor:{type:'validatebox'},data_item:'GRD_022'">Ext Text</th>
			<th data-options="field:'regiId',   halign:'center',width: 80, align:'center',data_item:'GRD_023'">Regi ID</th>
			<th data-options="field:'regiDate', halign:'center',width:140, align:'center',data_item:'GRD_024'">Regi Date</th>
			<th data-options="field:'chngId',   halign:'center',width: 80, align:'center',data_item:'GRD_025'">Chng ID</th>
			<th data-options="field:'chngDate', halign:'center',width:140, align:'center',data_item:'GRD_026'">Chng Date</th>
		</tr>
	</thead>
</table>

<!-- fieldset 구분 변경  20160928 박소현 -->
<div id="search-toolbar" class="wui-toolbar">
	<form id="search-form">
		<!-- <fieldset class="div-line-new" > -->
		<fieldset class="Remake-div-line-new" >
	        <table cellpadding="7" class="search-table tableSearch-c wd-100" >
	        	<colgroup>
	        		<col width="7%">
	        		<col width="13%">
	        		<col width="7%">
	        		<col width="13%">
	        		<col width="7%">
	        		<col width="13%">
	        		<col width="7%">
	        		<col width="13%">
	        		<col width="7%">
	        		<col width="13%">
	        		<col width="*">
	        	</colgroup>
	        	<tr class="topnav_sty">
            		<td colspan="11" >
            			<div>
	            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
	            			<div>
								<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}">Search</a>
								<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="sort-button"  data-item="BTN_002">Sort</a>
								<input type="hidden" name="sortValue" id="sortValue" value=""/>
	                        </div>
                        </div>
            		</td>
            	</tr>
            	
	            <tr>
					<th class="h table-Search-h search-label-h2" style="min-width: 127px;" data-item="LAB_001"><span>Code Group </span></th>
					<td class="d" style="min-width: 165px;">
						<select class="easyui-combobox" name="codeGrup" ID="s_codeGrup" >
							<option value="ALL">ALL</option>
							<c:forEach var="selectCode" items="${selectCode}">
								<option value="${selectCode.codeCd}" >${selectCode.codeName}</option>
							</c:forEach>
							<option value="0" selected>Code Group</option>
						</select>
					</td>
					<th class="h table-Search-h search-label-h2" style="min-width: 125px;" data-item="LAB_002"><span>Code </span></th>
					<td class="d" style="min-width: 165px;">
						<input class="easyui-textbox" name="codeCd" id="s_codeCd"  />
					</td>
					<th class="h table-Search-h search-label-h2" style="min-width: 100px;" data-item="LAB_003"><span>Code Desc </span></th>
					<td class="d" style="min-width: 165px;">
						<input class="easyui-textbox" name="codeDesc" id="s_codeDesc"  />
					</td>
					<th class="h table-Search-h search-label-h2" style="min-width: 100px;" data-item="LAB_004"><span>Use Flag </span></th>
					<td class="d" style="min-width: 165px;">
						<select class="easyui-combobox" name="useFlag" ID="s_useFlag" data-options="panelHeight:'auto'">
						<option value="ALL">ALL</option>
							<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'USE_FLAG' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
							</c:forEach>
						</select>
					<!-- span class 추가 20160928 박소현 -->
						<!-- <span class="radio-span">
							<input name="useFlag" type="radio" value="Y" id="s_useFlag1"/><label for="s_useFlag1">사용중</label>
							<input name="useFlag" type="radio" value="N" id="s_useFlag2"/><label for="s_useFlag2">중지</label>
						</span> -->
					</td>
					<td class="b w-a" colspan="3" style="text-align: right;">
						<!-- Search/Sort 버튼은 topnav_sty로 이동됨 -->
					</td>
	            </tr>
	        </table>
	   </fieldset>
	        <!-- <div class="div-line-new"></div>  -->
	    <fieldset class="div-line-new-sub grd-div-btn">
	        <table cellpadding="7" class="search-table tableEtc-c wd-100" >
	            <tr>
					<td class="h">
						<div class="dis_flex_gap4" >
							<!-- <a href="javascript:void(0)" class="easyui-linkbutton c8" iconCls="icon-add"    id="append-button">추가</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c8" iconCls="icon-remove" id="remove-button">삭제</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c8" iconCls="icon-save"   id="save-button"  >저장</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c8" iconCls="icon-add"    id="add-button-codeGrup">코드그룹등록</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel"  id="excel-button">엑셀</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-print"  id="report-button-pdf">pdf</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-print"  id="report-button-xls">xls</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-print"  id="report-button-htm">html</a> -->
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_003" data-options="disabled:${INS}" >Add</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_004" data-options="disabled:${DEL}" >Del</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_005" data-options="disabled:${UPD}" >Save</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="extChr-button" data-item="BTN_006" data-options="disabled:${UPD}">Extension</a>
						    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="extNum-button" data-item="BTN_007" data-options="disabled:${UPD},width:90">Extension2</a>
						    <!-- <a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel"  id="excel-button" data-item="BTN_008">Excel Download</a> -->
						    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_008">
						    	Excel Download&nbsp;
						    	<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/excel_download.png" />
						    </a>
						    <!-- <a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-print"  id="report-button-pdf" data-item="BTN_009" >Print</a> -->
						    <a href="javascript:void(0)" class="easyui-linkbutton c4"  id="report-button-pdf" data-item="BTN_009" >
						    	Print&nbsp;
		                		<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/print.png" />
		                	</a>
						    <!-- <a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_008">Clear</a> -->
							<!-- <a href="javascript:void(0)" class="easyui-linkbutton c8" id="add-button-codeGrup" style="width:110px;">코드그룹등록</a> -->
							<!-- <a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-print"  id="report-button-xls">XML</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-print"  id="report-button-htm">HTML</a> -->
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
		<div class="center_div">
			<div class="centerImg" style="">
	   			<a href="javascript:void(0)" onclick="javascript:doMove('right')">
	   				<img class="trs_180" src="<c:url value="/resources/images/icon_new/fa-solid_angle-right.png" />" ></img>
	   			</a>
	   		</div>
			<div class="centerImg" style="margin-top: 16px;">
	   			<a href="javascript:void(0)" onclick="javascript:doMove('left')">
	   				<img src="<c:url value="/resources/images/icon_new/fa-solid_angle-right.png" />" ></img>
	   			</a>
	  		</div>
  		</div>
		<%-- <img onclick="javascript:doMove('right')" src="<c:url value="/resources/images/addr_right-arrow.jpg" />" style="width:26px; cursor: pointer;"><br/><br/>
		<img onclick="javascript:doMove('left')" src="<c:url value="/resources/images/addr_left-arrow.jpg" />" style="width:26px; cursor: pointer;"> --%>
	</div>
	<div id = "sort-order" class="sortlistRight">
		<ul class="sortul">
		</ul>
	</div>
	<div class="dialog-button">
		<input type="checkbox" id="moveChk" onClick="javascript:doSortCookie()"/><label for="moveChk" data-item="LAB_005">Save for one day</label>
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
		<input type="hidden" id="r_codeGrup" name="codeGrup" value="" />
		<input type="hidden" id="r_codeCd" name="codeCd" value="" />
		<fieldset class="div-line-new-sub">
			<div class="popup-table-alignCenter">
				<table class="popup-search-table">
					<tr>
						<th class="h"><span>Ext. 01</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr01" id="r_extChr01" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 02</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr02" id="r_extChr02" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 03</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr03" id="r_extChr03" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 04</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr04" id="r_extChr04" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 05</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr05" id="r_extChr05" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 06</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr06" id="r_extChr06" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 07</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr07" id="r_extChr07" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 08</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr08" id="r_extChr08" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 09</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr09" id="r_extChr09" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span>Ext. 10</span></th>
						<td class="d">
							<input class="easyui-textbox" name="extChr10" id="r_extChr10" value="" style="width:300px"/>
						</td>
					</tr>
					<tr style="height:5px;">
					</tr>
		            <tr style="border-top-style:inset;border-top-color:#00000;border-top-width:2px;">
						<td class="d popup-table-alignCenter" colspan="2" style="padding-top: 10px;">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-create-button" data-item="BTN_010" data-options="disabled:${UPD}" >Save</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="close-create-button" data-item="BTN_011">Close</a>
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
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-create-button2" data-item="BTN_012" data-options="disabled:${UPD}" >Save</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="close-create-button2" data-item="BTN_013">Close</a>
						</td>
		            </tr>
		        </table>
			</div>
		</fieldset>
	</form>
</div>
</html>