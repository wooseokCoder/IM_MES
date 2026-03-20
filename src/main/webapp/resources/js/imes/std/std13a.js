/**
 * ============================================================================
 * 화면명: STD13A - 부서/사원 관리
 * ============================================================================
 * 설명: 부서 트리 조회, 사원 목록 조회(읽기전용), 부서 CRUD
 *       좌: treegrid (부서), 우: datagrid (사원, 읽기전용)
 * 원본: ProActive STD13A_M0A.cs, STD13A_D0A.cs
 * 작성일: 2026-02-11
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var dialogMode = '';           // 다이얼로그 모드: 'NEW' 또는 'EDIT'
var selectedOrgCode = '';      // 현재 선택된 부서코드

// ============================================================================
// 코드 → 명칭 변환 formatter (AS-IS AddLookUpEdit 대응)
// ============================================================================
function codeFormatter(codeGrup) {
    return function(value, row, index) {
        if (!value && value !== 0) return '';
        var items = codeDataMap[codeGrup] || [];
        for (var i = 0; i < items.length; i++) {
            if (items[i].codeCd == value) return items[i].codeName;
        }
        return value;
    };
}

// ============================================================================
// consts
// ============================================================================
var codeDataMap = {};  // 코드 데이터 캐시

var consts = {
    url: {
        STD13A_SER:  getUrl('/imes/std/std13a/STD13A_SER.json'),
        STD13A_SER2: getUrl('/imes/std/std13a/STD13A_SER2.json'),
        STD13A_INS:  getUrl('/imes/std/std13a/STD13A_INS.json'),
        STD13A_DEL:  getUrl('/imes/std/std13a/STD13A_DEL.json'),
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

        // --- 코드 데이터 로드 (AS-IS AddLookUpEdit 대응) ---
        var codeS100 = this.loadCode('S100');  // 코스트센터
        this.loadCode('S021');  // 사원형태 (EMP_TYPE)
        this.loadCode('C040');  // 직책 (EMP_TITLE)
        this.loadCode('S028');  // 사원구분 (EMP_GUBUN)

        // --- 코스트센터 combobox (AS-IS: acLookupEdit SetCode("S100")) ---
        $('#f_costCenter').combobox({
            data: codeS100,
            valueField: 'codeCd',
            textField: 'codeName',
            panelHeight: 'auto',
            editable: false
        });

        // --- 부서 treegrid 초기화 ---
        $('#org-tree').treegrid({
            method: 'post',
            fit: true,
            fitColumns: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: false,
            nowrap: true,
            idField: 'orgCode',
            treeField: 'orgName',
            onClickRow: function(row) {
                onOrgSelect(row);
            },
            onDblClickRow: function(row) {
                // "전체" 노드는 더블클릭 수정 불가
                if (row && row.orgCode && row.orgCode !== '_ALL_') {
                    doOpenEdit(row);
                }
            },
            onContextMenu: function(e, row) {
                /*e.preventDefault();
                if (row && row.orgCode && row.orgCode !== '_ALL_') {
                    $(this).treegrid('select', row.orgCode);
                    onOrgSelect(row);
                    $('#org-context-menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                }*/
            }
        });
        
        GridHeaderMenu('#org-tree', { type: 'treegrid', exportFileName: '부서목록' });

        // --- 사원 datagrid 초기화 (읽기전용) ---
        $('#emp-grid').datagrid({
            fit: true,
            fitColumns: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true
        });

        // --- 사원 그리드 헤더 컨텍스트 메뉴 ---
        GridHeaderMenu('#emp-grid', { exportFileName: '사원목록' });
        enableGridSortReset('#emp-grid');

        // --- 다이얼로그 초기화 ---
        $('#edit-dialog').dialog({
            title: '부서 편집',
            closed: true,
            modal: true,
            onOpen: function() {
            	$(this).css('visibility', '');
                $('#edit-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
            }
        });

        // --- 컨텍스트 메뉴 초기화 ---
        initContextMenu();

        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#new-button').bind('click', doOpenNew);
        $('#delete-button').bind('click', doDelete);

        // 다이얼로그 버튼
        $('#dialog-clear-button').bind('click', doClearDialog);
        $('#dialog-save-button').bind('click', function() { doSaveDialog(false); });
        $('#dialog-save-close-button').bind('click', function() { doSaveCloseDialog(false); });
        $('#dialog-delete-button').bind('click', doDeleteFromDialog);

        // 상위부서 검색 버튼
        $('#org-parent-search-btn').bind('click', function() {
            acORGForm.open();
        });
    }
};


// ============================================================================
// 화면 초기화
// ============================================================================
$(function() {
    consts.init();
    acORGForm.init({
        onSelect: function(row) {
            $('#f_orgParent').val(row.orgCode);
            $('#f_orgParentName').textbox('setValue', row.orgName);
        }
    });
});

