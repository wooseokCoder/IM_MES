/**
 * STD23A 휴일관리 JS
 * @author 송우석
 */

/* 전역 변수 */
var codeDataMap = {};
var calYear;
var calMonth;  /* 0-based (0=1월, 11=12월) */
var selectedDate = null;
var holidayMap = {};
var contextMenuDate = null;
var contextMenuRow = null;

/* D0B/D1B/D2B guard flags */
var d0bInited = false;
var d1bInited = false;
var d2bInited = false;

/* consts 객체 */
var consts = {
    url: {
        STD23A_SER:       getUrl('/imes/std/std23a/STD23A_SER.json'),
        STD23A_SER1:      getUrl('/imes/std/std23a/STD23A_SER1.json'),
        STD23A_SER5:      getUrl('/imes/std/std23a/STD23A_SER5.json'),
        STD23A_INS_CAPA:  getUrl('/imes/std/std23a/STD23A_INS_CAPA.json'),
        STD23A_UPD1:      getUrl('/imes/std/std23a/STD23A_UPD1.json'),
        STD23A_UPD2:      getUrl('/imes/std/std23a/STD23A_UPD2.json'),
        STD23A_UPD3:      getUrl('/imes/std/std23a/STD23A_UPD3.json'),
        STD23B_UPD4:      getUrl('/imes/std/std23a/STD23B_UPD4.json')
    },

    init: function() {
        // 1. 달력 초기화 (현재 월 기준, AS-IS: DateTime.Now)
        var now = new Date();
        calYear = now.getFullYear();
        calMonth = now.getMonth();

        // 2. 메인 그리드 초기화
        initMainGrid();

        // 3. 버튼 이벤트 바인딩
        bindButtonEvents();

        // 4. 달력 네비게이션 이벤트
        bindCalendarEvents();
    }
};

/* ========== 초기화 ========== */

$(function() {
    // 500 에러 시 raw 메시지 대신 일반 메시지 표시
    $.ajaxSetup({ statusCode: { 500: function() {
        $.messager.alert('Error', '오류가 발생했습니다.', 'error');
    }}});
    consts.init();
});

$(window).load(function() {
    hideLoadingBar();

    GridHeaderMenu('#search-grid', { exportFileName: '생산능력관리' });
    enableGridSortReset('#search-grid');

    // 달력 렌더링 + 휴일 로드
    loadHolidaysAndRenderCalendar();
});

/* ========== 메인 그리드 ========== */

function initMainGrid() {
    $('#search-grid').datagrid({
        fit: true,
        fitColumns: true,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        striped: true,
        rownumbers: true,
        columns: [[
            {field:'ck', checkbox:true},
            {field:'workDate', title:'일자', width:90, halign:'center', align:'center'},
            {field:'mcCode', title:'설비코드', width:90, halign:'center', align:'center'},
            {field:'mcName', title:'설비명', width:120, halign:'center', align:'center'},
            {field:'capa', title:'CAPA', width:70, halign:'center', align:'right'},
            {field:'holiName', title:'휴일명', width:100, halign:'center', align:'center'},
            {field:'scomment', title:'CAPA 변경사유', width:180, halign:'center', align:'left'}
        ]],
        onDblClickRow: function(index, row) {
            doOpenD2b(row);
        },
        onRowContextMenu: function(e, index, row) {
            e.preventDefault();
            contextMenuRow = row;
            $('#search-grid').datagrid('selectRow', index);
            $('#grid-context-menu').menu('show', {left: e.pageX, top: e.pageY});
        }
    });
}

/* ========== 버튼 이벤트 ========== */

function bindButtonEvents() {
    // 조회 버튼
    $('#search-button').bind('click', function() {
        if (selectedDate) {
            doSearchGrid(selectedDate);
        }
    });

    // 생성 버튼 → D0B 팝업
    $('#create-button').bind('click', function() {
        doOpenD0b();
    });

    // 달력 우클릭 메뉴
    $('#ctx-set-holiday').bind('click', function() {
        if (contextMenuDate) {
            doOpenD1b(contextMenuDate);
        }
    });

    $('#ctx-clear-holiday').bind('click', function() {
        if (contextMenuDate) {
            doClearHoliday(contextMenuDate);
        }
    });

    // 그리드 우클릭 메뉴
    $('#ctx-change-capa').bind('click', function() {
        if (contextMenuRow) {
            doOpenD2b(contextMenuRow);
        }
    });

    $('#ctx-reset-capa').bind('click', function() {
        doResetCapaDefault();
    });
}

