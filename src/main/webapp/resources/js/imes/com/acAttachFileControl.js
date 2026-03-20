/**
 * ============================================================================
 * acAttachFileControl.js - 파일 첨부 컨트롤 공통 모듈
 * ============================================================================
 * AS-IS: ProActive acAttachFileControl.cs 웹 전환
 *
 * 탭 구성 (원본 acTabControl1 대응):
 *   Tab1: 첨부파일목록  — FileGridView         (활성 파일, DATA_FLAG=0)
 *   Tab2: 전송 대기파일 — FileTransferGridView  (웹: 업로드 큐 스텁)
 *   Tab3: 삭제이력      — FileDelHistoryGridView (DATA_FLAG=1)
 *
 * 사용법:
 *   1) JSP include:
 *      <%@ include file="/WEB-INF/views/imes/com/acAttachFileControl.jsp" %>
 *
 *   2) 초기화 (DOM ready 후 1회):
 *      acAttachFileControl.init({ uploadMenu: 'STD47A' });
 *
 *   3) 노드 선택 시 LINK_KEY 변경:
 *      acAttachFileControl.setLinkKey(code, displayName);
 *
 * @version 2.0 2026-03-10 — 3탭 구조 전환 (원본 CS 대응)
 * ============================================================================
 */
var acAttachFileControl = (function() {

    // ========================================================================
    // 내부 상태
    // ========================================================================
    var _initialized = false;
    var _uploadMenu  = '';      // 화면 구분 (예: 'STD47A')
    var _linkKey     = '';      // 현재 선택된 노드 CODE
    var _permission  = 'UD';    // 'D'=다운로드만, 'U'=업로드만, 'UD'=전체
    var RENAME_MAX_LEN = 200;   // DB: FILE_NAME VARCHAR(200)

    // ========================================================================
    // URL 상수
    // ========================================================================
    var URL = {
        SER:           getUrl('/imes/com/acAttachFile/ATTACH_FILE_SER.json'),
        UPD:           getUrl('/imes/com/acAttachFile/ATTACH_FILE_UPD.json'),
        DEL:           getUrl('/imes/com/acAttachFile/ATTACH_FILE_DEL.json'),
        DOWN:          getUrl('/imes/com/acAttachFile/ATTACH_FILE_DOWN.do'),
        RENAME:        getUrl('/imes/com/acAttachFile/ATTACH_FILE_RENAME.json'),
        ACC_LEVEL_UPD: getUrl('/imes/com/acAttachFile/ATTACH_FILE_ACC_LEVEL_UPD.json')
    };

    // ========================================================================
    // 공개 API
    // ========================================================================
    return {

        /**
         * 초기화 (DOM ready 후 1회 호출)
         * @param {Object} opts
         * @param {string}   opts.uploadMenu   화면 구분 코드 (예: 'STD47A')
         * @param {string}  [opts.permission]  'D' | 'U' | 'UD' (기본: 'UD')
         */
        init: function(opts) {
            opts = opts || {};
            _uploadMenu  = opts.uploadMenu  || '';
            _permission  = opts.permission  || 'UD';

            _initTabs();
            _initAttachGrid();
            _initTransferGrid();
            _initDelHistoryGrid();
            _applyPermission();

            _initialized = true;
        },

        /**
         * LINK_KEY 설정 및 파일 목록/삭제이력 즉시 조회
         * 원본: acAttachFileControl.LinkKey = code; → RefreshFile() 호출
         *
         * @param {string} linkKey      조회 기준 키 (트리 노드 CODE)
         * @param {string} [displayName] 툴바에 표시할 이름 (선택)
         */
        setLinkKey: function(linkKey, displayName) {
            _linkKey = linkKey || '';

            if (!_linkKey) {
                // 전체 그리드 초기화
                $('#ac-attach-grid').datagrid('loadData', []);
                $('#ac-del-history-grid').datagrid('loadData', []);
                $('#ac-transfer-grid').datagrid('loadData', []);
                return;
            }

            _loadAll();
        },

        /**
         * 파일 선택 input 클릭 트리거
         */
        clickUpload: function() {
            if (!_linkKey) {
                $.messager.alert('알림', '파일을 첨부할 노드를 먼저 선택하세요.', 'info');
                return;
            }
            $('#ac-attach-file-input').val('').click();
        },

        /**
         * input[file] onchange 핸들러
         * 원본: FileTransferGridView 에 UPLOAD 큐 추가 후 TransferFileStart() 호출
         * 웹: 즉시 multipart 업로드, 전송 대기파일 탭에 진행중 표시 후 완료 시 제거
         *
         * @param {HTMLInputElement} input
         */
        onFileSelected: function(input) {
            if (!input.files || input.files.length === 0) return;

            var file = input.files[0];

            // 전송 대기파일 탭에 진행중 행 추가
            var queueRow = {
                FILE_NAME: file.name,
                FILE_SIZE: file.size,
                COMMAND:   'UPLOAD',
                PROGRESS:  0,
                STATE:     'UPLOADING'
            };
            var transferData = $('#ac-transfer-grid').datagrid('getData');
            var transferRows = (transferData && transferData.rows) ? transferData.rows.slice() : [];
            transferRows.push(queueRow);
            $('#ac-transfer-grid').datagrid('loadData', transferRows);

            // 전송 대기파일 탭으로 자동 전환
            $('#ac-attach-tabs').tabs('select', '전송 대기파일');

            var formData = new FormData();
            formData.append('file',       file);
            formData.append('uploadMenu', _uploadMenu);
            formData.append('linkKey',    _linkKey);
            formData.append('accLevel',   'P');

            $.ajax({
                url:         URL.UPD,
                type:        'POST',
                data:        formData,
                processData: false,
                contentType: false,
                success: function(result) {
                    // 전송 대기파일 탭에서 완료된 행 제거
                    $('#ac-transfer-grid').datagrid('loadData', []);

                    var ok = result && (result.success === true || result.total > 0 || result.FILE_ID);
                    if (ok) {
                        $.messager.show({
                            title:   '완료',
                            msg:     '파일이 업로드되었습니다.',
                            timeout: 1500
                        });
                        // 첨부파일목록 탭으로 복귀 후 갱신
                        $('#ac-attach-tabs').tabs('select', '첨부파일목록');
                        _loadAll();
                    } else {
                        var msg = (result && result.message) ? result.message : '업로드에 실패했습니다.';
                        $.messager.alert('오류', msg, 'error');
                    }
                },
                error: function() {
                    $('#ac-transfer-grid').datagrid('loadData', []);
                    $.messager.alert('오류', '업로드 중 서버 오류가 발생했습니다.', 'error');
                }
            });
        },

        /**
         * 체크 선택된 행 삭제 (다중 삭제 지원)
         * 원본: DeleteFile() — 논리 삭제 후 RefreshFile() 호출
         */
        deleteSelected: function() {
            var rows = $('#ac-attach-grid').datagrid('getChecked');
            if (!rows || rows.length === 0) {
                $.messager.alert('알림', '삭제할 파일을 선택(체크)하세요.', 'info');
                return;
            }

            var names = $.map(rows, function(r) { return '"' + (r.FILE_NAME || '') + '"'; }).join(', ');
            $.messager.confirm('확인', rows.length + '개 파일을 삭제하시겠습니까?\n' + names, function(confirmed) {
                if (!confirmed) return;

                // 순차 삭제: 각 행을 직렬 처리
                var doDelete = function(idx) {
                    if (idx >= rows.length) {
                        $.messager.show({ title: '완료', msg: rows.length + '개 파일이 삭제되었습니다.', timeout: 1500 });
                        _loadAll();
                        return;
                    }
                    var row = rows[idx];
                    $.ajax({
                        url:      URL.DEL,
                        type:     'POST',
                        data: {
                            fileId:     row.FILE_ID,
                            filePath:   row.FILE_PATH,
                            uploadMenu: _uploadMenu,
                            linkKey:    _linkKey
                        },
                        dataType: 'json',
                        success: function(result) {
                            if (result && result.success) {
                                doDelete(idx + 1);
                            } else {
                                var msg = (result && result.message) ? result.message : '삭제에 실패했습니다.';
                                $.messager.alert('오류', '"' + (row.FILE_NAME || '') + '" 삭제 실패: ' + msg, 'error');
                            }
                        },
                        error: function() {
                            $.messager.alert('오류', '삭제 중 서버 오류가 발생했습니다.', 'error');
                        }
                    });
                };
                doDelete(0);
            });
        },

        /**
         * 선택된 행 다운로드
         * 원본: DownloadFile() / ATTACH_FILE_MASTER_SER2
         */
        downloadSelected: function() {
            var row = $('#ac-attach-grid').datagrid('getSelected');
            if (!row) {
                $.messager.alert('알림', '다운로드할 파일을 선택하세요.', 'info');
                return;
            }
            _downloadFile(row);
        }
    };

    // ========================================================================
    // 내부 함수
    // ========================================================================

    /**
     * EasyUI tabs 초기화 (탭 컴포넌트 파싱)
     */
    function _initTabs() {
        // data-options 방식으로 이미 선언됨 — easyui-tabs 파싱 트리거
        if ($('#ac-attach-tabs').length) {
            $.parser.parse('#ac-attach-wrap');
        }
    }

    /**
     * Tab1: 첨부파일목록 그리드 초기화
     * 원본: FileGridView (acGridView.emGridType.ATTACH_FILE_LIST)
     * 컬럼: 선택(체크), 공개형태, 파일명, 파일크기, 올린 날짜, 올린 사용자코드, 올린 사용자명
     */
    function _initAttachGrid() {
        $('#ac-attach-grid').datagrid({
            fit:            true,
            border:         false,
            singleSelect:   false,
            // ── 체크박스와 행 선택 완전 분리 ──────────────────────────────
            // checkOnSelect:false  → 행 클릭 시 체크박스 체크 안 됨
            // selectOnCheck:false  → 체크박스 클릭 시 행 선택(하이라이트) 안 됨
            // singleSelect:false   → 다중 체크 허용
            // 행 클릭 시 단일 선택(하이라이트)은 onClickRow 에서 수동 처리
            checkOnSelect:  false,
            selectOnCheck:  false,
            striped:        true,
            nowrap:         true,
            rownumbers:     true,
            sortName:       'FILE_SEQ',
            sortOrder:      'asc',
            columns: [[
                // 선택 체크박스 (원본: AddCheckEdit "SEL")
                {field: 'SEL',          title: '선택',           width: 40,  halign: 'center', align: 'center', checkbox: true},
                {field: 'ACC_LEVEL',    title: '공개형태',       width: 60,  halign: 'center', align: 'center', sortable: true,
                    formatter: function(v) {
                        if (v === 'P') return '공개';
                        if (v === 'I') return '내부';
                        return v || '';
                    }
                },
                {field: 'FILE_NAME',    title: '파일명',         width: 240, halign: 'center', align: 'left',   sortable: true},
                {field: 'FILE_ID',      title: 'FILE_ID',        width: 0,   hidden: true},
                {field: 'FILE_SEQ',     title: 'FILE_SEQ',       width: 0,   hidden: true},
                {field: 'FILE_SIZE',    title: '파일크기',       width: 80,  halign: 'center', align: 'right',  sortable: true,
                    formatter: _formatFileSize
                },
                {field: 'REG_DATE',     title: '올린 날짜',      width: 130, halign: 'center', align: 'center', sortable: true,
                    formatter: _formatDateTime
                },
                {field: 'REG_EMP',      title: '올린 사용자코드',width: 110,  halign: 'center', align: 'center', sortable: true},
                {field: 'REG_EMP_NAME', title: '올린 사용자명',  width: 110,  halign: 'center', align: 'center', sortable: true}
            ]],
            onClickRow: function(index, row) {
                // 행 클릭 시 단일 행만 하이라이트 (singleSelect:false 이므로 수동 처리)
                $('#ac-attach-grid').datagrid('unselectAll');
                $('#ac-attach-grid').datagrid('selectRow', index);
            },
            onDblClickCell: function(index, field, value) {
                // 체크박스 컬럼 더블클릭은 무시 (체크/해제 빠른 클릭 시 다운로드 방지)
                if (field === 'SEL') return;
                var row = $('#ac-attach-grid').datagrid('getRows')[index];
                if (row) _downloadFile(row);
            },
            onLoadSuccess: function() {
                $('#ac-attach-grid').datagrid('unselectAll');
                $('#ac-attach-grid').datagrid('uncheckAll');
            },
            // ── 우클릭 컨텍스트 메뉴 (pop32b.js 방식) ─────────────────
            // 원본: FileGridView.ShowGridMenuEx += FileGridView_ShowGridMenuEx
            onRowContextMenu: function(e, index, row) {
                e.preventDefault();
                $('#ac-attach-grid').datagrid('selectRow', index);
                _showContextMenu(e.pageX, e.pageY);
            }
        });

        // 컨텍스트 메뉴 항목 클릭 핸들러 바인딩
        _initContextMenu();
    }

    /**
     * Tab2: 전송 대기파일 그리드 초기화 (웹 전환 스텁)
     * 원본: FileTransferGridView — FTP 비동기 전송 큐
     * 웹:   HTTP 업로드 진행중 파일 임시 표시용
     * 컬럼: 형태, 파일명, 파일크기, 상태 — 균등 너비
     */
    function _initTransferGrid() {
        $('#ac-transfer-grid').datagrid({
            fit:          true,
            border:       false,
            singleSelect: true,
            striped:      true,
            nowrap:       true,
            rownumbers:   true,
            emptyMsg:     '대기 중인 파일이 없습니다.',
            columns: [[
                {field: 'COMMAND',   title: '형태',   width: 100, halign: 'center', align: 'center',
                    formatter: function(v) {
                        if (v === 'UPLOAD')   return '올리기';
                        if (v === 'DOWNLOAD') return '내려받기';
                        return v || '';
                    }
                },
                {field: 'FILE_NAME', title: '파일명', width: 200, halign: 'center', align: 'left'},
                {field: 'FILE_SIZE', title: '파일크기', width: 100, halign: 'center', align: 'right',
                    formatter: _formatFileSize
                },
                {field: 'STATE',     title: '상태',   width: 100, halign: 'center', align: 'center',
                    formatter: function(v) {
                        if (v === 'UPLOADING') return '전송중...';
                        if (v === 'DONE')      return '완료';
                        return v || '';
                    }
                }
            ]]
        });
    }

    /**
     * Tab3: 삭제이력 그리드 초기화
     * 원본: FileDelHistoryGridView (acGridView.emGridType.ATTACH_FILE_LIST)
     * 컬럼: 파일명, 파일크기, 삭제 날짜, 삭제한 사용자코드, 삭제한 사용자명
     */
    function _initDelHistoryGrid() {
        $('#ac-del-history-grid').datagrid({
            fit:          true,
            border:       false,
            singleSelect: true,
            striped:      true,
            nowrap:       true,
            rownumbers:   false,
            emptyMsg:     '삭제된 파일이 없습니다.',
            columns: [[
                {field: 'FILE_NAME',    title: '파일명',             width: 280, halign: 'center', align: 'left'},
                {field: 'FILE_SIZE',    title: '파일크기',           width: 80,  halign: 'center', align: 'right',
                    formatter: _formatFileSize
                },
                {field: 'DEL_DATE',     title: '삭제 날짜',         width: 130, halign: 'center', align: 'center',
                    formatter: _formatDateTime
                },
                {field: 'DEL_EMP',      title: '삭제한 사용자코드', width: 110, halign: 'center', align: 'center'},
                {field: 'DEL_EMP_NAME', title: '삭제한 사용자명',   width: 110,  halign: 'center', align: 'center'}
            ]]
        });
        enableGridSortReset('#ac-del-history-grid'); // 그리드 sort 부여
    }

    /**
     * 권한에 따라 컨텍스트 메뉴 항목 표시/숨김 (초기 설정)
     * 원본: SetStyle() — AttachLinkPermission 에 따른 버튼 가시성 제어
     *
     * 실제 메뉴 표시 시점의 세부 제어는 _showContextMenu() 에서 수행하며,
     * 여기서는 권한에 따라 영구적으로 숨길 항목을 설정한다.
     * (권한은 init 시 1회 설정되고 변경되지 않으므로)
     */
    function _applyPermission() {
        // _showContextMenu() 에서 매번 권한 체크하므로 여기서는 별도 처리 불필요
        // 권한 값(_permission)은 이미 저장되어 있고, 컨텍스트 메뉴 표시 시 반영됨
    }

    // ========================================================================
    // 우클릭 컨텍스트 메뉴
    // 원본: FileGridView_ShowGridMenuEx / popupMenu1
    // 방식: pop32b.js 와 동일한 EasyUI menu 위젯 + onRowContextMenu 콜백
    // ========================================================================

    /**
     * 컨텍스트 메뉴 항목 클릭 이벤트 바인딩
     * (메뉴 표시는 datagrid 의 onRowContextMenu 에서 _showContextMenu 호출)
     * 원본: btnXxx.ItemClick += ... 이벤트 연결
     */
    function _initContextMenu() {

        // EasyUI menu 가 아직 파싱되지 않았을 경우 보장
        if (!$('#ac-attach-context-menu').data('menu')) {
            $.parser.parse('#ac-attach-context-menu');
        }

        // 파일 올리기 (btnUpload)
        $('#ac-ctx-upload').bind('click', function() {
            acAttachFileControl.clickUpload();
        });

        // 파일열기 (btnOpen) — 웹: 다운로드로 처리
        $('#ac-ctx-open').bind('click', function() {
            var row = $('#ac-attach-grid').datagrid('getSelected');
            if (!row) { $.messager.alert('알림', '파일을 선택하세요.', 'info'); return; }
            _downloadFile(row);
        });

        // 내려받기 (btnDownload)
        $('#ac-ctx-download').bind('click', function() {
            var row = $('#ac-attach-grid').datagrid('getSelected');
            if (!row) { $.messager.alert('알림', '다운로드할 파일을 선택하세요.', 'info'); return; }
            _downloadFile(row);
        });

        // 공개형태 → 공개 (acBarSubItem1 > P)
        $('#ac-ctx-acc-public').bind('click', function() {
            _changeAccLevel('P');
        });

        // 공개형태 → 내부 (acBarSubItem1 > I)
        $('#ac-ctx-acc-private').bind('click', function() {
            _changeAccLevel('I');
        });

        // 이름 바꾸기 (btnRename)
        $('#ac-ctx-rename').bind('click', function() {
            _renameFile();
        });

        // 파일삭제 (btnDelete)
        $('#ac-ctx-delete').bind('click', function() {
            acAttachFileControl.deleteSelected();
        });
    }

    /**
     * 컨텍스트 메뉴를 지정 좌표에 표시 (EasyUI menu 위젯)
     * 권한에 따라 항목 표시/숨김 제어
     * 원본: FileGridView_ShowGridMenuEx → GridMenuType.Row 분기
     *       → popupMenu1.ShowPopup(point)
     *
     * @param {number} x - pageX
     * @param {number} y - pageY
     */
    function _showContextMenu(x, y) {
        var canUpload   = (_permission === 'U'  || _permission === 'UD');
        var canDownload = (_permission === 'D'  || _permission === 'UD');

        // ── 권한별 항목 표시/숨김 ────────────────────────────────────────
        // pop32b.js 방식: .parent() 가 EasyUI 가 생성한 .menu-item 래퍼
        // 업로드 권한 항목: 파일 올리기, 공개형태, 이름 바꾸기, 파일삭제
        var showUpload = canUpload && !!_linkKey;
        $('#ac-ctx-upload').parent().toggle(showUpload);
        $('#ac-ctx-acc-level').parent().toggle(showUpload);
        $('#ac-ctx-rename').parent().toggle(showUpload);
        $('#ac-ctx-delete').parent().toggle(showUpload);

        // 다운로드 권한 항목: 파일열기, 내려받기
        $('#ac-ctx-open').parent().toggle(canDownload);
        $('#ac-ctx-download').parent().toggle(canDownload);

        // 구분선1: 업로드·다운로드 경계 (둘 다 보일 때만 표시)
        $('#ac-ctx-sep1').toggle(showUpload && canDownload);

        // 구분선2: 다운로드·편집 경계 (업로드 항목이 보일 때만)
        $('#ac-ctx-sep2').toggle(showUpload);

        // ── EasyUI menu 위젯으로 표시 ────────────────────────────────────
        $('#ac-attach-context-menu').menu('show', { left: x, top: y });
    }

    /**
     * 이름 바꾸기 — 현재 선택 행의 FILE_NAME 을 인라인 prompt 로 수정
     * 원본: btnRename_ItemClick → ATTACH_FILE_MASTER_SER4 → ShowEditor()
     */
    function _renameFile() {
        var row = $('#ac-attach-grid').datagrid('getSelected');
        if (!row) { $.messager.alert('알림', '이름을 바꿀 파일을 선택하세요.', 'info'); return; }

        // EasyUI prompt 팝업으로 새 파일명 입력
        $.messager.prompt('이름 바꾸기', '새 파일명을 입력하세요:', function(newName) {
            if (!newName || !newName.trim()) return;
            newName = newName.trim();

            if (newName.length > RENAME_MAX_LEN) return; // 안전 가드

            $.ajax({
                url:      URL.RENAME,
                type:     'POST',
                data: {
                    fileId:   row.FILE_ID,
                    fileName: newName
                },
                dataType: 'json',
                success: function(result) {
                    if (result && result.success) {
                        $.messager.show({ title: '완료', msg: '파일명이 변경되었습니다.', timeout: 1500 });
                        _loadAll();
                    } else {
                        var msg = (result && result.message) ? result.message : '이름 바꾸기에 실패했습니다.';
                        $.messager.alert('오류', msg, 'error');
                    }
                },
                error: function() {
                    $.messager.alert('오류', '이름 바꾸기 중 서버 오류가 발생했습니다.', 'error');
                }
            });
        });

        // prompt 입력창에 기존 파일명 기본값 설정 + 글자수 제한 UI
        setTimeout(function() {
            var $input = $('.messager-input');
            if (!$input.length) return;

            if (row.FILE_NAME) $input.val(row.FILE_NAME);
            $input.attr('maxlength', RENAME_MAX_LEN);

            // 글자수 카운터 추가
            var $counter = $('<div class="ac-rename-counter" style="text-align:right;font-size:11px;margin-top:4px;color:#888;"></div>');
            var $warn = $('<div class="ac-rename-warn" style="color:red;font-size:11px;margin-top:2px;display:none;">파일명은 ' + RENAME_MAX_LEN + '자를 초과할 수 없습니다.</div>');
            $input.after($warn).after($counter);

            // 확인 버튼 참조
            var $okBtn = $input.closest('.messager-body').find('.l-btn');

            var updateCounter = function() {
                var len = $input.val().length;
                $counter.text(len + ' / ' + String(RENAME_MAX_LEN));

                if (len > RENAME_MAX_LEN) {
                    $counter.css('color', 'red');
                    $warn.show();
                    $okBtn.linkbutton('disable');
                } else {
                    $counter.css('color', '#888');
                    $warn.hide();
                    $okBtn.linkbutton('enable');
                }
            };

            $input.on('input keyup paste', updateCounter);
            updateCounter(); // 초기 표시
        }, 50);
    }

    /**
     * 공개형태 변경 — 선택(체크)된 행 또는 포커스 행의 ACC_LEVEL 업데이트
     * 원본: AccLevelChange_ItemClick → ATTACH_FILE_MASTER_UPD2
     * 체크된 행이 없으면 현재 포커스 행 1건만 처리
     *
     * @param {string} accLevel  'PUBLIC' | 'PRIVATE'
     */
    function _changeAccLevel(accLevel) {
        var checked = $('#ac-attach-grid').datagrid('getChecked');
        var targets = (checked && checked.length > 0)
                    ? checked
                    : [$('#ac-attach-grid').datagrid('getSelected')];

        targets = $.grep(targets, function(r) { return r != null; });
        if (!targets.length) {
            $.messager.alert('알림', '공개형태를 변경할 파일을 선택하세요.', 'info');
            return;
        }

        var label = (accLevel === 'P') ? '공개' : '내부';
        var doUpdate = function(idx) {
            if (idx >= targets.length) {
                $.messager.show({ title: '완료', msg: label + '(으)로 변경되었습니다.', timeout: 1500 });
                _loadAll();
                return;
            }
            var row = targets[idx];
            $.ajax({
                url:      URL.ACC_LEVEL_UPD,
                type:     'POST',
                data: {
                    fileId:   row.FILE_ID,
                    accLevel: accLevel
                },
                dataType: 'json',
                success: function(result) {
                    if (result && result.success) {
                        doUpdate(idx + 1);
                    } else {
                        var msg = (result && result.message) ? result.message : '공개형태 변경에 실패했습니다.';
                        $.messager.alert('오류', '"' + (row.FILE_NAME || '') + '" 변경 실패: ' + msg, 'error');
                    }
                },
                error: function() {
                    $.messager.alert('오류', '공개형태 변경 중 서버 오류가 발생했습니다.', 'error');
                }
            });
        };
        doUpdate(0);
    }

    /**
     * 활성 파일 목록 + 삭제이력 동시 조회
     * 원본: RefreshFile() — ATTACH_FILE_MASTER_SER → RSLTDT + RSLTDT2
     */
    function _loadAll() {
        if (!_linkKey) return;

        $.ajax({
            url:      URL.SER,
            type:     'POST',
            data: {
                uploadMenu: _uploadMenu,
                linkKey:    _linkKey
            },
            dataType: 'json',
            success: function(result) {
                // Tab1: 활성 파일 목록 (rows/total 구조)
                var files = (result && result.rows) ? result.rows : [];
                $('#ac-attach-grid').datagrid('loadData', files);

                // Tab3: 삭제이력 (delHistory.rows)
                var delRows = (result && result.delHistory && result.delHistory.rows)
                            ? result.delHistory.rows : [];
                $('#ac-del-history-grid').datagrid('loadData', delRows);
            },
            error: function() {
                $.messager.alert('오류', '파일 목록 조회 중 오류가 발생했습니다.', 'error');
            }
        });
    }

    /**
     * 파일 다운로드 (hidden iframe)
     * 원본: DownloadFile() / ATTACH_FILE_MASTER_SER2
     */
    function _downloadFile(row) {
        var url = URL.DOWN
                + '?fileId='     + encodeURIComponent(row.FILE_ID     || '')
                + '&uploadMenu=' + encodeURIComponent(_uploadMenu      || '')
                + '&linkKey='    + encodeURIComponent(row.LINK_KEY || _linkKey || '');

        var iframe = document.getElementById('_acAttachDownloadFrame');
        if (!iframe) {
            iframe = document.createElement('iframe');
            iframe.id    = '_acAttachDownloadFrame';
            iframe.style.display = 'none';
            document.body.appendChild(iframe);
        }
        iframe.src = url;
    }

    /**
     * 날짜 포맷 (yyyy-MM-dd HH:mm:ss → yyyy-MM-dd 오전/오후 h:mm:ss)
     * - 24시간 → 12시간 + 오전/오후 변환
     * - 시각 한 자릿수는 앞에 0 붙이지 않음 (예: 오후 1:02:24)
     */
    function _formatDateTime(val) {
        if (!val) return '';
        // 'yyyy-MM-dd HH:mm:ss' 파싱
        var parts = val.match(/^(\d{4}-\d{2}-\d{2})\s+(\d{1,2}):(\d{2}):(\d{2})$/);
        if (!parts) return val;

        var datePart = parts[1];
        var hh = parseInt(parts[2], 10);
        var mm = parts[3];
        var ss = parts[4];

        var ampm = (hh < 12) ? '오전' : '오후';
        var h12  = hh % 12;
        if (h12 === 0) h12 = 12;

        return datePart + ' ' + ampm + ' ' + h12 + ':' + mm + ':' + ss;
    }

    /**
     * 파일 크기 포맷 (bytes → B/KB/MB)
     */
    function _formatFileSize(size) {
        if (size == null || size === '') return '';
        var n = parseFloat(size);
        if (isNaN(n)) return size;
        if (n < 1024)        return n + ' B';
        if (n < 1024 * 1024) return (n / 1024).toFixed(1) + ' KB';
        return (n / 1024 / 1024).toFixed(2) + ' MB';
    }

}());

// ============================================================================
// 전역 핸들러 (그리드 다운로드 버튼 onclick에서 호출)
// ============================================================================

/**
 * Tab1 그리드 행의 다운로드 버튼 클릭 핸들러
 * formatter 의 onclick="..." 인라인에서 호출됨
 * @param {number} index - datagrid 행 인덱스
 */
function _acAttachDownload(index) {
    $('#ac-attach-grid').datagrid('selectRow', index);
    acAttachFileControl.downloadSelected();
}
