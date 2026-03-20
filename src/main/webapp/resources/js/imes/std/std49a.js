/**
 * ============================================================================
 * 화면명: STD49A - 비가동 관리
 * ============================================================================
 * 설명: 비가동시간 목록 조회, 등록, 수정, 삭제
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 공통 사용
 * 원본: ProActive STD49A_M0A.cs, STD49A_D0A.cs
 * 작성일: 2026-02-10
 * ============================================================================
 * 주요 기능:
 * - 비가동코드 LookUpEdit (콤보박스)
 * - 시간 입력 (HH:MM 형식) → DB 저장 (HHMM 4자리)
 * - 시간 중복 체크 (서버 측)
 * - OVERWRITE 처리 (중복/삭제 이력)
 * - 삭제 시 삭제사유 입력
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var dialogMode = '';       // 다이얼로그 모드: 'NEW' 또는 'EDIT' (AS-IS: emDialogMode)
var idleCodeData = [];     // 비가동코드 Lookup 데이터 캐시

// ============================================================================
// consts (user2.js 패턴)
// ============================================================================
var consts = {
    url: {
        STD49A_SER:  getUrl('/imes/std/std49a/STD49A_SER.json'),
        STD49A_IDLE: getUrl('/imes/std/std49a/STD49A_IDLE.json'),
        STD49A_INS:  getUrl('/imes/std/std49a/STD49A_INS.json'),
        STD49A_DEL:  getUrl('/imes/std/std49a/STD49A_DEL.json')
    },

    // 전체 초기화 (user2.js consts.init() 패턴)
    init: function() {

        // --- 비가동코드 Lookup 데이터 로드 (동기) ---
        // AS-IS: STD49A_IDLE → TSTD_IDLECODE_QUERY1
        $.ajax({
            url: this.url.STD49A_IDLE,
            type: 'POST',
            data: { plants: PAGE_PLANTS },
            dataType: 'json',
            async: false,
            success: function(response) {
                idleCodeData = response.rows || response || [];
            }
        });

        // --- 다이얼로그 콤보박스 설정 ---
        // AS-IS: acLookupEdit("SCODE", display="IDLE_NAME", value="SCODE")
        $('#f_scode').combobox({
            data: idleCodeData,
            valueField: 'scode',
            textField: 'idleName',
            panelHeight: 200,
            editable: true,
            filter: function(q, row) {
                return row.idleName.toLowerCase().indexOf(q.toLowerCase()) >= 0;
            }
        });

        // --- 그리드 초기화 (컬럼은 JSP <thead>에서 정의, data_item으로 다국어 지원) ---
        // AS-IS: acGridView.GridType = SEARCH (읽기 전용), 더블클릭=편집, 우클릭=컨텍스트메뉴
        $('#search-grid').datagrid({
            url: this.url.STD49A_SER,
            method: 'post',
            fit: true,
            fitColumns: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'idleNo',
            toolbar: '#search-toolbar',
            onLoadSuccess: function(data) {
                $('#search-grid').datagrid('unselectAll');
                $('#search-grid').datagrid('clearSelections');
            },
            onDblClickRow: function(index, row) {
                // AS-IS: acGridView_MouseDown → DoubleClick → acBarButtonItem2_ItemClick (열기)
                doOpenEdit(row);
            }
        });

        // --- 다이얼로그 초기화 ---
        $('#edit-dialog').dialog({
            title: '비가동 관리 편집기',
            closed: true,
            modal: true,
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
        // AS-IS: barItemClear(초기화), barItemSave(저장), barItemSaveClose(저장&닫기), barItemDel(삭제)
        $('#dialog-clear-button').bind('click', doClearDialog);
        $('#dialog-save-button').bind('click', function() { doSaveDialog(false); });
        $('#dialog-save-close-button').bind('click', function() { doSaveCloseDialog(false); });
        $('#dialog-delete-button').bind('click', doDeleteFromDialog);
    }
};

// ============================================================================
// 화면 초기화 (user2.js 패턴: 단일 $(function))
// ============================================================================
$(function() {
    consts.init();
});

// EasyUI 자동 파싱 완료 후 실행
$(window).load(function() {
    hideLoadingBar();
    GridHeaderMenu('#search-grid', { exportFileName: '비가동관리' });
    enableGridSortReset('#search-grid');
    
    // 검색 조건 Enter 키 (EasyUI textbox 초기화 후)
    $('#s_idleLike').textbox('textbox').bind('keyup', function(e) {
        $('#s_idleLike').textbox('setValue', $(this).val());
    });
    $('#s_idleLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_idleLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });

    // 시간 입력 자동 포맷 (숫자만, 2자리 후 ':' 자동 삽입, 최대 4숫자)
    bindTimeInput('#f_idleStartTime');
    bindTimeInput('#f_idleEndTime');

    doSearch();
});

// ============================================================================
// 포맷터 함수
// ============================================================================

/**
 * 시간 포맷터: DB값(HHMM) → 표시값(HH:MM)
 * AS-IS: DevExpress TextEdit with RegEx mask
 * 예: "0830" → "08:30", "1430" → "14:30"
 */
