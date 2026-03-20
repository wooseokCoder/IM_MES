<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 설비 검색 팝업 공통 (acMachineForm)                                    --%>
<%-- 설비 검색이 필요한 화면에서 공통 사용                                  --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/acMachineForm.jsp" %>   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 설비 검색 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/acMachineForm.js?v=260227A" />"></script>

<!-- 설비 검색 다이얼로그 (공통) -->
<div id="acmc-search-dialog" class="easyui-dialog" style="visibility:hidden;width:780px;height:370px"
    data-options="closed:true, modal:true, buttons:'#acmc-search-buttons'">
    <div class="easyui-layout" data-options="fit:true">
        <!-- 상단: 검색 영역 -->
        <div data-options="region:'north', border:false" style="height:40px; padding:5px;">
            <input id="acmc-search-keyword" class="easyui-textbox"
                data-options="width:300, prompt:'설비코드 또는 설비명 검색'" />
            <a href="javascript:void(0)" id="acmc-search-btn" class="easyui-linkbutton cgray">조회</a>
        </div>
        <!-- 하단: 설비 그리드 -->
        <div data-options="region:'center', border:false">
            <table id="acmc-search-grid"></table>
        </div>
    </div>
</div>

<!-- 설비 검색 다이얼로그 버튼 -->
<div id="acmc-search-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acmc-confirm-button">확인</a>
</div>
