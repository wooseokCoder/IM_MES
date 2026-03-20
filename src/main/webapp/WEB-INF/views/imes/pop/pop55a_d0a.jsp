<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- NAM공정 NG파일배포 확인 - 비고 입력 다이얼로그 (D0A)                    --%>
<%-- pop55a.jsp에서 include                                                --%>
<%-- 원본: ProActive POP55A_M0A.cs (비고 입력 팝업)                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 비고 입력 다이얼로그 -->
<div id="comment-dialog" class="easyui-dialog" style="width:450px;height:250px;padding:10px 15px;"
    data-options="closed:true, modal:true, title:'비고', buttons:'#comment-dialog-buttons'">
    <div style="padding:10px;">
        <textarea id="f_scomment" style="width:100%; height:100px;" maxlength="1000"></textarea>
    </div>
</div>

<!-- 비고 다이얼로그 버튼 -->
<div id="comment-dialog-buttons" style="padding:5px;">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="comment-save-btn">저장</a>
</div>
