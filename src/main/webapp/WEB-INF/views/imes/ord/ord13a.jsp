<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord13a.jsp 1.0 2026/02/23                                         --%>
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
<%-- 생산오더 일정 관리 (ORD13A)                                            --%>
<%-- 원본: ProActive ORD13A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/02/23                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord13a.js?v=260313B"/>" ></script>

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

<!-- 그리드 영역 (동적 컬럼이므로 thead 없음 - JS에서 columns 옵션으로 생성) -->
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
                    <col width="55px">   <!-- Model (라벨) -->
                    <col width="120px">  <!-- 입력필드 -->
                    <col width="43px">   <!-- 공정 (라벨) -->
                    <col width="120px">  <!-- 입력필드 -->
                    <col width="43px">   <!-- 부품 (라벨) -->
                    <col width="120px">  <!-- 입력필드 -->
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
                <!-- 검색 조건: Model + 공정 + 부품 -->
                <tr>
                    <th class="h table-Search-h search-label-h"><span>Model</span></th>
                    <td class="d">
                        <input id="s_modelLike" class="easyui-textbox" data-options="width:120"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>공정</span></th>
                    <td class="d">
                        <input id="s_procLike" class="easyui-textbox" data-options="width:120"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>부품</span></th>
                    <td class="d">
                        <input id="s_partLike" class="easyui-textbox" data-options="width:120"/>
                    </td>
                    <td class="d"></td>
                </tr>
            </table>
        </fieldset>
        <!-- 2단: 액션 버튼 (비고 저장, 공정명 저장) + 범례 -->
        <fieldset class="div-line-new-sub grd-div-btn">
            <table cellpadding="7" class="search-table tableEtc-c wd-100">
                <tr>
                    <td class="h">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <div class="dis_flex_gap4">
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-remark-button" data-options="disabled:${UPD}">비고 저장</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-proc-button" data-options="disabled:${UPD}">공정명 저장</a>
                            </div>
                            <div id="legend-bar" style="display:flex; align-items:center; gap:2px;">
                                <span style="font-weight:bold; margin-right:4px; font-size:12px;">범례</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#D3D3D3; border:1px solid #ccc; font-size:11px;">미확정</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#D4EDF7; border:1px solid #ccc; font-size:11px;">확정</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#FF6347; color:#fff; border:1px solid #ccc; font-size:11px;">진행</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#FFFF00; border:1px solid #ccc; font-size:11px;">중지</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#00FF00; border:1px solid #ccc; font-size:11px;">완료</span>
                            </div>
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
