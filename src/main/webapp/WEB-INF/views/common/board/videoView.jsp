<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)boardView.jsp 1.0 2014/08/24                                       --%>
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
<form id="select-form" method="post">

	<fieldset>
		<input type="hidden" name="oper"     id="v_oper"   />
		<input type="hidden" name="sysId"    id="v_sysId"    value="${model.sysId}"   />
		<input type="hidden" name="bordNo"   id="v_bordNo"   value="${model.bordNo}"  />
		<input type="hidden" name="bordGrup" id="v_bordGrup" value="${model.bordGrup}"/>
		<input type="hidden" name="bordType" id="v_bordType" value="${model.bordType}"/>

		<table  class="adjust-select">
			<tr>
				<th data-popup="POP_LAB_003"><span>제목 :</span>${model.button_stts}</th>
				<td colspan="3"><span id="v_bordTitle"></span>
					<c:if test="${groupIdC eq 'DEVADMIN'}">
						<a href="javascript:langTextPopSave();">언어저장</a>
					</c:if>
				</td>
			</tr>
			<tr>
				<th data-popup="POP_LAB_004"><span>작성자 :</span></th>
				<td ><span id="v_regiName"></span></td>
				<th data-popup="POP_LAB_005"><span>조회수 :</span></th>
				<td ><span id="v_readCnt"></span></td>
			</tr>
			<tr>
				<th data-popup="POP_LAB_006"><span>시작일 :</span></th>
				<td class="nhstyle nstyle"><span id="v_bordBgn"></span></td>
				<th data-popup="POP_LAB_007"><span>종료일 :</span></th>
				<td class="nhstyle nstyle"><span id="v_bordEnd"></span></td>
			</tr>
			<!--
			<tr>
				<th width="12%"><span>시작일</span></th><td width="38%"><span id="v_bordBgn"/></td>
				<th width="12%"><span>종료일</span></th><td width="38%"><span id="v_bordEnd"/></td>
			</tr>
			 -->
			<tr>
				<th class="nhstyle nstyle" data-popup="POP_LAB_008"><span>등록일 :</span></th>
				<td class="nhstyle nstyle"><span id="v_regiDate"></span></td>
				<th class="nhstyle nstyle" data-popup="POP_LAB_009"><span>수정일 :</span></th>
				<td class="nhstyle nstyle"><span id="v_chngDate"></span></td>
			</tr>
		</table>
		<div class="easyui-panel wui-tareas" title='내용' style="height:270px;padding:10px;">
			<span id="v_bordText"></span>
		</div>

		<div class="wui-upload">
			<div id="select-fileupload"></div>
		</div>

		<div class="reply-list easyui-panel" title='답글'>

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

	var replyArea = "";

	$.ajax({
        url: getUrl("/common/board/video/reply.json"),
        type: "POST",
        dataType: "json",
        data: { bordPno: $("#v_bordNo").val() },
        success: function( data ) {
        	if(!data || !data.rows){
        		replyArea = "답글이 없습니다."
        	}else{
	        	$.map( data.rows, function( v, i ) {
	        		replyArea += "<div class=\"reply-header\">"
	        				 		+ "<span class=\"reply-user\">" + v.regiName + "</span> | "
	        				 		+ "<span class=\"reply-date\">" + v.regiDate + "</span>"
	        				    + "</div>"
	        				    + "<div class=\"reply-text\""
	        				    	+ "<div class=\"reply-text\"><a href=\"javascript:doReplyView('" + v.bordNo + "')\">" + v.bordText + "</a></div>"
	        				    + "</div>"
  	            });
        	}

        	$('.reply-list').html(replyArea);
        },
        error: function (error) {
           console.log(error);
        }
});
});
</script>
