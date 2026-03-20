/**
 * ============================================================================
 * 화면: POP30B - 단말기 - 가공
 * ============================================================================
 * 원본: ProActive POP30B_M0A.cs
 * 작성일: 2026-03-18
 *
 * 주요 기능:
 *   1. 생산오더+비가동 조회 (POP30B_SER)
 *   2. 작업 상태 변경 (POP30B_UPD: START/END/STOP/RESTART/PRE_START)
 *   3. 비가동 입력 (POP30B_INS2)
 *   4. 자주검사 (POP30B_INS, POP30B_INS_1)
 *   5. 일일점검 (POP30B_INS3)
 *   6. 작업장/작업자 선택 (acMachineForm, acEmpForm)
 *   7. 다이얼로그: D4A(자주검사), D9A(설비제원), D10A(비가동입력),
 *      D11A(실적현황), D12A(부적합등록), D13A(부적합현황), 
 *
 * 그리드 구조:
 *   search-grid: 메인 작업오더 목록 (생산오더+비가동 통합)
 * ============================================================================
 */

// ============================================================================
// 1. consts 객체 (URL 설정 및 초기화)
// ============================================================================
var consts = {
    url: {
        // POP30B BIZ (11개)
        POP30B_SER:    getUrl('/imes/pop/pop30b/POP30B_SER.json'),
        POP30B_SER2:   getUrl('/imes/pop/pop30b/POP30B_SER2.json'),
        POP30B_SER3:   getUrl('/imes/pop/pop30b/POP30B_SER3.json'),
        POP30B_SER4:   getUrl('/imes/pop/pop30b/POP30B_SER4.json'),
        POP30B_SER5:   getUrl('/imes/pop/pop30b/POP30B_SER5.json'),
        POP30B_SER6:   getUrl('/imes/pop/pop30b/POP30B_SER6.json'),
        POP30B_UPD:    getUrl('/imes/pop/pop30b/POP30B_UPD.json'),
        POP30B_INS:    getUrl('/imes/pop/pop30b/POP30B_INS.json'),
        POP30B_INS_1:  getUrl('/imes/pop/pop30b/POP30B_INS_1.json'),
        POP30B_INS2:   getUrl('/imes/pop/pop30b/POP30B_INS2.json'),
        POP30B_INS3:   getUrl('/imes/pop/pop30b/POP30B_INS3.json'),
        // POP30A BIZ 참조 (9개)
        POP30A_SER_INIT: getUrl('/imes/pop/pop30b/POP30A_SER_INIT.json'),
        POP30A_SER16:    getUrl('/imes/pop/pop30b/POP30A_SER16.json'),
        POP30A_SER17:    getUrl('/imes/pop/pop30b/POP30A_SER17.json'),
        POP30A_SER19:    getUrl('/imes/pop/pop30b/POP30A_SER19.json'),
        POP30A_SER20:    getUrl('/imes/pop/pop30b/POP30A_SER20.json'),
        POP30A_SER21:    getUrl('/imes/pop/pop30b/POP30A_SER21.json'),
        POP30A_SER22:    getUrl('/imes/pop/pop30b/POP30A_SER22.json'),
        POP30A_SER_A:    getUrl('/imes/pop/pop30b/POP30A_SER_A.json'),
        POP30A_INS_A:    getUrl('/imes/pop/pop30b/POP30A_INS_A.json'),
        // 비가동코드 조회 (WorkIdle 공통 팝업용)
        IDLE_CODE_SEARCH: getUrl('/imes/pop/pop30b/idleCodeSearch.json')
    },

    // 현재 선택된 작업장/작업자 정보
    currentMcCode: '',
    currentMcName: '',
    currentEmpCode: '',
    currentEmpName: '',
    currentIdleId: '',
    currentIsPop: 0,
    isDailyCheck: false,
    _dailyCheckTimer: null,
    _autoRefreshTimer: null,
    _lastSelectedIndex: 0,
    _lastIdleRows: [],

    /**
     * 초기화 함수
     */
    init: function() {
        // 그리드 초기화
        initGrid();

        // 그리드 헤더 메뉴 / 정렬 리셋
        enableGridSortReset('#search-grid');
        GridHeaderMenu('#search-grid', { exportFileName: '단말기_가공_오더목록' });

        // 버튼 이벤트 바인딩
        bindEvents();
    }
};

// ============================================================================
// 2. 전역 변수
// ============================================================================
var plants = '3605';  // 기본 공장코드 (가공)

// ============================================================================
// 3. jQuery Ready
// ============================================================================
$(function() {
    consts.init();
});

// ============================================================================
// 4. Window Load (EasyUI 컴포넌트 초기화 완료 후)
// ============================================================================
$(window).load(function() {
    // 날짜 네비게이션 초기화
    initDateRange();

    // AS-IS: FirstWorkerSetting() → OnLoad() → timer1_Tick() → MenuInit() → timer1.Start()
    // 첫 조회 완료 후 자동 갱신 타이머 시작 (AS-IS 동일)
    initFirstWorker();

    // 화면 로딩 완료
    hideLoadingBar();
});

// ============================================================================
// 5. 그리드 초기화
// ============================================================================

/**
 * 메인 그리드 초기화 (작업오더 + 비가동 목록)
 * AS-IS: gridView1 (18+ 컬럼)
 */
