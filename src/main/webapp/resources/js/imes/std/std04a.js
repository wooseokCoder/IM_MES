/**
 * ============================================================================
 * 화면명: STD04A - 표준 자원 관리
 * ============================================================================
 * 설명: 설비(자원) 목록 조회, 등록, 수정, 삭제, 가용사원 관리
 * 작성자: 송우석
 * 작성일: 2026-02-23
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var codeDataMap = {};       // 코드 데이터 캐시 (그리드 콤보박스용)
var d0aMode = '';           // D0A 팝업 모드: 'NEW' 또는 'EDIT'
var d0aInited = false;      // D0A 팝업 초기화 여부 (guard flag)
var d1aInited = false;      // D1A 팝업 초기화 여부 (guard flag)
var d0aEditRow = null;      // D0A 편집 모드에서 원본 행 데이터
var d0aPendingAction = null; // D0A 첫 로드 시 pending 작업 ('NEW' 또는 'EDIT')
var _d1aRows = [];             // D1A 미리보기 데이터 (plain HTML table)
var _deleteTarget = null;      // 삭제 대상 정보 {source:'grid'|'d0a', mcCodes:[], row:null}

// ============================================================================
// consts (STD45A 패턴)
// ============================================================================
var consts = {
    url: {
        STD04A_SER:      getUrl('/imes/std/std04a/STD04A_SER.json'),
        STD04A_INS:      getUrl('/imes/std/std04a/STD04A_INS.json'),
        STD04A_DEL:      getUrl('/imes/std/std04a/STD04A_DEL.json'),
        STD04A_SER2:     getUrl('/imes/std/std04a/STD04A_SER2.json'),
        STD06A_SER2:     getUrl('/imes/std/std04a/STD06A_SER2.json'),
        STD06A_SER3:     getUrl('/imes/std/std04a/STD06A_SER3.json'),
        STD04A_STD_PROC: getUrl('/imes/std/std04a/STD04A_STD_PROC.json'),
        CODE_LIST:       getUrl('/common/code/code.json')
    },

    // 코드 데이터 동기 로드
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

    // 공정 콤보 데이터 로드
    loadProcData: function() {
        var items = [];
        $.ajax({
            url: this.url.STD04A_STD_PROC,
            type: 'POST',
            data: {},
            dataType: 'json',
            async: false,
            success: function(response) {
                items = response.rows || response || [];
            }
        });
        return items;
    },

    // 전체 초기화
    init: function() {
        // --- 코드 데이터 로드 (동기) ---
        consts.codeData = {};
        consts.codeData.C020 = this.loadCode('C020');  // 자원그룹
        consts.codeData.S908 = this.loadCode('S908');  // 구분 (전동/유압/가공)
        consts.codeData.S021 = this.loadCode('S021');  // 사원형태
        consts.codeData.C040 = this.loadCode('C040');  // 직책
        consts.procData = this.loadProcData();

        // --- 메인 그리드 초기화 (검색 결과 - 상단) ---
        $('#search-grid').datagrid({
            method: 'post',
            fit: true,
            fitColumns: false,
            striped: true,
            singleSelect: false,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'mcCode',
            checkOnSelect: false,
            selectOnCheck: false,
            onSelect: function(index, row) {
                loadAvailEmp(row.mcCode);
            },
            onClickRow: function(index, row) {
                // 행 클릭 시 단일선택 (기존 선택 해제 후 현재 행만 선택)
                $('#search-grid').datagrid('unselectAll');
                $('#search-grid').datagrid('selectRow', index);
            },
            onCheck: function(index, row) {
                // 체크박스 클릭 시 해당 행 선택 + 하단 가용사원 로드
                $('#search-grid').datagrid('unselectAll');
                $('#search-grid').datagrid('selectRow', index);
                loadAvailEmp(row.mcCode);
            },
            onDblClickRow: function(index, row) {
                doOpenEdit(row);
            },
            onRowContextMenu: function(e, rowIndex, rowData) {
                e.preventDefault();
                $(this).datagrid('unselectAll');
                $(this).datagrid('selectRow', rowIndex);
            },
            onLoadSuccess: function(data) {
                $('#search-grid').datagrid('unselectAll');
                $('#search-grid').datagrid('uncheckAll');
                $('#emp-grid').datagrid('loadData', []);
            }
        });

        // 메인 그리드 헤더 체크박스 → "선택" 텍스트로 교체 (AS-IS 동일)
        _replaceHeaderCheck($('#search-grid'));

        // --- 하단 가용사원 그리드 (읽기전용) ---
        $('#emp-grid').datagrid({
            fit: false,
            fitColumns: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            rowStyler: function(index) {
                if (index % 2 === 0) {
                    return 'background:#ffffff';
                } else {
                    return 'background:#f5f5f5';
                }
            }
        });

        // 하단 가용사원 그리드: noStyle 적용 (컬럼 폭 강제확장 방지)
        $('#emp-grid').datagrid('getPanel').find('.datagrid-view').addClass('noStyle');

        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#excel-import-button').bind('click', doOpenD1a);

        // 상단 버튼 이벤트 바인딩
        $('#btn-new').bind('click', doOpenNew);
        $('#btn-open').bind('click', function() {
            var row = $('#search-grid').datagrid('getSelected');
            if (row) {
                doOpenEdit(row);
            } else {
                $.messager.alert(getTitle('WARNING'), '열기할 항목을 선택하세요.', 'warning');
            }
        });
        $('#btn-delete').bind('click', doDeleteFromGrid);

        // 삭제사유 다이얼로그 버튼 바인딩
        $('#del-dialog-ok-button').bind('click', doDeleteConfirm);
        $('#del-dialog-cancel-button').bind('click', function() {
            $('#delete-dialog').dialog('close');
        });
    }
};


// ============================================================================
// 화면 초기화
// ============================================================================
$(function() {
    // 500 에러 시 raw 메시지 대신 일반 메시지 표시
    $.ajaxSetup({ statusCode: { 500: function() {
        $.messager.alert('Error', '오류가 발생했습니다.', 'error');
    }}});
    consts.init();
});

// EasyUI 자동 파싱 완료 후 실행
$(window).load(function() {
    hideLoadingBar();

    // north 패널 높이 자동 조정 (레이아웃 표시 후 실측)
    var toolbarHeight = $('#search-toolbar').outerHeight(true);
    if (toolbarHeight > 0) {
        $('#search-grid-panel').panel({height: toolbarHeight});
        $('#account-layout').layout('resize');
    }

    // 검색 조건 Enter 키
    $('#s_mcLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_mcLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });

    GridHeaderMenu('#search-grid', { exportFileName: '표준자원관리_자원' });
    GridHeaderMenu('#emp-grid', { exportFileName: '표준자원관리_가용사원' });
    enableGridSortReset('#search-grid');
    enableGridSortReset('#emp-grid');
    doSearch();
});


// ============================================================================
// 포맷터 함수
// ============================================================================

/**
 * 체크박스 포맷터
 */
