<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- D0B: CAPA 생성 팝업 (href 동적 로드, script 금지) -->
<div style="padding:10px 15px;">
    <form id="d0b-form">
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <tr>
                    <th class="h"><span>시작일</span></th>
                    <td class="d">
                        <input class="easyui-datebox" id="d0b_frDate" data-options="width:150, editable:false" />
                    </td>
                    <th class="h"><span>종료일</span></th>
                    <td class="d">
                        <input class="easyui-datebox" id="d0b_toDate" data-options="width:150, editable:false" />
                    </td>
                </tr>
            </table>
        </fieldset>
        <div style="padding:5px 0; color:#d32f2f; font-size:11px;">
            [기간 내에 휴일이 있으면 휴일의 CAPA는 0으로 생성됩니다.]
        </div>
        <div style="padding:2px 0 5px 0; color:#666; font-size:11px;">
            ※ 설비의 CAPA가 존재하지 않으면 표시하지 않습니다.
        </div>
        <input type="hidden" id="d0b_checkZero" value="0" />

        <!-- 근무 요일설정 -->
        <fieldset class="div-line-new-sub" style="margin-top:5px;">
            <legend style="font-size:12px; font-weight:bold;">근무 요일설정</legend>
            <table id="d0b-weekday-table" style="width:100%; border-collapse:collapse; text-align:center;">
                <thead>
                    <tr>
                        <th style="padding:4px; font-size:11px;">월</th>
                        <th style="padding:4px; font-size:11px;">화</th>
                        <th style="padding:4px; font-size:11px;">수</th>
                        <th style="padding:4px; font-size:11px;">목</th>
                        <th style="padding:4px; font-size:11px;">금</th>
                        <th style="padding:4px; font-size:11px;">토</th>
                        <th style="padding:4px; font-size:11px;">일</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><input type="checkbox" id="d0b_monday" /></td>
                        <td><input type="checkbox" id="d0b_tuesday" /></td>
                        <td><input type="checkbox" id="d0b_wednesday" /></td>
                        <td><input type="checkbox" id="d0b_thursday" /></td>
                        <td><input type="checkbox" id="d0b_friday" /></td>
                        <td><input type="checkbox" id="d0b_saturday" /></td>
                        <td><input type="checkbox" id="d0b_sunday" /></td>
                    </tr>
                </tbody>
            </table>
        </fieldset>

        <!-- 설비 목록 -->
        <fieldset class="div-line-new-sub" style="margin-top:5px;">
            <legend style="font-size:12px; font-weight:bold;">설비 목록</legend>
            <table id="d0b-mc-grid"></table>
        </fieldset>
    </form>
</div>
