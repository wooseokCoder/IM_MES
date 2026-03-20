<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)qct06a_d0a.jsp 1.0 2026/03/06                                    --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2026 WSC, INC.                                           --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- D0A 팝업 콘텐츠: 검사그룹 선택 (href로 동적 로드)                    --%>
<%-- html/head/body 태그 없음, script 태그 금지                             --%>
<%-- 초기화: 메인 JS의 initD0aPopup() onLoad 콜백에서 처리                  --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.3 2026/03/09                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="easyui-layout" style="width:100%; height:100%">

    <!-- 상단: 선택 버튼 + 대표코드/내역 정보 -->
    <div data-options="region:'north', border:false" style="height:65px; overflow:hidden;">
        <!-- 1행: 선택 버튼 (AS-IS bar2 toolbar) -->
        <div style="padding:1px 8px; border-bottom:1px solid #ddd; background-color:#F5F5F5; height:28px; line-height:28px; vertical-align:top;">
            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d0a-select-button"
               data-options="height:22" style="vertical-align:top;">선택</a>
        </div>
        <!-- 2행: 대표코드 + 내역 (AS-IS acSplitControl2 Panel1) -->
        <div style="padding:0 8px; border-bottom:1px solid #ddd; height:35px; line-height:35px;">
            <span style="font-weight:bold; margin-right:5px">대표코드</span>
            <input id="d0a_partCode" class="easyui-textbox" data-options="width:130, height:22, readonly:true" style="vertical-align:middle" />
            <span style="font-weight:bold; margin:0 5px 0 15px">내역</span>
            <input id="d0a_partName" class="easyui-textbox" data-options="width:400, height:22, readonly:true" style="vertical-align:middle" />
        </div>
    </div>

    <!-- 좌우 분할: 선택 항목 / 검사 항목 List -->
    <div data-options="region:'center', border:false">
        <div class="easyui-layout" data-options="fit:true">
            <!-- 좌측: 선택 항목 (AS-IS 334/1251 ≈ 27%) -->
            <div data-options="region:'west', split:true, border:true, title:'선택 항목'" style="width:27%">
                <div class="easyui-layout" data-options="fit:true">
                    <!-- 좌측 상단: 검색어 + 조회 -->
                    <div data-options="region:'north', border:false" style="height:35px;">
                        <div style="padding:6px 8px;">
                            <span style="font-weight:bold; margin-right:3px">검색어</span>
                            <input id="d0a_searchLike" class="easyui-textbox" data-options="width:150, height:22" style="vertical-align:middle" />
                            <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d0a-search-button"
                               data-options="height:22" style="vertical-align:middle">조회</a>
                        </div>
                    </div>
                    <!-- 좌측 그리드: 검사그룹 목록 (체크박스) -->
                    <div data-options="region:'center', border:false">
                        <table id="d0a-group-grid"></table>
                    </div>
                </div>
            </div>
            <!-- 우측: 검사 항목 List (AS-IS acGroupControl2) -->
            <div data-options="region:'center', border:true, title:'검사 항목 List'">
                <div class="easyui-layout" data-options="fit:true">
                    <!-- 우측 상단: 그룹명 표시 (AS-IS acTextEdit2) -->
                    <div data-options="region:'north', border:false" style="height:35px;">
                        <div style="padding:6px 8px;">
                            <span style="font-weight:bold; margin-right:3px">그룹명</span>
                            <input id="d0a_grpName" class="easyui-textbox" data-options="width:200, height:22, readonly:true" />
                        </div>
                    </div>
                    <!-- 우측 그리드: 검사항목 상세 -->
                    <div data-options="region:'center', border:false">
                        <table id="d0a-detail-grid"></table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