function initGrid() {
    $('#search-grid').datagrid({
        fit: true,
        fitColumns: true,
        singleSelect: true,
        checkOnSelect: true,
        selectOnCheck: true,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        striped: true,
        remoteSort: false,
        idField: 'woNo',
        toolbar: '#search-toolbar',
        columns: [[
            // AS-IS 컬럼 순서/헤더명 충실 전환
            {field: 'woFlag', title: '상태', width: 50, halign: 'center', align: 'center',
                resizable: true, sortable: true,
                formatter: formatWoFlag
            },
            {field: 'actPrep', title: '작업준비', width: 60, halign: 'center', align: 'center',
                formatter: function(val, row) {

                    // AS-IS: _bisPOP!=0 AND WO_FLAG!='2' (Line 1039-1050)
                    // 진행('2')만 비활성, 그 외(확정/중지/완료) 모두 활성
                    var pop = consts.currentIsPop;
                    var enabled = (pop != 0) && (row.woFlag !== '2');
                    return gridActionBtn('doWorkPreStart', row.woNo, '⇨', '#1a237e', enabled, '준비작업시작');
                }
            },
            {field: 'actStart', title: '시작', width: 50, halign: 'center', align: 'center',
                formatter: function(val, row) {

                    // AS-IS: _bisPOP!=0 AND NOT (WO_FLAG='2' AND PRE_WORK='0')
                    var pop = consts.currentIsPop;
                    var enabled = (pop != 0) && !(row.woFlag === '2' && row.preWork !== '1');
                    return gridActionBtn('doWorkStart', row.woNo, '▶', '#1a237e', enabled, '작업시작');
                }
            },
            {field: 'actStop', title: '중지', width: 50, halign: 'center', align: 'center',
                formatter: function(val, row) {

                    // AS-IS: _bisPOP!=0 AND isStart() AND WO_FLAG='2'
                    var pop = consts.currentIsPop;
                    var enabled = (pop != 0) && (row.woFlag === '2') && hasAnyInProgress();
                    return gridActionBtn('doWorkStop', row.woNo, '▮▮', '#1a237e', enabled, '작업중지');
                }
            },
            {field: 'actEnd', title: '완료', width: 50, halign: 'center', align: 'center',
                formatter: function(val, row) {

                    // AS-IS: _bisPOP!=0 AND (WO_FLAG='2' OR WO_FLAG='3')
                    var pop = consts.currentIsPop;
                    var enabled = (pop != 0) && (row.woFlag === '2' || row.woFlag === '3');
                    return gridActionBtn('doWorkEnd', row.woNo, '■', '#1a237e', enabled, '작업완료');
                }
            },
            {field: 'sapWoNo',    title: '오더번호',     width: 110, halign: 'center', align: 'center', resizable: true, sortable: true},
            {field: 'mcCode',     title: '자원코드',     width: 70,  halign: 'center', align: 'center', resizable: true, sortable: true},
            {field: 'mcName',     title: '자원명',       width: 80,  halign: 'center', align: 'center', resizable: true, sortable: true},
            {field: 'procCode',   title: '공정',         width: 80,  halign: 'center', align: 'center', resizable: true, sortable: true},
            {field: 'mctVenName', title: '고객명',       width: 80,  halign: 'center', align: 'left',   resizable: true, sortable: true},
            {field: 'model',      title: 'Model',        width: 80,  halign: 'center', align: 'left',   resizable: true, sortable: true},
            {field: 'partName',   title: '자재명',       width: 100, halign: 'center', align: 'left',   resizable: true, sortable: true},
            {field: 'partCode',   title: '자재코드',     width: 90,  halign: 'center', align: 'center', resizable: true, sortable: true},
            {field: 'actMcCode',  title: '작업자원코드', width: 90,  halign: 'center', align: 'center', resizable: true, sortable: true},
            {field: 'actMcName',  title: '작업자원',     width: 80,  halign: 'center', align: 'center', resizable: true, sortable: true},
            {field: 'actEmpName', title: '작업자',       width: 70,  halign: 'center', align: 'center', resizable: true, sortable: true},
            {field: 'workContents', title: '작업내역',   width: 100, halign: 'center', align: 'left',   resizable: true, sortable: true},
            {field: 'isMatChk',   title: '자재\n확인', width: 45, halign: 'center', align: 'center', resizable: true,
                formatter: function(val) {
                    return val === '1'
                        ? '<span style="color:green;font-size:16px;">&#10004;</span>'
                        : '<span style="color:red;font-size:16px;">&#10008;</span>';
                }
            },
            {field: 'isInsChk',   title: '자주\n검사', width: 45, halign: 'center', align: 'center', resizable: true,
                formatter: function(val) {
                    return val === '1'
                        ? '<span style="color:green;font-size:16px;">&#10004;</span>'
                        : '<span style="color:red;font-size:16px;">&#10008;</span>';
                }
            },
            // 숨김 필드
            {field: 'woNo',       hidden: true},
            {field: 'pltCode',    hidden: true},
            {field: 'panelStat',  hidden: true},
            {field: 'preWork',    hidden: true},
            {field: 'isMatChkVal', hidden: true},
            {field: 'isInsChkVal', hidden: true}
        ]],
        rowStyler: function(index, row) {
            // WO_FLAG별 배경색 (ord13a 범례 동일)
            switch (row.woFlag) {
                case '1': return 'background-color:#D4EDF7 !important';  // 확정 (하늘색)
                case '2': return 'background-color:#FF6347 !important';  // 진행 (주황)
                case '3': return 'background-color:#FFFF00 !important';  // 중지 (노란색)
                case '4': return 'background-color:#00FF00 !important';  // 완료 (초록)
                case '5': return 'background-color:#FFFF00 !important';  // 비가동 (노란색, 중지와 동일)
            }
        },
        onBeforeLoad: function(param) {
            if (!this.loaded) {
                this.loaded = true;
                return false;
            }
        },
        onLoadSuccess: function(data) {
            // AS-IS: SetOldFocusRowHandle - 이전 선택 행 복원
            var oldIndex = consts._lastSelectedIndex || 0;
            var rows = $('#search-grid').datagrid('getRows');
            if (rows.length > 0) {
                var idx = (oldIndex < rows.length) ? oldIndex : 0;
                $('#search-grid').datagrid('selectRow', idx);
            }
            updateStatusMessage();
        },
        onSelect: function(index, row) {
            // AS-IS: gvWO_FocusedRowChanged - 선택 행 기억 + 버튼 상태 업데이트
            consts._lastSelectedIndex = index;
            updateBottomButtons(row);
        }
    });
}

// ============================================================================
// 6. 이벤트 바인딩
// ============================================================================

/**
 * 버튼 이벤트 바인딩
 */
