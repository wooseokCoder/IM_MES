/**
 * ============================================================================
 * 모듈: POP32A_D2A - 비가동시간 수정 팝업 JS
 * ============================================================================
 * 파일: resources/js/imes/pop/pop32a_d2a.js
 * 원본: ProActive POP32A_D2A.cs
 * 설명: 비가동시간 수정(D2A) 팝업 전용 JavaScript
 *       doOpenD2a(row)를 호출하면 수정 팝업이 열림
 *       다른 화면에서도 pop32a_d2a.jsp include 후 이 JS를 로드하면 사용 가능
 * ============================================================================
 */

// ============================================================================
// URL 상수
// ============================================================================
var _d2aConsts = {
    url: {
        POP32A_INS2 : getUrl('/imes/pop/pop32a/POP32A_INS2.json'),
        POP32A_IDLE : getUrl('/imes/pop/pop32a/POP32A_IDLE.json')
    }
};

// ============================================================================
// 화면 초기화
// ============================================================================
$(function() {
    initD2aDialog();
    bindD2aButtonEvents();
});

// ============================================================================
// D2A 다이얼로그 초기화
// ============================================================================
function initD2aDialog() {
    // 날짜/시간 자동 포맷팅 바인딩 여부 플래그 (최초 1회만)
    var _d2aFormatBound = false;

    $('#d2a-dialog').dialog({
        title   : '비가동 편집기',
        closed  : true,
        modal   : true,
        width   : 450,
        height  : 'auto',
        buttons : '#d2a-dialog-buttons',
        onOpen  : function() {
            $(this).css('visibility', '');
            $(this).dialog('center');
            // 날짜/시간 자동 포맷팅 이벤트 바인딩 (최초 1회)
            // dialog 초기화 시 DOM이 이동되므로, dialog가 열린 후에
            // datebox/timespinner textbox를 찾아 바인딩해야 정확한 요소에 걸림
            if (!_d2aFormatBound) {
                _d2aFormatBound = true;
                _bindDateAutoFormat($('#d2a_startDate').datebox('textbox'));
                _bindDateAutoFormat($('#d2a_endDate').datebox('textbox'));
                _bindTimeAutoFormat($('#d2a_startTime').timespinner('textbox'));
                _bindTimeAutoFormat($('#d2a_endTime').timespinner('textbox'));
            }
        },
        onClose : function() {
            clearD2aFields();
        }
    });

    // 비가동코드 콤보박스 (읽기전용)
    $('#d2a_idleCode').combobox({
        valueField: 'scode',
        textField: 'idleName',
        readonly: true
    });
}

// ============================================================================
// D2A 버튼 이벤트 바인딩
// ============================================================================
function bindD2aButtonEvents() {
    $('#d2a-save-button').off('click').on('click', function() {
        doSaveD2a();
    });
}

