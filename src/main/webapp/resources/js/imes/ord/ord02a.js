/**
 * ============================================================================
 * 화면명: ORD02A - 이메일 수신자그룹 관리
 * ============================================================================
 * 설명: 수신자그룹/사원 조회, 등록, 수정, 삭제, 엑셀업로드
 *       좌측: 수신자그룹 그리드 (인라인 편집)
 *       우측: 그룹별 사원 그리드 (마스터-디테일)
 * 작성자: 송우석
 * 작성일: 2026-02-10
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var groupEditIndex = undefined;   // 그룹 그리드 편집 중 행 인덱스
var empEditIndex = undefined;     // 사원 그리드 편집 중 행 인덱스
var selectedMcode = '';           // 현재 선택된 그룹코드 (마스터-디테일)
var codeDataMap = {};             // 코드 데이터 캐시
var d0aInited = false;            // D0A 엑셀업로드 팝업 초기화 플래그

// ============================================================================
// consts (URL 및 초기화)
// ============================================================================
var consts = {
    url: {
        ORD02A_SER:  getUrl('/imes/ord/ord02a/ORD02A_SER.json'),
        ORD02A_SER2: getUrl('/imes/ord/ord02a/ORD02A_SER2.json'),
        ORD02A_INS:  getUrl('/imes/ord/ord02a/ORD02A_INS.json'),
        ORD02A_INS2: getUrl('/imes/ord/ord02a/ORD02A_INS2.json'),
        ORD02A_INS3: getUrl('/imes/ord/ord02a/ORD02A_INS3.json'),
        ORD02A_DEL:  getUrl('/imes/ord/ord02a/ORD02A_DEL.json'),
        ORD02A_DEL2: getUrl('/imes/ord/ord02a/ORD02A_DEL2.json'),
        CODE_LIST:   getUrl('/common/code/code.json')
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

    // 전체 초기화
    init: function() {
        // 코드 데이터 로드: 사용여부(S900)
        this.loadCode('S900');

        // ================================================================
        // 좌측 그리드: 수신자 그룹 (group-grid)
        // 컬럼: SEL(체크), GROUP_NAME(편집가능), REG_DATE(읽기), USE_FLAG(라디오), MCODE(hidden), GROUP_TYPE(hidden)
        // ================================================================
        $('#group-grid').datagrid({
            method: 'post',
            fit: true,
            fitColumns: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'mcode',
            columns: [[
                {field: 'sel', title: '선택', width: 50, halign: 'center', align: 'center',
                    formatter: function(value) {
                        var checked = (value === '1' || value === true) ? ' checked' : '';
                        return '<input type="checkbox"' + checked + ' onclick="toggleGroupSel(this)" />';
                    }
                },
                {field: 'groupName', title: '그룹명', width: 160, halign: 'center', align: 'left', resizable: true,
                    editor: {type: 'textbox', options: {required: true, validType: 'length[0,50]'}}
                },
                {field: 'groupType', title: '그룹타입', hidden: true},
                {field: 'regDate', title: '생성일', width: 150, halign: 'center', align: 'center', resizable: true},
                {field: 'useFlag', title: '사용여부', width: 100, halign: 'center', align: 'center', resizable: true,
                    formatter: function(value, row, index) {
                        var items = codeDataMap['S900'] || [];
                        var html = '';
                        for (var i = 0; i < items.length; i++) {
                            var checked = (value === items[i].codeCd) ? ' checked' : '';
                            html += '<label style="margin-right:4px;cursor:pointer;"><input type="radio" name="grpUseFlag_' + index + '" value="' + items[i].codeCd + '"' + checked + ' onclick="setGroupUseFlag(' + index + ',\'' + items[i].codeCd + '\')" />' + items[i].codeName + '</label>';
                        }
                        return html;
                    }
                },
                {field: 'mcode', title: 'MCODE', hidden: true},
                {field: 'addFlag', title: 'ADD_FLAG', hidden: true}
            ]],
            onLoadSuccess: function(data) {
                groupEditIndex = undefined;
                selectedMcode = '';
                clearEmpGrid();
                setEmpPanelEnabled(false);

                // 첫 행 자동 선택 (AS-IS 동일: DevExpress 자동 포커스)
                var rows = $('#group-grid').datagrid('getRows');
                if (rows.length > 0) {
                    $('#group-grid').datagrid('selectRow', 0);
                }
            },
            onClickRow: function(index, row) {
                // 이전 편집 종료
                if (groupEditIndex !== undefined && groupEditIndex !== index) {
                    $('#group-grid').datagrid('endEdit', groupEditIndex);
                }
                groupEditIndex = index;
                $('#group-grid').datagrid('beginEdit', index);
                // 인라인 에디터 maxlength 설정
                var ed = $('#group-grid').datagrid('getEditor', {index: index, field: 'groupName'});
                if (ed) $(ed.target).textbox('textbox').attr('maxlength', 50);  // GROUP_NAME VARCHAR(50)
            },
            onSelect: function(index, row) {
                // 마스터-디테일: 그룹 선택 시 사원 조회
                if (row.mcode && row.groupName && row.addFlag !== '1') {
                    selectedMcode = row.mcode;
                    setEmpPanelEnabled(true);
                    doSearchEmp(row.mcode);
                } else {
                    // 신규 행 또는 그룹명 없는 경우 사원 패널 비활성
                    selectedMcode = '';
                    clearEmpGrid();
                    setEmpPanelEnabled(false);
                }
            },
            onAfterEdit: function(index, row, changes) {
                groupEditIndex = undefined;
            },
            onCancelEdit: function(index, row) {
                groupEditIndex = undefined;
            }
        });

        // ================================================================
        // 우측 그리드: 그룹별 사원 (emp-grid)
        // 컬럼: SEL(체크), EMP_CODE(읽기), EMP_NAME(읽기), ORG_NAME(읽기), EMAIL(편집가능)
        // ================================================================
        $('#emp-grid').datagrid({
            method: 'post',
            fit: true,
            fitColumns: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'empCode',
            columns: [[
                {field: 'sel', title: '선택', width: 50, halign: 'center', align: 'center',
                    formatter: function(value) {
                        var checked = (value === '1' || value === true) ? ' checked' : '';
                        return '<input type="checkbox"' + checked + ' onclick="toggleEmpSel(this)" />';
                    }
                },
                {field: 'empCode', title: '사원코드', width: 100, halign: 'center', align: 'center', resizable: true},
                {field: 'empName', title: '사원명', width: 120, halign: 'center', align: 'center', resizable: true},
                {field: 'orgName', title: '부서명', width: 120, halign: 'center', align: 'center', resizable: true},
                {field: 'email', title: '이메일', width: 250, halign: 'center', align: 'left', resizable: true,
                    editor: {type: 'textbox', options: {validType: 'length[0,250]'}}
                }
            ]],
            onClickRow: function(index, row) {
                if (empEditIndex !== undefined && empEditIndex !== index) {
                    $('#emp-grid').datagrid('endEdit', empEditIndex);
                }
                empEditIndex = index;
                $('#emp-grid').datagrid('beginEdit', index);
                // 인라인 에디터 maxlength 설정
                var ed = $('#emp-grid').datagrid('getEditor', {index: index, field: 'email'});
                if (ed) $(ed.target).textbox('textbox').attr('maxlength', 250);  // EMAIL VARCHAR(250)
            },
            onAfterEdit: function(index, row, changes) {
                empEditIndex = undefined;
            },
            onCancelEdit: function(index, row) {
                empEditIndex = undefined;
            }
        });

        // ================================================================
        // 버튼 이벤트 바인딩
        // ================================================================

        // 툴바 조회
        $('#search-button').bind('click', doSearch);

        // 좌측: 그룹 추가/저장/삭제
        $('#group-add-button').bind('click', doGroupAdd);
        $('#group-save-button').bind('click', doGroupSave);
        $('#group-delete-button').bind('click', doGroupDelete);

        // 우측: 엑셀업로드/사원추가/저장/삭제
        $('#excel-upload-button').bind('click', doOpenExcelUpload);
        $('#emp-add-button').bind('click', doOpenEmpSearch);
        $('#emp-save-button').bind('click', doEmpSave);
        $('#emp-delete-button').bind('click', doEmpDelete);

        // 사원 검색 공통 팝업 초기화
        acEmpForm.init();
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

$(window).load(function() {
    hideLoadingBar();
    setEmpPanelEnabled(false);
    GridHeaderMenu('#group-grid', { exportFileName: '이메일수신자그룹관리_그룹' });
    GridHeaderMenu('#emp-grid', { exportFileName: '이메일수신자그룹관리_사원' });
    enableGridSortReset('#group-grid');
    enableGridSortReset('#emp-grid');
    doSearch();
});

// ============================================================================
// 체크박스 토글 (인라인 체크박스)
// ============================================================================
function toggleGroupSel(cb) {
    var tr = $(cb).closest('tr.datagrid-row');
    var index = parseInt(tr.attr('datagrid-row-index'));
    var row = $('#group-grid').datagrid('getRows')[index];
    if (row) row.sel = cb.checked ? '1' : '0';
}

function setGroupUseFlag(index, value) {
    // 편집 중이면 editor 값 먼저 커밋 (그룹명 등 유지)
    if (groupEditIndex !== undefined) {
        $('#group-grid').datagrid('endEdit', groupEditIndex);
        groupEditIndex = undefined;
    }
    // useFlag 변경
    $('#group-grid').datagrid('updateRow', {index: index, row: {useFlag: value}});
    // 편집 모드 복원
    $('#group-grid').datagrid('beginEdit', index);
    groupEditIndex = index;
}

function toggleEmpSel(cb) {
    var tr = $(cb).closest('tr.datagrid-row');
    var index = parseInt(tr.attr('datagrid-row-index'));
    var row = $('#emp-grid').datagrid('getRows')[index];
    if (row) row.sel = cb.checked ? '1' : '0';
}

// ============================================================================
// 조회 (ORD02A_SER): 수신자그룹 목록
// ============================================================================
function doSearch() {
    if (groupEditIndex !== undefined) {
        $('#group-grid').datagrid('endEdit', groupEditIndex);
        groupEditIndex = undefined;
    }

    $.ajax({
        url: consts.url.ORD02A_SER,
        type: 'POST',
        data: { groupType: 'A' },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#group-grid').datagrid('loadData', rows);
        },
        error: function() {
        }
    });
}

// ============================================================================
// 상세 조회 (ORD02A_SER2): 그룹별 사원 목록
// ============================================================================
function doSearchEmp(mcode) {
    if (empEditIndex !== undefined) {
        $('#emp-grid').datagrid('endEdit', empEditIndex);
        empEditIndex = undefined;
    }

    $.ajax({
        url: consts.url.ORD02A_SER2,
        type: 'POST',
        data: { mcode: mcode },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#emp-grid').datagrid('loadData', rows);
        },
        error: function() {
        }
    });
}

// ============================================================================
// 그룹 추가 (신규 행 추가, GROUP_TYPE='A', USE_FLAG='1')
// ============================================================================
function doGroupAdd() {
    if (groupEditIndex !== undefined) {
        $('#group-grid').datagrid('endEdit', groupEditIndex);
    }

    $('#group-grid').datagrid('appendRow', {
        sel: '0',
        groupName: '',
        groupType: 'A',
        regDate: '',
        useFlag: '1',
        mcode: '',
        addFlag: '1'
    });

    var rows = $('#group-grid').datagrid('getRows');
    var newIndex = rows.length - 1;
    $('#group-grid').datagrid('selectRow', newIndex);
    $('#group-grid').datagrid('beginEdit', newIndex);
    groupEditIndex = newIndex;

    // 신규 행이므로 사원 패널 비활성
    clearEmpGrid();
    setEmpPanelEnabled(false);
}

// ============================================================================
// 그룹 저장 (ORD02A_INS): 추가/수정된 행 일괄 저장
// ============================================================================
function doGroupSave() {
    if (groupEditIndex !== undefined) {
        $('#group-grid').datagrid('endEdit', groupEditIndex);
        groupEditIndex = undefined;
    }

    // 변경된 행 수집 (추가 + 수정)
    var changes = $('#group-grid').datagrid('getChanges');

    if (changes.length === 0) {
        $.messager.alert(getTitle('INFO'), getMessage('NO_CHANGED'), 'info');
        return;
    }

    // GROUP_NAME 비어있는 행 필터링
    var saveRows = [];
    for (var i = 0; i < changes.length; i++) {
        var row = changes[i];
        if (row.groupName && row.groupName.trim() !== '') {
            saveRows.push({
                mcode: row.mcode || '',
                groupName: row.groupName,
                groupType: row.groupType || 'A',
                useFlag: row.useFlag || '1'
            });
        }
    }

    if (saveRows.length === 0) {
        $.messager.alert(getTitle('WARNING'), '그룹명을 입력하세요.', 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_SAVE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.ORD02A_INS,
                type: 'POST',
                data: { models: JSON.stringify(saveRows) },
                dataType: 'json',
                success: function(result) {
                    if (result.rows || (result.success !== false && !result.error)) {
                        $.messager.alert(getTitle('INFO'), getMessage('SAVED'), 'info');
                        // 저장 후 그룹 목록 재조회 (서버에서 반환한 데이터 사용)
                        var rows = result.rows || result || [];
                        if (rows.length > 0) {
                            $('#group-grid').datagrid('loadData', rows);
                        } else {
                            doSearch();
                        }
                    } else {
                        $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
                    }
                },
                error: function() {
                }
            });
        }
    });
}

// ============================================================================
// 그룹 삭제 (ORD02A_DEL): 선택된 행 또는 현재 행 삭제
// ============================================================================
function doGroupDelete() {
    if (groupEditIndex !== undefined) {
        $('#group-grid').datagrid('endEdit', groupEditIndex);
        groupEditIndex = undefined;
    }

    // 체크된 행 수집
    var allRows = $('#group-grid').datagrid('getRows');
    var delRows = [];
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel === '1') {
            delRows.push(allRows[i]);
        }
    }

    // 체크된 행이 없으면 현재 선택된 행 사용
    if (delRows.length === 0) {
        var selected = $('#group-grid').datagrid('getSelected');
        if (selected) {
            delRows.push(selected);
        }
    }

    if (delRows.length === 0) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    // 신규 행(mcode 없음)은 로컬에서만 제거
    var serverDelRows = [];
    for (var i = 0; i < delRows.length; i++) {
        if (delRows[i].mcode) {
            serverDelRows.push({ mcode: delRows[i].mcode });
        } else {
            var idx = $('#group-grid').datagrid('getRowIndex', delRows[i]);
            if (idx >= 0) {
                $('#group-grid').datagrid('deleteRow', idx);
            }
        }
    }

    if (serverDelRows.length === 0) {
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_DELETE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.ORD02A_DEL,
                type: 'POST',
                data: { models: JSON.stringify(serverDelRows) },
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
                }
            });
        }
    });
}

// ============================================================================
// 사원 추가 팝업 열기 (acEmpForm 공통 모듈 사용)
// ============================================================================
function doOpenEmpSearch() {
    if (!selectedMcode) {
        $.messager.alert(getTitle('WARNING'), '그룹을 먼저 선택하세요.', 'warning');
        return;
    }
    acEmpForm.open({
        selectMode: true,
        onSelect: function(rows) {
            // 기존 사원 중복 체크
            var existingRows = $('#emp-grid').datagrid('getRows');
            var existingMap = {};
            for (var i = 0; i < existingRows.length; i++) {
                existingMap[existingRows[i].empCode] = true;
            }

            // 선택된 사원을 emp-grid에 추가 (중복 제외)
            for (var i = 0; i < rows.length; i++) {
                var emp = rows[i];
                if (!existingMap[emp.empCode]) {
                    $('#emp-grid').datagrid('appendRow', {
                        sel: '0',
                        empCode: emp.empCode,
                        empName: emp.empName,
                        orgName: emp.orgName,
                        email: emp.email || ''
                    });
                }
            }
        }
    });
}

// ============================================================================
// 사원 저장 (ORD02A_INS2): 추가/수정된 사원 일괄 저장
// ============================================================================
function doEmpSave() {
    if (!selectedMcode) {
        $.messager.alert(getTitle('WARNING'), '그룹을 먼저 선택하세요.', 'warning');
        return;
    }

    if (empEditIndex !== undefined) {
        $('#emp-grid').datagrid('endEdit', empEditIndex);
        empEditIndex = undefined;
    }

    // 변경/추가 행 수집
    var saveRows = [];
    var insertedRows = $('#emp-grid').datagrid('getChanges', 'inserted');
    var updatedRows = $('#emp-grid').datagrid('getChanges', 'updated');

    var allChanges = insertedRows.concat(updatedRows);
    if (allChanges.length === 0) {
        $.messager.alert(getTitle('INFO'), getMessage('NO_CHANGED'), 'info');
        return;
    }

    for (var i = 0; i < allChanges.length; i++) {
        var row = allChanges[i];
        saveRows.push({
            mcode: selectedMcode,
            empCode: row.empCode,
            empName: row.empName || '',
            email: row.email || ''
        });
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_SAVE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.ORD02A_INS2,
                type: 'POST',
                data: { models: JSON.stringify(saveRows) },
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
                        doSearchEmp(selectedMcode);
                    } else {
                        $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
                    }
                },
                error: function() {
                }
            });
        }
    });
}

// ============================================================================
// 사원 삭제 (ORD02A_DEL2): 선택된 행 또는 현재 행 삭제
// ============================================================================
function doEmpDelete() {
    if (!selectedMcode) return;

    if (empEditIndex !== undefined) {
        $('#emp-grid').datagrid('endEdit', empEditIndex);
        empEditIndex = undefined;
    }

    // 체크된 행 수집
    var allRows = $('#emp-grid').datagrid('getRows');
    var delRows = [];
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel === '1') {
            delRows.push(allRows[i]);
        }
    }

    // 체크된 행이 없으면 현재 선택된 행 사용
    if (delRows.length === 0) {
        var selected = $('#emp-grid').datagrid('getSelected');
        if (selected && selected.empCode) {
            delRows.push(selected);
        }
    }

    if (delRows.length === 0) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    var serverDelRows = [];
    for (var i = 0; i < delRows.length; i++) {
        serverDelRows.push({
            mcode: selectedMcode,
            empCode: delRows[i].empCode
        });
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_DELETE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.ORD02A_DEL2,
                type: 'POST',
                data: { models: JSON.stringify(serverDelRows) },
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success || getMessage('DELETED'), 'info');
                        doSearchEmp(selectedMcode);
                    } else {
                        $.messager.alert(getTitle('ERROR'), result.error || '삭제 실패', 'error');
                    }
                },
                error: function() {
                }
            });
        }
    });
}

// ============================================================================
// 엑셀업로드 팝업 열기
// ============================================================================
function doOpenExcelUpload() {
    $('#d0a-popup').dialog('open').dialog('center');
    // 재오픈 시 미리보기 그리드/파일 입력 초기화
    if (d0aInited) {
        $('#d_previewGrid').datagrid('loadData', []);
        $('#d_excelFile').val('');
    }
}

// ============================================================================
// 사원 패널 활성/비활성
// ============================================================================
function setEmpPanelEnabled(enabled) {
    if (enabled) {
        $('#excel-upload-button').linkbutton('enable');
        $('#emp-add-button').linkbutton('enable');
        $('#emp-save-button').linkbutton('enable');
        $('#emp-delete-button').linkbutton('enable');
    } else {
        $('#excel-upload-button').linkbutton('disable');
        $('#emp-add-button').linkbutton('disable');
        $('#emp-save-button').linkbutton('disable');
        $('#emp-delete-button').linkbutton('disable');
    }
}

function clearEmpGrid() {
    $('#emp-grid').datagrid('loadData', []);
    empEditIndex = undefined;
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

// ============================================================================
// D0A 엑셀업로드 팝업 (href onLoad 콜백)
// ============================================================================
function initD0aPopup() {
    if (d0aInited) return;
    d0aInited = true;

    // 미리보기 그리드 초기화 (읽기 전용)
    $('#d_previewGrid').datagrid({
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        columns: [[
            {field: 'sel', title: '선택', width: 50, halign: 'center', align: 'center',
                formatter: function(value) {
                    var checked = (value === '1' || value === true) ? ' checked' : '';
                    return '<input type="checkbox"' + checked + ' onclick="toggleD0aSel(this)" />';
                }
            },
            {field: 'overwrite', title: '덮어쓰기', width: 70, halign: 'center', align: 'center',
                formatter: function(value) {
                    var checked = (value === '1' || value === true) ? ' checked' : '';
                    return '<input type="checkbox"' + checked + ' onclick="toggleD0aOverwrite(this)" />';
                }
            },
            {field: 'groupName', title: '그룹명', width: 150, halign: 'center', align: 'center', resizable: true},
            {field: 'empName', title: '사원명', width: 100, halign: 'center', align: 'center', resizable: true},
            {field: 'empCode', title: '사원코드', width: 100, halign: 'center', align: 'center', resizable: true},
            {field: 'email', title: '이메일', width: 200, halign: 'center', align: 'center', resizable: true}
        ]]
    });

    // 파일열기 버튼
    $('#d_fileOpenBtn').bind('click', function() {
        $('#d_excelFile').val('');
        $('#d_excelFile').click();
    });

    // 파일 선택 후 엑셀 파싱 (SheetJS)
    $('#d_excelFile').bind('change', function() {
        if (!this.files || this.files.length === 0) return;

        var file = this.files[0];
        var reader = new FileReader();

        reader.onload = function(e) {
            try {
                var workbook = XLSX.read(e.target.result, {type: 'binary'});
                var sheet = workbook.Sheets[workbook.SheetNames[0]];

                var startRow = parseInt($('#d_startRow').numberbox('getValue')) || 2;
                var colGroupName = ($('#d_colGroupName').textbox('getValue') || 'A').toUpperCase();
                var colEmpName = ($('#d_colEmpName').textbox('getValue') || 'B').toUpperCase();
                var colEmpCode = ($('#d_colEmpCode').textbox('getValue') || 'C').toUpperCase();
                var colEmail = ($('#d_colEmail').textbox('getValue') || 'D').toUpperCase();

                var rows = [];
                var rowIdx = startRow;

                while (true) {
                    var cellEmpCode = sheet[colEmpCode + rowIdx];
                    if (!cellEmpCode || cellEmpCode.v === undefined || cellEmpCode.v === '') break;

                    var cellGroupName = sheet[colGroupName + rowIdx];
                    var cellEmpName = sheet[colEmpName + rowIdx];
                    var cellEmail = sheet[colEmail + rowIdx];

                    rows.push({
                        sel: '0',
                        overwrite: '0',
                        groupName: cellGroupName ? String(cellGroupName.v) : '',
                        empName: cellEmpName ? String(cellEmpName.v) : '',
                        empCode: String(cellEmpCode.v),
                        email: cellEmail ? String(cellEmail.v) : ''
                    });

                    rowIdx++;
                }

                if (rows.length === 0) {
                    $.messager.alert(getTitle('WARNING'), '엑셀에서 데이터를 읽을 수 없습니다.', 'warning');
                    return;
                }

                var cleanRows = JSON.parse(JSON.stringify(rows));
                $('#d_previewGrid').datagrid('loadData', cleanRows);

            } catch (ex) {
                $.messager.alert(getTitle('ERROR'), '엑셀 파일을 읽는 중 오류가 발생했습니다.', 'error');
            }
        };

        reader.readAsBinaryString(file);
    });

    // 저장 (ORD02A_INS3)
    $('#d_saveBtn').bind('click', function() {
        var allRows = $('#d_previewGrid').datagrid('getRows');
        var saveRows = [];
        for (var i = 0; i < allRows.length; i++) {
            if (allRows[i].sel === '1') {
                saveRows.push({
                    groupName: allRows[i].groupName,
                    empName: allRows[i].empName,
                    empCode: allRows[i].empCode,
                    email: allRows[i].email || '',
                    overwrite: allRows[i].overwrite || '0'
                });
            }
        }

        if (saveRows.length === 0) {
            $.messager.alert(getTitle('WARNING'), '저장할 행을 선택하세요.', 'warning');
            return;
        }

        $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_SAVE'), function(r) {
            if (r) {
                $.ajax({
                    url: consts.url.ORD02A_INS3,
                    type: 'POST',
                    data: { models: JSON.stringify(saveRows) },
                    dataType: 'json',
                    success: function(result) {
                        if (result.success) {
                            $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
                            $('#d0a-popup').dialog('close');
                            doSearch();
                        } else {
                            $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
                        }
                    },
                    error: function() {
                    }
                });
            }
        });
    });
}

// D0A 체크박스 토글 (onclick에서 호출)
function toggleD0aSel(cb) {
    var tr = $(cb).closest('tr.datagrid-row');
    var index = parseInt(tr.attr('datagrid-row-index'));
    var row = $('#d_previewGrid').datagrid('getRows')[index];
    if (row) row.sel = cb.checked ? '1' : '0';
}

function toggleD0aOverwrite(cb) {
    var tr = $(cb).closest('tr.datagrid-row');
    var index = parseInt(tr.attr('datagrid-row-index'));
    var row = $('#d_previewGrid').datagrid('getRows')[index];
    if (row) row.overwrite = cb.checked ? '1' : '0';
}
