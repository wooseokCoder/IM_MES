<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std44a.jsp 1.0 2026/02/20                                         --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2026 WSC, INC.                                           --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 모델군 관리 (STD44A)                                                   --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/02/20                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/std/std44a.js?v=260220A" />"></script>

</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<style>
.panel-btn-area {
    padding: 3px 5px;
    text-align: right;
    white-space: nowrap;
}
.panel-btn-area .easyui-linkbutton {
    margin-left: 3px;
}
#account-layout .panel-title {
    font-size: 14px;
    line-height: 22px;
}
#account-layout .panel-header {
    padding: 2px 5px;
    height : 25px;
    background-color: #F5F5F5;
    border-bottom: 1px solid #e2dddd;
}
.datagrid-cell input[type="radio"] {
    margin: 0;
    vertical-align: middle;
}
.datagrid-cell label {
    margin: 0;
    vertical-align: middle;
    line-height: normal;
    font-weight: normal;
}
.panel-btn-area .l-btn-disabled,
.panel-btn-area .l-btn-disabled:hover {
    display: inline-block !important;
    opacity: 0.5;
}
/* 1440x900 이하 해상도에서 버튼 축소 — 두 줄 방지 */
@media screen and (max-width: 1600px) {
    .panel-btn-area .l-btn {
        min-width: 40px !important;
        height: 26px !important;
        margin: 0 1px !important;
    }
    .panel-btn-area .l-btn .l-btn-text {
        font-size: 11px;
        line-height: 22px;
    }
}
@media screen and (max-width: 1440px) {
    .panel-btn-area .l-btn {
        min-width: 32px !important;
        height: 22px !important;
        margin: 0 !important;
    }
    .panel-btn-area .l-btn .l-btn-text {
        font-size: 11px;
        line-height: 18px;
    }
    .panel-btn-area {
        padding: 2px 3px;
    }
}
</style>

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

<!-- ====================================================================== -->
<!-- NORTH: 검색 툴바 (전체 너비)                                           -->
<!-- ====================================================================== -->
<div data-options="region:'north', border:false" style="height:auto;">
    <div id="search-toolbar" class="wui-toolbar">
        <form id="search-form">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="*">
                    </colgroup>
                    <tr class="topnav_sty">
                        <td colspan="1">
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- ====================================================================== -->
<!-- CENTER: 3단 수평 분할 (구분 → 시리즈 → 모델)                           -->
<!-- ====================================================================== -->
<div data-options="region:'center', border:false">
    <div class="easyui-layout" data-options="fit:true">

        <!-- 좌측: 구분 (B) 그리드 -->
        <div data-options="region:'west', border:true, split:true" style="width:28%">
            <div id="toolbar-b" class="panel-btn-area">
                <a href="javascript:void(0)" id="btn-add-b" class="easyui-linkbutton c6" data-item="BTN_001" data-options="disabled:${INS}">추가</a>
                <a href="javascript:void(0)" id="btn-save-b" class="easyui-linkbutton c6" data-item="BTN_002" data-options="disabled:${UPD}">저장</a>
                <a href="javascript:void(0)" id="btn-del-b" class="easyui-linkbutton c6" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
            </div>
            <table id="grid-b"></table>
        </div>

        <!-- 중앙+우측 (2단 분할) -->
        <div data-options="region:'center', border:false">
            <div class="easyui-layout" data-options="fit:true">

                <!-- 중앙: 시리즈 (M) 그리드 -->
                <div data-options="region:'west', border:true, split:true" style="width:45%">
                    <div id="toolbar-m" class="panel-btn-area">
                        <a href="javascript:void(0)" id="btn-add-m" class="easyui-linkbutton c6" data-item="BTN_001" data-options="disabled:${INS}">추가</a>
                        <a href="javascript:void(0)" id="btn-save-m" class="easyui-linkbutton c6" data-item="BTN_002" data-options="disabled:${UPD}">저장</a>
                        <a href="javascript:void(0)" id="btn-del-m" class="easyui-linkbutton c6" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
                    </div>
                    <table id="grid-m"></table>
                </div>

                <!-- 우측: 모델 (S) 그리드 -->
                <div data-options="region:'center', border:true">
                    <div id="toolbar-s" class="panel-btn-area">
                        <a href="javascript:void(0)" id="btn-add-s" class="easyui-linkbutton c6" data-item="BTN_001" data-options="disabled:${INS}">추가</a>
                        <a href="javascript:void(0)" id="btn-save-s" class="easyui-linkbutton c6" data-item="BTN_002" data-options="disabled:${UPD}">저장</a>
                        <a href="javascript:void(0)" id="btn-del-s" class="easyui-linkbutton c6" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
                    </div>
                    <table id="grid-s"></table>
                </div>

            </div>
        </div>

    </div>
</div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
