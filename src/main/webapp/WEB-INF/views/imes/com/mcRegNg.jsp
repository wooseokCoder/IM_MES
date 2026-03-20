<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- NG 등록 공통 팝업 (mcRegNg)                                           --%>
<%-- AS-IS: McRegNg.cs - 3개 화면 + WorkIdle 하위                          --%>
<%-- 백엔드: Pop30aService.pop30aInsA() (POP30A_INS_A)                     --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/mcRegNg.jsp" %>       --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- NG 등록 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/mcRegNg.js?v=260319A" />"></script>

<!-- NG 등록 다이얼로그 (공통) -->
<div id="mrng-dialog" class="easyui-dialog" style="visibility:hidden;width:550px;height:450px"
    data-options="closed:true, modal:true, buttons:'#mrng-dialog-buttons'">
    <div style="padding:10px;">
        <table cellpadding="0" class="search-table tableSearch-c wd-100">
            <colgroup>
                <col width="90px">
                <col width="*">
                <col width="90px">
                <col width="*">
            </colgroup>
            <tr>
                <th class="h table-Search-h search-label-h"><span>불량유형</span></th>
                <td class="d">
                    <select id="mrng-master-cause" class="easyui-combobox"
                        data-options="width:150, editable:false, panelHeight:'auto',
                            valueField:'codeValue', textField:'codeName'"></select>
                </td>
                <th class="h table-Search-h search-label-h"><span>상세유형</span></th>
                <td class="d">
                    <select id="mrng-detail-cause" class="easyui-combobox"
                        data-options="width:150, editable:false, panelHeight:'auto',
                            valueField:'codeValue', textField:'codeName'"></select>
                </td>
            </tr>
            <tr>
                <th class="h table-Search-h search-label-h"><span>수량</span></th>
                <td class="d">
                    <input id="mrng-quantity" class="easyui-numberbox"
                        data-options="width:100, min:1, value:1, precision:0" />
                </td>
                <th class="h table-Search-h search-label-h"><span>작업자</span></th>
                <td class="d">
                    <input id="mrng-emp-code" class="easyui-textbox"
                        data-options="width:150, readonly:true" />
                </td>
            </tr>
        </table>
        <div style="margin-top:8px;">
            <label style="font-weight:bold;">불량내용:</label>
            <textarea id="mrng-contents" style="width:100%;height:140px;font-size:14px;resize:none;margin-top:4px;"
                placeholder="불량 내용을 입력하세요."></textarea>
        </div>
    </div>
</div>

<!-- NG 등록 다이얼로그 버튼 -->
<div id="mrng-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="mrng-save-button">등록</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="mrng-close-button">닫기</a>
</div>
