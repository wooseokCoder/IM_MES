/**
 * ============================================================================
 * 화면명: POP32B - 비가동현황 (가공)
 * ============================================================================
 * 설명: 비가동현황 목록 조회, 삭제, 상세원인 수정 및 확인
 * 작성자: AI Assistant
 * 작성일: 2026-03-03
 * ============================================================================
 * 참고: POP32A의 서비스를 재사용 (POP32A_SER, POP32A_DEL, POP32A_INS3)
 * ============================================================================
 */

// ============================================================================
// URL 상수
// ============================================================================
var consts = {
    url: {
        POP32A_SER:  getUrl('/imes/pop/pop32b/POP32A_SER.json'),
        POP32A_DEL:  getUrl('/imes/pop/pop32b/POP32A_DEL.json'),
        POP32A_INS3: getUrl('/imes/pop/pop32b/POP32A_INS3.json')
    },

	/**
	 * 초기화 함수
	 * - 버튼 이벤트 바인딩
	 * - 컨텍스트 메뉴 바인딩
	 * - 그리드 초기화
	 */
	init: function() {
	    // 컨텍스트 메뉴 이벤트 바인딩
	    // AS-IS: popupMenu1 (ShowGridMenuEx) - 신규등록, 열기, 삭제
	    $('#ctx-append').bind('click', doAppend);
	    $('#ctx-open').bind('click', doOpenEdit);
	    $('#ctx-delete').bind('click', doDelete);
	}
};

// ============================================================================
// 전역 변수
// ============================================================================
var plants = '3605';  // 기본 공장코드 (가공)

// ============================================================================
// 화면 초기화
// ============================================================================

/**
 * DOM Ready: 그리드/다이얼로그 초기화
 */
$(function() {
    // 그리드 초기화
    initGrid();

    // 다이얼로그 초기화
    initDialog();
    
    consts.init();
});

/**
 * Window Load: EasyUI 컴포넌트 초기화 완료 후 실행
 */
$(window).load(function() {
	acWeekDate.init({
        prefix: 'wd1',
        mode: 'WEEK',
        onPrev: doSearch,
        onNext: doSearch
    });

    // 화면 로딩 완료
    hideLoadingBar();

    // 버튼 이벤트 바인딩
    bindButtonEvents();

    // 화면 진입 시 자동 조회
    doSearch();
});

// ============================================================================
// 그리드 초기화
// ============================================================================
function initGrid() {
    // 그리드 초기화 - 단건 선택 + 우클릭 컨텍스트 메뉴
    $('#search-grid').datagrid({
        url: consts.url.POP32A_SER,
        method: 'post',
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: false,
        remoteSort: false,
        idField: 'idleId',
        toolbar: '#search-toolbar',
        frozenColumns: [[
            {field: 'ifFlag',   title: 'SAP전송 여부', width: 80,  halign: 'center', align: 'center', resizable: true, sortable: true, formatter: formatIfFlag, data_item: 'GRD_001'},
            {field: 'empCode',  title: '사번',         width: 100, halign: 'center', align: 'center', resizable: true, sortable: true, data_item: 'GRD_002'},
            {field: 'empName',  title: '작업자',       width: 120, halign: 'center', align: 'center', resizable: true, sortable: true, data_item: 'GRD_003'}
        ]],
        columns: [[
            {field: 'mcName',           title: '작업장',       width: 150, halign: 'center', align: 'center', resizable: true, sortable: true, data_item: 'GRD_004'},
            {field: 'idleCode',         title: '비가동구분코드', width: 100, halign: 'center', align: 'center', resizable: true, hidden: true},
            {field: 'idleName',         title: '비가동구분',   width: 150, halign: 'center', align: 'center', resizable: true, sortable: true, data_item: 'GRD_005'},
            {field: 'startTime',        title: '시작시간',     width: 140, halign: 'center', align: 'center', resizable: true, sortable: true, data_item: 'GRD_006'},
            {field: 'endTime',          title: '완료시간',     width: 140, halign: 'center', align: 'center', resizable: true, sortable: true, data_item: 'GRD_007'},
            {field: 'idleTime',         title: '비가동시간(분)', width: 120, halign: 'center', align: 'right',  resizable: true, sortable: true, data_item: 'GRD_008'},
            {field: 'regEmpName',       title: '등록자',       width: 100, halign: 'center', align: 'center', resizable: true, sortable: true, data_item: 'GRD_009'},
            {field: 'mctScomment',      title: '상세원인',     width: 200, halign: 'center', align: 'left',   resizable: true, sortable: true, data_item: 'GRD_010', formatter: function(v) { return v == 'NULL' ? '' : v; }},
            {field: 'mctScommentResult', title: '처리내용',    width: 200, halign: 'center', align: 'left',   resizable: true, sortable: true, data_item: 'GRD_011', formatter: function(v) { return v == 'NULL' ? '' : v; }},
            {field: 'idleId',   hidden: true},
            {field: 'pltCode',  hidden: true},
            {field: 'dataFlag', hidden: true}
        ]],
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
            // 더블클릭 시 상세원인 수정 다이얼로그 열기
            doOpenDetail(row);
        },
        onRowContextMenu: function(e, index, row) {
            e.preventDefault();
            $(this).datagrid('selectRow', index);
            // AS-IS 가시성 로직: 행 선택 시 열기/삭제 표시
            $('#ctx-open').show();
            $('#ctx-delete').show();
            $('#grid-context-menu').menu('show', { left: e.pageX, top: e.pageY });
        }
    });

    // 빈 영역 우클릭: 등록만 표시
    $('#search-grid').datagrid('getPanel').bind('contextmenu', function(e) {
        var target = $(e.target);
        if (target.closest('.datagrid-row').length === 0) {
            e.preventDefault();
            $('#search-grid').datagrid('unselectAll');

            $('#ctx-open').parent().hide();
            $('#ctx-delete').parent().hide();

            $('#grid-context-menu').menu('show', {left: e.pageX, top: e.pageY});
        }
    });
}

