<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)user.jsp 1.0 2014/08/12                                            --%>
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
<%-- 사용자관리 화면이다.                                                      		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
	#excel-button, #excel-button .l-btn-text { width: 130px;}
	.search-label-h { width: 10% !important; }
	.dialog-button {
    padding: 5px;
    text-align: center !important;
}
#report-button-pdf .l-btn-text{
	width: 100px;
}
</style>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user2/user2.js?v=251111a" />"></script>
<script type="text/javascript">
	 doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
</script>
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

	<thead  data-options="frozen:true">
		<tr>
			<th data-options="field:'userId',   width: 80, halign:'center', align:'center', editor:{type:'validatebox', options:{required:true}}, sortable:true,data_item:'GRD_001', sortable:true">User ID</th>
			<th data-options="field:'userName', width:100, halign:'center', align:'center', editor:{type:'validatebox', options:{required:true}}, sortable:true,data_item:'GRD_002', sortable:true">User Name</th>
		</tr>
	</thead>
	
	<thead>
		<tr>
			<th data-options="field:'deptName',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_003', hidden:true"  >부서명</th>
			<th data-options="field:'deptCode',   width: 100, halign:'center', align:'center',editor:consts.combo.incomeDept.editor(),formatter:consts.combo.incomeDept.formatter(),sortable:true,data_item:'GRD_004'">Dept Name</th>
			<th data-options="field:'userType', 	 width: 70, halign:'center', align:'center', editor:consts.combo.userType.editor(),formatter:consts.combo.userType.formatter(),data_item:'GRD_005', sortable:true">User Type</th>
			<th data-options="field:'upprDeptCode',  width:100, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_006', hidden:true">Uppr Dept</th>
			<th data-options="field:'orgAuthCode',   width:100, halign:'center', align:'center', editor:consts.combo.orgAuthCode.editor(),formatter:consts.combo.orgAuthCode.formatter(),data_item:'GRD_007'">Org Auth</th>
			<th data-options="field:'spcAuthCode',   width: 100, halign:'center', align:'center',editor:'text',editor:{type:'popupbox',options:{editable:true,onOpen:doOpenPopup}},data_item:'GRD_008'">Spc Auth</th>
			<th data-options="field:'menuSet',   width:100, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_009'">Root Menu</th>
			<th data-options="field:'menuType', 	 width: 70, halign:'center', align:'center', editor:consts.combo.menuType.editor(),formatter:consts.combo.menuType.formatter(),data_item:'GRD_010'">Menu Type</th>
			<th data-options="field:'dashType', 	 width: 70, halign:'center', align:'center', editor:consts.combo.dashType.editor(),formatter:consts.combo.dashType.formatter(),data_item:'GRD_010'">Dash Type</th>
			<th data-options="field:'mobileType', 	 width: 80, halign:'center', align:'center', editor:consts.combo.mobileType.editor(),formatter:consts.combo.mobileType.formatter(),data_item:'GRD_011', hidden:true">Mobile Type</th>
			<th data-options="field:'userTel',       width:120, halign:'center', align:'center', editor:{type:'textbox'}, data_item:'GRD_012', sortable:true"  >Tel</th>
			<th data-options="field:'userMail',      width:150, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_013', sortable:true"  >Email</th>
			<th data-options="field:'saleGrup',      width:100, halign:'center', align:'center', editor:consts.combo.saleGrup.editor(),formatter:consts.combo.saleGrup.formatter(),data_item:'GRD_014', sortable:true"  >Sale Grup</th>
			<th data-options="field:'regnMagr',      width:120, halign:'center', align:'center', editor:consts.combo.userBm.editor(),formatter:consts.combo.userBm.formatter(),data_item:'GRD_015', sortable:true"  >Regional Manager</th>
			<th data-options="field:'regnGb',        width:120, halign:'center', align:'center', editor:consts.combo.regnGb.editor(),formatter:consts.combo.regnGb.formatter(),data_item:'GRD_016', sortable:true"  >Region</th>
			<th data-options="field:'applList',      width: 100, halign:'center', align:'center',editor:'text',editor:{type:'popupbox',options:{editable:true,onOpen:doOpenListPopup}},data_item:'GRD_044'">Appl List</th>
			<th data-options="field:'shipLoc',       width:100, halign:'center', align:'center', editor:consts.combo.shipLoc.editor(),formatter:consts.combo.shipLoc.formatter(),data_item:'GRD_017', sortable:true"  >Shipping W/H</th>
