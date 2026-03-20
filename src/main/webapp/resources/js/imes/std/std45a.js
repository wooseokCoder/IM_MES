/**
 * ============================================================================
 * 화면명: STD45A - 비가동코드 관리
 * ============================================================================
 * 설명: 비가동코드 목록 조회, 등록, 수정, 삭제
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 공통 사용
 * 원본: ProActive STD45A_M0A.cs, STD45A_D0A.cs
 * 작성일: 2026-02-05
 * ============================================================================
 */

// ============================================================================
// editCell 확장 (셀 단위 편집용, ord06a 패턴)
// ============================================================================
$.extend($.fn.datagrid.methods, {
    editCell: function(jq, param) {
        return jq.each(function() {
            var fields = $(this).datagrid('getColumnFields', true)
                         .concat($(this).datagrid('getColumnFields'));
            for (var i = 0; i < fields.length; i++) {
                var col = $(this).datagrid('getColumnOption', fields[i]);
                col._editor = col.editor;
                if (fields[i] !== param.field) {
                    col.editor = null;
                }
            }
            $(this).datagrid('beginEdit', param.index);
            for (var i = 0; i < fields.length; i++) {
                var col = $(this).datagrid('getColumnOption', fields[i]);
                col.editor = col._editor;
            }
        });
    }
});

// ============================================================================
// 전역 변수
// ============================================================================
var changedRows = [];  // 그리드에서 수정된 행 추적
var editIndex = undefined;  // 현재 편집 중인 행 인덱스
var editField = undefined;  // 현재 편집 중인 필드명
var checkFields = ['isNg', 'isSap', 'isRpt', 'isMctScomment'];  // 체크박스 컬럼 목록
var codeDataMap = {};  // 코드 데이터 캐시 (그리드 콤보박스용)
var dialogMode = '';   // 다이얼로그 모드: 'NEW' 또는 'EDIT' (AS-IS: emDialogMode)

