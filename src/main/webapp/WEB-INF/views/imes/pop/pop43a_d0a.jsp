<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 수리수선 편집 다이얼로그 (D0A)                                          --%>
<%-- 원본: ProActive POP43A_D0A.cs                                           --%>
<%--                                                                        --%>
<%-- 레이아웃 (AS-IS 2열 배치):                                              --%>
<%--   행1: 일자 | 수리업체                                                  --%>
<%--   행2: 설비 | 설비구분                                                  --%>
<%--   행3: 수리 | 금액                                                      --%>
<%--   행4: 수리내역 (전체 너비, 멀티라인)                                   --%>
<%--                                                                        --%>
<%-- @author MES                                                            --%>
<%-- @version 1.1 2026/03/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<style>
#f_repairAmount + .numberbox .textbox-text { text-align: right !important; }
</style>

<!-- 상세 편집 다이얼로그 -->
<div id="edit-dialog" style="visibility:hidden;padding:10px 15px; width:530px;">
    <form id="edit-form" method="post">
        <input type="hidden" id="f_mcrId" name="mcrId"/>
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table" style="width:100%;">
                <colgroup>
                    <col width="60px">
                    <col width="180px">
                    <col width="60px">
                    <col width="180px">
                </colgroup>
                <!-- 행1: 일자 | 수리업체 -->
                <tr>
                    <th class="h"><span data-item="FRM_001">일자</span></th>
                    <td class="d">
                        <input id="f_repairDate" name="repairDate" class="easyui-datebox"
                            data-options="width: '168px', required:true, editable:true"/>
                    </td>
                    <th class="h"><span data-item="FRM_002">수리업체</span></th>
                    <td class="d">
                        <input id="f_repairVendor" name="repairVendor" class="easyui-textbox"
                            data-options="width: '168px', validType:'length[0,200]'"/>
                    </td>
                </tr>
                <!-- 행2: 설비 | 설비구분 -->
                <tr>
                    <th class="h"><span data-item="FRM_003">설비</span></th>
                    <td class="d">
                        <input id="f_repairMc" name="repairMc" class="easyui-textbox"
                            data-options="width: '168px', validType:'length[0,200]'"/>
                    </td>
                    <th class="h"><span data-item="FRM_004">설비구분</span></th>
                    <td class="d">
                        <input id="f_repairMcType" name="repairMcType" class="easyui-textbox"
                            data-options="width: '168px', validType:'length[0,200]'"/>
                    </td>
                </tr>
                <!-- 행3: 수리 | 금액 -->
                <tr>
                    <th class="h"><span data-item="FRM_005">수리</span></th>
                    <td class="d">
                        <input id="f_repairName" name="repairName" class="easyui-textbox"
                            data-options="width: '168px', validType:'length[0,200]'"/>
                    </td>
                    <th class="h"><span data-item="FRM_006">금액</span></th>
                    <td class="d">
                        <input id="f_repairAmount" name="repairAmount" class="easyui-numberbox"
                            data-options="width: '168px', precision:0, groupSeparator:','"/>
                    </td>
                </tr>
                <!-- 행4: 수리내역 (전체 너비) -->
                <tr>
                    <th class="h"><span data-item="FRM_007">수리내역</span></th>
                    <td class="d" colspan="3">
                        <input id="f_repairContents" name="repairContents" class="easyui-textbox multiline"
                            data-options="width:'100%', multiline:true, height:120, validType:'length[0,2000]'"/>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 다이얼로그 버튼 -->
<div id="edit-dialog-buttons" style="padding:5px;visibility:hidden;margin-top: 10px;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-save-button">저장</a>
</div>
