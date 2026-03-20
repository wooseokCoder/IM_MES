/**
 * ============================================================================
 * 화면: ORD15A - 실적/비가동 현황
 * ============================================================================
 * 작성자: 송우석
 * 작성일: 2026-03-16
 *
 * 주요 기능:
 *   1. 실적/비가동 UNION ALL 조회 (TSHP_ACTUAL_QUERY15_4)
 *   2. 퇴근 로그 조회 (TSYS_OFF_LOG_QUERY1)
 *   3. 무작업/퇴근 행 클라이언트 계산 (AS-IS addNonWork/addOffWork)
 *
 * 검색조건:
 *   - 날짜구분 (멀티셀렉: 실적 시작일 / 오더 완료일)
 *   - 시작일 ~ 종료일
 *   - 판매오더, 호기, 거래처, 기계번호 (LIKE)
 *   - 무작업포함 체크박스
 *
 * 행 색상:
 *   - 무작업: AliceBlue (#F0F8FF)
 *   - 퇴근:   WhiteSmoke (#F5F5F5)
 *
 * LookUp 코드: S034 (공정 진행상태)
 * ============================================================================
 */

// ============================================================================
// 1. 전역 변수 / consts 객체
// ============================================================================
var codeDataMap = {};

var consts = {
    url: {
        TSHP_ACTUAL_QUERY15_4: getUrl('/imes/ord/ord15a/TSHP_ACTUAL_QUERY15_4.json'),
        TSYS_OFF_LOG_QUERY1:  getUrl('/imes/ord/ord15a/TSYS_OFF_LOG_QUERY1.json'),
        CODE_LIST:      getUrl('/common/code/code.json')
    },

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

    init: function() {
        consts.codeData = {};
        consts.codeData.S034 = this.loadCode('S034');

        $('#search-button').bind('click', doSearch);
        $('#search-toolbar').bind('keydown', function(e) {
            if (e.keyCode == 13) doSearch();
        });

        initGrid();
    }
};

// ============================================================================
// 2. jQuery 준비
// ============================================================================
$(function() {
    // 500 에러 시 raw 메시지 대신 일반 메시지 표시
    $.ajaxSetup({ statusCode: { 500: function() {
        $.messager.alert('Error', '오류가 발생했습니다.', 'error');
    }}});
    consts.init();
});

$(window).load(function() {
    hideLoadingBar();
    enableGridSortReset('#search-grid');
    GridHeaderMenu('#search-grid', { exportFileName: '실적비가동현황' });

    initDefaultDate();
    initDateTypeCombo();
});

// ============================================================================
// 3. 초기화 함수
// ============================================================================

/**
 * 기본 날짜 설정 (현재 주차 시작/종료)
 */
function initDefaultDate() {
    var now = new Date();
    var day = now.getDay();
    var diff = now.getDate() - day + (day === 0 ? -6 : 1);
    var monday = new Date(now.setDate(diff));
    var sunday = new Date(monday);
    sunday.setDate(monday.getDate() + 6);

    var sDate = formatDate(monday);
    var eDate = formatDate(sunday);

    $('#s_sDate').datebox('setValue', sDate);
    $('#s_eDate').datebox('setValue', eDate);
}

/**
 * 날짜 포맷 (yyyy-MM-dd)
 */
function formatDate(d) {
    var mm = ('0' + (d.getMonth() + 1)).slice(-2);
    var dd = ('0' + d.getDate()).slice(-2);
    return d.getFullYear() + '-' + mm + '-' + dd;
}

/**
 * 날짜 구분 콤보 초기화 (POP42A 체크콤보 패턴)
 * - 체크박스 포맷터 (AS-IS CheckedComboBoxEdit 대응)
 * - "모두선택"은 values에 포함하되 텍스트 표시에서 제외
 * - 기본값: "실적 시작일" 체크
 */
