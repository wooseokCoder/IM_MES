<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 도면/PLM 파일 목록 팝업 공통 (acFileForm)                             --%>
<%-- AS-IS: ProActive FileList 클래스 대응                                 --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/acFileForm.jsp" %>    --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 파일 목록 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/acFileForm.js?v=260304C" />"></script>

<!-- 그리드 버튼 스타일: common.css grid-btn 공통 클래스 사용 -->

<!-- 파일 목록 다이얼로그 (공통) -->
<div id="acfile-search-dialog" class="easyui-dialog" style="width:750px;height:450px;visibility:hidden;"
    data-options="closed:true, modal:true">
    <table id="acfile-search-grid"></table>
</div>