// ============================================================================
// consts (user2.js 패턴)
// ============================================================================
var consts = {
    url: {
        STD45A_SER: getUrl('/imes/std/std45a/STD45A_SER.json'),
        STD45A_INS: getUrl('/imes/std/std45a/STD45A_INS.json'),
        STD45A_UPD: getUrl('/imes/std/std45a/STD45A_UPD.json'),
        STD45A_DEL: getUrl('/imes/std/std45a/STD45A_DEL.json'),
        CODE_LIST: getUrl('/common/code/code.json')
    },

    // 코드 데이터 동기 로드 (user2.js jcombobox 패턴: async:false)
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

    // 전체 초기화 (user2.js consts.init() 패턴)
    init: function() {
        // --- 코드 데이터 로드 (동기) → consts.codeData에 저장 (JSP data-options에서 참조) ---
        consts.codeData = {};
        consts.codeData.S901 = this.loadCode('S901');
        consts.codeData.S902 = this.loadCode('S902');
        consts.codeData.S900 = this.loadCode('S900');
        consts.codeData.W004 = this.loadCode('W004');

        // --- 다이얼로그 콤보박스 설정 ---
        $('#f_mgType1').combobox({ data: consts.codeData.S901, valueField: 'codeCd', textField: 'codeName', panelHeight: 'auto' });
        $('#f_mgType2').combobox({ data: consts.codeData.S902, valueField: 'codeCd', textField: 'codeName', panelHeight: 'auto' });
        $('#f_useFlag').combobox({ data: consts.codeData.S900, valueField: 'codeCd', textField: 'codeName', panelHeight: 'auto' });
        $('#f_useFlag').combobox('setValue', '1');
        $('#f_alarmType').combobox({ data: consts.codeData.W004, valueField: 'codeCd', textField: 'codeName', panelHeight: 'auto' });

        // --- 그리드 초기화 (컬럼은 JSP <thead>에서 정의, data_item으로 다국어 지원) ---

        // checkbox 에디터 확장 (AS-IS: DevExpress CheckEdit)
        $.extend($.fn.datagrid.defaults.editors, {
            checkbox: {
                init: function(container, options) {
                    var input = $('<input type="checkbox">').appendTo(container);
                    if (options.on) input.data('on', options.on);
                    if (options.off) input.data('off', options.off);
                    return input;
                },
                getValue: function(target) {
                    return $(target).is(':checked') ? ($(target).data('on') || '1') : ($(target).data('off') || '0');
                },
                setValue: function(target, value) {
                    $(target).prop('checked', value === ($(target).data('on') || '1'));
                },
                resize: function(target, width) {}
            }
        });

        // 그리드 생성
        $('#search-grid').datagrid({
            url: this.url.STD45A_SER,
            method: 'post',
            fit: true,
            fitColumns: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'scode',
            toolbar: '#search-toolbar',
            onLoadSuccess: function(data) {
                editIndex = undefined;
                editField = undefined;
                changedRows = [];
                $('#search-grid').datagrid('unselectAll');
                $('#search-grid').datagrid('clearSelections');
            },
            onClickCell: function(index, field, value) {
                // 체크박스: onclick으로 직접 처리
                if (checkFields.indexOf(field) >= 0) {
                    return;
                }
                // 편집 가능 컬럼만 셀 편집
                var col = $('#search-grid').datagrid('getColumnOption', field);
                if (!col || !col.editor) return;

                if (editIndex !== index || editField !== field) {
                    if (endEditing()) {
                        $('#search-grid').datagrid('selectRow', index);
                        $('#search-grid').datagrid('editCell', { index: index, field: field });
                        editIndex = index;
                        editField = field;

                        var ed = $('#search-grid').datagrid('getEditor', { index: index, field: field });
                        if (ed) {
                            ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
                        }
                    }
                }
            },
            onDblClickRow: function(index, row) {
                endEditing();
                doOpenEdit(row);
            },
            onEndEdit: function(index, row, changes) {
                editIndex = undefined;
                editField = undefined;
                if (changes && Object.keys(changes).length > 0) {
                    markRowChanged(row);
                }
                $('#search-grid').datagrid('refreshRow', index);
            }
        });

        // 가공 화면이 아니면 isMctScomment 컬럼 숨김 (JSP에 항상 포함, JS에서 동적 제어)
        if (!PAGE_SHOW_MCT_SCOMMENT) {
            $('#search-grid').datagrid('hideColumn', 'isMctScomment');
        }

        // --- 다이얼로그 초기화 ---
        $('#edit-dialog').dialog({
            title: '비가동코드 등록',
            closed: true,
            modal: true,
            onOpen: function() {
            	$(this).css('visibility', '');
                $('#edit-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
            }
        });

        // 가공 화면이 아니면 상세원인등록 행 숨김
        if (typeof PAGE_SHOW_MCT_SCOMMENT !== 'undefined' && !PAGE_SHOW_MCT_SCOMMENT) {
            $('#mct-scomment-row').hide();
        }

        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#new-button').bind('click', doOpenNew);
        $('#save-button').bind('click', doSaveGrid);
        $('#delete-button').bind('click', doDelete);

        $('#dialog-clear-button').bind('click', doClearDialog);
        $('#dialog-save-button').bind('click', function() { doSaveDialog(false); });
        $('#dialog-save-close-button').bind('click', function() { doSaveDialog(false); });
        $('#dialog-delete-button').bind('click', doDeleteFromDialog);
        $('#dialog-cancel-button').bind('click', function() { $('#edit-dialog').dialog('close'); });

        $('#org-search-btn').bind('click', function() {
            acORGForm.open();
        });
    }
};


// ============================================================================
// 화면 초기화 (user2.js 패턴: 단일 $(function))
// ============================================================================
$(function() {
    consts.init();
    acORGForm.init({
        onSelect: function(row) {
            $('#f_mgOrg').val(row.orgCode);
            $('#f_mgOrgName').textbox('setValue', row.orgName);
        }
    });
});

// EasyUI 자동 파싱 완료 후 실행 (HTML의 easyui-textbox 등 초기화 대기)
$(window).load(function() {
    hideLoadingBar();
    GridHeaderMenu('#search-grid', { exportFileName: '비가동코드관리' });
    enableGridSortReset('#search-grid');

    // 검색 조건 Enter 키 (EasyUI textbox 초기화 후)
    $('#s_idleLike').textbox('textbox').bind('keyup', function(e) {
        $('#s_idleLike').textbox('setValue', $(this).val());
    });
    $('#s_idleLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_idleLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });

    // 입력 길이 제한 (DB 컬럼 길이)
    $('#s_idleLike').textbox('textbox').attr('maxlength', 100);       // VARCHAR(100)
    $('#f_idleCode').textbox('textbox').attr('maxlength', 20);        // VARCHAR(20)
    $('#f_idleName').textbox('textbox').attr('maxlength', 100);       // VARCHAR(100)
    $('#f_sapCode').textbox('textbox').attr('maxlength', 20);         // VARCHAR(20)
    $('#f_scomment').textbox('textbox').attr('maxlength', 500);       // VARCHAR(500)
    $('#f_idleSeq').numberbox('textbox').attr('maxlength', 10);       // INT → 최대 10자리

    doSearch();
});

// ============================================================================
// 포맷터 함수
// ============================================================================

/**
 * 셀 편집 종료 (ord06a endEditing 패턴)
 */
function endEditing() {
    if (editIndex === undefined) return true;
    if ($('#search-grid').datagrid('validateRow', editIndex)) {
        $('#search-grid').datagrid('endEdit', editIndex);
        editIndex = undefined;
        editField = undefined;
        return true;
    }
    return false;
}

/**
 * 편집 가능 셀 배경색 (ord06a editableCellStyler 패턴)
 */
function editableCellStyler(value, row, index) {
    return 'background-color:#FFFFCC;';
}

/**
 * 체크박스 포맷터 (AS-IS: DevExpress CheckEdit)
 */
function formatCheck(value, row, index) {
    if (value == '1' || value == 'Y') {
        return '<input type="checkbox" checked/>';
    }
    return '<input type="checkbox" />';
}

/**
 * 체크박스 포맷터 - 원클릭 토글 (ord06a formatSelCheckbox 패턴)
 */
function formatCheckClick(field, value, row, index) {
    var checked = (value == '1' || value == 'Y') ? 'checked="checked"' : '';
    return '<input type="checkbox" ' + checked + ' onclick="toggleCheck(' + index + ',\'' + field + '\', this)" />';
}

/**
 * 체크박스 토글 (ord06a toggleSel 패턴)
 */
function toggleCheck(index, field, checkbox) {
    var rows = $('#search-grid').datagrid('getRows');
    rows[index][field] = checkbox.checked ? '1' : '0';
    markRowChanged(rows[index]);
}

/**
 * 코드값 유효성 검사 — 콤보 데이터에 있으면 값 반환, 없으면 '' (다이얼로그용)
 */
function getValidCode(codeGrup, value) {
    if (!value) return '';
    if (codeDataMap[codeGrup]) {
        for (var i = 0; i < codeDataMap[codeGrup].length; i++) {
            if (codeDataMap[codeGrup][i].codeCd === value) {
                return value;
            }
        }
    }
    return '';
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
        value = '';
    }
    return value;
}

/**
 * 행 변경 표시
 */
function markRowChanged(row) {
    if (!row.scode) return;
    var exists = false;
    for (var i = 0; i < changedRows.length; i++) {
        if (changedRows[i].scode === row.scode) {
            changedRows[i] = row;
            exists = true;
            break;
        }
    }
    if (!exists) {
        changedRows.push(row);
    }
}

// ============================================================================
// 조회 (STD45A_SER)
// ============================================================================
function doSearch() {
    endEditing();
    var params = {
        plants: PAGE_PLANTS,
        idleLike: $('#s_idleLike').textbox('getValue')
    };
    $('#search-grid').datagrid('load', params);
}

// ============================================================================
// 다이얼로그 모드 전환 (AS-IS: BaseMenuDialog.emDialogMode)
// ============================================================================
function setDialogMode(mode) {
    dialogMode = mode;
    if (mode === 'NEW') {
        $('.dialog-new-btn').show();
        $('.dialog-edit-btn').hide();
        $('#f_idleCode').textbox('readonly', false);
    } else {
        $('.dialog-new-btn').hide();
        $('.dialog-edit-btn').show();
        $('#f_idleCode').textbox('readonly', true);
    }
}

// ============================================================================
// 신규 다이얼로그 열기 (AS-IS: DialogMode=NEW)
// ============================================================================
function doOpenNew() {
    clearDialogFields();
    setDialogMode('NEW');
    $('#edit-dialog').dialog('setTitle', '비가동코드 등록');
    $('#edit-dialog').dialog('open');
}

// ============================================================================
// 편집 다이얼로그 열기 (AS-IS: DialogMode=OPEN, 더블클릭)
// ============================================================================
function doOpenEdit(row) {
    clearDialogFields();
    loadDialogFields(row);
    setDialogMode('EDIT');
    $('#edit-dialog').dialog('setTitle', '비가동코드 수정');
    $('#edit-dialog').dialog('open');
}

/**
 * 다이얼로그 필드 초기화 (AS-IS: 사용여부 기본값 '1')
 */
function clearDialogFields() {
    $('#f_scode').val('');
    $('#f_idleCode').textbox('setValue', '');
    $('#f_idleName').textbox('setValue', '');
    $('#f_mgType1').combobox('setValue', '');
    $('#f_mgType2').combobox('setValue', '');
    $('#f_sapCode').textbox('setValue', '');
    $('#f_idleSeq').numberbox('setValue', 0);
    $('#f_mgOrg').val('');
    $('#f_mgOrgName').textbox('setValue', '');
    $('#f_useFlag').combobox('setValue', '1');
    $('#f_isNg').prop('checked', false);
    $('#f_alarmType').combobox('setValue', '');
    $('#f_isSap').prop('checked', false);
    $('#f_isRpt').prop('checked', false);
    $('#f_isMctScomment').prop('checked', false);
    $('#f_scomment').textbox('setValue', '');
}

/**
 * 다이얼로그 필드 로드 (수정 시, AS-IS: 체크박스 값 '1'/'0')
 */
function loadDialogFields(row) {
    $('#f_scode').val(row.scode || '');
    $('#f_idleCode').textbox('setValue', row.idleCode || '');
    $('#f_idleName').textbox('setValue', row.idleName || '');
    $('#f_mgType1').combobox('setValue', getValidCode('S901', row.mgType1));
    $('#f_mgType2').combobox('setValue', getValidCode('S902', row.mgType2));
    $('#f_sapCode').textbox('setValue', row.sapCode || '');
    $('#f_idleSeq').numberbox('setValue', row.idleSeq || 0);
    $('#f_mgOrg').val(row.mgOrg || '');
    $('#f_mgOrgName').textbox('setValue', row.mgOrgName || '');
    $('#f_useFlag').combobox('setValue', row.useFlag || '1');
    $('#f_isNg').prop('checked', row.isNg === '1');
    $('#f_alarmType').combobox('setValue', row.alarmType || '');
    $('#f_isSap').prop('checked', row.isSap === '1');
    $('#f_isRpt').prop('checked', row.isRpt === '1');
    $('#f_isMctScomment').prop('checked', row.isMctScomment === '1');
    $('#f_scomment').textbox('setValue', row.scomment || '');
}

/**
 * 다이얼로그 필드 검증
 */
function validateDialogFields() {
    var idleCode = $('#f_idleCode').textbox('getValue');
    var idleName = $('#f_idleName').textbox('getValue');
    var sapCode = $('#f_sapCode').textbox('getValue');

    if (!idleCode || idleCode.trim() === '') {
        $.messager.alert(getTitle('ALERT'), 'MES코드를 입력하세요.', 'warning');
        $('#f_idleCode').textbox('textbox').focus();
        return false;
    }
    if (!idleName || idleName.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '비가동명을 입력하세요.', 'warning');
        $('#f_idleName').textbox('textbox').focus();
        return false;
    }
    if (!sapCode || sapCode.trim() === '') {
        $.messager.alert(getTitle('ALERT'), 'SAP코드를 입력하세요.', 'warning');
        $('#f_sapCode').textbox('textbox').focus();
        return false;
    }
    return true;
}

