/**
 * ============================================================================
 * 화면: ORD06A - 생산오더 확정 관리
 * ============================================================================
 * 원본: ProActive ORD06A_M0A.cs
 * 작성일: 2026-02-24
 *
 * 주요 기능:
 *   1. 작업지시 조회 (ORD06A_SER)
 *   2. 계획시간/설비 저장 (ORD06A_UPD2)
 *   3. 확정 (ORD06A_UPD, woFlag=1)
 *   4. 확정 취소 (ORD06A_UPD, woFlag=0)
 *   5. 확정 이력 보기 (ORD06A_SER2)
 * ============================================================================
 */

// ============================================================================
// 1. editCell 확장 (셀 단위 편집용)
// ============================================================================
$.extend($.fn.datagrid.methods, {
    editCell: function(jq, param) {
        return jq.each(function() {
            var fields = $(this).datagrid('getColumnFields', true)
                         .concat($(this).datagrid('getColumnFields'));
            for (var i = 0; i < fields.length; i++) {
                var col = $(this).datagrid('getColumnOption', fields[i]);
                col._editor = col.editor;
                if (fields[i] !== param.field) {
                    col.editor = null;
                }
            }
            $(this).datagrid('beginEdit', param.index);
            for (var i = 0; i < fields.length; i++) {
                var col = $(this).datagrid('getColumnOption', fields[i]);
                col.editor = col._editor;
            }
        });
    }
});

// ============================================================================
// 2. 전역 변수
// ============================================================================
var editIndex = undefined;
var editField = undefined;
var machineData = [];       // 설비 콤보 데이터
var gridData = [];          // 그리드 데이터 (원본 참조)
var originalData = [];      // 조회 시점 스냅샷 (변경 감지용)

// WO_FLAG 상태 색상 매핑
var woFlagColors = {
    '0': '#D3D3D3',    // 미확정 (LightGray)
    '1': '#D4EDF7',    // 확정 (SkyBlue)
    '2': '#FF6347',    // 진행 (Tomato)
    '3': '#FFFF00',    // 중지 (Yellow)
    '4': '#00FF00'     // 완료 (Green)
};

// WO_FLAG 상태명 매핑
var woFlagNames = {
    '0': '미확정',
    '1': '확정',
    '2': '진행',
    '3': '정지',
    '4': '완료'
};

// ============================================================================
// 3. consts 객체
// ============================================================================
var consts = {
    url: {
        ORD06A_MC:   getUrl('/imes/ord/ord06a/ORD06A_MC.json'),
        ORD06A_SER:  getUrl('/imes/ord/ord06a/ORD06A_SER.json'),
        ORD06A_UPD2: getUrl('/imes/ord/ord06a/ORD06A_UPD2.json'),
        ORD06A_UPD:  getUrl('/imes/ord/ord06a/ORD06A_UPD.json'),
        ORD06A_SER2: getUrl('/imes/ord/ord06a/ORD06A_SER2.json')
    },

    init: function() {
        // 버튼 바인딩
        $('#search-button').bind('click', doSearch);
        $('#btn-save-plan').bind('click', doSavePlan);
        $('#btn-confirm').bind('click', doConfirm);
        $('#btn-unconfirm').bind('click', doUnconfirm);
        $('#btn-history').bind('click', doViewHistory);

        // 설비 목록 로딩 (동기)
        loadMachineData();

        // 그리드 초기화
        initGrid();

        // 이력 그리드 초기화
        initHistoryGrid();
    }
};

// ============================================================================
// 4. 초기화
// ============================================================================
$(function() {
    consts.init();
});

$(window).load(function() {
    // 날짜 초기값: 시작일 = 오늘-7일, 종료일 = 오늘
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);
    $('#s_startDate').datebox('setValue', formatDate(weekAgo));
    $('#s_endDate').datebox('setValue', formatDate(today));

    hideLoadingBar();
    bindEnterKey('s_modelLike');
    bindEnterKey('s_procLike');
    bindEnterKey('s_partLike');
    bindEnterKey('s_sapWoLike');
});

// ============================================================================
// 5. 설비 데이터 로딩
// ============================================================================
function loadMachineData() {
    $.ajax({
        url: consts.url.ORD06A_MC,
        type: 'POST',
        dataType: 'json',
        async: false,
        success: function(result) {
            machineData = result.rows || [];
        },
        error: function() {
            machineData = [];
        }
    });
}

