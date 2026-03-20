/**
 * ============================================================================
 * 화면: ORD18A - 실적삭제/삭제현황/오더완료일수정
 * ============================================================================
 * 원본: ProActive ORD18A_M0A.cs
 * 작성일: 2026-03-06
 *
 * 3-Tab 구조:
 *   Tab1 (ACT): 실적삭제 조회 (ORD18A_SER) + 삭제 (ORD18A_DEL)
 *   Tab2 (ACTD): 삭제현황 조회 (ORD18A_SER2) + 삭제취소 (ORD18A_DEL_CANCEL)
 *   Tab3 (WO): 오더완료일 조회 (ORD18A_SER3) + D0A 팝업 수정
 * ============================================================================
 */

// ============================================================================
// 1. 전역 변수
// ============================================================================
var codeDataMap = {};

// ============================================================================
// 2. consts 객체
// ============================================================================
var consts = {
    url: {
        ORD18A_SER:        getUrl('/imes/ord/ord18a/ORD18A_SER.json'),
        ORD18A_SER2:       getUrl('/imes/ord/ord18a/ORD18A_SER2.json'),
        ORD18A_SER3:       getUrl('/imes/ord/ord18a/ORD18A_SER3.json'),
        ORD18A_DEL:        getUrl('/imes/ord/ord18a/ORD18A_DEL.json'),
        ORD18A_DEL_CANCEL: getUrl('/imes/ord/ord18a/ORD18A_DEL_CANCEL.json'),
        ORD18A_UPD:        getUrl('/imes/ord/ord18a/ORD18A_UPD.json'),
        CODE_LIST:         getUrl('/common/code/code.json')
    },

    /** 현재 활성 탭 (ACT / ACTD / WO) */
    currentTab: 'ACT',

    /**
     * 공통 코드 동기 로드
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

    init: function() {
        // 공장 코드(P009) 콤보 초기화
        var plantData = this.loadCode('P009');
        var comboData = [];
        for (var i = 0; i < plantData.length; i++) {
            comboData.push({codeCd: plantData[i].codeCd, codeName: plantData[i].codeName});
        }
        $('#s3_plants').combobox({
            data: comboData,
            valueField: 'codeCd',
            textField: 'codeName',
            value: comboData.length > 0 ? comboData[0].codeCd : ''
        });

        // 버튼 이벤트
        $('#search-button1').bind('click', doSearchTab1);
        $('#search-button2').bind('click', doSearchTab2);
        $('#search-button3').bind('click', doSearchTab3);

        // 액션 버튼 이벤트
        $('#btn-delete').bind('click', doDelete);
        $('#btn-delete-cancel').bind('click', doDeleteCancel);
        $('#btn-wo-edit').bind('click', doOpenD0a);

        // D0A 팝업 버튼 이벤트
        $('#d0a-save-button').bind('click', doSaveD0a);

        // D0A datetimebox: 달력 패널 버튼 높이 보정 (레이어 팝업 내 datetimebox만 적용, 공통 달력 미영향)
        $('#d0a_actStartTime, #d0a_actEndTime').each(function() {
            $(this).datetimebox({ onShowPanel: _d0aFixCalendarBtn });
        });

        // Tab3 오더 완료일 드롭다운: Tab1/Tab2 동일 스타일 (AS-IS acCheckedComboBoxEdit3)

        // 그리드 초기화
        initGrid1();
        initGrid2();
        initGrid3();

        // 그리드 헤더 컨텍스트 메뉴 (정렬/컬럼숨김/엑셀 등)
        GridHeaderMenu('#grid1', { exportFileName: '실적삭제_실적현황' });
        GridHeaderMenu('#grid2', { exportFileName: '실적삭제_삭제현황' });
        GridHeaderMenu('#grid3', { exportFileName: '실적삭제_오더완료일' });

        // 탭 이벤트
        initTabs();
        
        enableGridSortReset('#grid1');
        enableGridSortReset('#grid2');
        enableGridSortReset('#grid3');
    }
};

// ============================================================================
// 3. 초기화
// ============================================================================
$(function() {
    consts.init();
});

$(window).load(function() {
    // 날짜 초기값: 오늘 기준 1주일
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);

    $('#s1_sDate').datebox('setValue', formatDate(weekAgo));
    $('#s1_eDate').datebox('setValue', formatDate(today));
    $('#s2_sDate').datebox('setValue', formatDate(weekAgo));
    $('#s2_eDate').datebox('setValue', formatDate(today));
    $('#s3_sDate').datebox('setValue', formatDate(weekAgo));
    $('#s3_eDate').datebox('setValue', formatDate(today));

    hideLoadingBar();

    // Enter 키 검색
    bindEnterKey('search-form1', doSearchTab1);
    bindEnterKey('search-form2', doSearchTab2);
    bindEnterKey('search-form3', doSearchTab3);
});

// ============================================================================
// 4. 그리드 초기화
// ============================================================================

/**
 * Grid1: 실적삭제
 * AS-IS: acGridView1 컬럼 순서/타입 반영
 */
function initGrid1() {
    $('#grid1').datagrid({
        fit: true,
        border: false,
        singleSelect: true,
        pagination: true,
        pageSize: 100,
        loadFilter: clientPagerFilter,
        rownumbers: true,
        nowrap: true,
        striped: true,
        fitColumns: false,
        columns: [[
            {field:'sel',           title:'선택',         width:40,  halign:'center', align:'center', formatter:formatSelCheckbox, styler:function(){return 'background-color:#FFFFC0;';}},
            {field:'key',           title:'KEY',          width:150, halign:'center', align:'left'},
            {field:'actType',       title:'구분',         width:60,  halign:'center', align:'left'},
            {field:'actContents',   title:'비가동코드',    width:80,  halign:'center', align:'left'},
            {field:'sapCode',       title:'비가동코드(SAP)', width:100, halign:'center', align:'left', hidden:true},
            {field:'idleName',      title:'비가동명',      width:100, halign:'center', align:'left'},
            {field:'orderNo',       title:'판매오더',      width:100, halign:'center', align:'left'},
            {field:'orderLine',     title:'라인',         width:60,  halign:'center', align:'left'},
            {field:'prodHogi',      title:'호기',         width:60,  halign:'center', align:'left'},
            {field:'sapWoNo',       title:'생산오더번호',   width:110, halign:'center', align:'left'},
            {field:'woSeq',         title:'오퍼레이션',    width:80,  halign:'center', align:'left'},
            {field:'procCode',      title:'공정명',       width:60,  halign:'center', align:'left'},
            {field:'customer',      title:'거래처',       width:100, halign:'center', align:'left'},
            {field:'procSt',        title:'ST',          width:60,  halign:'center', align:'left'},
            {field:'empCode',       title:'작업자 코드',   width:80,  halign:'center', align:'left'},
            {field:'empName',       title:'작업자',       width:80,  halign:'center', align:'left'},
            {field:'actStartTime',  title:'시작시간',      width:130, halign:'center', align:'center', formatter:formatMediumDate2},
            {field:'actEndTime',    title:'종료시간',      width:130, halign:'center', align:'center', formatter:formatMediumDate2},
            {field:'actTime',       title:'실적시간(분)',   width:80,  halign:'center', align:'right',  formatter:formatNumeric},
            {field:'woEndTime',     title:'오더완료일',    width:130, halign:'center', align:'center', formatter:formatMediumDate2},
            {field:'sapMcCode',     title:'작업장 코드',   width:80,  halign:'center', align:'left'},
            {field:'mcName',        title:'작업장',       width:80,  halign:'center', align:'left'},
            {field:'preWork',       title:'준비작업여부',   width:80,  halign:'center', align:'left'},
            {field:'prodType',      title:'작업장 구분',   width:80,  halign:'center', align:'left'},
            {field:'procStat',      title:'상태',         width:80,  halign:'center', align:'center', formatter:formatS034},
            {field:'ngId',          title:'부적합/결품ID', width:100, halign:'center', align:'left'}
        ]],
        onLoadSuccess: function(data) {
            $('#grid1').datagrid('uncheckAll');
            $('#grid1').datagrid('clearChecked');
        }
    });
}

/**
 * Grid2: 삭제현황
 * AS-IS: acGridView2 컬럼 (Grid1 + SAP 관련 추가 컬럼)
 */
function initGrid2() {
    $('#grid2').datagrid({
        fit: true,
        border: false,
        singleSelect: true,
        pagination: true,
        pageSize: 100,
        loadFilter: clientPagerFilter,
        rownumbers: true,
        nowrap: true,
        striped: true,
        fitColumns: false,
        columns: [[
            {field:'sel',            title:'선택',          width:40,  halign:'center', align:'center', formatter:formatSelCheckbox, styler:function(){return 'background-color:#FFFFC0;';}},
            {field:'key',            title:'KEY',           width:120, halign:'center', align:'left'},
            {field:'actType',        title:'구분',          width:60,  halign:'center', align:'left'},
            {field:'actContents',    title:'비가동코드',     width:80,  halign:'center', align:'left'},
            {field:'sapCode',        title:'비가동코드(SAP)', width:100, halign:'center', align:'left', hidden:true},
            {field:'idleName',       title:'비가동명',       width:100, halign:'center', align:'left'},
            {field:'orderNo',        title:'판매오더',       width:100, halign:'center', align:'left'},
            {field:'orderLine',      title:'라인',          width:60,  halign:'center', align:'left'},
            {field:'prodHogi',       title:'호기',          width:60,  halign:'center', align:'left'},
            {field:'sapWoNo',        title:'생산오더번호',    width:110, halign:'center', align:'left'},
            {field:'woSeq',          title:'오퍼레이션',     width:80,  halign:'center', align:'left'},
            {field:'procCode',       title:'공정명',        width:60,  halign:'center', align:'left'},
            {field:'customer',       title:'거래처',        width:100, halign:'center', align:'left'},
            {field:'procSt',         title:'ST',           width:60,  halign:'center', align:'left'},
            {field:'empCode',        title:'작업자 코드',    width:80,  halign:'center', align:'left'},
            {field:'empName',        title:'작업자',        width:80,  halign:'center', align:'left'},
            {field:'actStartTime',   title:'시작시간',       width:130, halign:'center', align:'center', formatter:formatMediumDate2},
            {field:'actEndTime',     title:'종료시간',       width:130, halign:'center', align:'center', formatter:formatMediumDate2},
            {field:'actTime',        title:'실적시간(분)',    width:80,  halign:'center', align:'right',  formatter:formatNumeric},
            {field:'woEndTime',      title:'오더완료일',     width:130, halign:'center', align:'center', formatter:formatMediumDate2},
            {field:'sapMcCode',      title:'작업장 코드',    width:80,  halign:'center', align:'left'},
            {field:'mcName',         title:'작업장',        width:80,  halign:'center', align:'left'},
            {field:'preWork',        title:'준비작업여부',    width:80,  halign:'center', align:'left'},
            {field:'prodType',       title:'작업장 구분',    width:80,  halign:'center', align:'left'},
            {field:'procStat',       title:'상태',          width:80,  halign:'center', align:'center', formatter:formatS034},
            {field:'ngId',           title:'부적합/결품ID',  width:100, halign:'center', align:'left'},
            {field:'model',          title:'모델',          width:100, halign:'center', align:'left', hidden:true},
            {field:'workLoc',        title:'SAP작업장',     width:80,  halign:'center', align:'left', hidden:true},
            {field:'orderConfValue', title:'SAP입고번호',    width:100, halign:'center', align:'left', hidden:true},
            {field:'orderConfCount', title:'SAP입고카운터',   width:100, halign:'center', align:'left', hidden:true},
            {field:'confValue',      title:'SAP실적번호',    width:100, halign:'center', align:'left', hidden:true},
            {field:'confCount',      title:'SAP실적카운터',   width:100, halign:'center', align:'left', hidden:true},
            {field:'eaiResult',      title:'SAP결과',       width:60,  halign:'center', align:'center', hidden:true},
            {field:'eaiScomment',    title:'SAP결과 비고',   width:150, halign:'center', align:'left', hidden:true},
            {field:'ifSelFlag',      title:'상태',          width:60,  halign:'center', align:'center', hidden:true}
        ]],
        onLoadSuccess: function(data) {
            $('#grid2').datagrid('uncheckAll');
            $('#grid2').datagrid('clearChecked');
        }
    });
}

/**
 * Grid3: 오더완료일수정
 * AS-IS: acGridView3 컬럼
 */
function initGrid3() {
    $('#grid3').datagrid({
        fit: true,
        fitColumns: false,
        border: false,
        singleSelect: true,
        pagination: true,
        pageSize: 100,
        loadFilter: clientPagerFilter,
        rownumbers: true,
        nowrap: true,
        striped: true,
        fitColumns: false,
        columns: [[
            {field:'woNo',          title:'KEY',          width:120, halign:'center', align:'left'},
            {field:'plants',        title:'공장',         width:60,  halign:'center', align:'center', formatter:formatP009},
            {field:'orderNo',       title:'판매오더',      width:100, halign:'center', align:'left'},
            {field:'orderLine',     title:'라인',         width:60,  halign:'center', align:'left'},
            {field:'prodHogi',      title:'호기',         width:140,  halign:'center', align:'left'},
            {field:'partCode',      title:'자재코드',      width:100, halign:'center', align:'left'},
            {field:'partName',      title:'자재명',       width:300, halign:'center', align:'left'},
            {field:'sapWoNo',       title:'생산오더번호',   width:110, halign:'center', align:'left'},
            {field:'woSeq',         title:'오퍼레이션',    width:80,  halign:'center', align:'left'},
            {field:'procCode',      title:'공정명',       width:60,  halign:'center', align:'left'},
            {field:'cvndContents',  title:'거래처',       width:160, halign:'center', align:'left'},
            {field:'plnStartTime',  title:'계획시작일',    width:90,  halign:'center', align:'center', formatter:formatShortDate},
            {field:'actStartTime',  title:'오더시작시간',   width:130, halign:'center', align:'center', formatter:formatMediumDate2},
            {field:'actEndTime',    title:'오더종료시간',   width:130, halign:'center', align:'center', formatter:formatMediumDate2}
        ]],
        onLoadSuccess: function(data) {
            $('#grid3').datagrid('unselectAll');
            $('#grid3').datagrid('clearSelections');
        }
    });
}

function initTabs() {
    $('#main-tabs').tabs({
        onSelect: function(title, index) {
            if (index == 0) {
                consts.currentTab = 'ACT';
            } else if (index == 1) {
                consts.currentTab = 'ACTD';
            } else {
                consts.currentTab = 'WO';
            }
        }
    });
}

// ============================================================================
// 5. 조회 함수
// ============================================================================

/**
 * Tab1: 실적삭제 조회 (ORD18A_SER)
 */
function doSearchTab1() {
    var sDate = $('#s1_sDate').datebox('getValue');
    var eDate = $('#s1_eDate').datebox('getValue');
    if (!sDate || !eDate) {
        $.messager.alert('알림', '검색 기간을 선택해주세요.');
        return;
    }

    var dateTypes = $('#s1_dateType').combobox('getValues');
    var params = {};
    for (var i = 0; i < dateTypes.length; i++) {
        if (dateTypes[i] == 'WORK_DATE') {
            params.sWorkDate = sDate.replace(/-/g, '');
            params.eWorkDate = eDate.replace(/-/g, '');
        } else if (dateTypes[i] == 'WO_DATE') {
            params.sWoDate = sDate.replace(/-/g, '');
            params.eWoDate = eDate.replace(/-/g, '');
        }
    }

    $('#grid1').datagrid('loading');
    $.ajax({
        url: consts.url.ORD18A_SER,
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
 * Tab2: 삭제현황 조회 (ORD18A_SER2)
 */
function doSearchTab2() {
    var sDate = $('#s2_sDate').datebox('getValue');
    var eDate = $('#s2_eDate').datebox('getValue');
    if (!sDate || !eDate) {
        $.messager.alert('알림', '검색 기간을 선택해주세요.');
        return;
    }

    var dateTypes = $('#s2_dateType').combobox('getValues');
    var params = {};
    for (var i = 0; i < dateTypes.length; i++) {
        if (dateTypes[i] == 'WORK_DATE') {
            params.sWorkDate = sDate.replace(/-/g, '');
            params.eWorkDate = eDate.replace(/-/g, '');
        } else if (dateTypes[i] == 'WO_DATE') {
            params.sWoDate = sDate.replace(/-/g, '');
            params.eWoDate = eDate.replace(/-/g, '');
        }
    }

    $('#grid2').datagrid('loading');
    $.ajax({
        url: consts.url.ORD18A_SER2,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#grid2').datagrid('loadData', rows);
            $('#grid2').datagrid('loaded');
        },
        error: function() {
            $('#grid2').datagrid('loaded');
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

/**
 * Tab3: 오더완료일 조회 (ORD18A_SER3)
 * - 오더 완료일 드롭다운에서 체크된 경우에만 날짜 파라미터 전송 (AS-IS 동일)
 */
function doSearchTab3() {
    // 오더 완료일 드롭다운 체크 상태에 따라 날짜 파라미터 분기
    var dateTypes = $('#s3_dateType').combobox('getValues');
    var params = {
        sapWoLike: $('#s3_sapWoLike').textbox('getValue'),
        hogiLike:  $('#s3_hogiLike').textbox('getValue'),
        procLike:  $('#s3_procLike').textbox('getValue'),
        plants:    $('#s3_plants').combobox('getValue'),
        sWoDate:   '',
        eWoDate:   ''
    };
    for (var i = 0; i < dateTypes.length; i++) {
        if (dateTypes[i] == 'WO_DATE') {
            var sDate = $('#s3_sDate').datebox('getValue');
            var eDate = $('#s3_eDate').datebox('getValue');
            params.sWoDate = sDate ? sDate.replace(/-/g, '') : '';
            params.eWoDate = eDate ? eDate.replace(/-/g, '') : '';
        }
    }

    $('#grid3').datagrid('loading');
    $.ajax({
        url: consts.url.ORD18A_SER3,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#grid3').datagrid('loadData', rows);
            $('#grid3').datagrid('loaded');
        },
        error: function() {
            $('#grid3').datagrid('loaded');
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 6. 삭제 (ORD18A_DEL) - Tab1
// ============================================================================
function doDelete() {
    var checkedRows = getCustomCheckedRows('grid1');
    if (!checkedRows || checkedRows.length == 0) {
        $.messager.alert('알림', '삭제할 행을 체크하세요.');
        return;
    }

    var deleteRows = [];
    for (var i = 0; i < checkedRows.length; i++) {
        deleteRows.push({ key: checkedRows[i].key });
    }

    $.messager.confirm('확인', checkedRows.length + '건을 삭제하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.ORD18A_DEL,
                type: 'POST',
                data: JSON.stringify({ rows: deleteRows }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(result) {
                    if (result.success != false) {
                        $.messager.alert('알림', '삭제되었습니다.');
                        doSearchTab1();
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
// 7. 삭제취소 (ORD18A_DEL_CANCEL) - Tab2
// ============================================================================
function doDeleteCancel() {
    var checkedRows = getCustomCheckedRows('grid2');
    if (!checkedRows || checkedRows.length == 0) {
        $.messager.alert('알림', '복원할 행을 체크하세요.');
        return;
    }

    var restoreRows = [];
    for (var i = 0; i < checkedRows.length; i++) {
        restoreRows.push({ key: checkedRows[i].key });
    }

    $.messager.confirm('확인', checkedRows.length + '건을 복원하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.ORD18A_DEL_CANCEL,
                type: 'POST',
                data: JSON.stringify({ rows: restoreRows }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(result) {
                    if (result.success != false) {
                        $.messager.alert('알림', '복원되었습니다.');
                        doSearchTab2();
                    } else {
                        $.messager.alert('오류', result.message || '복원 실패', 'error');
                    }
                },
                error: function() {
                    $.messager.alert('오류', '복원 중 오류가 발생했습니다.', 'error');
                }
            });
        }
    });
}

// ============================================================================
// 8. D0A 레이어 팝업 (오더완료일 수정) - Tab3
// ============================================================================

/**
 * D0A 팝업 열기 (AS-IS: ORD18A_D0A.cs 팝업)
 * - Grid3에서 선택된 행의 시작/종료 시간을 datetimebox에 설정
 * - EasyUI dialog로 열기
 */
function doOpenD0a() {
    var selected = $('#grid3').datagrid('getSelected');
    if (!selected) {
        $.messager.alert('알림', '수정할 행을 선택하세요.');
        return;
    }

    // hidden 필드에 WO_NO 설정
    $('#d0a_woNo').val(selected.woNo || '');

    // 시작/종료 시간 설정 (yyyyMMddHHmmss 또는 yyyy-MM-dd HH:mm:ss)
    if (selected.actStartTime) {
        $('#d0a_actStartTime').datetimebox('setValue', formatDateTimeForBox(selected.actStartTime));
    } else {
        $('#d0a_actStartTime').datetimebox('setValue', '');
    }
    if (selected.actEndTime) {
        $('#d0a_actEndTime').datetimebox('setValue', formatDateTimeForBox(selected.actEndTime));
    } else {
        $('#d0a_actEndTime').datetimebox('setValue', '');
    }

    // 다이얼로그 열기 (화면 정중앙 배치)
    $('#d0a-dialog').dialog('open').dialog('center');
}

/**
 * D0A 저장 (AS-IS: ORD18A_D0A 저장 버튼)
 * - 시작 > 종료 유효성 검증
 * - ORD18A_UPD 호출
 */
function doSaveD0a() {
    var startTime = $('#d0a_actStartTime').datetimebox('getValue');
    var endTime = $('#d0a_actEndTime').datetimebox('getValue');

    if (!startTime || !endTime) {
        $.messager.alert('알림', '시작시간과 종료시간을 입력하세요.');
        return;
    }

    // 시간 유효성 검증 (AS-IS: 시작 > 종료 불가)
    if (startTime > endTime) {
        $.messager.alert('알림', '시간설정이 잘못되었습니다.');
        return;
    }

    $.ajax({
        url: consts.url.ORD18A_UPD,
        type: 'POST',
        data: {
            woNo: $('#d0a_woNo').val(),
            actStartTime: startTime,
            actEndTime: endTime
        },
        dataType: 'json',
        success: function(result) {
            if (result.success != false) {
                $.messager.alert('알림', '저장되었습니다.', 'info', function() {
                    $('#d0a-dialog').dialog('close');
                    doSearchTab3();
                });
            } else {
                $.messager.alert('오류', result.message || '저장 실패', 'error');
            }
        },
        error: function() {
            $.messager.alert('오류', '저장 중 오류가 발생했습니다.', 'error');
        }
    });
}

/**
 * yyyyMMddHHmmss 또는 datetime → yyyy-MM-dd HH:mm:ss (datetimebox 값 형식)
 */
function formatDateTimeForBox(value) {
    if (!value) return '';
    var s = String(value).replace(/[-:T ]/g, '');
    if (s.length < 8) return value;
    var result = s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
    if (s.length >= 14) {
        result += ' ' + s.substring(8, 10) + ':' + s.substring(10, 12) + ':' + s.substring(12, 14);
    } else if (s.length >= 12) {
        result += ' ' + s.substring(8, 10) + ':' + s.substring(10, 12) + ':00';
    } else if (s.length >= 10) {
        result += ' ' + s.substring(8, 10) + ':00:00';
    } else {
        result += ' 00:00:00';
    }
    return result;
}

// ============================================================================
// 9. 체크박스 관련
// ============================================================================

function formatSelCheckbox(value, row, index) {
    var checked = (value == '1') ? 'checked="checked"' : '';
    return '<input type="checkbox" class="row-checkbox" data-row-index="' + index + '" ' +
           checked + ' onclick="toggleRowSelection(this, event)"/>';
}

function toggleRowSelection(checkbox, event) {
    if (event) {
        event.stopPropagation();
    }
    var index = parseInt($(checkbox).attr('data-row-index'));
    if (isNaN(index) || index < 0) return;

    var gridId = 'grid1';
    if (consts.currentTab == 'ACTD') gridId = 'grid2';
    var rows = $('#' + gridId).datagrid('getRows');
    if (rows[index]) {
        rows[index].sel = checkbox.checked ? '1' : '0';
    }
}

function getCustomCheckedRows(gridId) {
    var rows = [];
    var allRows = $('#' + gridId).datagrid('getRows');
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel == '1') {
            rows.push(allRows[i]);
        }
    }
    return rows;
}

// ============================================================================
// 10. 포맷터
// ============================================================================

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

function formatShortDate(value) {
    if (!value) return '';
    var s = String(value).replace(/[-/ ]/g, '');
    if (s.length < 8) return value;
    return s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
}

function formatNumeric(value) {
    if (value == null || value == undefined || value == '') return '';
    var num = Number(value);
    if (isNaN(num)) return value;
    return num.toLocaleString('en-US', { maximumFractionDigits: 0 });
}

function formatS034(value) {
    if (!value) return '';
    if (value == '2') return '진행';
    if (value == '3') return '중단';
    if (value == '4') return '완료';
    return value;
}

function formatP009(value) {
    if (!value) return '';
    var items = codeDataMap['P009'] || [];
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd == value) {
            return items[i].codeName || value;
        }
    }
    return value;
}

// ============================================================================
// 11. 클라이언트 페이징
// ============================================================================


// ============================================================================
// 12. 유틸리티
// ============================================================================

function formatDate(dt) {
    return dt.getFullYear() + '-' + pad2(dt.getMonth() + 1) + '-' + pad2(dt.getDate());
}

function pad2(n) {
    return (n < 10 ? '0' : '') + n;
}

function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').css('display', '');
}

/**
 * D0A datetimebox: 달력 패널 버튼 높이 보정
 * - D0A 레이어 팝업 내 datetimebox에만 적용 (공통 달력 미영향)
 */
function _d0aFixCalendarBtn() {
    var $panel = $(this).combo('panel');
    // 버튼(a) 높이 18→30px
    $panel.find('.datebox-button a').css({ 'height': '30px'});
    $panel.find('.datebox-button').css({ 'height': '32px', 'line-height': '30px' });

    // 달력 날짜 클릭 시 자동으로 Ok 버튼 trigger (중복 바인딩 방지)
    if (!$panel.data('d0a-autoOk')) {
        $panel.data('d0a-autoOk', true);
        $panel.on('click.d0a', '.calendar td', function() {
            var text = $.trim($(this).text());
            if (/^\d{1,2}$/.test(text)) {
                setTimeout(function() {
                    $panel.find('.datebox-button a').eq(1).trigger('click');
                }, 100);
            }
        });
    }
}

/**
 * Enter 키 바인딩 (검색 폼)
 */
function bindEnterKey(formId, searchFn) {
    $('#' + formId).bind('keydown', function(e) {
        if (e.keyCode == 13) {
            searchFn();
        }
    });
}
