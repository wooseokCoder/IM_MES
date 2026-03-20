/**
 * ============================================================================
 * 화면: ORD14A - 실적관리 가공
 * ============================================================================
 * 원본: ProActive ORD14A_M0A.cs
 * 작성일: 2026-03-06
 *
 * 주요 기능:
 *   1. 작업지시 목록 조회 (ORD14A_SER) - 상단 그리드
 *   2. 실적 상세 조회 (ORD14A_SER2) - 하단 그리드 (Master-Detail)
 *
 * 그리드 배치: MAT05A Tab1 좌우분할 → 상하분할 변형
 *   - 상단(grid1): 작업지시 목록 (MAT05A grid1 역할)
 *   - 하단(grid2): 실적 상세 (MAT05A grid2 역할)
 *   - 첫 행 자동선택 → 디테일 자동로드 (MAT05A 패턴)
 *
 * 검색조건: MAT05A 패턴 (멀티셀렉 콤보 일자구분)
 *   AS-IS: acCheckedComboBoxEdit1 (생산계획일)
 *   TO-BE: easyui-combobox multiple:true
 *
 * LookUp 코드:
 *   S032 - woFlag   (작업지시 상태)
 *   S034 - procStat (공정 진행상태)
 *   S044 - isPreWork (작업준비 여부)
 *   S045 - panelStat (재작업 여부)
 *
 * 날짜 포맷: yyyy-MM-dd HH:mm (MEDIUM_DATE2)
 * ============================================================================
 */

// ============================================================================
// 1. 전역 변수 / consts 객체
// ============================================================================
var codeDataMap = {};  // 코드 데이터 캐시
var USE_PAGING = false; // 상단 그리드 페이징 사용 여부 (true: 페이징, false: 전체표시)

var consts = {
    url: {
        ORD14A_SER:  getUrl('/imes/ord/ord14a/ORD14A_SER.json'),
        ORD14A_SER2: getUrl('/imes/ord/ord14a/ORD14A_SER2.json'),
        CODE_LIST:   getUrl('/common/code/code.json')
    },

    // 코드 데이터 동기 로드 (MAT05A 패턴)
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

    // 초기화: 코드 데이터 로드 + 버튼 바인딩 + 그리드 초기화
    init: function() {
        // (1) 코드 로드
        consts.codeData = {};
        consts.codeData.S032 = this.loadCode('S032');  // 작업지시 상태
        consts.codeData.S034 = this.loadCode('S034');  // 공정 진행상태
        consts.codeData.S044 = this.loadCode('S044');  // 작업준비 여부
        consts.codeData.S045 = this.loadCode('S045');  // 재작업 여부

        // (2) 버튼 바인딩
        $('#search-button').bind('click', doSearch);

        // (3) 그리드 초기화
        initGrid1();
        initGrid2();
    }
};

// ============================================================================
// 2. 초기화
// ============================================================================
$(function() {
    consts.init();
});

$(window).load(function() {
    // AS-IS 기본값: 오늘 -7일 ~ 오늘
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);

    $('#s_startDate').datebox('setValue', formatDate(weekAgo));
    $('#s_endDate').datebox('setValue', formatDate(today));

    // AS-IS: acCheckedComboBoxEdit1 기본값 PLN_DATE 선택
    setTimeout(function() {
        $('#s_dateType').combobox('setValues', ['PLN_DATE']);
    }, 100);

    hideLoadingBar();
    bindEnterKey('s_orderLike');
    bindEnterKey('s_procLike');
});

// ============================================================================
// 3. 그리드 초기화
// ============================================================================

/**
 * 상단 그리드: 작업지시 목록
 * AS-IS: acGridView1 (TSHP_WORKORDER_QUERY12)
 * MAT05A grid1 패턴: pagination + 첫 행 자동선택 → 디테일 자동로드
 */
