/**
 * ============================================================================
 * 화면: POP33A - SAP실적처리
 * ============================================================================
 * 원본: ProActive POP33A_M0A.cs
 * 작성일: 2026-03-05
 *
 * 주요 기능:
 *   1. Grid1: 일별 공수 현황 조회 (POP33A_SER)
 *   2. Grid2: 실적현황 조회 (POP33A_SER2)
 *   3. Grid3: 삭제현황 조회 (POP33A_SER3)
 *   4. IF_SEL_FLAG 저장 (POP33A_INS)
 *   5. SAP 전송 (POP33A_INS2)
 *   6. 실적 삭제 (POP33A_DEL)
 *   7. 삭제 취소 (POP33A_DEL_CANCEL)
 *   8. 제외 여부 저장 (POP33A_INS3)
 *   9. 기준설정 팝업 (localStorage)
 *
 * 그리드 구조:
 *   Grid1 (Master) → Grid2 (Detail: 실적현황 탭) / Grid3 (Detail: 삭제현황 탭)
 * ============================================================================
 */

// ============================================================================
// 1. consts 객체 (URL 설정 및 초기화)
// ============================================================================

/** FIX2: 코드 데이터 캐시 (코드 → 명칭 변환) */
var codeDataMap = {};

var consts = {
    url: {
        POP33A_SER:        getUrl('/imes/pop/pop33a/POP33A_SER.json'),
        POP33A_SER2:       getUrl('/imes/pop/pop33a/POP33A_SER2.json'),
        POP33A_SER3:       getUrl('/imes/pop/pop33a/POP33A_SER3.json'),
        POP33A_INS:        getUrl('/imes/pop/pop33a/POP33A_INS.json'),
        POP33A_INS2:       getUrl('/imes/pop/pop33a/POP33A_INS2.json'),
        POP33A_DEL:        getUrl('/imes/pop/pop33a/POP33A_DEL.json'),
        POP33A_DEL_CANCEL: getUrl('/imes/pop/pop33a/POP33A_DEL_CANCEL.json'),
        POP33A_INS3:       getUrl('/imes/pop/pop33a/POP33A_INS3.json'),
        CODE_LIST:         getUrl('/common/code/code.json')  // FIX2: 코드 조회 URL
    },

    /** 현재 선택된 탭 (ACT / DEL) */
    currentTab: 'ACT',

    /** Grid1 선택된 행 정보 */
    selectedRow: null,

    /**
     * FIX2: 코드 데이터 로드 함수
     * @param {String} codeGrup 코드그룹 (예: S029)
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
        // FIX2: S029 코드 데이터 로드 (구분)
        this.loadCode('S029');
        // 버튼 이벤트 바인딩
        $('#search-button').bind('click', doSearch);
        $('#save-button').bind('click', doSave);
        $('#delete-button').bind('click', doDelete);
        $('#delete-cancel-button').bind('click', doDeleteCancel);
        $('#sap-send-button').bind('click', doSapSend);
        $('#except-save-button').bind('click', doExceptSave);
        $('#popup-setting-button').bind('click', doOpenSetting);

        // 기준설정 팝업 버튼
        $('#setting-save-button').bind('click', doSettingSave);

        // Enter 키 검색
        $('#search-form').bind('keydown', function(e) {
            if (e.keyCode == 13) {
                doSearch();
            }
        });

        // 그리드 초기화
        initGrid1();
        initGrid2();
        initGrid3();

        // 그리드 헤더 컨텍스트 메뉴 (정렬/컬럼숨김/엑셀 등)
        GridHeaderMenu('#grid1', { exportFileName: 'SAP실적처리_일별공수' });
        GridHeaderMenu('#grid2', { exportFileName: 'SAP실적처리_실적현황' });
        GridHeaderMenu('#grid3', { exportFileName: 'SAP실적처리_삭제현황' });

        // 탭 이벤트
        initTabs();
        
        enableGridSortReset('#grid1');
        enableGridSortReset('#grid2');
        enableGridSortReset('#grid3');
    }
};

// ============================================================================
// 2. jQuery Ready
// ============================================================================
$(function() {
    consts.init();
});

// ============================================================================
// 2-1. 버튼 활성화/비활성화 헬퍼
//      (easyui.css에서 .l-btn-disabled에 display:none이 설정되어 있어
//       linkbutton('disable') 호출 시 버튼이 숨겨지는 문제 우회)
// ============================================================================

/** 버튼 비활성화 (보이되 클릭 불가) */
function disableBtn(id) {
    var $btn = $('#' + id);
    // linkbutton 초기화 전이면 무시 (EasyUI 파싱 중 onSelect 호출 시 방지)
    if (!$btn.data('linkbutton')) return;
    $btn.linkbutton('disable').css('display', 'inline-block');
}

/** 버튼 활성화 */
function enableBtn(id) {
    var $btn = $('#' + id);
    if (!$btn.data('linkbutton')) return;
    $btn.linkbutton('enable');
}

/** 버튼이 비활성화 상태인지 확인 */
function isBtnDisabled(id) {
    var $btn = $('#' + id);
    if (!$btn.data('linkbutton')) return false;
    return $btn.linkbutton('options').disabled;
}

// ============================================================================
// 3. window.load
// ============================================================================
$(window).load(function() {
    // 날짜 초기값: 오늘 기준 1주일
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);
    $('#s_sWorkDate').datebox('setValue', formatDate(weekAgo));
    $('#s_eWorkDate').datebox('setValue', formatDate(today));

    hideLoadingBar();

    // 초기 버튼 상태: Tab 0 (실적현황) 기본 → 삭제취소만 비활성화
    disableBtn('delete-cancel-button');

});

