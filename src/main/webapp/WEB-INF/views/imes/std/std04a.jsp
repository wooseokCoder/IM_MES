<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std04a.jsp 1.0 2026/02/23                                         --%>
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
<%-- 표준 자원 관리                                                          --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/02/23                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<style>
/* noStyle 그리드: common.css width:100% 오버라이드 (emp-grid, D1A 미리보기 그리드 공용) */
.datagrid-view.noStyle .datagrid-body table {
    width: auto !important;
}
/* 하단 그리드 헤더 빈 영역 배경색 통일 */
.datagrid-view.noStyle .datagrid-header {
    background: #f5f5f5;
}
/* 레이아웃 패널 간 padding 제거 (그리드 상하 밀착) */
#account-layout .layout-panel-center .panel-body,
#account-layout .layout-panel-south .panel-body {
    padding: 0 !important;
}
/* 하단 가용사원 그리드 줄무늬 배경 (흰색/회색 교대) */
#account-layout .layout-panel-south .datagrid-row:nth-child(odd) {
    background: #ffffff;
}
#account-layout .layout-panel-south .datagrid-row:nth-child(even) {
    background: #f5f5f5;
}
/* disabled 항목 마우스 커서 변경 방지 */
input[disabled],
input:disabled,
.datagrid-cell label,
.l-btn-disabled,
.l-btn-disabled:hover,
.textbox-disabled,
.textbox-disabled input,
.combo-disabled,
.combo-disabled input {
    cursor: default !important;
}
/* D0A 버튼 초기 숨김 (EasyUI 파싱 전 깜빡임 방지) */
#d0a-buttons {
    visibility: hidden;
}
/* D0A 우측 treegrid 폴더/파일 아이콘 숨김 (트리 토글만 표시) */
#d0a-popup .tree-icon {
    display: none;
}
/* D0A 팝업 상단 폼 td 우측 여백 */
#d0a-popup .popup-search-table td.d {
    padding-right: 29px;
}
/* D0A 팝업 상단 폼 체크박스/라디오 */
#d0a-popup .popup-search-table input[type="checkbox"],
#d0a-popup .popup-search-table input[type="radio"] {
    width: 16px;
    height: 16px;
    accent-color: #0078d4;
    cursor: pointer;
    margin-bottom: 0;
}
#d0a-popup .popup-search-table label {
    font-weight: normal;
    margin-bottom: 0;
}
/* D0A 팝업 그리드 체크박스 흰색 배경 (흐리게 보이는 현상 방지) */
#d0a-popup .datagrid-cell-check,
#d0a-popup .datagrid-header-check {
    background-color: #fff;
}
#d0a-popup .datagrid-cell-check input[type="checkbox"],
#d0a-popup .datagrid-cell input[type="checkbox"]:not([disabled]) {
    width: 16px;
    height: 16px;
    accent-color: #0078d4;
    cursor: pointer;
}

/* 메인 그리드: 체크된 행 하이라이트 제거 (체크와 행선택 분리) */
#search-grid-panel .datagrid-row-checked {
    background: inherit !important;
}
</style>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/std/std04a.js?v=260225I" />"></script>

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

<!-- ================================================================== -->
<!-- 조회 영역 (north)                                                    -->
<!-- ================================================================== -->
<div data-options="region:'north', border:true" style="height:130px" id="search-grid-panel">
    <div id="search-toolbar" class="wui-toolbar">
        <form id="search-form">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="80px">
                        <col width="220px">
                        <col width="*">
                    </colgroup>
                    <tr class="topnav_sty">
                        <td colspan="3">
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                                    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="excel-import-button" data-item="BTN_003" data-options="disabled:${INS}">
                                        <img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/excel_download.png" /> 가져오기
                                    </a>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th class="h table-Search-h search-label-h" data-item="LAB_001"><span>자원코드/명</span></th>
                        <td class="d">
                            <input id="s_mcLike" class="easyui-textbox" data-options="width:220"/>
                        </td>
                        <td class="d"></td>
                    </tr>
                </table>
            </fieldset>
            <!-- 버튼 영역 (컨텍스트 메뉴 → 버튼) -->
            <fieldset class="div-line-new-sub grd-div-btn">
                <table cellpadding="5" class="search-table tableEtc-c wd-100">
                    <tr><td class="h">
                        <div class="dis_flex_gap4">
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="btn-new" data-item="BTN_001" data-options="disabled:${INS}">등록</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="btn-open" data-item="BTN_002" data-options="disabled:${UPD}">열기</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="btn-delete" data-item="BTN_004" data-options="disabled:${DEL}">삭제</a>
                        </div>
                    </td></tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- ================================================================== -->
