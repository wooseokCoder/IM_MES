/**
 * ============================================================================
 * 화면명: STD50A - 작업자 그룹 관리
 * ============================================================================
 * 설명: 작업자 그룹 목록 조회, 등록, 수정, 삭제
 *       마스터(TSTD_WORKGROUP) + 자식(MC, EMP)
 *       다이얼로그에서 4개 그리드 간 전환(Transfer) UI
 * 원본: ProActive STD50A_M0A.cs, STD50A_D0A.cs
 * 작성일: 2026-02-10
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var dialogMode = '';           // 다이얼로그 모드: 'NEW' 또는 'EDIT'
var mcInsRows = [];            // 작업장 추가 추적 배열
var mcDelRows = [];            // 작업장 삭제 추적 배열
var empInsRows = [];           // 작업자 추가 추적 배열
var empDelRows = [];           // 작업자 삭제 추적 배열
var allMcData = [];            // 전체 작업장 캐시
var allEmpData = [];           // 전체 작업자 캐시

// ============================================================================
// consts
// ============================================================================
var consts = {
    url: {
        STD50A_SER:  getUrl('/imes/std/std50a/STD50A_SER.json'),
        STD50A_SER2: getUrl('/imes/std/std50a/STD50A_SER2.json'),
        STD50A_SER3: getUrl('/imes/std/std50a/STD50A_SER3.json'),
        STD50A_INS:  getUrl('/imes/std/std50a/STD50A_INS.json'),
        STD50A_DEL:  getUrl('/imes/std/std50a/STD50A_DEL.json')
    },

    init: function() {

        // --- 메인 그리드 초기화 ---
        $('#search-grid').datagrid({
            url: this.url.STD50A_SER,
            method: 'post',
            fit: true,
            fitColumns: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'groupNo',
            toolbar: '#search-toolbar',
            onLoadSuccess: function(data) {
                if (data.rows && data.rows.length > 0) {
                    $('#search-grid').datagrid('selectRow', 0);
                    onGridSelect(data.rows[0]);
                } else {
                    $('#detail-mc-grid').datagrid('loadData', []);
                    $('#detail-emp-grid').datagrid('loadData', []);
                }
            },
            onClickRow: function(index, row) {
                onGridSelect(row);
            },
            onDblClickRow: function(index, row) {
                doOpenEdit(row);
            }
        });
        GridHeaderMenu('#search-grid', { exportFileName: '작업자그룹' });
        enableGridSortReset('#search-grid');

        // --- 상세 그리드: 소속 작업장 ---
        $('#detail-mc-grid').datagrid({
            fit: true,
            //fitColumns: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            columns: [[
                {field: 'mcCode', title: '작업장코드', width: 100, halign: 'center', align: 'center', data_item: 'GRD_005'},
                {field: 'mcName', title: '작업장명', width: 150, halign: 'center', align: 'center', data_item: 'GRD_006'},
                {field: 'procCode', title: '공정코드', width: 100, halign: 'center', align: 'center', data_item: 'GRD_007'},
                {field: 'scomment', title: '비고', width: 200, halign: 'center', align: 'left', data_item: 'GRD_008'}
            ]]
        });
        GridHeaderMenu('#detail-mc-grid', { exportFileName: '소속작업장' });
        enableGridSortReset('#detail-mc-grid');

        // --- 상세 그리드: 소속 작업자 ---
        $('#detail-emp-grid').datagrid({
            fit: true,
            //fitColumns: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            columns: [[
                {field: 'empCode', title: '작업자코드', width: 100, halign: 'center', align: 'center', data_item: 'GRD_009'},
                {field: 'empName', title: '작업자명', width: 150, halign: 'center', align: 'center', data_item: 'GRD_010'}
            ]]
        });
        GridHeaderMenu('#detail-emp-grid', { exportFileName: '소속작업자' });
        enableGridSortReset('#detail-emp-grid');

        // --- 다이얼로그 그리드 초기화 ---
        initDialogGrids();

        // --- 다이얼로그 초기화 ---
        $('#edit-dialog').dialog({
            title: '작업자 그룹 편집기',
            closed: true,
            modal: true,
            onOpen: function() {
            	$(this).css('visibility', '');
                $('#edit-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
                // 다이얼로그 오픈 후 그리드 리사이즈 (닫힌 상태에서 0px 방지)
                setTimeout(function() {
                    $('#dlg-mc-sel').datagrid('resize');
                    $('#dlg-mc-all').datagrid('resize');
                    $('#dlg-emp-sel').datagrid('resize');
                    $('#dlg-emp-all').datagrid('resize');
                }, 100);
            }
        });

        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#new-button').bind('click', doOpenNew);
        $('#delete-button').bind('click', doDelete);

        // 다이얼로그 버튼
        $('#dialog-clear-button').bind('click', doClearDialog);
        $('#dialog-save-button').bind('click', function() { doSaveDialog(false); });
        $('#dialog-save-close-button').bind('click', function() { doSaveCloseDialog(false); });
        $('#dialog-delete-button').bind('click', doDeleteFromDialog);
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
    $('#s_groupLike').textbox('textbox').bind('keyup', function(e) {
        $('#s_groupLike').textbox('setValue', $(this).val());
    });
    $('#s_groupLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_groupLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });

    // 입력 길이 제한 (TSTD_WORKGROUP 테이블 컬럼 길이)
    $('#s_groupLike').textbox('textbox').attr('maxlength', 50);      // GROUP_NAME VARCHAR(50)
    $('#f_groupName').textbox('textbox').attr('maxlength', 50);      // GROUP_NAME VARCHAR(50)
    $('#f_scomment').textbox('textbox').attr('maxlength', 500);      // SCOMMENT VARCHAR(500)

    doSearch();
});

// ============================================================================
// 다이얼로그 그리드 초기화 (4개)
// ============================================================================
function initDialogGrids() {
    // 활동 가능 작업장 (좌측) - AS-IS: acGridView1
    $('#dlg-mc-sel').datagrid({
        title: '활동 가능 작업장',
        height: 185,
        //fitColumns: true,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'mcCode',
        columns: [[
            {field: 'mcName', title: '작업장명', width: 120, halign: 'center', align: 'center', data_item: 'GRD_011'},
            {field: 'procCode', title: '공정코드', width: 70, halign: 'center', align: 'center', data_item: 'GRD_012'},
            {field: 'scomment', title: '비고', width: 100, halign: 'center', align: 'left', data_item: 'GRD_013'}
        ]],
        onDblClickRow: function(index, row) {
            removeMachine(row);
        }
    });
    enableGridSortReset('#dlg-mc-sel');

    // 작업장 리스트 (우측) - AS-IS: acGridView2
    $('#dlg-mc-all').datagrid({
        title: '작업장 리스트',
        height: 185,
        //fitColumns: true,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'mcCode',
        columns: [[
            {field: 'mcName', title: '작업장명', width: 120, halign: 'center', align: 'center', data_item: 'GRD_011'},
            {field: 'procCode', title: '공정코드', width: 70, halign: 'center', align: 'center', data_item: 'GRD_012'},
            {field: 'scomment', title: '비고', width: 100, halign: 'center', align: 'left', data_item: 'GRD_013'}
        ]],
        onDblClickRow: function(index, row) {
            addMachine(row);
        }
    });
    enableGridSortReset('#dlg-mc-all');

    // 소속 작업자 (좌측) - AS-IS: acGridView3
    $('#dlg-emp-sel').datagrid({
        title: '소속 작업자',
        height: 185,
        //fitColumns: true,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'empCode',
        columns: [[
            {field: 'empCode', title: '사원코드', width: 100, halign: 'center', align: 'center', data_item: 'GRD_014'},
            {field: 'empName', title: '사원명', width: 150, halign: 'center', align: 'center', data_item: 'GRD_015'}
        ]],
        onDblClickRow: function(index, row) {
            removeEmployee(row);
        }
    });
    enableGridSortReset('#dlg-emp-sel');

    // 작업자 리스트 (우측) - AS-IS: acGridView4
    $('#dlg-emp-all').datagrid({
        title: '작업자 리스트',
        height: 185,
        //fitColumns: true,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'empCode',
        columns: [[
            {field: 'empCode', title: '사원코드', width: 100, halign: 'center', align: 'center', data_item: 'GRD_014'},
            {field: 'empName', title: '사원명', width: 150, halign: 'center', align: 'center', data_item: 'GRD_015'}
        ]],
        onDblClickRow: function(index, row) {
            addEmployee(row);
        }
    });
    enableGridSortReset('#dlg-emp-all');
}

// ============================================================================
// 조회 (STD50A_SER)
// ============================================================================
function doSearch() {
    var params = {
        groupLike: $('#s_groupLike').textbox('getValue')
    };
    $('#search-grid').datagrid('load', params);
}

// ============================================================================
// 그리드 행 선택 → 상세 조회 (STD50A_SER2)
// ============================================================================
function onGridSelect(row) {
    if (!row || !row.groupNo) {
        $('#detail-mc-grid').datagrid('loadData', []);
        $('#detail-emp-grid').datagrid('loadData', []);
        return;
    }

    $.ajax({
        url: consts.url.STD50A_SER2,
        type: 'POST',
        data: { groupNo: row.groupNo },
        dataType: 'json',
        success: function(result) {
            var mcList = result.mcList || [];
            var empList = result.empList || [];
            $('#detail-mc-grid').datagrid('loadData', mcList);
            $('#detail-emp-grid').datagrid('loadData', empList);
        }
    });
}

// ============================================================================
// 다이얼로그 모드 전환
// ============================================================================
function setDialogMode(mode) {
    dialogMode = mode;
    if (mode === 'NEW') {
        $('.dialog-new-btn').show();
        $('.dialog-edit-btn').hide();
    } else {
        $('.dialog-new-btn').hide();
        $('.dialog-edit-btn').show();
    }
}

// ============================================================================
// 신규 다이얼로그 열기 (AS-IS: DialogNew)
// ============================================================================
function doOpenNew() {
    clearDialogFields();
    mcInsRows = []; mcDelRows = [];
    empInsRows = []; empDelRows = [];

    setDialogMode('NEW');
    $('#edit-dialog').dialog('setTitle', '작업자 그룹 편집기 - 등록');

    // 전체 목록 로드 후 다이얼로그 열기
    loadAllLists(function() {
        // 소속 그리드 비우기
        $('#dlg-mc-sel').datagrid('loadData', []);
        $('#dlg-emp-sel').datagrid('loadData', []);

        // 전체 목록 그대로 표시
        $('#dlg-mc-all').datagrid('loadData', allMcData);
        $('#dlg-emp-all').datagrid('loadData', allEmpData);

        updateCounts();
        $('#edit-dialog').dialog('open');
    });
}

// ============================================================================
// 편집 다이얼로그 열기 (AS-IS: DialogOpen / DoubleClick)
// ============================================================================
function doOpenEdit(row) {
    clearDialogFields();
    mcInsRows = []; mcDelRows = [];
    empInsRows = []; empDelRows = [];

    loadDialogFields(row);
    setDialogMode('EDIT');
    $('#edit-dialog').dialog('setTitle', '작업자 그룹 편집기 - 수정');

    // 그룹 상세 + 전체 목록 동시 로드
    var groupNo = row.groupNo;
    var loaded = { detail: false, all: false };

    var selMcRows = [];
    var selEmpRows = [];

    // 1. 그룹 상세 (소속 작업장/작업자)
    $.ajax({
        url: consts.url.STD50A_SER2,
        type: 'POST',
        data: { groupNo: groupNo },
        dataType: 'json',
        success: function(result) {
            selMcRows = result.mcList || [];
            selEmpRows = result.empList || [];
            loaded.detail = true;
            if (loaded.all) applyDialogData(selMcRows, selEmpRows);
        }
    });

    // 2. 전체 목록
    loadAllLists(function() {
        loaded.all = true;
        if (loaded.detail) applyDialogData(selMcRows, selEmpRows);
    });

    $('#edit-dialog').dialog('open');
}

/**
 * 다이얼로그 데이터 적용 (상세 + 전체 목록 로드 완료 후)
 * 전체 목록에서 소속 항목 제거
 */
