/**
 * ============================================================================
 * 화면명: STD47A - 작업표준서(조립)
 * ============================================================================
 * 설명: 작업표준서 등록 및 조회
 *       - 탭1: 모델 트리 + 파일 첨부
 *       - 탭2: 작업표준서 리스트
 * 원본: ProActive STD47A_M0A.cs, STD47A.cs
 * 작성일: 2026-03-03
 * ============================================================================
 */

// ============================================================================
// URL 상수
// ============================================================================
var consts = {
    url: {
        STD47A_SER:        getUrl('/imes/std/std47a/STD47A_SER.json'),
        STD47A_SER_LEVEL3: getUrl('/imes/std/std47a/STD47A_SER_LEVEL3.json'),
        STD47A_SER2:       getUrl('/imes/std/std47a/STD47A_SER2.json')
    }
};

// ============================================================================
// 전역 변수
// ============================================================================
var plants = '3603';           // 기본 공장코드 (조립)
var _tabInitialized = false;   // onTabSelect 초기 발동 차단 플래그

// ============================================================================
// 화면 초기화
// ============================================================================

/**
 * DOM Ready: 그리드/트리 초기화
 */
$(function() {
    // treegrid 로딩 마스크 CSS 주입
    // datagrid-mask 와 동일한 구조·스타일이지만 클래스명을 treegrid-* 로 변경
    var _tgImgUrl = getUrl('/resources/jquery/easyui-1.4/themes/ui-pepper-grinder/images/loading.gif');
    $('<style id="treegrid-mask-style">' +
        // 로딩 마스크 (datagrid-mask 와 동일 구조, treegrid 전용 클래스명)
        '.treegrid-mask {' +
        '  position:absolute; left:0; top:0; width:100%; height:100%;' +
        '  opacity:0.3; filter:alpha(opacity=30); background:#ccc; display:none; z-index:999;' +
        '}' +
        '.treegrid-mask-msg {' +
        '  position:absolute; top:50%; margin-top:-20px;' +
        '  padding:10px 5px 10px 30px; width:auto;' +
        '  border-width:2px; border-style:solid; border-color:#cbc7bd;' +
        '  background:#eceadf url(' + _tgImgUrl + ') no-repeat scroll 5px center;' +
        '  display:none; z-index:1000;' +
        '}' +
        // 폴더/파일 아이콘 전체 제거 (tree-icon 스팬 숨김)
        '#model-tree span.tree-icon { display:none !important; }' +
    '</style>').appendTo('head');

    initModelTree();
    initListGrid();
    bindButtonEvents();

    // 파일 첨부 컨트롤 초기화 (acAttachFileControl.jsp 포함 시 사용)
    // uploadMenu: 'STD47A' — TSYS_FILELIST_MASTER.UPLOAD_MENU 구분값
    acAttachFileControl.init({ uploadMenu: 'STD47A' });
});

/**
 * Window Load: EasyUI 컴포넌트 초기화 완료 후 실행
 */
$(window).load(function() {
    // 화면 로딩 완료
    hideLoadingBar();

    // 탭 초기화 플래그: doSearch() 호출 전에 false 로 설정하여
    // doSearch() 내부에서 onTabSelect가 이미 reload를 중복 호출하지 않도록 방지
    _tabInitialized = false;

    // 화면 진입 시 자동 조회
    doSearch();

    // 이후 탭 전환에는 onTabSelect가 정상 동작하도록 플래그 활성화
    _tabInitialized = true;
});

// ============================================================================
// 모델 트리 초기화 (탭1: 작업표준서 등록)
// ============================================================================
/**
 * 트리 그리드 구조만 초기화 (url 없이 수동 로드 방식 - acEmpForm._loadOrgTree 패턴)
 * url 옵션을 사용하면 init 시 EasyUI가 자동으로 요청을 발사하므로 사용하지 않음
 */
