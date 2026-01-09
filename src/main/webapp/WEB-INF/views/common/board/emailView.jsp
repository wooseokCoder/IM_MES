<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)emailView.jsp 1.0 2014/09/18                                       --%>
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
<%-- 전자메일 상세보기 화면이다.                                               --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/09/18                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<form id="select-form" method="post">

	<fieldset>
		<input type="hidden" name="oper"     id="v_oper"   />
		<input type="hidden" name="sysId"    id="v_sysId"    value="${model.sysId}"   />
		<input type="hidden" name="bordNo"   id="v_bordNo"   value="${model.bordNo}"  />
		<input type="hidden" name="bordGrup" id="v_bordGrup" value="${model.bordGrup}"/>
		<input type="hidden" name="bordType" id="v_bordType" value="${model.bordType}"/>
		
		<table cellpadding="5" cellspacing="2" class="select-table accordion">
			<tr>
				<th width="12%"><span>제목</span></th>
				<td width="88%" colspan="3"><span id="v_bordTitle"></span></td>
			</tr>
			<tr>
				<th width="12%"><span>보낸사람</span></th><td width="38%"><span id="v_regiName"></span></td>
				<th width="12%"><span>보낸날짜</span></th><td width="38%"><span id="v_regiDate"></span></td>
			</tr>
			<tr>
				<th width="12%"><span>받은사람</span></th><td width="38%"><span id="v_tgtName"></span></td>
				<th width="12%"><span>받은날짜</span></th><td width="38%"><span id="v_readDate"></span></td>
			</tr>
		</table>
		<div class="easyui-panel wui-tareas">
			<span id="v_bordText">내용</span>
		</div>

		<div class="wui-upload">
			<div id="select-fileupload"></div>
		</div>
	
	</fieldset>

</form>

<script type="text/javascript">

$(function() {
	
	jsystemboard.initView({
		mode: "select",
		//등록폼 KEY (#포함)
		formKey: "#select-form",
		//업로드 레이어 KEY
		layoutKey: "select-fileupload",
		//첨부파일 그리드 KEY
		gridKey: "files-grid",
		//Form Hidden Value 정의
		setHiddenValues: function(params) {
			$("#v_sysId"   ).val (params.sysId);
			$("#v_oper"    ).val (params.oper);
			$("#v_bordNo"  ).val (params.bordNo);
			$("#v_bordGrup").val (params.bordGrup);
			$("#v_bordType").val (params.bordType);
		}
	});
	
	
	
});
</script>
