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

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/ehelpmanu.js"    />"> </script>
<script>
$(function(){

	if(window.innerWidth<900){
	 	//alert("call");
	    // console.log(check);
		$("#search-file-form table").addClass("forcedTable");

	}
	
})


</script>
<style>
.panel-header{border-bottom:1px solid #ccc;padding-left:10px;}
#search-file-form{color:#000;}
.forcedTable th{width:70px !important;}
</style>
</head>

    
<!-- E-Help 팝업 =========================================================== -->
<!-- 상세 화면 -->	
	
	<form id="search-file-form" method="post">
	
		<fieldset>
			<input type="hidden" name="oper"     id="v_oper"   />
			<input type="hidden" name="sysId"    id="v_sysId"    value="${model.sysId}"   />
			<input type="hidden" name="bordNo"   id="v_bordNo"   value="${model.bordNo}"  />
			<input type="hidden" name="bordGrup" id="v_bordGrup" value="${model.bordGrup}"/>
			<input type="hidden" name="bordType" id="v_bordType" value="${model.bordType}"/>
			<input type="hidden" name="eHelpMenuKey" id="h_eHelpMenuKey" value="${model.eHelpMenuKey}"/>
			<input type="hidden" name="atchNo" id="h_atchNo" value=""/>
			<input type="hidden" name="atchGrup" id="h_atchGrup" value=""/>
			<input type="hidden" name="text_menuKey" id="text_menuKey" value="N0001"/>
			<input type="hidden" name="text_ehelp_menuKey" id="text_ehelp_menuKey" value="N0001"/>
			
			<table cellpadding="5" cellspacing="2" class="adjust-select">
				<tr>
					<th style="border-top:0px;" data-popup="POP_LAB_001"><span>제목 </span>${model.button_stts}</th>
					<td style="border:0px;"><span id="v_bordTitle"></span>
							<%-- <c:if test="${groupIdC eq 'DEVADMIN'}">
								<a href="javascript:langTextPopSave();">언어저장</a>
							</c:if> --%>
					</td>
				</tr>
				<tr>
					<th data-popup="POP_LAB_002"><span>작성자 </span></th>
					<td class="font_color nhstyle nstyle"><span id="v_regiName"></span></td>
					<th data-popup="POP_LAB_003"><span>조회수 </span></th>
					<td class="font_color nhstyle nstyle"><span id="v_readCnt"></span></td>
				</tr>
				<!-- 
				<tr>
					<th width="12%"><span>시작일</span></th><td width="38%"><span id="v_bordBgn"/></td>
					<th width="12%"><span>종료일</span></th><td width="38%"><span id="v_bordEnd"/></td>
				</tr>
				 -->
				<tr>
					<th data-popup="POP_LAB_004"><span>등록일 </span></th>
					<td><span id="v_regiDate"></span></td>
					<th data-popup="POP_LAB_005"><span>수정일 </span></th>
					<td><span id="v_chngDate"></span></td>
				</tr>
			</table>
			<div class="easyui-panel wui-tareas" title="내용" style="height:397px">
				<span id="v_bordText"></span>
			</div>
	
			<div class="wui-upload" style="height:107px">
				<!-- <div id="select-fileupload"></div> -->
				<div class="panel-header" style="border-top:1px solid #ccc;"><div class="panel-title" data-popup="POP_LAB_006">첨부파일</div><div class="panel-tool"></div></div>
					<table id="select-fileupload" data-options="pagination:false">
						<thead>
							<tr>
								<th data-options="field:'fileName',   halign:'center',width: 300, align:'left',data_popup:'POP_GRD_001'">파일명</th>
								<th data-options="field:'fileSize', halign:'center',width:140, align:'center',data_popup:'POP_GRD_002'">파일크기</th>
								<th data-options="field:'fileType',   halign:'center',width: 80, align:'center',data_popup:'POP_GRD_003'">파일타입</th>
								<th data-options="field:'fileDown', halign:'center',width:140, align:'center',data_popup:'POP_GRD_004',
								styler: function(value,row,index) {
			    						return {class:'icon-saveblack'}
				    				}">다운로드</th>
							</tr>
						</thead>
					</table>
			</div>
	
		
		</fieldset>
	
	</form>


</html>