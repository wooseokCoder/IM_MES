/**
 * ============================================================================
 * 화면명: STD52A - 설비점검항목 관리
 * ============================================================================
 * 설명: 설비 일일점검항목 목록 조회, 등록, 수정, 삭제
 * 작성자: 송우석
 * 작성일: 2026-02-06
 * ============================================================================
 */

// ============================================================================
// URL 상수
// ============================================================================
var consts = {
    url: {
        STD52A_SER: getUrl('/imes/std/std52a/STD52A_SER.json'),
        STD52A_INS: getUrl('/imes/std/std52a/STD52A_INS.json'),
        STD52A_DEL: getUrl('/imes/std/std52a/STD52A_DEL.json')
    }
};

// ============================================================================
// 화면 초기화
// ============================================================================

/**
 * DOM Ready: 그리드/다이얼로그 초기화
 */
$(function() {
    // 500 에러 시 raw 메시지 대신 일반 메시지 표시
    $.ajaxSetup({ statusCode: { 500: function() {
        $.messager.alert('Error', '오류가 발생했습니다.', 'error');
    }}});
    // 그리드 초기화
    initGrid();

    // 다이얼로그 초기화
    initDialog();
});

/**
 * Window Load: EasyUI 컴포넌트 초기화 완료 후 실행
 */
$(window).load(function() {
    setTimeout(function() {
        // 화면 로딩 완료
        hideLoadingBar();

        // 버튼 이벤트 바인딩
        bindButtonEvents();

        enableGridSortReset('#search-grid');
        GridHeaderMenu('#search-grid', { exportFileName: '설비점검항목' });

        // 화면 진입 시 자동 조회
        doSearch();
    }, 100);
});

// ============================================================================
// 그리드 초기화
// ============================================================================
function initGrid() {
    // 그리드 컬럼은 JSP <thead>에서 data_item으로 정의 (다국어 지원)

    // 그리드 초기화
    $('#search-grid').datagrid({
        url: consts.url.STD52A_SER,
        method: 'post',
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'smdcNo',
        toolbar: '#search-toolbar',
        onBeforeLoad: function(param) {
            if (!this.loaded) {
                this.loaded = true;
                return false;
            }
        },
        onLoadSuccess: function(data) {
            $('#search-grid').datagrid('unselectAll');
        },
        onDblClickRow: function(index, row) {
            doOpenEdit(row);
        }
    });
}

// ============================================================================
// 다이얼로그 초기화
// ============================================================================
var _dialogMaxLenSet = false;

function initDialog() {
    $('#edit-dialog').dialog({
        title: '점검항목 등록',
        closed: true,
        modal: true,
        onOpen: function() {
        	$(this).css('visibility', '');
            $('#edit-dialog-buttons').css('visibility', '');
            $(this).dialog('center');

            // 입력 필드 maxlength 설정 (TSTD_MC_DAILY_CHECK 컬럼 길이)
            if (!_dialogMaxLenSet) {
                _dialogMaxLenSet = true;
                $('#f_smdcType').textbox('textbox').attr('maxlength', 50);    // SMDC_TYPE VARCHAR(50)
                $('#f_smdcNum').textbox('textbox').attr('maxlength', 10);     // SMDC_NUM VARCHAR(10)
                $('#f_smdcMeans').textbox('textbox').attr('maxlength', 50);   // SMDC_MEANS VARCHAR(50)
                $('#f_smdcSeq').numberbox('textbox').attr('maxlength', 9);    // SMDC_SEQ INT (9자리)
            }
        }
    });
}

