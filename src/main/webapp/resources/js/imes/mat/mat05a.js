/**
 * ============================================================================
 * 화면: MAT05A - 자재불출현황
 * ============================================================================
 * 원본: ProActive MAT05A_M0A.cs, MAT05A_D0A.cs, MAT05A_D1A.cs
 * 작성일: 2026-03-04
 * 수정일: 2026-03-04 (AS-IS 기준 그리드/검색 재구성)
 *
 * 주요 기능:
 *   1. Tab1(공정별): 생산지시 마스터 + 소요자재 디테일 (마스터-디테일)
 *   2. Tab2(전체): 작업지시+소요자재 결합 조회
 *   3. Tab3(불출현황): PROC_CODE별 피벗 동적컬럼
 *   4. D0A: 현장불출 다이얼로그
 *   5. D1A: 불출취소 다이얼로그
 *
 * AS-IS 검색 조건:
 *   - DATE: 일자구분 (PLN_DATE/INDUE_DATE/SAP_DUE_DATE) — 멀티체크
 *   - S_DATE/E_DATE: 시작일/종료일
 *   - ORDER_LIKE: 오더번호 (LIKE)
 *   - HOGI_LIKE: 호기 (LIKE)
 *   - CUSTOMER_LIKE: 수주처 (LIKE)
 *   - PLANTS: 공장 (P009)
 * ============================================================================
 */

// ============================================================================
// 1. 전역 변수
// ============================================================================
var codeDataMap = {};
var _searchAllRows = [];       // Tab1 데이터 (MAT05A_SER)
var _searchEmpList = [];       // MRP_EMP 동적컬럼 목록
var _searchRateList = [];      // 불출율 데이터
var _searchAllRows8 = [];      // Tab2/Tab3 데이터 (MAT05A_SER8)
var _currentTab = 0;
var _searchProcList = [];      // 마스터 공정 목록 (Tab3 컬럼용, ORD04A_PROC)
var _d0aContext = {};          // D0A 컨텍스트 (선택 행 정보)
var _d1aContext = {};          // D1A 컨텍스트

// ============================================================================
// 2. consts 객체
// ============================================================================
var consts = {
    url: {
        MAT05A_SER:  getUrl('/imes/mat/mat05a/MAT05A_SER.json'),
        MAT05A_SER2: getUrl('/imes/mat/mat05a/MAT05A_SER2.json'),
        MAT05A_SER2_MULTI: getUrl('/imes/mat/mat05a/MAT05A_SER2_MULTI.json'),
        MAT05A_SER3: getUrl('/imes/mat/mat05a/MAT05A_SER3.json'),
        MAT05A_SER4: getUrl('/imes/mat/mat05a/MAT05A_SER4.json'),
        MAT05A_SER6: getUrl('/imes/mat/mat05a/MAT05A_SER6.json'),
        MAT05A_SER8: getUrl('/imes/mat/mat05a/MAT05A_SER8.json'),
        ORD04A_PROC: getUrl('/imes/mat/mat05a/ORD04A_PROC.json'),
        MAT05A_INS:  getUrl('/imes/mat/mat05a/MAT05A_INS.json'),
        MAT05A_DEL:  getUrl('/imes/mat/mat05a/MAT05A_DEL.json'),
        CODE_LIST:   getUrl('/common/code/code.json'),
        DRAW_FILE_LIST: getUrl('/imes/mat/mat02a/drawFileList.json')
    },

    codeData: {},

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
        // (1) 코드 로드
        this.codeData.P009 = this.loadCode('P009');
        this.codeData.S032 = this.loadCode('S032');

        // (2) 공장 콤보
        $('#s_plants').combobox({
            data: this.codeData.P009,
            valueField: 'codeCd',
            textField: 'codeName',
            editable: false,
            panelHeight: 'auto',
            width: 90
        });
        // 첫번째 행 자동 선택
        if (this.codeData.P009 && this.codeData.P009.length > 0) {
            $('#s_plants').combobox('setValue', this.codeData.P009[0].codeCd);
        }

        // (5) 버튼 바인딩
        $('#search-button').bind('click', doSearch);
        $('#issue-button').bind('click', openD0A);
        $('#cancel-button').bind('click', openD1A);
        $('#print-button').bind('click', doPrintMatSheet);
        $('#matquery-button').bind('click', doSelectedProcQuery);

        // (6) 그리드 초기화
        initGrid1();
        initGrid2();
        initGrid3();
        initGrid4();

        // (7) D0A/D1A 다이얼로그 그리드 초기화
        initD0aGrid1();
        initD0aGrid2();
        initD1aGrid1();
        initD1aGrid2();

        // (8) D0A/D1A 버튼
        $('#d0a-save-button').bind('click', doD0aSave);
        $('#d1a-cancel-button').bind('click', doD1aCancel);
    }
};

// ============================================================================
// 3. 초기화
// ============================================================================
$(function() {
    consts.init();
    
    // 파일 목록 팝업 초기화 (acFileForm 공통 모듈)
    acFileForm.init();
});

$(window).load(function() {
    // 날짜 초기값: 시작일 = 오늘-7일, 종료일 = 오늘
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);
    $('#s_startDate').datebox('setValue', formatDateStr(weekAgo));
    $('#s_endDate').datebox('setValue', formatDateStr(today));

    hideLoadingBar();
    bindEnterKey('s_orderLike');
    bindEnterKey('s_hogiLike');
    bindEnterKey('s_customerLike');
    
    
    
});

// ============================================================================
// 4. Tab1 그리드 초기화
// ============================================================================

/**
 * Grid1: 생산지시 마스터 (Tab1 상단)
 * AS-IS: acGridView1 - AllowCellMerge, 30+ columns (hidden 포함)
 */
function initGrid1() {
    $('#grid1').datagrid({
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
        onSelect: onGrid1Select,
        columns: [ getGrid1BaseCols() ],
        onLoadSuccess: function(data) {
            $(this).datagrid('getPanel').find('.datagrid-body').scrollTop(0);
            // AS-IS: DataSource 바인딩 시 첫 행 자동 포커스 → FocusedRowChanged → GetDetail()
            var rows = data.rows || [];
            if (rows.length > 0) {
                $('#grid1').datagrid('selectRow', 0);
            } else {
                $('#grid2').datagrid('loadData', []);
            }
        }
    });
}

/**
 * Grid1 기본 컬럼 (동적 MRP_EMP 컬럼 제외)
 * AS-IS 컬럼 순서와 가시성 일치
 */
