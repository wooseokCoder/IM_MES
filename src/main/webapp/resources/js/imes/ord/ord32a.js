/**
 * ORD32A - NG 조립 파일 모델/공정 매핑 관리 (본체)
 *
 * 원본: ProActive ORD32A_M0A.cs
 * 레이아웃:
 *   - 상단 좌: Grid1 (파일목록) / 상단 우: 첨부파일 (acAttachFileControl)
 *   - 하단 좌: Grid2 (모델)     / 하단 우: Grid3 (공정)
 *
 * D0A 팝업 로직: ord32a_d0a.js 참조
 *
 * @author Claude
 * @since 2026-03-10
 */

var consts = {
    sysId:    gconsts.SYS_ID,
    title:    gconsts.TITLE,
    admin:    gconsts.ADMIN,

    url: {
        ser:     getUrl('/imes/ord/ord32a/ORD32A_SER.json'),
        ser2:    getUrl('/imes/ord/ord32a/ORD32A_SER2.json'),
        ser3:    getUrl('/imes/ord/ord32a/ORD32A_SER3.json'),
        ins:     getUrl('/imes/ord/ord32a/ORD32A_INS.json')
    },

    /** 현재 Grid1에서 선택된 파일ID */
    selectedFileId: null,

    /**
     * 초기화
     */
    init: function() {
        // ----------------------------------------------------------
        // Grid1: 파일목록
        // AS-IS: FILE_ID, FILE_NAME, REG_DATE(LONG_DATE), REG_EMP(hidden), REG_EMP_NAME
        // ----------------------------------------------------------
        $('#grid1').datagrid({
            fit: true,
            border: false,
            singleSelect: true,
            selectOnCheck: false,
            checkOnSelect: false,
            fitColumns: false,
            idField: 'fileId',
            columns: [[
                {field:'fileId',      title:'파일ID',  width:150, halign:'center', align:'center'},
                {field:'fileName',    title:'파일명',  width:375, halign:'center', align:'left'},
                {field:'regDate',     title:'생성일',  width:150, halign:'center', align:'center'},
                {field:'regEmpName',  title:'생성자',  width:150, halign:'center', align:'center'},
                {field:'regEmp',      title:'생성자코드',  hidden:true}
            ]],
            onClickRow: function(index, row) {
                if (row) {
                    doGetDetail(row.fileId);
                }
            }
        });

        // ----------------------------------------------------------
        // Grid2: 모델 (선택된 파일의 적용 모델)
        // AS-IS: MODEL_TYPE, MODEL_SERISE, MODEL
        // ----------------------------------------------------------
        $('#grid2').datagrid({
            fit: true,
            border: false,
            singleSelect: true,
            columns: [[
                {field:'modelType',   title:'모델군',   width:120, halign:'center', align:'center'},
                {field:'modelSerise', title:'시리즈',   width:120, halign:'center', align:'center'},
                {field:'model',       title:'모델',     width:150, halign:'center', align:'center'}
            ]]
        });

        // ----------------------------------------------------------
        // Grid3: 공정 (선택된 파일의 적용 공정)
        // AS-IS: PROC_CODE, PROC_NAME
        // ----------------------------------------------------------
        $('#grid3').datagrid({
            fit: true,
            border: false,
            singleSelect: true,
            columns: [[
                {field:'procCode', title:'공정코드', width:100, halign:'center', align:'center'},
                {field:'procName', title:'공정명',   width:150, halign:'center', align:'left'}
            ]]
        });

        // ----------------------------------------------------------
        // 첨부파일 컨트롤 초기화 (acAttachFileControl 공통 모듈)
        // AS-IS: acAttachFileControl1.LinkKey = "NG_ASSY_FILE" (고정)
        // ----------------------------------------------------------
        acAttachFileControl.init({ uploadMenu: 'ORD32A' });
        acAttachFileControl.setLinkKey('NG_ASSY_FILE');

        // 그리드 헤더 컨텍스트 메뉴 (정렬/컬럼숨김/엑셀 등)
        GridHeaderMenu('#grid1', { exportFileName: 'NG파일목록' });
        GridHeaderMenu('#grid2', { exportFileName: 'NG파일_모델매핑' });
        GridHeaderMenu('#grid3', { exportFileName: 'NG파일_공정매핑' });

        // D0A 그리드 초기화 (ord32a_d0a.js)
        initD0aGrids();

        // 로딩 완료
        hideLoadingBar();
        $('#account-layout').css('display', '');
        
        enableGridSortReset('#grid1');
        enableGridSortReset('#grid2');
        enableGridSortReset('#grid3');
    }
};

// ================================================================
// jQuery Ready
// ================================================================
$(function() {
    consts.init();

    // 본체 이벤트 바인딩
    $('#search-button').bind('click', doSearch);
    $('#edit-button').bind('click', doOpenD0a);

    // D0A 이벤트 바인딩 (ord32a_d0a.js)
    initD0aEvents();
});

/**
 * 초기화 (JSP에서 호출)
 */
function doInit(args) {
    if (args) {
        $.extend(consts, args);
    }
}

// ================================================================
// 조회
// ================================================================

/**
 * 파일목록 조회 (Grid1)
 * AS-IS: PLT_CODE + LINK_KEY='NG_ASSY_FILE' 고정 파라미터 (검색 조건 없음)
 */
function doSearch() {
    $.ajax({
        url: consts.url.ser,
        type: 'POST',
        dataType: 'json',
        data: {},
        success: function(res) {
            var rows = res.rows || [];
            $('#grid1').datagrid('loadData', rows);

            // 그리드 초기화 시 하단 모델/공정 클리어
            $('#grid2').datagrid('loadData', []);
            $('#grid3').datagrid('loadData', []);
            consts.selectedFileId = null;

            // 첫 행 자동 선택
            if (rows.length > 0) {
                $('#grid1').datagrid('selectRow', 0);
                doGetDetail(rows[0].fileId);
            }
        },
        error: function() {
            $.messager.alert('오류', '조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

/**
 * 선택 파일의 모델/공정 상세 조회 (Grid2, Grid3)
 * AS-IS: ORD32A_SER2 (Grid1 FocusedRowChanged 이벤트)
 * @param {string} fileId 선택된 파일ID
 */
function doGetDetail(fileId) {
    console.log('[ORD32A] doGetDetail 호출, fileId=', fileId);
    if (!fileId) {
        $('#grid2').datagrid('loadData', []);
        $('#grid3').datagrid('loadData', []);
        consts.selectedFileId = null;
        return;
    }

    consts.selectedFileId = fileId;

    $.ajax({
        url: consts.url.ser2,
        type: 'POST',
        dataType: 'json',
        data: {fileId: fileId},
        success: function(res) {
            console.log('[ORD32A] SER2 응답:', JSON.stringify(res));

            // 모델 → Grid2
            var models = res.models || [];
            console.log('[ORD32A] Grid2 로드할 모델 수:', models.length);
            $('#grid2').datagrid('loadData', models);

            // 공정 → Grid3
            var procs = res.procs || [];
            console.log('[ORD32A] Grid3 로드할 공정 수:', procs.length);
            $('#grid3').datagrid('loadData', procs);
        },
        error: function(xhr, status, err) {
            console.error('[ORD32A] SER2 에러:', status, err);
            $.messager.alert('오류', '상세 조회 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ================================================================
// 로딩바 숨김
// ================================================================
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
}
