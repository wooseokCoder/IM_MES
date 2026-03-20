<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)pop30b.jsp 1.0 2026/03/18                                         --%>
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
<%-- 단말기 - 가공 (POP30B)                                                 --%>
<%-- 원본: ProActive Pop30B_M0A.cs                                          --%>
<%--                                                                        --%>
<%-- @author AI Assistant                                                   --%>
<%-- @version 1.0 2026/03/18                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop30b.js"/>?v=260319E"></script>

<style>
/* ================================================ */
/* 단말기(POP) 정보 패널 전용 스타일                   */
/* ================================================ */

/* 테이블 기본 */
table.pop-terminal-table {
    border-collapse: collapse;
    border: 1px solid #bbb;
    table-layout: fixed;
}

/* 모든 셀 공통 */
table.pop-terminal-table td {
    border: 1px solid #bbb;
    padding: 0 !important;
    text-align: center;
    vertical-align: middle;
}
/* 행 높이는 tr에서 제어 (td height 지정하면 rowspan 무시됨) */
table.pop-terminal-table tr {
    height: 45px;
}

/* 버튼 셀: 버튼이 셀 영역 꽉 차게 + 라벨 중앙 */
table.pop-terminal-table td.pt-btn .easyui-linkbutton {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* 대형 버튼 (작업장/작업자 선택, row1~3) */
table.pop-terminal-table td.pt-btn-lg .easyui-linkbutton {
    min-height: 130px;
    font-size: 15px;
    font-weight: bold;
}
table.pop-terminal-table td.pt-btn-lg .l-btn-text {
    line-height: 1.4;
}

/* 대형 버튼2 (비계획 입력, row1~4) */
table.pop-terminal-table td.pt-btn-lg2 .easyui-linkbutton {
    min-height: 177px;
    font-size: 15px;
    font-weight: bold;
}
table.pop-terminal-table td.pt-btn-lg2 .l-btn-text {
    line-height: 1.4;
}


/* 화살표 버튼 (row1~4) */
table.pop-terminal-table td.pt-btn-arrow .easyui-linkbutton {
    min-height: 170px;
    font-size: 26px;
    font-weight: bold;
    min-width: 30px;
}

/* 기능 버튼 (부적합등록 등, row1~2 / row3~4) */
table.pop-terminal-table td.pt-btn-func .easyui-linkbutton {
    min-height: 87px;
    font-size: 14px;
    font-weight: bold;
}

/* 정보 텍스트 셀 (날짜범위, 금일, 작업자명) */
table.pop-terminal-table td.pt-info {
    font-size: 21px;
    font-weight: bold;
    padding: 0 10px !important;
}

/* 상태 메시지 셀 (기본: 확정색 배경, JS에서 동적 변경) */
table.pop-terminal-table td.pt-status {
    font-size: 21px;
    font-weight: bold;
    color: #000;
    padding: 0 10px !important;
    background-color: #D4EDF7;
}

/* 체크박스 셀 */
table.pop-terminal-table td.pt-chk {
    padding: 0 8px !important;
}
table.pop-terminal-table td.pt-chk label {
    font-size: 13px;
    font-weight: bold;
    cursor: pointer;
    white-space: nowrap;
}
table.pop-terminal-table td.pt-chk input[type="checkbox"] {
    transform: scale(1.3);
    margin-right: 5px;
    vertical-align: middle;
}

/* 하단 버튼 영역 - 화면 하단 고정 */
/* 하단 버튼 영역 - 화면 하단 고정 */
#grid-bottom-toolbar {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 10;
    background: #f5f5f5;
    border-top: 1px solid #ccc;
}
.pop-bottom-btn .easyui-linkbutton {
    min-height: 55px;
    min-width: 130px;
    font-size: 14px;
    font-weight: bold;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}
/* 그리드 영역에 하단 버튼 높이만큼 여백 확보 */
#account-layout {
    padding-bottom: 65px !important;
}

/* ================================================ */
/* 단말기 그리드 스타일                                */
/* ================================================ */

/* 그리드 헤더 높이 */
#account-layout .datagrid-header,
#account-layout .datagrid-htable,
#account-layout .datagrid-btable,
#account-layout .datagrid-ftable {
    height: auto !important;
}
#account-layout .datagrid-header td .datagrid-cell,
#account-layout .datagrid-header td .datagrid-cell-group {
    height: 50px !important;
    line-height: 50px !important;
    font-size: 14px;
}
#account-layout .datagrid-header-row {
    height: 40px !important;
}

/* 그리드 로우 높이 */
#account-layout .datagrid-body td .datagrid-cell {
    height: 45px !important;
    line-height: 45px !important;
    font-size: 14px;
}

