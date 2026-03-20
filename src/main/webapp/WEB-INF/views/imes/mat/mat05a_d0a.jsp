<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- MAT05A D0A 다이얼로그 (현장불출)                                       --%>
<%-- 원본: ProActive MAT05A_D0A.cs                                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<div id="d0a-dialog" class="easyui-dialog" title="현장 불출"
     data-options="closed:true, modal:true, shadow:true, resizable:true, buttons:'#d0a-buttons'"
     style="width:950px; height:520px; padding:0px; visibility:hidden;">
    <div class="easyui-layout" data-options="fit:true">
        <!-- 담당자 그리드 (West) -->
        <div data-options="region:'west', border:false, split:true" style="width:230px;">
            <table id="d0a-grid1"></table>
        </div>
        <!-- 자재 그리드 (Center) -->
        <div data-options="region:'center', border:false">
            <table id="d0a-grid2"></table>
        </div>
    </div>
</div>
<div id="d0a-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" id="d0a-save-button" class="easyui-linkbutton c6">불출</a>
</div>
