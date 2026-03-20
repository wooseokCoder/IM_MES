<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord18a.jsp 1.0 2026/03/06                                         --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2026 WSC, INC.                                           --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 실적삭제/삭제현황/오더완료일수정 (ORD18A)                              --%>
<%-- 원본: ProActive ORD18A_M0A.cs                                         --%>
<%-- 3-Tab: 실적삭제(ACT) / 삭제현황(ACTD) / 오더완료일수정(WO)           --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord18a.js"/>?v=260306B"></script>

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

<!-- 3-Tab 구조 (각 탭이 독립된 검색영역+그리드) -->
<div data-options="region:'center', border:false">
    <div id="main-tabs" class="easyui-tabs" data-options="fit:true, border:false">

        <!-- ====================================================== -->
        <!-- Tab1: 실적삭제 (ACT) -->
        <!-- ====================================================== -->
        <div title="실적삭제" id="tab-act" style="padding:0">
            <div class="easyui-layout" data-options="fit:true">

                <!-- 검색 영역 -->
                <div data-options="region:'north', border:false" style="height:78px;">
                    <div id="search-toolbar1" class="wui-toolbar">
                        <form id="search-form1">
                            <fieldset class="Remake-div-line-new">
                                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                                    <colgroup>
                                        <col width="0px">
                                        <col width="100px">
                                        <col width="120px">
                                        <col width="20px">
                                        <col width="120px">
                                        <col width="*">
                                    </colgroup>
                                    <tr class="topnav_sty">
                                        <td colspan="6">
                                            <div>
                                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                                <div>
                                                    <a href="javascript:void(0)" id="search-button1" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                                                    <a href="javascript:void(0)" id="btn-delete" class="easyui-linkbutton c6" data-options="disabled:${UPD}">삭제</a>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="h table-Search-h search-label-h"><span>일자구분</span></th>
                                        <td class="d">
                                            <select id="s1_dateType" class="easyui-combobox" name="dateType"
                                                data-options="width:90, panelHeight:'auto', editable:false, multiple:true">
                                                <option value="WORK_DATE" selected>실적 시작일</option>
                                                <option value="WO_DATE">오더 완료일</option>
                                            </select>
                                        </td>
                                        <td class="d">
                                            <input id="s1_sDate" class="easyui-datebox" name="sDate"
                                                data-options="width:110, editable:false, required:true" />
                                        </td>
                                        <td class="d" style="text-align:center;">~</td>
                                        <td class="d">
                                            <input id="s1_eDate" class="easyui-datebox" name="eDate"
                                                data-options="width:110, editable:false, required:true" />
                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                            </fieldset>
                        </form>
                    </div>
                </div>

                <!-- Grid1 (실적삭제) -->
                <div data-options="region:'center', border:false">
                    <table id="grid1"></table>
                </div>

            </div>
        </div>

        <!-- ====================================================== -->
        <!-- Tab2: 삭제현황 (ACTD) -->
        <!-- ====================================================== -->
        <div title="삭제현황" id="tab-actd" style="padding:0">
            <div class="easyui-layout" data-options="fit:true">

                <!-- 검색 영역 -->
                <div data-options="region:'north', border:false" style="height:78px;">
                    <div id="search-toolbar2" class="wui-toolbar">
                        <form id="search-form2">
                            <fieldset class="Remake-div-line-new">
                                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                                    <colgroup>
                                        <col width="0px">
                                        <col width="100px">
                                        <col width="120px">
                                        <col width="20px">
                                        <col width="120px">
                                        <col width="*">
                                    </colgroup>
                                    <tr class="topnav_sty">
                                        <td colspan="6">
                                            <div>
                                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                                <div>
                                                    <a href="javascript:void(0)" id="search-button2" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                                                    <a href="javascript:void(0)" id="btn-delete-cancel" class="easyui-linkbutton c6" data-options="disabled:${UPD}">삭제취소</a>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="h table-Search-h search-label-h"><span>일자구분</span></th>
                                        <td class="d">
                                            <select id="s2_dateType" class="easyui-combobox" name="dateType"
                                                data-options="width:90, panelHeight:'auto', editable:false, multiple:true">
                                                <option value="WORK_DATE" selected>실적 시작일</option>
                                                <option value="WO_DATE">오더 완료일</option>
                                            </select>
                                        </td>
                                        <td class="d">
                                            <input id="s2_sDate" class="easyui-datebox" name="sDate"
                                                data-options="width:110, editable:false, required:true" />
                                        </td>
                                        <td class="d" style="text-align:center;">~</td>
                                        <td class="d">
                                            <input id="s2_eDate" class="easyui-datebox" name="eDate"
                                                data-options="width:110, editable:false, required:true" />
                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                            </fieldset>
                        </form>
                    </div>
                </div>

                <!-- Grid2 (삭제현황) -->
                <div data-options="region:'center', border:false">
                    <table id="grid2"></table>
                </div>

            </div>
        </div>

        <!-- ====================================================== -->
        <!-- Tab3: 오더완료일수정 (WO) -->
        <!-- ====================================================== -->
        <div title="오더완료일수정" id="tab-wo" style="padding:0">
            <div class="easyui-layout" data-options="fit:true">

                <!-- 검색 영역 -->
                <div data-options="region:'north', border:false" style="height:78px;">
                    <div id="search-toolbar3" class="wui-toolbar">
                        <form id="search-form3">
                            <fieldset class="Remake-div-line-new">
                                <table cellpadding="0" class="search-table tableSearch-c wd-100">
                                    <colgroup>
                                        <col width="100px">
                                        <col width="120px">
                                        <col width="20px">
                                        <col width="120px">
                                        <col width="50px">
                                        <col width="120px">
                                        <col width="80px">
                                        <col width="80px">
                                        <col width="40px">
                                        <col width="80px">
                                        <col width="40px">
                                        <col width="120px">
                                        <col width="*">
                                    </colgroup>
                                    <tr class="topnav_sty">
                                        <td colspan="13">
                                            <div>
                                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                                <div>
                                                    <a href="javascript:void(0)" id="search-button3" class="easyui-linkbutton cgray" data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                                                    <a href="javascript:void(0)" id="btn-wo-edit" class="easyui-linkbutton c6" data-options="disabled:${UPD}">오더완료일 수정</a>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <!-- 오더 완료일 체크 드롭다운: Tab1/Tab2 동일 스타일 (AS-IS acCheckedComboBoxEdit3) -->
                                        <td class="d">
                                            <select id="s3_dateType" class="easyui-combobox" name="dateType"
                                                data-options="width:90, panelHeight:'auto', editable:false, multiple:true">
                                                <option value="WO_DATE" selected>오더 완료일</option>
                                            </select>
                                        </td>
                                        <td class="d">
                                            <input id="s3_sDate" class="easyui-datebox" name="sDate"
                                                data-options="width:110, editable:false, required:true" />
                                        </td>
                                        <td class="d" style="text-align:center;">~</td>
                                        <td class="d">
                                            <input id="s3_eDate" class="easyui-datebox" name="eDate"
                                                data-options="width:110, editable:false, required:true" />
                                        </td>
                                        <!-- AS-IS 순서: 호기 → 생산오더 → 공정 → 공장 -->
                                        <th class="h table-Search-h search-label-h"><span>호기</span></th>
                                        <td class="d">
                                            <input id="s3_hogiLike" class="easyui-textbox" data-options="width:70"/>
                                        </td>
                                        <th class="h table-Search-h search-label-h"><span>생산오더</span></th>
                                        <td class="d">
                                            <input id="s3_sapWoLike" class="easyui-textbox" data-options="width:110"/>
                                        </td>
                                        <th class="h table-Search-h search-label-h"><span>공정</span></th>
                                        <td class="d">
                                            <input id="s3_procLike" class="easyui-textbox" data-options="width:70"/>
                                        </td>
                                        <th class="h table-Search-h search-label-h"><span>공장</span></th>
                                        <td class="d">
                                            <input id="s3_plants" class="easyui-combobox"
                                                data-options="width:110, editable:false, panelHeight:'auto'"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                            </fieldset>
                        </form>
                    </div>
                </div>

                <!-- Grid3 (오더완료일) -->
                <div data-options="region:'center', border:false">
                    <table id="grid3"></table>
                </div>

            </div>
        </div>

    </div>
</div>

</div>

<!-- ====================================================== -->
<!-- D0A 팝업: 오더완료일 수정 (레이어 다이얼로그) -->
<!-- 원본: ProActive ORD18A_D0A.cs (ClientSize 353x78) -->
<!-- ====================================================== -->
<div id="d0a-dialog" class="easyui-dialog" data-options="
        width: 420,
        height: 160,
        closed: true,
        modal: true,
        title: '오더완료일 수정',
        buttons: '#d0a-dialog-buttons'
    " style="padding:10px 20px;">
    <form id="d0a-form">
        <input type="hidden" id="d0a_woNo" />
        <table cellpadding="5" style="border-collapse:collapse;">
            <tr>
                <!-- 시작시간 -->
                <td>
                    <input id="d0a_actStartTime" class="easyui-datetimebox"
                        data-options="width:170, editable:false, required:true" />
                </td>
                <td style="padding:0 5px;">~</td>
                <!-- 종료시간 -->
                <td>
                    <input id="d0a_actEndTime" class="easyui-datetimebox"
                        data-options="width:170, editable:false, required:true" />
                </td>
            </tr>
        </table>
    </form>
</div>
<div id="d0a-dialog-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d0a-save-button">저장</a>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
