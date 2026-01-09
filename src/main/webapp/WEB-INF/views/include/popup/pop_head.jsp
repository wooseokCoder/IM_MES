<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)topnav.jsp 1.0 2016/09/20                                          --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 컨텐츠 내에 상단 내비 화면이다.                                                 --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2016/09/20                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>

<input type="hidden" name="BAS" id="BAS" value="${BAS}" /> <!--기본  -->
<input type="hidden" name="INS" id="INS" value="${INS}" /> <!--등록  -->
<input type="hidden" name="RET" id="RET" value="${RET}" /> <!--조회  -->
<input type="hidden" name="UPD" id="UPD" value="${UPD}" /> <!--수정  -->
<input type="hidden" name="DEL" id="DEL" value="${DEL}" /> <!--삭제  -->
<input type="hidden" name="AUP" id="AUP" value="${AUP}" /> <!--권한P -->
<input type="hidden" name="AUS" id="AUS" value="${AUS}" /> <!--권한S -->
<input type="hidden" name="AU1" id="AU1" value="${AU1}" /> <!--권한1 -->
<input type="hidden" name="AU2" id="AU2" value="${AU2}" /> <!--권한2 -->
<input type="hidden" name="AU3" id="AU3" value="${AU3}" /> <!--권한3 -->
<input type="hidden" name="AU4" id="AU4" value="${AU4}" /> <!--권한4 -->
<input type="hidden" name="AU5" id="AU5" value="${AU5}" /> <!--권한5 -->

<style>
.pop_topnav {
	height: 66px; 
	background-color: #002658;
	display: flex;
	justify-content: space-between;
}

.btn_orderForm {
	color: #ffffff;
    font-size: 17px;
    padding: 20px;
}

.btn_orderForm:hover, .btn_orderForm:focus {
	color: #c6d3e3;
	cursor: pointer;
}

.body_border {
	height: 100%;
    border: 1px solid #e1e1e1;
    border-radius: 4px;
    /* background-color: #f5f7f8; */
}

.order_header_tit {
	color: #fff;
	padding-top: 8px;
	flex:1;
	font-size: 35px;
}

</style>
<script>
	$(function() {
		//let hostIndex = location.href.indexOf( location.host ) + location.host.length;
		//let contextPath = location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );
		
		//언어 변환
		if(locale == 'en') {
			//영어
			//$("#pop_top_logo").attr("src", contextPath + "/resources/images/lsta_logo.png");
			
			$("#btn_order_form").text("Order form");
			$("#btn_main_page").text("Main Page");
		}
		else {
			//$("#pop_top_logo").attr("src", contextPath + "/resources/images/lsta_logo.png");
			
			$("#btn_order_form").text("p_Order form");
			$("#btn_main_page").text("p_Main Page");
		}
		
	});

	function orderFormPop(userId) {
		var _width = '1300';
	    var _height = '600';
	 
	    // 팝업을 가운데 위치시키기 위해 아래와 같이 값 구하기
	    var _left = Math.ceil(( window.screen.width - _width )/2);
	    var _top = Math.ceil(( window.screen.height - _height )/2); 

		//let hostIndex = location.href.indexOf( location.host ) + location.host.length;
		//let contextPath = location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );

		var orderPop = window.open(context+'/ndmorder/ndmorder/ndmorderstate.do?userId='+userId, 'ndmorderstate_'+userId,'width='+ _width +',height='+ _height +',left=' + _left + ',top='+ _top);
		
	}
	
	function ndmOrderMain(userId) {
		//let hostIndex = location.href.indexOf( location.host ) + location.host.length;
		//let contextPath = location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );

		window.location.href = context + '/ndm';
	}
	
</script>

<body>

<div class="easyui-layout" data-options="fit:true">
	<div id="topnavSubDiv" data-options="region:'north' ,border:false" class="pop_topnav" >
		<div class="tal" style="width: 130px;">
			<img id="pop_top_logo" src="${pageContext.request.contextPath}/resources/images/lsta_logo.png" style="margin-left: 10px;padding-top: 15px;height: 40px;">
		</div>
		<div class="order_header_tit tac">NDM Order Management</div>
		<div style="display: flex; align-items: center; padding-right: 20px; width: 130px; justify-content: end;">
			<%-- <c:if test="${orderFormYn == 'Y'}">
				<a id="btn_order_form" class="btn btn_orderForm" href="javascript:orderFormPop('${user.userId}');">Order form</a>
			</c:if> --%>
			<c:if test="${ndmOrderMainYn != 'Y'}">
				<img src="${pageContext.request.contextPath}/resources/images/nav_icons/nav_home.png" onclick="ndmOrderMain('${user.userId}');" style="width: 20px; height: 20px; cursor: pointer;" />
				<%-- <a id="btn_main_page" class="btn btn_orderForm" href="javascript:ndmOrderMain('${user.userId}');">Main Page</a> --%>
			</c:if>
		</div>
	</div>
	<div data-options="region:'center',border:false" style="padding: 12px;">
	<!-- <div class="easyui-panel" style="width:100%;border:0;padding: 12px;position: absolute; top: 65px;height: 100%;"> -->
	<!-- <div class="body_border"> -->