function initModelTree() {
    $('#model-tree').treegrid({
        // url 제거 - EasyUI 자동 로드 방지 (수동 AJAX 로드 사용)
        fit: true,
        fitColumns: true,
        striped: true,
        singleSelect: true,
        idField: 'SAFE_CODE',       // CSS 셀렉터 안전 ID (특수문자 치환 버전)
        treeField: 'CODE_NAME',
        parentField: 'SAFE_P_CODE', // CSS 셀렉터 안전 부모 ID
        animate: false,             // 애니메이션 OFF - 마우스오버 성능 개선
        rownumbers: false,          // 로우번호 제거 (요청사항 + 성능 개선)
        loadMsg: 'Processing, please wait ...',  // treegrid 전용 로딩 메시지
        columns: [[
            {field: 'CODE_NAME', title: '구분', width: 300, align: 'left', halign: 'center'}
        ]],
        onLoadSuccess: function(row, data) {
            // 트리 로드 성공
        },
        onBeforeExpand: function(row) {
            // LEVEL2 노드(모델번호) 펼치기 시 LEVEL3(공정그룹)를 Lazy Load
            // _level3Loaded 플래그로 이미 로드된 경우 중복 요청 방지
            if (parseInt(row.LEVEL) === 2 && !row._level3Loaded) {
                loadLevel3(row);
                return false;  // 기본 펼침 동작 취소 — loadLevel3 완료 후 expand 호출
            }
            return true;
        },
        onSelect: function(row) {
            // 노드 선택 시 파일 첨부 컨트롤 업데이트
            // 트리 구조: LEVEL=1(트리0/루트), LEVEL=2(트리1/모델), LEVEL=3(트리2/공정그룹)
            // 원본 C# e.Node.Level == 2 → DevExpress 0-indexed Level 2 = 3단계(공정그룹)
            var dataLevel = parseInt(row.LEVEL) || 0;
            if (dataLevel === 3) {
                // LEVEL3(공정그룹) 노드 선택 시 파일 첨부 컨트롤 연동
                // 원본: acAttachFileControl1.LinkKey = e.Node["CODE"]
                // e.Node["CODE"] = MODEL_NO-PRG_CODE (공정그룹 고유 코드)
                var code        = row.CODE || '';
                var displayName = row.CODE_NAME || code;
                acAttachFileControl.setLinkKey(code, displayName);
            } else {
                // LEVEL1/LEVEL2 선택 시 파일 목록 초기화
                acAttachFileControl.setLinkKey('', '(공정그룹 노드를 선택하세요)');
            }
        }
    });

    // mouseover Violation 방지
    // jquery.treegrid.js 내부 _2c() 가 body1/body2 에 mouseover/mouseout 을 bind하여
    // 마우스 이동 시마다 closest() + addClass/removeClass 가 발생 → "[Violation] 'mouseover' handler" 경고
    // click 핸들러는 별도이므로 off 해도 확장/축소 기능에는 영향 없음
    var _tgData = $.data($('#model-tree')[0], 'datagrid');
    if (_tgData && _tgData.dc) {
        _tgData.dc.body1.add(_tgData.dc.body2).off('mouseover mouseout');
    }
}

// ============================================================================
// 모델 트리 데이터 로드 (acEmpForm._loadOrgTree 패턴)
// ============================================================================
/**
 * 수동 AJAX 호출 후 flat 배열을 children 중첩 구조로 변환하여 treegrid에 로드
 * flat 배열: [{CODE, P_CODE, CODE_NAME, LEVEL}, ...]
 * 변환 후: 루트 노드에 children 배열이 중첩된 구조
 */