function initDateTypeCombo() {
    var realItems = ['WORK_DATE', 'WO_DATE'];
    var isUpdating = false;

    $('#s_dateTypes').combobox({
        width: 120,
        editable: false,
        panelHeight: 'auto',
        multiple: true,
        separator: ',',
        valueField: 'id',
        textField: 'text',
        data: [
            {id: 'ALL', text: '모두선택'},
            {id: 'WORK_DATE', text: '실적 시작일'},
            {id: 'WO_DATE', text: '오더 완료일'}
        ],
        formatter: function(row) {
            return '<input type="checkbox" style="vertical-align:middle; margin-right:4px;">' + row.text;
        },
        onSelect: function(rec) {
            if (isUpdating) return;
            isUpdating = true;
            if (rec.id === 'ALL') {
                $('#s_dateTypes').combobox('setValues', ['ALL'].concat(realItems));
            } else {
                var vals = $('#s_dateTypes').combobox('getValues');
                if (_isAllRealSelected(vals, realItems) && !_containsValue(vals, 'ALL')) {
                    vals.push('ALL');
                    $('#s_dateTypes').combobox('setValues', vals);
                }
            }
            _updateDateTypeText();
            isUpdating = false;
            _syncDateTypePanel();
        },
        onUnselect: function(rec) {
            if (isUpdating) return;
            isUpdating = true;
            if (rec.id === 'ALL') {
                $('#s_dateTypes').combobox('setValues', []);
            } else {
                var vals = $('#s_dateTypes').combobox('getValues');
                var newVals = [];
                for (var i = 0; i < vals.length; i++) {
                    if (vals[i] !== 'ALL') newVals.push(vals[i]);
                }
                $('#s_dateTypes').combobox('setValues', newVals);
            }
            _updateDateTypeText();
            isUpdating = false;
            _syncDateTypePanel();
        },
        onShowPanel: function() {
            _syncDateTypePanel();
        }
    });

    // 초기값: "실적 시작일" 선택
    $('#s_dateTypes').combobox('setValues', ['WORK_DATE']);
    _updateDateTypeText();
}

/** 콤보박스 텍스트를 실제 항목명만 표시 ("모두선택" 제외) */
function _updateDateTypeText() {
    var vals = $('#s_dateTypes').combobox('getValues');
    var data = $('#s_dateTypes').combobox('getData');
    var texts = [];
    for (var i = 0; i < data.length; i++) {
        if (data[i].id !== 'ALL' && _containsValue(vals, data[i].id)) {
            texts.push(data[i].text);
        }
    }
    $('#s_dateTypes').combobox('setText', texts.join(', '));
}

/** 드롭다운 체크박스 상태를 현재 선택값과 동기화 */
function _syncDateTypePanel() {
    var vals = $('#s_dateTypes').combobox('getValues');
    var data = $('#s_dateTypes').combobox('getData');
    var $panel = $('#s_dateTypes').combobox('panel');

    $panel.find('.combobox-item').each(function(idx) {
        if (idx < data.length) {
            var checked = _containsValue(vals, data[idx].id);
            $(this).find('input[type=checkbox]').prop('checked', checked);
        }
    });
}

/** 배열에 값 포함 여부 (indexOf 대체 — IE 호환) */
function _containsValue(arr, val) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] === val) return true;
    }
    return false;
}

/** 실제 항목 전부 선택됐는지 확인 */
function _isAllRealSelected(vals, realItems) {
    for (var i = 0; i < realItems.length; i++) {
        if (!_containsValue(vals, realItems[i])) return false;
    }
    return true;
}

/**
 * 그리드 초기화
 */