// ============================================================================
// 6. 그리드 초기화
// ============================================================================
function initGrid() {
    var columns = [
        // hidden: WO_NO (키 컬럼)
        { field: 'woNo', title: '지시번호', hidden: true },
        // hidden: PROD_CODE
        { field: 'prodCode', title: 'prodCode', hidden: true },
        // 생산오더 (셀 머지)
        { field: 'sapWoNo', title: '생산오더', width: 140, halign: 'center', align: 'left' },
        // 고객명 (편집 가능)
        { field: 'mctVenName', title: '고객명', width: 120, halign: 'center', align: 'left',
          editor: { type: 'textbox' },
          styler: editableCellStyler
        },
        // MODEL (셀 머지)
        { field: 'model', title: 'MODEL', width: 100, halign: 'center', align: 'center' },
        // 부품코드 (셀 머지)
        { field: 'partCode', title: '부품코드', width: 120, halign: 'center', align: 'left' },
        // 부품명 (셀 머지)
        { field: 'partName', title: '부품명', width: 150, halign: 'center', align: 'left' },
        // 순번
        { field: 'woSeq', title: '순번', width: 50, halign: 'center', align: 'left' },
        // 공정선택 (체크박스)
        { field: 'sel', title: '공정선택', width: 60, halign: 'center', align: 'center',
          formatter: formatSelCheckbox,
          styler: editableCellStyler
        },
        // 작업지시 확정일
        { field: 'confirmDate', title: '작업지시<br>확정일', width: 100, halign: 'center', align: 'center',
          formatter: formatShortDate
        },
        // 공정
        { field: 'procCode', title: '공정', width: 80, halign: 'center', align: 'center' },
        // 자원 (콤보 편집)
        { field: 'mcCode', title: '자원', width: 120, halign: 'center', align: 'center',
          editor: {
              type: 'combobox',
              options: {
                  data: machineData,
                  valueField: 'mcCode',
                  textField: 'mcDisp',
                  panelHeight: 'auto',
                  editable: false
              }
          },
          formatter: formatMcCode,
          styler: editableCellStyler
        },
        // 작업상세내역
        { field: 'scomment', title: '작업상세내역', width: 150, halign: 'center', align: 'left' },
        // 실적 시작
        { field: 'actStartTime', title: '실적 시작', width: 110, halign: 'center', align: 'center',
          formatter: formatShortDate
        },
        // 실적 종료
        { field: 'actEndTime', title: '실적 종료', width: 110, halign: 'center', align: 'center',
          formatter: formatShortDate
        },
        // 실적 ST(분)
        { field: 'actSt', title: '실적 ST(분)', width: 80, halign: 'center', align: 'right',
          formatter: formatQty
        },
        // 상태 (WO_FLAG)
        { field: 'woFlag', title: '상태', width: 60, halign: 'center', align: 'center',
          formatter: formatWoFlag,
          styler: woFlagStyler
        },
        // 계획 시작 (편집 가능 - 날짜 선택)
        { field: 'plnStartTime', title: '계획 시작', width: 110, halign: 'center', align: 'center',
          editor: { type: 'datebox', options: { editable: true } },
          formatter: formatShortDate,
          styler: editableCellStyler
        },
        // 계획 종료 (편집 가능 - 날짜 선택)
        { field: 'plnEndTime', title: '계획 종료', width: 110, halign: 'center', align: 'center',
          editor: { type: 'datebox', options: { editable: true } },
          formatter: formatShortDate,
          styler: editableCellStyler
        },
        // 계획 ST(분)
        { field: 'plnProcTime', title: '계획 ST(분)', width: 80, halign: 'center', align: 'right',
          formatter: formatQty
        }
    ];

    $('#search-grid').datagrid({
        columns: [columns],
        fit: true,
        fitColumns: false,
        striped: false,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        toolbar: '#search-toolbar',
        onClickCell: onClickCell,
        onEndEdit: onEndEdit,
        onLoadSuccess: function(data) {
            $('#search-grid').datagrid('unselectAll');
        }
    });
    GridHeaderMenu('#search-grid', { exportFileName: '생산오더확정' });
    enableGridSortReset('#search-grid');
}