// ============================================================================
// 다이얼로그 초기화 (상세원인 수정 다이얼로그만 처리, 팝업은 pop32a_dialog.js 에서 처리)
// ============================================================================
function initDialog() {
    // 상세원인 수정 다이얼로그
    // class="easyui-dialog"는 사용하지 않고 여기서만 초기화 (중복 초기화 방지)
    $('#detail-dialog').dialog({
        title   : '가공 상세원인 수정 및 확인',
        closed  : true,
        modal   : true,
        width   : 500,
        height  : 640,
        buttons : '#detail-dialog-buttons',
        onOpen  : function() {
            $(this).css('visibility', '');
            $(this).dialog('center');
        },
        onClose : function() {
            clearDialogFields();
        }
    });
}

// ============================================================================
// 버튼 이벤트 바인딩
// ============================================================================
function bindButtonEvents() {
    // 조회
    $('#search-button').bind('click', doSearch);

    // 신규등록 (POP32A D0A 팝업 열기)
    $('#add-button').bind('click', function() {
        doOpenNew();
    });

    // 삭제
    $('#delete-button').bind('click', function() {
        var row = $('#search-grid').datagrid('getSelected');
        if (row) {
            doDeleteRow(row);
        } else {
            $.messager.alert('알림', '삭제할 항목을 선택하세요.', 'info');
        }
    });

    // 가공 상세원인 수정 및 확인
    $('#detail-button').bind('click', function() {
        var row = $('#search-grid').datagrid('getSelected');
        if (row) {
            doOpenDetail(row);
        } else {
            $.messager.alert('알림', '수정할 항목을 선택하세요.', 'info');
        }
    });


    // 상세원인 수정 다이얼로그 저장
    $('#dialog-save-button2').off('click').on('click', function() {
    	doSaveDialog();
    });

    // 상세원인 수정 다이얼로그 닫기
    $('#dialog-close-button2').off('click').on('click', function() {
    	$('#detail-dialog').dialog('close');
    });
}

// ============================================================================
// 조회 (POP32A_SER)
// ============================================================================
function doSearch() {
    var sDate = acWeekDate.getStartDate('wd1');
    var eDate = acWeekDate.getEndDate('wd1');

    if (!sDate || !eDate) {
        $.messager.alert('알림', '조회 기간을 입력하세요.', 'info');
        return;
    }

    var params = {
        sIdleDate: sDate.replace(/-/g, ''),
        eIdleDate: eDate.replace(/-/g, ''),
        plants: plants
    };

    $('#search-grid').datagrid('load', params);
}

// ============================================================================
// 신규등록 (D0A 팝업 오픈)
// ============================================================================
/**
 * 신규등록 - 비가동 등록 팝업(D0A) 열기
 * AS-IS: POP32A_M0A.cs > acBarButtonItem3_ItemClick → POP32A_D0A (NEW mode)
 * - D0A 팝업은 pop32a_dialog.js에서 처리
 */
function doAppend() {
    doOpenNew();
}

// ============================================================================
// 컨텍스트 메뉴 "열기" - 비가동 수정 팝업 열기
// ============================================================================
/**
 * 컨텍스트 메뉴 "열기" - 비가동 수정 팝업 열기
 * AS-IS: POP32A_M0A.cs > acBarButtonItem5_ItemClick
 * - IF_FLAG=1(SAP 전송완료) 건은 수정 불가
 */
function doOpenEdit() {
    var row = $('#search-grid').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', '수정할 데이터를 선택하세요.', 'info');
        return;
    }

    // SAP 전송완료 건 수정 차단 (AS-IS: IF_FLAG == "1" 체크)
    if (row.ifFlag == '1' || row.ifFlag == '2') {
        $.messager.alert('알림', '이미 전송된 비가동은 수정할 수 없습니다.', 'warning');
        return;
    }

    // 상세원인 수정 다이얼로그 열기
    doOpenD2a(row);
}

// ============================================================================
// 삭제 (POP32A_DEL)
// ============================================================================
/**
 * 비가동 삭제 (논리 삭제: DATA_FLAG=2)
 * - 선택된 행이 없으면 안내 메시지 표시
 * - SAP 전송 완료(ifFlag=1)인 건은 삭제 불가
 * - 확인 후 삭제 처리, 성공 시 재조회
 * - AS-IS: POP32A_DEL 서비스
 */
