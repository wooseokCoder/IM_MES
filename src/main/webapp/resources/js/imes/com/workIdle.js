/**
 * ============================================================================
 * workIdle.js - 비가동 사유 선택 공통 팝업
 * ============================================================================
 * AS-IS: WorkIdle.cs - PRE_START, STOP, 비가동입력에서 공통 호출
 *
 * UI 구조 (AS-IS 충실 전환):
 *   ┌────────────────────────────────────┐
 *   │ 비가동 사유를 선택하세요.            │
 *   ├────────────────────────────────────┤
 *   │          비가동 사유                │
 *   │ [없음              v] 분 후 시작    │
 *   │ [비가동코드 콤보    v]              │
 *   ├────────────────────────────────────┤
 *   │   [확인]         [닫기]            │
 *   └────────────────────────────────────┘
 *
 * 사용법:
 *   <%@ include file="/WEB-INF/views/imes/com/workIdle.jsp" %>
 *
 *   workIdle.open({
 *       plants: '3605',
 *       searchUrl: getUrl('/imes/pop/pop30b/idleCodeSearch.json'),
 *       idleCause: 'M132',
 *       onConfirm: function(result) {
 *           // result = { idleCode, idleName, idleMinute, scomment }
 *       }
 *   });
 *
 * @version 2.2 2026/03/19
 * ============================================================================
 */

// W005 코드 동기 로드 (consts.loadCode 패턴)
var _wiCodeW005 = null;

function _wiLoadCode(codeGrup) {
    var items = [];
    $.ajax({
        url: getUrl('/common/code/code.json'),
        type: 'POST',
        data: { codeGrup: codeGrup },
        dataType: 'json',
        async: false,
        success: function(data) {
            items = data.rows || data || [];
        }
    });
    return items;
}

var workIdle = {
    _initialized: false,
    _currentOnConfirm: null,
    _searchUrl: null,
    _idleCause: null,
    _currentOnCancel: null,

    /**
     * 초기화 (1회)
     */
    init: function() {
        if (this._initialized) return;
        var _this = this;

        // W005 코드 동기 로드
        _wiCodeW005 = _wiLoadCode('W005');

        // 다이얼로그 파싱 (acWorkerForm 패턴 동일)
        $.parser.parse($('#wi-dialog'));

        // 다이얼로그 설정
        $('#wi-dialog').dialog({
            title: '비가동 사유를 선택하세요.',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).css('visibility', '');
                $('#wi-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
            },
            onClose: function() {
                // onConfirm이 호출되지 않고 닫히면 onCancel 호출
                if (_this._currentOnCancel) {
                    var cancel = _this._currentOnCancel;
                    _this._currentOnCancel = null;
                    cancel();
                }
                _this._currentOnConfirm = null;
                _this._idleCause = null;
            }
        });

        // IDLE_MINUTE: W005 코드 데이터 로드
        $('#wi-idle-minute').combobox('loadData', _wiCodeW005);

        // 확인 버튼
        $('#wi-confirm-button').bind('click', function() { _this._doConfirm(); });
        // 닫기 버튼
        $('#wi-close-button').bind('click', function() { _this.close(); });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     */
    open: function(opts) {
        opts = opts || {};

        if (!this._initialized) {
            this.init();
        }

        this._currentOnConfirm = opts.onConfirm || null;
        this._currentOnCancel = opts.onCancel || null;
        this._searchUrl = opts.searchUrl || null;
        this._idleCause = opts.idleCause || null;

        // 콤보 초기화
        $('#wi-idle-minute').combobox('readonly', false);
        $('#wi-idle-cause').combobox('readonly', false);
        $('#wi-idle-minute').combobox('select', 'NONE');
        $('#wi-idle-cause').combobox('clear');

        // 비가동코드 목록 로드
        if (this._searchUrl) {
            var _this = this;
            $.ajax({
                url: _this._searchUrl,
                type: 'POST',
                data: { plants: opts.plants || '' },
                dataType: 'json',
                success: function(data) {
                    var rows = data.rows || data || [];
                    if (!$.isArray(rows)) rows = [];
                    $('#wi-idle-cause').combobox('loadData', rows);

                    // 사전선택 idleCause → 자동 선택 + 읽기전용
                    if (_this._idleCause) {
                        $('#wi-idle-cause').combobox('select', _this._idleCause);
                        $('#wi-idle-cause').combobox('readonly', true);
                        $('#wi-idle-minute').combobox('readonly', true);
                    }
                },
                error: function() {
                    $.messager.alert('오류', '비가동코드 조회 중 오류가 발생했습니다.', 'error');
                }
            });
        }

        $('#wi-dialog').dialog('open');
    },

    /**
     * 닫기
     */
    close: function() {
        $('#wi-dialog').dialog('close');
    },

    /**
     * 확인 처리
     */
    _doConfirm: function() {
        var idleCode = $('#wi-idle-cause').combobox('getValue');
        if (!idleCode) {
            $.messager.alert('알림', '비가동 사유를 선택하세요.', 'warning');
            return;
        }

        var idleName = $('#wi-idle-cause').combobox('getText');
        var idleMinute = $('#wi-idle-minute').combobox('getValue');

        // 선택된 비가동코드의 전체 데이터 (isMctScomment, isNg 등)
        var allData = $('#wi-idle-cause').combobox('getData');
        var selectedData = null;
        for (var i = 0; i < allData.length; i++) {
            if (allData[i].idleCode === idleCode) {
                selectedData = allData[i];
                break;
            }
        }

        var _this = this;
        var result = {
            idleCode: idleCode,
            idleName: idleName,
            idleMinute: idleMinute,
            scomment: ''
        };

        // AS-IS: IS_MCT_SCOMMENT='1' → McScomment 팝업
        if (selectedData && selectedData.isMctScomment === '1') {
            if (typeof mcScomment !== 'undefined') {
                mcScomment.open({
                    onConfirm: function(comment) {
                        result.scomment = comment;
                        _this._returnResult(result);
                    }
                });
                return;
            }
        }

        _this._returnResult(result);
    },

    /**
     * 결과 반환 및 닫기
     */
    _returnResult: function(result) {
        var handler = this._currentOnConfirm;
        this._currentOnCancel = null;  // confirm 성공 → onClose에서 cancel 호출 방지
        this.close();
        if (handler) handler(result);
    }
};
