/**
 * ============================================================================
 * 모듈: POP32A_DIALOG - 비가동시간 등록 팝업 공통 JS
 * ============================================================================
 * 파일: resources/js/imes/pop/pop32a_dialog.js
 * 설명: pop32a_d0a.jsp(비가동시간 등록)와 pop32a_d1a.jsp(사원 선택) 팝업에서
 *       사용하는 공통 JavaScript.
 *       pop32b.js 가 없는 화면(예: pop32a.jsp)에서 팝업을 호출할 때 자동 로드됨.
 *       pop32b.jsp 에서 호출 시에는 pop32b.js 에서 동일 로직을 처리하므로
 *       이 파일은 로드되지 않음.
 * ============================================================================
 */

// 중복 로딩 방지 마커
var _POP32A_DIALOG_LOADED = true;

// ============================================================================
// URL 상수 (pop32b.js 의 consts 와 충돌 방지를 위해 별도 객체 사용)
// ============================================================================
var _d0aConsts = {
    url: {
        POP32A_SER2 : getUrl('/imes/pop/pop32a/POP32A_SER2.json'),
        POP32A_IDLE : getUrl('/imes/pop/pop32a/POP32A_IDLE.json'),
        POP32A_INS  : getUrl('/imes/pop/pop32a/POP32A_INS.json')
    }
};

// ============================================================================
// 전역 변수
// ============================================================================
// 공장코드: 부모 페이지(pop32a.js 등)에서 이미 선언된 경우 그 값을 사용
if (typeof window.plants === 'undefined') {
    window.plants = '3605';
}

var dialogMode = 'NEW';  // NEW / EDIT

// ============================================================================
// 화면 초기화
// ============================================================================
$(function() {
    initEditDialog();
    initEmpGrid();
    initEmpSearchGrid();
    bindDialogButtonEvents();
});

// ============================================================================
// edit-dialog / emp-search-dialog 초기화
// ============================================================================
function initEditDialog() {
    // 비가동시간 등록 다이얼로그 (POP32A D0A)
    // class="easyui-dialog"는 사용하지 않고 여기서만 초기화 (중복 초기화 방지)
    $('#edit-dialog').dialog({
        title   : '비가동시간 등록',
        closed  : true,
        modal   : true,
        width   : 515,
        height  : 'auto',
        buttons : '#edit-dialog-buttons',
        onOpen  : function() {
            $(this).css('visibility', '');
            $(this).dialog('center');
        },
        onClose : function() {
            clearEditDialogFields();
        }
    });

    // 비가동코드 콤보박스 초기화 (데이터 로드는 팝업 오픈 시 수행)
    // valueField: scode (TSTD_IDLECODE 기본키), textField: idlename (DB 소문자 반환)
    $('#f_idleCode').combobox({
        valueField: 'scode',
        textField: 'idlename',
        required: true
    });

    // 작업자 검색 다이얼로그 (POP32A D1A)
    // class="easyui-dialog"는 사용하지 않고 여기서만 초기화 (중복 초기화 방지)
    $('#emp-search-dialog').dialog({
        title   : '사원 선택',
        closed  : true,
        modal   : true,
        width   : 530,
        height  : 'auto',
        buttons : '#emp-search-dialog-buttons',
        onOpen  : function() {
            $(this).css('visibility', '');
            $(this).dialog('center');
            // 팝업 오픈 시 자동 조회
            doEmpSearch();
        },
        onClose : function() {
            clearEmpSearchFields();
        }
    });
}

// ============================================================================
// 작업자 그리드 초기화 (edit-dialog 내부 emp-grid)
// ============================================================================
function initEmpGrid() {
    $('#emp-grid').datagrid({
        fit: false,
        striped: true,
        singleSelect: false,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'empCode',
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault();
            $('#emp-grid').datagrid('selectRow', rowIndex);
            $('#emp-grid-context-menu').menu('show', {left: e.pageX, top: e.pageY});
        }
    });
}

// ============================================================================
// 작업자 검색 그리드 초기화 (emp-search-dialog 내부 emp-search-grid)
// ============================================================================
function initEmpSearchGrid() {
    $('#emp-search-grid').datagrid({
        fit: false,
        striped: true,
        singleSelect: false,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'empCode',
        onDblClickRow: function(index, row) {
            doSelectEmpFromSearch();
        }
    });
}

