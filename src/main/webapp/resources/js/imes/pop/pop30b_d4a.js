/**
 * ============================================================================
 * 모듈: POP30B_D4A - 자주검사 다이얼로그 JS
 * ============================================================================
 * 설명: 자주검사(D4A) 다이얼로그 전용 JavaScript
 *       pop30b_d4a.open(row) 호출 시 자주검사 팝업이 열림
 *
 * 주요 기능:
 *   1. 검사그룹 콤보 조회 (POP30B_SER4)
 *   2. 검사항목 그리드 조회 (POP30A_SER22) + 이미지 (POP30A_SER21)
 *   3. INS_TYPE별 동적 에디터 (텍스트/숫자/콤보)
 *   4. 부적합 셀 빨강 배경 (Min/Max 초과, NG)
 *   5. 검사결과 임시저장 (POP30B_INS)
 *   6. 검사결과 완료/QMS전송 (POP30B_INS_1)
 *
 * 그리드: plain HTML table (EasyUI datagrid 가로스크롤 한계 → STD04A_D1A 패턴)
 *
 * 작성자: 송우석
 * 작성일: 2026-03-19
 * 수정일: 2026-03-20 (plain HTML table 전환)
 * ============================================================================
 */

// ============================================================================
// URL 상수
// ============================================================================
var _d4aConsts = {
    url: {
        D4A_WO_INFO  : getUrl('/imes/pop/pop30b/POP30B_D4A_WO_INFO.json'),
        POP30B_SER4  : getUrl('/imes/pop/pop30b/POP30B_SER4.json'),
        POP30A_SER21 : getUrl('/imes/pop/pop30b/POP30A_SER21.json'),
        POP30A_SER22 : getUrl('/imes/pop/pop30b/POP30A_SER22.json'),
        D4A_IMG      : getUrl('/imes/pop/pop30b/POP30B_D4A_IMG.json'),
        POP30B_INS   : getUrl('/imes/pop/pop30b/POP30B_INS.json'),
        POP30B_INS_1 : getUrl('/imes/pop/pop30b/POP30B_INS_1.json'),
        CODE_LIST    : getUrl('/common/code/code.json')
    }
};

// ============================================================================
// 코드 데이터 캐시
// ============================================================================
var _d4aCodeData = {};

/** 코드 데이터 동기 로드 */
function _d4aLoadCode(codeGrup) {
    if (_d4aCodeData[codeGrup]) return _d4aCodeData[codeGrup];
    var items = [];
    $.ajax({
        url: _d4aConsts.url.CODE_LIST,
        type: 'POST',
        data: { codeGrup: codeGrup },
        dataType: 'json',
        async: false,
        success: function(response) {
            items = response.rows || response || [];
        }
    });
    _d4aCodeData[codeGrup] = items;
    return items;
}

/** 코드값 → 코드명 변환 */
function _d4aFormatCode(codeGrup, value) {
    if (!value) return '';
    var items = _d4aCodeData[codeGrup] || [];
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd === value) return items[i].codeName;
    }
    return value;
}

// ============================================================================
// 내부 데이터 배열 (datagrid('getRows') 대체)
// ============================================================================
var _d4aRows = [];