function getGrid1BaseCols() {
    return [
        {field:'sel',            title:'선택',          width:40,  halign:'center', align:'center',
            styler: editableCellStyler,
            formatter: function(v, r, i) {
                var checked = (v === '1') ? 'checked' : '';
                return '<input type="checkbox" ' + checked + ' onclick="toggleGrid1Sel(this,' + i + ')"/>';
            }
        },
        {field:'plants',         title:'공장',          width:60,  halign:'center', align:'center', formatter:formatPlants},
        {field:'orderNo',        title:'판매오더',      width:90,  halign:'center', align:'center'},
        {field:'orderLine',      title:'품목',          width:50,  halign:'center', align:'center'},
        {field:'sapWoNo',        title:'생산오더',      width:100, halign:'center', align:'center'},
        {field:'prodHogi',       title:'호기',          width:80,  halign:'center', align:'left'},
        {field:'sapDueDate',     title:'납기일',        width:90,  halign:'center', align:'center', formatter:formatShortDate},
        {field:'indueDate',      title:'생산완료일',    width:90,  halign:'center', align:'center', formatter:formatShortDate},
        {field:'customer',       title:'수주처',        width:120, halign:'center', align:'left'},
        {field:'modelType',      title:'타입',          width:100,  halign:'center', align:'center'},
        {field:'woFlag',         title:'상태',          width:60,  halign:'center', align:'center', formatter:formatWoFlag},
        {field:'actEmps',        title:'작업자',        width:100, halign:'center', align:'left'},
        {field:'bfPlnStartTime', title:'이전계획',      width:90,  halign:'center', align:'center', formatter:formatShortDate},
        {field:'plnStartTime',   title:'계획시작',      width:90,  halign:'center', align:'center', formatter:formatShortDate},
        {field:'procCode',       title:'공정',          width:60,  halign:'center', align:'center'},
        {field:'matOutRate',     title:'출고율(SAP)',    width:80,  halign:'center', align:'right', formatter:formatPercent},
        {field:'matOutRateMes',  title:'출고율(MES)',    width:80,  halign:'center', align:'right', formatter:formatPercent},
        {field:'matOutStkRate',  title:'출고율(MES_물류)', width:90, halign:'center', align:'right', formatter:formatPercent}
    ];
}

function toggleGrid1Sel(cb, index) {
    var rows = $('#grid1').datagrid('getRows');
    if (rows[index]) {
        rows[index].sel = cb.checked ? '1' : '0';
    }
}

/**
 * Grid2: 소요자재 디테일 (Tab1 하단)
 * AS-IS: acGridView2 - 도면/상태아이콘/과부족 포함
 */
function initGrid2() {
    $('#grid2').datagrid({
        fit: true,
        fitColumns: false,
        border: false,
        singleSelect: true,
        rownumbers: true,
        striped: true,
        nowrap: true,
        frozenColumns: [[
            {field:'drawOpen', title:'도면', width:50, halign:'center', align:'center',
                formatter: formatDraw
            }
        ]],
        columns: [[
            {field:'mrpEmp',       title:'담당자',       width:70,  halign:'center', align:'center'},
            {field:'mrpEmpName',   title:'담당자명',     width:80,  halign:'center', align:'center'},
            {field:'isShip',       title:'상태(SAP)',     width:60,  halign:'center', align:'center', formatter:formatStatIcon},
            {field:'outFlag',      title:'상태(MES)',     width:60,  halign:'center', align:'center', formatter:formatStatIcon},
            {field:'partSpec',     title:'소요자재',     width:100, halign:'center', align:'left'},
            {field:'partName',     title:'소요자재명',   width:140, halign:'center', align:'left'},
            {field:'bin',          title:'저장빈',       width:70,  halign:'center', align:'left'},
            {field:'shipQty',      title:'불출량',       width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'useQty',       title:'소요량',       width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkUseQty',    title:'가용재고',     width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkInsQty',    title:'검사재고',     width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkVndQty',    title:'업체재고',     width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'lassFCause',   title:'1차과부족',    width:80,  halign:'center', align:'left'},
            {field:'lassF',        title:'과부족수량',   width:80,  halign:'center', align:'left'},
            {field:'isFile',       title:'파일여부',    width:0,   halign:'center', align:'center', hidden:true},
            {field:'orderNo',      title:'판매오더',     width:90,  halign:'center', align:'center'},
            {field:'orderLine',    title:'품목',         width:50,  halign:'center', align:'center'},
            {field:'sapWoNo',      title:'생산오더',     width:100, halign:'center', align:'center'},
            {field:'prodHogi',     title:'호기',         width:70,  halign:'center', align:'left'},
            {field:'customer',     title:'수주처',       width:100, halign:'center', align:'left'},
            {field:'procCode',     title:'공정',         width:60,  halign:'center', align:'center'},
            {field:'ypgoPlanDate', title:'입고예정일',   width:90,  halign:'center', align:'center', formatter:formatShortDate},
            {field:'mvndName',     title:'거래처',       width:100, halign:'center', align:'left'}
        ]],
        onLoadSuccess: function() {
            $('#grid2').datagrid('unselectAll');
            $('#grid2').datagrid('clearSelections');
        }
    });

    GridHeaderMenu('#grid2', { exportFileName: '자재불출_실적현황' });
    enableGridSortReset('#grid2');

}

/**
 * Grid3: 전체 (Tab2)
 * AS-IS: acGridView3 - Grid1 + Grid2 결합 (작업지시+소요자재)
 */
function initGrid3() {
    $('#grid3').datagrid({
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
            {field:'plants',         title:'공장',          width:60,  halign:'center', align:'center', formatter:formatPlants},
            {field:'orderNo',        title:'판매오더',      width:90,  halign:'center', align:'center'},
            {field:'orderLine',      title:'품목',          width:50,  halign:'center', align:'center'},
            {field:'sapWoNo',        title:'생산오더',      width:100, halign:'center', align:'center'},
            {field:'prodHogi',       title:'호기',          width:70,  halign:'center', align:'left'},
            {field:'sapDueDate',     title:'납기일',        width:90,  halign:'center', align:'center', formatter:formatShortDate},
            {field:'indueDate',      title:'생산완료일',    width:90,  halign:'center', align:'center', formatter:formatShortDate},
            {field:'customer',       title:'수주처',        width:100, halign:'center', align:'left'},
            {field:'modelType',      title:'타입',          width:100,  halign:'center', align:'center'},
            {field:'woFlag',         title:'상태',          width:60,  halign:'center', align:'center', formatter:formatWoFlag},
            {field:'bfPlnStartTime', title:'이전계획',      width:90,  halign:'center', align:'center', formatter:formatShortDate},
            {field:'plnStartTime',   title:'계획시작',      width:90,  halign:'center', align:'center', formatter:formatShortDate},
            {field:'procCode',       title:'공정',          width:60,  halign:'center', align:'center'},
            {field:'matOutRate',     title:'출고율(SAP)',    width:80,  halign:'center', align:'right', formatter:formatPercent},
            {field:'matOutRateMes',  title:'출고율(MES)',    width:80,  halign:'center', align:'right', formatter:formatPercent},
            {field:'matOutStkRate',  title:'출고율(MES_물류)', width:90, halign:'center', align:'right', formatter:formatPercent},
            {field:'mrpEmp',         title:'담당자',        width:70,  halign:'center', align:'center'},
            {field:'mrpEmpName',     title:'담당자명',      width:80,  halign:'center', align:'center'},
            {field:'isShip',         title:'상태(SAP)',      width:60,  halign:'center', align:'center', formatter:formatStatIcon},
            {field:'outFlag',        title:'상태(MES)',      width:60,  halign:'center', align:'center', formatter:formatStatIcon},
            {field:'partSpec',       title:'소요자재',      width:100, halign:'center', align:'left'},
            {field:'partName',       title:'소요자재명',    width:140, halign:'center', align:'left'},
            {field:'bin',            title:'저장빈',        width:70,  halign:'center', align:'left'},
            {field:'lassFCause',     title:'1차과부족',     width:80,  halign:'center', align:'left'},
            {field:'lassF',          title:'과부족수량',    width:80,  halign:'center', align:'left'},
            {field:'shipQty',        title:'불출량',        width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'useQty',         title:'소요량',        width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkUseQty',      title:'가용재고',      width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkInsQty',      title:'검사재고',      width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkVndQty',      title:'업체재고',      width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'ypgoPlanDate',   title:'입고예정일',    width:90,  halign:'center', align:'center', formatter:formatShortDate},
            {field:'mvndName',       title:'거래처',        width:100, halign:'center', align:'left'}
        ]],
        onLoadSuccess: function() {
            $(this).datagrid('getPanel').find('.datagrid-body').scrollTop(0);
            $('#grid3').datagrid('unselectAll');
        }
    });

    GridHeaderMenu('#grid3', { exportFileName: '자재불출_전체' });
    enableGridSortReset('#grid3');

}