function applyDialogData(selMcRows, selEmpRows) {
    // 소속 그리드에 로드
    $('#dlg-mc-sel').datagrid('loadData', selMcRows);
    $('#dlg-emp-sel').datagrid('loadData', selEmpRows);

    // 전체 목록 그대로 표시 (AS-IS: 필터링 없음)
    $('#dlg-mc-all').datagrid('loadData', allMcData);
    $('#dlg-emp-all').datagrid('loadData', allEmpData);

    updateCounts();
}

// ============================================================================
// 전체 작업장/작업자 목록 로드 (STD50A_SER3)
// ============================================================================
function loadAllLists(callback) {
    $.ajax({
        url: consts.url.STD50A_SER3,
        type: 'POST',
        data: {},
        dataType: 'json',
        success: function(result) {
            allMcData = result.mcAllList || [];
            allEmpData = result.empAllList || [];
            if (callback) callback();
        }
    });
}

// ============================================================================
// 다이얼로그 필드 관리
// ============================================================================
function clearDialogFields() {
    $('#f_groupNo').val('');
    $('#f_groupName').textbox('setValue', '');
    $('#f_scomment').textbox('setValue', '');
    $('#f_mcCount').textbox('setValue', '0');
    $('#f_empCount').textbox('setValue', '0');
}

