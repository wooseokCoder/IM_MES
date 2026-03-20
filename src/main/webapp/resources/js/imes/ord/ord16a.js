/**
 * ============================================================================
 * 화면: ORD16A - 생산오더 완료처리
 * ============================================================================
 * 원본: ProActive ORD16A_M0A.cs
 * 작성일: 2026-03-04
 * 수정일: 2026-03-05 (AS-IS 동일화 - 그리드 38컬럼, 검색 15파라미터)
 *
 * 주요 기능:
 *   1. 작업지시 조회 (ORD16A_SER)
 *   2. 완료 처리 (ORD16A_UPD)
 *      - 진행중/일시중단 작업자 실적 종료
 *      - 비가동 종료
 *      - 작업지시 완료 (WO_FLAG=2)
 * ============================================================================
 */

// ============================================================================
// 1. 전역 변수
// ============================================================================
var gridData = [];

// WO_FLAG 상태 색상 매핑 (AS-IS 원본 동일)
var woFlagColors = {
    '0': '#D3D3D3',    // 대기 (LightGray)
    '1': '#F0F8FF',    // 진행 (AliceBlue) - AS-IS MC_OPERATE_CLR_WAIT
    '2': '#FF8C00',    // 완료 (DarkOrange) - AS-IS MC_OPERATE_CLR_RUN
    '3': '#FFFF00',    // 중지 (Yellow) - AS-IS MC_OPERATE_CLR_PAUSE
    '4': '#90EE90'     // 최종완료 (LightGreen) - AS-IS MC_OPERATE_CLR_FINISH
};

// WO_FLAG 상태명 매핑
var woFlagNames = {
    '0': '대기',
    '1': '진행',
    '2': '완료',
    '3': '중지',
    '4': '최종완료'
};

// ============================================================================
// 2. consts 객체
// ============================================================================
var consts = {
    url: {
        ORD16A_SER: getUrl('/imes/ord/ord16a/ORD16A_SER.json'),
        ORD16A_UPD: getUrl('/imes/ord/ord16a/ORD16A_UPD.json')
    },

    init: function() {
        // 버튼 바인딩
        $('#search-button').bind('click', doSearch);
        $('#btn-complete').bind('click', doComplete);

        // 그리드 초기화
        initGrid();

        // 그리드 헤더 컨텍스트 메뉴 (정렬/컬럼숨김/엑셀 등)
        GridHeaderMenu('#search-grid', { exportFileName: '작업지시현황' });
        
        enableGridSortReset('#search-grid');
    }
};

// ============================================================================
// 3. 초기화
// ============================================================================
$(function() {
    consts.init();
});

$(window).load(function() {
    // 날짜 초기값: 시작일 = 오늘-7일, 종료일 = 오늘
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);
    $('#s_startDate').datebox('setValue', formatDate(weekAgo));
    $('#s_endDate').datebox('setValue', formatDate(today));

    hideLoadingBar();
    bindEnterKey('s_orderLike');
    bindEnterKey('s_hogiLike');
    bindEnterKey('s_customerLike');
    $('#s_plants').combobox('setValue', '3603,3607');
});