// ============================================================================
// D2A 수정 다이얼로그 열기 (다른 화면에서도 호출 가능)
// row 필수: idleId(UPDATE 키), idleCode(비가동사유), startTime(yyyyMMddHHmmss), endTime(yyyyMMddHHmmss)
// row 표시: empName(작업자명), mcName(작업장명) - 없으면 빈값 표시
// ============================================================================
function doOpenD2a(row) {
    if (!row) return;

    // 비가동코드 콤보박스 데이터 로드 후 값 설정
    $.ajax({
        url: _d2aConsts.url.POP32A_IDLE,
        type: 'POST',
        data: { plants: window.plants },
        dataType: 'json',
        success: function(data) {
            var rows = data.rows || data || [];
            $('#d2a_idleCode').combobox({
                data: rows,
                valueField: 'scode',
                textField: 'idleName',
                readonly: true
            });
            $('#d2a_idleCode').combobox('setValue', row.idleCode);
        }
    });

    // hidden 필드 설정
    $('#d2a_idleId').val(row.idleId);
    $('#d2a_empCode').val(row.empCode);
    $('#d2a_mcCode').val(row.mcCode);

    // 읽기전용 필드 설정
    $('#d2a_empName').textbox('setValue', row.empName || '');
    $('#d2a_mcName').textbox('setValue', row.mcName || '');

    // 시작/완료 시간 파싱 및 설정
    // startTime/endTime 형식: yyyyMMddHHmmss (14자리) 또는 yyyy-MM-dd HH:mm:ss
    if (row.startTime) {
        var st = String(row.startTime).replace(/[-: ]/g, '');
        if (st.length >= 14) {
            var sDate = st.substring(0, 4) + '-' + st.substring(4, 6) + '-' + st.substring(6, 8);
            var sTime = st.substring(8, 10) + ':' + st.substring(10, 12) + ':' + st.substring(12, 14);
            $('#d2a_startDate').datebox('setValue', sDate);
            $('#d2a_startTime').timespinner('setValue', sTime);
        }
    }
    if (row.endTime) {
        var et = String(row.endTime).replace(/[-: ]/g, '');
        if (et.length >= 14) {
            var eDate = et.substring(0, 4) + '-' + et.substring(4, 6) + '-' + et.substring(6, 8);
            var eTime = et.substring(8, 10) + ':' + et.substring(10, 12) + ':' + et.substring(12, 14);
            $('#d2a_endDate').datebox('setValue', eDate);
            $('#d2a_endTime').timespinner('setValue', eTime);
        }
    }

    $('#d2a-dialog').dialog('open');
}

// ============================================================================
// D2A 필드 검증
// ============================================================================
function validateD2aFields() {
    var valid = true;

    function setFieldError($comp) {
        $comp.css({
            'border'            : '2px solid transparent',
            'background-image'  : 'linear-gradient(#fff, #fff), linear-gradient(135deg, rgba(220,53,69,0.85), rgba(255,120,80,0.55))',
            'background-origin' : 'border-box',
            'background-clip'   : 'padding-box, border-box'
        });
    }
    function clearFieldError($comp) {
        $comp.css({ 'border': '', 'background-image': '', 'background-origin': '', 'background-clip': '' });
    }

    var fields = [
        { id: '#d2a_startDate', type: 'datebox' },
        { id: '#d2a_startTime', type: 'timespinner' },
        { id: '#d2a_endDate',   type: 'datebox' },
        { id: '#d2a_endTime',   type: 'timespinner' }
    ];

    for (var i = 0; i < fields.length; i++) {
        var $wrap = $(fields[i].id).next();
        if (!$(fields[i].id)[fields[i].type]('getValue')) {
            setFieldError($wrap);
            valid = false;
        } else {
            clearFieldError($wrap);
        }
    }
    return valid;
}

// ============================================================================
// timespinner getValue() 시간 파싱 (Date 객체 또는 문자열 "HH:mm:ss" 모두 대응)
// ============================================================================
function _parseTimeParts(timeVal) {
    if (timeVal && typeof timeVal.getHours == 'function') {
        return { h: timeVal.getHours(), m: timeVal.getMinutes(), s: timeVal.getSeconds() };
    }
    var parts = String(timeVal || '00:00:00').split(':');
    return { h: parseInt(parts[0]) || 0, m: parseInt(parts[1]) || 0, s: parseInt(parts[2]) || 0 };
}

