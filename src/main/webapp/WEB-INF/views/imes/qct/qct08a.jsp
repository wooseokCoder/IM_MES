<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)qct08a.jsp 1.0 2026/03/17                                        --%>
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
<%-- 자주검사 현황 - 내부 탭(조립/가공)                                      --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/03/17                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<style>
/* D0A 팝업 이미지 스타일 */
#d0a-popup .ng-img-cell {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}
/* common.css '.datagrid-body table { width:100% }' 오버라이드 */
.datagrid-view.noStyle .datagrid-body table {
    width: auto !important;
}
/* 검색 영역: JS 초기화 combobox 높이 보정 */
#search-area .search-table .combo {
    height: 26px !important;
    line-height: 22px;
    box-sizing: border-box;
}
#search-area .search-table .combo .combo-arrow {
    height: 26px !important;
}
/* 검색 영역: editable:false 시 readonly 배경색 흰색 유지 */
#search-area .search-table .textbox-text[readonly],
#search-area .search-table .combo-text[readonly] {
    background-color: #fff !important;
}
</style>

<!-- 이미지 컨텍스트 메뉴 공통 모듈 -->
<script type="text/javascript" src="<c:url value="/resources/js/include/imgContextMenu.js" />"></script>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/qct/qct08a.js?v=260318" />"></script>

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

    <!-- 상단: 버튼 + 검색조건 영역 -->
    <div data-options="region:'north', border:false" style="height:auto;">
        <div class="wui-toolbar">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup><col width="*"></colgroup>
                    <tr class="topnav_sty">
                        <td>
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                                    <a href="javascript:void(0)" id="qms-send-button" class="easyui-linkbutton c6" data-item="BTN_001" data-options="disabled:${UPD}">QMS 전송</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
            <!-- 검색조건 (탭별 show/hide) -->
            <div id="search-area">
                <!-- 조립 검색조건 -->
                <fieldset id="search-assy" class="Remake-div-line-new">
                    <table cellpadding="0" class="search-table tableSearch-c wd-100" style="table-layout:auto;">
                        <tr>
                            <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>판매오더</span></th>
                            <td class="d" style="width:auto; min-width:0px;">
                                <input class="easyui-textbox" id="s_orderLike_assy" data-options="width:120" />
                            </td>
                            <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>호기</span></th>
                            <td class="d" style="width:auto; min-width:0px;">
                                <input class="easyui-textbox" id="s_hogiLike_assy" data-options="width:100" />
                            </td>
                            <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>공정</span></th>
                            <td class="d" style="width:auto; min-width:0px; white-space:nowrap;">
                                <input id="s_procCode_assy" />
                                <a href="javascript:void(0)" id="s_procFind_assy"
                                   style="display:inline-block;width:22px;height:22px;cursor:pointer;vertical-align:middle;
                                          border:1px solid #b4b4b4;background:#f5f5f5;text-align:center;line-height:22px;
                                          border-radius:2px;margin-left:2px;">
                                    <img src="<%=request.getContextPath()%>/resources/jquery/easyui-1.4/themes/icons/search.png"
                                        style="width:16px;height:16px;vertical-align:middle" />
                                </a>
                            </td>
                            <td class="d" style="width:99%"></td>
                        </tr>
                    </table>
                </fieldset>
                <!-- 가공 검색조건 (초기 숨김) -->
                <fieldset id="search-mach" class="Remake-div-line-new" style="display:none;">
                    <table cellpadding="0" class="search-table tableSearch-c wd-100" style="table-layout:auto;">
                        <tr>
                            <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>모델</span></th>
                            <td class="d" style="width:auto; min-width:0px;">
                                <input class="easyui-textbox" id="s_modelLike_mach" data-options="width:120" />
                            </td>
                            <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>공정</span></th>
                            <td class="d" style="width:auto; min-width:0px; white-space:nowrap;">
                                <input id="s_procCode_mach" />
                                <a href="javascript:void(0)" id="s_procFind_mach"
                                   style="display:inline-block;width:22px;height:22px;cursor:pointer;vertical-align:middle;
                                          border:1px solid #b4b4b4;background:#f5f5f5;text-align:center;line-height:22px;
                                          border-radius:2px;margin-left:2px;">
                                    <img src="<%=request.getContextPath()%>/resources/jquery/easyui-1.4/themes/icons/search.png"
                                        style="width:16px;height:16px;vertical-align:middle" />
                                </a>
                            </td>
                            <td class="d" style="width:99%"></td>
                        </tr>
                    </table>
                </fieldset>
            </div>
        </div>
    </div>

    <!-- 중앙: 탭 + 그리드 -->
    <div data-options="region:'center', border:false">
        <div id="main-tabs" class="easyui-tabs" data-options="fit:true, border:false, tabHeight:27">

            <!-- 탭 1: 조립 (PLANTS=1000) -->
            <div title="조립">
                <div class="easyui-layout" data-options="fit:true">
                    <div data-options="region:'center', border:false">
                        <table id="grid-assy"></table>
                    </div>
                </div>
            </div>

            <!-- 탭 2: 가공 (PLANTS=2000) -->
            <div title="가공">
                <div class="easyui-layout" data-options="fit:true">
                    <div data-options="region:'center', border:false">
                        <table id="grid-mach"></table>
                    </div>
                </div>
            </div>

        </div>
    </div>

</div>

<!-- D0A 검사 이미지 팝업 (href 방식) -->
<div id="d0a-popup" class="easyui-dialog" style="width:320px;height:340px"
     data-options="closed:true, modal:true, title:'검사 이미지',
                   href:'<c:url value="/imes/qct/qct08a_d0a.do" />',
                   onLoad: initD0aPopup,
                   buttons: '#d0a-popup-buttons'">
</div>
<div id="d0a-popup-buttons" style="padding:5px">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d0a-close-button">닫기</a>
</div>

<!-- 공정 검색 공통 팝업 -->
<%@ include file="/WEB-INF/views/imes/com/acProcForm.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
