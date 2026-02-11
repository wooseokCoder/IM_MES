/**
 * STD23B 휴일관리 JS
 * @author 송우석
 */

/* 전역 변수 */
var calYear;
var calMonth;  /* 0-based (0=1월, 11=12월) */
var holidayMap = {};
var contextMenuDate = null;

/* D1B guard flag */
var d1bInited = false;
var d1bDateStr = null;

/* consts 객체 */
var consts = {
    url: {
        STD23B_SER:  getUrl('/imes/std/std23b/STD23B_SER.json'),
        STD23B_UPD2: getUrl('/imes/std/std23b/STD23B_UPD2.json'),
        STD23B_UPD3: getUrl('/imes/std/std23b/STD23B_UPD3.json')
    },

    init: function() {
        var now = new Date();
        calYear = now.getFullYear();
        calMonth = now.getMonth();

        initMainGrid();
        bindButtonEvents();
        bindCalendarEvents();
    }
};

/* ========== 초기화 ========== */

$(function() {
    consts.init();
});

$(window).load(function() {
    hideLoadingBar();
    doSearch();
});

/* ========== 메인 그리드 (3컬럼: dispHoliDate, holiDate hidden, holiName) ========== */

function initMainGrid() {
    $('#search-grid').datagrid({
        toolbar: '#search-toolbar',
        fit: true,
        fitColumns: true,
        singleSelect: true,
        striped: true,
        rownumbers: true,
        columns: [[
            {field:'dispHoliDate', title:'일자', width:120, halign:'center', align:'center'},
            {field:'holiDate', hidden:true},
            {field:'holiName', title:'휴일명', width:200, halign:'center', align:'left'}
        ]]
    });
}

/* ========== 버튼 이벤트 ========== */

function bindButtonEvents() {
    $('#search-button').bind('click', function() {
        doSearch();
    });

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
}

/* ========== 달력 ========== */

function bindCalendarEvents() {
    $('#cal-prev-year').bind('click', function() {
        calYear--;
        doSearch();
    });
    $('#cal-next-year').bind('click', function() {
        calYear++;
        doSearch();
    });
}

/* ========== 조회 (달력+그리드 동시) ========== */

function doSearch() {
    var sDate = calYear + padZero(calMonth + 1) + '01';
    var endDt = new Date(calYear, calMonth + 12, 0);
    var eDate = endDt.getFullYear() + padZero(endDt.getMonth() + 1) + padZero(endDt.getDate());

    $.ajax({
        url: consts.url.STD23B_SER,
        type: 'POST',
        data: { sHoliDate: sDate, eHoliDate: eDate },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];

            // 1. 달력 갱신
            holidayMap = {};
            for (var i = 0; i < rows.length; i++) {
                holidayMap[rows[i].holiDate] = rows[i].holiName;
            }
            renderYearCalendar();

            // 2. 그리드 갱신
            $('#search-grid').datagrid('loadData', rows);
        },
        error: function() {
            holidayMap = {};
            renderYearCalendar();
            $('#search-grid').datagrid('loadData', []);
        }
    });
}

/* ========== 12개월 연간 달력 렌더링 ========== */

function renderYearCalendar() {
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

    // 달력 우클릭 이벤트
    $('#calendar-body td[data-date]').bind('contextmenu', function(e) {
        e.preventDefault();
        contextMenuDate = $(this).attr('data-date');

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

/* ========== D1B: 휴일설정 팝업 ========== */

function doOpenD1b(dateStr) {
    $('#d1b-popup').dialog('open').dialog('center');
    if (d1bInited) {
        loadD1bFields(dateStr);
    } else {
        d1bDateStr = dateStr;
    }
}

function initD1bPopup() {
    if (d1bInited) return;
    d1bInited = true;

    $('#d1b-save-button').bind('click', doSaveD1b);

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
        url: consts.url.STD23B_UPD2,
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

/* ========== 휴일 해제 ========== */

function doClearHoliday(dateStr) {
    if (!holidayMap[dateStr]) {
        $.messager.alert(getTitle('WARNING'), '해당 날짜는 휴일이 아닙니다.', 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), '휴일을 해제하시겠습니까?\n(' + formatDateDisplay(dateStr) + ' ' + holidayMap[dateStr] + ')', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.STD23B_UPD3,
            type: 'POST',
            data: { holiDate: dateStr },
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert(getTitle('INFO'), result.success, 'info');
                    doSearch();
                } else {
                    $.messager.alert(getTitle('ERROR'), result.error || '처리 실패', 'error');
                }
            },
            error: function() {
                $.messager.alert(getTitle('ERROR'), '처리 중 오류가 발생했습니다.', 'error');
            }
        });
    });
}

/* ========== 유틸리티 함수 ========== */

function padZero(n) {
    return n < 10 ? '0' + n : '' + n;
}

function formatDateDisplay(dateStr) {
    if (!dateStr || dateStr.length !== 8) return dateStr;
    return dateStr.substring(0, 4) + '-' + dateStr.substring(4, 6) + '-' + dateStr.substring(6, 8);
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
