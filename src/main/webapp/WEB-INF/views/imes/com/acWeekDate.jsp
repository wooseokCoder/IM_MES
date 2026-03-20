<%@ page pageEncoding="UTF-8" %>
<%--
 * ============================================================================
 * acWeekDate.jsp - 주간/일자 선택기 공통 컴포넌트 (include용)
 * ============================================================================
 * AS-IS: acWeekDate (C# UserControl)
 *
 * 사용법 (JSP에서):
 *   <c:set var="wdPrefix" value="wd1"/>
 *   <%@ include file="/WEB-INF/views/imes/com/acWeekDate.jsp" %>
 *
 * wdPrefix 변수로 컴포넌트 ID 접두사를 지정합니다.
 * 한 화면에 여러 개를 배치할 경우 prefix를 다르게 설정합니다.
 * ============================================================================
--%>
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/acWeekDate.js?v=260304B" />"></script>

<div style="display:flex; align-items:center; flex-wrap:nowrap;">
    <input id="${wdPrefix}_selectMode" class="easyui-combobox" data-options="width:60, editable:false, panelHeight:'auto'" style="max-width:60px !important;"/>
    <input id="${wdPrefix}_startDate" class="easyui-datebox" data-options="width:120, editable:true" style="margin-left:4px;"/>
    <span style="margin:0 2px;">~</span>
    <input id="${wdPrefix}_endDate" class="easyui-datebox" data-options="width:120, editable:true"/>
    <input id="${wdPrefix}_weekNo" class="easyui-textbox" data-options="width:120, editable:false" style="margin-left:4px;"/>
    <a href="javascript:void(0)" id="${wdPrefix}_btnPrev" class="easyui-linkbutton" data-options="plain:true, iconCls:'icon-arrow2'" style="min-width:24px; height:22px; margin-left:2px;"></a>
    <a href="javascript:void(0)" id="${wdPrefix}_btnNext" class="easyui-linkbutton" data-options="plain:true, iconCls:'icon-arrow1'" style="min-width:24px; height:22px; margin-left:2px;"></a>
</div>
