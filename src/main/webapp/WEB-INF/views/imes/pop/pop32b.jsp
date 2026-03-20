<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)pop32b.jsp 1.0 2026/03/03                                         --%>
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
<%-- 비가동현황 (가공) (POP32B)                                                  --%>
<%-- 원본: ProActive Pop32B_M0A.cs                                           --%>
<%--                                                                        --%>
<%-- @author AI Assistant                                                   --%>
<%-- @version 1.0 2026/03/03                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop32b.js"/>?v=260319A"></script>
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop32a_dialog.js"/>?v=260303A"></script>
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop32a_d2a.js"/>?v=260306A"></script>

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

<!-- 조회 영역 (Toolbar) -->
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup>
                    <col width="550px">
                    <col width="*">
                </colgroup>
                <tr class="topnav_sty">
                    <td colspan="2">
                        <div>
                            <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                            <div>
                                <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="d">
                        <c:set var="wdPrefix" value="wd1"/>
                        <%@ include file="/WEB-INF/views/imes/com/acWeekDate.jsp" %>
                    </td>
                </tr>
            </table>
        </fieldset>
        <fieldset class="div-line-new-sub grd-div-btn">
            <table cellpadding="7" class="search-table tableEtc-c wd-100">
                <tr>
                    <td class="h">
                        <div class="dis_flex_gap4">
                            <a href="javascript:void(0)" id="add-button" class="easyui-linkbutton c6" data-item="BTN_001" data-options="disabled:${INS}">신규등록</a>
                            <a href="javascript:void(0)" id="delete-button" class="easyui-linkbutton c6" data-item="BTN_002" data-options="disabled:${DEL}">삭제</a>
                            <a href="javascript:void(0)" id="detail-button" class="easyui-linkbutton c6" data-item="BTN_003" data-options="disabled:${UPD}">가공 상세원인 수정 및 확인</a>
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
<!-- AS-IS: popupMenu1 (ShowGridMenuEx 이벤트) -->
<div id="grid-context-menu" class="easyui-menu" style="width:180px;">
    <div id="ctx-append" data-options="iconCls:'icon-add'">신규등록</div>
    <div id="ctx-open" data-options="iconCls:'icon-edit'">열기</div>
    <div id="ctx-delete" data-options="iconCls:'icon-remove'">삭제</div>
</div>

<!-- 신규등록 다이얼로그 (32AD0A) INCLUDE -->
<%@ include file="/WEB-INF/views/imes/pop/pop32a_d0a.jsp" %>

<!-- 작업자 선택 다이얼로그 (32AD1A) INCLUDE -->
<%@ include file="/WEB-INF/views/imes/pop/pop32a_d1a.jsp" %>

<!-- 비가동시간 수정 다이얼로그 (32AD2A) INCLUDE -->
<%@ include file="/WEB-INF/views/imes/pop/pop32a_d2a.jsp" %>

<!-- 신규등록 다이얼로그 (32BD0A) INCLUDE -->
<%@ include file="/WEB-INF/views/imes/pop/pop32b_d0a.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