/* ========== 달력 ========== */

function bindCalendarEvents() {
    $('#cal-prev-year').bind('click', function() {
        calYear--;
        loadHolidaysAndRenderCalendar();
    });
    $('#cal-next-year').bind('click', function() {
        calYear++;
        loadHolidaysAndRenderCalendar();
    });
    $('#cal-prev-month').bind('click', function() {
        calMonth--;
        if (calMonth < 0) {
            calMonth = 11;
            calYear--;
        }
        loadHolidaysAndRenderCalendar();
    });
    $('#cal-next-month').bind('click', function() {
        calMonth++;
        if (calMonth > 11) {
            calMonth = 0;
            calYear++;
        }
        loadHolidaysAndRenderCalendar();
    });
}

function loadHolidaysAndRenderCalendar() {
    // 현재 월 기준 12개월 휴일 조회 (AS-IS: StartDateTime ~ EndDateTime)
    var startDt = new Date(calYear, calMonth, 1);
    var endDt = new Date(calYear, calMonth + 12, 0);  /* 12번째 월의 마지막 날 */
    var sDate = startDt.getFullYear() + padZero(startDt.getMonth() + 1) + '01';
    var eDate = endDt.getFullYear() + padZero(endDt.getMonth() + 1) + padZero(endDt.getDate());

    $.ajax({
        url: consts.url.STD23A_SER1,
        type: 'POST',
        data: { sHoliDate: sDate, eHoliDate: eDate },
        dataType: 'json',
        success: function(result) {
            holidayMap = {};
            var rows = result.rows || result || [];
            for (var i = 0; i < rows.length; i++) {
                holidayMap[rows[i].holiDate] = rows[i].holiName;
            }
            renderYearCalendar();
        },
        error: function() {
            holidayMap = {};
            renderYearCalendar();
        }
    });
}

/**
 * 12개월 연간 달력 렌더링 (AS-IS MaxCalendar=12 대응)
 */
function renderYearCalendar() {
    // 타이틀: 시작월 ~ 종료월 (AS-IS: 현재월 기준 12개월)
    var endDt = new Date(calYear, calMonth + 11, 1);
    $('#cal-title').text(calYear + '.' + padZero(calMonth + 1) + ' ~ ' + endDt.getFullYear() + '.' + padZero(endDt.getMonth() + 1));

    var today = new Date();
    var todayStr = today.getFullYear() + padZero(today.getMonth() + 1) + padZero(today.getDate());
    var dayHeaders = '<tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr>';
    var html = '<div id="calendar-grid">';

    for (var i = 0; i < 12; i++) {
        var dt = new Date(calYear, calMonth + i, 1);
        html += '<div class="mini-cal-wrap">';
        html += renderMiniMonth(dt.getFullYear(), dt.getMonth(), todayStr, dayHeaders);
        html += '</div>';
    }

    html += '</div>';
    $('#calendar-body').html(html);

    // 날짜 셀 클릭 이벤트
    $('#calendar-body td[data-date]').bind('click', function() {
        var dateStr = $(this).attr('data-date');
        selectedDate = dateStr;

        // 선택 표시 갱신
        $('#calendar-body td').removeClass('selected');
        $(this).addClass('selected');

        // 그리드 조회
        doSearchGrid(dateStr);
    });

    // 달력 우클릭 이벤트
    $('#calendar-body td[data-date]').bind('contextmenu', function(e) {
        e.preventDefault();
        contextMenuDate = $(this).attr('data-date');

        // 휴일 여부에 따라 메뉴 항목 활성화/비활성화
        var isHoliday = !!holidayMap[contextMenuDate];
        if (isHoliday) {
            $('#calendar-context-menu').menu('disableItem', $('#ctx-set-holiday')[0]);
            $('#calendar-context-menu').menu('enableItem', $('#ctx-clear-holiday')[0]);
        } else {
            $('#calendar-context-menu').menu('enableItem', $('#ctx-set-holiday')[0]);
            $('#calendar-context-menu').menu('disableItem', $('#ctx-clear-holiday')[0]);
        }

        $('#calendar-context-menu').menu('show', {left: e.pageX, top: e.pageY});
    });
}

