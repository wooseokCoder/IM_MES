/**
 * ============================================================================
 * acProcForm.js - 공정 찾기 팝업 공통 모듈
 * ============================================================================
 * AS-IS CodeHelperManager.acProcForm 대응
 * QCT05A 등 공정 검색이 필요한 화면에서 공통 사용
 *
 * 사용법:
 *   acProcForm.init({ url: '...', lprocCode: '...' });
 *   acProcForm.open({ onSelect: function(row) { ... } });
 *
 * row = { procCode, procName, lprocName, mprocName, procColor, isOs }
 *
 * @author 송우석
 * @version 1.1 2026/03/06
 * ============================================================================
 */
var acProcForm = {
    _defaultOnSelect: null,
    _currentOnSelect: null,
    _initialized: false,
    _keyBound: false,
    _url: '',
    _lprocCode: '',
    _allRows: [],

    /**
     * 초기화 (DOM ready 후 1회 호출)
     * @param {Object} args
     * @param {string}   args.url       - 공정 목록 조회 URL (필수)
     * @param {string}   [args.lprocCode] - LPROC_CODE 필터
     * @param {Function} [args.onSelect]  - 기본 선택 핸들러: function(row) {}
     */
    init: function(args) {
        var _this = this;
        args = args || {};

        this._url = args.url || '';
        this._lprocCode = args.lprocCode || '';
        this._defaultOnSelect = args.onSelect || null;

        // 다이얼로그 설정
        $('#acproc-search-dialog').dialog({
            title: '공정 찾기',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).css('visibility', '');
                $('#acproc-search-buttons').css('visibility', '');
                $(this).dialog('center');
                // Enter 키 바인딩 (1회)
                if (!_this._keyBound) {
                    _this._keyBound = true;
                    $('#acproc-search-keyword').textbox('textbox').bind('keydown', function(e) {
                        if (e.keyCode == 13) {
                            _this._doFilter();
                        }
                    });
                }
                // 첫 열기 시 데이터 로드
                if (_this._allRows.length === 0 && _this._url) {
                    _this._loadData();
                }
                setTimeout(function() {
                    $('#acproc-search-grid').datagrid('resize');
                }, 100);
            }
        });

        // 그리드 초기화
        $('#acproc-search-grid').datagrid({
            fit: true,
            fitColumns: false,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: false,
            nowrap: true,
            idField: 'procCode',
            columns: [[
                {field: 'lprocName', title: '대일정',   hidden: true},
                {field: 'mprocName', title: '중일정',   hidden: true},
                {field: 'procColor', title: '색상',     width: 60,  halign: 'center', align: 'center',
                    formatter: function(value) {
                        var bg = value ? 'background-color:' + value + ';' : '';
                        return '<div style="width:20px;height:14px;margin:2px auto;' + bg + 'border:1px solid #999;"></div>';
                    }
                },
                {field: 'procCode', title: '공정코드', width: 100, halign: 'center', align: 'center'},
                {field: 'procName', title: '공정명',   width: 200, halign: 'center', align: 'center'},
                {field: 'isOs',     title: '외주가능', width: 70,  halign: 'center', align: 'center',
                    formatter: function(value) {
                        var checked = (value == 1 || value == '1') ? ' checked' : '';
                        return '<input type="checkbox"' + checked + ' onclick="return false" style="cursor:default" />';
                    }
                }
            ]],
            onDblClickRow: function(index, row) {
                _this._doSelect(row);
            }
        });

        // 조회 버튼
        $('#acproc-search-btn').bind('click', function() {
            _this._doFilter();
        });

        // 확인 버튼
        $('#acproc-confirm-button').bind('click', function() {
            var row = $('#acproc-search-grid').datagrid('getSelected');
            if (!row) {
                var warnTitle = (typeof msg !== 'undefined' && msg.MSG0051) ? msg.MSG0051 : '경고';
                $.messager.alert(warnTitle, '공정을 선택하세요.', 'warning');
                return;
            }
            _this._doSelect(row);
        });

        // 닫기 버튼
        $('#acproc-close-button').bind('click', function() {
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
            $('#acproc-search-dialog').dialog('setTitle', opts.title);
        }

        // lprocCode 변경 시 캐시 비우고 재조회
        if (opts.lprocCode !== undefined && opts.lprocCode !== this._lprocCode) {
            this._lprocCode = opts.lprocCode;
            this._allRows = [];
        }

        // 검색어 초기화
        $('#acproc-search-keyword').textbox('setValue', '');

        $('#acproc-search-dialog').dialog('open');

        // 이전 선택 해제
        $('#acproc-search-grid').datagrid('unselectAll');

        // 전체 데이터 표시
        if (this._allRows.length > 0) {
            $('#acproc-search-grid').datagrid('loadData', this._allRows);
        }
    },

    /** 팝업 닫기 */
    close: function() {
        $('#acproc-search-dialog').dialog('close');
    },

    /** 내부: 전체 데이터 로드 */
    _loadData: function() {
        var _this = this;
        $.ajax({
            url: _this._url,
            type: 'POST',
            data: { lprocCode: _this._lprocCode },
            dataType: 'json',
            success: function(response) {
                var rows = response.rows || response || [];
                _this._allRows = rows;
                $('#acproc-search-grid').datagrid('loadData', rows);
            }
        });
    },

    /** 내부: 키워드 필터 (클라이언트 사이드) */
    _doFilter: function() {
        var keyword = $('#acproc-search-keyword').textbox('getValue') || '';
        keyword = keyword.trim().toUpperCase();

        if (!keyword) {
            $('#acproc-search-grid').datagrid('loadData', this._allRows);
            return;
        }

        var filtered = [];
        for (var i = 0; i < this._allRows.length; i++) {
            var r = this._allRows[i];
            var code = (r.procCode || '').toUpperCase();
            var name = (r.procName || '').toUpperCase();
            var lname = (r.lprocName || '').toUpperCase();
            var mname = (r.mprocName || '').toUpperCase();
            if (code.indexOf(keyword) >= 0 || name.indexOf(keyword) >= 0
                || lname.indexOf(keyword) >= 0 || mname.indexOf(keyword) >= 0) {
                filtered.push(r);
            }
        }
        $('#acproc-search-grid').datagrid('loadData', filtered);
    },

    /** 내부: 행 선택 처리 */
    _doSelect: function(row) {
        if (!row) return;

        var handler = this._currentOnSelect || this._defaultOnSelect;
        if (handler) {
            handler(row);
        }

        this.close();
        this._currentOnSelect = null;
    }
};