// ============================================================================
// 다이얼로그 버튼 이벤트 바인딩
// ============================================================================
function bindDialogButtonEvents() {
    // .off().on() 패턴: 중복 호출 시에도 핸들러가 1개만 유지됨

    // 신규등록 다이얼로그 저장
    $('#dialog-save-button').off('click').on('click', function() {
        doSaveEditDialog();
    });

    // 신규등록 다이얼로그 초기화
    $('#dialog-clear-button').off('click').on('click', function() {
        clearEditDialogFields();
    });

    // 신규등록 다이얼로그 닫기
    $('#dialog-close-button').off('click').on('click', function() {
        $('#edit-dialog').dialog('close');
    });

    // 작업자 검색 버튼 (edit-dialog 내부) - 이벤트 위임
    $('#edit-dialog').off('click', '#emp-search-button').on('click', '#emp-search-button', doOpenEmpSearch);

    // 작업자 그리드 우클릭 메뉴 삭제 버튼
    $('#emp-grid-context-menu').off('click', '#ctx-emp-delete').on('click', '#ctx-emp-delete', doRemoveSelectedEmp);

    // 작업자 검색 다이얼로그 조회 버튼
    $('#emp-search-dialog').off('click', '#emp-search-search-button').on('click', '#emp-search-search-button', doEmpSearch);

    // 작업자 검색 다이얼로그 선택 버튼
    $('#emp-search-select-button').off('click').on('click', function() {
    	doSelectEmpFromSearch();
    });
//    $('#emp-search-dialog').off('click', '#emp-search-select-button').on('click', '#emp-search-select-button', doSelectEmpFromSearch);

    // 작업자 검색 다이얼로그 닫기 버튼
    $('#emp-search-close-button').off('click').on('click', function() {
    	doEmpSearchClose();
    });
//    $('#emp-search-dialog').off('click', '#emp-search-close-button').on('click', '#emp-search-close-button', doEmpSearchClose);

    // 작업자 검색 입력 필드 Enter 키 바인딩
    $('#f_empLike').off('keydown.empSearch').on('keydown.empSearch', function(e) {
        if (e.keyCode === 13) {
            doEmpSearch();
        }
    });
}

// ============================================================================
// 신규등록 다이얼로그 열기
// ============================================================================
function doOpenNew() {
    dialogMode = 'NEW';
    $('#edit-dialog').dialog('setTitle', '비가동 등록');
    $('#dialog-save-button').show();
//    $('#dialog-clear-button').show();
    $('#dialog-close-button').show();

    // 비가동코드 콤보박스 데이터 로드 (팝업 오픈 시 AJAX 호출 후 loadData로 바인딩)
    $.ajax({
        url: _d0aConsts.url.POP32A_IDLE,
        type: 'POST',
        data: { plants: window.plants },
        dataType: 'json',
        success: function(data) {
            var rows = data.rows || data || [];
            $('#f_idleCode').combobox({
                data: rows,
                valueField: 'scode',
                textField: 'idleName'
            });
        }
    });

    // 기본값 설정 (원본: DateTime.Now)
    var today = new Date();
    $('#f_startDate').datebox('setValue', formatDate(today));
    $('#f_startTime').timespinner('setValue', formatTime(today));
    $('#f_endDate').datebox('setValue', formatDate(today));
    $('#f_endTime').timespinner('setValue', formatTime(today));

    // 작업자 그리드 초기화
    $('#emp-grid').datagrid('loadData', []);

    $('#edit-dialog').dialog('open');
}

// ============================================================================
// 작업자 검색 다이얼로그 열기 (POP32A_D1A 팝업)
// ============================================================================
function doOpenEmpSearch() {
    $('#f_empLike').textbox('setValue', '');
    $('#emp-search-dialog').dialog('open');
}

