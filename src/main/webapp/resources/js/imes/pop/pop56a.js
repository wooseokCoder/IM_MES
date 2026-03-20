/**
 * ============================================================================
 * 화면: POP56A - 불량메일 발신자 관리
 * ============================================================================
 * 원본: ProActive POP56A_M0A.cs
 * 작성일: 2026-03-07
 *
 * 주요 기능:
 *   1. Grid1: 전동(E) 수신자 목록
 *   2. Grid2: 유압(P) 수신자 목록
 *   3. 사원 등록 (D0A 팝업)
 *   4. 사원 삭제 (논리삭제)
 *   5. 발신자 설정 저장 (TSYS_CONF: NG_MAIL_E, NG_MAIL_P)
 *
 * 그리드 구조:
 *   Grid1 (전동E 수신자) | Grid2 (유압P 수신자)
 *   - 컨텍스트 메뉴로 등록/삭제
 * ============================================================================
 */

// ============================================================================
// 1. consts 객체 (URL 설정 및 초기화)
// ============================================================================

var consts = {
    url: {
        POP56A_SER:         getUrl('/imes/pop/pop56a/POP56A_SER.json'),
        POP56A_INS:         getUrl('/imes/pop/pop56a/POP56A_INS.json'),
        POP56A_DEL:         getUrl('/imes/pop/pop56a/POP56A_DEL.json'),
        POP56A_SAVE_CONFIG: getUrl('/imes/pop/pop56a/POP56A_SAVE_CONFIG.json')
    },

    /** 현재 컨텍스트 메뉴가 열린 그리드의 prodType (E 또는 P) */
    currentProdType: 'E',

    /** 서버에서 전달된 발신자 설정값 (코드 + 이름) */
    ngMailE: '',
    ngMailP: '',
    ngMailEName: '',
    ngMailPName: '',

    /**
     * 초기화 함수
     * - 버튼 이벤트 바인딩
     * - 그리드 초기화
     * - 발신자 설정값 적용
     */
    init: function() {
        // 버튼 이벤트 바인딩
        $('#search-button').bind('click', doSearch);
        $('#save-config-button').bind('click', doSaveConfig);

        // D0A 팝업 버튼
        $('#emp-save-button').bind('click', doEmpSave);

        // Enter 키 검색
        $('#search-form').bind('keydown', function(e) {
            if (e.keyCode == 13) {
                doSearch();
            }
        });

        // 그리드 초기화
        initGrid1();
        initGrid2();

        // 그리드 헤더 컨텍스트 메뉴 (정렬/컬럼숨김/엑셀 등)
        GridHeaderMenu('#grid1', { exportFileName: '불량메일_전동수신자' });
        GridHeaderMenu('#grid2', { exportFileName: '불량메일_유압수신자' });

        // 사원 검색 공통 팝업 초기화 (발신자 돋보기 버튼용)
        acEmpForm.init();
        
        enableGridSortReset('#grid1');
        enableGridSortReset('#grid2');
    }
};

// ============================================================================
// 2. 초기값 전달 함수 (JSP에서 호출)
// ============================================================================

/**
 * JSP에서 서버 데이터를 전달받는 함수
 *
 * @param {Object} args 서버에서 전달된 초기값 (ngMailE, ngMailP)
 */
function doInit(args) {
    if (args) {
        $.extend(consts, args);
    }
}

// ============================================================================
// 3. jQuery Ready
// ============================================================================
$(function() {
    consts.init();
});

// ============================================================================
// 4. window.load
// ============================================================================
$(window).load(function() {
    // 발신자 설정값 적용 (hidden에 코드, textbox에 이름)
    if (consts.ngMailE) {
        $('#empE_code').val(consts.ngMailE);
        $('#empE').textbox('setValue', consts.ngMailEName || consts.ngMailE);
    }
    if (consts.ngMailP) {
        $('#empP_code').val(consts.ngMailP);
        $('#empP').textbox('setValue', consts.ngMailPName || consts.ngMailP);
    }

    hideLoadingBar();

    // 초기 조회
    doSearch();
});

// ============================================================================
// 5. 그리드 초기화
// ============================================================================

/**
 * Grid1: 전동(E) 수신자 목록
 */
