<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)noticeView.jsp 1.0 2015/04/27                                      --%>
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
<%-- LS Q&A News 상세조회화면(페이지 이동형태의 게시판).                             		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2015/04/27                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/lsqnaView.js?v=0627A" />"></script>
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
.wui-tareas{padding:20px;border-bottom:1px solid #ededed;}
#v_bordTitle{font-weight:bold;}
.adjust-select th{border-right:1px solid #ededed;}
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

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">


<input type="hidden" name="hUseId" id="hUserId" value="${userId}"/>
<c:forEach var="item" items="${cUserId}">
	<input type="hidden" name="cUserId" id="cUserId" value="${item.REGI_ID}"/>
</c:forEach>

		<div class="easyui-panel" data-options="fit:true">
			<form id="select-form" method="post">

				<fieldset>
					<input type="hidden" name="oper"     id="v_oper"     value="${model.oper}"    />
					<input type="hidden" name="sysId"    id="v_sysId"    value="${model.sysId}"   />
					<input type="hidden" name="bordNo"   id="v_bordNo"   value="${model.bordNo}"  />
					<input type="hidden" name="bordGrup" id="v_bordGrup" value="${model.bordGrup}"/>
					<input type="hidden" name="bordType" id="v_bordType" value="${model.bordType}"/>
					<input type="hidden" name="bordTitle" id="r_bordTitle" value=""/>
					<input type="hidden" name="bordPno" id="r_bordPno" value="${model.bordNo}"/>
					<table class="adjust-select">
						<tr class="topnav_sty">
							<td colspan="4">
								<div>
									<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
								</div>
							</td>
						</tr>
				
						<tr>
							<th width="12%"><span data-item="LAB_201">Title</span></th>
							<td width="88%" colspan="3"><span id="v_bordTitle"></span></td>
						</tr>
						<!-- <tr>
							<th width="12%"><span data-item="LAB_005">Period</span></th>
							<td width="88%" colspan="3"><span id="v_bordBgn"></span> ~ <span id="v_bordEnd"></span></td>
						</tr> -->
						<tr>
							<input type="hidden" name="regiId" id="v_regiId"/>
							<th width="12%"><span data-item="LAB_202">Writer</span></th><td width="38%"><span id="v_regiName"></span></td>
							<th width="12%"><span data-item="LAB_203">View</span></th><td width="38%"><span id="v_readCnt"></span></td>
						</tr>
						<tr>
							<th width="12%"><span data-item="LAB_204">Write date</span></th><td width="38%"><span id="v_regiDate"></span></td>
							<th width="12%"><span data-item="LAB_205">Update date</span></th><td width="38%"><span id="v_chngDate"></span></td>
						</tr>
					</table>
					<div class="easyui-panel wui-tareas">
						<span id="v_bordText"></span>
					</div>

					<div class="wui-upload">
						<div id="select-fileupload" style="width:100%"></div>
					</div>
					
					<div style="text-align:center;padding:5px">
				        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="update-button" data-item="BTN_201" data-options="disabled:${UPD}" >Modify</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="reply-button" data-item="BTN_202" data-options="disabled:${INS}" >Reply</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_203" data-options="disabled:${DEL}" >Delete</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="list-button" data-item="BTN_204"   >List</a>
				    </div>
					
					<!-- <div class="reply-list easyui-panel" title='Reply'>
					</div> -->
					<div class="reply-list"></div>

				</fieldset>

			</form>

		    <!-- <div style="text-align:center;padding:5px">
		        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="update-button" data-item="BTN_008" >Modify</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="reply-button" data-item="BTN_009" >Reply</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_010" >Delete</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="list-button" data-item="BTN_011"   >List</a>
		    </div> -->

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

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
