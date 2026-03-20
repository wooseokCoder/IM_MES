<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 비가동 관리 - 편집 다이얼로그 (조립/가공 공통)                          --%>
<%-- std49a_assy.jsp, std49a_mach.jsp에서 include                          --%>
<%-- 원본: ProActive STD49A_D0A.cs                                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- ====================================================================== -->
<!-- 상세 편집 다이얼로그                                                    -->
<!-- AS-IS 필드: SCODE(비가동코드), IDLE_START_TIME, IDLE_END_TIME, SCOMMENT -->
<!-- ====================================================================== -->
<div id="edit-dialog" class="easyui-dialog" style="width:400px;height:auto;padding:10px 20px;visibility:hidden;"
    data-options="closed:true, modal:true, buttons:'#edit-dialog-buttons'">
    <form id="edit-form" method="post">
        <input type="hidden" id="f_idleNo" name="idleNo"/>
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table" style="width:100%; display:table; table-layout:fixed">
                <tr>
                    <th class="h" style="width:60px"><span data-item="FRM_001">비가동</span></th>
                    <td class="d">
                        <input id="f_scode" name="scode" class="easyui-combobox"
                            data-options="width:220, panelHeight:200, editable:true, required:true"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_002">시작 시간</span></th>
                    <td class="d">
                        <input id="f_idleStartTime" name="idleStartTime" class="easyui-textbox"
                            data-options="width:120, required:true, prompt:'HH:MM'"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_003">종료 시간</span></th>
                    <td class="d">
                        <input id="f_idleEndTime" name="idleEndTime" class="easyui-textbox"
                            data-options="width:120, required:true, prompt:'HH:MM'"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_004">비고</span></th>
                    <td class="d">
                        <input id="f_scomment" name="scomment" class="multiline easyui-textbox"
                            data-options="width:280, multiline:true, height:120"/>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 편집 다이얼로그 버튼 -->
<!-- AS-IS: NEW모드=초기화+저장, EDIT모드=저장&닫기+삭제 -->
<div id="edit-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-new-btn" id="dialog-clear-button">초기화</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-new-btn" id="dialog-save-button">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-edit-btn" id="dialog-save-close-button">저장&닫기</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-edit-btn" id="dialog-delete-button">삭제</a>
</div>
