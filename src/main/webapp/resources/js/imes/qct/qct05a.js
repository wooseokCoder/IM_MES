/**
 * ============================================================================
 * 화면명: QCT05A - 자주검사 그룹 관리
 * ============================================================================
 * 설명: 검사그룹 목록 조회, 등록, 수정
 *       검사그룹-검사항목 매핑 관리
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 공통 JS
 *       D0A: 검사항목 추가 팝업 (좌우 이동)
 *       탭별 독립 그리드 (show/hide 방식, 탭별 독립 상태)
 * 작성자: 송우석
 * 작성일: 2026-03-04
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var codeDataMap = {};           // 코드 데이터 캐시
var d0aInited = false;          // D0A 팝업 초기화 여부
var d0aEditIndex = undefined;   // D0A 좌측 그리드 편집 인덱스
var _selectedImgBase64 = null;  // 이미지 선택 임시 저장 (PROC용)
var _imgMenu = null;            // 이미지 컨텍스트 메뉴 인스턴스

// 탭별 독립 그리드 ID
var _masterGridId = '#master-grid-assy';
var _detailGridId = '#detail-grid-assy';

// 탭별 독립 상태 (각 탭이 자신만의 상태를 보유)
var _tabData = {
    '3603': { masterEditIndex: undefined, changedRows: {}, dbOriginal: {}, currentGrpCode: '', loaded: false },
    '3605': { masterEditIndex: undefined, changedRows: {}, dbOriginal: {}, currentGrpCode: '', loaded: false }
};

/** 현재 활성 탭의 상태 반환 (축약 접근자) */
function _ts() { return _tabData[PAGE_PLANTS]; }

// ============================================================================
// consts (STD45A 패턴)
// ============================================================================
var consts = {
    url: {
        QCT05A_SER:      getUrl('/imes/qct/qct05a/QCT05A_SER.json'),
        QCT05A_SER2:     getUrl('/imes/qct/qct05a/QCT05A_SER2.json'),
        QCT05A_SER3:     getUrl('/imes/qct/qct05a/QCT05A_SER3.json'),
        QCT05A_SER4:     getUrl('/imes/qct/qct05a/QCT05A_SER4.json'),
        QCT05A_INS:      getUrl('/imes/qct/qct05a/QCT05A_INS.json'),
        QCT05A_INS2:     getUrl('/imes/qct/qct05a/QCT05A_INS2.json'),
        QCT05A_DEL:      getUrl('/imes/qct/qct05a/QCT05A_DEL.json'),
        QCT05A_IMG:      getUrl('/imes/qct/qct05a/QCT05A_IMG.json'),
        QCT05A_IMG_SAVE: getUrl('/imes/qct/qct05a/QCT05A_IMG_SAVE.json'),
        QCT05A_PROC:     getUrl('/imes/qct/qct05a/QCT05A_PROC.json'),
        CODE_LIST:       getUrl('/common/code/code.json')
    },

    // 코드 데이터 동기 로드
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

    // 전체 초기화
    init: function() {
        // --- 코드 데이터 로드 ---
        consts.codeData = {};
        consts.codeData.C053 = this.loadCode('C053');
        consts.codeData.C054 = this.loadCode('C054');

        // --- ASSY 그리드 초기화 ---
        _initMasterGrid('#master-grid-assy', '#detail-grid-assy', '3603', true, false);
        _initDetailGrid('#detail-grid-assy', false);

        // --- MACH 그리드 초기화 ---
        _initMasterGrid('#master-grid-mach', '#detail-grid-mach', '3605', false, true);
        _initDetailGrid('#detail-grid-mach', true);

        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#add-group-button').bind('click', doAddGroup);
        $('#save-group-button').bind('click', doSaveGroup);
        $('#add-ins-button').bind('click', doOpenD0a);
        $('#del-ins-button').bind('click', doDelIns);

        // D0A 팝업 버튼 (외부 buttons div — href 로드 전에도 존재)
        $('#d0a-save-button').bind('click', d0aSave);
        $('#d0a-close-button').bind('click', function() {
            $('#d0a-popup').dialog('close');
        });

        // acProcForm 공통 팝업 초기화
        acProcForm.init({
            url: consts.url.QCT05A_PROC,
            lprocCode: PAGE_LPROC_CODE
        });

        // 이미지 버튼 바인딩 (항상 — DOM은 항상 존재, 실행 시 PAGE_SHOW_IMAGE 체크)
        $('#image-select-button').bind('click', _imgSelect);
        $('#image-save-button').bind('click', _imgSaveToServer);

        var imgInput = document.getElementById('_qct05a_img_input');
        if (imgInput) {
            imgInput.onchange = function() {
                _handleImageSelected(this);
            };
        }

        // 이미지 컨텍스트 메뉴 초기화 (edit 모드)
        _imgMenu = new ImgContextMenu({
            menuId: 'qct05a-img-context-menu',
            mode: 'edit',
            targetSelector: '#group-image',
            containerSelector: '#image-container',
            isEnabled: function() { return PAGE_SHOW_IMAGE; },
            onImageChange: function(b64) {
                _selectedImgBase64 = b64 ? ('data:image/png;base64,' + b64) : null;
            },
            getFileName: function() {
                return 'QCT05A_' + (_ts().currentGrpCode || 'image') + '.png';
            }
        });
    }
};


// ============================================================================
// 그리드 초기화 헬퍼 (클로저로 그리드 ID + plants 캡처 → 독립 상태)
// ============================================================================

/**
 * 마스터 그리드 초기화
 * @param {string} gridId - 마스터 그리드 셀렉터
 * @param {string} detailGridId - 연결된 디테일 그리드 셀렉터
 * @param {string} plants - 탭 plants 코드 ('3603' 또는 '3605')
 * @param {boolean} showGrpSeq - 순번 컬럼 표시 여부
 * @param {boolean} showInsGrpModel - 검사품명 컬럼 표시 여부
 */