// ============================================================================
// D2A 저장 (POP32A_INS2)
// ============================================================================
function doSaveD2a() {
    if (!validateD2aFields()) return;

    $.messager.confirm('확인', '비가동 시간을 수정하시겠습니까?', function(r) {
        if (!r) return;

        var startDateStr = $('#d2a_startDate').datebox('getValue');
        var endDateStr   = $('#d2a_endDate').datebox('getValue');

        var startDate = parseDate(startDateStr);
        var endDate   = parseDate(endDateStr);

        var st = _parseTimeParts($('#d2a_startTime').timespinner('getValue'));
        var et = _parseTimeParts($('#d2a_endTime').timespinner('getValue'));

        var startDateTime = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate(),
                                     st.h, st.m, st.s);
        var endDateTime   = new Date(endDate.getFullYear(), endDate.getMonth(), endDate.getDate(),
                                     et.h, et.m, et.s);

        var idleTime = Math.round((endDateTime - startDateTime) / 60000);

        if (idleTime <= 0) {
            $.messager.alert('알림', '종료시간은 시작시간보다 이후여야 합니다.', 'info');
            return;
        }

        var workDate = formatDate(startDateTime).replace(/-/g, '');

        var params = {
            idleId:    $('#d2a_idleId').val(),
            workDate:  workDate,
            startTime: formatDateTimeForServer(startDateTime),
            endTime:   formatDateTimeForServer(endDateTime),
            idleTime:  idleTime,
            idleState: '0'
        };

        $.ajax({
            url:      _d2aConsts.url.POP32A_INS2,
            type:     'POST',
            data:     params,
            dataType: 'json',
            success:  function(result) {
                if (result && result.errCode) {
                    $.messager.alert('오류', result.errMsg || '수정 실패', 'error');
                    return;
                }
                $.messager.alert('알림', '수정되었습니다.', 'info', function() {
                    $('#d2a-dialog').dialog('close');
                    if (typeof doSearch == 'function') {
                        doSearch();
                    }
                });
            },
            error: function() {
                $.messager.alert('오류', '수정 중 오류가 발생했습니다.', 'error');
            }
        });
    });
}

// ============================================================================
// D2A 필드 초기화
// ============================================================================
function clearD2aFields() {
    $('#d2a-form').form('clear');
    $('#d2a_idleId').val('');
    $('#d2a_empCode').val('');
    $('#d2a_mcCode').val('');
}

// ============================================================================
// 날짜/시간 자동 포맷팅 (숫자만 입력 → 구분자 자동 삽입)
// ============================================================================

/**
 * 커서 위치 복원 유틸리티
 * val() 변경 후 포맷팅 전 커서 앞에 있던 숫자 개수를 기준으로
 * 포맷팅 후 동일 숫자 위치로 커서를 이동시킴
 * @param {HTMLInputElement} input 대상 input 요소
 * @param {number} digitsBefore 포맷팅 전 커서 앞 숫자 개수
 */
function _restoreCursorByDigitCount(input, digitsBefore) {
    var val = input.value;
    var count = 0;
    var newPos = val.length; // 기본값: 맨 끝
    for (var i = 0; i < val.length; i++) {
        if (/[0-9]/.test(val[i])) {
            count++;
        }
        if (count >= digitsBefore) {
            newPos = i + 1;
            break;
        }
    }
    input.setSelectionRange(newPos, newPos);
}

/**
 * 날짜 자동 포맷팅 바인딩
 * 숫자 8자리 입력 → yyyy-MM-dd 자동 변환
 * keydown: 숫자 외 입력 차단 + 8자리 초과 차단
 * keyup + input: combo keydown 핸들러 후에도 값 정리 (EasyUI datebox 호환)
 * @param {jQuery} $textbox EasyUI 내부 textbox 요소
 */
