/**
 * ============================================================================
 * 화면명: QCT06A - 자주검사 연계 관리
 * ============================================================================
 * 설명: 부품-검사그룹 연계 관리
 *       탭: 조립(3603), 그룹 연계 리스트
 *       D0A: 검사그룹 추가 팝업 (체크박스 선택)
 * 작성자: 송우석
 * 작성일: 2026-03-06
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var codeDataMap = {};
var d0aInited = false;
var activeTab = 'assy';  // 'assy', 'list'

// 탭별 상태
var tabs = {
    assy: { plants: '3603', showProdType: false, inited: false,
            partCode: '', grpCode: '', editIdx: undefined, changed: {}, original: {} },
    list: { inited: false }
};

// 현재 활성 탭 상태 반환
function T() { return tabs[activeTab]; }
// 현재 탭 그리드 셀렉터
function G(id) { return '#' + activeTab + '-' + id; }


// ============================================================================
// consts (STD45A 패턴)
// ============================================================================
var consts = {
    url: {
        QCT06A_SER:  getUrl('/imes/qct/qct06a/QCT06A_SER.json'),
        QCT06A_SER2: getUrl('/imes/qct/qct06a/QCT06A_SER2.json'),
        QCT06A_SER3: getUrl('/imes/qct/qct06a/QCT06A_SER3.json'),
        QCT06A_SER5: getUrl('/imes/qct/qct06a/QCT06A_SER5.json'),
        QCT06A_SER6: getUrl('/imes/qct/qct06a/QCT06A_SER6.json'),
        QCT06A_INS:  getUrl('/imes/qct/qct06a/QCT06A_INS.json'),
        QCT06A_UPD:  getUrl('/imes/qct/qct06a/QCT06A_UPD.json'),
        QCT06A_DEL:  getUrl('/imes/qct/qct06a/QCT06A_DEL.json'),
        CODE_LIST:   getUrl('/common/code/code.json')
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
        // 코드 데이터 로드
        consts.codeData = {};
        consts.codeData.C011 = this.loadCode('C011');
        consts.codeData.C053 = this.loadCode('C053');
        consts.codeData.C054 = this.loadCode('C054');
        consts.codeData.S900 = this.loadCode('S900');

        // 조립 탭 그리드 초기화 (첫 번째 탭이므로 즉시)
        initTabGrids('assy');

        // 탭 전환 이벤트
        $('#main-tabs').tabs({
            onSelect: function(title, index) {
                // 이전 탭 편집 중인 행 종료
                if (activeTab === 'assy' && tabs.assy.editIdx !== undefined) {
                    try {
                        $('#assy-group-grid').datagrid('endEdit', tabs.assy.editIdx);
                    } catch(e) {}
                    tabs.assy.editIdx = undefined;
                }
                if (index === 0) {
                    activeTab = 'assy';
                    if (!tabs.assy.inited) initTabGrids('assy');
                } else if (index === 1) {
                    activeTab = 'list';
                    if (!tabs.list.inited) {
                        initListGrid();
                    }
                }
            }
        });

        // 공통 버튼 이벤트
        $('#search-button').bind('click', doSearch);
        $('#ctx-delete-group').bind('click', doDeleteGroup);

        // D0A 팝업 닫기 버튼 (하단 buttons, 항상 DOM에 존재)
        $('#d0a-close-button').bind('click', function() {
            $('#d0a-popup').dialog('close');
        });
    }
};


// ============================================================================
// 탭 그리드 초기화 (조립/가공 공통)
// ============================================================================
function initTabGrids(prefix) {
    var state = tabs[prefix];
    if (state.inited) return;
    state.inited = true;

    var showProdType = state.showProdType;

    // --- 부품 그리드 (AS-IS: "모델") ---
    $('#' + prefix + '-part-grid').datagrid({
        title: '모델',
        method: 'post',
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'partCode',
        columns: [[
            {field: 'partCode', title: '대표코드', width: 120, halign: 'center', align: 'left'},
            {field: 'partName', title: '내역', width: 180, halign: 'center', align: 'left'}
        ]],
        onLoadSuccess: function(data) {
            state.partCode = '';
            state.grpCode = '';
            $('#' + prefix + '-group-grid').datagrid('loadData', []);
            $('#' + prefix + '-detail-grid').datagrid('loadData', []);
            var rows = data.rows || data || [];
            if (rows.length > 0) {
                $(this).datagrid('selectRow', 0);
                state.partCode = rows[0].partCode;
                _loadGroups(prefix, rows[0].partCode);
            }
        },
        onClickRow: function(index, row) {
            if (row.partCode && row.partCode !== state.partCode) {
                state.partCode = row.partCode;
                state.grpCode = '';
                _loadGroups(prefix, row.partCode);
                $('#' + prefix + '-detail-grid').datagrid('loadData', []);
            }
        }
    });

    // --- 검사그룹 그리드 ---
    $('#' + prefix + '-group-grid').datagrid({
        title: '검사그룹',
        method: 'post',
        fit: true,
        fitColumns: true,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'insGrpCode',
        columns: [[
            {field: 'insGrpCode', hidden: true},
            {field: 'insGrpName', title: '자주검사그룹', width: 180, halign: 'center', align: 'left'},
            {field: 'insGrpSeq', title: '순번', width: 60, halign: 'center', align: 'right',
                editor: {type: 'numberbox', options: {precision: 0, min: 0}}
            },
            {field: 'scomment', title: '비고', width: 150, halign: 'center', align: 'left'}
        ]],
        rowStyler: function(index, row) {
            if (row.insGrpCode && state.changed[row.insGrpCode]) {
                return 'background-color:#90EE90';
            }
        },
        onLoadSuccess: function(data) {
            state.editIdx = undefined;
            state.changed = {};
            state.original = {};
            var rows = data.rows || data;
            for (var i = 0; i < rows.length; i++) {
                var r = rows[i];
                if (r.insGrpCode) {
                    state.original[r.insGrpCode] = r.insGrpSeq || '';
                }
            }
            state.grpCode = '';
            $('#' + prefix + '-detail-grid').datagrid('loadData', []);
            if (rows.length > 0) {
                $(this).datagrid('selectRow', 0);
                $(this).datagrid('beginEdit', 0);
                state.editIdx = 0;
                if (rows[0].insGrpCode) {
                    state.grpCode = rows[0].insGrpCode;
                    _loadDetail(prefix, rows[0].insGrpCode);
                }
            }
        },
        onClickRow: function(index, row) {
            if (state.editIdx !== index) {
                if (state.editIdx !== undefined) {
                    $(this).datagrid('endEdit', state.editIdx);
                }
                $(this).datagrid('beginEdit', index);
                state.editIdx = index;
            }
            if (row.insGrpCode) {
                state.grpCode = row.insGrpCode;
                _loadDetail(prefix, row.insGrpCode);
            } else {
                state.grpCode = '';
                $('#' + prefix + '-detail-grid').datagrid('loadData', []);
            }
        },
        onBeginEdit: function(index, row) {
            var gridId = '#' + prefix + '-group-grid';
            var ed = $(gridId).datagrid('getEditor', {index: index, field: 'insGrpSeq'});
            if (ed) {
                var $cell = $(ed.target).closest('td');
                $cell.find('input').each(function() {
                    this.style.setProperty('text-align', 'right', 'important');
                });
            }
        },
        onAfterEdit: function(index, row) {
            state.editIdx = undefined;
            if (row.insGrpCode && state.original[row.insGrpCode] !== undefined) {
                var origSeq = state.original[row.insGrpCode] + '';
                var newSeq = (row.insGrpSeq || '') + '';
                if (origSeq !== newSeq) {
                    state.changed[row.insGrpCode] = true;
                } else {
                    delete state.changed[row.insGrpCode];
                }
                $(this).datagrid('refreshRow', index);
            }
        },
        onCancelEdit: function() {
            state.editIdx = undefined;
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault();
            $(this).datagrid('selectRow', rowIndex);
            if (rowData.insGrpCode) {
                state.grpCode = rowData.insGrpCode;
                _loadDetail(prefix, rowData.insGrpCode);
            }
            $('#group-context-menu').menu('show', {left: e.pageX, top: e.pageY});
        }
    });

    // --- 검사항목 그리드 (ReadOnly) ---
    var detailCols = buildDetailGridColumns(showProdType);
    $('#' + prefix + '-detail-grid').datagrid({
        title: '검사항목',
        method: 'post',
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'insCode',
        columns: [detailCols]
    });

    // --- 탭별 버튼 이벤트 ---
    $('#' + prefix + '-add-btn').bind('click', doOpenD0a);
    $('#' + prefix + '-save-btn').bind('click', doSaveSeq);

}


// ============================================================================
// 리스트 탭 그리드 초기화
// ============================================================================
function initListGrid() {
    if (tabs.list.inited) return;
    tabs.list.inited = true;

    $('#list-grid').datagrid({
        method: 'post',
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        columns: [[
            {field: 'partCode', title: '대표코드', width: 120, halign: 'center', align: 'left'},
            {field: 'partName', title: '품목명', width: 180, halign: 'center', align: 'left'},
            {field: 'insGrpCode', title: '검사그룹코드', hidden: true},
            {field: 'insGrpName', title: '검사그룹명', width: 180, halign: 'center', align: 'left'},
            {field: 'grpSeq', title: '순번', width: 60, halign: 'center', align: 'left'},
            {field: 'scomment', title: '비고', width: 150, halign: 'center', align: 'left'},
            {field: 'useFlag', title: '사용여부', width: 70, halign: 'center', align: 'center',
                formatter: function(value) { return formatCode('S900', value); }
            }
        ]]
    });
    $('#list-grid').datagrid('getPanel').find('.datagrid-view').addClass('noStyle');

    // Enter 키
    $('#list_partLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) doSearchList();
    });
    $('#list_groupLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) doSearchList();
    });

    // 그리드 초기화 후 헤더 메뉴/정렬 적용
    GridHeaderMenu('#list-grid', { exportFileName: '자주검사연계관리' });
    enableGridSortReset('#list-grid');
}


// ============================================================================
// 그리드 컬럼 정의
// ============================================================================
function buildDetailGridColumns(showProdType) {
    var cols = [
        {field: 'insCode', hidden: true},
        {field: 'procCode', title: '검사공정', width: 75, halign: 'center', align: 'center'}
    ];
    if (showProdType) {
        cols.push({field: 'prodType', title: '제품구분', width: 70, halign: 'center', align: 'center',
            formatter: function(value) { return formatCode('C011', value); }
        });
    }
    cols.push(
        {field: 'procName', title: '검사공정명', width: 100, halign: 'center', align: 'left'},
        {field: 'insName', title: '검사항목명', width: 120, halign: 'center', align: 'left'},
        {field: 'insDesc', title: '점검내역', width: 500, halign: 'center', align: 'left'},
        {field: 'insType', title: 'TYPE', width: 60, halign: 'center', align: 'center',
            formatter: function(value) { return formatCode('C053', value); }
        },
        {field: 'avgVal', title: '기준값', width: 70, halign: 'center', align: 'left'},
        {field: 'insUnit', title: '단위', width: 60, halign: 'center', align: 'center',
            formatter: function(value) { return formatCode('C054', value); }
        },
        {field: 'minVal', title: 'Min', width: 60, halign: 'center', align: 'right'},
        {field: 'maxVal', title: 'Max', width: 60, halign: 'center', align: 'right'},
        {field: 'insSeq', title: '순번', width: 50, halign: 'center', align: 'right'}
    );
    return cols;
}


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

    // EasyUI 파싱 완료 후 textbox Enter 키 바인딩
    $('#assy_partCode').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) doSearch();
    });
    $('#assy_searchLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) doSearch();
    });

    GridHeaderMenu('#assy-part-grid', { exportFileName: '자주검사연계_모델' });
    GridHeaderMenu('#assy-group-grid', { exportFileName: '자주검사연계_검사그룹' });
    GridHeaderMenu('#assy-detail-grid', { exportFileName: '자주검사연계_검사항목' });
    enableGridSortReset('#assy-part-grid');
    enableGridSortReset('#assy-group-grid');
    enableGridSortReset('#assy-detail-grid');
});


// ============================================================================
// 포맷터
// ============================================================================
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
// 데이터 로드 (내부 함수)
// ============================================================================
function _loadGroups(prefix, partCode) {
    var state = tabs[prefix];
    if (state.editIdx !== undefined) {
        $('#' + prefix + '-group-grid').datagrid('endEdit', state.editIdx);
        state.editIdx = undefined;
    }
    $.ajax({
        url: consts.url.QCT06A_SER5,
        type: 'GET',
        data: { partCode: partCode, plants: state.plants },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#' + prefix + '-group-grid').datagrid('loadData', rows);
        }
    });
}

function _loadDetail(prefix, insGrpCode) {
    $.ajax({
        url: consts.url.QCT06A_SER2,
        type: 'GET',
        data: { insGrpCode: insGrpCode },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#' + prefix + '-detail-grid').datagrid('loadData', rows);
        }
    });
}


// ============================================================================
// 조회
// ============================================================================
function doSearch() {
    if (activeTab === 'list') {
        doSearchList();
        return;
    }

    var state = T();
    if (state.editIdx !== undefined) {
        $(G('group-grid')).datagrid('endEdit', state.editIdx);
        state.editIdx = undefined;
    }
    state.partCode = '';
    state.grpCode = '';

    var partCode = $('#' + activeTab + '_partCode').textbox('getText') || '';
    var searchLike = $('#' + activeTab + '_searchLike').textbox('getText') || '';

    $(G('part-grid')).datagrid('options').url = consts.url.QCT06A_SER;
    $(G('part-grid')).datagrid('load', {
        partCode: partCode,
        searchLike: searchLike
    });
}

function doSearchList() {
    var partLike = $('#list_partLike').textbox('getText') || '';
    var groupLike = $('#list_groupLike').textbox('getText') || '';

    $('#list-grid').datagrid('options').url = consts.url.QCT06A_SER6;
    $('#list-grid').datagrid('load', {
        partLike: partLike,
        groupLike: groupLike
    });
}


// ============================================================================
// 순번 저장 (QCT06A_UPD)
// ============================================================================
function doSaveSeq() {
    var state = T();
    if (state.editIdx !== undefined) {
        $(G('group-grid')).datagrid('endEdit', state.editIdx);
        state.editIdx = undefined;
    }

    var allRows = $(G('group-grid')).datagrid('getRows');
    var saveRows = [];

    for (var i = 0; i < allRows.length; i++) {
        var row = allRows[i];
        if (row.insGrpCode && state.changed[row.insGrpCode]) {
            saveRows.push({
                partCode: state.partCode,
                insGrpCode: row.insGrpCode,
                insGrpSeq: row.insGrpSeq || 0
            });
        }
    }

    if (saveRows.length === 0) {
        $.messager.alert(getTitle('INFO'), getMessage('NO_CHANGED'), 'info');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_SAVE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.QCT06A_UPD,
                type: 'POST',
                data: { models: JSON.stringify(saveRows) },
                dataType: 'json',
                success: function(result) {
                    if (result.success !== undefined) {
                        $.messager.alert(getTitle('INFO'), getMessage('SAVED'), 'info');
                        state.changed = {};
                        if (state.partCode) {
                            _loadGroups(activeTab, state.partCode);
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
// 연계 삭제 (컨텍스트 메뉴)
// ============================================================================
function doDeleteGroup() {
    var state = T();
    if (!state.partCode) {
        $.messager.alert(getTitle('WARNING'), '부품을 선택하세요.', 'warning');
        return;
    }

    var selRow = $(G('group-grid')).datagrid('getSelected');
    if (!selRow || !selRow.insGrpCode) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), '선택 된 그룹을 삭제하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.QCT06A_DEL,
                type: 'POST',
                data: {
                    partCode: state.partCode,
                    insGrpCode: selRow.insGrpCode
                },
                dataType: 'json',
                success: function(result) {
                    if (result.success !== undefined) {
                        $.messager.alert(getTitle('INFO'), getMessage('DELETED'), 'info');
                        _loadGroups(activeTab, state.partCode);
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
// D0A 팝업: 검사그룹 추가
// ============================================================================
function doOpenD0a() {
    var state = T();
    if (!state.partCode) {
        $.messager.alert(getTitle('WARNING'), '부품을 선택하세요.', 'warning');
        return;
    }

    if (state.editIdx !== undefined) {
        $(G('group-grid')).datagrid('endEdit', state.editIdx);
        state.editIdx = undefined;
    }

    $('#d0a-popup').dialog('open').dialog('center');

    if (d0aInited) {
        // 대표코드/내역 표시
        var selPart = $(G('part-grid')).datagrid('getSelected');
        if (selPart) {
            $('#d0a_partCode').textbox('setValue', selPart.partCode || '');
            $('#d0a_partName').textbox('setValue', selPart.partName || '');
        }
        $('#d0a_searchLike').textbox('setValue', '');
        $('#d0a_grpName').textbox('setValue', '');
        $('#d0a-detail-grid').datagrid('loadData', []);
        _loadD0aGroupList();
    }
}

function initD0aPopup() {
    if (d0aInited) return;
    d0aInited = true;

    // 좌측: 검사그룹 목록 (체크박스)
    $('#d0a-group-grid').datagrid({
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: false,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'insGrpCode',
        checkOnSelect: false,
        selectOnCheck: false,
        columns: [[
            {field: 'ck', checkbox: true},
            {field: 'insGrpCode', hidden: true},
            {field: 'insGrpName', title: '검사그룹명', width: 180, halign: 'center', align: 'left'},
            {field: 'scomment', title: '비고', width: 120, halign: 'center', align: 'left'}
        ]],
        onClickRow: function(index, row) {
            // 선택 하이라이트: 이전 선택 해제 후 현재만 선택 (체크는 유지)
            $('#d0a-group-grid').datagrid('unselectAll');
            $('#d0a-group-grid').datagrid('selectRow', index);
            if (row.insGrpCode) {
                $('#d0a_grpName').textbox('setValue', row.insGrpName || '');
                _loadD0aDetail(row.insGrpCode);
            }
        }
    });

    // 우측: 검사항목 상세 (D0A에서는 제품구분 포함)
    var d0aDetailCols = buildDetailGridColumns(true);
    $('#d0a-detail-grid').datagrid({
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'insCode',
        columns: [d0aDetailCols]
    });

    // 검색 버튼
    $('#d0a-search-button').bind('click', _loadD0aGroupList);

    // 선택 버튼 (D0A 내부 상단, href 로딩 후 바인딩)
    $('#d0a-select-button').bind('click', d0aSelect);

    // 검색어 Enter 키
    $('#d0a_searchLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) _loadD0aGroupList();
    });

    // 대표코드/내역 표시
    var selPart = $(G('part-grid')).datagrid('getSelected');
    if (selPart) {
        $('#d0a_partCode').textbox('setValue', selPart.partCode || '');
        $('#d0a_partName').textbox('setValue', selPart.partName || '');
    }

    _loadD0aGroupList();
}

function _loadD0aGroupList() {
    var state = T();
    var searchLike = '';
    var $sl = $('#d0a_searchLike');
    if ($sl.length > 0) {
        searchLike = $sl.textbox('getText') || '';
    }

    $.ajax({
        url: consts.url.QCT06A_SER3,
        type: 'GET',
        data: { plants: state.plants, searchLike: searchLike },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#d0a-group-grid').datagrid('loadData', rows);
            $('#d0a-detail-grid').datagrid('loadData', []);
            $('#d0a_grpName').textbox('setValue', '');
            // 첫 번째 행 자동 선택 + 우측 상세 로드
            if (rows.length > 0) {
                $('#d0a-group-grid').datagrid('selectRow', 0);
                var firstRow = rows[0];
                if (firstRow.insGrpCode) {
                    $('#d0a_grpName').textbox('setValue', firstRow.insGrpName || '');
                    _loadD0aDetail(firstRow.insGrpCode);
                }
            }
        }
    });
}

function _loadD0aDetail(insGrpCode) {
    $.ajax({
        url: consts.url.QCT06A_SER2,
        type: 'GET',
        data: { insGrpCode: insGrpCode },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#d0a-detail-grid').datagrid('loadData', rows);
        }
    });
}

function d0aSelect() {
    var state = T();
    // 체크된 행 우선, 없으면 선택(포커스) 행 사용
    var checked = $('#d0a-group-grid').datagrid('getChecked');
    var selected = $('#d0a-group-grid').datagrid('getSelected');
    var rows = [];
    if (checked.length > 0) {
        rows = checked;
    } else if (selected) {
        rows = [selected];
    }
    if (rows.length === 0) {
        $.messager.alert(getTitle('WARNING'), '연계할 검사그룹을 선택하세요.', 'warning');
        return;
    }

    // confirm 후 INS 실행
    $.messager.confirm(getTitle('CONFIRM'), '선택된 그룹을 연계하시겠습니까?', function(r) {
        if (!r) return;

        var models = [];
        for (var i = 0; i < rows.length; i++) {
            models.push({
                partCode: state.partCode,
                insGrpCode: rows[i].insGrpCode,
                insGrpName: rows[i].insGrpName || ''
            });
        }

        $.ajax({
            url: consts.url.QCT06A_INS,
            type: 'POST',
            data: { models: JSON.stringify(models) },
            dataType: 'json',
            success: function(result) {
                if (result.success !== undefined) {
                    $('#d0a-popup').dialog('close');
                    $.messager.show({
                        title: '알림',
                        msg: getMessage('SAVED'),
                        showType: 'slide',
                        timeout: 2000,
                        style: { right: '', bottom: '' }
                    });
                    _loadGroups(activeTab, state.partCode);
                } else {
                    $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
                }
            },
            error: function() {
            }
        });
    });
}


// ============================================================================
// 유틸리티
// ============================================================================
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

function getTitle(key) {
    if (typeof tit !== 'undefined') {
        if (key === 'ALERT') return tit.TITLE0001 || '알림';
        if (key === 'INFO') return (typeof msg !== 'undefined' && msg.MSG0052) || '정보';
        if (key === 'WARNING') return (typeof msg !== 'undefined' && msg.MSG0051) || '경고';
        if (key === 'ERROR') return (typeof msg !== 'undefined' && msg.MSG0068) || '오류';
        if (key === 'CONFIRM') return (typeof msg !== 'undefined' && msg.MSG0053) || '확인';
    }
    if (key === 'ALERT') return '알림';
    if (key === 'INFO') return '정보';
    if (key === 'WARNING') return '경고';
    if (key === 'ERROR') return '오류';
    if (key === 'CONFIRM') return '확인';
    return key;
}

function getMessage(key) {
    if (typeof msg !== 'undefined') {
        if (key === 'SAVED') return msg.MSG0021 || '저장되었습니다.';
        if (key === 'DELETED') return msg.MSG0054 || '삭제되었습니다.';
        if (key === 'NO_CHANGED') return msg.MSG0022 || '변경된 데이터가 없습니다.';
        if (key === 'SELECT_DELETE') return msg.MSG0016 || '삭제할 항목을 선택하세요.';
        if (key === 'CONFIRM_SAVE') return msg.MSG0036 || '저장하시겠습니까?';
        if (key === 'CONFIRM_DELETE') return msg.MSG0030 || '삭제하시겠습니까?';
    }
    if (key === 'SAVED') return '저장되었습니다.';
    if (key === 'DELETED') return '삭제되었습니다.';
    if (key === 'NO_CHANGED') return '변경된 데이터가 없습니다.';
    if (key === 'SELECT_DELETE') return '삭제할 항목을 선택하세요.';
    if (key === 'CONFIRM_SAVE') return '저장하시겠습니까?';
    if (key === 'CONFIRM_DELETE') return '삭제하시겠습니까?';
    return key;
}
