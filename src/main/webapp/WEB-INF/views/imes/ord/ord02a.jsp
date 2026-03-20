<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord02a.jsp 1.0 2026/02/10                                         --%>
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
<%-- 이메일 수신자그룹 관리 (ORD02A)                                        --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/02/10                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- 그리드 인라인 편집 스타일: textbox 테두리 제거 (셀 편집 느낌) -->
<style>
.datagrid-body .datagrid-editable .textbox,
.datagrid-body .datagrid-editable .textbox.textbox-focused {
    border: none !important;
    box-shadow: none !important;
    background-color: transparent !important;
    border-radius: 0 !important;
}
.datagrid-body .datagrid-editable .textbox .textbox-text,
.datagrid-body .datagrid-editable .textbox input.textbox-text {
    background: transparent !important;
    padding-left: 8px !important;
}
/* disabled 버튼이 숨겨지는 문제 수정 (ui-pepper-grinder 테마 display:none 오버라이드) */
.l-btn-disabled, .l-btn-disabled:hover {
    display: inline-block !important;
    pointer-events: none;
}
/* 좌측 패널 접기 화살표 숨김 */
#account-layout .layout-expand,
#account-layout .layout-split-west { cursor: default !important; }
#account-layout > .layout-split-west { display: none !important; }
/* 패널 헤더 스타일 */
#account-layout .panel-header {
    padding: 2px 5px;
    height: 25px;
    background-color: #F5F5F5;
    border-bottom: 1px solid #e2dddd;
}
#account-layout .panel-title {
    font-size: 14px;
    line-height: 22px;
}
#account-layout .panel-tool {
    display: none !important;
}
</style>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord02a.js"/>?v=<%= System.currentTimeMillis() %>"></script>

</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

<!-- 상단: 검색 영역 (전체 너비) -->
<div data-options="region:'north', border:false" style="height:auto;">
    <div id="search-toolbar" class="wui-toolbar">
        <form id="search-form">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="*">  <!-- 전체 공간 -->
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

<!-- 메인 분할 영역 (좌: 수신자그룹 / 우: 그룹별 사원) -->
<div data-options="region:'center', border:false" style="overflow:hidden;">
    <div class="easyui-layout" data-options="fit:true">

        <!-- 좌측 패널: 수신자 그룹 -->
        <div data-options="region:'west', split:true, collapsible:false, border:true, title:'수신자 그룹'" style="width:50%;">
            <div class="easyui-layout" data-options="fit:true">
                <!-- 좌측 버튼 영역 -->
                <div data-options="region:'north', border:false" style="height:40px; padding:5px;">
                    <div style="text-align:right;">
                        <a href="javascript:void(0)" id="group-add-button" class="easyui-linkbutton c6" data-item="BTN_001" data-options="disabled:${INS}">추가</a>
                        <a href="javascript:void(0)" id="group-save-button" class="easyui-linkbutton c6" data-item="BTN_002" data-options="disabled:${UPD}">저장</a>
                        <a href="javascript:void(0)" id="group-delete-button" class="easyui-linkbutton c6" data-item="BTN_003" data-options="disabled:${DEL}">그룹삭제</a>
                    </div>
                </div>
                <!-- 좌측 그리드 -->
                <div data-options="region:'center', border:false">
                    <table id="group-grid"></table>
                </div>
            </div>
        </div>

        <!-- 우측 패널: 그룹별 세부 내역 -->
        <div data-options="region:'center', border:true, title:'그룹별 세부 내역'">
            <div class="easyui-layout" data-options="fit:true">
                <!-- 우측 버튼 영역 -->
                <div data-options="region:'north', border:false" style="height:40px; padding:5px;">
                    <div style="text-align:right;">
                        <a href="javascript:void(0)" id="excel-upload-button" class="easyui-linkbutton c6" data-item="BTN_004">엑셀업로드</a>
                        <a href="javascript:void(0)" id="emp-add-button" class="easyui-linkbutton c6" data-item="BTN_005" data-options="disabled:${INS}">사원추가</a>
                        <a href="javascript:void(0)" id="emp-delete-button" class="easyui-linkbutton c6" data-item="BTN_007" data-options="disabled:${DEL}">사원삭제</a>
                        <a href="javascript:void(0)" id="emp-save-button" class="easyui-linkbutton c6" data-item="BTN_006" data-options="disabled:${UPD}">저장</a>
                    </div>
                </div>
                <!-- 우측 그리드 -->
                <div data-options="region:'center', border:false">
                    <table id="emp-grid"></table>
                </div>
            </div>
        </div>

    </div>
</div>

</div>


<!-- 엑셀업로드 팝업 (href 동적 로드) -->
<div id="d0a-popup" class="easyui-dialog" data-options="
    width:900, height:550, closed:true, modal:true, title:'수신자그룹 엑셀 업로드',
    href:'<c:url value="/imes/ord/ord02a_d0a.do" />',
    onLoad: initD0aPopup">
</div>

<!-- 사원 검색 공통 팝업 (acEmpForm) -->
<%@ include file="/WEB-INF/views/imes/com/acEmpForm.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
