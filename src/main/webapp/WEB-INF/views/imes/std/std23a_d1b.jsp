<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- D1B: 휴일설정 팝업 (href 동적 로드, script 금지) -->
<div style="padding:10px 20px;">
    <form id="d1b-form">
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <tr>
                    <th class="h"><span>일자</span></th>
                    <td class="d">
                        <input class="easyui-textbox" id="d1b_holiDate" data-options="width:150, readonly:true" />
                    </td>
                </tr>
                <tr>
                    <th class="h"><span>휴일명</span></th>
                    <td class="d">
                        <input class="easyui-textbox" id="d1b_holiName" data-options="width:200, validType:'length[0,50]'" />
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