/**
 * Grid4: 불출현황 (Tab3) - 정적컬럼 + PROC_CODE 동적컬럼
 * AS-IS: acGridView4 - PROC_CODE별 MAT_OUT_RATE 피벗
 */
function initGrid4() {
    $('#grid4').datagrid({
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
        columns: [ getGrid4StaticCols() ],
        onLoadSuccess: function() {
            $(this).datagrid('getPanel').find('.datagrid-body').scrollTop(0);
            $('#grid4').datagrid('unselectAll');
        }
    });
}

/**
 * Grid4 정적 컬럼 (AS-IS 일치)
 */
function getGrid4StaticCols() {
    return [
        {field:'orderNo',    title:'판매오더',    width:90,  halign:'center', align:'center'},
        {field:'orderLine',  title:'품목',        width:50,  halign:'center', align:'center'},
        {field:'plants',     title:'공장',        width:60,  halign:'center', align:'center', formatter:formatPlants},
        {field:'prodHogi',   title:'호기',        width:70,  halign:'center', align:'left'},
        {field:'sapDueDate', title:'납기일',      width:90,  halign:'center', align:'center', formatter:formatShortDate},
        {field:'indueDate',  title:'생산완료일',  width:90,  halign:'center', align:'center', formatter:formatShortDate},
        {field:'customer',   title:'수주처',      width:100, halign:'center', align:'left'},
        {field:'modelType',  title:'타입',        width:100,  halign:'center', align:'center'}
    ];
}

// ============================================================================
// 5. 조회
// ============================================================================

/**
 * 메인 조회
 * AS-IS: 멀티체크된 일자구분에 대해 모두 날짜조건 적용
 */
function doSearch() {
    var sDate = $('#s_startDate').datebox('getValue');
    var eDate = $('#s_endDate').datebox('getValue');
    var dateTypes = $('#s_dateType').combobox('getValues') || [];

    // 날짜 선택 검증: 일자구분이 하나라도 선택되면 날짜 필수
    if (dateTypes.length > 0 && (!sDate || !eDate)) {
        $.messager.alert('알림', '일자를 선택해주세요.');
        return;
    }

    var sDateFmt = sDate ? sDate.replace(/-/g, '') : '';
    var eDateFmt = eDate ? eDate.replace(/-/g, '') : '';

    var params = {
        orderLike:    $('#s_orderLike').textbox('getValue'),
        hogiLike:     $('#s_hogiLike').textbox('getValue'),
        customerLike: $('#s_customerLike').textbox('getValue'),
        plants:       $('#s_plants').combobox('getValue') || '',
        woFlagIn:     '1,2,3,4'    // AS-IS: UI에서 WO_FLAG_IN 고정 전달
    };

    // 멀티체크: 선택된 모든 일자구분에 대해 날짜조건 적용 (AND)
    for (var i = 0; i < dateTypes.length; i++) {
        var dt = dateTypes[i];
        if (dt === 'PLN_DATE') {
            params.sPlnStartDate = sDateFmt;
            params.ePlnStartDate = eDateFmt;
        } else if (dt === 'INDUE_DATE') {
            params.sIndueDate = sDateFmt;
            params.eIndueDate = eDateFmt;
        } else if (dt === 'SAP_DUE_DATE') {
            params.sSapDueDate = sDateFmt;
            params.eSapDueDate = eDateFmt;
        }
    }

    if (_currentTab === 0) {
        doSearchTab1(params);
    } else {
        doSearchTab2Tab3(params);
    }
}

/**
 * Tab1 조회 (MAT05A_SER)
 */
function doSearchTab1(params) {
    $('#grid1').datagrid('loading');

    $.ajax({
        url: consts.url.MAT05A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            var empList = result.empList || [];
            var rateList = result.rateList || [];

            _searchAllRows = rows;
            _searchEmpList = empList;
            _searchRateList = rateList;

            // MRP_EMP 동적컬럼 재생성
            rebuildGrid1Columns();
            GridHeaderMenu('#grid1', { exportFileName: '자재불출_오더목록' });
            enableGridSortReset('#grid1');

            // 불출율 데이터를 rows에 매핑
            applyRateData();

            var opts = $('#grid1').datagrid('options');
            opts.pageNumber = 1;
            $('#grid1').datagrid('loadData', _searchAllRows);
            $('#grid1').datagrid('loaded');
        },
        error: function() {
            $('#grid1').datagrid('loaded');
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.');
        }
    });
}