/**
 * 인라인 에디터 maxlength 일괄 설정 (DB 컬럼 길이 기준, 입력 시점 자릿수 차단)
 * - textbox 에디터: 문자열 컬럼 → maxlength = DB VARCHAR 길이
 * - numberbox 에디터: 정수 컬럼 → maxlength = 9 (INT 최대 9자리)
 * @param $g       datagrid jQuery 객체
 * @param index    행 인덱스
 * @param fieldMap {field: maxlength} 객체 (예: {insGrpName:30, grpSeq:9})
 */
function _setEditorMaxLen($g, index, fieldMap) {
    for (var field in fieldMap) {
        var ed = $g.datagrid('getEditor', {index: index, field: field});
        if (ed) {
            var widget = (ed.type === 'numberbox') ? 'numberbox' : 'textbox';
            $(ed.target)[widget]('textbox').attr('maxlength', fieldMap[field]);
        }
    }
}

function _initMasterGrid(gridId, detailGridId, plants, showGrpSeq, showInsGrpModel) {
    var $g = $(gridId);
    var $d = $(detailGridId);
    var td = _tabData[plants];  // 이 그리드 전용 상태 (클로저 캡처)

    // 컬럼 구성
    var cols = [
        {field: 'insGrpCode', hidden: true},
        {field: 'insGrpName', title: '검사그룹명', width: 150, halign: 'center', align: 'left',
            editor: {type: 'textbox', options: {validType: 'length[0,30]'}}
        }
    ];
    if (showGrpSeq) {
        cols.push({field: 'grpSeq', title: '순번', width: 60, halign: 'center', align: 'right',
            editor: {type: 'numberbox', options: {precision: 0, min: 0, max: 999999999}}
        });
    }
    if (showInsGrpModel) {
        cols.push({field: 'insGrpModel', title: '검사품명', width: 100, halign: 'center', align: 'left',
            editor: {type: 'textbox', options: {validType: 'length[0,30]'}}
        });
    }
    cols.push(
        {field: 'useFlag', title: '사용', width: 130, halign: 'center', align: 'center',
            formatter: function(value, row, index) {
                return _radioUseFlag(index, value);
            }
        },
        {field: 'scomment', title: '비고', width: 150, halign: 'center', align: 'left',
            editor: {type: 'textbox', options: {validType: 'length[0,200]'}}
        }
    );

    // 이미지 표시 여부 (가공 탭만)
    var showImage = (plants === '3605');

    $g.datagrid({
        title: '검사그룹',
        method: 'post',
        fit: true,
        fitColumns: true,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'insGrpCode',
        columns: [cols],
        rowStyler: function(index, row) {
            if (row.insGrpCode && td.changedRows[row.insGrpCode]) {
                return 'background-color:#90EE90';
            }
        },
        onLoadSuccess: function(data) {
            td.masterEditIndex = undefined;
            td.changedRows = {};
            td.dbOriginal = {};
            var rows = data.rows || data;
            for (var i = 0; i < rows.length; i++) {
                var r = rows[i];
                if (r.insGrpCode) {
                    td.dbOriginal[r.insGrpCode] = {
                        insGrpName: r.insGrpName || '',
                        grpSeq: r.grpSeq || '',
                        insGrpModel: r.insGrpModel || '',
                        useFlag: r.useFlag || '',
                        scomment: r.scomment || ''
                    };
                }
            }
            $g.datagrid('unselectAll');
            td.currentGrpCode = '';
            $d.datagrid('loadData', []);
            if (showImage) {
                _clearGroupImage();
            }
            // 조회 완료 후 첫 번째 행 자동 선택
            var allRows = rows;
            if (allRows.length > 0) {
                $g.datagrid('selectRow', 0);
                $g.datagrid('beginEdit', 0);
                td.masterEditIndex = 0;
                var firstRow = allRows[0];
                if (firstRow.insGrpCode) {
                    td.currentGrpCode = firstRow.insGrpCode;
                    _doSearchDetail(firstRow.insGrpCode, $d);
                    if (showImage) {
                        _loadGroupImage(firstRow.insGrpCode);
                    }
                }
            }
        },
        onClickRow: function(index, row) {
            if (td.masterEditIndex !== index) {
                if (td.masterEditIndex !== undefined) {
                    $g.datagrid('endEdit', td.masterEditIndex);
                }
                $g.datagrid('beginEdit', index);
                td.masterEditIndex = index;
                // DB 컬럼 길이에 맞춘 입력 자릿수 제한 (TSTD_INS_GRP)
                // insGrpName:VARCHAR(30), insGrpModel:VARCHAR(30), scomment:VARCHAR(200), grpSeq:INT
                _setEditorMaxLen($g, index, {insGrpName:30, insGrpModel:30, scomment:200, grpSeq:9});
            }
            if (row.insGrpCode) {
                td.currentGrpCode = row.insGrpCode;
                _doSearchDetail(row.insGrpCode, $d);
                if (showImage) {
                    _loadGroupImage(row.insGrpCode);
                }
            } else {
                td.currentGrpCode = '';
                $d.datagrid('loadData', []);
                if (showImage) {
                    _clearGroupImage();
                }
            }
        },
        onBeforeEdit: function(index, row) {
            row._original = $.extend({}, row);
        },
        onAfterEdit: function(index, row, changes) {
            td.masterEditIndex = undefined;
            if (row.insGrpCode && td.dbOriginal[row.insGrpCode]) {
                var orig = td.dbOriginal[row.insGrpCode];
                var isDiff = false;
                for (var key in orig) {
                    if ((row[key] || '') != (orig[key] || '')) {
                        isDiff = true;
                        break;
                    }
                }
                if (isDiff) {
                    td.changedRows[row.insGrpCode] = true;
                } else {
                    delete td.changedRows[row.insGrpCode];
                }
                $g.datagrid('refreshRow', index);
            }
        },
        onCancelEdit: function(index, row) {
            td.masterEditIndex = undefined;
        }
    });
}

/**
 * 디테일 그리드 초기화
 * @param {string} gridId - 디테일 그리드 셀렉터
 * @param {boolean} showProdType - 제품구분 컬럼 표시 여부
 */
