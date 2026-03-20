<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std52a.jsp 1.0 2026/02/06                                         --%>
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
<%-- 설비점검항목 관리 (STD52A)                                              --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/02/06                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/std/std52a.js"/>?v=<%= System.currentTimeMillis() %>"></script>

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
  <thead data-options="frozen:true">
    <tr>
      <th data-options="field:'sel', width:40, halign:'center', align:'center', formatter:formatSel">선택</th>
      <th data-options="field:'smdcNo', width:150, halign:'center', align:'center', resizable:true, data_item:'GRD_001'">점검항목ID</th>
      <th data-options="field:'smdcType', width:120, halign:'center', align:'center', resizable:true, data_item:'GRD_002'">구분</th>
    </tr>
  </thead>
  <thead>
    <tr>
      <th data-options="field:'smdcNum', width:100, halign:'center', align:'center', resizable:true, data_item:'GRD_003'">점검번호</th>
      <th data-options="field:'smdcContents', width:250, halign:'center', align:'center', resizable:true, data_item:'GRD_004'">점검항목</th>
      <th data-options="field:'smdcCheck', width:250, halign:'center', align:'center', resizable:true, data_item:'GRD_005'">점검내용</th>
      <th data-options="field:'smdcMeans', width:120, halign:'center', align:'center', resizable:true, data_item:'GRD_006'">점검방법</th>
      <th data-options="field:'smdcSeq', width:60, halign:'center', align:'center', resizable:true, data_item:'GRD_007'">순번</th>
      <th data-options="field:'regDate', width:140, halign:'center', align:'center', hidden:true">최초 등록일</th>
      <th data-options="field:'regEmp', width:100, halign:'center', align:'center', hidden:true">최초 등록자코드</th>
      <th data-options="field:'mdfyDate', width:140, halign:'center', align:'center', hidden:true">최근 수정일</th>
      <th data-options="field:'mdfyEmp', width:100, halign:'center', align:'center', hidden:true">최근 수정자코드</th>
      <th data-options="field:'pltCode', hidden:true">PLT_CODE</th>
      <th data-options="field:'dataFlag', hidden:true">DATA_FLAG</th>
    </tr>
  </thead>
</table>

<!-- 조회 영역 (Toolbar) -->
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup>
                    <col width="43px">
                    <col width="180px">
                    <col width="65px">
                    <col width="220px">
                    <col width="*">
                </colgroup>
                <tr class="topnav_sty">
                    <td colspan="5">
                        <div>
                            <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                            <div>
                                <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th class="h table-Search-h search-label-h" data-item="LAB_001"><span>구분</span></th>
                    <td class="d">
                        <input id="s_typeLike" class="easyui-textbox" data-options="width:180"/>
                    </td>
                    <th class="h table-Search-h search-label-h" data-item="LAB_002"><span>점검항목</span></th>
                    <td class="d">
                        <input id="s_contentsLike" class="easyui-textbox" data-options="width:220"/>
                    </td>
                    <td class="d"></td>
                </tr>
            </table>
        </fieldset>
    </form>
    <fieldset class="div-line-new-sub grd-div-btn">
        <table cellpadding="5" class="search-table tableEtc-c wd-100">
            <tr><td class="h">
                <div class="dis_flex_gap4">
                    <a href="javascript:void(0)" id="btn-add" class="easyui-linkbutton c6" data-item="BTN_001" data-options="disabled:${INS}">등록</a>
                    <a href="javascript:void(0)" id="btn-delete" class="easyui-linkbutton c6" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
                </div>
            </td></tr>
        </table>
    </fieldset>
</div>

<!-- 조회영역을 붙일 패널 -->
<div data-options="region:'north', border:true" id="search-grid-panel"></div>

</div>

<!-- 편집 다이얼로그 (D0A) INCLUDE -->
<%@ include file="/WEB-INF/views/imes/std/std52a_dialog.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