/**
 * Tab2/Tab3 조회 (MAT05A_SER8)
 * Tab3: 마스터 공정목록(ORD04A_PROC) 선조회 후 SER8 호출
 */
function doSearchTab2Tab3(params) {
    var gridId = (_currentTab === 1) ? '#grid3' : '#grid4';
    $(gridId).datagrid('loading');

    if (_currentTab === 2 && _searchProcList.length === 0) {
        // Tab3: 마스터 공정 목록 먼저 조회 (AS-IS: ORD04A_PROC)
        $.ajax({
            url: consts.url.ORD04A_PROC,
            type: 'POST',
            data: { isFirstProc: '1' },  // AS-IS: PLT_CODE=acInfo.PLT_CODE(세션), IS_FIRST_PROC='1'
            dataType: 'json',
            success: function(procResult) {
                _searchProcList = procResult.rows || [];
                doSearchSer8(params, gridId);
            },
            error: function() {
                $(gridId).datagrid('loaded');
                $.messager.alert('오류', '공정 목록 조회 중 오류가 발생했습니다.');
            }
        });
    } else {
        doSearchSer8(params, gridId);
    }
}

/**
 * SER8 데이터 조회 (Tab2/Tab3 공통)
 */
function doSearchSer8(params, gridId) {
    $.ajax({
        url: consts.url.MAT05A_SER8,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            _searchAllRows8 = rows;

            if (_currentTab === 1) {
                applyTab2Data();
            } else {
                applyTab3Data();
            }
            $(gridId).datagrid('loaded');
        },
        error: function() {
            $(gridId).datagrid('loaded');
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.');
        }
    });
}

// ============================================================================
// 6. 동적 컬럼 및 데이터 매핑
// ============================================================================

/**
 * Grid1에 MRP_EMP 동적 컬럼 추가
 */
function rebuildGrid1Columns() {
    var baseCols = getGrid1BaseCols();

    // MRP_EMP 동적 컬럼 추가
    for (var i = 0; i < _searchEmpList.length; i++) {
        var emp = _searchEmpList[i].mrpEmp;
        if (emp) {
            baseCols.push({
                field: 'emp_' + emp,
                title: emp,
                width: 70,
                halign: 'center',
                align: 'right',
                formatter: formatPercent
            });
        }
    }
    
    // 컬럼 설정 + 빈 렌더링으로 컨테이너 크기 확정 후 재설정
    $('#grid1').datagrid({columns: [baseCols], data: []});
    $('#grid1').datagrid({columns: [baseCols]});
}

/**
 * 부모 grid1 인플레이스 업데이트 (AS-IS: UpdateMapingRow)
 * INS/DEL 응답의 updatedRow로 해당 행만 갱신 (전체 재조회 안함)
 */
function updateParentGrid(updatedRow) {
    if (!updatedRow) return;

    var newRows = updatedRow.rows || [];
    var newRateList = updatedRow.rateList || [];

    // 현재 선택 행의 sapWoNo로 매칭
    var selectedRow = $('#grid1').datagrid('getSelected');
    if (!selectedRow) return;
    var selectedIndex = $('#grid1').datagrid('getRowIndex', selectedRow);

    // _searchAllRows에서 해당 행 교체
    for (var i = 0; i < newRows.length; i++) {
        for (var j = 0; j < _searchAllRows.length; j++) {
            if (_searchAllRows[j].sapWoNo === newRows[i].sapWoNo &&
                _searchAllRows[j].procCode === newRows[i].procCode) {
                // 기존 행 데이터 갱신 (동적 emp_ 컬럼 유지를 위해 덮어쓰기)
                var oldRow = _searchAllRows[j];
                for (var key in newRows[i]) {
                    oldRow[key] = newRows[i][key];
                }
            }
        }
    }

    // 불출율 데이터 갱신
    for (var r = 0; r < newRateList.length; r++) {
        var nr = newRateList[r];
        var found = false;
        for (var s = 0; s < _searchRateList.length; s++) {
            var sr = _searchRateList[s];
            if (sr.prodCode === nr.prodCode && sr.sapWoNo === nr.sapWoNo &&
                sr.partCode === nr.partCode && sr.procCode === nr.procCode &&
                sr.mrpEmp === nr.mrpEmp) {
                _searchRateList[s] = nr;
                found = true;
                break;
            }
        }
        if (!found) _searchRateList.push(nr);
    }

    // 불출율 재매핑 + grid1 리프레시 (선택 유지)
    applyRateData();
    $('#grid1').datagrid('loadData', _searchAllRows);
    if (selectedIndex >= 0) {
        $('#grid1').datagrid('selectRow', selectedIndex);
    }
}

/**
 * 불출율 데이터를 마스터 행에 매핑
 * rateList의 MRP_EMP별 SHIP_RATE를 emp_XXX 필드로 매핑
 */
function applyRateData() {
    // rateList → {prodCode+sapWoNo+partCode+procCode3 → {mrpEmp → shipRate}} 맵 구성
    var rateMap = {};
    for (var i = 0; i < _searchRateList.length; i++) {
        var r = _searchRateList[i];
        var procCode3 = (r.procCode || '').substring(0, 3);
        var key = (r.prodCode || '') + '|' + (r.sapWoNo || '') + '|' + (r.partCode || '') + '|' + procCode3;
        if (!rateMap[key]) rateMap[key] = {};
        rateMap[key][r.mrpEmp] = r.shipRate;
    }

    // 각 row에 emp_XXX 필드 추가
    for (var j = 0; j < _searchAllRows.length; j++) {
        var row = _searchAllRows[j];
        var procCode3 = (row.procCode || '').substring(0, 3);
        var key = (row.prodCode || '') + '|' + (row.sapWoNo || '') + '|' + (row.banPartCode || '') + '|' + procCode3;
        var rates = rateMap[key];
        if (rates) {
            for (var k = 0; k < _searchEmpList.length; k++) {
                var emp = _searchEmpList[k].mrpEmp;
                if (emp) {
                    row['emp_' + emp] = rates[emp] || '';
                }
            }
        }
    }
}

/**
 * Tab2 데이터 적용
 */
function applyTab2Data() {
    var opts = $('#grid3').datagrid('options');
    opts.pageNumber = 1;
    $('#grid3').datagrid('loadData', _searchAllRows8);
}

/**
 * Tab3: PROC_CODE별 피벗 동적 컬럼
 * AS-IS: 마스터 공정 목록(_dtProcList = ORD04A_PROC) 기반 컬럼 생성
 */
