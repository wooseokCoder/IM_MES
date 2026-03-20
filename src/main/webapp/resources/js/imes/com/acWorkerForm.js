/**
 * ============================================================================
 * acWorkerForm.js - 작업자(사원) 선택 팝업 공통 모듈
 * ============================================================================
 * AS-IS: ChangeEmp → CONTROL_EMP_SEARCH → TSTD_EMPLOYEE_QUERY6
 *
 * 사용법:
 *   // 1. JSP에서 include
 *   <%@ include file="/WEB-INF/views/imes/com/acWorkerForm.jsp" %>
 *
 *   // 2. 열기
 *   acWorkerForm.open({
 *       isMc: '1',            // 기계 작업자만 (선택)
 *       isAssy: '1',          // 조립 작업자만 (선택)
 *       onSelect: function(row) {
 *           // row = { empCode, empName, orgCode, orgName,
 *           //         mainMcCode, mainMcName, isPop, ... }
 *       }
 *   });
 *
 * 핵심: TSTD_EMPLOYEE 테이블 기반, MAIN_MC_CODE/MAIN_MC_NAME 반환
 *       → 작업자 선택 시 주설비 자동 세팅 가능
 *
 * API: /imes/pop/pop30b/empSearch.json (→ TSTD_EMPLOYEE_QUERY6)
 *
 * @version 1.0 2026/03/18
 * ============================================================================
 */
var acWorkerForm = {
    _defaultOnSelect: null,
    _currentOnSelect: null,
    _initialized: false,
    _isMc: null,
    _isAssy: null,
    _searchUrl: null,

    /**
     * 초기화 (window.load 후 1회 호출)
     * @param {Object} [args]
     * @param {Function} [args.onSelect] - 기본 선택 핸들러
     * @param {string}   [args.searchUrl] - 검색 API URL
     */
    init: function(args) {
        if (this._initialized) return;
        var _this = this;
        args = args || {};

        this._defaultOnSelect = args.onSelect || null;
        this._searchUrl = args.searchUrl || getUrl('/imes/pop/pop30b/empSearch.json');

        // 다이얼로그 파싱
        $.parser.parse($('#acwk-search-dialog'));

        // 다이얼로그 설정
        $('#acwk-search-dialog').dialog({
            title: '사원선택',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).css('visibility', '');
                $('#acwk-search-buttons').css('visibility', '');
                $(this).dialog('center');
                setTimeout(function() {
                    $('#acwk-search-grid').datagrid('resize');
                }, 100);
            }
        });

        // 그리드 초기화 (부서명, 사원명 - AS-IS와 동일)
        $('#acwk-search-grid').datagrid({
            method: 'post',
            fit: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: false,
            nowrap: true,
            fitColumns: true,
            idField: 'empCode',
            columns: [[
                {field: 'orgName',    title: '부서명',   width: 120, halign: 'center', align: 'center'},
                {field: 'empName',    title: '사원명',   width: 120, halign: 'center', align: 'center'},
                {field: 'empCode',    hidden: true},
                {field: 'mainMcCode', hidden: true},
                {field: 'mainMcName', hidden: true},
                {field: 'isPop',      hidden: true}
            ]],
            onDblClickRow: function(index, row) {
                _this._doSelect(row);
            }
        });

        // 검색 버튼
        $('#acwk-search-btn').bind('click', function() { _this._doSearch(); });

        // Enter 키
        $('#acwk-search-keyword').textbox('textbox').bind('keydown', function(e) {
            if (e.keyCode == 13) _this._doSearch();
        });

        // 선택 버튼
        $('#acwk-confirm-button').bind('click', function() {
            var row = $('#acwk-search-grid').datagrid('getSelected');
            if (!row) {
                $.messager.alert('알림', '작업자를 선택하세요.', 'warning');
                return;
            }
            _this._doSelect(row);
        });

        // 닫기 버튼
        $('#acwk-close-button').bind('click', function() { _this.close(); });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     * @param {Object} [opts]
     * @param {string}   [opts.isMc]   - 기계 작업자만 (AS-IS: IS_MC='1')
     * @param {string}   [opts.isAssy] - 조립 작업자만 (AS-IS: IS_ASSY='1')
     * @param {Function} [opts.onSelect] - 선택 핸들러
     * @param {string}   [opts.searchUrl] - 검색 API URL 오버라이드
     */
    open: function(opts) {
        opts = opts || {};

        if (!this._initialized) {
            this.init();
        }

        this._currentOnSelect = opts.onSelect || null;
        this._isMc = (opts.isMc !== undefined) ? opts.isMc : null;
        this._isAssy = (opts.isAssy !== undefined) ? opts.isAssy : null;
        if (opts.searchUrl) this._searchUrl = opts.searchUrl;

        // 초기화
        $('#acwk-search-keyword').textbox('setValue', '');
        $('#acwk-search-grid').datagrid('loadData', []);
        $('#acwk-search-grid').datagrid('clearSelections');

        $('#acwk-search-dialog').dialog('open');

        // 자동 조회 (AS-IS: OnShown에서 Search 자동 호출)
        this._doSearch();
    },

    close: function() {
        $('#acwk-search-dialog').dialog('close');
    },

    _doSearch: function() {
        var _this = this;
        var keyword = $('#acwk-search-keyword').textbox('getText');

        var reqData = {
            empLike: keyword,
            dataFlag: 0
        };
        if (_this._isMc) reqData.isMc = _this._isMc;
        if (_this._isAssy) reqData.isAssy = _this._isAssy;

        $.ajax({
            url: _this._searchUrl,
            type: 'POST',
            data: reqData,
            dataType: 'json',
            success: function(result) {
                var rows = (result && result.rows) ? result.rows : ($.isArray(result) ? result : []);
                $('#acwk-search-grid').datagrid('loadData', rows);
            },
            error: function() {
                $('#acwk-search-grid').datagrid('loadData', []);
            }
        });
    },

    _doSelect: function(row) {
        if (!row) return;
        var handler = this._currentOnSelect || this._defaultOnSelect;
        if (handler) handler(row);
        this.close();
        this._currentOnSelect = null;
    }
};