function formatCheck(value, row, index) {
    if (value == '1' || value == 'Y') {
        return '<input type="checkbox" checked disabled/>';
    }
    return '<input type="checkbox" disabled/>';
}

/**
 * 라디오버튼 그룹 포맷터 (구분 컬럼용)
 */
function formatRadioGroup(codeGrup, value) {
    var items = codeDataMap[codeGrup] || [];
    if (items.length === 0) return value || '';
    var html = '<div style="text-align:center;font-weight:normal;">';
    for (var i = 0; i < items.length; i++) {
        var checked = (items[i].codeCd === value) ? ' checked' : '';
        html += '<label style="margin-right:6px;white-space:nowrap;font-weight:normal;">'
             + '<input type="radio" disabled' + checked + ' style="vertical-align:middle;margin:0 1px 0 0;" />'
             + items[i].codeName + '</label>';
    }
    html += '</div>';
    return html;
}

/**
 * 코드값 → 코드명 포맷터
 */
function formatCode(codeGrup, value) {
    if (!value) return '';
    if (codeDataMap[codeGrup]) {
        for (var i = 0; i < codeDataMap[codeGrup].length; i++) {
            if (codeDataMap[codeGrup][i].codeCd === value) {
                return codeDataMap[codeGrup][i].codeName;
            }
        }
    }
    return value;
}


// ============================================================================
// 조회 (STD04A_SER)
// ============================================================================
function doSearch() {
    var params = {
        mcLike: $('#s_mcLike').textbox('getText')
    };
    $('#search-grid').datagrid('options').url = consts.url.STD04A_SER;
    $('#search-grid').datagrid('load', params);
}


// ============================================================================
// 가용사원 조회 (STD06A_SER2) — 메인 그리드 행 선택 시
// ============================================================================
function loadAvailEmp(mcCode) {
    if (!mcCode) {
        $('#emp-grid').datagrid('loadData', []);
        return;
    }
    $.ajax({
        url: consts.url.STD06A_SER2,
        type: 'POST',
        data: { mcCode: mcCode },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#emp-grid').datagrid('loadData', rows);
        }
    });
}


// ============================================================================
// D0A 팝업 초기화 (onLoad 콜백 — 첫 로드 시 1회)
// ============================================================================
function initD0aPopup() {
    if (d0aInited) return;
    d0aInited = true;

    // 자원그룹 콤보박스 설정
    $('#d_mcGroup').combobox({
        data: consts.codeData.C020,
        valueField: 'codeCd',
        textField: 'codeName',
        panelHeight: 'auto',
        editable: false
    });

    // 표시순서 numberbox 명시 초기화 (href 파싱 보장)
    $('#d_mcSeq').numberbox({width: '100%', min: 0, max: 999999999, precision: 0});
    $('#d_mcSeq').numberbox('textbox').attr('maxlength', 9);  // MC_SEQ INT (9자리)

    // 공정 콤보박스 설정
    $('#d_procCode').combobox({
        data: consts.procData,
        valueField: 'mprocCode',
        textField: 'mprocCode',
        panelHeight: 160,
        editable: false
    });

    // 좌측 그리드: 가용인원 (배정된 사원)
    $('#d0a-left-grid').datagrid({
        fit: false,
        width: '100%',
        height: 260,
        fitColumns: true,
        striped: true,
        singleSelect: false,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'empCode',
        columns: [[
            {field: 'sel', title: '선택', width: 40, halign: 'center', align: 'center',
                formatter: function(value, row, index) {
                    var checked = (value === '1') ? ' checked' : '';
                    return '<input type="checkbox"' + checked + ' />';
                }},
            {field: 'orgName', title: '부서명', width: 120, halign: 'center', align: 'center'},
            {field: 'empCode', title: '사원코드', width: 100, halign: 'center', align: 'center'},
            {field: 'empName', title: '사원명', width: 100, halign: 'center', align: 'center'}
        ]],
        onDblClickRow: function(index, row) {
            // 더블클릭 → 좌측에서 제거
            removeEmpFromLeft(index);
        }
    });

    // 우측 그리드: 전체 사원 (AS-IS: 부서별 그룹화 → treegrid로 구현)
    $('#d0a-right-grid').treegrid({
        fit: false,
        width: '100%',
        height: 260,
        fitColumns: true,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'id',
        treeField: 'sel',
        animate: false,
        columns: [[
            {field: 'sel', title: '선택', width: 60, halign: 'center', align: 'center',
                formatter: function(value, row) {
                    if (row.empCode) {
                        var checked = (value === '1') ? ' checked' : '';
                        return '<input type="checkbox" class="emp-sel-ck"' + checked + ' />';
                    }
                    return '';
                }},
            {field: 'text', title: '부서/사원', width: 120, halign: 'center', align: 'left'},
            {field: 'empCode', title: '사원코드', width: 80, halign: 'center', align: 'center'},
            {field: 'empType', title: '사원형태', width: 70, halign: 'center', align: 'center',
                formatter: function(v) { return v ? formatCode('S021', v) : ''; }},
            {field: 'empTitle', title: '직책', width: 70, halign: 'center', align: 'center',
                formatter: function(v) { return v ? formatCode('C040', v) : ''; }}
        ]],
        onDblClickRow: function(row) {
            // 사원 행 더블클릭 → 좌측에 추가 (부서 행은 무시)
            if (row.empCode) {
                addEmpToLeft(row);
            }
        }
    });

    // D0A 그리드 noStyle 적용 (common.css width:100% 강제확장 방지)
    $('#d0a-left-grid').datagrid('getPanel').find('.datagrid-view').addClass('noStyle');
    $('#d0a-right-grid').treegrid('getPanel').find('.datagrid-view').addClass('noStyle');

    // D0A 버튼 이벤트
    $('#d0a-clear-button').bind('click', doClearD0a);
    $('#d0a-save-button').bind('click', function() { doSaveD0a(false); });
    $('#d0a-save-close-button').bind('click', function() { doSaveD0a(false); });
    $('#d0a-delete-button').bind('click', doDeleteFromD0a);

    // 첫 로드 시 pending 작업 실행 (href 비동기 로드 완료 후)
    if (d0aPendingAction === 'NEW') {
        clearD0aFields();
        setD0aMode('NEW');
        $('#d0a-popup').dialog('setTitle', '표준 자원 등록');
        loadAllEmpToRight();
    } else if (d0aPendingAction === 'EDIT' && d0aEditRow) {
        clearD0aFields();
        loadD0aFields(d0aEditRow);
        setD0aMode('EDIT');
        $('#d0a-popup').dialog('setTitle', '표준 자원 수정');
        loadAssignedEmpToLeft(d0aEditRow.mcCode);
        loadAllEmpToRight();
    }
    d0aPendingAction = null;
}