// ============================================================================
// 7. 이력 그리드 초기화
// ============================================================================
function initHistoryGrid() {
    $('#history-grid').datagrid({
        columns: [[
            { field: 'woNo', title: '지시번호', width: 120, halign: 'center', align: 'left' },
            { field: 'procCode', title: '공정코드', width: 80, halign: 'center', align: 'center' },
            { field: 'procName', title: '공정명', width: 120, halign: 'center', align: 'left' },
            { field: 'woFlag', title: '상태', width: 60, halign: 'center', align: 'center',
              formatter: formatWoFlag
            },
            { field: 'mdfyDate', title: '처리일시', width: 140, halign: 'center', align: 'center' },
            { field: 'mdfyEmp', title: '처리자', width: 80, halign: 'center', align: 'center' }
        ]],
        fit: true,
        fitColumns: true,
        striped: true,
        singleSelect: true,
        rownumbers: true
    });
    GridHeaderMenu('#history-grid', { exportFileName: '확정이력' });
    enableGridSortReset('#history-grid');
}

// ============================================================================
// 8. 조회 (ORD06A_SER)
// ============================================================================
function doSearch() {
    endEditing();
    $('#search-grid').datagrid('loading');

    var dateTypes = $('#s_dateType').combobox('getValues') || [];
    var chkPln = dateTypes.indexOf('PLN') >= 0;
    var chkReg = dateTypes.indexOf('REG') >= 0;
    var startDate = $('#s_startDate').datebox('getValue') || '';
    var endDate = $('#s_endDate').datebox('getValue') || '';

    // 날짜 형식 변환: yyyy-MM-dd → yyyyMMdd
    var sDate = startDate.replace(/-/g, '');
    var eDate = endDate.replace(/-/g, '');

    var params = {
        modelLike:  $('#s_modelLike').textbox('getValue'),
        procLike:   $('#s_procLike').textbox('getValue'),
        partLike:   $('#s_partLike').textbox('getValue'),
        sapWoLike:  $('#s_sapWoLike').textbox('getValue'),
        sPlnDate:   chkPln ? sDate : '',
        ePlnDate:   chkPln ? eDate : '',
        sRegDate:   chkReg ? sDate : '',
        eRegDate:   chkReg ? eDate : '',
        isZero:     $('#s_isZero').is(':checked') ? '1' : '0'
    };

    $.ajax({
        url: consts.url.ORD06A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            gridData = result.rows || [];

            // SEL 컬럼 초기화 (계획시간은 원본 yyyyMMddHHmm 유지)
            for (var i = 0; i < gridData.length; i++) {
                gridData[i].sel = '0';
            }

            // 원본 스냅샷 저장 (변경 감지용)
            originalData = JSON.parse(JSON.stringify(gridData));

            // 데이터 로딩
            $('#search-grid').datagrid('loadData', gridData);
            $('#search-grid').datagrid('loaded');
        },
        error: function() {
            $('#search-grid').datagrid('loaded');
            $.messager.alert(getTitle('ERROR'), '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 9. 계획 저장 (ORD06A_UPD2)
// ============================================================================
function doSavePlan() {
    endEditing();

    // 변경된 행 수집 (PLN_START_TIME, PLN_END_TIME, MC_CODE, MCT_VEN_NAME)
    var rows = [];
    var allRows = $('#search-grid').datagrid('getRows');

    for (var i = 0; i < allRows.length; i++) {
        var curr = allRows[i];
        var orig = originalData[i];

        if (!orig) continue;

        var changed = false;
        if (curr.plnStartTime !== orig.plnStartTime) changed = true;
        if (curr.plnEndTime !== orig.plnEndTime) changed = true;
        if (curr.mcCode !== orig.mcCode) changed = true;
        if (curr.mctVenName !== orig.mctVenName) changed = true;

        if (changed) {
            rows.push({
                woNo:         curr.woNo,
                sapWoNo:      curr.sapWoNo,
                plnStartTime: toDbDateTime(curr.plnStartTime),
                plnEndTime:   toDbDateTime(curr.plnEndTime),
                mcCode:       curr.mcCode || '',
                mctVenName:   curr.mctVenName || ''
            });
        }
    }

    if (rows.length === 0) {
        $.messager.alert(getTitle('ALERT'), '변경된 데이터가 없습니다.', 'info');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), rows.length + '건을 저장하시겠습니까?', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.ORD06A_UPD2,
            type: 'POST',
            data: {
                models: JSON.stringify(rows)
            },
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert(getTitle('INFO'), result.success, 'info');
                    doSearch();
                } else {
                    $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
                }
            },
            error: function() {
                $.messager.alert(getTitle('ERROR'), '저장 중 오류가 발생했습니다.', 'error');
            }
        });
    });
}

