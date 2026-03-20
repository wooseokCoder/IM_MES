<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 호기 순번 수정 팝업 (ORD07A_D0A)                                      --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.0 2026/02/10                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
#d_srNo + .numberbox .textbox-text { text-align: right !important; }
</style>

<div style="padding:10px 20px;">
    <form id="d0a-form">
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <tr>
                    <th class="h" data-item="GRD_001"><span>년도</span></th>
                    <td class="d"><input class="easyui-textbox" id="d_srKey" data-options="width:220, readonly:true" /></td>
                </tr>
                <tr>
                    <th class="h" data-item="GRD_002"><span>모델</span></th>
                    <td class="d"><input class="easyui-textbox" id="d_srCode" data-options="width:220, readonly:true" /></td>
                </tr>
                <tr>
                    <th class="h" data-item="GRD_003"><span>순번</span></th>
                    <td class="d"><input class="easyui-numberbox" id="d_srNo" data-options="width:220, precision:0, min:1, max:999999999" /></td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
