<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<style>
/* 연간 달력 스타일 */
#calendar-panel { padding:6px; overflow-y:auto; height:100%; box-sizing:border-box; }
#calendar-nav { text-align:center; margin-bottom:6px; padding:4px 0; }
#calendar-nav a { cursor:pointer; font-size:18px; font-weight:bold; padding:0 12px; text-decoration:none; color:#333; }
#calendar-nav span { font-size:16px; font-weight:bold; min-width:90px; display:inline-block; }
#calendar-grid { display:flex; flex-wrap:wrap; gap:6px; }
.mini-cal-wrap { flex:1 1 160px; min-width:140px; }
.mini-cal { width:100%; border-collapse:collapse; }
.mini-cal-title { text-align:center; font-size:12px; font-weight:bold; padding:4px 0; background:#f5f5f5; border:1px solid #ddd; }
.mini-cal th { text-align:center; padding:2px; font-size:11px; color:#888; }
.mini-cal td { text-align:center; padding:3px 2px; font-size:11px; cursor:pointer; line-height:1.4; }
.mini-cal td:hover { background-color:#e8f0fe; }
.mini-cal td.today { font-weight:bold; border:1px solid #4285f4; }
.mini-cal td.selected { background-color:#4285f4; color:#fff; }
.mini-cal td.holiday { background-color:#ffe0e0; color:#d32f2f; font-weight:bold; }
.mini-cal td.other-month { color:#ddd; cursor:default; }
.mini-cal td.sunday { color:#d32f2f; }
.mini-cal td.saturday { color:#1976d2; }
</style>
<script src="<c:url value='/resources/js/imes/std/std23b.js' />"></script>
</head>
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>

<div id="loadingProgressBar" style="position:absolute; z-index:99; left:45%; top:50%;">
    <img src="<c:url value='/resources/images/loading_02.gif' />" />
</div>

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

    <!-- 좌측: 연간 달력 -->
    <div data-options="region:'west', split:true, title:'달력'" style="width:51%;">
        <div id="calendar-panel">
            <div id="calendar-nav">
                <a id="cal-prev-year" href="javascript:void(0)">&laquo;</a>
                <span id="cal-title"></span>
                <a id="cal-next-year" href="javascript:void(0)">&raquo;</a>
            </div>
            <div id="calendar-body"></div>
        </div>
    </div>

    <!-- 우측: 휴일 목록 그리드 -->
    <div data-options="region:'center', border:false">
        <table id="search-grid"></table>
        <div id="search-toolbar" class="wui-toolbar">
            <form id="search-form">
                <fieldset class="Remake-div-line-new">
                    <table cellpadding="7" class="search-table tableSearch-c wd-100" style="table-layout: auto;">
                        <tr class="topnav_sty">
                            <td colspan="4">
                                <div>
                                    <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                    <div>
                                        <a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray"
                                           data-item="BTN_000" data-options="disabled:${RET}">조회</a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </form>
        </div>
    </div>
</div>

<!-- 달력 우클릭 컨텍스트 메뉴 -->
<div id="calendar-context-menu" class="easyui-menu" style="width:120px;">
    <div id="ctx-set-holiday">휴일설정</div>
    <div id="ctx-clear-holiday">휴일해제</div>
</div>

<!-- D1B 팝업: 휴일설정 -->
<div id="d1b-popup" class="easyui-dialog" data-options="
    width:346, height:'auto', closed:true, modal:true, title:'휴일설정',
    href:'<c:url value='/imes/std/std23a_d1b.do' />',
    onLoad: initD1bPopup,
    buttons: '#d1b-buttons'">
</div>
<div id="d1b-buttons" style="padding:5px;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d1b-save-button">저장</a>
</div>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
</html>
