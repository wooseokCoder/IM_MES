/**
 * ============================================================================
 * 모듈: POP30B_D11A - 실적현황 다이얼로그 JS
 * ============================================================================
 * 파일: resources/js/imes/pop/pop30b_pop30b_d11a.js
 * 원본: ProActive POP30B_D11A.cs
 * 설명: 실적현황(D11A) 다이얼로그 전용 JavaScript
 *       pop30b_d11a.open()을 호출하면 실적현황 팝업이 열림
 *
 * 주요 기능:
 *   1. 실적/비가동 이력 조회 (POP30B_SER3)
 * ============================================================================
 */

// ============================================================================
// URL 상수
// ============================================================================
var _d11aConsts = {
    url: {
        POP30B_SER3 : getUrl('/imes/pop/pop30b/POP30B_SER3.json')
    }
};

// ============================================================================
// D11A 네임스페이스
// ============================================================================
var pop30b_d11a = {

    // ========================================================================
    // 다이얼로그 초기화
    // ========================================================================
    init: function() {
        $('#d11a-dialog').dialog({
            title   : '실적현황',
            closed  : true,
            modal   : true,
            width   : 900,
            height  : 500,
            buttons : '#d11a-dialog-buttons',
            onOpen  : function() {
                $(this).css('visibility', '');
                $(this).dialog('center');
            },
            onClose : function() {
                pop30b_d11a.clear();
            }
        });

        // 그리드 초기화
        $('#d11a-grid').datagrid({
            fit       : false,
            width     : '100%',
            height    : 400,
            striped   : true,
            singleSelect : true,
            pagination: false,
            rownumbers: true,
            nowrap    : true,
            columns   : [[
                {field:'actType',      title:'구분',     width:60,  halign:'center', align:'center',
                    styler: function(val) {
                        if (val === '비가동') return 'color:red;';
                        return '';
                    }
                },
                {field:'actContents',  title:'내용',     width:100, halign:'center', align:'left'},
                {field:'preWork',      title:'작업준비',  width:70,  halign:'center', align:'center'},
                {field:'partName',     title:'자재명',    width:100, halign:'center', align:'left'},
                {field:'procCode',     title:'공정',     width:70,  halign:'center', align:'center'},
                {field:'empName',      title:'작업자',    width:70,  halign:'center', align:'center'},
                {field:'actStartTime', title:'시작시간',  width:130, halign:'center', align:'center'},
                {field:'actEndTime',   title:'종료시간',  width:130, halign:'center', align:'center'},
                {field:'actTime',      title:'시간(분)',  width:60,  halign:'center', align:'right'}
            ]]
        });

        // 버튼 이벤트 바인딩
        pop30b_d11a.bindEvents();
    },

    // ========================================================================
    // 버튼 이벤트 바인딩
    // ========================================================================
    bindEvents: function() {
        $('#d11a-close-button').off('click').on('click', function() {
            pop30b_d11a.close();
        });
    },

    // ========================================================================
    // 다이얼로그 열기
    // ========================================================================
    open: function() {
        // 실적현황 조회
        $.ajax({
            url     : _d11aConsts.url.POP30B_SER3,
            type    : 'POST',
            data    : {
                sWorkDate : window.currentStartDate || '',
                eWorkDate : window.currentEndDate || '',
                empCode   : window.currentEmpCode || '',
                mcCode    : window.currentMcCode || ''
            },
            dataType: 'json',
            success : function(data) {
                var rows = data.rows || data || [];
                if (!$.isArray(rows)) rows = [];
                $('#d11a-grid').datagrid('loadData', {total: rows.length, rows: rows});
            },
            error: function() {
                $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
            }
        });

        $('#d11a-dialog').dialog('open');
    },

    // ========================================================================
    // 필드 초기화
    // ========================================================================
    clear: function() {
        $('#d11a-grid').datagrid('loadData', []);
    },

    // ========================================================================
    // 다이얼로그 닫기
    // ========================================================================
    close: function() {
        $('#d11a-dialog').dialog('close');
    }
};

// ============================================================================
// jQuery Ready - 초기화
// ============================================================================
$(function() {
    pop30b_d11a.init();
});