function bindEvents() {
    // ----------------------------------------------------------------
    // 작업장 선택
    // ----------------------------------------------------------------
    $('#btn-select-mc').bind('click', function() {
        acCellForm.open({
            mcGroup: '3605',
            onSelect: function(row) {
                onMachineSelected(row);
            }
        });
    });

    // ----------------------------------------------------------------
    // 작업자 선택
    // ----------------------------------------------------------------
    $('#btn-select-emp').bind('click', function() {
        acWorkerForm.open({
            isMc: '1',
            onSelect: function(row) {
                onEmpSelected(row);
                // AS-IS: MAIN_MC_CODE가 있으면 작업장 자동 세팅
                if (row.mainMcCode && row.mainMcCode !== '') {
                    onMachineSelected({
                        mcCode: row.mainMcCode,
                        mcName: row.mainMcName || ''
                    });
                }
            }
        });
    });

    // ----------------------------------------------------------------
    // 날짜 네비게이션
    // ----------------------------------------------------------------
    $('#btn-prev-week').bind('click', function() { navigateWeek(-7); });
    $('#btn-next-week').bind('click', function() { navigateWeek(7); });

    // ----------------------------------------------------------------
    // 필터 체크박스
    // ----------------------------------------------------------------
    // AS-IS: chk_Finish_CheckedChanged, chk_All_CheckedChanged → timer1_Tick
    $('#chk-include-done').bind('change', function() { timerTick(); });
    $('#chk-all-order').bind('change', function() { timerTick(); });

    // ----------------------------------------------------------------
    // 상단 기능 버튼
    // ----------------------------------------------------------------
    $('#btn-ng-reg').bind('click', function() { doOpenNgReg(); });
    $('#btn-inspection').bind('click', function() { if ($(this).linkbutton('options').disabled) return; doOpenInspection(); });
    $('#btn-ng-list').bind('click', function() { doOpenNgList(); });
    $('#btn-act-list').bind('click', function() { doOpenActList(); });

    // ----------------------------------------------------------------
    // 하단 버튼
    // ----------------------------------------------------------------
    $('#btn-mat-ready').bind('click', function() {
        if ($(this).linkbutton('options').disabled) return;
        $.messager.alert('알림', '추후 구현 예정입니다.', 'info');
    });
    $('#btn-equip-spec').bind('click', function() { doOpenEquipSpec(); });
    $('#btn-daily-check').bind('click', function() { doOpenDailyCheck(); });
    $('#btn-idle-input').bind('click', function() { doOpenIdleInput(); });
    $('#btn-2d-drawing').bind('click', function() {
        $.messager.alert('알림', '추후 구현 예정입니다.', 'info');
    });
    $('#btn-work-std').bind('click', function() {
        $.messager.alert('알림', '추후 구현 예정입니다.', 'info');
    });
    $('#btn-leave').bind('click', function() {
        $.messager.alert('알림', '추후 구현 예정입니다.', 'info');
    });
    $('#btn-work-std-req').bind('click', function() {
        $.messager.alert('알림', '추후 구현 예정입니다.', 'info');
    });
}

// ============================================================================
// 7. 작업장/작업자 선택 콜백
// ============================================================================

/**
 * 작업장(설비) 선택 콜백
 * AS-IS: btn_Cell_Click → MC 세팅 → POP30B_SER6(일일점검 확인) → timer1_Tick(Search)
 * @param {Object} row - { mcCode, mcName, mcGroup, ... }
 */
function onMachineSelected(row) {
    consts.currentMcCode = row.mcCode;
    consts.currentMcName = row.mcName;
    $('#hid-mc-code').val(row.mcCode);
    $('#hid-mc-name').val(row.mcName);

    // AS-IS: POP30B_SER6 → 일일점검 완료 여부 체크
    checkDailyInspection(row.mcCode);

    // AS-IS: timer1_Tick(null, null)
    timerTick();
}

/**
 * 작업자(사원) 선택 콜백
 * AS-IS: btn_Emp_Click → EMP 세팅 → MAIN_MC_CODE 자동세팅 → OnLoad → timer1_Tick(Search)
 * @param {Object} row - { empCode, empName, isPop, mainMcCode, mainMcName, ... }
 */
function onEmpSelected(row) {
    consts.currentEmpCode = row.empCode;
    consts.currentEmpName = row.empName;
    consts.currentIsPop = row.isPop || 0;
    $('#hid-emp-code').val(row.empCode);

    // AS-IS: OnLoad → timer1_Tick(null, null)
    timerTick();
}

/**
 * 일일점검 완료 여부 확인 (AS-IS: POP30B_SER6)
 * 작업장 선택 시 호출 → 오늘 날짜 + 설비코드로 일일점검 결과 조회
 */
function checkDailyInspection(mcCode) {
    consts.isDailyCheck = false;
    $.ajax({
        url: consts.url.POP30B_SER6,
        type: 'POST',
        data: {
            mdcrDate: formatDateCompact(new Date()),
            mdcrMcCode: mcCode
        },
        dataType: 'json',
        success: function(data) {
            var rows = data.rows || data || [];
            if (rows.length > 0) {
                consts.isDailyCheck = true;
            }
            // 일일점검 버튼 시각적 표시 (TODO: 미완료 시 깜빡임 효과)
            updateDailyCheckBtn();
        }
    });
}

/**
 * 일일점검 버튼 상태 업데이트
 */
/**
 * 비가동 오버레이 표시/숨김 (AS-IS: 그리드 위 빨간 팝업)
 */
function updateIdleOverlay() {
    var $overlay = $('#idle-overlay');
    if (consts.currentIdleId && consts._lastIdleRows && consts._lastIdleRows.length > 0) {
        var idle = consts._lastIdleRows[0];
        var html = '비가동<br/>사유 : ' + (idle.idleName || '')
                 + '<br/>시간 : ' + (idle.startTime || '') + ' ~';
        $('#idle-overlay-text').html(html);

        // position:fixed + CSS transform으로 화면 중앙 배치 (JSP에서 설정)
        $overlay.show();
    } else {
        $overlay.hide();
    }
}

/**
 * 행 선택 시 하단 버튼 상태 업데이트
 * AS-IS: gvWO_FocusedRowChanged → Work_State()
 */
function updateBottomButtons(row) {
    if (!row) {
        // AS-IS: 행 미선택 시 초기 상태
        $('#btn-mat-ready').linkbutton({text: '-', disabled: true});
        $('#btn-inspection').linkbutton({disabled: true});
        return;
    }

    // AS-IS: Work_State() - 자재준비 버튼 텍스트 변경
    if (row.isMatChk === '1') {
        $('#btn-mat-ready').linkbutton({text: '자재준비완료취소', disabled: false});
    } else {
        $('#btn-mat-ready').linkbutton({text: '자재준비완료', disabled: false});
    }

    // AS-IS: gvWO_FocusedRowChanged - 자주검사 버튼 (WO_FLAG='1'이면 비활성)
    if (row.woFlag === '1') {
        $('#btn-inspection').linkbutton({disabled: true});
    } else {
        $('#btn-inspection').linkbutton({disabled: false});
    }
}

function updateDailyCheckBtn() {
    var $btn = $('#btn-daily-check');
    if (consts.isDailyCheck) {
        // 일일점검 완료: 정상 표시, 깜빡임 중지
        if (consts._dailyCheckTimer) {
            clearInterval(consts._dailyCheckTimer);
            consts._dailyCheckTimer = null;
        }
        $btn.linkbutton({text: '일일점검'});
        var $a = $btn.closest('.l-btn').length ? $btn.closest('.l-btn') : $btn;
        $a.removeAttr('style');
        $a.find('.l-btn-text').css('color', '');
    } else {
        // 일일점검 미완료: 빨간 배경 깜빡임 (AS-IS: _timer2)
        if (!consts._dailyCheckTimer) {
            var blink = true;
            consts._dailyCheckTimer = setInterval(function() {
                // EasyUI linkbutton 내부: a.l-btn > span.l-btn-left > span.l-btn-text
                var $a = $btn.closest('.l-btn').length ? $btn.closest('.l-btn') : $btn;
                if (blink) {
                    $a.attr('style', 'background-color:#ff0000 !important; color:#fff !important;');
                    $a.find('.l-btn-text').css('color', '#fff');
                } else {
                    $a.removeAttr('style');
                    $a.find('.l-btn-text').css('color', '');
                }
                blink = !blink;
            }, 700);
        }
    }
}