// ============================================================================
// 작업자 검색 (POP32A_SER2)
// ============================================================================
function doEmpSearch() {
    var params = {
        plants: window.plants,
        empLike: $('#f_empLike').textbox('getValue') || ''
    };

    $.ajax({
        url: _d0aConsts.url.POP32A_SER2,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            if (result && result.rows) {
                var rows = result.rows;
                for (var i = 0; i < rows.length; i++) {
                    if (!rows[i].sel) {
                        rows[i].sel = '0';
                    }
                }
                $('#emp-search-grid').datagrid('loadData', {total: rows.length, rows: rows});
            } else {
                $('#emp-search-grid').datagrid('loadData', []);
            }
        },
        error: function() {
            $.messager.alert('오류', '작업자 조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 작업자 검색 다이얼로그에서 선택된 작업자들을 edit-dialog의 emp-grid에 추가
// ============================================================================
function doSelectEmpFromSearch() {
    var allRows = $('#emp-search-grid').datagrid('getRows');
    var selectedRows = [];

    // SEL='1'인 행 찾기
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel == '1') {
            selectedRows.push(allRows[i]);
        }
    }

    // SEL='1'인 행이 없으면 포커스된 행 사용
    if (selectedRows.length === 0) {
        var focusedRow = $('#emp-search-grid').datagrid('getSelected');
        if (focusedRow) {
            selectedRows.push(focusedRow);
        } else {
            $.messager.alert('알림', '선택할 작업자를 선택하세요.', 'info');
            return;
        }
    }

    // 기존 emp-grid 데이터 가져오기
    var existing = $('#emp-grid').datagrid('getData');
    var merged = [];

    for (var i = 0; i < existing.rows.length; i++) {
        merged.push(existing.rows[i]);
    }

    // 새로 선택된 데이터 추가 (중복 체크)
    for (var i = 0; i < selectedRows.length; i++) {
        var exists = false;
        for (var j = 0; j < merged.length; j++) {
            if (merged[j].empCode == selectedRows[i].empCode) {
                exists = true;
                break;
            }
        }
        if (!exists) {
            var newRow = {
                empCode: selectedRows[i].empCode,
                empName: selectedRows[i].empName,
                mcCode:  selectedRows[i].mainMcCode || selectedRows[i].mcCode,
                mcName:  selectedRows[i].mainMcName || selectedRows[i].mcName,
                sel:     '0'
            };
            merged.push(newRow);
        }
    }

    $('#emp-grid').datagrid('loadData', {total: merged.length, rows: merged});
    $('#emp-search-dialog').dialog('close');
}

//============================================================================
//작업자 검색 다이얼로그 닫기
//============================================================================
function doEmpSearchClose() {
	$('#emp-search-dialog').dialog('close');
}

// ============================================================================
// 작업자 검색 다이얼로그 필드 초기화
// ============================================================================
function clearEmpSearchFields() {
    $('#f_empLike').textbox('setValue', '');
    $('#emp-search-grid').datagrid('loadData', []);
}

// ============================================================================
// 선택된 작업자 삭제
// SEL='1'인 행 삭제, 선택된 행이 없으면 포커스된 행 삭제
// ============================================================================
function doRemoveSelectedEmp() {
    var allRows = $('#emp-grid').datagrid('getRows');
    var selectedRows = [];

    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel == '1') {
            selectedRows.push(allRows[i]);
        }
    }

    if (selectedRows.length === 0) {
        var focusedRow = $('#emp-grid').datagrid('getSelected');
        if (focusedRow) {
            selectedRows.push(focusedRow);
        } else {
            $.messager.alert('알림', '삭제할 작업자를 선택하세요.', 'info');
            return;
        }
    }

    var remaining = [];
    for (var i = 0; i < allRows.length; i++) {
        var found = false;
        for (var j = 0; j < selectedRows.length; j++) {
            if (allRows[i].empCode == selectedRows[j].empCode) {
                found = true;
                break;
            }
        }
        if (!found) {
            remaining.push(allRows[i]);
        }
    }

    $('#emp-grid').datagrid('loadData', {total: remaining.length, rows: remaining});
}

