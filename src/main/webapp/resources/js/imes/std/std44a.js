/**
 * ============================================================================
 * 화면명: STD44A - 모델군 관리
 * ============================================================================
 * 설명: 모델군 목록 조회, 등록, 수정, 삭제
 *       3단 수평 분할 — 구분(B) → 시리즈(M) → 모델(S)
 *       TSTD_MODEL 테이블 단일 사용, DATA_TYPE(B/M/S)로 계층 구분
 * 작성자: 송우석
 * 작성일: 2026-02-20
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var editIndexB = undefined;   // 구분 그리드 편집 중인 행 인덱스
var editIndexM = undefined;   // 시리즈 그리드 편집 중인 행 인덱스
var editIndexS = undefined;   // 모델 그리드 편집 중인 행 인덱스
var codeDataMap = {};         // 코드 데이터 캐시

// ============================================================================
// consts
// ============================================================================
var consts = {
    url: {
        STD44A_SER: getUrl('/imes/std/std44a/STD44A_SER.json'),
        STD44A_INS: getUrl('/imes/std/std44a/STD44A_INS.json'),
        STD44A_DEL: getUrl('/imes/std/std44a/STD44A_DEL.json'),
        CODE_LIST:  getUrl('/common/code/code.json')
    },

    codeData: {},

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

    init: function() {
        // --- 코드 데이터 로드 ---
        consts.codeData.S907 = this.loadCode('S907');  // 유형 (PROD_TYPE)
        consts.codeData.S900 = this.loadCode('S900');  // 사용여부 (USE_FLAG)

        // --- Grid1: 구분 (B) ---
        $('#grid-b').datagrid({
            title: '구분',
            toolbar: '#toolbar-b',
            fit: true,
            fitColumns: true,
            autoRowHeight: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'scode',
            columns: [[
                {field: 'prodType', title: '유형', width: 40, halign: 'center', align: 'center',
                    formatter: function(value) { return _codeName(consts.codeData.S907, value); },
                    editor: {
                        type: 'combobox',
                        options: {
                            data: consts.codeData.S907,
                            valueField: 'codeCd',
                            textField: 'codeName',
                            panelHeight: 'auto',
                            editable: false
                        }
                    }
                },
                {field: 'modelType', title: '구분', width: 80, halign: 'center', align: 'left',
                    editor: { type: 'textbox', options: { validType: 'length[0,50]' } }
                },
                {field: 'useFlag', title: '사용여부', width: 120, halign: 'center', align: 'center',
                    formatter: function(value, row, index) { return _radioUseFlag('B', index, value); }
                },
                {field: 'scode', hidden: true}
            ]],
            onSelect: function(index, row) {
                _endEdit('B');
                onSelectB(row);
            },
            onClickRow: function(index, row) {
                _beginEdit('#grid-b', index, 'B');
            },
            onBeforeEdit: function(index, row) {
                row._savedUseFlag = row.useFlag;
                editIndexB = index;
            },
            onAfterEdit: function(index, row, changes) {
                if (row._savedUseFlag !== undefined) {
                    row.useFlag = row._savedUseFlag;
                    delete row._savedUseFlag;
                }
                editIndexB = undefined;
            },
            onCancelEdit: function(index, row) {
                if (row._savedUseFlag !== undefined) {
                    row.useFlag = row._savedUseFlag;
                    delete row._savedUseFlag;
                }
                editIndexB = undefined;
            },
        });
        GridHeaderMenu('#grid-b', { exportFileName: '구분목록' });

        // --- Grid2: 시리즈 (M) ---
        $('#grid-m').datagrid({
            title: '시리즈',
            toolbar: '#toolbar-m',
            fit: true,
            fitColumns: true,
            autoRowHeight: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'scode',
            columns: [[
                {field: 'modelType', title: '구분', width: 80, halign: 'center', align: 'left', data_item: 'GRD_002'},
                {field: 'modelSerise', title: '시리즈', width: 70, halign: 'center', align: 'left', data_item: 'GRD_004',
                    editor: { type: 'textbox', options: { validType: 'length[0,50]' } }
                },
                {field: 'useFlag', title: '사용여부', width: 120, halign: 'center', align: 'center', data_item: 'GRD_003',
                    formatter: function(value, row, index) { return _radioUseFlag('M', index, value); }
                },
                {field: 'scode', hidden: true}
            ]],
            onSelect: function(index, row) {
                _endEdit('M');
                onSelectM(row);
            },
            onClickRow: function(index, row) {
                _beginEdit('#grid-m', index, 'M');
            },
            onBeforeEdit: function(index, row) {
                row._savedUseFlag = row.useFlag;
                editIndexM = index;
            },
            onAfterEdit: function(index, row, changes) {
                if (row._savedUseFlag !== undefined) {
                    row.useFlag = row._savedUseFlag;
                    delete row._savedUseFlag;
                }
                editIndexM = undefined;
            },
            onCancelEdit: function(index, row) {
                if (row._savedUseFlag !== undefined) {
                    row.useFlag = row._savedUseFlag;
                    delete row._savedUseFlag;
                }
                editIndexM = undefined;
            },
        });
        GridHeaderMenu('#grid-m', { exportFileName: '시리즈목록' });

        // --- Grid3: 모델 (S) ---
        $('#grid-s').datagrid({
            title: '모델',
            toolbar: '#toolbar-s',
            fit: true,
            fitColumns: true,
            autoRowHeight: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'scode',
            columns: [[
                {field: 'modelType', title: '구분', width: 80, halign: 'center', align: 'left', data_item: 'GRD_002'},
                {field: 'modelSerise', title: '시리즈', width: 60, halign: 'center', align: 'left', data_item: 'GRD_004'},
                {field: 'modelNo', title: '모델', width: 80, halign: 'center', align: 'left', data_item: 'GRD_005',
                    editor: { type: 'textbox', options: { validType: 'length[0,50]' } }
                },
                {field: 'modelCode', title: '호기관리', width: 80, halign: 'center', align: 'left', data_item: 'GRD_006',
                    editor: { type: 'textbox', options: { validType: 'length[0,50]' } }
                },
                {field: 'useFlag', title: '사용여부', width: 110, halign: 'center', align: 'center', data_item: 'GRD_003',
                    formatter: function(value, row, index) { return _radioUseFlag('S', index, value); }
                },
                {field: 'scode', hidden: true}
            ]],
            onSelect: function(index, row) {
                _endEdit('S');
            },
            onClickRow: function(index, row) {
                _beginEdit('#grid-s', index, 'S');
            },
            onBeforeEdit: function(index, row) {
                row._savedUseFlag = row.useFlag;
                editIndexS = index;
            },
            onAfterEdit: function(index, row, changes) {
                if (row._savedUseFlag !== undefined) {
                    row.useFlag = row._savedUseFlag;
                    delete row._savedUseFlag;
                }
                editIndexS = undefined;
            },
            onCancelEdit: function(index, row) {
                if (row._savedUseFlag !== undefined) {
                    row.useFlag = row._savedUseFlag;
                    delete row._savedUseFlag;
                }
                editIndexS = undefined;
            },
        });
        GridHeaderMenu('#grid-s', { exportFileName: '모델목록' });

        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#btn-add-b').bind('click', function() { doAddRow('B'); });
        $('#btn-save-b').bind('click', function() { doSaveGrid('B'); });
        $('#btn-add-m').bind('click', function() { doAddRow('M'); });
        $('#btn-save-m').bind('click', function() { doSaveGrid('M'); });
        $('#btn-add-s').bind('click', function() { doAddRow('S'); });
        $('#btn-save-s').bind('click', function() { doSaveGrid('S'); });

        // --- 삭제 버튼 이벤트 ---
        $('#btn-del-b').bind('click', function() { doDelete('B'); });
        $('#btn-del-m').bind('click', function() { doDelete('M'); });
        $('#btn-del-s').bind('click', function() { doDelete('S'); });

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
    // 시리즈/모델 버튼 초기 비활성화 (EasyUI 파싱 완료 후 실행)
    _setButtonEnabled('M', false);
    _setButtonEnabled('S', false);
    enableGridSortReset('#grid-b');
    enableGridSortReset('#grid-m');
    enableGridSortReset('#grid-s');
    doSearch();
});

// ============================================================================
// 조회
// ============================================================================

/**
 * 구분(B) 조회 → Grid1 로드, Grid2/Grid3 초기화
 */
