/**
 * ============================================================================
 * mcScomment.js - 설비점검 의견 공통 팝업
 * ============================================================================
 * AS-IS: McScomment.cs - WorkIdle 하위 팝업
 *        MCT_SCOMMENT textarea 입력 후 DataSet 반환
 *
 * 사용법:
 *   // 1. JSP에서 include
 *   <%@ include file="/WEB-INF/views/imes/com/mcScomment.jsp" %>
 *
 *   // 2. 열기
 *   mcScomment.open({
 *       onConfirm: function(comment) {
 *           // comment = 입력된 상세원인 텍스트
 *       }
 *   });
 *
 * @version 1.0 2026/03/19
 * ============================================================================
 */
var mcScomment = {
    _initialized: false,
    _currentOnConfirm: null,

    /**
     * 초기화 (1회)
     */
    init: function() {
        if (this._initialized) return;
        var _this = this;

        // 다이얼로그 파싱
        $.parser.parse($('#mcs-dialog'));

        // 다이얼로그 설정
        $('#mcs-dialog').dialog({
            title: '상세원인',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).css('visibility', '');
                $('#mcs-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
                // 포커스
                setTimeout(function() { $('#mcs-comment').focus(); }, 100);
            },
            onClose: function() {
                _this._currentOnConfirm = null;
                $('#mcs-comment').val('');
            }
        });

        // 확인 버튼
        $('#mcs-confirm-button').bind('click', function() { _this._doConfirm(); });
        // 닫기 버튼
        $('#mcs-close-button').bind('click', function() { _this.close(); });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     * @param {Object} opts
     * @param {Function} opts.onConfirm - 확인 콜백 (comment: string)
     */
    open: function(opts) {
        opts = opts || {};

        if (!this._initialized) {
            this.init();
        }

        this._currentOnConfirm = opts.onConfirm || null;
        $('#mcs-comment').val('');

        $('#mcs-dialog').dialog('open');
    },

    /**
     * 닫기
     */
    close: function() {
        $('#mcs-dialog').dialog('close');
    },

    /**
     * 확인 처리
     */
    _doConfirm: function() {
        var comment = $('#mcs-comment').val() || '';
        var handler = this._currentOnConfirm;
        this.close();
        if (handler) handler(comment);
    }
};
