<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)rep09a.jsp 1.0 2026/03/16                                         --%>
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
<%-- 가공 진행현황 (REP09A)                                                --%>
<%-- 원본: ProActive REP09A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- @author AI Assistant                                                   --%>
<%-- @version 2.0 2026/03/17                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/rep/rep09a.js"/>?v=260318B"></script>

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

<!-- 그리드 영역 (동적 컬럼 — JS에서 columns 옵션으로 생성) -->
<div data-options="region:'center', border:false">
    <table id="search-grid"></table>
</div>

<!-- 조회 영역 (Toolbar) -->
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <!-- 1단: topnav + 조회 버튼 + 검색 조건 -->
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup>
                    <col width="65px">
                    <col width="140px">
                    <col width="20px">
                    <col width="140px">
                    <col width="65px">
                    <col width="120px">
                    <col width="43px">
                    <col width="120px">
                    <col width="80px">
                    <col width="120px">
                    <col width="*">
                </colgroup>
                <tr class="topnav_sty">
                    <td colspan="11">
                        <div>
                            <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                            <div>
                                <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray"
                                   data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th class="h table-Search-h search-label-h"><span>계획일자</span></th>
                    <td class="d">
                        <input id="s_planDate" class="easyui-datebox" data-options="width:140, editable:true"/>
                    </td>
                    <td class="d" style="text-align:center;">~</td>
                    <td class="d">
                        <input id="e_planDate" class="easyui-datebox" data-options="width:140, editable:true"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>생산오더</span></th>
                    <td class="d">
                        <input id="s_sapWoLike" class="easyui-textbox" data-options="width:120"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>모델</span></th>
                    <td class="d">
                        <input id="s_modelLike" class="easyui-textbox" data-options="width:120"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>부품코드/명</span></th>
                    <td class="d">
                        <input id="s_partLike" class="easyui-textbox" data-options="width:120"/>
                    </td>
                    <td class="d"></td>
                </tr>
            </table>
        </fieldset>
        <!-- 2단: 버튼 + 범례 -->
        <fieldset class="div-line-new-sub grd-div-btn">
            <table cellpadding="7" class="search-table tableEtc-c wd-100">
                <tr>
                    <td class="h">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <div class="dis_flex_gap4">
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d1a-button"
                                   data-item="BTN_002" data-options="disabled:${RET}">완료공정 상세보기</a>
                            </div>
                            <div id="legend-bar" style="display:flex; align-items:center; gap:2px;">
                                <span style="font-weight:bold; margin-right:4px; font-size:12px;">범례</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#D3D3D3; border:1px solid #ccc; font-size:11px;">미확정</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#F0F8FF; border:1px solid #ccc; font-size:11px;">확정</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#FF8C00; border:1px solid #ccc; font-size:11px; color:#fff;">진행</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#FFFF00; border:1px solid #ccc; font-size:11px;">중지</span>
                                <span style="display:inline-block; width:60px; height:18px; line-height:18px; text-align:center; background:#90EE90; border:1px solid #ccc; font-size:11px; color:#fff;">완료</span>
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

<!-- 우클릭 컨텍스트 메뉴 -->
<div id="grid-context-menu" class="easyui-menu" style="width:140px;">
    <div id="ctx-detail" data-options="iconCls:'icon-search'">상세보기</div>
</div>

<!-- D0A 공정 상세 다이얼로그 INCLUDE -->
<%@ include file="/WEB-INF/views/imes/rep/rep09a_d0a.jsp" %>

<!-- D1A 완료공정 조회 다이얼로그 INCLUDE -->
<%@ include file="/WEB-INF/views/imes/rep/rep09a_d1a.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
