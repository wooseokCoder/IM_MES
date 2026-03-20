<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std04a_dialog.jsp 1.0 2026/03/13                                 --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2026 WSC, INC.                                           --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 삭제사유 입력 다이얼로그 (include 방식, script 태그 금지)              --%>
<%-- 초기화: 메인 JS consts.init()에서 처리                                 --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/03/13                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 삭제사유 입력 다이얼로그 -->
<div id="delete-dialog" class="easyui-dialog" style="width:400px;height:auto"
    data-options="closed:true, modal:true, title:'삭제사유 입력', buttons:'#delete-dialog-buttons'">
    <div style="padding:15px">
        <table class="popup-search-table">
            <tr>
                <th class="h" style="width:70px"><span>삭제사유</span></th>
                <td class="d">
                    <input id="del_reason" class="easyui-textbox" data-options="width:260, multiline:true, height:80"/>
                </td>
            </tr>
        </table>
    </div>
</div>

<!-- 삭제사유 다이얼로그 버튼 -->
<div id="delete-dialog-buttons" style="padding:5px">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="del-dialog-ok-button">확인</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="del-dialog-cancel-button">취소</a>
</div>