// ============================================================================
// D4A 네임스페이스
// ============================================================================
var pop30b_d4a = {
    currentRow: null,
    insmNo: '',

    // ========================================================================
    // 다이얼로그 초기화
    // ========================================================================
    init: function() {
        // 코드 데이터 로드
        _d4aLoadCode('C053');  // TYPE (텍스트/수치/판정/기타)
        _d4aLoadCode('C054');  // 단위
        _d4aLoadCode('C057');  // 판정 (OK/NG)

        // 다이얼로그 설정 (버튼은 상단 toolbar에 배치 — AS-IS 동일)
        $('#d4a-dialog').dialog({
            title   : '자주검사',
            closed  : true,
            modal   : true,
            width   : 1100,
            height  : 580,
            onOpen  : function() {
                $(this).css('visibility', '');
                $(this).dialog('center');
            },
            onClose : function() {
                pop30b_d4a.clear();
            }
        });

        // 인라인 입력 이벤트 바인딩 (이벤트 위임 — 테이블에 1회 바인딩)
        _d4aBindInputEvents();

        // 버튼 이벤트 바인딩
        pop30b_d4a.bindEvents();
    },

    // ========================================================================
    // 버튼 이벤트 바인딩
    // ========================================================================
    bindEvents: function() {
        $('#d4a-grp-select-button').off('click').on('click', function() {
            pop30b_d4a.selectGroup();
        });
        $('#d4a-temp-save-button').off('click').on('click', function() {
            pop30b_d4a.tempSave();
        });
        $('#d4a-complete-button').off('click').on('click', function() {
            pop30b_d4a.complete();
        });
        $('#d4a-close-button').off('click').on('click', function() {
            pop30b_d4a.close();
        });
    },

    // ========================================================================
    // 다이얼로그 열기
    // ========================================================================
    woInfo: null,

    open: function(row) {
        if (!row) return;
        pop30b_d4a.currentRow = row;
        pop30b_d4a.insmNo = '';
        pop30b_d4a.woInfo = null;

        // 라벨 초기화
        $('#d4a-info-label').html('-');
        _d4aShowImage(null);

        // 다이얼로그 열기
        $('#d4a-dialog').dialog('open');

        // 작업지시 정보 조회 → 라벨 표시 → 검사항목 로드
        _d4aLoadWoInfo(row.woNo || row.WO_NO || '');
    },

    currentGrpCode: '',

    // ========================================================================
    // 검사그룹선택 버튼
    // ========================================================================
    selectGroup: function() {
        var row = pop30b_d4a.currentRow;
        if (!row) return;

        $.messager.confirm('확인', '검사결과가 있는경우 초기화 됩니다.\n새로 가져오시겠습니까?', function(r) {
            if (!r) return;

            // 검사그룹 목록 조회 (POP30B_SER4)
            $.ajax({
                url  : _d4aConsts.url.POP30B_SER4,
                type : 'POST',
                data : { plants: window.plants || '3605' },
                dataType: 'json',
                success: function(data) {
                    var grpRows = data.rows || data || [];
                    if (grpRows.length === 0) {
                        $.messager.alert('알림', '검사그룹이 없습니다.', 'info');
                        return;
                    }
                    _d4aShowGroupSelector(grpRows);
                }
            });
        });
    },

    // ========================================================================
    // 검사항목 로드 (POP30A_SER22)
    // ========================================================================
    loadItems: function(insGrpCode) {
        var info = pop30b_d4a.woInfo;
        if (!info) return;

        $.ajax({
            url     : _d4aConsts.url.POP30A_SER22,
            type    : 'POST',
            data    : {
                woNo       : info.woNo || '',
                sapWoNo    : info.sapWoNo || '',
                partCode   : info.partCode || '',
                procCode   : info.procCode || '',
                empCode    : info.empCode || window.currentEmpCode || '',
                insGrpCode : insGrpCode,
                plants     : info.plants || window.plants || '3605'
            },
            dataType: 'json',
            success : function(data) {
                var rows = data.rows || data || [];
                pop30b_d4a.currentGrpCode = insGrpCode;
                _d4aRenderGrid(rows);

                // 이미지 별도 조회 (QCT05A 방식)
                _d4aLoadImage(insGrpCode);
            }
        });
    },

    // ========================================================================
    // 임시저장 (POP30B_INS)
    // ========================================================================
    tempSave: function() {
        _d4aCollectInputValues();
        if (_d4aRows.length === 0) {
            $.messager.alert('알림', '저장할 데이터가 없습니다.', 'info');
            return;
        }

        $.messager.confirm('확인', '임시저장 하시겠습니까?', function(r) {
            if (!r) return;

            var sendModels = _d4aBuildSaveModels(_d4aRows);
            var info = pop30b_d4a.woInfo || {};

            $.ajax({
                url         : _d4aConsts.url.POP30B_INS,
                type        : 'POST',
                contentType : 'application/json',
                data        : JSON.stringify({
                    woNo       : info.woNo || '',
                    sapWoNo    : info.sapWoNo || '',
                    insGrpCode : pop30b_d4a.currentGrpCode || '',
                    empCode    : info.empCode || window.currentEmpCode || '',
                    insmNo     : pop30b_d4a.insmNo || '',
                    models     : JSON.stringify(sendModels)
                }),
                dataType    : 'json',
                success     : function(result) {
                    if (result && result.errCode) {
                        $.messager.alert('오류', result.errMsg || '저장 실패', 'error');
                        return;
                    }
                    $.messager.alert('알림', '임시저장되었습니다.', 'info');
                }
            });
        });
    },

    // ========================================================================
    // 완료/QMS전송 (POP30B_INS_1)
    // ========================================================================
    complete: function() {
        _d4aCollectInputValues();
        if (_d4aRows.length === 0) {
            $.messager.alert('알림', '전송할 데이터가 없습니다.', 'info');
            return;
        }

        $.messager.confirm('확인', '완료 하시겠습니까?\n(QMS로 전송됩니다.)', function(r) {
            if (!r) return;

            var sendModels = _d4aBuildSaveModels(_d4aRows);
            var info = pop30b_d4a.woInfo || {};

            $.ajax({
                url         : _d4aConsts.url.POP30B_INS_1,
                type        : 'POST',
                contentType : 'application/json',
                data        : JSON.stringify({
                    woNo       : info.woNo || '',
                    sapWoNo    : info.sapWoNo || '',
                    insGrpCode : pop30b_d4a.currentGrpCode || '',
                    empCode    : info.empCode || window.currentEmpCode || '',
                    insmNo     : pop30b_d4a.insmNo || '',
                    models     : JSON.stringify(sendModels)
                }),
                dataType    : 'json',
                success     : function(result) {
                    if (result && result.errCode) {
                        $.messager.alert('오류', result.errMsg || '처리 실패', 'error');
                        return;
                    }
                    $.messager.alert('알림', '완료/QMS전송되었습니다.', 'info', function() {
                        pop30b_d4a.close();
                        if (typeof doSearch === 'function') doSearch();
                    });
                }
            });
        });
    },

    // ========================================================================
    // 필드 초기화
    // ========================================================================
    clear: function() {
        pop30b_d4a.currentRow = null;
        pop30b_d4a.woInfo = null;
        pop30b_d4a.currentGrpCode = '';
        pop30b_d4a.insmNo = '';
        _d4aRenderGrid([]);
        _d4aShowImage(null);
        $('#d4a-info-label').html('-');
    },

    // ========================================================================
    // 다이얼로그 닫기
    // ========================================================================
    close: function() {
        $('#d4a-dialog').dialog('close');
    }
};