// ============================================================================
// 4. 그리드 초기화 (AS-IS 38컬럼 순서 동일)
// ============================================================================
function initGrid() {
    var columns = [
        // #1 sel: 선택 체크박스 (가상 컬럼) - AS-IS 편집가능 셀 배경색 적용
        { field: 'sel', title: '선택', width: 50, halign: 'center', align: 'center',
          formatter: formatSelCheckbox,
          styler: function() { return 'background-color:#FFFFC0;'; }
        },
        // #2 prodCode: 관리코드 (hidden)
        { field: 'prodCode', title: '관리코드', hidden: true },
        // #3 plants: 공장
        { field: 'plants', title: '공장', width: 60, halign: 'center', align: 'center' },
        // #4 woNo: 지시번호 (hidden)
        { field: 'woNo', title: '지시번호', hidden: true },
        // #5 prodOrder: 판매오더 (hidden)
        { field: 'prodOrder', title: '판매오더', hidden: true },
        // #6 orderNo: 판매오더
        { field: 'orderNo', title: '판매오더', width: 100, halign: 'center', align: 'left' },
        // #7 orderLine: 품목
        { field: 'orderLine', title: '품목', width: 45, halign: 'center', align: 'center' },
        // #8 sapWoNo: 생산오더
        { field: 'sapWoNo', title: '생산오더', width: 140, halign: 'center', align: 'left' },
        // #9 indueWeek: 생산완료주차 (hidden)
        { field: 'indueWeek', title: '생산완료주차', hidden: true },
        // #10 prodHogi: 호기
        { field: 'prodHogi', title: '호기', width: 60, halign: 'center', align: 'center' },
        // #11 yearWeek: 수주주차 (hidden)
        { field: 'yearWeek', title: '수주주차', hidden: true },
        // #12 prodWeek: 생산시작주차
        { field: 'prodWeek', title: '생산시작주차', width: 80, halign: 'center', align: 'center' },
        // #13 dueDate: 계약납기일 (hidden, 날짜)
        { field: 'dueDate', title: '계약납기일', hidden: true,
          formatter: formatShortDate
        },
        // #14 sapDueDate: 납기일
        { field: 'sapDueDate', title: '납기일', width: 90, halign: 'center', align: 'center',
          formatter: formatShortYearDate
        },
        // #15 indueDate: 생산완료일
        { field: 'indueDate', title: '생산완료일', width: 90, halign: 'center', align: 'center',
          formatter: formatShortYearDate
        },
        // #16 customer: 수주처
        { field: 'customer', title: '수주처', width: 100, halign: 'center', align: 'left' },
        // #17 modelType: 타입
        { field: 'modelType', title: '타입', width: 60, halign: 'center', align: 'center' },
        // #18 procCode: 공정
        { field: 'procCode', title: '공정', width: 80, halign: 'center', align: 'center' },
        // #19 ingEmps: 작업자(진행)
        { field: 'ingEmps', title: '작업자(진행)', width: 120, halign: 'center', align: 'left' },
        // #20 stopEmps: 작업자(중지)
        { field: 'stopEmps', title: '작업자(중지)', width: 120, halign: 'center', align: 'left' },
        // #21 finEmps: 작업자(완료)
        { field: 'finEmps', title: '작업자(완료)', width: 120, halign: 'center', align: 'left' },
        // #22 idleEmps: 작업자(비가동)
        { field: 'idleEmps', title: '작업자(비가동)', width: 120, halign: 'center', align: 'left' },
        // #23 confirmDate: 작업지시확정일 (hidden, 날짜)
        { field: 'confirmDate', title: '작업지시확정일', hidden: true,
          formatter: formatShortDate
        },
        // #24 mcCode: 작업장 코드 (hidden)
        { field: 'mcCode', title: '작업장 코드', hidden: true },
        // #25 mcName: 작업장 (hidden)
        { field: 'mcName', title: '작업장', hidden: true },
        // #26 actStartTime: 실적 시작 (hidden, 날짜)
        { field: 'actStartTime', title: '실적 시작', hidden: true,
          formatter: formatDateTime
        },
        // #27 actEndTime: 실적 종료 (hidden, 날짜)
        { field: 'actEndTime', title: '실적 종료', hidden: true,
          formatter: formatDateTime
        },
        // #28 actSt: 실적 ST(분) (hidden, 숫자)
        { field: 'actSt', title: '실적 ST(분)', hidden: true,
          formatter: formatQty
        },
        // #29 woFlag: 상태 (LookUp S032)
        { field: 'woFlag', title: '상태', width: 60, halign: 'center', align: 'center',
          formatter: formatWoFlag,
          styler: woFlagStyler
        },
        // #30 bfPlnStartTime: 이전 계획 시작 (hidden, 날짜)
        { field: 'bfPlnStartTime', title: '이전 계획 시작', hidden: true,
          formatter: formatDateTime
        },
        // #31 bfPlnEndTime: 이전 계획 종료 (hidden, 날짜)
        { field: 'bfPlnEndTime', title: '이전 계획 종료', hidden: true,
          formatter: formatDateTime
        },
        // #32 plnStartTime: 계획 시작 (VARCHAR(12) → yyyy-MM-dd)
        { field: 'plnStartTime', title: '계획 시작', width: 130, halign: 'center', align: 'center',
          formatter: formatShortDate
        },
        // #33 plnEndTime: 계획 종료 (VARCHAR(12) → yyyy-MM-dd)
        { field: 'plnEndTime', title: '계획 종료', width: 130, halign: 'center', align: 'center',
          formatter: formatShortDate
        },
        // #34 plnSt: 계획 ST(분) (hidden, 숫자)
        { field: 'plnSt', title: '계획 ST(분)', hidden: true,
          formatter: formatQty
        },
        // #35 prgSeq: 공정순서 (hidden, 숫자)
        { field: 'prgSeq', title: '공정순서', hidden: true,
          formatter: formatQty
        },
        // #36 orderSeq: 판매오더순서 (hidden, 숫자)
        { field: 'orderSeq', title: '판매오더순서', hidden: true,
          formatter: formatQty
        },
        // #37 mcFlag: 작업장순서 (hidden, 숫자)
        { field: 'mcFlag', title: '작업장순서', hidden: true,
          formatter: formatQty
        },
        // #38 prodType: (hidden)
        { field: 'prodType', title: 'prodType', hidden: true }
    ];

    $('#search-grid').datagrid({
        columns: [columns],
        fit: true,
        fitColumns: false,
        striped: false,
        singleSelect: true,
        pagination: true,
        pageSize: 100,
        loadFilter: clientPagerFilter,
        rownumbers: true,
        nowrap: true,
        toolbar: '#search-toolbar',
        onLoadSuccess: function(data) {
            $('#search-grid').datagrid('unselectAll');
        }
    });
}

