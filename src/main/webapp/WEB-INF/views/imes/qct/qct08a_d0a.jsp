<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)qct08a_d0a.jsp 1.0 2026/03/17                                    --%>
<%--                                                                        --%>
<%-- 검사 이미지 팝업 (D0A) - href 방식 동적 로드                            --%>
<%-- 이미지 1개 (사진1) 표시                                                 --%>
<%-- @author 송우석                                                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<div style="padding:10px; text-align:center;">
    <div id="d0a-img-wrap" style="width:100%; height:240px; display:flex; align-items:center; justify-content:center; border:1px solid #ddd; background:#fafafa; position:relative;">
        <img id="d0a-img1" style="display:none; max-width:100%; max-height:100%; object-fit:contain;" />
        <span id="d0a-img1-empty" style="color:#999;">이미지 없음</span>
        <div id="d0a-loading" style="display:none; position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(255,255,255,0.8); z-index:10; display:none;">
            <div style="display:flex; align-items:center; justify-content:center; width:100%; height:100%;">
                <img src="<%=request.getContextPath()%>/resources/images/ajax_loader_red_48.gif" style="width:32px; height:32px;" />
                <span style="margin-left:8px; color:#666; font-size:12px;">조회 중...</span>
            </div>
        </div>
    </div>
</div>
