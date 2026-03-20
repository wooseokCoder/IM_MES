/**
 * ============================================================================
 * 화면: POP32A - 비가동 현황 (조립)
 * ============================================================================
 * 원본: ProActive POP32A_M0A.cs (AS-IS 화면ID: POP32A, PLANTS=3603)
 * 작성일: 2026-03-04
 *
 * 주요 기능:
 *   1. 비가동 이력 조회 (POP32A_SER)
 *   2. 비가동 신규등록 (D0A 팝업 - 별도 개발 예정)
 *   3. 비가동 삭제 (POP32A_DEL)
 *
 * 서비스 매핑:
 *   AS-IS POP32A_SER  → 비가동 이력 목록 조회
 *   AS-IS POP32A_DEL  → 비가동 삭제 (논리삭제)
 *
 * 그리드 컬럼:
 *   Hidden: idleId, idleCode, empCode, mcCode
 *   Visible: ifFlag(SAP전송), empName(작업자), mcName(작업장),
 *            idleName(비가동구분), startTime(시작시간), endTime(완료시간),
 *            idleTime(비가동시간), regEmpName(등록자)
 * ============================================================================
 */

// ============================================================================
// 1. consts 객체 (URL 설정 및 초기화)
// ============================================================================
var consts = {
    url: {
        /** 비가동 이력 조회 (AS-IS: POP32A_SER) */
        POP32A_SER:  getUrl('/imes/pop/pop32a/POP32A_SER.json'),
        /** 비가동 삭제 (AS-IS: POP32A_DEL) */
        POP32A_DEL:  getUrl('/imes/pop/pop32a/POP32A_DEL.json')
    },

    /**
     * 초기화 함수
     * - 버튼 이벤트 바인딩
     * - 컨텍스트 메뉴 바인딩
     * - 그리드 초기화
     */
    init: function() {
        // 조회/신규등록/삭제 버튼 바인딩
        $('#search-button').bind('click', doSearch);
        $('#append-button').bind('click', doAppend);
        $('#delete-button').bind('click', doDelete);

        // 그리드 초기화
        initGrid();

        // 그리드 헤더 컨텍스트 메뉴 (정렬/컬럼숨김/엑셀 등)
        GridHeaderMenu('#search-grid', { exportFileName: '비가동현황' });
        
        enableGridSortReset('#search-grid');
    }
};

// ============================================================================
// 2. jQuery Ready - consts 초기화
// ============================================================================
$(function() {
    consts.init();
});

// ============================================================================
// 3. window.load - 로딩바 숨김, 날짜 초기화, 초기 조회
// ============================================================================
$(window).load(function() {
    // EasyUI 파싱 완료 후 acWeekDate 초기화
    // AS-IS: acWeekDate1 컴포넌트 (주간 모드, 월~일 범위)
    // mode='WEEK': 자동으로 현재 주 월~일 설정 + 주차 표시
    acWeekDate.init({
        prefix: 'wd1',
        mode: 'DATE',
        onPrev: doSearch,
        onNext: doSearch
    });

    hideLoadingBar();
    //doSearch();
});

// ============================================================================
// 4. 그리드 초기화
// ============================================================================
/**
 * 메인 그리드 초기화 (AS-IS: acGridView1, GridType=SEARCH, 읽기전용)
 * - toolbar: 조회 영역 (#search-toolbar)
 * - 컨텍스트 메뉴: 우클릭 시 #grid-context-menu 표시
 * - 단일 선택, 페이징 없음, 행 번호 표시
 */
function initGrid() {
    $('#search-grid').datagrid({
        toolbar: '#search-toolbar',
        fit: true,
        singleSelect: true,
        pagination: true,
        pageSize: 100,
        loadFilter: clientPagerFilter,
        rownumbers: true,
        nowrap: true,
        striped: true,
        /**
         * 더블클릭 시 수정 팝업(D2A) 열기
         * AS-IS: 컨텍스트 메뉴 "열기" → 더블클릭으로 변경
         */
        onDblClickRow: function(index, row) {
            if (row) {
                doOpenEdit();
            }
        },
        /**
         * 데이터 로드 완료 시 선택 해제
         */
        onLoadSuccess: function(data) {
            $('#search-grid').datagrid('unselectAll');
        }
    });
}

// ============================================================================
// 5. 조회 (POP32A_SER)
// ============================================================================
/**
 * 비가동 이력 조회
 * - 검색 조건: 시작일(startDate), 종료일(endDate)
 * - 날짜 형식: datebox의 yyyy-MM-dd → yyyyMMdd로 변환하여 서버 전송
 * - AS-IS: POP32A_SER 서비스 (TSHP_IDLETIME_QUERY2 기반)
 */
