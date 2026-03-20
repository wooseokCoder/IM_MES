<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)mat01a.jsp 1.0 2026/03/03                                         --%>
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
<%-- 과부족정보 조회 (MAT01A)                                               --%>
<%-- 원본: ProActive MAT01A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/03/03                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/mat/mat01a.js"/>?v=260313B"></script>

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
                        <col width="110px">  <!-- 생산완료일(계획) -->
                        <col width="550px">  <!-- 주차 combobox + datebox + 주차info + < > -->
                        <col width="65px">   <!-- 판매오더 -->
                        <col width="120px">  <!-- 입력 -->
                        <col width="65px">   <!-- 구성부품 -->
                        <col width="120px">  <!-- 입력 -->
                        <col width="40px">   <!-- 공장 -->
                        <col width="120px">  <!-- 콤보 -->
                        <col width="*">      <!-- 남은 공간 -->
                    </colgroup>
                    <tr class="topnav_sty">
                        <td colspan="9">
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th class="h table-Search-h search-label-h"><span>생산완료일(계획)</span></th>
                        <td class="d">
                            <c:set var="wdPrefix" value="wd1"/>
                            <%@ include file="/WEB-INF/views/imes/com/acWeekDate.jsp" %>
                        </td>
                        <th class="h table-Search-h search-label-h"><span>판매오더</span></th>
                        <td class="d">
                            <input id="s_orderLike" class="easyui-textbox" data-options="width:110"/>
                        </td>
                        <th class="h table-Search-h search-label-h"><span>구성부품</span></th>
                        <td class="d">
                            <input id="s_partLike" class="easyui-textbox" data-options="width:110"/>
                        </td>
                        <th class="h table-Search-h search-label-h"><span>공장</span></th>
                        <td class="d">
                            <input id="s_plants" class="easyui-combobox" data-options="width:110, editable:false, panelHeight:'auto'"/>
                        </td>
                        <td></td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- 탭 + 그리드 영역 (Center) -->
<div data-options="region:'center', border:false">
    <div id="tab-panel" class="easyui-tabs" data-options="fit:true, border:false, onSelect:onTabSelect">
        <!-- 탭1: 리스트 -->
        <div title="리스트" style="padding:0px;">
            <table id="search-grid"></table>
        </div>
        <!-- 탭2: 피벗 (공급처별 부족 요약) -->
        <div title="피벗" style="padding:0px;">
            <table id="pivot-grid"></table>
        </div>
    </div>
</div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
