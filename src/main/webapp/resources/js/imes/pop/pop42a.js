/**
 * ============================================================================
 * 화면: POP42A - 일일점검 이력 조회
 * ============================================================================
 * 좌우 분할 마스터-디테일 구조 (조회 전용)
 *   좌측: 일별 점검설비 리스트 (POP42A_SER)
 *   우측: 점검 결과 (POP42A_SER2, 셀 병합)
 *
 * 작성자: 송우석
 * 작성일: 2026-03-10
 * ============================================================================
 */

// ============================================================================
// 1. consts 객체 (URL 설정 및 초기화)
// ============================================================================
var consts = {
    url: {
        /** 마스터 조회 (설비별 점검일 목록) */
        POP42A_SER:  getUrl('/imes/pop/pop42a/POP42A_SER.json'),
        /** 디테일 조회 (점검항목 상세) */
        POP42A_SER2: getUrl('/imes/pop/pop42a/POP42A_SER2.json')
    },

    /**
     * 초기화 함수
     * - 버튼 이벤트 바인딩
     * - 그리드 초기화
     */
    init: function() {
        // 점검 콤보박스 초기화 (JS 동적 생성)
        initChkDateCombo();

        // 조회 버튼 바인딩
        $('#search-button').bind('click', doSearch);

        // Enter 키 조회
        $('#search-toolbar').bind('keydown', function(e) {
            if (e.keyCode == 13) doSearch();
        });

        // 그리드 초기화
        initMasterGrid();
        initDetailGrid();
    }
};

// ============================================================================
// 2. jQuery Ready - consts 초기화
// ============================================================================
$(function() {
    // 500 에러 시 raw 메시지 대신 일반 메시지 표시
    $.ajaxSetup({ statusCode: { 500: function() {
        $.messager.alert('Error', '오류가 발생했습니다.', 'error');
    }}});
    consts.init();
});

// ============================================================================
// 3. window.load - 로딩바 숨김, 날짜 기본값 설정
// ============================================================================
$(window).load(function() {
    // 날짜 기본값 설정 (7일전 ~ 당일)
    initDefaultDate();
    GridHeaderMenu('#master-grid', { exportFileName: '일일점검이력조회_설비' });
    GridHeaderMenu('#detail-grid', { exportFileName: '일일점검이력조회_점검항목' });
    enableGridSortReset('#master-grid');
    enableGridSortReset('#detail-grid');
    hideLoadingBar();
});

// ============================================================================
// 4. 마스터 그리드 초기화
// ============================================================================
/**
 * 좌측 마스터 그리드 초기화 (일별 점검설비 리스트)
 * - 단일 선택, 페이징 없음
 * - 행 클릭 시 우측 디테일 조회
 */
function initMasterGrid() {
    $('#master-grid').datagrid({
        fit: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        striped: true,
        /**
         * 행 클릭 시 디테일 조회
         */
        onClickRow: function(index, row) {
            doSearchDetail(row);
            updateDetailTitle(row);
        },
        /**
         * 데이터 로드 완료 시 첫 행 자동 선택 + 디테일 조회
         */
        onLoadSuccess: function(data) {
            var rows = $('#master-grid').datagrid('getRows');
            if (rows && rows.length > 0) {
                $('#master-grid').datagrid('selectRow', 0);
                doSearchDetail(rows[0]);
                updateDetailTitle(rows[0]);
            } else {
                $('#detail-grid').datagrid('loadData', []);
                updateDetailTitle(null);
            }
        }
    });
}

// ============================================================================
// 5. 디테일 그리드 초기화
// ============================================================================
/**
 * 우측 디테일 그리드 초기화 (점검 결과)
 * - 셀 병합: MDCR_TYPE, MDCR_CONTENTS
 * - 읽기 전용
 */
function initDetailGrid() {
    $('#detail-grid').datagrid({
        fit: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: false,
        striped: true,
        /**
         * 데이터 로드 완료 시 셀 병합 처리
         */
        onLoadSuccess: function(data) {
            $('#detail-grid').datagrid('unselectAll');
            mergeDetailCells();
        }
    });
}

// ============================================================================
// 6. 마스터 조회 (POP42A_SER)
// ============================================================================
/**
 * 마스터 그리드 조회 (설비별 점검일 목록)
 * 검색 조건: 설비명 LIKE, 점검일 범위
 */
