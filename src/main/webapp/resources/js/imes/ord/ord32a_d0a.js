/**
 * ORD32A D0A - 모델/공정 편집 팝업
 *
 * 원본: ProActive ORD32A_D0A.cs
 * 레이아웃:
 *   - 상단 좌: D0A Grid1 (선택된 모델) / 상단 우: D0A Grid2 (전체 모델)
 *   - 하단 좌: D0A Grid3 (선택된 공정) / 하단 우: D0A Grid4 (전체 공정)
 *   - 우클릭 컨텍스트 메뉴: 추가/제외
 *
 * @author Claude
 * @since 2026-03-10
 */

// ================================================================
// D0A 그리드 초기화 (consts.init() 에서 호출)
// ================================================================

/**
 * D0A 4개 그리드 초기화
 */
function initD0aGrids() {
    // ----------------------------------------------------------
    // D0A Grid1: 선택된 모델 (SEL checkbox + 모델 정보)
    // ----------------------------------------------------------
    $('#d0a-grid1').datagrid({
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        idField: 'model',
        columns: [[
            {field:'ck', title:'선택', checkbox:true, styler: function() { return 'background-color:#FFFFC0;'; }},
            {field:'modelType',   title:'모델군',   width:100, halign:'center', align:'center'},
            {field:'modelSerise', title:'시리즈',   width:100, halign:'center', align:'center'},
            {field:'model',       title:'모델',     width:130, halign:'center', align:'center'}
        ]],
        onRowContextMenu: function(e, index, row) {
            e.preventDefault();
            $(this).datagrid('selectRow', index);
            $('#d0a-grid1-menu').menu('show', {left: e.pageX, top: e.pageY});
        }
    });

    // ----------------------------------------------------------
    // D0A Grid2: 전체 모델 (SEL checkbox + 모델 정보)
    // ----------------------------------------------------------
    $('#d0a-grid2').datagrid({
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        idField: 'model',
        columns: [[
            {field:'ck', title:'선택', checkbox:true, styler: function() { return 'background-color:#FFFFC0;'; }},
            {field:'modelType',   title:'모델군',   width:100, halign:'center', align:'center'},
            {field:'modelSerise', title:'시리즈',   width:100, halign:'center', align:'center'},
            {field:'model',       title:'모델',     width:130, halign:'center', align:'center'}
        ]],
        onRowContextMenu: function(e, index, row) {
            e.preventDefault();
            $(this).datagrid('selectRow', index);
            $('#d0a-grid2-menu').menu('show', {left: e.pageX, top: e.pageY});
        }
    });

    // ----------------------------------------------------------
    // D0A Grid3: 선택된 공정 (SEL checkbox + 공정 정보)
    // ----------------------------------------------------------
    $('#d0a-grid3').datagrid({
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        idField: 'procCode',
        columns: [[
            {field:'ck', title:'선택', checkbox:true, styler: function() { return 'background-color:#FFFFC0;'; }},
            {field:'procCode', title:'공정코드', width:100, halign:'center', align:'center'},
            {field:'procName', title:'공정명',   width:150, halign:'center', align:'left'}
        ]],
        onRowContextMenu: function(e, index, row) {
            e.preventDefault();
            $(this).datagrid('selectRow', index);
            $('#d0a-grid3-menu').menu('show', {left: e.pageX, top: e.pageY});
        }
    });

    // ----------------------------------------------------------
    // D0A Grid4: 전체 공정 (SEL checkbox + 공정 정보)
    // ----------------------------------------------------------
    $('#d0a-grid4').datagrid({
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        idField: 'procCode',
        columns: [[
            {field:'ck', title:'선택', checkbox:true, styler: function() { return 'background-color:#FFFFC0;'; }},
            {field:'procCode', title:'공정코드', width:100, halign:'center', align:'center'},
            {field:'procName', title:'공정명',   width:150, halign:'center', align:'left'}
        ]],
        onRowContextMenu: function(e, index, row) {
            e.preventDefault();
            $(this).datagrid('selectRow', index);
            $('#d0a-grid4-menu').menu('show', {left: e.pageX, top: e.pageY});
        }
    });

}

// ================================================================
// D0A 이벤트 바인딩 ($(function) 에서 호출)
// ================================================================

/**
 * D0A 버튼 이벤트 바인딩
 */
function initD0aEvents() {
    $('#d0a-save-button').bind('click', doD0aSave);
}

// ================================================================
// D0A 팝업: 열기/닫기
// ================================================================

/**
 * D0A 팝업 열기 (Grid1 우클릭 → 편집)
 * AS-IS: D0A 생성자에 focusedDataRow, Grid2, Grid3 전달
 *   → SER2 (선택된 모델/공정) + SER3 (전체 모델/공정) 호출
 */