// ============================================================================
// 5. 조회 (ORD16A_SER) - 15파라미터 전달
// ============================================================================
function doSearch() {
    $('#search-grid').datagrid('loading');

    // 검색 조건 수집
    var dateTypes = $('#s_dateType').combobox('getValues') || [];
    var startDate = $('#s_startDate').datebox('getValue') || '';
    var endDate = $('#s_endDate').datebox('getValue') || '';

    // 날짜 형식 변환: yyyy-MM-dd → yyyyMMdd
    var sDate = startDate.replace(/-/g, '');
    var eDate = endDate.replace(/-/g, '');

    // 기본 검색 파라미터
    var params = {
        orderLike:    $('#s_orderLike').textbox('getValue'),
        hogiLike:     $('#s_hogiLike').textbox('getValue'),
        customerLike: $('#s_customerLike').textbox('getValue'),
        plants:       $('#s_plants').combobox('getValue')
    };

    // 체크된 일자구분별 날짜 범위 설정
    for (var i = 0; i < dateTypes.length; i++) {
        if (dateTypes[i] === 'PLN_DATE') {
            params.sPlnDate = sDate;
            params.ePlnDate = eDate;
        } else if (dateTypes[i] === 'INDUE_DATE') {
            params.sIndueDate = sDate;
            params.eIndueDate = eDate;
        } else if (dateTypes[i] === 'SAP_DUE_DATE') {
            params.sSapDueDate = sDate;
            params.eSapDueDate = eDate;
        } else if (dateTypes[i] === 'DUE_DATE') {
            params.sDueDate = sDate;
            params.eDueDate = eDate;
        }
    }

    $.ajax({
        url: consts.url.ORD16A_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            gridData = result.rows || [];

            // SEL 컬럼 초기화
            for (var i = 0; i < gridData.length; i++) {
                gridData[i].sel = '0';
            }

            $('#search-grid').datagrid('loadData', gridData);
            $('#search-grid').datagrid('loaded');
        },
        error: function() {
            $('#search-grid').datagrid('loaded');
            $.messager.alert(getTitle('ERROR'), '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 6. 완료 처리 (ORD16A_UPD)
// AS-IS 흐름:
//   1. 선택된 행(SEL='1') 수집 (없으면 현재 선택행 사용)
//   2. 각 행의 WO_NO, MC_CODE, ACT_START_TIME 전달
//   3. 서버에서 진행중/일시중단 실적 종료 + 비가동 종료 + WO_FLAG=2
// ============================================================================
function doComplete() {
    // SEL 체크된 행 수집
    var allRows = $('#search-grid').datagrid('getRows');
    var rows = [];

    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel === '1') {
            rows.push({
                woNo:         allRows[i].woNo,
                mcCode:       allRows[i].mcCode || '',
                actStartTime: allRows[i].actStartTime || ''
            });
        }
    }

    // 체크된 행이 없으면 현재 선택된 행 사용 (AS-IS 동작)
    if (rows.length === 0) {
        var selected = $('#search-grid').datagrid('getSelected');
        if (!selected) {
            $.messager.alert(getTitle('ALERT'), '완료 처리할 작업지시를 선택해 주세요.', 'info');
            return;
        }
        rows.push({
            woNo:         selected.woNo,
            mcCode:       selected.mcCode || '',
            actStartTime: selected.actStartTime || ''
        });
    }

    // 이미 완료된 행 제외 확인
    var completedCount = 0;
    for (var j = 0; j < rows.length; j++) {
        for (var k = 0; k < allRows.length; k++) {
            if (allRows[k].woNo === rows[j].woNo && allRows[k].woFlag === '2') {
                completedCount++;
            }
        }
    }

    if (completedCount > 0) {
        $.messager.alert(getTitle('ALERT'), '이미 완료된 작업지시가 ' + completedCount + '건 포함되어 있습니다.', 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), rows.length + '건의 작업지시를 완료 처리하시겠습니까?', function(r) {
        if (!r) return;

        $.ajax({
            url: consts.url.ORD16A_UPD,
            type: 'POST',
            data: {
                modelList: JSON.stringify(rows)
            },
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    $.messager.alert(getTitle('INFO'), result.success, 'info');
                    doSearch();
                } else {
                    $.messager.alert(getTitle('ERROR'), result.error || '완료 처리 실패', 'error');
                }
            },
            error: function() {
                $.messager.alert(getTitle('ERROR'), '완료 처리 중 오류가 발생했습니다.', 'error');
            }
        });
    });
}

