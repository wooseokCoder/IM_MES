/**
 * ============================================================================
 * 화면명: ORD13A - 생산오더 일정 관리
 * ============================================================================
 * 설명: 주간 단위 생산 작업지시 조회, 동적 공정 컬럼 + 상태별 셀 색상,
 *       비고(SCOMMENT) 저장, 공정명(PROC_CODE) 저장
 * 원본: ProActive ORD13A_M0A.cs
 * 작성일: 2026-02-23
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var woFlagMap = {};      // "sapWoNo+woSeq" → woFlag (셀 색상 매핑)
var maxProcCnt = 0;      // 최대 공정 수 (동적 컬럼 수)
var summaryData = [];    // QUERY6 결과 (요약)
var detailData = [];     // QUERY5 결과 (상세)
var gridInited = false;  // 그리드 초기화 여부
var originalData = [];   // 원본 스냅샷 (페이지 간 변경 추적용)
var USE_PAGINATION = true; // 페이징 사용 여부

// WO_FLAG별 색상 매핑 (AS-IS 화면 기준)
var colors = {
    '0':  '#D3D3D3',   // 미확정 (LightGray)
    '1':  '#D4EDF7',   // 확정 (SkyBlue)
    '2':  '#FF6347',   // 진행 (Tomato - 주황계열)
    '3':  '#FFFF00',   // 중지 (Yellow)
    '4':  '#00FF00',   // 완료 (Green)
    '03': '#D3D3D3',   // LightGray
    '11': '#5F9EA0'    // CadetBlue
};

// ============================================================================
// consts
// ============================================================================
var consts = {
    url: {
        ORD13A_SER:  getUrl('/imes/ord/ord13a/ORD13A_SER.json'),
        ORD13A_UPD:  getUrl('/imes/ord/ord13a/ORD13A_UPD.json'),
        ORD13A_UPD2: getUrl('/imes/ord/ord13a/ORD13A_UPD2.json')
    },

    init: function() {
        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#save-remark-button').bind('click', doSaveRemarks);
        $('#save-proc-button').bind('click', doSaveProcNames);
    }
};

// ============================================================================
// 화면 초기화
// ============================================================================
$(function() {
    consts.init();
});

$(window).load(function() {
    hideLoadingBar();

    // 검색 조건 Enter 키
    bindEnterKey('s_modelLike');
    bindEnterKey('s_procLike');
    bindEnterKey('s_partLike');

    // 초기 빈 그리드 생성 후 DOM 렌더링 완료 대기 → 조회
    initGrid(0);
    
    //enableGridSortReset('#search-grid');
    //setTimeout(doSearch, 0);
});

// ============================================================================
// 그리드 초기화 (동적 컬럼 생성)
// ============================================================================

/**
 * 그리드 재생성: 고정 컬럼 5개 + 동적 공정 컬럼 procCnt개
 * @param procCnt  동적 컬럼 수
 * @param colWidths 컬럼별 자동 계산 너비 (field → px)
 */
function initGrid(procCnt, colWidths) {
    colWidths = colWidths || {};
    var columns = [];

    // 고정 컬럼
    columns.push({field:'sapWoNo', title:'생산오더', width:colWidths['sapWoNo'] || 140, halign:'center', align:'left'});
    columns.push({field:'model', title:'MODEL', width:colWidths['model'] || 100, halign:'center', align:'center'});
    columns.push({field:'partCode', title:'부품코드', width:colWidths['partCode'] || 120, halign:'center', align:'left'});
    columns.push({field:'partName', title:'부품명', width:colWidths['partName'] || 150, halign:'center', align:'left'});
    columns.push({field:'scomment', title:'비고', width:colWidths['scomment'] || 150, halign:'center', align:'left',
        editor: {type:'textbox'},
        styler: editableCellStyler
    });

    // 동적 공정 컬럼 (10, 20, 30, ...)
    for (var i = 1; i <= procCnt; i++) {
        var fieldName = String(i * 10);
        // IIFE 클로저로 fieldName 바인딩
        (function(fName) {
            columns.push({
                field: fName,
                title: fName,
                width: colWidths[fName] || 80,
                halign: 'center',
                align: 'center',
                editor: {type:'textbox'},
                styler: function(value, row, index) {
                    var flag = woFlagMap[row.sapWoNo + fName];
                    if (flag !== undefined && colors[flag]) {
                        return 'background-color:' + colors[flag] + ';';
                    }
                    return 'background-color:#FFFFCC;';
                }
            });
        })(fieldName);
    }

    // 그리드 (재)생성
    var dgOpts = {
        columns: [columns],
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: USE_PAGINATION,
        rownumbers: true,
        nowrap: true,
        toolbar: '#search-toolbar',
        onClickCell: onClickCell,
        onEndEdit: onEndEdit,
        onLoadSuccess: function(data) {
            $('#search-grid').datagrid('unselectAll');
            // td-div 너비 일치: common.css의 .datagrid-body table{width:100%} override
            var panel = $('#search-grid').datagrid('getPanel');
            panel.find('.datagrid-header table, .datagrid-body table').css('width', 'auto');
        }
    };

    // 페이징 사용 시 공통 clientPagerFilter 사용 (lsCommon.js)
    if (USE_PAGINATION) {
        dgOpts.pageNumber = 1;
        dgOpts.pageSize = parseInt(gconsts.PAGE_SIZE) || 50;
        dgOpts.pageList = [20, 50, 100, 200];
        dgOpts.loadFilter = clientPagerFilter;
        dgOpts.onBeforePageChange = endEditing;
    }

    $('#search-grid').datagrid(dgOpts);

    gridInited = true;

    GridHeaderMenu('#search-grid', { exportFileName: '생산오더일정' });
    enableGridSortReset('#search-grid');
}