function applyTab3Data() {
    // 마스터 공정 목록에서 컬럼 구성 (AS-IS: _dtProcList 기반)
    var procOrder = [];
    for (var i = 0; i < _searchProcList.length; i++) {
        var proc = _searchProcList[i];
        procOrder.push({
            code: proc.procCode,
            prgSeq: parseInt(proc.prgSeq) || 0
        });
    }
    // prgSeq, procCode 순 정렬 (서버에서 정렬되지만 안전하게)
    procOrder.sort(function(a, b) {
        if (a.prgSeq !== b.prgSeq) return a.prgSeq - b.prgSeq;
        return a.code < b.code ? -1 : (a.code > b.code ? 1 : 0);
    });

    // prodCode별 그룹화 & procCode별 matOutRate(SAP) 피벗
    var prodMap = {};
    var prodOrder = [];
    for (var j = 0; j < _searchAllRows8.length; j++) {
        var r = _searchAllRows8[j];
        var pKey = (r.orderNo || '') + '|' + (r.orderLine || '');
        if (!prodMap[pKey]) {
            prodMap[pKey] = {
                orderNo: r.orderNo, orderLine: r.orderLine,
                plants: r.plants, prodHogi: r.prodHogi,
                sapDueDate: r.sapDueDate, indueDate: r.indueDate,
                customer: r.customer, modelType: r.modelType
            };
            prodOrder.push(pKey);
        }
        if (r.procCode && r.matOutRate != null) {
            prodMap[pKey]['proc_' + r.procCode] = r.matOutRate;
        }
    }

    // 동적 컬럼 구성 (정적 + PROC_CODE 피벗, prgSeq 정렬)
    var cols = getGrid4StaticCols();
    for (var p = 0; p < procOrder.length; p++) {
        cols.push({
            field: 'proc_' + procOrder[p].code,
            title: procOrder[p].code,
            width: 70,
            halign: 'center',
            align: 'right',
            formatter: formatPercent
        });
    }

    // 피벗 행 구성
    var pivotRows = [];
    for (var q = 0; q < prodOrder.length; q++) {
        pivotRows.push(prodMap[prodOrder[q]]);
    }

    $('#grid4').datagrid({columns: [cols]});
    GridHeaderMenu('#grid4', { exportFileName: '자재불출_불출현황' });
    enableGridSortReset('#grid4');
    
    var opts = $('#grid4').datagrid('options');
    opts.pageNumber = 1;
    $('#grid4').datagrid('loadData', pivotRows);
}

// ============================================================================
// 7. Grid1 행 선택 → Grid2 디테일
// ============================================================================

function onGrid1Select(index, row) {
    if (!row) return;

    // AS-IS: SEL='1'인 행이 하나라도 있으면 상세 조회 안 함
    var allRows = $('#grid1').datagrid('getRows');
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel === '1') return;
    }

    // AS-IS: PROC_CODE 앞 3자리가 TST이면 디테일 조회 건너뜀
    var procCode = row.procCode || '';
    if (procCode.substring(0, 3) === 'TST') {
        $('#grid2').datagrid('loadData', []);
        return;
    }

    $('#grid2').datagrid('loading');

    $.ajax({
        url: consts.url.MAT05A_SER2,
        type: 'POST',
        data: {
            sapWoNo:   row.sapWoNo,
            orderNo:   row.orderNo,
            orderLine: row.orderLine,
            partCode:  row.banPartCode
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#grid2').datagrid('loadData', rows);
            $('#grid2').datagrid('loaded');
        },
        error: function() {
            $('#grid2').datagrid('loaded');
        }
    });
}

// ============================================================================
// 8. 자재확인표출력 / 선택공정 자재조회
// ============================================================================

/**
 * 자재확인표 출력
 * AS-IS: acBarButtonItem16 - 현재 탭에 따라 acGridView2(공정별) 또는 acGridView3(전체) 데이터로 Excel 출력
 */
function doPrintMatSheet() {
    if (_currentTab === 0) {
        var rows = $('#grid2').datagrid('getRows');
        if (!rows || rows.length === 0) {
            $.messager.alert('알림', '출력할 자재 데이터가 없습니다.');
            return;
        }
        doExcelDownload('grid2', '자재확인표_공정별');
    } else if (_currentTab === 1) {
        var rows = $('#grid3').datagrid('getRows');
        if (!rows || rows.length === 0) {
            $.messager.alert('알림', '출력할 자재 데이터가 없습니다.');
            return;
        }
        doExcelDownload('grid3', '자재확인표_전체');
    }
}

/**
 * 선택공정 자재조회
 * AS-IS: acBarButtonItem17 - Grid1에서 SEL='1'인 행의 자재를 일괄 조회하여 Grid2에 표시
 */
function doSelectedProcQuery() {
    var rows = $('#grid1').datagrid('getRows');
    var paramRows = [];
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].sel === '1') {
            // AS-IS: PROC_CODE 앞 3자리가 TST이면 제외
            var procCode = rows[i].procCode || '';
            if (procCode.substring(0, 3) === 'TST') continue;
            paramRows.push({
                sapWoNo:   rows[i].sapWoNo,
                orderNo:   rows[i].orderNo,
                orderLine: rows[i].orderLine,
                partCode:  rows[i].banPartCode
            });
        }
    }
    if (paramRows.length === 0) {
        $.messager.alert('알림', '공정을 선택해주세요.');
        return;
    }

    $('#grid2').datagrid('loading');

    // AS-IS: 각 행에 대해 QUERY3 반복 실행 후 결과 Merge
    $.ajax({
        url: consts.url.MAT05A_SER2_MULTI,
        type: 'POST',
        data: { models: JSON.stringify(paramRows) },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#grid2').datagrid('loadData', rows);
            $('#grid2').datagrid('loaded');
        },
        error: function() {
            $('#grid2').datagrid('loaded');
        }
    });
}

// ============================================================================
// 9. 탭 전환
// ============================================================================

function onTabSelect(title, index) {
    _currentTab = index;

    // AS-IS 탭별 버튼 show/hide
    // 공정별(0): 현장불출, 불출취소, 자재확인표출력, 선택공정자재조회
    // 전체(1):   자재확인표출력
    // 불출현황(2): 없음
    if (index === 0) {
        $('#issue-button').show();
        $('#cancel-button').show();
        $('#print-button').show();
        $('#matquery-button').show();
    } else if (index === 1) {
        $('#issue-button').hide();
        $('#cancel-button').hide();
        $('#print-button').show();
        $('#matquery-button').hide();
    } else {
        $('#issue-button').hide();
        $('#cancel-button').hide();
        $('#print-button').hide();
        $('#matquery-button').hide();
    }

    // AS-IS: 탭 전환 시 자동조회 없음 (버튼 가시성만 제어, 조회는 사용자 클릭)
    setTimeout(function() {
        if (index === 0) {
            $('#grid1').datagrid('resize');
            $('#grid2').datagrid('resize');
        } else if (index === 1) {
            var body1 = $('#tab-panel').tabs('getTab', '전체').panel('body');
            $('#grid3').datagrid('resize', {height: body1.height()});
        } else if (index === 2) {
            var body2 = $('#tab-panel').tabs('getTab', '불출현황').panel('body');
            $('#grid4').datagrid('resize', {height: body2.height()});
        }
    }, 50);
}

