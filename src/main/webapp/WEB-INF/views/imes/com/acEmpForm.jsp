<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 사원 검색 팝업 공통 (acEmpForm) - JS + HTML 일체형                     --%>
<%-- ORD02A 등 사원 검색이 필요한 화면에서 공통 사용                        --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/acEmpForm.jsp" %>      --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 사원 검색 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/acEmpForm.js?v=260227A" />"></script>

<!-- 사원 검색 다이얼로그 (공통) -->
<div id="acemp-search-dialog" class="easyui-dialog" style="width:900px;height:600px;visibility:hidden;"
    data-options="closed:true, modal:true, buttons:'#acemp-search-buttons'">
    <div class="easyui-layout" data-options="fit:true">
        <!-- 상단: 검색 영역 -->
        <div data-options="region:'north', border:false" style="height:40px; padding:5px;">
            <input id="acemp-search-keyword" type="text" style="width:300px; height:24px; padding:2px 5px;"
                placeholder="사원코드 또는 사원명 검색" />
            <a href="javascript:void(0)" id="acemp-search-btn" class="easyui-linkbutton cgray">조회</a>
        </div>
        <!-- 좌측: 조직 트리 -->
        <div data-options="region:'west', split:true, border:true" style="width:300px;">
            <table id="acemp-org-tree"></table>
        </div>
        <!-- 우측: 사원 그리드 -->
        <div data-options="region:'center', border:false">
            <table id="acemp-search-grid"></table>
        </div>
    </div>
</div>

<!-- 사원 검색 다이얼로그 버튼 -->
<div id="acemp-search-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acemp-confirm-button">확인</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acemp-close-button">닫기</a>
</div>
