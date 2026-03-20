<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord14a.jsp 1.0 2026/03/06                                         --%>
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
<%-- 실적관리 가공 (ORD14A)                                                --%>
<%-- 원본: ProActive ORD14A_M0A.cs                                         --%>
<%-- 구조: 상단 작업지시 그리드 + 하단 실적 상세 그리드 (Master-Detail)     --%>
<%-- 그리드 배치: MAT05A Tab1 좌우분할 → 상하분할 변형                     --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/03/06                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord14a.js"/>?v=260313B"></script>

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

<!-- 조회 영역 (North) -->
<div data-options="region:'north', border:false" style="height:78px;">
    <div id="search-toolbar" class="wui-toolbar">
        <form id="search-form">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="130px">  <!-- 일자구분 멀티콤보 -->
                        <col width="260px">  <!-- 날짜범위 -->
                        <col width="65px">   <!-- 오더번호 (라벨) -->
                        <col width="110px">  <!-- 입력필드 -->
                        <col width="43px">   <!-- 공정 (라벨) -->
                        <col width="110px">  <!-- 입력필드 -->
                        <col width="*">      <!-- 남은 공간 -->
                    </colgroup>
                    <tr class="topnav_sty">
                        <td colspan="7">
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th class="h table-Search-h search-label-h">
                            <%-- AS-IS: acCheckedComboBoxEdit1 (생산계획일 체크콤보) --%>
                            <select id="s_dateType" class="easyui-combobox"
                                data-options="width:120, editable:false, panelHeight:'auto', multiple:true">
                                <option value="PLN_DATE">생산계획일</option>
                            </select>
                        </th>
                        <td class="d">
                            <div style="display:flex; align-items:center; flex-wrap:nowrap;">
                                <input id="s_startDate" class="easyui-datebox" data-options="width:120, editable:true" style="margin-left:4px;"/>
                                <span style="margin:0 2px;">~</span>
                                <input id="s_endDate" class="easyui-datebox" data-options="width:120, editable:true"/>
                            </div>
                        </td>
                        <th class="h table-Search-h search-label-h"><span>오더번호</span></th>
                        <td class="d">
                            <input id="s_orderLike" class="easyui-textbox" data-options="width:100"/>
                        </td>
                        <th class="h table-Search-h search-label-h"><span>공정</span></th>
                        <td class="d">
                            <input id="s_procLike" class="easyui-textbox" data-options="width:100"/>
                        </td>
                        <td></td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- 상단: 작업지시 그리드 (Center) -->
<div data-options="region:'center', border:false">
    <table id="grid1"></table>
</div>

<!-- 하단: 실적 상세 그리드 (South) (AS-IS: acGroupControl2.Text="실적 정보") -->
<div data-options="region:'south', border:true, split:true, collapsible:false, title:'실적 정보'" style="height:40%">
    <table id="grid2"></table>
</div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