/**
 * 다이얼로그 파라미터 수집 (AS-IS: 체크박스 '1'/'0')
 */
function getDialogParams() {
    return {
        scode: $('#f_scode').val(),
        plants: PAGE_PLANTS,
        idleCode: $('#f_idleCode').textbox('getValue'),
        idleName: $('#f_idleName').textbox('getValue'),
        mgType1: $('#f_mgType1').combobox('getValue'),
        mgType2: $('#f_mgType2').combobox('getValue'),
        sapCode: $('#f_sapCode').textbox('getValue'),
        idleSeq: $('#f_idleSeq').numberbox('getValue') || 0,
        mgOrg: $('#f_mgOrg').val(),
        useFlag: $('#f_useFlag').combobox('getValue') || '1',
        isNg: $('#f_isNg').is(':checked') ? '1' : '0',
        alarmType: $('#f_alarmType').combobox('getValue'),
        isSap: $('#f_isSap').is(':checked') ? '1' : '0',
        isRpt: $('#f_isRpt').is(':checked') ? '1' : '0',
        isMctScomment: $('#f_isMctScomment').is(':checked') ? '1' : '0',
        scomment: $('#f_scomment').textbox('getValue')
    };
}

// ============================================================================
// 초기화 - 다이얼로그 (AS-IS: barItemClear)
// ============================================================================
function doClearDialog() {
    clearDialogFields();
}

