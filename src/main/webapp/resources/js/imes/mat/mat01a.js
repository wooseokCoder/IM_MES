/**
 * ============================================================================
 * 화면: MAT01A - 과부족정보 조회
 * ============================================================================
 * 원본: ProActive MAT01A_M0A.cs
 * 작성일: 2026-03-03
 *
 * 주요 기능:
 *   1. 과부족정보 조회 (MAT01A_SER → TSAP_MORE_LESS_QUERY2)
 *   2. 리스트 탭: 전체 조회 결과 그리드 표시
 *   3. 피벗 탭: LASS_F < 0 (부족) 항목만 공급처/부품별 요약
 *
 * AS-IS 검색 조건:
 *   - ORDER_LIKE: 판매오더 (LIKE)
 *   - PART_LIKE: 구성부품 (LIKE)
 *   - S_INDUE_DATE / E_INDUE_DATE: 생산완료일(계획) 주간 범위
 *   - PLANTS: 공장 코드 (IN)
 *
 * AS-IS 결과 처리 (QuickSearch):
 *   - 리스트 탭: 전체 결과
 *   - 피벗 탭: LASS_F < 0 AND (MVND_NAME IS NOT NULL OR MVND_NAME <> '')
 *     → 해당 조건 만족하는 행이 있으면 해당 행만, 없으면 전체 결과 표시
 * ============================================================================
 */

// ============================================================================
// 1. 전역 변수
// ============================================================================
var codeDataMap = {};
var _searchAllRows = [];  // 전체 조회 결과 보관 (피벗 집계용)