// ============================================================================
// 4. 그리드 초기화
// ============================================================================

/**
 * Grid1: 일별 공수 현황 (Master)
 */
function initGrid1() {
    $('#grid1').datagrid({
        fit: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        striped: true,
        fitColumns: false,
        onClickRow: function(index, row) {
            // Master 행 선택 시 Detail 조회
            consts.selectedRow = row;
            if (consts.currentTab == 'ACT') {
                doSearchDetail2();
            } else {
                doSearchDetail3();
            }
        },
        onLoadSuccess: function(data) {
            var rows = data.rows || data || [];
            if (rows.length > 0) {
                // 첫 번째 행 자동 선택 + Detail 조회
                $('#grid1').datagrid('selectRow', 0);
                consts.selectedRow = rows[0];
                if (consts.currentTab == 'ACT') {
                    doSearchDetail2();
                } else {
                    doSearchDetail3();
                }
            } else {
                consts.selectedRow = null;
                $('#grid2').datagrid('loadData', []);
                $('#grid3').datagrid('loadData', []);
            }
        },
        /**
         * AS-IS: SAP_RATE에 따라 행 색상 변경
         */
        rowStyler: function(index, row) {
            // 오류율 기준값 (localStorage에서 로드)
            var percent = parseFloat(localStorage.getItem('POPUP_PERCENT') || '0') / 100;
            if (row.sapRate != null && row.sapRate != '') {
                var rate = parseFloat(row.sapRate);
                if (!isNaN(rate) && !isNaN(percent) && percent > 0) {
                    if (Math.abs(rate) >= percent) {
                        return 'background-color:#FFE0E0;';
                    }
                }
            }
        }
    });
}

/**
 * Grid2: 실적현황 (Detail - ACT 탭)
 */
function initGrid2() {
    $('#grid2').datagrid({
        fit: true,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,  // FIX4: false로 변경 — 행 클릭이 체크 토글하지 않도록
        pagination: false,
        rownumbers: true,
        nowrap: true,
        striped: true,
        fitColumns: false,
        onLoadSuccess: function(data) {
            // FIX5: 체크 상태 초기화 (sel 데이터 값 기반으로 체크박스 렌더링)
            $('#grid2').datagrid('uncheckAll');
            $('#grid2').datagrid('clearChecked');
        },
        /**
         * AS-IS: Grid2 CustomDrawCell - IF_SEL_FLAG에 따라 행 색상
         */
        rowStyler: function(index, row) {
            if (row.ifSelFlag == '2') {
                return 'background-color:#F0FFF0;';  // Honeydew (완료)
            } else if (row.ifSelFlag == '1') {
                return 'background-color:#F0F8FF;';  // AliceBlue (대기)
            }
        }
    });
}

