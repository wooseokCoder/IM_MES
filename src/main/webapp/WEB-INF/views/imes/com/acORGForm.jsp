<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 부서 검색 팝업 공통 (acORGForm) - JS + HTML 일체형                     --%>
<%-- ProActive CodeHelperManager.acORG 대응                                --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/acORGForm.jsp" %>      --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 부서 검색 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/acORGForm.js?v=260317A" />"></script>

<!-- 부서 검색 다이얼로그 (공통) -->
<div id="acorg-search-dialog" class="easyui-dialog" style="visibility:hidden;width:650px;height:550px"
    data-options="closed:true, modal:true, buttons:'#acorg-search-buttons'">
    <table id="acorg-search-grid"></table>
</div>

<!-- 부서 검색 다이얼로그 버튼 -->
<div id="acorg-search-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acorg-confirm-button">확인</a>
    <!-- <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acorg-close-button">닫기</a> -->
</div>
