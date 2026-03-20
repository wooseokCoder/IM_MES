/**
 * ============================================================================
 * mcNgLog.js - NG 이력 공통 팝업
 * ============================================================================
 * AS-IS: McNgLog.cs - 부적합 현황 그리드 (읽기 전용)
 * 백엔드: Pop30aService.pop30aSerA() (POP30A_SER_A)
 *
 * 사용법:
 *   // 1. JSP에서 include
 *   <%@ include file="/WEB-INF/views/imes/com/mcNgLog.jsp" %>
 *
 *   // 2. 열기
 *   mcNgLog.open({
 *       woNo: row.woNo,
 *       mcCode: consts.currentMcCode,
 *       plants: '3605',
 *       searchUrl: getUrl('/imes/pop/pop30b/POP30A_SER_A.json')
 *   });
 *
 * @version 1.0 2026/03/19
 * ============================================================================
 */
var mcNgLog = {
    _initialized: false,
    _searchUrl: null,
    _woNo: null,
    _mcCode: null,
    _plants: null,

    /**
     * 초기화 (1회)
     */
    init: function() {
        if (this._initialized) return;
        var _this = this;

        // 다이얼로그 파싱
        $.parser.parse($('#mngl-dialog'));

        // 다이얼로그 설정
        $('#mngl-dialog').dialog({
            title: '부적합 현황',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).css('visibility', '');
                $('#mngl-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
                setTimeout(function() {
                    $('#mngl-grid').datagrid('resize');
                }, 100);
            },
            onClose: function() {
                _this._woNo = null;
                _this._mcCode = null;
            }
        });

        // NG 이력 그리드 초기화
        $('#mngl-grid').datagrid({
            method: 'post',
            fit: true,
            striped: true,
            singleSelect: true,
            pagination: false,
            rownumbers: true,
            nowrap: true,
            fitColumns: true,
            columns: [[
                {field: 'reqCode',      title: '요청번호',   width: 100, halign: 'center', align: 'center'},
                {field: 'mngStateName', title: '상태',       width: 60,  halign: 'center', align: 'center'},
                {field: 'reqDate',      title: '등록일',     width: 90,  halign: 'center', align: 'center'},
                {field: 'empName',      title: '작업자',     width: 70,  halign: 'center', align: 'center'},
                {field: 'procCode',     title: '공정',       width: 70,  halign: 'center', align: 'center'},
                {field: 'partCode',     title: '자재코드',   width: 90,  halign: 'center', align: 'center'},
                {field: 'partName',     title: '자재명',     width: 100, halign: 'center', align: 'left'},
                {field: 'masterCause',  title: '불량유형',   width: 80,  halign: 'center', align: 'center'},
                {field: 'detailCause',  title: '상세유형',   width: 80,  halign: 'center', align: 'center'},
                {field: 'reqContents',  title: '불량내용',   width: 150, halign: 'center', align: 'left'}
            ]]
        });

        // 조회 버튼
        $('#mngl-search-btn').bind('click', function() { _this._doSearch(); });
        // 닫기 버튼
        $('#mngl-close-button').bind('click', function() { _this.close(); });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     * @param {Object} opts
     * @param {string}   opts.woNo      - 작업오더번호
     * @param {string}   opts.mcCode    - 설비코드
     * @param {string}   opts.plants    - 공장코드
     * @param {string}   opts.searchUrl - 부적합 조회 API URL
     */
    open: function(opts) {
        opts = opts || {};

        if (!this._initialized) {
            this.init();
        }

        this._searchUrl = opts.searchUrl || null;
        this._woNo = opts.woNo || '';
        this._mcCode = opts.mcCode || '';
        this._plants = opts.plants || '';

        // 날짜 범위 초기화 (AS-IS: ±7일)
        var today = new Date();
        var start = new Date(today);
        start.setDate(today.getDate() - 7);
        var end = new Date(today);
        end.setDate(today.getDate() + 7);

        $('#mngl-start-date').datebox('setValue', this._formatDate(start));
        $('#mngl-end-date').datebox('setValue', this._formatDate(end));

        // 그리드 초기화
        $('#mngl-grid').datagrid('loadData', []);

        $('#mngl-dialog').dialog('open');

        // 자동 조회
        this._doSearch();
    },

    /**
     * 닫기
     */
    close: function() {
        $('#mngl-dialog').dialog('close');
    },

    /**
     * 조회
     */
    _doSearch: function() {
        if (!this._searchUrl) return;

        var _this = this;
        $.ajax({
            url: _this._searchUrl,
            type: 'POST',
            data: {
                woNo: _this._woNo,
                mcCode: _this._mcCode,
                plants: _this._plants,
                sNgDate: $('#mngl-start-date').datebox('getValue'),
                eNgDate: $('#mngl-end-date').datebox('getValue')
            },
            dataType: 'json',
            success: function(data) {
                // pop30aSerA returns { rows: [...], rows2: [...] }
                var wrapper = data.rows || data || {};
                var rows = wrapper.rows || wrapper || [];
                if (!$.isArray(rows)) rows = [];
                $('#mngl-grid').datagrid('loadData', {total: rows.length, rows: rows});
            },
            error: function() {
                $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
            }
        });
    },

    /**
     * 날짜 포맷 (yyyy-MM-dd)
     */
    _formatDate: function(date) {
        var y = date.getFullYear();
        var m = ('0' + (date.getMonth() + 1)).slice(-2);
        var d = ('0' + date.getDate()).slice(-2);
        return y + '-' + m + '-' + d;
    }
};