function initGrid() {
    var s034Map = {};
    var s034Items = consts.codeData.S034 || [];
    for (var i = 0; i < s034Items.length; i++) {
        var cd = s034Items[i].codeCd || s034Items[i].codeId || '';
        var nm = s034Items[i].codeName || '';
        s034Map[cd] = nm;
    }

    $('#search-grid').datagrid({
        fit: true,
        method: 'post',
        rownumbers: true,
        singleSelect: true,
        striped: true,
        nowrap: true,
        fitColumns: false,
        pagination: true,
        pageSize: 100,
        pageList: [50, 100, 200, 500],
        loadFilter: function(data) {
            if ($.isArray(data)) {
                var dg = $(this);
                var opts = dg.datagrid('options');
                var pager = dg.datagrid('getPager');
                pager.pagination({
                    onSelectPage: function(pageNum, pageSize) {
                        opts.pageNumber = pageNum;
                        opts.pageSize = pageSize;
                        pager.pagination('refresh', {
                            pageNumber: pageNum,
                            pageSize: pageSize
                        });
                        dg.datagrid('loadData', data);
                    }
                });
                if (!opts.pageNumber) opts.pageNumber = 1;
                var start = (opts.pageNumber - 1) * opts.pageSize;
                var end = start + opts.pageSize;
                return {
                    total: data.length,
                    rows: data.slice(start, end)
                };
            }
            return data;
        },
        columns: [[
            {field: 'KEY',          title: 'KEY',             width: 100, align: 'left'},
            {field: 'ACT_TYPE',     title: '구분',            width: 70,  align: 'center'},
            {field: 'actContents',  title: '비가동코드',      width: 100, align: 'left'},
            {field: 'sapCode',      title: '비가동코드(SAP)', width: 120, align: 'left',   hidden: true},
            {field: 'idleName',     title: '비가동명',        width: 130, align: 'left'},
            {field: 'orderNo',      title: '판매오더',        width: 110, align: 'left'},
            {field: 'orderLine',    title: '라인',            width: 60,  align: 'center'},
            {field: 'prodHogi',     title: '호기',            width: 60,  align: 'center'},
            {field: 'mcNo',         title: '기계번호',        width: 100, align: 'left'},
            {field: 'sapWoNo',      title: '생산오더번호',    width: 130, align: 'left'},
            {field: 'woSeq',        title: '오퍼레이션',      width: 90,  align: 'center'},
            {field: 'procCode',     title: '공정명',          width: 120, align: 'left'},
            {field: 'customer',     title: '거래처',          width: 140, align: 'left'},
            {field: 'procSt',       title: 'ST',              width: 70,  align: 'right',
                formatter: formatDecimal2},
            {field: 'readySt',      title: '준비작업 ST',     width: 90,  align: 'right',
                formatter: formatDecimal2},
            {field: 'empCode',      title: '작업자 코드',     width: 100, align: 'center'},
            {field: 'empName',      title: '작업자',          width: 90,  align: 'left'},
            {field: 'actStartTime', title: '시작시간',        width: 140, align: 'center',
                formatter: formatDateTime},
            {field: 'actEndTime',   title: '종료시간',        width: 140, align: 'center',
                formatter: formatDateTime},
            {field: 'actTime',      title: '실적시간(분)',    width: 100, align: 'right',
                formatter: formatNumber},
            {field: 'woEndTime',    title: '오더완료일',      width: 140, align: 'center',
                formatter: formatDateTime},
            {field: 'sapMcCode',    title: '작업장 코드',     width: 100, align: 'center'},
            {field: 'mcName',       title: '작업장',          width: 120, align: 'left'},
            {field: 'preWork',      title: '준비작업여부',    width: 90,  align: 'center'},
            {field: 'prodType',     title: '작업장 구분',     width: 90,  align: 'center'},
            {field: 'procStat',     title: '상태',            width: 70,  align: 'center',
                formatter: function(value) {
                    return s034Map[value] || value || '';
                }
            },
            {field: 'ngId',         title: '부적합/결품ID',   width: 130, align: 'left'},
            {field: 'modelType',    title: '전동/유압',       width: 80,  align: 'center'},
            {field: 'partCode',     title: '대표코드',        width: 120, align: 'left'},
            {field: 'modelNo',      title: '모델',            width: 130, align: 'left'}
        ]],
        rowStyler: function(index, row) {
            if (row.ACT_TYPE === '무작업') {
                return 'background-color:#F0F8FF;';
            }
            if (row.ACT_TYPE === '퇴근') {
                return 'background-color:#F5F5F5;';
            }
        }
    });

    // common.css width:100% 강제 확장 방지 — 가로 스크롤 허용
    $('#search-grid').datagrid('getPanel').find('.datagrid-view').addClass('noStyle');
}

// ============================================================================
// 4. 조회
// ============================================================================

/**
 * 조회 실행
 */
function doSearch() {
    var dateTypes = $('#s_dateTypes').combobox('getValues');
    var sDate = $('#s_sDate').datebox('getValue').replace(/-/g, '');
    var eDate = $('#s_eDate').datebox('getValue').replace(/-/g, '');

    if (!sDate || !eDate) {
        $.messager.alert(getTitle('WARNING'), '날짜를 선택하세요.', 'warning');
        return;
    }

    var sWorkDate = '';
    var eWorkDate = '';
    var sWoDate = '';
    var eWoDate = '';

    for (var i = 0; i < dateTypes.length; i++) {
        if (dateTypes[i] === 'WORK_DATE') {
            sWorkDate = sDate;
            eWorkDate = eDate;
        }
        if (dateTypes[i] === 'WO_DATE') {
            sWoDate = sDate;
            eWoDate = eDate;
        }
    }

    var params = {
        sWorkDate: sWorkDate,
        eWorkDate: eWorkDate,
        sWoDate:   sWoDate,
        eWoDate:   eWoDate,
        orderLike: $('#s_orderLike').textbox('getText'),
        hogiLike:  $('#s_hogiLike').textbox('getText'),
        cvndLike:  $('#s_cvndLike').textbox('getText'),
        mcNoLike:  $('#s_mcNoLike').textbox('getText')
    };

    var isNonwork = $('#s_isNonwork').is(':checked');

    $('#search-grid').datagrid('loading');

    $.ajax({
        url: consts.url.TSHP_ACTUAL_QUERY15_4,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(response) {
            var rows = response.rows || response || [];

            if (isNonwork) {
                fetchOffLogAndProcess(rows, sDate, eDate);
            } else {
                $('#search-grid').datagrid('loadData', rows);
                $('#search-grid').datagrid('loaded');
                reapplySort();
            }
        },
        error: function() {
            $('#search-grid').datagrid('loaded');
        }
    });
}