// ============================================================================
// D0A 사원 이동 함수
// ============================================================================

/**
 * 우측 → 좌측 추가 (중복 방지)
 */
function addEmpToLeft(row) {
    var leftRows = $('#d0a-left-grid').datagrid('getRows');
    for (var i = 0; i < leftRows.length; i++) {
        if (leftRows[i].empCode === row.empCode) {
            return; // 이미 존재
        }
    }
    $('#d0a-left-grid').datagrid('appendRow', {
        orgName: row.orgName,
        empCode: row.empCode,
        empName: row.empName || row.userName
    });

}

/**
 * 좌측에서 제거
 */
function removeEmpFromLeft(index) {
    $('#d0a-left-grid').datagrid('deleteRow', index);

}



// ============================================================================
// D0A 모드 설정 (NEW / EDIT)
// ============================================================================
function setD0aMode(mode) {
    d0aMode = mode;
    $('#d0a-buttons').css('visibility', 'visible');
    if (mode === 'NEW') {
        $('.d0a-new-btn').show();
        $('.d0a-edit-btn').hide();
        $('#d_mcCode').textbox('readonly', false);
    } else {
        $('.d0a-new-btn').hide();
        $('.d0a-edit-btn').show();
        $('#d_mcCode').textbox('readonly', true);
    }
}


// ============================================================================
// D0A 신규 열기 (컨텍스트 메뉴 '새로 만들기' 또는 '신규' 버튼)
// ============================================================================
function doOpenNew() {
    d0aEditRow = null;
    $('#d0a-popup').css('visibility', '');
    $('#d0a-buttons').css('visibility', '');
    $('#d0a-popup').dialog('open').dialog('center');
    if (d0aInited) {
        // 이미 초기화 완료 → 바로 실행
        clearD0aFields();
        setD0aMode('NEW');
        $('#d0a-popup').dialog('setTitle', '표준 자원 등록');
        loadAllEmpToRight();
    } else {
        // 첫 로드: href 비동기 로드 중 → initD0aPopup()에서 실행하도록 예약
        d0aPendingAction = 'NEW';
    }
}


// ============================================================================
// D0A 편집 열기 (더블클릭 또는 컨텍스트 메뉴 '열기')
// ============================================================================
function doOpenEdit(row) {

	$('#d0a-popup').css('visibility', '');
	$('#d0a-buttons').css('visibility', '');

    d0aEditRow = row;
    $('#d0a-popup').dialog('open').dialog('center');
    if (d0aInited) {
        // 이미 초기화 완료 → 바로 실행
        clearD0aFields();
        loadD0aFields(row);
        setD0aMode('EDIT');
        $('#d0a-popup').dialog('setTitle', '표준 자원 수정');
        loadAssignedEmpToLeft(row.mcCode);
        loadAllEmpToRight();
    } else {
        // 첫 로드: href 비동기 로드 중 → initD0aPopup()에서 실행하도록 예약
        d0aPendingAction = 'EDIT';
    }
}


// ============================================================================
// D0A 필드 초기화
// ============================================================================
function clearD0aFields() {
    $('#d_overwrite').val('0');
    // visible 필드 초기화
    $('#d_mcCode').textbox('setValue', '');
    $('#d_mcName').textbox('setValue', '');
    $('#d_mcGroup').combobox('setValue', '');
    $('input[name="d_mcFlag"]').prop('checked', false);
    $('#d_procCode').combobox('setValue', '');
    $('#d_mcSeq').numberbox('setValue', '');
    $('#d_isSap').prop('checked', false);
    $('#d_isSimGantt').prop('checked', false);
    $('#d_isPop').prop('checked', false);
    $('#d_scomment').val('');
    // hidden fields 초기화
    $('#d_mcModel').val('');
    $('#d_mainEmpCode').val('');
    $('#d_mcMaker').val('');
    $('#d_assetNo').val('');
    $('#d_asTel').val('');
    $('#d_mcOpenDate').val('');
    $('#d_mcCloseDate').val('');
    $('#d_plcIp').val('');
    $('#d_mcIp').val('');
    $('#d_venCode').val('');
    $('#d_mcOs').val('0');
    $('#d_mcMgtFlag').val('0');
    $('#d_isSignal').val('0');
    $('#d_isOperateState').val('0');
    $('#d_signalType').val('');
    $('#d_plcPort').val('');
    $('#d_ifMcCode').val('');
    $('#d_ftpPort').val('');
    $('#d_ftpUser').val('');
    $('#d_ftpUserPw').val('');
    $('#d_ftpDir').val('');
    // 그리드 초기화
    $('#d0a-left-grid').datagrid('loadData', []);
    $('#d0a-right-grid').treegrid('loadData', []);

}


