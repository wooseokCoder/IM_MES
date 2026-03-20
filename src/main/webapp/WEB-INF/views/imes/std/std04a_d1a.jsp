<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std04a_d1a.jsp 1.2 2026/02/24                                    --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2026 WSC, INC.                                           --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- D1A 팝업 콘텐츠: 엑셀 임포트 (href로 동적 로드)                       --%>
<%-- html/head/body 태그 없음, script 태그 금지                             --%>
<%-- 초기화: 메인 JS의 initD1aPopup() onLoad 콜백에서 처리                  --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.2 2026/02/24                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* 좌측 테이블 margin 제거 + 셀 구분선 */
#d1a-col-table {
    margin: 0;
}
#d1a-col-table th.h {
    border: 1px solid #ddd;
    white-space: nowrap;
}
#d1a-col-table td.d {
    border: 1px solid #ddd;
}
/* AS-IS VerticalGrid 스타일: input 테두리/배경 없이 셀처럼 보임 */
#d1a-col-table td.d input {
    border: none;
    background: transparent;
    width: 100%;
    text-align: center;
    text-transform: uppercase;
    outline: none;
    padding: 2px 0;
}
#d1a-col-table td.d input:focus {
    background: #fff;
    border-bottom: 1px solid #999;
}
/* 시작행은 uppercase 불필요 */
#d1a_startRow {
    text-transform: none !important;
}
/* 우측 미리보기 테이블 스타일 */
#d1a-preview-table th {
    background: #f5f5f5;
    font-weight: bold;
    font-size: 13px;
    color: #696969;
    border: 1px solid #ddd;
    padding: 4px 6px;
    text-align: center;
    position: sticky;
    top: 0;
    z-index: 1;
}
#d1a-preview-table td {
    border: 1px solid #ddd;
    padding: 3px 6px;
    font-size: 13px;
}
#d1a-preview-table tbody tr:nth-child(odd) { background: #fff; }
#d1a-preview-table tbody tr:nth-child(even) { background: #f5f5f5; }
#d1a-preview-table tbody tr:hover { background: #e8f0fe; }
#d1a-preview-table input[type="checkbox"] {
    width: 16px;
    height: 16px;
    accent-color: #0078d4;
    cursor: pointer;
}
/* 우측 미리보기 영역 스크롤바 항상 표시 */
#d1a-grid-wrap {
    overflow: scroll !important;
}
#d1a-grid-wrap::-webkit-scrollbar {
    width: 10px;
    height: 10px;
}
#d1a-grid-wrap::-webkit-scrollbar-track {
    background: transparent;
}
#d1a-grid-wrap::-webkit-scrollbar-thumb {
    background: rgba(0, 0, 0, 0.2);
    border-radius: 4px;
}
#d1a-grid-wrap::-webkit-scrollbar-thumb:hover {
    background: rgba(0, 0, 0, 0.35);
}
</style>

<div style="position:relative; height:100%">

    <!-- 좌측: Excel 열 설정 (AS-IS: acVerticalGrid1) -->
    <div style="position:absolute; left:0; top:0; bottom:0; width:220px; overflow-y:auto; border-right:1px solid #ddd">
        <div style="font-weight:bold; padding:3px 5px; background:#f0f0f0; border-bottom:1px solid #ddd">
            Excel 열 설정
        </div>
        <table id="d1a-col-table" class="popup-search-table" style="width:100%">
            <tr>
                <th class="h"><span>시작행</span></th>
                <td class="d"><input id="d1a_startRow" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>설비코드</span></th>
                <td class="d"><input id="d1a_mcCode" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>설비명</span></th>
                <td class="d"><input id="d1a_mcName" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>설비그룹</span></th>
                <td class="d"><input id="d1a_mcGroup" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>실모델명</span></th>
                <td class="d"><input id="d1a_mcModel" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>무인가공</span></th>
                <td class="d"><input id="d1a_mcAutomated" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>외부설비</span></th>
                <td class="d"><input id="d1a_mcOs" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>부하 관리대상</span></th>
                <td class="d"><input id="d1a_mcMgtFlag" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>가동현황표시</span></th>
                <td class="d"><input id="d1a_isOperateState" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>다중작업지시 동시진행</span></th>
                <td class="d"><input id="d1a_isMultiStart" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>다중작업지시 동시진행시 실적분할</span></th>
                <td class="d"><input id="d1a_multiStartDiv" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>유효시작일</span></th>
                <td class="d"><input id="d1a_mcOpenDate" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>유효종료일</span></th>
                <td class="d"><input id="d1a_mcCloseDate" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>담당자</span></th>
                <td class="d"><input id="d1a_mainEmp" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>임률</span></th>
                <td class="d"><input id="d1a_cprocCode" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>표시순서</span></th>
                <td class="d"><input id="d1a_mcSeq" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>신호취득여부</span></th>
                <td class="d"><input id="d1a_isSignal" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>신호취득용IP</span></th>
                <td class="d"><input id="d1a_plcIp" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>설비IP</span></th>
                <td class="d"><input id="d1a_mcIp" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>FTP 포트</span></th>
                <td class="d"><input id="d1a_ftpPort" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>FTP 디렉토리</span></th>
                <td class="d"><input id="d1a_ftpDir" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>FTP 계정</span></th>
                <td class="d"><input id="d1a_ftpUser" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>FTP 계정암호</span></th>
                <td class="d"><input id="d1a_ftpUserPw" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>비고</span></th>
                <td class="d"><input id="d1a_scomment" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>작업시간(월)</span></th>
                <td class="d"><input id="d1a_monTime" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>작업시간(화)</span></th>
                <td class="d"><input id="d1a_tueTime" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>작업시간(수)</span></th>
                <td class="d"><input id="d1a_wedTime" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>작업시간(목)</span></th>
                <td class="d"><input id="d1a_thrTime" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>작업시간(금)</span></th>
                <td class="d"><input id="d1a_friTime" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>작업시간(토)</span></th>
                <td class="d"><input id="d1a_satTime" type="text"/></td>
            </tr>
            <tr>
                <th class="h"><span>작업시간(일)</span></th>
                <td class="d"><input id="d1a_sunTime" type="text"/></td>
            </tr>
        </table>
    </div>

    <!-- 우측: 미리보기 (plain HTML table — EasyUI datagrid CSS/JS 간섭 완전 우회) -->
    <div id="d1a-grid-wrap" style="position:absolute; left:221px; top:0; bottom:0; right:0; overflow:auto">
        <input type="file" id="d1a-file-input" accept=".xls,.xlsx" style="display:none"/>
        <table id="d1a-preview-table" cellpadding="0" cellspacing="0"
               style="border-collapse:collapse; white-space:nowrap; width:auto;">
            <thead id="d1a-thead"></thead>
            <tbody id="d1a-tbody"></tbody>
        </table>
    </div>

</div>