// ============================================================================
// 버튼 이벤트 바인딩
// ============================================================================
function bindButtonEvents() {
    // 조회
    $('#search-button').bind('click', doSearch);

    // 등록
    $('#btn-add').bind('click', doOpenNew);

    // 삭제
    $('#btn-delete').bind('click', function() {
        var row = $('#search-grid').datagrid('getSelected');
        if (row) {
            doDeleteRow(row);
        } else {
            $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        }
    });

    // 다이얼로그 저장 (NEW 모드: 저장 후 다이얼로그 유지, overwrite='0')
    $('#dialog-save-button').bind('click', function() {
        doSaveDialog(false, false);
    });

    // 다이얼로그 초기화 (NEW 모드)
    $('#dialog-clear-button').bind('click', function() {
        clearDialogFields();
    });

    // 다이얼로그 저장&닫기 (EDIT 모드: 저장 후 다이얼로그 닫기, overwrite='1')
    // EDIT 모드에서 항상 overwrite='1' 전송
    $('#dialog-saveclose-button').bind('click', function() {
        doSaveDialog(true, true);
    });

    // 다이얼로그 삭제 (EDIT 모드: 단건 삭제)
    $('#dialog-delete-button').bind('click', function() {
        doDeleteFromDialog();
    });

    // 검색 조건 Enter 키 이벤트
    $('#s_typeLike').textbox('textbox').bind('keyup', function(e) {
        $('#s_typeLike').textbox('setValue', $(this).val());
    });
    $('#s_typeLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_typeLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });

    $('#s_contentsLike').textbox('textbox').bind('keyup', function(e) {
        $('#s_contentsLike').textbox('setValue', $(this).val());
    });
    $('#s_contentsLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_contentsLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });
}

// ============================================================================
// 조회 (STD52A_SER)
// ============================================================================
function doSearch() {
    var params = {
        typeLike: $('#s_typeLike').textbox('getText'),
        contentsLike: $('#s_contentsLike').textbox('getText')
    };

    $('#search-grid').datagrid('load', params);
}

// ============================================================================
// 신규 다이얼로그 열기
// ============================================================================
function doOpenNew() {
    clearDialogFields();

    // NEW 모드: 저장 + 초기화 표시, 저장닫기 + 삭제 숨김
    $('#dialog-save-button').show();
    $('#dialog-clear-button').show();
    $('#dialog-saveclose-button').hide();
    $('#dialog-delete-button').hide();

    $('#edit-dialog').dialog('setTitle', '점검항목 등록');
    $('#edit-dialog').dialog('open');
}

// ============================================================================
// 편집 다이얼로그 열기 (더블클릭)
// ============================================================================
function doOpenEdit(row) {
    clearDialogFields();
    loadDialogFields(row);

    // EDIT 모드: 저장닫기 + 삭제 표시, 저장 + 초기화 숨김
    $('#dialog-save-button').hide();
    $('#dialog-clear-button').hide();
    $('#dialog-saveclose-button').show();
    $('#dialog-delete-button').show();

    $('#edit-dialog').dialog('setTitle', '점검항목 수정');
    $('#edit-dialog').dialog('open');
}

/**
 * 다이얼로그 필드 초기화
 */
function clearDialogFields() {
    $('#f_smdcNo').textbox('setValue', '');
    $('#f_smdcType').textbox('setValue', '');
    $('#f_smdcNum').textbox('setValue', '');
    $('#f_smdcContents').val('');
    $('#f_smdcCheck').val('');
    $('#f_smdcMeans').textbox('setValue', '');
    $('#f_smdcSeq').numberbox('setValue', 0);
}

/**
 * 다이얼로그 필드 로드 (수정 시)
 */
function loadDialogFields(row) {
    $('#f_smdcNo').textbox('setValue', row.smdcNo || '');
    $('#f_smdcType').textbox('setValue', row.smdcType || '');
    $('#f_smdcNum').textbox('setValue', row.smdcNum || '');
    $('#f_smdcContents').val(row.smdcContents || '');
    $('#f_smdcCheck').val(row.smdcCheck || '');
    $('#f_smdcMeans').textbox('setValue', row.smdcMeans || '');
    $('#f_smdcSeq').numberbox('setValue', row.smdcSeq || 0);
}

/**
 * 다이얼로그 필드 검증
 */
function validateDialogFields() {
    var smdcType = $('#f_smdcType').textbox('getValue');
    var smdcContents = $('#f_smdcContents').val();

    if (!smdcType || smdcType.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '구분을 입력하세요.', 'warning');
        $('#f_smdcType').textbox('textbox').focus();
        return false;
    }

    if (!smdcContents || smdcContents.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '점검항목을 입력하세요.', 'warning');
        $('#f_smdcContents').focus();
        return false;
    }

    return true;
}

/**
 * 다이얼로그 파라미터 수집
 */
function getDialogParams() {
    return {
        smdcNo: $('#f_smdcNo').textbox('getValue'),
        smdcType: $('#f_smdcType').textbox('getValue'),
        smdcNum: $('#f_smdcNum').textbox('getValue'),
        smdcContents: $('#f_smdcContents').val(),
        smdcCheck: $('#f_smdcCheck').val(),
        smdcMeans: $('#f_smdcMeans').textbox('getValue'),
        smdcSeq: $('#f_smdcSeq').numberbox('getValue') || 0
    };
}