function initGrid1() {
    $('#grid1').datagrid({
        fit: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        striped: true,
        columns: [[
            {field: 'empCode', title: '사원코드', width: 120, halign: 'center', align: 'center'},
            {field: 'empName', title: '사원명', width: 120, halign: 'center', align: 'center'}
        ]],
        onRowContextMenu: function(e, index, row) {
            e.preventDefault();
            // 해당 행 선택
            $('#grid1').datagrid('selectRow', index);
            // prodType 설정 (전동=E)
            consts.currentProdType = 'E';
            // 컨텍스트 메뉴 표시
            $('#grid-menu').menu('show', {
                left: e.pageX,
                top: e.pageY
            });
        }
    });
}

/**
 * Grid2: 유압(P) 수신자 목록
 */
function initGrid2() {
    $('#grid2').datagrid({
        fit: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        striped: true,
        columns: [[
            {field: 'empCode', title: '사원코드', width: 120, halign: 'center', align: 'center'},
            {field: 'empName', title: '사원명', width: 120, halign: 'center', align: 'center'}
        ]],
        onRowContextMenu: function(e, index, row) {
            e.preventDefault();
            // 해당 행 선택
            $('#grid2').datagrid('selectRow', index);
            // prodType 설정 (유압=P)
            consts.currentProdType = 'P';
            // 컨텍스트 메뉴 표시
            $('#grid-menu').menu('show', {
                left: e.pageX,
                top: e.pageY
            });
        }
    });
}

// ============================================================================
// 6. 조회 함수
// ============================================================================

/**
 * 수신자 목록 조회 (POP56A_SER)
 * 서버에서 전체 목록을 받아 prodType 기준으로 Grid1/Grid2에 분배
 */
function doSearch() {
    $('#grid1').datagrid('loading');
    $('#grid2').datagrid('loading');

    $.ajax({
        url: consts.url.POP56A_SER,
        type: 'POST',
        data: {},
        dataType: 'json',
        success: function(result) {
            var allRows = result.rows || result || [];
            var eRows = [];
            var pRows = [];

            // prodType 기준으로 분배
            for (var i = 0; i < allRows.length; i++) {
                if (allRows[i].prodType == 'E') {
                    eRows.push(allRows[i]);
                } else if (allRows[i].prodType == 'P') {
                    pRows.push(allRows[i]);
                }
            }

            // 그리드에 데이터 로드
            $('#grid1').datagrid('loadData', eRows);
            $('#grid1').datagrid('loaded');
            $('#grid2').datagrid('loadData', pRows);
            $('#grid2').datagrid('loaded');
        },
        error: function() {
            $('#grid1').datagrid('loaded');
            $('#grid2').datagrid('loaded');
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 7. 사원 등록 (D0A 팝업)
// ============================================================================

/**
 * 사원 등록 팝업 열기 (컨텍스트 메뉴에서 호출)
 * consts.currentProdType에 따라 전동(E) 또는 유압(P) 그리드에 등록
 */
function doAddEmp() {
    // 값 초기화
    $('#f_empCode').val('');
    $('#f_empName').textbox('setValue', '');

    // dialog open
    $('#emp-dialog').dialog('open').dialog('center');

    // 팝업 타이틀에 유형 표시
    var typeLabel = (consts.currentProdType == 'E') ? '전동(E)' : '유압(P)';
    $('#emp-dialog').dialog('setTitle', '사원 등록 - ' + typeLabel);
}

/**
 * 사원 등록 저장 (D0A 팝업 저장 버튼)
 */
function doEmpSave() {
    var empCode = $('#f_empCode').val();

    if (!empCode || empCode.trim() == '') {
        $.messager.alert('알림', '사원을 선택하세요.');
        return;
    }

    $.ajax({
        url: consts.url.POP56A_INS,
        type: 'POST',
        data: JSON.stringify({
            empCode: empCode.trim(),
            prodType: consts.currentProdType
        }),
        contentType: 'application/json',
        dataType: 'json',
        success: function(result) {
            if (result.success != false) {
                $.messager.alert('알림', '등록되었습니다.');
                $('#emp-dialog').dialog('close');

                // 그리드 갱신: 서버에서 반환된 rows 사용
                if (result.rows) {
                    var allRows = result.rows;
                    if ($.isArray(allRows)) {
                        _distributeRows(allRows);
                    } else {
                        // rows가 ResultMap 형태인 경우 다시 조회
                        doSearch();
                    }
                } else {
                    doSearch();
                }
            } else {
                $.messager.alert('오류', result.message || '등록 실패', 'error');
            }
        },
        error: function() {
            $.messager.alert('오류', '등록 중 오류가 발생했습니다.', 'error');
        }
    });
}

/**
 * 사원 등록 팝업 닫기
 */
function doEmpClose() {
    $('#emp-dialog').dialog('close');
}

// ============================================================================
// 8. 사원 삭제 (컨텍스트 메뉴)
// ============================================================================

/**
 * 사원 삭제 (컨텍스트 메뉴에서 호출)
 * 현재 선택된 그리드의 선택 행을 논리삭제
 */
function doDeleteEmp() {
    var gridId = (consts.currentProdType == 'E') ? 'grid1' : 'grid2';
    var selected = $('#' + gridId).datagrid('getSelected');

    if (!selected) {
        $.messager.alert('알림', '삭제할 사원을 선택하세요.');
        return;
    }

    $.messager.confirm('확인', selected.empCode + ' 사원을 삭제하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.POP56A_DEL,
                type: 'POST',
                data: JSON.stringify({
                    empCode: selected.empCode,
                    prodType: consts.currentProdType
                }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(result) {
                    if (result.success != false) {
                        $.messager.alert('알림', '삭제되었습니다.');
                        doSearch();
                    } else {
                        $.messager.alert('오류', result.message || '삭제 실패', 'error');
                    }
                },
                error: function() {
                    $.messager.alert('오류', '삭제 중 오류가 발생했습니다.', 'error');
                }
            });
        }
    });
}

// ============================================================================
// 9. 발신자 설정 저장
// ============================================================================

/**
 * 발신자 설정 저장 (POP56A_SAVE_CONFIG)
 * TSYS_CONF에 NG_MAIL_E, NG_MAIL_P 저장
 */
function doSaveConfig() {
    // hidden field에서 사원코드 읽기 (textbox는 사원명 표시용)
    var empE = $('#empE_code').val();
    var empP = $('#empP_code').val();

    $.messager.confirm('확인', '발신자 설정을 저장하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.POP56A_SAVE_CONFIG,
                type: 'POST',
                data: JSON.stringify({
                    empE: empE,
                    empP: empP
                }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(result) {
                    if (result.success != false) {
                        $.messager.alert('알림', '발신자 설정이 저장되었습니다.');
                    } else {
                        $.messager.alert('오류', result.message || '저장 실패', 'error');
                    }
                },
                error: function() {
                    $.messager.alert('오류', '저장 중 오류가 발생했습니다.', 'error');
                }
            });
        }
    });
}

