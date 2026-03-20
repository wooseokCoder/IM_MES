/**
 * ============================================================================
 * mcDailyCheck.js - 일일점검 공통 팝업
 * ============================================================================
 * AS-IS: McDailyCheck.cs - POP30A/POP30B 등 여러 화면에서 공통 사용
 *
 * 사용법:
 *   <%@ include file="/WEB-INF/views/imes/com/mcDailyCheck.jsp" %>
 *
 *   mcDailyCheck.open({
 *       mcCode: consts.currentMcCode,
 *       empCode: consts.currentEmpCode,
 *       searchUrl: getUrl('/imes/pop/pop30b/POP30B_SER5.json'),
 *       saveUrl: getUrl('/imes/pop/pop30b/POP30B_INS3.json'),
 *       onSave: function() { checkDailyInspection(consts.currentMcCode); }
 *   });
 *
 * AS-IS 근거:
 *   - 타이틀: "일일점검" (McDailyCheck.cs Line 395: this.Text = "일일점검")
 *   - 크기: 870x627 (McDailyCheck.cs Line 388: base.ClientSize = new Size(870, 627))
 *   - 버튼: 저장(Line 277) + 확인(Line 309)
 *   - 그리드 컬럼 9개 (Line 75-83), visible 6개, hidden 3개
 *   - 셀 병합: MDCR_TYPE, MDCR_CONTENTS (Line 84-85)
 *   - 편집 가능: MDCR_RESULT, MDCR_SCOMMENT (Line 81-82: allowEdit: true)
 *   - 조회: POP30B_SER5 (Line 137) → TPOP_MC_DAILY_CHECK_RESULT_QUERY1 / TSTD_MC_DAILY_CHECK_QUERY2
 *   - 저장: POP30B_INS3 (Line 194) → SER(존재확인) → UPD or INS
 *   - 저장 콜백: DialogResult.OK (Line 201) → 바로 닫기
 *   - 확인 버튼: DialogResult.Cancel (Line 211) → 닫기
 *
 * @version 1.0 2026/03/19
 * ============================================================================
 */

// ============================================================================
// 참고: editCell 확장은 사용하지 않음
// mergeCells와 beginEdit 충돌 방지를 위해 직접 input 생성 방식 사용
// ============================================================================

// ============================================================================
// 전역 변수
// ============================================================================
var _mdcEditIndex = undefined;
var _mdcEditField = undefined;

/**
 * 편집 가능 셀 배경색
 * AS-IS: acGridView1.NoApplyEditableCellColor = false (Line 292)
 */
function _mdcEditableStyler(value, row, index) {
    return 'background-color:#FFFFCC;';
}

/**
 * 셀 편집 시작 (mergeCells 보존 방식)
 * beginEdit 대신 직접 td에 input 생성 → 병합 깨짐 방지
 */
function _mdcStartCellEdit(index, field) {
    // 이전 편집 종료
    _mdcEndCellEdit();

    var $grid = $('#mdc-grid');
    var rows = $grid.datagrid('getRows');
    var row = rows[index];
    if (!row) return;

    // 해당 td 찾기
    var $tr = $grid.datagrid('getPanel').find('.datagrid-body tr[datagrid-row-index=' + index + ']');
    var fieldIdx = $grid.datagrid('getColumnFields').indexOf(field);
    var $td = $tr.find('td[field=' + field + ']');
    var $cell = $td.find('.datagrid-cell');
    if (!$cell.length) return;

    var currentVal = row[field] || '';

    // input 생성 (DB 컬럼 길이 제한: MDCR_RESULT/MDCR_SCOMMENT VARCHAR(50))
    var $input = $('<input type="text" class="mdc-cell-input" maxlength="50" style="width:100%;height:100%;border:1px solid #4b9ce2;padding:2px;box-sizing:border-box;text-align:center;font-size:inherit;"/>');
    $input.val(currentVal);

    // 기존 텍스트 숨기고 input 표시
    $cell.data('orig-html', $cell.html());
    $cell.html('').append($input);
    $input.focus().select();

    _mdcEditIndex = index;
    _mdcEditField = field;

    // blur 시 편집 종료
    $input.on('blur', function() {
        _mdcEndCellEdit();
    });

    // 키보드 네비게이션
    $input.on('keydown', function(e) {
        _mdcHandleKeyNav(e);
    });
}