function _initDetailGrid(gridId, showProdType) {
    var $g = $(gridId);

    // 컬럼 구성
    var cols = [
        {field: '_rowNum', title: 'No', width: 35, halign: 'center', align: 'center',
            formatter: function(value, row, index) {
                return index + 1;
            }
        },
        {field: 'sel', title: '선택', width: 60, halign: 'center', align: 'center',
            formatter: function(value, row) {
                return '<input type="checkbox" class="emp-sel-ck"/>';
            }},
        {field: 'insGrpCode', hidden: true},
        {field: 'insCode', hidden: true},
        {field: 'procCode', title: '검사공정', width: 75, halign: 'center', align: 'left'}
    ];
    if (showProdType) {
        cols.push({field: 'prodType', title: '제품구분', width: 70, halign: 'center', align: 'center'});
    }
    cols.push(
        {field: 'procName', title: '검사공정명', width: 100, halign: 'center', align: 'left'},
        {field: 'insName', title: '검사항목명', width: 120, halign: 'center', align: 'left'},
        {field: 'insDesc', title: '점검내역', width: 150, halign: 'center', align: 'left'},
        {field: 'insType', title: 'TYPE', width: 60, halign: 'center', align: 'center',
            formatter: function(value) {
                return formatCode('C053', value);
            }
        },
        {field: 'avgVal', title: '기준값', width: 70, halign: 'center', align: 'left'},
        {field: 'insUnit', title: '단위', width: 60, halign: 'center', align: 'center',
            formatter: function(value) {
                return formatCode('C054', value);
            }
        },
        {field: 'minVal', title: 'Min', width: 60, halign: 'center', align: 'right'},
        {field: 'maxVal', title: 'Max', width: 60, halign: 'center', align: 'right'},
        {field: 'insSeq', title: '순번', width: 50, halign: 'center', align: 'right'}
    );

    $g.datagrid({
        title: '검사항목',
        method: 'post',
        fit: true,
        fitColumns: true,
        striped: true,
        singleSelect: false,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'insCode',
        columns: [cols],
        checkOnSelect: false,
        selectOnCheck: false,
        onClickRow: function(index, row) {
            $g.datagrid('unselectAll');
            $g.datagrid('selectRow', index);
        },
        onCheck: function(index, row) {
            $g.datagrid('unselectAll');
            $g.datagrid('selectRow', index);
        }
    });

    // 디테일 그리드 체크박스 클릭 시 녹색 배경 토글
    $g.datagrid('getPanel').on('click', '.emp-sel-ck', function() {
        var tr = $(this).closest('tr.datagrid-row');
        if (this.checked) {
            tr.css('background-color', '#90EE90');
        } else {
            tr.css('background-color', '');
        }
    });
}


// ============================================================================
// 그리드 컬럼 정의 (D0A용)
// ============================================================================

/**
 * 콤보 패널을 입력 위쪽에 표시 (그리드 하단 행에서 잘림 방지)
 */
function _comboShowAbove() {
    var $panel = $(this).combo('panel');
    var $wrap = $panel.panel('panel');
    var $combo = $(this).combo('textbox').closest('.combo');
    if ($combo.length === 0) return;
    var offset = $combo.offset();
    var comboH = $combo.outerHeight();
    var $gp = $('#grid-m').datagrid('getPanel');
    var gridTop = $gp.offset().top;
    var gridBottom = gridTop + $gp.outerHeight();
    var spaceBelow = gridBottom - (offset.top + comboH);
    var spaceAbove = offset.top - gridTop;
    var maxH = Math.max(spaceBelow, spaceAbove) - 5;
    if (maxH < 50) maxH = 50;
    $wrap.css('height', 'auto');
    var panelH = $wrap.outerHeight();
    if (panelH > maxH) {
        $wrap.css('height', maxH + 'px');
        panelH = maxH;
    }
    if (spaceBelow < panelH && spaceAbove > spaceBelow) {
        $wrap.css('top', (offset.top - panelH) + 'px');
    }
}


// ============================================================================
// 화면 초기화
// ============================================================================
$(function() {
    // 500 에러 시 raw 메시지 대신 일반 메시지 표시
    $.ajaxSetup({ statusCode: { 500: function() {
        $.messager.alert('Error', '오류가 발생했습니다.', 'error');
    }}});
    consts.init();

    // 탭 전환 바인딩
    $('#tab-assy').bind('click', function() { switchTab('3603'); });
    $('#tab-mach').bind('click', function() { switchTab('3605'); });
});

$(window).load(function() {
    hideLoadingBar();
    GridHeaderMenu('#master-grid-assy', { exportFileName: '자주검사그룹관리_조립' });
    GridHeaderMenu('#master-grid-mach', { exportFileName: '자주검사그룹관리_가공' });
    GridHeaderMenu('#detail-grid-assy', { exportFileName: '검사항목_조립' });
    GridHeaderMenu('#detail-grid-mach', { exportFileName: '검사항목_가공' });
    enableGridSortReset('#master-grid-assy');
    enableGridSortReset('#master-grid-mach');
    enableGridSortReset('#detail-grid-assy');
    enableGridSortReset('#detail-grid-mach');
});

/**
 * 탭 전환 (조립/가공) — show/hide 방식, 상태는 _tabData에 독립 보관
 */
