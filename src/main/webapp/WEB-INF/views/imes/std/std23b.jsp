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
#calendar-nav { display:flex; align-items:center; justify-content:center; margin-bottom:6px; padding:4px 0; }
#calendar-nav .cal-btn { cursor:pointer; font-size:20px; font-weight:bold; padding:2px 10px; color:#333; display:inline-block; line-height:1; user-select:none; border:1px solid #ccc; background:#f9f9f9; border-radius:3px; margin:0 2px; }
#calendar-nav .cal-btn:hover { color:#4285f4; background:#e8f0fe; border-color:#4285f4; }
#calendar-nav .cal-title-wrap { display:flex; align-items:center; margin:0 8px; }
#calendar-nav #cal-title { font-size:16px; font-weight:bold; min-width:90px; display:inline-block; text-align:center; margin:0 4px; }
#calendar-grid { display:flex; flex-wrap:wrap; gap:18px 16px; }
.mini-cal-wrap { flex:1 1 165px; min-width:165px; max-width:200px; }
#cal-today-bar { text-align:center; padding:6px 0; }
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

<div id="loadingProgressBar">
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

    <!-- 상단: 검색 영역 (달력+그리드 위에 가로로 길게) -->
    <div data-options="region:'north', border:false" style="height:auto;">
        <div id="search-toolbar" class="wui-toolbar">
            <form id="search-form">
                <fieldset class="Remake-div-line-new">
                    <table cellpadding="0" class="search-table tableSearch-c wd-100">
                        <colgroup>
                            <col width="*">
                        </colgroup>
                        <tr class="topnav_sty">
                            <td colspan="1">
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

    <!-- 좌측: 연간 달력 -->
    <div data-options="region:'west', split:true, title:'달력'" style="width:50%;">
        <div id="calendar-panel">
            <div id="calendar-nav">
                <span id="cal-prev-year" class="cal-btn" title="이전 년">&#171;</span>
                <span class="cal-title-wrap">
                    <span id="cal-prev-month" class="cal-btn" title="이전 월">&#8249;</span>
                    <span id="cal-title"></span>
                    <span id="cal-next-month" class="cal-btn" title="다음 월">&#8250;</span>
                </span>
                <span id="cal-next-year" class="cal-btn" title="다음 년">&#187;</span>
            </div>
            <div id="calendar-body"></div>
            <div id="cal-today-bar">
                <a href="javascript:void(0)" id="cal-today" class="easyui-linkbutton cgray">오늘</a>
            </div>
        </div>
    </div>

    <!-- 우측: 휴일 목록 그리드 -->
    <div data-options="region:'center', border:false">
        <table id="search-grid"></table>
    </div>
</div>

<!-- 달력 우클릭 컨텍스트 메뉴 -->
<div id="calendar-context-menu" class="easyui-menu" data-options="hideOnUnhover:false" style="width:120px;">
    <div id="ctx-set-holiday">휴일설정</div>
    <div id="ctx-clear-holiday">휴일해제</div>
</div>

<!-- D1B 팝업: 휴일설정 -->
<div id="d1b-popup" class="easyui-dialog" data-options="
    width:346, height:'auto', closed:true, modal:true, title:'휴일설정',
    href:'<c:url value='/imes/std/std23a_d1b.do' />',
    onLoad: initD1bPopup,
    buttons: '#d1b-buttons'" style="visibility:hidden;">
</div>
<div id="d1b-buttons" style="visibility:hidden;padding:5px;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d1b-save-button">저장</a>
</div>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
</html>