// ============================================================================
// 저장 - 다이얼로그 (STD45A_INS)
// OVERWRITE 처리: 중복(DUPLICATE)/삭제(DELETED) 에러 시 확인 후 재시도
// ============================================================================
function doSaveDialog(overwrite) {
    if (!validateDialogFields()) return;

    var params = getDialogParams();
    if (overwrite) params.overwrite = '1';

    $.ajax({
        url: consts.url.STD45A_INS,
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
// 삭제 - 다이얼로그 (AS-IS: barItemDel)
// ============================================================================
function doDeleteFromDialog() {
    var scode = $('#f_scode').val();
    if (!scode) return;

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_DELETE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.STD45A_DEL,
                type: 'POST',
                data: { scode: scode },
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
// 저장 - 그리드 일괄 (STD45A_UPD, models 패턴)
// ============================================================================
function doSaveGrid() {
    endEditing();

    var changes = $('#search-grid').datagrid('getChanges');
    if (changes.length === 0 && changedRows.length === 0) {
        $.messager.alert(getTitle('INFO'), getMessage('NO_CHANGED'), 'info');
        return;
    }

    var rows = [];
    var allChanges = changedRows.concat(changes);
    var scodeMap = {};
    for (var i = 0; i < allChanges.length; i++) {
        var row = allChanges[i];
        if (row.scode && !scodeMap[row.scode]) {
            scodeMap[row.scode] = true;
            rows.push({
                scode: row.scode,
                useFlag: row.useFlag,
                idleSeq: row.idleSeq,
                isNg: row.isNg,
                isSap: row.isSap,
                isRpt: row.isRpt,
                isMctScomment: row.isMctScomment
            });
        }
    }

    if (rows.length === 0) {
        $.messager.alert(getTitle('INFO'), getMessage('NO_CHANGED'), 'info');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_SAVE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.STD45A_UPD,
                type: 'POST',
                data: {models: JSON.stringify(rows)},
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
                        changedRows = [];
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
    });
}

// ============================================================================
// 삭제 (STD45A_DEL) - 그리드 선택 행
// ============================================================================
function doDelete() {
    var row = $('#search-grid').datagrid('getSelected');
    if (!row) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_DELETE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.STD45A_DEL,
                type: 'POST',
                data: {scode: row.scode},
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
