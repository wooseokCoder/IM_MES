<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)qct04a.jsp 1.2 2026/03/10                                        --%>
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
<%-- 자주검사 항목 관리 - 내부 탭(조립/가공)                                --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.2 2026/03/10                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<style>
/* common.css '.datagrid-body table { width:100% }' 오버라이드 */
.datagrid-view.noStyle .datagrid-body table {
    width: auto !important;
}
/* 비활성화 버튼 사라짐 방지 */
.grd-div-btn .l-btn-disabled,
.grd-div-btn .l-btn-disabled:hover {
    display: inline-block !important;
    opacity: 0.5;
}
/* 검사이미지 셀 */
.ins-img-cell {
    max-width: 100%;
    height: auto;
    object-fit: contain;
    display: block;
}
.ins-img-cell.img-loading {
    height: 60px;
}
/* D1A 팝업 스타일 */
#d1a-popup .datagrid-header {
    background-color: #f5f5f5;
}
#d1a-popup .panel-header {
    padding: 2px 5px;
    height: 25px;
    background-color: #F5F5F5;
    border-bottom: 1px solid #e2dddd;
}
#d1a-popup .panel-title {
    font-size: 14px;
    line-height: 22px;
}
#d1a-popup .panel-tool {
    display: none !important;
}
/* 탭 바 스타일 */
.plants-tab-bar {
    padding: 0 5px;
    border-bottom: 1px solid #ddd;
    background: #f9f9f9;
}
.plants-tab-item {
    display: inline-block;
    padding: 5px 18px;
    cursor: pointer;
    border: 1px solid #ccc;
    border-bottom: none;
    margin-right: 2px;
    background: #e8e8e8;
    position: relative;
    top: 1px;
    font-size: 12px;
}
.plants-tab-item.active {
    background: #fff;
    font-weight: bold;
    border-bottom: 1px solid #fff;
}
</style>

<!-- 화면별 변수 설정 (기본값: 조립) -->
<script type="text/javascript">
    var PAGE_PLANTS = '3603';
    var PAGE_PLANTS_NAME = '조립';
    var PAGE_LPROC_CODE = 'ASSY';
    var PAGE_SHOW_INS_IMG = true;
</script>

<!-- EasyUI 컬럼 이동 플러그인 -->
<script type="text/javascript" src="<c:url value="/resources/jquery/columns-ext.js" />"></script>

<!-- 이미지 컨텍스트 메뉴 공통 모듈 -->
<script type="text/javascript" src="<c:url value="/resources/js/include/imgContextMenu.js" />"></script>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/qct/qct04a.js?v=260318" />"></script>

</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<div class="easyui-layout" data-options="fit:true" id="account-layout">

<!-- 상단: 조회 + 버튼 -->
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
            <fieldset class="div-line-new-sub grd-div-btn">
                <table cellpadding="7" class="search-table tableEtc-c wd-100">
                    <tr>
                        <td class="h">
                            <div class="dis_flex_gap4">
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="add-button" data-item="BTN_001" data-options="disabled:${INS}">추가</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_002" data-options="disabled:${UPD}">저장</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="delete-button" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="grp-button" data-item="BTN_004" data-options="disabled:${UPD}">그룹관리</a>
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
    <!-- 탭 바 (조립/가공 전환) -->
    <div class="plants-tab-bar">
        <span id="tab-assy" class="plants-tab-item active">조립</span>
        <span id="tab-mach" class="plants-tab-item">가공</span>
    </div>
</div>

<!-- 그리드 영역 (탭별 독립 그리드) -->
<div data-options="region:'center', border:false">
    <div id="tab-panel-assy" style="width:100%;height:100%">
        <table id="grid-assy"></table>
    </div>
    <div id="tab-panel-mach" style="width:100%;height:100%;display:none">
        <table id="grid-mach"></table>
    </div>
</div>

</div>

<!-- D1A 검사그룹 관리 팝업 (href 방식) -->
<div id="d1a-popup" class="easyui-dialog" style="width:1150px;height:550px"
     data-options="closed:true, modal:true, title:'검사그룹 관리',
                   href:'<c:url value="/imes/qct/qct04a_d1a.do" />',
                   onLoad: initD1aPopup,
                   buttons: '#d1a-popup-buttons'">
</div>
<div id="d1a-popup-buttons" style="padding:5px">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d1a-save-button">저장후닫기</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d1a-close-button">닫기</a>
</div>

<!-- 컨텍스트 메뉴 (우클릭) -->
<div id="grid-context-menu" class="easyui-menu" data-options="hideOnUnhover:false">
    <div id="ctx-delete">삭제</div>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
