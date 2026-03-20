/*
 * ============================================================================
 * 화면명: QCT08A - 자주검사 현황
 * ============================================================================
 * 설명: 자주검사 결과 조회 전용
 *       내부 탭으로 조립(PLANTS=1000) / 가공(PLANTS=2000) 구분
 *       QMS 전송 기능 포함
 * 작성일: 2026-03-17
 * @author 송우석
 * ============================================================================
 */

/* 코드 데이터 캐시 */
var codeDataMap = {};

/* 현재 선택된 탭 ('assy' 또는 'mach') */
var currentTab = 'assy';

/* D0A 이미지 팝업 */
var d0aInited = false;
var d0aPendingRow = null;
var _d0aImgMenu = null;   // 이미지 컨텍스트 메뉴 (공통 모듈 인스턴스)

/* ========================================================================
 * URL 및 초기화
 * ======================================================================== */
var consts = {
    url: {
        QCT08A_SER:  getUrl('/imes/qct/qct08a/QCT08A_SER.json'),
        QCT08A_SER2: getUrl('/imes/qct/qct08a/QCT08A_SER2.json'),
        QCT08A_IMG:  getUrl('/imes/qct/qct08a/QCT08A_IMG.json'),
        QCT08A_UPD:  getUrl('/imes/qct/qct08a/QCT08A_UPD.json'),
        QCT08A_UPD2: getUrl('/imes/qct/qct08a/QCT08A_UPD2.json'),
        QCT08A_PROC: getUrl('/imes/qct/qct08a/QCT08A_PROC.json'),
        CODE_LIST:   getUrl('/common/code/code.json')
    },

    /**
     * 코드 데이터 동기 로드
     */
    loadCode: function(codeGrup) {
        if (codeDataMap[codeGrup]) return codeDataMap[codeGrup];
        var items = [];
        $.ajax({
            url: this.url.CODE_LIST,
            type: 'POST',
            data: { codeGrup: codeGrup },
            async: false,
            success: function(response) {
                items = response.rows || response || [];
            }
        });
        codeDataMap[codeGrup] = items;
        return items;
    },

    /**
     * 초기화
     */
    init: function() {
        /* 코드 데이터 로드 */
        consts.codeData = {};
        consts.codeData.C053 = this.loadCode('C053');
        consts.codeData.C054 = this.loadCode('C054');
        consts.codeData.C055 = this.loadCode('C055');

        /* 공정 combogrid 초기화 (조립/가공 각각) */
        var procGridCols = [[
            {field: 'procCode', title: '공정코드', width: 80, halign: 'center', align: 'center'},
            {field: 'procName', title: '공정명',   width: 150, halign: 'center', align: 'left'}
        ]];
        var procGridOpts = {
            width: 130,
            panelWidth: 300,
            panelHeight: 200,
            editable: false,
            idField: 'procCode',
            textField: 'procName',
            fitColumns: false,
            columns: procGridCols,
            data: []
        };
        $('#s_procCode_assy').combogrid(procGridOpts);
        $('#s_procCode_mach').combogrid(procGridOpts);

        /* acProcForm 공통 팝업 초기화 */
        acProcForm.init({
            url: consts.url.QCT08A_PROC
        });

        /* 공정 찾기 돋보기 버튼 바인딩 */
        $('#s_procFind_assy').bind('click', function() {
            acProcForm.open({
                onSelect: function(row) {
                    var gridData = [{procCode: row.procCode, procName: row.procName}];
                    $('#s_procCode_assy').combogrid('grid').datagrid('loadData', gridData);
                    $('#s_procCode_assy').combogrid('setValue', row.procCode);
                }
            });
        });
        $('#s_procFind_mach').bind('click', function() {
            acProcForm.open({
                onSelect: function(row) {
                    var gridData = [{procCode: row.procCode, procName: row.procName}];
                    $('#s_procCode_mach').combogrid('grid').datagrid('loadData', gridData);
                    $('#s_procCode_mach').combogrid('setValue', row.procCode);
                }
            });
        });

        /* 조립 그리드 */
        initGrid('grid-assy', getAssyColumns());

        /* 가공 그리드 */
        initGrid('grid-mach', getMachColumns());

        /* 탭 전환 이벤트 — 검색영역 show/hide */
        $('#main-tabs').tabs({
            onSelect: function(title, index) {
                if (index === 0) {
                    currentTab = 'assy';
                    $('#search-assy').show();
                    $('#search-mach').hide();
                } else {
                    currentTab = 'mach';
                    $('#search-assy').hide();
                    $('#search-mach').show();
                }
            }
        });

        /* 버튼 바인딩 */
        $('#search-button').bind('click', doSearch);
        $('#qms-send-button').bind('click', doQmsSend);
    }
};