/**
 * 셀 편집 종료 - input 값을 row 데이터에 반영
 * AS-IS: acGridView1.EndEditor() (McDailyCheck.cs Line 159)
 */
function _mdcEndCellEdit() {
    if (_mdcEditIndex === undefined) return;

    var $grid = $('#mdc-grid');
    var rows = $grid.datagrid('getRows');
    var row = rows[_mdcEditIndex];
    if (!row) { _mdcEditIndex = undefined; _mdcEditField = undefined; return; }

    var $tr = $grid.datagrid('getPanel').find('.datagrid-body tr[datagrid-row-index=' + _mdcEditIndex + ']');
    var $td = $tr.find('td[field=' + _mdcEditField + ']');
    var $cell = $td.find('.datagrid-cell');
    var $input = $cell.find('.mdc-cell-input');

    if ($input.length) {
        // input 값 → row 데이터 반영
        var newVal = $input.val();
        row[_mdcEditField] = newVal;

        // input 제거, 텍스트 복원
        $cell.html(newVal || '');
    }

    _mdcEditIndex = undefined;
    _mdcEditField = undefined;
}

/**
 * 전체 편집 종료 (저장 전 호출)
 */
function _mdcEndEditing() {
    _mdcEndCellEdit();
    return true;
}

// ============================================================================
// 셀 병합 함수 (AS-IS: AllowCellMerge + CellMerge 이벤트)
// EasyUI datagrid.mergeCells 메서드로 rowspan 병합 구현
// ============================================================================
function _mdcMergeCells(field) {
    var rows = $('#mdc-grid').datagrid('getRows');
    if (!rows || rows.length === 0) return;

    var startIndex = 0;
    var span = 1;

    for (var i = 1; i <= rows.length; i++) {
        if (i < rows.length && rows[i][field] === rows[startIndex][field]) {
            span++;
        } else {
            if (span > 1) {
                $('#mdc-grid').datagrid('mergeCells', {
                    index: startIndex,
                    field: field,
                    rowspan: span
                });
            }
            startIndex = i;
            span = 1;
        }
    }
}

// ============================================================================
// 편집 가능 컬럼 목록 (방향키 네비게이션용)
// ============================================================================
var _mdcEditableFields = ['mdcrResult', 'mdcrScomment'];

/**
 * 방향키 네비게이션 핸들러
 * 위/아래: 같은 컬럼 이전/다음 행으로 이동
 * 좌/우: 편집 가능 컬럼 간 이동
 * Tab: 다음 편집 가능 셀로 이동
 */
function _mdcHandleKeyNav(e) {
    if (_mdcEditIndex === undefined || _mdcEditField === undefined) return;

    var keyCode = e.keyCode;
    // 38=Up, 40=Down, 37=Left, 39=Right, 9=Tab
    if (keyCode !== 38 && keyCode !== 40 && keyCode !== 37 && keyCode !== 39 && keyCode !== 9) return;

    var rows = $('#mdc-grid').datagrid('getRows');
    var newIndex = _mdcEditIndex;
    var newField = _mdcEditField;
    var fieldIdx = _mdcEditableFields.indexOf(_mdcEditField);

    if (keyCode === 38) {
        // Up
        newIndex = Math.max(0, _mdcEditIndex - 1);
    } else if (keyCode === 40) {
        // Down
        newIndex = Math.min(rows.length - 1, _mdcEditIndex + 1);
    } else if (keyCode === 37) {
        // Left → 이전 편집 컬럼
        if (fieldIdx > 0) {
            newField = _mdcEditableFields[fieldIdx - 1];
        }
    } else if (keyCode === 39 || keyCode === 9) {
        // Right / Tab → 다음 편집 컬럼, 마지막이면 다음 행 첫 컬럼
        if (fieldIdx < _mdcEditableFields.length - 1) {
            newField = _mdcEditableFields[fieldIdx + 1];
        } else if (newIndex < rows.length - 1) {
            newIndex = _mdcEditIndex + 1;
            newField = _mdcEditableFields[0];
        }
    }

    if (newIndex !== _mdcEditIndex || newField !== _mdcEditField) {
        e.preventDefault();
        e.stopPropagation();
        // blur 이벤트보다 먼저 처리하기 위해 setTimeout
        setTimeout(function() {
            _mdcStartCellEdit(newIndex, newField);
        }, 0);
    }
}

