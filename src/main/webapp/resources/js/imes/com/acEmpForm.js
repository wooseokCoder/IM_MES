/**
 * ============================================================================
 * acEmpForm.js - 사원 검색 팝업 공통 모듈
 * ============================================================================
 * AS-IS CodeHelperManager.acEmpForm 대응
 * ORD02A 등 사원 검색이 필요한 화면에서 공통 사용
 *
 * 사용법:
 *   acEmpForm.init({ onSelect: function(rows) { ... } });
 *   acEmpForm.open();
 *   acEmpForm.open({ selectMode: true, onSelect: function(rows) { ... } });
 *
 * @version 1.0 2026/02/12
 * ============================================================================
 */
var _acEmpCodeMap = {};  // 코드 캐시 (S021:사원유형, C040:직책)

/** 코드 캐시 로드 */
function _acEmpLoadCode(codeGrup) {
    if (_acEmpCodeMap[codeGrup]) return _acEmpCodeMap[codeGrup];
    var items = [];
    $.ajax({
        url: getUrl('/common/code/code.json'),
        type: 'POST',
        data: {codeGrup: codeGrup},
        dataType: 'json',
        async: false,
        success: function(res) { items = res.rows || []; }
    });
    _acEmpCodeMap[codeGrup] = items;
    return items;
}

/** 코드값 → 코드명 변환 */
function _acEmpFormatCode(codeGrup, value) {
    if (!value) return '';
    var items = _acEmpCodeMap[codeGrup] || [];
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd === value) return items[i].codeName;
    }
    return value;
}