// ============================================================================
// 8. 조회 (POP30B_SER)
// ============================================================================

/**
 * 메인 조회 - 작업오더+비가동 목록
 * AS-IS: POP30B.POP30B_SER()
 *   → TSHP_WORKORDER_QUERY27 (오더) + TSHP_IDLETIME_QUERY2_1 (비가동)
 */
function doSearch() {
    if (!consts.currentMcCode) {
        // 작업장 미선택 시 그리드 초기화
        $('#search-grid').datagrid('loadData', []);
        return;
    }

    var params = {
        plants: plants,
        mcCode: consts.currentMcCode,
        empCode: consts.currentEmpCode,
        isAll: $('#chk-all-order').prop('checked') ? 'Y' : 'N',
        includeDone: $('#chk-include-done').prop('checked') ? 'Y' : 'N',
        sPlanTime: consts.currentStartDate,
        ePlanTime: consts.currentEndDate
    };

    $.ajax({
        url: consts.url.POP30B_SER,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(data) {
            // addObject → addData → model.addAttribute("rows", Map)
            // 응답: { rows: { rows: [...], idleRows: [...] } }
            var wrapper = data.rows || data || {};
            var rows = wrapper.rows || [];
            var idleRows = wrapper.idleRows || [];
            consts._lastIdleRows = idleRows;  // 상태 메시지에서 사용

            // 완료작업 포함 체크 해제 시 woFlag='4' 제거
            if (!$('#chk-include-done').prop('checked')) {
                rows = filterExcludeDone(rows);
            }

            // AS-IS: 그리드에는 오더만 표시
            $('#search-grid').datagrid('loadData', rows);
        },
        error: function() {
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 9. 작업 상태 변경 (POP30B_UPD)
// ============================================================================

/**
 * 작업준비 시작
 * AS-IS: PreWoStart_ButtonClick (POP30B_M0A.cs Line 1180-1240)
 *   1. 일일점검 미등록 → 차단 (Line 1184)
 *   2. 비가동 아닌 경우: 다른 작업자 확인 + 진행중 작업 중지 confirm
 *   3. 비가동 중: "비가동 종료후 준비작업을 하시겠습니까?" confirm
 *   4. WorkIdle("M132") 팝업 → POP30A_INS2 (Line 1216)
 */
function doWorkPreStart(woNo) {
    if (!_checkCommon()) return;
    var row = findRowByWoNo(woNo);
    if (!row) return;

    // AS-IS Line 1184: 일일점검 필수
    if (!consts.isDailyCheck) {
        $.messager.alert('알림', '일일점검이 등록되지 않았습니다.', 'warning');
        return;
    }

    if (!consts.currentIdleId) {
        // AS-IS Line 1199-1210: 비가동 아닌 경우
        if (row.woFlag === '2' &&
            (row.actEmpCode !== consts.currentEmpCode || row.actMcCode !== consts.currentMcCode)) {
            $.messager.alert('알림', '다른 작업자가 진행중입니다.', 'warning');
            return;
        }
        var myInProgress = _findMyInProgressRow();
        if (myInProgress) {
            $.messager.confirm('확인', '진행중인 작업이 있습니다. 중지 하시겠습니까?', function(r) {
                if (r) _doPreStartWithIdle(row);
            });
            return;
        }
    } else {
        // AS-IS Line 1212: 비가동 중 → confirm
        $.messager.confirm('확인', '비가동 종료후 준비작업을 하시겠습니까?', function(r) {
            if (r) _doPreStartWithIdle(row);
        });
        return;
    }

    _doPreStartWithIdle(row);
}

/**
 * 작업준비 + WorkIdle("M132") 팝업
 * AS-IS Line 1216: WorkIdle("3605", row, empCode, mcCode, "M132") → 사유 고정/읽기전용
 * AS-IS Line 1220-1240: WorkIdle 확인 → POP30A_INS2 호출
 */
function _doPreStartWithIdle(row) {
    stopAutoRefresh();
    workIdle.open({
        plants: plants,
        searchUrl: consts.url.IDLE_CODE_SEARCH,
        idleCause: 'M132',
        onConfirm: function(result) { _callIns2(row, result); },
        onCancel: function() { startAutoRefresh(); }
    });
}

/**
 * POP30B_INS2 공통 호출 (비가동 등록)
 * 자동갱신 중지 → AJAX → 완료 후 재시작 (락 충돌 방지)
 */
function _callIns2(row, result) {
    stopAutoRefresh();
    $.ajax({
        url: consts.url.POP30B_INS2,
        type: 'POST',
        data: {
            woNo: row.woNo,
            mcCode: consts.currentMcCode,
            empCode: consts.currentEmpCode,
            idleCode: result.idleCode,
            idleMinute: result.idleMinute || '',
            scomment: result.scomment || '',
            plants: plants
        },
        dataType: 'json',
        success: function(data) {
            startAutoRefresh();
            if (data && data.success) {
                timerTick();
            } else {
                $.messager.alert('오류', (data && data.error) || '비가동 등록 실패', 'error');
            }
        },
        error: function() {
            startAutoRefresh();
            $.messager.alert('오류', '비가동 등록 중 오류가 발생했습니다.', 'error');
        }
    });
}

/**
 * 작업 시작
 * AS-IS: woStart_ButtonClick
 */
function doWorkStart(woNo) {
    if (!_checkCommon()) return;
    var row = findRowByWoNo(woNo);
    if (!row) return;

    // AS-IS: 일일점검 필수
    if (!consts.isDailyCheck) {
        $.messager.alert('알림', '일일점검이 등록되지 않았습니다.', 'warning');
        return;
    }

    // AS-IS: 비가동 중 → 비가동 종료 후 시작
    if (consts.currentIdleId) {
        $.messager.confirm('확인', '비가동 종료 후 시작하시겠습니까?', function(r) {
            if (r) _executeWorkAction(woNo, row, 'START');
        });
        return;
    }

    // AS-IS: 진행 중 작업 확인 → 동적 메시지
    var text = '';
    var myInProgress = _findMyInProgressRow();
    if (myInProgress) {
        if (myInProgress.preWork === '1') {
            text = '작업준비를 완료하고 ';
        } else {
            text = '진행중인 작업을 중지하고 ';
        }
    }

    var confirmMsg;
    if (row.woFlag === '4') {
        confirmMsg = text + '재시작하시겠습니까?';
    } else {
        confirmMsg = text + '시작하시겠습니까?';
    }

    $.messager.confirm('확인', confirmMsg, function(r) {
        if (r) _executeWorkAction(woNo, row, 'START');
    });
}

/**
 * 작업 중지
 * AS-IS: woStop_ButtonClick (POP30B_M0A.cs Line 1354-1394)
 *   1. 작업자/자원 불일치 confirm
 *   2. "중지하시겠습니까?" confirm
 *   3. WorkIdle 팝업 (비가동 사유 선택)
 *   4. POP30A_INS2 호출 (비가동 등록)
 */
function doWorkStop(woNo) {
    if (!_checkCommon()) return;
    var row = findRowByWoNo(woNo);
    if (!row) return;

    // AS-IS: 작업자/자원 불일치 → 1차 confirm
    if ((row.actEmpCode || '') !== consts.currentEmpCode || (row.actMcCode || '') !== consts.currentMcCode) {
        $.messager.confirm('확인',
            '진행중인 자원또는 작업자가 일치하지 않습니다. 중지를 계속 진행하시겠습니까?',
            function(r) {
                if (!r) return;
                // AS-IS: 2차 confirm
                $.messager.confirm('확인', '중지하시겠습니까?', function(r2) {
                    if (r2) _doStopWithIdle(row);
                });
            });
        return;
    }

    // AS-IS: 정상 → "중지하시겠습니까?"
    $.messager.confirm('확인', '중지하시겠습니까?', function(r) {
        if (r) _doStopWithIdle(row);
    });
}

/**
 * 중지 + 비가동 사유 입력 (AS-IS: woStop_ButtonClick Line 1364-1394)
 * AS-IS: confirm 후 WorkIdle 팝업 → POP30A_INS2 호출
 */
function _doStopWithIdle(row) {
    stopAutoRefresh();
    workIdle.open({
        plants: plants,
        searchUrl: consts.url.IDLE_CODE_SEARCH,
        onConfirm: function(result) { _callIns2(row, result); },
        onCancel: function() { startAutoRefresh(); }
    });
}

/**
 * 작업 완료
 * AS-IS: woEnd_ButtonClick
 */
function doWorkEnd(woNo) {
    if (!_checkCommon()) return;
    var row = findRowByWoNo(woNo);
    if (!row) return;

    // AS-IS: 작업자/자원 불일치 → 1차 confirm (actEmpCode 빈값도 불일치)
    if ((row.actEmpCode || '') !== consts.currentEmpCode || (row.actMcCode || '') !== consts.currentMcCode) {
        $.messager.confirm('확인',
            '진행중인 자원또는 작업자가 일치하지 않습니다. 완료를 계속 진행하시겠습니까?',
            function(r) {
                if (!r) return;
                // AS-IS: 2차 confirm
                $.messager.confirm('확인', '완료하시겠습니까?', function(r2) {
                    if (r2) _executeWorkAction(woNo, row, 'END');
                });
            });
        return;
    }

    // AS-IS: 정상 → "완료하시겠습니까?"
    $.messager.confirm('확인', '완료하시겠습니까?', function(r) {
        if (r) _executeWorkAction(woNo, row, 'END');
    });
}

/**
 * 공통 체크 (작업장/작업자 선택 여부)
 */
function _checkCommon() {
    if (!consts.currentEmpCode || !consts.currentMcCode) {
        $.messager.alert('알림', '작업장 또는 작업자를 선택해주세요.', 'warning');
        return false;
    }
    return true;
}

/**
 * 현재 작업자+작업장의 진행 중 오더 찾기
 * AS-IS: isStartDB() / GetDataSourceView("WO_FLAG='2' AND ACT_EMP_CODE=... AND ACT_MC_CODE=...")
 */
function _findMyInProgressRow() {
    var rows = $('#search-grid').datagrid('getRows');
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].woFlag === '2' &&
            rows[i].actEmpCode === consts.currentEmpCode &&
            rows[i].actMcCode === consts.currentMcCode) {
            return rows[i];
        }
    }
    return null;
}

/**
 * 작업 상태 변경 실행 (내부)
 * AS-IS: workorder_state() 실행부
 */
function _executeWorkAction(woNo, row, typeCode) {
    // AS-IS: PANEL_STAT 로직 - WO_FLAG='4' 또는 기존 PANEL_STAT='1'이면 '1' 유지
    var panelStat = '0';
    if (row.woFlag === '4' || row.panelStat === '1') {
        panelStat = '1';
    }

    var sendData = {
        typeCode: typeCode,
        woNo: woNo,
        mcCode: consts.currentMcCode,
        empCode: consts.currentEmpCode,
        panelStat: panelStat,
        inputFlag: '0',                              // AS-IS: INPUT_FLAG = '0'
        idleId: consts.currentIdleId || '',           // AS-IS: _strIdleID
        isPreWork: (typeCode === 'PRE_START') ? '1' : '0'  // AS-IS: IS_PRE_WORK
    };

    // 작업 상태 변경 중 자동갱신 중지 (락 충돌 방지)
    stopAutoRefresh();

    $.ajax({
        url: consts.url.POP30B_UPD,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(sendData),
        dataType: 'json',
        success: function(data) {
            if (data.success) {
                timerTick();
            } else {
                $.messager.alert('오류', data.error || '처리 실패', 'error');
            }
            startAutoRefresh();
        },
        error: function() {
            $.messager.alert('오류', '서버 통신 오류가 발생했습니다.', 'error');
            startAutoRefresh();
        }
    });
}

// ============================================================================
// 10. 다이얼로그 오픈 함수
// ============================================================================

/**
 * 부적합등록 팝업 열기 (공통: McRegNg)
 * AS-IS: POP30B_M0A → acBarButtonItem3 (부적합등록)
 */
function doOpenNgReg() {
    var row = $('#search-grid').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', '부적합 등록할 오더를 선택하세요.', 'warning');
        return;
    }
    if (!consts.currentEmpCode) {
        $.messager.alert('알림', '작업자를 선택하세요.', 'warning');
        return;
    }

    mcRegNg.open({
        woNo: row.woNo,
        mcCode: consts.currentMcCode,
        empCode: consts.currentEmpCode,
        itemCode: row.partCode || row.itemCode,
        procCode: row.procCode,
        saveUrl: consts.url.POP30A_INS_A,
        onSave: function() { timerTick(); }
    });
}

