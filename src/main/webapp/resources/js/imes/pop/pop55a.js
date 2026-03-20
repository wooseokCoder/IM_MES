/**
 * ============================================================================
 * 화면: POP55A - NAM공정 NG파일배포 확인
 * ============================================================================
 * 원본: ProActive POP55A_M0A.cs
 * 작성일: 2026-03-07
 *
 * 주요 기능:
 *   1. Grid1: 제품 목록 조회 (POP55A_SER) - Master
 *   2. Grid2: 파일 목록 조회 (POP55A_SER2) - Detail
 *   3. 확인완료 (POP55A_INS) - 비고 입력 후 확인 처리
 *   4. 삭제 (POP55A_UDE) - 우클릭 메뉴 삭제
 *   5. FTP 파일 열기 (FTP_DOWNLOAD)
 *
 * 그리드 구조:
 *   Grid1 (Master: 제품 목록) → Grid2 (Detail: 파일 목록)
 * ============================================================================
 */

// ============================================================================
// 1. 전역 변수 / consts 객체 (URL 설정 및 초기화)
// ============================================================================

/** 코드 데이터 캐시 (코드 → 명칭 변환) */
var codeDataMap = {};

var consts = {
    url: {
        POP55A_SER:    getUrl('/imes/pop/pop55a/POP55A_SER.json'),
        POP55A_SER2:   getUrl('/imes/pop/pop55a/POP55A_SER2.json'),
        POP55A_INS:    getUrl('/imes/pop/pop55a/POP55A_INS.json'),
        POP55A_UDE:    getUrl('/imes/pop/pop55a/POP55A_UDE.json'),
        FTP_DOWNLOAD:  getUrl('/imes/common/ftpFile/download.do'),
        CODE_LIST:     getUrl('/common/code/code.json')
    },

    /** Grid1 선택된 행 정보 */
    selectedRow: null,

    /**
     * 코드 데이터 로드 함수
     * @param {String} codeGrup 코드그룹 (예: S907)
     * @returns {Array} 코드 데이터 배열
     */
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

    /**
     * 초기화 함수
     */
    init: function() {
        // S907 코드 데이터 로드 (전동/유압 구분)
        this.loadCode('S907');

        // 버튼 이벤트 바인딩
        $('#search-button').bind('click', doSearch);
        $('#confirm-button').bind('click', doConfirm);
        $('#delete-button').bind('click', doDelete);

        // D0A 다이얼로그 버튼
        $('#comment-save-btn').bind('click', doCommentSave);

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
        GridHeaderMenu('#grid1', { exportFileName: 'NG파일배포_마스터' });
        GridHeaderMenu('#grid2', { exportFileName: 'NG파일배포_상세' });
        
        enableGridSortReset('#grid1');
        enableGridSortReset('#grid2');
    }
};

// ============================================================================
// 2. jQuery Ready
// ============================================================================
$(function() {
    consts.init();
});

// ============================================================================
// 3. window.load
// ============================================================================
$(window).load(function() {
    // 날짜 초기값: 오늘 기준 7일 전 ~ 오늘
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);
    $('#s_sDate').datebox('setValue', formatDate(weekAgo));
    $('#s_eDate').datebox('setValue', formatDate(today));

    hideLoadingBar();
});

// ============================================================================
// 4. 그리드 초기화
// ============================================================================

