<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 일일점검 공통 팝업 (mcDailyCheck)                                     --%>
<%-- AS-IS: McDailyCheck.cs - POP30A/POP30B 등 여러 화면에서 공통 사용     --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- AS-IS 레이아웃 (McDailyCheck.cs Line 268):                            --%>
<%--   ClientSize: 870 x 627                                               --%>
<%--   btnSave: (569,5) 149x56 "저장"                                      --%>
<%--   btnOk:   (728,5) 137x56 "확인"                                      --%>
<%--   Grid:    (5,71)  860x551                                            --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/mcDailyCheck.jsp" %>   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 일일점검 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/mcDailyCheck.js?v=260319A" />"></script>

<!-- 일일점검 다이얼로그 (AS-IS: McDailyCheck.cs ClientSize 870x627) -->
<div id="mdc-dialog" class="easyui-dialog" style="visibility:hidden;width:870px;height:640px"
    data-options="closed:true, modal:true, buttons:'#mdc-dialog-buttons'">
    <table id="mdc-grid"></table>
</div>

<!-- 다이얼로그 버튼 (AS-IS: btnSave="저장" + btnOk="확인") -->
<div id="mdc-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="mdc-save-button"
        style="width:130px;height:45px;font-size:15px;font-weight:bold;">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="mdc-close-button"
        style="width:130px;height:45px;font-size:15px;font-weight:bold;">확인</a>
</div>
