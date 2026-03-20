<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)qct05a.jsp 1.1 2026/03/10                                        --%>
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
<%-- 자주검사 그룹 관리 (ASSY/MACH 공용)                                    --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.1 2026/03/10                                                --%>
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
.datagrid-row-modified td {
    background-color: #90EE90 !important;
}
.panel-btn-area {
    padding: 3px 5px;
    text-align: right;
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
    height: 25px;
    background-color: #F5F5F5;
    border-bottom: 1px solid #e2dddd;
}
.panel-btn-area .l-btn-disabled,
.panel-btn-area .l-btn-disabled:hover {
    display: inline-block !important;
    opacity: 0.5;
}
/* D0A 그리드 헤더 배경색 통일 (스크롤바 위 빈 영역 포함) */
#d0a-popup .datagrid-header,
#d0a-popup .datagrid-header td,
#d0a-popup .datagrid-htable td,
#d0a-popup .datagrid-header-inner {
    background-color: #f5f5f5;
}
/* D0A 팝업 패널 헤더: 메인 화면과 동일 스타일 */
#d0a-popup .panel-header {
    padding: 2px 5px;
    height: 25px;
    background-color: #F5F5F5;
    border-bottom: 1px solid #e2dddd;
}
#d0a-popup .panel-title {
    font-size: 14px;
    line-height: 22px;
}
/* D0A 패널 헤더 도구 아이콘 숨김 */
#d0a-popup .panel-tool {
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
    var PAGE_SHOW_GRP_SEQ = true;
    var PAGE_SHOW_INS_GRP_MODEL = false;
    var PAGE_SHOW_PROD_TYPE = false;
    var PAGE_SHOW_IMAGE = false;
</script>

<!-- 이미지 컨텍스트 메뉴 공통 모듈 -->
<script type="text/javascript" src="<c:url value="/resources/js/include/imgContextMenu.js" />"></script>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/qct/qct05a.js?v=260318A" />"></script>

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

<!-- 상단: 조회 + 탭 바 -->
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
    <!-- 탭 바 (조립/가공 전환) -->
    <div class="plants-tab-bar">
        <span id="tab-assy" class="plants-tab-item active">조립</span>
        <span id="tab-mach" class="plants-tab-item">가공</span>
    </div>
</div>

<!-- 좌우 분할 영역 -->
<div data-options="region:'center', border:false" style="padding:3px">
    <div class="easyui-layout" data-options="fit:true">

        <!-- 좌측: 검사그룹 (마스터) -->
        <div id="west-panel" data-options="region:'west', split:true, border:true" style="width:35%">
            <div id="west-inner-layout" class="easyui-layout" data-options="fit:true">
                <!-- 마스터 버튼 + 그리드 -->
                <div data-options="region:'center', border:false">
                    <div class="easyui-layout" data-options="fit:true">
                        <div data-options="region:'north', border:false" style="height:40px; overflow:hidden;">
                            <div id="toolbar-master" class="panel-btn-area">
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="add-group-button" data-options="disabled:${INS}">추가</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-group-button" data-options="disabled:${UPD}">저장</a>
                            </div>
                        </div>
                        <div data-options="region:'center', border:false">
                            <div id="master-panel-assy" style="width:100%;height:100%">
                                <table id="master-grid-assy"></table>
                            </div>
                            <div id="master-panel-mach" style="width:100%;height:100%;display:none">
                                <table id="master-grid-mach"></table>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 검사그룹 이미지 패널 (초기: 닫힘 — 가공 탭에서만 표시) -->
                <div data-options="region:'south', split:false, border:true, title:'검사그룹 이미지', closed:true" id="image-panel" style="height:50%">
                    <div id="toolbar-image" class="panel-btn-area">
                        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="image-select-button" data-options="disabled:${UPD}">추가</a>
                        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="image-save-button" data-options="disabled:${UPD}">저장</a>
                    </div>
                    <div id="image-container" style="text-align:center; overflow:auto; height:calc(100% - 30px);padding-bottom:12px;">
                        <img id="group-image" src="" style="width:100%; max-height:100%; object-fit:contain; display:none" />
                    </div>
                </div>
            </div>
        </div>

        <!-- 우측: 검사항목 (디테일) -->
        <div data-options="region:'center', border:true">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north', border:false" style="height:40px; overflow:hidden;">
                    <div id="toolbar-detail" class="panel-btn-area">
                        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="add-ins-button" data-options="disabled:${UPD}">검사항목선택</a>
                        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="del-ins-button" data-options="disabled:${DEL}">삭제</a>
                    </div>
                </div>
                <div data-options="region:'center', border:false">
                    <div id="detail-panel-assy" style="width:100%;height:100%">
                        <table id="detail-grid-assy"></table>
                    </div>
                    <div id="detail-panel-mach" style="width:100%;height:100%;display:none">
                        <table id="detail-grid-mach"></table>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

</div>

<!-- D0A 검사 항목 선택 팝업 (href 방식) -->
<div id="d0a-popup" class="easyui-dialog" style="width:1150px;height:550px"
     data-options="closed:true, modal:true, title:'검사 항목 선택',
                   href:'<c:url value="/imes/qct/qct05a_d0a.do" />',
                   onLoad: initD0aPopup,
                   buttons: '#d0a-popup-buttons'">
</div>
<div id="d0a-popup-buttons" style="padding:5px">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d0a-save-button">저장후닫기</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d0a-close-button">닫기</a>
</div>

<!-- 이미지 파일 선택용 hidden input -->
<input type="file" id="_qct05a_img_input" accept="image/*" style="display:none" />

<!-- 공정 검색 공통 팝업 -->
<%@ include file="/WEB-INF/views/imes/com/acProcForm.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
</html>