// ============================================================================
// 2. consts 객체
// ============================================================================
var consts = {
    url: {
        MAT01A_SER: getUrl('/imes/mat/mat01a/MAT01A_SER.json'),
        CODE_LIST:  getUrl('/common/code/code.json')
    },

    /**
     * 공통 코드 동기 로드
     */
    loadCode: function(codeGrup) {
        if (codeDataMap[codeGrup]) return codeDataMap[codeGrup];
        var items = [];
        $.ajax({
            url: this.url.CODE_LIST,
            type: 'POST',
            data: {codeGrup: codeGrup},
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
        // 버튼 바인딩
        $('#search-button').bind('click', doSearch);

        // 공장 코드(P009) 콤보 초기화
        var plantData = this.loadCode('P009');
        var comboData = [];
        for (var i = 0; i < plantData.length; i++) {
            comboData.push({codeCd: plantData[i].codeCd, codeName: plantData[i].codeName});
        }
        $('#s_plants').combobox({
            data: comboData,
            valueField: 'codeCd',
            textField: 'codeName',
            value: comboData.length > 0 ? comboData[0].codeCd : ''
        });

        // 그리드 초기화
        initGrid();
        initPivotGrid();
        
    }
};

// ============================================================================
// 3. 초기화
// ============================================================================
$(function() {
    consts.init();
});

$(window).load(function() {
    // EasyUI 파싱 완료 후 acWeekDate 초기화
    acWeekDate.init({
        prefix: 'wd1',
        mode: 'WEEK',
        onPrev: doSearch,
        onNext: doSearch
    });

    hideLoadingBar();
    bindEnterKey('s_orderLike');
    bindEnterKey('s_partLike');
});

// ============================================================================
// 5. 그리드 초기화
// ============================================================================

/**
 * 리스트 탭 그리드 (AS-IS: acGridView1 MenuInit 46개 컬럼)
 *
 * AS-IS 컬럼 순서/타입/정렬을 그대로 반영:
 *   - TextEdit + Center → align:'center'
 *   - TextEdit + Near → align:'left'
 *   - TextEdit + Far + QTY → align:'right', formatNumber
 *   - DateEdit + SHORT_DATE → align:'center'
 *   - LookUpEdit(P009) → formatter: formatPlants
 *   - 모든 컬럼: allowEdit=false (읽기 전용)
 *
 * AS-IS 그리드 옵션:
 *   - AllowCellMerge = true
 *   - ShowGroupPanel = false
 *   - ShowIndicator = false
 *   - RowAutoHeight = true
 *   - ColumnPanelRowHeight = 25
 *   - RowHeight = 25
 */
function initGrid() {
    $('#search-grid').datagrid({
        fit: true,
        fitColumns: false,
        border: false,
        singleSelect: true,
        rownumbers: true,
        striped: true,
        nowrap: true,
        pagination: true,
        pageSize: 100,
        loadFilter: clientPagerFilter,
        columns: [[
            // --- 기본 정보 ---
            {field:'orderNo',       title:'판매오더',        width:90,  halign:'center', align:'center'},
            {field:'orderLine',     title:'품목',            width:50,  halign:'center', align:'center'},
            {field:'plants',        title:'공장',            width:60,  halign:'center', align:'center', formatter:formatPlants},
            {field:'gubun',         title:'구분',            width:60,  halign:'center', align:'center'},
            {field:'lassType',      title:'유형',            width:60,  halign:'center', align:'center'},
            {field:'model',         title:'모델구분',        width:70,  halign:'center', align:'center'},
            {field:'hogi',          title:'호기',            width:60,  halign:'center', align:'center'},
            // --- 고객 정보 ---
            {field:'cvndCode',      title:'고객코드',        width:80,  halign:'center', align:'center'},
            {field:'cvndName',      title:'고객명',          width:120, halign:'center', align:'left'},
            // --- 납기 정보 ---
            {field:'ordDate',       title:'수주일',          width:90,  halign:'center', align:'center', formatter:formatShortDate},
            {field:'indueDate',     title:'생산완료일(계획)',  width:100, halign:'center', align:'center', formatter:formatShortDate},
            {field:'dueDate',       title:'고객납기일',       width:90,  halign:'center', align:'center', formatter:formatShortDate},
            {field:'planMonth',     title:'년월',            width:70,  halign:'center', align:'center', formatter:formatMonthDate},
            {field:'assyDate',      title:'총조립예정일',     width:100, halign:'center', align:'center', formatter:formatShortDate},
            {field:'subDate',       title:'SUB일자',         width:90,  halign:'center', align:'center', formatter:formatShortDate},
            // --- 제품 정보 ---
            {field:'partName',      title:'제품명',          width:150, halign:'center', align:'left'},
            {field:'sapWoNo',       title:'오더번호',        width:100, halign:'center', align:'center'},
            {field:'banPartCode',   title:'반제품코드',      width:90,  halign:'center', align:'center'},
            {field:'banPartName',   title:'반제품명',        width:150, halign:'center', align:'left'},
            // --- 담당자 정보 ---
            {field:'mrpEmp',        title:'MRP관리자',       width:80,  halign:'center', align:'center'},
            {field:'mrpEmpName',    title:'MRP관리자명',     width:100, halign:'center', align:'center'},
            {field:'partSpec',      title:'구성부품',        width:100, halign:'center', align:'center'},
            {field:'prjName',       title:'전체품명',        width:150, halign:'center', align:'left'},
            // --- 창고/재고 ---
            {field:'bin',           title:'저장빈',          width:80,  halign:'center', align:'left'},
            {field:'totQty',        title:'총소요량',        width:80,  halign:'center', align:'right', formatter:formatNumber},
            {field:'shipQty',       title:'출고수량',        width:80,  halign:'center', align:'right', formatter:formatNumber},
            {field:'useQty',        title:'소요량',          width:80,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkUseQty',     title:'가용재고',        width:80,  halign:'center', align:'right', formatter:formatNumber},
            // --- 과부족 ---
            {field:'lassF',         title:'1차 과부족',      width:90,  halign:'center', align:'right', formatter:formatLassF},
            {field:'lassFCause',    title:'1차 과부족문제',   width:100, halign:'center', align:'center'},
            // --- 공급처 ---
            {field:'mvndCode',      title:'구성부품공급처',   width:100, halign:'center', align:'center'},
            {field:'mvndName',      title:'구성부품공급처명', width:130, halign:'center', align:'left'},
            // --- 공정 ---
            {field:'procName',      title:'공정구분',        width:80,  halign:'center', align:'center'},
            {field:'procCode',      title:'공정',            width:60,  halign:'center', align:'center'},
            // --- 입고 ---
            {field:'ypgoPlanQty',   title:'입고예정량',      width:80,  halign:'center', align:'right', formatter:formatNumber},
            {field:'ypgoPlanDate',  title:'입고예정일',      width:90,  halign:'center', align:'center', formatter:formatShortDate},
            // --- 재고 합계 ---
            {field:'stkVndQty',     title:'업체재고',        width:80,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkSumQty',     title:'재고합계',        width:80,  halign:'center', align:'right', formatter:formatNumber},
            {field:'planDueDate',   title:'계산납입요청일',   width:100, halign:'center', align:'center', formatter:formatShortDate},
            // --- 특수 재고 ---
            {field:'stkNonQty',     title:'보세재고',        width:80,  halign:'center', align:'right', formatter:formatNumber},
            {field:'inBoundQty',    title:'인바운드',        width:80,  halign:'center', align:'right', formatter:formatNumber},
            // --- 미발주/미입고 ---
            {field:'noBalQty',      title:'미발주',          width:80,  halign:'center', align:'right', formatter:formatNumber},
            {field:'noInQty',       title:'미입고',          width:80,  halign:'center', align:'right', formatter:formatNumber},
            // --- 담당자/사급처 ---
            {field:'partEmp',       title:'담당자',          width:80,  halign:'center', align:'center'},
            {field:'supplyVnd',     title:'사급공급처',      width:90,  halign:'center', align:'center'},
            {field:'supplyVndName', title:'사급공급처명',    width:100, halign:'center', align:'center'}
        ]],
        onLoadSuccess: function(data) {
            $('#search-grid').datagrid('unselectAll');
            $('#search-grid').datagrid('clearSelections');
        }
    });
    GridHeaderMenu('#search-grid', { exportFileName: '과부족정보' });
    enableGridSortReset('#search-grid');
}

/**
 * 피벗 탭 그리드 (트리 형태 요약)
 *
 * AS-IS: acPivotGridControl1
 *   Row Area: MVND_NAME (구성부품공급처명) → PART_SPEC (구성부품) → PRJ_NAME (전체품명)
 *   Data Area: LASS_F (1차 과부족) - SUM 집계
 *   ShowRowTotals = false
 *
 * TO-BE: EasyUI treegrid로 구현
 *   - 공급처명 최상위 노드 (접고 펼치기 가능)
 *   - 구성부품코드 + 전체품명 자식 노드
 */
function initPivotGrid() {
    $('#pivot-grid').treegrid({
        fit: true,
        fitColumns: false,
        border: false,
        singleSelect: true,
        nowrap: true,
        idField: 'nodeId',
        treeField: 'mvndName',
        onLoadSuccess: function(data) {
        	
        },
        columns: [[
            {field:'mvndName',  title:'구성부품공급처명', width:200, halign:'center', align:'left'},
            {field:'partSpec',  title:'구성부품',        width:130, halign:'center', align:'center'},
            {field:'prjName',   title:'전체품명',        width:300, halign:'center', align:'left'},
            {field:'lassF',     title:'1차 과부족 합계',  width:120, halign:'center', align:'right', formatter:formatLassF}
        ]]
    });
    GridHeaderMenu('#pivot-grid', { type: 'treegrid', exportFileName: '과부족정보_피벗' });
}


// ============================================================================
// 6. 조회
// ============================================================================

/**
 * 과부족정보 조회
 *
 * AS-IS: Search() 메서드
 *   1. acLayoutControl1.ValidCheck()
 *   2. 파라미터 구성 (PLT_CODE, ORDER_LIKE, PART_LIKE, S_INDUE_DATE, E_INDUE_DATE, PLANTS)
 *   3. MAT01A_SER 서비스 호출
 *   4. QuickSearch 콜백으로 리스트/피벗 탭 데이터 설정
 */
function doSearch() {
    var sDate = acWeekDate.getStartDate('wd1');
    var eDate = acWeekDate.getEndDate('wd1');

    if (!sDate || !eDate) {
        $.messager.alert('알림', '생산완료일(계획)을 선택해주세요.');
        return;
    }

    // AS-IS 파라미터: S_INDUE_DATE=yyyyMMdd, E_INDUE_DATE=yyyyMMdd
    var params = {
        orderLike:  $('#s_orderLike').textbox('getValue'),
        partLike:   $('#s_partLike').textbox('getValue'),
        sIndueDate: sDate.replace(/-/g, ''),
        eIndueDate: eDate.replace(/-/g, ''),
        plants:     $('#s_plants').combobox('getValue')
    };

    $('#search-grid').datagrid('loading');
    $('#pivot-grid').treegrid('loading');

    $.ajax({
        url: consts.url.MAT01A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];

            // 전체 결과 보관 (피벗 집계용)
            _searchAllRows = rows;

            // 리스트 탭: 클라이언트 페이징으로 표시
            var opts = $('#search-grid').datagrid('options');
            opts.pageNumber = 1;
            $('#search-grid').datagrid('loadData', rows);
            $('#search-grid').datagrid('loaded');

            // 피벗 탭: AS-IS 로직 그대로 반영
            var filteredRows = [];
            for (var i = 0; i < _searchAllRows.length; i++) {
                var lf = parseInt(_searchAllRows[i].lassF);
                var mn = _searchAllRows[i].mvndName;
                if (lf < 0 && mn != null && mn !== '') {
                    filteredRows.push(_searchAllRows[i]);
                }
            }

            var pivotSource = (filteredRows.length > 0) ? filteredRows : _searchAllRows;
            var pivotResult = buildPivotData(pivotSource);
            $('#pivot-grid').treegrid('loadData', pivotResult.rows);
            $('#pivot-grid').treegrid('loaded');
        },
        error: function() {
            $('#search-grid').datagrid('loaded');
            $('#pivot-grid').treegrid('loaded');
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.');
        }
    });
}

/**
 * 피벗 데이터 집계 → EasyUI treegrid 데이터 구조
 *
 * AS-IS PivotGrid Row Area: MVND_NAME → PART_SPEC → PRJ_NAME
 * AS-IS Data Area: LASS_F (SUM), ShowRowTotals = false
 *
 * 구조:
 *   부모 행: 공급처명 (lassF = 해당 공급처 합계)
 *   자식 행: 구성부품코드 + 전체품명 (개별 lassF 합계)
 */
function buildPivotData(rows) {
    var grandTotal = 0;
    var vendorMap = {};
    var vendorOrder = [];

    for (var i = 0; i < rows.length; i++) {
        var r = rows[i];
        var vnd  = r.mvndName || '';
        var part = r.partSpec || '';
        var prj  = r.prjName  || '';
        var v    = parseInt(r.lassF) || 0;

        grandTotal += v;

        if (!vendorMap[vnd]) {
            vendorMap[vnd] = { total: 0, itemMap: {}, itemOrder: [] };
            vendorOrder.push(vnd);
        }

        var itemKey = part + '\x00' + prj;
        if (!vendorMap[vnd].itemMap[itemKey]) {
            vendorMap[vnd].itemMap[itemKey] = { partSpec: part, prjName: prj, lassF: 0 };
            vendorMap[vnd].itemOrder.push(itemKey);
        }
        vendorMap[vnd].itemMap[itemKey].lassF += v;
        vendorMap[vnd].total += v;
    }

    // 공급처명 정렬
    vendorOrder.sort(function(a, b) { return a.localeCompare(b); });

    var result = [];
    var idCounter = 1;

    for (var vi = 0; vi < vendorOrder.length; vi++) {
        var vndName = vendorOrder[vi];
        var vndData = vendorMap[vndName];
        var parentNodeId = 'N_' + (idCounter++);

        // 구성부품코드 정렬
        vndData.itemOrder.sort(function(a, b) { return a.localeCompare(b); });

        var children = [];
        for (var ii = 0; ii < vndData.itemOrder.length; ii++) {
            var item = vndData.itemMap[vndData.itemOrder[ii]];
            children.push({
                nodeId:   'N_' + (idCounter++),
                mvndName: '',
                partSpec: item.partSpec,
                prjName:  item.prjName,
                lassF:    item.lassF
            });
        }

        result.push({
            nodeId:   parentNodeId,
            mvndName: vndName,
            partSpec: '',
            prjName:  '',
            lassF:    '',
            children: children
        });
    }

    // 총합계 행 (leaf 노드로 마지막에 추가)
    result.push({
        nodeId:   'N_total',
        mvndName: '총합계',
        partSpec: '',
        prjName:  '',
        lassF:    grandTotal
    });

    return { rows: result };
}

// ============================================================================
// 7. 포맷터 함수
// ============================================================================

/**
 * 공장 코드 → 공장명 변환
 * AS-IS: acGridView1.AddLookUpEdit("PLANTS", "공장", ..., "P009")
 */
function formatPlants(value, row, index) {
    if (!value) return '';
    var items = consts.loadCode('P009');
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd == value) return items[i].codeName;
    }
    return value;
}

