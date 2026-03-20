/**
 * ============================================================================
 * 화면: REP10A - 작업자현황
 * ============================================================================
 * 작성자: 송우석
 * 작성일: 2026-03-16
 *
 * 주요 기능:
 *   1. 메인 그리드 조회 (REP10A_SER) — 검색조건 없음, 자동 조회
 *   2. (삭제됨)
 *   3. 행 색상: '중지' → 빨간 배경 + 흰 글자
 *   4. EMP_GUBUN2 → S029 코드 변환 표시
 * ============================================================================
 */

// ============================================================================
// 1. consts 객체
// ============================================================================

/** S029 코드 데이터 캐시 */
var codeDataMap = {};

var consts = {
    url: {
        REP10A_SER: getUrl('/imes/rep/rep10a/REP10A_SER.json'),
        CODE_LIST:  getUrl('/common/code/code.json')
    },

    /**
     * 코드 데이터 로드
     */
    loadCode: function(codeGrup) {
        if (codeDataMap[codeGrup]) return codeDataMap[codeGrup];
        var items = [];
        $.ajax({
            url: this.url.CODE_LIST,
            type: 'POST',
            data: { codeGrup: codeGrup },
            dataType: 'json',
            async: false,
            success: function(response) {
                items = response.rows || response || [];
            }
        });
        codeDataMap[codeGrup] = items;
        return items;
    },

    /**
     * 초기화
     */
    init: function() {
        // S029 코드 로드 (구분)
        this.loadCode('S029');

        // 버튼 이벤트 바인딩
        $('#search-button').bind('click', doSearch);

        // 그리드 초기화
        initGrid();

        // 헤더 컨텍스트 메뉴
        GridHeaderMenu('#grid1', { exportFileName: '작업자현황' });

        enableGridSortReset('#grid1');
    }
};

// ============================================================================
// 2. jQuery Ready
// ============================================================================
$(function() {
    // 500 에러 시 raw 메시지 대신 일반 메시지 표시
    $.ajaxSetup({ statusCode: { 500: function() {
        $.messager.alert('Error', '오류가 발생했습니다.', 'error');
    }}});
    consts.init();
});

// ============================================================================
// 3. window.load — 로딩바 숨기고 자동 조회
// ============================================================================
$(window).load(function() {
    hideLoadingBar();
});

// ============================================================================
// 4. 그리드 초기화
// ============================================================================
function initGrid() {
    $('#grid1').datagrid({
        fit: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        striped: false,
        fitColumns: false,
        method: 'post',
        onLoadSuccess: function(data) {
        },
        /**
         * AS-IS CustomDrawCell: '중지' 행 → 빨간 배경 + 흰 글자
         */
        rowStyler: function(index, row) {
            if (row.empStat == '중지') {
                return 'background-color:#FF0000; color:#FFFFFF;';
            }
        }
    });
}

// ============================================================================
// 5. 조회
// ============================================================================
function doSearch() {
    $('#grid1').datagrid('loading');
    $.ajax({
        url: consts.url.REP10A_SER,
        type: 'POST',
        data: {},
        dataType: 'json',
        success: function(result) {
            if (result && result.error) {
                $('#grid1').datagrid('loadData', []);
                $('#grid1').datagrid('loaded');
                return;
            }
            var rows = result.rows || result || [];
            $('#grid1').datagrid('loadData', rows);
            $('#grid1').datagrid('loaded');
        },
        error: function() {
            $('#grid1').datagrid('loadData', []);
            $('#grid1').datagrid('loaded');
        }
    });
}

// ============================================================================
// 6. 셀 병합 함수
// ============================================================================

/**
 * 동일 값 연속 행 병합
 * AS-IS: AllowCellMerge = true (DevExpress 자동 병합)
 *
 * @param {String} gridId 그리드 ID
 * @param {String} field 병합 대상 필드명
 */
function mergeCells(gridId, field) {
    var rows = $('#' + gridId).datagrid('getRows');
    if (!rows || rows.length == 0) return;

    var startIndex = 0;
    var startValue = rows[0][field];

    for (var i = 1; i <= rows.length; i++) {
        var currentValue = (i < rows.length) ? rows[i][field] : null;
        if (currentValue != startValue) {
            var span = i - startIndex;
            if (span > 1) {
                $('#' + gridId).datagrid('mergeCells', {
                    index: startIndex,
                    field: field,
                    rowspan: span,
                    colspan: 1
                });
            }
            startIndex = i;
            startValue = currentValue;
        }
    }
}

// ============================================================================
// 7. 포맷터
// ============================================================================

/**
 * S029 코드 변환 (구분)
 */
function formatS029(value) {
    if (!value && value != 0) return '';
    var items = codeDataMap['S029'] || [];
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd == value) {
            return items[i].codeName || value;
        }
    }
    return value;
}

/**
 * MEDIUM_DATE 포맷: datetime → yyyy-MM-dd 오전/오후 h:mm
 */
function formatMediumDate(value) {
    if (!value) return '';
    var s = String(value).replace(/[-:T ]/g, '');
    if (s.length < 8) return value;
    var result = s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
    if (s.length >= 12) {
        var hh = parseInt(s.substring(8, 10), 10);
        var mm = s.substring(10, 12);
        var ampm = (hh < 12) ? '오전' : '오후';
        var h12 = (hh === 0) ? 12 : (hh > 12) ? hh - 12 : hh;
        result += ' ' + ampm + ' ' + h12 + ':' + mm;
    }
    return result;
}

// ============================================================================
// 8. 유틸리티
// ============================================================================

/**
 * 로딩바 숨기기
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}
