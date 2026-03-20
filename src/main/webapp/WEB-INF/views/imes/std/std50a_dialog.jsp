<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 작업자 그룹 관리 - 편집 다이얼로그                                     --%>
<%-- std50a.jsp에서 include                                                --%>
<%-- 원본: ProActive STD50A_D0A.cs                                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 4개 그리드: dlg-mc-sel(활동가능작업장), dlg-mc-all(작업장리스트),       --%>
<%--             dlg-emp-sel(소속작업자), dlg-emp-all(작업자리스트)          --%>
<%-- 더블클릭으로 좌우 전환(Transfer) 동작                                  --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- ====================================================================== -->
<!-- 상세 편집 다이얼로그                                                    -->
<!-- ====================================================================== -->
<div id="edit-dialog" class="easyui-dialog" style="width:820px;height:750px;padding:10px 15px;visibility:hidden;"
    data-options="closed:true, modal:true, buttons:'#edit-dialog-buttons'">
    <form id="edit-form" method="post">
        <input type="hidden" id="f_groupNo" name="groupNo"/>

        <!-- 기본 정보: AS-IS 레이아웃 (그룹명|입력|작업장수|값|작업자수|값) -->
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table" style="width:100%; display:table; table-layout:fixed">
                <colgroup>
                    <col width="13%">
                    <col width="*">
                    <col width="10%">
                    <col width="12%">
                    <col width="10%">
                    <col width="12%">
                </colgroup>
                <tr>
                    <th class="h"><span data-item="FRM_001">작업자 그룹명</span></th>
                    <td class="d">
                        <input id="f_groupName" name="groupName" class="easyui-textbox"
                            data-options="width:'100%', required:true"/>
                    </td>
                    <th class="h"><span data-item="FRM_002">작업장수</span></th>
                    <td class="d">
                        <input id="f_mcCount" name="mcCount" class="easyui-textbox"
                            data-options="width:'100%', readonly:true" value="0"/>
                    </td>
                    <th class="h"><span data-item="FRM_004">작업자수</span></th>
                    <td class="d">
                        <input id="f_empCount" name="empCount" class="easyui-textbox"
                            data-options="width:'100%', readonly:true" value="0"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_003">비고</span></th>
                    <td class="d" colspan="5">
                        <input id="f_scomment" name="scomment" class="multiline easyui-textbox"
                            data-options="width:'100%', multiline:true, height:80"/>
                    </td>
                </tr>
            </table>
        </fieldset>

        <!-- 작업장 전환 영역 -->
        <fieldset class="div-line-new-sub" style="margin-top:5px">
            <legend data-item="FRM_005" style="margin-bottom:0px">작업장</legend>
            <table style="width:100%">
                <tr>
                    <td style="width:48%">
                        <table id="dlg-mc-sel"></table>
                    </td>
                    <td style="width:4%; text-align:center; vertical-align:middle">
                        <div style="font-size:18px; color:#666">&harr;</div>
                    </td>
                    <td style="width:48%">
                        <table id="dlg-mc-all"></table>
                    </td>
                </tr>
            </table>
        </fieldset>

        <!-- 작업자 전환 영역 -->
        <fieldset class="div-line-new-sub" style="margin-top:5px">
            <legend data-item="FRM_006" style="margin-bottom:0px">작업자</legend>
            <table style="width:100%">
                <tr>
                    <td style="width:48%">
                        <table id="dlg-emp-sel"></table>
                    </td>
                    <td style="width:4%; text-align:center; vertical-align:middle">
                        <div style="font-size:18px; color:#666">&harr;</div>
                    </td>
                    <td style="width:48%">
                        <table id="dlg-emp-all"></table>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 편집 다이얼로그 버튼 -->
<!-- AS-IS: NEW모드=초기화+저장, EDIT모드=저장닫기+삭제 -->
<div id="edit-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-new-btn" id="dialog-clear-button">초기화</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-new-btn" id="dialog-save-button">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-edit-btn" id="dialog-save-close-button">저장&닫기</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-edit-btn" id="dialog-delete-button">삭제</a>
</div>
