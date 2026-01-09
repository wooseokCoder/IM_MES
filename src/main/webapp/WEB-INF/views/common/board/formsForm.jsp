<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)noticeForm.jsp 1.0 2015/04/27                                      --%>
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
<%-- Forms 등록,수정화면(페이지 이동형태의 게시판).                            				--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2015/04/27                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/formsForm.js" />"></script>
<script type="text/javascript">
	doInit({
		oper:     '${model.oper}',
		sysId:    '${model.sysId}',
		title:    '${model.bordName}',
		bordNo:   '${model.bordNo}',
		bordGrup: '${model.bordGrup}',
		bordType: '${model.bordType}'
	});
</script>
<style>
/*.panel-header{color:#000 !important; border-bottom:1px solid #ccc !important;border-top:1px solid #ccc !important;}*/
.panel-header{color:#000 !important;padding-left:0px;}
.adjust-select th{border-right:1px solid #ededed;}
#editor-area{padding-top:10px;padding-bottom:12px;}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>

		<div id="regist-panel" class="easyui-panel" data-options="fit:true">
		    <form id="regist-form" method="post">
		    	<fieldset>
					<input type="hidden" name="oper"     id="r_oper"     value="${model.oper}"    />
					<input type="hidden" name="sysId"    id="r_sysId"    value="${model.sysId}"   />
					<input type="hidden" name="bordNo"   id="r_bordNo"   value="${model.bordNo}"  />
					<input type="hidden" name="bordGrup" id="r_bordGrup" value="${model.bordGrup}"/>
					<input type="hidden" name="bordType" id="r_bordType" value="${model.bordType}"/>
					<input type="hidden" name="bordBgn"  id="r_bordBgn"  value="${model.bordBgn}"/>
					<input type="hidden" name="bordEnd"  id="r_bordEnd"  value="9999-12-31"/>
					<table class="adjust-select">
						<!-- <tr>
							<th width="12%"><span data-item="LAB_001">Period</span></th>
							<td><input class="easyui-datebox" name="bordBgn" id="r_bordBgn" value="${model.bordBgn}" data-options="required:true,validType:'validDate',width:140"/> ~
							    <input class="easyui-datebox" name="bordEnd" id="r_bordEnd" value="${model.bordEnd}" data-options="required:true,validType:'validDate',width:140"/>
							</td>
						</tr> -->
						<tr>
							<th width="12%"><span data-item="LAB_002">Title</span></th>
							<td width="88%"><input class="easyui-textbox" name="bordTitle" id="r_bordTitle" style="width:100%" data-options="required:true,validType:'length[0,100]'"/>
							</td>
						</tr>
						<tr>
							<th width="12%"><span data-item="LAB_003">Add files</span></th>
							<td width="88%">
								<div class="wui-upload">
									<div id="regist-fileupload"></div>
								</div>
			 				</td>
						</tr>
						<tr>
							<td colspan="2">
								<div id="editor-area">
									<textarea name="bordText" id="r_bordText" class="sceditor wui-editor"></textarea>
								</div>
			 				</td>
						</tr>
					</table>

		    	</fieldset>
		    </form>
		    <div style="text-align:center;padding:20px">
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"  id="save-button" data-item="BTN_005" data-options="disabled:${INS}">Save</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"  id="remove-button" data-item="BTN_006" data-options="disabled:${DEL}">Delete</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"  id="list-button" data-item="BTN_007"  >List</a>
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
	<input type="hidden" name="rows"       id="h_rows"       value="${model.rows}"/>
	<input type="hidden" name="page"       id="h_page"       value="${model.page}"/>
</form>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