function doSearch() {
    _endEdit('B');
    _endEdit('M');
    _endEdit('S');

    // Grid2, Grid3 초기화
    $('#grid-m').datagrid('loadData', []);
    $('#grid-s').datagrid('loadData', []);
    _setButtonEnabled('M', false);
    _setButtonEnabled('S', false);

    $.ajax({
        url: consts.url.STD44A_SER,
        type: 'POST',
        data: { dataType: 'B' },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#grid-b').datagrid('loadData', rows);
            // 첫 행 선택 (onSelect 이벤트에서 onSelectB 자동 호출)
            if (rows.length > 0) {
                $('#grid-b').datagrid('selectRow', 0);
            }
        }
    });
}

/**
 * 시리즈(M) 조회 → Grid2 로드, Grid3 초기화
 */
function doSearchM(pScode) {
    _endEdit('M');
    _endEdit('S');

    // Grid3 초기화
    $('#grid-s').datagrid('loadData', []);
    _setButtonEnabled('S', false);

    $.ajax({
        url: consts.url.STD44A_SER,
        type: 'POST',
        data: { dataType: 'M', pScode: pScode },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#grid-m').datagrid('loadData', rows);
            // 첫 행 선택 (onSelect 이벤트에서 onSelectM 자동 호출)
            if (rows.length > 0) {
                $('#grid-m').datagrid('selectRow', 0);
            }
        }
    });
}

