<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 비가동시간 관리 - 편집 다이얼로그 (D0A)                                  --%>
<%-- 원본: ProActive POP32A_D0A.cs                                           --%>
<%--                                                                        --%>
<%-- 레이아웃 (원본 구조):                                                   --%>
<%--   행1: 비가동사유 (전체 너비)                                            --%>
<%--   행2: 시작시간 (날짜 | 시간)                                           --%>
<%--   행3: 완료시간 (날짜 | 시간)                                           --%>
<%--   행4: 대상 작업자 그리드 (전체 너비)                                   --%>
<%--                                                                        --%>
<%-- @author AI Assistant                                                   --%>
<%-- @version 1.0 2026/03/03                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<style>
#f_idleTime + .numberbox .textbox-text { text-align: right !important; }
</style>

<!-- 상세 편집 다이얼로그 -->
<div id="edit-dialog" style="visibility:hidden;padding:10px 20px; width:515px;">
    <form id="edit-form" method="post">
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <colgroup>
                    <col width="20%">
                    <col width="80%">
                </colgroup>
                <!-- 행1: 비가동사유 (전체 너비) -->
                <tr>
                    <th class="h"><span data-item="FRM_005">비가동사유</span></th>
                    <td class="d">
                        <input id="f_idleCode" name="idleCode" class="easyui-combobox"
                            data-options="width:'100%', required:true"/>
                    </td>
                </tr>
                <!-- 행2: 시작시간 (날짜 | 시간) -->
                <tr>
                    <th class="h"><span data-item="FRM_001">시작시간</span></th>
                    <td class="d">
                        <div style="display:flex; align-items:center; gap:5px;">
                            <input id="f_startDate" name="startDate" class="easyui-datebox"
                                data-options="width:157, required:true"/>
                            <input id="f_startTime" name="startTime" class="easyui-timespinner"
                                data-options="width:209, required:true, showSeconds:true, format:'HH:mm:ss'"/>
                        </div>
                    </td>
                </tr>
                <!-- 행3: 완료시간 (날짜 | 시간) -->
                <tr>
                    <th class="h"><span data-item="FRM_003">완료시간</span></th>
                    <td class="d">
                        <div style="display:flex; align-items:center; gap:5px;">
                            <input id="f_endDate" name="endDate" class="easyui-datebox"
                                data-options="width:157, required:true"/>
                            <input id="f_endTime" name="endTime" class="easyui-timespinner"
                                data-options="width:209, required:true, showSeconds:true, format:'HH:mm:ss'"/>
                        </div>
                    </td>
                </tr>
            </table>
        </fieldset>
        
        <!-- 대상 작업자 그리드 (원본: acGroupControl1) -->
        <fieldset class="div-line-new-sub" style="margin-top:10px;">
            <legend><span data-item="FRM_007">대상 작업자</span></legend>
            <div style="padding:5px; display:flex; justify-content:flex-end;">
                <a href="javascript:void(0)" id="emp-search-button" class="easyui-linkbutton cgray" 
                    data-options="iconCls:'icon-search', plain:true" style="width:140px;">선택</a>
            </div>
            <table id="emp-grid" class="easyui-datagrid" style="width:100%;height:238px;">
                <thead>
                    <tr>
                        <th data-options="field:'sel', width:40, halign:'center', align:'center', formatter:formatEmpSel">선택</th>
                        <th data-options="field:'empName', width:120, halign:'center', align:'left'">작업자명</th>
                        <th data-options="field:'empCode', width:100, halign:'center', align:'center'">사원번호</th>
                        <th data-options="field:'mcCode', width:100, hidden:true">작업장코드</th>
                        <th data-options="field:'mcName', width:150, halign:'center', align:'left'">작업장</th>
                    </tr>
                </thead>
            </table>
        </fieldset>
    </form>
</div>

<!-- 다이얼로그 버튼 -->
<div id="edit-dialog-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-save-button">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-clear-button" style="display:none;">초기화</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-close-button" style="display:none;">닫기</a>
</div>

<!-- 작업자 그리드 우클릭 컨텍스트 메뉴 -->
<div id="emp-grid-context-menu" class="easyui-menu" data-options="hideOnUnhover:false" style="width:150px;">
    <div id="ctx-emp-delete">삭제</div>
</div>