/* ========================================================================
 * 그리드 초기화
 * ======================================================================== */

/**
 * 그리드 공통 초기화
 */
function initGrid(gridId, columns) {
    $('#' + gridId).datagrid({
        method: 'post',
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: false,
        checkOnSelect: false,
        selectOnCheck: false,
        pagination: true,
        pageSize: 100,
        pageList: [50, 100, 300],
        rownumbers: true,
        nowrap: true,
        loadMsg: '조회 중...',
        columns: [columns],
        onLoadSuccess: function(data) {
            /* 로딩 완료 */
        },
        onClickRow: function(index, row) {
            $('#' + gridId).datagrid('unselectAll');
            $('#' + gridId).datagrid('selectRow', index);
        },
        onClickCell: function(index, field, value) {
            if (field === 'insResultImg') {
                var row = $('#' + gridId).datagrid('getRows')[index];
                if (row && parseInt(row.imgCnt) > 0) {
                    doOpenImage(row);
                }
            }
        }
    });

    /* noStyle 적용 */
    $('#' + gridId).datagrid('getPanel').find('.datagrid-view').addClass('noStyle');

    /* 헤더 컨텍스트 메뉴 */
    GridHeaderMenu('#' + gridId, { exportFileName: '자주검사현황' });
}

/**
 * 조립 탭 그리드 컬럼
 */
function getAssyColumns() {
    return [
        {field: 'ck', checkbox: true},
        {field: 'prodOrder', title: '판매오더/라인', width: 130, halign: 'center', align: 'left'},
        {field: 'prodWeek', title: '생산주차', width: 80, halign: 'center', align: 'left'},
        {field: 'prodHogi', title: '호기', width: 70, halign: 'center', align: 'left'},
        {field: 'indueDate', title: '생산완료일', width: 100, halign: 'center', align: 'center'},
        {field: 'customer', title: '수주처', width: 130, halign: 'center', align: 'left'},
        {field: 'modelType', title: '타입', width: 80, halign: 'center', align: 'center'},
        {field: 'empName', title: '검사자', width: 80, halign: 'center', align: 'center'},
        {field: 'empCode', title: '검사자사번', width: 90, halign: 'center', align: 'center'},
        {field: 'insDate', title: '검사일', width: 100, halign: 'center', align: 'center'},
        {field: 'qmsState', title: 'QMS 전송여부', width: 100, halign: 'center', align: 'center'},
        {field: 'procCode', title: '검사공정', width: 80, halign: 'center', align: 'left'},
        {field: 'procName', title: '검사공정명', width: 120, halign: 'center', align: 'left'},
        {field: 'insName', title: '검사항목명', width: 150, halign: 'center', align: 'left'},
        {field: 'insDesc', title: '점검내역', width: 170, halign: 'center', align: 'left'},
        {field: 'insType', title: 'TYPE', width: 60, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('C053', v); }},
        {field: 'avgVal', title: '기준값', width: 80, halign: 'center', align: 'left'},
        {field: 'insUnit', title: '단위', width: 60, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('C054', v); }},
        {field: 'minVal', title: 'Min', width: 70, halign: 'center', align: 'right'},
        {field: 'maxVal', title: 'Max', width: 70, halign: 'center', align: 'right'},
        {field: 'insResult', title: '검사값', width: 90, halign: 'center', align: 'center'},
        {field: 'insResultImg', title: '검사이미지', width: 80, halign: 'center', align: 'center', sortable: false,
            formatter: formatImgButton},
        {field: 'insmNo', hidden: true},
        {field: 'insNo', hidden: true},
        {field: 'imgCnt', hidden: true},
        {field: 'pltCode', hidden: true}
    ];
}

/**
 * 가공 탭 그리드 컬럼
 */
