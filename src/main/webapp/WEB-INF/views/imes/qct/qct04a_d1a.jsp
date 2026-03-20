<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)qct04a_d1a.jsp 1.0 2026/02/27                                    --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2026 WSC, INC.                                           --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- D1A 팝업 콘텐츠: 검사그룹 관리 (href로 동적 로드)                      --%>
<%-- html/head/body 태그 없음, script 태그 금지                             --%>
<%-- 초기화: 메인 JS의 initD1aPopup() onLoad 콜백에서 처리                  --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/02/27                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 좌우 분할: 연결 그룹 / 그룹 LIST -->
<div class="easyui-layout" data-options="fit:true">
    <!-- 좌측: 연결 그룹 -->
    <div data-options="region:'west', split:true, border:true, title:'연결 그룹'" style="width:50%">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'north', border:false" style="height:80px; padding:10px 8px 0 8px">
                <table style="width:100%">
                    <tr>
                        <td style="white-space:nowrap; padding:3px 5px 3px 0"><span style="font-weight:bold">공정</span></td>
                        <td style="padding:3px 10px 3px 0"><input id="d1a_procName" class="easyui-textbox" data-options="width:80, readonly:true"/></td>
                        <td style="white-space:nowrap; padding:3px 5px 3px 0"><span style="font-weight:bold">검사항목</span></td>
                        <td style="padding:3px 0"><input id="d1a_insName" class="easyui-textbox" data-options="width:120, readonly:true"/></td>
                    </tr>
                    <tr>
                        <td style="white-space:nowrap; padding:3px 5px 3px 0"><span style="font-weight:bold">검사내용</span></td>
                        <td colspan="3" style="padding:3px 0"><input id="d1a_insDesc" class="easyui-textbox" data-options="width:'100%', readonly:true"/></td>
                    </tr>
                </table>
            </div>
            <div data-options="region:'center', border:false">
                <table id="d1a-left-grid"></table>
            </div>
        </div>
    </div>
    <!-- 우측: 그룹 LIST -->
    <div data-options="region:'center', border:true, title:'그룹 LIST'">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'north', border:false" style="height:80px; padding:10px 8px 0 8px">
                <table style="width:100%">
                    <tr>
                        <td style="white-space:nowrap; padding:3px 5px 3px 0"><span style="font-weight:bold">그룹명</span></td>
                        <td style="padding:3px 10px 3px 0"><input id="d1a_searchKeyword" class="easyui-textbox" data-options="width:150"/></td>
                        <td style="padding:3px 0"><a href="javascript:void(0)" class="easyui-linkbutton c6" id="d1a-search-button">조회</a></td>
                        <td style="width:99%"></td>
                    </tr>
                    <tr><td colspan="4" style="height:26px"></td></tr>
                </table>
            </div>
            <div data-options="region:'center', border:false">
                <table id="d1a-right-grid"></table>
            </div>
        </div>
    </div>
</div>

<!-- D1A 좌측 컨텍스트 메뉴 (삭제→우측이동) -->
<div id="d1a-left-ctx" class="easyui-menu" data-options="hideOnUnhover:false">
    <div id="d1a-ctx-remove">삭제</div>
</div>

<!-- D1A 우측 컨텍스트 메뉴 (추가→좌측이동) -->
<div id="d1a-right-ctx" class="easyui-menu" data-options="hideOnUnhover:false">
    <div id="d1a-ctx-add">추가</div>
</div>