// ============================================================================
// 편집 다이얼로그 필드 검증
// 유효하지 않은 필드는 gradient 테두리 표시, 유효한 필드는 원상복구
// ============================================================================
function validateEditDialogFields() {
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
        $comp.css({
            'border'            : '',
            'background-image'  : '',
            'background-origin' : '',
            'background-clip'   : ''
        });
    }

    var $idleCodeWrap = $('#f_idleCode').next();
    if (!$('#f_idleCode').combobox('getValue')) {
        setFieldError($idleCodeWrap);
        valid = false;
    } else {
        clearFieldError($idleCodeWrap);
    }

    var $startDateWrap = $('#f_startDate').next();
    if (!$('#f_startDate').datebox('getValue')) {
        setFieldError($startDateWrap);
        valid = false;
    } else {
        clearFieldError($startDateWrap);
    }

    var $startTimeWrap = $('#f_startTime').next();
    if (!$('#f_startTime').timespinner('getValue')) {
        setFieldError($startTimeWrap);
        valid = false;
    } else {
        clearFieldError($startTimeWrap);
    }

    var $endDateWrap = $('#f_endDate').next();
    if (!$('#f_endDate').datebox('getValue')) {
        setFieldError($endDateWrap);
        valid = false;
    } else {
        clearFieldError($endDateWrap);
    }

    var $endTimeWrap = $('#f_endTime').next();
    if (!$('#f_endTime').timespinner('getValue')) {
        setFieldError($endTimeWrap);
        valid = false;
    } else {
        clearFieldError($endTimeWrap);
    }

    return valid;
}

// ============================================================================
// 편집 다이얼로그 저장
// ============================================================================
function doSaveEditDialog() {
    if (!validateEditDialogFields()) {
        return;
    }

    var empRows = $('#emp-grid').datagrid('getRows');
    if (empRows.length == 0) {
        $.messager.alert('알림', '비가동 대상 작업자를 입력 해 주세요', 'info');
        return;
    }

    $.messager.confirm('확인', '비가동을 등록하시겠습니까?', function(r) {
        if (!r) {
            return;
        }

        var startDateStr = $('#f_startDate').datebox('getValue');
        var startTimeObj = $('#f_startTime').timespinner('getValue');
        var endDateStr   = $('#f_endDate').datebox('getValue');
        var endTimeObj   = $('#f_endTime').timespinner('getValue');

        var startDate = parseDate(startDateStr);
        var endDate   = parseDate(endDateStr);

        var startHours   = startTimeObj.getHours();
        var startMinutes = startTimeObj.getMinutes();
        var startSeconds = startTimeObj.getSeconds();
        var endHours     = endTimeObj.getHours();
        var endMinutes   = endTimeObj.getMinutes();
        var endSeconds   = endTimeObj.getSeconds();

        var startDateTime = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate(),
                                     startHours, startMinutes, startSeconds);
        var endDateTime   = new Date(endDate.getFullYear(), endDate.getMonth(), endDate.getDate(),
                                     endHours, endMinutes, endSeconds);

        var workDate = formatDate(startDateTime).replace(/-/g, '');
        var idleTime = Math.round((endDateTime - startDateTime) / 60000);

        if (idleTime <= 0) {
            $.messager.alert('알림', '종료시간은 시작시간보다 이후여야 합니다.', 'info');
            return;
        }

        // TODO: 시간 중복 체크 (POP32A_SER3) 구현 후 연결
        doSaveIdleTime(empRows, workDate, startDateTime, endDateTime, idleTime);
    });
}

// ============================================================================
// 비가동시간 저장
// ============================================================================
function doSaveIdleTime(empRows, workDate, startDateTime, endDateTime, idleTime) {
    var savePromises = [];

    for (var i = 0; i < empRows.length; i++) {
        var emp    = empRows[i];
        var params = {
            workDate:  workDate,
            mcCode:    emp.mcCode,
            empCode:   emp.empCode,
            idleCode:  $('#f_idleCode').combobox('getValue'),
            startTime: formatDateTimeForServer(startDateTime),
            endTime:   formatDateTimeForServer(endDateTime),
            idleTime:  idleTime,
            idleState: '0',
            scomment:  ($('#f_scomment').length ? $('#f_scomment').textbox('getValue') : '') || ''
        };

        savePromises.push(
            $.ajax({
                url:      _d0aConsts.url.POP32A_INS,
                type:     'POST',
                data:     params,
                dataType: 'json'
            })
        );
    }

    $.when.apply($, savePromises).done(function() {
        $.messager.alert('알림', '등록되었습니다.', 'info', function() {
            $('#edit-dialog').dialog('close');
            // 부모 페이지의 doSearch() 호출 (pop32a.js 등에서 정의된 경우)
            if (typeof doSearch === 'function') {
                doSearch();
            }
        });
    }).fail(function() {
        $.messager.alert('오류', '등록 중 오류가 발생했습니다.', 'error');
    });
}

