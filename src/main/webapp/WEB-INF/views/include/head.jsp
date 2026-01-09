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


<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- BODY 내의 상단 화면이다.                                                 --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
	<!-- HEADER -->
	 <div data-options="region:'north',border:false" id="header-region" style="overflow:visible;height:105px;"> 
		<%@ include file="/WEB-INF/views/include/north.jsp" %>
	</div>

	<!-- WEST -->
    <div data-options="region:'west',border:false" id="menu-region" style="display: none"><!--  -->
		<%@ include file="/WEB-INF/views/include/west.jsp" %><!-- 좌측 HTML -->
    </div>
    
	<!-- CENTER -->
    <div data-options="region:'center',border:false" id="center-region" class="scroll-area" style="padding: 0 16px; background-color: #f5f7f8 !important;">
