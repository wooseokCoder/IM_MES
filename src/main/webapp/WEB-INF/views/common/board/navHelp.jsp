<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)navHelp.jsp 1.0 2025/10/23                                         --%>
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
<%-- Help 화면                                    	                        --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2025/10/23                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/navHelp.js" />"></script>
<script type="text/javascript">
	 doInit({
		sysId:    '${model.sysId}',
		title:    '${model.bordName}',
		bordGrup: '${model.bordGrup}',
		bordType: '${model.bordType}',
		rows:     '${model.rows}',
		page:     '${model.page}'
	});
</script>
<style>
#account-layout{min-width:500px !important;}
/*.panel-header{color:#000 !important;border-bottom:1px solid #ccc !important;}*/
.panel-header{color:#000 !important;padding-left:0px;}

#s_searchKey + .combo {
	width: 100px !important;
}

.grd-div-btn .l-btn {
	min-width: 130px;
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

<table id="search-grid"></table>

<div id="search-toolbar" class="wui-toolbar">

	<form id="search-form" class="brd_srch_div">
		<fieldset class="div-line-new">
		<!-- <fieldset class="Remake-div-line-new" > -->
			<input type="hidden" name="sysId"    id="s_sysId"    value="${model.sysId}"   />
			<input type="hidden" name="bordGrup" id="s_bordGrup" value="${model.bordGrup}"/>
            <table cellpadding="5" class="search-table wd-100" >
				<tr class="topnav_sty">
            		<td colspan="4" >
            			<div>
	            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
							<div>
								<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001" data-options="disabled:${RET}">Select</a>
							</div>
                        </div>
            		</td>
            	</tr>

				<tr>
					<td style="padding-left: 10px;">
						<div class="dis_flex_gap5">
							<input class="easyui-combobox" name="searchKey"  id="s_searchKey"  value="${model.searchKey}"  codeGrup="BORD_STYPE" data-options="mode:'remote',width:100,editable:false,loader:jcombo.loader,panelHeight:'auto'"/>
							<span id="searchExt" style="width:calc(100% - 100px);">
								<input class="easyui-textbox"  name="searchText" id="r_searchText" value="${model.searchText}" />
							</span>
							<span id="writeDate" class="dis_flex" style="display:none; width:calc(100% - 100px);" >
								<input class="easyui-datebox date-L" name="date1" id="date1" value="${date1}" />
								<input class="easyui-datebox date-R" name="date2" id="date2" value="${date2}" />
							</span>
						</div>
					</td>
				</tr>
			</table>
		</fieldset>
	</form>

    <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"    id="regist-button">등록</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" id="remove-button">삭제</a> -->
	<fieldset class="div-line-new-sub grd-div-btn">
		<table  cellpadding="5" class="search-table tableEtc-c" style="width:100%;">
			<tr>
				<td class="h" style="width:500px; min-width: 200px;">
					<div class="dis_flex_gap4" >
						<%-- <a href="javascript:void(0)" class="easyui-linkbutton c6" id="regist-button" data-item="BTN_002" data-options="disabled:${INS}">Write</a> --%>
					    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}">Delete</a>
					    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button"  data-item="BTN_004">Excel Download&nbsp;
					    	<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/excel_download.png" />
					    </a>
				    </div>
				</td>
				<td class="h etctext" style="text-align:right;" data-item="TXT_001"><span>For more information, double click on the line.</span></td>
			</tr>
		</table>
	</fieldset>
</div>

<form id="hidden-form" method="post">
	<input type="hidden" name="oper"       id="h_oper"       value=""/>
	<input type="hidden" name="bordNo"     id="h_bordNo"     value=""/>
	<input type="hidden" name="sysId"      id="h_sysId"      value="${model.sysId}"/>
	<input type="hidden" name="bordGrup"   id="h_bordGrup"   value="${model.bordGrup}"/>
	<input type="hidden" name="bordType"   id="h_bordType"   value="${model.bordType}"/>
	<input type="hidden" name="searchKey"  id="h_searchKey"  value="${model.searchKey}"/>
	<input type="hidden" name="searchText" id="h_searchText" value="${model.searchText}"/>
	<input type="hidden" name="rows"       id="h_rows"       value="${model.rows}"/>
	<input type="hidden" name="page"       id="h_page"       value="${model.page}"/>
</form>


<!-- [LAYOUT] end -->
</div>
<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
