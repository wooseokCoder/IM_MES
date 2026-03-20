<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 공수오류현황 - 오류율 팝업 기준 설정                                    --%>
<%-- pop33a.jsp에서 include                                                --%>
<%-- 원본: ProActive POP33A_M0A.cs (D0A popup)                             --%>
<%-- 서버 호출 없음 - localStorage 저장                                     --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- numberbox 오른쪽 정렬 -->
<style>
#f_percent + .numberbox .textbox-text { text-align: right !important; }
</style>

<!-- 기준설정 다이얼로그 -->
<div id="setting-dialog" class="easyui-dialog" style="width:350px;height:200px;padding:10px 15px;"
    data-options="closed:true, modal:true, title:'기준설정', buttons:'#setting-dialog-buttons'">
    <form id="setting-form" method="post">
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table" style="width:100%; display:table; table-layout:fixed">
                <colgroup>
                    <col width="35%">
                    <col width="65%">
                </colgroup>
                <tr>
                    <th class="h"><span>오류율 기준(%)</span></th>
                    <td class="d">
                        <input id="f_percent" name="percent" class="easyui-numberbox"
                            data-options="width:'100%', min:0, max:100, precision:0, value:0" />
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 기준설정 다이얼로그 버튼 -->
<div id="setting-dialog-buttons" style="padding:5px;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="setting-save-button">저장</a>
</div>
