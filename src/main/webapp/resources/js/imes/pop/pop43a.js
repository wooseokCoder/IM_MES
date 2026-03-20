/**
 * ============================================================================
 * 화면명: POP43A - 수리수선 이력관리
 * ============================================================================
 * 설명: 수리수선 이력 조회, 등록, 수정, 삭제
 * 원본: ProActive POP43A_M0A.cs, POP43A_D0A.cs
 * 작성일: 2026-03-11
 * ============================================================================
 * 주요 기능:
 * - 멀티체크콤보 (일자 검색 조건)
 * - 수리수선 CRUD (팝업 다이얼로그)
 * - 금액 천단위 콤마 포맷
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var dialogMode = '';   // 다이얼로그 모드: 'NEW' 또는 'EDIT'

// ============================================================================
// consts
// ============================================================================
var consts = {
    url: {
        POP43A_SER: getUrl('/imes/pop/pop43a/POP43A_SER.json'),
        POP43A_INS: getUrl('/imes/pop/pop43a/POP43A_INS.json'),
        POP43A_DEL: getUrl('/imes/pop/pop43a/POP43A_DEL.json')
    },

    init: function() {

        // --- 그리드 초기화 ---
        $('#search-grid').datagrid({
            method: 'post',
            fit: true,
            fitColumns: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'mcrId',
            toolbar: '#search-toolbar',
            onLoadSuccess: function(data) {
                $('#search-grid').datagrid('unselectAll');
            },
            onDblClickRow: function(index, row) {
                doOpenEdit(row);
            },
            onClickCell: function(index, field, value) {
                if (field === 'ck') {
                    var row = $('#search-grid').datagrid('getRows')[index];
                    row.ck = row.ck === '1' ? '0' : '1';
                    $('#search-grid').datagrid('refreshRow', index);
                }
            }
        });

        // --- 다이얼로그 초기화 ---
        $('#edit-dialog').dialog({
            title: '수리수선 편집기',
            closed: true,
            modal: true,
            buttons: '#edit-dialog-buttons',
            onOpen: function() {
                $(this).css('visibility', '');
                $('#edit-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
            }
        });

        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#new-button').bind('click', doOpenNew);
        $('#delete-button').bind('click', doDelete);

        // 다이얼로그 버튼
        $('#dialog-save-button').bind('click', function() { doSaveDialog(); });

        // --- 멀티체크콤보 ALL 토글 ---
        $('#s_dateType').combobox({
            onSelect: function(record) {
                var values = $(this).combobox('getValues');
                if (record.id === 'ALL') {
                    // ALL 선택 시 → 모든 항목 선택
                    $(this).combobox('setValues', ['ALL', 'REPAIR_DATE']);
                }
            },
            onUnselect: function(record) {
                var values = $(this).combobox('getValues');
                if (record.id === 'ALL') {
                    // ALL 해제 시 → 모든 항목 해제
                    $(this).combobox('setValues', []);
                } else {
                    // 개별 항목 해제 시 → ALL도 해제
                    var idx = values.indexOf('ALL');
                    if (idx > -1) {
                        values.splice(idx, 1);
                        $(this).combobox('setValues', values);
                    }
                }
            }
        });
    }
};

// ============================================================================
// 화면 초기화
// ============================================================================
$(function() {
    consts.init();
});

// EasyUI 자동 파싱 완료 후 실행
$(window).load(function() {
    hideLoadingBar();
    GridHeaderMenu('#search-grid', { exportFileName: '수리수선이력' });
    enableGridSortReset('#search-grid');

    // AS-IS 기본값: REPAIR_DATE 선택, 시작일=오늘-7일, 종료일=오늘
    $('#s_dateType').combobox('setValues', ['REPAIR_DATE']);
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);
    $('#s_startDate').datebox('setValue', formatDateYmd(weekAgo));
    $('#s_endDate').datebox('setValue', formatDateYmd(today));

    // 검색 조건 Enter 키 바인딩
    $('#s_repairVendorLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_repairVendorLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });
    $('#s_repairMcLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_repairMcLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });

    // 입력 길이 제한 (DB 컬럼 길이: TMCM_REPAIR)
    $('#s_repairVendorLike').textbox('textbox').attr('maxlength', 100);  // REPAIR_VENDOR VARCHAR(100)
    $('#s_repairMcLike').textbox('textbox').attr('maxlength', 100);      // REPAIR_MC VARCHAR(100)
    $('#f_repairVendor').textbox('textbox').attr('maxlength', 100);      // REPAIR_VENDOR VARCHAR(100)
    $('#f_repairMc').textbox('textbox').attr('maxlength', 100);          // REPAIR_MC VARCHAR(100)
    $('#f_repairMcType').textbox('textbox').attr('maxlength', 100);      // REPAIR_MC_TYPE VARCHAR(100)
    $('#f_repairName').textbox('textbox').attr('maxlength', 100);        // REPAIR_NAME VARCHAR(100)
    $('#f_repairContents').textbox('textbox').attr('maxlength', 1000);   // REPAIR_CONTENTS VARCHAR(1000)
    $('#f_repairAmount').numberbox('textbox').attr('maxlength', 16);     // DECIMAL(18,2) → 정수부 16자리

});

// ============================================================================
// 포맷터 함수
// ============================================================================

/**
 * 체크박스 포맷터 (AS-IS: SEL CheckEdit)
 */