function doSearch() {
    var chkValues = $('#s_chkDate').combobox('getValues');
    var chkDate = false;
    for (var i = 0; i < chkValues.length; i++) {
        if (chkValues[i] === 'MDCR_DATE') { chkDate = true; break; }
    }
    var mdcrMcLike = $('#s_mdcrMcLike').textbox('getText');
    var params = { mdcrMcLike: mdcrMcLike };

    if (chkDate) {
        var sMdcrDate = $('#s_sMdcrDate').datebox('getValue');
        var eMdcrDate = $('#s_eMdcrDate').datebox('getValue');
        if (!sMdcrDate || !eMdcrDate) {
            $.messager.alert('알림', '점검일 범위를 선택해주세요.');
            return;
        }
        params.sMdcrDate = sMdcrDate.replace(/-/g, '');
        params.eMdcrDate = eMdcrDate.replace(/-/g, '');
    }

    $('#master-grid').datagrid('loading');
    $.ajax({
        url: consts.url.POP42A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#master-grid').datagrid('loadData', rows);
            $('#master-grid').datagrid('loaded');
        },
        error: function(xhr, status, error) {
            $('#master-grid').datagrid('loaded');
        }
    });
}

// ============================================================================
// 7. 디테일 조회 (POP42A_SER2)
// ============================================================================
/**
 * 디테일 그리드 조회 (점검항목 상세)
 * 마스터 행 선택 시 호출
 *
 * @param {Object} row 마스터 그리드에서 선택된 행 (mdcrMcCode, mdcrDate)
 */
function doSearchDetail(row) {
    if (!row) return;

    $('#detail-grid').datagrid('loading');
    $.ajax({
        url: consts.url.POP42A_SER2,
        type: 'POST',
        data: {
            mdcrMcCode: row.mdcrMcCode,
            mdcrDate: row.mdcrDate
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#detail-grid').datagrid('loadData', rows);
            $('#detail-grid').datagrid('loaded');
        },
        error: function() {
            $('#detail-grid').datagrid('loaded');
        }
    });
}

// ============================================================================
// 8. 셀 병합 처리
// ============================================================================
/**
 * 디테일 그리드 셀 병합 (MDCR_TYPE, MDCR_CONTENTS)
 * 같은 값이 연속된 행을 세로 병합
 */
function mergeDetailCells() {
    var rows = $('#detail-grid').datagrid('getRows');
    if (!rows || rows.length === 0) return;

    // MDCR_TYPE 병합
    mergeCellsByField('detail-grid', 'mdcrType', rows);
    // MDCR_CONTENTS 병합
    mergeCellsByField('detail-grid', 'mdcrContents', rows);
}

/**
 * 범용 셀 병합 유틸
 * 같은 값이 연속된 행을 세로(rowspan) 병합
 *
 * @param {String} gridId 그리드 ID (# 제외)
 * @param {String} field 병합 대상 필드명
 * @param {Array} rows 그리드 행 배열
 */
function mergeCellsByField(gridId, field, rows) {
    var start = 0;
    for (var i = 1; i <= rows.length; i++) {
        if (i < rows.length && rows[i][field] === rows[start][field]) {
            continue;
        }
        var span = i - start;
        if (span > 1) {
            $('#' + gridId).datagrid('mergeCells', {
                index: start,
                field: field,
                rowspan: span
            });
        }
        start = i;
    }
}

// ============================================================================
// 9. 포맷터 (Formatter)
// ============================================================================

/**
 * 날짜 포맷터 (yyyyMMdd → yyyy-MM-dd)
 *
 * @param {String} value yyyyMMdd 형식
 * @returns {String} yyyy-MM-dd 형식
 */
function formatDate8(value) {
    if (!value) return '';
    var s = String(value).replace(/[-]/g, '');
    if (s.length < 8) return value;
    return s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
}

// ============================================================================
// 10. 유틸리티 함수
// ============================================================================

/**
 * 날짜 기본값 설정 (7일전 ~ 당일)
 */
function initDefaultDate() {
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);

    $('#s_sMdcrDate').datebox('setValue', dateToStr(weekAgo));
    $('#s_eMdcrDate').datebox('setValue', dateToStr(today));
}

/**
 * 점검 콤보박스 초기화
 * - 체크박스 포맷터 (AS-IS CheckedComboBoxEdit 대응)
 * - "모두선택"은 values에 포함하되 텍스트 표시에서 제외
 * - 기본값: "점검" 체크
 */