// ============================================================================
// D0A 필드 로드 (편집 모드)
// ============================================================================
function loadD0aFields(row) {
    // visible 필드 로드
    $('#d_mcCode').textbox('setValue', row.mcCode || '');
    $('#d_mcName').textbox('setValue', row.mcName || '');
    $('#d_mcGroup').combobox('setValue', row.mcGroup || '');
    $('input[name="d_mcFlag"]').prop('checked', false);
    if (row.mcFlag) {
        $('input[name="d_mcFlag"][value="' + row.mcFlag + '"]').prop('checked', true);
    }
    $('#d_procCode').combobox('setValue', row.procCode || '');
    $('#d_mcSeq').numberbox('setValue', row.mcSeq || '');
    $('#d_isSap').prop('checked', row.isSap === '1' || row.isSap === 1);
    $('#d_isSimGantt').prop('checked', row.isSimGantt === '1' || row.isSimGantt === 1);
    $('#d_isPop').prop('checked', row.isPop === '1' || row.isPop === 1);
    $('#d_scomment').val(row.scomment || '');
    // hidden fields 로드 (저장 시 전송 필요)
    $('#d_mcModel').val(row.mcModel || '');
    $('#d_mainEmpCode').val(row.mainEmp || '');
    $('#d_mcMaker').val(row.mcMaker || '');
    $('#d_assetNo').val(row.assetNo || '');
    $('#d_asTel').val(row.asTel || '');
    $('#d_mcOpenDate').val(row.mcOpenDate || '');
    $('#d_mcCloseDate').val(row.mcCloseDate || '');
    $('#d_plcIp').val(row.plcIp || '');
    $('#d_mcIp').val(row.mcIp || '');
    $('#d_venCode').val(row.venCode || '');
    $('#d_mcOs').val(row.mcOs || '0');
    $('#d_mcMgtFlag').val(row.mcMgtFlag || '0');
    $('#d_isSignal').val(row.isSignal || '0');
    $('#d_isOperateState').val(row.isOperateState || '0');
    $('#d_signalType').val(row.signalType || '');
    $('#d_plcPort').val(row.plcPort || '');
    $('#d_ifMcCode').val(row.ifMcCode || '');
    $('#d_ftpPort').val(row.ftpPort || '');
    $('#d_ftpUser').val(row.ftpUser || '');
    $('#d_ftpUserPw').val(row.ftpUserPw || '');
    $('#d_ftpDir').val(row.ftpDir || '');
}


// ============================================================================
// D0A 가용사원 로드 (좌측: 배정된 사원)
// ============================================================================
function loadAssignedEmpToLeft(mcCode) {
    $.ajax({
        url: consts.url.STD06A_SER2,
        type: 'POST',
        data: { mcCode: mcCode },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#d0a-left-grid').datagrid('loadData', rows);

        }
    });
}


// ============================================================================
// D0A 전체사원 로드 (우측 — treegrid 트리 구조)
// ============================================================================
function loadAllEmpToRight() {
    $.ajax({
        url: consts.url.STD06A_SER3,
        type: 'POST',
        data: {},
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            var treeData = buildEmpTree(rows);
            $('#d0a-right-grid').treegrid('loadData', treeData);
        }
    });
}

/**
 * flat 사원 목록 → 부서별 트리 구조 변환
 * AS-IS: GridView GroupIndex=0 (ORG_NAME)
 */
function buildEmpTree(rows) {
    var groups = {};
    var tree = [];
    for (var i = 0; i < rows.length; i++) {
        var orgName = rows[i].orgName || '';
        var orgCode = rows[i].orgCode || '_NONE_';
        if (!groups[orgCode]) {
            groups[orgCode] = {
                id: 'org_' + orgCode,
                text: orgName,
                state: 'closed',
                children: []
            };
            tree.push(groups[orgCode]);
        }
        groups[orgCode].children.push({
            id: rows[i].empCode,
            text: rows[i].empName || rows[i].userName,
            empCode: rows[i].empCode,
            empName: rows[i].empName || rows[i].userName,
            orgName: orgName,
            empType: rows[i].empType,
            empTitle: rows[i].empTitle
        });
    }
    // 부서 내 사원명 오름차순 정렬
    for (var j = 0; j < tree.length; j++) {
        tree[j].children.sort(function(a, b) {
            if (a.text < b.text) return -1;
            if (a.text > b.text) return 1;
            return 0;
        });
    }
    // 부서명 오름차순 정렬 (빈값 → 영어 → 한글)
    tree.sort(function(a, b) {
        if (!a.text && !b.text) return 0;
        if (!a.text) return -1;
        if (!b.text) return 1;
        if (a.text < b.text) return -1;
        if (a.text > b.text) return 1;
        return 0;
    });
    return tree;
}


// ============================================================================
// D0A 초기화 (barItemClear)
// ============================================================================
function doClearD0a() {
    clearD0aFields();
    loadAllEmpToRight();
}


// ============================================================================
// D0A 필드 검증
// ============================================================================
function validateD0a() {
    var mcCode = $('#d_mcCode').textbox('getValue');
    var mcName = $('#d_mcName').textbox('getValue');

    if (!mcCode || mcCode.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '자원코드를 입력하세요.', 'warning');
        return false;
    }
    if (!mcName || mcName.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '자원명을 입력하세요.', 'warning');
        return false;
    }
    return true;
}


// ============================================================================
// D0A 저장 파라미터 수집
// ============================================================================
function getD0aParams() {
    // 좌측 그리드의 가용사원 목록
    var leftRows = $('#d0a-left-grid').datagrid('getRows');
    var empList = [];
    for (var i = 0; i < leftRows.length; i++) {
        empList.push({
            empCode: leftRows[i].empCode,
            empSeq: i
        });
    }

    return {
        // visible 필드
        mcCode: $('#d_mcCode').textbox('getValue'),
        mcName: $('#d_mcName').textbox('getValue'),
        mcGroup: $('#d_mcGroup').combobox('getValue'),
        mcFlag: $('input[name="d_mcFlag"]:checked').val() || 'E',
        procCode: $('#d_procCode').combobox('getValue'),
        mcSeq: $('#d_mcSeq').numberbox('getValue') || 0,
        isSap: $('#d_isSap').is(':checked') ? '1' : '0',
        isSimGantt: $('#d_isSimGantt').is(':checked') ? '1' : '0',
        isPop: $('#d_isPop').is(':checked') ? '1' : '0',
        scomment: $('#d_scomment').val(),
        // hidden fields (AS-IS DataBind로 자동 전송되던 값)
        mcModel: $('#d_mcModel').val(),
        mainEmp: $('#d_mainEmpCode').val(),
        mcMaker: $('#d_mcMaker').val(),
        assetNo: $('#d_assetNo').val(),
        asTel: $('#d_asTel').val(),
        mcOpenDate: $('#d_mcOpenDate').val(),
        mcCloseDate: $('#d_mcCloseDate').val(),
        plcIp: $('#d_plcIp').val(),
        mcIp: $('#d_mcIp').val(),
        venCode: $('#d_venCode').val(),
        mcOs: $('#d_mcOs').val() || '0',
        mcMgtFlag: $('#d_mcMgtFlag').val() || '0',
        isSignal: $('#d_isSignal').val() || '0',
        isOperateState: $('#d_isOperateState').val() || '0',
        // OVERWRITE
        overwrite: $('#d_overwrite').val() || '0',
        // 가용사원 JSON
        modelList: JSON.stringify(empList)
    };
}