function loadDialogFields(row) {
    $('#f_groupNo').val(row.groupNo || '');
    $('#f_groupName').textbox('setValue', row.groupName || '');
    $('#f_scomment').textbox('setValue', row.scomment || '');
    $('#f_mcCount').textbox('setValue', String(row.mcCount || 0));
    $('#f_empCount').textbox('setValue', String(row.empCount || 0));
}

function validateDialogFields() {
    var groupName = $('#f_groupName').textbox('getValue');
    if (!groupName || groupName.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '그룹명을 입력하세요.', 'warning');
        return false;
    }
    return true;
}

function updateCounts() {
    var mcCount = $('#dlg-mc-sel').datagrid('getRows').length;
    var empCount = $('#dlg-emp-sel').datagrid('getRows').length;
    $('#f_mcCount').textbox('setValue', String(mcCount));
    $('#f_empCount').textbox('setValue', String(empCount));
}

// ============================================================================
// 전환(Transfer) 로직: 작업장
// ============================================================================

/**
 * 작업장 목록 → 소속 작업장 (추가)
 * dlg-mc-all 더블클릭 시 호출
 * AS-IS: 오른쪽 그리드에서 행 삭제 안함, 왼쪽에 이미 있으면 동작 안함
 */
function addMachine(row) {
    // 이미 소속 그리드에 있으면 동작 안함
    var selRows = $('#dlg-mc-sel').datagrid('getRows');
    for (var i = 0; i < selRows.length; i++) {
        if (selRows[i].mcCode === row.mcCode) return;
    }

    // dlg-mc-sel에 추가
    $('#dlg-mc-sel').datagrid('appendRow', {
        mcCode: row.mcCode,
        mcName: row.mcName,
        procCode: row.procCode,
        scomment: row.scomment,
        mcSeq: selRows.length
    });

    // 추적 배열 업데이트
    var delIdx = findRowIndex(mcDelRows, 'mcCode', row.mcCode);
    if (delIdx >= 0) {
        mcDelRows.splice(delIdx, 1);
    } else {
        mcInsRows.push({mcCode: row.mcCode, mcSeq: selRows.length});
    }

    updateCounts();
}

