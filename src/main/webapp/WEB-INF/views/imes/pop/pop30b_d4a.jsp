<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 단말기 - 가공 - 자주검사 다이얼로그 (D4A)                                --%>
<%--                                                                        --%>
<%-- 레이아웃:                                                              --%>
<%--   상단: [검사그룹선택] [정보라벨(주황)] [완료(QMS전송)] [임시저장] [닫기] --%>
<%--   하단좌: 검사그룹 이미지                                              --%>
<%--   하단우: 검사항목 그리드                                              --%>
<%--                                                                        --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.4 2026/03/20                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* 부적합 셀 빨강 배경 */
.d4a-cell-ng { background-color: #FF0000 !important; color: #000 !important; }
/* 인라인 입력 기본 스타일 */
.d4a-input { width: 95%; height: 24px; border: 1px solid #ccc; padding: 1px 3px; box-sizing: border-box; }
.d4a-select { width: 95%; height: 24px; border: 1px solid #ccc; box-sizing: border-box; }
/* 상단 버튼바 */
.d4a-toolbar { display: flex; align-items: stretch; height: 100%; padding: 5px; gap: 5px; }
.d4a-toolbar .d4a-info-label {
    flex: 1;
    background-color: rgb(255,192,128);
    padding: 4px 12px;
    font-size: 13px;
    font-weight: bold;
    text-align: center;
    border-radius: 3px;
    line-height: 1.4;
    display: flex;
    align-items: center;
    justify-content: center;
}
.d4a-toolbar .l-btn {
    min-width: 90px !important;
    height: auto !important;
    font-size: 14px;
    display: flex !important;
    align-items: center;
    justify-content: center;
}
/* 완료 버튼 두줄 */
.d4a-toolbar .l-btn-text { font-size: 14px !important; line-height: 1.3; white-space: normal !important; text-align: center; }
/* 우측 그리드 영역 스크롤 (plain HTML table — STD04A_D1A 패턴) */
#d4a-grid-wrap {
    overflow: auto !important;
}
#d4a-grid-wrap::-webkit-scrollbar { width: 10px; height: 10px; }
#d4a-grid-wrap::-webkit-scrollbar-track { background: transparent; }
#d4a-grid-wrap::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.2); border-radius: 4px; }
#d4a-grid-wrap::-webkit-scrollbar-thumb:hover { background: rgba(0,0,0,0.35); }
/* plain table 스타일 */
#d4a-grid { border-collapse: collapse; white-space: nowrap; width: auto; }
#d4a-grid th {
    background: #f5f5f5; font-weight: bold; font-size: 13px; color: #696969;
    border: 1px solid #ddd; padding: 4px 6px; text-align: center;
    position: sticky; top: 0; z-index: 1;
}
#d4a-grid td {
    border: 1px solid #ddd; padding: 3px 6px; font-size: 13px;
}
#d4a-grid tbody tr:nth-child(odd) { background: #fff; }
#d4a-grid tbody tr:nth-child(even) { background: #f5f5f5; }
#d4a-grid tbody tr:hover { background: #e8f0fe; }
/* 우측 이미지 없을 때 */
.d4a-no-image {
    color: #999;
    font-size: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
}
</style>

<script type="text/javascript" src="<c:url value="/resources/js/imes/pop/pop30b_d4a.js"/>?v=260320B"></script>

<!-- 자주검사 다이얼로그 -->
<div id="d4a-dialog" style="visibility:hidden;">
    <div class="easyui-layout" data-options="fit:true">

        <!-- 상단: 버튼 + 정보라벨 -->
        <div data-options="region:'north', border:false" style="height:80px; overflow:hidden;">
            <div class="d4a-toolbar">
                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d4a-grp-select-button">검사그룹선택</a>
                <div id="d4a-info-label" class="d4a-info-label">-</div>
                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d4a-complete-button">완료<br/>(QMS전송)</a>
                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d4a-temp-save-button">임시저장</a>
                <a href="javascript:void(0)" class="easyui-linkbutton c6" id="d4a-close-button">닫기</a>
            </div>
        </div>

        <!-- 좌측: 검사그룹 이미지 -->
        <div data-options="region:'west', split:true, border:true" style="width:50%; padding:5px;">
            <div id="d4a-image-area" style="text-align:center; height:100%; display:flex; align-items:center; justify-content:center; overflow:auto;">
                <span class="d4a-no-image">이미지 없음</span>
                <img id="d4a-ins-image" src="" style="max-width:100%; max-height:100%; object-fit:contain; display:none;" alt=""/>
            </div>
        </div>

        <!-- 우측: 검사항목 그리드 (plain HTML table — 가로 스크롤 허용) -->
        <div data-options="region:'center', border:true">
            <div id="d4a-grid-wrap" style="width:100%; height:100%;">
                <table id="d4a-grid" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th style="min-width:35px; width:35px">No</th>
                            <th style="min-width:80px">검사대분류명</th>
                            <th style="min-width:90px">검사항목명</th>
                            <th style="min-width:90px">점검내역</th>
                            <th style="min-width:45px; width:45px">TYPE</th>
                            <th style="min-width:55px; width:55px">기준값</th>
                            <th style="min-width:45px; width:45px">단위</th>
                            <th style="min-width:50px; width:50px">Min</th>
                            <th style="min-width:50px; width:50px">Max</th>
                            <th style="min-width:80px; width:80px">검사결과</th>
                            <th style="min-width:250px; width:250px">이미지</th>
                            <th style="min-width:90px">비고</th>
                        </tr>
                    </thead>
                    <tbody id="d4a-tbody"></tbody>
                </table>
            </div>
        </div>

    </div>
</div>
