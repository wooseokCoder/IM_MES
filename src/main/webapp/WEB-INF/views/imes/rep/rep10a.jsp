<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)rep10a.jsp 1.0 2026/03/16                                         --%>
<%-- 작업자현황 - REP10A                                                   --%>
<%-- 작성자: 송우석                                                        --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<script type="text/javascript" src="<c:url value="/resources/js/imes/rep/rep10a.js"/>?v=260316A"></script>
</head>

<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 로딩바 -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

<!-- ============================================================ -->
<!-- NORTH: topnav + 조회 버튼 (검색조건 없음) -->
<!-- ============================================================ -->
<div data-options="region:'north', border:false">
    <div id="search-toolbar" class="wui-toolbar datagrid-toolbar">
        <form id="search-form">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="0px">
                        <col width="*">
                    </colgroup>
                    <tr class="topnav_sty">
                        <td colspan="2">
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-options="disabled:${RET}">조회</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- ============================================================ -->
<!-- CENTER: 메인 그리드 -->
<!-- ============================================================ -->
<div data-options="region:'center', border:false">
    <table id="grid1">
      <thead>
        <tr>
          <!-- AS-IS: LookupEdit EMP_GUBUN2 구분 (S029) -->
          <th data-options="field:'empGubun2', width:80, halign:'center', align:'center',
              formatter:formatS029">구분</th>
          <!-- AS-IS: TextEdit EMP_CODE 사원번호 -->
          <th data-options="field:'empCode', width:80, halign:'center', align:'center'">사원번호</th>
          <!-- AS-IS: TextEdit EMP_NAME 사원명 -->
          <th data-options="field:'empName', width:80, halign:'center', align:'center'">사원명</th>
          <!-- AS-IS: TextEdit EMP_STAT 상태 -->
          <th data-options="field:'empStat', width:50, halign:'center', align:'center'">상태</th>
          <!-- AS-IS: TextEdit PROD_HOGI 호기 -->
          <th data-options="field:'prodHogi', width:140, halign:'center', align:'left'">호기</th>
          <!-- AS-IS: TextEdit CUSTOMER 고객사/수주처명 -->
          <th data-options="field:'customer', width:140, halign:'center', align:'left'">고객사/수주처명</th>
          <!-- AS-IS: TextEdit SAP_WO_NO 생산오더번호 -->
          <th data-options="field:'sapWoNo', width:100, halign:'center', align:'center'">생산오더번호</th>
          <!-- AS-IS: TextEdit WO_SEQ 작업번호 -->
          <th data-options="field:'woSeq', width:60, halign:'center', align:'center'">작업번호</th>
          <!-- AS-IS: TextEdit PROC_CODE 공정 -->
          <th data-options="field:'procCode', width:70, halign:'center', align:'center'">공정</th>
          <!-- AS-IS: TextEdit PART_CODE 반제품코드 -->
          <th data-options="field:'partCode', width:100, halign:'center', align:'center'">반제품코드</th>
          <!-- AS-IS: TextEdit PART_NAME 반제품명 -->
          <th data-options="field:'partName', width:280, halign:'center', align:'left'">반제품명</th>
          <!-- AS-IS: TextEdit IDLE_CODE 비가동코드 -->
          <th data-options="field:'idleCode', width:80, halign:'center', align:'center'">비가동코드</th>
          <!-- AS-IS: TextEdit IDLE_NAME 비가동코드 (AS-IS 헤더 동일) -->
          <th data-options="field:'idleName', width:100, halign:'center', align:'center'">비가동코드</th>
          <!-- AS-IS: DateEdit ACT_START_TIME 시작시간 (MEDIUM_DATE) -->
          <th data-options="field:'actStartTime', width:150, halign:'center', align:'center',
              formatter:formatMediumDate">시작시간</th>
        </tr>
      </thead>
    </table>
</div>

</div>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