/**
 * 자주검사 다이얼로그 (D4A) 열기
 * AS-IS: POP30B_M0A → acBarButtonItem4 (자주검사)
 */
function doOpenInspection() {
    var row = $('#search-grid').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', '검사할 오더를 선택하세요.', 'warning');
        return;
    }
    if (!consts.currentEmpCode) {
        $.messager.alert('알림', '작업자를 선택하세요.', 'warning');
        return;
    }

    // D4A 다이얼로그 열기 (추후 pop30b_d4a.js에서 구현)
    if (typeof pop30b_d4a !== 'undefined') {
        pop30b_d4a.open({
            woNo: row.woNo,
            sapWoNo: row.sapWoNo,
            mcCode: consts.currentMcCode,
            empCode: consts.currentEmpCode,
            itemCode: row.itemCode,
            procCode: row.procCode
        });
    } else {
        $.messager.alert('알림', '자주검사 다이얼로그가 준비되지 않았습니다.', 'info');
    }
}

/**
 * 부적합현황 팝업 열기 (공통: McNgLog)
 * AS-IS: POP30B_M0A → acBarButtonItem5 (부적합현황)
 */
function doOpenNgList() {
    var row = $('#search-grid').datagrid('getSelected');

    mcNgLog.open({
        woNo: row ? row.woNo : '',
        mcCode: consts.currentMcCode,
        plants: plants,
        searchUrl: consts.url.POP30A_SER_A
    });
}