/**
 * 소속 작업장 → 제거
 * dlg-mc-sel 더블클릭 시 호출
 * AS-IS: 왼쪽에서만 제거, 오른쪽은 항상 전체 표시이므로 추가 불필요
 */
function removeMachine(row) {
    // dlg-mc-sel에서 제거
    var selRows = $('#dlg-mc-sel').datagrid('getRows');
    var newSelRows = [];
    for (var i = 0; i < selRows.length; i++) {
        if (selRows[i].mcCode !== row.mcCode) {
            newSelRows.push(selRows[i]);
        }
    }
    $('#dlg-mc-sel').datagrid('loadData', newSelRows);

    // 추적 배열 업데이트
    var insIdx = findRowIndex(mcInsRows, 'mcCode', row.mcCode);
    if (insIdx >= 0) {
        mcInsRows.splice(insIdx, 1);
    } else {
        mcDelRows.push({mcCode: row.mcCode});
    }

    updateCounts();
}

// ============================================================================
// 전환(Transfer) 로직: 작업자
// ============================================================================

/**
 * 작업자 목록 → 소속 작업자 (추가)
 * dlg-emp-all 더블클릭 시 호출
 * AS-IS: 오른쪽 그리드에서 행 삭제 안함, 왼쪽에 이미 있으면 동작 안함
 */
function addEmployee(row) {
    // 이미 소속 그리드에 있으면 동작 안함
    var selRows = $('#dlg-emp-sel').datagrid('getRows');
    for (var i = 0; i < selRows.length; i++) {
        if (selRows[i].empCode === row.empCode) return;
    }

    // dlg-emp-sel에 추가
    $('#dlg-emp-sel').datagrid('appendRow', {
        empCode: row.empCode,
        empName: row.empName,
        empSeq: selRows.length
    });

    // 추적 배열 업데이트
    var delIdx = findRowIndex(empDelRows, 'empCode', row.empCode);
    if (delIdx >= 0) {
        empDelRows.splice(delIdx, 1);
    } else {
        empInsRows.push({empCode: row.empCode, empSeq: selRows.length});
    }

    updateCounts();
}

/**
 * 소속 작업자 → 제거
 * dlg-emp-sel 더블클릭 시 호출
 * AS-IS: 왼쪽에서만 제거, 오른쪽은 항상 전체 표시이므로 추가 불필요
 */
