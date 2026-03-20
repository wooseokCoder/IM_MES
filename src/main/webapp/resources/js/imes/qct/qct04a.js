/**
 * ============================================================================
 * 화면명: QCT04A - 자주검사 항목 관리
 * ============================================================================
 * 설명: 검사항목 목록 조회, 등록, 수정, 삭제
 *       조립(PLANTS=3603), 가공(PLANTS=3605) 공통 JS
 *       D1A: 검사그룹 관리 팝업
 * 작성자: 송우석
 * 작성일: 2026-02-27
 * ============================================================================
 */

// ============================================================================
// 전역 변수
// ============================================================================
var codeDataMap = {};      // 코드 데이터 캐시
var procDataList = [];     // 공정코드 콤보 데이터
var editIndex = undefined; // 현재 편집 중인 행 인덱스 (beginEdit/endEdit)
var changedRows = {};      // 수정된 행 추적 (insCode → true)
var dbOriginal = {};       // DB 조회 시점 원본 (insCode → {field:value})
var d1aInited = false;     // D1A 팝업 초기화 여부
var d1aInsCode = '';       // D1A에서 사용하는 검사항목코드
var _imgTargetIndex = -1;  // 이미지 업로드 대상 행 인덱스
var _imgStore = {};        // 이미지 base64 저장소 (insCode → base64) — row 분리로 성능 개선
var _imgCacheOrder = [];   // LRU 순서 배열 (최근 접근이 뒤)
var _imgMenu = null;       // 이미지 컨텍스트 메뉴 (공통 모듈 인스턴스)
var _IMG_CACHE_MAX = 40;   // 최대 캐시 건수 (pageSize 50 기준 — 현재 페이지 + 여유)
var _allRows = [];         // 전체 데이터 (클라이언트 사이드 페이징)
var _currentPage = 1;      // 현재 페이지 번호
var _freshLoad = false;    // doSearch 직후 플래그 — _syncCurrentPage 건너뛰기
var _sortPrev = { field: null, order: null };  // 현재 정렬 상태 (asc→desc→reset 3클릭 사이클)

// 탭별 독립 상태 저장소
var _tabState = {
    '3603': null,  // 조립
    '3605': null   // 가공
};
var _gridId = '#grid-assy';  // 현재 활성 그리드 셀렉터

