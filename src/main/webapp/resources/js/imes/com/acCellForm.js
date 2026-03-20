/**
 * ============================================================================
 * acCellForm.js - 작업장(CELL/설비) 선택 팝업 공통 모듈
 * ============================================================================
 * AS-IS: ChangeCellMc → CONTROL_MACHINE_SEARCH → LSE_MACHINE_QUERY2
 *
 * 사용법:
 *   // 1. JSP에서 include
 *   <%@ include file="/WEB-INF/views/imes/com/acCellForm.jsp" %>
 *
 *   // 2. 열기
 *   acCellForm.open({
 *       mcGroup: '3605',      // 설비그룹 필터 (필수)
 *       isSap: '1',           // SAP 필터 (선택)
 *       onSelect: function(row) {
 *           // row = { mcCode, mcName, mcGroup, mcFlag, mainEmp, mainEmpName, ... }
 *       }
 *   });
 *
 * API: /imes/pop/pop30b/mcSearch.json (→ LSE_MACHINE_QUERY2)
 *      다른 화면에서는 별도 Controller API를 만들거나
 *      공통 API로 분리 가능
 *
 * @version 1.0 2026/03/18
 * ============================================================================
 */
var acCellForm = {
    _defaultOnSelect: null,
    _currentOnSelect: null,
    _initialized: false,
    _mcGroup: null,
    _isSap: null,
    _searchUrl: null,

    /**
     * 초기화 (window.load 후 1회 호출)
     * @param {Object} [args]
     * @param {Function} [args.onSelect] - 기본 선택 핸들러
     * @param {string}   [args.searchUrl] - 검색 API URL (기본: /imes/pop/pop30b/mcSearch.json)
     */
    init: function(args) {
        if (this._initialized) return;
        var _this = this;
        args = args || {};

        this._defaultOnSelect = args.onSelect || null;
        this._searchUrl = args.searchUrl || getUrl('/imes/pop/pop30b/mcSearch.json');

        // 다이얼로그 파싱
        $.parser.parse($('#acce-search-dialog'));

        // 다이얼로그 설정
        $('#acce-search-dialog').dialog({
            title: 'CELL 선택',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).css('visibility', '');
                $('#acce-search-buttons').css('visibility', '');
                $(this).dialog('center');
                setTimeout(function() {
                    $('#acce-search-grid').datagrid('resize');
                }, 100);
            }
        });

        // 그리드 초기화 (MC_CODE, MC_NAME 2컬럼 - AS-IS와 동일)
        $('#acce-search-grid').datagrid({
            method: 'post',
            fit: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: false,
            nowrap: true,
            fitColumns: true,
            idField: 'mcCode',
            columns: [[
                {field: 'mcCode', title: '자원코드', width: 120, halign: 'center', align: 'center'},
                {field: 'mcName', title: '자원명',   width: 200, halign: 'center', align: 'center'}
            ]],
            onDblClickRow: function(index, row) {
                _this._doSelect(row);
            }
        });

        // 검색 버튼
        $('#acce-search-btn').bind('click', function() { _this._doSearch(); });

        // Enter 키
        $('#acce-search-keyword').textbox('textbox').bind('keydown', function(e) {
            if (e.keyCode == 13) _this._doSearch();
        });

        // 선택 버튼
        $('#acce-confirm-button').bind('click', function() {
            var row = $('#acce-search-grid').datagrid('getSelected');
            if (!row) {
                $.messager.alert('알림', '작업장을 선택하세요.', 'warning');
                return;
            }
            _this._doSelect(row);
        });

        // 닫기 버튼
        $('#acce-close-button').bind('click', function() { _this.close(); });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     * @param {Object} [opts]
     * @param {string}   [opts.mcGroup] - 설비그룹 필터 (AS-IS: "3605")
     * @param {string}   [opts.isSap]   - SAP 필터 (AS-IS: "1")
     * @param {Function} [opts.onSelect] - 선택 핸들러
     * @param {string}   [opts.searchUrl] - 검색 API URL 오버라이드
     */
    open: function(opts) {
        opts = opts || {};

        if (!this._initialized) {
            this.init();
        }

        this._currentOnSelect = opts.onSelect || null;
        this._mcGroup = opts.mcGroup || null;
        // AS-IS: IS_SAP은 mcGroup이 '3603'일 때만 '1' 세팅
        if (opts.isSap !== undefined) {
            this._isSap = opts.isSap;
        } else {
            this._isSap = (this._mcGroup === '3603') ? '1' : null;
        }
        if (opts.searchUrl) this._searchUrl = opts.searchUrl;

        // 초기화
        $('#acce-search-keyword').textbox('setValue', '');
        $('#acce-search-grid').datagrid('loadData', []);
        $('#acce-search-grid').datagrid('clearSelections');

        $('#acce-search-dialog').dialog('open');

        // 자동 조회
        this._doSearch();
    },

    close: function() {
        $('#acce-search-dialog').dialog('close');
    },

    _doSearch: function() {
        var _this = this;
        var keyword = $('#acce-search-keyword').textbox('getText');

        var reqData = { mcLike: keyword };
        if (_this._mcGroup) reqData.mcGroup = _this._mcGroup;
        if (_this._isSap !== null) reqData.isSap = _this._isSap;

        $.ajax({
            url: _this._searchUrl,
            type: 'POST',
            data: reqData,
            dataType: 'json',
            success: function(result) {
                var rows = (result && result.rows) ? result.rows : ($.isArray(result) ? result : []);
                $('#acce-search-grid').datagrid('loadData', rows);
            },
            error: function() {
                $('#acce-search-grid').datagrid('loadData', []);
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