function getMachColumns() {
    return [
        {field: 'ck', checkbox: true},
        {field: 'sapWoNo', title: '생산오더', width: 130, halign: 'center', align: 'left'},
        {field: 'model', title: '타입', width: 120, halign: 'center', align: 'center'},
        {field: 'empName', title: '검사자', width: 90, halign: 'center', align: 'center'},
        {field: 'empCode', title: '검사자사번', width: 100, halign: 'center', align: 'center'},
        {field: 'insDate', title: '검사일', width: 110, halign: 'center', align: 'center'},
        {field: 'qmsState', title: 'QMS 전송여부', width: 110, halign: 'center', align: 'center'},
        {field: 'procCode', title: '검사공정', width: 90, halign: 'center', align: 'left'},
        {field: 'procName', title: '검사공정명', width: 130, halign: 'center', align: 'left'},
        {field: 'insName', title: '검사항목명', width: 170, halign: 'center', align: 'left'},
        {field: 'insDesc', title: '점검내역', width: 190, halign: 'center', align: 'left'},
        {field: 'insType', title: 'TYPE', width: 70, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('C053', v); }},
        {field: 'avgVal', title: '기준값', width: 90, halign: 'center', align: 'left'},
        {field: 'insUnit', title: '단위', width: 70, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('C054', v); }},
        {field: 'minVal', title: 'Min', width: 80, halign: 'center', align: 'right'},
        {field: 'maxVal', title: 'Max', width: 80, halign: 'center', align: 'right'},
        {field: 'insResult', title: '검사값', width: 100, halign: 'center', align: 'left'},
        {field: 'insmNo', hidden: true},
        {field: 'insNo', hidden: true},
        {field: 'pltCode', hidden: true}
    ];
}

/* ========================================================================
 * 페이지 초기화
 * ======================================================================== */
$(function() {
    $.ajaxSetup({ statusCode: { 500: function() {
        $.messager.alert('Error', '오류가 발생했습니다.', 'error');
    }}});
    consts.init();
});

$(window).load(function() {
    hideLoadingBar();

    /* 검색 조건 Enter 키 바인딩 */
    $('#s_orderLike_assy').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) doSearch();
    });
    $('#s_hogiLike_assy').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) doSearch();
    });
    $('#s_modelLike_mach').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) doSearch();
    });

    enableGridSortReset('#grid-assy');
    enableGridSortReset('#grid-mach');
});

/* ========================================================================
 * 유틸 함수
 * ======================================================================== */

/**
 * 코드 값 → 코드명 변환
 */
function formatCode(codeGrup, value) {
    if (!value && value !== 0) return '';
    var strVal = String(value);
    if (codeDataMap[codeGrup]) {
        for (var i = 0; i < codeDataMap[codeGrup].length; i++) {
            if (codeDataMap[codeGrup][i].codeCd === strVal) {
                return codeDataMap[codeGrup][i].codeName;
            }
        }
    }
    return strVal;
}

/**
 * 사진보기 버튼 포맷터
 */
function formatImgButton(value, row, index) {
    var cnt = parseInt(row.imgCnt);
    if (cnt > 0) {
        return '<a href="javascript:void(0)" class="grid-btn grid-btn-blue"'
             + ' style="width:auto; padding:0 6px; font-size:11px;" title="사진보기">사진보기</a>';
    }
    return '<span class="grid-btn grid-btn-off"'
         + ' style="width:auto; padding:0 6px; font-size:11px;" title="없음">없음</span>';
}

/**
 * 로딩바 숨기기
 */
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

/* ========================================================================
 * 조회
 * ======================================================================== */

/**
 * 현재 탭 기준으로 조회
 */
function doSearch() {
    if (currentTab === 'assy') {
        doSearchAssy();
    } else {
        doSearchMach();
    }
}

/**
 * 조립 탭 조회
 */
function doSearchAssy() {
    var params = {
        plants: '3603',
        orderLike: $('#s_orderLike_assy').textbox('getText'),
        hogiLike: $('#s_hogiLike_assy').textbox('getText'),
        procCode: $('#s_procCode_assy').combogrid('getValue')
    };

    var opts = $('#grid-assy').datagrid('options');
    opts.url = consts.url.QCT08A_SER;
    $('#grid-assy').datagrid('load', params);
}

/**
 * 가공 탭 조회
 */
function doSearchMach() {
    var params = {
        plants: '3605',
        modelLike: $('#s_modelLike_mach').textbox('getText'),
        procCode: $('#s_procCode_mach').combogrid('getValue')
    };

    var opts = $('#grid-mach').datagrid('options');
    opts.url = consts.url.QCT08A_SER2;
    $('#grid-mach').datagrid('load', params);
}

/* ========================================================================
 * 이미지 조회
 * ======================================================================== */

/**
 * D0A 팝업 초기화 (onLoad 콜백)
 */
function initD0aPopup() {
    if (d0aInited) return;
    d0aInited = true;

    /* 닫기 버튼 바인딩 */
    $('#d0a-close-button').bind('click', function() {
        $('#d0a-popup').dialog('close');
    });

    /* 이미지 컨텍스트 메뉴 초기화 (readonly 모드: 복사, 저장만 활성) */
    _d0aImgMenu = new ImgContextMenu({
        menuId: 'd0a-img-context-menu',
        mode: 'readonly',
        targetSelector: '#d0a-img1',
        getImageBase64: function(cb) {
            _getD0aImgBase64($('#d0a-img1'), cb);
        },
        getFileName: function() { return 'QCT08A_IMG.png'; }
    });

    /* 첫 로드 시 pending 이미지 로드 */
    if (d0aPendingRow) {
        _loadD0aImage(d0aPendingRow);
        d0aPendingRow = null;
    }
}