/**
 * Grid1: 제품 목록 (Master)
 * 좌측 패널, singleSelect, 행 클릭 시 Grid2 Detail 조회
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
            /* 확인여부 (workFlag, readonly checkbox) */
            {field:'workFlag', title:'확인여부', width:60, halign:'center', align:'center',
                formatter:formatCheckbox},
            /* 구분 (S907 코드) */
            {field:'prodType', title:'구분', width:60, halign:'center', align:'center',
                formatter:formatS907},
            /* 완료(NAM) (readonly checkbox) */
            {field:'isNam', title:'완료(NAM)', width:80, halign:'center', align:'center',
                formatter:formatCheckbox},
            /* 생산계획일 */
            {field:'indueDate', title:'생산계획일', width:90, halign:'center', align:'center',
                formatter:formatShortDate},
            /* 판매오더 */
            {field:'orderNo', title:'판매오더', width:80, halign:'center', align:'left'},
            /* 라인 */
            {field:'orderLine', title:'라인', width:50, halign:'center', align:'center'},
            /* 호기 */
            {field:'prodHogi', title:'호기', width:60, halign:'center', align:'center'},
            /* 모델 */
            {field:'modelNo', title:'모델', width:100, halign:'center', align:'left'},
            /* 거래처 */
            {field:'customer', title:'거래처', width:120, halign:'center', align:'left'},
            /* 기계번호 */
            {field:'mcNo', title:'기계번호', width:80, halign:'center', align:'left'},
            /* 비고 */
            {field:'scomment', title:'비고', width:120, halign:'center', align:'left'},
            /* 감독자 */
            {field:'chkEmpName', title:'감독자', width:70, halign:'center', align:'center'},
            /* 확인일 */
            {field:'chkDate', title:'확인일', width:90, halign:'center', align:'center',
                formatter:formatShortDate},
            /* Hidden: prodCode (키 컬럼) */
            {field:'prodCode', hidden:true}
        ]],
        onClickRow: function(index, row) {
            // Master 행 선택 시 Detail 조회
            consts.selectedRow = row;
            doSearchDetail(row);
        },
        onLoadSuccess: function(data) {
            var rows = data.rows || data || [];
            if (rows.length > 0) {
                // 첫 번째 행 자동 선택 + Detail 조회
                $('#grid1').datagrid('selectRow', 0);
                consts.selectedRow = rows[0];
                doSearchDetail(rows[0]);
            } else {
                consts.selectedRow = null;
                $('#grid2').datagrid('loadData', []);
            }
        },
        /**
         * isNam == '1' → Honeydew 배경 (#F0FFF0)
         */
        rowStyler: function(index, row) {
            if (row.isNam == '1') {
                return 'background-color:#F0FFF0;';
            }
        },
    });
}

/**
 * Grid2: 파일 목록 (Detail)
 * 우측 패널, Grid1 행 선택 시 파일 목록 조회
 */
function initGrid2() {
    $('#grid2').datagrid({
        fit: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        striped: true,
        fitColumns: false,
        columns: [[
            /* 선택 버튼 (FTP 파일 열기) */
            {field:'sel', title:'선택', width:50, halign:'center', align:'center',
                formatter:formatSelButton},
            /* 파일명 */
            {field:'fileName', title:'파일명', width:150, halign:'center', align:'left'},
            /* 공정 */
            {field:'procCode', title:'공정', width:80, halign:'center', align:'center'},
            /* 확인자 */
            {field:'empName', title:'확인자', width:80, halign:'center', align:'center'},
            /* 확인일 */
            {field:'chkRegDate', title:'확인일', width:130, halign:'center', align:'center',
                formatter:formatMediumDate2},
            /* 배포자 */
            {field:'regEmpName', title:'배포자', width:80, halign:'center', align:'center'},
            /* 배포일 */
            {field:'regDate', title:'배포일', width:130, halign:'center', align:'center',
                formatter:formatMediumDate2},
            /* Hidden: fileId, woNo, dataFlag */
            {field:'fileId', hidden:true},
            {field:'woNo', hidden:true},
            {field:'dataFlag', hidden:true}
        ]]
    });
}

// ============================================================================
// 5. 조회 함수
// ============================================================================

/**
 * Grid1 조회 (POP55A_SER)
 * 검색 조건을 수집하여 제품 목록 조회
 */
