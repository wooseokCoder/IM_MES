<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 비가동코드 관리 - 편집/조직검색 다이얼로그 (조립/가공 공통)              --%>
<%-- std45a_assy.jsp, std45a_mach.jsp에서 include                          --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- ====================================================================== -->
<!-- 상세 편집 다이얼로그                                                    -->
<!-- ====================================================================== -->
<div id="edit-dialog" class="easyui-dialog" style="width:500px;height:auto;padding:10px 20px;visibility:hidden;"
    data-options="closed:true, modal:true, buttons:'#edit-dialog-buttons'">
    <form id="edit-form" method="post">
        <input type="hidden" id="f_scode" name="scode"/>
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <tr>
                    <th class="h"><span data-item="FRM_001">MES코드</span></th>
                    <td class="d">
                        <input id="f_idleCode" name="idleCode" class="easyui-textbox"
                            data-options="width:150, required:true"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_002">비가동명</span></th>
                    <td class="d">
                        <input id="f_idleName" name="idleName" class="easyui-textbox"
                            data-options="width:250, required:true"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_003">구분1</span></th>
                    <td class="d">
                        <input id="f_mgType1" name="mgType1" class="easyui-combobox"
                            data-options="width:150, panelHeight:'auto', editable:false"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_004">구분2</span></th>
                    <td class="d">
                        <input id="f_mgType2" name="mgType2" class="easyui-combobox"
                            data-options="width:150, panelHeight:'auto', editable:false"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_005">SAP코드</span></th>
                    <td class="d">
                        <input id="f_sapCode" name="sapCode" class="easyui-textbox"
                            data-options="width:150, required:true"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_006">정렬순서</span></th>
                    <td class="d">
                        <input id="f_idleSeq" name="idleSeq" class="easyui-numberbox"
                            data-options="width:80, min:0, max:2147483647, precision:0"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_007">관리부서</span></th>
                    <td class="d">
                        <input id="f_mgOrg" name="mgOrg" type="hidden"/>
                        <input id="f_mgOrgName" class="easyui-textbox" data-options="width:170, readonly:true"/>
                        <!-- <a href="javascript:void(0)" class="easyui-linkbutton" id="org-search-btn"
                            iconCls="icon-search" plain="true"></a> -->
                            
                        <a href="javascript:void(0)" style="" id="org-search-btn" class="easyui-linkbutton c12 searchListA">
							<img id="userIdlist" style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/icon_new/Icon_search.png" />
						</a>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_008">사용여부</span></th>
                    <td class="d">
                        <input id="f_useFlag" name="useFlag" class="easyui-combobox"
                            data-options="width:100, panelHeight:'auto', editable:false"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_009">부적합 등록여부</span></th>
                    <td class="d">
                        <input type="checkbox" id="f_isNg" name="isNg" value="Y"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_010">알람구분</span></th>
                    <td class="d">
                        <input id="f_alarmType" name="alarmType" class="easyui-combobox"
                            data-options="width:150, panelHeight:'auto', editable:false"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_011">SAP전송 여부</span></th>
                    <td class="d">
                        <input type="checkbox" id="f_isSap" name="isSap" value="Y"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_012">지표 포함여부</span></th>
                    <td class="d">
                        <input type="checkbox" id="f_isRpt" name="isRpt" value="Y"/>
                    </td>
                </tr>
                <!-- 가공 전용: JS에서 PAGE_SHOW_MCT_SCOMMENT=false이면 숨김 처리 -->
                <tr id="mct-scomment-row">
                    <th class="h"><span data-item="FRM_014">상세원인등록</span></th>
                    <td class="d">
                        <input type="checkbox" id="f_isMctScomment" name="isMctScomment" value="Y"/>
                    </td>
                </tr>
                <tr>
                    <th class="h"><span data-item="FRM_013">정의</span></th>
                    <td class="d">
                        <input id="f_scomment" name="scomment" class="multiline easyui-textbox"
                            data-options="width:300, multiline:true, height:60"/>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 편집 다이얼로그 버튼 -->
<div id="edit-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-new-btn" id="dialog-clear-button">초기화</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-new-btn" id="dialog-save-button">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-edit-btn" id="dialog-save-close-button">저장&닫기</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6 dialog-edit-btn" id="dialog-delete-button">삭제</a>
</div>

<!-- 부서 검색 공통 팝업 -->
<%@ include file="/WEB-INF/views/imes/com/acORGForm.jsp" %>