/* 그리드 내 액션 버튼 (작업준비/시작/중지/완료) */
.pop-grid-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 100%;
    min-height: 43px;
    border: 1px solid #aaa;
    font-size: 20px;
    text-decoration: none !important;
    cursor: default;
    box-sizing: border-box;
    margin: 0;
}
.pop-grid-btn-active {
    background: #f0f0f0;
    border-color: #888;
    cursor: pointer;
}
.pop-grid-btn-active:hover {
    background: #e0e0e0;
    border-color: #555;
}
.pop-grid-btn-disabled {
    background: #fafafa;
    border-color: #ddd;
}

/* 선택 행: 빨간 굵은 테두리 + 볼드 (over 시에도 유지) */
#account-layout .datagrid-row-selected,
#account-layout .datagrid-row-checked {
    outline: 5px solid #ff0000 !important;
    outline-offset: -3px;
}
#account-layout .datagrid-row-selected td .datagrid-cell,
#account-layout .datagrid-row-checked td .datagrid-cell {
    font-weight: bold !important;
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

<!-- 그리드 영역 -->
<table id="search-grid"></table>

<!-- 비가동 오버레이 (그리드 위에 표시) -->
<div id="idle-overlay" style="display:none;position:fixed;z-index:100;
    left:50%;top:50%;transform:translate(-50%,-50%);
    background:rgba(255,0,0,0.85);color:#fff;font-size:20px;font-weight:bold;
    text-align:center;padding:20px 40px;border-radius:5px;
    pointer-events:none;">
    <div id="idle-overlay-text"></div>
</div>

<!-- 조회 영역 (Toolbar) -->
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup><col width="*"></colgroup>
                <tr class="topnav_sty">
                    <td>
                        <div>
                            <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                        </div>
                    </td>
                </tr>
            </table>
        </fieldset>
        <fieldset class="div-line-new-sub" style="padding:0;margin:0;">
            <!-- ============================================ -->
            <!-- 단말기 정보 패널: 4 Row × 8 Col               -->
            <!-- ============================================ -->
            <table cellpadding="0" class="pop-terminal-table wd-100">
                <colgroup>
                    <col width="120px">  <!-- col1: 작업장선택 -->
                    <col width="120px">  <!-- col2: 작업자선택 -->
                    <col width="60px">  <!-- col3: ◄ 화살표 -->
                    <col width="*">     <!-- col4: 주차/진행상태 -->
                    <col width="250px"> <!-- col5: 금일/작업자명 -->
                    <col width="60px">  <!-- col6: ► 화살표 -->
                    <!--<col width="0px">  col7: 부적합등록/현황 130px-->
                    <!--<col width="0px">  col8: 자주검사/실적현황 130px-->
                    <col width="200px"> <!-- col9: new 비계획 입력  -->
                </colgroup>
                <!-- Row 1 -->
                <tr>
                    <td rowspan="3" class="pt-btn pt-btn-lg"><a href="javascript:void(0)" id="btn-select-mc" class="easyui-linkbutton c6">작업장<br/>선택</a></td>
                    <td rowspan="3" class="pt-btn pt-btn-lg"><a href="javascript:void(0)" id="btn-select-emp" class="easyui-linkbutton c6">작업자<br/>선택</a></td>
                    <td rowspan="4" class="pt-btn pt-btn-arrow"><a href="javascript:void(0)" id="btn-prev-week" class="easyui-linkbutton" data-options="plain:true">◀</a></td>
                    <td rowspan="2" class="pt-info"><span id="lbl-date-range"></span></td>
                    <td rowspan="2" class="pt-info"><span id="lbl-today"></span></td>
                    <td rowspan="4" class="pt-btn pt-btn-arrow"><a href="javascript:void(0)" id="btn-next-week" class="easyui-linkbutton" data-options="plain:true">▶</a></td>
                    
                    <!-- tobe오면서 삭제 버튼 영역 
                    <td rowspan="2" class="pt-btn pt-btn-func" style="display:none;">
                    	<a href="javascript:void(0)" id="btn-ng-reg" class="easyui-linkbutton c6">부적합 등록</a>
                    </td>
                    <td rowspan="2" class="pt-btn pt-btn-func" style="display:none;"
                    	<a href="javascript:void(0)" id="btn-inspection" class="easyui-linkbutton c6" data-options="disabled:true">자주검사</a>
                    </td>-->
                    
                    <!-- 신규 버튼 영역 -->
                    <td rowspan="4" class="pt-btn pt-btn-lg2">
                    	<a href="javascript:void(0)" id="btn-none-plan" class="easyui-linkbutton c6">비계획<br/>입력</a>
                    </td>
                    
                </tr>
                <!-- Row 2 (rowspan 계속) -->
                <tr></tr>
                <!-- Row 3 -->
                <tr>
                    <td rowspan="2" class="pt-status"><span id="lbl-status">진행중인 작업이 없습니다.</span></td>
                    <td rowspan="2" class="pt-info"><span id="lbl-current-worker"></span></td>
                    
                    <!-- tobe오면서 삭제 버튼 영역 
                    <td rowspan="2" class="pt-btn pt-btn-func" style="display:none;"><a href="javascript:void(0)" id="btn-ng-list" class="easyui-linkbutton c6">부적합 현황</a></td>
                    <td rowspan="2" class="pt-btn pt-btn-func" style="display:none;"><a href="javascript:void(0)" id="btn-act-list" class="easyui-linkbutton c6">실적현황</a></td>
                    -->
                </tr>
                <!-- Row 4 -->
                <tr>
                    <td class="pt-chk"><label><input type="checkbox" id="chk-include-done"/> 완료작업 포함</label></td>
                    <td class="pt-chk"><label><input type="checkbox" id="chk-all-order"/> 전체오더</label></td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 하단 버튼 영역 (그리드 아래 고정) -->