// ============================================================================
// mcDailyCheck 네임스페이스
// ============================================================================
var mcDailyCheck = {
    _initialized: false,
    _searchUrl: null,
    _saveUrl: null,
    _currentOnSave: null,
    _mcCode: null,
    _empCode: null,

    /**
     * 초기화 (1회)
     */
    init: function() {
        if (this._initialized) return;
        var _this = this;

        // 다이얼로그 파싱 (acWorkerForm 패턴)
        $.parser.parse($('#mdc-dialog'));

        // AS-IS: this.Text = "일일점검" (Line 395)
        $('#mdc-dialog').dialog({
            title   : '일일점검',
            closed  : true,
            modal   : true,
            onOpen  : function() {
                $(this).css('visibility', '');
                $('#mdc-dialog-buttons').css('visibility', '');
                $(this).dialog('center');
            },
            onClose : function() {
                _this._clear();
            }
        });

        /**
         * 그리드 초기화
         * AS-IS 컬럼 정의 (McDailyCheck.cs Line 75-83):
         *   Line 75: AddTextEdit("MDCR_NO",       "점검항목ID", allowEdit:false, visible:false)  → hidden
         *   Line 76: AddTextEdit("MDCR_TYPE",     "구분",       allowEdit:false, visible:true)   → 셀 병합(Line 84)
         *   Line 77: AddTextEdit("MDCR_NUM",      "점검번호",   allowEdit:false, visible:false)  → hidden
         *   Line 78: AddMemoEdit("MDCR_CONTENTS", "점검항목",   allowEdit:false, visible:true)   → 셀 병합(Line 85)
         *   Line 79: AddMemoEdit("MDCR_CHECK",    "점검내용",   allowEdit:false, visible:true)
         *   Line 80: AddTextEdit("MDCR_MEANS",    "점검방법",   allowEdit:false, visible:true)
         *   Line 81: AddTextEdit("MDCR_RESULT",   "결과",       allowEdit:true,  visible:true)   → 편집 가능
         *   Line 82: AddTextEdit("MDCR_SCOMMENT", "비고",       allowEdit:true,  visible:true)   → 편집 가능
         *   Line 83: AddTextEdit("MDCR_SEQ",      "순번",       allowEdit:false, visible:false)  → hidden
         *
         * AS-IS 셀 병합 (Line 84-85, 92-121):
         *   acGridView1.Columns["MDCR_TYPE"].OptionsColumn.AllowMerge = True
         *   acGridView1.Columns["MDCR_CONTENTS"].OptionsColumn.AllowMerge = True
         *   → 연속 행의 값이 동일하면 셀 병합 (CellMerge 이벤트)
         *
         * AS-IS 그리드 옵션 (Line 288-301):
         *   ColumnPanelRowHeight = 25 (헤더 높이)
         *   RowAutoHeight = true     (행 높이 자동)
         *   RowHeight = 25           (기본 행 높이)
         *   ShowGroupPanel = false   (그룹 패널 숨김)
         *   ShowIndicator = false    (행 표시기 숨김)
         *   EnableAppearanceEvenRow = true (짝수행 색상)
         */
        $('#mdc-grid').datagrid({
            fit       : true,        // 다이얼로그 영역에 맞춤 (overflow 방지)
            striped   : false,     // AS-IS: EnableAppearanceEvenRow=true → 병합 시각 충돌로 false
            singleSelect : true,
            pagination: false,
            rownumbers: false,     // AS-IS: ShowIndicator = false (Line 299)
            nowrap    : false,     // AS-IS: RowAutoHeight = true (Line 297) → 멀티라인 대응
            fitColumns: true,
            columns   : [[
                // AS-IS Line 76: "MDCR_TYPE", "구분", visible:true, allowEdit:false
                // AS-IS Line 84: AllowMerge = True → mergeCells로 실제 rowspan 병합
                {field:'mdcrType',     title:'구분',     width:80,  halign:'center', align:'center'},
                // AS-IS Line 78: "MDCR_CONTENTS", "점검항목", MemoEdit, visible:true, allowEdit:false
                // AS-IS Line 85: AllowMerge = True → mergeCells로 실제 rowspan 병합
                // AS-IS: MemoEdit → 줄바꿈 지원 (\n → <br>)
                {field:'mdcrContents', title:'점검항목',  width:100, halign:'center', align:'center',
                    formatter: function(val) {
                        return val ? val.replace(/\n/g, '<br>') : '';
                    }
                },
                // AS-IS Line 79: "MDCR_CHECK", "점검내용", MemoEdit, visible:true, allowEdit:false
                // AS-IS: MemoEdit → 줄바꿈 지원 (\n → <br>)
                {field:'mdcrCheck',    title:'점검내용',  width:200, halign:'center', align:'center',
                    formatter: function(val) {
                        return val ? val.replace(/\n/g, '<br>') : '';
                    }
                },
                // AS-IS Line 80: "MDCR_MEANS", "점검방법", TextEdit, visible:true, allowEdit:false
                {field:'mdcrMeans',    title:'점검방법',  width:100, halign:'center', align:'center'},
                // AS-IS Line 81: "MDCR_RESULT", "결과", TextEdit, visible:true, allowEdit:true
                // DB: MDCR_RESULT VARCHAR(50)
                {field:'mdcrResult',   title:'결과',     width:60,  halign:'center', align:'center',
                    editor: {type:'textbox', options:{validType:'length[0,50]'}},
                    styler: _mdcEditableStyler
                },
                // AS-IS Line 82: "MDCR_SCOMMENT", "비고", TextEdit, visible:true, allowEdit:true
                // DB: MDCR_SCOMMENT VARCHAR(50)
                {field:'mdcrScomment', title:'비고',     width:80,  halign:'center', align:'center',
                    editor: {type:'textbox', options:{validType:'length[0,50]'}},
                    styler: _mdcEditableStyler
                },
                // AS-IS Line 75: "MDCR_NO", visible:false (PK)
                {field:'mdcrNo',   hidden: true},
                // AS-IS Line 77: "MDCR_NUM", visible:false
                {field:'mdcrNum',  hidden: true},
                // AS-IS Line 83: "MDCR_SEQ", visible:false
                {field:'mdcrSeq',  hidden: true}
            ]],
            onLoadSuccess: function() {
                _mdcEditIndex = undefined;
                _mdcEditField = undefined;
                // AS-IS: 셀 병합 (Line 84-85, 92-121)
                // MDCR_TYPE, MDCR_CONTENTS 연속 같은 값 → rowspan 병합
                _mdcMergeCells('mdcrType');
                _mdcMergeCells('mdcrContents');
            },
            // 셀 클릭 시 편집 가능 컬럼이면 인라인 input 생성
            // mergeCells와 beginEdit 충돌 방지: EasyUI beginEdit 사용 안 함
            // 직접 td에 input을 생성/제거하는 방식
            onClickCell: function(index, field, value) {
                if (_mdcEditableFields.indexOf(field) < 0) return;
                _mdcStartCellEdit(index, field);
            }
        });

        // 버튼 이벤트 바인딩
        // AS-IS Line 281: btnSave.Click += btnSave_Click → SAVE()
        $('#mdc-save-button').bind('click', function() { _this._doSave(); });
        // AS-IS Line 313: btnOk.Click += btnOk_Click → DialogResult = Cancel
        $('#mdc-close-button').bind('click', function() { _this.close(); });

        this._initialized = true;
    },

    /**
     * 팝업 열기
     * AS-IS: McDailyCheck(linkData) → DialogInitComplete() → search()
     *
     * @param {Object} opts
     * @param {string}   opts.mcCode    - 설비코드 (AS-IS: linkData["MC_CODE"] Line 132)
     * @param {string}   opts.empCode   - 작업자코드
     * @param {string}   opts.searchUrl - 조회 API (POP30B_SER5)
     * @param {string}   opts.saveUrl   - 저장 API (POP30B_INS3)
     * @param {Function} [opts.onSave]  - 저장 후 콜백
     */
    open: function(opts) {
        opts = opts || {};

        if (!this._initialized) {
            this.init();
        }

        this._searchUrl = opts.searchUrl || null;
        this._saveUrl = opts.saveUrl || null;
        this._currentOnSave = opts.onSave || null;
        this._mcCode = opts.mcCode || '';
        this._empCode = opts.empCode || '';

        // 그리드 초기화
        $('#mdc-grid').datagrid('loadData', []);

        /**
         * AS-IS: search() (McDailyCheck.cs Line 123-138)
         *   DataTable에 PLT_CODE, MDCR_MC_CODE, MDCR_DATE 세팅
         *   → BizRun.ExecuteService("POP30B_SER5", ...)
         *   → QuickSearch 콜백 → 그리드에 RSLTDT 바인딩
         *
         * AS-IS BIZ: POP30B_SER5 (POP30B.cs Line 73-98)
         *   1. DATA_FLAG=0 세팅
         *   2. TPOP_MC_DAILY_CHECK_RESULT_QUERY1 호출
         *   3. 결과 있으면 → 기존 데이터 반환
         *   4. 결과 없으면 → TSTD_MC_DAILY_CHECK_QUERY2 (템플릿) 반환
         */
        if (this._searchUrl) {
            var _this = this;
            $.ajax({
                url: _this._searchUrl,
                type: 'POST',
                data: { mcCode: _this._mcCode },
                dataType: 'json',
                success: function(data) {
                    // Service returns { rows: { rows: [...], isNew: boolean } }
                    var wrapper = data.rows || data || {};
                    var rows = wrapper.rows || [];
                    if (!$.isArray(rows)) rows = [];
                    $('#mdc-grid').datagrid('loadData', {total: rows.length, rows: rows});
                },
                error: function() {
                    $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
                }
            });
        }

        $('#mdc-dialog').dialog('open');
    },

    /**
     * 닫기
     * AS-IS: btnOk_Click → DialogResult = Cancel (Line 211)
     */
    close: function() {
        $('#mdc-dialog').dialog('close');
    },

    /**
     * 저장
     * AS-IS: SAVE() (McDailyCheck.cs Line 157-195)
     *   1. acGridView1.EndEditor() (Line 159)
     *   2. linkData에서 DATE, MC_CODE 추출 (Line 160)
     *   3. 그리드 DataSource에서 전체 행 추출 (Line 161)
     *   4. 각 행에 PLT_CODE, MDCR_DATE, MDCR_MC_CODE 세팅 (Line 178-181)
     *   5. 전체 컬럼 복사: MDCR_NO~MDCR_SEQ (Line 179-189)
     *   6. BizRun.ExecuteService("POP30B_INS3", ...) (Line 194)
     *   7. 콜백 QuickSaveClose: DialogResult.OK (Line 201) → 바로 닫기
     *
     * AS-IS BIZ: POP30B_INS3 (POP30B.cs Line 679-693)
     *   foreach row:
     *     1. SER(PLT_CODE+MDCR_NO) → 존재 확인
     *     2. 존재 → UPD (전체 컬럼 UPDATE)
     *     3. 미존재 → MDCR_NO 채번("MDCR") → INS
     */
    _doSave: function() {
        _mdcEndEditing();
        var rows = $('#mdc-grid').datagrid('getRows');
        if (!rows || rows.length === 0) {
            $.messager.alert('알림', '저장할 데이터가 없습니다.', 'info');
            return;
        }

        if (!this._saveUrl) return;
        var _this = this;

        $.ajax({
            url: _this._saveUrl,
            type: 'POST',
            data: {
                mcCode: _this._mcCode,
                empCode: _this._empCode,
                models: JSON.stringify(rows)
            },
            dataType: 'json',
            success: function(result) {
                if (result && result.success) {
                    // AS-IS: QuickSaveClose → DialogResult.OK (Line 201) → 바로 닫기
                    var handler = _this._currentOnSave;
                    _this.close();
                    if (handler) handler();
                } else {
                    $.messager.alert('오류', (result && result.error) || '저장 실패', 'error');
                }
            },
            error: function() {
                $.messager.alert('오류', '저장 중 오류가 발생했습니다.', 'error');
            }
        });
    },

    /**
     * 필드 초기화
     */
    _clear: function() {
        _mdcEndEditing();
        _mdcEditIndex = undefined;
        _mdcEditField = undefined;
        this._currentOnSave = null;
        $('#mdc-grid').datagrid('loadData', []);
    }
};
