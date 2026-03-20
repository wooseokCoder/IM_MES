/**
 * ============================================================================
 * 화면명: REP09A - 가공 진행현황
 * ============================================================================
 * 설명: 동적 공정 컬럼 그리드 + D0A 상세 팝업 + D1A 완료공정 팝업
 * 원본: ProActive REP09A_M0A.cs / REP09A_D0A.cs / REP09A_D1A.cs
 * 작성일: 2026-03-17 (v2 - ord13a 패턴 기반 재작성)
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var PLANTS     = '3605'; // 가공 공장 (원본 하드코딩)
var woFlagMap  = {};     // "sapWoNo+woSeq" → woFlag
var empMap     = {};     // "sapWoNo+woSeq" → [empName, ...]
var woDetailData = [];   // WO 공정 상세 (동적 컬럼 데이터)
var maxProcCnt = 0;      // 최대 공정 수
var gridInited = false;
var currentProcCnt = 5;  // 현재 그리드에 생성된 공정 컬럼 수

// WO_FLAG별 색상 매핑 (tsys_conf MC_OPERATE_CLR_* ARGB 변환값)
var colors = {
    '0':  '#D3D3D3',   // 미확정 (LightGray - 고정)
    '1':  '#F0F8FF',   // 확정 (_WAIT: AliceBlue)
    '2':  '#FF8C00',   // 진행 (_RUN: DarkOrange)
    '3':  '#FFFF00',   // 중지 (_PAUSE: Yellow)
    '4':  '#90EE90',   // 완료 (_FINISH: 올리브)
    '03': '#D3D3D3',   // LightGray
    '11': '#5F9EA0'    // CadetBlue
};

// WO_FLAG → 라벨 매핑 (원본: S032 코드 테이블)
var woFigMap = {
    '0':'미확정', '1':'확정', '2':'진행', '3':'중지',
    '4':'완료', '03':'미확정', '11':'특수'
};

// ============================================================================
// consts
// ============================================================================
var consts = {
    url: {
        REP09A_SER:  getUrl('/imes/rep/rep09a/REP09A_SER.json'),
        REP09A_SER2: getUrl('/imes/rep/rep09a/REP09A_SER2.json'),
        REP09A_SER3: getUrl('/imes/rep/rep09a/REP09A_SER3.json'),
        REP09A_SER4: getUrl('/imes/rep/rep09a/REP09A_SER4.json')
    },

    init: function() {
        $('#search-button').bind('click', doSearch);
        $('#d1a-button').bind('click', doOpenD1a);

        // 컨텍스트 메뉴
        $('#ctx-detail').on('click', function() {
            var row = $('#search-grid').datagrid('getSelected');
            if (row) doOpenD0a(row);
        });
    }
};

// ============================================================================
// 화면 초기화
// ============================================================================
$(function() {
    consts.init();
});

$(window).load(function() {
    hideLoadingBar();

    // 기본값: 당월 1일 ~ 말일
    var now = new Date();
    var y = now.getFullYear();
    var m = ('0' + (now.getMonth() + 1)).slice(-2);
    var lastDay = new Date(y, now.getMonth() + 1, 0).getDate();
    $('#s_planDate').datebox('setValue', y + '-' + m + '-01');
    $('#e_planDate').datebox('setValue', y + '-' + m + '-' + ('0' + lastDay).slice(-2));

    // Enter 키 바인딩
    bindEnterKey('s_sapWoLike');
    bindEnterKey('s_modelLike');
    bindEnterKey('s_partLike');

    // 초기 그리드 생성 (원본 SetGrid(5) → 10~50 컬럼 미리 생성)
    initGrid(5);

    // D0A/D1A 팝업 그리드 초기화
    initD0aGrids();
    initD1aGrids();
});

// ============================================================================
// 그리드 초기화 (동적 컬럼 생성) — ord13a.initGrid 패턴
// procCnt: 동적 공정 컬럼 수 (원본 SetGrid의 proc_cnt)
// ============================================================================
function initGrid(procCnt) {
    procCnt = procCnt || 0;
    var columns = [];

    // 고정 컬럼 (필드명은 SP 반환 UPPER_CASE 그대로 사용)
    columns.push({field:'SAP_WO_NO', title:'생산오더', width:140, halign:'center', align:'left'});
    columns.push({field:'MODEL',     title:'MODEL',    width:100, halign:'center', align:'center'});
    columns.push({field:'PART_CODE', title:'부품코드', width:120, halign:'center', align:'left'});
    columns.push({field:'PART_NAME', title:'부품명',   width:200, halign:'center', align:'left'});

    // 동적 공정 컬럼 (원본: WO_SEQ 값 "10","20",... 을 헤더로 표시)
    for (var i = 1; i <= procCnt; i++) {
        var fName = String(i * 10); // "10", "20", "30", ...
        (function(fn) {
            // 공정 컬럼 (헤더: "10", "20", ...)
            columns.push({
                field: fn,
                title: fn,
                width: 120,
                halign: 'center',
                align: 'center',
                formatter: function(value) {
                    if (!value) return '';
                    return String(value).replace(/\n/g, '<br>');
                },
                styler: function(value, row, index) {
                    var flag = woFlagMap[row.SAP_WO_NO + fn];
                    if (flag !== undefined && colors[flag]) {
                        return 'background-color:' + colors[flag] + ';';
                    }
                    return '';
                }
            });
            // 작업자 컬럼 (헤더: "10 작업자", "20 작업자", ...)
            columns.push({
                field: fn + '_EMP',
                title: fn + ' 작업자',
                width: 120,
                halign: 'center',
                align: 'center',
                formatter: function(value) {
                    if (!value) return '';
                    return String(value).replace(/\n/g, '<br>');
                },
                styler: function(value, row, index) {
                    var flag = woFlagMap[row.SAP_WO_NO + fn];
                    if (flag !== undefined && colors[flag]) {
                        return 'background-color:' + colors[flag] + ';';
                    }
                    return '';
                }
            });
        })(fName);
    }

    // 그리드 (재)생성
    $('#search-grid').datagrid({
        columns: [columns],
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: true,
        rownumbers: true,
        nowrap: false,
        toolbar: '#search-toolbar',
        pageNumber: 1,
        pageSize: parseInt(gconsts.PAGE_SIZE) || 100,
        pageList: [50, 100, 200, 500],
        loadFilter: clientPagerFilter,
        rowHeight: 60,
        onRowContextMenu: function(e, index, row) {
            e.preventDefault();
            $(this).datagrid('selectRow', index);
            $('#grid-context-menu').menu('show', {left: e.pageX, top: e.pageY});
        },
        onDblClickRow: function(index, row) {
            if (row) doOpenD0a(row);
        },
        onLoadSuccess: function() {
            $(this).datagrid('unselectAll');
        }
    });

    gridInited = true;
    currentProcCnt = procCnt;
    enableGridSortReset('#search-grid');
    GridHeaderMenu('#search-grid', {exportFileName: '가공진행현황'});
}

// ============================================================================
// 조회 (REP09A_SER)
// ============================================================================
function doSearch() {
    var sDate = $('#s_planDate').datebox('getValue');
    var eDate = $('#e_planDate').datebox('getValue');

    if (!sDate || !eDate) {
        $.messager.alert(getTitle('ALERT'), '검색 기간을 선택해주세요.');
        return;
    }

    $('#search-grid').datagrid('loading');

    $.ajax({
        url: consts.url.REP09A_SER,
        type: 'POST',
        data: {
            plants:     PLANTS,
            sPlanDate:  sDate.replace(/-/g, ''),
            ePlanDate:  eDate.replace(/-/g, ''),
            sapWoLike:  $('#s_sapWoLike').textbox('getValue'),
            modelLike:  $('#s_modelLike').textbox('getValue'),
            partLike:   $('#s_partLike').textbox('getValue')
        },
        dataType: 'json',
        success: function(result) {
            // ── 응답 구조: result.rows = {rows:[], woRows:[], empRows:[]} ──
            var data = result.rows || {};
            var summaryData = data.rows    || [];
            var woRows      = data.woRows  || [];
            var empRows     = data.empRows || [];

            // 1. max(PROC_CNT) 계산
            maxProcCnt = 0;
            for (var i = 0; i < summaryData.length; i++) {
                var cnt = parseInt(summaryData[i].PROC_CNT) || 0;
                if (cnt > maxProcCnt) maxProcCnt = cnt;
            }

            // 2. summaryData에 동적 필드 초기화
            for (var i = 0; i < summaryData.length; i++) {
                for (var j = 1; j <= maxProcCnt; j++) {
                    summaryData[i][String(j * 10)] = '';
                    summaryData[i][String(j * 10) + '_EMP'] = '';
                }
            }

            // 3. EMP 인덱스: key="SAP_WO_NO|WO_SEQ" → [EMP_NAME, ...]
            empMap = {};
            for (var i = 0; i < empRows.length; i++) {
                var emp = empRows[i];
                var key = emp.SAP_WO_NO + '|' + emp.WO_SEQ;
                if (!empMap[key]) empMap[key] = [];
                empMap[key].push(emp.EMP_NAME || '');
            }

            // 4. woFlagMap 구축 + summaryData 셀 텍스트 매핑
            //    (원본 QuickSearch 로직 충실 이식)
            woFlagMap = {};
            woDetailData = woRows;

            for (var i = 0; i < woRows.length; i++) {
                var d = woRows[i];
                var sapWoNo  = d.SAP_WO_NO;
                var woSeq    = String(d.WO_SEQ);
                var woFlag   = String(d.WO_FLAG);
                var procCode = d.PROC_CODE || '';

                woFlagMap[sapWoNo + woSeq] = woFlag;

                // 셀 표시 텍스트: 공정코드\n계획시작~계획종료\n실적시작~실적종료
                var plnS = toShortDate(d.PLN_START_TIME);
                var plnE = toShortDate(d.PLN_END_TIME);
                var actS = toShortDate(d.ACT_START_TIME);
                var actE = toShortDate(d.ACT_END_TIME);
                var dispText = procCode + '\n' + plnS + '~' + plnE + '\n' + actS + '~' + actE;

                // 작업자 텍스트 (원본: 2명마다 줄바꿈)
                var emps = empMap[sapWoNo + '|' + woSeq] || [];
                var empText = '';
                for (var e = 0; e < emps.length; e++) {
                    empText += emps[e] + ',';
                    if ((e + 1) % 2 === 0) {
                        empText = empText.substring(0, empText.length - 1) + '\n';
                    }
                }
                if (empText.length > 0) empText = empText.replace(/[,\n]$/, '');

                // summaryData에 매핑 (SAP_WO_NO 매칭)
                for (var k = 0; k < summaryData.length; k++) {
                    if (summaryData[k].SAP_WO_NO === sapWoNo) {
                        summaryData[k][woSeq] = dispText;
                        summaryData[k][woSeq + '_EMP'] = empText;
                        break;
                    }
                }
            }

            // 5. 컬럼 수 변경 시에만 그리드 재생성
            if (maxProcCnt !== currentProcCnt) {
                initGrid(maxProcCnt);
            }

            // 6. 그리드에 데이터 로드
            $('#search-grid').datagrid('loadData', summaryData);
            $('#search-grid').datagrid('loaded');
        },
        error: function() {
            $('#search-grid').datagrid('loaded');
            $.messager.alert(getTitle('ERROR'), '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// D0A 상세 팝업 (우클릭/더블클릭 → 원본: REP09A_D0A)
// ============================================================================
function doOpenD0a(row) {
    var sapWoNo = row.SAP_WO_NO || '';
    if (!sapWoNo) return;

    $('#d0a-model').textbox('setValue', row.MODEL || '');
    $('#d0a-partname').textbox('setValue', row.PART_NAME || '');
    $('#d0a-dialog').dialog('center');
    $('#d0a-dialog').dialog('open');
    $('#d0a-tabs').tabs('select', 0);

    $.ajax({
        url: consts.url.REP09A_SER2,
        type: 'POST',
        data: {plants: PLANTS, sapWoNo: sapWoNo},
        dataType: 'json',
        success: function(result) {
            var d = result.rows || {};
            $('#d0a-proc-grid').datagrid('loadData', d.procRows || []);
            $('#d0a-act-grid').datagrid('loadData',  d.actRows  || []);
            $('#d0a-ng-grid').datagrid('loadData',   d.ngRows   || []);
            $('#d0a-ins-grid').datagrid('loadData',  d.insRows  || []);
        },
        error: function() {
            $.messager.alert(getTitle('ERROR'), 'D0A 조회 중 오류가 발생했습니다.', 'error');
        }
    });
    
    enableGridSortReset('#d0a-proc-grid');
    enableGridSortReset('#d0a-act-grid');
    enableGridSortReset('#d0a-ng-grid');
    enableGridSortReset('#d0a-ins-grid');
}

function initD0aGrids() {
    // D0A 닫기 시 그리드 초기화
    $('#d0a-dialog').dialog({
        onClose: function() {
            $('#d0a-proc-grid').datagrid('loadData', []);
            $('#d0a-act-grid').datagrid('loadData', []);
            $('#d0a-ng-grid').datagrid('loadData', []);
            $('#d0a-ins-grid').datagrid('loadData', []);
            $('#d0a-model').textbox('setValue', '');
            $('#d0a-partname').textbox('setValue', '');
        }
    });

    // 공정별 상태 (원본 GridView1)
    $('#d0a-proc-grid').datagrid({
        fit: true, singleSelect: true, rownumbers: true, striped: true,
        columns: [[
            {field:'SAP_WO_NO',  title:'생산오더번호', width:120, align:'center'},
            {field:'PROC_CODE',  title:'공정',         width:100, align:'center'},
            {field:'WO_FLAG',    title:'상태',         width:80,  align:'center',
                formatter: function(v) { return woFigMap[String(v || '0')] || v; }
            }
        ]]
    });

    // 실적/비가동 (원본 GridView2)
    $('#d0a-act-grid').datagrid({
        fit: true, singleSelect: true, rownumbers: true, striped: true,
        columns: [[
            {field:'ACT_TYPE',       title:'구분',         width:60,  align:'center'},
            {field:'EMP_NAME',       title:'작업자',       width:80,  align:'center'},
            {field:'PROC_CODE',      title:'공정',         width:80,  align:'center'},
            {field:'PRE_WORK',       title:'준비작업 여부', width:90,  align:'center'},
            {field:'IDLE_NAME',      title:'비가동',       width:100, align:'center'},
            {field:'ACT_START_TIME', title:'시작시간',     width:140, align:'center', formatter: formatDateTime},
            {field:'ACT_END_TIME',   title:'종료시간',     width:140, align:'center', formatter: formatDateTime},
            {field:'ACT_TIME',       title:'시간(분)',     width:70,  align:'right'}
        ]]
    });

    // 부적합 (원본 GridView3)
    $('#d0a-ng-grid').datagrid({
        fit: true, singleSelect: true, rownumbers: true, striped: true,
        columns: [[
            {field:'NG_DATE',       title:'발생일',       width:100, align:'center', formatter: formatDate},
            {field:'EMP_NAME',      title:'작업자',       width:80,  align:'center'},
            {field:'PROC_CODE',     title:'공정',         width:80,  align:'center'},
            {field:'MASTER_CAUSE',  title:'불량유형',     width:100, align:'center'},
            {field:'DETAIL_CAUSE',  title:'불량유형 상세', width:120, align:'center'},
            {field:'NG_CONTENTS',   title:'불량현상',     width:200, align:'left'}
        ]]
    });

    // 자주검사 (원본 GridView4)
    $('#d0a-ins-grid').datagrid({
        fit: true, singleSelect: true, rownumbers: true, striped: true,
        columns: [[
            {field:'EMP_NAME',   title:'작업자',     width:80,  align:'center'},
            {field:'REG_DATE',   title:'등록일',     width:100, align:'center', formatter: formatDate},
            {field:'PROC_CODE',  title:'공정',       width:80,  align:'center'},
            {field:'INS_NAME',   title:'검사항목명', width:120, align:'left'},
            {field:'INS_DESC',   title:'점검내역',   width:150, align:'left'},
            {field:'AVG_VAL',    title:'기준값',     width:70,  align:'center'},
            {field:'MIN_VAL',    title:'Min',        width:70,  align:'center', formatter: formatF2},
            {field:'MAX_VAL',    title:'Max',        width:70,  align:'center', formatter: formatF2},
            {field:'INS_RESULT', title:'검사결과',   width:80,  align:'center'}
        ]]
    });
}

// ============================================================================
// D1A 완료공정 팝업 (원본: REP09A_D1A)
// ============================================================================
function doOpenD1a() {
    var sDate = $('#s_planDate').datebox('getValue');
    var eDate = $('#e_planDate').datebox('getValue');

    if (!sDate || !eDate) {
        $.messager.alert(getTitle('ALERT'), '검색 기간을 먼저 설정해주세요.');
        return;
    }
    
    $('#d1a-dialog').dialog('center');
    $('#d1a-dialog').dialog('open');
    $('#d1a-tabs').tabs('select', 0);

    // 상단 정보 초기화
    $('#d1a-sapwono').textbox('setValue', '');
    $('#d1a-model').textbox('setValue', '');
    $('#d1a-partname').textbox('setValue', '');

    $('#d1a-master-grid').datagrid('loading');
    $.ajax({
        url: consts.url.REP09A_SER3,
        type: 'POST',
        data: {
            plants:     PLANTS,
            sPlanDate:  sDate.replace(/-/g, ''),
            ePlanDate:  eDate.replace(/-/g, ''),
            sapWoLike:  $('#s_sapWoLike').textbox('getValue'),
            modelLike:  $('#s_modelLike').textbox('getValue'),
            partLike:   $('#s_partLike').textbox('getValue')
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || [];
            $('#d1a-master-grid').datagrid('loadData', rows);
            $('#d1a-master-grid').datagrid('loaded');
            $('#d1a-act-grid').datagrid('loadData', []);
            $('#d1a-ng-grid').datagrid('loadData', []);
            $('#d1a-ins-grid').datagrid('loadData', []);

            // 첫 번째 행 자동 선택 → 상단 정보 + 상세 로드
            if (rows.length > 0) {
                $('#d1a-master-grid').datagrid('selectRow', 0);
                onD1aMasterSelect(0, rows[0]);
            }
        },
        error: function() {
            $('#d1a-master-grid').datagrid('loaded');
            $.messager.alert(getTitle('ERROR'), 'D1A 조회 중 오류가 발생했습니다.', 'error');
        }
    });

    enableGridSortReset('#d1a-master-grid');
    enableGridSortReset('#d1a-act-grid');
    enableGridSortReset('#d1a-ng-grid');
    enableGridSortReset('#d1a-ins-grid');
}

/** D1A 마스터 행 선택 → 상단 정보 갱신 + 상세 로드 */
function onD1aMasterSelect(index, row) {
    var sapWoNo = row.SAP_WO_NO;
    var woSeq   = row.WO_SEQ;
    if (!sapWoNo || !woSeq) return;

    // 상단 정보 갱신
    $('#d1a-sapwono').textbox('setValue', sapWoNo || '');
    $('#d1a-model').textbox('setValue', row.MODEL || '');
    $('#d1a-partname').textbox('setValue', row.PART_NAME || '');

    $.ajax({
        url: consts.url.REP09A_SER4,
        type: 'POST',
        data: {plants: PLANTS, sapWoNo: sapWoNo, woSeq: woSeq},
        dataType: 'json',
        success: function(result) {
            var d = result.rows || {};
            $('#d1a-act-grid').datagrid('loadData', d.actRows || []);
            $('#d1a-ng-grid').datagrid('loadData',  d.ngRows  || []);
            $('#d1a-ins-grid').datagrid('loadData',  d.insRows || []);
        }
    });
}