function formatTime(value) {
    if (!value) return '';
    var s = String(value);
    // 4자리: "0830" → "08:30"
    if (s.length === 4) return s.substring(0, 2) + ':' + s.substring(2, 4);
    // 3자리: "830" → "08:30"
    if (s.length === 3) return '0' + s.substring(0, 1) + ':' + s.substring(1, 3);
    return s;
}

// ============================================================================
// 조회 (STD49A_SER)
// AS-IS: Search() → BizRun "STD49A_SER"
// ============================================================================
function doSearch() {
    var params = {
        plants: PAGE_PLANTS,
        idleLike: $('#s_idleLike').textbox('getValue')
    };
    $('#search-grid').datagrid('load', params);
}

// ============================================================================
// 다이얼로그 모드 전환 (AS-IS: BaseMenuDialog.emDialogMode)
// NEW: 초기화 + 저장 버튼 표시
// EDIT: 저장&닫기 + 삭제 버튼 표시
// ============================================================================
function setDialogMode(mode) {
    dialogMode = mode;
    if (mode === 'NEW') {
        // AS-IS: DialogNew() → barItemClear=Always, barItemSave=Always
        $('.dialog-new-btn').show();
        $('.dialog-edit-btn').hide();
        $('#f_scode').combobox('readonly', false);
    } else {
        // AS-IS: DialogOpen() → barItemDel=Always, barItemSaveClose=Always
        // AS-IS: _KeyColumns에 SCODE 미설정 → 수정 모드에서도 비가동코드 변경 가능
        $('.dialog-new-btn').hide();
        $('.dialog-edit-btn').show();
        $('#f_scode').combobox('readonly', false);
    }
}

// ============================================================================
// 신규 다이얼로그 열기 (AS-IS: acBarButtonItem1 → DialogMode=NEW)
// ============================================================================
function doOpenNew() {
    clearDialogFields();
    setDialogMode('NEW');
    $('#edit-dialog').dialog('setTitle', '비가동 등록');
    $('#edit-dialog').dialog('open');
}

// ============================================================================
// 편집 다이얼로그 열기 (AS-IS: acBarButtonItem2 또는 DoubleClick → DialogMode=OPEN)
// ============================================================================
function doOpenEdit(row) {
    clearDialogFields();
    loadDialogFields(row);
    setDialogMode('EDIT');
    $('#edit-dialog').dialog('setTitle', '비가동 수정');
    $('#edit-dialog').dialog('open');
}

/**
 * 다이얼로그 필드 초기화
 */
function clearDialogFields() {
    $('#f_idleNo').val('');
    $('#f_scode').combobox('setValue', '');
    $('#f_idleStartTime').textbox('setValue', '');
    $('#f_idleEndTime').textbox('setValue', '');
    $('#f_scomment').textbox('setValue', '');
}

/**
 * 다이얼로그 필드 로드 (수정 시)
 * AS-IS: DialogOpen() → acLayoutControl1.DataBind(dataRow)
 * 시간: DB값(HHMM) → 표시값(HH:MM) 변환
 */
function loadDialogFields(row) {
    $('#f_idleNo').val(row.idleNo || '');
    $('#f_scode').combobox('setValue', row.scode || '');

    // DB format (HHMM) → display format (HH:MM)
    // AS-IS: DialogOpen()에서 4자리→5자리 변환
    var startTime = formatTime(row.idleStartTime);
    var endTime = formatTime(row.idleEndTime);
    $('#f_idleStartTime').textbox('setValue', startTime);
    $('#f_idleEndTime').textbox('setValue', endTime);
    $('#f_scomment').textbox('setValue', row.scomment || '');
}

