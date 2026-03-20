<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 비가동시간 관리 - 수정 다이얼로그 (D2A)                                  --%>
<%-- 원본: ProActive POP32A_D2A.cs                                           --%>
<%--                                                                        --%>
<%-- 레이아웃 (원본 구조):                                                   --%>
<%--   행1: 비가동사유 (읽기전용)                                             --%>
<%--   행2: 작업자 (읽기전용)                                                 --%>
<%--   행3: 작업장 (읽기전용)                                                 --%>
<%--   행4: 시작시간 (날짜 | 시간)                                           --%>
<%--   행5: 완료시간 (날짜 | 시간)                                           --%>
<%--                                                                        --%>
<%-- @author AI Assistant                                                   --%>
<%-- @version 1.0 2026/03/06                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 비가동시간 수정 다이얼로그 (다른 화면에서도 include하여 재사용 가능) -->
<div id="d2a-dialog" style="visibility:hidden;padding:10px 20px; width:450px;">
    <form id="d2a-form" method="post">
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <colgroup>
                    <col width="25%">
                    <col width="75%">
                </colgroup>
                <!-- 행1: 비가동사유 (읽기전용) -->
                <tr>
                    <th class="h"><span data-item="FRM_005">비가동사유</span></th>
                    <td class="d">
                        <input id="d2a_idleCode" name="idleCode" class="easyui-combobox"
                            data-options="width:'100%', readonly:true"/>
                        <input type="hidden" id="d2a_idleId" name="idleId"/>
                        <input type="hidden" id="d2a_empCode" name="empCode"/>
                        <input type="hidden" id="d2a_mcCode" name="mcCode"/>
                    </td>
                </tr>
                <!-- 행2: 작업자 (읽기전용) -->
                <tr>
                    <th class="h"><span data-item="FRM_006">작업자</span></th>
                    <td class="d">
                        <input id="d2a_empName" name="empName" class="easyui-textbox"
                            data-options="width:'100%', readonly:true"/>
                    </td>
                </tr>
                <!-- 행3: 작업장 (읽기전용) -->
                <tr>
                    <th class="h"><span data-item="FRM_007">작업장</span></th>
                    <td class="d">
                        <input id="d2a_mcName" name="mcName" class="easyui-textbox"
                            data-options="width:'100%', readonly:true"/>
                    </td>
                </tr>
                <!-- 행4: 시작시간 (날짜 | 시간) -->
                <tr>
                    <th class="h"><span data-item="FRM_001">시작시간</span></th>
                    <td class="d">
                        <div style="display:flex; align-items:center; gap:5px;">
                            <input id="d2a_startDate" name="startDate" class="easyui-datebox"
                                data-options="width:130, required:true"/>
                            <input id="d2a_startTime" name="startTime" class="easyui-timespinner"
                                data-options="width:150, required:true, showSeconds:true"/>
                        </div>
                    </td>
                </tr>
                <!-- 행5: 완료시간 (날짜 | 시간) -->
                <tr>
                    <th class="h"><span data-item="FRM_003">완료시간</span></th>
                    <td class="d">
                        <div style="display:flex; align-items:center; gap:5px;">
                            <input id="d2a_endDate" name="endDate" class="easyui-datebox"
                                data-options="width:130, required:true"/>
                            <input id="d2a_endTime" name="endTime" class="easyui-timespinner"
                                data-options="width:150, required:true, showSeconds:true"/>
                        </div>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 다이얼로그 버튼 -->
<div id="d2a-dialog-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d2a-save-button">저장</a>
</div>