<!-- 설비 목록 그리드 (center)                                            -->
<!-- ================================================================== -->
<div data-options="region:'center', border:false">
<table id="search-grid">
  <thead>
    <tr>
      <th data-options="field:'ck', width:40, halign:'center', align:'center', checkbox:true"></th>
      <th data-options="field:'mcCode', width:120, halign:'center', align:'center', resizable:true, data_item:'GRD_001'">자원코드</th>
      <th data-options="field:'mcName', width:180, halign:'center', align:'left', resizable:true, data_item:'GRD_002'">자원명</th>
      <th data-options="field:'mcGroup', width:100, halign:'center', align:'center', resizable:true,
          formatter:function(v){return formatCode('C020',v);}, data_item:'GRD_003'">자원그룹</th>
      <th data-options="field:'mcFlag', width:200, halign:'center', align:'left', resizable:true,
          formatter:function(v){return formatRadioGroup('S908',v);}, data_item:'GRD_004'">구분</th>
      <th data-options="field:'isSap', width:110, halign:'center', align:'center', resizable:true,
          formatter:formatCheck, data_item:'GRD_005'">SAP존재여부</th>
      <th data-options="field:'isPop', width:110, halign:'center', align:'center', resizable:true,
          formatter:formatCheck, data_item:'GRD_006'">실적입력 여부</th>
      <th data-options="field:'isSimGantt', width:160, halign:'center', align:'center', resizable:true,
          formatter:formatCheck, data_item:'GRD_007'">간트 표시여부(시뮬레이터)</th>
      <th data-options="field:'mcSeq', width:80, halign:'center', align:'right', resizable:true, data_item:'GRD_008'">표시순서</th>
      <th data-options="field:'procCode', width:80, halign:'center', align:'center', resizable:true, hidden:true">공정</th>
      <th data-options="field:'scomment', width:200, halign:'center', align:'left', resizable:true, data_item:'GRD_009'">비고</th>
      <th data-options="field:'regDate', width:130, halign:'center', align:'center', resizable:true, hidden:true">최초 등록일</th>
      <th data-options="field:'regEmp', width:100, halign:'center', align:'center', resizable:true, hidden:true">최초 등록자코드</th>
      <th data-options="field:'regEmpName', width:100, halign:'center', align:'center', resizable:true, hidden:true">최초 등록자</th>
      <th data-options="field:'mdfyDate', width:130, halign:'center', align:'center', resizable:true, hidden:true">최근 수정일</th>
      <th data-options="field:'mdfyEmp', width:100, halign:'center', align:'center', resizable:true, hidden:true">최근 수정자코드</th>
      <th data-options="field:'mdfyEmpName', width:100, halign:'center', align:'center', resizable:true, hidden:true">최근 수정자</th>
    </tr>
  </thead>
</table>
</div>

<!-- ================================================================== -->
<!-- 가용사원 그리드 (south)                                              -->
<!-- ================================================================== -->
<div data-options="region:'south', border:false" style="height:35%">
<table id="emp-grid">
  <thead>
    <tr>
      <th data-options="field:'orgName', width:150, halign:'center', align:'center', resizable:true">부서명</th>
      <th data-options="field:'empCode', width:120, halign:'center', align:'center', resizable:true">사원코드</th>
      <th data-options="field:'empName', width:150, halign:'center', align:'center', resizable:true">사원명</th>
    </tr>
  </thead>
</table>
</div>

</div>

<!-- ================================================================== -->
<!-- D0A 팝업 - 설비 상세 편집 (href 동적 로드)                           -->
<!-- ================================================================== -->
<div id="d0a-popup" class="easyui-dialog" style="visibility:hidden;width:830px;height:660px;"
    data-options="closed:true, modal:true, title:'표준 자원 등록',
    href:'<c:url value="/imes/std/std04a_d0a.do" />',
    onLoad: initD0aPopup, buttons:'#d0a-buttons'">
</div>

<!-- D0A 팝업 버튼 -->
<div id="d0a-buttons" style="visibility:hidden;padding:5px">
    <a href="javascript:void(0)" class="easyui-linkbutton c6 d0a-new-btn" id="d0a-clear-button">초기화</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 d0a-new-btn" id="d0a-save-button">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 d0a-edit-btn" id="d0a-save-close-button">저장&닫기</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 d0a-edit-btn" id="d0a-delete-button">삭제</a>
</div>

<!-- ================================================================== -->
<!-- D1A 팝업 - 엑셀 임포트 (href 동적 로드)                              -->
<!-- ================================================================== -->
<div id="d1a-popup" class="easyui-dialog" style="visibility:hidden;width:950px;height:600px;"
    data-options="closed:true, modal:true, title:'Excel 파일에서 가져오기',
    href:'<c:url value="/imes/std/std04a_d1a.do" />',
    onLoad: initD1aPopup, buttons:'#d1a-buttons'">
</div>

<!-- D1A 팝업 버튼 -->
<div id="d1a-buttons" style="visibility:hidden;padding:5px">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d1a-load-button">엑셀 파일 열기</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d1a-save-button">저장</a>
</div>

<!-- ================================================================== -->
<!-- 삭제사유 입력 다이얼로그 (include 방식)                              -->
<!-- ================================================================== -->
<%@ include file="/WEB-INF/views/imes/std/std04a_dialog.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
