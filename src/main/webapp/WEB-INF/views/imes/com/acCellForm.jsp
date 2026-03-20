<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 작업장(CELL/설비) 선택 팝업 공통 (acCellForm)                          --%>
<%-- AS-IS: ChangeCellMc → LSE_MACHINE_QUERY2                              --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/acCellForm.jsp" %>     --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 작업장 선택 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/acCellForm.js?v=260318B" />"></script>

<!-- 작업장 선택 다이얼로그 (공통) -->
<div id="acce-search-dialog" class="easyui-dialog" style="visibility:hidden;width:450px;height:450px"
    data-options="closed:true, modal:true, buttons:'#acce-search-buttons'">
    <div class="easyui-layout" data-options="fit:true">
        <!-- 상단: 검색 영역 -->
        <div data-options="region:'north', border:false" style="height:40px; padding:5px; display:none;">
            <input id="acce-search-keyword" class="easyui-textbox"
                data-options="width:250, prompt:'자원코드 또는 자원명 검색'" />
            <a href="javascript:void(0)" id="acce-search-btn" class="easyui-linkbutton cgray">조회</a>
        </div>
        <!-- 하단: 설비 그리드 -->
        <div data-options="region:'center', border:false">
            <table id="acce-search-grid"></table>
        </div>
    </div>
</div>

<!-- 작업장 선택 다이얼로그 버튼 -->
<div id="acce-search-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acce-confirm-button">확인</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acce-close-button">닫기</a>
</div>