/**
 * 다이얼로그 필드 검증
 * AS-IS: acLayoutControl1.ValidCheck() + isTimeCheck()
 */
function validateDialogFields() {
    var scode = $('#f_scode').combobox('getValue');
    var startTime = $('#f_idleStartTime').textbox('getValue');
    var endTime = $('#f_idleEndTime').textbox('getValue');

    // 필수값 체크
    if (!scode) {
        $.messager.alert(getTitle('ALERT'), '비가동코드를 선택하세요.', 'warning');
        return false;
    }
    if (!startTime || startTime.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '시작 시간을 입력하세요. (HH:MM)', 'warning');
        return false;
    }
    if (!endTime || endTime.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '종료 시간을 입력하세요. (HH:MM)', 'warning');
        return false;
    }

    // 시간 형식 검증 (AS-IS: RegEx "(0?\d|1\d|2[0-3])\:[0-5]\d")
    var timeRegex = /^([01]?\d|2[0-3]):([0-5]\d)$/;
    if (!timeRegex.test(startTime)) {
        $.messager.alert(getTitle('ALERT'), '시작 시간 형식이 잘못되었습니다. (HH:MM)', 'warning');
        return false;
    }
    if (!timeRegex.test(endTime)) {
        $.messager.alert(getTitle('ALERT'), '종료 시간 형식이 잘못되었습니다. (HH:MM)', 'warning');
        return false;
    }

    // 시간 대소 비교 (AS-IS: isTimeCheck())
    var startInt = parseInt(startTime.replace(':', ''), 10);
    var endInt = parseInt(endTime.replace(':', ''), 10);
    if (startInt >= endInt) {
        $.messager.alert(getTitle('ALERT'), '시작 시간이 종료 시간보다 크거나 같습니다.', 'warning');
        return false;
    }

    return true;
}

/**
 * 다이얼로그 파라미터 수집
 * 시간: 표시값(HH:MM) → DB값(HHMM) 변환
 * AS-IS: barItemSave에서 HH:MM → HHMM 변환 로직
 */
function getDialogParams() {
    var startTime = $('#f_idleStartTime').textbox('getValue').replace(':', '');
    var endTime = $('#f_idleEndTime').textbox('getValue').replace(':', '');

    return {
        idleNo: $('#f_idleNo').val(),
        scode: $('#f_scode').combobox('getValue'),
        plants: PAGE_PLANTS,
        idleStartTime: startTime,
        idleEndTime: endTime,
        scomment: $('#f_scomment').textbox('getValue')
    };
}

// ============================================================================
// 초기화 - 다이얼로그 (AS-IS: barItemClear)
// ============================================================================
function doClearDialog() {
    clearDialogFields();
}

