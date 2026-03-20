/**
 * ============================================================================
 * 모듈: POP30B_D9A - 설비제원 다이얼로그 JS
 * ============================================================================
 * 파일: resources/js/imes/pop/pop30b_d9a.js
 * 원본: ProActive POP30B_D9A.cs
 * 설명: 설비제원(D9A) 다이얼로그 전용 JavaScript
 *       pop30b_d9a.open()을 호출하면 설비제원 팝업이 열림
 *
 * 주요 기능:
 *   1. 설비 파일목록 조회 (POP30A_SER17)
 *   2. 파일 다운로드
 * ============================================================================
 */

// ============================================================================
// URL 상수
// ============================================================================
var _d9aConsts = {
    url: {
        POP30A_SER17 : getUrl('/imes/pop/pop30b/POP30A_SER17.json')
    }
};

// ============================================================================
// D9A 네임스페이스
// ============================================================================
var pop30b_d9a = {
    _currentMcCode: null,
    _currentPlants: null,

    // ========================================================================
    // 다이얼로그 초기화
    // ========================================================================
    init: function() {
        var _this = this;

        $('#d9a-dialog').dialog({
            title   : '설비제원',
            closed  : true,
            modal   : true,
            width   : 550,
            height  : 400,
            buttons : '#d9a-dialog-buttons',
            onOpen  : function() {
                $(this).css('visibility', '');
                $('#d9a-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
            },
            onClose : function() {
                pop30b_d9a._clear();
            }
        });

        // 파일목록 그리드 초기화
        // AS-IS: SEL(버튼), FILE_NAME, REG_EMP_NAME, REG_DATE, FILE_ID(hidden)
        $('#d9a-grid').datagrid({
            fit       : false,
            width     : '100%',
            height    : 280,
            striped   : true,
            singleSelect : true,
            pagination: false,
            rownumbers: true,
            nowrap    : true,
            fitColumns: true,
            columns   : [[
                {field:'fileName',    title:'파일명',     width:200, halign:'center', align:'left'},
                {field:'regEmpName',  title:'등록자',     width:80,  halign:'center', align:'center'},
                {field:'regDate',     title:'등록일',     width:90,  halign:'center', align:'center'},
                {field:'fileId',      hidden: true}
            ]],
            onDblClickRow: function(index, row) {
                pop30b_d9a._doDownload(row);
            }
        });

        // 버튼 이벤트 바인딩
        pop30b_d9a._bindEvents();
    },

    // ========================================================================
    // 버튼 이벤트 바인딩
    // ========================================================================
    _bindEvents: function() {
        $('#d9a-download-button').off('click').on('click', function() {
            var row = $('#d9a-grid').datagrid('getSelected');
            if (!row) {
                $.messager.alert('알림', '파일을 선택하세요.', 'warning');
                return;
            }
            pop30b_d9a._doDownload(row);
        });
        $('#d9a-close-button').off('click').on('click', function() {
            pop30b_d9a.close();
        });
    },

    // ========================================================================
    // 다이얼로그 열기
    // ========================================================================
    open: function(opts) {
        opts = opts || {};
        pop30b_d9a._currentMcCode = opts.mcCode || '';
        pop30b_d9a._currentPlants = opts.plants || '';

        // 그리드 초기화
        $('#d9a-grid').datagrid('loadData', []);

        // 파일목록 조회 (POP30A_SER17)
        // AS-IS: CAT_CODE='MCT_SPEC', REF_CODE=MC_CODE
        $.ajax({
            url     : _d9aConsts.url.POP30A_SER17,
            type    : 'POST',
            data    : {
                catCode : 'MCT_SPEC',
                refCode : opts.mcCode || '',
                plants  : opts.plants || ''
            },
            dataType: 'json',
            success : function(data) {
                var rows = data.rows || data || [];
                if (!$.isArray(rows)) rows = [];
                $('#d9a-grid').datagrid('loadData', {total: rows.length, rows: rows});
            },
            error: function() {
                $.messager.alert('오류', '파일목록 조회 중 오류가 발생했습니다.', 'error');
            }
        });

        $('#d9a-dialog').dialog('open');
    },

    // ========================================================================
    // 파일 다운로드
    // AS-IS: FTP에서 파일 다운로드 → 로컬 temp 저장 → 열기
    // TO-BE: 웹 기반 파일 다운로드 (서버에서 처리)
    // ========================================================================
    _doDownload: function(row) {
        if (!row || !row.fileId) {
            $.messager.alert('알림', '파일 정보가 없습니다.', 'warning');
            return;
        }

        // 파일 다운로드 (GET 방식 - 브라우저 기본 다운로드)
        var downloadUrl = getUrl('/imes/pop/pop30b/fileDownload.do')
            + '?fileId=' + encodeURIComponent(row.fileId)
            + '&fileName=' + encodeURIComponent(row.fileName || '');

        // 새 창/iframe으로 다운로드 실행
        var $iframe = $('<iframe style="display:none;"></iframe>');
        $iframe.attr('src', downloadUrl);
        $('body').append($iframe);
        setTimeout(function() { $iframe.remove(); }, 30000);
    },

    // ========================================================================
    // 필드 초기화
    // ========================================================================
    _clear: function() {
        pop30b_d9a._currentMcCode = null;
        pop30b_d9a._currentPlants = null;
        $('#d9a-grid').datagrid('loadData', []);
    },

    // ========================================================================
    // 다이얼로그 닫기
    // ========================================================================
    close: function() {
        $('#d9a-dialog').dialog('close');
    }
};

// ============================================================================
// jQuery Ready - 초기화
// ============================================================================
$(function() {
    pop30b_d9a.init();
});
