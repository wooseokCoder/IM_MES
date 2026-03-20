<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 비가동현황 (가공) - 상세원인 수정 및 확인 다이얼로그 (D0A)                --%>
<%-- pop32b.jsp에서 include                                                --%>
<%-- 2개 그룹 (발생원인, 처리내용)                                         --%>
<%--                                                                        --%>
<%-- @author AI Assistant                                                   --%>
<%-- @version 1.0 2026/03/03                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<style type="text/css">
	.pop32b_d0a_legend {margin-bottom : 10px;}
</style>

<!-- 상세원인 수정 및 확인 다이얼로그 -->
<div id="detail-dialog" style="visibility:hidden;padding:10px 20px">
    <form id="detail-form" method="post">
        <!-- 발생원인 -->
        <fieldset class="div-line-new-sub">
            <legend class="pop32b_d0a_legend"><span data-item="FRM_001">발생원인</span></legend>
            <div style="padding:5px; height:200px;">
                <input id="f_mctScomment" name="mctScomment" class="multiline easyui-textbox"
                    data-options="width:'100%', multiline:true, height:200" readonly="true" />
            </div>
        </fieldset>
        
        <!-- 처리내용 -->
        <fieldset class="div-line-new-sub" style="margin-top : 5px;">
            <legend class="pop32b_d0a_legend"><span data-item="FRM_002">처리내용</span></legend>
            <div style="padding:5px; height:200px;">
                <input id="f_mctScommentResult" name="mctScommentResult" class="multiline easyui-textbox"
                    data-options="width:'100%', multiline:true, height:200" />
            </div>
        </fieldset>
        
        <!-- Hidden Fields -->
        <input type="hidden" id="f_idleId" name="idleId"/>
    </form>
</div>

<!-- 다이얼로그 버튼 -->
<div id="detail-dialog-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-save-button2">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-close-button2">닫기</a>
</div>