// ============================================================================
// 저장 - 다이얼로그 (STD52A_INS) + OVERWRITE 에러 처리
//   - NEW 모드: overwrite='0', smdcNo=빈값
//   - EDIT 모드 (저장&닫기): overwrite='1', smdcNo=기존값
//   - 중복 에러: 100001(활성 중복)/100002(삭제이력) → overwrite='1'로 재시도
// ============================================================================
function doSaveDialog(overwrite, closeAfterSave) {
    // 필수값 검증
    if (!validateDialogFields()) return;

    var params = getDialogParams();
    params.overwrite = overwrite ? '1' : '0';

    $.ajax({
        url: consts.url.STD52A_INS,
        type: 'POST',
        data: params,
        success: function(result) {
            // OVERWRITE 에러 처리 (중복/삭제이력)
            var code = result.code;

            if (code == 100001) {
                // 동일 데이터 존재 → 사용자 확인 후 overwrite='1'로 재시도
                $.messager.confirm(getTitle('CONFIRM'),
                    result.message,
                    function(r) {
                        if (r) {
                            doSaveDialog(true, closeAfterSave);
                        }
                    }
                );
            } else if (code == 100002) {
                // 삭제된 이력 존재 → 삭제 이력 표시 후 사용자 확인
                var msg = result.message;
                if (result.delDate) {
                    msg += '\n\n삭제일시: ' + result.delDate;
                }
                if (result.delEmp) {
                    msg += '\n삭제자: ' + result.delEmp;
                }

                $.messager.confirm(getTitle('CONFIRM'),
                    msg,
                    function(r) {
                        if (r) {
                            doSaveDialog(true, closeAfterSave);
                        }
                    }
                );
            } else if (result.error) {
                // 일반 에러
                $.messager.alert(getTitle('ERROR'), result.error, 'error');
            } else {
                // 저장 성공 (result = 목록 데이터 또는 success 메시지)
                $.messager.alert(getTitle('INFO'), getMessage('SAVED'), 'info');
                doSearch();

                if (closeAfterSave) {
                    // EDIT 모드 (저장&닫기): 다이얼로그 닫기
                    $('#edit-dialog').dialog('close');
                } else {
                    // NEW 모드 (저장): 다이얼로그 유지 + 필드 초기화
                    clearDialogFields();
                }
            }
        },
        error: function() {
        }
    });
}

// ============================================================================
// 삭제 (STD52A_DEL) - 컨텍스트 메뉴 단건
// ============================================================================
function doDeleteRow(row) {
    $.messager.prompt(getTitle('CONFIRM'), '삭제사유를 입력하세요.', function(reason) {
        if (reason !== undefined && reason !== null) {
            $.ajax({
                url: consts.url.STD52A_DEL,
                type: 'POST',
                data: { smdcNo: row.smdcNo, delReason: reason },
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success || getMessage('DELETED'), 'info');
                        doSearch();
                    } else {
                        $.messager.alert(getTitle('ERROR'), result.error || result.message, 'error');
                    }
                },
                error: function() {
                }
            });
        }
    });
}

// ============================================================================
// 다이얼로그 삭제 (EDIT 모드 - 단건)
// ============================================================================
function doDeleteFromDialog() {
    var smdcNo = $('#f_smdcNo').textbox('getValue');

    if (!smdcNo || smdcNo.trim() === '') {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    $.messager.prompt(getTitle('CONFIRM'), '삭제사유를 입력하세요.', function(reason) {
        if (reason !== undefined && reason !== null) {
            $.ajax({
                url: consts.url.STD52A_DEL,
                type: 'POST',
                data: { smdcNo: smdcNo, delReason: reason },
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success || getMessage('DELETED'), 'info');
                        $('#edit-dialog').dialog('close');
                        doSearch();
                    } else {
                        $.messager.alert(getTitle('ERROR'), result.error || result.message, 'error');
                    }
                },
                error: function() {
                }
            });
        }
    });
}

// ============================================================================
// 체크박스 (SEL 컬럼)
// ============================================================================

/**
 * SEL 컬럼 체크박스 formatter
 */
function formatSel(value) {
    var checked = (value === '1') ? ' checked' : '';
    return '<input type="checkbox"' + checked + ' onclick="toggleSel(this)" />';
}

/**
 * SEL 컬럼 체크박스 토글
 */
function toggleSel(cb) {
    var tr = $(cb).closest('tr.datagrid-row');
    var index = parseInt(tr.attr('datagrid-row-index'));
    var row = $('#search-grid').datagrid('getRows')[index];
    if (row) {
        row.sel = cb.checked ? '1' : '0';
    }
}

// ============================================================================
// 유틸리티 함수
// ============================================================================

/**
 * 로딩바 숨김
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

/**
 * 다국어 제목 조회
 */
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

/**
 * 다국어 메시지 조회
 */
function getMessage(key) {
    if (typeof msg !== 'undefined') {
        switch (key) {
            case 'SAVED': return msg.MSG0021 || '저장되었습니다.';
            case 'DELETED': return msg.MSG0054 || '삭제되었습니다.';
            case 'SELECT_DELETE': return msg.MSG0016 || '삭제할 항목을 선택하세요.';
            case 'CONFIRM_DELETE': return msg.MSG0030 || '삭제하시겠습니까?';
        }
    }
    switch (key) {
        case 'SAVED': return '저장되었습니다.';
        case 'DELETED': return '삭제되었습니다.';
        case 'SELECT_DELETE': return '삭제할 항목을 선택하세요.';
        case 'CONFIRM_DELETE': return '삭제하시겠습니까?';
        default: return key;
    }
}
