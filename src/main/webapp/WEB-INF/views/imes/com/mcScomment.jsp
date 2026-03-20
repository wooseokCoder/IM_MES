<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 설비점검 의견 공통 팝업 (mcScomment)                                  --%>
<%-- AS-IS: McScomment.cs - WorkIdle 하위 팝업                             --%>
<%-- 사용: <%@ include file="/WEB-INF/views/imes/com/mcScomment.jsp" %>    --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 설비점검 의견 공통 모듈 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/mcScomment.js?v=260319A" />"></script>

<!-- 설비점검 의견 다이얼로그 (공통) -->
<div id="mcs-dialog" class="easyui-dialog" style="visibility:hidden;width:550px;height:320px"
    data-options="closed:true, modal:true, buttons:'#mcs-dialog-buttons'">
    <div style="padding:10px;">
        <textarea id="mcs-comment" style="width:100%;height:200px;font-size:14px;resize:none;"
            placeholder="상세원인을 입력하세요."></textarea>
    </div>
</div>

<!-- 설비점검 의견 다이얼로그 버튼 -->
<div id="mcs-dialog-buttons" style="padding:5px;visibility:hidden;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="mcs-confirm-button">확인</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="mcs-close-button">닫기</a>
</div>
