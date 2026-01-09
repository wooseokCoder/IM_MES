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
<script type="text/javascript" src="<c:url value="/resources/js/ehelp.js"    />"> </script>
<script>

</script>
</head>

    
<!-- E-Help 팝업 =========================================================== -->
<!-- 상세 화면 -->
<div id="ehelp" class="wui-dialog">
	<div id="search-toolbar" class="wui-toolbar">
		<form id="move-form">
			<fieldset class="div-line-new" style="margin-bottom: 0px">
		        <table cellpadding="5" class="search-table tableSearch-c forcedTable" >
		            <tr>
						<!-- <th class="h table-Search-h"></th> -->
						<td class="d" style="padding-left:5px;">
							<input type="radio" name="chkinfoView" value="manu" checked="checked">메뉴얼
							<input type="radio" name="chkinfoView" value="memo" onclick="javascript:doMoveMemo();">사용자메모
						<!-- <td class="b">
							<a href="javascript:void(0)" class="easyui-linkbutton cgray" iconCls="icon-search" id="search-button">검색</a>
							<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray">검색</a> 
						</td> -->
		            </tr>
		        </table>
		   </fieldset>
		</form>
	</div>
	<form id="search-file-form" method="post">
	
		<fieldset>
			<input type="hidden" name="oper"     id="v_oper"   />
			<input type="hidden" name="sysId"    id="v_sysId"    value="${model.sysId}"   />
			<input type="hidden" name="bordNo"   id="v_bordNo"   value="${model.bordNo}"  />
			<input type="hidden" name="bordGrup" id="v_bordGrup" value="${model.bordGrup}"/>
			<input type="hidden" name="bordType" id="v_bordType" value="${model.bordType}"/>
				<input type="hidden" name="atchNo" id="h_atchNo" value=""/>
				<input type="hidden" name="atchGrup" id="h_atchGrup" value=""/>
			
			<table cellpadding="5" cellspacing="2" class="select-table accordion">
				<tr>
					<th width="12%"><span>제목</span>${model.button_stts}</th>
					<td width="88%" colspan="3"><span id="v_bordTitle"></span></td>
				</tr>
				<tr>
					<th width="12%"><span>작성자</span></th><td width="38%"><span id="v_regiName"></span></td>
					<th width="12%"><span>조회수</span></th><td width="38%"><span id="v_readCnt"></span></td>
				</tr>
				<!-- 
				<tr>
					<th width="12%"><span>시작일</span></th><td width="38%"><span id="v_bordBgn"/></td>
					<th width="12%"><span>종료일</span></th><td width="38%"><span id="v_bordEnd"/></td>
				</tr>
				 -->
				<tr>
					<th width="12%"><span>등록일</span></th><td width="38%"><span id="v_regiDate"></span></td>
					<th width="12%"><span>수정일</span></th><td width="38%"><span id="v_chngDate"></span></td>
				</tr>
			</table>
			<div class="easyui-panel wui-tareas" title="내용">
				<span id="v_bordText"></span>
			</div>
	
			<div class="wui-upload">
				<!-- <div id="select-fileupload"></div> -->
				<div class="panel-header"><div class="panel-title">첨부파일</div><div class="panel-tool"></div></div>
					<table id="select-fileupload">
						<thead>
							<tr>
								<th data-options="field:'fileName',   halign:'center',width: 300, align:'left'">파일명</th>
								<th data-options="field:'fileSize', halign:'center',width:140, align:'center'">파일크기</th>
								<th data-options="field:'fileType',   halign:'center',width: 80, align:'center'">파일타입</th>
								<th data-options="field:'fileDown', halign:'center',width:140, align:'center',
								styler: function(value,row,index) {
			    						return {class:'icon-saveblack'}
				    				}">다운로드</th>
							</tr>
						</thead>
					</table>
			</div>
	
		
		</fieldset>
	
	</form>
</div>

<div id="ehelpUpdate" class="wui-dialog">
	<div id="search-toolbar" class="wui-toolbar">
		<form id="move-form">
			<fieldset class="div-line-new" style="margin-bottom: 0px">
		        <table cellpadding="5" class="search-table tableSearch-c" >
		            <tr>
						<!-- <th class="h table-Search-h"></th> -->
						<td class="d" style="padding-left:5px;">
							<input type="radio" name="chkinfoUpdate" value="manu" onclick="javascript:doMoveManu()">메뉴얼
							<input type="radio" name="chkinfoUpdate" value="memo" checked="checked">사용자메모
						<!-- <td class="b">
							<a href="javascript:void(0)" class="easyui-linkbutton cgray" iconCls="icon-search" id="search-button">검색</a>
							<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray">검색</a> 
						</td> -->
		            </tr>
		        </table>
		   </fieldset>
		</form>
	</div>
	<form name="tx_editor_form" id="tx_editor_form" action="/insert.jsp" method="post" accept-charset="utf-8"> <!-- 2016/11/01 김영진 -- 폼 id 에디터셋팅값과 매칭 원래는 regist-form -->
	
		<fieldset>
			<input type="hidden" name="oper"     id="r_oper"   />
			<input type="hidden" name="sysId"    id="r_sysId"    value="${model.sysId}"   />
			<input type="hidden" name="bordNo"   id="r_bordNo"   value="${model.bordNo}"  />
			<input type="hidden" name="bordGrup" id="r_bordGrup" value="${model.bordGrup}"/>
			<input type="hidden" name="bordType" id="r_bordType" value="${model.bordType}"/>
			
			<table cellpadding="5" cellspacing="2" class="select-table accordion">			
				<tr>
					<td colspan="2" id="editorTd">
	 				</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="wui-upload">
							<div id="regist-fileupload"></div>
						</div>
	 				</td>
				</tr>
			</table>
		
		</fieldset>
	
	</form>
</div>


</html>