$(window).load(function() {
    hideLoadingBar();

    // 검색 조건 Enter 키
    $('#s_empLike').textbox('textbox').bind('keyup', function(e) {
        $('#s_empLike').textbox('setValue', $(this).val());
    });
    $('#s_empLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_empLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });

    // 입력 길이 제한 (TSTD_ORG 테이블 컬럼 길이)
    $('#s_empLike').textbox('textbox').attr('maxlength', 30);        // ORG_NAME VARCHAR(30) 기준
    $('#f_orgCode').textbox('textbox').attr('maxlength', 20);        // VARCHAR(20)
    $('#f_orgName').textbox('textbox').attr('maxlength', 30);        // VARCHAR(30)
    $('#f_orgSeq').numberbox('textbox').attr('maxlength', 10);       // INT → 최대 10자리

    doSearch();
});

// ============================================================================
// 컨텍스트 메뉴 초기화
// ============================================================================
function initContextMenu() {
    // 컨텍스트 메뉴 DOM 생성
    var menuHtml = '<div id="org-context-menu" class="easyui-menu" style="width:120px">';
    menuHtml += '<div data-options="iconCls:\'icon-add\'" onclick="doOpenNew()">부서 신규</div>';
    menuHtml += '<div data-options="iconCls:\'icon-edit\'" onclick="doOpenEditSelected()">부서 수정</div>';
    menuHtml += '<div class="menu-sep"></div>';
    menuHtml += '<div data-options="iconCls:\'icon-remove\'" onclick="doDelete()">부서 삭제</div>';
    menuHtml += '</div>';
    $('body').append(menuHtml);
    $.parser.parse($('#org-context-menu').parent());
}

// ============================================================================
// 조회 (STD13A_SER) - 부서 트리
// ============================================================================
function doSearch() {
    var params = {
        empLike: $('#s_empLike').textbox('getValue')
    };

    $.ajax({
        url: consts.url.STD13A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            var treeData = convertTreeData(rows);
            $('#org-tree').treegrid('loadData', treeData);

            // 전체 노드 확장
            $('#org-tree').treegrid('expandAll');

            // "전체" 노드 선택 → 전체 사원 표시
            if (treeData.length > 0) {
                $('#org-tree').treegrid('select', '_ALL_');
                onOrgSelect({ orgCode: '' });
            } else {
                selectedOrgCode = '';
                $('#emp-grid').datagrid('loadData', []);
            }
        },
        error: function() {
            $.messager.alert(getTitle('ERROR'), '부서 조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 부서 선택 → 사원 목록 조회 (STD13A_SER2)
// ============================================================================
function onOrgSelect(row) {
    if (!row) {
        selectedOrgCode = '';
        $('#emp-grid').datagrid('loadData', []);
        return;
    }

    // _ALL_ 노드(전체) → orgCode를 비워서 전체 사원 조회
    selectedOrgCode = (row.orgCode && row.orgCode !== '_ALL_') ? row.orgCode : '';

    var params = { empLike: $('#s_empLike').textbox('getValue') };
    if (selectedOrgCode) {
        params.orgCode = selectedOrgCode;
    }

    $.ajax({
        url: consts.url.STD13A_SER2,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#emp-grid').datagrid('loadData', rows);
        }
    });
}

// ============================================================================
// Treegrid 데이터 변환
// orgParent → _parentId 매핑 (EasyUI treegrid용)
// ============================================================================
function convertTreeData(rows) {
    // AS-IS QuickSearch 로직:
    // 1. "전체" 루트 노드 추가 (ORG_CODE=_ALL_, ORG_NAME="전체")
    // 2. 최상위 노드(orgParent 없음)는 "전체"의 하위로 설정
    // 3. children 계층 구조로 변환 (EasyUI treegrid loadData용)

    var allNode = { orgCode: '_ALL_', orgName: '전체', state: 'open', children: [] };

    // orgCode → node 매핑
    var map = {};
    map['_ALL_'] = allNode;
    $.each(rows, function(i, row) {
        row.children = [];
        row.state = 'open';
        map[row.orgCode] = row;
    });

    // 부모-자식 관계 구성
    $.each(rows, function(i, row) {
        var parentId = row.orgParent;
        if (!parentId || parentId === '' || !map[parentId]) {
            // 최상위 부서 → "전체"의 하위
            allNode.children.push(row);
        } else {
            // 상위부서가 있음 → 해당 부서의 하위
            map[parentId].children.push(row);
        }
    });

    return [allNode];
}

// ============================================================================
// 다이얼로그 모드 전환
// ============================================================================
function setDialogMode(mode) {
    dialogMode = mode;
    if (mode === 'NEW') {
        $('.dialog-new-btn').show();
        $('.dialog-edit-btn').hide();
        // 부서코드 입력 가능
        $('#f_orgCode').textbox('readonly', false);
    } else {
        $('.dialog-new-btn').hide();
        $('.dialog-edit-btn').show();
        // 부서코드 수정 불가
        $('#f_orgCode').textbox('readonly', true);
    }
}

// ============================================================================
// 신규 다이얼로그 열기
// ============================================================================
function doOpenNew() {
    clearDialogFields();
    setDialogMode('NEW');
    $('#edit-dialog').dialog('setTitle', '부서 편집 - 등록');
    $('#edit-dialog').dialog('open');
}

// ============================================================================
// 편집 다이얼로그 열기
// ============================================================================
function doOpenEdit(row) {
    clearDialogFields();
    loadDialogFields(row);
    setDialogMode('EDIT');
    $('#edit-dialog').dialog('setTitle', '부서 편집 - 수정');
    $('#edit-dialog').dialog('open');
}

/**
 * 컨텍스트 메뉴에서 수정 선택 시
 */
function doOpenEditSelected() {
    var row = $('#org-tree').treegrid('getSelected');
    if (row && row.orgCode && row.orgCode !== '_ALL_') {
        doOpenEdit(row);
    }
}

// ============================================================================
// 다이얼로그 필드 관리
// ============================================================================
function clearDialogFields() {
    $('#f_orgCode').textbox('setValue', '');
    $('#f_orgName').textbox('setValue', '');
    $('#f_orgParent').val('');
    $('#f_orgParentName').textbox('setValue', '');
    $('#f_orgLeader').textbox('setValue', '');
    $('#f_orgSeq').numberbox('setValue', 0);
    $('#f_costCenter').combobox('setValue', '');
}

function loadDialogFields(row) {
    $('#f_orgCode').textbox('setValue', row.orgCode || '');
    $('#f_orgName').textbox('setValue', row.orgName || '');
    $('#f_orgParent').val(row.orgParent || '');
    // 상위부서명: treegrid에서 찾아서 표시
    var parentName = '';
    if (row.orgParent) {
        var parentNode = $('#org-tree').treegrid('find', row.orgParent);
        if (parentNode) parentName = parentNode.orgName;
    }
    $('#f_orgParentName').textbox('setValue', parentName);
    $('#f_orgLeader').textbox('setValue', row.orgLeader || '');
    $('#f_orgSeq').numberbox('setValue', row.orgSeq || 0);
    $('#f_costCenter').combobox('setValue', row.costCenter || '');
}

function validateDialogFields() {
    var orgCode = $('#f_orgCode').textbox('getValue');
    if (!orgCode || orgCode.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '부서코드를 입력하세요.', 'warning');
        return false;
    }
    var orgName = $('#f_orgName').textbox('getValue');
    if (!orgName || orgName.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '부서명을 입력하세요.', 'warning');
        return false;
    }
    return true;
}

// ============================================================================
// 초기화 - 다이얼로그
// ============================================================================
function doClearDialog() {
    clearDialogFields();
}

// ============================================================================
// 저장 - 다이얼로그 (STD13A_INS) - NEW 모드
// ============================================================================
function doSaveDialog(overwrite) {
    if (!validateDialogFields()) return;

    var params = {
        orgCode: $('#f_orgCode').textbox('getValue'),
        orgName: $('#f_orgName').textbox('getValue'),
        orgParent: $('#f_orgParent').val(),
        orgLeader: $('#f_orgLeader').textbox('getValue'),
        orgSeq: $('#f_orgSeq').numberbox('getValue'),
        costCenter: $('#f_costCenter').combobox('getValue'),
        overwrite: overwrite ? '1' : '0'
    };

    $.ajax({
        url: consts.url.STD13A_INS,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success || getMessage('SAVED'), 'info');
                $('#edit-dialog').dialog('close');
                doSearch();
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
// 저장&닫기 - 다이얼로그 (STD13A_INS) - EDIT 모드
// ============================================================================
function doSaveCloseDialog(overwrite) {
    if (!validateDialogFields()) return;

    var params = {
        orgCode: $('#f_orgCode').textbox('getValue'),
        orgName: $('#f_orgName').textbox('getValue'),
        orgParent: $('#f_orgParent').val(),
        orgLeader: $('#f_orgLeader').textbox('getValue'),
        orgSeq: $('#f_orgSeq').numberbox('getValue'),
        costCenter: $('#f_costCenter').combobox('getValue'),
        overwrite: '1'
    };

    $.ajax({
        url: consts.url.STD13A_INS,
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
// 삭제 - 다이얼로그
// ============================================================================
function doDeleteFromDialog() {
    var orgCode = $('#f_orgCode').textbox('getValue');
    if (!orgCode) return;

    $.messager.confirm(getTitle('CONFIRM'), '선택한 부서를 삭제하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.STD13A_DEL,
                type: 'POST',
                data: { orgCode: orgCode },
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
// 삭제 - 트리 선택 행 (STD13A_DEL)
// ============================================================================
function doDelete() {
    var row = $('#org-tree').treegrid('getSelected');
    if (!row || !row.orgCode || row.orgCode === '_ALL_') {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), '선택한 부서를 삭제하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.STD13A_DEL,
                type: 'POST',
                data: { orgCode: row.orgCode },
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

