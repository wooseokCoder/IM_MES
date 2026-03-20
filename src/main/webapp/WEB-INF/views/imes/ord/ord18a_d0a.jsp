<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord18a_d0a.jsp 1.0 2026/03/06                                     --%>
<%-- 오더 완료일 수정 팝업 - ORD18A_D0A                                    --%>
<%-- 원본: ProActive ORD18A_D0A.cs                                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<script type="text/javascript" src="<c:url value="/resources/js/imes/ord/ord18a_d0a.js"/>?v=260306A"></script>
</head>

<%@ include file="/WEB-INF/views/include/body.head.jsp" %>

<!-- 로딩바 -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

<div data-options="region:'north', border:false">
    <div class="wui-toolbar datagrid-toolbar">
        <fieldset class="Remake-div-line-new">
            <table cellpadding="0" class="search-table tableSearch-c wd-100">
                <colgroup>
                    <col width="0px">
                    <col width="*">
                </colgroup>
                <tr class="topnav_sty">
                    <td colspan="2">
                        <div>
                            <div>
                                <a href="javascript:void(0)" id="save-button" class="easyui-linkbutton c6">저장</a>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
</div>

<div data-options="region:'center', border:false" style="padding:10px;">
    <table cellpadding="5" style="border-collapse:collapse;">
        <tr>
            <td>
                <input id="f_actStartTime" class="easyui-datetimebox" name="actStartTime"
                    data-options="width:180, editable:false, required:true" />
            </td>
            <td style="padding:0 5px;">~</td>
            <td>
                <input id="f_actEndTime" class="easyui-datetimebox" name="actEndTime"
                    data-options="width:180, editable:false, required:true" />
            </td>
        </tr>
    </table>
</div>

</div>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
