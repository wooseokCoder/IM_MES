/**
 * ============================================================================
 * 화면명: ORD07A - 일련번호 관리
 * ============================================================================
 * 설명: 일련번호 목록 조회, D0A 팝업을 통한 순번 수정
 * 작성자: 송우석
 * 작성일: 2026-02-10
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var d0aInited = false;  // D0A 팝업 초기화 여부 (guard flag)
var d0aRow = null;      // D0A 팝업에서 편집 중인 행 데이터

// ============================================================================
// consts
// ============================================================================
var consts = {
    url: {
        ORD07A_SER: getUrl('/imes/ord/ord07a/ORD07A_SER.json'),
        ORD07A_UPD: getUrl('/imes/ord/ord07a/ORD07A_UPD.json')
    },

    init: function() {
        // --- 그리드 초기화 (컬럼은 JSP <thead>에서 data_item으로 정의) ---
        $('#search-grid').datagrid({
            url: this.url.ORD07A_SER,
            method: 'post',
            fit: true,
            fitColumns: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
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
                doOpenD0a(row);
            },
            onRowContextMenu: function(e, rowIndex, rowData) {
                e.preventDefault();
                if (rowData) {
                    $('#search-grid').datagrid('selectRow', rowIndex);
                    $('#grid-context-menu').menu('show', {left: e.pageX, top: e.pageY});
                }
            }
        });

        // common.css의 width:100% 강제 확장 방지
        $('#search-grid').datagrid('getPanel').find('.datagrid-view').addClass('noStyle');

        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#ctx-open').bind('click', function() {
            var row = $('#search-grid').datagrid('getSelected');
            if (row) doOpenD0a(row);
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

$(window).load(function() {
    hideLoadingBar();

    // 검색 조건 Enter 키
    $('#s_modelLike').textbox('textbox').bind('keyup', function(e) {
        $('#s_modelLike').textbox('setValue', $(this).val());
    });
    $('#s_modelLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_modelLike').textbox('setValue', $(this).val());
            doSearch();
        }
    });

    GridHeaderMenu('#search-grid', { exportFileName: '일련번호관리' });
    enableGridSortReset('#search-grid');

    // 화면 진입 시 자동 조회
    doSearch();
});

// ============================================================================
// 조회 (ORD07A_SER)
// ============================================================================
function doSearch() {
    var params = {
        modelLike: $('#s_modelLike').textbox('getText')
    };
    $('#search-grid').datagrid('load', params);
}

// ============================================================================
// D0A 팝업 열기
// ============================================================================
function doOpenD0a(row) {
	$('#d0a-popup').css('visibility', '');
    $('#d0a-buttons').css('visibility', '');

    d0aRow = row;
    $('#d0a-popup').dialog('open').dialog('center');
    // href 캐시 대응: 재오픈 시 필드 값 설정
    if (d0aInited) {
        loadD0aFields(row);
    }
}

// ============================================================================
// D0A 팝업 초기화 (href onLoad 콜백)
// ============================================================================
function initD0aPopup() {
    if (d0aInited) return;
    d0aInited = true;

    // 버튼 이벤트 바인딩
    $('#d0a-save-button').bind('click', doSaveD0a);

    // numberbox 입력 자릿수 제한
    $('#d_srNo').numberbox('textbox').attr('maxlength', 9);  // SR_NO INT (9자리)

    // 첫 open 시 필드 값 설정
    if (d0aRow) {
        loadD0aFields(d0aRow);
    }
}

/**
 * D0A 팝업 필드 로드
 */
function loadD0aFields(row) {
    $('#d_srKey').textbox('setValue', row.srKey || '');
    $('#d_srCode').textbox('setValue', row.srCode || '');
    $('#d_srNo').numberbox('setValue', row.srNo || 0);
}

// ============================================================================
// D0A 저장 (ORD07A_UPD)
// ============================================================================
function doSaveD0a() {
    var srKey = $('#d_srKey').textbox('getValue');
    var srCode = $('#d_srCode').textbox('getValue');
    var srNo = $('#d_srNo').numberbox('getValue');

    if (!srKey || srKey.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '년도를 입력하세요.', 'warning');
        return;
    }
    if (!srCode || srCode.trim() === '') {
        $.messager.alert(getTitle('ALERT'), '모델을 입력하세요.', 'warning');
        return;
    }

    $.ajax({
        url: consts.url.ORD07A_UPD,
        type: 'POST',
        data: {
            srKey: srKey,
            srCode: srCode,
            srNo: srNo
        },
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
            case 'CONFIRM_SAVE': return msg.MSG0036 || '저장하시겠습니까?';
        }
    }
    switch (key) {
        case 'SAVED': return '저장되었습니다.';
        case 'CONFIRM_SAVE': return '저장하시겠습니까?';
        default: return key;
    }
}
