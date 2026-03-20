<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 작업자 선택 다이얼로그 (D1A)                                         --%>
<%-- 원본: ProActive POP32A_D1A.cs                                        --%>
<%--                                                                      --%>
<%-- 레이아웃 (원본 구조):                                                 --%>
<%--   상단: 검색 영역 (사원코드/명 입력, 조회 버튼)                       --%>
<%--   하단: 작업자 그리드 (SEL, 작업자명, 사원번호, 부서, 작업장)        --%>
<%--                                                                      --%>
<%-- @author AI Assistant                                                 --%>
<%-- @version 1.0 2026/03/03                                              --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 작업자 선택 다이얼로그 -->
<div id="emp-search-dialog" style="visibility:hidden;padding:10px 20px">
    <form id="emp-search-form" method="post">
        <!-- 검색 영역 -->
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <colgroup>
                    <col width="30%">
                    <col width="70%">
                </colgroup>
                <tr>
                    <th class="h">사원코드/명</th>
                    <td class="d">
                        <input id="f_empLike" name="empLike" class="easyui-textbox"
                            data-options="width:'100%', prompt:'사원코드 또는 이름 입력'"/>
                    </td>
                </tr>
            </table>
            <div style="padding:5px; text-align:right;">
                <a href="javascript:void(0)" id="emp-search-search-button" class="easyui-linkbutton c6" 
                    data-options="iconCls:'icon-search'">조회</a>
            </div>
        </fieldset>
        
        <!-- 작업자 그리드 -->
        <fieldset class="div-line-new-sub" style="margin-top:10px;">
            <legend>작업자 목록</legend>
            <table id="emp-search-grid" class="easyui-datagrid" style="width:100%;height:300px;">
                <thead>
                    <tr>
                        <th data-options="field:'sel', width:40, halign:'center', align:'center', formatter:formatEmpSearchSel">선택</th>
                        <th data-options="field:'empName', width:120, halign:'center', align:'left'">작업자명</th>
                        <th data-options="field:'empCode', width:100, halign:'center', align:'center'">사원번호</th>
                        <th data-options="field:'orgName', width:100, halign:'center', align:'left'">부서</th>
                        <th data-options="field:'mainMcCode', width:100, hidden:true">작업장코드</th>
                        <th data-options="field:'mainMcName', width:100, halign:'center', align:'left'">작업장</th>
                    </tr>
                </thead>
            </table>
        </fieldset>
    </form>
</div>

<!-- 다이얼로그 버튼 -->
<div id="emp-search-dialog-buttons" style="">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="emp-search-select-button">선택</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="emp-search-close-button">닫기</a>
</div>

