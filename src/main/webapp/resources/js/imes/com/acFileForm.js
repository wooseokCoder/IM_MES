/**
 * ============================================================================
 * acFileForm.js - 도면/PLM 파일 목록 팝업 공통 모듈
 * ============================================================================
 * AS-IS: ProActive FileList 클래스 대응
 *   - DevExpress DataGrid(선택버튼, 파일ID, 파일명, 개정번호, 크기, 생성시간)
 *   → EasyUI DataGrid 동일 구조
 *
 * 사용법:
 *   1. 초기화 (DOM ready 후 1회):
 *      acFileForm.init();
 *      acFileForm.init({ onSelect: function(row) { ... } });
 *
 *   2. 팝업 열기 (rows는 호출 전에 fetch한 데이터):
 *      acFileForm.open({ rows: files });
 *      acFileForm.open({ rows: files, title: '도면 - ' + partCode,
 *                        onSelect: function(row) { ... } });
 *
 * @version 1.0 2026/03/03
 * ============================================================================
 */
var acFileForm = {
    _defaultOnSelect: null,  // init 시 등록한 기본 선택 핸들러
    _currentOnSelect: null,  // open 시 1회성 선택 핸들러
    _initialized: false,

    /**
     * 초기화 (DOM ready 후 1회 호출)
     * @param {Object}   [args]
     * @param {Function} [args.onSelect] - 기본 선택 핸들러: function(row) {}
     *                    row = { ifCode, fileName, revNo, fileSize, savePath, regDate }
     */
    init: function(args) {
        var _this = this;
        args = args || {};

        this._defaultOnSelect = args.onSelect || null;

        // 다이얼로그 설정 (JSP에서 class="easyui-dialog"로 자동 파싱됨)
        $('#acfile-search-dialog').dialog({
            title: '파일 목록',
            closed: true,
            modal: true,
            onOpen: function() {
                $(this).dialog('center');
                $(this).css('visibility', '');
                setTimeout(function() {
                    $('#acfile-search-grid').datagrid('resize');
                }, 100);
            }
        });

        // 파일 그리드 초기화
        // AS-IS: 선택버튼, 파일ID(숨김), 파일명, 개정번호, 크기, 생성시간 컬럼 구성
        $('#acfile-search-grid').datagrid({
            fit: true,
            border: false,
            singleSelect: true,
            striped: true,
            nowrap: true,
            rownumbers: false,
            columns: [[
                {field: 'sel',      title: '선택',      width: 50,  halign: 'center', align: 'center',
                    formatter: _acFileFormatSelect},
                {field: 'ifCode',   title: '파일ID',    width: 0,   hidden: true},
                {field: 'savePath', title: '경로',      width: 0,   hidden: true},
                {field: 'fileName', title: '파일명',    width: 300, halign: 'center', align: 'left'},
                {field: 'revNo',    title: '개정번호',  width: 80,  halign: 'center', align: 'center'},
                {field: 'fileSize', title: '크기',      width: 90,  halign: 'center', align: 'center',
                    formatter: _acFileFormatNumber},
                {field: 'regDate',  title: '생성시간',  width: 150, halign: 'center', align: 'center'}
            ]]
        });

        // 서버 오류 시 iframe → parent 에러 콜백
        window._smbDownloadError = function(msg) {
            $.messager.alert('오류', msg || '파일 다운로드 중 오류가 발생했습니다.', 'error');
        };

        this._initialized = true;
    },

    /**
     * 팝업 열기 (rows는 호출 전에 fetch한 데이터 전달)
     * @param {Object}   [opts]
     * @param {Array}    [opts.rows]     - 파일 목록 데이터 (fetch 결과)
     * @param {string}   [opts.title]   - 이번 호출에만 적용할 다이얼로그 제목
     * @param {Function} [opts.onSelect] - 이번 호출에만 적용할 선택 핸들러
     */
    open: function(opts) {
        opts = opts || {};
        this._currentOnSelect = opts.onSelect || null;
        this._currentPartCode = opts.partCode || '';

        if (opts.title) {
            $('#acfile-search-dialog').dialog('setTitle', opts.title);
        }

        // 그리드 데이터 초기화 후 로드
        var rows = opts.rows || [];
        $('#acfile-search-grid').datagrid('loadData', rows);
        $('#acfile-search-grid').datagrid('clearSelections');

        $('#acfile-search-dialog').dialog('open');
    },

    /** 팝업 닫기 */
    close: function() {
        $('#acfile-search-dialog').dialog('close');
    },

    /**
     * 내부: 행 선택 처리 — SMB 파일 다운로드 후 팝업 닫기
     *
     * location.href 방식은 서버 500 오류 시 현재 화면이 오류 페이지로 대체되므로
     * 숨겨진 iframe을 사용:
     *   - 정상: 브라우저 파일 저장 다이얼로그, 현재 화면 유지
     *   - 오류: iframe 내 스크립트가 parent._smbDownloadError() 호출 → 알림만 표시
     *
     * @param {Object} row - 선택된 파일 행 데이터 (fileName, savePath, ...)
     */
    _doSelect: function(row) {
        this.downloadFile(row.fileName, this._currentPartCode);

        this.close();

        var handler = this._currentOnSelect || this._defaultOnSelect;
        if (handler) handler(row);
        this._currentOnSelect = null;
    },

    /**
     * SMB 파일 다운로드 (공통)
     * 팝업 내 선택 시, 또는 파일 1개일 때 직접 호출 가능
     *
     * @param {string} fileName  - 파일명
     * @param {string} partCode  - 자재번호 (하위 폴더명)
     */
    downloadFile: function(fileName, partCode) {
        var downloadUrl = getUrl('/imes/common/smbFile/download.do')
                        + '?fileName=' + encodeURIComponent(fileName)
                        + '&partCode=' + encodeURIComponent(partCode || '');

        // hidden iframe으로 다운로드 (현재 화면 유지)
        var iframe = document.getElementById('_smbDownloadFrame');
        if (!iframe) {
            iframe = document.createElement('iframe');
            iframe.id = '_smbDownloadFrame';
            iframe.style.display = 'none';
            document.body.appendChild(iframe);
        }
        iframe.src = downloadUrl;
    }
};

/**
 * 선택 버튼 포맷터
 * AS-IS: FileList RepositoryItemButtonEdit (모든 행 활성, mat02a draw-btn-on 동일 스타일)
 */
function _acFileFormatSelect(val, row, index) {
    return '<a href="javascript:void(0)" class="grid-btn grid-btn-blue"'
         + ' onclick="_acFileSelectRow(' + index + ')" title="선택">&#10003;</a>';
}

/**
 * 선택 버튼 클릭 핸들러 (전역 — onclick 인라인에서 호출)
 * @param {number} index - 그리드 행 인덱스
 */
function _acFileSelectRow(index) {
    var row = $('#acfile-search-grid').datagrid('getRows')[index];
    if (row) acFileForm._doSelect(row);
}

/**
 * 천단위 콤마 포맷터
 */
function _acFileFormatNumber(value) {
    if (value == null || value === '') return '';
    var num = parseFloat(value);
    if (isNaN(num)) return value;
    return num.toLocaleString();
}