// ============================================================================
// D0A 저장 (STD04A_INS) — OVERWRITE 처리
// ============================================================================
function doSaveD0a(overwrite) {
    if (!validateD0a()) return;

    var params = getD0aParams();
    if (overwrite) {
        params.overwrite = '1';
        $('#d_overwrite').val('1');
    }

    $.ajax({
        url: consts.url.STD04A_INS,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success || '저장되었습니다.', 'info');
                // EDIT 모드(저장&닫기) → 팝업 닫기
                if (d0aMode === 'EDIT') {
                    $('#d0a-popup').dialog('close');
                }
                doSearch();
            } else if (result.errorCode === 'DUPLICATE') {
                // 100001: 중복 → 덮어쓰기 확인
                $.messager.confirm(getTitle('CONFIRM'), result.error, function(r) {
                    if (r) doSaveD0a(true);
                });
            } else if (result.errorCode === 'DELETED') {
                // 100002: 삭제된 데이터 존재 → 복원 확인
                var errMsg = result.error;
                if (result.delDate) errMsg += '\n\n삭제일: ' + result.delDate;
                if (result.delEmp) errMsg += '\n삭제자: ' + result.delEmp;
                if (result.delReason) errMsg += '\n삭제사유: ' + result.delReason;
                $.messager.confirm(getTitle('CONFIRM'), errMsg, function(r) {
                    if (r) doSaveD0a(true);
                });
            } else {
                $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
            }
        },
        error: function() {
        }
    });
}


// ============================================================================
// D0A 삭제 (barItemDelete)
// ============================================================================
function doDeleteFromD0a() {
    if (!d0aEditRow) return;

    _deleteTarget = {
        source: 'd0a',
        mcCodes: [d0aEditRow.mcCode]
    };
    $('#del_reason').textbox('setValue', '');
    $('#delete-dialog').dialog('open').dialog('center');
}


// ============================================================================
// 그리드 삭제 (다건 — 체크박스 또는 선택행)
// ============================================================================
function doDeleteFromGrid() {
    var checkedRows = $('#search-grid').datagrid('getChecked');
    var selectedRow = $('#search-grid').datagrid('getSelected');

    if (checkedRows.length === 0 && !selectedRow) {
        $.messager.alert(getTitle('WARNING'), '삭제할 항목을 선택하세요.', 'warning');
        return;
    }

    var mcCodes = [];
    if (checkedRows.length > 0) {
        for (var i = 0; i < checkedRows.length; i++) {
            mcCodes.push(checkedRows[i].mcCode);
        }
    } else {
        mcCodes.push(selectedRow.mcCode);
    }

    _deleteTarget = {
        source: 'grid',
        mcCodes: mcCodes
    };
    $('#del_reason').textbox('setValue', '');
    $('#delete-dialog').dialog('open').dialog('center');
}


// ============================================================================
// 삭제사유 다이얼로그 확인 버튼
// ============================================================================
function doDeleteConfirm() {
    if (!_deleteTarget) return;

    var delReason = $('#del_reason').textbox('getValue');
    var mcCodes = _deleteTarget.mcCodes;
    var source = _deleteTarget.source;

    var data = { delReason: delReason };
    for (var j = 0; j < mcCodes.length; j++) {
        data['mcCodes[' + j + ']'] = mcCodes[j];
    }

    $.ajax({
        url: consts.url.STD04A_DEL,
        type: 'POST',
        data: data,
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success || '삭제되었습니다.', 'info');
                $('#delete-dialog').dialog('close');
                if (source === 'd0a') {
                    $('#d0a-popup').dialog('close');
                    d0aEditRow = null;
                }
                // 그리드 선택 상태 즉시 초기화
                $('#search-grid').datagrid('unselectAll');
                $('#search-grid').datagrid('uncheckAll');
                doSearch();
            } else {
                $.messager.alert(getTitle('ERROR'), result.error || '삭제 실패', 'error');
            }
        },
        error: function() {
        }
    });
    _deleteTarget = null;
}


// ============================================================================
// D1A 팝업 열기
// ============================================================================
function doOpenD1a() {

	$('#d1a-popup').css('visibility', '');
	$('#d1a-buttons').css('visibility', '');

    $('#d1a-popup').dialog('open').dialog('center');
    if (d1aInited) {
        // 재오픈 시 미리보기 테이블 초기화
        _d1aRows = [];
        $('#d1a-tbody').empty();
    }
}


// ============================================================================
// D1A 팝업 초기화 (onLoad 콜백 — 첫 로드 시 1회)
// ============================================================================
function initD1aPopup() {
    if (d1aInited) return;
    d1aInited = true;

    // 미리보기 테이블 헤더 생성 (plain HTML — EasyUI datagrid 우회)
    _d1aBuildHeader();

    // 엑셀 파일 열기 버튼
    $('#d1a-load-button').bind('click', function() {
        $('#d1a-file-input').click();
    });

    // 파일 선택 시 SheetJS 파싱
    $('#d1a-file-input').bind('change', function(e) {
        var file = e.target.files[0];
        if (!file) return;
        d1aParseExcel(file);
        // 파일 입력 초기화 (같은 파일 재선택 가능)
        $(this).val('');
    });

    // 저장 버튼
    $('#d1a-save-button').bind('click', doSaveD1a);
}


/**
 * D1A 미리보기 컬럼 정의 (plain HTML table)
 */