function doSearch() {
    var sDate = $('#s_sDate').datebox('getValue');
    var eDate = $('#s_eDate').datebox('getValue');

    if (!sDate || !eDate) {
        $.messager.alert('알림', '검색 기간을 선택해주세요.');
        return;
    }

    // 일자구분 (multiple combobox)
    var dateTypes = $('#s_dateType').combobox('getValues');
    var params = {};
    for (var i = 0; i < dateTypes.length; i++) {
        if (dateTypes[i] == 'INDUE_DATE') {
            params.sIndueDate = sDate.replace(/-/g, '');
            params.eIndueDate = eDate.replace(/-/g, '');
        } else if (dateTypes[i] == 'CHK_DATE') {
            params.sChkDate = sDate.replace(/-/g, '');
            params.eChkDate = eDate.replace(/-/g, '');
        }
    }

    // 기타 검색 조건
    params.hogiLike = $('#s_hogiLike').textbox('getValue');
    params.orderLike = $('#s_orderLike').textbox('getValue');
    params.customerLike = $('#s_customerLike').textbox('getValue');
    params.prodType = $('#s_prodType').combobox('getValue');
    params.mcNoLike = $('#s_mcNoLike').textbox('getValue');

    $('#grid1').datagrid('loading');
    $.ajax({
        url: consts.url.POP55A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#grid1').datagrid('loadData', rows);
            $('#grid1').datagrid('loaded');
        },
        error: function() {
            $('#grid1').datagrid('loaded');
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

/**
 * Grid2 조회 (POP55A_SER2)
 * Grid1 행 선택 시 해당 제품의 파일 목록 조회
 * @param {Object} row Grid1에서 선택된 행
 */
function doSearchDetail(row) {
    if (!row) return;

    $('#grid2').datagrid('loading');
    $.ajax({
        url: consts.url.POP55A_SER2,
        type: 'POST',
        data: {
            prodCode: row.prodCode,
            model: row.modelNo
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#grid2').datagrid('loadData', rows);
            $('#grid2').datagrid('loaded');
        },
        error: function() {
            $('#grid2').datagrid('loaded');
        }
    });
}

// ============================================================================
// 6. 확인완료 (POP55A_INS)
// ============================================================================

/**
 * 확인완료 버튼 클릭
 * - Grid1에서 선택된 행의 workFlag 확인
 * - workFlag == '0' 이면 기본 비고 '확인 완료' 설정
 * - 비고 입력 다이얼로그 오픈
 * - 저장 시 Grid2 전체 행 + 비고를 서버에 POST
 */
function doConfirm() {
    var row = $('#grid1').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', '확인할 행을 선택하세요.');
        return;
    }

    // workFlag == '0' (미확인) 시 기본 비고 설정
    var defaultComment = '';
    if (row.workFlag == '0' || !row.workFlag) {
        defaultComment = '확인 완료';
    } else {
        defaultComment = row.scomment || '';
    }

    // 비고 입력 다이얼로그 열기
    $('#f_scomment').val(defaultComment);
    $('#comment-dialog').dialog('open').dialog('center');
}

/**
 * 비고 다이얼로그 저장 버튼
 * Grid2의 모든 행을 detailRows로 수집하여 서버에 전송
 */
function doCommentSave() {
    var row = $('#grid1').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', 'Grid1에서 행을 선택하세요.');
        return;
    }

    var scomment = $('#f_scomment').val();

    // Grid2의 전체 행 수집
    var grid2Rows = $('#grid2').datagrid('getRows');
    var detailRows = [];
    for (var i = 0; i < grid2Rows.length; i++) {
        detailRows.push({
            fileId: grid2Rows[i].fileId,
            woNo: grid2Rows[i].woNo,
            dataFlag: grid2Rows[i].dataFlag
        });
    }

    $.ajax({
        url: consts.url.POP55A_INS,
        type: 'POST',
        data: JSON.stringify({
            prodCode: row.prodCode,
            scomment: scomment,
            detailRows: detailRows
        }),
        contentType: 'application/json',
        dataType: 'json',
        success: function(result) {
            if (result.success != false) {
                $.messager.alert('알림', '확인 완료되었습니다.');
                $('#comment-dialog').dialog('close');
                doSearch();
            } else {
                $.messager.alert('오류', result.message || '저장 실패', 'error');
            }
        },
        error: function() {
            $.messager.alert('오류', '저장 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 7. 삭제 (POP55A_UDE) - 우클릭 메뉴
// ============================================================================

/**
 * 우클릭 삭제
 * Grid1 선택 행의 prodCode로 삭제 요청
 */
function doDelete() {
    var row = $('#grid1').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', '삭제할 행을 선택하세요.');
        return;
    }

    $.messager.confirm('확인', '선택한 항목을 삭제하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.POP55A_UDE,
                type: 'POST',
                data: {
                    prodCode: row.prodCode
                },
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
// 8. FTP 파일 열기
// ============================================================================

/**
 * FTP 파일 다운로드/열기
 * Grid2의 선택 버튼 클릭 시 호출
 * @param {String} fileId 파일 ID
 */
function doOpenFile(fileId) {
    if (!fileId) return;
    var url = consts.url.FTP_DOWNLOAD + '?fileId=' + encodeURIComponent(fileId) + '&pltCode=' + encodeURIComponent(gconsts.PLT_CODE || '');
    window.open(url, '_blank');
}

// ============================================================================
// 9. 포맷터 (Formatter)
// ============================================================================

/**
 * 체크박스 포맷 (readonly)
 * value '0'/'1' → 체크박스 표시 (클릭 불가)
 */
function formatCheckbox(value) {
    var checked = (value == '1' || value == 'Y') ? 'checked="checked"' : '';
    return '<input type="checkbox" ' + checked + ' disabled="disabled" />';
}

/**
 * S907 코드 포맷 (전동/유압 구분)
 */
function formatS907(value) {
    if (!value && value != 0) return '';
    var items = codeDataMap['S907'] || [];
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd == value) {
            return items[i].codeName || value;
        }
    }
    return value;
}

/**
 * SHORT_DATE 포맷: yyyyMMdd → yyyy-MM-dd
 */
function formatShortDate(value) {
    if (!value) return '';
    var s = String(value).replace(/[-/ ]/g, '');
    if (s.length < 8) return value;
    return s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
}

/**
 * MEDIUM_DATE2 포맷: datetime → yyyy-MM-dd HH:mm
 */
function formatMediumDate2(value) {
    if (!value) return '';
    var s = String(value).replace(/[-:T ]/g, '');
    if (s.length < 8) return value;
    var result = s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
    if (s.length >= 12) {
        result += ' ' + s.substring(8, 10) + ':' + s.substring(10, 12);
    } else if (s.length >= 10) {
        result += ' ' + s.substring(8, 10) + ':00';
    }
    return result;
}

/**
 * Grid2 SEL 버튼 포맷
 * dataFlag == '0' → 클릭 가능한 버튼 표시
 * 그 외 → 빈 값
 */
function formatSelButton(value, row, index) {
    if (row.dataFlag == '0') {
        return '<a href="javascript:void(0)" class="grid-btn grid-btn-blue" onclick="doOpenFile(\'' + (row.fileId || '') + '\')" ' +
               '>&#10003;</a>';
    }
    return '';
}

// ============================================================================
// 10. 유틸리티 함수
// ============================================================================

/**
 * Date → yyyy-MM-dd 문자열 변환
 */
function formatDate(dt) {
    return dt.getFullYear() + '-' + pad2(dt.getMonth() + 1) + '-' + pad2(dt.getDate());
}

/**
 * 2자리 패딩
 */
function pad2(n) {
    return (n < 10 ? '0' : '') + n;
}

/**
 * 로딩바 숨기기 + 메인 레이아웃 표시
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').css('display', '');
}
