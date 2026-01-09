<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)popup.jsp 1.0 2015/05/20                                          --%>
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
<%-- 팝업관리 화면(페이지 이동형태의 게시판).                                    			--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2015/05/20                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/popup.js" />"></script>
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
#account-layout{min-width:700px !important;}
#report-button-pdf .l-btn-text{
	width: 100px;
}
.search-label-h {width:10%;}

#s_searchKey + .combo {
	width: 100px !important;
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
	<form id="search-form">
		<input type="hidden" name="sysId"    id="s_sysId"    value="${model.sysId}"   />
		<input type="hidden" name="bordGrup" id="s_bordGrup" value="${model.bordGrup}"/>

		<!-- 검색 영역 -->
		<fieldset class="Remake-div-line-new" >
	        <table cellpadding="2" class="search-table tableSearch-c wd-100" >
	        	<colgroup>
					<col width="7%" style="min-width: 80px;" />
					<col width="15%" style="min-width: 80px;" />
					<col width="20%" style="min-width: 80px;" />
					<col width="*" style="min-width: 140px;" />
				</colgroup>
	        	<tr class="topnav_sty">
            		<td colspan="4">
            			<div>
	            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
	            			<div>
								<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001">Select</a>
	                        </div>
                        </div>
            		</td>
            	</tr>

				<tr>
					<td class="d">
						<input class="easyui-combobox" name="searchKey"  id="s_searchKey"  value="${model.searchKey}"  codeGrup="BORD_STYPE" data-options="mode:'remote',editable:false,loader:jcombo.loader,panelHeight:'auto' ,onChange:doChange"/>
					</td>
					<td class="d">
						<span id="searchExt" >
							<input class="easyui-textbox"  name="searchText" id="r_searchText" value="${model.searchText}" />
						</span>
					</td>
					<td class="d">
						<span id="writeDate" class="dis_flex" style="display:none;">
							<input class="easyui-datebox date-L" name="date1" id="date1" value="${date1}" />
							<input class="easyui-datebox date-R" name="date2" id="date2" value="${date2}" />
						</span>
					</td>
					<td></td>
				</tr>
			</table>
		</fieldset>
	</form>

	<div>
	<fieldset class="div-line-new-sub grd-div-btn">
		<table cellpadding="7" class="search-table tableEtc-c wd-100">
			<tr>
				<td class="h">
					<div class="dis_flex_gap4">
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="regist-button" data-item="BTN_002">Write</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003">Delete</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_004">
							Excel Download&nbsp;
						    	<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/excel_download.png" />
						</a>
					</div>
				</td>
				<td class="h etctext" style="width:50%;" data-item="LAB_001"><span>For more information, double click on the line.</span></td>
			</tr>
		</table>
	</fieldset>
	</div>
</div>

<form id="hidden-form" method="post">
	<input type="hidden" name="oper"       id="h_oper"       value=""/>
	<input type="hidden" name="bordNo"     id="h_bordNo"     value=""/>
	<input type="hidden" name="sysId"      id="h_sysId"      value="${model.sysId}"/>
	<input type="hidden" name="bordGrup"   id="h_bordGrup"   value="${model.bordGrup}"/>
	<input type="hidden" name="bordType"   id="h_bordType"   value="${model.bordType}"/>
	<input type="hidden" name="searchKey"  id="h_searchKey"  value="${model.searchKey}"/>
	<input type="hidden" name="searchText" id="h_searchText" value="${model.searchText}"/>
	<input type="hidden" name="openCls"    id="h_openCls"    value="${model.openCls}"/>
	<input type="hidden" name="rows"       id="h_rows"       value="${model.rows}"/>
	<input type="hidden" name="page"       id="h_page"       value="${model.page}"/>
</form>


<!-- 등록 레이어 -->
<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;"></div>
<!-- 조회 레이어 -->
<div id="select-dialog" class="wui-dialog" style="border-top-width:1px;"></div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="easyui-dialog" >
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- [LAYOUT] end -->
</div>

</html>