/**
 * 실적현황 다이얼로그 (D11A) 열기
 * AS-IS: POP30B_M0A → acBarButtonItem6 (실적현황)
 */
function doOpenActList() {
    var row = $('#search-grid').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', '실적 조회할 오더를 선택하세요.', 'warning');
        return;
    }

    // D11A 다이얼로그 열기 (추후 pop30b_d11a.js에서 구현)
    if (typeof pop30b_d11a !== 'undefined') {
        pop30b_d11a.open({
            woNo: row.woNo,
            mcCode: consts.currentMcCode,
            plants: plants
        });
    } else {
        $.messager.alert('알림', '실적현황 다이얼로그가 준비되지 않았습니다.', 'info');
    }
}

/**
 * 설비제원 다이얼로그 (D9A) 열기
 * AS-IS: POP30B_M0A → acBarButtonItem9 (설비제원)
 */
function doOpenEquipSpec() {
    if (!consts.currentMcCode) {
        $.messager.alert('알림', '작업장을 선택하세요.', 'warning');
        return;
    }

    // D9A 다이얼로그 열기
    if (typeof pop30b_d9a !== 'undefined') {
        pop30b_d9a.open({
            mcCode: consts.currentMcCode,
            plants: plants
        });
    } else {
        $.messager.alert('알림', '설비제원 다이얼로그가 준비되지 않았습니다.', 'info');
    }
}

/**
 * 일일점검 팝업 열기 (공통: mcDailyCheck)
 * AS-IS: POP30B_M0A → acBarButtonItem10 (일일점검) → McDailyCheck 공통 팝업
 */
function doOpenDailyCheck() {
    if (!consts.currentMcCode) {
        $.messager.alert('알림', '작업장을 선택하세요.', 'warning');
        return;
    }
    if (!consts.currentEmpCode) {
        $.messager.alert('알림', '작업자를 선택하세요.', 'warning');
        return;
    }

    mcDailyCheck.open({
        mcCode: consts.currentMcCode,
        empCode: consts.currentEmpCode,
        searchUrl: consts.url.POP30B_SER5,
        saveUrl: consts.url.POP30B_INS3,
        onSave: function() {
            // AS-IS: 저장 후 일일점검 완료 상태 갱신
            checkDailyInspection(consts.currentMcCode);
        }
    });
}

/**
 * 비가동입력/종료 버튼 클릭
 * AS-IS: POP30B_M0A.btn_Idle_Click()
 *   SCENARIO A: _strIdleID=="" → 비가동 시작 (WorkIdle → POP30A_INS2)
 *   SCENARIO B: _strIdleID!="" → 비가동 종료 (confirm → POP30A_INS2)
 */
function doOpenIdleInput() {
    if (!_checkCommon()) return;

    if (consts.currentIdleId) {
        // ================================================================
        // SCENARIO B: 비가동 중 → 비가동 종료
        // AS-IS: "비가동 종료 하시겠습니까?" confirm → POP30A_INS2 (IDLE_ID set, WO_FLAG='3')
        // ================================================================
        $.messager.confirm('확인', '비가동 종료 하시겠습니까?', function(r) {
            if (!r) return;

            stopAutoRefresh();
            $.ajax({
                url: consts.url.POP30B_INS2,
                type: 'POST',
                data: {
                    idleId: consts.currentIdleId,
                    mcCode: consts.currentMcCode,
                    empCode: consts.currentEmpCode,
                    plants: plants
                },
                dataType: 'json',
                success: function(data) {
                    startAutoRefresh();
                    if (data && data.success) {
                        timerTick();
                    } else {
                        $.messager.alert('오류', (data && data.error) || '비가동 종료 실패', 'error');
                    }
                },
                error: function() {
                    startAutoRefresh();
                    $.messager.alert('오류', '비가동 종료 중 오류가 발생했습니다.', 'error');
                }
            });
        });
        return;
    }

    // ================================================================
    // SCENARIO A: 비가동 시작
    // AS-IS: btn_Idle_Click() → 행 검증 → WorkIdle → POP30A_INS2
    // ================================================================
    var row = $('#search-grid').datagrid('getSelected');
    if (!row) {
        $.messager.alert('알림', '오더를 선택하세요.', 'warning');
        return;
    }

    // AS-IS: 다른 작업자가 진행 중이면 차단
    if (row.woFlag === '2' &&
        (row.actEmpCode !== consts.currentEmpCode || row.actMcCode !== consts.currentMcCode)) {
        $.messager.alert('알림', '다른 작업자가 진행중입니다.', 'warning');
        return;
    }

    // AS-IS: 내 진행 중 작업이 있으면 중지 확인
    var myInProgress = _findMyInProgressRow();
    if (myInProgress) {
        $.messager.confirm('확인', '진행중인 작업이 있습니다. 중지 하시겠습니까?', function(r) {
            if (!r) return;
            _openWorkIdleForStart(row);
        });
        return;
    }

    _openWorkIdleForStart(row);
}

/**
 * WorkIdle 팝업 열기 → 확인 시 비가동 등록 (POP30B_INS2)
 * AS-IS: WorkIdle.ShowDialog() → POP30A_INS2
 */
function _openWorkIdleForStart(row) {
    stopAutoRefresh();
    workIdle.open({
        plants: plants,
        searchUrl: consts.url.IDLE_CODE_SEARCH,
        onConfirm: function(result) { _callIns2(row, result); },
        onCancel: function() { startAutoRefresh(); }
    });
}

// ============================================================================
// 11. 상태 표시 함수
// ============================================================================

/**
 * 상태 메시지 업데이트 (AS-IS: QuickSearch 콜백 로직)
 * 1. 비가동(idleRows)이 있으면 비가동 상태 표시
 * 2. ACT_EMP_CODE==선택작업자 && ACT_MC_CODE==선택작업장인 진행중 행 찾기
 * 3. 진행중 작업이 있으면 오더번호 표시
 */
