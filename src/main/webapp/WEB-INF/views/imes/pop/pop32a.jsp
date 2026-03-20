<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)pob32a.jsp 1.0 2026/03/04                                         --%>
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
<%-- 비가동 현황 (조립) - POB32A                                            --%>
<%-- 원본: ProActive POP32A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- 검색: 시작일 ~ 종료일 (주간 범위)                                      --%>
<%-- 그리드: 비가동 이력 (설비명, 작업자, 비가동명, 시간 등)                --%>
<%-- 컨텍스트 메뉴: 신규등록, 열기, 삭제                                     --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/03/04                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop32a.js"/>?v=260319B"></script>
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop32a_dialog.js"/>?v=260303S"></script>
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop32a_d2a.js"/>?v=260311A"></script>

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

<!-- 그리드 영역 -->
<!-- AS-IS: acGridView1 (GridType=SEARCH, 읽기전용) -->
<table id="search-grid">
  <thead>
    <tr>
      <!-- 숨김 컬럼 -->
      <th data-options="field:'idleId', hidden:true">IDLE_ID</th>
      <th data-options="field:'idleCode', hidden:true">비가동코드</th>
      <th data-options="field:'empCode', hidden:true">작업자코드</th>
      <th data-options="field:'mcCode', hidden:true">설비코드</th>
      <!-- 표시 컬럼 -->
      <!-- AS-IS: AddCheckEdit("IF_FLAG","SAP전송 여부") -->
      <th data-options="field:'ifFlag', width:80, halign:'center', align:'center', resizable:true,
          formatter:formatIfFlag">SAP전송</th>
      <!-- AS-IS: AddTextEdit("EMP_CODE","사번", visible:true) -->
      <th data-options="field:'empName', width:100, halign:'center', align:'center', resizable:true">작업자</th>
      <!-- AS-IS: AddTextEdit("MC_NAME","작업장") -->
      <th data-options="field:'mcName', width:150, halign:'center', align:'left', resizable:true">작업장</th>
      <!-- AS-IS: AddTextEdit("IDLE_NAME","비가동구분") -->
      <th data-options="field:'idleName', width:140, halign:'center', align:'left', resizable:true">비가동구분</th>
      <!-- AS-IS: AddDateEdit("START_TIME","시작시간", LONG_DATE2) -->
      <th data-options="field:'startTime', width:140, halign:'center', align:'center', resizable:true,
          formatter:formatDateTime">시작시간</th>
      <!-- AS-IS: AddDateEdit("END_TIME","완료시간", LONG_DATE2) -->
      <th data-options="field:'endTime', width:140, halign:'center', align:'center', resizable:true,
          formatter:formatDateTime">완료시간</th>
      <!-- AS-IS: AddTextEdit("IDLE_TIME","비가동시간(분)", QTY) -->
      <th data-options="field:'idleTime', width:100, halign:'center', align:'right', resizable:true,
          formatter:formatQty">비가동시간(분)</th>
      <!-- AS-IS: AddTextEdit("REG_EMP_NAME","등록자") -->
      <th data-options="field:'regEmpName', width:100, halign:'center', align:'center', resizable:true">등록자</th>
    </tr>
  </thead>
</table>

<!-- 조회 영역 (Toolbar) -->
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <!-- 1단: topnav + 조회 버튼 -->
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup>
                    <col width="0px">   <!-- 라벨 -->
                    <col width="500px">  <!-- 날짜 범위 -->
                    <col width="*">      <!-- 남은 공간 -->
                </colgroup>
                <tr class="topnav_sty">
                    <td colspan="3">
                        <div>
                            <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                            <div>
                                <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                            </div>
                        </div>
                    </td>
                </tr>
                <!-- AS-IS: acWeekDate1 (주간 날짜 범위) -->
                <tr>
                    <th class="h table-Search-h search-label-h" data-item="LAB_001"></th>
                    <td class="d">
                        <c:set var="wdPrefix" value="wd1"/>
                        <%@ include file="/WEB-INF/views/imes/com/acWeekDate.jsp" %>
                    </td>
                    <td class="d"></td>
                </tr>
            </table>
        </fieldset>
        <!-- 2단: 액션 버튼 -->
        <fieldset class="div-line-new-sub grd-div-btn">
            <table cellpadding="7" class="search-table tableEtc-c wd-100">
                <tr>
                    <td class="h">
                        <div class="dis_flex_gap4">
                            <!-- 신규등록 버튼 (AS-IS: acBarButtonItem1) -->
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">신규등록</a>
                            <!-- 삭제 버튼 (AS-IS: acBarButtonItem2) -->
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="delete-button" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
                        </div>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 조회영역을 붙일 패널 -->
<div data-options="region:'north', border:true" id="search-grid-panel"></div>

</div>

<!-- 신규등록 다이얼로그 (32AD0A) INCLUDE -->
<%@ include file="/WEB-INF/views/imes/pop/pop32a_d0a.jsp" %>

<!-- 작업자 선택 다이얼로그 (32AD1A) INCLUDE -->
<%@ include file="/WEB-INF/views/imes/pop/pop32a_d1a.jsp" %>

<!-- 비가동시간 수정 다이얼로그 (32AD2A) INCLUDE -->
<%@ include file="/WEB-INF/views/imes/pop/pop32a_d2a.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