function switchTab(plants) {
    if (PAGE_PLANTS === plants) return;

    // 현재 탭 편집 중이면 종료
    var curTd = _ts();
    if (curTd.masterEditIndex !== undefined) {
        try { $(_masterGridId).datagrid('endEdit', curTd.masterEditIndex); } catch(e) {}
        curTd.masterEditIndex = undefined;
    }

    // 변수 전환 (AS-IS 기준)
    if (plants === '3603') {
        PAGE_PLANTS = '3603';
        PAGE_PLANTS_NAME = '조립';
        PAGE_LPROC_CODE = 'ASSY';
        PAGE_SHOW_GRP_SEQ = true;
        PAGE_SHOW_INS_GRP_MODEL = false;
        PAGE_SHOW_PROD_TYPE = false;
        PAGE_SHOW_IMAGE = false;
    } else {
        PAGE_PLANTS = '3605';
        PAGE_PLANTS_NAME = '가공';
        PAGE_LPROC_CODE = 'PROC';
        PAGE_SHOW_GRP_SEQ = false;
        PAGE_SHOW_INS_GRP_MODEL = true;
        PAGE_SHOW_PROD_TYPE = true;
        PAGE_SHOW_IMAGE = true;
    }

    // 탭 활성 표시
    $('.plants-tab-item').removeClass('active');
    $(plants === '3603' ? '#tab-assy' : '#tab-mach').addClass('active');

    // 그리드 ID 전환
    _masterGridId = (plants === '3603') ? '#master-grid-assy' : '#master-grid-mach';
    _detailGridId = (plants === '3603') ? '#detail-grid-assy' : '#detail-grid-mach';

    // 패널 show/hide
    if (plants === '3603') {
        $('#master-panel-mach').hide();
        $('#detail-panel-mach').hide();
        $('#master-panel-assy').show();
        $('#detail-panel-assy').show();
    } else {
        $('#master-panel-assy').hide();
        $('#detail-panel-assy').hide();
        $('#master-panel-mach').show();
        $('#detail-panel-mach').show();
    }

    // 이미지 패널 표시/숨김
    if (PAGE_SHOW_IMAGE) {
        $('#image-panel').panel('open');
    } else {
        _clearGroupImage();
        $('#image-panel').panel('close');
    }
    $('#west-inner-layout').layout('resize');

    // 이미지 base64 해제 + 클립보드 초기화
    _selectedImgBase64 = null;
    if (_imgMenu) _imgMenu.clearClipboard();

    // 그리드 리사이즈 (display:none → show 후 필수)
    $(_masterGridId).datagrid('resize');
    $(_detailGridId).datagrid('resize');

    // 탭 상태 초기화 (처음 방문)
    if (!_tabData[plants].loaded) {
        _tabData[plants].loaded = true;
    }
}


// ============================================================================
// 포맷터 함수
// ============================================================================

/**
 * 코드값 → 코드명 포맷터
 */
function formatCode(codeGrup, value) {
    if (!value) return '';
    if (codeDataMap[codeGrup]) {
        for (var i = 0; i < codeDataMap[codeGrup].length; i++) {
            if (codeDataMap[codeGrup][i].codeCd === value) {
                return codeDataMap[codeGrup][i].codeName;
            }
        }
    }
    return value;
}


// ============================================================================
// 사용여부 라디오버튼
// ============================================================================
function _radioUseFlag(index, value) {
    var chkY = (value === 'Y') ? ' checked' : '';
    var chkN = (value !== 'Y') ? ' checked' : '';
    return '<label style="margin-right:4px"><input type="radio" name="uf_m_' + index + '"' + chkY +
           ' onclick="event.stopPropagation(); toggleMasterUseFlag(' + index + ',\'Y\')"/> 사용</label>' +
           '<label><input type="radio" name="uf_m_' + index + '"' + chkN +
           ' onclick="event.stopPropagation(); toggleMasterUseFlag(' + index + ',\'N\')"/> 미사용</label>';
}

function toggleMasterUseFlag(index, value) {
    var td = _ts();
    if (td.masterEditIndex !== undefined) {
        $(_masterGridId).datagrid('endEdit', td.masterEditIndex);
        td.masterEditIndex = undefined;
    }
    var rows = $(_masterGridId).datagrid('getRows');
    if (rows[index]) {
        rows[index].useFlag = value;
        // 변경 추적
        if (rows[index].insGrpCode && td.dbOriginal[rows[index].insGrpCode]) {
            var orig = td.dbOriginal[rows[index].insGrpCode];
            var isDiff = false;
            for (var key in orig) {
                if ((rows[index][key] || '') != (orig[key] || '')) {
                    isDiff = true;
                    break;
                }
            }
            if (isDiff) {
                td.changedRows[rows[index].insGrpCode] = true;
            } else {
                delete td.changedRows[rows[index].insGrpCode];
            }
        }
        $(_masterGridId).datagrid('refreshRow', index);
    }
}

// ============================================================================
// 조회 (QCT05A_SER)
// ============================================================================
function doSearch() {
    var td = _ts();
    if (td.masterEditIndex !== undefined) {
        $(_masterGridId).datagrid('endEdit', td.masterEditIndex);
        td.masterEditIndex = undefined;
    }
    td.currentGrpCode = '';
    $(_masterGridId).datagrid('options').url = consts.url.QCT05A_SER;
    $(_masterGridId).datagrid('load', { plants: PAGE_PLANTS });
    td.loaded = true;
}

/**
 * 디테일 조회 (QCT05A_SER2) — 내부 헬퍼 (클로저에서 호출)
 */
function _doSearchDetail(insGrpCode, $detailGrid) {
    $.ajax({
        url: consts.url.QCT05A_SER2,
        type: 'POST',
        data: { insGrpCode: insGrpCode },
        dataType: 'json',
        success: function(result) {
            var rows = result.data || result.rows || result || [];
            $detailGrid.datagrid('clearSelections');
            $detailGrid.datagrid('loadData', rows);
        }
    });
}

/**
 * 디테일 조회 — 외부 호출용 (현재 활성 탭의 디테일 그리드에 로드)
 */
function doSearchDetail(insGrpCode) {
    _doSearchDetail(insGrpCode, $(_detailGridId));
}


// ============================================================================
// 그룹 추가
// ============================================================================
function doAddGroup() {
    var td = _ts();
    if (td.masterEditIndex !== undefined) {
        $(_masterGridId).datagrid('endEdit', td.masterEditIndex);
    }

    var newRow = {
        insGrpCode: '',
        insGrpName: '',
        useFlag: 'Y',
        scomment: ''
    };
    if (PAGE_SHOW_GRP_SEQ) newRow.grpSeq = null;
    if (PAGE_SHOW_INS_GRP_MODEL) newRow.insGrpModel = '';

    $(_masterGridId).datagrid('appendRow', newRow);
    var rows = $(_masterGridId).datagrid('getRows');
    var newIndex = rows.length - 1;
    $(_masterGridId).datagrid('selectRow', newIndex);
    $(_masterGridId).datagrid('beginEdit', newIndex);
    td.masterEditIndex = newIndex;

    // 신규 행 선택 시 디테일 초기화
    td.currentGrpCode = '';
    $(_detailGridId).datagrid('loadData', []);
    if (PAGE_SHOW_IMAGE) {
        _clearGroupImage();
    }
}