function initGrid1(colWidths) {
    colWidths = colWidths || {};
    $('#grid1').datagrid({
        fit: true,
        fitColumns: false,
        border: false,
        singleSelect: true,
        rownumbers: true,
        striped: true,
        nowrap: true,
        pagination: USE_PAGING,
        pageSize: USE_PAGING ? 100 : undefined,
        loadFilter: USE_PAGING ? clientPagerFilter : undefined,
        onSelect: function(index, row) {
            doDetail(row.woNo);
        },
        columns: [[
            {field:'woFlag',       title:'상태',             width:colWidths['woFlag']       || 60,  halign:'center', align:'center', formatter: function(v) { return _codeName(consts.codeData.S032, v); }},
            {field:'sapWoNo',      title:'생산오더',         width:colWidths['sapWoNo']      || 110, halign:'center', align:'center'},
            {field:'partCode',     title:'품목코드',         width:colWidths['partCode']     || 100, halign:'center', align:'center'},
            {field:'partName',     title:'품목명',           width:colWidths['partName']     || 150, halign:'center', align:'center'},
            {field:'procCode',     title:'공정',             width:colWidths['procCode']     || 70,  halign:'center', align:'center'},
            {field:'mcCode',       title:'자원코드',         width:colWidths['mcCode']       || 80,  halign:'center', align:'center'},
            {field:'mcName',       title:'자원명',           width:colWidths['mcName']       || 120, halign:'center', align:'center'},
            {field:'actMcCode',    title:'최근진행자원코드', width:colWidths['actMcCode']    || 110, halign:'center', align:'center'},
            {field:'actMcName',    title:'최근진행자원명',   width:colWidths['actMcName']    || 120, halign:'center', align:'center'},
            {field:'actEmpCode',   title:'최근진행작업자코드', width:colWidths['actEmpCode'] || 120, halign:'center', align:'center'},
            {field:'actEmpName',   title:'최근진행작업자명', width:colWidths['actEmpName']   || 110, halign:'center', align:'center'},
            {field:'plnStartTime', title:'계획시작시간',     width:colWidths['plnStartTime'] || 120, halign:'center', align:'center', formatter: formatDateTime},
            {field:'plnEndTime',   title:'계획종료시간',     width:colWidths['plnEndTime']   || 120, halign:'center', align:'center', formatter: formatDateTime},
            {field:'actStartTime', title:'실적시작시간',     width:colWidths['actStartTime'] || 120, halign:'center', align:'center', formatter: formatDateTime},
            {field:'actEndTime',   title:'실적종료시간',     width:colWidths['actEndTime']   || 120, halign:'center', align:'center', formatter: formatDateTime},
            {field:'workContents', title:'작업내용',         width:colWidths['workContents'] || 200, halign:'center', align:'center'},
            {field:'woNo',         title:'WO_NO',            width:0,   hidden:true}
        ]],
        onLoadSuccess: function(data) {
            $(this).datagrid('getPanel').find('.datagrid-body').scrollTop(0);
            // ORD13A 패턴: CSS width:100% → auto 오버라이드
            var panel = $('#grid1').datagrid('getPanel');
            panel.find('.datagrid-header table, .datagrid-body table').css('width', 'auto');
            // 첫 행 자동 선택 → 디테일 자동로드
            var rows = data.rows || [];
            if (rows.length > 0) {
                $('#grid1').datagrid('selectRow', 0);
            } else {
                $('#grid2').datagrid('loadData', []);
            }
        }
    });
    GridHeaderMenu('#grid1', { exportFileName: '실적관리_공정별' });
    enableGridSortReset('#grid1');
}

/**
 * 하단 그리드: 실적 상세
 * AS-IS: acGridView2 (TSHP_ACTUAL_QUERY6)
 */
