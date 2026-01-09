<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)loaderCode.jsp 1.0 2015/05/11                                      --%>
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
<%-- 엑셀양식종류 관리화면이다.                                                 --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2015/05/11                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/loader/loaderCode.js" />"></script>
<style>
.p-west   {width:565px }
.p-center { }
.p-tbar   { }
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>

	<div class="easyui-layout" fit="true">

		<div region="west" border="false" class="p-west">
			<div id="cform-toolbar" class="p-tbar">
			    <form id="cform-form" method="post">
			    	<input type="hidden" name="oper"     id="r_oper"     />
			    	<input type="hidden" name="sysId"    id="r_sysId"    />
			    	<input type="hidden" name="codeGrup" id="r_codeGrup" value="${model.codeGrup}" />
			    	<input type="hidden" name="extChr01" id="r_extChr01" value="${model.extChr01}"/>
			    </form>
				<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true" title="추가" id="cform-add-button"   >추가</a>
				<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true" title="삭제" id="cform-remove-button">삭제</a>
				<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true" title="저장" id="cform-save-button"  >저장</a>
			</div>
			<table id="cform-grid"></table>
		</div>
		<div region="center" border="false" class="p-center">
			<div id="citem-toolbar" class="p-tbar">
			    <form id="citem-form" method="post">
			    	<input type="hidden" name="oper"     id="o_oper"     />
			    	<input type="hidden" name="sysId"    id="o_sysId"    />
			    	<input type="hidden" name="codeGrup" id="o_codeGrup" />
			    </form>
				<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true" title="저장" id="citem-add-button"   >추가</a>
				<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true" title="삭제" id="citem-remove-button">삭제</a>
				<a href="javascript:void(0)" class="easyui-linkbutton c6" plain="true" title="추가" id="citem-save-button"  >저장</a>
			</div>
			<table id="citem-grid"></table>
		</div>
	</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
