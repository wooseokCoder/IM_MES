<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)loaderForm.jsp 1.0 2015/04/30                                      --%>
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
<%-- 엑셀양식 관리화면이다.                                                    --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2015/04/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/loader/loaderForm.js" />"></script>
<style>
.p-west   { width:400px }
.p-center {}
.p-tbar   { height:30px;}
.p-form   { width:100%; }
.p-space  { height:10px;}
.p-south  { width:400px;height:180px;}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>

	<div class="easyui-layout" fit="true">
		<div region="west" border="false" class="p-west">
			<div class="easyui-layout" fit="true">
				<div region="south" title="엑셀양식 편집" iconCls="ui-icon ui-icon-pencil" class="p-south">
				    <form id="litem-form" method="post">
				    	<input type="hidden" name="oper"     id="o_oper"     />
				    	<input type="hidden" name="sysId"    id="o_sysId"    />
				    	<input type="hidden" name="exclGrup" id="o_exclGrup" />
				    	<table cellpadding="5" class="p-form">
				    		<tr>
				    			<th><b>코드:</b></th>
				    			<td><input class="easyui-textbox" type="text" name="formCode" id="o_formCode" data-options="required:true,width:200"/></td>
				    		</tr>
				    		<tr>
				    			<th><b>명칭:</b></th>
				    			<td><input class="easyui-textbox" type="text" name="formName" id="o_formName" data-options="required:true,width:200"/></td>
				    		</tr>
				    		<tr>
				    			<th><b>제목행:</b></th>
				    			<td><input class="easyui-numberbox" type="text" name="titleNo" id="o_titleNo" data-options="required:true,width:200"/></td>
				    		</tr>
				    		<tr>
				    			<th><b>시작행:</b></th>
				    			<td><input class="easyui-numberbox" type="text" name="startNo" id="o_startNo" data-options="required:true,width:200"/></td>
				    		</tr>
				    		<tr>
				    			<th><label for="o_pivotYn"><b>피벗:</b></label></th>
				    			<td><input name="pivotYn" type="checkbox" value="Y" id="o_pivotYn"/></td>
				    		</tr>
				    		<tr>
				    			<td colspan="2" align="center">
							    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="lform-clear-button" >신규</a>
							    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="lform-remove-button">삭제</a>
							    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="lform-save-button"  >저장</a>
				    			</td>
				    		</tr>
				    	</table>
				    </form>
				</div>
				<div region="center" border="false">
					<div id="lform-toolbar" class="p-tbar">
						<form id="lform-form" method="post">
							<input name="exclGrup" id="r_exclGrup" codeGrup="0" />
						</form>
					</div>
					<table id="lform-grid"></table>
				</div>
			</div>
		</div>
		<div region="center" border="false" class="p-center">
			<div id="litem-toolbar" class="p-tbar">
			    <form id="upload-form" method="post" enctype="multipart/form-data">
			    	<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true" id="litem-append-button">추가</a>
			    	<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true" id="litem-remove-button">삭제</a>
			    	<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true" id="litem-save-button"  >저장</a>
			    	&nbsp;&nbsp;&nbsp;&nbsp;
			    	&nbsp;&nbsp;&nbsp;&nbsp;
			    	<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true">엑셀파일:</a>
					<!-- <input name="excelFile" id="u_excelFile" class="easyui-filebox" style="width:350px"/> -->
					<input type="file" size="80" name="excelFile" id="u_excelFile" style="display:inline-block;" />
			    	<input name="oper"      id="u_oper"      type="hidden" >
			    	<input name="sysId"     id="u_sysId"     type="hidden" />
			    	<input name="exclGrup"  id="u_exclGrup"  type="hidden" />
			    	<input name="formCode"  id="u_formCode"  type="hidden" />
				    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="litem-upload-button">업로드</a>
			    </form>
			</div>
			<table id="litem-grid"></table>
			<div id="upload-frame"></div>
		</div>
	</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>