// ============================================================================
// 7. 포맷터
// ============================================================================

/**
 * 공정선택 체크박스 포맷터
 */
function formatSelCheckbox(value, row, index) {
    var checked = (value === '1') ? 'checked="checked"' : '';
    return '<input type="checkbox" ' + checked + ' onclick="toggleSel(' + index + ', this)" />';
}

/**
 * SEL 토글
 */
function toggleSel(index, checkbox) {
    var rows = $('#search-grid').datagrid('getRows');
    rows[index].sel = checkbox.checked ? '1' : '0';
}

/**
 * SHORT_DATE 포맷터 (yyyyMMdd[HHmmss] → yyyy-MM-dd)
 */
function formatShortDate(value) {
    if (!value) return '';
    var s = String(value).replace(/[-: ]/g, '');
    if (s.length < 8) return value;
    return s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
}

/**
 * SHORT_DATE 포맷터 (yyyyMMdd[HHmmss] → yy-MM-dd)
 */
function formatShortYearDate(value) {
    if (!value) return '';
    var s = String(value).replace(/[-: ]/g, '');
    if (s.length < 8) return value;
    return s.substring(2, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
}


/**
 * 날짜/시간 포맷터 (yyyyMMddHHmmss → yyyy-MM-dd HH:mm)
 */
function formatDateTime(value) {
    if (!value) return '';
    var s = String(value).replace(/[-: ]/g, '');
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
 * QTY 숫자 포맷터 (#,##0)
 */
function formatQty(value) {
    if (value === null || value === undefined || value === '') return '';
    var num = Number(value);
    if (isNaN(num)) return value;
    return num.toLocaleString('en-US', { maximumFractionDigits: 0 });
}

/**
 * WO_FLAG 포맷터
 */
function formatWoFlag(value) {
    return woFlagNames[String(value)] || value || '';
}

/**
 * WO_FLAG 셀 배경색 styler
 */
function woFlagStyler(value) {
    var color = woFlagColors[String(value)];
    if (color) {
        return 'background-color:' + color + ';';
    }
}


// ============================================================================
// 9. 유틸리티
// ============================================================================

function pad2(n) {
    return (n < 10 ? '0' : '') + n;
}

/**
 * Date → YYYY-MM-DD 문자열
 */
function formatDate(dt) {
    return dt.getFullYear() + '-' + pad2(dt.getMonth() + 1) + '-' + pad2(dt.getDate());
}

/**
 * 로딩바 숨기기 + 레이아웃 표시
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

/**
 * 텍스트박스 Enter 키 바인딩 → 조회
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
 * 다국어 타이틀
 */
function getTitle(key) {
    if (typeof tit !== 'undefined') {
        switch (key) {
            case 'ALERT':   return tit.TITLE0001 || '알림';
            case 'INFO':    return (typeof msg !== 'undefined' && msg.MSG0052) || '정보';
            case 'ERROR':   return (typeof msg !== 'undefined' && msg.MSG0068) || '오류';
            case 'CONFIRM': return (typeof msg !== 'undefined' && msg.MSG0053) || '확인';
        }
    }
    switch (key) {
        case 'ALERT':   return '알림';
        case 'INFO':    return '정보';
        case 'ERROR':   return '오류';
        case 'CONFIRM': return '확인';
        default:        return key;
    }
}
