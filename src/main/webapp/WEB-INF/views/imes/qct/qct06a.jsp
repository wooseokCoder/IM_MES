<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)qct06a.jsp 1.0 2026/03/06                                        --%>
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
<%-- 자주검사 연계 관리 (조립/가공/리스트 통합)                              --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/03/06                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<style>
.datagrid-view.noStyle .datagrid-body table,
.datagrid-view.noStyle .datagrid-header table {
    width: auto !important;
}
/* numberbox 에디터 우측 정렬 강제 */
.datagrid-editable .numberbox-f .textbox-text,
.datagrid-editable .numberbox-f input {
    text-align: right !important;
}
/* 버튼 영역 */
.panel-btn-area {
    padding: 7px 8px;
    text-align: center;
    border-bottom: 1px solid #e2dddd;
    background-color: #F5F5F5;
}
.panel-btn-area .l-btn {
    min-width: 150px;
    margin: 0 3px;
}
/* 버튼 비활성화 시 사라짐 방지 */
.panel-btn-area .l-btn-disabled,
.panel-btn-area .l-btn-disabled:hover {
    display: inline-block !important;
    opacity: 0.5;
}
/* 탭 내부 패널 헤더 */
#account-layout .panel-title {
    font-size: 14px;
    line-height: 22px;
}
#account-layout .panel-header {
    padding: 5px 5px;
    height: 28px;
    background-color: #F5F5F5;
    border-bottom: 1px solid #e2dddd;
}
/* 검색조건 패널 */
.search-cond-panel {
    padding: 8px 10px;
    background-color: #f9f9f9;
    border-bottom: 1px solid #e2dddd;
}
.search-cond-panel .cond-label {
    font-weight: bold;
    margin-right: 5px;
}
.search-cond-panel .cond-field {
    margin-right: 15px;
    display: inline-block;
}
/* D0A 그리드 헤더 배경색 통일 */
#d0a-popup .datagrid-header,
#d0a-popup .datagrid-header td,
#d0a-popup .datagrid-htable td,
#d0a-popup .datagrid-header-inner {
    background-color: #f5f5f5;
}
#d0a-popup .panel-header {
    padding: 0 8px;
    height: 32px;
    line-height: 32px;
    background-color: #F5F5F5;
    border-bottom: 1px solid #e2dddd;
    overflow: visible;
}
#d0a-popup .panel-title {
    font-size: 14px;
    height: 32px;
    line-height: 32px;
    margin: 0;
    padding: 0;
}
#d0a-popup .panel-tool {
    display: none !important;
}
</style>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/qct/qct06a.js?v=260319A" />"></script>

</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 화면 첫 로딩시 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

<!-- 상단: topnav2 + 조회 버튼 -->
<div data-options="region:'north', border:false" style="height:auto">
    <div id="search-toolbar" class="wui-toolbar">
        <form id="search-form">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup><col width="*"></colgroup>
                    <tr class="topnav_sty">
                        <td>
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

<!-- 탭 + 콘텐츠 영역 -->
<div data-options="region:'center', border:false" style="padding:3px">
    <div id="main-tabs" class="easyui-tabs" data-options="fit:true, border:true, plain:true">

        <!-- ===== 조립 탭 (PLANTS=3603) ===== -->
        <div title="조립" data-options="selected:true" style="padding:0">
            <div class="easyui-layout" data-options="fit:true" id="assy-layout">
                <!-- 검색조건 -->
                <div data-options="region:'north', border:false" style="height:40px">
                    <div class="search-cond-panel">
                        <span class="cond-field">
                            <span class="cond-label">대표코드</span>
                            <input id="assy_partCode" class="easyui-textbox" data-options="width:150" />
                        </span>
                        <span class="cond-field">
                            <span class="cond-label">검색어</span>
                            <input id="assy_searchLike" class="easyui-textbox" data-options="width:150" />
                        </span>
                    </div>
                </div>
                <!-- 콘텐츠: 가로 3분할 -->
                <div data-options="region:'center', border:false">
                    <div class="easyui-layout" data-options="fit:true">
                        <!-- 1. 모델 -->
                        <div data-options="region:'west', split:true, border:true" style="width:20%">
                            <table id="assy-part-grid"></table>
                        </div>
                        <!-- 2+3. 검사그룹 + 검사항목 -->
                        <div data-options="region:'center', border:false">
                            <div class="easyui-layout" data-options="fit:true">
                                <!-- 2. 검사그룹 (버튼 + 그리드) -->
                                <div data-options="region:'west', split:true, border:true" style="width:35%">
                                    <div class="easyui-layout" data-options="fit:true">
                                        <div data-options="region:'north', border:false" style="height:40px">
                                            <div class="panel-btn-area">
                                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="assy-add-btn" data-options="disabled:${INS}">검사그룹추가</a>
                                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="assy-save-btn" data-options="disabled:${UPD}">순번저장</a>
                                            </div>
                                        </div>
                                        <div data-options="region:'center', border:false">
                                            <table id="assy-group-grid"></table>
                                        </div>
                                    </div>
                                </div>
                                <!-- 3. 검사항목 -->
                                <div data-options="region:'center', border:true">
                                    <table id="assy-detail-grid"></table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===== 그룹 연계 리스트 탭 ===== -->
        <div title="그룹 연계 리스트" style="padding:0">
            <div class="easyui-layout" data-options="fit:true" id="list-layout">
                <!-- 검색조건 -->
                <div data-options="region:'north', border:true" style="height:40px">
                    <div class="search-cond-panel">
                        <span class="cond-field">
                            <span class="cond-label">대표코드/명</span>
                            <input id="list_partLike" class="easyui-textbox" data-options="width:150" />
                        </span>
                        <span class="cond-field">
                            <span class="cond-label">검사 그룹명</span>
                            <input id="list_groupLike" class="easyui-textbox" data-options="width:150" />
                        </span>
                    </div>
                </div>
                <!-- 그리드 -->
                <div data-options="region:'center', border:false">
                    <table id="list-grid"></table>
                </div>
            </div>
        </div>

    </div>
</div>

</div>

<!-- 그룹 그리드 컨텍스트 메뉴 (공유) -->
<div id="group-context-menu" class="easyui-menu" data-options="hideOnUnhover:false">
    <div id="ctx-delete-group">삭제</div>
</div>

<!-- D0A 검사그룹 추가 팝업 (href 방식) -->
<div id="d0a-popup" class="easyui-dialog" style="width:1250px;height:650px"
     data-options="closed:true, modal:true, title:'검사그룹 선택',
                   href:'<c:url value="/imes/qct/qct06a_d0a.do" />',
                   onLoad: initD0aPopup,
                   buttons: '#d0a-popup-buttons'">
</div>
<div id="d0a-popup-buttons" style="padding:5px">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d0a-close-button">닫기</a>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
</html>