/**
 * 퇴근 로그 조회 후 무작업/퇴근 행 계산
 */
function fetchOffLogAndProcess(mainRows, sDate, eDate) {
    $.ajax({
        url: consts.url.TSYS_OFF_LOG_QUERY1,
        type: 'POST',
        data: { sDate: sDate, eDate: eDate },
        dataType: 'json',
        success: function(response) {
            var offRows = response.rows || response || [];
            var processed = processNonWorkAndOffWork(mainRows, offRows);
            $('#search-grid').datagrid('loadData', processed);
            $('#search-grid').datagrid('loaded');
            reapplySort();
        },
        error: function() {
            $('#search-grid').datagrid('loadData', mainRows);
            $('#search-grid').datagrid('loaded');
            reapplySort();
        }
    });
}

// ============================================================================
// 5. 무작업/퇴근 계산 로직
// ============================================================================

/**
 * 무작업/퇴근 행 추가 처리
 * @param mainRows 실적/비가동 목록
 * @param offRows  퇴근 로그 목록
 * @return 무작업/퇴근 행이 추가된 최종 목록
 */
function processNonWorkAndOffWork(mainRows, offRows) {
    var now = new Date();

    // ACT_END_TIME이 null인 행 → 현재 시각으로 채움
    for (var i = 0; i < mainRows.length; i++) {
        if (!mainRows[i].actEndTime) {
            mainRows[i].actEndTime = formatFullDateTime(now);
        }
    }

    // EMP_CODE별 그룹화
    var empMap = {};
    for (var i = 0; i < mainRows.length; i++) {
        var emp = mainRows[i].empCode;
        if (!emp) continue;
        if (!empMap[emp]) empMap[emp] = [];
        empMap[emp].push(mainRows[i]);
    }

    // 퇴근 로그 맵 (empCode + offDate → regDate)
    var offMap = {};
    for (var i = 0; i < offRows.length; i++) {
        var key = offRows[i].empCode + '_' + offRows[i].offDate;
        offMap[key] = offRows[i].regDate;
    }

    var result = [];

    for (var emp in empMap) {
        var rows = empMap[emp];
        // ACT_START_TIME 기준 정렬
        rows.sort(function(a, b) {
            return parseDateTime(a.actStartTime) - parseDateTime(b.actStartTime);
        });

        if (rows.length === 0) continue;

        // 첫 레코드 시작일 기준 08:30
        var firstStart = parseDateTime(rows[0].actStartTime);
        var dayStart = new Date(firstStart.getFullYear(), firstStart.getMonth(), firstStart.getDate(), 8, 30, 0);

        var prevEnd = dayStart;

        for (var j = 0; j < rows.length; j++) {
            var rowStart = parseDateTime(rows[j].actStartTime);
            var rowEnd = parseDateTime(rows[j].actEndTime);

            // 이전 종료 ~ 현재 시작 사이에 갭 있으면 무작업 추가
            if (prevEnd < rowStart) {
                var gapMinutes = (rowStart - prevEnd) / 60000;
                if (gapMinutes >= 1) {
                    var nextDayStart = new Date(prevEnd.getFullYear(), prevEnd.getMonth(), prevEnd.getDate() + 1, 8, 30, 0);

                    // 날짜 경계(08:30)를 넘는 경우
                    if (nextDayStart > prevEnd && nextDayStart < rowStart) {
                        var offKey = rows[j].empCode + '_' + formatDateCompact(prevEnd);
                        if (offMap[offKey]) {
                            var offTime = parseDateTime(offMap[offKey]);
                            addNonWorkRow(result, rows[j], prevEnd, offTime);
                            addOffWorkRow(result, rows[j], offTime);
                        } else {
                            addNonWorkRow(result, rows[j], prevEnd, nextDayStart);
                        }
                        addNonWorkRow(result, rows[j], nextDayStart, rowStart);
                    } else {
                        addNonWorkRow(result, rows[j], prevEnd, rowStart);
                    }
                }
            }

            result.push(rows[j]);
            prevEnd = rowEnd;

            // 마지막 행이면 퇴근 체크
            if (j === rows.length - 1) {
                var offKey2 = rows[j].empCode + '_' + formatDateCompact(rowEnd);
                if (offMap[offKey2]) {
                    addOffWorkRow(result, rows[j], parseDateTime(offMap[offKey2]));
                }
            }
        }
    }

    // 최종 정렬 (EMP_NAME, EMP_CODE, ACT_START_TIME)
    result.sort(function(a, b) {
        var cmp = (a.empName || '').localeCompare(b.empName || '');
        if (cmp !== 0) return cmp;
        cmp = (a.empCode || '').localeCompare(b.empCode || '');
        if (cmp !== 0) return cmp;
        return parseDateTime(a.actStartTime) - parseDateTime(b.actStartTime);
    });

    return result;
}

