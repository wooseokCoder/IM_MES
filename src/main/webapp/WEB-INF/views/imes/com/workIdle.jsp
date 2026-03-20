<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 비가동 사유 선택 공통 팝업 (workIdle)                                 --%>
<%-- AS-IS: WorkIdle.cs - 5개 화면에서 공통 사용                           --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/workIdle.jsp" %>      --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 비가동 사유 선택 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/workIdle.js?v=260319E" />"></script>

<!-- 비가동 사유 선택 다이얼로그 (공통) -->
<div id="wi-dialog" class="easyui-dialog" style="visibility:hidden;width:400px;height:230px"
    data-options="closed:true, modal:true, buttons:'#wi-dialog-buttons'">
    <div style="padding:10px 15px;">
        <!-- 라벨: 비가동 사유 (중앙 정렬) -->
        <div style="text-align:center;font-weight:bold;font-size:14px;margin-bottom:10px;">비가동 사유</div>
        <!-- Row 1: 분 후 시작 콤보 -->
        <div style="margin-bottom:8px;display:flex;align-items:center;">
            <input id="wi-idle-minute" class="easyui-combobox"
                data-options="width:250, editable:false, panelHeight:'auto',
                    valueField:'codeCd', textField:'codeName'" />
            <span style="margin-left:8px;font-weight:bold;white-space:nowrap;">분 후 시작</span>
        </div>
        <!-- Row 2: 비가동 코드 콤보 -->
        <div>
            <input id="wi-idle-cause" class="easyui-combobox"
                data-options="width:355, editable:false, panelHeight:200,
                    valueField:'idleCode', textField:'idleName'" />
        </div>
    </div>
</div>

<!-- 비가동 사유 선택 다이얼로그 버튼 -->
<div id="wi-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="wi-confirm-button"
        style="width:120px;height:35px;font-size:14px;font-weight:bold;">확인</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="wi-close-button"
        style="width:120px;height:35px;font-size:14px;font-weight:bold;">닫기</a>
</div>
