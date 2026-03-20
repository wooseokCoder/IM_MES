<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)pop33a.jsp 1.0 2026/03/05                                         --%>
<%-- SAP실적처리 - POP33A                                                  --%>
<%-- 원본: ProActive POP33A_M0A.cs                                         --%>
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
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop33a.js"/>?v=260305A"></script>
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
<!-- NORTH: 검색 영역 -->
<!-- ============================================================ -->
<div data-options="region:'north', border:false">
    <div id="search-toolbar" class="wui-toolbar datagrid-toolbar">
        <form id="search-form">
            <!-- 1단: topnav + 검색 -->
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
                    <!-- 검색 조건 행: AS-IS와 동일하게 1줄 -->
                    <tr>
                        <th class="h table-Search-h search-label-h"></th>
                        <td class="d">
                            <table cellpadding="3" style="border-collapse:collapse;">
                                <tr>
                                    <!-- 작업일 (AS-IS: acCheckedComboBoxEdit1 DATE) -->
                                    <td style="padding-right:5px;">
                                        <select id="s_dateType" class="easyui-combobox" name="dateType"
                                            data-options="width:80, panelHeight:'auto', editable:false">
                                            <option value="">전체</option>
                                            <option value="WORK_DATE" selected>작업일</option>
                                        </select>
                                    </td>
                                    <!-- 시작일 ~ 종료일 -->
                                    <td style="padding-right:3px;">
                                        <input id="s_sWorkDate" class="easyui-datebox" name="sWorkDate"
                                            data-options="width:110, editable:false" />
                                    </td>
                                    <td style="padding:0 3px;">~</td>
                                    <td style="padding-right:10px;">
                                        <input id="s_eWorkDate" class="easyui-datebox" name="eWorkDate"
                                            data-options="width:110, editable:false" />
                                    </td>
                                    <!-- 작업자명/번호 (AS-IS: acTextEdit1 EMP_LIKE) -->
                                    <td style="padding-right:5px;">
                                        <span style="font-size:12px;">작업자</span>
                                    </td>
                                    <td style="padding-right:10px;">
                                        <input id="s_empLike" class="easyui-textbox" name="empLike"
                                            data-options="width:120" />
                                    </td>
                                    <!-- 구분 (AS-IS: acLookupEdit1 EMP_GUBUN2, S029) -->
                                    <td style="padding-right:5px;">
                                        <span style="font-size:12px;">구분</span>
                                    </td>
                                    <td>
                                        <input id="s_empGubun2" class="easyui-combobox" name="empGubun2"
                                            codeGrup="S029"
                                            data-options="width:100, panelHeight:'auto', editable:false,
                                            mode:'remote', loader:jcombo.loader" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>

            <!-- 2단: 제외 저장 + 기준 설정 버튼 -->
            <fieldset class="div-line-new-sub grd-div-btn">
                <table cellpadding="7" class="search-table tableEtc-c wd-100">
                    <tr>
                        <td class="h">
                            <div class="dis_flex_gap4">
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="except-save-button">제외 저장</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="popup-setting-button">오류율 팝업 기준 설정</a>
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- ============================================================ -->
<!-- CENTER: 그리드 영역 (좌-우 분할) -->
<!-- ============================================================ -->
<div data-options="region:'center', border:false">
    <div class="easyui-layout" data-options="fit:true">

        <!-- WEST: Grid1 (일별 공수) -->
        <div data-options="region:'west', border:true, split:true" style="width:35%">
            <table id="grid1">
              <thead>
                <tr>
                  <!-- AS-IS: LookupEdit EMP_GUBUN2 구분 (S029) -->
                  <th data-options="field:'empGubun2', width:80, halign:'center', align:'center',
                      formatter:formatS029">구분</th>
                  <!-- AS-IS: TextEdit EMP_CODE 사번 -->
                  <th data-options="field:'empCode', width:80, halign:'center', align:'center'">사번</th>
                  <!-- AS-IS: TextEdit EMP_NAME 성명 -->
                  <th data-options="field:'empName', width:80, halign:'center', align:'center'">성명</th>
                  <!-- Hidden: WORK_DATE_KEY -->
                  <th data-options="field:'workDateKey', hidden:true">WORK_DATE_KEY</th>
                  <!-- AS-IS: DateEdit WORK_DATE 작업일 (SHORT_DATE) -->
                  <th data-options="field:'workDate', width:90, halign:'center', align:'center',
                      formatter:formatShortDate">작업일</th>
                  <!-- AS-IS: TextEdit ACT_TIME 실적시간 (F2) -->
                  <th data-options="field:'actTime', width:90, halign:'center', align:'right',
                      formatter:formatF2">실적시간</th>
                  <!-- AS-IS: TextEdit SAP_TIME SAP전송시간 (F2) -->
                  <th data-options="field:'sapTime', width:100, halign:'center', align:'right',
                      formatter:formatF2">SAP전송시간</th>
                  <!-- AS-IS: TextEdit SAP_WORK_TIME SAP근태시간 (F2) -->
                  <th data-options="field:'sapWorkTime', width:100, halign:'center', align:'right',
                      formatter:formatF2">SAP근태시간</th>
                  <!-- AS-IS: TextEdit SAP_RATE 공수오류율 (PER2) -->
                  <th data-options="field:'sapRate', width:90, halign:'center', align:'right',
                      formatter:formatPer2">공수오류율</th>
                  <!-- AS-IS: TextEdit SAP_ACT_TIME 전송완료시간 (F2, hidden) -->
                  <th data-options="field:'sapActTime', width:100, halign:'center', align:'right', hidden:true,
                      formatter:formatF2">전송완료시간</th>
                  <!-- AS-IS: CheckEdit IS_EXCEPT 제외 - 편집가능 셀 배경색 -->
                  <th data-options="field:'isExcept', width:60, halign:'center', align:'center',
                      formatter:formatCheckbox,
                      styler:function(){return 'background-color:#FFFFC0;';}">제외</th>
                </tr>
              </thead>
            </table>
        </div>

        <!-- CENTER: Detail 영역 (실적현황/삭제현황 탭) -->
        <div data-options="region:'center', border:true">
            <div class="easyui-layout" data-options="fit:true">
                <!-- NORTH: 버튼 행 (탭 위에 표시) -->
                <div data-options="region:'north', border:false" style="height:35px;">
                    <div id="detail-toolbar" class="wui-toolbar" style="padding:3px 5px;">
                        <div class="dis_flex_gap4" style="align-items:center;">
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button">저장</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="delete-button">삭제</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="delete-cancel-button">삭제취소</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="sap-send-button">SAP전송</a>
                            <span id="status-label" style="font-size:11px; color:#888; margin-left:10px;">상태가 저장일때 SAP전송 가능합니다.</span>
                        </div>
                    </div>
                </div>
                <!-- CENTER: 탭 (실적현황/삭제현황) -->
                <div data-options="region:'center', border:false">
                    <div id="detail-tabs" class="easyui-tabs" data-options="fit:true, border:false">
                <div title="실적현황" id="tab-act" style="padding:0">
                    <!-- Grid2: 실적현황 (ACT 탭) -->
                    <table id="grid2">
                      <thead>
                        <tr>
                          <!-- SEL: 선택 체크박스 - 편집가능 셀 배경색 -->
                          <th data-options="field:'sel', width:40, halign:'center', align:'center',
                              formatter:formatSelCheckbox,
                              styler:function(){return 'background-color:#FFFFC0;';}">선택</th>
                          <!-- IF_SEL_FLAG: 상태코드 (JS 로직용, hidden) -->
                          <th data-options="field:'ifSelFlag', width:60, halign:'center', align:'center', hidden:true">상태코드</th>
                          <!-- IF_SEL_FLAG_NM: 상태명 (SP에서 변환) -->
                          <th data-options="field:'ifSelFlagNm', width:60, halign:'center', align:'center'">상태</th>
                          <!-- ACT_TYPE: 구분 -->
                          <th data-options="field:'actType', width:60, halign:'center', align:'left'">구분</th>
                          <!-- ACT_START_TIME: 시작시간 (MEDIUM_DATE2) -->
                          <th data-options="field:'actStartTime', width:130, halign:'center', align:'center',
                              formatter:formatMediumDate2">시작시간</th>
                          <!-- ACT_END_TIME: 종료시간 (MEDIUM_DATE2) -->
                          <th data-options="field:'actEndTime', width:130, halign:'center', align:'center',
                              formatter:formatMediumDate2">종료시간</th>
                          <!-- ACT_TIME: 실적시간(분) (NUMERIC) -->
                          <th data-options="field:'actTime', width:80, halign:'center', align:'right',
                              formatter:formatNumeric">실적시간(분)</th>
                          <!-- WORK_LOC: SAP작업장 -->
                          <th data-options="field:'workLoc', width:80, halign:'center', align:'left'">SAP작업장</th>
                          <!-- ACT_CONTENTS: 비가동코드 -->
                          <th data-options="field:'actContents', width:80, halign:'center', align:'left'">비가동코드</th>
                          <!-- SAP_CODE: 비가동코드(SAP) hidden -->
                          <th data-options="field:'sapCode', width:100, halign:'center', align:'left', hidden:true">비가동코드(SAP)</th>
                          <!-- IDLE_NAME: 비가동명 -->
                          <th data-options="field:'idleName', width:100, halign:'center', align:'left'">비가동명</th>
                          <!-- PROC_CODE: 공정 -->
                          <th data-options="field:'procCode', width:60, halign:'center', align:'left'">공정</th>
                          <!-- SAP_WO_NO: 생산오더번호 -->
                          <th data-options="field:'sapWoNo', width:110, halign:'center', align:'left'">생산오더번호</th>
                          <!-- WO_SEQ: 오퍼레이션 -->
                          <th data-options="field:'woSeq', width:80, halign:'center', align:'left'">오퍼레이션</th>
                          <!-- ORDER_CONF_VALUE: SAP입고번호 -->
                          <th data-options="field:'orderConfValue', width:100, halign:'center', align:'left'">SAP입고번호</th>
                          <!-- ORDER_CONF_COUNT: SAP입고카운터 -->
                          <th data-options="field:'orderConfCount', width:100, halign:'center', align:'left'">SAP입고카운터</th>
                          <!-- CONF_VALUE: SAP실적번호 -->
                          <th data-options="field:'confValue', width:100, halign:'center', align:'left'">SAP실적번호</th>
                          <!-- CONF_COUNT: SAP실적카운터 -->
                          <th data-options="field:'confCount', width:100, halign:'center', align:'left'">SAP실적카운터</th>
                          <!-- EAI_RESULT: SAP결과 -->
                          <th data-options="field:'eaiResult', width:60, halign:'center', align:'center'">SAP결과</th>
                          <!-- EAI_SCOMMENT: SAP결과 비고 -->
                          <th data-options="field:'eaiScomment', width:150, halign:'center', align:'left'">SAP결과 비고</th>
                          <!-- PRE_WORK: 준비작업여부 -->
                          <th data-options="field:'preWork', width:80, halign:'center', align:'left'">준비작업여부</th>
                          <!-- ORDER_NO: 판매오더 -->
                          <th data-options="field:'orderNo', width:100, halign:'center', align:'left'">판매오더</th>
                          <!-- ORDER_LINE: 라인 -->
                          <th data-options="field:'orderLine', width:60, halign:'center', align:'left'">라인</th>
                          <!-- PROD_HOGI: 호기 -->
                          <th data-options="field:'prodHogi', width:60, halign:'center', align:'left'">호기</th>
                          <!-- MODEL: 모델 -->
                          <th data-options="field:'model', width:100, halign:'center', align:'left'">모델</th>
                          <!-- CUSTOMER: 거래처 -->
                          <th data-options="field:'customer', width:100, halign:'center', align:'left'">거래처</th>
                          <!-- PROC_ST: ST (hidden) -->
                          <th data-options="field:'procSt', width:60, halign:'center', align:'left', hidden:true">ST</th>
                          <!-- EMP_CODE: 작업자 코드 (hidden) -->
                          <th data-options="field:'empCode', width:80, halign:'center', align:'left', hidden:true">작업자 코드</th>
                          <!-- EMP_NAME: 작업자 (hidden) -->
                          <th data-options="field:'empName', width:80, halign:'center', align:'left', hidden:true">작업자</th>
                          <!-- WO_END_TIME: 오더완료일 (MEDIUM_DATE2) -->
                          <th data-options="field:'woEndTime', width:130, halign:'center', align:'center',
                              formatter:formatMediumDate2">오더완료일</th>
                          <!-- MC_NAME: 작업장 (hidden) -->
                          <th data-options="field:'mcName', width:80, halign:'center', align:'left', hidden:true">작업장</th>
                          <!-- PROD_TYPE: 작업장 구분 -->
                          <th data-options="field:'prodType', width:80, halign:'center', align:'left'">작업장 구분</th>
                          <!-- PROC_STAT: 실적상태 (S034 Lookup) -->
                          <th data-options="field:'procStat', width:80, halign:'center', align:'center',
                              formatter:formatS034">실적상태</th>
                          <!-- KEY -->
                          <th data-options="field:'key', width:120, halign:'center', align:'left'">KEY</th>
                        </tr>
                      </thead>
                    </table>
                </div>
                <div title="삭제현황" id="tab-del" style="padding:0">
                    <!-- Grid3: 삭제현황 (DEL 탭) -->
                    <table id="grid3">
                      <thead>
                        <tr>
                          <!-- Same as Grid2 but fewer columns (no SAP columns) - 편집가능 셀 배경색 -->
                          <th data-options="field:'sel', width:40, halign:'center', align:'center',
                              formatter:formatSelCheckbox,
                              styler:function(){return 'background-color:#FFFFC0;';}">선택</th>
                          <!-- IF_SEL_FLAG: 상태코드 (JS 로직용, hidden) -->
                          <th data-options="field:'ifSelFlag', width:60, halign:'center', align:'center', hidden:true">상태코드</th>
                          <!-- IF_SEL_FLAG_NM: 상태명 (SP에서 변환) -->
                          <th data-options="field:'ifSelFlagNm', width:60, halign:'center', align:'center'">상태</th>
                          <th data-options="field:'actType', width:60, halign:'center', align:'left'">구분</th>
                          <th data-options="field:'actStartTime', width:130, halign:'center', align:'center',
                              formatter:formatMediumDate2">시작시간</th>
                          <th data-options="field:'actEndTime', width:130, halign:'center', align:'center',
                              formatter:formatMediumDate2">종료시간</th>
                          <th data-options="field:'actTime', width:80, halign:'center', align:'right',
                              formatter:formatNumeric">실적시간(분)</th>
                          <th data-options="field:'workLoc', width:80, halign:'center', align:'left'">SAP작업장</th>
                          <th data-options="field:'actContents', width:80, halign:'center', align:'left'">비가동코드</th>
                          <th data-options="field:'sapCode', width:100, halign:'center', align:'left', hidden:true">비가동코드(SAP)</th>
                          <th data-options="field:'idleName', width:100, halign:'center', align:'left'">비가동명</th>
                          <th data-options="field:'procCode', width:60, halign:'center', align:'left'">공정</th>
                          <th data-options="field:'sapWoNo', width:110, halign:'center', align:'left'">생산오더번호</th>
                          <th data-options="field:'woSeq', width:80, halign:'center', align:'left'">오퍼레이션</th>
                          <th data-options="field:'preWork', width:80, halign:'center', align:'left'">준비작업여부</th>
                          <th data-options="field:'orderNo', width:100, halign:'center', align:'left'">판매오더</th>
                          <th data-options="field:'orderLine', width:60, halign:'center', align:'left'">라인</th>
                          <th data-options="field:'prodHogi', width:60, halign:'center', align:'left'">호기</th>
                          <th data-options="field:'model', width:100, halign:'center', align:'left'">모델</th>
                          <th data-options="field:'customer', width:100, halign:'center', align:'left'">거래처</th>
                          <th data-options="field:'procSt', width:60, halign:'center', align:'left', hidden:true">ST</th>
                          <th data-options="field:'empCode', width:80, halign:'center', align:'left', hidden:true">작업자 코드</th>
                          <th data-options="field:'empName', width:80, halign:'center', align:'left', hidden:true">작업자</th>
                          <th data-options="field:'woEndTime', width:130, halign:'center', align:'center',
                              formatter:formatMediumDate2">오더완료일</th>
                          <th data-options="field:'mcName', width:80, halign:'center', align:'left', hidden:true">작업장</th>
                          <th data-options="field:'prodType', width:80, halign:'center', align:'left'">작업장 구분</th>
                          <th data-options="field:'procStat', width:80, halign:'center', align:'center',
                              formatter:formatS034">실적상태</th>
                          <th data-options="field:'key', width:120, halign:'center', align:'left'">KEY</th>
                        </tr>
                      </thead>
                    </table>
                </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

</div>

<!-- ============================================================ -->
<!-- 기준설정 팝업 (localStorage) -->
<!-- ============================================================ -->
<%@ include file="/WEB-INF/views/imes/pop/pop33a_d0a.jsp" %>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
