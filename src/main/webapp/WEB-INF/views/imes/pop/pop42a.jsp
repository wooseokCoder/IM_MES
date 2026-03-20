<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)pop42a.jsp 1.0 2026/03/10                                         --%>
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
<%-- 일일점검 이력 조회 - POP42A                                            --%>
<%-- 좌우 분할 마스터-디테일 구조 (조회 전용)                                --%>
<%--   상단: 검색조건 (점검일 범위, 설비코드/명)                            --%>
<%--   좌측: 일별 점검설비 리스트 (마스터, 240px)                           --%>
<%--   우측: 점검 결과 (디테일, 셀 병합)                                    --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/03/10                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop42a.js"/>?v=260312A"></script>

<style>
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
/* 검색 영역: datebox width 고정 */
#search-toolbar .search-table .datebox {
    width: 120px !important;
}
/* 검색 영역: JS 초기화 combobox 높이 보정 */
#search-toolbar .search-table .combo {
    height: 26px !important;
    line-height: 22px;
    box-sizing: border-box;
}
#search-toolbar .search-table .combo .combo-arrow {
    height: 26px !important;
}
/* editable:false 시 readonly 배경색 흰색 유지 */
#search-toolbar .search-table .textbox-text[readonly],
#search-toolbar .search-table .combo-text[readonly] {
    background-color: #fff !important;
}
</style>

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

    <!-- 상단: 조회 버튼 + 검색 영역 -->
    <div data-options="region:'north', border:false" style="height:auto;">
        <div id="search-toolbar" class="wui-toolbar">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup><col width="*"></colgroup>
                    <tr class="topnav_sty">
                        <td>
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button"
                                       class="easyui-linkbutton cgray" data-item="BTN_000"
                                       data-options="disabled:${RET}">조회</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100" style="table-layout:auto;">
                    <tr>
                        <td class="d" style="width:auto; min-width:0px;">
                            <input id="s_chkDate" />
                        </td>
                        <td class="d" style="width:auto; min-width:0px; white-space:nowrap;">
                            <div style="display:flex; align-items:center; flex-wrap:nowrap;">
                                <input class="easyui-datebox" id="s_sMdcrDate" data-options="width:120, editable:false" />
                                <span style="margin:0 2px;">~</span>
                                <input class="easyui-datebox" id="s_eMdcrDate" data-options="width:120, editable:false" />
                            </div>
                        </td>
                        <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>설비코드/명</span></th>
                        <td class="d" style="width:auto; min-width:0px;">
                            <input class="easyui-textbox" id="s_mdcrMcLike" data-options="width:150" />
                        </td>
                        <td class="d" style="width:99%"></td>
                    </tr>
                </table>
            </fieldset>
        </div>
    </div>

    <!-- 중앙: 좌우 분할 마스터-디테일 그리드 영역 -->
    <div data-options="region:'center', border:false">
        <div class="easyui-layout" data-options="fit:true">

            <!-- 좌측: 마스터 그리드 - 일별 점검설비 리스트 (고정 240px) -->
            <div data-options="region:'west', split:true, border:true, title:'일별 점검설비 리스트'" style="width:320px;">
                <table id="master-grid">
                    <thead>
                        <tr>
                            <th data-options="field:'mdcrMcCode', width:80, halign:'center', align:'center', resizable:true">설비코드</th>
                            <th data-options="field:'mdcrMcName', width:100, halign:'center', align:'left', resizable:true">설비명</th>
                            <th data-options="field:'mdcrDate', width:80, halign:'center', align:'center', resizable:true,
                                formatter:formatDate8">점검일</th>
                        </tr>
                    </thead>
                </table>
            </div>

            <!-- 우측: 디테일 그리드 - 점검 결과 (가변) -->
            <div data-options="region:'center', border:true, title:'점검 결과'" id="detail-panel">
                <table id="detail-grid">
                    <thead>
                        <tr>
                            <th data-options="field:'mdcrNo', hidden:true">점검항목ID</th>
                            <th data-options="field:'mdcrType', width:100, halign:'center', align:'center', resizable:true">구분</th>
                            <th data-options="field:'mdcrNum', hidden:true">점검번호</th>
                            <th data-options="field:'mdcrContents', width:200, halign:'center', align:'center', resizable:true">점검항목</th>
                            <th data-options="field:'mdcrCheck', width:200, halign:'center', align:'center', resizable:true">점검내용</th>
                            <th data-options="field:'mdcrMeans', width:120, halign:'center', align:'center', resizable:true">점검방법</th>
                            <th data-options="field:'mdcrResult', width:100, halign:'center', align:'center', resizable:true">결과</th>
                            <th data-options="field:'mdcrScomment', width:150, halign:'center', align:'center', resizable:true">비고</th>
                            <th data-options="field:'mdcrSeq', hidden:true">순번</th>
                        </tr>
                    </thead>
                </table>
            </div>

        </div>
    </div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
