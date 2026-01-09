<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)modelmanagement.jsp 1.0 2014/08/05                                 --%>
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
<%-- A/S접수관리 화면이다.                                                  		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2017/04/07                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/views/include/common.jsp" %>
<script type="text/javascript">
	 var context = "<c:out value="${pageContext.request.contextPath}" />";
</script>
<script type="text/javascript" src="<c:url value="/resources/js/smsreturn.js" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css" />" />
<script type="text/javascript">
	function demoAlert(){
		$.messager.alert('Warning', msg.MSG0047, 'warning');
		return false;
	}
	 doInit({
		message: '${exception.message}'
	});
</script>

<%
//--------------------------------------------------------------------
// Xonda.Net
// 예약/즉시전송 Receive Form
//-------------------------------------


	String return_value = request.getParameter("return_value");        // 1: 성공 , -1: 실패
	String success_value = request.getParameter("success_value");       // 성공된 SMS 건수 (단건: 1, 동보일경우 : N )
	String fail_value = request.getParameter("fail_value");          // 실패된 SMS 건수 (단건: 1, 동보일경우 : N )
	String error_code = request.getParameter("error_code");          // Error Code
	String error_msg = request.getParameter("error_msg");           // Error Msg
	String process_type = request.getParameter("process_type");        // 처리종류 (send : 즉시발송 , send_reserved: 예약발송 )
	String unique_num = request.getParameter("unique_num");          // 예약된 메세지의 고유번호 (예약수정및 삭제할 경우 필요)
	String remain_cash = request.getParameter("remain_cash");         // 잔여발송건수
	String usrdata1 = request.getParameter("usrdata1");            // 되돌려 받고자 한값 usrdata1
	String usrdata2 = request.getParameter("usrdata2");            // 되돌려 받고자 한값 usrdata2
	String usrdata3 = request.getParameter("usrdata3");            // 되돌려 받고자 한값 usrdata3
	String shetNo = request.getParameter("shetNo");
	String tel = request.getParameter("tel");
%>


<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/smsreturn.js" />"></script>
</head>

<body  oncontextmenu = "return false"  ondragstart  = "return false"  onselectstart = "return false" bgcolor="#FFFFFF" text="#000000" class="bodyGra" style="margin:0;" onload="onPopUpSms();">

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout">
    <!-- [CENTER] start -->
<div data-options="region:'center',border:false">
		<!-- 문자발송 -->
<div id="sms-dialog" class="wui-dialog" style="border-top-width:1px;">
	<div id="sms-toolbar" class="wui-toolbar">
		<form accept-charset="EUC-KR"  name="sms-form" id="sms-form" action="http://biz.xonda.net/biz/biz_newV2/SMSASP_WEBV4_s.asp" method="post">
		<input type="hidden" name="sms_return_value" id=sms_return_value value="<%=return_value%>">
		<input type="hidden" name="sms_error_code" id=sms_error_code value="<%=error_code%>">
		<input type="hidden" name="shetNo" id=shetNo value="<%=shetNo%>">
		<input type="hidden" name="tel" id=tel value="<%=tel%>">
			<fieldset class="div-line-new" >
				<div style="display:inline-block;">
					<table class="search-table" style="width:340px;">
						<tr>
							<th style="text-align:right"><span>문자종류</span></th>
							<td>
								<input class="easyui-combobox" name="smsType" ID="smsType" data-options="width:140, onChange:doChngText" />
							</td>
						</tr>
						<tr>
							<th style="text-align:right"><span>수신번호</span></th>
							<td>
								<input type="hidden" name="send_number" value="0325880102">												<%//발송자 핸드폰 번호(숫자만기입) 15자이내%>
								<input type="text"   name="receive_number" id="receive_number" style="width:140px;" >(숫자만기입)		<%//수신자 핸드폰 번호(동보일 경우 0123456789,0123456789 / 단문일경우 15자 이내 )%>
								<input type="hidden" name="biz_id" value="koiss">														<%//Xonda/Biz ID %>
								<input type="hidden" name="smskey" value="96A3A744-E074-44AB-8E67-CCCD79174294 ">						<%//보안키  %>
								<input type="hidden" name="return_url" value="http://erp.koiss.co.kr/wsc/smsreturn.do">

							</td>
						</tr>
						<tr>
							<th style="text-align:right;height:160px;"><span>문자내용</span></th>
							<td class="d" colspan="10" style="height:160px;width:210px;">
								<span class="textbox" style="height:160px;width:200px"><textarea class="textbox-text" style="height:160px;width:200px;" name="sms_contents" id="sms_contents"></textarea></span>
								<input type="hidden" name="reserved_flag" value="">						<%// true : 예약, false : 즉시%>
								<input type="hidden" name="reserved_year" value="" >					<%//예약년도 4자 (숫자만 기입, 현재년 ~ 현재년 + 1) %>
								<input type="hidden" name="reserved_month" value="" >					<%//예약월 2자 (숫자만 기입, 01 ~ 12) %>
								<input type="hidden" name="reserved_day" value="" >						<%//예약일 2자 (숫자만 기입, 01 ~ 31) %>
								<input type="hidden" name="reserved_hour" value="" >					<%//예약시간 2자 (숫자만 기입, 00 ~ 23) %>
								<input type="hidden" name="reserved_minute" value="" >					<%//예약분 2자 (숫자만 기입, 00 ~ 59) %>
								<input type="hidden" name="usrdata1" value="">							<%//기타 되돌려받을값%>
								<input type="hidden" name="usrdata2" value="">							<%//기타 되돌려받을값%>
								<input type="hidden" name="usrdata3" value="">							<%//기타 되돌려받을값%>
							</td>
						</tr>
					</table>
					 <table cellpadding="5" class="search-table tableEtc-c" style="margin:auto;">
		            <tr>
						<td class="h">
							<input type="button" value="보내기" id="submit1" name="submit1" onclick="demoAlert()">
							<!-- <input type="submit" value="보내기" id="submit1" name="submit1"> -->
<!-- 							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="sms-button" data-item="BTN_003">전송</a> -->
						</td>
		            </tr>
		        </table>
				</div>
		   	</fieldset>

		</form>
	</div>
</div>
</div>
</div>
</body>
</html>