function removeEmployee(row) {
    // dlg-emp-sel에서 제거
    var selRows = $('#dlg-emp-sel').datagrid('getRows');
    var newSelRows = [];
    for (var i = 0; i < selRows.length; i++) {
        if (selRows[i].empCode !== row.empCode) {
            newSelRows.push(selRows[i]);
        }
    }
    $('#dlg-emp-sel').datagrid('loadData', newSelRows);

    // 추적 배열 업데이트
    var insIdx = findRowIndex(empInsRows, 'empCode', row.empCode);
    if (insIdx >= 0) {
        empInsRows.splice(insIdx, 1);
    } else {
        empDelRows.push({empCode: row.empCode});
    }

    updateCounts();
}

// ============================================================================
// 초기화 - 다이얼로그 (AS-IS: barItemClear)
// ============================================================================
function doClearDialog() {
    clearDialogFields();
    mcInsRows = []; mcDelRows = [];
    empInsRows = []; empDelRows = [];

    // 소속 그리드 비우기 (오른쪽 전체 목록은 항상 유지)
    $('#dlg-mc-sel').datagrid('loadData', []);
    $('#dlg-emp-sel').datagrid('loadData', []);

    updateCounts();
}

// ============================================================================
// 저장 - 다이얼로그 (STD50A_INS) - NEW 모드
// ============================================================================
function doSaveDialog(overwrite) {
    if (!validateDialogFields()) return;

    var params = {
        groupNo: $('#f_groupNo').val(),
        groupName: $('#f_groupName').textbox('getValue'),
        mcCount: $('#dlg-mc-sel').datagrid('getRows').length,
        empCount: $('#dlg-emp-sel').datagrid('getRows').length,
        scomment: $('#f_scomment').textbox('getValue'),
        overwrite: overwrite ? '1' : '0',
        mcInsList:  JSON.stringify(mcInsRows),
        mcDelList:  JSON.stringify(mcDelRows),
        empInsList: JSON.stringify(empInsRows),
        empDelList: JSON.stringify(empDelRows)
    };

    $.ajax({
        url: consts.url.STD50A_INS,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
                $('#edit-dialog').dialog('close');
                doSearch();
            } else if (result.errorCode === 'DUPLICATE') {
                $.messager.confirm(getTitle('CONFIRM'), result.error, function(r) {
                    if (r) doSaveDialog(true);
                });
            } else if (result.errorCode === 'DELETED') {
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
// 저장&닫기 - 다이얼로그 (STD50A_INS) - EDIT 모드
// ============================================================================
function doSaveCloseDialog(overwrite) {
    if (!validateDialogFields()) return;

    var params = {
        groupNo: $('#f_groupNo').val(),
        groupName: $('#f_groupName').textbox('getValue'),
        mcCount: $('#dlg-mc-sel').datagrid('getRows').length,
        empCount: $('#dlg-emp-sel').datagrid('getRows').length,
        scomment: $('#f_scomment').textbox('getValue'),
        overwrite: '1',
        mcInsList:  JSON.stringify(mcInsRows),
        mcDelList:  JSON.stringify(mcDelRows),
        empInsList: JSON.stringify(empInsRows),
        empDelList: JSON.stringify(empDelRows)
    };

    $.ajax({
        url: consts.url.STD50A_INS,
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
// 삭제 - 다이얼로그 (AS-IS: barItemDel)
// ============================================================================
function doDeleteFromDialog() {
    var groupNo = $('#f_groupNo').val();
    if (!groupNo) return;

    $.messager.prompt(getTitle('CONFIRM'), '삭제사유를 입력하세요.', function(reason) {
        if (reason !== undefined && reason !== null) {
            $.ajax({
                url: consts.url.STD50A_DEL,
                type: 'POST',
                data: { groupNo: groupNo, delReason: reason },
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
// 삭제 - 그리드 선택 행
// ============================================================================
function doDelete() {
    var row = $('#search-grid').datagrid('getSelected');
    if (!row) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    $.messager.prompt(getTitle('CONFIRM'), '삭제사유를 입력하세요.', function(reason) {
        if (reason !== undefined && reason !== null) {
            $.ajax({
                url: consts.url.STD50A_DEL,
                type: 'POST',
                data: { groupNo: row.groupNo, delReason: reason },
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
 * 배열에서 특정 키-값 조합의 인덱스를 찾는다
 */
function findRowIndex(arr, key, value) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i][key] === value) return i;
    }
    return -1;
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