/**
 * 모델(S) 조회 → Grid3 로드
 */
function doSearchS(pScode) {
    _endEdit('S');

    $.ajax({
        url: consts.url.STD44A_SER,
        type: 'POST',
        data: { dataType: 'S', pScode: pScode },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#grid-s').datagrid('loadData', rows);
        }
    });
}

// ============================================================================
// 마스터-디테일 연동
// ============================================================================

/**
 * Grid1 행 선택 → Grid2 조회, Grid3 초기화
 */
function onSelectB(row) {
    if (!row || !row.scode || row.scode === '') {
        // 신규 행 (SCODE 없음) → 시리즈/모델 비활성화
        $('#grid-m').datagrid('loadData', []);
        $('#grid-s').datagrid('loadData', []);
        _setButtonEnabled('M', false);
        _setButtonEnabled('S', false);
        return;
    }
    _setButtonEnabled('M', true);
    doSearchM(row.scode);
}

/**
 * Grid2 행 선택 → Grid3 조회
 */
function onSelectM(row) {
    if (!row || !row.scode || row.scode === '') {
        // 신규 행 (SCODE 없음) → 모델 비활성화
        $('#grid-s').datagrid('loadData', []);
        _setButtonEnabled('S', false);
        return;
    }
    _setButtonEnabled('S', true);
    doSearchS(row.scode);
}

// ============================================================================
// 행 추가
// ============================================================================

/**
 * 해당 그리드에 새 행 추가
 * USE_FLAG 기본값 '1' (사용)
 */