function loadModelTree() {
    _showTreegridLoading();
    $.ajax({
        url: consts.url.STD47A_SER,
        type: 'POST',
        data: {
            plants: plants,
            modelLike: safeGetTextboxValue('#s_modelLike')
        },
        dataType: 'json',
        success: function(result) {
            _hideTreegridLoading();
            var rows = result.rows || [];
            console.log('[STD47A] 트리 데이터 수신 건수:', rows.length);

            // flat 배열 → children 중첩 구조 변환 (acEmpForm._loadOrgTree 패턴)
            var map = {};
            var roots = [];
            var i;

            // 1단계: 맵 구축 + children 배열 초기화
            // idField = SAFE_CODE (CSS 셀렉터 안전 ID)
            // LEVEL1/LEVEL2: state='closed' (확장 버튼 표시)
            // LEVEL3: state 미설정 → children 빈 배열만 → treegrid가 tree-indent 렌더링(확장 버튼 없음)
            // ※ 현재는 LEVEL3가 초기 로드에 포함되지 않지만(Lazy Load), 방어적으로 조건 유지
            for (i = 0; i < rows.length; i++) {
                rows[i].children = [];
                if (parseInt(rows[i].LEVEL) !== 3) {
                    rows[i].state = 'closed';
                }
                map[rows[i].SAFE_CODE] = rows[i];
            }

            // 2단계: 부모-자식 연결 (SAFE_P_CODE → SAFE_CODE 기준)
            for (i = 0; i < rows.length; i++) {
                var pCode = rows[i].SAFE_P_CODE;
                if (pCode && pCode !== '' && map[pCode]) {
                    map[pCode].children.push(rows[i]);
                } else {
                    roots.push(rows[i]);
                }
            }

            // 3단계: treegrid에 로드
            $('#model-tree').treegrid('loadData', roots);
        },
        error: function() {
        	
            _hideTreegridLoading();
            $.messager.alert('오류', '모델 트리 조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 리스트 그리드 초기화 (탭2: 리스트)
// ============================================================================
function initListGrid() {
    $('#list-grid').datagrid({
        // url 제거 - onBeforeLoad 방식 대신 datagrid('load', params) 사용
        method: 'post',
        fit: true,
        fitColumns: true,
        striped: true,
        singleSelect: true,
        pagination: true,
        pageSize: 100,
        loadFilter: clientPagerFilter,
        rownumbers: true,
        nowrap: false,
        idField: 'FILE_NO',
        columns: [[
            {field: 'MODEL_TYPE',    title: '구분',    width: 100, halign: 'center', align: 'center'},
            {field: 'MODEL_SERISE',  title: '시리즈',  width: 120, halign: 'center', align: 'left'},
            {field: 'MODEL_NO',      title: '모델',    width: 150, halign: 'center', align: 'left'},
            {field: 'PROC_CODE',     title: '공정',    width: 100, halign: 'center', align: 'center'},
            {field: 'FILE_NAME',     title: '파일명',  width: 250, halign: 'center', align: 'left'},
            {field: 'REG_DATE',      title: '등록일',  width: 120, halign: 'center', align: 'center', formatter: formatDate},
            {field: 'REG_EMP',       title: '등록자코드', width: 100, halign: 'center', align: 'center'},
            {field: 'REG_EMP_NAME',  title: '등록자',  width: 100, halign: 'center', align: 'center'}
        ]],
        onLoadSuccess: function(data) {
            $('#list-grid').datagrid('unselectAll');
        }
    });
    
    enableGridSortReset('#list-grid');
}

// ============================================================================
// 버튼 이벤트 바인딩
// ============================================================================
function bindButtonEvents() {
	
    // 조회
    $('#search-button').bind('click', doSearch);

    // 검색 입력 필드 Enter 키 바인딩 (window.load 이후에 textbox가 초기화되므로 안전 처리)
    $('#s_modelLike').bind('keydown', function(e) {
        if (e.keyCode === 13) {
            doSearch();
        }
    });
}

// ============================================================================
// 탭 선택 이벤트
// ============================================================================
/**
 * 탭 전환 시 해당 탭 데이터 조회
 * _tabInitialized 플래그로 페이지 초기 진입 시 중복 조회 방지
 */
function onTabSelect(title, index) {
    // 초기 진입 시 onTabSelect가 자동 발동되는 것을 차단
    if (!_tabInitialized) return;

    var tab = $('#tab-panel').tabs('getTab', index);
    var containerName = tab.panel('options').containerName;

    // 탭 전환 시 해당 탭의 데이터 자동 조회 (비활성화)
    // if (containerName === 'INPUT') {
    //     // 작업표준서 등록 탭: 트리 조회
    //     loadModelTree();
    // } else if (containerName === 'LIST') {
    //     // 리스트 탭: 그리드 조회
    //     doSearchList();
    // }
}

// ============================================================================
// 조회
// ============================================================================
/**
 * 현재 선택된 탭에 따라 조회 실행
 */
function doSearch() {
    var selectedTab = $('#tab-panel').tabs('getSelected');
    var containerName = selectedTab.panel('options').containerName;

    if (containerName === 'INPUT') {
        // 작업표준서 등록 탭: 트리 조회 (STD47A_SER)
        loadModelTree();
    } else if (containerName === 'LIST') {
        // 리스트 탭: 그리드 조회 (STD47A_SER2)
        doSearchList();
    } else {
        // 기본: 트리 조회
        loadModelTree();
    }
}

/**
 * 리스트 탭 그리드 조회 (STD47A_SER2)
 */
function doSearchList() {
    var $grid = $('#list-grid');
    $grid.datagrid('options').url = consts.url.STD47A_SER2;
    $grid.datagrid('load', {
        plants: plants,
        modelLike: safeGetTextboxValue('#s_modelLike'),
        uploadMenu: 'STD47A'
    });
}

// ============================================================================
// LEVEL3 Lazy Load (LEVEL2 노드 펼치기 시 호출)
// ============================================================================

/**
 * 특정 LEVEL2 노드의 공정그룹(LEVEL3)을 AJAX로 로드하여 treegrid에 append
 * onBeforeExpand 에서 호출됨. 로드 완료 후 treegrid('expand') 로 펼침.
 * @param {Object} row - 펼칠 LEVEL2 노드의 row 데이터 (MODEL_NO, SAFE_CODE 포함)
 */
function loadLevel3(row) {
    $.ajax({
        url: consts.url.STD47A_SER_LEVEL3,
        type: 'POST',
        data: {
            plants:  plants,
            modelNo: row.MODEL_NO
        },
        dataType: 'json',
        success: function(result) {
            var level3Rows = (result && result.rows) ? result.rows : [];

            // LEVEL3 노드: children 빈 배열 (리프 노드 — 확장 버튼 없음)
            for (var i = 0; i < level3Rows.length; i++) {
                level3Rows[i].children = [];
                // state 미설정 → treegrid가 tree-indent(확장 버튼 없음) 렌더링
            }

            // 로드 완료 플래그 먼저 설정 (재진입 방지)
            row._level3Loaded = true;

            if (level3Rows.length > 0) {
                $('#model-tree').treegrid('append', {
                    parent: row.SAFE_CODE,
                    data:   level3Rows
                });
            }

            // 자식 추가 후 펼침 (onBeforeExpand 가 다시 발동되지만 _level3Loaded=true 이므로 통과)
            $('#model-tree').treegrid('expand', row.SAFE_CODE);
        },
        error: function() {
            row._level3Loaded = true;  // 실패해도 플래그 설정하여 무한 재시도 방지
            $.messager.alert('오류', '공정그룹 조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// treegrid 로딩 마스크 (datagrid loading/loaded 메서드의 treegrid 전용 구현)
// - datagrid 플러그인은 datagrid-mask / datagrid-mask-msg 클래스를 사용하지만
//   여기서는 treegrid-mask / treegrid-mask-msg 클래스명으로 독립적으로 처리함
// ============================================================================

/**
 * treegrid 로딩 마스크 표시
 * loadMsg 옵션이 설정된 경우에만 동작
 * treegrid 패널(.datagrid 래퍼)에 treegrid-mask / treegrid-mask-msg 를 주입
 */
function _showTreegridLoading() {
    var opts = $('#model-tree').treegrid('options');
    if (!opts.loadMsg) return;

    // treegrid 는 datagrid 를 기반으로 하므로 외부 래퍼에 class="datagrid" 가 존재함
    var $panel = $('#model-tree').closest('.datagrid');
    if ($panel.length === 0) return;

    // 중복 생성 방지
    if ($panel.children('div.treegrid-mask').length) return;

    $('<div class="treegrid-mask" style="display:block"></div>').appendTo($panel);

    var $msg = $('<div class="treegrid-mask-msg" style="display:block;left:50%"></div>')
        .html(opts.loadMsg)
        .appendTo($panel);

    // 가로 중앙 정렬 (datagrid loading 메서드와 동일한 방식)
    $msg.css({
        'margin-left': (-$msg.outerWidth() / 2),
        'line-height':  ($msg.height() + 'px')
    });
}

/**
 * treegrid 로딩 마스크 숨김
 * treegrid-mask / treegrid-mask-msg 를 패널에서 제거
 */
function _hideTreegridLoading() {
    var $panel = $('#model-tree').closest('.datagrid');
    if ($panel.length === 0) return;
    $panel.children('div.treegrid-mask-msg').remove();
    $panel.children('div.treegrid-mask').remove();
}

// ============================================================================
// 유틸리티 함수
// ============================================================================

/**
 * 로딩바 숨김
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

/**
 * textbox 값 안전하게 가져오기
 * EasyUI textbox가 초기화되지 않은 경우에도 안전하게 처리
 * @param {string} selector - jQuery 셀렉터
 * @returns {string} textbox 값 또는 빈 문자열
 */
function safeGetTextboxValue(selector) {
    var $elem = $(selector);
    if ($elem.length === 0) {
        return '';
    }

    // EasyUI textbox가 초기화되었는지 확인
    var textboxData = $.data($elem[0], 'textbox');
    if (textboxData) {
        // textbox가 초기화된 경우
        try {
            return $elem.textbox('getValue') || '';
        } catch (e) {
            // textbox API 호출 실패 시 일반 input value 읽기
            return $elem.val() || '';
        }
    } else {
        // textbox가 아직 초기화되지 않은 경우 일반 input value 읽기
        return $elem.val() || '';
    }
}

/**
 * 날짜 포맷 (YYYY-MM-DD)
 */
function formatDate(value) {
    if (!value) return '';
    if (typeof value === 'string') {
        // YYYYMMDD -> YYYY-MM-DD
        if (value.length > 10) {
            return '<div>' + value.substring(0, 10) + '</div><div>' + value.substring(10) + '</div>';
        }
        return value;
    }
    return value;
}
