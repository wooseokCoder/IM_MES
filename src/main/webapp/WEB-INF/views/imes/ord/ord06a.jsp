<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord06a.jsp 1.0 2026/02/24                                         --%>
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
<%-- 생산오더 확정 관리 (ORD06A)                                            --%>
<%-- 원본: ProActive ORD06A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/02/24                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord06a.js"/>?v=260313B"></script>

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
                    <col width="120px">   <!-- 일자구분 -->
                    <col width="250px">  <!-- 콤보+날짜범위 -->
                    <col width="55px">   <!-- Model -->
                    <col width="120px">  <!-- 입력 -->
                    <col width="43px">   <!-- 공정 -->
                    <col width="120px">  <!-- 입력 -->
                    <col width="80px">   <!-- 부품코드/명 -->
                    <col width="120px">  <!-- 입력 -->
                    <col width="65px">   <!-- 생산오더 -->
                    <col width="120px">  <!-- 입력 -->
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
                    	<!-- <span>일자구분</span> -->
                    	<select id="s_dateType" class="easyui-combobox" data-options="width:120, editable:false, panelHeight:'auto', multiple:true, value:'REG'">
                            <option value="REG">등록일</option>
                            <option value="PLN">계획일</option>
                        </select>
                    </th>
                    <td class="d">
                        <div style="display:flex; align-items:center; flex-wrap:nowrap;">
                            <input id="s_startDate" class="easyui-datebox" data-options="width:120, editable:true" style="margin-left:4px;"/>
                            <span style="margin:0 2px;">~</span>
                            <input id="s_endDate" class="easyui-datebox" data-options="width:120, editable:true"/>
                        </div>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>Model</span></th>
                    <td class="d">
                        <input id="s_modelLike" class="easyui-textbox" data-options="width:110"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>공정</span></th>
                    <td class="d">
                        <input id="s_procLike" class="easyui-textbox" data-options="width:100"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>부품코드/명</span></th>
                    <td class="d">
                        <input id="s_partLike" class="easyui-textbox" data-options="width:120"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>생산오더</span></th>
                    <td class="d">
                        <input id="s_sapWoLike" class="easyui-textbox" data-options="width:110"/>
                    </td>
                    <td class="d">
                        <input type="checkbox" id="s_isZero" /><label for="s_isZero"> 계획 ST가 '0'인건 제외</label>
                    </td>
                </tr>
            </table>
        </fieldset>
        <!-- 2단: 액션 버튼 -->
        <fieldset class="div-line-new-sub grd-div-btn">
            <table cellpadding="7" class="search-table tableEtc-c wd-100">
                <tr>
                    <td class="h">
                        <div class="dis_flex_gap4">
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="btn-save-plan" data-options="disabled:${UPD}">계획 저장</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="btn-confirm" data-options="disabled:${UPD}">확정</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="btn-unconfirm" data-options="disabled:${UPD}">확정 취소</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="btn-history">확정 이력</a>
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

<!-- 확정이력 다이얼로그 -->
<div id="history-dialog" class="easyui-dialog" style="width:750px; height:400px; padding:10px;visibility:hidden;"
     data-options="closed:true, modal:true, title:'확정이력',
                    onOpen: function(){ $(this).dialog('center'); }">
    <table id="history-grid"></table>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