function formatCheckbox(value, row, index) {
    var checked = (value === '1' || value === 1) ? 'checked' : '';
    return '<input type="checkbox" ' + checked + ' onclick="return false;" />';
}

/**
 * 숫자 포맷터: 천단위 콤마
 */
function formatNumber(value) {
    if (value === null || value === undefined || value === '') return '';
    var num = parseFloat(value);
    if (isNaN(num)) return value;
    return num.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 2 });
}

/**
 * 날짜 포맷터: YYYY-MM-DD 또는 YYYYMMDD → YYYY-MM-DD
 */
function formatDate(value) {
    if (!value) return '';
    var s = String(value).replace(/-/g, '');
    if (s.length === 8) {
        return s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
    }
    return value;
}

/**
 * Date 객체 → 'YYYY-MM-DD' 문자열 (datebox setValue용)
 */
function formatDateYmd(dt) {
    var y = dt.getFullYear();
    var m = ('0' + (dt.getMonth() + 1)).slice(-2);
    var d = ('0' + dt.getDate()).slice(-2);
    return y + '-' + m + '-' + d;
}

/**
 * 'YYYY-MM-DD' → 'YYYYMMDD' 변환 (AS-IS DB 포맷: yyyyMMdd)
 */
function toDbDate(dateStr) {
    if (!dateStr) return '';
    return dateStr.replace(/-/g, '');
}

