<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std13a.jsp 1.0 2026/02/11                                         --%>
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
<%-- 부서/사원 관리 (STD13A)                                               --%>
<%-- 원본: ProActive STD13A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- 좌: 부서 treegrid, 우: 사원 datagrid (읽기전용)                        --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/02/11                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/std/std13a.js?v=260313B" />"></script>

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

<!-- ====================================================================== -->
<!-- NORTH: 검색 영역 (전체 너비)                                           -->
<!-- ====================================================================== -->
<div data-options="region:'north', border:false">
    <div id="search-toolbar" class="wui-toolbar datagrid-toolbar">
        <form id="search-form">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="80px">
                        <col width="180px">
                        <col width="*">
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
                    <tr>
                        <th class="h table-Search-h search-label-h" data-item="LAB_001"><span>사원코드/명</span></th>
                        <td class="d">
                            <input id="s_empLike" class="easyui-textbox" data-options="width:180"/>
                        </td>
                        <td class="d"></td>
                    </tr>
                </table>
            </fieldset>
            <fieldset class="div-line-new-sub grd-div-btn">
                <table cellpadding="7" class="search-table tableEtc-c wd-100">
                    <tr>
                        <td class="h">
                            <div class="dis_flex_gap4">
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="new-button" data-item="BTN_001" data-options="disabled:${INS}">부서 등록</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="delete-button" data-item="BTN_003" data-options="disabled:${DEL}">부서 삭제</a>
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- ====================================================================== -->
<!-- CENTER: 트리 + 그리드 분할 영역                                        -->
<!-- ====================================================================== -->
<div data-options="region:'center', border:false">
    <div class="easyui-layout" data-options="fit:true">

        <!-- WEST: 부서 트리 -->
        <div data-options="region:'west', border:true, split:true" style="width:35%">
            <table id="org-tree">
              <thead>
                <tr>
                  <th data-options="field:'orgCode', width:120, halign:'center', align:'center', resizable:true, hidden:true, data_item:'GRD_001'">부서코드</th>
                  <th data-options="field:'orgName', width:200, halign:'center', align:'left', resizable:true, data_item:'GRD_002'">부서명</th>
                  <th data-options="field:'costCenter', width:120, halign:'center', align:'center', resizable:true, formatter:codeFormatter('S100'), data_item:'GRD_003'">코스트센터</th>
                </tr>
              </thead>
            </table>
        </div>

        <!-- CENTER: 사원 목록 -->
        <div data-options="region:'center', border:true">
            <table id="emp-grid">
              <thead>
                <tr>
                  <th data-options="field:'orgName', width:120, halign:'center', align:'left', resizable:true, data_item:'GRD_011'">부서명</th>
                  <th data-options="field:'empCode', width:100, halign:'center', align:'center', resizable:true, data_item:'GRD_012'">사원코드</th>
                  <th data-options="field:'empName', width:100, halign:'center', align:'left', resizable:true, data_item:'GRD_013'">사원명</th>
                  <th data-options="field:'empType', width:80, halign:'center', align:'center', resizable:true, formatter:codeFormatter('S021'), data_item:'GRD_014'">사원형태</th>
                  <th data-options="field:'empTitle', width:80, halign:'center', align:'center', resizable:true, formatter:codeFormatter('C040'), data_item:'GRD_015'">직책</th>
                  <th data-options="field:'cprocName', width:100, halign:'center', align:'center', resizable:true, data_item:'GRD_016'">임률명</th>
                  <th data-options="field:'usrgrpCode', width:120, halign:'center', align:'center', resizable:true, data_item:'GRD_017'">사용자 그룹코드</th>
                  <th data-options="field:'usrgrpName', width:120, halign:'center', align:'left', resizable:true, data_item:'GRD_018'">사용자 그룹명</th>
                  <th data-options="field:'mobilePhone', width:120, halign:'center', align:'center', resizable:true, data_item:'GRD_019'">휴대폰</th>
                  <th data-options="field:'email', width:160, halign:'center', align:'left', resizable:true, data_item:'GRD_020'">E-Mail</th>
                  <th data-options="field:'empGubun', width:80, halign:'center', align:'center', resizable:true, formatter:codeFormatter('S028'), data_item:'GRD_021'">사원구분</th>
                  <th data-options="field:'ifMcCode', width:120, halign:'center', align:'center', resizable:true, data_item:'GRD_022'">SAP 작업장코드</th>
                  <th data-options="field:'ifMcName', width:120, halign:'center', align:'left', resizable:true, data_item:'GRD_023'">SAP 작업장명</th>
                  <th data-options="field:'empSeq', width:80, halign:'center', align:'right', resizable:true, data_item:'GRD_024'">표시순서</th>
                  <th data-options="field:'rfidNo', width:100, halign:'center', align:'center', resizable:true, data_item:'GRD_025'">RFID</th>
                  <th data-options="field:'fireFlag', width:80, halign:'center', align:'center', resizable:true, data_item:'GRD_026'">퇴사구분</th>
                  <th data-options="field:'fireDate', width:100, halign:'center', align:'center', resizable:true, data_item:'GRD_027'">퇴사일</th>
                </tr>
              </thead>
            </table>
        </div>

    </div>
</div>

</div>

<!-- 부서 편집 다이얼로그 INCLUDE -->
<%@ include file="/WEB-INF/views/imes/std/std13a_dialog.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