function _bindDateAutoFormat($textbox) {
    if (!$textbox || !$textbox.length) return;

    // keydown: 숫자만 허용, 8자리 초과 차단
    // 텍스트 선택(드래그) 상태면 선택 영역의 숫자를 차감하여 대체 입력 허용
    $textbox.off('keydown.d2aFmt').on('keydown.d2aFmt', function(e) {
        var controlKeys = [8, 9, 35, 36, 37, 38, 39, 40, 46]; // backspace,tab,home,end,arrows,delete
        if (controlKeys.indexOf(e.keyCode) != -1) return true;
        if (e.ctrlKey) return true;
        var isNumeric = (e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 96 && e.keyCode <= 105);
        if (!isNumeric) { e.preventDefault(); return false; }
        // 선택 영역이 있으면 대체되므로 해당 숫자 자릿수 차감
        var selectedDigits = 0;
        if (this.selectionStart != this.selectionEnd) {
            var sel = $(this).val().substring(this.selectionStart, this.selectionEnd);
            selectedDigits = sel.replace(/[^0-9]/g, '').length;
        }
        var digits = $(this).val().replace(/[^0-9]/g, '');
        if ((digits.length - selectedDigits) >= 8) { e.preventDefault(); return false; }
    });
    // keyup + input: 자동 포맷팅 (yyyy-MM-dd)
    // keyup을 추가하여 EasyUI combo의 keydown 핸들러 이후에도 확실히 정리
    $textbox.off('keyup.d2aFmt input.d2aFmt').on('keyup.d2aFmt input.d2aFmt', function() {
        // 포맷팅 전 커서 위치의 숫자 개수 기억 (val 변경 시 커서 복원용)
        var cursorPos = this.selectionStart;
        var beforeCursor = $(this).val().substring(0, cursorPos);
        var digitsBefore = beforeCursor.replace(/[^0-9]/g, '').length;

        var digits = $(this).val().replace(/[^0-9]/g, '');
        if (digits.length > 8) digits = digits.substring(0, 8);
        var formatted = digits;
        if (digits.length > 4) {
            formatted = digits.substring(0, 4) + '-' + digits.substring(4);
        }
        if (digits.length > 6) {
            formatted = digits.substring(0, 4) + '-' + digits.substring(4, 6) + '-' + digits.substring(6);
        }
        if ($(this).val() != formatted) {
            $(this).val(formatted);
            // 커서 복원: 포맷팅 후 동일한 숫자 개수 위치로 이동
            _restoreCursorByDigitCount(this, digitsBefore);
        }
    });
}

/**
 * 시간 자동 포맷팅 바인딩
 * 숫자 6자리 입력 → HH:mm:ss 자동 변환
 * keydown: 숫자 외 입력 차단 + 6자리 초과 차단
 * keyup + input: 값 정리 (EasyUI spinner 호환)
 * @param {jQuery} $textbox EasyUI 내부 textbox 요소
 */
function _bindTimeAutoFormat($textbox) {
    if (!$textbox || !$textbox.length) return;

    // keydown: 숫자만 허용, 6자리 초과 차단
    // 텍스트 선택(드래그) 상태면 선택 영역의 숫자를 차감하여 대체 입력 허용
    $textbox.off('keydown.d2aFmt').on('keydown.d2aFmt', function(e) {
        var controlKeys = [8, 9, 35, 36, 37, 38, 39, 40, 46];
        if (controlKeys.indexOf(e.keyCode) != -1) return true;
        if (e.ctrlKey) return true;
        var isNumeric = (e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 96 && e.keyCode <= 105);
        if (!isNumeric) { e.preventDefault(); return false; }
        // 선택 영역이 있으면 대체되므로 해당 숫자 자릿수 차감
        var selectedDigits = 0;
        if (this.selectionStart != this.selectionEnd) {
            var sel = $(this).val().substring(this.selectionStart, this.selectionEnd);
            selectedDigits = sel.replace(/[^0-9]/g, '').length;
        }
        var digits = $(this).val().replace(/[^0-9]/g, '');
        if ((digits.length - selectedDigits) >= 6) { e.preventDefault(); return false; }
    });
    // keyup + input: 자동 포맷팅 (HH:mm:ss)
    $textbox.off('keyup.d2aFmt input.d2aFmt').on('keyup.d2aFmt input.d2aFmt', function() {
        // 포맷팅 전 커서 위치의 숫자 개수 기억
        var cursorPos = this.selectionStart;
        var beforeCursor = $(this).val().substring(0, cursorPos);
        var digitsBefore = beforeCursor.replace(/[^0-9]/g, '').length;

        var digits = $(this).val().replace(/[^0-9]/g, '');
        if (digits.length > 6) digits = digits.substring(0, 6);
        var formatted = digits;
        if (digits.length > 2) {
            formatted = digits.substring(0, 2) + ':' + digits.substring(2);
        }
        if (digits.length > 4) {
            formatted = digits.substring(0, 2) + ':' + digits.substring(2, 4) + ':' + digits.substring(4);
        }
        if ($(this).val() != formatted) {
            $(this).val(formatted);
            // 커서 복원
            _restoreCursorByDigitCount(this, digitsBefore);
        }
    });
}