// ============================================================================
// 조회 (POP43A_SER)
// ============================================================================
function doSearch() {
    var params = {};

    // 멀티체크콤보: REPAIR_DATE 선택 시에만 날짜 조건 전달
    var dateTypes = $('#s_dateType').combobox('getValues');
    if (dateTypes && dateTypes.indexOf('REPAIR_DATE') >= 0) {
        params.sRepairDate = toDbDate($('#s_startDate').datebox('getValue'));
        params.eRepairDate = toDbDate($('#s_endDate').datebox('getValue'));
    }

    params.repairVendorLike = $('#s_repairVendorLike').textbox('getValue');
    params.repairMcLike = $('#s_repairMcLike').textbox('getValue');

    $('#search-grid').datagrid('loading');
    $.ajax({
        url: consts.url.POP43A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#search-grid').datagrid('loadData', rows);
            $('#search-grid').datagrid('loaded');
        },
        error: function() {
            $('#search-grid').datagrid('loaded');
            $.messager.alert(getTitle('ERROR'), '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 신규 다이얼로그 열기
// ============================================================================
function doOpenNew() {
    clearDialogFields();
    dialogMode = 'NEW';
    // AS-IS: 신규 시 일자를 서버 현재일로 자동 세팅
    $('#f_repairDate').datebox('setValue', formatDateYmd(new Date()));
    $('#edit-dialog').dialog('setTitle', '수리수선 등록');
    $('#edit-dialog').dialog('open');
}

// ============================================================================
// 편집 다이얼로그 열기 (그리드 더블클릭)
// ============================================================================
function doOpenEdit(row) {
    clearDialogFields();
    loadDialogFields(row);
    dialogMode = 'EDIT';
    $('#edit-dialog').dialog('setTitle', '수리수선 수정');
    $('#edit-dialog').dialog('open');
}

/**
 * 다이얼로그 필드 초기화
 */
function clearDialogFields() {
    $('#f_mcrId').val('');
    $('#f_repairDate').datebox('setValue', '');
    $('#f_repairVendor').textbox('setValue', '');
    $('#f_repairMc').textbox('setValue', '');
    $('#f_repairMcType').textbox('setValue', '');
    $('#f_repairName').textbox('setValue', '');
    $('#f_repairAmount').numberbox('setValue', '');
    $('#f_repairContents').textbox('setValue', '');
}

/**
 * 다이얼로그 필드 로드 (수정 시)
 */
function loadDialogFields(row) {
    $('#f_mcrId').val(row.mcrId || '');
    // DB yyyyMMdd → datebox yyyy-MM-dd
    $('#f_repairDate').datebox('setValue', formatDate(row.repairDate) || '');
    $('#f_repairVendor').textbox('setValue', row.repairVendor || '');
    $('#f_repairMc').textbox('setValue', row.repairMc || '');
    $('#f_repairMcType').textbox('setValue', row.repairMcType || '');
    $('#f_repairName').textbox('setValue', row.repairName || '');
    $('#f_repairAmount').numberbox('setValue', row.repairAmount || '');
    $('#f_repairContents').textbox('setValue', row.repairContents || '');
}

/**
 * 다이얼로그 필드 검증
 */
function validateDialogFields() {
    var repairDate = $('#f_repairDate').datebox('getValue');

    if (!repairDate) {
        $.messager.alert(getTitle('ALERT'), '일자를 입력하세요.', 'warning');
        return false;
    }

    return true;
}

/**
 * 다이얼로그 파라미터 수집
 */
function getDialogParams() {
    return {
        mcrId: $('#f_mcrId').val(),
        repairDate: toDbDate($('#f_repairDate').datebox('getValue')),
        repairVendor: $('#f_repairVendor').textbox('getValue'),
        repairMc: $('#f_repairMc').textbox('getValue'),
        repairMcType: $('#f_repairMcType').textbox('getValue'),
        repairName: $('#f_repairName').textbox('getValue'),
        repairAmount: $('#f_repairAmount').numberbox('getValue'),
        repairContents: $('#f_repairContents').textbox('getValue')
    };
}

// ============================================================================
// 저장 - 다이얼로그
// ============================================================================
function doSaveDialog() {
    if (!validateDialogFields()) return;

    var params = getDialogParams();

    $.ajax({
        url: consts.url.POP43A_INS,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
                $('#edit-dialog').dialog('close');
                doSearch();
            } else {
                $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
            }
        },
        error: function() {
            $.messager.alert(getTitle('ERROR'), '저장 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 삭제 - 체크된 행 다건 삭제 (AS-IS: SEL 체크박스 기반)
// ============================================================================
function doDelete() {
    // ck='1'인 행 수집
    var allRows = $('#search-grid').datagrid('getRows');
    var list = [];
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].ck === '1' || allRows[i].ck === 1) {
            list.push({ pltCode: allRows[i].pltCode, mcrId: allRows[i].mcrId });
        }
    }
    if (list.length === 0) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_DELETE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.POP43A_DEL,
                type: 'POST',
                data: { models: JSON.stringify(list) },
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success || getMessage('DELETED'), 'info');
                        doSearch();
                    } else {
                        $.messager.alert(getTitle('ERROR'), result.error || '삭제 실패', 'error');
                    }
                },
                error: function() {
                    $.messager.alert(getTitle('ERROR'), '삭제 중 오류가 발생했습니다.', 'error');
                }
            });
        }
    });
}

// ============================================================================
// 유틸리티 함수
// ============================================================================

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

function getMessage(key) {
    if (typeof msg !== 'undefined') {
        switch (key) {
            case 'SAVED': return msg.MSG0021 || '저장되었습니다.';
            case 'DELETED': return msg.MSG0054 || '삭제되었습니다.';
            case 'SELECT_DELETE': return msg.MSG0016 || '삭제할 항목을 선택하세요.';
            case 'CONFIRM_DELETE': return msg.MSG0030 || '삭제하시겠습니까?';
        }
    }
    switch (key) {
        case 'SAVED': return '저장되었습니다.';
        case 'DELETED': return '삭제되었습니다.';
        case 'SELECT_DELETE': return '삭제할 항목을 선택하세요.';
        case 'CONFIRM_DELETE': return '삭제하시겠습니까?';
        default: return key;
    }
}
