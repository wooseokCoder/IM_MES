<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 단말기 - 가공 - 설비제원 다이얼로그 (D9A)                               --%>
<%-- 원본: ProActive POP30B_D9A.cs                                         --%>
<%-- API: POP30A_SER17 (파일목록)                                           --%>
<%--                                                                        --%>
<%-- @author AI Assistant                                                   --%>
<%-- @version 2.0 2026/03/19                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop30b_d9a.js"/>?v=260319A"></script>

<!-- 설비제원 다이얼로그 -->
<div id="d9a-dialog" class="easyui-dialog" style="visibility:hidden;width:550px;height:400px"
    data-options="closed:true, modal:true, buttons:'#d9a-dialog-buttons'">
    <div style="padding:5px;">
        <table id="d9a-grid"></table>
    </div>
</div>

<!-- 설비제원 다이얼로그 버튼 -->
<div id="d9a-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d9a-download-button">다운로드</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d9a-close-button">닫기</a>
</div>
