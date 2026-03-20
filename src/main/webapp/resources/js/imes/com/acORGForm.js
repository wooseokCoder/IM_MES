/**
 * ============================================================================
 * acORGForm.js - 부서 검색 팝업 공통 모듈
 * ============================================================================
 * ProActive CodeHelperManager.acORG 대응
 * STD13A, STD45A, USER2 등 부서 검색이 필요한 화면에서 공통 사용
 *
 * 사용법:
 *   acORGForm.init({ onSelect: function(row) { ... } });
 *   acORGForm.open();
 *   acORGForm.open({ title: '...', onSelect: function(row) { ... } });
 *
 * @version 1.0 2026/02/11
 * ============================================================================
 */
var acORGForm = {
    _defaultOnSelect: null,  // init 시 등록한 기본 선택 핸들러
    _currentOnSelect: null,  // open 시 1회성 선택 핸들러
    _initialized: false,

    /**
     * 초기화 (DOM ready 후 1회 호출)
     * @param {Object} [args]
     * @param {Function} [args.onSelect] - 기본 선택 핸들러: function(row) {}
     *                    row = { orgCode, orgName, id, _parentId, ... }
     */
    init: function(args) {
        var _this = this;
        args = args || {};

        this._defaultOnSelect = args.onSelect || null;

        // 다이얼로그 설정
        $('#acorg-search-dialog').dialog({
            title: '부서 검색',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).css('visibility', '');
                $('#acorg-search-buttons').css('visibility', '');
                $(this).dialog('center');
                setTimeout(function() {
                    $('#acorg-search-grid').treegrid('resize');
                    $('#acorg-search-grid').treegrid('reload');
                }, 100);
            }
        });

        // TreeGrid 초기화
        $('#acorg-search-grid').treegrid({
            url: getUrl('/common/board/orgSearch/treeSearch.json'),
            method: 'post',
            fit: true,
            fitColumns: true,
            idField: 'id',
            treeField: 'orgCode',
            singleSelect: true,
            animate: true,
            rownumbers: false,
            columns: [[
                {field: 'orgCode', title: '부서코드', width: 220, halign: 'center', align: 'left'},
                {field: 'orgName', title: '부서명', width: 200, halign: 'center', align: 'left'}
            ]],
            onLoadSuccess: function(row, data) {
                $('#acorg-search-grid').treegrid('expandAll');
            },
            onDblClickRow: function(row) {
                _this._doSelect(row);
            }
        });

        GridHeaderMenu('#acorg-search-grid', { type: 'treegrid', exportFileName: '부서목록' });
        enableGridSortReset('#acorg-search-grid');

        // 확인 버튼
        $('#acorg-confirm-button').bind('click', function() {
            var selectRow = $('#acorg-search-grid').treegrid('getSelected');
            if (!selectRow) {
                var warnTitle = (typeof msg !== 'undefined' && msg.MSG0051) ? msg.MSG0051 : '경고';
                $.messager.alert(warnTitle, '부서를 선택하세요.', 'warning');
                return;
            }
            _this._doSelect(selectRow);
        });

        // 닫기 버튼
        $('#acorg-close-button').bind('click', function() {
            _this.close();
        });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     * @param {Object} [opts]
     * @param {Function} [opts.onSelect] - 이번 호출에만 적용할 선택 핸들러
     * @param {string}   [opts.title]    - 이번 호출에만 적용할 다이얼로그 제목
     */
    open: function(opts) {
        opts = opts || {};
        this._currentOnSelect = opts.onSelect || null;

        if (opts.title) {
            $('#acorg-search-dialog').dialog('setTitle', opts.title);
        }

        $('#acorg-search-dialog').dialog('open');
    },

    /** 팝업 닫기 */
    close: function() {
        $('#acorg-search-dialog').dialog('close');
    },

    /**
     * 내부: 행 선택 처리
     * open() 시 onSelect가 있으면 우선, 없으면 init() 시 등록한 기본 핸들러 사용
     */
    _doSelect: function(row) {
        if (!row) return;

        var handler = this._currentOnSelect || this._defaultOnSelect;
        if (handler) {
            handler(row);
        }

        this.close();
        this._currentOnSelect = null;  // 1회성 핸들러 초기화
    }
};