function doDelete() {
    // 선택된 행 확인
    var selected = $('#search-grid').datagrid('getSelected');
    if (!selected) {
        $.messager.alert('알림', '삭제할 데이터를 선택하세요.', 'info');
        return;
    }
    // SAP 전송 완료 건은 삭제 불가
    if (selected.ifFlag == '1') {
        $.messager.alert('알림', 'SAP 전송 완료 건은 삭제할 수 없습니다.', 'warning');
        return;
    }

    // 삭제 확인 다이얼로그
    $.messager.confirm('확인', '선택한 비가동 데이터를 삭제하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.POP32A_DEL,
                type: 'POST',
                data: {
                    idleId: selected.idleId
                },
                dataType: 'json',
                success: function(result) {
                    // 삭제 성공 시 재조회
                    doSearch();
                },
                error: function() {
                    $.messager.alert('오류', '삭제 중 오류가 발생했습니다.', 'error');
                }
            });
        }
    });
}

// ============================================================================
// 상세원인 수정 다이얼로그 열기
// ============================================================================
function doOpenDetail(row) {
    // 다이얼로그 필드 설정
    $('#f_idleId').val(row.idleId);
    
    var scom = row.mctScomment || '';
    scom = scom == 'NULL' ? '' : scom;
    var scomRes = row.mctScommentResult || '';
    scomRes = scomRes == 'NULL' ? '' : scomRes;
    
    $('#f_mctScomment').textbox('setValue', scom);
    $('#f_mctScommentResult').textbox('setValue', scomRes);

    $('#detail-dialog').dialog('open');
}

// ============================================================================
// 다이얼로그 저장
// ============================================================================
function doSaveDialog() {
    var idleId = $('#f_idleId').val();
    if (!idleId) {
        $.messager.alert('알림', '저장할 항목이 없습니다.', 'info');
        return;
    }

    // 저장 확인
    $.messager.confirm('확인', '수정하시겠습니까?', function(r) {
        if (!r) {
            return;
        }

        var params = {
            idleId: idleId,
            mctScomment: $('#f_mctScomment').textbox('getValue'),
            mctScommentResult: $('#f_mctScommentResult').textbox('getValue'),
            startDate: acWeekDate.getStartDate('wd1'),
        	endDate: acWeekDate.getEndDate('wd1')
        };
        
        // 날짜 형식 변환 (YYYY-MM-DD -> YYYYMMDD)
        params.startDate = params.startDate.replace(/-/g, '');
        params.endDate = params.endDate.replace(/-/g, '');

        $.ajax({
            url: consts.url.POP32A_INS3,
            type: 'POST',
            data: params,
            dataType: 'json',
            success: function(result) {
                if (result && result.success) {
                    $.messager.alert('알림', '수정되었습니다.', 'info');
                    $('#detail-dialog').dialog('close');
                    doSearch();  // 목록 재조회
                } else {
                    $.messager.alert('오류', result.message || '수정 실패', 'error');
                }
            },
            error: function() {
                $.messager.alert('오류', '수정 중 오류가 발생했습니다.', 'error');
            }
        });
    });
}

// ============================================================================
// 삭제
// ============================================================================
function doDeleteRow(row) {
    if (row.ifFlag == '1' || row.ifFlag == '2') {
        $.messager.alert('알림', '이미 전송된 비가동은 삭제할 수 없습니다.', 'info');
        return;
    }

    $.messager.confirm('확인', '정말 삭제하시겠습니까?', function(r) {
        if (!r) {
            return;
        }

        $.ajax({
            url: consts.url.POP32A_DEL,
            type: 'POST',
            data: {
                idleId: row.idleId
            },
            success: function(result) {
                if (result && result.success) {
                    $.messager.alert('알림', '삭제되었습니다.', 'info');
                    doSearch();
                } else {
                    $.messager.alert('오류', result.message || '삭제 실패', 'error');
                }
            },
            error: function() {
                $.messager.alert('오류', '삭제 중 오류가 발생했습니다.', 'error');
            }
        });
    });
}

// ============================================================================
// 다이얼로그 필드 초기화
// ============================================================================
function clearDialogFields() {
    $('#detail-form').form('clear');
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
 * 텍스트박스 Enter 키 바인딩
 */
function bindEnterKey(id) {
    var $tb = $('#' + id);
    if ($tb.length === 0) return;
    $tb.textbox('textbox').bind('keyup', function(e) {
        $tb.textbox('setValue', $(this).val());
    });
    $tb.textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode === 13) {
            $tb.textbox('setValue', $(this).val());
            doSearch();
        }
    });
}

/**
 * SAP 전송 여부 포맷터 (체크박스)
 */
function formatIfFlag(value, row, index) {
    // 전송완료(value == '1' || value == '2')일 경우 checked
    var checked = (value == '1' || value == '2') ? ' checked="checked"' : '';
    return '<input type="checkbox"' + checked + ' disabled />';
}