// ============================================================================
// 그룹 저장 (QCT05A_INS — UPSERT)
// ============================================================================
function doSaveGroup() {
    var td = _ts();
    if (td.masterEditIndex !== undefined) {
        $(_masterGridId).datagrid('endEdit', td.masterEditIndex);
        td.masterEditIndex = undefined;
    }

    var allRows = $(_masterGridId).datagrid('getRows');
    var saveRows = [];

    for (var i = 0; i < allRows.length; i++) {
        var row = allRows[i];
        // 신규 행 (insGrpCode 비어있음) 또는 수정된 행
        if (!row.insGrpCode || td.changedRows[row.insGrpCode]) {
            if (!row.insGrpName || row.insGrpName.trim() === '') {
                $.messager.alert(getTitle('WARNING'), '검사그룹명을 입력하세요. (행 ' + (i + 1) + ')', 'warning');
                return;
            }
            saveRows.push({
                insGrpCode: row.insGrpCode || '',
                insGrpName: row.insGrpName,
                grpSeq: row.grpSeq || 0,
                insGrpModel: row.insGrpModel || '',
                useFlag: row.useFlag || 'Y',
                scomment: row.scomment || ''
            });
        }
    }

    if (saveRows.length === 0) {
        $.messager.alert(getTitle('INFO'), getMessage('NO_CHANGED'), 'info');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_SAVE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.QCT05A_INS,
                type: 'POST',
                data: {
                    models: JSON.stringify(saveRows),
                    plants: PAGE_PLANTS
                },
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success, 'info');
                        td.changedRows = {};
                        doSearch();
                    } else {
                        $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
                    }
                },
                error: function() {
                }
            });
        }
    });
}


// ============================================================================
// 검사항목 삭제 (QCT05A_DEL)
// ============================================================================
function doDelIns() {
    var td = _ts();
    if (!td.currentGrpCode) {
        $.messager.alert(getTitle('WARNING'), '검사그룹을 선택하세요.', 'warning');
        return;
    }

    // 체크박스가 체크된 행만 수집 (getSelections 대신 — selection과 체크박스는 별개 상태)
    var allRows = $(_detailGridId).datagrid('getRows');
    var $panel = $(_detailGridId).datagrid('getPanel');
    var checkedRows = [];
    $panel.find('.emp-sel-ck:checked').each(function() {
        var tr = $(this).closest('tr.datagrid-row');
        var index = parseInt(tr.attr('datagrid-row-index'));
        if (allRows[index]) checkedRows.push(allRows[index]);
    });

    if (checkedRows.length === 0) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    var delRows = [];
    for (var i = 0; i < checkedRows.length; i++) {
        delRows.push({
            insGrpCode: td.currentGrpCode,
            insCode: checkedRows[i].insCode
        });
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_DELETE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.QCT05A_DEL,
                type: 'POST',
                data: {
                    models: JSON.stringify(delRows)
                },
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success, 'info');
                        doSearchDetail(td.currentGrpCode);
                    } else {
                        $.messager.alert(getTitle('ERROR'), result.error || '삭제 실패', 'error');
                    }
                },
                error: function() {
                }
            });
        }
    });
}


// ============================================================================
// D0A 팝업: 검사항목 추가
// ============================================================================

/**
 * D0A 팝업 열기
 */
function doOpenD0a() {
    var td = _ts();
    if (!td.currentGrpCode) {
        $.messager.alert(getTitle('WARNING'), '검사그룹을 선택하세요.', 'warning');
        return;
    }

    if (td.masterEditIndex !== undefined) {
        $(_masterGridId).datagrid('endEdit', td.masterEditIndex);
        td.masterEditIndex = undefined;
    }

    $('#d0a-popup').dialog('open').dialog('center');

    if (d0aInited) {
        // 그룹명 업데이트
        var selRow = $(_masterGridId).datagrid('getSelected');
        if (selRow) {
            $('#d0a_grpName').textbox('setValue', selRow.insGrpName || '');
        }
        // 검사공정/검색어 초기화
        $('#d0a_procCode').combogrid('setValue', '');
        $('#d0a_procCode').combogrid('setText', '');
        $('#d0a_searchLike').textbox('setValue', '');
        _loadD0aData(td.currentGrpCode);
    }
}

/**
 * D0A 팝업 초기화 (onLoad 콜백 — href 첫 로드 시 1회)
 */