function initGrid2() {
    $('#grid2').datagrid({
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: true,
        striped: true,
        nowrap: true,
        columns: [[
            {field:'procStat',     title:'상태',         width:70,  halign:'center', align:'center', formatter: function(v) { return _codeName(consts.codeData.S034, v); }},
            {field:'isPreWork',    title:'작업준비',     width:70,  halign:'center', align:'center', formatter: function(v) { return _codeName(consts.codeData.S044, v); }},
            {field:'panelStat',    title:'재작업여부',   width:80,  halign:'center', align:'center', formatter: function(v) { return _codeName(consts.codeData.S045, v); }},
            {field:'workDate',     title:'작업일',       width:90,  halign:'center', align:'center', formatter: formatDateOnly},
            {field:'empCode',      title:'작업자코드',   width:80,  halign:'center', align:'center'},
            {field:'empName',      title:'작업자명',     width:90,  halign:'center', align:'center'},
            {field:'actStartTime', title:'실적시작시간', width:120, halign:'center', align:'center', formatter: formatDateTime},
            {field:'actEndTime',   title:'실적종료시간', width:120, halign:'center', align:'center', formatter: formatDateTime},
            {field:'actTime',      title:'실적시간(분)', width:90,  halign:'center', align:'center',  formatter: formatNumber},
            {field:'actualId',     title:'실적ID',       width:0,   hidden:true}
        ]],
        onLoadSuccess: function() {
            $('#grid2').datagrid('unselectAll');
            $('#grid2').datagrid('clearSelections');
        }
    });
    GridHeaderMenu('#grid2', { exportFileName: '실적관리_실적현황' });
    enableGridSortReset('#grid2');
}

// ============================================================================
// 4. 조회
// ============================================================================

/**
 * 작업지시 목록 조회
 *
 * AS-IS: Search() → ORD14A_SER 호출
 * 검색조건 패턴: MAT05A doSearch() 동일
 *   - 멀티콤보에서 선택된 일자구분에 따라 날짜 파라미터 매핑
 *   - 선택된 일자가 있으면 날짜 필수
 *   - 선택 안 하면 전체 조회
 */
function doSearch() {
    var sDate = $('#s_startDate').datebox('getValue');
    var eDate = $('#s_endDate').datebox('getValue');
    var dateTypes = $('#s_dateType').combobox('getValues') || [];

    // 일자구분 선택 시 날짜 필수 검증 (MAT05A 패턴)
    if (dateTypes.length > 0 && (!sDate || !eDate)) {
        $.messager.alert('알림', '일자를 선택해주세요.');
        return;
    }

    var sDateFmt = sDate ? sDate.replace(/-/g, '') : '';
    var eDateFmt = eDate ? eDate.replace(/-/g, '') : '';

    var params = {
        orderLike: $('#s_orderLike').textbox('getValue'),
        procLike:  $('#s_procLike').textbox('getValue')
    };

    // 멀티체크: 선택된 일자구분에 대해 날짜조건 적용 (MAT05A 패턴)
    for (var i = 0; i < dateTypes.length; i++) {
        var dt = dateTypes[i];
        if (dt === 'PLN_DATE') {
            params.sPlnDate = sDateFmt;
            params.ePlnDate = eDateFmt;
        }
    }

    $('#grid1').datagrid('loading');

    $.ajax({
        url: consts.url.ORD14A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            // ORD13A 패턴: 데이터 기반 컬럼 너비 계산 → 그리드 재생성
            var colWidths = calcColumnWidths(rows);
            initGrid1(colWidths);
            $('#grid1').datagrid('loadData', rows);
            $('#grid1').datagrid('loaded');
        },
        error: function() {
            $('#grid1').datagrid('loaded');
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.');
        }
    });
}

/**
 * 실적 상세 조회 (Master-Detail)
 * AS-IS: grid1 FocusedRowChanged → GetDetail() → ORD14A_SER2 호출
 */
function doDetail(woNo) {
    if (!woNo) {
        $('#grid2').datagrid('loadData', []);
        return;
    }

    $('#grid2').datagrid('loading');

    $.ajax({
        url: consts.url.ORD14A_SER2,
        type: 'POST',
        data: { woNo: woNo },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#grid2').datagrid('loadData', rows);
            $('#grid2').datagrid('loaded');
        },
        error: function() {
            $('#grid2').datagrid('loaded');
            $.messager.alert('오류', '실적 조회 중 오류가 발생했습니다.');
        }
    });
}

// ============================================================================
// 5. 포맷터 함수
// ============================================================================

/**
 * 코드 데이터에서 codeCd로 codeName 반환
 */
function _codeName(codeData, value) {
    if (!codeData || value == null || value === '') return '';
    var strVal = String(value);
    for (var i = 0; i < codeData.length; i++) {
        if (String(codeData[i].codeCd) === strVal) return codeData[i].codeName;
    }
    return value;
}

