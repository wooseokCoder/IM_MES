/**
 * ============================================================================
 * acWeekDate.js - 주간/일자 선택기 공통 모듈
 * ============================================================================
 * AS-IS: acWeekDate (C# UserControl - acWeekDate.cs)
 *   컨트롤 배치: cboSelect → dtStart → "~" → dtEnd → txtWeekNo → btnPrev → btnNext
 *   모드: DATE(자유 날짜) / WEEK(주간 스냅, 월~일)
 *
 * 사용법:
 *   1. JSP에 acWeekDate.jsp include (컴포넌트 HTML 자동 생성)
 *   2. JS 초기화:
 *      acWeekDate.init({
 *          prefix: 'wd1',                  // 컴포넌트 ID 접두사
 *          mode: 'WEEK',                   // 초기 모드 ('DATE' 또는 'WEEK')
 *          weekOnly: false,                // true: 주차 모드 고정 (콤보 비활성)
 *          onPrev: function() { ... },     // < 버튼 클릭 콜백
 *          onNext: function() { ... }      // > 버튼 클릭 콜백
 *      });
 *
 *   3. 값 읽기:
 *      acWeekDate.getStartDate('wd1')  // '2026-03-03'
 *      acWeekDate.getEndDate('wd1')    // '2026-03-09'
 *      acWeekDate.getMode('wd1')       // 'WEEK' 또는 'DATE'
 *
 * @version 1.0 2026/03/04
 * ============================================================================
 */
