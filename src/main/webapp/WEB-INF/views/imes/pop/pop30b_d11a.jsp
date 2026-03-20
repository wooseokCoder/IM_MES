<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 단말기 - 가공 - 실적현황 다이얼로그 (D11A)        일단 미사용                       --%>
<%-- 원본: ProActive POP30B_D11A.cs                                         --%>
<%--                                                                        --%>
<%-- 레이아웃 (원본 구조):                                                   --%>
<%--   실적/비가동 이력 조회 그리드 (전체 너비)                                --%>
<%--   하단: 닫기 버튼                                                      --%>
<%--                                                                        --%>
<%-- @author AI Assistant                                                   --%>
<%-- @version 1.0 2026/03/18                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop30b_d11a.js"/>?v=260318A"></script>

<!-- 실적현황 다이얼로그 -->
<div id="d11a-dialog" style="visibility:hidden;padding:5px;">
    <table id="d11a-grid"></table>
</div>

<!-- 다이얼로그 버튼 -->
<div id="d11a-dialog-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d11a-close-button">닫기</a>
</div>