// ============================================================================
// 9. D0A 다이얼로그 (현장불출)
// ============================================================================

function initD0aGrid1() {
    $('#d0a-grid1').datagrid({
        fit: true,
        //fitColumns: false,
        border: false,
        singleSelect: true,
        rownumbers: true,
        striped: true,
        nowrap: true,
        onSelect: onD0aGrid1Select,
        columns: [[
            {field:'mrpEmp',     title:'담당자',    width:100, halign:'center', align:'center'},
            {field:'mrpEmpName', title:'담당자명',  width:120, halign:'center', align:'center'}
        ]],
        onLoadSuccess: function() {
            $('#d0a-grid1').datagrid('unselectAll');
        }
    });
    GridHeaderMenu('#d0a-grid1', { exportFileName: '불출_오더목록' });
    enableGridSortReset('#d0a-grid1');
}

function initD0aGrid2() {
    $('#d0a-grid2').datagrid({
        fit: true,
        //fitColumns: false,
        border: false,
        singleSelect: true,
        rownumbers: true,
        striped: true,
        nowrap: true,
        rowStyler: function(index, row) {
            // AS-IS: SEL='1' → Color.Honeydew (#F0FFF0)
            if (row.sel === '1') return 'background-color:#F0FFF0;';
        },
        columns: [[
            {field:'sel',         title:'선택',      width:50,  halign:'center', align:'center',
                styler: editableCellStyler,
                formatter: function(v, r, i) {
                    var checked = (v === '1') ? 'checked' : '';
                    return '<input type="checkbox" ' + checked + ' onclick="toggleD0aSel(this,' + i + ')"/>';
                }
            },
            {field:'partSpec',    title:'소요자재',   width:100, halign:'center', align:'left'},
            {field:'partName',    title:'소요자재명', width:140, halign:'center', align:'left'},
            {field:'bin',         title:'저장빈',     width:70,  halign:'center', align:'left'},
            {field:'shipQty',     title:'불출량',     width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'useQty',      title:'소요량',     width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkUseQty',   title:'가용재고',   width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkInsQty',   title:'검사재고',   width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkVndQty',   title:'업체재고',   width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'isShip',      title:'상태(SAP)',   width:60,  halign:'center', align:'center', formatter:formatStatIcon},
            {field:'outFlag',     title:'상태(MES)',   width:60,  halign:'center', align:'center', formatter:formatStatIcon}
        ]],
        onLoadSuccess: function() {
            $('#d0a-grid2').datagrid('unselectAll');
        }
    });
    GridHeaderMenu('#d0a-grid2', { exportFileName: '불출_자재목록' });
    enableGridSortReset('#d0a-grid2');
}

/**
 * D0A 열기
 */
function openD0A() {
    var row = $('#grid1').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', '생산지시를 선택해주세요.');
        return;
    }

    _d0aContext = {
        pltCode:     row.pltCode,
        sapWoNo:     row.sapWoNo,
        orderNo:     row.orderNo,
        orderLine:   row.orderLine,
        partCode:    row.banPartCode,
        prodCode:    row.prodCode,
        woNo:        row.woNo,
        procCode:    row.procCode
    };

    $('#d0a-dialog').css('visibility', '');
    $('#d0a-buttons').css('visibility', '');
    $('#d0a-dialog').dialog('open').dialog('center');

    // 담당자 목록 조회
    $.ajax({
        url: consts.url.MAT05A_SER3,
        type: 'POST',
        data: {
            sapWoNo:   row.sapWoNo,
            orderNo:   row.orderNo,
            orderLine: row.orderLine,
            partCode:  row.banPartCode
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#d0a-grid1').datagrid('loadData', rows);
            $('#d0a-grid2').datagrid('loadData', []);
            // 첫 행 자동 선택 → onD0aGrid1Select 트리거
            if (rows.length > 0) {
                $('#d0a-grid1').datagrid('selectRow', 0);
            }
        }
    });
}

/**
 * D0A 담당자 선택 → 자재 목록 로드
 */
function onD0aGrid1Select(index, row) {
    if (!row) return;

    _d0aContext.mrpEmp = row.mrpEmp;
    _d0aContext.mrpEmpName = row.mrpEmpName;

    loadD0aGrid2();
}

/**
 * D0A grid2 자재 목록 조회
 */
function loadD0aGrid2() {
    $.ajax({
        url: consts.url.MAT05A_SER4,
        type: 'POST',
        data: {
            sapWoNo:     _d0aContext.sapWoNo,
            orderNo:     _d0aContext.orderNo,
            orderLine:   _d0aContext.orderLine,
            partCode:    _d0aContext.partCode,
            mrpEmp:      _d0aContext.mrpEmp,
            mrpEmpName:  _d0aContext.mrpEmpName
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            // AS-IS 자동 SEL: USE_QTY != 0 → SEL='0', USE_QTY == 0 → SEL='1'
            for (var i = 0; i < rows.length; i++) {
                var useQty = parseFloat(rows[i].useQty) || 0;
                rows[i].sel = (useQty !== 0) ? '0' : '1';
            }
            $('#d0a-grid2').datagrid('loadData', rows);
        }
    });
}

/**
 * D0A 선택 체크박스 토글
 */
function toggleD0aSel(cb, index) {
    var rows = $('#d0a-grid2').datagrid('getRows');
    if (rows[index]) {
        rows[index].sel = cb.checked ? '1' : '0';
        // 행 배경색 갱신 (AS-IS: SEL='1' → Honeydew)
        var tr = $('#d0a-grid2').datagrid('getPanel').find('.datagrid-view2 .datagrid-body tr[datagrid-row-index=' + index + ']');
        if (cb.checked) {
            tr.css('background-color', '#F0FFF0');
        } else {
            tr.css('background-color', '');
        }
    }
}

/**
 * D0A 불출 저장
 */