<!--			<th data-options="field:'idLspo',        width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_018', sortable:true"  >ID LSPO</th>
			<th data-options="field:'idLws',         width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_019', sortable:true"  >ID LWS</th>   -->
			<th data-options="field:'idMerc',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_020', sortable:true"  >ID MERC</th>
			<th data-options="field:'idServ',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_021', sortable:true"  >ID SERV</th>
			<th data-options="field:'idWgbc',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_022', sortable:true"  >ID WGBC</th>
            <th data-options="field:'idMts',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_023', sortable:true"  >ID MTS</th>
            <th data-options="field:'idAcb',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >ID ACB</th>
            <th data-options="field:'idSproutLoud',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >ID SPROUTLOUD</th>
<!--             <th data-options="field:'type',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >SproutLoud Type</th>
            <th data-options="field:'FirstName',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >First Name </th>
            <th data-options="field:'LastName',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >Last Name</th>
            <th data-options="field:'userAddress1',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >User Address1</th>
            <th data-options="field:'userCity',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >User City</th>
            <th data-options="field:'userRegnCode',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >User Regn Code</th>
            <th data-options="field:'userPostCode',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >User Post Code</th>
            <th data-options="field:'tpAccountId',      width:100, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_024', sortable:true"  >Tp Account ID</th>     -->                   
			<th data-options="field:'createMailFlag', width:150, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_025', sortable:true"  >Create Mail Flag</th>
			<th data-options="field:'reviewMailFlag', width:150, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_026', sortable:true"  >Review Mail Flag</th>
			<th data-options="field:'confMailFlag',   width:150, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_027', sortable:true"  >Confirm Mail Flag</th>
			<th data-options="field:'readyMailFlag',  width:150, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_028', sortable:true"  >RTS Mail Flag</th>
            <th data-options="field:'shipMailFlag',   width:150, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_029', sortable:true"  >Shipped Mail Flag</th>
            <th data-options="field:'compMailFlag',   width:150, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_030', sortable:true"  >Completed Mail Flag</th>
            <th data-options="field:'returnMailFlag', width:150, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_031', sortable:true"  >Return Mail Flag</th>
            <th data-options="field:'notiAllreadYn', width:150, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_031', sortable:true"  >Noti All Read Flag</th>
            <th data-options="field:'smtpId',      width:100, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_032', sortable:true"  >SMTP ID</th>
            <th data-options="field:'smtpPw',      width:100, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_032', sortable:true"  >SMTP PW</th>
			<th data-options="field:'userRemk',      width:200, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_032', sortable:true"  >Remk</th>
			<th data-options="field:'emplNo',        width:100, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_033', sortable:true">Empl No</th>
			<th data-options="field:'comCode',       width:100, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_034', sortable:true">Company Code</th>
			<th data-options="field:'comName',       width:120, halign:'center', align:'left', editor:{type:'textbox'},data_item:'GRD_035', sortable:true"  >Company Name</th>
			<th data-options="field:'loginFailCnt',  width: 80, halign:'center', align:'center',data_item:'GRD_036', sortable:true">Login Fail Cnt</th>
			<th data-options="field:'pwdChngDate',   width:140, halign:'center', align:'center',data_item:'GRD_037', sortable:true">Pw Chng Date</th>
			<th data-options="field:'lastLoginDate', width:140, halign:'center', align:'center',data_item:'GRD_038', sortable:true">Last Login</th>
			<th data-options="field:'useFlag',       width:60, halign:'center', align:'center', editor:{type:'textbox'},data_item:'GRD_039', sortable:true"  >Use Flag</th>
			<th data-options="field:'regiId',        width: 80, halign:'center', align:'center',data_item:'GRD_040', sortable:true">Regi ID</th>
			<th data-options="field:'regiDate',      width:140, halign:'center', align:'center',data_item:'GRD_041', sortable:true">Regi Date</th>
			<th data-options="field:'chngId',        width: 80, halign:'center', align:'center',data_item:'GRD_042', sortable:true">Chng ID</th>
			<th data-options="field:'chngDate',      width:140, halign:'center', align:'center',data_item:'GRD_043', sortable:true">Chng Date</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