// ============================================================================
// 편집 다이얼로그 필드 초기화
// ============================================================================
function clearEditDialogFields() {
    $('#edit-form').form('clear');
    $('#emp-grid').datagrid('loadData', []);

    var today = new Date();
    $('#f_startDate').datebox('setValue', formatDate(today));
    $('#f_startTime').timespinner('setValue', formatTime(today));
    $('#f_endDate').datebox('setValue', formatDate(today));
    $('#f_endTime').timespinner('setValue', formatTime(today));
}

// ============================================================================
// 포맷터 / 토글
// ============================================================================

/**
 * 작업자 그리드(emp-grid) SEL 컬럼 체크박스 포맷터
 */
function formatEmpSel(value, row, index) {
    var checked = (value === '1') ? ' checked' : '';
    return '<input type="checkbox"' + checked + ' onclick="toggleEmpSel(' + index + ', this)" />';
}

/**
 * 작업자 그리드(emp-grid) SEL 체크박스 토글
 */
function toggleEmpSel(index, cb) {
    var row = $('#emp-grid').datagrid('getRows')[index];
    if (row) {
        row.sel = cb.checked ? '1' : '0';
    }
}

/**
 * 작업자 검색 그리드(emp-search-grid) SEL 컬럼 체크박스 포맷터
 */
function formatEmpSearchSel(value, row, index) {
    var checked = (value === '1') ? ' checked' : '';
    return '<input type="checkbox"' + checked + ' onclick="toggleEmpSearchSel(' + index + ', this)" />';
}

/**
 * 작업자 검색 그리드(emp-search-grid) SEL 체크박스 토글
 */
function toggleEmpSearchSel(index, cb) {
    var row = $('#emp-search-grid').datagrid('getRows')[index];
    if (row) {
        row.sel = cb.checked ? '1' : '0';
    }
}

// ============================================================================
// 유틸리티 함수
// (부모 페이지 JS에 이미 정의된 경우 덮어쓰지 않도록 typeof 가드 적용)
// ============================================================================

/**
 * Date → 'yyyy-MM-dd' 문자열
 */
if (typeof window.formatDate === 'undefined') {
    window.formatDate = function(d) {
        var y  = d.getFullYear();
        var m  = ('0' + (d.getMonth() + 1)).slice(-2);
        var dd = ('0' + d.getDate()).slice(-2);
        return y + '-' + m + '-' + dd;
    };
}

/**
 * Date → 'HH:mm:ss' 문자열 (timespinner 용)
 */
if (typeof window.formatTime === 'undefined') {
    window.formatTime = function(d) {
        var h = ('0' + d.getHours()).slice(-2);
        var m = ('0' + d.getMinutes()).slice(-2);
        var s = ('0' + d.getSeconds()).slice(-2);
        return h + ':' + m + ':' + s;
    };
}

/**
 * 'yyyy-MM-dd' 문자열 → Date 객체
 */
if (typeof window.parseDate === 'undefined') {
    window.parseDate = function(str) {
        if (!str) return null;
        var parts = str.split('-');
        return new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
    };
}

/**
 * 날짜시간 포맷 (YYYY-MM-DD HH:mm:ss)
 */
if (typeof window.formatDateTime === 'undefined') {
    window.formatDateTime = function(date) {
        var year    = date.getFullYear();
        var month   = ('0' + (date.getMonth() + 1)).slice(-2);
        var day     = ('0' + date.getDate()).slice(-2);
        var hours   = ('0' + date.getHours()).slice(-2);
        var minutes = ('0' + date.getMinutes()).slice(-2);
        var seconds = ('0' + date.getSeconds()).slice(-2);
        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
    };
}

/**
 * 서버 전송용 날짜시간 포맷 (YYYYMMDDHHmmss)
 */
if (typeof window.formatDateTimeForServer === 'undefined') {
    window.formatDateTimeForServer = function(date) {
        var year    = date.getFullYear();
        var month   = ('0' + (date.getMonth() + 1)).slice(-2);
        var day     = ('0' + date.getDate()).slice(-2);
        var hours   = ('0' + date.getHours()).slice(-2);
        var minutes = ('0' + date.getMinutes()).slice(-2);
        var seconds = ('0' + date.getSeconds()).slice(-2);
        return year + month + day + hours + minutes + seconds;
    };
}