// ============================================================================
// plain HTML table 렌더링 (datagrid 대체)
// ============================================================================

/**
 * 그리드 데이터 렌더링
 */
function _d4aRenderGrid(rows) {
    _d4aRows = rows || [];
    var $tbody = $('#d4a-tbody');
    $tbody.empty();

    for (var i = 0; i < _d4aRows.length; i++) {
        var row = _d4aRows[i];
        var tr = '<tr data-idx="' + i + '">';
        tr += '<td style="text-align:center">' + (i + 1) + '</td>';
        tr += '<td>' + _esc(row.procName) + '</td>';
        tr += '<td>' + _esc(row.insName) + '</td>';
        tr += '<td>' + _esc(row.insDesc) + '</td>';
        tr += '<td style="text-align:center">' + _d4aFormatCode('C053', row.insType) + '</td>';
        tr += '<td style="text-align:center">' + _esc(row.avgVal) + '</td>';
        tr += '<td style="text-align:center">' + _d4aFormatCode('C054', row.insUnit) + '</td>';
        tr += '<td style="text-align:right">' + _esc(row.minVal) + '</td>';
        tr += '<td style="text-align:right">' + _esc(row.maxVal) + '</td>';
        tr += '<td style="text-align:center" data-field="insResult">' + _d4aResultFormatter(row.insResult, row, i) + '</td>';
        tr += '<td style="text-align:center">' + _d4aResultImgFormatter(row.insResultImg, i) + '</td>';
        tr += '<td>' + _d4aCommentFormatter(row.scomment, i) + '</td>';
        tr += '</tr>';
        $tbody.append(tr);
    }
}

