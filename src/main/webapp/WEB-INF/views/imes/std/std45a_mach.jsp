<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std45a_mach.jsp 1.0 2026/02/05                                     --%>
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
<%-- 비가동코드 관리 - 가공 화면 (PLANTS=3605)                                 --%>
<%-- 원본: ProActive STD45A_M0A.cs                                           --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/02/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- 화면별 변수 설정 -->
<script type="text/javascript">
    var PAGE_PLANTS = '${plants}';          // 3605
    var PAGE_PLANTS_NAME = '${plantsName}'; // 가공
    var PAGE_SHOW_MCT_SCOMMENT = true;      // 가공 전용 컬럼 표시 (비가동 상세원인 등록여부)
</script>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/std/std45a.js?v=260313C" />"></script>

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
      <th data-options="field:'mgType1', width:80, halign:'center', align:'center', resizable:true,
          formatter:function(v){return formatCode('S901',v);}, data_item:'GRD_001'">구분1</th>
      <th data-options="field:'mgType2', width:100, halign:'center', align:'center', resizable:true,
          formatter:function(v){return formatCode('S902',v);}, data_item:'GRD_002'">구분2</th>
    </tr>
  </thead>
  <thead>
    <tr>
      <th data-options="field:'scode', width:100, halign:'center', align:'center', hidden:true">SCODE</th>
      <th data-options="field:'sapCode', width:100, halign:'center', align:'center', resizable:true, data_item:'GRD_003'">SAP코드</th>
      <th data-options="field:'idleCode', width:100, halign:'center', align:'center', resizable:true, data_item:'GRD_004'">MES코드</th>
      <th data-options="field:'idleName', width:180, halign:'center', align:'left', resizable:true, data_item:'GRD_005'">비가동명</th>
      <th data-options="field:'idleSeq', width:80, halign:'center', align:'right', resizable:true,
          editor:{type:'numberbox',options:{precision:0,max:2147483647}},
          styler:editableCellStyler, data_item:'GRD_006'">정렬순서</th>
      <th data-options="field:'mgOrgName', width:120, halign:'center', align:'center', resizable:true, data_item:'GRD_007'">관리부서</th>
      <th data-options="field:'scomment', width:200, halign:'center', align:'left', resizable:true, data_item:'GRD_008'">정의</th>
      <th data-options="field:'useFlag', width:80, halign:'center', align:'center', resizable:true,
          formatter:function(v){return formatCode('S900',v);},
          editor:{type:'combobox',options:{valueField:'codeCd',textField:'codeName',panelHeight:'auto',editable:false,data:consts.codeData.S900}},
          styler:editableCellStyler, data_item:'GRD_009'">사용여부</th>
      <th data-options="field:'isNg', width:110, halign:'center', align:'center', resizable:true,
          formatter:function(v,r,i){return formatCheckClick('isNg',v,r,i);},
          styler:editableCellStyler, data_item:'GRD_010'">부적합 등록여부</th>
      <th data-options="field:'alarmType', width:80, halign:'center', align:'center', resizable:true,
          formatter:function(v){return formatCode('W004',v);}, data_item:'GRD_011'">알람구분</th>
      <th data-options="field:'isSap', width:100, halign:'center', align:'center', resizable:true,
          formatter:function(v,r,i){return formatCheckClick('isSap',v,r,i);},
          styler:editableCellStyler, data_item:'GRD_012'">SAP전송 여부</th>
      <th data-options="field:'isRpt', width:100, halign:'center', align:'center', resizable:true,
          formatter:function(v,r,i){return formatCheckClick('isRpt',v,r,i);},
          styler:editableCellStyler, data_item:'GRD_013'">지표 포함여부</th>
      <th data-options="field:'isMctScomment', width:150, halign:'center', align:'center', resizable:true,
          formatter:function(v,r,i){return formatCheckClick('isMctScomment',v,r,i);},
          styler:editableCellStyler, data_item:'GRD_014'">비가동 상세원인 등록여부</th>
    </tr>
  </thead>
</table>

<!-- 조회 영역 (Toolbar) -->
<div id="search-toolbar" class="wui-toolbar">
    <form id="search-form">
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup>
                    <col width="120px">
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
                    <th class="h table-Search-h search-label-h" data-item="LAB_001"><span>비가동유형 코드/명</span></th>
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
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_002" data-options="disabled:${UPD}">저장</a>
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

<!-- 편집 다이얼로그 + 조직 검색 팝업 (공통) -->
<%@ include file="/WEB-INF/views/imes/std/std45a_dialog.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
