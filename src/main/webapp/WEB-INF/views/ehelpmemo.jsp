<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@(#)user.jsp 1.0 2014/08/12                                           
                                                                      
COPYRIGHT (C) 2011 C-NODE, INC.                                       
ALL RIGHTS RESERVED.                                                  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
사용자관리 화면이다.                                                     
                                                                      
@author C-NODE                                                        
@version 1.0 2014/08/12                                               
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<c:url value="/resources/jquery/daumeditor-7.5.9/css/editor.css" />" type="text/css" charset="utf-8"/>
<script type="text/javascript" src="<c:url value="/resources/jquery/daumeditor-7.5.9/js/editor_loader.js"    />"> </script>	

<%@ include file="/WEB-INF/views/include/common.jsp" %>

<link rel="stylesheet" href="<c:url value="/resources/jquery/uploader-3.1/css/uploadfile.css" />" type="text/css" charset="utf-8"/>
<script type="text/javascript" src="<c:url value="/resources/jquery/uploader-3.1/js/jquery.uploadfile.js"    />"> </script>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/ehelpmemo.js"    />"> </script>

</head>

    
<!-- E-Help 팝업 =========================================================== -->
<!-- 상세 화면 -->
	<div id="search-toolbar" class="wui-toolbar">
		<form id="save-form">
			<fieldset class="div-line-new-sub" style="margin-bottom: 0px;padding:0px">
		        <table cellpadding="5" class="search-table tableSearch-c" >
		            <tr>
						<td class="b">
							<a href="javascript:void(0)" id="ehelp-save-button" class="easyui-linkbutton c6" style="margin-left: 10px" data-popup="POP_BTN_001">저장</a>
							<a href="javascript:void(0)" id="ehelp-delete-button" class="easyui-linkbutton c6" data-popup="POP_BTN_003">DELETE</a> 
							<%-- <c:if test="${groupIdC eq 'DEVADMIN'}">
								<a href="javascript:langTextPopSave();">언어저장</a>
							</c:if> --%>
						</td>
		            </tr>
		        </table>
		   </fieldset>
		</form>
	</div>
	<form name="tx_editor_form" id="tx_editor_form" action="/insert.jsp" method="post" accept-charset="utf-8"> <!-- 2016/11/01 김영진 -- 폼 id 에디터셋팅값과 매칭 원래는 regist-form -->
	
		<fieldset>
			<input type="hidden" name="oper"     id="r_oper"   value="I"/>
			<input type="hidden" name="sysId"    id="r_sysId"    value="${model.sysId}"   />
			<input type="hidden" name="bordNo"   id="r_bordNo"   value="${model.bordNo}"  />
			<input type="hidden" name="bordGrup" id="r_bordGrup" value="${model.bordGrup}"/>
			<input type="hidden" name="bordType" id="r_bordType" value="${model.bordType}"/>

			<input type="hidden" name="eHelpMenuKey" id="h_eHelpMenuKey" value="${model.eHelpMenuKey}"/>
			<input type="hidden" name="atchNo" id="h_atchNo" value=""/>
			<input type="hidden" name="atchGrup" id="h_atchGrup" value="B11"/>
			<input type="hidden" name="text_menuKey" id="text_menuKey" value="N0002"/>
			<input type="hidden" name="text_ehelp_menuKey" id="text_ehelp_menuKey" value="N0002"/>
			
			<input type="hidden" name="userId" id="h_userId" value=""/>
			
			<table cellpadding="5" cellspacing="2" class="select-table accordion">			
				<tr>
					<td colspan="2" id="editorTd" style="height:200px">
						<%@ include file="/resources/jquery/daumeditor-7.5.9/editor_template.jsp" %>
	 				</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="wui-upload">
							<div id="regist-fileupload" class="fileStyle"></div>
						</div>
	 				</td>
				</tr>
			</table>
		
		</fieldset>
	
	</form>
<script type="text/javascript">

</script>

</html>