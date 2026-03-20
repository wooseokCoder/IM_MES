<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 가공 진행현황 - 완료공정 조회 다이얼로그 (D1A)                        --%>
<%-- rep09a.jsp에서 include                                                --%>
<%-- 원본: ProActive REP09A_D1A.cs                                         --%>
<%--                                                                        --%>
<%-- @version 2.1 2026/03/18                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- D1A 팝업: 완료공정 (AS-IS: REP09A_D1A) -->
<div id="d1a-dialog" class="easyui-dialog" style="width:950px; height:600px;"
     data-options="closed:true, modal:true, title:'완료공정 조회', resizable:true">
    <div class="easyui-layout" data-options="fit:true">
        <!-- 상단 정보 (모델/부품/생산오더 ReadOnly) -->
        <div data-options="region:'north', border:false" style="height:36px; background:#f5f5f5;">
            <table cellpadding="0" cellspacing="0" style="height:100%; padding:4px 8px;">
                <tr>
                    <td style="font-weight:bold; font-size:12px; padding-right:5px; white-space:nowrap;">모델</td>
                    <td style="padding-right:15px;">
                        <input id="d1a-model" class="easyui-textbox" data-options="width:150, readonly:true"/>
                    </td>
                    <td style="font-weight:bold; font-size:12px; padding-right:5px; white-space:nowrap;">부품</td>
                    <td style="padding-right:15px;">
                        <input id="d1a-partname" class="easyui-textbox" data-options="width:280, readonly:true"/>
                    </td>
                    <td style="font-weight:bold; font-size:12px; padding-right:5px; white-space:nowrap;">생산오더번호</td>
                    <td>
                        <input id="d1a-sapwono" class="easyui-textbox" data-options="width:130, readonly:true"/>
                    </td>
                </tr>
            </table>
        </div>
        <!-- 탭 영역 -->
        <div data-options="region:'center', border:false">
            <div id="d1a-tabs" class="easyui-tabs" data-options="fit:true, border:false, plain:true">
                <!-- Tab1: 공정/실적/비가동/부적합 (D0A와 동일 구조 — master-grid 포함) -->
                <div title="공정/실적/비가동/부적합" style="padding:0; overflow:hidden;">
                    <div class="easyui-layout" data-options="fit:true">
                        <div data-options="region:'west', split:true, border:true" style="width:28%;">
                            <table id="d1a-master-grid" class="popup-grid"></table>
                        </div>
                        <div data-options="region:'center', border:false">
                            <div class="easyui-layout" data-options="fit:true">
                                <div data-options="region:'north', split:true, border:true" style="height:52%;">
                                    <table id="d1a-act-grid" class="popup-grid"></table>
                                </div>
                                <div data-options="region:'center', border:true">
                                    <table id="d1a-ng-grid" class="popup-grid"></table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Tab2: 자주검사 -->
                <div title="자주검사" style="padding:0; overflow:hidden;">
                    <table id="d1a-ins-grid" class="popup-grid"></table>
                </div>
            </div>
        </div>
    </div>
</div>
