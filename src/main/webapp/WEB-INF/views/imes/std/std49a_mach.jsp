<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std49a_mach.jsp 1.0 2026/02/10                                     --%>
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
<%-- 비가동 관리 - 가공 화면 (PLANTS=3605)                                   --%>
<%-- 원본: ProActive STD49A_M0A.cs                                          --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/02/10                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- 화면별 변수 설정 -->
<script type="text/javascript">
    var PAGE_PLANTS = '${plants}';          // 3605
    var PAGE_PLANTS_NAME = '${plantsName}'; // 가공
</script>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/std/std49a.js?v=260313B" />"></script>

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
<table id="search-grid">
  <thead>
    <tr>
      <th data-options="field:'idleNo', hidden:true">IDLE_NO</th>
      <th data-options="field:'scode', hidden:true">SCODE</th>
      <th data-options="field:'idleName', width:200, halign:'center', align:'center', resizable:true, data_item:'GRD_001'">비가동명</th>
      <th data-options="field:'idleStartTime', width:140, halign:'center', align:'center', resizable:true,
          formatter:formatTime, data_item:'GRD_002'">비가동 시작시간</th>
      <th data-options="field:'idleEndTime', width:140, halign:'center', align:'center', resizable:true,
          formatter:formatTime, data_item:'GRD_003'">비가동 종료시간</th>
      <th data-options="field:'scomment', width:300, halign:'center', align:'left', resizable:true, data_item:'GRD_004'">비고</th>
    </tr>
  </thead>
</table>

<!-- 조회 영역 (Toolbar) -->
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup>
                    <col width="65px">
                    <col width="220px">
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
                    <th class="h table-Search-h search-label-h" data-item="LAB_001"><span>비가동명</span></th>
                    <td class="d">
                        <input id="s_idleLike" class="easyui-textbox" data-options="width:220"/>
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
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="new-button" data-item="BTN_001" data-options="disabled:${INS}">신규</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="delete-button" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
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

<!-- 편집 다이얼로그 (공통) -->
<%@ include file="/WEB-INF/views/imes/std/std49a_dialog.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