/**
 * 단일 월 미니 달력 HTML 생성
 */
function renderMiniMonth(year, month, todayStr, dayHeaders) {
    var monthNames = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
    var firstDay = new Date(year, month, 1).getDay();
    var lastDate = new Date(year, month + 1, 0).getDate();

    var html = '<div class="mini-cal-title">' + monthNames[month] + '</div>';
    html += '<table class="mini-cal">';
    html += dayHeaders;

    var day = 1;
    for (var row = 0; row < 6; row++) {
        if (day > lastDate) break;
        html += '<tr>';
        for (var col = 0; col < 7; col++) {
            if (row === 0 && col < firstDay) {
                html += '<td class="other-month"></td>';
            } else if (day > lastDate) {
                html += '<td class="other-month"></td>';
            } else {
                var dateStr = year + padZero(month + 1) + padZero(day);
                var classes = [];

                if (dateStr === todayStr) classes.push('today');
                if (selectedDate === dateStr) classes.push('selected');
                if (holidayMap[dateStr]) classes.push('holiday');
                if (col === 0) classes.push('sunday');
                if (col === 6) classes.push('saturday');

                var title = holidayMap[dateStr] ? ' title="' + holidayMap[dateStr] + '"' : '';
                html += '<td class="' + classes.join(' ') + '" data-date="' + dateStr + '"' + title + '>' + day + '</td>';
                day++;
            }
        }
        html += '</tr>';
    }
    html += '</table>';
    return html;
}

/* ========== 그리드 조회 ========== */

function doSearchGrid(dateStr) {
    $.ajax({
        url: consts.url.STD23A_SER,
        type: 'POST',
        data: { date1: dateStr, date2: dateStr },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#search-grid').datagrid('loadData', rows);
        },
        error: function() {
        }
    });
}

/* ========== D0B: CAPA 생성 팝업 ========== */

function doOpenD0b() {
	$('#d0b-popup').css('visibility', '');
    $('#edit-dialog-buttons').css('visibility', '');
    $('#d0b-popup').dialog('open').dialog('center');
    if (d0bInited) {
        // 재오픈 시 기간 기본값 갱신
        var year = calYear;
        $('#d0b_frDate').datebox('setValue', formatDateForBox(year + '0101'));
        $('#d0b_toDate').datebox('setValue', formatDateForBox(year + '1231'));
        // 설비 그리드 갱신
        loadD0bMcGrid();
    }
}

function initD0bPopup() {
    if (d0bInited) return;
    d0bInited = true;

    var year = calYear;

    // 기간 기본값: 올해 1/1 ~ 12/31
    $('#d0b_frDate').datebox('setValue', formatDateForBox(year + '0101'));
    $('#d0b_toDate').datebox('setValue', formatDateForBox(year + '1231'));

    // 설비 그리드 초기화
    $('#d0b-mc-grid').datagrid({
        fit: false,
        width: '100%',
        height: 220,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        columns: [[
            {field:'ck', checkbox:true},
            {field:'mcCode', title:'설비코드', width:100, halign:'center', align:'center'},
            {field:'mcName', title:'설비명', width:120, halign:'center', align:'left'},
            {field:'mcGroup', title:'설비그룹', width:100, halign:'center', align:'center'}
        ]]
    });

    loadD0bMcGrid();

    // 저장 버튼
    $('#d0b-save-button').bind('click', doSaveD0b);
}

function loadD0bMcGrid() {
    $.ajax({
        url: consts.url.STD23A_SER5,
        type: 'POST',
        data: {},
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#d0b-mc-grid').datagrid('loadData', rows);
        }
    });
}

