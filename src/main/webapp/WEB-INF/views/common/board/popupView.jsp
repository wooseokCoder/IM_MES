<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)popupView.jsp 1.0 2015/05/20                                       --%>
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
<script type="text/javascript" src="<c:url value="/resources/js/common/board/popupView.js" />"></script>
<script type="text/javascript">
	doInit({
		oper:     '${model.oper}',
		sysId:    '${model.sysId}',
		title:    '${model.bordName}',
		bordNo:   '${model.bordNo}',
		bordGrup: '${model.bordGrup}',
		bordType: '${model.bordType}',
		openCls:  '${model.openCls}'
	});
</script>
<style>
/* .panel-header{color:#000 !important; border-bottom:1px solid #ccc !important;border-top:1px solid #ccc !important;} */
.panel-header{color:#000 !important;padding-left:0px;}
.wui-tareas{padding:10px;}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
<input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>

		<div class="easyui-panel" data-options="fit:true">

			<form id="select-form" method="post">

				<fieldset>
					<input type="hidden" name="oper"     id="v_oper"     value="${model.oper}"    />
					<input type="hidden" name="sysId"    id="v_sysId"    value="${model.sysId}"   />
					<input type="hidden" name="bordNo"   id="v_bordNo"   value="${model.bordNo}"  />
					<input type="hidden" name="bordGrup" id="v_bordGrup" value="${model.bordGrup}"/>
					<input type="hidden" name="bordType" id="v_bordType" value="${model.bordType}"/>
					<input type="hidden" name="openCls"  id="v_openCls"  value="${model.openCls}"/>

					<table class="adjust-select">
						<tr class="topnav_sty">
							<td colspan="4">
								<div>
									<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
								</div>
							</td>
						</tr>
				
						<tr>
							<th width="12%" data-item="POP_LAB_001"><span>Title</span></th>
							<td width="88%" colspan="3" >
								<span id="v_bordTitle"></span>
							</td>
						</tr>
						<tr>
							<th width="12%"  data-item="POP_LAB_002"><span>Period</span></th>
							<td width="88%" colspan="3" >
								<span id="v_bordBgn"></span> ~ <span id="v_bordEnd"></span>
							</td>
						</tr>
						<tr>
							<th width="12%"  data-item="POP_LAB_003"><span>Type</span></th>
							<td width="88%" colspan="3">
								<span id="v_openName"></span> :
								<span data-item="POP_TXT_001">Width</span>:  <span id="v_width" ></span><span data-item="POP_TXT_005">Pixel</span>,
								<span data-item="POP_TXT_002">Height</span>:  <span id="v_height"></span><span data-item="POP_TXT_006">Pixel</span>,
								<span data-item="POP_TXT_003">X coordinate</span>: <span id="v_pointX"></span><span data-item="POP_TXT_007">Pixel</span>,
								<span data-item="POP_TXT_004">Y coordinate</span>: <span id="v_pointY"></span><span data-item="POP_TXT_008">Pixel</span>
							</td>
						</tr>
						<tr>
							<th width="12%" data-item="POP_LAB_004"><span>Writer</span></th>
							<td width="38%" class="nhstyle nstyle"><span id="v_regiName"></span></td>
							<th width="12%" data-item="POP_LAB_005"><span>View</span></th>
							<td width="38%" class="nhstyle nstyle"><span id="v_readCnt"></span></td>
						</tr>
						<tr>
							<th width="12%" data-item="POP_LAB_006"><span>Write date</span></th>
							<td width="38%" class="nhstyle nstyle"><span id="v_regiDate"></span></td>
							<th width="12%" data-item="POP_LAB_007"><span>Update date</span></th>
							<td width="38%" class="nhstyle nstyle"><span id="v_chngDate"></span></td>
						</tr>
						<tr>
							<th width="12%" data-item="POP_LAB_006"><span>Display to</span></th>
							<td width="88%" class="nhstyle nstyle" colspan="3"><span id="v_target"></span></td>
						</tr>
					</table>
					<div class="easyui-panel wui-tareas">
						<span id="v_bordText"></span>
					</div>

				</fieldset>

			</form>

		    <div style="text-align:center;padding:5px">
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"   id="update-button" data-item="POP_BTN_001">Modify</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"id="remove-button" data-item="POP_BTN_002">Delete</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"- id="list-button"  data-item="POP_BTN_003">List</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="preview-button" data-item="POP_BTN_004">Preview</a>
		    </div>

		</div>

<form id="hidden-form" method="post">
	<input type="hidden" name="oper"       id="h_oper"       value=""/>
	<input type="hidden" name="bordNo"     id="h_bordNo"     value="${model.bordNo}"/>
	<input type="hidden" name="sysId"      id="h_sysId"      value="${model.sysId}"/>
	<input type="hidden" name="bordGrup"   id="h_bordGrup"   value="${model.bordGrup}"/>
	<input type="hidden" name="bordType"   id="h_bordType"   value="${model.bordType}"/>
	<input type="hidden" name="searchKey"  id="h_searchKey"  value="${model.searchKey}"/>
	<input type="hidden" name="searchText" id="h_searchText" value="${model.searchText}"/>
	<input type="hidden" name="openCls"    id="h_openCls"    value="${model.openCls}"/>
	<input type="hidden" name="rows"       id="h_rows"       value="${model.rows}"/>
	<input type="hidden" name="page"       id="h_page"       value="${model.page}"/>
</form>

<script type="text/javascript">

$(function() {
	doLangSettingPopTable();
});

</script>

<!-- 팝업용 레이어 -->
<div id="popup-dialog"></div>
<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