var acWeekDate = {

    _instances: {},  // prefix별 설정 저장

    /**
     * 초기화
     * @param {Object}   opts
     * @param {string}   opts.prefix    - 컴포넌트 ID 접두사 (필수)
     * @param {string}   [opts.mode]    - 초기 모드: 'DATE' | 'WEEK' (기본: 'WEEK')
     * @param {boolean}  [opts.weekOnly]- true면 주차 모드 고정 (콤보 readonly)
     * @param {Function} [opts.onPrev]  - 이전 주 이동 후 콜백
     * @param {Function} [opts.onNext]  - 다음 주 이동 후 콜백
     */
    init: function(opts) {
        opts = opts || {};
        var prefix = opts.prefix;
        if (!prefix) return;

        var mode = opts.mode || 'WEEK';
        var inst = {
            prefix: prefix,
            onPrev: opts.onPrev || null,
            onNext: opts.onNext || null
        };
        this._instances[prefix] = inst;

        var _this = this;

        // 모드 콤보
        $('#' + prefix + '_selectMode').combobox({
            data: [
                { value: 'DATE', text: '일자' },
                { value: 'WEEK', text: '주차' }
            ],
            valueField: 'value',
            textField: 'text',
            value: mode,
            editable: false,
            onSelect: function(record) {
                _this._onModeChanged(prefix, record.value);
            }
        });

        // weekOnly: 콤보 비활성 (AS-IS: SetWeekOnly)
        if (opts.weekOnly) {
            $('#' + prefix + '_selectMode').combobox('disable');
        }

        // datebox onSelect 바인딩
        $('#' + prefix + '_startDate').datebox({
            onSelect: function(date) {
                if (_this.getMode(prefix) === 'WEEK') {
                    _this._setWeekNo(prefix, date);
                }
            }
        });
        $('#' + prefix + '_endDate').datebox({
            onSelect: function(date) {
                if (_this.getMode(prefix) === 'WEEK') {
                    _this._setWeekNo(prefix, date);
                }
            }
        });

        // 버튼 바인딩
        $('#' + prefix + '_btnPrev').bind('click', function() { _this._movePrev(prefix); });
        $('#' + prefix + '_btnNext').bind('click', function() { _this._moveNext(prefix); });

        // 초기 날짜 설정
        if (mode === 'WEEK') {
            this._setWeekNo(prefix, new Date());
        } else {
            // DATE 모드: AS-IS와 동일하게 오늘 날짜 기본값 설정
            var today = this._formatDate(new Date());
            $('#' + prefix + '_startDate').datebox('setValue', today);
            $('#' + prefix + '_endDate').datebox('setValue', today);
            // DATE 모드 UI 상태 적용
            this._onModeChanged(prefix, 'DATE');
        }
    },

    // ========================================================================
    // Public API
    // ========================================================================

    /** 시작일 값 (yyyy-MM-dd) */
    getStartDate: function(prefix) {
        return $('#' + prefix + '_startDate').datebox('getValue');
    },

    /** 종료일 값 (yyyy-MM-dd) */
    getEndDate: function(prefix) {
        return $('#' + prefix + '_endDate').datebox('getValue');
    },

    /** 현재 모드 ('DATE' | 'WEEK') */
    getMode: function(prefix) {
        return $('#' + prefix + '_selectMode').combobox('getValue');
    },

    // ========================================================================
    // Private - 모드 변경
    // ========================================================================

    /**
     * 모드 변경 처리
     * AS-IS: cboSelect_SelectedIndexChanged
     */
    _onModeChanged: function(prefix, mode) {
        if (mode === 'WEEK') {
            $('#' + prefix + '_weekNo').textbox('enable');
            $('#' + prefix + '_btnPrev').linkbutton('enable');
            $('#' + prefix + '_btnNext').linkbutton('enable');
            var startStr = this.getStartDate(prefix);
            var baseDate = startStr ? this._parseDate(startStr) : new Date();
            this._setWeekNo(prefix, baseDate);
        } else {
            $('#' + prefix + '_weekNo').textbox('setValue', '');
            $('#' + prefix + '_weekNo').textbox('disable');
            $('#' + prefix + '_btnPrev').linkbutton('disable');
            $('#' + prefix + '_btnNext').linkbutton('disable');
        }
    },

    // ========================================================================
    // Private - 주차 계산
    // ========================================================================

    /**
     * 주차 설정 (핵심)
     * AS-IS: acWeekDate.SetWeekNo(DateTime s_date)
     */
    _setWeekNo: function(prefix, date) {
        var week = this._getWeekRange(date);
        $('#' + prefix + '_startDate').datebox('setValue', this._formatDate(week.monday));
        $('#' + prefix + '_endDate').datebox('setValue', this._formatDate(week.sunday));

        var weekNum = this._getWeekOfYear(date);
        var y = week.monday.getFullYear();
        var m = ('0' + (week.monday.getMonth() + 1)).slice(-2);
        $('#' + prefix + '_weekNo').textbox('setValue', y + '-' + m + '  ' + weekNum + '주차');
    },

    /**
     * 해당 주의 월요일~일요일 계산
     * AS-IS: ExtensionMethods.GetJuFullStartEndDate
     */
    _getWeekRange: function(date) {
        var day = date.getDay();
        var num = day - 1;
        if (num < 0) num = 6;

        var monday = new Date(date);
        monday.setDate(date.getDate() - num);
        var sunday = new Date(monday);
        sunday.setDate(monday.getDate() + 6);

        return { monday: monday, sunday: sunday };
    },

    /**
     * ISO 주차 번호 계산
     * AS-IS: ExtensionMethods.GetJuCha → GetWeekOfYear
     *   CalendarWeekRule.FirstFourDayWeek, Monday 시작
     */
    _getWeekOfYear: function(date) {
        var target = new Date(date.valueOf());
        var dayNr = (date.getDay() + 6) % 7;
        target.setDate(target.getDate() - dayNr + 3);

        var firstThursday = new Date(target.getFullYear(), 0, 4);
        var firstDayNr = (firstThursday.getDay() + 6) % 7;
        firstThursday.setDate(firstThursday.getDate() - firstDayNr + 3);

        return 1 + Math.round((target - firstThursday) / (7 * 24 * 60 * 60 * 1000));
    },

    // ========================================================================
    // Private - 이전/다음 주 이동
    // ========================================================================

    /** 이전 주 이동 (AS-IS: btnPrev_Click) */
    _movePrev: function(prefix) {
        if (this.getMode(prefix) !== 'WEEK') return;
        var startStr = this.getStartDate(prefix);
        if (!startStr) return;

        var prevDate = this._parseDate(startStr);
        prevDate.setDate(prevDate.getDate() - 7);
        this._setWeekNo(prefix, prevDate);

        var inst = this._instances[prefix];
        if (inst && inst.onPrev) inst.onPrev();
    },

    /** 다음 주 이동 (AS-IS: btnNext_Click) */
    _moveNext: function(prefix) {
        if (this.getMode(prefix) !== 'WEEK') return;
        var startStr = this.getStartDate(prefix);
        if (!startStr) return;

        var nextDate = this._parseDate(startStr);
        nextDate.setDate(nextDate.getDate() + 7);
        this._setWeekNo(prefix, nextDate);

        var inst = this._instances[prefix];
        if (inst && inst.onNext) inst.onNext();
    },

    // ========================================================================
    // Private - 유틸
    // ========================================================================

    _formatDate: function(d) {
        var y = d.getFullYear();
        var m = ('0' + (d.getMonth() + 1)).slice(-2);
        var dd = ('0' + d.getDate()).slice(-2);
        return y + '-' + m + '-' + dd;
    },

    _parseDate: function(str) {
        var parts = str.split('-');
        return new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
    }
};