function doD0aSave() {
    var allRows = $('#d0a-grid2').datagrid('getRows');
    var selectedRows = [];
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel === '1') {
            selectedRows.push({
                stkOutNo:     allRows[i].stkOutNo || '',
                stkOutPartNo: allRows[i].stkOutPartNo || '',
                partCode:     allRows[i].partSpec,
                outFlag:      '1',
                prodCode:     _d0aContext.prodCode,
                woNo:         _d0aContext.woNo,
                procCode:     _d0aContext.procCode,
                sapWoNo:      _d0aContext.sapWoNo,
                mrpEmp:       _d0aContext.mrpEmp,
                banPartCode:  _d0aContext.partCode,
                orderNo:      _d0aContext.orderNo,
                orderLine:    _d0aContext.orderLine
            });
        }
    }

    if (selectedRows.length === 0) {
        $.messager.alert('알림', '불출할 자재를 선택해주세요.');
        return;
    }

    $.messager.confirm('확인', selectedRows.length + '건을 불출하시겠습니까?', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.MAT05A_INS,
            type: 'POST',
            data: {models: JSON.stringify(selectedRows)},
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert('알림', result.success, 'info');
                    // AS-IS: 팝업 유지, 부모 grid1 인플레이스 갱신 (UpdateMapingRow)
                    updateParentGrid(result.updatedRow);
                    // AS-IS: SER5 응답의 partList로 D0A grid2 갱신 (SEL 서버에서 설정됨)
                    if (result.updatedRow && result.updatedRow.partList) {
                        $('#d0a-grid2').datagrid('loadData', result.updatedRow.partList);
                    }
                } else {
                    $.messager.alert('오류', result.error || '불출 실패');
                }
            },
            error: function() {
                $.messager.alert('오류', '서버 통신 오류');
            }
        });
    });
}

// ============================================================================
// 10. D1A 다이얼로그 (불출취소)
// ============================================================================

function initD1aGrid1() {
    $('#d1a-grid1').datagrid({
        fit: true,
        //fitColumns: false,
        border: false,
        singleSelect: true,
        rownumbers: true,
        striped: true,
        nowrap: true,
        onSelect: onD1aGrid1Select,
        columns: [[
            {field:'mrpEmp',  title:'담당자',   width:100, halign:'center', align:'center'},
            {field:'regDate', title:'등록일',   width:140, halign:'center', align:'center', hidden:true}
        ]],
        onLoadSuccess: function() {
            $('#d1a-grid1').datagrid('unselectAll');
        }
    });
    GridHeaderMenu('#d1a-grid1', { exportFileName: '불출취소_오더목록' });
    enableGridSortReset('#d1a-grid1');
}

function initD1aGrid2() {
    $('#d1a-grid2').datagrid({
        fit: true,
        //fitColumns: false,
        border: false,
        singleSelect: true,
        rownumbers: true,
        striped: true,
        nowrap: true,
        columns: [[
            {field:'sel',         title:'선택',      width:50,  halign:'center', align:'center',
                styler: editableCellStyler,
                formatter: function(v, r, i) {
                    var checked = (v === '1') ? 'checked' : '';
                    return '<input type="checkbox" ' + checked + ' onclick="toggleD1aSel(this,' + i + ')"/>';
                }
            },
            {field:'partSpec',    title:'소요자재',   width:100, halign:'center', align:'left'},
            {field:'partName',    title:'소요자재명', width:140, halign:'center', align:'left'},
            {field:'shipQty',     title:'불출량',     width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'useQty',      title:'소요량',     width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkUseQty',   title:'가용재고',   width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkInsQty',   title:'검사재고',   width:70,  halign:'center', align:'right', formatter:formatNumber},
            {field:'stkVndQty',   title:'업체재고',   width:70,  halign:'center', align:'right', formatter:formatNumber}
        ]],
        onLoadSuccess: function() {
            $('#d1a-grid2').datagrid('unselectAll');
        }
    });
    GridHeaderMenu('#d1a-grid2', { exportFileName: '불출취소_자재목록' });
    enableGridSortReset('#d1a-grid2');
}

/**
 * D1A 열기
 */
function openD1A() {
    var row = $('#grid1').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', '생산지시를 선택해주세요.');
        return;
    }

    _d1aContext = {
        pltCode:     row.pltCode,
        sapWoNo:     row.sapWoNo,
        orderNo:     row.orderNo,
        orderLine:   row.orderLine,
        partCode:    row.banPartCode,
        prodCode:    row.prodCode,
        woNo:        row.woNo,
        procCode:    row.procCode
    };

    $('#d1a-dialog').css('visibility', '');
    $('#d1a-buttons').css('visibility', '');
    $('#d1a-dialog').dialog('open').dialog('center');

    // 출고건 목록 조회
    $.ajax({
        url: consts.url.MAT05A_SER6,
        type: 'POST',
        data: {sapWoNo: row.sapWoNo},
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#d1a-grid1').datagrid('loadData', rows);
            $('#d1a-grid2').datagrid('loadData', []);
            // 첫 행 자동 선택 → onD1aGrid1Select 트리거
            if (rows.length > 0) {
                $('#d1a-grid1').datagrid('selectRow', 0);
            }
        }
    });
}

/**
 * D1A 출고건 선택 → 불출자재 로드 (OUT_FLAG='1'만)
 */
function onD1aGrid1Select(index, row) {
    if (!row) return;

    _d1aContext.stkOutNo = row.stkOutNo;
    _d1aContext.mrpEmp = row.mrpEmp;

    loadD1aGrid2();
}

/**
 * D1A grid2 불출자재 목록 조회 (OUT_FLAG='1'만)
 */
function loadD1aGrid2() {
    $.ajax({
        url: consts.url.MAT05A_SER4,
        type: 'POST',
        data: {
            stkOutNo:  _d1aContext.stkOutNo,
            outFlag:   '1',
            isSel:     '1'
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            // AS-IS: IS_SEL='1' → flag=false → SEL 설정 스킵 (전체 미선택)
            $('#d1a-grid2').datagrid('loadData', rows);
        }
    });
}

/**
 * D1A 선택 체크박스 토글
 */
function toggleD1aSel(cb, index) {
    var rows = $('#d1a-grid2').datagrid('getRows');
    if (rows[index]) {
        rows[index].sel = cb.checked ? '1' : '0';
    }
}

/**
 * D1A 불출취소
 */