/**
 * 무작업 행 추가
 */
function addNonWorkRow(result, refRow, startTime, endTime) {
    var gapMinutes = Math.floor((endTime - startTime) / 60000);
    if (gapMinutes < 1) return;

    result.push({
        ACT_TYPE: '무작업',
        empCode: refRow.empCode,
        empName: refRow.empName,
        actStartTime: formatFullDateTime(startTime),
        actEndTime: formatFullDateTime(endTime),
        actTime: gapMinutes
    });
}

/**
 * 퇴근 행 추가
 */
function addOffWorkRow(result, refRow, offTime) {
    result.push({
        ACT_TYPE: '퇴근',
        empCode: refRow.empCode,
        empName: refRow.empName,
        actStartTime: formatFullDateTime(offTime),
        actEndTime: formatFullDateTime(offTime)
    });
}

// ============================================================================
// 6. 유틸리티 함수
// ============================================================================

/**
 * 날짜/시간 문자열 파싱
 * 지원 형식: "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", ISO 등
 */
function parseDateTime(str) {
    if (!str) return new Date(0);
    if (str instanceof Date) return str;
    var s = String(str).replace(/T/, ' ').replace(/Z$/, '');
    var d = new Date(s);
    if (isNaN(d.getTime())) {
        d = new Date(s.replace(/-/g, '/'));
    }
    return d;
}

/**
 * Date → "yyyy-MM-dd HH:mm" 포맷
 */
function formatFullDateTime(d) {
    if (!(d instanceof Date)) return d;
    var mm = ('0' + (d.getMonth() + 1)).slice(-2);
    var dd = ('0' + d.getDate()).slice(-2);
    var hh = ('0' + d.getHours()).slice(-2);
    var mi = ('0' + d.getMinutes()).slice(-2);
    return d.getFullYear() + '-' + mm + '-' + dd + ' ' + hh + ':' + mi;
}

/**
 * Date → "yyyyMMdd" 포맷 (퇴근 로그 키 조합용)
 */
function formatDateCompact(d) {
    if (!(d instanceof Date)) return '';
    var mm = ('0' + (d.getMonth() + 1)).slice(-2);
    var dd = ('0' + d.getDate()).slice(-2);
    return '' + d.getFullYear() + mm + dd;
}

/**
 * loadData 후 기존 정렬 상태 재적용
 */
function reapplySort() {
    var opts = $('#search-grid').datagrid('options');
    if (opts.sortName) {
        $('#search-grid').datagrid('sort', {
            sortName: opts.sortName,
            sortOrder: opts.sortOrder || 'asc'
        });
    }
}

/**
 * 소수점 2자리 고정 포맷터
 */
function formatDecimal2(value) {
    if (value === null || value === undefined || value === '') return '';
    var num = Number(value);
    if (isNaN(num)) return value;
    return num.toFixed(2);
}

/**
 * 숫자 포맷터 (천단위 콤마)
 */
function formatNumber(value) {
    if (value === null || value === undefined || value === '') return '';
    var num = Number(value);
    if (isNaN(num)) return value;
    return num.toLocaleString();
}

/**
 * 날짜/시간 포맷터 (그리드 컬럼 formatter)
 * "yyyy-MM-dd HH:mm" 형식으로 표시
 */
function formatDateTime(value) {
    if (!value) return '';
    var d = parseDateTime(value);
    if (isNaN(d.getTime())) return value;
    return formatFullDateTime(d);
}

/**
 * 로딩바 숨기기 + 메인 레이아웃 표시
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#main-layout').show();
}