function doOpenD0a() {
    var fileId = consts.selectedFileId;
    if (!fileId) {
        $.messager.alert('알림', '편집할 파일을 선택하세요.', 'info');
        return;
    }

    // D0A 다이얼로그 열기 + 가운데 정렬 + 내부 레이아웃 리사이즈
    $('#d0a-dialog').dialog('open').dialog('center');
    $('#d0a-dialog .easyui-layout').each(function() {
        $(this).layout('resize');
    });

    // 헤더 "전체선택" 체크박스 → "선택" 텍스트 표시 (AS-IS 동일화)
    // datagrid-cell-check 전체를 일반 텍스트 셀로 교체 (체크박스 셀은 크기가 작아 텍스트 불가)
    $('#d0a-grid1, #d0a-grid2, #d0a-grid3, #d0a-grid4').each(function() {
        var headerCheck = $(this).datagrid('getPanel').find('.datagrid-header-check');
        if (headerCheck.length > 0) {
            headerCheck.parent().html('<span>선택</span>').css('text-align', 'center');
        }
    });

    // 4개 그리드 체크/선택 상태 초기화
    $('#d0a-grid1').datagrid('uncheckAll').datagrid('unselectAll');
    $('#d0a-grid2').datagrid('uncheckAll').datagrid('unselectAll');
    $('#d0a-grid3').datagrid('uncheckAll').datagrid('unselectAll');
    $('#d0a-grid4').datagrid('uncheckAll').datagrid('unselectAll');

    // SER2 (선택된 모델/공정) 조회 → D0A Grid1, Grid3
    $.ajax({
        url: consts.url.ser2,
        type: 'POST',
        dataType: 'json',
        data: {fileId: fileId},
        success: function(res) {
            $('#d0a-grid1').datagrid('loadData', res.models || []);
            $('#d0a-grid3').datagrid('loadData', res.procs || []);
        }
    });

    // SER3 (전체 모델/공정) 조회 → D0A Grid2, Grid4
    $.ajax({
        url: consts.url.ser3,
        type: 'POST',
        dataType: 'json',
        data: {},
        success: function(res) {
            $('#d0a-grid2').datagrid('loadData', res.models || []);
            $('#d0a-grid4').datagrid('loadData', res.procs || []);
        }
    });
}

/**
 * D0A 닫기
 */
function doD0aClose() {
    $('#d0a-dialog').dialog('close');
}

// ================================================================
// D0A: 모델 추가/제외
// ================================================================

/**
 * D0A: 전체 모델에서 선택된 모델로 추가
 * AS-IS: Grid2 → Grid1 (체크된 행 또는 포커스 행)
 */
function doD0aAddModel() {
    var checked = $('#d0a-grid2').datagrid('getChecked');
    if (checked.length == 0) {
        // 체크된 행 없으면 선택(포커스) 행
        var selected = $('#d0a-grid2').datagrid('getSelected');
        if (selected) {
            checked = [selected];
        }
    }
    if (checked.length == 0) {
        $.messager.alert('알림', '추가할 모델을 선택하세요.', 'info');
        return;
    }

    // 기존 선택된 모델 데이터 가져오기
    var existing = $('#d0a-grid1').datagrid('getData').rows;

    for (var i = 0; i < checked.length; i++) {
        var row = checked[i];
        // 중복 체크 (model 필드 기준)
        var isDup = false;
        for (var j = 0; j < existing.length; j++) {
            if (existing[j].model == row.model) {
                isDup = true;
                break;
            }
        }
        if (!isDup) {
            $('#d0a-grid1').datagrid('appendRow', {
                modelType:   row.modelType,
                modelSerise: row.modelSerise,
                model:       row.model
            });
        }
    }

    // 체크 해제
    $('#d0a-grid2').datagrid('uncheckAll');
}

/**
 * D0A: 선택된 모델에서 제외
 * AS-IS: Grid1에서 체크된 행 또는 포커스 행 삭제
 */
function doD0aRemoveModel() {
    var checked = $('#d0a-grid1').datagrid('getChecked');
    if (checked.length == 0) {
        var selected = $('#d0a-grid1').datagrid('getSelected');
        if (selected) {
            checked = [selected];
        }
    }
    if (checked.length == 0) {
        $.messager.alert('알림', '제외할 모델을 선택하세요.', 'info');
        return;
    }

    // 역순으로 삭제 (인덱스 밀림 방지)
    var indices = [];
    for (var i = 0; i < checked.length; i++) {
        var idx = $('#d0a-grid1').datagrid('getRowIndex', checked[i]);
        if (idx >= 0) {
            indices.push(idx);
        }
    }
    indices.sort(function(a, b) { return b - a; });
    for (var i = 0; i < indices.length; i++) {
        $('#d0a-grid1').datagrid('deleteRow', indices[i]);
    }
}

// ================================================================
// D0A: 공정 추가/제외
// ================================================================

/**
 * D0A: 전체 공정에서 선택된 공정으로 추가
 * AS-IS: Grid4 → Grid3 (체크된 행 또는 포커스 행)
 */