var _d1aCols = [
    {field: 'mcCode', title: '설비코드', width: 100, align: 'center'},
    {field: 'mcName', title: '설비명', width: 120, align: 'left'},
    {field: 'mcGroup', title: '설비그룹', width: 80, align: 'center',
        formatter: function(v) { return formatCode('C020', v); }},
    {field: 'mcModel', title: '실모델명', width: 100, align: 'center'},
    {field: 'mcAutomated', title: '무인가공', width: 70, align: 'center', formatter: formatCheck},
    {field: 'mcOs', title: '외부설비', width: 70, align: 'center', formatter: formatCheck},
    {field: 'mcMgtFlag', title: '부하 관리대상', width: 90, align: 'center', formatter: formatCheck},
    {field: 'isOperateState', title: '가동현황표시', width: 90, align: 'center', formatter: formatCheck},
    {field: 'isMultiStart', title: '다중작업지시', width: 90, align: 'center', formatter: formatCheck},
    {field: 'multiStartDiv', title: '실적분할', width: 70, align: 'center', formatter: formatCheck},
    {field: 'mcOpenDate', title: '유효시작일', width: 90, align: 'center'},
    {field: 'mcCloseDate', title: '유효종료일', width: 90, align: 'center'},
    {field: 'mainEmp', title: '담당자', width: 80, align: 'center'},
    {field: 'cprocCode', title: '임률', width: 80, align: 'center'},
    {field: 'mcSeq', title: '표시순서', width: 70, align: 'right'},
    {field: 'isSignal', title: '신호취득여부', width: 90, align: 'center', formatter: formatCheck},
    {field: 'plcIp', title: '신호취득용IP', width: 100, align: 'center'},
    {field: 'mcIp', title: '설비IP', width: 100, align: 'center'},
    {field: 'ftpPort', title: 'FTP 포트', width: 70, align: 'center'},
    {field: 'ftpDir', title: 'FTP 디렉토리', width: 100, align: 'left'},
    {field: 'ftpUser', title: 'FTP 계정', width: 80, align: 'center'},
    {field: 'ftpUserPw', title: 'FTP 계정암호', width: 90, align: 'center'},
    {field: 'scomment', title: '비고', width: 150, align: 'left'},
    {field: 'monTime', title: '작업시간(월)', width: 80, align: 'right'},
    {field: 'tueTime', title: '작업시간(화)', width: 80, align: 'right'},
    {field: 'wedTime', title: '작업시간(수)', width: 80, align: 'right'},
    {field: 'thrTime', title: '작업시간(목)', width: 80, align: 'right'},
    {field: 'friTime', title: '작업시간(금)', width: 80, align: 'right'},
    {field: 'satTime', title: '작업시간(토)', width: 80, align: 'right'},
    {field: 'sunTime', title: '작업시간(일)', width: 80, align: 'right'}
];

/**
 * D1A 미리보기 테이블 헤더 생성
 */
function _d1aBuildHeader() {
    // 총 너비 계산 (#, 선택, 덮어쓰기 + 데이터 컬럼)
    var totalW = 30 + 40 + 70;
    for (var i = 0; i < _d1aCols.length; i++) {
        totalW += _d1aCols[i].width;
    }

    var html = '<tr>';
    html += '<th style="min-width:30px">#</th>';
    html += '<th style="min-width:40px">선택</th>';
    html += '<th style="min-width:70px">덮어쓰기</th>';
    for (var i = 0; i < _d1aCols.length; i++) {
        html += '<th style="min-width:' + _d1aCols[i].width + 'px">' + _d1aCols[i].title + '</th>';
    }
    html += '</tr>';
    $('#d1a-thead').html(html);

    // 테이블 전체 min-width 강제 → 가로 스크롤 보장
    $('#d1a-preview-table').css('min-width', totalW + 'px');
}

/**
 * D1A 미리보기 테이블 데이터 렌더링
 */
function _d1aLoadData(rows) {
    _d1aRows = rows;
    var html = '';
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        html += '<tr>';
        html += '<td style="text-align:center">' + (i + 1) + '</td>';
        html += '<td style="text-align:center"><input type="checkbox" class="d1a-row-ck" data-index="' + i + '" /></td>';
        var owCk = (row.overwrite === '1') ? ' checked' : '';
        html += '<td style="text-align:center"><input type="checkbox"' + owCk + ' onclick="toggleD1aOverwrite(this,' + i + ')" /></td>';
        for (var j = 0; j < _d1aCols.length; j++) {
            var col = _d1aCols[j];
            var val = row[col.field];
            if (val === undefined || val === null) val = '';
            if (col.formatter) val = col.formatter(val, row, i) || '';
            html += '<td style="text-align:' + col.align + '">' + val + '</td>';
        }
        html += '</tr>';
    }
    $('#d1a-tbody').html(html);
}

/**
 * D1A 체크된 행 반환
 */
function _d1aGetChecked() {
    var result = [];
    $('#d1a-tbody input.d1a-row-ck:checked').each(function() {
        var idx = parseInt($(this).attr('data-index'));
        if (_d1aRows[idx]) result.push(_d1aRows[idx]);
    });
    return result;
}

/**
 * D1A 좌측 열 매핑 기본값 설정 (A~AD)
 */
function _d1aSetDefaults() {
    var ids = [
        'd1a_mcCode', 'd1a_mcName', 'd1a_mcGroup', 'd1a_mcModel',
        'd1a_mcAutomated', 'd1a_mcOs', 'd1a_mcMgtFlag', 'd1a_isOperateState',
        'd1a_isMultiStart', 'd1a_multiStartDiv', 'd1a_mcOpenDate', 'd1a_mcCloseDate',
        'd1a_mainEmp', 'd1a_cprocCode', 'd1a_mcSeq', 'd1a_isSignal',
        'd1a_plcIp', 'd1a_mcIp', 'd1a_ftpPort', 'd1a_ftpDir',
        'd1a_ftpUser', 'd1a_ftpUserPw', 'd1a_scomment',
        'd1a_monTime', 'd1a_tueTime', 'd1a_wedTime', 'd1a_thrTime',
        'd1a_friTime', 'd1a_satTime', 'd1a_sunTime'
    ];
    for (var i = 0; i < ids.length; i++) {
        var col = '';
        var n = i;
        if (n < 26) {
            col = String.fromCharCode(65 + n);
        } else {
            col = String.fromCharCode(64 + Math.floor(n / 26)) + String.fromCharCode(65 + (n % 26));
        }
        $('#' + ids[i]).val(col);
    }
    $('#d1a_startRow').val('2');
}