function doSaveD0b() {
    var frDate = dateBoxToYmd($('#d0b_frDate').datebox('getValue'));
    var toDate = dateBoxToYmd($('#d0b_toDate').datebox('getValue'));
    var checkZero = $('#d0b_checkZero').val();

    if (!frDate || !toDate) {
        $.messager.alert(getTitle('WARNING'), '기간을 입력하세요.', 'warning');
        return;
    }

    var checkedRows = $('#d0b-mc-grid').datagrid('getChecked');
    if (checkedRows.length === 0) {
        $.messager.alert(getTitle('WARNING'), '설비를 선택하세요.', 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), 'CAPA를 생성하시겠습니까?', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.STD23A_INS_CAPA,
            type: 'POST',
            data: {
                frDate: frDate,
                toDate: toDate,
                checkZero: checkZero,
                monday:    $('#d0b_monday').is(':checked') ? '1' : '0',
                tuesday:   $('#d0b_tuesday').is(':checked') ? '1' : '0',
                wednesday: $('#d0b_wednesday').is(':checked') ? '1' : '0',
                thursday:  $('#d0b_thursday').is(':checked') ? '1' : '0',
                friday:    $('#d0b_friday').is(':checked') ? '1' : '0',
                saturday:  $('#d0b_saturday').is(':checked') ? '1' : '0',
                sunday:    $('#d0b_sunday').is(':checked') ? '1' : '0',
                models: JSON.stringify(checkedRows)
            },
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert(getTitle('INFO'), result.success, 'info');
                    $('#d0b-popup').dialog('close');
                    if (selectedDate) doSearchGrid(selectedDate);
                } else {
                    $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
                }
            },
            error: function() {
            }
        });
    });
}

/* ========== D1B: 휴일설정 팝업 ========== */

function doOpenD1b(dateStr) {
	$('#d1b-popup').css('visibility', '');
    $('#d1b-buttons').css('visibility', '');
    $('#d1b-popup').dialog('open').dialog('center');
    if (d1bInited) {
        loadD1bFields(dateStr);
    } else {
        // onLoad에서 처리
        d1bDateStr = dateStr;
    }
}
var d1bDateStr = null;

function initD1bPopup() {
    if (d1bInited) return;
    d1bInited = true;

    $('#d1b-save-button').bind('click', doSaveD1b);
    $('#d1b_holiName').textbox('textbox').attr('maxlength', 50);  // LSE_HOLIDAY.HOLI_NAME VARCHAR(50)

    if (d1bDateStr) {
        loadD1bFields(d1bDateStr);
    }
}

function loadD1bFields(dateStr) {
    $('#d1b_holiDate').textbox('setValue', formatDateDisplay(dateStr));
    $('#d1b_holiName').textbox('setValue', '');
    d1bDateStr = dateStr;
}

function doSaveD1b() {
    var holiName = $('#d1b_holiName').textbox('getValue');
    if (!holiName) {
        $.messager.alert(getTitle('WARNING'), '휴일명을 입력하세요.', 'warning');
        return;
    }

    $.ajax({
        url: consts.url.STD23A_UPD2,
        type: 'POST',
        data: {
            holiDate: d1bDateStr,
            holiName: holiName
        },
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success, 'info');
                $('#d1b-popup').dialog('close');
                loadHolidaysAndRenderCalendar();
                if (selectedDate) doSearchGrid(selectedDate);
            } else {
                $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
            }
        },
        error: function() {
        }
    });
}

/* ========== 휴일 해제 ========== */

function doClearHoliday(dateStr) {
    if (!holidayMap[dateStr]) {
        $.messager.alert(getTitle('WARNING'), '해당 날짜는 휴일이 아닙니다.', 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), '휴일을 해제하시겠습니까?\n(' + formatDateDisplay(dateStr) + ' ' + holidayMap[dateStr] + ')', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.STD23A_UPD3,
            type: 'POST',
            data: { holiDate: dateStr },
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert(getTitle('INFO'), result.success, 'info');
                    loadHolidaysAndRenderCalendar();
                    if (selectedDate) doSearchGrid(selectedDate);
                } else {
                    $.messager.alert(getTitle('ERROR'), result.error || '처리 실패', 'error');
                }
            },
            error: function() {
            }
        });
    });
}

/* ========== D2B: CAPA 변경 팝업 ========== */

function doOpenD2b(row) {
    contextMenuRow = row;
    $('#d2b-popup').dialog('open').dialog('center');
    if (d2bInited) {
        loadD2bFields(row);
    }
}