function doD0aAddProc() {
    var checked = $('#d0a-grid4').datagrid('getChecked');
    if (checked.length == 0) {
        var selected = $('#d0a-grid4').datagrid('getSelected');
        if (selected) {
            checked = [selected];
        }
    }
    if (checked.length == 0) {
        $.messager.alert('알림', '추가할 공정을 선택하세요.', 'info');
        return;
    }

    var existing = $('#d0a-grid3').datagrid('getData').rows;

    for (var i = 0; i < checked.length; i++) {
        var row = checked[i];
        // 중복 체크 (procCode 필드 기준)
        var isDup = false;
        for (var j = 0; j < existing.length; j++) {
            if (existing[j].procCode == row.procCode) {
                isDup = true;
                break;
            }
        }
        if (!isDup) {
            $('#d0a-grid3').datagrid('appendRow', {
                procCode: row.procCode,
                procName: row.procName
            });
        }
    }

    // 체크 해제
    $('#d0a-grid4').datagrid('uncheckAll');
}

/**
 * D0A: 선택된 공정에서 제외
 * AS-IS: Grid3에서 체크된 행 또는 포커스 행 삭제
 */
function doD0aRemoveProc() {
    var checked = $('#d0a-grid3').datagrid('getChecked');
    if (checked.length == 0) {
        var selected = $('#d0a-grid3').datagrid('getSelected');
        if (selected) {
            checked = [selected];
        }
    }
    if (checked.length == 0) {
        $.messager.alert('알림', '제외할 공정을 선택하세요.', 'info');
        return;
    }

    var indices = [];
    for (var i = 0; i < checked.length; i++) {
        var idx = $('#d0a-grid3').datagrid('getRowIndex', checked[i]);
        if (idx >= 0) {
            indices.push(idx);
        }
    }
    indices.sort(function(a, b) { return b - a; });
    for (var i = 0; i < indices.length; i++) {
        $('#d0a-grid3').datagrid('deleteRow', indices[i]);
    }
}

// ================================================================
// D0A: 저장
// ================================================================

/**
 * D0A 저장
 * AS-IS: 모델&공정 중 하나만 있고 다른 하나가 비어있으면 에러
 *        RQSTDT(PLT_CODE, FILE_ID) + RQSTDT_MODEL + RQSTDT_PROC 전송
 *        → ORD32A_INS (Delete-Insert 패턴)
 */
function doD0aSave() {
    var fileId = consts.selectedFileId;
    console.log('[D0A] doD0aSave 호출, fileId=', fileId);
    if (!fileId) {
        $.messager.alert('알림', '파일이 선택되지 않았습니다.', 'info');
        return;
    }

    // D0A Grid1 (선택된 모델), Grid3 (선택된 공정) 데이터 수집
    var modelRows = $('#d0a-grid1').datagrid('getData').rows;
    var procRows  = $('#d0a-grid3').datagrid('getData').rows;
    console.log('[D0A] Grid1 모델수:', modelRows.length, ', Grid3 공정수:', procRows.length);

    // AS-IS 검증: 모델&공정 중 선택되지 않은 항목 존재 체크
    if ((modelRows.length > 0 && procRows.length == 0) ||
        (modelRows.length == 0 && procRows.length > 0)) {
        $.messager.alert('알림', '모델&공정중 선택되지 않은 항목이 존재합니다.', 'warning');
        return;
    }

    // 모델 데이터 (model 필드만)
    var models = [];
    for (var i = 0; i < modelRows.length; i++) {
        models.push({model: modelRows[i].model});
    }

    // 공정 데이터 (procCode 필드만)
    var procs = [];
    for (var i = 0; i < procRows.length; i++) {
        procs.push({procCode: procRows[i].procCode});
    }

    console.log('[D0A] 전송 데이터:', JSON.stringify({fileId: fileId, models: models, procs: procs}));

    $.ajax({
        url: consts.url.ins,
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({
            fileId: fileId,
            models: models,
            procs:  procs
        }),
        success: function(res) {
            console.log('[D0A] INS 응답:', JSON.stringify(res));
            if (res.success) {
                $.messager.alert('알림', '저장되었습니다.', 'info', function() {
                    console.log('[D0A] 알림 OK 클릭 → doD0aClose + doGetDetail(' + fileId + ')');
                    // 저장 후 D0A 닫고, 메인 Grid2/Grid3 갱신
                    doD0aClose();
                    doGetDetail(fileId);
                });
            } else {
                console.log('[D0A] INS 실패: res.success=', res.success, ', res.error=', res.error);
                $.messager.alert('오류', res.message || res.error || '저장 실패', 'error');
            }
        },
        error: function(xhr, status, err) {
            console.error('[D0A] INS AJAX 에러:', status, err, xhr.responseText);
            $.messager.alert('오류', '저장 중 오류가 발생했습니다.', 'error');
        }
    });
}
