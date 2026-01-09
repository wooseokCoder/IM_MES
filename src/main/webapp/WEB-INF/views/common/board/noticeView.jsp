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
<%-- 공지사항 상세조회화면(페이지 이동형태의 게시판).                             --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2015/04/27                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/noticeView.js" />"></script>
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
.panel-header{color:#000 !important; border-bottom:1px solid #ccc !important;border-top:1px solid #ccc !important;}
.wui-tareas{padding:10px;}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

		<div class="easyui-panel" data-options="title:'${model.bordName} 상세',fit:true,iconCls:'icon-edit'">


			<form id="select-form" method="post">

				<fieldset>
					<input type="hidden" name="oper"     id="v_oper"     value="${model.oper}"    />
					<input type="hidden" name="sysId"    id="v_sysId"    value="${model.sysId}"   />
					<input type="hidden" name="bordNo"   id="v_bordNo"   value="${model.bordNo}"  />
					<input type="hidden" name="bordGrup" id="v_bordGrup" value="${model.bordGrup}"/>
					<input type="hidden" name="bordType" id="v_bordType" value="${model.bordType}"/>

					<table class="adjust-select">
						<tr>
							<th width="12%"><span data-item="LAB_004">제목</span></th>
							<td width="88%" colspan="3"><span id="v_bordTitle"></span></td>
						</tr>
						<tr>
							<th width="12%"><span data-item="LAB_005">게시기간</span></th>
							<td width="88%" colspan="3"><span id="v_bordBgn"></span> ~ <span id="v_bordEnd"></span></td>
						</tr>
						<tr>
							<th width="12%"><span data-item="LAB_006">작성자</span></th><td width="38%"><span id="v_regiName"></span></td>
							<th width="12%"><span data-item="LAB_007">조회수</span></th><td width="38%"><span id="v_readCnt"></span></td>
						</tr>
						<tr>
							<th width="12%"><span data-item="LAB_008">등록일</span></th><td width="38%"><span id="v_regiDate"></span></td>
							<th width="12%"><span data-item="LAB_009">수정일</span></th><td width="38%"><span id="v_chngDate"></span></td>
						</tr>
					</table>
					<div class="easyui-panel wui-tareas">
						<span id="v_bordText"></span>
					</div>

					<div class="wui-upload">
						<div id="select-fileupload" style="width:100%"></div>
					</div>

				</fieldset>

			</form>

		    <div style="text-align:center;padding:5px">
		        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="update-button" data-item="BTN_008" >수정</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_009" >삭제</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="list-button" data-item="BTN_010"   >목록</a>
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
