<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)pop56a.jsp 1.0 2026/03/07                                         --%>
<%-- 불량메일 발신자 관리 - POP56A                                          --%>
<%-- 원본: ProActive POP56A_M0A.cs                                         --%>
<%--                                                                        --%>
<%-- 레이아웃: West(전동E) / Center(유압P) 분할                             --%>
<%-- 각 패널: 발신자 입력 + 수신자 그리드                                   --%>
<%-- 컨텍스트 메뉴: 사원 등록, 삭제                                         --%>
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
<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop56a.js"/>?v=260307A"></script>
<script type="text/javascript">
    /* 서버에서 로딩한 발신자 설정값 전달 */
    doInit({
        ngMailE: '<c:out value="${ngMailE}" />',
        ngMailP: '<c:out value="${ngMailP}" />',
        ngMailEName: '<c:out value="${ngMailEName}" />',
        ngMailPName: '<c:out value="${ngMailPName}" />'
    });
</script>
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
<!-- NORTH: 검색 영역 (툴바) -->
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
                                    <a href="javascript:void(0)" id="save-config-button" class="easyui-linkbutton c6">저장</a>
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
<!-- CENTER: 좌-우 분할 (전동E / 유압P) -->
<!-- ============================================================ -->
<div data-options="region:'center', border:false">
    <div class="easyui-layout" data-options="fit:true">

        <!-- WEST: 전동(E) 패널 -->
        <div data-options="region:'west', split:true, border:true, title:''" style="width:50%">
            <div class="easyui-layout" data-options="fit:true">
                <!-- 전동 발신자 입력 -->
                <div data-options="region:'north', border:false" style="height:40px; padding:5px 10px;">
                    <table cellpadding="0" style="border-collapse:collapse;">
                        <tr>
                            <td style="padding-right:5px;">
                                <span style="font-size:12px; font-weight:bold;">전동 발신자</span>
                            </td>
                            <td>
                                <input type="hidden" id="empE_code" />
                                <input id="empE" class="easyui-textbox" data-options="width:180, editable:false, icons:[{iconCls:'icon-search',handler:function(e){doSearchSender('E');}}]" />
                            </td>
                        </tr>
                    </table>
                </div>
                <!-- 전동 수신자 그리드 -->
                <div data-options="region:'center', border:false">
                    <table id="grid1"></table>
                </div>
            </div>
        </div>

        <!-- CENTER: 유압(P) 패널 -->
        <div data-options="region:'center', border:true, title:''">
            <div class="easyui-layout" data-options="fit:true">
                <!-- 유압 발신자 입력 -->
                <div data-options="region:'north', border:false" style="height:40px; padding:5px 10px;">
                    <table cellpadding="0" style="border-collapse:collapse;">
                        <tr>
                            <td style="padding-right:5px;">
                                <span style="font-size:12px; font-weight:bold;">유압 발신자</span>
                            </td>
                            <td>
                                <input type="hidden" id="empP_code" />
                                <input id="empP" class="easyui-textbox" data-options="width:180, editable:false, icons:[{iconCls:'icon-search',handler:function(e){doSearchSender('P');}}]" />
                            </td>
                        </tr>
                    </table>
                </div>
                <!-- 유압 수신자 그리드 -->
                <div data-options="region:'center', border:false">
                    <table id="grid2"></table>
                </div>
            </div>
        </div>

    </div>
</div>

</div>

<!-- ============================================================ -->
<!-- 컨텍스트 메뉴 (Grid1, Grid2 공통) -->
<!-- ============================================================ -->
<div id="grid-menu" class="easyui-menu" style="width:120px;">
    <div data-options="iconCls:'icon-add'" onclick="doAddEmp()">사원 등록</div>
    <div data-options="iconCls:'icon-remove'" onclick="doDeleteEmp()">삭제</div>
</div>

<!-- ============================================================ -->
<!-- D0A 팝업 (사원 등록) -->
<!-- ============================================================ -->
<%@ include file="/WEB-INF/views/imes/pop/pop56a_d0a.jsp" %>

<!-- ============================================================ -->
<!-- 사원 검색 공통 팝업 (acEmpForm) - 발신자 돋보기 버튼용 -->
<!-- ============================================================ -->
<%@ include file="/WEB-INF/views/imes/com/acEmpForm.jsp" %>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