// ============================================================================
// D1A 엑셀 파싱 (SheetJS)
// ============================================================================
function d1aParseExcel(file) {
    var reader = new FileReader();
    reader.onload = function(e) { debugger;
        try {
            var data = new Uint8Array(e.target.result);
            var workbook = XLSX.read(data, {type: 'array'});
            var sheetName = workbook.SheetNames[0];
            var sheet = workbook.Sheets[sheetName];

            // 시작행 (1-based, 엑셀 행번호)
            var startRow = parseInt($('#d1a_startRow').val()) || 2;

            // 열 매핑 읽기
            var mapping = getD1aMapping();

            // 범위 계산
            var range = XLSX.utils.decode_range(sheet['!ref']);
            var rows = [];

            for (var R = startRow - 1; R <= range.e.r; R++) {
                // MC_CODE 열이 비어있으면 중단
                if (mapping.mcCode) {
                    var mcCodeCell = sheet[mapping.mcCode + (R + 1)];
                    if (!mcCodeCell || !mcCodeCell.v) break;
                }

                var row = {
                    overwrite: '0'
                };

                if (mapping.mcCode) row.mcCode = getCellValue(sheet, mapping.mcCode, R);
                if (mapping.mcName) row.mcName = getCellValue(sheet, mapping.mcName, R);
                if (mapping.mcGroup) row.mcGroup = getCellValue(sheet, mapping.mcGroup, R);
                if (mapping.mcModel) row.mcModel = getCellValue(sheet, mapping.mcModel, R);
                if (mapping.mcAutomated) row.mcAutomated = getCellValue(sheet, mapping.mcAutomated, R);
                if (mapping.mcOs) row.mcOs = getCellValue(sheet, mapping.mcOs, R);
                if (mapping.mcMgtFlag) row.mcMgtFlag = getCellValue(sheet, mapping.mcMgtFlag, R);
                if (mapping.isOperateState) row.isOperateState = getCellValue(sheet, mapping.isOperateState, R);
                if (mapping.isMultiStart) row.isMultiStart = getCellValue(sheet, mapping.isMultiStart, R);
                if (mapping.multiStartDiv) row.multiStartDiv = getCellValue(sheet, mapping.multiStartDiv, R);
                if (mapping.mcOpenDate) row.mcOpenDate = getCellValue(sheet, mapping.mcOpenDate, R);
                if (mapping.mcCloseDate) row.mcCloseDate = getCellValue(sheet, mapping.mcCloseDate, R);
                if (mapping.mainEmp) row.mainEmp = getCellValue(sheet, mapping.mainEmp, R);
                if (mapping.cprocCode) row.cprocCode = getCellValue(sheet, mapping.cprocCode, R);
                if (mapping.mcSeq) row.mcSeq = getCellValue(sheet, mapping.mcSeq, R);
                if (mapping.isSignal) row.isSignal = getCellValue(sheet, mapping.isSignal, R);
                if (mapping.plcIp) row.plcIp = getCellValue(sheet, mapping.plcIp, R);
                if (mapping.mcIp) row.mcIp = getCellValue(sheet, mapping.mcIp, R);
                if (mapping.ftpPort) row.ftpPort = getCellValue(sheet, mapping.ftpPort, R);
                if (mapping.ftpDir) row.ftpDir = getCellValue(sheet, mapping.ftpDir, R);
                if (mapping.ftpUser) row.ftpUser = getCellValue(sheet, mapping.ftpUser, R);
                if (mapping.ftpUserPw) row.ftpUserPw = getCellValue(sheet, mapping.ftpUserPw, R);
                if (mapping.scomment) row.scomment = getCellValue(sheet, mapping.scomment, R);
                if (mapping.monTime) row.monTime = getCellValue(sheet, mapping.monTime, R);
                if (mapping.tueTime) row.tueTime = getCellValue(sheet, mapping.tueTime, R);
                if (mapping.wedTime) row.wedTime = getCellValue(sheet, mapping.wedTime, R);
                if (mapping.thrTime) row.thrTime = getCellValue(sheet, mapping.thrTime, R);
                if (mapping.friTime) row.friTime = getCellValue(sheet, mapping.friTime, R);
                if (mapping.satTime) row.satTime = getCellValue(sheet, mapping.satTime, R);
                if (mapping.sunTime) row.sunTime = getCellValue(sheet, mapping.sunTime, R);

                rows.push(row);
            }

            // 내부 참조 정리 후 테이블 렌더링
            var cleanRows = JSON.parse(JSON.stringify(rows));
            _d1aLoadData(cleanRows);
            $.messager.alert(getTitle('INFO'), cleanRows.length + '건을 로드했습니다.', 'info');

        } catch (ex) {
            $.messager.alert(getTitle('ERROR'), '엑셀 파일 파싱 오류: ' + ex.message, 'error');
        }
    };
    reader.readAsArrayBuffer(file);
}


/**
 * D1A 열 매핑 수집 (좌측 폼에서 열 문자 읽기)
 */