function doD1aCancel() {
    var allRows = $('#d1a-grid2').datagrid('getRows');
    var selectedRows = [];
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel === '1') {
            selectedRows.push({
                stkOutNo:     _d1aContext.stkOutNo,
                stkOutPartNo: allRows[i].stkOutPartNo || '',
                partCode:     allRows[i].partSpec,
                outFlag:      '0',
                prodCode:     _d1aContext.prodCode,
                woNo:         _d1aContext.woNo,
                procCode:     _d1aContext.procCode,
                sapWoNo:      _d1aContext.sapWoNo,
                mrpEmp:       _d1aContext.mrpEmp,
                banPartCode:  _d1aContext.partCode,
                orderNo:      _d1aContext.orderNo,
                orderLine:    _d1aContext.orderLine
            });
        }
    }

    if (selectedRows.length === 0) {
        $.messager.alert('알림', '취소할 자재를 선택해주세요.');
        return;
    }

    $.messager.confirm('확인', selectedRows.length + '건의 불출을 취소하시겠습니까?', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.MAT05A_DEL,
            type: 'POST',
            data: {models: JSON.stringify(selectedRows)},
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert('알림', result.success, 'info');
                    // AS-IS: 팝업 유지, 부모 grid1 인플레이스 갱신 (UpdateMapingRow)
                    updateParentGrid(result.updatedRow);
                    // AS-IS: SER5 응답의 partList에서 OUT_FLAG='0' 행 삭제 (DeleteMappingRow)
                    if (result.updatedRow && result.updatedRow.partList) {
                        var currentRows = $('#d1a-grid2').datagrid('getRows');
                        var keepRows = [];
                        // partList에서 OUT_FLAG='0'인 partSpec 수집
                        var cancelledParts = {};
                        var pl = result.updatedRow.partList;
                        for (var k = 0; k < pl.length; k++) {
                            if (pl[k].outFlag === '0' || pl[k].outFlag === 0) {
                                cancelledParts[pl[k].partSpec] = true;
                            }
                        }
                        // 현재 grid2에서 취소되지 않은 행만 유지
                        for (var i = 0; i < currentRows.length; i++) {
                            if (!cancelledParts[currentRows[i].partSpec]) {
                                keepRows.push(currentRows[i]);
                            }
                        }
                        $('#d1a-grid2').datagrid('loadData', keepRows);
                    }
                } else {
                    $.messager.alert('오류', result.error || '불출취소 실패');
                }
            },
            error: function() {
                $.messager.alert('오류', '서버 통신 오류');
            }
        });
    });
}

// ============================================================================
// 11. 포맷터 함수
// ============================================================================

/**
 * 수정가능 셀/체크박스 셀 배경색 (ord06a 동일)
 */
function editableCellStyler(value, row, index) {
    return 'background-color:#FFFFCC;';
}

/**
 * 공장 코드 → 공장명
 */
function formatPlants(value, row, index) {
    if (!value) return '';
    var items = consts.codeData.P009 || [];
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd == value) return items[i].codeName;
    }
    return value;
}

/**
 * WO_FLAG → 상태명
 */
function formatWoFlag(value, row, index) {
    if (value == null || value === '') return '';
    var label = value;
    var items = consts.codeData.S032 || [];
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd == value) { label = items[i].codeName; break; }
    }
    var colors = {'0':'#D3D3D3', '1':'#D4EDF7', '2':'#FF6347', '3':'#FFFF00', '4':'#00FF00'};
    if (colors[String(value)]) {
        return '<span style="display:block;background-color:' + colors[String(value)] + ';text-align:center;margin:-2px -8px;padding:2px 8px;">' + label + '</span>';
    }
    return label;
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

/**
 * 날짜 포맷 (yyyy-MM-dd)
 */
function formatShortDate(value, row, index) {
    if (value == null || value === '') return '';
    var s = String(value).replace(/T.*$/, '').trim();
    if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s;
    if (/^\d{8}$/.test(s)) return s.substr(0, 4) + '-' + s.substr(4, 2) + '-' + s.substr(6, 2);
    if (/^\d{12,14}$/.test(s)) return s.substr(0, 4) + '-' + s.substr(4, 2) + '-' + s.substr(6, 2);
    return s;
}

/**
 * 퍼센트 포맷
 */
function formatPercent(value, row, index) {
    if (value == null || value === '') return '';
    var num = parseFloat(value);
    if (isNaN(num)) return value;
    if (num === 100) return '100%';
    // AS-IS PER100 마스크: RegEx (\d{1,2}|\d{1,2}\.\d{1,2}|100)%
    // 소수점 앞 최대 2자리만 표시 → 172.41 → "17.41%" (AS-IS 버그, 값 잘림)
    var str = num.toFixed(2);
    var dotIdx = str.indexOf('.');
    if (dotIdx > 2) {
        str = str.substring(0, 2) + str.substring(dotIdx);
    }
    return str + '%';
}

/**
 * 불출 상태 아이콘 (1=완료O, 그외=미완X)
 */
function formatStatIcon(value, row, index) {
    if (value === '1') return '<span style="color:green; font-weight:bold;">O</span>';
    if (value === '0' || value != null) return '<span style="color:red;">X</span>';
    return '';
}

/**
 * WO_FLAG 색상 (사용하지 않으나 참조용 유지)
 * 색상 매핑: 0=#D3D3D3(회색), 1=#FFFF99(노랑), 2=#90EE90(초록), 3=#FFB6C1(분홍), 4=#ADD8E6(파랑)
 * → formatWoFlag 셀 포맷터로 이전 (상태 컬럼에만 배경색 적용)
 */

// ============================================================================
// 12. (clientPagerFilter → lsCommon.js 공통 함수로 이동)
// ============================================================================

// ============================================================================
// 13. 유틸리티 함수
// ============================================================================

function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').css('display', '');
}

function bindEnterKey(id) {
    $('#' + id).textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#' + id).textbox('setValue', $(this).val());
            doSearch();
        }
    });
}

/**
 * Date → 'yyyy-MM-dd' 문자열 변환
 */
function formatDateStr(d) {
    var yyyy = d.getFullYear();
    var mm = ('0' + (d.getMonth() + 1)).slice(-2);
    var dd = ('0' + d.getDate()).slice(-2);
    return yyyy + '-' + mm + '-' + dd;
}

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


/**
 * 도면 버튼 포맷터
 * AS-IS: RepositoryItemButtonEdit + glyphicons_halflings_13_ok2x (Navy ✓ 아이콘)
 *   - isFile='1': 버튼 활성(Navy ✓), 클릭 가능
 *   - isFile='0': 버튼 비활성(회색 ✓), 클릭 불가
 */
function formatDraw(val, row) {
    if (row.isFile === '1') {
        return '<a href="javascript:void(0)" class="grid-btn grid-btn-blue"'
             + ' onclick="openDraw(\'' + row.partSpec + '\')" title="도면 열기">&#10003;</a>';
    }
    return '<span class="grid-btn grid-btn-off" title="도면 없음">없음</span>';
}