function initChkDateCombo() {
    var realItems = ['MDCR_DATE'];
    var isUpdating = false;

    $('#s_chkDate').combobox({
        width: 100,
        editable: false,
        panelHeight: 'auto',
        multiple: true,
        separator: ',',
        valueField: 'id',
        textField: 'text',
        data: [{id:'ALL',text:'모두선택'},{id:'MDCR_DATE',text:'점검'}],
        formatter: function(row) {
            return '<input type="checkbox" style="vertical-align:middle; margin-right:4px;">' + row.text;
        },
        onSelect: function(rec) {
            if (isUpdating) return;
            isUpdating = true;
            if (rec.id === 'ALL') {
                // 모두선택: ALL + 실제 항목 전부 선택
                $('#s_chkDate').combobox('setValues', ['ALL'].concat(realItems));
            } else {
                // 개별 선택: 실제 항목 전부 선택됐으면 ALL도 자동 추가
                var vals = $('#s_chkDate').combobox('getValues');
                if (isAllRealSelected(vals, realItems) && !containsValue(vals, 'ALL')) {
                    vals.push('ALL');
                    $('#s_chkDate').combobox('setValues', vals);
                }
            }
            updateChkText();
            isUpdating = false;
            toggleDateEnabled();
            syncChkPanel();
        },
        onUnselect: function(rec) {
            if (isUpdating) return;
            isUpdating = true;
            if (rec.id === 'ALL') {
                // 모두선택 해제: 전부 해제
                $('#s_chkDate').combobox('setValues', []);
            } else {
                // 개별 해제: ALL 제거
                var vals = $('#s_chkDate').combobox('getValues');
                var newVals = [];
                for (var i = 0; i < vals.length; i++) {
                    if (vals[i] !== 'ALL') newVals.push(vals[i]);
                }
                $('#s_chkDate').combobox('setValues', newVals);
            }
            updateChkText();
            isUpdating = false;
            toggleDateEnabled();
            syncChkPanel();
        },
        onShowPanel: function() {
            syncChkPanel();
        }
    });

    // 초기값: "점검" 선택 (AS-IS 고정)
    var initVals = ['MDCR_DATE'];
    // 실제 항목 전부 선택 시 "모두선택"도 자동 체크
    if (isAllRealSelected(initVals, realItems)) {
        initVals = ['ALL'].concat(initVals);
    }
    $('#s_chkDate').combobox('setValues', initVals);
    updateChkText();
}

/**
 * 콤보박스 텍스트를 실제 항목명만 표시 ("모두선택" 제외)
 */
function updateChkText() {
    var vals = $('#s_chkDate').combobox('getValues');
    var data = $('#s_chkDate').combobox('getData');
    var texts = [];
    for (var i = 0; i < data.length; i++) {
        if (data[i].id !== 'ALL' && containsValue(vals, data[i].id)) {
            texts.push(data[i].text);
        }
    }
    $('#s_chkDate').combobox('setText', texts.join(', '));
}

/**
 * 드롭다운 체크박스 상태를 현재 선택값과 동기화
 */
function syncChkPanel() {
    var vals = $('#s_chkDate').combobox('getValues');
    var data = $('#s_chkDate').combobox('getData');
    var $panel = $('#s_chkDate').combobox('panel');

    $panel.find('.combobox-item').each(function(idx) {
        if (idx < data.length) {
            var checked = containsValue(vals, data[idx].id);
            $(this).find('input[type=checkbox]').prop('checked', checked);
        }
    });
}

/** 배열에 값 포함 여부 (indexOf 대체 — IE 호환) */
function containsValue(arr, val) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] === val) return true;
    }
    return false;
}

/** 실제 항목이 전부 선택됐는지 확인 */
function isAllRealSelected(vals, realItems) {
    for (var i = 0; i < realItems.length; i++) {
        if (!containsValue(vals, realItems[i])) return false;
    }
    return true;
}

/**
 * 점검 콤보 선택 여부에 따라 날짜 활성/비활성
 */
function toggleDateEnabled() {
    var vals = $('#s_chkDate').combobox('getValues');
    var hasDate = false;
    for (var i = 0; i < vals.length; i++) {
        if (vals[i] === 'MDCR_DATE') { hasDate = true; break; }
    }
    if (hasDate) {
        $('#s_sMdcrDate').datebox('enable');
        $('#s_eMdcrDate').datebox('enable');
    } else {
        $('#s_sMdcrDate').datebox('disable');
        $('#s_eMdcrDate').datebox('disable');
    }
}

/**
 * Date 객체를 yyyy-MM-dd 문자열로 변환
 *
 * @param {Date} dt 날짜 객체
 * @returns {String} yyyy-MM-dd 형식 문자열
 */
function dateToStr(dt) {
    var mm = dt.getMonth() + 1;
    var dd = dt.getDate();
    return dt.getFullYear() + '-' + (mm < 10 ? '0' : '') + mm + '-' + (dd < 10 ? '0' : '') + dd;
}

/**
 * 디테일 패널 제목 갱신
 *
 * @param {Object} row 마스터 그리드 선택 행 (mdcrMcName, mdcrDate)
 */
function updateDetailTitle(row) {
    var title = '점검 결과';
    if (row) {
        var dateStr = formatDate8(row.mdcrDate);
        title = '점검결과 - ' + (row.mdcrMcName || '') + ' / ' + dateStr;
    }
    $('#detail-panel').panel('setTitle', title);
}

/**
 * 로딩바 숨기기 + 레이아웃 표시
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}