function initD2bPopup() {
    if (d2bInited) return;
    d2bInited = true;

    // 슬라이더 ↔ CAPA 양방향 연동
    $('#d2b_slider').bind('input', function() {
        $('#d2b_capa').numberbox('setValue', $(this).val());
    });
    $('#d2b_capa').numberbox({
        onChange: function(newValue) {
            var val = parseInt(newValue) || 0;
            if (val < 0) val = 0;
            if (val > 1440) val = 1440;
            $('#d2b_slider').val(val);
        }
    });

    $('#d2b_scomment').textbox('textbox').attr('maxlength', 100);
    $('#d2b-save-button').bind('click', doSaveD2b);

    if (contextMenuRow) {
        loadD2bFields(contextMenuRow);
    }
}

function loadD2bFields(row) {
    $('#d2b_workDate').textbox('setValue', formatDateDisplay(row.workDate));
    $('#d2b_mcCode').textbox('setValue', row.mcCode || '');
    $('#d2b_mcName').textbox('setValue', row.mcName || '');
    $('#d2b_capa').numberbox('setValue', row.capa || 0);
    $('#d2b_scomment').textbox('setValue', row.scomment || '');
    $('#d2b_slider').val(row.capa || 0);
}

function doSaveD2b() {
    var capa = $('#d2b_capa').numberbox('getValue');
    var scomment = $('#d2b_scomment').textbox('getValue');

    if (capa === '' || capa === null) {
        $.messager.alert(getTitle('WARNING'), 'CAPA를 입력하세요.', 'warning');
        return;
    }

    $.ajax({
        url: consts.url.STD23B_UPD4,
        type: 'POST',
        data: {
            workDate: contextMenuRow.workDate,
            mcCode: contextMenuRow.mcCode,
            capa: capa,
            scomment: scomment
        },
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success, 'info');
                $('#d2b-popup').dialog('close');
                if (selectedDate) doSearchGrid(selectedDate);
            } else {
                $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
            }
        },
        error: function() {
        }
    });
}

/* ========== CAPA 기본값 복원 ========== */

function doResetCapaDefault() {
    var checkedRows = $('#search-grid').datagrid('getChecked');
    if (checkedRows.length === 0) {
        // 체크된 행이 없으면 우클릭한 행만
        if (contextMenuRow) {
            checkedRows = [contextMenuRow];
        } else {
            $.messager.alert(getTitle('WARNING'), '항목을 선택하세요.', 'warning');
            return;
        }
    }

    $.messager.confirm(getTitle('CONFIRM'), checkedRows.length + '건의 CAPA를 기본값으로 복원하시겠습니까?', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.STD23A_UPD1,
            type: 'POST',
            data: { models: JSON.stringify(checkedRows) },
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert(getTitle('INFO'), result.success, 'info');
                    if (selectedDate) doSearchGrid(selectedDate);
                } else {
                    $.messager.alert(getTitle('ERROR'), result.error || '처리 실패', 'error');
                }
            },
            error: function() {
            }
        });
    });
}

/* ========== 유틸리티 함수 ========== */

function padZero(n) {
    return n < 10 ? '0' + n : '' + n;
}

/**
 * yyyyMMdd → yyyy-MM-dd 표시용
 */
function formatDateDisplay(dateStr) {
    if (!dateStr || dateStr.length !== 8) return dateStr;
    return dateStr.substring(0, 4) + '-' + dateStr.substring(4, 6) + '-' + dateStr.substring(6, 8);
}

/**
 * yyyyMMdd → datebox 설정용 (MM/dd/yyyy 또는 yyyy-MM-dd)
 */
function formatDateForBox(dateStr) {
    if (!dateStr || dateStr.length !== 8) return '';
    return dateStr.substring(4, 6) + '/' + dateStr.substring(6, 8) + '/' + dateStr.substring(0, 4);
}

/**
 * datebox 값 (MM/dd/yyyy) → yyyyMMdd
 */
function dateBoxToYmd(val) {
    if (!val) return '';
    // MM/dd/yyyy 형식
    var parts = val.split('/');
    if (parts.length === 3) {
        return parts[2] + parts[0] + parts[1];
    }
    // yyyy-MM-dd 형식
    parts = val.split('-');
    if (parts.length === 3) {
        return parts[0] + parts[1] + parts[2];
    }
    return val.replace(/[^0-9]/g, '');
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
