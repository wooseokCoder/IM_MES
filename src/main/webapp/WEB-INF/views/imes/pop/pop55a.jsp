<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)pop55a.jsp 1.0 2026/03/07                                         --%>
<%-- NAM공정 NG파일배포 확인 - POP55A                                      --%>
<%-- 원본: ProActive POP55A_M0A.cs                                         --%>
<%-- 좌우 분할: Grid1(제품 목록) + Grid2(파일 목록)                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop55a.js"/>?v=260307A"></script>
</head>

<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 로딩바 -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

<!-- ============================================================ -->
<!-- NORTH: 검색 영역 -->
<!-- ============================================================ -->
<div data-options="region:'north', border:false">
    <div id="search-toolbar" class="wui-toolbar datagrid-toolbar">
        <form id="search-form">
            <!-- 1단: topnav + 검색버튼 -->
            <fieldset class="Remake-div-line-new">
                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="0px">
                        <col width="*">
                    </colgroup>
                    <tr class="topnav_sty">
                        <td colspan="2">
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-options="disabled:${RET}">조회</a>
                                    <a href="javascript:void(0)" id="confirm-button" class="easyui-linkbutton c6">확인완료</a>
                                    <a href="javascript:void(0)" id="delete-button" class="easyui-linkbutton c6" data-options="disabled:${UPD}">삭제</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <!-- 검색 조건 1행 -->
                    <tr>
                        <th class="h table-Search-h search-label-h"></th>
                        <td class="d">
                            <table cellpadding="3" style="border-collapse:collapse;">
                                <tr>
                                    <!-- 일자구분 -->
                                    <td style="padding-right:5px;">
                                        <select id="s_dateType" class="easyui-combobox" name="dateType"
                                            data-options="width:100, panelHeight:'auto', editable:false, multiple:true">
                                            <option value="INDUE_DATE" selected>생산계획일</option>
                                            <option value="CHK_DATE">확인일</option>
                                        </select>
                                    </td>
                                    <!-- 시작일 ~ 종료일 -->
                                    <td style="padding-right:3px;">
                                        <input id="s_sDate" class="easyui-datebox" name="sDate"
                                            data-options="width:110, editable:false, required:true" />
                                    </td>
                                    <td style="padding:0 3px;">~</td>
                                    <td style="padding-right:10px;">
                                        <input id="s_eDate" class="easyui-datebox" name="eDate"
                                            data-options="width:110, editable:false, required:true" />
                                    </td>
                                    <!-- 호기 -->
                                    <td style="padding-right:5px;">
                                        <span style="font-size:12px;">호기</span>
                                    </td>
                                    <td style="padding-right:10px;">
                                        <input id="s_hogiLike" class="easyui-textbox" name="hogiLike"
                                            data-options="width:80" />
                                    </td>
                                    <!-- 판매오더 -->
                                    <td style="padding-right:5px;">
                                        <span style="font-size:12px;">판매오더</span>
                                    </td>
                                    <td style="padding-right:10px;">
                                        <input id="s_orderLike" class="easyui-textbox" name="orderLike"
                                            data-options="width:100" />
                                    </td>
                                    <!-- 거래처 -->
                                    <td style="padding-right:5px;">
                                        <span style="font-size:12px;">거래처</span>
                                    </td>
                                    <td style="padding-right:10px;">
                                        <input id="s_customerLike" class="easyui-textbox" name="customerLike"
                                            data-options="width:100" />
                                    </td>
                                    <!-- 구분 (전동/유압) -->
                                    <td style="padding-right:5px;">
                                        <span style="font-size:12px;">구분</span>
                                    </td>
                                    <td style="padding-right:10px;">
                                        <input id="s_prodType" class="easyui-combobox" name="prodType"
                                            codeGrup="S907"
                                            data-options="width:100, panelHeight:'auto', editable:false,
                                            mode:'remote', loader:jcombo.loader" />
                                    </td>
                                    <!-- 기계번호 -->
                                    <td style="padding-right:5px;">
                                        <span style="font-size:12px;">기계번호</span>
                                    </td>
                                    <td>
                                        <input id="s_mcNoLike" class="easyui-textbox" name="mcNoLike"
                                            data-options="width:100" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- ============================================================ -->
<!-- WEST: Grid1 (Master - 제품 목록) -->
<!-- ============================================================ -->
<div data-options="region:'west', split:true, border:true" style="width:65%">
    <table id="grid1"></table>
</div>

<!-- ============================================================ -->
<!-- CENTER: Grid2 (Detail - 파일 목록) -->
<!-- ============================================================ -->
<div data-options="region:'center', border:true">
    <table id="grid2"></table>
</div>

</div>

<!-- ============================================================ -->
<!-- D0A: 비고 입력 다이얼로그 (inline) -->
<!-- ============================================================ -->
<%@ include file="/WEB-INF/views/imes/pop/pop55a_d0a.jsp" %>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