<!-- topnav2 영역 -->
<%-- <div class="topnav_sty" style="background-color: #f0f0f0; border-radius: 5px; padding: 5px 10px; margin-bottom: 10px;">
	<div style="display: flex; justify-content: space-between; align-items: center;">
		<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
		<div>
			<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}" >Search</a>
			<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton btn-clear" id="dreload-button" data-item="BTN_002">Clear</a>
		</div>
	</div>
</div> --%>

<!-- fieldset 변경 20190628 박소현 -->
	<form id="search-form">
		<fieldset  class="Remake-div-line-new">
	        <table cellpadding="5" class="search-table tableSearch-c wd-100" >
	        	<colgroup>
	        		<col width="7%" style="min-width: 120px;" />
	        		<col width="13%" style="min-width: 165px;" />
	        		<col width="7%" style="min-width: 120px;" />
	        		<col width="13%" style="min-width: 165px;" />
	        		<col width="7%" style="min-width: 120px;" />
	        		<col width="13%" style="min-width: 165px;" />
	        		<col width="7%" style="min-width: 120px;" />
	        		<col width="13%" style="min-width: 165px;" />
	        		<col width="*" style="min-width: 120px;" />
	        	</colgroup>
	        	
	        	<tr class="topnav_sty">
            		<td colspan="10" >
            			<div>
	            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
	            			<div>
								<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}" >Search</a>
								<a href="javascript:void(0)" style="width: 80px;" class="easyui-linkbutton btn-clear" id="dreload-button" data-item="BTN_002">Clear</a>
	                        </div>
                        </div>
            		</td>
            	</tr>
            	
	            <tr>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_001"><span>Type </span></th>
					<td class="d">
						<input class="easyui-combobox" name="userType" id="s_userType"
							data-options="width:100,
										height:30,
										mode:'remote',
										editable:false,
										loader:jcombo.loader,
										params:{codeGrup:'USER_TYPE'},panelHeight:'auto'
										"
						/>
					</td>
					<!-- search-label-h 1280x1024 크기떄문에 제거 -->
					<th class="h table-Search-h-right search-label-h" data-item="LAB_002"><span>Org Auth </span></th>
					<td class="d">
						<select class="easyui-combobox" name="orgAuthCode" ID="s_orgAuthCode" style="width:100px;height:30px;" data-options="panelHeight:'auto'">
							<option value="">ALL</option>
							<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'ORG_AUTH' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
							</c:forEach>
						</select>
					</td>
					<!-- <th class="h"><span>부서&nbsp;</span></th>
					<td class="d">
						<input class="easyui-combobox" name="deptPrnt" id="s_deptPrnt"
							data-options="width:120,
										mode:'remote',
										loader:jcombo.loader,
										params:{codeGrup:'DEPT_CODE',extNum01:1},
										child: {id:'s_deptCode',name:'deptCode'},
										onChange: jcombo.select
										"
						/>, 
										icons:[{iconCls:'icon-cut',handler: function() {
												$('#s_deptPrnt').combobox('clear');
											}
										}]
						<input class="easyui-combobox" name="deptCode" id="s_deptCode"
							data-options="width:120,
										mode:'remote',
										loader:jcombo.loader,
										params:{codeGrup:'DEPT_CODE',extNum01:2},
										parent:{id:'s_deptPrnt',name:'extChr01'}
										"
						/>, 
										icons:[{iconCls:'icon-cut',handler: function() {
												$('#s_deptCode').combobox('clear');
											}
										}]
					</td> -->
					<th class="h table-Search-h-right search-label-h" data-item="LAB_003"><span>Use Flag </span></th>
					<td class="d">
						<select class="easyui-combobox" name="useFlag" ID="s_useFlag" style="width:50px;height:30px;" data-options="panelHeight:'auto'">
							 <option value="ALL">ALL</option>
							<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'USE_FLAG' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
							</c:forEach>
						</select>
						<!-- <span class="radio-span">
							<input name="useFlag" type="radio" value="Y" id="s_useFlag1"/><label for="s_useFlag1">사용중</label>
							<input name="useFlag" type="radio" value="N" id="s_useFlag2"/><label for="s_useFlag2">중지</label>
						</span> -->
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_004"><span>User ID </span></th>
					<td class="d">
						<input type="text" class="easyui-textbox textbox-list" name="userId" id="s_userId" data-options="width:120,height:30" style="min-width: 119px;"></input>
						<input type="hidden" name="h_userIdList" id="h_userIdList" value=""/>
						<a href="javascript:void(0)" style="" id="userId-list-button" class="easyui-linkbutton c12 searchListA">
							<img id="userIdlist" style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/picklist_type.png" />
						</a>
					</td>
					<th class="h table-Search-h-right search-label-h" data-item="LAB_005"><span>User Name </span></th>
					<td class="d">
						<input type="text" class="easyui-textbox" name="userName" id="s_userName" data-options="width:120,height:30"></input>
					</td>
	            </tr>
	        </table>
	      </fieldset>
	        <!-- <div class="div-line"></div> -->
	      <fieldset class="div-line-new-sub grd-div-btn">
	        <table cellpadding="5" class="search-table tableEtc-c wd-100">
	            <tr>
					<td >
						<div class="dis_flex_gap4">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_003" data-options="disabled:${INS}">UserAdd</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="dealAppend-button" data-item="BTN_004" data-options="disabled:${INS}">DealAdd</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_005" data-options="disabled:${DEL}">Del</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"   data-item="BTN_006" data-options="disabled:${UPD}">Save</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button"  data-item="BTN_007">Excel Download <img src="<%=request.getContextPath() %>/resources/images/excel_download.png" style="width: 16px; height: 16px; margin-left: 5px;"></a>
						</div>
					</td>
	            </tr>
	        </table>
	        <!--  <div class="div-line"></div> -->
		</fieldset>
	</form>
    <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"    id="append-button">추가</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" id="remove-button">삭제</a> -->

	<!-- <div>
		<table>
			<tr>
				<td><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"    id="append-button">추가</a></td>
				<td><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" id="remove-button">삭제</a></td>
				<td style="width:100%; text-align: right; color:#0064FF"><span>상세 정보는 해당 행을 더블클릭하시면 확인 할수 있습니다.</span></td>
			</tr>
		</table>
	</div> -->
	
	<!-- 메뉴타입 팝업 -->
	<div id="search-menu-dialog" class="wui-dialog"	style="border-top-width: 1px;display:none">
		<table id="search-menu-grid">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true,halign:'center',align:'center'"></th>
					<th	data-options="field:'menuType', halign:'center', align:'center',width:80,data_item:'GRD_101'">Code</th>
					<th	data-options="field:'menuTypeName', halign:'center', align:'center',width:100,data_item:'GRD_102'">Spc Auth</th>
				</tr>
			</thead>
		</table>
	
		<!-- fieldset 구분 변경  20160928 박소현 -->
			<div id="search-menu-toolbar" class="wui-toolbar">
				<form id="search-menu-form">
					<input type="hidden" name="smenuType" id="smenuType" value="" />
				</form>
			</div>
				<input type="hidden" id="hdfIndex" value="-1" />
				<input type="hidden" id="hdfChk" value="" />
				<input type="hidden" id="testmenuType" value="" />
		</div>
		
		
		<!-- Appl List 팝업 -->
		<div id="search-menu-appl-list-dialog" class="wui-dialog"	style="border-top-width: 1px;display:none">
			<table id="search-menu-appl-list-grid">
				<thead>
					<tr>
						<th data-options="field:'ck',checkbox:true,halign:'center',align:'center'"></th>
						<th	data-options="field:'EXT_CHR10', halign:'center', align:'center',width:55,data_item:'GRD_101'">Code</th>
						<th	data-options="field:'CODE_NAME', halign:'center', align:'left',width:260,data_item:'GRD_102'">Code Name</th>
					</tr>
				</thead>
			</table>
	
		<!-- fieldset 구분 변경  20160928 박소현 -->
			<div id="search-menu-appl-list-toolbar" class="wui-toolbar">
				<form id="search-menu-appl-list-form">
					<input type="hidden" name="smenuType" id="smenuType" value="" />
				</form>
			</div>
				<input type="hidden" id="hdfIndex" value="-1" />
				<input type="hidden" id="hdfChk" value="" />
				<input type="hidden" id="testmenuType" value="" />
		</div>
		
		<form id="login-form" name="login-form" method="post">
			<fieldset>
				<input type="hidden" id="j_system" name="j_system" />
				<input type="hidden" id="j_userid" name="j_userid" />
				<input type="hidden" id="j_secure" name="j_secure" />
			</fieldset>
		</form>
	
