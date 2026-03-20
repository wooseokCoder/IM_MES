<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)mat02a.jsp 1.0 2026/03/03                                         --%>
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
<%-- 재고정보 조회 (MAT02A)                                                 --%>
<%-- 원본: ProActive MAT02A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.0 2026/03/03                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/mat/mat02a.js"/>?v=260313B"></script>

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
<div data-options="region:'north', border:false" style="height:78px;">
    <div id="search-toolbar" class="wui-toolbar">
        <form id="search-form">
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="43px">   <!-- 타입 (라벨) -->
                        <col width="250px">  <!-- 멀티콤보 -->
                        <col width="82px">   <!-- 자재번호/명 (라벨) -->
                        <col width="150px">  <!-- 텍스트박스 -->
                        <col width="*">      <!-- 남은 공간 -->
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
                        <th class="h table-Search-h search-label-h"><span>타입</span></th>
                        <td class="d">
                            <%-- AS-IS: CheckedComboBoxEdit (4개 항목 체크박스) --%>
                            <select id="s_stockTypes" class="easyui-combobox"
                                data-options="multiple:true, editable:false, panelHeight:'auto', width:230">
                                <option value="COMM">일반재고</option>
                                <option value="ORDER">판매오더재고</option>
                                <option value="CVND">고객 특별재고</option>
                                <option value="MVND">공급업체 특별재고</option>
                            </select>
                        </td>
                        <th class="h table-Search-h search-label-h"><span>자재번호/명</span></th>
                        <td class="d">
                            <input id="s_partLike" class="easyui-textbox" data-options="width:140"/>
                        </td>
                        <td></td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- 그리드 영역 (Center) -->
<div data-options="region:'center', border:false">
    <table id="search-grid"></table>
</div>

</div>

<!-- 파일 목록 공통 팝업 -->
<%@ include file="/WEB-INF/views/imes/com/acFileForm.jsp" %>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