// ============================================================================
// 10. 확정 (ORD06A_UPD, woFlag=1)
// ============================================================================
function doConfirm() {
    doConfirmAction('1', '확정');
}

// ============================================================================
// 11. 확정 취소 (ORD06A_UPD, woFlag=0)
// ============================================================================
function doUnconfirm() {
    doConfirmAction('0', '확정 취소');
}

/**
 * 확정/확정취소 공통 처리
 * @param woFlag '1'=확정, '0'=확정취소
 * @param actionName 액션명 (메시지용)
 */
function doConfirmAction(woFlag, actionName) {
    endEditing();

    // SEL 체크된 행 수집
    var allRows = $('#search-grid').datagrid('getRows');
    var rows = [];

    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel === '1') {
            rows.push({
                woNo:         allRows[i].woNo,
                procCode:     allRows[i].procCode || '',
                prodCode:     allRows[i].prodCode || '',
                sapWoNo:      allRows[i].sapWoNo || '',
                plnStartTime: toDbDateTime(allRows[i].plnStartTime),
                plnEndTime:   toDbDateTime(allRows[i].plnEndTime),
                mcCode:       allRows[i].mcCode || ''
            });
        }
    }

    // AS-IS: 체크된 행 없으면 현재 선택된 행 사용
    if (rows.length === 0) {
        var selected = $('#search-grid').datagrid('getSelected');
        if (!selected) return;
        rows.push({
            woNo:         selected.woNo,
            procCode:     selected.procCode || '',
            prodCode:     selected.prodCode || '',
            sapWoNo:      selected.sapWoNo || '',
            plnStartTime: toDbDateTime(selected.plnStartTime),
            plnEndTime:   toDbDateTime(selected.plnEndTime),
            mcCode:       selected.mcCode || ''
        });
    }

    $.messager.confirm(getTitle('CONFIRM'), rows.length + '건을 ' + actionName + ' 하시겠습니까?', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.ORD06A_UPD,
            type: 'POST',
            data: {
                models: JSON.stringify(rows),
                woFlag: woFlag
            },
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert(getTitle('INFO'), result.success, 'info');
                    doSearch();
                } else {
                    $.messager.alert(getTitle('ERROR'), result.error || actionName + ' 실패', 'error');
                }
            },
            error: function() {
                $.messager.alert(getTitle('ERROR'), actionName + ' 중 오류가 발생했습니다.', 'error');
            }
        });
    });
}