</div>



<form id="login-form" name="login-form" method="post">
	<fieldset>
		<input type="hidden" id="j_system" name="j_system" />
		<input type="hidden" id="j_userid" name="j_userid" />
		<input type="hidden" id="j_secure" name="j_secure" />
	</fieldset>
</form>


<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="easyui-dialog" >
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

<!-- 등록화면 -->
<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;">
	<form id="search-create-form">
		<input type="hidden" id="r_oper" name="oper" value="I" />
		<fieldset class="div-line-new-sub">
			<div class="popup-table-alignCenter">
				<table class="popup-search-table">
					<tr>
						<th class="h"><span data-item="LAB_006">User Id</span></th>
						<td class="d">
							<input class="easyui-textbox" name="userId" id="r_userId" value="" style="width:150px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_007">Name</span></th>
						<td class="d">
							<input class="easyui-textbox" name="userName" id="r_userName" value="" style="width:300px"/>
						</td>
					</tr>
					<tr style="border-bottom-style:inset;border-bottom-color:#00000;border-bottom-width:2px;"><td style="height:1px;"></td><td style="height:1px;"></td></tr>
		        	<tr>
		        		<th class="h"><span data-item="LAB_008">User Type</span></th>
		        		<td class="d">
							<select class="easyui-combobox" name="userType" ID="r_userType" data-options="width:150,panelHeight:'auto',editable:false">
								<option value="DEAL">DEALER</option>
							</select>
						</td>
					</tr>
					<tr>
		        		<th class="h"><span data-item="LAB_009">Responsible BM</span></th>
		        		<td class="d">
							<select class="easyui-combobox" name="respBm" ID="r_respBm" data-options="width:150">
							<option value="">Select.</option>
							<c:forEach var="selectBmList" items="${selectBmList}">
								<option value="${selectBmList.USER_ID}">${selectBmList.USER_ID}</option>
							</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
		        		<th class="h"><span data-item="LAB_010">Head Dealer</span></th>
		        		<td class="d">
							<select class="easyui-combobox" name="headDeal" ID="r_headDeal" data-options="width:150">
							<option value="">Select.</option>
							<c:forEach var="selectHeadDealList" items="${selectHeadDealList}">
								<option value="${selectHeadDealList.USER_ID}">${selectHeadDealList.USER_ID}</option>
							</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
		        		<th class="h"><span data-item="LAB_011">Sales Group</span></th>
		        		<td class="d">
							<select class="easyui-combobox" name="saleGrup" ID="r_saleGrup" data-options="width:150">
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'SALE_GRUP' }">
										<option value="${item.CODE_CD}">${item.CODE_CD}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
		        		<th class="h"><span data-item="LAB_012">Shipping W/H</span></th>
		        		<td class="d">
							<select class="easyui-combobox" name="wareHous" ID="r_wareHous" data-options="width:150,panelHeight:'auto'">
							<option value="">Select.</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'WARE_HOUS'}">
										<option value="${item.CODE_CD}">${item.CODE_DESC}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>
					</tr>
					<!-- <tr>
		        		<th class="h"><span>Shipping Location</span></th>
		        		<td class="d">
							<select class="easyui-combobox" name="shipLoc" ID="r_shipLoc" data-options="width:150">
							<option value="">Select.</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'SHIP_LOC' }">
										<option value="${item.CODE_CD}">${item.CODE_CD}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>
					</tr> -->
					<tr style="border-bottom-style:dotted;border-bottom-color:#00000;border-bottom-width:2px;"><td style="height:1px;"></td><td style="height:1px;"></td></tr>
					<tr>
						<th class="h"><span data-item="LAB_013">Address (road)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="addrStr" id="r_addrStr" value="" data-options="width:300"/>
						</td>
					</tr>
					<tr style="display: none;">
						<th class="h"><span data-item="LAB_014">P.O. Box</span></th>
						<td class="d">
							<input type="hidden" class="easyui-textbox" name="addrBox" id="r_addrBox" value="" data-options="width:300"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_015">Zip Code/City</span></th>
						<td class="d">
							<input class="easyui-textbox" name="postCode" id="r_postCode" value="" style="width:80px"/>
							<input class="easyui-textbox" name="addrCity" id="r_addrCity" value="" style="width:217px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_016">States</span></th>
						<td class="d">
							<select class="easyui-combobox" name="addrRegn" ID="r_addrRegn" data-options="onChange:doAreaChange,width:80">
				              <option value="">Select.</option>
				              <c:forEach var="item" items="${result}">
				                <c:if test="${item.CODE_GRUP eq 'AREA_CODE' }">
				                  <option value="${item.CODE_CD}">${item.CODE_CD}</option>
				                </c:if>
				              </c:forEach>
				            </select>
							<input class="easyui-textbox" name="addrRegn2" id="r_addrRegn2" value="" data-options="width:217,editable:false"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_017">Country</span></th>
						<td class="d">
							<select class="easyui-combobox" name="addrCnty" ID="r_addrCnty" data-options="onChange:doCntyChange,width:80,panelHeight:'auto'">
							<option value="">Select.</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'CNTY_CODE' }">
										<option value="${item.CODE_CD}">${item.CODE_CD}</option>
									</c:if>
								</c:forEach>
							</select>
							<input class="easyui-textbox" name="addrCnty2" id="r_addrCnty2" value="" data-options="width:217,editable:false"/>
						</td>
					</tr>
					<tr style="display: none;">
						<th class="h"><span data-item="LAB_018">Transportation zone</span></th>
						<td class="d">
							<select class="easyui-combobox" name="transZone" ID="r_transZone" data-options="onChange:doTransChange,width:80,panelHeight:'auto'">
							<option value="">Select.</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'TRANS_ZONE' }">
										<option value="${item.CODE_CD}">${item.CODE_CD}</option>
									</c:if>
								</c:forEach>
							</select>
							<input class="easyui-textbox" name="transZone2" id="r_transZone2" value=""  data-options="width:217,editable:false"/>
						</td>
					</tr>
					<tr style="border-bottom-style:dotted;border-bottom-color:#00000;border-bottom-width:2px;"><td style="height:1px;"></td><td style="height:1px;"></td></tr>
					<tr>
						<th class="h"><span data-item="LAB_019">Mobile</span></th>
						<td class="d">
							<input class="easyui-textbox" name="moNo" id="r_moNo" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_020">Telephone</span></th>
						<td class="d">
							<input class="easyui-textbox" name="telNo" id="r_telNo" value="" style="width:300px"/>
						</td>
					</tr>
					
					<tr>
						<th class="h"><span data-item="LAB_021">E-Mail</span></th>
						<td class="d">
							<input class="easyui-textbox" name="email" id="r_email" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_022">E-Mail List</span></th>
						<td class="d">
							<input class="easyui-textbox" name="emailList" id="r_emailList" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_023">Fax</span></th>
						<td class="d">
							<input class="easyui-textbox" name="faxNo" id="r_faxNo" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_024">E-Mail Receive</span></th>
						<td class="d">
							<select class="easyui-combobox" name="emailRecv" ID="r_emailRecv" data-options="width:80,panelHeight:'auto'">
								<option value="">Select.</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'MAIL_RECV' }">
										<option value="${item.CODE_CD}">${item.CODE_CD}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr style="border-bottom-style:dotted;border-bottom-color:#00000;border-bottom-width:2px;"><td style="height:1px;"></td><td style="height:1px;"></td></tr>
					<tr>
						<th class="h"><span data-item="LAB_025">Payment Method</span></th>
						<td class="d">
							<select class="easyui-combobox" name="payType" ID="r_payType" data-options="onChange:doPaymChange,width:80,panelHeight:'auto'">
							<option value="">Select.</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'PAYM_METH' }">
										<option value="${item.CODE_CD}">${item.CODE_CD}</option>
									</c:if>
								</c:forEach>
							</select>
							<input class="easyui-textbox" name="payType2" id="r_payType2" value=""  data-options="width:217,editable:false"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span data-item="LAB_026">Currency</span></th>
						<td class="d">
							<select class="easyui-combobox" name="currUnit" ID="r_currUnit" data-options="width:80,panelHeight:'auto'">
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'CURR_UNIT' }">
										<option value="${item.CODE_CD}">${item.CODE_CD}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr style="border-bottom-style:dotted;border-bottom-color:#00000;border-bottom-width:2px;"><td style="height:1px;"></td><td style="height:1px;"></td></tr>
		            <!--  <tr>
						<th class="h"><span style="color:#2393e4" data-item="LAB_027">Parts(LSPO) ID</span></th>
						<td class="d">
							<input class="easyui-textbox" name="idLspo" id="r_idLspo" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span style="color:#2393e4" data-item="LAB_028">Warranty(LWS)</span></th>
						<td class="d">
							<input class="easyui-textbox" name="idLws" id="r_idLws" value="" style="width:300px"/>
						</td>
					</tr> -->
					<tr>
						<th class="h"><span style="color:#2393e4" data-item="LAB_029">Merchandise ID</span></th>
						<td class="d">
							<input class="easyui-textbox" name="idMerc" id="r_idMerc" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span style="color:#2393e4" data-item="LAB_030">Service Training ID</span></th>
						<td class="d">
							<input class="easyui-textbox" name="idServ" id="r_idServ" value="" style="width:300px"/>
						</td>
					</tr>
					<tr>
						<th class="h"><span style="color:#2393e4" data-item="LAB_031">WGBC ID</span></th>
						<td class="d">
							<input class="easyui-textbox" name="idWgbc" id="r_idWgbc" value="" style="width:300px"/>
						</td>
					</tr>
                    <tr>
                        <th class="h"><span style="color:#2393e4" data-item="LAB_032">MTS ID</span></th>
                        <td class="d">
                            <input class="easyui-textbox" name="idMts" id="r_idMts" value="" style="width:300px"/>
                        </td>
                    </tr>
                    <tr>
                        <th class="h"><span style="color:#2393e4" data-item="LAB_033">ACB ID</span></th>
                        <td class="d">
                            <input class="easyui-textbox" name="idAcb" id="r_idAcb" value="" style="width:300px"/>
                        </td>
                    </tr>
		            <tr style="border-top-style:inset;border-top-color:#00000;border-top-width:2px;">
						<td class="d popup-table-alignCenter" colspan="2">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-create-button" data-item="BTN_008" data-options="disabled:${INS}" >Save</a>
					    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="close-create-button" data-item="BTN_009">Close</a>
						</td>
		            </tr>
		        </table>
			</div>
		</fieldset>
	</form>
</div>

<!-- 멀티검색 팝업창 -->
<div id="multi-serach-pop" style="display: none; position: absolute; background: #ffffff; border: 1px solid #808080; padding: 5px;">
	<div>
		<textarea rows="9" style="width:100%; border-color: #e2dddd; padding: 5px;" name="s_poNo" id="s_poNo"></textarea>
	</div>
	<div class="dis_flex_gap4">
		<a href="javascript:void(0)" class="easyui-linkbutton c6" id="poList-button1" data-item="BTN_005" data-options="width:50" >Save</a>
        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="poList-button2" data-item="BTN_006" data-options="width:50">Del</a>
        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="poList-button3" data-options="width:50">Close</a>
	</div>
</div>

</html>