function initD0aPopup() {
    if (d0aInited) return;
    d0aInited = true;

    // 좌측 그리드: 선택 항목
    $('#d0a-left-grid').datagrid({
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: false,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'insCode',
        checkOnSelect: false,
        selectOnCheck: false,
        columns: [[
            {field: 'ck', checkbox: true},
            {field: 'insCode', hidden: true},
            {field: 'procCode', title: '검사공정', width: 60, halign: 'center', align: 'left'},
            {field: 'procName', title: '검사공정명', width: 100, halign: 'center', align: 'left'},
            {field: 'insName', title: '검사항목명', width: 100, halign: 'center', align: 'left'},
            {field: 'insDesc', title: '점검내역', width: 100, halign: 'center', align: 'left'},
            {field: 'insType', title: 'TYPE', width: 40, halign: 'center', align: 'center'},
            {field: 'avgVal', title: '기준값', width: 60, halign: 'center', align: 'left'},
            {field: 'insUnit', title: '단위', width: 40, halign: 'center', align: 'center'},
            {field: 'minVal', title: 'Min', width: 50, halign: 'center', align: 'right'},
            {field: 'maxVal', title: 'Max', width: 50, halign: 'center', align: 'right'},
            {field: 'insSeq', title: '순번', width: 40, halign: 'center', align: 'right',
                editor: {type: 'numberbox', options: {precision: 0, min: 1, max: 999999999}}
            },
            {field: 'insGrp', title: '연결된 그룹명', width: 100, halign: 'center', align: 'left'}
        ]],
        onClickRow: function(index, row) {
            if (d0aEditIndex !== undefined && d0aEditIndex !== index) {
                $(this).datagrid('endEdit', d0aEditIndex);
            }
            $(this).datagrid('beginEdit', index);
            d0aEditIndex = index;
            _setEditorMaxLen($(this), index, {insSeq:9}); // TSTD_INS_GRP_LIST.INS_SEQ INT
        },
        onDblClickRow: function(index, row) {
            if (d0aEditIndex !== undefined) {
                $(this).datagrid('endEdit', d0aEditIndex);
                d0aEditIndex = undefined;
            }
            d0aRemoveFromLeft([row]);
        },
        onAfterEdit: function(index, row) {
            d0aEditIndex = undefined;
        },
        onCancelEdit: function(index, row) {
            d0aEditIndex = undefined;
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault();
            $(this).datagrid('selectRow', rowIndex);
            $('#d0a-left-ctx').menu('show', {left: e.pageX, top: e.pageY});
        }
    });
    $('#d0a-left-grid').datagrid('getPanel').find('.datagrid-view').addClass('noStyle');

    // 우측 그리드: 검사 항목 List
    $('#d0a-right-grid').datagrid({
        fit: true,
        fitColumns: true,
        striped: true,
        singleSelect: false,
        pagination: false,
        rownumbers: false,
        nowrap: true,
        idField: 'insCode',
        checkOnSelect: false,
        selectOnCheck: false,
        columns: [[
            {field: 'ck', checkbox: true},
            {field: 'insCode', hidden: true},
            {field: 'insGrpCode', hidden: true},
            {field: 'procCode', title: '검사공정', width: 60, halign: 'center', align: 'left'},
            {field: 'procName', title: '검사공정명', width: 100, halign: 'center', align: 'left'},
            {field: 'insName', title: '검사항목명', width: 100, halign: 'center', align: 'left'},
            {field: 'insDesc', title: '점검내역', width: 100, halign: 'center', align: 'left'},
            {field: 'insType', title: 'TYPE', width: 40, halign: 'center', align: 'center'},
            {field: 'avgVal', title: '기준값', width: 60, halign: 'center', align: 'left'},
            {field: 'insUnit', title: '단위', width: 40, halign: 'center', align: 'center'},
            {field: 'minVal', title: 'Min', width: 50, halign: 'center', align: 'right'},
            {field: 'maxVal', title: 'Max', width: 50, halign: 'center', align: 'right'},
            {field: 'insSeq', title: '순번', width: 40, halign: 'center', align: 'right'}
        ]],
        onDblClickRow: function(index, row) {
            d0aAddToLeft([row]);
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault();
            $(this).datagrid('selectRow', rowIndex);
            $('#d0a-right-ctx').menu('show', {left: e.pageX, top: e.pageY});
        }
    });
    // 우측은 fitColumns:true이므로 noStyle 불필요 (대량 데이터 성능 개선)

    // 컨텍스트 메뉴 이벤트 (체크된 행 다건 처리)
    $('#d0a-ctx-remove').bind('click', function() {
        if (d0aEditIndex !== undefined) {
            $('#d0a-left-grid').datagrid('endEdit', d0aEditIndex);
            d0aEditIndex = undefined;
        }
        var checked = $('#d0a-left-grid').datagrid('getChecked');
        if (checked.length === 0) {
            var row = $('#d0a-left-grid').datagrid('getSelected');
            if (row) checked = [row];
        }
        if (checked.length > 0) {
            d0aRemoveFromLeft(checked);
        }
    });
    $('#d0a-ctx-add').bind('click', function() {
        var checked = $('#d0a-right-grid').datagrid('getChecked');
        if (checked.length === 0) {
            var row = $('#d0a-right-grid').datagrid('getSelected');
            if (row) checked = [row];
        }
        if (checked.length > 0) {
            d0aAddToLeft(checked);
        }
    });

    // combogrid 초기화 (URL 없이 — AS-IS처럼 화살표 클릭 시 빈 패널)
    _initD0aProcGrid();

    // 돋보기 버튼 → acProcForm 공통 팝업 열기 (AS-IS FIND 버튼)
    $('#d0a-proc-find-btn').bind('click', function() {
        acProcForm.open({
            lprocCode: PAGE_LPROC_CODE,
            onSelect: function(row) {
                var gridData = [{procCode: row.procCode, procName: row.procName}];
                $('#d0a_procCode').combogrid('grid').datagrid('loadData', gridData);
                $('#d0a_procCode').combogrid('setValue', row.procCode);
            }
        });
    });

    // 검색 버튼
    $('#d0a-search-button').bind('click', d0aSearch);

    // 검색 Enter 키
    $('#d0a_searchLike').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            d0aSearch();
        }
    });

    // 그룹명 표시
    var td = _ts();
    if (td.currentGrpCode) {
        var selRow = $(_masterGridId).datagrid('getSelected');
        if (selRow) {
            $('#d0a_grpName').textbox('setValue', selRow.insGrpName || '');
        }
    }

    // 첫 로드
    if (td.currentGrpCode) {
        _loadD0aData(td.currentGrpCode);
    }
}

/**
 * D0A 좌측 그리드(매핑 항목)만 로드 (QCT05A_SER2)
 * 우측(미매핑)은 빈 상태로 시작 — 사용자가 검색으로 조회
 */
function _loadD0aData(insGrpCode) {
    d0aEditIndex = undefined;
    // 좌측 그리드: 매핑된 항목만 조회
    $.ajax({
        url: consts.url.QCT05A_SER2,
        type: 'POST',
        data: {
            insGrpCode: insGrpCode
        },
        dataType: 'json',
        success: function(result) {
            var mapped = result.data || result.rows || result || [];
            $('#d0a-left-grid').datagrid('loadData', mapped);
        }
    });
    // 우측 그리드: 전체 항목 조회
    d0aSearch();
}

