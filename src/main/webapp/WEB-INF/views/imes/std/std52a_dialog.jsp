<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 설비점검항목 관리 - 편집 다이얼로그 (D0A)                               --%>
<%-- std52a.jsp에서 include                                                --%>
<%-- 2컬럼 4행 레이아웃 (560x auto)                                        --%>
<%--                                                                        --%>
<%-- 레이아웃:                                                              --%>
<%--   행1: 점검항목ID(readonly)  | (빈공간)                                --%>
<%--   행2: 구분                  | 번호                                    --%>
<%--   행3: 점검항목(textarea)    | 점검내용(textarea)                      --%>
<%--   행4: 점검방법              | 순번                                    --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.2 2026/02/06                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<style>
#f_smdcSeq + .numberbox .textbox-text { text-align: right !important; }
</style>

<!-- 상세 편집 다이얼로그 -->
<div id="edit-dialog" class="easyui-dialog" style="visibility:hidden;width:560px;height:auto;padding:10px 20px"
    data-options="closed:true, modal:true, buttons:'#edit-dialog-buttons'">
    <form id="edit-form" method="post">
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <colgroup>
                    <col width="15%">
                    <col width="35%">
                    <col width="15%">
                    <col width="35%">
                </colgroup>
                <!-- 행1: 점검항목ID | (빈공간) -->
                <tr>
                    <th class="h"><span data-item="FRM_001">점검항목ID</span></th>
                    <td class="d">
                        <input id="f_smdcNo" name="smdcNo" class="easyui-textbox"
                            data-options="width:'100%', readonly:true"/>
                    </td>
                    <th class="h"></th>
                    <td class="d"></td>
                </tr>
                <!-- 행2: 구분 | 번호 -->
                <tr>
                    <th class="h"><span data-item="FRM_002">구분</span></th>
                    <td class="d">
                        <input id="f_smdcType" name="smdcType" class="easyui-textbox"
                            data-options="width:'100%', required:true, validType:'length[0,50]'"/>
                    </td>
                    <th class="h"><span data-item="FRM_003">번호</span></th>
                    <td class="d">
                        <input id="f_smdcNum" name="smdcNum" class="easyui-textbox"
                            data-options="width:'100%', validType:'length[0,10]'"/>
                    </td>
                </tr>
                <!-- 행3: 점검항목(MemoEdit) | 점검내용(MemoEdit) -->
                <tr>
                    <th class="h" style="vertical-align:top; padding-top:8px;"><span data-item="FRM_004">점검항목</span></th>
                    <td class="d" style="height:120px">
                        <span class="textbox" style="height:120px !important; width:100%;">
                            <textarea class="textbox-text" name="smdcContents" id="f_smdcContents" maxlength="50"
                                style="width:100%;height:100%;overflow-y:scroll;resize:none;border:none;"></textarea>
                        </span>
                    </td>
                    <th class="h" style="vertical-align:top; padding-top:8px;"><span data-item="FRM_005">점검내용</span></th>
                    <td class="d" style="height:120px">
                        <span class="textbox" style="height:120px !important; width:100%;">
                            <textarea class="textbox-text" name="smdcCheck" id="f_smdcCheck" maxlength="50"
                                style="width:100%;height:100%;overflow-y:scroll;resize:none;border:none;"></textarea>
                        </span>
                    </td>
                </tr>
                <!-- 행4: 점검방법 | 순번 -->
                <tr>
                    <th class="h"><span data-item="FRM_006">점검방법</span></th>
                    <td class="d">
                        <input id="f_smdcMeans" name="smdcMeans" class="easyui-textbox"
                            data-options="width:'100%', validType:'length[0,50]'"/>
                    </td>
                    <th class="h"><span data-item="FRM_007">순번</span></th>
                    <td class="d">
                        <input id="f_smdcSeq" name="smdcSeq" class="easyui-numberbox"
                            data-options="width:'100%', min:0, max:999999999, precision:0"/>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 다이얼로그 버튼 (NEW→저장+초기화, EDIT→저장&닫기+삭제) -->
<div id="edit-dialog-buttons" style="visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-save-button">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-clear-button">초기화</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-saveclose-button">저장&닫기</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-delete-button">삭제</a>
</div>
