<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 가공 진행현황 - 공정 상세 다이얼로그 (D0A)                            --%>
<%-- rep09a.jsp에서 include                                                --%>
<%-- 원본: ProActive REP09A_D0A.cs                                         --%>
<%--                                                                        --%>
<%-- @version 1.0 2026/03/16                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- D0A 팝업: 공정 상세 (AS-IS: REP09A_D0A) -->
<div id="d0a-dialog" class="easyui-dialog" style="width:900px; height:550px;"
     data-options="closed:true, modal:true, title:'공정 상세', resizable:true">
    <div class="easyui-layout" data-options="fit:true">
        <!-- 상단 정보 (원본: acLayoutControl1 — 모델/부품 ReadOnly) -->
        <div data-options="region:'north', border:false" style="height:36px; background:#f5f5f5;">
            <table cellpadding="0" cellspacing="0" style="height:100%; padding:4px 8px;">
                <tr>
                    <td style="font-weight:bold; font-size:12px; padding-right:5px; white-space:nowrap;">모델</td>
                    <td style="padding-right:15px;">
                        <input id="d0a-model" class="easyui-textbox" data-options="width:180, readonly:true"/>
                    </td>
                    <td style="font-weight:bold; font-size:12px; padding-right:5px; white-space:nowrap;">부품</td>
                    <td>
                        <input id="d0a-partname" class="easyui-textbox" data-options="width:280, readonly:true"/>
                    </td>
                </tr>
            </table>
        </div>
        <!-- 탭 영역 -->
        <div data-options="region:'center', border:false">
            <div id="d0a-tabs" class="easyui-tabs" data-options="fit:true, border:false, plain:true">
                <!-- Tab1: 공정/실적/비가동/부적합 (원본 acTabPage1) -->
                <!-- 좌측: 공정별 상태 | 우측상단: 실적/비가동 | 우측하단: 부적합 -->
                <div title="공정/실적/비가동/부적합" style="padding:0; overflow:hidden;">
                    <div class="easyui-layout" data-options="fit:true">
                        <div data-options="region:'west', split:true, border:true" style="width:28%;">
                            <table id="d0a-proc-grid" class="popup-grid"></table>
                        </div>
                        <div data-options="region:'center', border:false">
                            <div class="easyui-layout" data-options="fit:true">
                                <div data-options="region:'north', split:true, border:true" style="height:52%;">
                                    <table id="d0a-act-grid" class="popup-grid"></table>
                                </div>
                                <div data-options="region:'center', border:true">
                                    <table id="d0a-ng-grid" class="popup-grid"></table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Tab2: 자주검사 (원본 acTabPage2) -->
                <div title="자주검사" style="padding:0; overflow:hidden;">
                    <table id="d0a-ins-grid" class="popup-grid"></table>
                </div>
            </div>
        </div>
    </div>
</div>
