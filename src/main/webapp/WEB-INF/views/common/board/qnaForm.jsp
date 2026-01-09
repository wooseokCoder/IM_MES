<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)boardForm.jsp 1.0 2014/08/24                                       --%>
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
<%-- 게시판관리 화면이다.                                                      --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/24                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<form id="regist-form" method="post">

	<fieldset>
		<input type="hidden" name="oper"     id="r_oper"   />
		<input type="hidden" name="sysId"    id="r_sysId"    value="${model.sysId}"   />
		<input type="hidden" name="bordNo"   id="r_bordNo"   value="${model.bordNo}"  />
		<input type="hidden" name="bordGrup" id="r_bordGrup" value="${model.bordGrup}"/>
		<input type="hidden" name="bordType" id="r_bordType" value="${model.bordType}"/>
		<input type="hidden" name="bordPno"  id="r_bordPno" />
		
		<table cellpadding="5" cellspacing="2" class="adjust-select mail-table-add">
			<!-- 
			<tr>
				<th><span>시작일:</span></th><td><input class="easyui-datebox" name="bordBgn" id="r_bordBgn"/></td>
				<th><span>종료일:</span></th><td><input class="easyui-datebox" name="bordEnd" id="r_bordEnd"/></td>
			</tr>
			-->
			<tr>
				<th data-popup="POP_LAB_001"><p class="essential"></p><span>제목</span></th>
				<td>
					<input class="easyui-textbox" name="bordTitle" id="r_bordTitle" data-options="required:true,validType:'length[0,100]',width:500"/> 
					<c:if test="${groupIdC eq 'DEVADMIN'}">
						<a href="javascript:langTextPopSave();">언어저장</a>
					</c:if>
				</td>
			</tr>
			<tr>
				<th data-popup="POP_LAB_002"><p class="essential"></p><span>날짜</span></th>
				<td>
					<input id="bordBgn" name="bordBgn" type="text" class="easyui-datebox" style="width:100px;" value="${bordBgn}" required="required"/>
					~<input id="bordEnd" name="bordEnd" type="text" class="easyui-datebox" style="width:100px;" value="${bordEnd}" required="required"/>
				</td>
			</tr>
			
			<tr>
				<td colspan="2">
					<div id="editor-area" >
						<textarea name="bordText" id="r_bordText" class="sceditor wui-editor"></textarea>
					</div>
 				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="wui-upload">
						<div id="regist-fileupload" class="fileStyle2"></div>
					</div>
 				</td>
			</tr>
		</table>
	
	</fieldset>

</form>

<script type="text/javascript">

$(function() {
	
	jsystemboard.initForm({
		mode: "regist",
		//등록폼 KEY (#포함)
		formKey: "#regist-form",
		//첨부파일 레이어 KEY
		layoutKey: "regist-fileupload",
		//첨부파일 업로더 KEY
		loaderKey: "uploader",
		//첨부파일 INPUT 명칭
		fileName: "files",
		//Form Hidden Value 정의
		setHiddenValues: function(params) {

			$("#r_sysId"    ).val (params.sysId);
			$("#r_oper"     ).val (params.oper);
			$("#r_bordNo"   ).val (params.bordNo);
			$("#r_bordGrup" ).val (params.bordGrup);
			$("#r_bordType" ).val (params.bordType);
			$("#r_bordTitle").val (params.bordTitle);
			$("#r_bordPno"  ).val (params.bordPno);
		},
		//[WSC2.0] [2015.04 LSH] 웹에디터 설정 추가
		//웹에디터 레이어 ID
		editorLayer: "editor-area",
		//웹에디터 텍스트박스 ID
		editorBox:   "r_bordText",
		//웹에디터 폼 ID
		editorForm:  "regist-form"
	});
	
	//console.log($("#r_bordPno").val());
	if($("#r_bordPno").val() != "" && $("#r_bordPno").val() != null && $("#r_bordPno").val() != undefined){
		$('#r_bordTitle').attr("readonly", "readonly");
	}
	doLangSettingPopTable();
});
</script>
