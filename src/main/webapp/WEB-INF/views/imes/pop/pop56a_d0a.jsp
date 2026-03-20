<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 불량메일 발신자 관리 - 사원 등록 팝업 (D0A)                              --%>
<%-- pop56a.jsp에서 include                                                --%>
<%-- 원본: ProActive POP56A_M0A.cs (사원 추가 팝업)                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 사원 등록 다이얼로그 -->
<div id="emp-dialog" class="easyui-dialog" style="width:400px;height:200px;padding:10px 15px;"
    data-options="closed:true, modal:true, title:'사원 등록', buttons:'#emp-dialog-buttons'">
    <form id="emp-form" method="post">
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table" style="width:100%; display:table; table-layout:fixed">
                <colgroup>
                    <col width="30%">
                    <col width="70%">
                </colgroup>
                <!-- 사원 (돋보기 버튼으로 검색) -->
                <tr>
                    <th class="h"><span>사원</span></th>
                    <td class="d" style="white-space:nowrap;">
                        <input type="hidden" id="f_empCode" />
                        <input id="f_empName" class="easyui-textbox" data-options="width:160, editable:false" />
                        <a href="javascript:void(0)" onclick="doSearchEmpD0a()" style="display:inline-block; vertical-align:middle; cursor:pointer; margin-left:2px;">
                            <img style="width:13px; height:13px; vertical-align:middle;" src="<%=request.getContextPath() %>/resources/images/search.png" />
                        </a>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>

<!-- 사원 등록 다이얼로그 버튼 -->
<div id="emp-dialog-buttons" style="padding:5px;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="emp-save-button">저장</a>
</div>