/** HTML 이스케이프 */
function _esc(val) {
    if (val === null || val === undefined) return '';
    return String(val).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

/** 검사결과 이미지 컬럼 (INS_RESULT_IMG) — AS-IS: Picture, Width=250 */
function _d4aResultImgFormatter(value, index) {
    if (value) {
        var src = (value.indexOf('data:') === 0) ? value : 'data:image/png;base64,' + value;
        return '<img src="' + src + '" style="max-width:240px; max-height:60px; object-fit:contain; cursor:pointer;" data-idx="' + index + '" class="d4a-result-img" />';
    }
    return '';
}

/** 비고 컬럼 인라인 입력 */
function _d4aCommentFormatter(value, index) {
    var escaped = (value || '').toString().replace(/"/g, '&quot;');
    return '<input type="text" class="d4a-input d4a-comment-input" data-idx="' + index + '" value="' + escaped + '" />';
}

// ============================================================================
// 내부 헬퍼 함수
// ============================================================================

/**
 * 검사그룹 이미지 별도 조회 (QCT05A 방식 — TO_BASE64)
 */
function _d4aLoadImage(insGrpCode) {
    if (!insGrpCode) {
        _d4aShowImage(null);
        return;
    }
    $.ajax({
        url      : _d4aConsts.url.D4A_IMG,
        type     : 'POST',
        data     : { insGrpCode: insGrpCode },
        dataType : 'json',
        success  : function(data) {
            var b64 = data.imgData || null;
            _d4aShowImage(b64);
        }
    });
}

/**
 * 이미지 표시/초기화 헬퍼
 */
function _d4aShowImage(base64) {
    if (base64) {
        $('#d4a-ins-image').attr('src', 'data:image/png;base64,' + base64).show();
        $('#d4a-image-area .d4a-no-image').hide();
    } else {
        $('#d4a-ins-image').attr('src', '').hide();
        $('#d4a-image-area .d4a-no-image').show();
    }
}

/**
 * 작업지시 정보 조회 → 라벨 표시 → 검사항목 로드
 */
function _d4aLoadWoInfo(woNo) {
    $.ajax({
        url  : _d4aConsts.url.D4A_WO_INFO,
        type : 'POST',
        data : { woNo: woNo },
        dataType: 'json',
        success : function(data) {
            var info = data.rows || data || {};
            if (!info.woNo) {
                $('#d4a-info-label').html('-');
                return;
            }

            pop30b_d4a.woInfo = info;

            var line1 = (info.sapWoNo || '') + ' - ' + (info.procCode || '') + ' - ' + (info.mcCode || '') + ' - ' + (info.model || '');
            var line2 = info.partCode || '';
            var line3 = info.partName || '';
            $('#d4a-info-label').html(line1 + '<br/>' + line2 + '<br/>' + line3);

            _d4aLoadInsData(info);
        }
    });
}

/**
 * 검사항목 로드 (POP30A_SER22)
 */
function _d4aLoadInsData(info) {
    $.ajax({
        url  : _d4aConsts.url.POP30A_SER22,
        type : 'POST',
        data : {
            woNo       : info.woNo || '',
            sapWoNo    : info.sapWoNo || '',
            partCode   : info.partCode || '',
            procCode   : info.procCode || '',
            empCode    : info.empCode || window.currentEmpCode || '',
            insGrpCode : '',
            plants     : info.plants || window.plants || '3605'
        },
        dataType: 'json',
        success : function(data) {
            var rows = data.rows || [];

            pop30b_d4a.currentGrpCode = data.insGrpCode || '';
            pop30b_d4a.insmNo = data.insmNo || '';

            _d4aRenderGrid(rows);

            // 이미지 별도 조회 (QCT05A 방식)
            if (pop30b_d4a.currentGrpCode) {
                _d4aLoadImage(pop30b_d4a.currentGrpCode);
            }
        }
    });
}

/**
 * 검사그룹 선택 팝업 표시
 */
function _d4aShowGroupSelector(grpRows) {
    var html = '<div style="padding:10px; max-height:300px; overflow:auto;">';
    for (var i = 0; i < grpRows.length; i++) {
        var grp = grpRows[i];
        html += '<div class="d4a-grp-item" data-code="' + (grp.insGrpCode || '') + '" ';
        html += 'style="padding:8px 12px; cursor:pointer; border-bottom:1px solid #eee; font-size:13px;"';
        html += ' onmouseover="this.style.backgroundColor=\'#e0f0ff\'" onmouseout="this.style.backgroundColor=\'\'">';
        html += (grp.insGrpName || grp.insGrpCode || '') + '</div>';
    }
    html += '</div>';

    $.messager.alert('검사그룹 선택', html, 'info', function() {});

    setTimeout(function() {
        $(document).off('click.d4aGrp').on('click.d4aGrp', '.d4a-grp-item', function() {
            var grpCode = $(this).data('code');
            $(document).off('click.d4aGrp');
            $('.messager-window').window('close');

            pop30b_d4a.currentGrpCode = grpCode;
            pop30b_d4a.loadItems(grpCode);
        });
    }, 100);
}

/**
 * INS_RESULT 컬럼 formatter (TYPE별 동적 에디터)
 *   TYPE=1,4 → 텍스트 입력
 *   TYPE=2   → 숫자 입력 (소수점2자리)
 *   TYPE=3   → 콤보 (C057: OK/NG 등)
 */
function _d4aResultFormatter(value, row, index) {
    var insType = (row.insType || '1').toString();
    var escaped = (value || '').toString().replace(/"/g, '&quot;');

    if (insType === '3') {
        var c057 = _d4aCodeData['C057'] || [];
        var html = '<select class="d4a-select d4a-result-input" data-idx="' + index + '">';
        html += '<option value=""></option>';
        for (var i = 0; i < c057.length; i++) {
            var sel = (c057[i].codeCd === value) ? ' selected' : '';
            html += '<option value="' + c057[i].codeCd + '"' + sel + '>' + c057[i].codeName + '</option>';
        }
        html += '</select>';
        return html;
    } else if (insType === '2') {
        return '<input type="text" class="d4a-input d4a-result-input" data-idx="' + index + '" value="' + escaped + '" style="text-align:right" />';
    } else {
        return '<input type="text" class="d4a-input d4a-result-input" data-idx="' + index + '" value="' + escaped + '" />';
    }
}

/**
 * 인라인 입력 이벤트 바인딩 (이벤트 위임 — 테이블에 1회 바인딩)
 */
function _d4aBindInputEvents() {
    var $table = $('#d4a-grid');

    // 검사결과 변경 → row 데이터 반영 + 부적합 색상 체크
    $table.off('change input', '.d4a-result-input').on('change input', '.d4a-result-input', function() {
        var idx = parseInt($(this).data('idx'));
        if (_d4aRows[idx]) {
            _d4aRows[idx].insResult = $(this).val();
            _d4aCheckSpec(idx, _d4aRows[idx]);
        }
    });

    // 비고 변경 → row 데이터 반영
    $table.off('change input', '.d4a-comment-input').on('change input', '.d4a-comment-input', function() {
        var idx = parseInt($(this).data('idx'));
        if (_d4aRows[idx]) {
            _d4aRows[idx].scomment = $(this).val();
        }
    });
}

/**
 * 부적합 셀 색상 체크
 *   TYPE=2 (수치): insResult < minVal 또는 insResult > maxVal → 빨강
 *   TYPE=3 (판정): insResult == 'NG' → 빨강
 */
function _d4aCheckSpec(index, row) {
    var $tr = $('#d4a-grid tbody tr[data-idx=' + index + ']');
    var $resultTd = $tr.find('td[data-field=insResult]');

    var insType = (row.insType || '').toString();
    var isNg = false;

    if (insType === '2') {
        var val = parseFloat(row.insResult);
        var min = parseFloat(row.minVal);
        var max = parseFloat(row.maxVal);
        if (!isNaN(val)) {
            if (!isNaN(min) && val < min) isNg = true;
            if (!isNaN(max) && val > max) isNg = true;
        }
    } else if (insType === '3') {
        if (row.insResult === 'NG') isNg = true;
    }

    if (isNg) {
        $resultTd.addClass('d4a-cell-ng');
    } else {
        $resultTd.removeClass('d4a-cell-ng');
    }
}

/**
 * 인라인 입력값을 row 데이터에 수집 (저장 전 호출)
 */
function _d4aCollectInputValues() {
    $('#d4a-grid .d4a-result-input').each(function() {
        var idx = parseInt($(this).data('idx'));
        if (_d4aRows[idx]) _d4aRows[idx].insResult = $(this).val();
    });
    $('#d4a-grid .d4a-comment-input').each(function() {
        var idx = parseInt($(this).data('idx'));
        if (_d4aRows[idx]) _d4aRows[idx].scomment = $(this).val();
    });
}

/**
 * 저장용 모델 배열 생성
 */
function _d4aBuildSaveModels(rows) {
    var models = [];
    for (var i = 0; i < rows.length; i++) {
        var r = rows[i];
        models.push({
            insNo      : r.insNo || '',
            insCode    : r.insCode || '',
            insGrpCode : r.insGrpCode || '',
            procCode   : r.procCode || '',
            insName    : r.insName || '',
            insDesc    : r.insDesc || '',
            insType    : r.insType || '',
            insUnit    : r.insUnit || '',
            avgVal     : (r.avgVal !== '' && r.avgVal != null) ? r.avgVal : null,
            minVal     : (r.minVal !== '' && r.minVal != null) ? r.minVal : null,
            maxVal     : (r.maxVal !== '' && r.maxVal != null) ? r.maxVal : null,
            insResult  : r.insResult || '',
            insSeq     : (r.insSeq !== '' && r.insSeq != null) ? r.insSeq : null,
            scomment   : r.scomment || ''
        });
    }
    return models;
}


// ============================================================================
// jQuery Ready - 초기화
// ============================================================================
$(function() {
    pop30b_d4a.init();
});