// ============================================================================
// 저장 - 다이얼로그 (STD49A_INS) - NEW 모드
// AS-IS: barItemSave → OVERWRITE="0"
// OVERWRITE 처리: 중복(DUPLICATE)/삭제(DELETED)/시간중복(OVERLAP) 에러 시 처리
// ============================================================================
function doSaveDialog(overwrite) {
    if (!validateDialogFields()) return;

    var params = getDialogParams();
    if (overwrite) params.overwrite = '1';

    $.ajax({
        url: consts.url.STD49A_INS,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
                $('#edit-dialog').dialog('close');
                doSearch();
            } else if (result.errorCode === 'OVERLAP') {
                // AS-IS: 에러 100009 → 시간 중복 알림 (재시도 없음)
                $.messager.alert(getTitle('WARNING'), result.error || '비가동 시간이 겹칩니다.', 'warning');
            } else if (result.errorCode === 'DUPLICATE') {
                // AS-IS: 에러 100001 → 덮어쓰기 확인
                $.messager.confirm(getTitle('CONFIRM'), result.error, function(r) {
                    if (r) doSaveDialog(true);
                });
            } else if (result.errorCode === 'DELETED') {
                // AS-IS: 에러 100002 → 삭제이력 표시 후 복원 확인
                var errMsg = result.error;
                if (result.delDate) errMsg += '\n\n삭제일: ' + result.delDate;
                if (result.delEmp) errMsg += '\n삭제자: ' + result.delEmp;
                $.messager.confirm(getTitle('CONFIRM'), errMsg, function(r) {
                    if (r) doSaveDialog(true);
                });
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
// 저장&닫기 - 다이얼로그 (STD49A_INS) - EDIT 모드
// AS-IS: barItemSaveClose → OVERWRITE="1" (수정 모드이므로 항상 덮어쓰기)
// ============================================================================
function doSaveCloseDialog(overwrite) {
    if (!validateDialogFields()) return;

    var params = getDialogParams();
    // EDIT 모드: OVERWRITE=1 (AS-IS: barItemSaveClose에서 OVERWRITE="1" 고정)
    params.overwrite = '1';

    $.ajax({
        url: consts.url.STD49A_INS,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
                $('#edit-dialog').dialog('close');
                doSearch();
            } else if (result.errorCode === 'OVERLAP') {
                $.messager.alert(getTitle('WARNING'), result.error || '비가동 시간이 겹칩니다.', 'warning');
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
// 삭제 - 다이얼로그 (AS-IS: barItemDel)
// AS-IS: ShowParameterYesNo → 삭제사유 입력 후 삭제
// ============================================================================
function doDeleteFromDialog() {
    var idleNo = $('#f_idleNo').val();
    if (!idleNo) return;

    // AS-IS: ParameterYesNoDialogResult → 삭제사유 입력
    $.messager.prompt(getTitle('CONFIRM'), '삭제사유를 입력하세요.', function(reason) {
        if (reason !== undefined && reason !== null) {
            $.ajax({
                url: consts.url.STD49A_DEL,
                type: 'POST',
                data: { idleNo: idleNo, delReason: reason },
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success || getMessage('DELETED'), 'info');
                        $('#edit-dialog').dialog('close');
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
// 삭제 - 그리드 선택 행 (AS-IS: acBarButtonItem3 컨텍스트 메뉴)
// ============================================================================
function doDelete() {
    var row = $('#search-grid').datagrid('getSelected');
    if (!row) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    // AS-IS: ParameterYesNoDialogResult → 삭제사유 입력
    $.messager.prompt(getTitle('CONFIRM'), '삭제사유를 입력하세요.', function(reason) {
        if (reason !== undefined && reason !== null) {
            $.ajax({
                url: consts.url.STD49A_DEL,
                type: 'POST',
                data: { idleNo: row.idleNo, delReason: reason },
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

/**
 * 시간 입력 자동 포맷 바인딩
 * - 숫자만 입력 허용
 * - 2자리 입력 후 ':' 자동 삽입
 * - 최대 4숫자 (HH:MM = 5자)
 */
function bindTimeInput(selector) {
    $(selector).textbox('textbox').bind('input', function() {
        var raw = $(this).val().replace(/[^0-9]/g, '');
        if (raw.length > 4) raw = raw.substring(0, 4);
        var formatted = raw;
        if (raw.length > 2) {
            formatted = raw.substring(0, 2) + ':' + raw.substring(2);
        }
        $(this).val(formatted);
        $(selector).textbox('setValue', formatted);
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

function getMessage(key) {
    if (typeof msg !== 'undefined') {
        switch (key) {
            case 'SAVED': return msg.MSG0021 || '저장되었습니다.';
            case 'DELETED': return msg.MSG0054 || '삭제되었습니다.';
            case 'NO_CHANGED': return msg.MSG0022 || '변경된 데이터가 없습니다.';
            case 'SELECT_DELETE': return msg.MSG0016 || '삭제할 항목을 선택하세요.';
            case 'CONFIRM_SAVE': return msg.MSG0036 || '저장하시겠습니까?';
            case 'CONFIRM_DELETE': return msg.MSG0030 || '삭제하시겠습니까?';
        }
    }
    switch (key) {
        case 'SAVED': return '저장되었습니다.';
        case 'DELETED': return '삭제되었습니다.';
        case 'NO_CHANGED': return '변경된 데이터가 없습니다.';
        case 'SELECT_DELETE': return '삭제할 항목을 선택하세요.';
        case 'CONFIRM_SAVE': return '저장하시겠습니까?';
        case 'CONFIRM_DELETE': return '삭제하시겠습니까?';
        default: return key;
    }
}
