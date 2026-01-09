<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)header.jsp 1.0 2014/07/30                                          --%>
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
<%-- BODY 내의 상단 화면이다.                                                 --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<c:if test="${layoutYn == 'N'}">
<body class="wui-body" onload="windowResizing();">
</c:if>
<c:if test="${layoutYn == 'Y'}">
<body class="easyui-layout"  id="main-layout" onload="windowResizing();">

<style>
/* 왼쪽 west 메뉴 영역 css */
.layout-panel-west {
	top: 0 !important;
	height: 100% !important;
	z-index: 99 !important;
	position: fixed !important;
	width: 240px;
}

.layout-panel-west .layout-panel {
	width: 240px !important;
}

.layout-panel-center {
	background-color: #f5f7f8 !important;
}
</style>

<script type="text/javascript">
$(function() {
	//상단메뉴 로딩
	jwidget.menu.load({
		menuKey  : '<c:out value="${menuKey}" />',
		menuUrl  : '<c:out value="${menuUrl}" />',
		menuDesc : '<c:out value="${menuDesc}" />'
		
	});
	//핫메뉴 로딩
	jwidget.hotmenu.load();
});

</script>
	<!-- HEADER -->
	<div data-options="region:'north',border:false" id="header-region" style="overflow:visible;height:105px;"> 
		<%@ include file="/WEB-INF/views/include/north.jsp" %>
	</div>

	<!-- WEST -->
    <div data-options="region:'west',border:false" id="menu-region" style="display: none;"> <!-- 2016/10/06 김영진 --display:none - 초기 상태 안보이게 -->
		<%@ include file="/WEB-INF/views/include/west.jsp" %><!-- 좌측 HTML -->
    </div>
	<!-- CENTER -->
    <!-- <div data-options="region:'center',border:false" id="center-region" style="padding: 0 16px; background-color: #f5f7f8 !important;"> -->
    <div data-options="region:'center',border:false" id="center-region" style="padding: 0 16px; ">
</c:if>

<!-- =========================== CONTENTS START =========================== -->

