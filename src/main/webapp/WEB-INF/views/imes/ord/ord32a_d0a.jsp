<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)ord32a_d0a.jsp 1.0 2026/03/10                                     --%>
<%-- 모델/공정 편집 다이얼로그 (D0A) - ORD32A 하위 팝업                      --%>
<%-- 원본: ProActive ORD32A_D0A.cs                                          --%>
<%-- 레이아웃:                                                              --%>
<%--   상단: 선택된 모델(Grid1) | 전체 모델(Grid2)                          --%>
<%--   하단: 선택된 공정(Grid3) | 전체 공정(Grid4)                          --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- ============================================================ -->
<!-- D0A: 모델/공정 편집 다이얼로그 -->
<!-- ============================================================ -->
<div id="d0a-dialog" class="easyui-dialog" style="width:900px;height:550px;"
    data-options="closed:true, modal:true, title:'모델/공정 편집', buttons:'#d0a-buttons'">
    <div class="easyui-layout" data-options="fit:true">

        <!-- 상단: 모델선택 -->
        <div data-options="region:'north', split:true, border:true, title:'모델선택'" style="height:50%">
            <div class="easyui-layout" data-options="fit:true">
                <!-- 좌: 선택된 모델 (D0A Grid1) -->
                <div data-options="region:'west', split:true, border:true, title:'선택된 모델'" style="width:50%">
                    <table id="d0a-grid1"></table>
                </div>
                <!-- 우: 전체 모델 (D0A Grid2) -->
                <div data-options="region:'center', border:true, title:'전체 모델'">
                    <table id="d0a-grid2"></table>
                </div>
            </div>
        </div>

        <!-- 하단: 공정선택 -->
        <div data-options="region:'center', border:true, title:'공정선택'">
            <div class="easyui-layout" data-options="fit:true">
                <!-- 좌: 선택된 공정 (D0A Grid3) -->
                <div data-options="region:'west', split:true, border:true, title:'선택된 공정'" style="width:50%">
                    <table id="d0a-grid3"></table>
                </div>
                <!-- 우: 전체 공정 (D0A Grid4) -->
                <div data-options="region:'center', border:true, title:'전체 공정'">
                    <table id="d0a-grid4"></table>
                </div>
            </div>
        </div>

    </div>
</div>
<div id="d0a-buttons" style="padding:5px">
    <a href="javascript:void(0)" class="easyui-linkbutton c8" id="d0a-save-button">저장</a>
</div>

<!-- D0A Grid1 (선택된 모델) 우클릭 메뉴 -->
<div id="d0a-grid1-menu" class="easyui-menu" style="width:120px;">
    <div onclick="doD0aRemoveModel()">제외</div>
</div>

<!-- D0A Grid2 (전체 모델) 우클릭 메뉴 -->
<div id="d0a-grid2-menu" class="easyui-menu" style="width:120px;">
    <div onclick="doD0aAddModel()">추가</div>
</div>

<!-- D0A Grid3 (선택된 공정) 우클릭 메뉴 -->
<div id="d0a-grid3-menu" class="easyui-menu" style="width:120px;">
    <div onclick="doD0aRemoveProc()">제외</div>
</div>

<!-- D0A Grid4 (전체 공정) 우클릭 메뉴 -->
<div id="d0a-grid4-menu" class="easyui-menu" style="width:120px;">
    <div onclick="doD0aAddProc()">추가</div>
</div>
