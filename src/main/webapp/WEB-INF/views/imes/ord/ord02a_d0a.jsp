<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 이메일 수신자그룹 엑셀업로드 팝업 (ORD02A_D0A)                        --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/02/10                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* 좌측 패널 1열(th): padding 추가 */
#excel-mapping-form th {
    padding-left: 10px !important;
    text-align: left !important;
}
/* 좌측 패널 2열(td) input: 테두리/배경 제거 */
#excel-mapping-form .textbox,
#excel-mapping-form .textbox.textbox-focused {
    border: none !important;
    box-shadow: none !important;
    background-color: transparent !important;
    border-radius: 0 !important;
}
#excel-mapping-form .textbox .textbox-text,
#excel-mapping-form .textbox input.textbox-text,
#excel-mapping-form .numberbox-f {
    background: #fff !important;
    border: none !important;
}
#excel-mapping-form td {
    background-color: #fff !important;
}
</style>

<div class="easyui-layout" data-options="fit:true">

    <!-- 상단: 버튼 영역 -->
    <div data-options="region:'north', border:false" style="height:40px; padding:5px;">
        <input type="file" id="d_excelFile" accept=".xls,.xlsx" style="display:none;" />
        <div style="text-align:right;">
            <a href="javascript:void(0)" id="d_fileOpenBtn" class="easyui-linkbutton c6">파일열기</a>
            <a href="javascript:void(0)" id="d_saveBtn" class="easyui-linkbutton c6">저장</a>
        </div>
    </div>

    <!-- 좌측: Excel 열 설정 -->
    <div data-options="region:'west', border:true, title:'Excel 열 설정'" style="width:180px; padding:5px;">
        <form id="excel-mapping-form">
            <table cellpadding="4" cellspacing="2" class="select-table accordion" style="width:100%;">
                <tr>
                    <th style="width:50%;" data-item="GRD_001"><span>시작행</span></th>
                    <td><input id="d_startRow" class="easyui-numberbox" data-options="width:60, value:2, min:1, precision:0" /></td>
                </tr>
                <tr>
                    <th data-item="GRD_002"><span>그룹명</span></th>
                    <td><input id="d_colGroupName" class="easyui-textbox" data-options="width:60, value:'A'" /></td>
                </tr>
                <tr>
                    <th data-item="GRD_003"><span>사원명</span></th>
                    <td><input id="d_colEmpName" class="easyui-textbox" data-options="width:60, value:'B'" /></td>
                </tr>
                <tr>
                    <th data-item="GRD_004"><span>사원코드</span></th>
                    <td><input id="d_colEmpCode" class="easyui-textbox" data-options="width:60, value:'C'" /></td>
                </tr>
                <tr>
                    <th data-item="GRD_005"><span>이메일</span></th>
                    <td><input id="d_colEmail" class="easyui-textbox" data-options="width:60, value:'D'" /></td>
                </tr>
            </table>
        </form>
    </div>

    <!-- 우측: 미리보기 그리드 -->
    <div data-options="region:'center', border:true">
        <table id="d_previewGrid"></table>
    </div>

</div>