/**
 * 숫자 포맷 (천단위 콤마)
 * AS-IS: emTextEditMask.QTY
 */
function formatNumber(value, row, index) {
    if (value == null || value === '') return '';
    var num = parseFloat(value);
    if (isNaN(num)) return value;
    return num.toLocaleString();
}

/**
 * 날짜 포맷 (yyyy-MM-dd)
 * AS-IS: DateEdit SHORT_DATE
 * DB에서 'YYYYMMDD' 또는 'YYYY-MM-DD' 또는 Date 객체로 올 수 있음
 */
function formatShortDate(value, row, index) {
    if (value == null || value === '') return '';
    var s = String(value).replace(/T.*$/, '').trim();
    // 이미 yyyy-MM-dd 형태
    if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s;
    // yyyyMMdd → yyyy-MM-dd
    if (/^\d{8}$/.test(s)) return s.substr(0, 4) + '-' + s.substr(4, 2) + '-' + s.substr(6, 2);
    return s;
}

/**
 * 년월 포맷 (yyyy-MM)
 * AS-IS: DateEdit MONTH_DATE
 */
function formatMonthDate(value, row, index) {
    if (value == null || value === '') return '';
    var s = String(value).replace(/T.*$/, '').trim();
    // 이미 yyyy-MM 형태
    if (/^\d{4}-\d{2}$/.test(s)) return s;
    // yyyyMM → yyyy-MM
    if (/^\d{6}$/.test(s)) return s.substr(0, 4) + '-' + s.substr(4, 2);
    // yyyy-MM-dd → yyyy-MM
    if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s.substr(0, 7);
    // yyyyMMdd → yyyy-MM
    if (/^\d{8}$/.test(s)) return s.substr(0, 4) + '-' + s.substr(4, 2);
    return s;
}

