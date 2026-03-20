/**
 * ============================================================================
 * 화면: MAT02A - 재고정보 조회
 * ============================================================================
 * 원본: ProActive MAT02A_M0A.cs
 * 작성일: 2026-03-03
 *
 * 주요 기능:
 *   1. 재고정보 조회 (MAT02A_SER)
 *      - 4종 재고: 일반재고(COMM) / 판매오더재고(ORDER) /
 *                  고객 특별재고(CVND) / 공급업체 특별재고(MVND)
 *   2. 타입 멀티 선택 → 선택된 타입만 조회 후 통합 표시
 *   3. 도면 여부(isFile) 기반 도면 버튼 표시
 *
 * AS-IS 검색 조건:
 *   - STOCK_TYPES: CheckedComboBoxEdit (4개 항목)
 *   - PART_LIKE: 자재번호/명 LIKE
 * ============================================================================
 */

// ============================================================================
// 1. consts 객체
// ============================================================================
var consts = {
    url: {
        MAT02A_SER:    getUrl('/imes/mat/mat02a/MAT02A_SER.json'),
        DRAW_FILE_LIST: getUrl('/imes/mat/mat02a/drawFileList.json')
    }
};

// ============================================================================
// 2. 초기화
// ============================================================================
$(function() {
    // 버튼 바인딩
    $('#search-button').bind('click', doSearch);

    // 그리드 초기화
    initGrid();

    // 파일 목록 팝업 초기화 (acFileForm 공통 모듈)
    acFileForm.init();
});

$(window).load(function() {
    // 멀티콤보 기본값: 4개 전체 선택
    // AS-IS: CheckedComboBoxEdit 기본 전체 체크
    setTimeout(function() {
        $('#s_stockTypes').combobox('setValues', ['COMM', 'ORDER', 'CVND', 'MVND']);
    }, 100);

    hideLoadingBar();
    bindEnterKey('s_partLike');
});

// ============================================================================
// 3. 그리드 초기화
// ============================================================================

/**
 * 재고정보 그리드
 *
 * AS-IS: acGridView1 MenuInit
 *   - 타입별로 컬럼 유무가 다르지만 단일 그리드에 통합 표시
 *   - 없는 타입의 컬럼은 NULL로 반환되어 빈 셀로 표시
 */
function initGrid() {
    $('#search-grid').datagrid({
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: true,
        striped: true,
        nowrap: true,
        pagination: true,
        pageSize: 100,
        loadFilter: clientPagerFilter,
        columns: [[
            // AS-IS 순서: STOCK_TYPE(hidden) → IS_FILE(hidden) → DRAW_OPEN → PART_CODE → ...
            {field:'drawOpen',  title:'도면',        width:50,  halign:'center', align:'center', formatter:formatDraw},
            {field:'stockType', title:'재고타입',    width:90,  halign:'center', align:'center'},
            {field:'isFile',    title:'파일여부',    width:0,   halign:'center', align:'center', hidden:true},
            {field:'partCode',  title:'자재번호',    width:120, halign:'center', align:'left'},
            {field:'partName',  title:'자재명',      width:180, halign:'center', align:'left'},
            {field:'plants',    title:'플랜트',      width:80,  halign:'center', align:'left',   hidden:true},
            {field:'bin',       title:'저장빈',      width:100, halign:'center', align:'left'},
            {field:'qty',       title:'가용수량',    width:80,  halign:'center', align:'right',  formatter:formatNumber},
            {field:'qinsFlag',  title:'품질검사',    width:70,  halign:'center', align:'right'},
            {field:'hinsFlag',  title:'보류검사',    width:70,  halign:'center', align:'right'},
            {field:'partUnit',  title:'단위',        width:55,  halign:'center', align:'left'},
            {field:'batchNo',   title:'배치번호',    width:100, halign:'center', align:'left'},
            {field:'stockEmp',  title:'특별지시자',  width:100, halign:'center', align:'left'},
            {field:'orderNo',   title:'판매오더',    width:100, halign:'center', align:'left'},
            {field:'orderLine', title:'품목',        width:55,  halign:'center', align:'left'},
            {field:'cvndCode',  title:'고객처코드',  width:90,  halign:'center', align:'left'},
            {field:'cvndName',  title:'고객처명',    width:130, halign:'center', align:'left'},
            {field:'mvndCode',  title:'공급처코드',  width:90,  halign:'center', align:'left'},
            {field:'mvndName',  title:'공급처명',    width:130, halign:'center', align:'left'}
        ]],
        onLoadSuccess: function(data) {
            $('#search-grid').datagrid('unselectAll');
            $('#search-grid').datagrid('clearSelections');
        }
    });
    GridHeaderMenu('#search-grid', { exportFileName: '재고정보' });
    enableGridSortReset('#search-grid');
}

