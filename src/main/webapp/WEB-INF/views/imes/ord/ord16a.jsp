<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord16a.jsp 1.0 2026/03/04                                         --%>
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
<%-- 생산오더 완료처리 (ORD16A)                                            --%>
<%-- 원본: ProActive ORD16A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/03/04                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord16a.js"/>?v=260304T"></script>

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

<!-- 그리드 영역 (JS에서 columns 옵션으로 생성) -->
<div data-options="region:'center', border:false">
    <table id="search-grid"></table>
</div>

<!-- 조회 영역 (Toolbar) -->
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <!-- 1단: topnav + 조회 버튼 -->
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup>
                    <col width="120px">   <!-- 일자구분 (CheckedComboBox) -->
                    <col width="250px">   <!-- 날짜범위 -->
                    <col width="90px">    <!-- 생산오더번호 -->
                    <col width="100px">   <!-- 입력 -->
                    <col width="45px">    <!-- 호기 -->
                    <col width="90px">    <!-- 입력 -->
                    <col width="55px">    <!-- 수주처 -->
                    <col width="100px">   <!-- 입력 -->
                    <col width="45px">    <!-- 공장 -->
                    <col width="120px">   <!-- 콤보 -->
                    <col width="*">       <!-- 남은 공간 -->
                </colgroup>
                <tr class="topnav_sty">
                    <td colspan="11">
                        <div>
                            <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                            <div>
                                <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <!-- 일자구분 (AS-IS: acCheckedComboBoxEdit1 - 계획시작일/생산완료일/납기일) -->
                    <th class="h table-Search-h search-label-h">
                        <select id="s_dateType" class="easyui-combobox" data-options="width:120, editable:false, panelHeight:'auto', multiple:true, value:'PLN_DATE'">
                            <option value="PLN_DATE">계획시작일</option>
                            <option value="INDUE_DATE">생산완료일</option>
                            <option value="SAP_DUE_DATE">납기일</option>
                        </select>
                    </th>
                    <!-- 날짜 범위 (AS-IS: acDateEdit1 ~ acDateEdit2, 기본 -7일 ~ 오늘) -->
                    <td class="d">
                        <div style="display:flex; align-items:center; flex-wrap:nowrap;">
                            <input id="s_startDate" class="easyui-datebox" data-options="width:120, editable:true" style="margin-left:4px;"/>
                            <span style="margin:0 2px;">~</span>
                            <input id="s_endDate" class="easyui-datebox" data-options="width:120, editable:true"/>
                        </div>
                    </td>
                    <!-- 생산오더번호 (AS-IS: acTextEdit1 / ORDER_LIKE) -->
                    <th class="h table-Search-h search-label-h"><span>생산오더번호</span></th>
                    <td class="d">
                        <input id="s_orderLike" class="easyui-textbox" data-options="width:90"/>
                    </td>
                    <!-- 호기 (AS-IS: acTextEdit2 / HOGI_LIKE) -->
                    <th class="h table-Search-h search-label-h"><span>호기</span></th>
                    <td class="d">
                        <input id="s_hogiLike" class="easyui-textbox" data-options="width:80"/>
                    </td>
                    <!-- 수주처 (AS-IS: acTextEdit3 / CUSTOMER_LIKE) -->
                    <th class="h table-Search-h search-label-h"><span>수주처</span></th>
                    <td class="d">
                        <input id="s_customerLike" class="easyui-textbox" data-options="width:90"/>
                    </td>
                    <!-- 공장 (AS-IS: acLookupEdit1 / PLANTS, P009) -->
                    <th class="h table-Search-h search-label-h"><span>공장</span></th>
                    <td class="d">
                        <input id="s_plants" class="easyui-combobox" data-options="width:110, editable:false, panelHeight:'auto', mode:'remote', loader:jcombo.loader, params:{codeGrup:'P009'}"/>
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
                            <!-- AS-IS: acBarButtonItem5 (완료처리) → acBarButtonItem6_ItemClick 호출 -->
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="btn-complete" data-options="disabled:${UPD}">완료처리</a>
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

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
