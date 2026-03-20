<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)pop43a.jsp 1.0 2026/03/11                                         --%>
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
<%-- 수리수선 이력관리 - POP43A                                            --%>
<%-- 원본: ProActive POP43A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- 검색: 멀티체크콤보(일자), 시작일~종료일, 수리업체, 설비               --%>
<%-- 그리드: 수리수선 이력 (일자, 수리업체, 설비, 금액 등)                 --%>
<%-- 버튼: 신규, 삭제                                                       --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/03/11                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop43a.js"/>?v=260313B"></script>

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
<!-- AS-IS: acGridView1 (GridType=SEARCH, 읽기전용) -->
<table id="search-grid">
  <thead>
    <tr>
      <!-- 선택 컬럼 (AS-IS: SEL CheckEdit) -->
      <th data-options="field:'ck', width:50, halign:'center', align:'center', resizable:false,
          formatter:formatCheckbox" data-item="GRD_000">선택</th>
      <!-- 숨김 컬럼 (PK) -->
      <th data-options="field:'pltCode', hidden:true">PLT_CODE</th>
      <th data-options="field:'mcrId', hidden:true">MCR_ID</th>
      <!-- 표시 컬럼 -->
      <th data-options="field:'repairDate', width:100, halign:'center', align:'center', resizable:true,
          formatter:formatDate"
          data-item="GRD_001">일자</th>
      <th data-options="field:'repairVendor', width:120, halign:'center', align:'left', resizable:true"
          data-item="GRD_002">수리업체</th>
      <th data-options="field:'repairMc', width:80, halign:'center', align:'left', resizable:true"
          data-item="GRD_003">설비</th>
      <th data-options="field:'repairMcType', width:80, halign:'center', align:'left', resizable:true"
          data-item="GRD_004">설비구분</th>
      <th data-options="field:'repairName', width:80, halign:'center', align:'left', resizable:true"
          data-item="GRD_005">수리</th>
      <th data-options="field:'repairContents', width:350, halign:'center', align:'left', resizable:true"
          data-item="GRD_006">수리내역</th>
      <th data-options="field:'repairAmount', width:100, halign:'center', align:'right', resizable:true,
          formatter:formatNumber"
          data-item="GRD_007">금액</th>
    </tr>
  </thead>
</table>

<!-- 조회 영역 (Toolbar) -->
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <!-- 1단: 검색 영역 -->
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup>
                    <col width="100px">
                    <col width="120px">
                    <col width="15px">
                    <col width="120px">
                    <col width="65px">
                    <col width="150px">
                    <col width="42px">
                    <col width="150px">
                    <col width="*">
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
                    <!-- 멀티체크콤보: 일자 -->
                    <th class="h table-Search-h search-label-h">
                        <input class="easyui-combobox" id="s_dateType"
                            data-options="width:100, editable:false, panelHeight:'auto',
                            multiple:true, separator:',',
                            valueField:'id', textField:'text',
                            data:[{id:'REPAIR_DATE',text:'일자'}]"/>
                    </th>
                    <td class="d">
                        <input id="s_startDate" class="easyui-datebox" data-options="width:120, editable:true"/>
                    </td>
                    <td class="d" style="text-align:center;">~</td>
                    <td class="d">
                        <input id="s_endDate" class="easyui-datebox" data-options="width:120, editable:true"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>수리업체</span></th>
                    <td class="d">
                        <input id="s_repairVendorLike" class="easyui-textbox" data-options="width:150, validType:'length[0,100]'"/>
                    </td>
                    <th class="h table-Search-h search-label-h"><span>설비</span></th>
                    <td class="d">
                        <input id="s_repairMcLike" class="easyui-textbox" data-options="width:150, validType:'length[0,100]'"/>
                    </td>
                    <td></td>
                </tr>
            </table>
        </fieldset>
        <!-- 2단: 버튼 영역 -->
        <fieldset class="div-line-new-sub grd-div-btn">
            <table cellpadding="7" class="search-table tableEtc-c wd-100">
                <tr>
                    <td class="h">
                        <div class="dis_flex_gap4">
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="new-button" data-item="BTN_001" data-options="disabled:${INS}">신규</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="delete-button" data-item="BTN_002" data-options="disabled:${DEL}">삭제</a>
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

<!-- 편집 팝업 INCLUDE -->
<%@ include file="/WEB-INF/views/imes/pop/pop43a_d0a.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
