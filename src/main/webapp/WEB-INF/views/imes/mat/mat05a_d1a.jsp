<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- MAT05A D1A 다이얼로그 (불출취소)                                       --%>
<%-- 원본: ProActive MAT05A_D1A.cs                                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<div id="d1a-dialog" class="easyui-dialog" title="현장 불출 취소"
     data-options="closed:true, modal:true, shadow:true, resizable:true, buttons:'#d1a-buttons'"
     style="width:950px; height:520px; padding:0px; visibility:hidden;">
    <div class="easyui-layout" data-options="fit:true">
        <!-- 안내 문구 (North) -->
        <div data-options="region:'north', border:false" style="height:29px; overflow:hidden;">
            <div style="padding:4px 8px; color:#000; font-size:16px; text-align:right; font-weight: bold;">MES에서 불출된 자재만 조회됩니다.</div>
        </div>
        <!-- 출고건 그리드 (West) -->
        <div data-options="region:'west', border:false, split:true" style="width:160px;">
            <table id="d1a-grid1"></table>
        </div>
        <!-- 불출자재 그리드 (Center) -->
        <div data-options="region:'center', border:false">
            <table id="d1a-grid2"></table>
        </div>
    </div>
</div>
<div id="d1a-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" id="d1a-cancel-button" class="easyui-linkbutton c6">불출취소</a>
</div>