function getD1aMapping() {
    return {
        mcCode: ($('#d1a_mcCode').val() || '').toUpperCase(),
        mcName: ($('#d1a_mcName').val() || '').toUpperCase(),
        mcGroup: ($('#d1a_mcGroup').val() || '').toUpperCase(),
        mcModel: ($('#d1a_mcModel').val() || '').toUpperCase(),
        mcAutomated: ($('#d1a_mcAutomated').val() || '').toUpperCase(),
        mcOs: ($('#d1a_mcOs').val() || '').toUpperCase(),
        mcMgtFlag: ($('#d1a_mcMgtFlag').val() || '').toUpperCase(),
        isOperateState: ($('#d1a_isOperateState').val() || '').toUpperCase(),
        isMultiStart: ($('#d1a_isMultiStart').val() || '').toUpperCase(),
        multiStartDiv: ($('#d1a_multiStartDiv').val() || '').toUpperCase(),
        mcOpenDate: ($('#d1a_mcOpenDate').val() || '').toUpperCase(),
        mcCloseDate: ($('#d1a_mcCloseDate').val() || '').toUpperCase(),
        mainEmp: ($('#d1a_mainEmp').val() || '').toUpperCase(),
        cprocCode: ($('#d1a_cprocCode').val() || '').toUpperCase(),
        mcSeq: ($('#d1a_mcSeq').val() || '').toUpperCase(),
        isSignal: ($('#d1a_isSignal').val() || '').toUpperCase(),
        plcIp: ($('#d1a_plcIp').val() || '').toUpperCase(),
        mcIp: ($('#d1a_mcIp').val() || '').toUpperCase(),
        ftpPort: ($('#d1a_ftpPort').val() || '').toUpperCase(),
        ftpDir: ($('#d1a_ftpDir').val() || '').toUpperCase(),
        ftpUser: ($('#d1a_ftpUser').val() || '').toUpperCase(),
        ftpUserPw: ($('#d1a_ftpUserPw').val() || '').toUpperCase(),
        scomment: ($('#d1a_scomment').val() || '').toUpperCase(),
        monTime: ($('#d1a_monTime').val() || '').toUpperCase(),
        tueTime: ($('#d1a_tueTime').val() || '').toUpperCase(),
        wedTime: ($('#d1a_wedTime').val() || '').toUpperCase(),
        thrTime: ($('#d1a_thrTime').val() || '').toUpperCase(),
        friTime: ($('#d1a_friTime').val() || '').toUpperCase(),
        satTime: ($('#d1a_satTime').val() || '').toUpperCase(),
        sunTime: ($('#d1a_sunTime').val() || '').toUpperCase()
    };
}


/**
 * SheetJS 셀 값 읽기 (열문자 + 행번호)
 */
function getCellValue(sheet, col, rowIdx) {
    if (!col) return '';
    var cell = sheet[col + (rowIdx + 1)];
    if (!cell) return '';
    return (cell.v !== undefined && cell.v !== null) ? String(cell.v) : '';
}


// ============================================================================
// D1A 저장 (체크된 행 일괄 저장)
// ============================================================================
function doSaveD1a() {
    var checked = _d1aGetChecked();
    if (checked.length === 0) {
        $.messager.alert(getTitle('WARNING'), '저장할 항목을 선택하세요.', 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), checked.length + '건을 저장하시겠습니까?', function(r) {
        if (!r) return;

        var successCount = 0;
        var errorCount = 0;
        var overwriteCount = 0;
        var totalCount = checked.length;
        var processed = 0;

        function buildParams(row, isRetry) {
            return {
                mcCode: row.mcCode || '',
                mcName: row.mcName || '',
                mcGroup: row.mcGroup || '',
                mcModel: row.mcModel || '',
                mcAutomated: row.mcAutomated || '0',
                mcOs: row.mcOs || '0',
                mcMgtFlag: row.mcMgtFlag || '0',
                isOperateState: row.isOperateState || '0',
                isSignal: row.isSignal || '0',
                mcOpenDate: row.mcOpenDate || '',
                mcCloseDate: row.mcCloseDate || '',
                mainEmp: row.mainEmp || '',
                cprocCode: row.cprocCode || '',
                mcSeq: row.mcSeq || '0',
                scomment: row.scomment || '',
                mcIp: row.mcIp || '',
                plcIp: row.plcIp || '',
                ftpPort: row.ftpPort || '',
                ftpUser: row.ftpUser || '',
                ftpUserPw: row.ftpUserPw || '',
                ftpDir: row.ftpDir || '',
                monTime: row.monTime || '1440',
                tueTime: row.tueTime || '1440',
                wedTime: row.wedTime || '1440',
                thrTime: row.thrTime || '1440',
                friTime: row.friTime || '1440',
                satTime: row.satTime || '1440',
                sunTime: row.sunTime || '1440',
                overwrite: isRetry ? '1' : (row.overwrite || '0'),
                mcFlag: 'E',
                isSap: '0',
                isSimGantt: '0',
                isPop: '0',
                modelList: '[]'
            };
        }

        function finishRow() {
            processed++;
            if (processed === totalCount) {
                var message = '완료: 성공 ' + successCount + '건';
                if (overwriteCount > 0) message += ' (덮어쓰기 ' + overwriteCount + '건 포함)';
                if (errorCount > 0) message += ', 실패 ' + errorCount + '건';
                $.messager.alert(getTitle('INFO'), message, 'info');
                if (successCount > 0) {
                    $('#d1a-popup').dialog('close');
                    doSearch();
                }
            }
        }

        function saveRow(row, isRetry) {
            $.ajax({
                url: consts.url.STD04A_INS,
                type: 'POST',
                data: buildParams(row, isRetry),
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        successCount++;
                        finishRow();
                    } else if (!isRetry && (result.errorCode === 'DUPLICATE' || result.errorCode === 'DELETED')) {
                        overwriteCount++;
                        saveRow(row, true);
                    } else {
                        errorCount++;
                        finishRow();
                    }
                },
                error: function() {
                    errorCount++;
                    finishRow();
                }
            });
        }

        for (var i = 0; i < checked.length; i++) {
            saveRow(checked[i], false);
        }
    });
}


/**
 * D1A 미리보기 그리드 덮어쓰기 체크박스 토글
 */
function toggleD1aOverwrite(cb, index) {
    var row = _d1aRows[index];
    if (row) {
        row.overwrite = cb.checked ? '1' : '0';
    }
}


// ============================================================================
// 유틸리티 함수
// ============================================================================
/**
 * datagrid 헤더 체크박스를 "선택" 텍스트로 교체 (다른 헤더 컬럼과 동일한 스타일)
 */
function _replaceHeaderCheck($grid) {
    var $check = $grid.datagrid('getPanel').find('.datagrid-header-check');
    $check.removeClass('datagrid-header-check').addClass('datagrid-cell')
        .empty().html('<span>선택</span>');
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
            case 'SELECT_DELETE': return msg.MSG0016 || '삭제할 항목을 선택하세요.';
            case 'CONFIRM_SAVE': return msg.MSG0036 || '저장하시겠습니까?';
            case 'CONFIRM_DELETE': return msg.MSG0030 || '삭제하시겠습니까?';
        }
    }
    switch (key) {
        case 'SAVED': return '저장되었습니다.';
        case 'DELETED': return '삭제되었습니다.';
        case 'SELECT_DELETE': return '삭제할 항목을 선택하세요.';
        case 'CONFIRM_SAVE': return '저장하시겠습니까?';
        case 'CONFIRM_DELETE': return '삭제하시겠습니까?';
        default: return key;
    }
}