var acEmpForm = {
    _defaultOnSelect: null,  // init 시 등록한 기본 선택 핸들러
    _currentOnSelect: null,  // open 시 1회성 선택 핸들러
    _initialized: false,
    _selectMode: false,      // false=단일선택, true=다중선택(체크박스)
    _allData: [],            // 전체 사원 데이터 (클라이언트 필터링용)
    _selectedOrgCode: null,  // 현재 선택된 조직코드

    /**
     * 초기화 (DOM ready 후 1회 호출)
     * @param {Object} [args]
     * @param {Function} [args.onSelect] - 기본 선택 핸들러: function(rows) {}
     *                    rows = [{ empCode, empName, orgCode, orgName, empType, empTitle, email }, ...]
     */
    init: function(args) {
        var _this = this;
        args = args || {};

        this._defaultOnSelect = args.onSelect || null;

        // 코드 캐시 미리 로드 (S021:사원유형, C040:직책)
        _acEmpLoadCode('S021');
        _acEmpLoadCode('C040');

        // 다이얼로그 설정 (JSP에서 class="easyui-dialog"로 자동 파싱됨)
        $('#acemp-search-dialog').dialog({
            title: '사원찾기',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).dialog('center');
                $(this).css('visibility', '');
                $('#acemp-search-buttons').css('visibility', '');
                setTimeout(function() {
                    $('#acemp-org-tree').treegrid('resize');
                    $('#acemp-search-grid').datagrid('resize');
                }, 100);
            }
        });

        // 검색 Enter 키 (일반 input — EasyUI 파싱 의존 없음)
        $('#acemp-search-keyword').bind('keydown', function(e) {
            if (e.keyCode == 13) _this._doSearch();
        });

        // 좌측: 조직 트리 초기화 (url 없이 수동 로드 — loadFilter+expandAll 무한 루프 방지)
        $('#acemp-org-tree').treegrid({
            method: 'post',
            fit: true,
            fitColumns: false,
            idField: 'id',
            treeField: 'orgName',
            singleSelect: true,
            animate: true,
            rownumbers: false,
            autoRowHeight: true,
            columns: [[
                {field: 'orgName', title: '조직', width: 500, halign: 'center', align: 'left'}
            ]],
            onClickRow: function(row) {
                if (!row.orgCode) {
                    _this._selectedOrgCode = null;
                    _this._filterByOrg(null);
                } else {
                    _this._selectedOrgCode = row.orgCode;
                    _this._filterByOrg(row.orgCode);
                }
            }
        });

        // 조직 트리 데이터 수동 로드
        this._loadOrgTree();

        // 우측: 사원 그리드 초기화 (기본: 단일선택)
        $('#acemp-search-grid').datagrid({
            method: 'post',
            fit: true,
            fitColumns: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'empCode',
            columns: [[
                {field: 'orgCode', title: '부서코드', width: 100, halign: 'center', align: 'center'},
                {field: 'orgName', title: '부서명', width: 120, halign: 'center', align: 'left'},
                {field: 'empCode', title: '사원코드', width: 100, halign: 'center', align: 'center'},
                {field: 'empName', title: '사원명', width: 100, halign: 'center', align: 'center'},
                {field: 'empType', title: '사원형태', width: 80, halign: 'center', align: 'center',
                    formatter: function(v) { return _acEmpFormatCode('S021', v); }},
                {field: 'empTitle', title: '직책', width: 80, halign: 'center', align: 'center',
                    formatter: function(v) { return _acEmpFormatCode('C040', v); }},
                {field: 'email', title: '이메일', width: 200, halign: 'center', align: 'left'}
            ]],
            onDblClickRow: function(index, row) {
                _this._doSelect([row]);
            }
        });

        // 검색 버튼
        $('#acemp-search-btn').bind('click', function() {
            _this._doSearch();
        });

        // 확인 버튼
        $('#acemp-confirm-button').bind('click', function() {
            var rows;
            if (_this._selectMode) {
                // sel='1'인 행 수집
                var allRows = $('#acemp-search-grid').datagrid('getRows');
                rows = [];
                for (var i = 0; i < allRows.length; i++) {
                    if (allRows[i].sel === '1') rows.push(allRows[i]);
                }
            } else {
                var row = $('#acemp-search-grid').datagrid('getSelected');
                rows = row ? [row] : [];
            }
            if (!rows || rows.length === 0) {
                var warnTitle = (typeof msg !== 'undefined' && msg.MSG0051) ? msg.MSG0051 : '경고';
                $.messager.alert(warnTitle, '사원을 선택하세요.', 'warning');
                return;
            }
            _this._doSelect(rows);
        });

        // 닫기 버튼
        $('#acemp-close-button').bind('click', function() {
            _this.close();
        });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     * @param {Object} [opts]
     * @param {Function} [opts.onSelect]   - 이번 호출에만 적용할 선택 핸들러
     * @param {string}   [opts.title]      - 이번 호출에만 적용할 다이얼로그 제목
     * @param {boolean}  [opts.selectMode] - true=다중선택(체크박스), false=단일선택
     */
    open: function(opts) {
        opts = opts || {};
        this._currentOnSelect = opts.onSelect || null;

        if (opts.title) {
            $('#acemp-search-dialog').dialog('setTitle', opts.title);
        }

        // selectMode 변경 시 그리드 재설정
        var newMode = !!opts.selectMode;
        if (newMode !== this._selectMode) {
            this._selectMode = newMode;
            this._rebuildGridColumns();
        }

        // 이전 데이터 초기화
        $('#acemp-search-keyword').val('');
        $('#acemp-search-grid').datagrid('loadData', []);
        $('#acemp-search-grid').datagrid('clearSelections');
        this._selectedOrgCode = null;
        this._allData = [];

        $('#acemp-search-dialog').dialog('open');

        // 사원 전체 조회
        this._doSearch();
    },

    /** 팝업 닫기 */
    close: function() {
        $('#acemp-search-dialog').dialog('close');
    },

    /**
     * 내부: 조직 트리 데이터 로드 (수동 AJAX → flat을 nested children으로 변환)
     */
    _loadOrgTree: function() {
        $.ajax({
            url: getUrl('/common/board/orgSearch/treeSearch.json'),
            type: 'POST',
            dataType: 'json',
            success: function(result) {
                var rows = $.isArray(result) ? result : (result && result.rows ? result.rows : []);

                // flat _parentId 배열 → nested children 배열로 변환
                var map = {};
                var roots = [];
                var i;

                // 1단계: 맵 구축 + children 배열 초기화
                for (i = 0; i < rows.length; i++) {
                    rows[i].children = [];
                    rows[i].state = 'open';
                    map[rows[i].id] = rows[i];
                }

                // 2단계: 부모-자식 연결
                for (i = 0; i < rows.length; i++) {
                    var pid = rows[i]._parentId;
                    if (pid && map[pid]) {
                        map[pid].children.push(rows[i]);
                    } else {
                        roots.push(rows[i]);
                    }
                }

                // 3단계: "전체" 루트 노드를 맨 앞에 삽입
                roots.unshift({id: '_ALL', orgCode: '', orgName: '전체', state: 'open', children: []});

                $('#acemp-org-tree').treegrid('loadData', roots);
            }
        });
    },

    /**
     * 내부: selectMode에 따라 그리드 컬럼 재구성
     */
    _rebuildGridColumns: function() {
        var baseCols = [
            {field: 'orgCode', title: '부서코드', width: 100, halign: 'center', align: 'center'},
            {field: 'orgName', title: '부서명', width: 120, halign: 'center', align: 'left'},
            {field: 'empCode', title: '사원코드', width: 100, halign: 'center', align: 'center'},
            {field: 'empName', title: '사원명', width: 100, halign: 'center', align: 'center'},
            {field: 'empType', title: '사원형태', width: 80, halign: 'center', align: 'center',
                formatter: function(v) { return _acEmpFormatCode('S021', v); }},
            {field: 'empTitle', title: '직책', width: 80, halign: 'center', align: 'center',
                formatter: function(v) { return _acEmpFormatCode('C040', v); }},
            {field: 'email', title: '이메일', width: 200, halign: 'center', align: 'left'}
        ];

        var cols;
        if (this._selectMode) {
            var selCol = {field: 'sel', title: '선택', width: 50, halign: 'center', align: 'center',
                formatter: function(value) {
                    var checked = (value === '1') ? ' checked' : '';
                    return '<input type="checkbox"' + checked + ' onclick="_acEmpToggleSel(this)" />';
                }
            };
            cols = [[selCol].concat(baseCols)];
        } else {
            cols = [baseCols];
        }

        var _this = this;
        $('#acemp-search-grid').datagrid({
            singleSelect: !this._selectMode,
            columns: cols,
            onDblClickRow: function(index, row) {
                _this._doSelect([row]);
            }
        });
    },

    /**
     * 내부: 사원 검색 실행
     */
    _doSearch: function() {
        var _this = this;
        var keyword = $.trim($('#acemp-search-keyword').val());

        $.ajax({
            url: getUrl('/common/board/empSearch/search.json'),
            type: 'POST',
            data: {
                empLike: keyword
            },
            dataType: 'json',
            success: function(result) {
                _this._allData = (result && result.rows) ? result.rows : [];

                // 조직 필터가 선택되어 있으면 필터링 적용
                if (_this._selectedOrgCode) {
                    _this._filterByOrg(_this._selectedOrgCode);
                } else {
                    $('#acemp-search-grid').datagrid('loadData', _this._allData);
                }
            },
            error: function() {
                _this._allData = [];
                $('#acemp-search-grid').datagrid('loadData', []);
            }
        });
    },

    /**
     * 내부: 조직코드로 클라이언트 필터링
     */
    _filterByOrg: function(orgCode) {
        if (!orgCode || !this._allData.length) {
            $('#acemp-search-grid').datagrid('loadData', this._allData);
            return;
        }
        var filtered = [];
        for (var i = 0; i < this._allData.length; i++) {
            if (this._allData[i].orgCode === orgCode) {
                filtered.push(this._allData[i]);
            }
        }
        $('#acemp-search-grid').datagrid('loadData', filtered);
    },

    /**
     * 내부: 행 선택 처리
     * @param {Array} rows - 선택된 행 배열
     */
    _doSelect: function(rows) {
        if (!rows || rows.length === 0) return;

        var handler = this._currentOnSelect || this._defaultOnSelect;
        if (handler) {
            handler(rows);
        }

        this.close();
        this._currentOnSelect = null;  // 1회성 핸들러 초기화
    }
};

/** 체크박스 토글 (selectMode용 전역 함수) */
function _acEmpToggleSel(cb) {
    var tr = $(cb).closest('tr.datagrid-row');
    var index = parseInt(tr.attr('datagrid-row-index'));
    var row = $('#acemp-search-grid').datagrid('getRows')[index];
    if (row) row.sel = cb.checked ? '1' : '0';
}