// ============================================================================
// 12. 확정 이력 보기 (ORD06A_SER2)
// ============================================================================
function doViewHistory() {
    endEditing();

    var selected = $('#search-grid').datagrid('getSelected');
    if (!selected) {
        $.messager.alert(getTitle('ALERT'), '작업지시를 선택해 주세요.', 'info');
        return;
    }

    $.ajax({
        url: consts.url.ORD06A_SER2,
        type: 'POST',
        data: {
            woNo: selected.woNo
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#history-grid').datagrid('loadData', rows);
            
            $('#history-dialog').dialog({onOpen: function() {
                $(this).css('visibility', '');
                $('#history-buttons').css('visibility', '');
                $(this).dialog('center');
            }});
            
            $('#history-dialog').dialog('setTitle', '확정이력 - ' + selected.woNo);
            $('#history-dialog').dialog('open');
        },
        error: function() {
            $.messager.alert(getTitle('ERROR'), '이력 조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 13. 셀 편집 핸들러
// ============================================================================
function onClickCell(index, field) {
    // 편집 가능 컬럼만 편집 허용
    if (field === 'sel') {
        // 체크박스는 formatter에서 직접 처리
        return;
    }

    var col = $('#search-grid').datagrid('getColumnOption', field);
    if (!col || !col.editor) return;

    if (editIndex !== index || editField !== field) {
        if (endEditing()) {
            // datebox 에디터: 원본 yyyyMMddHHmm → yyyy-MM-dd 변환 후 편집 시작
            if (field === 'plnStartTime' || field === 'plnEndTime') {
                var rows = $('#search-grid').datagrid('getRows');
                rows[index]['_' + field] = rows[index][field]; // 원본 백업
                rows[index][field] = toShortDateStr(rows[index][field]);
            }

            $('#search-grid').datagrid('selectRow', index);
            $('#search-grid').datagrid('editCell', { index: index, field: field });
            editIndex = index;
            editField = field;

            var ed = $('#search-grid').datagrid('getEditor', { index: index, field: field });
            if (ed) {
                ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
            }
        }
    }
}

function endEditing() {
    if (editIndex === undefined) return true;
    if ($('#search-grid').datagrid('validateRow', editIndex)) {
        $('#search-grid').datagrid('endEdit', editIndex);
        editIndex = undefined;
        editField = undefined;
        return true;
    }
    return false;
}

function onEndEdit(index, row, changes) {
    // 계획시작: 사용자가 날짜를 변경했는지 확인
    if (changes.plnStartTime !== undefined) {
        var backup = row['_plnStartTime'];
        if (backup && toShortDateStr(backup) === changes.plnStartTime) {
            // 동일 날짜 → 원본(시간 포함) 복원
            row.plnStartTime = backup;
        }
        // 변경된 경우: 계획 종료 자동 계산 (ST 분 단위 가산)
        if (backup && toShortDateStr(backup) !== changes.plnStartTime && row.plnProcTime) {
            var procTime = parseInt(row.plnProcTime) || 0;
            if (procTime > 0 && changes.plnStartTime) {
                row.plnEndTime = addMinutes(changes.plnStartTime, procTime);
            }
        }
        delete row['_plnStartTime'];
    } else if (row['_plnStartTime']) {
        // 편집 시작했지만 변경 없이 종료 → 원본 복원
        row.plnStartTime = row['_plnStartTime'];
        delete row['_plnStartTime'];
    }

    // 계획종료: 사용자가 날짜를 변경했는지 확인
    if (changes.plnEndTime !== undefined) {
        var backup = row['_plnEndTime'];
        if (backup && toShortDateStr(backup) === changes.plnEndTime) {
            row.plnEndTime = backup;
        }
        delete row['_plnEndTime'];
    } else if (row['_plnEndTime']) {
        row.plnEndTime = row['_plnEndTime'];
        delete row['_plnEndTime'];
    }

    $('#search-grid').datagrid('refreshRow', index);
}

// ============================================================================
// 15. 포맷터
// ============================================================================

/**
 * 편집 가능 셀 배경색 (연노랑)
 */
function editableCellStyler(value, row, index) {
    return 'background-color:#FFFFCC;';
}

/**
 * 공정선택 체크박스 포맷터
 */
function formatSelCheckbox(value, row, index) {
    var checked = (value === '1') ? 'checked="checked"' : '';
    return '<input type="checkbox" ' + checked + ' onclick="toggleSel(' + index + ', this)" />';
}

/**
 * SEL 토글
 */
function toggleSel(index, checkbox) {
    var rows = $('#search-grid').datagrid('getRows');
    rows[index].sel = checkbox.checked ? '1' : '0';
}

/**
 * SHORT_DATE 포맷터 (yyyyMMdd[HHmm] → yyyy-MM-dd)
 */
function formatShortDate(value) {
    if (!value) return '';
    var s = String(value).replace(/[-: ]/g, '');
    if (s.length < 8) return value;
    return s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
}

/**
 * 날짜/시간 포맷터 (yyyyMMddHHmm[ss] → yyyy-MM-dd HH:mm)
 */
function formatDateTime(value) {
    if (!value) return '';
    var s = String(value).replace(/[-: ]/g, '');
    if (s.length < 8) return value;
    var result = s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
    if (s.length >= 12) {
        result += ' ' + s.substring(8, 10) + ':' + s.substring(10, 12);
    } else if (s.length >= 10) {
        result += ' ' + s.substring(8, 10) + ':00';
    }
    return result;
}

/**
 * QTY 숫자 포맷터 (#,##0 콤마 구분)
 */
function formatQty(value) {
    if (value === null || value === undefined || value === '') return '';
    var num = Number(value);
    if (isNaN(num)) return value;
    return num.toLocaleString('en-US', { maximumFractionDigits: 0 });
}

/**
 * WO_FLAG 포맷터 (텍스트만 반환)
 */
function formatWoFlag(value) {
    return woFlagNames[String(value)] || value || '';
}

/**
 * WO_FLAG 셀 배경색 styler
 */
function woFlagStyler(value) {
    var color = woFlagColors[String(value)];
    if (color) {
        return 'background-color:' + color + ';';
    }
}

/**
 * MC_CODE 포맷터 (mcCode → mcDisp)
 */
function formatMcCode(value) {
    if (!value) return '';
    for (var i = 0; i < machineData.length; i++) {
        if (machineData[i].mcCode === value) {
            return machineData[i].mcDisp || value;
        }
    }
    return value;
}

// ============================================================================
// 16. 유틸리티
// ============================================================================

/**
 * 시간 가산 (yyyyMMddHHmm, yyyy-MM-dd HH:mm, yyyy-MM-dd 형식 + 분)
 */
function addMinutes(dateStr, minutes) {
    if (!dateStr) return '';
    var s = String(dateStr).replace(/[-: ]/g, '');
    // 날짜만 있는 경우 (8자리) 00:00 기준으로 처리
    if (s.length === 8) s += '0000';
    if (s.length < 12) return dateStr;

    var y = parseInt(s.substring(0, 4));
    var m = parseInt(s.substring(4, 6)) - 1;
    var d = parseInt(s.substring(6, 8));
    var h = parseInt(s.substring(8, 10));
    var mi = parseInt(s.substring(10, 12));

    var dt = new Date(y, m, d, h, mi);
    dt.setMinutes(dt.getMinutes() + minutes);

    var ry = dt.getFullYear();
    var rm = pad2(dt.getMonth() + 1);
    var rd = pad2(dt.getDate());
    var rh = pad2(dt.getHours());
    var rmi = pad2(dt.getMinutes());

    // 항상 yyyy-MM-dd HH:mm 형식으로 반환 (시간 포함)
    if (dateStr.indexOf('-') >= 0) {
        return ry + '-' + rm + '-' + rd + ' ' + rh + ':' + rmi;
    }
    return '' + ry + rm + rd + rh + rmi;
}

function pad2(n) {
    return (n < 10 ? '0' : '') + n;
}

/**
 * yyyy-MM-dd → yyyyMMdd0000 변환 (DB 저장용, AS-IS 형식)
 * 이미 yyyyMMddHHmm 형식이면 그대로 반환
 */
function toDbDateTime(val) {
    if (!val) return '';
    var s = String(val).replace(/[-: ]/g, '');
    if (s.length >= 12) return s.substring(0, 12);  // 이미 yyyyMMddHHmm
    if (s.length >= 8) return s.substring(0, 8) + '0000';  // yyyyMMdd → yyyyMMdd0000
    return val;
}

/**
 * yyyyMMddHHmm → yyyy-MM-dd 변환 (datebox 값 호환)
 */
function toShortDateStr(val) {
    if (!val) return '';
    var s = String(val).replace(/[-: ]/g, '');
    if (s.length < 8) return val;
    return s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
}

/**
 * Date → YYYY-MM-DD 문자열 (전역 datebox 포맷)
 */
function formatDate(dt) {
    return dt.getFullYear() + '-' + pad2(dt.getMonth() + 1) + '-' + pad2(dt.getDate());
}

/**
 * 로딩바 숨기기 + 레이아웃 표시
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

/**
 * 텍스트박스 Enter 키 바인딩
 */
function bindEnterKey(id) {
    var $tb = $('#' + id);
    if ($tb.length === 0) return;
    $tb.textbox('textbox').bind('keyup', function(e) {
        $tb.textbox('setValue', $(this).val());
    });
    $tb.textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode === 13) {
            $tb.textbox('setValue', $(this).val());
            doSearch();
        }
    });
}

/**
 * 다국어 타이틀 가져오기
 */
function getTitle(key) {
    if (typeof tit !== 'undefined') {
        switch (key) {
            case 'ALERT':   return tit.TITLE0001 || '알림';
            case 'INFO':    return (typeof msg !== 'undefined' && msg.MSG0052) || '정보';
            case 'ERROR':   return (typeof msg !== 'undefined' && msg.MSG0068) || '오류';
            case 'CONFIRM': return (typeof msg !== 'undefined' && msg.MSG0053) || '확인';
        }
    }
    switch (key) {
        case 'ALERT':   return '알림';
        case 'INFO':    return '정보';
        case 'ERROR':   return '오류';
        case 'CONFIRM': return '확인';
        default:        return key;
    }
}