/**
 * 날짜+시간 포맷 (yyyy-MM-dd HH:mm)
 * DB 값: DATETIME 또는 VARCHAR(12) yyyyMMddHHmm
 */
function formatDateTime(value) {
    if (!value) return '';
    var s = String(value).replace(/[-: T]/g, '');
    if (s.length >= 12) {
        return s.substring(0,4) + '-' + s.substring(4,6) + '-' + s.substring(6,8)
             + ' ' + s.substring(8,10) + ':' + s.substring(10,12);
    }
    if (s.length >= 8) {
        return s.substring(0,4) + '-' + s.substring(4,6) + '-' + s.substring(6,8);
    }
    return value;
}

/**
 * 날짜만 포맷 (yyyy-MM-dd)
 * DB 값: VARCHAR(8) yyyyMMdd
 */
function formatDateOnly(value) {
    if (!value) return '';
    var s = String(value).replace(/-/g, '');
    if (s.length >= 8) {
        return s.substring(0,4) + '-' + s.substring(4,6) + '-' + s.substring(6,8);
    }
    return value;
}

/**
 * 숫자 포맷 (천단위 콤마)
 */
function formatNumber(value) {
    if (value == null || value === '') return '';
    var num = parseFloat(value);
    if (isNaN(num)) return value;
    return num.toLocaleString();
}

// ============================================================================
// 6. (clientPagerFilter → lsCommon.js 공통 함수로 이동)
// ============================================================================

// ============================================================================
// 7. 유틸리티 함수
// ============================================================================

/**
 * Date 객체 → yyyy-MM-dd 문자열
 */
function formatDate(d) {
    var year  = d.getFullYear();
    var month = ('0' + (d.getMonth() + 1)).slice(-2);
    var day   = ('0' + d.getDate()).slice(-2);
    return year + '-' + month + '-' + day;
}

/**
 * 로딩바 숨김 + 레이아웃 표시
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').css('display', '');
}

/**
 * 데이터 기반 컬럼 너비 계산 (ORD13A calcColumnWidths 패턴)
 * - 헤더(bold) + 데이터(normal) 텍스트 너비 측정
 * - 반환값: { field: px, ... }
 */
function calcColumnWidths(data) {
    var widths = {};
    var $ruler = $('<span></span>').css({
        visibility: 'hidden', position: 'absolute',
        whiteSpace: 'nowrap', fontSize: '14px'
    }).appendTo('body');

    var cols = [
        {field:'woFlag',       title:'상태',             min:50},
        {field:'sapWoNo',      title:'생산오더',         min:80},
        {field:'partCode',     title:'품목코드',         min:80},
        {field:'partName',     title:'품목명',           min:80},
        {field:'procCode',     title:'공정',             min:50},
        {field:'mcCode',       title:'자원코드',         min:60},
        {field:'mcName',       title:'자원명',           min:80},
        {field:'actMcCode',    title:'최근진행자원코드', min:80},
        {field:'actMcName',    title:'최근진행자원명',   min:80},
        {field:'actEmpCode',   title:'최근진행작업자코드', min:80},
        {field:'actEmpName',   title:'최근진행작업자명', min:80},
        {field:'plnStartTime', title:'계획시작시간',     min:100},
        {field:'plnEndTime',   title:'계획종료시간',     min:100},
        {field:'actStartTime', title:'실적시작시간',     min:100},
        {field:'actEndTime',   title:'실적종료시간',     min:100},
        {field:'workContents', title:'작업내용',         min:80}
    ];

    for (var c = 0; c < cols.length; c++) {
        var field = cols[c].field;

        // 헤더 너비 (bold)
        $ruler.css('fontWeight', '700').text(cols[c].title);
        var maxW = $ruler.outerWidth() + 24;

        // 데이터 너비 (normal) — 전체 행 대상
        $ruler.css('fontWeight', 'normal');
        for (var i = 0; i < data.length; i++) {
            var val = data[i][field];
            if (val != null && String(val) !== '') {
                $ruler.text(String(val));
                var w = $ruler.outerWidth() + 16;
                if (w > maxW) maxW = w;
            }
        }

        widths[field] = Math.max(maxW, cols[c].min);
    }

    $ruler.remove();
    return widths;
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
