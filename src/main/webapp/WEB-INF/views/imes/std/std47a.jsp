<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std47a.jsp 1.0 2026/03/03                                         --%>
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
<%-- 작업표준서(조립) (STD47A)                                               --%>
<%-- 원본: ProActive STD47A_M0A.cs                                          --%>
<%--                                                                        --%>
<%-- @author AI Assistant                                                   --%>
<%-- @version 1.0 2026/03/03                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/std/std47a.js"/>?v=260303A"></script>

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
<div data-options="region:'north', border:false" style="height:auto;">
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
                            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                                <colgroup>
                                    <col width="80px">
                                    <col width="*">
                                </colgroup>
                                <tr>
                                    <th class="h table-Search-h search-label-h"><span>모델</span></th>
                                    <td class="d">
                                        <input id="s_modelLike" name="modelLike" class="easyui-textbox" data-options="width:'100%', prompt:'모델코드 또는 모델명 입력'"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td></td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </div>
</div>

<!-- 탭 + 분할 영역 (Center) -->
<div data-options="region:'center', border:false">
    <div id="tab-panel" class="easyui-tabs" data-options="fit:true, border:false, onSelect:onTabSelect">
        <!-- 탭1: 작업표준서 등록 (INPUT) -->
        <div title="작업표준서 등록" data-options="containerName:'INPUT'" style="padding:0px;">
            <div class="easyui-layout" data-options="fit:true">
                <!-- 좌측: 모델 트리 -->
                <div data-options="region:'west', split:true, collapsible:false, border:true" style="width:50%;">
                    <table id="model-tree"></table>
                </div>
                <!-- 우측: 파일 첨부 (acAttachFileControl) -->
                <div data-options="region:'center', border:true">
                    <%@ include file="/WEB-INF/views/imes/com/acAttachFileControl.jsp" %>
                </div>
            </div>
        </div>
        <!-- 탭2: 리스트 (LIST) -->
        <div title="리스트" data-options="containerName:'LIST'" style="padding:0px;">
            <table id="list-grid"></table>
        </div>
    </div>
</div>

</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
