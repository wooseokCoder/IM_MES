<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 공정 검색 팝업 공통 (acProcForm) - include 방식                        --%>
<%-- AS-IS CodeHelperManager.acProcForm 대응                                --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/acProcForm.jsp" %>     --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.1 2026/03/06                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 공정 검색 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/acProcForm.js?v=260306B" />"></script>

<!-- 공정 찾기 다이얼로그 (공통) -->
<div id="acproc-search-dialog" class="easyui-dialog" style="visibility:hidden;width:600px;height:470px"
    data-options="closed:true, modal:true, title:'공정 찾기', buttons:'#acproc-search-buttons'">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north', border:false" style="height:45px; padding:8px 8px 0 8px">
            <table style="width:100%">
                <tr>
                    <td style="white-space:nowrap; padding:3px 5px 3px 0"><span style="font-weight:bold">공정코드/명</span></td>
                    <td style="padding:3px 5px 3px 0"><input id="acproc-search-keyword" class="easyui-textbox" data-options="width:200" /></td>
                    <td style="padding:3px 0"><a href="javascript:void(0)" class="easyui-linkbutton c6" id="acproc-search-btn">조회</a></td>
                    <td style="width:99%"></td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center', border:false">
            <table id="acproc-search-grid"></table>
        </div>
    </div>
</div>

<!-- 공정 찾기 다이얼로그 버튼 -->
<div id="acproc-search-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acproc-confirm-button">확인</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="acproc-close-button">닫기</a>
</div>
