<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord32a.jsp 1.0 2026/03/10                                         --%>
<%-- NG 조립 파일 모델/공정 매핑 관리 - ORD32A                              --%>
<%-- 원본: ProActive ORD32A_M0A.cs, ORD32A_D0A.cs                          --%>
<%-- 레이아웃:                                                              --%>
<%--   상단 좌: Grid1 (파일목록), 상단 우: 첨부파일 (acAttachFileControl)     --%>
<%--   하단 좌: Grid2 (모델), 하단 우: Grid3 (공정)                        --%>
<%--   D0A 팝업: 모델/공정 편집 (4 grids)                                  --%>
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
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord32a_d0a.js"/>?v=260310C"></script>
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord32a.js"/>?v=260310D"></script>
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
<!-- NORTH: 검색 영역 (검색 조건 없음, 조회 버튼만) -->
<!-- ============================================================ -->
<div data-options="region:'north', border:false">
    <div id="search-toolbar" class="wui-toolbar datagrid-toolbar">
        <form id="search-form">
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
                                    <a href="javascript:void(0)" id="edit-button" class="easyui-linkbutton c6" data-options="disabled:${UPD}">편집</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- ============================================================ -->
<!-- CENTER: 메인 컨텐츠 (좌우 분할 → 각각 상하 분할) -->
<!-- ============================================================ -->
<div data-options="region:'center'">
    <div class="easyui-layout" data-options="fit:true">

        <!-- 좌측: Grid1 (파일목록) + Grid2 (모델) -->
        <div data-options="region:'center', border:true">
            <div class="easyui-layout" data-options="fit:true">
                <!-- 좌 상단: Grid1 (파일목록) -->
                <div data-options="region:'north', split:true, border:true" style="height:50%">
                    <table id="grid1"></table>
                </div>
                <!-- 좌 하단: Grid2 (모델) -->
                <div data-options="region:'center', border:true, title:'모델'">
                    <table id="grid2"></table>
                </div>
            </div>
        </div>

        <!-- 우측: 첨부파일 영역 + Grid3 (공정) -->
        <div data-options="region:'east', split:true, border:true" style="width:50%">
            <div class="easyui-layout" data-options="fit:true">
                <!-- 우 상단: 첨부파일 영역 (acAttachFileControl 공통 모듈) -->
                <!-- AS-IS: acAttachFileControl1 (LinkKey="NG_ASSY_FILE", 3탭) -->
                <div data-options="region:'north', split:true, border:true" style="height:50%">
                    <%@ include file="/WEB-INF/views/imes/com/acAttachFileControl.jsp" %>
                </div>
                <!-- 우 하단: Grid3 (공정) -->
                <div data-options="region:'center', border:true, title:'공정'">
                    <table id="grid3"></table>
                </div>
            </div>
        </div>

    </div>
</div>

</div>

<!-- D0A: 모델/공정 편집 다이얼로그 (별도 파일) -->
<%@ include file="/WEB-INF/views/imes/ord/ord32a_d0a.jsp" %>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