function updateStatusMessage() {
    var rows = $('#search-grid').datagrid('getRows');
    var $td = $('#lbl-status').closest('td');
    var statusText = '진행중인 작업이 없습니다.';
    // 기본(대기): 확정색 배경, 검은 글씨
    var statusColor = '#000';
    var statusBg = '#D4EDF7';
    var foundInProgress = false;

    // 1. 비가동 체크 (consts에 저장된 idleRows)
    if (consts._lastIdleRows && consts._lastIdleRows.length > 0) {
        var idle = consts._lastIdleRows[0];
        consts.currentIdleId = idle.idleId || '';
        statusText = '[비가동] [사유 : ' + (idle.idleName || '') + ']  [' + (idle.startTime || '') + ' ~ ]';
        // AS-IS: MC_OPERATE_CLR_IDLE (빨간 배경, 흰 글씨)
        statusColor = '#fff';
        statusBg = '#ff0000';
        // AS-IS: 비가동 입력 → 비가동 종료 버튼 텍스트 변경
        $('#btn-idle-input').linkbutton({text: '비가동 종료'});
    } else {
        consts.currentIdleId = '';
        $('#btn-idle-input').linkbutton({text: '비가동 입력'});
    }

    // 2. 진행중 작업 찾기 (ACT_EMP_CODE==선택작업자, ACT_MC_CODE==선택작업장, WO_FLAG='2')
    for (var i = 0; i < rows.length; i++) {
        var r = rows[i];
        if (r.woFlag === '2' &&
            r.actEmpCode === consts.currentEmpCode &&
            r.actMcCode === consts.currentMcCode) {
            foundInProgress = true;
            // 비가동이 없을 때만 텍스트 변경
            if (!consts._lastIdleRows || consts._lastIdleRows.length === 0) {
                var prepText = (r.preWork === '1') ? ' 작업준비 ' : '';
                statusText = '[오더번호 : ' + (r.sapWoNo || r.woNo) + ']' + prepText + ' 진행 중입니다.';
            }
            // AS-IS: MC_OPERATE_CLR_RUN (그리드 진행색과 동일, 검은 글씨)
            statusColor = '#000';
            statusBg = '#FF6347';
            break;
        }
    }

    $('#lbl-status').text(statusText);
    $('#lbl-status').css('color', statusColor);
    $td.css('background-color', statusBg);

    // AS-IS: 비가동 시 그리드 위에 빨간 오버레이 표시
    updateIdleOverlay();
}

/**
 * 진행중 작업 존재 여부 (AS-IS: isStart())
 * 그리드 전체에서 woFlag='2'인 행이 하나라도 있는지
 */
function hasAnyInProgress() {
    var rows = $('#search-grid').datagrid('getRows');
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].woFlag === '2') return true;
    }
    return false;
}

// ============================================================================
// 12. 유틸리티 함수
// ============================================================================

/**
 * WO_FLAG 코드 → 표시명 변환
 */
/**
 * 그리드 액션 버튼 HTML 생성
 * @param {string} fnName - onclick 함수명
 * @param {string} woNo - 오더번호
 * @param {string} icon - 아이콘 문자 (⇨, ▶, ▮▮, ■)
 * @param {string} color - 활성 시 아이콘 색상
 * @param {boolean} enabled - 활성 여부
 * @param {string} tooltip - 툴팁
 */
function gridActionBtn(fnName, woNo, icon, color, enabled, tooltip) {
    if (enabled) {
        return '<a href="javascript:void(0)" onclick="' + fnName + '(\'' + woNo + '\')" title="' + tooltip + '"'
             + ' class="pop-grid-btn pop-grid-btn-active">'
             + '<span style="color:' + color + ';">' + icon + '</span></a>';
    } else {
        return '<span class="pop-grid-btn pop-grid-btn-disabled">'
             + '<span style="color:#ccc;">' + icon + '</span></span>';
    }
}

function formatWoFlag(val) {
    switch (val) {
        case '1': return '확정';
        case '2': return '<span style="">진행</span>';
        case '3': return '<span style="">중지</span>';
        case '4': return '<span style="">완료</span>';
        case '5': return '<span style="">비가동</span>';
        default:  return val || '';
    }
}

/**
 * 완료 오더 필터링 (woFlag='4' 제거)
 * @param {Array} rows - 오더 목록
 * @returns {Array} 필터링된 목록
 */
function filterExcludeDone(rows) {
    var filtered = [];
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].woFlag !== '4') {
            filtered.push(rows[i]);
        }
    }
    return filtered;
}

/**
 * woNo로 그리드 행 검색
 * @param {string} woNo - 오더번호
 * @returns {Object|null} 해당 행 또는 null
 */
function findRowByWoNo(woNo) {
    var rows = $('#search-grid').datagrid('getRows');
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].woNo === woNo) {
            return rows[i];
        }
    }
    return null;
}

/**
 * 날짜 표시용 포맷 (yyyy-MM-dd)
 * @param {Date} date - 날짜 객체
 * @returns {string} 'yyyy-MM-dd' 형식 문자열
 */
function formatDateDisplay(date) {
    var y = date.getFullYear();
    var m = ('0' + (date.getMonth() + 1)).slice(-2);
    var d = ('0' + date.getDate()).slice(-2);
    return y + '-' + m + '-' + d;
}

/**
 * 날짜 yyyyMMdd 포맷
 */
function formatDateCompact(date) {
    var y = date.getFullYear();
    var m = ('0' + (date.getMonth() + 1)).slice(-2);
    var d = ('0' + date.getDate()).slice(-2);
    return '' + y + m + d;
}

/**
 * yyyyMMdd → Date 객체
 */
function parseDateCompact(str) {
    return new Date(parseInt(str.substring(0, 4)), parseInt(str.substring(4, 6)) - 1, parseInt(str.substring(6, 8)));
}

/**
 * 주차 계산
 */
function getWeekNumber(d) {
    var target = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
    target.setUTCDate(target.getUTCDate() + 4 - (target.getUTCDay() || 7));
    var yearStart = new Date(Date.UTC(target.getUTCFullYear(), 0, 1));
    return Math.ceil((((target - yearStart) / 86400000) + 1) / 7);
}

/**
 * 날짜 네비게이션 초기화 (현재 주간 월~일 설정)
 */
function initDateRange() {
    var today = new Date();
    var day = today.getDay();
    var monday = new Date(today);
    monday.setDate(today.getDate() - (day === 0 ? 6 : day - 1));
    var sunday = new Date(monday);
    sunday.setDate(monday.getDate() + 6);

    consts.currentStartDate = formatDateCompact(monday);
    consts.currentEndDate = formatDateCompact(sunday);

    updateDateRangeLabel(monday, sunday);
    $('#lbl-today').text('금일 : ' + formatDateDisplay(today));
}

