/**
 * ============================================================================
 * acMachineForm.js - 설비 검색 팝업 공통 모듈
 * ============================================================================
 * AS-IS CodeHelperManager.acMachineForm 대응
 * STD13A 등 설비 검색이 필요한 화면에서 공통 사용
 *
 * 사용법:
 *   acMachineForm.init({ onSelect: function(row) { ... } });
 *   acMachineForm.open();
 *   acMachineForm.open({ isSap: 1, mcGroup: '3603', onSelect: function(row) { ... } });
 *
 * @version 1.0 2026/02/12
 * ============================================================================
 */
var _acMcCodeMap = {};  // 코드 캐시 (C020:설비그룹, S908:구분)

/** 코드 캐시 로드 */
function _acMcLoadCode(codeGrup) {
    if (_acMcCodeMap[codeGrup]) return _acMcCodeMap[codeGrup];
    var items = [];
    $.ajax({
        url: getUrl('/common/code/code.json'),
        type: 'POST',
        data: {codeGrup: codeGrup},
        dataType: 'json',
        async: false,
        success: function(res) { items = res.rows || []; }
    });
    _acMcCodeMap[codeGrup] = items;
    return items;
}

/** 코드값 → 코드명 변환 */
function _acMcFormatCode(codeGrup, value) {
    if (!value) return '';
    var items = _acMcCodeMap[codeGrup] || [];
    for (var i = 0; i < items.length; i++) {
        if (items[i].codeCd === value) return items[i].codeName;
    }
    return value;
}

var acMachineForm = {
    _defaultOnSelect: null,  // init 시 등록한 기본 선택 핸들러
    _currentOnSelect: null,  // open 시 1회성 선택 핸들러
    _initialized: false,
    _isSap: null,            // open 시 IS_SAP 필터 (null=전체, 0, 1)
    _mcGroup: null,          // open 시 MC_GROUP 필터

    /**
     * 초기화 (DOM ready 후 1회 호출)
     * @param {Object} [args]
     * @param {Function} [args.onSelect] - 기본 선택 핸들러: function(row) {}
     *                    row = { mcCode, mcName, mcGroup, mcFlag, mcModel, ... }
     */
    init: function(args) {
        var _this = this;
        args = args || {};

        this._defaultOnSelect = args.onSelect || null;

        // 코드 캐시 미리 로드 (C020:설비그룹, S908:구분)
        _acMcLoadCode('C020');
        _acMcLoadCode('S908');

        // 다이얼로그 내부 컴포넌트 파싱
        $.parser.parse($('#acmc-search-dialog'));

        // 다이얼로그 설정
        $('#acmc-search-dialog').dialog({
            title: '설비찾기',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).css('visibility', '');
                $('#acmc-search-buttons').css('visibility', '');
                $(this).dialog('center');
                setTimeout(function() {
                    $('#acmc-search-grid').datagrid('resize');
                }, 100);
            }
        });

        // 설비 그리드 초기화
        $('#acmc-search-grid').datagrid({
            method: 'post',
            fit: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            idField: 'mcCode',
            columns: [[
                {field: 'mcCode', title: '설비코드', width: 100, halign: 'center', align: 'center'},
                {field: 'mcName', title: '설비명', width: 200, halign: 'center', align: 'left'},
                {field: 'mcGroup', title: '설비그룹', width: 80, halign: 'center', align: 'center',
                    formatter: function(v) { return _acMcFormatCode('C020', v); }},
                {field: 'mcFlag', title: '구분', width: 130, halign: 'center', align: 'center',
                    formatter: function(v) {
                        var items = _acMcCodeMap['S908'] || [];
                        var html = '';
                        for (var i = 0; i < items.length; i++) {
                            var checked = (items[i].codeCd === v) ? ' checked' : '';
                            html += '<label style="margin-right:4px;"><input type="radio" disabled' + checked + ' style="vertical-align:middle;margin:0 1px 0 0;" />' + items[i].codeName + '</label>';
                        }
                        return html;
                    }},
                {field: 'scomment', title: '비고', width: 200, halign: 'center', align: 'left'}
            ]],
            onDblClickRow: function(index, row) {
                _this._doSelect(row);
            }
        });

        GridHeaderMenu('#acmc-search-grid', { exportFileName: '설비찾기' });
        enableGridSortReset('#acmc-search-grid');

        // 검색 버튼
        $('#acmc-search-btn').bind('click', function() {
            _this._doSearch();
        });

        // 검색 Enter 키
        $('#acmc-search-keyword').textbox('textbox').bind('keydown', function(e) {
            if (e.keyCode == 13) _this._doSearch();
        });

        // 확인 버튼
        $('#acmc-confirm-button').bind('click', function() {
            var row = $('#acmc-search-grid').datagrid('getSelected');
            if (!row) {
                var warnTitle = (typeof msg !== 'undefined' && msg.MSG0051) ? msg.MSG0051 : '경고';
                $.messager.alert(warnTitle, '설비를 선택하세요.', 'warning');
                return;
            }
            _this._doSelect(row);
        });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     * @param {Object} [opts]
     * @param {Function} [opts.onSelect] - 이번 호출에만 적용할 선택 핸들러
     * @param {string}   [opts.title]    - 이번 호출에만 적용할 다이얼로그 제목
     * @param {number}   [opts.isSap]    - IS_SAP 필터 (1=SAP설비, 0=비SAP, null=전체)
     * @param {string}   [opts.mcGroup]  - MC_GROUP 필터 (설비그룹 코드)
     */
    open: function(opts) {
        opts = opts || {};
        this._currentOnSelect = opts.onSelect || null;
        this._isSap = (opts.isSap !== undefined) ? opts.isSap : null;
        this._mcGroup = opts.mcGroup || null;

        if (opts.title) {
            $('#acmc-search-dialog').dialog('setTitle', opts.title);
        }

        // 이전 데이터 초기화
        $('#acmc-search-keyword').textbox('setValue', '');
        $('#acmc-search-grid').datagrid('loadData', []);
        $('#acmc-search-grid').datagrid('clearSelections');

        $('#acmc-search-dialog').dialog('open');

        // 설비 전체 조회
        this._doSearch();
    },

    /** 팝업 닫기 */
    close: function() {
        $('#acmc-search-dialog').dialog('close');
    },

    /**
     * 내부: 설비 검색 실행
     */
    _doSearch: function() {
        var _this = this;
        var keyword = $('#acmc-search-keyword').textbox('getText');

        var reqData = {
            mcLike: keyword
        };
        if (_this._isSap !== null) {
            reqData.isSap = _this._isSap;
        }
        if (_this._mcGroup) {
            reqData.mcGroup = _this._mcGroup;
        }

        $.ajax({
            url: getUrl('/common/board/machineSearch/search.json'),
            type: 'POST',
            data: reqData,
            dataType: 'json',
            success: function(result) {
                var rows = (result && result.rows) ? result.rows : [];
                $('#acmc-search-grid').datagrid('loadData', rows);
            },
            error: function() {
                $('#acmc-search-grid').datagrid('loadData', []);
            }
        });
    },

    /**
     * 내부: 행 선택 처리
     * @param {Object} row - 선택된 행
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
