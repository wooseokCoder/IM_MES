/**
 * ============================================================================
 * mcRegNg.js - NG 등록 공통 팝업
 * ============================================================================
 * AS-IS: McRegNg.cs - 부적합 등록 폼
 * 백엔드: Pop30aService.pop30aInsA() (POP30A_INS_A)
 *
 * 사용법:
 *   // 1. JSP에서 include
 *   <%@ include file="/WEB-INF/views/imes/com/mcRegNg.jsp" %>
 *
 *   // 2. 열기
 *   mcRegNg.open({
 *       woNo: row.woNo,
 *       mcCode: consts.currentMcCode,
 *       empCode: consts.currentEmpCode,
 *       procCode: row.procCode,
 *       itemCode: row.itemCode || row.partCode,
 *       saveUrl: getUrl('/imes/pop/pop30b/POP30A_INS_A.json'),
 *       codeUrl: getUrl('/imes/pop/pop30b/codeSearch.json'),  // (선택) 코드 조회
 *       onSave: function() { doSearch(); }
 *   });
 *
 * @version 1.0 2026/03/19
 * ============================================================================
 */
var mcRegNg = {
    _initialized: false,
    _saveUrl: null,
    _currentOnSave: null,
    _currentParams: null,

    /**
     * 초기화 (1회)
     */
    init: function() {
        if (this._initialized) return;
        var _this = this;

        // 다이얼로그 파싱
        $.parser.parse($('#mrng-dialog'));

        // 다이얼로그 설정
        $('#mrng-dialog').dialog({
            title: '부적합 등록',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).css('visibility', '');
                $('#mrng-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
            },
            onClose: function() {
                _this._clear();
            }
        });

        // 등록 버튼
        $('#mrng-save-button').bind('click', function() { _this._doSave(); });
        // 닫기 버튼
        $('#mrng-close-button').bind('click', function() { _this.close(); });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     * @param {Object} opts
     * @param {string}   opts.woNo      - 작업오더번호
     * @param {string}   opts.mcCode    - 설비코드
     * @param {string}   opts.empCode   - 작업자코드
     * @param {string}   opts.procCode  - 공정코드
     * @param {string}   opts.itemCode  - 품목코드
     * @param {string}   opts.saveUrl   - 부적합 등록 API URL
     * @param {string}   [opts.codeUrl] - 코드 조회 API URL (Q002/Q001)
     * @param {Function} [opts.onSave]  - 등록 후 콜백
     */
    open: function(opts) {
        opts = opts || {};

        if (!this._initialized) {
            this.init();
        }

        this._saveUrl = opts.saveUrl || null;
        this._currentOnSave = opts.onSave || null;
        this._currentParams = {
            woNo: opts.woNo || '',
            mcCode: opts.mcCode || '',
            empCode: opts.empCode || '',
            procCode: opts.procCode || '',
            itemCode: opts.itemCode || ''
        };

        // 필드 초기화
        this._clear();

        // 작업자 표시
        $('#mrng-emp-code').textbox('setValue', opts.empCode || '');

        // 코드 로드 (불량유형 Q002)
        if (opts.codeUrl) {
            this._loadCodes(opts.codeUrl);
        }

        $('#mrng-dialog').dialog('open');
    },

    /**
     * 닫기
     */
    close: function() {
        $('#mrng-dialog').dialog('close');
    },

    /**
     * 코드 로드 (Q002: 불량유형, Q001: 상세유형)
     */
    _loadCodes: function(codeUrl) {
        // 불량유형 (Q002) 로드
        $.ajax({
            url: codeUrl,
            type: 'POST',
            data: { codeGrup: 'Q002' },
            dataType: 'json',
            success: function(data) {
                var rows = data.rows || data || [];
                $('#mrng-master-cause').combobox('loadData', rows);
            }
        });

        // 상세유형 (Q001) 로드
        $.ajax({
            url: codeUrl,
            type: 'POST',
            data: { codeGrup: 'Q001' },
            dataType: 'json',
            success: function(data) {
                var rows = data.rows || data || [];
                $('#mrng-detail-cause').combobox('loadData', rows);
            }
        });
    },

    /**
     * 등록 처리
     */
    _doSave: function() {
        if (!this._saveUrl) {
            $.messager.alert('오류', '등록 API가 설정되지 않았습니다.', 'error');
            return;
        }

        var masterCause = $('#mrng-master-cause').combobox('getValue');
        var detailCause = $('#mrng-detail-cause').combobox('getValue');
        var quantity = $('#mrng-quantity').numberbox('getValue');
        var contents = $('#mrng-contents').val() || '';

        if (!contents) {
            $.messager.alert('알림', '불량 내용을 입력하세요.', 'warning');
            return;
        }

        var _this = this;

        $.messager.confirm('확인', '부적합을 등록하시겠습니까?', function(r) {
            if (!r) return;

            var params = {
                woNo: _this._currentParams.woNo,
                mcCode: _this._currentParams.mcCode,
                empCode: _this._currentParams.empCode,
                procCode: _this._currentParams.procCode,
                partCode: _this._currentParams.itemCode,
                masterCause: masterCause,
                detailCause: detailCause,
                quantity: quantity,
                reqContents: contents
            };

            $.ajax({
                url: _this._saveUrl,
                type: 'POST',
                data: params,
                dataType: 'json',
                success: function(result) {
                    if (result && result.success) {
                        $.messager.alert('알림', '부적합이 등록되었습니다.', 'info', function() {
                            var handler = _this._currentOnSave;
                            _this.close();
                            if (handler) handler();
                        });
                    } else {
                        $.messager.alert('오류', (result && result.error) || '등록 실패', 'error');
                    }
                },
                error: function() {
                    $.messager.alert('오류', '등록 중 오류가 발생했습니다.', 'error');
                }
            });
        });
    },

    /**
     * 필드 초기화
     */
    _clear: function() {
        this._currentOnSave = null;
        try { $('#mrng-master-cause').combobox('setValue', ''); } catch(e) {}
        try { $('#mrng-detail-cause').combobox('setValue', ''); } catch(e) {}
        try { $('#mrng-quantity').numberbox('setValue', 1); } catch(e) {}
        try { $('#mrng-emp-code').textbox('setValue', ''); } catch(e) {}
        $('#mrng-contents').val('');
    }
};
