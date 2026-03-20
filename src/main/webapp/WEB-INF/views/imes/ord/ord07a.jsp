<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord07a.jsp 1.0 2026/02/10                                         --%>
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
<%-- 일련번호 관리 (ORD07A)                                                --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/02/10                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord07a.js"/>?v=<%= System.currentTimeMillis() %>"></script>

<style>
/* common.css '.datagrid-body table { width:100% }' 오버라이드 */
.datagrid-view.noStyle .datagrid-body table,
.datagrid-view.noStyle .datagrid-header table {
    width: auto !important;
}
/* 컬럼 없는 빈 영역의 헤더 하단 라인 제거 (common.css !important 오버라이드) */
.datagrid-view.noStyle .datagrid-header {
    border-bottom: none !important;
}
</style>

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

<!-- 상단: 검색 영역 (전체 너비) -->
<div data-options="region:'north', border:false" style="height:auto;">
    <div id="search-toolbar" class="wui-toolbar">
        <form id="search-form">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="43px">   <!-- 모델 (라벨) -->
                        <col width="210px">  <!-- 입력필드 -->
                        <col width="*">      <!-- 남은 공간 -->
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
                        <th class="h table-Search-h search-label-h" data-item="LAB_001"><span>모델</span></th>
                        <td class="d">
                            <input id="s_modelLike" class="easyui-textbox" data-options="width:200"/>
                        </td>
                        <td class="d"></td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- 그리드 영역 -->
<div data-options="region:'center', border:false">
<table id="search-grid">
  <thead>
    <tr>
      <th data-options="field:'srKey', width:80, halign:'center', align:'center', data_item:'GRD_001'">년도</th>
      <th data-options="field:'srCode', width:150, halign:'center', align:'center', data_item:'GRD_002'">모델</th>
      <th data-options="field:'srNo', width:60, halign:'center', align:'center', data_item:'GRD_003'">순번</th>
    </tr>
  </thead>
</table>
</div>

</div>

<!-- 그리드 우클릭 컨텍스트 메뉴 -->
<div id="grid-context-menu" class="easyui-menu" data-options="hideOnUnhover:false" style="width:120px;">
    <div id="ctx-open" data-item="BTN_001">열기</div>
</div>

<!-- D0A 팝업 (href 동적 로드) -->
<div id="d0a-popup" class="easyui-dialog" data-options="
    width:400, height:'auto', closed:true, modal:true, title:'호기 순번 수정',
    href:'<c:url value="/imes/ord/ord07a_d0a.do" />',
    onLoad: initD0aPopup,
    buttons: '#d0a-buttons'" style="visibility:hidden;">
</div>
<div id="d0a-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d0a-save-button" data-options="disabled:${UPD}">저장</a>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
