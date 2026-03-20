<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 부서/사원 관리 - 부서 편집 다이얼로그                                   --%>
<%-- std13a.jsp에서 include                                                --%>
<%-- 원본: ProActive STD13A_D0A.cs                                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- ====================================================================== -->
<!-- 부서 편집 다이얼로그                                                    -->
<!-- ====================================================================== -->
<div id="edit-dialog" class="easyui-dialog" style="width:480px;height:380px;padding:10px 15px;visibility:hidden;"
    data-options="closed:true, modal:true, buttons:'#edit-dialog-buttons'">
    <form id="edit-form" method="post">

        <fieldset class="div-line-new-sub">
            <table class="popup-search-table" style="width:100%; display:table; table-layout:fixed">
                <colgroup>
                    <col width="25%">
                    <col width="75%">
                </colgroup>
                <tr>
                    <th class="h"><span data-item="FRM_001">부서코드</span></th>
                    <td class="d">
                        <input id="f_orgCode" name="orgCode" class="easyui-textbox"
                            data-options="width:'100%', required:true"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_002">부서명</span></th>
                    <td class="d">
                        <input id="f_orgName" name="orgName" class="easyui-textbox"
                            data-options="width:'100%', required:true"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_003">코스트센터</span></th>
                    <td class="d">
                        <input id="f_costCenter" name="costCenter" class="easyui-combobox"
                            data-options="width:'100%', panelHeight:'auto', editable:false"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_004">상위부서</span></th>
                    <td class="d">
                        <input id="f_orgParent" name="orgParent" type="hidden"/>
                        <input id="f_orgParentName" class="easyui-textbox" data-options="width:200, readonly:true"/>
                        <a href="javascript:void(0)" id="org-parent-search-btn" class="easyui-linkbutton c12 searchListA">
                            <img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/Icon_search.png" />
                        </a>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_005">표시순서</span></th>
                    <td class="d">
                        <input id="f_orgSeq" name="orgSeq" class="easyui-numberbox"
                            data-options="width:'100%', min:0, max:2147483647, precision:0" value="0"/>
                    </td>
                </tr>
                <!-- ORG_LEADER: AS-IS Visibility=Never (숨김) -->
                <tr style="display:none">
                    <th class="h"><span>부서관리자</span></th>
                    <td class="d">
                        <input id="f_orgLeader" name="orgLeader" class="easyui-textbox"
                            data-options="width:'100%'"/>
                    </td>
                </tr>
            </table>
        </fieldset>

    </form>
</div>

<!-- 편집 다이얼로그 버튼 -->
<!-- AS-IS: NEW모드=초기화+저장, EDIT모드=저장닫기+삭제 -->
<div id="edit-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-new-btn" id="dialog-clear-button" data-item="BTN_004">초기화</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-new-btn" id="dialog-save-button" data-item="BTN_005">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-edit-btn" id="dialog-save-close-button" data-item="BTN_006">저장닫기</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-edit-btn" id="dialog-delete-button" data-item="BTN_007">삭제</a>
</div>

<!-- 부서 검색 공통 팝업 -->
<%@ include file="/WEB-INF/views/imes/com/acORGForm.jsp" %>