// ============================================================================
// consts (STD45A 패턴)
// ============================================================================
var consts = {
    url: {
        QCT04A_SER:  getUrl('/imes/qct/qct04a/QCT04A_SER.json'),
        QCT04A_INS:  getUrl('/imes/qct/qct04a/QCT04A_INS.json'),
        QCT04A_DEL:  getUrl('/imes/qct/qct04a/QCT04A_DEL.json'),
        QCT04A_SER2: getUrl('/imes/qct/qct04a/QCT04A_SER2.json'),
        QCT04A_SER3: getUrl('/imes/qct/qct04a/QCT04A_SER3.json'),
        QCT04A_INS2: getUrl('/imes/qct/qct04a/QCT04A_INS2.json'),
        QCT04A_PROC: getUrl('/imes/qct/qct04a/QCT04A_PROC.json'),
        QCT04A_IMG:       getUrl('/imes/qct/qct04a/QCT04A_IMG.json'),
        CODE_LIST:   getUrl('/common/code/code.json')
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

    // 공정코드 콤보 데이터 로드
    loadProcData: function() {
        var items = [];
        $.ajax({
            url: this.url.QCT04A_PROC,
            type: 'POST',
            data: { lprocCode: PAGE_LPROC_CODE },
            dataType: 'json',
            async: false,
            success: function(response) {
                items = response.rows || response || [];
            }
        });
        return items;
    },

    // 전체 초기화
    init: function() {
        // --- 조회 진행상태 다이얼로그 초기화 ---
        $('#progress-popup').dialog({
            title: (typeof tit !== 'undefined' && tit.TITLE0003) ? tit.TITLE0003 : '',
            top: 100,
            width: 200,
            height: 200,
            closed: true,
            modal: true,
            resizable: false
        });

        // --- 코드 데이터 로드 (동기) ---
        consts.codeData = {};
        consts.codeData.C053 = this.loadCode('C053'); // INS_TYPE
        consts.codeData.C054 = this.loadCode('C054'); // INS_UNIT

        // --- 양쪽 탭 그리드 초기화 ---
        // ASSY 그리드 (insImg 컬럼 포함)
        PAGE_LPROC_CODE = 'ASSY';
        var assyProcData = this.loadProcData();
        procDataList = assyProcData;
        _initSearchGrid('#grid-assy', buildGridColumns(true), true);

        // MACH 그리드 (insImg 컬럼 없음)
        PAGE_LPROC_CODE = 'PROC';
        var machProcData = this.loadProcData();
        _initSearchGrid('#grid-mach', buildGridColumns(false), false);

        // 기본값 복원 (ASSY)
        PAGE_LPROC_CODE = 'ASSY';
        procDataList = assyProcData;

        // 탭별 procDataList 캐시
        _tabState['3603'] = null;
        _tabState['3605'] = null;
        consts._procDataCache = { '3603': assyProcData, '3605': machProcData };

        // --- 버튼 이벤트 바인딩 ---
        $('#search-button').bind('click', doSearch);
        $('#add-button').bind('click', doAddRow);
        $('#save-button').bind('click', doSaveGrid);
        $('#delete-button').bind('click', doDelete);
        $('#grp-button').bind('click', doOpenD1a);

        // 그리드 컨텍스트 메뉴
        $('#ctx-delete').bind('click', doDelete);

        // 이미지 컨텍스트 메뉴 (공통 모듈 초기화)
        _imgMenu = new ImgContextMenu({
            menuId: 'img-context-menu',
            mode: 'edit',
            maxFileSize: 2 * 1024 * 1024,
            getImageBase64: function(cb) { _getRowImgBase64(_imgTargetIndex, cb); },
            setImageData: function(b64) { _setImgData(_imgTargetIndex, b64); },
            getFileName: function() {
                var row = $(_gridId).datagrid('getRows')[_imgTargetIndex];
                return (row && row.insCode ? row.insCode : 'image') + '.png';
            }
        });

        // D1A 팝업 버튼
        $('#d1a-save-button').bind('click', d1aSave);
        $('#d1a-close-button').bind('click', function() {
            $('#d1a-popup').dialog('close');
        });
    }
};

/**
 * 검색 그리드 초기화 헬퍼 (ASSY/MACH 공통)
 * @param gridId   '#grid-assy' 또는 '#grid-mach'
 * @param columns  컬럼 배열
 * @param showInsImg 이미지 컬럼 표시 여부
 */
function _initSearchGrid(gridId, columns, showInsImg) {
    var $g = $(gridId);
    $g.datagrid({
        method: 'post',
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: true,
        pageSize: 50,
        pageList: [50, 100, 300],
        rownumbers: false,
        nowrap: true,
        remoteSort: false,
        idField: 'insCode',
        columns: [columns],
        rowStyler: function(index, row) {
            if ((row.insCode && changedRows[row.insCode]) || row.sel === '1') {
                return 'background-color:#90EE90';
            }
        },
        onLoadSuccess: function(data) {
            editIndex = undefined;
            $g.datagrid('unselectAll');
            $g.datagrid('columnMoving');
            if (showInsImg) {
                _startThrottledImageLoad();
            }
        },
        onClickRow: function(index) {
            if (editIndex !== index) {
                if (editIndex !== undefined) {
                    $g.datagrid('endEdit', editIndex);
                }
                editIndex = index;
                $g.datagrid('beginEdit', index);
                _bindProcCodeSelect(index);
                // DB 컬럼 길이에 맞춘 입력 자릿수 제한 (TSTD_PROC_INS)
                // insName:VARCHAR(50), insDesc:VARCHAR(200), avgVal:VARCHAR(50), insSeq:INT
                _setEditorMaxLen($g, index, {insName:50, insDesc:200, avgVal:50, insSeq:9});
            }
        },
        onAfterEdit: function(index, row, changes) {
            editIndex = undefined;

            // procCode 변경 시 procName 연동
            if (changes.procCode !== undefined) {
                row.procName = '';
                for (var i = 0; i < procDataList.length; i++) {
                    if (procDataList[i].procCode === row.procCode) {
                        row.procName = procDataList[i].procName || '';
                        break;
                    }
                }
            }

            // 변경 추적 (dbOriginal 대비)
            if (row.insCode) {
                var orig = dbOriginal[row.insCode];
                if (orig) {
                    var isDiff = false;
                    for (var key in orig) {
                        if (String(row[key] || '') !== String(orig[key] || '')) {
                            isDiff = true;
                            break;
                        }
                    }
                    if (row._imgChanged) isDiff = true;
                    if (isDiff) {
                        changedRows[row.insCode] = true;
                    } else {
                        delete changedRows[row.insCode];
                    }
                }
            }

            // 배경색 갱신
            $g.datagrid('refreshRow', index);
        },
        onCancelEdit: function(index, row) {
            editIndex = undefined;
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault();
            $(this).datagrid('selectRow', rowIndex);

            // 이미지 셀 우클릭 판별
            var $td = $(e.target).closest('td[field=insImg]');
            if (showInsImg && $td.length > 0 && _imgMenu) {
                _imgTargetIndex = rowIndex;
                var hasImg = !!((rowData.insCode && _imgStore[rowData.insCode]) || rowData._imgBase64 || rowData.hasImg == 1 || rowData.hasImg == '1');
                _imgMenu.show(e, hasImg);
            } else {
                _showMenuAbove('grid-context-menu', e);
            }
        }
    });
    $g.datagrid('getPanel').find('.datagrid-view').addClass('noStyle');

    // 전체 컬럼 정렬 활성화 (sortable:false 명시 컬럼은 제외)
    var fields = $g.datagrid('getColumnFields');
    for (var i = 0; i < fields.length; i++) {
        var col = $g.datagrid('getColumnOption', fields[i]);
        if (col && col.sortable !== false) col.sortable = true;
    }
}


// ============================================================================
// 그리드 컬럼 정의 (ASSY/PROC 분기)
// ============================================================================
/**
 * 컨텍스트 메뉴를 마우스 위쪽에 표시 (하단 잘림 방지)
 */
var _menuHeightCache = {};
function _showMenuAbove(menuId, e) {
    var $menu = $('#' + menuId);
    var menuH = _menuHeightCache[menuId];
    if (!menuH) {
        $menu.menu('show', {left: -9999, top: -9999});
        menuH = $menu.outerHeight();
        _menuHeightCache[menuId] = menuH;
        $menu.menu('hide');
    }
    var top = e.pageY - menuH;
    if (top < 0) top = e.pageY;
    $menu.menu('show', {left: e.pageX, top: top});
}

function buildGridColumns(showInsImg) {
    var cols = [
        {field: '_rowNum', title: 'No', width: 35, halign: 'center', align: 'center',
            formatter: function(value, row, index) {
                var opts = $(_gridId).datagrid('options');
                var pageSize = opts.pageSize || 50;
                return (_currentPage - 1) * pageSize + index + 1;
            }
        },
        {field: 'sel', title: '선택', width: 40, halign: 'center', align: 'center',
            formatter: function(value) {
                var checked = (value === '1') ? ' checked' : '';
                return '<input type="checkbox"' + checked + ' onclick="toggleSel(this)" />';
            }
        },
        {field: 'insCode', hidden: true},
        {field: 'procCode', title: '검사공정', width: 75, halign: 'center', align: 'center',
            formatter: function(value) { return formatProcCode(value); },
            editor: {type:'combobox', options:{
                valueField:'procCode', textField:'procCode',
                data: procDataList,
                editable:false, panelHeight:'auto', panelMaxHeight:200
            }}
        },
        {field: 'procName', title: '검사공정명', width: 75, halign: 'center', align: 'center'},
        {field: 'insName', title: '검사항목명', width: 100, halign: 'center', align: 'left',
            editor: {type:'textbox', options:{validType:'length[0,50]'}}
        },
        {field: 'insDesc', title: '점검내역', width: 150, halign: 'center', align: 'left',
            editor: {type:'textbox', options:{validType:'length[0,200]'}}
        },
        {field: 'insType', title: 'TYPE', width: 60, halign: 'center', align: 'center',
            formatter: function(value) { return formatCode('C053', value); },
            editor: {type:'combobox', options:{
                valueField:'codeCd', textField:'codeName',
                data: consts.codeData.C053,
                editable:false, panelHeight:'auto', panelMaxHeight:200
            }}
        },
        {field: 'avgVal', title: '기준값', width: 70, halign: 'center', align: 'left',
            editor: {type:'textbox', options:{validType:'length[0,50]'}}
        },
        {field: 'insUnit', title: '단위', width: 60, halign: 'center', align: 'center',
            formatter: function(value) { return formatCode('C054', value); },
            editor: {type:'combobox', options:{
                valueField:'codeCd', textField:'codeName',
                data: consts.codeData.C054,
                editable:false, panelHeight:'auto', panelMaxHeight:200
            }}
        },
        {field: 'minVal', title: 'Min', width: 60, halign: 'center', align: 'right',
            editor: {type:'numberbox', options:{precision:2, max:999999.99}}
        },
        {field: 'maxVal', title: 'Max', width: 60, halign: 'center', align: 'right',
            editor: {type:'numberbox', options:{precision:2, max:999999.99}}
        },
        {field: 'insSeq', title: '순번', width: 50, halign: 'center', align: 'right',
            editor: {type:'numberbox', options:{precision:0, min:0, max:999999999}}
        },
        {field: 'insGrp', title: '연결된 그룹명', width: 120, halign: 'center', align: 'left'}
    ];
    // ASSY 탭: 검사이미지 컬럼 추가
    if (showInsImg) {
        cols.push({
            field: 'insImg', title: '검사이미지', width: 80, halign: 'center', align: 'center', sortable : false,
            formatter: function(value, row, index) {
                // 사용자가 편집한 이미지 → base64 (아직 서버에 미저장)
                if (row._imgChanged) {
                    var imgData = row.insCode ? _imgStore[row.insCode] : row._imgBase64;
                    if (imgData) {
                        return '<img class="ins-img-cell" '
                             + 'loading="lazy" '
                             + 'style="content-visibility:auto; contain-intrinsic-size:50px;" '
                             + 'oncontextmenu="return false" '
                             + 'src="data:image/png;base64,' + imgData + '" />';
                    }
                    return '';
                }
                // _imgStore 캐시 히트 → 서버 재요청 방지 (페이지 이동 후 복귀 시)
                if (row.insCode && _imgStore[row.insCode]) {
                    return '<img class="ins-img-cell" '
                         + 'loading="lazy" '
                         + 'style="content-visibility:auto; contain-intrinsic-size:50px;" '
                         + 'oncontextmenu="return false" '
                         + 'src="data:image/png;base64,' + _imgStore[row.insCode] + '" />';
                }
                // DB에 이미지 있음 → data-src에 URL 저장 (src는 비워둠)
                // JS 배치 로딩으로 5개씩 순차 요청 → 서버 heap space 방지
                if ((row.hasImg == 1 || row.hasImg == '1') && row.insCode) {
                    return '<img class="ins-img-cell img-loading" '
                         + 'loading="lazy" '
                         + 'style="content-visibility:auto; contain-intrinsic-size:50px;" '
                         + 'oncontextmenu="return false" '
                         + 'data-src="' + consts.url.QCT04A_IMG + '?insCode=' + encodeURIComponent(row.insCode) + '" />';
                }
                return '';
            }
        });
    }

    return cols;
}


// ============================================================================
// 에디터 콤보박스 바인딩 (beginEdit 후 호출)
// ============================================================================

/**
 * 콤보박스 패널 위치 자동 조정 (아래/위 공간 비교하여 넓은 쪽으로 열림)
 * 기준: 그리드 패널 영역 (fit:true 레이아웃에서 안정적)
 * combobox() 재호출 금지 — opts 직접 수정으로 값 초기화 방지
 */
function _comboShowAbove(ed) {
    var opts = $(ed.target).combobox('options');
    opts.onShowPanel = function() {
        var $panel = $(this).combobox('panel');
        var $combo = $(this).next('.combo');
        if ($combo.length === 0) return;
        var offset = $combo.offset();
        var comboH = $combo.outerHeight();
        var $gp = $(_gridId).datagrid('getPanel');
        var gridTop = $gp.offset().top;
        var gridBottom = gridTop + $gp.outerHeight();
        var spaceBelow = gridBottom - (offset.top + comboH);
        var spaceAbove = offset.top - gridTop;
        var maxH = Math.max(spaceBelow, spaceAbove) - 5;
        if (maxH < 50) maxH = 50;
        $panel.panel('resize', {height: 'auto'});
        var panelH = $panel.outerHeight();
        if (panelH > maxH) {
            $panel.panel('resize', {height: maxH});
            panelH = maxH;
        }
        if (spaceBelow < panelH && spaceAbove > spaceBelow) {
            $panel.panel('move', {
                left: offset.left,
                top: offset.top - panelH
            });
        }
    };
}

/**
 * 인라인 에디터 maxlength 일괄 설정 (DB 컬럼 길이 기준, 입력 시점 자릿수 차단)
 * - textbox 에디터: 문자열 컬럼 → maxlength = DB VARCHAR 길이
 * - numberbox 에디터: 정수 컬럼 → maxlength = 9 (INT 최대 9자리)
 * @param $g       datagrid jQuery 객체
 * @param index    행 인덱스
 * @param fieldMap {field: maxlength} 객체 (예: {insName:50, insSeq:9})
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

/**
 * beginEdit 후 공정코드 콤보박스 onSelect 바인딩 + 콤보 위치 보정
 * combobox() 재호출 금지 — opts 직접 수정으로 값 초기화 방지
 */
function _bindProcCodeSelect(index) {
    var ed = $(_gridId).datagrid('getEditor', {index: index, field: 'procCode'});
    if (ed) {
        var opts = $(ed.target).combobox('options');
        opts.onSelect = function(record) {
            var row = $(_gridId).datagrid('getRows')[index];
            if (row) {
                row.procName = record.procName || '';
            }
        };
        _comboShowAbove(ed);
    }
    var edType = $(_gridId).datagrid('getEditor', {index: index, field: 'insType'});
    if (edType) _comboShowAbove(edType);
    var edUnit = $(_gridId).datagrid('getEditor', {index: index, field: 'insUnit'});
    if (edUnit) _comboShowAbove(edUnit);
}


// ============================================================================
// 클라이언트 사이드 페이징
// ============================================================================

/**
 * 현재 페이지의 행 데이터를 _allRows에 동기화
 * (appendRow 등으로 추가된 행 반영)
 */
function _syncCurrentPage() {
    var rows = $(_gridId).datagrid('getRows');
    if (!rows || rows.length === 0) return;

    var opts = $(_gridId).datagrid('options');
    var pageSize = opts.pageSize || 500;
    var start = (_currentPage - 1) * pageSize;

    for (var i = 0; i < rows.length; i++) {
        var globalIdx = start + i;
        if (globalIdx < _allRows.length) {
            _allRows[globalIdx] = rows[i];
        } else {
            _allRows.push(rows[i]);
        }
    }
}

/**
 * 지정 페이지 렌더링
 * _allRows에서 해당 페이지 범위를 잘라서 loadData 호출
 */
function _renderPage(pageNum) {
    // 현재 편집 종료
    if (editIndex !== undefined) {
        try { $(_gridId).datagrid('endEdit', editIndex); } catch(e) {}
        editIndex = undefined;
    }

    // 이전 페이지 데이터 동기화 (doSearch 직후에는 건너뜀 — stale 데이터 오염 방지)
    if (_freshLoad) {
        _freshLoad = false;
    } else {
        _syncCurrentPage();
    }

    // 진행 중 이미지 로딩/변환 중단
    _imgLoadQueue = [];
    _convertQueue = [];
    _convertRunning = false;

    _currentPage = pageNum;
    var opts = $(_gridId).datagrid('options');
    var pageSize = opts.pageSize || 500;
    var start = (pageNum - 1) * pageSize;
    var end = Math.min(start + pageSize, _allRows.length);
    var pageRows = _allRows.slice(start, end);

    // 정렬 상태가 있으면 해당 페이지 데이터만 정렬 (_allRows 원본 순서 유지)
    if (_sortPrev.field) {
        var sf = _sortPrev.field;
        var so = _sortPrev.order;
        var $g = $(_gridId);
        var col = $g.datagrid('getColumnOption', sf);
        var sorter = (col && col.sorter) || function(a, b) {
            return a == b ? 0 : (a > b ? 1 : -1);
        };
        pageRows.sort(function(r1, r2) {
            return sorter(r1[sf], r2[sf]) * (so === 'asc' ? 1 : -1);
        });
    }

    // loadData 전 sortName 제거 — remoteSort:false일 때 EasyUI 자동 재정렬 방지
    opts.sortName = null;
    opts.sortOrder = 'asc';

    $(_gridId).datagrid('loadData', {
        total: _allRows.length,
        rows: pageRows
    });

    // 페이저 이벤트 바인딩
    var $pager = $(_gridId).datagrid('getPager');
    $pager.pagination({
        total: _allRows.length,
        pageNumber: pageNum,
        pageSize: pageSize,
        onSelectPage: function(p, s) {
            opts.pageSize = s;
            _renderPage(p);
        },
        onChangePageSize: function(s) {
            opts.pageSize = s;
            _renderPage(1);
        }
    });

    // loadData가 opts.sortName을 초기화할 수 있으므로, _sortPrev 기준으로 항상 복원
    if (_sortPrev.field) {
        opts.sortName = _sortPrev.field;
        opts.sortOrder = _sortPrev.order;
        _setSortArrow($(_gridId), _sortPrev.field, _sortPrev.order);
    } else {
        opts.sortName = null;
        opts.sortOrder = 'asc';
        _setSortArrow($(_gridId), null);
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

/**
 * 정렬 화살표 수동 설정 (enableGridSortReset 대체용)
 */
function _setSortArrow($g, sort, order) {
    var panel = $g.datagrid('getPanel');
    panel.find('div.datagrid-cell')
        .removeClass('datagrid-sort-asc datagrid-sort-desc');
    if (sort) {
        var col = $g.datagrid('getColumnOption', sort);
        if (col && col.cellClass) {
            panel.find('div.' + col.cellClass)
                .addClass('datagrid-sort-' + order);
        }
    }
}

/**
 * 커스텀 페이징 그리드용 정렬 패치
 * enableGridSortReset 호출 후 onBeforeSortColumn을 교체하여
 * 정렬 상태만 저장 → _renderPage에서 페이지 단위 정렬 수행
 * (_allRows 원본 순서는 유지, 각 페이지 슬라이싱 후 해당 페이지만 정렬)
 */
function _patchGridSort(gridId) {
    var $g = $(gridId);
    var opts = $g.datagrid('options');

    opts.onBeforeSortColumn = function(sort, order) {
        // asc → desc → reset (화살표 제거) → asc ... 3단계 사이클
        if (sort === _sortPrev.field && _sortPrev.order === 'desc') {
            // 3번째 클릭: 정렬 해제 + 화살표 제거
            _sortPrev = { field: null, order: null };
            _freshLoad = true;
            _renderPage(_currentPage);
            return false;
        }

        _sortPrev = { field: sort, order: order };
        _freshLoad = true;
        _renderPage(_currentPage);
        return false;
    };
}

$(window).load(function() {
    GridHeaderMenu('#grid-assy', { exportFileName: '자주검사항목관리_조립' });
    GridHeaderMenu('#grid-mach', { exportFileName: '자주검사항목관리_가공' });
    enableGridSortReset('#grid-assy');
    enableGridSortReset('#grid-mach');
    // 커스텀 페이징(_allRows+_renderPage)과 호환되도록 onBeforeSortColumn 교체
    _patchGridSort('#grid-assy');
    _patchGridSort('#grid-mach');

});

/**
 * 현재 탭 상태 저장
 */
function _saveTabState() {
    if (editIndex !== undefined) {
        try { $(_gridId).datagrid('endEdit', editIndex); } catch(e) {}
        editIndex = undefined;
    }
    _syncCurrentPage();
    _tabState[PAGE_PLANTS] = {
        allRows: _allRows,
        currentPage: _currentPage,
        changedRows: $.extend({}, changedRows),
        dbOriginal: $.extend(true, {}, dbOriginal),
        sortPrev: { field: _sortPrev.field, order: _sortPrev.order }
    };
}

/**
 * 탭 상태 복원
 */
function _restoreTabState(plants) {
    var st = _tabState[plants];
    if (st) {
        _allRows = st.allRows;
        _currentPage = st.currentPage;
        changedRows = st.changedRows;
        dbOriginal = st.dbOriginal;
        _sortPrev = st.sortPrev || { field: null, order: null };
    } else {
        _allRows = [];
        _currentPage = 1;
        changedRows = {};
        dbOriginal = {};
        _sortPrev = { field: null, order: null };
    }
    // procDataList는 캐시에서 복원 (탭별 고정)
    if (consts._procDataCache && consts._procDataCache[plants]) {
        procDataList = consts._procDataCache[plants];
    }
    _imgCacheReset();  // 이미지 캐시 초기화 — 탭 전환 시 서버 재조회
    if (_imgMenu) _imgMenu.clearClipboard();
    editIndex = undefined;
}

/**
 * 탭 전환 (조립/가공) — show/hide 방식
 * 각 탭별 독립 그리드로 데이터가 DOM에 보존됨
 */
function switchTab(plants) {
    if (PAGE_PLANTS === plants) return;

    // 현재 편집 종료
    if (editIndex !== undefined) {
        try { $(_gridId).datagrid('endEdit', editIndex); } catch(e) {}
        editIndex = undefined;
    }

    // 현재 탭 상태 저장
    _saveTabState();

    // 변수 전환
    if (plants === '3603') {
        PAGE_PLANTS = '3603';
        PAGE_PLANTS_NAME = '조립';
        PAGE_LPROC_CODE = 'ASSY';
        PAGE_SHOW_INS_IMG = true;
    } else {
        PAGE_PLANTS = '3605';
        PAGE_PLANTS_NAME = '가공';
        PAGE_LPROC_CODE = 'PROC';
        PAGE_SHOW_INS_IMG = false;
    }

    // 탭 활성 표시
    $('.plants-tab-item').removeClass('active');
    $(plants === '3603' ? '#tab-assy' : '#tab-mach').addClass('active');

    // 그리드 전환 (show/hide)
    _gridId = (plants === '3603') ? '#grid-assy' : '#grid-mach';
    if (plants === '3603') {
        $('#tab-panel-mach').hide();
        $('#tab-panel-assy').show();
    } else {
        $('#tab-panel-assy').hide();
        $('#tab-panel-mach').show();
    }

    // 대상 탭 상태 복원
    _restoreTabState(plants);

    // display:none → show 후 그리드 리사이즈
    $(_gridId).datagrid('resize');

    // 정렬 화살표 복원 (_renderPage를 거치지 않는 탭 전환 시)
    if (_sortPrev.field) {
        var sopts = $(_gridId).datagrid('options');
        sopts.sortName = _sortPrev.field;
        sopts.sortOrder = _sortPrev.order;
        _setSortArrow($(_gridId), _sortPrev.field, _sortPrev.order);
    }

    // 탭 상태 초기화 (처음 방문)
    if (!_tabState[plants]) {
        _tabState[plants] = true;
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

/**
 * 공정코드 → 공정명 포맷터
 */
function formatProcCode(value) {
    if (!value) return '';
    for (var i = 0; i < procDataList.length; i++) {
        if (procDataList[i].procCode === value) {
            return value;
        }
    }
    return value;
}

/**
 * SEL 체크박스 토글
 */
function toggleSel(cb) {
    var tr = $(cb).closest('tr.datagrid-row');
    var index = parseInt(tr.attr('datagrid-row-index'));
    var row = $(_gridId).datagrid('getRows')[index];
    if (row) {
        row.sel = cb.checked ? '1' : '0';
    }
    if (cb.checked) {
        tr.css('background-color', '#90EE90');
    } else {
        if (row && row.insCode && changedRows[row.insCode]) {
            tr.css('background-color', '#90EE90');
        } else {
            tr.css('background-color', '');
        }
    }
}


// ============================================================================
// 조회 (QCT04A_SER — 수동 AJAX + 클라이언트 페이징)
// ============================================================================
function doSearch() {
    if (editIndex !== undefined) {
        try { $(_gridId).datagrid('endEdit', editIndex); } catch(e) {}
        editIndex = undefined;
    }

    _imgLoadQueue = [];
    _convertQueue = [];
    _convertRunning = false;

    // 수동 AJAX → _allRows → _renderPage (조립/가공 공통)
    $.ajax({
        url: consts.url.QCT04A_SER,
        type: 'POST',
        data: { plants: PAGE_PLANTS },
        dataType: 'json',
        success: function(response) {
            _freshLoad = true;
            _allRows = response.rows || response || [];
            changedRows = {};
            dbOriginal = {};
            _imgCacheReset();
            if (_imgMenu) _imgMenu.clearClipboard();

            // 정렬 상태 초기화
            _sortPrev = { field: null, order: null };

            // 전체 행에 대해 원본 스냅샷 생성
            for (var i = 0; i < _allRows.length; i++) {
                var r = _allRows[i];
                if (r.insCode) {
                    dbOriginal[r.insCode] = {
                        procCode: r.procCode || '',
                        insName: r.insName || '',
                        insDesc: r.insDesc || '',
                        insType: r.insType || '',
                        insUnit: r.insUnit || '',
                        avgVal: r.avgVal || '',
                        minVal: r.minVal || '',
                        maxVal: r.maxVal || '',
                        insSeq: r.insSeq || ''
                    };
                }
            }

            _renderPage(1);
        },
        error: function() {
        }
    });
}


// ============================================================================
// 행 추가
// ============================================================================
function doAddRow() {
    if (editIndex !== undefined) {
        $(_gridId).datagrid('endEdit', editIndex);
        editIndex = undefined;
    }

    var newRow = {
        sel: '0', insCode: '', procCode: '', procName: '',
        insName: '', insDesc: '', insType: '', avgVal: '',
        insUnit: '', minVal: null, maxVal: null, insSeq: null,
        insGrp: '', hasImg: 0
    };

    // 현재 페이지 하단에 행 추가
    _syncCurrentPage();
    var opts = $(_gridId).datagrid('options');
    var pageSize = opts.pageSize || 50;
    var start = (_currentPage - 1) * pageSize;
    var curRows = $(_gridId).datagrid('getRows');
    var insertIdx = start + curRows.length;
    if (insertIdx > _allRows.length) insertIdx = _allRows.length;
    _allRows.splice(insertIdx, 0, newRow);
    $(_gridId).datagrid('appendRow', newRow);
    var $pager = $(_gridId).datagrid('getPager');
    $pager.pagination({total: _allRows.length});

    // 새 행 선택 + 편집 시작
    var rows = $(_gridId).datagrid('getRows');
    var newIndex = rows.length - 1;
    editIndex = newIndex;
    $(_gridId).datagrid('selectRow', newIndex);
    $(_gridId).datagrid('beginEdit', newIndex);
    _bindProcCodeSelect(newIndex);
}


// ============================================================================
// 저장 (QCT04A_INS — UPSERT, models 패턴)
// ============================================================================
function doSaveGrid() {
    if (editIndex !== undefined) {
        $(_gridId).datagrid('endEdit', editIndex);
        editIndex = undefined;
    }

    // 전체 행 가져오기
    _syncCurrentPage();
    var allRows = _allRows;

    var saveRows = [];

    for (var i = 0; i < allRows.length; i++) {
        var row = allRows[i];
        // 신규 행 (insCode 비어있음) 또는 수정된 행
        if (!row.insCode || changedRows[row.insCode]) {
            // 필수값 검증
            if (!row.procCode) {
                $.messager.alert(getTitle('WARNING'), '검사공정을 선택하세요. (행 ' + (i + 1) + ')', 'warning');
                return;
            }
            if (!row.insName || row.insName.trim() === '') {
                $.messager.alert(getTitle('WARNING'), '검사항목명을 입력하세요. (행 ' + (i + 1) + ')', 'warning');
                return;
            }
            if (!row.insType) {
                $.messager.alert(getTitle('WARNING'), 'TYPE을 선택하세요. (행 ' + (i + 1) + ')', 'warning');
                return;
            }

            // procName 연동
            var procName = '';
            for (var j = 0; j < procDataList.length; j++) {
                if (procDataList[j].procCode === row.procCode) {
                    procName = procDataList[j].procName || '';
                    break;
                }
            }

            // insImg 처리
            var imgVal;
            if (row._imgChanged) {
                var imgData = row.insCode ? _imgStore[row.insCode] : row._imgBase64;
                imgVal = imgData || '';
            } else {
                imgVal = '__KEEP__';
            }

            saveRows.push({
                insCode: row.insCode || '',
                procCode: row.procCode,
                procName: procName,
                insName: row.insName,
                insDesc: row.insDesc || '',
                insType: row.insType,
                avgVal: row.avgVal || '',
                insUnit: row.insUnit || '',
                minVal: row.minVal || '',
                maxVal: row.maxVal || '',
                insSeq: row.insSeq || 0,
                insImg: imgVal
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
                url: consts.url.QCT04A_INS,
                type: 'POST',
                data: {
                    models: JSON.stringify(saveRows),
                    plants: PAGE_PLANTS
                },
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        changedRows = {};
                        $.messager.alert(getTitle('INFO'), result.success, 'info', function() {
                            doSearch();
                        });
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
// 삭제 (QCT04A_DEL)
// ============================================================================
function doDelete() {
    if (editIndex !== undefined) {
        try { $(_gridId).datagrid('endEdit', editIndex); } catch(e) {}
        editIndex = undefined;
    }

    // 전체 행 가져오기
    _syncCurrentPage();
    var allRows = _allRows;

    var delRows = [];

    // SEL='1'인 행 수집
    for (var i = 0; i < allRows.length; i++) {
        if (allRows[i].sel === '1' && allRows[i].insCode) {
            delRows.push({insCode: allRows[i].insCode});
        }
    }

    // 체크된 행 없으면 현재 페이지에서 선택된 행
    if (delRows.length === 0) {
        var row = $(_gridId).datagrid('getSelected');
        if (row && row.insCode) {
            delRows.push({insCode: row.insCode});
        }
    }

    // 신규 행(insCode 없음)만 선택된 경우 → 제거
    if (delRows.length === 0) {
        var selRow = $(_gridId).datagrid('getSelected');
        if (selRow && !selRow.insCode) {
            var idx = $(_gridId).datagrid('getRowIndex', selRow);
            if (idx >= 0) {
                var opts = $(_gridId).datagrid('options');
                var pageSize = opts.pageSize || 50;
                var globalIdx = (_currentPage - 1) * pageSize + idx;
                if (globalIdx >= 0 && globalIdx < _allRows.length) {
                    _allRows.splice(globalIdx, 1);
                }
                var maxPage = Math.ceil(_allRows.length / pageSize);
                if (maxPage < 1) maxPage = 1;
                if (_currentPage > maxPage) _currentPage = maxPage;
                _renderPage(_currentPage);
            }
            return;
        }
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_DELETE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.QCT04A_DEL,
                type: 'POST',
                data: {
                    models: JSON.stringify(delRows)
                },
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        $.messager.alert(getTitle('INFO'), result.success, 'info', function() {
                            doSearch();
                        });
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
// D1A 팝업: 검사그룹 관리
// ============================================================================

/**
 * D1A 팝업 열기
 */
function doOpenD1a() {
    if (editIndex !== undefined) {
        $(_gridId).datagrid('endEdit', editIndex);
        editIndex = undefined;
    }

    var row = $(_gridId).datagrid('getSelected');
    if (!row || !row.insCode) {
        $.messager.alert(getTitle('WARNING'), '저장된 검사항목을 선택하세요.', 'warning');
        return;
    }

    d1aInsCode = row.insCode;

    $('#d1a-popup').dialog('open').dialog('center');

    if (d1aInited) {
        _loadD1aInfo(row);
        _loadD1aData(row.insCode);
    }
}

/**
 * D1A 팝업 초기화 (onLoad 콜백 — href 첫 로드 시 1회)
 */
function initD1aPopup() {
    if (d1aInited) return;
    d1aInited = true;

    // 좌측 그리드: 연결 그룹 (noStyle — 컬럼 고정폭)
    $('#d1a-left-grid').datagrid({
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: false,
        checkOnSelect: true,
        selectOnCheck: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'insGrpCode',
        columns: [[
            {field: 'sel', checkbox: true},
            {field: 'insGrpCode', hidden: true},
            {field: 'insGrpName', title: '검사그룹명', width: 200, halign: 'center', align: 'left'}
        ]],
        onDblClickRow: function(index, row) {
            d1aRemoveFromLeft([row]);
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault();
            $(this).datagrid('selectRow', rowIndex);
            $('#d1a-left-ctx').menu('show', {left: e.pageX, top: e.pageY});
        }
    });

    // 우측 그리드: 그룹 LIST (noStyle — 컬럼 고정폭)
    $('#d1a-right-grid').datagrid({
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: false,
        checkOnSelect: true,
        selectOnCheck: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'insGrpCode',
        columns: [[
            {field: 'sel', checkbox: true},
            {field: 'insGrpCode', hidden: true},
            {field: 'insGrpName', title: '검사그룹명', width: 200, halign: 'center', align: 'left'}
        ]],
        onDblClickRow: function(index, row) {
            d1aAddToLeft([row]);
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault();
            $(this).datagrid('selectRow', rowIndex);
            $('#d1a-right-ctx').menu('show', {left: e.pageX, top: e.pageY});
        }
    });

    // noStyle 적용 — 컬럼 고정폭, 전체 너비 채우기 방지
    $('#d1a-left-grid').datagrid('getPanel').find('.datagrid-view').addClass('noStyle');
    $('#d1a-right-grid').datagrid('getPanel').find('.datagrid-view').addClass('noStyle');

    // D1A 컨텍스트 메뉴 이벤트 (체크된 행 다건 처리)
    $('#d1a-ctx-remove').bind('click', function() {
        var checked = $('#d1a-left-grid').datagrid('getChecked');
        if (checked.length === 0) {
            var row = $('#d1a-left-grid').datagrid('getSelected');
            if (row) checked = [row];
        }
        if (checked.length > 0) {
            d1aRemoveFromLeft(checked);
        }
    });
    $('#d1a-ctx-add').bind('click', function() {
        var checked = $('#d1a-right-grid').datagrid('getChecked');
        if (checked.length === 0) {
            var row = $('#d1a-right-grid').datagrid('getSelected');
            if (row) checked = [row];
        }
        if (checked.length > 0) {
            d1aAddToLeft(checked);
        }
    });

    // D1A 검색 버튼
    $('#d1a-search-button').bind('click', d1aSearch);

    // D1A 검색 Enter 키
    var kwBox = document.getElementById('d1a_searchKeyword');
    if (kwBox) {
        $('#d1a_searchKeyword').textbox('textbox').bind('keydown', function(e) {
            if (e.keyCode == 13) {
                d1aSearch();
            }
        });
    }

    // 첫 로드: 선택된 행 정보 표시 + 데이터 로드
    var mainRow = $(_gridId).datagrid('getSelected');
    if (mainRow) {
        _loadD1aInfo(mainRow);
        _loadD1aData(mainRow.insCode);
    }
}

/**
 * D1A 상단 정보 세팅
 */
function _loadD1aInfo(row) {
    $('#d1a_procName').textbox('setValue', row.procName || '');
    $('#d1a_insName').textbox('setValue', row.insName || '');
    $('#d1a_insDesc').textbox('setValue', row.insDesc || '');
}

/**
 * D1A 양쪽 그리드 데이터 로드 (QCT04A_SER2)
 */
function _loadD1aData(insCode) {
    $.ajax({
        url: consts.url.QCT04A_SER2,
        type: 'POST',
        data: { insCode: insCode },
        dataType: 'json',
        success: function(result) {
            var assigned = result.assignedRows || [];
            var unassigned = result.unassignedRows || [];
            $('#d1a-left-grid').datagrid('loadData', assigned);
            $('#d1a-right-grid').datagrid('loadData', unassigned);
        }
    });
}

/**
 * D1A 우측→좌측 추가 (다건, 중복 방지)
 */
function d1aAddToLeft(rows) {
    var leftRows = $('#d1a-left-grid').datagrid('getRows');
    var existMap = {};
    for (var i = 0; i < leftRows.length; i++) {
        existMap[leftRows[i].insGrpCode] = true;
    }

    // 삭제할 우측 인덱스를 역순으로 수집
    var removeIdxList = [];
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        if (existMap[row.insGrpCode]) continue;
        $('#d1a-left-grid').datagrid('appendRow', {
            insGrpCode: row.insGrpCode,
            insGrpName: row.insGrpName
        });
        existMap[row.insGrpCode] = true;
        var rightIdx = $('#d1a-right-grid').datagrid('getRowIndex', row);
        if (rightIdx >= 0) removeIdxList.push(rightIdx);
    }
    removeIdxList.sort(function(a, b) { return b - a; });
    for (var i = 0; i < removeIdxList.length; i++) {
        $('#d1a-right-grid').datagrid('deleteRow', removeIdxList[i]);
    }
    $('#d1a-right-grid').datagrid('uncheckAll');

    // 추가된 마지막 행에 포커스
    var leftAllRows = $('#d1a-left-grid').datagrid('getRows');
    if (leftAllRows.length > 0) {
        var lastIdx = leftAllRows.length - 1;
        $('#d1a-left-grid').datagrid('selectRow', lastIdx);
        $('#d1a-left-grid').datagrid('scrollTo', lastIdx);
    }
}

/**
 * D1A 좌측→우측 제거 (다건)
 */
function d1aRemoveFromLeft(rows) {
    var removeIdxList = [];
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        $('#d1a-right-grid').datagrid('appendRow', {
            insGrpCode: row.insGrpCode,
            insGrpName: row.insGrpName
        });
        var idx = $('#d1a-left-grid').datagrid('getRowIndex', row);
        if (idx >= 0) removeIdxList.push(idx);
    }
    removeIdxList.sort(function(a, b) { return b - a; });
    for (var i = 0; i < removeIdxList.length; i++) {
        $('#d1a-left-grid').datagrid('deleteRow', removeIdxList[i]);
    }
    $('#d1a-left-grid').datagrid('uncheckAll');

    // 추가된 마지막 행에 포커스
    var rightAllRows = $('#d1a-right-grid').datagrid('getRows');
    if (rightAllRows.length > 0) {
        var lastIdx = rightAllRows.length - 1;
        $('#d1a-right-grid').datagrid('selectRow', lastIdx);
        $('#d1a-right-grid').datagrid('scrollTo', lastIdx);
    }
}

/**
 * D1A 우측 그리드 키워드 검색 (QCT04A_SER3)
 */
function d1aSearch() {
    var keyword = $('#d1a_searchKeyword').textbox('getText') || '';
    $.ajax({
        url: consts.url.QCT04A_SER3,
        type: 'POST',
        data: {
            insCode: d1aInsCode,
            searchKeyword: keyword
        },
        dataType: 'json',
        success: function(result) {
            var rows = result.rows || result || [];
            $('#d1a-right-grid').datagrid('loadData', rows);
        }
    });
}

/**
 * D1A 저장 (QCT04A_INS2 — Delete-Insert)
 */
function d1aSave() {
    var leftRows = $('#d1a-left-grid').datagrid('getRows');
    var models = [];
    for (var i = 0; i < leftRows.length; i++) {
        models.push({
            insGrpCode: leftRows[i].insGrpCode
        });
    }

    $.ajax({
        url: consts.url.QCT04A_INS2,
        type: 'POST',
        data: {
            insCode: d1aInsCode,
            models: JSON.stringify(models)
        },
        dataType: 'json',
        success: function(result) {
            if (result.success) {
                $('#d1a-popup').dialog('close');
                doSearch();
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
// 이미지 캐시 관리 (LRU — 최대 _IMG_CACHE_MAX건)
// ============================================================================
// changedRows에 있는 행(사용자가 편집, 아직 미저장)은 캐시에서 제거하지 않는다.
// 저장 시 _imgStore에서 base64를 가져오므로, 제거하면 이미지가 빈값으로 저장된다.
// ============================================================================

/**
 * _imgStore에 이미지 추가 + LRU 캐시 관리
 * 초과 시 가장 오래된 항목부터 제거 (changedRows 보호)
 */
function _imgCachePut(insCode, base64) {
    // 기존 순서에서 제거 (중복 방지)
    for (var i = _imgCacheOrder.length - 1; i >= 0; i--) {
        if (_imgCacheOrder[i] === insCode) {
            _imgCacheOrder.splice(i, 1);
            break;
        }
    }

    _imgStore[insCode] = base64;
    _imgCacheOrder.push(insCode);

    // 초과 시 가장 오래된 것부터 제거 (changedRows 보호)
    while (_imgCacheOrder.length > _IMG_CACHE_MAX) {
        var evicted = false;
        for (var i = 0; i < _imgCacheOrder.length; i++) {
            if (!changedRows[_imgCacheOrder[i]]) {
                delete _imgStore[_imgCacheOrder[i]];
                _imgCacheOrder.splice(i, 1);
                evicted = true;
                break;
            }
        }
        if (!evicted) break;  // 모두 changedRows → 더 이상 제거 불가
    }
}

/**
 * _imgStore + LRU 캐시 전체 초기화
 */
function _imgCacheReset() {
    _imgStore = {};
    _imgCacheOrder = [];
}

// ============================================================================
// 이미지 배치 로딩 (서버 heap space 방지)
// ============================================================================
// formatter에서 data-src만 설정하고 src는 비워둔다.
// onLoadSuccess 후 JS에서 5개씩 순차적으로 src를 설정한다.
// → 서버에 동시 요청 최대 5개로 제한 → heap space 문제 해결
// 모든 이미지 로드 완료 후 → data URI 변환 → 편집 성능 최적화
// ============================================================================
var _IMG_BATCH_SIZE = 5;
var _imgLoadQueue = [];

function _startThrottledImageLoad() {
    var $panel = $(_gridId).datagrid('getPanel');
    _imgLoadQueue = [];
    $panel.find('img.ins-img-cell[data-src]').each(function() {
        _imgLoadQueue.push(this);
    });
    if (_imgLoadQueue.length > 0) {
        _loadNextBatch();
    }
}

function _loadNextBatch() {
    if (_imgLoadQueue.length === 0) {
        // 모든 이미지 로드 완료 → img-loading 일괄 해제 + data URI 변환
        var $panel = $(_gridId).datagrid('getPanel');
        $panel.find('.ins-img-cell.img-loading').removeClass('img-loading');
        _convertUrlToDataUri();
        return;
    }

    var batch = _imgLoadQueue.splice(0, _IMG_BATCH_SIZE);
    var remaining = batch.length;

    for (var i = 0; i < batch.length; i++) {
        (function(img) {
            img.onload = img.onerror = function() {
                this.onload = null;
                this.onerror = null;
                remaining--;
                if (remaining <= 0) {
                    _loadNextBatch();
                }
            };
            img.src = img.getAttribute('data-src');
            img.removeAttribute('data-src');
        })(batch[i]);
    }
}

// ============================================================================
// URL → data URI 점진적 변환 (편집 성능 최적화)
// ============================================================================
// URL 이미지(<img src="http://...">)는 브라우저 이미지 파이프라인을 거치므로
// DOM 수정 시 reflow 비용이 높다. data URI(<img src="data:...">)로 변환하면
// 이미지 데이터가 DOM에 인라인으로 존재하여 후속 DOM 조작이 빨라진다.
// canvas.toDataURL()로 이미 로드된 이미지를 변환 (추가 네트워크 요청 없음).
// requestAnimationFrame으로 1개씩 처리하여 UI 블로킹 방지.
// ============================================================================
var _convertQueue = [];
var _convertRunning = false;

function _convertUrlToDataUri() {
    var $panel = $(_gridId).datagrid('getPanel');
    _convertQueue = [];
    // URL 기반 이미지만 수집 (data: 접두사가 아닌 것)
    $panel.find('img.ins-img-cell').each(function() {
        if (this.src && this.src.indexOf('data:') !== 0 && this.naturalWidth > 0) {
            _convertQueue.push(this);
        }
    });
    if (!_convertRunning && _convertQueue.length > 0) {
        _convertRunning = true;
        _processConvertNext();
    }
}

function _processConvertNext() {
    if (_convertQueue.length === 0) {
        _convertRunning = false;
        return;
    }
    var img = _convertQueue.shift();
    try {
        // 이미 로드된 이미지를 canvas에 그린 후 data URI로 변환
        var canvas = document.createElement('canvas');
        canvas.width = img.naturalWidth;
        canvas.height = img.naturalHeight;
        var ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0);
        var dataUrl = canvas.toDataURL('image/png');
        // canvas 비트맵 메모리 즉시 해제
        canvas.width = 0;
        canvas.height = 0;
        canvas = null;
        ctx = null;
        img.src = dataUrl;
        // _imgStore에도 저장 (편집 시 활용)
        var $tr = $(img).closest('tr.datagrid-row');
        var rowIdx = parseInt($tr.attr('datagrid-row-index'));
        var rows = $(_gridId).datagrid('getRows');
        if (!isNaN(rowIdx) && rows[rowIdx] && rows[rowIdx].insCode) {
            var b64 = dataUrl.substring(dataUrl.indexOf(',') + 1);
            _imgCachePut(rows[rowIdx].insCode, b64);
        }
    } catch(e) {
        // canvas 보안 제한 등 → 건너뜀
    }
    // 다음 이미지는 다음 프레임에서 처리 (UI 블로킹 방지)
    requestAnimationFrame(_processConvertNext);
}

// ============================================================================
// Base64 이미지 처리 (ASSY 탭 전용)
// ============================================================================
/**
 * DB 이미지를 AJAX로 가져와 base64로 변환
 */
function _fetchImgBase64(insCode, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', consts.url.QCT04A_IMG + '?insCode=' + encodeURIComponent(insCode), true);
    xhr.responseType = 'blob';
    xhr.onload = function() {
        if (xhr.status === 200) {
            var reader = new FileReader();
            reader.onloadend = function() {
                var b64 = reader.result;
                var idx = b64.indexOf(',');
                if (idx >= 0) b64 = b64.substring(idx + 1);
                _imgCachePut(insCode, b64);
                callback(b64);
            };
            reader.readAsDataURL(xhr.response);
        } else {
            callback(null);
        }
    };
    xhr.onerror = function() { callback(null); };
    xhr.send();
}

/**
 * 행의 이미지 base64 반환 (비동기)
 */
function _getRowImgBase64(rowIndex, callback) {
    var row = $(_gridId).datagrid('getRows')[rowIndex];
    if (!row) { callback(null); return; }

    var stored = row.insCode ? _imgStore[row.insCode] : row._imgBase64;
    if (stored) {
        callback(stored);
        return;
    }

    if ((row.hasImg == 1 || row.hasImg == '1') && row.insCode) {
        _fetchImgBase64(row.insCode, callback);
        return;
    }

    callback(null);
}

/**
 * 이미지 row 데이터 변경 + 수정 추적 + DOM 갱신
 *
 * Image.decode()로 이미지를 비동기 디코딩한 후 DOM에 삽입한다.
 * 이렇게 하면 메인 스레드에서 base64 파싱 + PNG 디코딩이 발생하지 않아
 * DOM 삽입 시 버벅임(stutter)이 제거된다.
 */
var _imgUpdateVer = 0;

function _setImgData(rowIndex, base64) {
    var row = $(_gridId).datagrid('getRows')[rowIndex];
    if (!row) return;

    // 데이터 모델 즉시 업데이트
    if (row.insCode) {
        if (base64) {
            _imgCachePut(row.insCode, base64);
        } else {
            delete _imgStore[row.insCode];
            // LRU 순서에서도 제거
            for (var ci = _imgCacheOrder.length - 1; ci >= 0; ci--) {
                if (_imgCacheOrder[ci] === row.insCode) {
                    _imgCacheOrder.splice(ci, 1);
                    break;
                }
            }
        }
        changedRows[row.insCode] = true;
    } else {
        row._imgBase64 = base64;
    }
    row._imgChanged = true;
    row.hasImg = base64 ? 1 : 0;

    // DOM 요소 + 배경색 즉시 적용
    var $panel = $(_gridId).datagrid('getPanel');
    var $trs = $panel.find('tr[datagrid-row-index=' + rowIndex + ']');
    var $cells = $trs.find('td[field=insImg] .datagrid-cell');
    $trs.css('background-color', '#90EE90');

    // 삭제: 즉시 비우기 (가벼운 작업)
    if (!base64) {
        $cells.html('');
        return;
    }

    // 이미지 삽입: Image.decode()로 비동기 디코딩 후 DOM 삽입
    // → 메인 스레드 블로킹 없음, stutter 제거
    _imgUpdateVer++;
    var ver = _imgUpdateVer;
    var img = new Image();
    img.className = 'ins-img-cell';
    img.oncontextmenu = function() { return false; };
    img.src = 'data:image/png;base64,' + base64;

    var doInsert = function() {
        if (_imgUpdateVer !== ver) return;
        $cells.empty().append(img);
    };

    setTimeout(doInsert, 0);
}

// ============================================================================
// 유틸리티 함수
// ============================================================================
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