/**
 * Grid3: 삭제현황 (Detail - DEL 탭)
 */
function initGrid3() {
    $('#grid3').datagrid({
        fit: true,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,  // FIX4: false로 변경 — 행 클릭이 체크 토글하지 않도록
        pagination: false,
        rownumbers: true,
        nowrap: true,
        striped: true,
        fitColumns: false,
        onLoadSuccess: function(data) {
            // FIX5: 체크 상태 초기화 (sel 데이터 값 기반으로 체크박스 렌더링)
            $('#grid3').datagrid('uncheckAll');
            $('#grid3').datagrid('clearChecked');
        }
    });
}

/**
 * 탭 초기화 및 이벤트
 */
function initTabs() {
    $('#detail-tabs').tabs({
        onSelect: function(title, index) {
            if (index == 0) {
                // 실적현황 탭: 삭제, 저장, SAP전송 활성화 / 삭제취소 비활성화
                consts.currentTab = 'ACT';
                enableBtn('delete-button');
                enableBtn('save-button');
                enableBtn('sap-send-button');
                disableBtn('delete-cancel-button');
                // Grid2 조회
                if (consts.selectedRow) {
                    doSearchDetail2();
                }
            } else {
                // 삭제현황 탭: 삭제취소 활성화 / 삭제, 저장, SAP전송 비활성화
                consts.currentTab = 'DEL';
                enableBtn('delete-cancel-button');
                disableBtn('delete-button');
                disableBtn('save-button');
                disableBtn('sap-send-button');
                // Grid3 조회
                if (consts.selectedRow) {
                    doSearchDetail3();
                }
            }
        }
    });
}

// ============================================================================
// 5. 조회 함수
// ============================================================================

/**
 * Grid1 조회 (POP33A_SER)
 */
