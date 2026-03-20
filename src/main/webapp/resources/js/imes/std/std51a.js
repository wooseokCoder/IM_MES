/**
 * ============================================================================
 * 화면명: STD51A - 검사그룹
 * ============================================================================
 * 설명: 검사그룹 조회 + 파일 첨부
 * 원본: ProActive STD51A_M0A.cs, STD51A.cs
 * 작성일: 2026-03-11
 * ============================================================================
 */

// ============================================================================
// URL 상수
// ============================================================================
var consts = {
    url: {
        STD51A_SER: getUrl('/imes/std/std51a/STD51A_SER.json')
    }
};

// ============================================================================
// 전역 변수
// ============================================================================
var plants = '3605';   // 기본 공장코드 (검사)

// ============================================================================
// 화면 초기화
// ============================================================================

$(function() {
    initGrid();
    bindButtonEvents();
    acAttachFileControl.init({ uploadMenu: 'STD51A' });
});

$(window).load(function() {
    hideLoadingBar();
    doSearch();
});

// ============================================================================
// 검사그룹 그리드 초기화
// ============================================================================
function initGrid() {
    $('#ins-grp-grid').datagrid({
        method: 'post',
        fit: true,
        fitColumns: true,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: false,
        remoteSort: false,
        columns: [[
            {field: 'insGrpCode',  title: '검사그룹코드', width: 0, halign: 'center', align: 'left', hidden: true},
            {field: 'insGrpName',  title: '검사그룹명', width: 150, halign: 'center', align: 'left', sortable: true},
            {field: 'insGrpModel', title: '검사품명', width: 150, halign: 'center', align: 'left', sortable: true},
            {field: 'scomment',    title: '비고', width: 200, halign: 'center', align: 'left', sortable: true}
        ]],
        onSelect: function(index, row) {
            if (row) {
                var code = row.insGrpCode || '';
                var displayName = row.insGrpName || code;
                acAttachFileControl.setLinkKey(code, displayName);
            }
        },
        onLoadSuccess: function(data) {
            $('#ins-grp-grid').datagrid('unselectAll');
            acAttachFileControl.setLinkKey('', '(검사그룹을 선택하세요)');
        }
    });
}

// ============================================================================
// 버튼 이벤트 바인딩
// ============================================================================
function bindButtonEvents() {
    $('#search-button').bind('click', doSearch);

    $('#s_searchLike').bind('keydown', function(e) {
        if (e.keyCode === 13) {
            doSearch();
        }
    });
}

// ============================================================================
// 조회
// ============================================================================
function doSearch() {
    var $grid = $('#ins-grp-grid');
    $grid.datagrid('options').url = consts.url.STD51A_SER;
    $grid.datagrid('load', {
        plants: plants,
        searchLike: safeGetTextboxValue('#s_searchLike')
    });
}

// ============================================================================
// 유틸리티 함수
// ============================================================================

function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

function safeGetTextboxValue(selector) {
    var $elem = $(selector);
    if ($elem.length === 0) return '';

    var textboxData = $.data($elem[0], 'textbox');
    if (textboxData) {
        try {
            return $elem.textbox('getValue') || '';
        } catch (e) {
            return $elem.val() || '';
        }
    } else {
        return $elem.val() || '';
    }
}