// ============================================================================
// 4. 조회
// ============================================================================

/**
 * 재고정보 조회
 *
 * AS-IS: Search() 메서드
 *   1. 타입 선택 유효성 검사
 *   2. 파라미터 구성 (STOCK_TYPES, PART_LIKE)
 *   3. MAT02A_SER 서비스 호출
 *   4. 결과 그리드 표시
 */
function doSearch() {
    var stockValues = $('#s_stockTypes').combobox('getValues');

    if (!stockValues || stockValues.length === 0) {
        $.messager.alert('알림', '타입을 하나 이상 선택하세요.', 'warning');
        return;
    }

    var params = {
        stockTypes: stockValues.join(','),
        partLike:   $('#s_partLike').textbox('getValue')
    };

    $('#search-grid').datagrid('loading');

    $.ajax({
        url: consts.url.MAT02A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            var opts = $('#search-grid').datagrid('options');
            opts.pageNumber = 1;
            $('#search-grid').datagrid('loadData', rows);
            $('#search-grid').datagrid('loaded');
        },
        error: function() {
            $('#search-grid').datagrid('loaded');
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.');
        }
    });
}

// ============================================================================
// 5. 포맷터 함수
// ============================================================================

/**
 * 도면 버튼 포맷터
 * AS-IS: RepositoryItemButtonEdit + glyphicons_halflings_13_ok2x (Navy ✓ 아이콘)
 *   - isFile='1': 버튼 활성(Navy ✓), 클릭 가능
 *   - isFile='0': 버튼 비활성(회색 ✓), 클릭 불가
 */
function formatDraw(val, row) {
    if (row.isFile === '1') {
        return '<a href="javascript:void(0)" class="grid-btn grid-btn-blue"'
             + ' onclick="openDraw(\'' + row.partCode + '\')" title="도면 열기">&#10003;</a>';
    }
    return '<span class="grid-btn grid-btn-off" title="도면 없음">없음</span>';
}

/**
 * 숫자 포맷 (천단위 콤마)
 */
function formatNumber(value, row, index) {
    if (value == null || value === '') return '';
    var num = parseFloat(value);
    if (isNaN(num)) return value;
    return num.toLocaleString();
}

// ============================================================================
// 6. 도면 열기
// ============================================================================

/**
 * 도면 파일 목록 조회 후 다운로드
 * AS-IS: DrawOpen_ButtonClick
 *   1. POP30A_SER16 호출 → IF_PLM_FILE_INFO(CAT_CODE='2', ORD_NO=PART_CODE) 조회
 *   2. 파일 0개 → "도면이 없습니다."
 *   3. 파일 1개 → 팝업 없이 바로 다운로드
 *   4. 파일 2개↑ → acFileForm 팝업으로 목록 표시 (선택 시 다운로드)
 */
function openDraw(partCode) {
    $.ajax({
        url: consts.url.DRAW_FILE_LIST,
        type: 'POST',
        data: { partCode: partCode },
        dataType: 'json',
        success: function(result) {
            var files = result.rows || [];

            if (files.length === 0) {
                $.messager.alert('도면', '도면이 없습니다.', 'info');
                return;
            }

            if (files.length === 1) {
                // 1개: 팝업 없이 바로 다운로드
                acFileForm.downloadFile(files[0].fileName, partCode);
                return;
            }

            // 2개 이상: 파일 선택 팝업
            acFileForm.open({ rows: files, partCode: partCode });
        },
        error: function() {
            $.messager.alert('오류', '도면 파일 조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 7. (clientPagerFilter → lsCommon.js 공통 함수로 이동)
// ============================================================================

// ============================================================================
// 8. 유틸리티 함수
// ============================================================================

/**
 * 로딩바 숨김 + 레이아웃 표시
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').css('display', '');
}

/**
 * Enter 키 바인딩 (검색 필드)
 */
function bindEnterKey(id) {
    $('#' + id).textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#' + id).textbox('setValue', $(this).val());
            doSearch();
        }
    });
}
