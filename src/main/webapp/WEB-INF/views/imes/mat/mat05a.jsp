<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)mat05a.jsp 1.0 2026/03/04                                         --%>
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
<%-- 자재불출현황 (MAT05A)                                                   --%>
<%-- 원본: ProActive MAT05A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/03/04                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/mat/mat05a.js"/>?v=260313B"></script>

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
<div data-options="region:'north', border:false" style="height:125px;">
    <div id="search-toolbar" class="wui-toolbar">
        <form id="search-form">
            <!-- 1단: 조회조건 + 조회 버튼 -->
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="180px">  <!-- 일자구분 멀티콤보 -->
                        <col width="250px">  <!-- 날짜범위 -->
                        <col width="65px">   <!-- 오더번호 -->
                        <col width="110px">  <!-- 입력 -->
                        <col width="43px">   <!-- 호기 -->
                        <col width="90px">   <!-- 입력 -->
                        <col width="53px">   <!-- 수주처 -->
                        <col width="90px">   <!-- 입력 -->
                        <col width="43px">   <!-- 공장 -->
                        <col width="100px">  <!-- 콤보 -->
                        <col width="*">      <!-- 남은 공간 -->
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
                        <th class="h table-Search-h search-label-h">
                            <select id="s_dateType" class="easyui-combobox" data-options="width:120, editable:false, panelHeight:'auto', multiple:true, value:'PLN_DATE'">
                                <option value="PLN_DATE">계획시작일</option>
                                <option value="INDUE_DATE">생산완료일</option>
                                <option value="SAP_DUE_DATE">납기일</option>
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
                        <th class="h table-Search-h search-label-h"><span>호기</span></th>
                        <td class="d">
                            <input id="s_hogiLike" class="easyui-textbox" data-options="width:80"/>
                        </td>
                        <th class="h table-Search-h search-label-h"><span>수주처</span></th>
                        <td class="d">
                            <input id="s_customerLike" class="easyui-textbox" data-options="width:80"/>
                        </td>
                        <th class="h table-Search-h search-label-h"><span>공장</span></th>
                        <td class="d">
                            <input id="s_plants" style="display:inline-block; vertical-align:middle;"/>
                        </td>
                        <td></td>
                    </tr>
                    
                    <tr>
                        <td class="h" colspan="10">
                            <div class="grd-div-btn dis_flex_gap4">
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="issue-button" data-options="disabled:${UPD}">현장불출</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="cancel-button" data-options="disabled:${DEL}">불출취소</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="print-button" data-options="disabled:${RET}">자재확인표출력</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="matquery-button" data-options="disabled:${RET}">선택공정 자재조회</a>
                            </div>
                        </td>
                    </tr>
                    
                </table>
            </fieldset>
            
        </form>
    </div>
</div>

<!-- 탭 + 그리드 영역 (Center) -->
<div data-options="region:'center', border:false">
    <div id="tab-panel" class="easyui-tabs" data-options="fit:true, border:false, onSelect:onTabSelect">

        <!-- Tab1: 공정별 (좌: 생산지시, 우: 소요자재) -->
        <div title="공정별" style="padding:0px;">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'west', border:false, split:true" style="width:50%;">
                    <table id="grid1"></table>
                </div>
                <div data-options="region:'center', border:false">
                    <table id="grid2"></table>
                </div>
            </div>
        </div>

        <!-- Tab2: 전체 -->
        <div title="전체" style="padding:0px;">
            <table id="grid3"></table>
        </div>

        <!-- Tab3: 불출현황 -->
        <div title="불출현황" style="padding:0px;">
            <table id="grid4"></table>
        </div>

    </div>
</div>

</div>

<!-- D0A 다이얼로그 (현장불출) -->
<%@ include file="/WEB-INF/views/imes/mat/mat05a_d0a.jsp" %>
<!-- D1A 다이얼로그 (불출취소) -->
<%@ include file="/WEB-INF/views/imes/mat/mat05a_d1a.jsp" %>

<!-- 파일 목록 공통 팝업 -->
<%@ include file="/WEB-INF/views/imes/com/acFileForm.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
