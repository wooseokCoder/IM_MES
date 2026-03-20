<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)qct05a_d0a.jsp 1.2 2026/03/06                                    --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2026 WSC, INC.                                           --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- D0A 팝업 콘텐츠: 검사 항목 선택 (href로 동적 로드)                    --%>
<%-- html/head/body 태그 없음, script 태그 금지                             --%>
<%-- 초기화: 메인 JS의 initD0aPopup() onLoad 콜백에서 처리                  --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.2 2026/03/06                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 좌우 분할: 선택 항목 / 검사 항목 List -->
<div class="easyui-layout" data-options="fit:true">
    <!-- 좌측: 선택 항목 -->
    <div data-options="region:'west', split:true, border:true, title:'선택 항목'" style="width:50%">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'north', border:false" style="height:80px; padding:10px 8px 0 8px">
                <table style="width:100%">
                    <tr>
                        <td style="white-space:nowrap; padding:3px 2px 3px 0"><span style="font-weight:bold">그룹 명</span></td>
                        <td style="padding:3px 0"><input id="d0a_grpName" class="easyui-textbox" data-options="width:250, readonly:true" /></td>
                        <td style="width:99%"></td>
                    </tr>
                    <tr><td colspan="3" style="height:26px"></td></tr>
                </table>
            </div>
            <div data-options="region:'center', border:false">
                <table id="d0a-left-grid"></table>
            </div>
        </div>
    </div>
    <!-- 우측: 검사 항목 List -->
    <div data-options="region:'center', border:true, title:'검사 항목 List'">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'north', border:false" style="height:80px; padding:10px 8px 0 8px">
                <table style="width:100%">
                    <tr>
                        <td style="white-space:nowrap; padding:3px 2px 3px 0"><span style="font-weight:bold">검사공정</span></td>
                        <td style="padding:3px 0">
                            <input id="d0a_procCode" />
                        </td>
                        <td style="padding:3px 5px 3px 0">
                            <a href="javascript:void(0)" id="d0a-proc-find-btn"
                                style="display:inline-block;width:22px;height:22px;cursor:pointer;vertical-align:middle;
                                       border:1px solid #b4b4b4;background:#f5f5f5;text-align:center;line-height:22px;
                                       border-radius:2px;">
                                <img src="<%=request.getContextPath()%>/resources/jquery/easyui-1.4/themes/icons/search.png"
                                    style="width:16px;height:16px;vertical-align:middle" />
                            </a>
                        </td>
                        <td style="white-space:nowrap; padding:3px 2px 3px 0"><span style="font-weight:bold">검색어</span></td>
                        <td style="padding:3px 10px 3px 0"><input id="d0a_searchLike" class="easyui-textbox" data-options="width:150" /></td>
                        <td style="padding:3px 0"><a href="javascript:void(0)" class="easyui-linkbutton c6" id="d0a-search-button">조회</a></td>
                        <td style="width:99%"></td>
                    </tr>
                    <tr><td colspan="7" style="height:26px"></td></tr>
                </table>
            </div>
            <div data-options="region:'center', border:false">
                <table id="d0a-right-grid"></table>
            </div>
        </div>
    </div>
</div>

<!-- D0A 좌측 컨텍스트 메뉴 (삭제→우측이동) -->
<div id="d0a-left-ctx" class="easyui-menu" data-options="hideOnUnhover:false">
    <div id="d0a-ctx-remove">삭제</div>
</div>

<!-- D0A 우측 컨텍스트 메뉴 (추가→좌측이동) -->
<div id="d0a-right-ctx" class="easyui-menu" data-options="hideOnUnhover:false">
    <div id="d0a-ctx-add">추가</div>
</div>