function initD1aGrids() {
    // D1A 닫기 시 그리드 초기화
    $('#d1a-dialog').dialog({
        onClose: function() {
            $('#d1a-master-grid').datagrid('loadData', []);
            $('#d1a-act-grid').datagrid('loadData', []);
            $('#d1a-ng-grid').datagrid('loadData', []);
            $('#d1a-ins-grid').datagrid('loadData', []);
            $('#d1a-sapwono').textbox('setValue', '');
            $('#d1a-model').textbox('setValue', '');
            $('#d1a-partname').textbox('setValue', '');
        }
    });

    // 마스터: 완료공정 목록 (D0A proc-grid와 동일 구조)
    $('#d1a-master-grid').datagrid({
        fit: true, singleSelect: true, rownumbers: true, striped: true,
        columns: [[
            {field:'SAP_WO_NO',  title:'생산오더번호', width:120, align:'center'},
            {field:'PROC_CODE',  title:'공정',         width:100, align:'center'},
            {field:'WO_FLAG',    title:'상태',         width:80,  align:'center',
                formatter: function(v) { return woFigMap[String(v || '0')] || v; }
            }
        ]],
        onClickRow: onD1aMasterSelect
    });

    // 실적/비가동
    $('#d1a-act-grid').datagrid({
        fit: true, singleSelect: true, rownumbers: true, striped: true,
        columns: [[
            {field:'ACT_TYPE',       title:'구분',         width:60,  align:'center'},
            {field:'EMP_NAME',       title:'작업자',       width:80,  align:'center'},
            {field:'PROC_CODE',      title:'공정',         width:80,  align:'center'},
            {field:'PRE_WORK',       title:'준비작업 여부', width:90,  align:'center'},
            {field:'IDLE_NAME',      title:'비가동',       width:100, align:'center'},
            {field:'ACT_START_TIME', title:'시작시간',     width:140, align:'center', formatter: formatDateTime},
            {field:'ACT_END_TIME',   title:'종료시간',     width:140, align:'center', formatter: formatDateTime},
            {field:'ACT_TIME',       title:'시간(분)',     width:70,  align:'right'}
        ]]
    });

    // 부적합
    $('#d1a-ng-grid').datagrid({
        fit: true, singleSelect: true, rownumbers: true, striped: true,
        columns: [[
            {field:'NG_DATE',       title:'발생일',       width:100, align:'center', formatter: formatDate},
            {field:'EMP_NAME',      title:'작업자',       width:80,  align:'center'},
            {field:'PROC_CODE',     title:'공정',         width:80,  align:'center'},
            {field:'MASTER_CAUSE',  title:'불량유형',     width:100, align:'center'},
            {field:'DETAIL_CAUSE',  title:'불량유형 상세', width:120, align:'center'},
            {field:'NG_CONTENTS',   title:'불량현상',     width:200, align:'left'}
        ]]
    });

    // 자주검사
    $('#d1a-ins-grid').datagrid({
        fit: true, singleSelect: true, rownumbers: true, striped: true,
        columns: [[
            {field:'EMP_NAME',   title:'작업자',     width:80,  align:'center'},
            {field:'REG_DATE',   title:'등록일',     width:100, align:'center', formatter: formatDate},
            {field:'PROC_CODE',  title:'공정',       width:80,  align:'center'},
            {field:'INS_NAME',   title:'검사항목명', width:120, align:'left'},
            {field:'INS_DESC',   title:'점검내역',   width:150, align:'left'},
            {field:'AVG_VAL',    title:'기준값',     width:70,  align:'center'},
            {field:'MIN_VAL',    title:'Min',        width:70,  align:'center', formatter: formatF2},
            {field:'MAX_VAL',    title:'Max',        width:70,  align:'center', formatter: formatF2},
            {field:'INS_RESULT', title:'검사결과',   width:80,  align:'center'}
        ]]
    });
}