/**
 * 주간 이동 (+7 또는 -7)
 * AS-IS: btn_DayPre/Next_Click → dtPop ±7 → timer1_Tick → Search
 */
function navigateWeek(days) {
    // AS-IS: dtPop = dtPop.AddDays(±7)
    var dtPop = parseDateCompact(consts.currentStartDate);
    dtPop.setDate(dtPop.getDate() + days + 3); // 주간 중간일 기준으로 이동

    // AS-IS: GetJuFullStartEndDate(dtPop) → 주간 경계(월~일) 계산
    var day = dtPop.getDay();
    var monday = new Date(dtPop);
    monday.setDate(dtPop.getDate() - (day === 0 ? 6 : day - 1));
    var sunday = new Date(monday);
    sunday.setDate(monday.getDate() + 6);

    consts.currentStartDate = formatDateCompact(monday);
    consts.currentEndDate = formatDateCompact(sunday);

    // AS-IS: timer1_Tick(null, null)
    timerTick();
}

/**
 * 날짜 범위 라벨 업데이트
 * AS-IS: GetWeek() → "YYYY-MM-DD ~ YYYY-MM-DD  N주차"
 */
function updateDateRangeLabel(startDate, endDate) {
    $('#lbl-date-range').text(
        formatDateDisplay(startDate) + ' ~ ' + formatDateDisplay(endDate)
        + '  ' + getWeekNumber(startDate) + '주차'
    );
}

/**
 * 현재 작업자/작업장 라벨 업데이트 (col5 row3-4)
 */
function updateCurrentWorkerLabel() {
    var parts = [];
    if (consts.currentMcName) parts.push('[' + consts.currentMcName + ']');
    if (consts.currentEmpName) parts.push(consts.currentEmpName);
    $('#lbl-current-worker').text(parts.join(' '));
}

/**
 * AS-IS: FirstWorkerSetting()
 * 로그인 사용자 기반 초기 작업자/작업장 자동 세팅
 * POP30A_SER_INIT_WORKER 호출 → EMP_CODE=로그인ID → MAIN_MC_CODE 반환
 */
function initFirstWorker() {
    $.ajax({
        url: consts.url.POP30A_SER_INIT,
        type: 'POST',
        dataType: 'json',
        success: function(data) {
            // addObject → addData → model.addAttribute("rows", Map)
            // 응답: { rows: { rows: [...], rows2: [...] } }
            var wrapper = data.rows || data || {};
            var rows = wrapper.rows || [];
            if (rows.length > 0) {
                var row = rows[0];
                // 작업자 세팅
                consts.currentEmpCode = row.empCode || '';
                consts.currentEmpName = row.empName || '';
                consts.currentIsPop = row.isPop || 0;
                $('#hid-emp-code').val(consts.currentEmpCode);

                // 주설비(MAIN_MC_CODE) 있으면 작업장 자동 세팅
                if (row.mainMcCode && row.mainMcCode !== '') {
                    consts.currentMcCode = row.mainMcCode;
                    consts.currentMcName = row.mainMcName || '';
                    $('#hid-mc-code').val(consts.currentMcCode);
                    $('#hid-mc-name').val(consts.currentMcName);
                }

                // AS-IS: OnLoad → timer1_Tick (첫 조회)
                timerTick();

                // AS-IS: MenuInit → timer1.Start() (첫 조회 이후 타이머 시작)
                startAutoRefresh();
            }
        }
    });
}

/**
 * AS-IS: timer1_Tick - 주기적 자동 갱신 (60초 간격) + 수동 호출 통합
 * 역할:
 *   1. 상단 헤더 갱신 (주차, 금일, 작업장/작업자명)
 *   2. Search() 호출 (그리드 재조회)
 * 호출처:
 *   - setInterval 60초 자동 호출
 *   - 주차 이동 (navigateWeek)
 *   - 작업장/작업자 변경 (onMachineSelected, onEmpSelected)
 *   - 작업 상태 변경 후 (doWorkAction 콜백)
 */
function timerTick() {
    // 헤더 갱신
    if (consts.currentStartDate && consts.currentEndDate) {
        updateDateRangeLabel(
            parseDateCompact(consts.currentStartDate),
            parseDateCompact(consts.currentEndDate)
        );
    }
    updateCurrentWorkerLabel();
    $('#lbl-today').text('금일 : ' + formatDateDisplay(new Date()));

    // AS-IS: _timer3_Tick (Line 900-936)
    // 날짜 변경 감지 → isDailyCheck 리셋 + POP30B_SER6 재조회
    if (consts.currentMcCode) {
        var today = formatDateCompact(new Date());
        if (consts._lastCheckDate && consts._lastCheckDate !== today) {
            // 날짜 변경됨 → 일일점검 상태 리셋 (AS-IS Line 904-906)
            consts.isDailyCheck = false;
            updateDailyCheckBtn();
        }
        consts._lastCheckDate = today;

        // AS-IS Line 911: 시간 > 7시 && 일일점검 미완료 → 재조회
        var hour = new Date().getHours();
        if (hour > 7 && !consts.isDailyCheck) {
            checkDailyInspection(consts.currentMcCode);
        }

        doSearch();
    }
}

/**
 * 자동 갱신 타이머 시작 (AS-IS: timer1.Interval = 60000)
 */
function startAutoRefresh() {
    if (consts._autoRefreshTimer) return;
    consts._autoRefreshTimer = setInterval(function() {
        timerTick();
    }, 60000);  // 60초

    // 그리드 0px 렌더링 자동 복구 (탭 전환 대응)
    // 패널 너비 > 0 (컨테이너 보임) && view 너비 === 0 (숨긴 상태에서 렌더링됨) → 재렌더링
    consts._gridFixTimer = setInterval(function() {
        var $panel = $('#search-grid').datagrid('getPanel');
        if (!$panel.length) return;
        var $view = $panel.find('.datagrid-view');
        if ($panel.width() > 0 && $view.width() === 0) {
            var data = $('#search-grid').datagrid('getData');
            $('#search-grid').datagrid('resize');
            if (data && data.rows && data.rows.length > 0) {
                $('#search-grid').datagrid('loadData', data);
            }
            updateStatusMessage();
        }
    }, 300);
}

/**
 * 자동 갱신 타이머 중지
 */
function stopAutoRefresh() {
    if (consts._autoRefreshTimer) {
        clearInterval(consts._autoRefreshTimer);
        consts._autoRefreshTimer = null;
    }
    if (consts._gridFixTimer) {
        clearInterval(consts._gridFixTimer);
        consts._gridFixTimer = null;
    }
}

/**
 * 로딩바 숨김
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}