function doSearch() {
    // acWeekDate에서 yyyy-MM-dd 형식 값 가져오기
    var sDate = acWeekDate.getStartDate('wd1');
    var eDate = acWeekDate.getEndDate('wd1');

    if (!sDate || !eDate) {
        $.messager.alert('알림', '검색 기간을 선택해주세요.');
        return;
    }
    $('#search-grid').datagrid('loading');
    $.ajax({
        url: consts.url.POP32A_SER,
        type: 'POST',
        data: {
            // AS-IS 파라미터: S_IDLE_DATE=yyyyMMdd, E_IDLE_DATE=yyyyMMdd
        	sIdleDate: sDate.replace(/-/g, ''),
        	eIdleDate:   eDate.replace(/-/g, '')
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#search-grid').datagrid('loadData', rows);
            $('#search-grid').datagrid('loaded');

        },
        error: function() {
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 6. 신규등록 (D0A 팝업 오픈)
// ============================================================================
/**
 * 신규등록 - 비가동 등록 팝업(D0A) 열기
 * AS-IS: POP32A_M0A.cs > acBarButtonItem3_ItemClick → POP32A_D0A (NEW mode)
 * - D0A 팝업은 별도 개발자 담당
 */
function doAppend() {
    // TODO: D0A 팝업 구현 후 등록 다이얼로그 오픈 코드로 교체
    //$.messager.alert('알림', '등록 팝업은 별도 개발 예정입니다.', 'info');
	doOpenNew();
}

/**
 * 컨텍스트 메뉴 "열기" - 비가동 수정 팝업(D2A) 열기
 * AS-IS: POP32A_M0A.cs > acBarButtonItem5_ItemClick
 * - IF_FLAG=1(SAP 전송완료) 건은 수정 불가
 * - D2A 팝업은 별도 개발자 담당
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

    // D2A 수정 팝업 열기
    doOpenD2a(row);
}

// ============================================================================
// 7. 삭제 (POP32A_DEL)
// ============================================================================
/**
 * 비가동 삭제 (논리 삭제: DATA_FLAG=2)
 * - 선택된 행이 없으면 안내 메시지 표시
 * - SAP 전송 완료(ifFlag=2)인 건은 삭제 불가
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
// 9. 포맷터 (Formatter)
// ============================================================================

/**
 * SAP 전송 상태 포맷터 (AS-IS: AddCheckEdit "IF_FLAG")
 * - '' 또는 null → ''
 * - '1' → '○' (전송대기/미전송)
 * - '2' → '전송완료'
 * - 기타 → ''
 *
 * @param {String} value IF_FLAG 값
 * @returns {String} 표시 문자열
 */
function formatIfFlag(value) {
    //if (value === '1') return '\u25CB';  // ○
    //if (value === '2') return '\uC804\uC1A1\uC644\uB8CC';  // 전송완료
    var checked = (value === '1') ? 'checked="checked"' : '';
    return  '<input type="checkbox" ' + checked + ' disabled/>';;
}

/**
 * 날짜/시간 포맷터 (yyyyMMddHHmmss → yyyy-MM-dd HH:mm:ss)
 * - AS-IS: AddDateEdit LONG_DATE2 형식
 * - null/빈값 → 빈 문자열
 * - yyyyMMddHHmmss (14자리) → yyyy-MM-dd HH:mm:ss
 *
 * @param {String} value 날짜시간 문자열 (yyyyMMddHHmmss)
 * @returns {String} 포맷된 날짜시간 (yyyy-MM-dd HH:mm:ss)
 */
function formatDateTime(value) {
    if (!value) return '';
    // 이미 포맷된 문자열이거나 구분자가 있으면 구분자 제거 후 파싱
    var s = String(value).replace(/[-: ]/g, '');
    if (s.length < 8) return value;
    // yyyy-MM-dd 부분
    var result = s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
    // HH:mm:ss 부분 (14자리 이상이면 시:분:초 포함)
    if (s.length >= 14) {
        result += ' ' + s.substring(8, 10) + ':' + s.substring(10, 12) + ':' + s.substring(12, 14);
    } else if (s.length >= 12) {
        result += ' ' + s.substring(8, 10) + ':' + s.substring(10, 12) + ':00';
    } else if (s.length >= 10) {
        result += ' ' + s.substring(8, 10) + ':00:00';
    }
    return result;
}

/**
 * 숫자 포맷터 (#,##0 콤마 구분)
 * - AS-IS: AddTextEdit QTY 형식
 * - null/빈값 → 빈 문자열
 * - 숫자 → 콤마 구분 문자열
 *
 * @param {String|Number} value 숫자 값
 * @returns {String} 콤마 구분된 숫자 문자열
 */
function formatQty(value) {
    if (value === null || value === undefined || value === '') return '';
    var num = Number(value);
    if (isNaN(num)) return value;
    return num.toLocaleString('en-US', { maximumFractionDigits: 0 });
}


// ============================================================================
// 11. 유틸리티 함수
// ============================================================================

/**
 * Date 객체를 yyyy-MM-dd 문자열로 변환
 * - datebox setValue에 사용하는 표준 날짜 형식
 *
 * @param {Date} dt 날짜 객체
 * @returns {String} yyyy-MM-dd 형식 문자열
 */
function formatDate(dt) {
    return dt.getFullYear() + '-' + pad2(dt.getMonth() + 1) + '-' + pad2(dt.getDate());
}

/**
 * 2자리 패딩 (1 → '01', 12 → '12')
 *
 * @param {Number} n 숫자
 * @returns {String} 2자리 문자열
 */
function pad2(n) {
    return (n < 10 ? '0' : '') + n;
}

/**
 * 로딩바 숨기기 + 레이아웃 표시
 * - 화면 초기 로드 완료 시 호출
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}