// ============================================================================
// 유틸리티 함수
// ============================================================================

/** 날짜 문자열 → MM.dd (원본: toDateString("MM.dd")) */
function toShortDate(val) {
    if (!val) return '';
    var s = String(val).replace(/[-\/:T ]/g, '');
    if (s.length >= 8) return s.substring(4, 6) + '.' + s.substring(6, 8);
    return '';
}

/** 날짜시간 포맷터 yyyy-MM-dd HH:mm */
function formatDateTime(value) {
    if (!value) return '';
    var s = String(value).replace(/[-\/:T ]/g, '');
    if (s.length < 8) return value;
    var result = s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
    if (s.length >= 12) {
        result += ' ' + s.substring(8, 10) + ':' + s.substring(10, 12);
    } else if (s.length >= 10) {
        result += ' ' + s.substring(8, 10) + ':00';
    }
    return result;
}

/** 날짜 포맷터 yyyy-MM-dd */
function formatDate(value) {
    if (!value) return '';
    var s = String(value).replace(/[-\/:T ]/g, '');
    if (s.length >= 8) return s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
    return value;
}

/** 소수점 둘째자리 고정 포맷터 (원본: emTextEditMask.F2) */
function formatF2(value) {
    if (value === null || value === undefined || value === '') return '';
    return parseFloat(value).toFixed(2);
}

function bindEnterKey(id) {
    $('#' + id).textbox('textbox').bind('keyup', function(e) {
        $('#' + id).textbox('setValue', $(this).val());
    });
    $('#' + id).textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#' + id).textbox('setValue', $(this).val());
            doSearch();
        }
    });
}

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
