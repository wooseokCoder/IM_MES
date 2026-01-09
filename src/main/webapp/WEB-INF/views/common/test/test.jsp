<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<script type="text/javascript" src="<c:url value="/resources/js/common/test/test.js?v=260109" />"></script>
</head>

<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<div class="easyui-layout" data-options="fit:true">
    <table id="search-grid">
        <thead>
            <tr>
                <th data-options="field:'menuKey',width:100,align:'center',editor:{type:'validatebox',options:{required:true}}">Menu ID</th>
                <th data-options="field:'menuDesc',width:200,align:'left',editor:{type:'validatebox',options:{required:true}}">Menu Name</th>
                <th data-options="field:'menuUrl',width:250,align:'left',editor:'text'">URL</th>
                <th data-options="field:'parentKey',width:100,align:'center',editor:'text'">Parent ID</th>
                <th data-options="field:'menuLevel',width:60,align:'center',editor:'numberbox'">Level</th>
                <th data-options="field:'menuSeq',width:60,align:'center',editor:'numberbox'">Seq</th>
                <th data-options="field:'useFlag',width:60,align:'center',editor:{type:'checkbox',options:{on:'Y',off:'N'}}">Use</th>
                <th data-options="field:'regiDate',width:120,align:'center'">Reg Date</th>
            </tr>
        </thead>
    </table>

    <div id="search-toolbar">
        <form id="search-form">
            <table cellpadding="5">
                <tr>
                    <td>Menu ID:</td>
                    <td><input class="easyui-textbox" name="menuKey" style="width:100px"></td>
                    <td>Menu Name:</td>
                    <td><input class="easyui-textbox" name="menuDesc" style="width:100px"></td>
                    <td>
                        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doSearch()">Search</a>
                        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="doAppend()">Add</a>
                        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="doRemove()">Delete</a>
                        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" onclick="doSave()">Save</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
</html>
