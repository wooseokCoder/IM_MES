<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 파일 첨부 컨트롤 공통 (acAttachFileControl)                          --%>
<%-- AS-IS: ProActive acAttachFileControl.cs 웹 전환                      --%>
<%--                                                                        --%>
<%-- 탭 구성 (원본 acTabControl1 대응):                                    --%>
<%--   Tab1: 첨부파일목록  — 활성 파일 목록 (우클릭 컨텍스트 메뉴)     --%>
<%--   Tab2: 전송 대기파일 — 업로드 진행 상황 표시 (웹: 업로드 큐 스텁)  --%>
<%--   Tab3: 삭제이력      — DATA_FLAG=1 파일 이력 (FileDelHistoryGridView)--%>
<%--                                                                        --%>
<%-- 사용법:                                                               --%>
<%--   JSP: <%@ include file="/WEB-INF/views/imes/com/acAttachFileControl.jsp" %> --%>
<%--   JS:  acAttachFileControl.init({ uploadMenu: 'STD47A' });            --%>
<%--        acAttachFileControl.setLinkKey('MODEL_NO-PRG_CODE');           --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 파일 첨부 컨트롤 JS -->
<script type="text/javascript" src="<c:url value="/resources/js/imes/com/acAttachFileControl.js"/>?v=260310A"></script>

<!-- ================================================================== -->
<!-- 파일 첨부 컨트롤 레이아웃                                          -->
<!-- ================================================================== -->
<div id="ac-attach-wrap" style="width:100%; height:100%; display:flex; flex-direction:column;">

    <!-- ── 3탭 영역 ── -->
    <div style="flex:1; overflow:hidden; position:relative;">
        <div id="ac-attach-tabs" class="easyui-tabs" style="width:100%; height:100%;"
             data-options="fit:true, border:false, plain:true">

            <!-- Tab1: 첨부파일목록 (FileGridView) -->
            <div title="첨부파일목록" style="padding:0; overflow:hidden;">
                <table id="ac-attach-grid" style="width:100%; height:100%;"></table>
            </div>

            <!-- Tab2: 전송 대기파일 (FileTransferGridView — 웹: 업로드 큐 스텁) -->
            <div title="전송 대기파일" style="padding:0; overflow:hidden;">
                <table id="ac-transfer-grid" style="width:100%; height:100%;"></table>
            </div>

            <!-- Tab3: 삭제이력 (FileDelHistoryGridView) -->
            <div title="삭제이력" style="padding:0; overflow:hidden;">
                <table id="ac-del-history-grid" style="width:100%; height:100%;"></table>
            </div>

        </div>
    </div>

</div>

<!-- ================================================================== -->
<!-- 숨김 파일 input (툴바 숨겨도 동작하도록 wrap 외부에 위치)         -->
<!-- ================================================================== -->
<input type="file" id="ac-attach-file-input"
       style="display:none;"
       onchange="acAttachFileControl.onFileSelected(this)" />

<!-- ================================================================== -->
<!-- 우클릭 컨텍스트 메뉴 (첨부파일목록 탭 — popupMenu1 대응)         -->
<!--   EasyUI menu 위젯 사용 (pop32b.js 방식)                          -->
<!--   항목 구성 (원본 popupMenu1.LinksPersistInfo 순서):               -->
<!--     파일 올리기 / [구분선] 파일열기·내려받기 /                    -->
<!--     [구분선] 공개형태(서브메뉴)·이름 바꾸기·파일삭제              -->
<!--   권한(attachLinkPermission)에 따라 항목 표시/숨김 제어            -->
<!-- ================================================================== -->
<div id="ac-attach-context-menu" class="easyui-menu" data-options="hideOnUnhover:false" style="width:160px; display:none;">
    <!-- btnUpload: 파일 올리기 -->
    <div id="ac-ctx-upload">파일 올리기</div>
    <!-- 구분선1: 업로드·다운로드 경계 -->
    <div id="ac-ctx-sep1" class="menu-sep"></div>
    <!-- btnOpen: 파일열기 -->
    <div id="ac-ctx-open">파일열기</div>
    <!-- btnDownload: 내려받기 -->
    <div id="ac-ctx-download">내려받기</div>
    <!-- 구분선2: 다운로드·편집 경계 -->
    <div id="ac-ctx-sep2" class="menu-sep"></div>
    <!-- acBarSubItem1: 공개형태 (서브메뉴) -->
    <div id="ac-ctx-acc-level">공개형태
        <div style="width:120px;">
            <div id="ac-ctx-acc-public">공개</div>
            <div id="ac-ctx-acc-private">내부</div>
        </div>
    </div>
    <!-- btnRename: 이름 바꾸기 -->
    <div id="ac-ctx-rename">이름 바꾸기</div>
    <!-- btnDelete: 파일삭제 -->
    <div id="ac-ctx-delete">파일삭제</div>
</div>