function doSearch() {
    var sDate = $('#s_sWorkDate').datebox('getValue');
    var eDate = $('#s_eWorkDate').datebox('getValue');

    if (!sDate || !eDate) {
        $.messager.alert('알림', '검색 기간을 선택해주세요.');
        return;
    }

    $('#grid1').datagrid('loading');
    $.ajax({
        url: consts.url.POP33A_SER,
        type: 'POST',
        data: {
            sWorkDate: sDate.replace(/-/g, ''),
            eWorkDate: eDate.replace(/-/g, ''),
            empLike: $('#s_empLike').textbox('getValue'),
            empGubun2: $('#s_empGubun2').combobox('getValue')
        },
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
 * Grid2 조회 (POP33A_SER2) - 실적현황
 */
function doSearchDetail2() {
    if (!consts.selectedRow) return;

    $('#grid2').datagrid('loading');
    $.ajax({
        url: consts.url.POP33A_SER2,
        type: 'POST',
        data: {
            empCode: consts.selectedRow.empCode,
            workDate: consts.selectedRow.workDateKey || consts.selectedRow.workDate
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

/**
 * Grid3 조회 (POP33A_SER3) - 삭제현황
 */
function doSearchDetail3() {
    if (!consts.selectedRow) return;

    $('#grid3').datagrid('loading');
    $.ajax({
        url: consts.url.POP33A_SER3,
        type: 'POST',
        data: {
            empCode: consts.selectedRow.empCode,
            workDate: consts.selectedRow.workDateKey || consts.selectedRow.workDate
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#grid3').datagrid('loadData', rows);
            $('#grid3').datagrid('loaded');
        },
        error: function() {
            $('#grid3').datagrid('loaded');
        }
    });
}

// ============================================================================
// 6. 저장 (POP33A_INS) - IF_SEL_FLAG 저장
// ============================================================================
function doSave() {
    if (isBtnDisabled('save-button')) return;
    // FIX5: 데이터 모델의 sel 값 기반으로 체크된 행 조회
    var checkedRows = getCustomCheckedRows('grid2');
    if (!checkedRows || checkedRows.length == 0) {
        $.messager.alert('알림', '저장할 행을 선택하세요.');
        return;
    }

    // 체크된 행: IF_SEL_FLAG='1', 체크 해제된 행: IF_SEL_FLAG='0'
    var allRows = $('#grid2').datagrid('getRows');
    var saveRows = [];
    for (var i = 0; i < allRows.length; i++) {
        var row = allRows[i];
        // AS-IS: IF_SEL_FLAG='2'이면 변경 불가
        if (row.ifSelFlag == '2') continue;

        var isChecked = false;
        for (var j = 0; j < checkedRows.length; j++) {
            if (checkedRows[j].key == row.key) {
                isChecked = true;
                break;
            }
        }
        saveRows.push({
            key: row.key,
            ifSelFlag: isChecked ? '1' : '0'
        });
    }

    $.messager.confirm('확인', '선택한 항목의 IF_SEL_FLAG를 저장하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.POP33A_INS,
                type: 'POST',
                data: JSON.stringify({ rows: saveRows }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(result) {
                    if (result.success != false) {
                        $.messager.alert('알림', '저장되었습니다.');
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
    });
}

// ============================================================================
// 7. 삭제 (POP33A_DEL)
// ============================================================================
function doDelete() {
    if (isBtnDisabled('delete-button')) return;
    // FIX5: 데이터 모델의 sel 값 기반으로 체크된 행 조회
    var checkedRows = getCustomCheckedRows('grid2');
    if (!checkedRows || checkedRows.length == 0) {
        $.messager.alert('알림', '삭제할 행을 선택하세요.');
        return;
    }

    var deleteRows = [];
    for (var i = 0; i < checkedRows.length; i++) {
        deleteRows.push({ key: checkedRows[i].key });
    }

    $.messager.confirm('확인', checkedRows.length + '건을 삭제하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.POP33A_DEL,
                type: 'POST',
                data: JSON.stringify({ rows: deleteRows }),
                contentType: 'application/json',
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
// 8. 삭제취소 (POP33A_DEL_CANCEL)
// ============================================================================
function doDeleteCancel() {
    if (isBtnDisabled('delete-cancel-button')) return;
    // FIX5: 데이터 모델의 sel 값 기반으로 체크된 행 조회
    var checkedRows = getCustomCheckedRows('grid3');
    if (!checkedRows || checkedRows.length == 0) {
        $.messager.alert('알림', '복원할 행을 선택하세요.');
        return;
    }

    var restoreRows = [];
    for (var i = 0; i < checkedRows.length; i++) {
        restoreRows.push({ key: checkedRows[i].key });
    }

    $.messager.confirm('확인', checkedRows.length + '건을 복원하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.POP33A_DEL_CANCEL,
                type: 'POST',
                data: JSON.stringify({ rows: restoreRows }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(result) {
                    if (result.success != false) {
                        $.messager.alert('알림', '복원되었습니다.');
                        doSearch();
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
// 9. SAP 전송 (POP33A_INS2)
// ============================================================================
function doSapSend() {
    if (isBtnDisabled('sap-send-button')) return;
    if (!consts.selectedRow) {
        $.messager.alert('알림', 'Grid1에서 행을 선택하세요.');
        return;
    }

    // FIX5: 데이터 모델의 sel 값 기반으로 체크된 행 조회
    var checkedRows = getCustomCheckedRows('grid2');
    if (!checkedRows || checkedRows.length == 0) {
        $.messager.alert('알림', 'SAP 전송할 행을 선택하세요.');
        return;
    }

    // AS-IS: IF_SEL_FLAG='1'(저장) 행만 전송 가능 ('0'=대기, '2'=전송완료 제외)
    var validChecked = [];
    for (var i = 0; i < checkedRows.length; i++) {
        if (checkedRows[i].ifSelFlag == '1') {
            validChecked.push(checkedRows[i]);
        }
    }
    if (validChecked.length == 0) {
        $.messager.alert('알림', '전송할 항목이 없습니다.\n상태가 저장일때 SAP전송 가능합니다.');
        return;
    }

    // 체크/미체크 행 모두 전송 (IF_SEL_FLAG 값 포함)
    var allRows = $('#grid2').datagrid('getRows');
    var sendRows = [];
    for (var i = 0; i < allRows.length; i++) {
        var row = allRows[i];
        var isChecked = false;
        // IF_SEL_FLAG='1'인 체크된 행만 '2'(전송)로 변경
        for (var j = 0; j < validChecked.length; j++) {
            if (validChecked[j].key == row.key) {
                isChecked = true;
                break;
            }
        }
        sendRows.push({
            key: row.key,
            ifSelFlag: isChecked ? '2' : row.ifSelFlag
        });
    }

    $.messager.confirm('확인', 'SAP 전송하시겠습니까?', function(r) {
        if (r) {
            $.ajax({
                url: consts.url.POP33A_INS2,
                type: 'POST',
                data: JSON.stringify({
                    empCode: consts.selectedRow.empCode,
                    workDate: consts.selectedRow.workDateKey || consts.selectedRow.workDate,
                    sendFlag: '1',
                    rows: sendRows
                }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(result) {
                    if (result.success != false) {
                        $.messager.alert('알림', 'SAP 전송되었습니다.');
                        doSearch();
                    } else {
                        $.messager.alert('오류', result.message || 'SAP 전송 실패', 'error');
                    }
                },
                error: function() {
                    $.messager.alert('오류', 'SAP 전송 중 오류가 발생했습니다.', 'error');
                }
            });
        }
    });
}

// ============================================================================
// 10. 제외 저장 (POP33A_INS3)
// ============================================================================
function doExceptSave() {
    // 제외 체크박스를 변경한 행만 저장
    var allRows = $('#grid1').datagrid('getRows');
    var saveRows = [];
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i]._exceptChanged) {
            saveRows.push({
                workDate: allRows[i].workDateKey || allRows[i].workDate,
                empCode: allRows[i].empCode,
                isExcept: allRows[i].isExcept == '1' ? '1' : '0'
            });
        }
    }

    if (saveRows.length == 0) {
        $.messager.alert('알림', '제외 여부를 변경한 행이 없습니다.');
        return;
    }

    $.ajax({
        url: consts.url.POP33A_INS3,
        type: 'POST',
        data: JSON.stringify({ rows: saveRows }),
        contentType: 'application/json',
        dataType: 'json',
        success: function(result) {
            if (result.success != false) {
                $.messager.alert('알림', '저장되었습니다.');
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
// 11. 기준설정 팝업 (localStorage)
// ============================================================================

/**
 * 기준설정 팝업 열기
 */
function doOpenSetting() {
    // localStorage에서 값 로드
    var percent = localStorage.getItem('POPUP_PERCENT') || '0';
    $('#f_percent').numberbox('setValue', percent);
    $('#setting-dialog').dialog('open').dialog('center');
}

/**
 * 기준설정 저장 (localStorage)
 */
function doSettingSave() {
    var percent = $('#f_percent').numberbox('getValue');
    localStorage.setItem('POPUP_PERCENT', percent);
    $('#setting-dialog').dialog('close');
    // 그리드 새로고침 (행 스타일 반영)
    $('#grid1').datagrid('loadData', $('#grid1').datagrid('getData'));
}

/**
 * 기준설정 팝업 닫기
 */
function doSettingClose() {
    $('#setting-dialog').dialog('close');
}

// ============================================================================
// 12. 포맷터 (Formatter)
// ============================================================================

/**
 * F2 포맷: 소수점 2자리 (AS-IS: F2 형식)
 */
function formatF2(value) {
    if (value == null || value == undefined || value == '') return '';
    var num = Number(value);
    if (isNaN(num)) return value;
    return num.toFixed(2);
}

/**
 * PER2 포맷: 퍼센트 (소수점 2자리)
 */
function formatPer2(value) {
    if (value == null || value == undefined || value == '') return '';
    var num = Number(value);
    if (isNaN(num)) return value;
    return (num * 100).toFixed(2) + '%';
}

/**
 * NUMERIC 포맷: 정수 콤마 구분
 */
function formatNumeric(value) {
    if (value == null || value == undefined || value == '') return '';
    var num = Number(value);
    if (isNaN(num)) return value;
    return num.toLocaleString('en-US', { maximumFractionDigits: 0 });
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
 * 체크박스 포맷 (IS_EXCEPT)
 * FIX3: Made interactive so users can toggle IS_EXCEPT for "제외 저장" button
 */
function formatCheckbox(value, row, index) {
	console.log("value::", value)
    var checked = (value == '1' || value == 'Y') ? 'checked="checked"' : '';
    return '<input type="checkbox" class="except-checkbox" ' + checked + ' onclick="toggleExcept(this, ' + index + ')"/>';
}

/**
 * FIX3: Toggle IS_EXCEPT value when checkbox is clicked
 */
function toggleExcept(checkbox, index) {
    var row = $('#grid1').datagrid('getRows')[index];
    if (row) {
        row.isExcept = checkbox.checked ? '1' : '0';
        row._exceptChanged = true;  // 변경 플래그
    }
}

/**
 * SEL 체크박스 포맷 (Grid2/Grid3)
 * FIX4: data-row-index 속성으로 안정적인 행 인덱스 참조
 *       IF_SEL_FLAG='2'(완료)인 행은 체크 해제 불가 (disabled)
 */
function formatSelCheckbox(value, row, index) {
    var checked = (value == '1') ? 'checked="checked"' : '';
    // IF_SEL_FLAG='2' 행은 체크박스 비활성화 (해제 불가)
    var disabled = (row.ifSelFlag == '2') ? 'disabled="disabled"' : '';
    return '<input type="checkbox" class="row-checkbox" data-row-index="' + index + '" ' +
           checked + ' ' + disabled + ' onclick="toggleRowSelection(this, event)"/>';
}

/**
 * FIX5: 커스텀 체크박스 클릭 시 데이터 모델의 sel 값 업데이트
 *       EasyUI의 checkRow/getChecked 대신 데이터 모델 기반으로 체크 상태 관리
 *       (EasyUI의 getChecked()는 built-in checkbox column 없이는 안정적으로 동작하지 않음)
 */
function toggleRowSelection(checkbox, event) {
    // 이벤트 버블링 방지 (행 클릭 이벤트와 중복 방지)
    if (event) {
        event.stopPropagation();
    }

    var index = parseInt($(checkbox).attr('data-row-index'));
    if (isNaN(index) || index < 0) return;

    // 데이터 모델의 sel 값 직접 업데이트
    var $grid = (consts.currentTab == 'ACT') ? $('#grid2') : $('#grid3');
    var rows = $grid.datagrid('getRows');
    if (rows[index]) {
        rows[index].sel = checkbox.checked ? '1' : '0';
    }
}

/**
 * FIX5: 커스텀 체크박스 기반 체크된 행 목록 반환
 *       EasyUI의 getChecked() 대신 사용 - 데이터 모델의 sel 값 기반
 * @param {String} gridId 그리드 ID (예: 'grid2', 'grid3')
 * @returns {Array} sel='1'인 행 배열
 */
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

/**
 * S029 LookupEdit 포맷 (구분)
 * FIX2: Changed from passthrough to actual code lookup
 */
function formatS029(value) {
    if (!value && value != 0) return '';
    var items = codeDataMap['S029'] || [];
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd == value) {
            return items[i].codeName || value;
        }
    }
    return value;
}

/**
 * A003 LookupEdit 포맷 (상태: IF_SEL_FLAG)
 */
function formatA003(value) {
    if (!value || value == '0') return '대기';
    if (value == '1') return '저장';
    if (value == '2') return '전송';
    return value;
}

/**
 * S034 LookupEdit 포맷 (실적상태: PROC_STAT)
 */
function formatS034(value) {
    if (!value) return '';
    if (value == '2') return '진행';
    if (value == '3') return '중단';
    if (value == '4') return '완료';
    return value;
}

// ============================================================================
// 13. 유틸리티 함수
// ============================================================================

/**
 * Date → yyyy-MM-dd 문자열
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
 * 로딩바 숨기기
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}
