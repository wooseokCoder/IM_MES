<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord15a.jsp 1.0 2026/03/16                                         --%>
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
<%-- 실적/비가동 현황                                                       --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/03/16                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<style>
/* 무작업 행 배경색 (AliceBlue) */
.row-nonwork { background-color: #F0F8FF !important; }
/* 퇴근 행 배경색 (WhiteSmoke) */
.row-offwork { background-color: #F5F5F5 !important; }

/* datagrid label bold 방지 */
.datagrid-cell label { font-weight: normal; }

/* 검색 영역: datebox width 고정 */
#search-toolbar .search-table .datebox {
    width: 140px !important;
}
/* 검색 영역: combobox 높이 보정 */
#search-toolbar .search-table .combo {
    height: 26px !important;
    line-height: 22px;
    box-sizing: border-box;
}
#search-toolbar .search-table .combo .combo-arrow {
    height: 26px !important;
}
/* editable:false 시 readonly 배경색 흰색 유지 */
#search-toolbar .search-table .textbox-text[readonly],
#search-toolbar .search-table .combo-text[readonly] {
    background-color: #fff !important;
}

/* common.css '.datagrid-body table { width:100% }' 오버라이드 — 가로 스크롤 허용 */
.datagrid-view.noStyle .datagrid-body table {
    width: auto !important;
}
</style>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord15a.js?v=260316D" />"></script>

</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 화면 첫 로딩시 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- ================================================================== -->
<!-- 메인 레이아웃                                                      -->
<!-- ================================================================== -->
<div class="easyui-layout" data-options="fit:true" style="display:none" id="main-layout">

    <!-- 상단: 검색 영역 -->
    <div data-options="region:'north', border:false" style="height:auto;">
        <div id="search-toolbar" class="wui-toolbar">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup><col width="*"></colgroup>
                    <tr class="topnav_sty">
                        <td>
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button"
                                       class="easyui-linkbutton cgray" data-item="BTN_000"
                                       data-options="disabled:${RET}">조회</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100" style="table-layout:auto;">
                    <tr>
                        <td class="d" style="width:auto; min-width:0px;">
                            <input id="s_dateTypes" />
                        </td>
                        <td class="d" style="width:auto; min-width:0px; white-space:nowrap;">
                            <div style="display:flex; align-items:center; flex-wrap:nowrap;">
                                <input class="easyui-datebox" id="s_sDate" data-options="width:140, editable:false" />
                                <span style="margin:0 2px;">~</span>
                                <input class="easyui-datebox" id="s_eDate" data-options="width:140, editable:false" />
                            </div>
                        </td>
                        <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>판매오더</span></th>
                        <td class="d" style="width:auto; min-width:0px;">
                            <input class="easyui-textbox" id="s_orderLike" data-options="width:100" />
                        </td>
                        <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>호기</span></th>
                        <td class="d" style="width:auto; min-width:0px;">
                            <input class="easyui-textbox" id="s_hogiLike" data-options="width:100" />
                        </td>
                        <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>거래처</span></th>
                        <td class="d" style="width:auto; min-width:0px;">
                            <input class="easyui-textbox" id="s_cvndLike" data-options="width:100" />
                        </td>
                        <th class="h table-Search-h search-label-h" style="width:auto; min-width:0px;"><span>기계번호</span></th>
                        <td class="d" style="width:auto; min-width:0px;">
                            <input class="easyui-textbox" id="s_mcNoLike" data-options="width:100" />
                        </td>
                        <td class="d" style="width:auto; min-width:0px; white-space:nowrap;">
                            <input type="checkbox" id="s_isNonwork" />
                            <label for="s_isNonwork">무작업/퇴근 포함</label>
                        </td>
                        <td class="d" style="width:99%"></td>
                    </tr>
                </table>
            </fieldset>
        </div>
    </div>

    <!-- 메인: 그리드 영역 -->
    <div data-options="region:'center', border:false">
        <table id="search-grid"></table>
    </div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