// ============================================================================
// 10. 유틸리티 함수
// ============================================================================

/**
 * 서버 응답 rows를 prodType 기준으로 Grid1/Grid2에 분배
 *
 * @param {Array} allRows 전체 수신자 목록
 */
function _distributeRows(allRows) {
    var eRows = [];
    var pRows = [];

    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].prodType == 'E') {
            eRows.push(allRows[i]);
        } else if (allRows[i].prodType == 'P') {
            pRows.push(allRows[i]);
        }
    }

    $('#grid1').datagrid('loadData', eRows);
    $('#grid2').datagrid('loadData', pRows);
}

/**
 * D0A 팝업 사원 검색 (돋보기 버튼 클릭)
 * hidden에 코드 저장, textbox에 이름 표시
 */
function doSearchEmpD0a() {
    acEmpForm.open({
        onSelect: function(rows) {
            if (rows && rows.length > 0) {
                $('#f_empCode').val(rows[0].empCode || '');
                $('#f_empName').textbox('setValue', rows[0].empName || '');
            }
        }
    });
}

/**
 * 발신자 입력란 돋보기 버튼 클릭 → 사원 검색 팝업 (acEmpForm 공통 모듈)
 * AS-IS: acEmp.FindButtonVisible = true → 사원 검색 팝업 호출
 *
 * @param {String} type 'E'=전동, 'P'=유압
 */
function doSearchSender(type) {
    var targetId = (type == 'E') ? 'empE' : 'empP';
    var hiddenId = (type == 'E') ? 'empE_code' : 'empP_code';

    acEmpForm.open({
        onSelect: function(rows) {
            if (rows && rows.length > 0) {
                // hidden에 코드 저장, textbox에 이름 표시
                $('#' + hiddenId).val(rows[0].empCode || '');
                $('#' + targetId).textbox('setValue', rows[0].empName || '');
            }
        }
    });
}

/**
 * 로딩바 숨기기 + 메인 레이아웃 표시
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').css('display', '');
}
