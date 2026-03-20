<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- D2B: CAPA 변경 팝업 (href 동적 로드, script 금지) -->
<div style="padding:10px 20px;">
    <form id="d2b-form">
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <tr>
                    <th class="h"><span>일자</span></th>
                    <td class="d">
                        <input class="easyui-textbox" id="d2b_workDate" data-options="width:150, readonly:true" />
                    </td>
                </tr>
                <tr>
                    <th class="h"><span>설비</span></th>
                    <td class="d">
                        <input class="easyui-textbox" id="d2b_mcCode" data-options="width:100, readonly:true" />
                        <input class="easyui-textbox" id="d2b_mcName" data-options="width:150, readonly:true" />
                    </td>
                </tr>
                <tr>
                    <th class="h"><span>CAPA</span></th>
                    <td class="d">
                        <input class="easyui-numberbox" id="d2b_capa" data-options="width:150, min:0, max:1440, precision:0" />
                    </td>
                </tr>
                <tr>
                    <th class="h"><span>변경사유</span></th>
                    <td class="d">
                        <input class="easyui-textbox" id="d2b_scomment" data-options="width:280,validType:'length[0,100]'" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding:5px 0;">
                        <input type="range" id="d2b_slider" min="0" max="1440" value="0" style="width:100%;" />
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