/**
 * D0A 공정 combogrid 초기화 (AS-IS acProc DOWN 버튼 대응)
 */
function _initD0aProcGrid() {
    $('#d0a_procCode').combogrid({
        width: 130,
        panelWidth: 300,
        panelHeight: 200,
        editable: false,
        idField: 'procCode',
        textField: 'procName',
        fitColumns: false,
        columns: [[
            {field: 'procCode', title: '공정코드', width: 80, halign: 'center', align: 'center'},
            {field: 'procName', title: '공정명', width: 150, halign: 'center', align: 'left'}
        ]],
        data: []
    });
}

/**
 * D0A 우측→좌측 추가 (다건, 중복 방지)
 * appendRow/deleteRow 사용 — 전체 loadData 리렌더 방지
 */
function d0aAddToLeft(rows) {
    var $left = $('#d0a-left-grid');
    var $right = $('#d0a-right-grid');
    var leftRows = $left.datagrid('getRows');
    var existMap = {};
    var maxSeq = 0;
    for (var i = 0; i < leftRows.length; i++) {
        existMap[leftRows[i].insCode] = true;
        var seq = parseInt(leftRows[i].insSeq) || 0;
        if (seq > maxSeq) maxSeq = seq;
    }

    // 우측에서 삭제할 인덱스 수집 (역순 삭제용)
    var removeIdxList = [];
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        if (existMap[row.insCode]) continue;
        maxSeq++;
        // 좌측에 단건 추가
        if (d0aEditIndex !== undefined) {
            $left.datagrid('endEdit', d0aEditIndex);
            d0aEditIndex = undefined;
        }
        $left.datagrid('appendRow', {
            insCode: row.insCode, insSeq: maxSeq,
            procCode: row.procCode, procName: row.procName,
            insName: row.insName, insDesc: row.insDesc,
            insType: row.insType, avgVal: row.avgVal,
            insUnit: row.insUnit, minVal: row.minVal,
            maxVal: row.maxVal, insGrp: row.insGrp || ''
        });
        existMap[row.insCode] = true;
        var rightIdx = $right.datagrid('getRowIndex', row);
        if (rightIdx >= 0) removeIdxList.push(rightIdx);
    }

    if (removeIdxList.length === 0) return;

    // 우측에서 역순 삭제
    removeIdxList.sort(function(a, b) { return b - a; });
    for (var i = 0; i < removeIdxList.length; i++) {
        $right.datagrid('deleteRow', removeIdxList[i]);
    }
    $right.datagrid('uncheckAll');
    d0aEditIndex = undefined;

    // 추가된 마지막 행에 포커스
    var leftAllRows = $left.datagrid('getRows');
    if (leftAllRows.length > 0) {
        var lastIdx = leftAllRows.length - 1;
        $left.datagrid('selectRow', lastIdx);
        $left.datagrid('scrollTo', lastIdx);
    }
}

/**
 * D0A 좌측→우측 제거 (다건)
 * appendRow/deleteRow 사용 — 전체 loadData 리렌더 방지
 */
function d0aRemoveFromLeft(rows) {
    var $left = $('#d0a-left-grid');
    var $right = $('#d0a-right-grid');

    if (d0aEditIndex !== undefined) {
        $left.datagrid('endEdit', d0aEditIndex);
        d0aEditIndex = undefined;
    }

    // 좌측에서 삭제할 인덱스 수집
    var removeIdxList = [];
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        // 우측에 단건 추가
        $right.datagrid('appendRow', {
            insCode: row.insCode,
            procCode: row.procCode, procName: row.procName,
            insName: row.insName, insDesc: row.insDesc,
            insType: row.insType, avgVal: row.avgVal,
            insUnit: row.insUnit, minVal: row.minVal,
            maxVal: row.maxVal, insSeq: row.insSeq
        });
        var leftIdx = $left.datagrid('getRowIndex', row);
        if (leftIdx >= 0) removeIdxList.push(leftIdx);
    }

    // 좌측에서 역순 삭제
    removeIdxList.sort(function(a, b) { return b - a; });
    for (var i = 0; i < removeIdxList.length; i++) {
        $left.datagrid('deleteRow', removeIdxList[i]);
    }
    $left.datagrid('uncheckAll');
    d0aEditIndex = undefined;

    // 추가된 마지막 행에 포커스
    var rightAllRows = $right.datagrid('getRows');
    if (rightAllRows.length > 0) {
        var lastIdx = rightAllRows.length - 1;
        $right.datagrid('selectRow', lastIdx);
        $right.datagrid('scrollTo', lastIdx);
    }
}

/**
 * D0A 우측 그리드 검색 (QCT05A_SER4)
 */
function d0aSearch() {
    var td = _ts();
    var procCode = $('#d0a_procCode').combogrid('getValue') || '';
    var searchLike = $('#d0a_searchLike').textbox('getText') || '';

    $.ajax({
        url: consts.url.QCT05A_SER4,
        type: 'POST',
        data: {
            insGrpCode: td.currentGrpCode,
            procCode: procCode,
            searchLike: searchLike,
            plants: PAGE_PLANTS,
            lprocCode: PAGE_LPROC_CODE
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.data || result.rows || result || [];
            $('#d0a-right-grid').datagrid('loadData', rows);
        }
    });
}

/**
 * D0A 저장 (QCT05A_INS2 — Delete-Insert)
 */