/**
 * D0A 이미지의 base64 데이터 추출 (img src URL → XHR → base64)
 */
function _getD0aImgBase64($img, callback) {
    if (!$img || !$img.attr('src')) {
        callback(null);
        return;
    }
    var src = $img.attr('src');

    /* data URI인 경우 직접 추출 */
    if (src.indexOf('data:') === 0) {
        var idx = src.indexOf(',');
        callback(idx >= 0 ? src.substring(idx + 1) : null);
        return;
    }

    /* URL인 경우 XHR로 blob → base64 변환 */
    var xhr = new XMLHttpRequest();
    xhr.open('GET', src, true);
    xhr.responseType = 'blob';
    xhr.onload = function() {
        if (xhr.status === 200) {
            var reader = new FileReader();
            reader.onloadend = function() {
                var b64 = reader.result;
                var ci = b64.indexOf(',');
                callback(ci >= 0 ? b64.substring(ci + 1) : null);
            };
            reader.readAsDataURL(xhr.response);
        } else {
            callback(null);
        }
    };
    xhr.onerror = function() { callback(null); };
    xhr.send();
}

/**
 * 이미지 팝업 열기 (D0A dialog)
 */
function doOpenImage(row) {
    $('#d0a-popup').dialog('open').dialog('center');

    if (d0aInited) {
        _loadD0aImage(row);
    } else {
        d0aPendingRow = row;
    }
}

/**
 * D0A 이미지 로드
 */
function _loadD0aImage(row) {
    var imgEl = $('#d0a-img1');
    var emptyEl = $('#d0a-img1-empty');
    var loadingEl = $('#d0a-loading');

    /* 초기화: 로딩 표시 */
    imgEl.hide().attr('src', '');
    emptyEl.hide();
    loadingEl.show();

    /* 이미지 URL 생성 */
    var imgUrl = consts.url.QCT08A_IMG
        + '?gsPltCode=' + encodeURIComponent(row.pltCode)
        + '&insNo=' + encodeURIComponent(row.insNo);

    imgEl.off('load error');
    imgEl.on('load', function() {
        loadingEl.hide();
        $(this).show();
        emptyEl.hide();
    });
    imgEl.on('error', function() {
        loadingEl.hide();
        $(this).hide();
        emptyEl.show();
    });
    imgEl.attr('src', imgUrl);
}

/* ========================================================================
 * QMS 전송
 * ======================================================================== */

/**
 * QMS 전송
 */
function doQmsSend() {
    var gridId = (currentTab === 'assy') ? 'grid-assy' : 'grid-mach';
    var url = (currentTab === 'assy') ? consts.url.QCT08A_UPD : consts.url.QCT08A_UPD2;

    var checkedRows = $('#' + gridId).datagrid('getChecked');
    if (!checkedRows || checkedRows.length === 0) {
        $.messager.alert('알림', '전송할 항목을 선택하세요.', 'info');
        return;
    }

    /* 체크된 행에서 중복 제거된 INSM_NO 목록 추출 */
    var insmNoMap = {};
    var insmNoList = [];
    for (var i = 0; i < checkedRows.length; i++) {
        var no = checkedRows[i].insmNo;
        if (no && !insmNoMap[no]) {
            insmNoMap[no] = true;
            insmNoList.push(no);
        }
    }

    if (insmNoList.length === 0) {
        $.messager.alert('알림', '전송할 항목을 선택하세요.', 'info');
        return;
    }

    $.messager.confirm('확인', insmNoList.length + '건을 QMS에 전송하시겠습니까?', function(r) {
        if (r) {
            _sendQmsOne(insmNoList, 0, url, gridId);
        }
    });
}

/**
 * QMS 전송 순차 실행 (1건씩)
 */
function _sendQmsOne(insmNoList, idx, url, gridId) {
    if (idx >= insmNoList.length) {
        $.messager.alert('알림', insmNoList.length + '건 QMS 전송이 완료되었습니다.', 'info');
        doSearch();
        return;
    }

    $.ajax({
        url: url,
        type: 'POST',
        data: { insmNo: insmNoList[idx] },
        dataType: 'json',
        success: function(result) {
            _sendQmsOne(insmNoList, idx + 1, url, gridId);
        },
        error: function() {
            /* 공통 에러 핸들러에서 처리 */
        }
    });
}
