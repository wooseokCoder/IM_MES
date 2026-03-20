<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)std04a_d0a.jsp 1.3 2026/02/24                                    --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2026 WSC, INC.                                           --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- D0A 팝업 콘텐츠: 표준자원 편집기 (href로 동적 로드)                    --%>
<%-- html/head/body 태그 없음, script 태그 금지                             --%>
<%-- 초기화: 메인 JS의 initD0aPopup() onLoad 콜백에서 처리                  --%>
<%-- @author 송우석                                                         --%>
<%-- @version 1.3 2026/02/24                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- hidden fields (AS-IS LayoutVisibility.Never + HiddenItems) -->
<input type="hidden" id="d_overwrite" value="0"/>
<input type="hidden" id="d_mcModel" value=""/>
<input type="hidden" id="d_mainEmpCode" value=""/>
<input type="hidden" id="d_mcMaker" value=""/>
<input type="hidden" id="d_assetNo" value=""/>
<input type="hidden" id="d_asTel" value=""/>
<input type="hidden" id="d_mcOpenDate" value=""/>
<input type="hidden" id="d_mcCloseDate" value=""/>
<input type="hidden" id="d_plcIp" value=""/>
<input type="hidden" id="d_mcIp" value=""/>
<input type="hidden" id="d_venCode" value=""/>
<input type="hidden" id="d_mcOs" value="0"/>
<input type="hidden" id="d_mcMgtFlag" value="0"/>
<input type="hidden" id="d_isSignal" value="0"/>
<input type="hidden" id="d_isOperateState" value="0"/>
<input type="hidden" id="d_signalType" value=""/>
<input type="hidden" id="d_plcPort" value=""/>
<input type="hidden" id="d_ifMcCode" value=""/>
<input type="hidden" id="d_ftpPort" value=""/>
<input type="hidden" id="d_ftpUser" value=""/>
<input type="hidden" id="d_ftpUserPw" value=""/>
<input type="hidden" id="d_ftpDir" value=""/>

<!-- 상단: 자원 정보 폼 -->
<fieldset class="div-line-new-sub">
    <table class="popup-search-table" style="table-layout:fixed; width:100%;">
        <colgroup>
            <col style="width:80px"/>
            <col style="width:43%"/>
            <col style="width:80px"/>
            <col/>
        </colgroup>
        <tr>
            <th class="h"><span>자원코드</span></th>
            <td class="d">
                <input id="d_mcCode" class="easyui-textbox" data-options="width:'100%', required:true, validType:'length[0,10]'"/>
            </td>
            <th class="h"><span>자원명</span></th>
            <td class="d">
                <input id="d_mcName" class="easyui-textbox" data-options="width:'100%', required:true, validType:'length[0,50]'"/>
            </td>
        </tr>
        <tr>
            <th class="h"><span>자원그룹</span></th>
            <td class="d">
                <input id="d_mcGroup" class="easyui-combobox"
                    data-options="width:'100%', panelHeight:'auto', editable:false, required:true"/>
            </td>
            <th class="h"><span>표시 순서</span></th>
            <td class="d">
                <input id="d_mcSeq" class="easyui-numberbox" data-options="width:'100%', min:0, max:999999999, precision:0"/>
            </td>
        </tr>
        <tr>
            <th class="h"><span>자원 구분</span></th>
            <td class="d" colspan="3">
                <div style="display:flex; align-items:center; flex-wrap:nowrap; white-space:nowrap;">
                    <label style="margin-right:15px"><input type="radio" name="d_mcFlag" value="E"/> 전동</label>
                    <label style="margin-right:15px"><input type="radio" name="d_mcFlag" value="P"/> 유압</label>
                    <label style="margin-right:20px"><input type="radio" name="d_mcFlag" value="M"/> 가공</label>
                    <label style="margin-right:15px"><input type="checkbox" id="d_isSap" value="1"/> SAP 존재여부</label>
                    <label style="margin-right:15px"><input type="checkbox" id="d_isSimGantt" value="1"/> 간트 표시여부</label>
                    <label style="margin-right:30px"><input type="checkbox" id="d_isPop" value="1"/> 실적입력 여부</label>
                    <span style="font-weight:bold; margin-right:8px;">공정</span>
                    <input id="d_procCode" class="easyui-combobox"
                        data-options="width:100, panelHeight:160, editable:false"/>
                </div>
            </td>
        </tr>
        <tr>
            <th class="h"><span>비고</span></th>
            <td class="d" colspan="3" style="height:150px">
                <span class="textbox" style="height:150px !important; width:100%;">
                    <textarea class="textbox-text" id="d_scomment" maxlength="100"
                        style="width:100%;height:100%;overflow-y:scroll;resize:none;border:none;"></textarea>
                </span>
            </td>
        </tr>
    </table>
</fieldset>

<!-- 하단: 가용사원 관리 (좌: 배정, 우: 전체) -->
<fieldset class="div-line-new-sub" style="margin-top:5px">
    <table style="width:100%; border-collapse:collapse">
        <tr>
            <td style="width:50%; vertical-align:top; padding-right:3px">
                <div style="font-weight:bold; padding:3px 5px; background:#f0f0f0; border:1px solid #ddd">
                    가용 인원
                </div>
                <table id="d0a-left-grid"></table>
            </td>
            <td style="width:50%; vertical-align:top; padding-left:3px">
                <div style="font-weight:bold; padding:3px 5px; background:#f0f0f0; border:1px solid #ddd">
                    사원 리스트
                </div>
                <table id="d0a-right-grid"></table>
            </td>
        </tr>
    </table>
</fieldset>
