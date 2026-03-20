<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 작업자(사원) 선택 팝업 공통 (acWorkerForm)                              --%>
<%-- AS-IS: ChangeEmp → TSTD_EMPLOYEE_QUERY6                               --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/acWorkerForm.jsp" %>   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 작업자 선택 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/acWorkerForm.js?v=260318B" />"></script>

<!-- 작업자 선택 다이얼로그 (공통) -->
<div id="acwk-search-dialog" class="easyui-dialog" style="visibility:hidden;width:500px;height:500px"
    data-options="closed:true, modal:true, buttons:'#acwk-search-buttons'">
    <div class="easyui-layout" data-options="fit:true">
        <!-- 상단: 검색 영역 -->
        <div data-options="region:'north', border:false" style="height:40px; padding:5px; display:none;">
            <input id="acwk-search-keyword" class="easyui-textbox"
                data-options="width:250, prompt:'사원코드 또는 사원명 검색'" />
            <a href="javascript:void(0)" id="acwk-search-btn" class="easyui-linkbutton cgray">조회</a>
        </div>
        <!-- 하단: 사원 그리드 -->
        <div data-options="region:'center', border:false">
            <table id="acwk-search-grid"></table>
        </div>
    </div>
</div>

<!-- 작업자 선택 다이얼로그 버튼 -->
<div id="acwk-search-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acwk-confirm-button">확인</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acwk-close-button">닫기</a>
</div>