<div id="grid-bottom-toolbar" style="border-top:1px solid #ddd;">
    <div class="pop-bottom-btn dis_flex_gap4" style="justify-content:center;padding:5px 0;">
        <a href="javascript:void(0)" id="btn-mat-ready" class="easyui-linkbutton c6" data-options="disabled:true" style="display:none;">-</a>
        <a href="javascript:void(0)" id="btn-equip-spec" class="easyui-linkbutton c6">설비제원</a>
        <a href="javascript:void(0)" id="btn-daily-check" class="easyui-linkbutton c6">일일점검</a>
        <a href="javascript:void(0)" id="btn-idle-input" class="easyui-linkbutton c6">비가동 입력</a>
        <a href="javascript:void(0)" id="btn-2d-drawing" class="easyui-linkbutton c6">2D 도면</a>
        <a href="javascript:void(0)" id="btn-work-std" class="easyui-linkbutton c6">작업표준</a>
        <a href="javascript:void(0)" id="btn-leave" class="easyui-linkbutton c6">퇴근</a>
        <a href="javascript:void(0)" id="btn-inspection" class="easyui-linkbutton c6" data-options="disabled:true">자주검사</a>
        <a href="javascript:void(0)" id="btn-work-std-req" class="easyui-linkbutton c6" style="min-width: 175px; display:none;">작업표준 수정 요청 메일 발송</a>
    </div>
</div>

<!-- 조회영역을 붙일 패널 -->
<div data-options="region:'north', border:true" id="search-grid-panel"></div>

</div>

<!-- ============================================================ -->
<!-- hidden fields (작업장/작업자 코드 저장) -->
<!-- ============================================================ -->
<input type="hidden" id="hid-mc-code" value=""/>
<input type="hidden" id="hid-mc-name" value=""/>
<input type="hidden" id="hid-emp-code" value=""/>

<!-- ============================================================ -->
<!-- 공통 팝업 INCLUDE                                              -->
<!-- ============================================================ -->
<!-- 작업장(CELL) 선택 팝업 (공통) AS-IS: ChangeCellMc -->
<%@ include file="/WEB-INF/views/imes/com/acCellForm.jsp" %>
<!-- 작업자 선택 팝업 (공통) AS-IS: ChangeEmp -->
<%@ include file="/WEB-INF/views/imes/com/acWorkerForm.jsp" %>
<!-- 비가동 사유 선택 팝업 (공통) AS-IS: WorkIdle -->
<%@ include file="/WEB-INF/views/imes/com/workIdle.jsp" %>
<!-- 설비점검 의견 팝업 (공통) AS-IS: McScomment (WorkIdle 하위) -->
<%@ include file="/WEB-INF/views/imes/com/mcScomment.jsp" %>
<!-- NG 등록 팝업 (공통) AS-IS: McRegNg -->
<%@ include file="/WEB-INF/views/imes/com/mcRegNg.jsp" %>
<!-- NG 이력 팝업 (공통) AS-IS: McNgLog -->
<%@ include file="/WEB-INF/views/imes/com/mcNgLog.jsp" %>
<!-- 일일점검 팝업 (공통) AS-IS: McDailyCheck -->
<%@ include file="/WEB-INF/views/imes/com/mcDailyCheck.jsp" %>

<!-- ============================================================ -->
<!-- POP30B 다이얼로그 INCLUDE                                      -->
<!-- ============================================================ -->
<!-- 자주검사 다이얼로그 (D4A) -->
<%@ include file="/WEB-INF/views/imes/pop/pop30b_d4a.jsp" %>
<!-- 설비제원 다이얼로그 (D9A) -->
<%@ include file="/WEB-INF/views/imes/pop/pop30b_d9a.jsp" %>
<!-- 실적현황 다이얼로그 (D11A) -->
<%@ include file="/WEB-INF/views/imes/pop/pop30b_d11a.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