function doAddRow(type) {
    _endEdit(type);

    var gridId, parentRow;
    switch (type) {
        case 'B':
            gridId = '#grid-b';
            break;
        case 'M':
            gridId = '#grid-m';
            parentRow = $('#grid-b').datagrid('getSelected');
            if (!parentRow || !parentRow.scode) {
                $.messager.alert(getTitle('WARNING'), '구분을 먼저 선택하세요.', 'warning');
                return;
            }
            break;
        case 'S':
            gridId = '#grid-s';
            parentRow = $('#grid-m').datagrid('getSelected');
            if (!parentRow || !parentRow.scode) {
                $.messager.alert(getTitle('WARNING'), '시리즈를 먼저 선택하세요.', 'warning');
                return;
            }
            break;
    }

    var newRow = { useFlag: '1', scode: '' };

    // 부모 데이터 복사
    if (type === 'M') {
        var bRow = $('#grid-b').datagrid('getSelected');
        newRow.modelType = bRow.modelType || '';
    } else if (type === 'S') {
        var bRow2 = $('#grid-b').datagrid('getSelected');
        var mRow = $('#grid-m').datagrid('getSelected');
        newRow.modelType = bRow2 ? (bRow2.modelType || '') : '';
        newRow.modelSerise = mRow ? (mRow.modelSerise || '') : '';
    }

    $(gridId).datagrid('appendRow', newRow);

    var rowCount = $(gridId).datagrid('getRows').length;
    var newIndex = rowCount - 1;
    $(gridId).datagrid('selectRow', newIndex);
    _beginEdit(gridId, newIndex, type);
}

// ============================================================================
// 저장
// ============================================================================

/**
 * 해당 그리드의 변경된 행을 수집하여 저장
 */
function doSaveGrid(type) {
    _endEdit(type);

    var gridId;
    switch (type) {
        case 'B': gridId = '#grid-b'; break;
        case 'M': gridId = '#grid-m'; break;
        case 'S': gridId = '#grid-s'; break;
    }

    // 변경/추가된 행 수집
    var rows = $(gridId).datagrid('getRows');
    var changedRows = $(gridId).datagrid('getChanges');

    // useFlag만 변경된 행도 추가 (EasyUI getChanges에서 누락되는 경우 대비)
    for (var k = 0; k < rows.length; k++) {
        if (rows[k]._useFlagDirty) {
            var already = false;
            for (var j = 0; j < changedRows.length; j++) {
                if (changedRows[j] === rows[k]) { already = true; break; }
            }
            if (!already) changedRows.push(rows[k]);
        }
    }

    if (changedRows.length === 0) {
        $.messager.alert(getTitle('INFO'), getMessage('NO_CHANGED'), 'info');
        return;
    }

    // 유효성 검증
    var models = [];
    for (var i = 0; i < changedRows.length; i++) {
        var r = changedRows[i];
        var m = {};

        switch (type) {
            case 'B':
                if (!r.modelType || r.modelType.trim() === '') continue;
                m.modelType = r.modelType;
                m.prodType = r.prodType || '';
                m.useFlag = r.useFlag || '1';
                m.scode = r.scode || '';
                break;
            case 'M':
                if (!r.modelSerise || r.modelSerise.trim() === '') continue;
                var bRow = $('#grid-b').datagrid('getSelected');
                m.modelType = bRow ? bRow.modelType : r.modelType;
                m.prodType = bRow ? bRow.prodType : '';
                m.pScode = bRow ? bRow.scode : '';
                m.modelSerise = r.modelSerise;
                m.useFlag = r.useFlag || '1';
                m.scode = r.scode || '';
                break;
            case 'S':
                if (!r.modelNo || r.modelNo.trim() === '') continue;
                var bRow2 = $('#grid-b').datagrid('getSelected');
                var mRow = $('#grid-m').datagrid('getSelected');
                m.modelType = bRow2 ? bRow2.modelType : r.modelType;
                m.prodType = bRow2 ? bRow2.prodType : '';
                m.modelSerise = mRow ? mRow.modelSerise : r.modelSerise;
                m.pScode = mRow ? mRow.scode : '';
                m.modelNo = r.modelNo;
                m.modelCode = r.modelCode || '';
                m.useFlag = r.useFlag || '1';
                m.scode = r.scode || '';
                break;
        }
        models.push(m);
    }

    if (models.length === 0) {
        $.messager.alert(getTitle('WARNING'), '저장할 유효 데이터가 없습니다.', 'warning');
        return;
    }

    $.ajax({
        url: consts.url.STD44A_INS,
        type: 'POST',
        data: {
            dataType: type,
            models: JSON.stringify(models)
        },
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
                // 저장 후 재조회
                switch (type) {
                    case 'B': doSearch(); break;
                    case 'M':
                        var bSel = $('#grid-b').datagrid('getSelected');
                        if (bSel) doSearchM(bSel.scode);
                        break;
                    case 'S':
                        var mSel = $('#grid-m').datagrid('getSelected');
                        if (mSel) doSearchS(mSel.scode);
                        break;
                }
            } else {
                $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
            }
        },
        error: function() {
        }
    });
}

