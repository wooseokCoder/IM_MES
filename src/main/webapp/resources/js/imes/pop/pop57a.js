/**
 * ============================================================================
 * 화면명: POP57A - 설비별 표준문서(검사)
 * ============================================================================
 * 설명: 설비별 표준문서(검사) 조회 + 파일 첨부
 * 원본: ProActive POP57A_M0A.cs, POP57A.cs
 * 작성일: 2026-03-12
 * ============================================================================
 */

// ============================================================================
// URL 상수
// ============================================================================
var consts = {
    url: {
        POP57A_SER: getUrl('/imes/pop/pop57a/POP57A_SER.json')
    }
};

// ============================================================================
// 화면 초기화
// ============================================================================

$(function() {
    initGrid();
    bindButtonEvents();
    acAttachFileControl.init({ uploadMenu: 'POP57A' });
});

$(window).load(function() {
    hideLoadingBar();
    doSearch();
});

// ============================================================================
// 설비 그리드 초기화
// ============================================================================
function initGrid() {
    $('#machine-grid').datagrid({
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
            {field: 'mcCode', title: '설비코드', width: 100, halign: 'center', align: 'left', sortable: true},
            {field: 'mcName', title: '설비명',   width: 200, halign: 'center', align: 'left', sortable: true}
        ]],
        onSelect: function(index, row) {
            if (row) {
                var code = row.mcCode || '';
                var displayName = row.mcName || code;
                acAttachFileControl.setLinkKey(code, displayName);
            }
        },
        onLoadSuccess: function(data) {
            $('#machine-grid').datagrid('unselectAll');
            acAttachFileControl.setLinkKey('', '(설비를 선택하세요)');
        }
    });
}

// ============================================================================
// 버튼 이벤트 바인딩
// ============================================================================
function bindButtonEvents() {
    $('#search-button').bind('click', doSearch);
}

// ============================================================================
// 조회
// ============================================================================
function doSearch() {
    var $grid = $('#machine-grid');
    $grid.datagrid('options').url = consts.url.POP57A_SER;
    $grid.datagrid('load', {});
}

// ============================================================================
// 유틸리티 함수
// ============================================================================

function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}