// ============================================================================
// 셀 단위 편집 (editCell 확장)
// beginEdit는 행 전체 editor를 생성하여 동적 컬럼이 많을 때 느림
// editCell은 클릭한 셀 1개만 editor를 생성하여 성능 개선
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

var editIndex = undefined;
var editField = undefined;

function onClickCell(index, field) {
    // 편집 불가 컬럼 무시
    var col = $('#search-grid').datagrid('getColumnOption', field);
    if (!col || !col.editor) return;

    if (editIndex !== index || editField !== field) {
        if (endEditing()) {
            $('#search-grid').datagrid('selectRow', index);
            $('#search-grid').datagrid('editCell', {index: index, field: field});
            editIndex = index;
            editField = field;
            var ed = $('#search-grid').datagrid('getEditor', {index: index, field: field});
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

function onEndEdit(index, row) {
    // 편집 종료 시 추가 처리 없음
}

// ============================================================================
// 조회 (ORD13A_SER)
// ============================================================================
function doSearch() {
    // 편집 중인 행 종료
    endEditing();

    $('#search-grid').datagrid('loading');

    $.ajax({
        url: consts.url.ORD13A_SER,
        type: 'POST',
        data: {
            modelLike: $('#s_modelLike').textbox('getValue'),
            procLike: $('#s_procLike').textbox('getValue'),
            partLike: $('#s_partLike').textbox('getValue')
        },
        dataType: 'json',
        success: function(result) {
            summaryData = result.summary || [];
            detailData = result.detail || [];

            // 1. max(procCnt) 계산
            maxProcCnt = 0;
            for (var i = 0; i < summaryData.length; i++) {
                var cnt = parseInt(summaryData[i].procCnt) || 0;
                if (cnt > maxProcCnt) maxProcCnt = cnt;
            }

            // 2. woFlagMap 구축 + summaryData에 procCode 매핑
            woFlagMap = {};
            for (var i = 0; i < summaryData.length; i++) {
                for (var j = 1; j <= maxProcCnt; j++) {
                    summaryData[i][String(j * 10)] = '';
                }
            }

            for (var i = 0; i < detailData.length; i++) {
                var d = detailData[i];
                var sapWoNo = d.sapWoNo;
                var woSeq = String(d.woSeq);
                var woFlag = String(d.woFlag);
                var procCode = d.procCode || '';

                woFlagMap[sapWoNo + woSeq] = woFlag;

                for (var k = 0; k < summaryData.length; k++) {
                    if (summaryData[k].sapWoNo === sapWoNo) {
                        summaryData[k][woSeq] = procCode;
                        break;
                    }
                }
            }

            // 3. 데이터 기반 컬럼 너비 계산 → 그리드 재생성
            var colWidths = calcColumnWidths(summaryData, maxProcCnt);
            initGrid(maxProcCnt, colWidths);

            // 4. 원본 스냅샷 저장 (페이지 간 변경 추적용)
            originalData = JSON.parse(JSON.stringify(summaryData));

            // 5. 그리드에 데이터 로드
            $('#search-grid').datagrid('loadData', summaryData);
            $('#search-grid').datagrid('loaded');
        },
        error: function() {
            $('#search-grid').datagrid('loaded');
            $.messager.alert(getTitle('ERROR'), '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 비고 저장 (ORD13A_UPD)
// ============================================================================
function doSaveRemarks() {
    endEditing();

    // summaryData vs originalData 비교 (전체 페이지 변경분 추출)
    var rows = [];
    for (var i = 0; i < summaryData.length; i++) {
        if (originalData[i] && summaryData[i].scomment !== originalData[i].scomment) {
            rows.push({
                sapWoNo: summaryData[i].sapWoNo,
                scomment: summaryData[i].scomment || ''
            });
        }
    }

    if (rows.length === 0) {
        $.messager.alert(getTitle('ALERT'), '변경된 비고가 없습니다.', 'info');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), '수정된 비고를 저장하시겠습니까?', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.ORD13A_UPD,
            type: 'POST',
            data: {
                models: JSON.stringify(rows)
            },
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
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
// 공정명 저장 (ORD13A_UPD2)
// ============================================================================
function doSaveProcNames() {
    endEditing();

    // summaryData vs originalData 비교 (전체 페이지 동적 컬럼 변경분 추출)
    var rows = [];
    for (var i = 0; i < summaryData.length; i++) {
        if (!originalData[i]) continue;
        for (var j = 1; j <= maxProcCnt; j++) {
            var fieldName = String(j * 10);
            if (summaryData[i][fieldName] !== originalData[i][fieldName]) {
                rows.push({
                    sapWoNo: summaryData[i].sapWoNo,
                    woSeq: fieldName,
                    procCode: summaryData[i][fieldName] || ''
                });
            }
        }
    }

    if (rows.length === 0) {
        $.messager.alert(getTitle('ALERT'), '변경된 공정명이 없습니다.', 'info');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), '수정된 공정명을 저장하시겠습니까?', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.ORD13A_UPD2,
            type: 'POST',
            data: {
                models: JSON.stringify(rows)
            },
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
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
// 유틸리티 함수
// ============================================================================

/**
 * 전체 데이터 기준 컬럼별 최적 너비 계산
 */
function calcColumnWidths(data, procCnt) {
    var widths = {};
    var $ruler = $('<span></span>').css({
        visibility: 'hidden', position: 'absolute',
        whiteSpace: 'nowrap', fontSize: '14px'
    }).appendTo('body');

    // 컬럼 정의: field, title, minWidth
    var cols = [
        {field:'sapWoNo', title:'생산오더', min:80},
        {field:'model', title:'MODEL', min:60},
        {field:'partCode', title:'부품코드', min:80},
        {field:'partName', title:'부품명', min:80},
        {field:'scomment', title:'비고', min:80}
    ];
    for (var j = 1; j <= procCnt; j++) {
        var fn = String(j * 10);
        cols.push({field:fn, title:fn, min:50});
    }

    for (var c = 0; c < cols.length; c++) {
        var field = cols[c].field;

        // 헤더 너비 (bold)
        $ruler.css('fontWeight', '700').text(cols[c].title);
        var maxW = $ruler.outerWidth() + 24;

        // 데이터 너비 (normal) — 전체 행 대상
        $ruler.css('fontWeight', 'normal');
        for (var i = 0; i < data.length; i++) {
            var val = data[i][field];
            if (val != null && String(val) !== '') {
                $ruler.text(String(val));
                var w = $ruler.outerWidth() + 16;
                if (w > maxW) maxW = w;
            }
        }

        widths[field] = Math.max(maxW, cols[c].min);
    }

    $ruler.remove();
    return widths;
}

function bindEnterKey(id) {
    $('#' + id).textbox('textbox').bind('keyup', function(e) {
        $('#' + id).textbox('setValue', $(this).val());
    });
    $('#' + id).textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#' + id).textbox('setValue', $(this).val());
            doSearch();
        }
    });
}

function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

function getTitle(key) {
    if (typeof tit !== 'undefined') {
        switch (key) {
            case 'ALERT': return tit.TITLE0001 || '알림';
            case 'INFO': return msg.MSG0052 || '정보';
            case 'WARNING': return msg.MSG0051 || '경고';
            case 'ERROR': return msg.MSG0068 || '오류';
            case 'CONFIRM': return msg.MSG0053 || '확인';
        }
    }
    switch (key) {
        case 'ALERT': return '알림';
        case 'INFO': return '정보';
        case 'WARNING': return '경고';
        case 'ERROR': return '오류';
        case 'CONFIRM': return '확인';
        default: return key;
    }
}

/**
 * 편집 가능 셀 배경색 (연노랑)
 */
function editableCellStyler(value, row, index) {
    return 'background-color:#FFFFCC;';
}

function getMessage(key) {
    if (typeof msg !== 'undefined') {
        switch (key) {
            case 'SAVED': return msg.MSG0021 || '저장되었습니다.';
            case 'CONFIRM_SAVE': return msg.MSG0036 || '저장하시겠습니까?';
        }
    }
    switch (key) {
        case 'SAVED': return '저장되었습니다.';
        case 'CONFIRM_SAVE': return '저장하시겠습니까?';
        default: return key;
    }
}