// ============================================================================
// 삭제 (컨텍스트 메뉴)
// ============================================================================

/**
 * 선택된 행 논리 삭제
 */
function doDelete(type) {
    var gridId;
    switch (type) {
        case 'B': gridId = '#grid-b'; break;
        case 'M': gridId = '#grid-m'; break;
        case 'S': gridId = '#grid-s'; break;
    }

    var row = $(gridId).datagrid('getSelected');
    if (!row) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    // 신규 행 (SCODE 없음) → 로컬에서만 삭제
    if (!row.scode || row.scode === '') {
        var idx = $(gridId).datagrid('getRowIndex', row);
        $(gridId).datagrid('cancelEdit', idx);
        $(gridId).datagrid('deleteRow', idx);
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_DELETE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.STD44A_DEL,
                type: 'POST',
                data: { scode: row.scode },
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success || getMessage('DELETED'), 'info');
                        // 삭제 후 재조회
                        switch (type) {
                            case 'B': doSearch(); break;
                            case 'M':
                                var bSel = $('#grid-b').datagrid('getSelected');
                                if (bSel) {
                                    doSearchM(bSel.scode);
                                }
                                break;
                            case 'S':
                                var mSel = $('#grid-m').datagrid('getSelected');
                                if (mSel) {
                                    doSearchS(mSel.scode);
                                }
                                break;
                        }
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
// 인라인 편집 헬퍼
// ============================================================================

/**
 * 편집 종료 + KEY 컬럼 readonly 처리
 */
function _endEdit(type) {
    var gridId, editIndex;
    switch (type) {
        case 'B':
            gridId = '#grid-b';
            editIndex = editIndexB;
            break;
        case 'M':
            gridId = '#grid-m';
            editIndex = editIndexM;
            break;
        case 'S':
            gridId = '#grid-s';
            editIndex = editIndexS;
            break;
    }
    if (editIndex !== undefined) {
        $(gridId).datagrid('endEdit', editIndex);
    }
}

/**
 * 행 클릭 시 인라인 편집 시작
 * AS-IS ShowingEditor 재현: 기존 행의 KEY 컬럼은 editor 자체를 제거하여 plain text 유지
 */
function _beginEdit(gridId, index, type) {
    var row = $(gridId).datagrid('getRows')[index];
    var isExisting = (row && row.scode && row.scode !== '');

    // KEY 컬럼의 editor를 동적 제거/복원 (beginEdit 전에 설정해야 반영됨)
    switch (type) {
        case 'B':
            // modelType: 기존 행이면 editor 제거, 신규면 editor 복원
            $(gridId).datagrid('getColumnOption', 'modelType').editor = isExisting ? null : {type: 'textbox', options: {validType: 'length[0,50]'}};
            break;
        case 'M':
            // modelSerise: 기존 행이면 editor 제거, 신규면 editor 복원
            $(gridId).datagrid('getColumnOption', 'modelSerise').editor = isExisting ? null : {type: 'textbox', options: {validType: 'length[0,50]'}};
            break;
        case 'S':
            // modelNo: 기존 행이면 editor 제거, 신규면 editor 복원
            $(gridId).datagrid('getColumnOption', 'modelNo').editor = isExisting ? null : {type: 'textbox', options: {validType: 'length[0,50]'}};
            break;
    }

    $(gridId).datagrid('beginEdit', index);

    // combobox 에디터 드롭다운 방향 자동 조정
    _bindComboDirection(gridId, index);
}

/**
 * beginEdit 후 combobox 에디터의 드롭다운 방향을 위/아래 가용 공간 비교로 조정
 */
function _bindComboDirection(gridId, index) {
    var fields = $(gridId).datagrid('getColumnFields');
    for (var i = 0; i < fields.length; i++) {
        var ed = $(gridId).datagrid('getEditor', {index: index, field: fields[i]});
        if (ed && ed.type === 'combobox') {
            var opts = $(ed.target).combobox('options');
            opts.onShowPanel = function() {
                var $panel = $(this).combobox('panel');
                var $combo = $(this).next('.combo');
                if ($combo.length === 0) return;
                var offset = $combo.offset();
                var comboH = $combo.outerHeight();
                var $gp = $(gridId).datagrid('getPanel');
                var gridTop = $gp.offset().top;
                var gridBottom = gridTop + $gp.outerHeight();
                var spaceBelow = gridBottom - (offset.top + comboH);
                var spaceAbove = offset.top - gridTop;
                var maxH = Math.max(spaceBelow, spaceAbove) - 5;
                if (maxH < 50) maxH = 50;
                $panel.panel('resize', {height: 'auto'});
                var panelH = $panel.outerHeight();
                if (panelH > maxH) {
                    $panel.panel('resize', {height: maxH});
                    panelH = maxH;
                }
                if (spaceBelow < panelH && spaceAbove > spaceBelow) {
                    $panel.panel('move', {
                        left: offset.left,
                        top: offset.top - panelH
                    });
                }
            };
        }
    }
}

// ============================================================================
// 유틸리티 함수
// ============================================================================

/**
 * 사용여부 라디오 버튼 HTML 생성
 * stopPropagation: onClickRow → beginEdit 방지 (변경 추적 보호)
 */
function _radioUseFlag(gridType, index, value) {
    var chk1 = (value === '1') ? ' checked' : '';
    var chk0 = (value !== '1') ? ' checked' : '';
    var g = gridType.toLowerCase();
    return '<label style="margin-right:4px"><input type="radio" name="uf_' + g + '_' + index + '"' + chk1 +
           ' onclick="event.stopPropagation(); toggleUseFlag(\'' + gridType + '\',' + index + ',\'1\')"/> 사용</label>' +
           '<label><input type="radio" name="uf_' + g + '_' + index + '"' + chk0 +
           ' onclick="event.stopPropagation(); toggleUseFlag(\'' + gridType + '\',' + index + ',\'0\')"/> 미사용</label>';
}

/**
 * 사용여부 라디오 클릭 시 값 변경
 * _useFlagDirty 플래그로 변경 추적 (EasyUI getChanges 우회)
 */
function toggleUseFlag(gridType, index, value) {
    _endEdit(gridType);
    var gridId = '#grid-' + gridType.toLowerCase();
    var rows = $(gridId).datagrid('getRows');
    if (rows[index]) {
        rows[index].useFlag = value;
        rows[index]._savedUseFlag = value;
        rows[index]._useFlagDirty = true;
        $(gridId).datagrid('refreshRow', index);
    }
}

/**
 * 코드 데이터에서 codeCd로 codeName 반환
 */
function _codeName(codeData, value) {
    if (!codeData || !value) return value || '';
    for (var i = 0; i < codeData.length; i++) {
        if (codeData[i].codeCd === value) return codeData[i].codeName;
    }
    return value;
}

/**
 * 추가/저장 버튼 활성화/비활성화
 */
function _setButtonEnabled(type, enabled) {
    var action = enabled ? 'enable' : 'disable';
    var ids;
    if (type === 'M') {
        ids = ['#btn-add-m', '#btn-save-m', '#btn-del-m'];
    } else if (type === 'S') {
        ids = ['#btn-add-s', '#btn-save-s', '#btn-del-s'];
    }
    if (ids) {
        for (var i = 0; i < ids.length; i++) {
            var $el = $(ids[i]);
            if ($el.length && $el.data('linkbutton')) {
                $el.linkbutton(action);
            }
        }
    }
}

function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
    // display:none → show 전환 후 내부 레이아웃+그리드 fitColumns 재계산
    $('#account-layout').layout('resize');
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