function d0aSave() {
    var td = _ts();
    // 좌측 그리드 편집 종료
    if (d0aEditIndex !== undefined) {
        $('#d0a-left-grid').datagrid('endEdit', d0aEditIndex);
        d0aEditIndex = undefined;
    }

    var leftRows = $('#d0a-left-grid').datagrid('getRows');
    var models = [];
    for (var i = 0; i < leftRows.length; i++) {
        models.push({
            insCode: leftRows[i].insCode,
            insSeq: leftRows[i].insSeq || (i + 1)
        });
    }

    $.ajax({
        url: consts.url.QCT05A_INS2,
        type: 'POST',
        data: {
            insGrpCode: td.currentGrpCode,
            models: JSON.stringify(models)
        },
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $('#d0a-popup').dialog('close');
                doSearchDetail(td.currentGrpCode);
                $.messager.show({
                    title: '알림',
                    msg: result.success,
                    showType: 'slide',
                    timeout: 2000,
                    style: { right: '', bottom: '' }
                });
            } else {
                $.messager.alert(getTitle('ERROR'), result.error || '저장 실패', 'error');
            }
        },
        error: function() {
        }
    });
}


// ============================================================================
// 이미지 처리 (PROC 전용)
// ============================================================================

/**
 * 검사그룹 이미지 로드
 */
function _loadGroupImage(insGrpCode) {
    if (!PAGE_SHOW_IMAGE) return;
    var imgEl = document.getElementById('group-image');
    if (!imgEl) return;

    _selectedImgBase64 = null;
    imgEl.style.display = 'none';

    $.ajax({
        url: consts.url.QCT05A_IMG,
        type: 'POST',
        data: { insGrpCode: insGrpCode },
        dataType: 'json',
        success: function(result) {
            if (result.imgData) {
                imgEl.src = 'data:image/png;base64,' + result.imgData;
                imgEl.style.display = 'block';
            }
        }
    });
}

/**
 * 이미지 초기화
 */
function _clearGroupImage() {
    var imgEl = document.getElementById('group-image');
    if (imgEl) {
        imgEl.src = '';
        imgEl.style.display = 'none';
    }
    _selectedImgBase64 = null;
}

/**
 * 이미지 선택 (파일 열기)
 */
function _imgSelect() {
    var td = _ts();
    if (!td.currentGrpCode) {
        $.messager.alert(getTitle('WARNING'), '검사그룹을 선택하세요.', 'warning');
        return;
    }
    var imgInput = document.getElementById('_qct05a_img_input');
    if (imgInput) {
        imgInput.value = '';
        imgInput.click();
    }
}

/**
 * 파일 선택 후 미리보기
 */
function _handleImageSelected(input) {
    if (!input.files || input.files.length === 0) return;
    var file = input.files[0];

    if (file.size > 2 * 1024 * 1024) {
        $.messager.alert(getTitle('WARNING'), '이미지 파일은 2MB 이하만 가능합니다.', 'warning');
        return;
    }

    var reader = new FileReader();
    reader.onload = function(e) {
        _selectedImgBase64 = e.target.result;
        reader = null;
        var imgEl = document.getElementById('group-image');
        if (imgEl) {
            imgEl.src = _selectedImgBase64;
            imgEl.style.display = 'block';
        }
    };
    reader.readAsDataURL(file);
}

/**
 * 이미지 서버 저장 (QCT05A_IMG_SAVE)
 */
function _imgSaveToServer() {
    var td = _ts();
    if (!td.currentGrpCode) {
        $.messager.alert(getTitle('WARNING'), '검사그룹을 선택하세요.', 'warning');
        return;
    }

    // 이미지가 없으면 빈 문자열 전송 → DB에서 이미지 삭제 (AS-IS 동일)
    var base64 = '';
    if (_selectedImgBase64) {
        base64 = _selectedImgBase64;
        var idx = base64.indexOf(',');
        if (idx >= 0) base64 = base64.substring(idx + 1);
    }

    var sendData = {
        insGrpCode: td.currentGrpCode,
        imgData: base64
    };
    base64 = null;

    $.ajax({
        url: consts.url.QCT05A_IMG_SAVE,
        type: 'POST',
        data: sendData,
        dataType: 'json',
        success: function(result) {
            sendData = null;
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.success, 'info');
                _selectedImgBase64 = null;
            } else {
                $.messager.alert(getTitle('ERROR'), result.error || '이미지 저장 실패', 'error');
            }
        },
        error: function() {
            sendData = null;
        }
    });
}


// ============================================================================
// 유틸리티 함수
// ============================================================================
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

function getTitle(key) {
    if (typeof tit !== 'undefined') {
        if (key === 'ALERT') return tit.TITLE0001 || '알림';
        if (key === 'INFO') return (typeof msg !== 'undefined' && msg.MSG0052) || '정보';
        if (key === 'WARNING') return (typeof msg !== 'undefined' && msg.MSG0051) || '경고';
        if (key === 'ERROR') return (typeof msg !== 'undefined' && msg.MSG0068) || '오류';
        if (key === 'CONFIRM') return (typeof msg !== 'undefined' && msg.MSG0053) || '확인';
    }
    if (key === 'ALERT') return '알림';
    if (key === 'INFO') return '정보';
    if (key === 'WARNING') return '경고';
    if (key === 'ERROR') return '오류';
    if (key === 'CONFIRM') return '확인';
    return key;
}

function getMessage(key) {
    if (typeof msg !== 'undefined') {
        if (key === 'SAVED') return msg.MSG0021 || '저장되었습니다.';
        if (key === 'DELETED') return msg.MSG0054 || '삭제되었습니다.';
        if (key === 'NO_CHANGED') return msg.MSG0022 || '변경된 데이터가 없습니다.';
        if (key === 'SELECT_DELETE') return msg.MSG0016 || '삭제할 항목을 선택하세요.';
        if (key === 'CONFIRM_SAVE') return msg.MSG0036 || '저장하시겠습니까?';
        if (key === 'CONFIRM_DELETE') return msg.MSG0030 || '삭제하시겠습니까?';
    }
    if (key === 'SAVED') return '저장되었습니다.';
    if (key === 'DELETED') return '삭제되었습니다.';
    if (key === 'NO_CHANGED') return '변경된 데이터가 없습니다.';
    if (key === 'SELECT_DELETE') return '삭제할 항목을 선택하세요.';
    if (key === 'CONFIRM_SAVE') return '저장하시겠습니까?';
    if (key === 'CONFIRM_DELETE') return '삭제하시겠습니까?';
    return key;
}
