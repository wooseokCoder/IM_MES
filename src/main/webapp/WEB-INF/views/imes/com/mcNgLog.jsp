<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- NG 이력 공통 팝업 (mcNgLog)                                           --%>
<%-- AS-IS: McNgLog.cs - 부적합 현황 그리드 (읽기 전용)                     --%>
<%-- 백엔드: Pop30aService.pop30aSerA() (POP30A_SER_A)                     --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/mcNgLog.jsp" %>       --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- NG 이력 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/mcNgLog.js?v=260319A" />"></script>

<!-- NG 이력 다이얼로그 (공통) -->
<div id="mngl-dialog" class="easyui-dialog" style="visibility:hidden;width:900px;height:450px"
    data-options="closed:true, modal:true, buttons:'#mngl-dialog-buttons'">
    <div class="easyui-layout" data-options="fit:true">
        <!-- 상단: 검색 영역 -->
        <div data-options="region:'north', border:false" style="height:40px; padding:5px;">
            <span style="font-weight:bold;">조회기간:</span>
            <input id="mngl-start-date" class="easyui-datebox"
                data-options="width:130, editable:false" />
            <span> ~ </span>
            <input id="mngl-end-date" class="easyui-datebox"
                data-options="width:130, editable:false" />
            <a href="javascript:void(0)" id="mngl-search-btn" class="easyui-linkbutton cgray">조회</a>
        </div>
        <!-- 하단: NG 이력 그리드 -->
        <div data-options="region:'center', border:false">
            <table id="mngl-grid"></table>
        </div>
    </div>
</div>

<!-- NG 이력 다이얼로그 버튼 -->
<div id="mngl-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="mngl-close-button">닫기</a>
</div>
