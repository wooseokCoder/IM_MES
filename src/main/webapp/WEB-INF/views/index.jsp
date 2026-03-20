<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)index.jsp 1.0 2014/07/30                                           --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 메인 화면 (탭 컨테이너)                                                --%>
<%-- Home 탭에 대시보드, 메뉴 클릭 시 새 탭 추가                           --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 2.0 2026/02/26                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp"%>

<!-- FRAME JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/frame.js" />"></script>

<script type="text/javascript">
	var groupIdC = '<c:out value="${groupIdC}" />';
</script>
</head>

<body class="easyui-layout" id="main-layout" onload="windowResizing();">

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
	// 메뉴 로딩 후 Home 탭 자동 생성
	jwidget.menu.load({
		callback: function() {
			// 새로고침 복원용: createHome의 onSelect가 덮어쓰기 전에 미리 읽기
			var lastTab = sessionStorage.getItem('activeTab');

			// Home 탭 생성
			jwidget.tabs.createHome();

			// 새로고침 시 마지막 활성 탭 복원
			if (lastTab && lastTab !== 'HOME') {
				jmenus.go(lastTab);
			}

			// 쿠키 기반 메뉴 이동 (SSO/이메일 로그인 등)
			var pdiMenu = getCookie("im_mesMenu");
			if (pdiMenu != "") {
				deleteCookie("im_mesMenu");
				jmenus.go(pdiMenu);
			}
		}
	});

	// 핫메뉴 로딩 — 메뉴 트리 onLoadSuccess에서 자동 호출 (LS099 노드 필요)
	//jwidget.hotmenu.load();
});
</script>

	<!-- HEADER (상단) -->
	<div data-options="region:'north',border:false" id="header-region" style="overflow:visible;height:105px;">
		<%@ include file="/WEB-INF/views/include/north.jsp" %>
	</div>

	<!-- WEST (좌측 메뉴) -->
	<div data-options="region:'west',border:false" id="menu-region" style="display: none;">
		<%@ include file="/WEB-INF/views/include/west.jsp" %>
	</div>

	<!-- CENTER (탭 영역) -->
	<div data-options="region:'center',border:false" id="center-region" style="padding: 0 16px;">
		<!-- TAB PANEL -->
		<div id="wui-tabs"></div>
	</div>

	<!-- FOOTER -->
	<div data-options="region:'south',split:false,border:false" id="footer-region" style="height:1px;">
		<%@ include file="/WEB-INF/views/include/south.jsp" %>
	</div>

</body>
</html>