/**
 * 과부족 수치 포맷 (정수 + 천단위 콤마)
 * AS-IS: CONVERT(INT, SUBSTRING(LASS_F, 0, CHARINDEX('.', LASS_F)))
 */
function formatLassF(value, row, index) {
    if (value == null || value === '') return '';
    var num = parseInt(value);
    if (isNaN(num)) return value;
    return num.toLocaleString();
}

// ============================================================================
// 8. 클라이언트 페이징
// ============================================================================

// ============================================================================
// 9. 유틸리티 함수
// ============================================================================

/**
 * Date → 'yyyy-MM-dd' 문자열
 */
function formatDate(d) {
    var y = d.getFullYear();
    var m = ('0' + (d.getMonth() + 1)).slice(-2);
    var dd = ('0' + d.getDate()).slice(-2);
    return y + '-' + m + '-' + dd;
}

/**
 * 'yyyy-MM-dd' 문자열 → Date
 */
function parseDate(str) {
    var parts = str.split('-');
    return new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
}

/**
 * 탭 선택 이벤트
 * 피벗 탭은 초기화 시 숨겨져 있어 treegrid가 높이를 0으로 계산함
 * → 탭 활성화 시점에 panel body 높이로 강제 resize
 */
function onTabSelect(title) {
    if (title === '피벗') {
        setTimeout(function() {
            var body = $('#tab-panel').tabs('getTab', '피벗').panel('body');
            $('#pivot-grid').treegrid('resize', {height: body.height()});
        }, 50);
    }
}

/**
 * 로딩바 숨김 + 레이아웃 표시 (화면 초기 로딩용)
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').css('display', '');
}



/**
 * Enter 키 바인딩 (검색 필드)
 * AS-IS: acLayoutControl1.OnValueKeyDown → if (KeyData == Keys.Return) Search()
 */
function bindEnterKey(id) {
    $('#' + id).textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            // 값 동기화
            $('#' + id).textbox('setValue', $(this).val());
            doSearch();
        }
    });
}
