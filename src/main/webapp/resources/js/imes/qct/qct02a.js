/*
 * ============================================================================
 * 화면명: QCT02A - 부적합/결품 현황
 * ============================================================================
 * 설명: 부적합/결품 데이터 조회 전용
 *       내부 탭으로 조립(PLANTS=3603) / 가공(PLANTS=3605) 구분
 *       D0A: 사진보기 팝업 (이미지 4개)
 * 작성일: 2026-03-09
 * @author 송우석
 * ============================================================================
 */

/* 코드 데이터 캐시 */
var codeDataMap = {};

/* D0A 팝업 초기화 guard */
var d0aInited = false;

/* D0A 이미지 로드 pending 데이터 (href 첫 로드 대응) */
var d0aPendingRow = null;

/* D0A 이미지 컨텍스트 메뉴 (공통 모듈 인스턴스) */
var _d0aImgMenu = null;
var _d0aImgTarget = null;  // 우클릭 대상 <img> 요소

/* 현재 선택된 탭 ('assy' 또는 'mach') */
var currentTab = 'assy';

/* ========================================================================
 * URL 및 초기화
 * ======================================================================== */
var consts = {
    url: {
        QCT02A_SER:  getUrl('/imes/qct/qct02a/QCT02A_SER.json'),
        QCT02A_IMG:  getUrl('/imes/qct/qct02a/QCT02A_IMG.json'),
        QCT02A_PROC: getUrl('/imes/qct/qct02a/QCT02A_PROC.json'),
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
        consts.codeData.Q003 = this.loadCode('Q003');
        consts.codeData.Q007 = this.loadCode('Q007');
        consts.codeData.Q002 = this.loadCode('Q002');
        consts.codeData.Q001 = this.loadCode('Q001');
        consts.codeData.S907 = this.loadCode('S907');

        /* 날짜타입 콤보박스 초기화 (조립/가공 각각) */
        var dateTypeData = [{codeCd: 'NG_DATE', codeName: '부적합발생일'}];
        $('#s_dateType_assy').combobox({
            data: dateTypeData, valueField: 'codeCd', textField: 'codeName',
            width: 120, panelHeight: 'auto', editable: false
        });
        $('#s_dateType_assy').combobox('setValue', 'NG_DATE');

        $('#s_dateType_mach').combobox({
            data: dateTypeData, valueField: 'codeCd', textField: 'codeName',
            width: 120, panelHeight: 'auto', editable: false
        });
        $('#s_dateType_mach').combobox('setValue', 'NG_DATE');

        /* 상태 콤보박스 초기화 (조립/가공 각각) */
        var ngStateData = [{codeCd: '', codeName: '전체'}].concat(consts.codeData.Q003);
        $('#s_ngState_assy').combobox({
            data: ngStateData, valueField: 'codeCd', textField: 'codeName',
            width: 120, panelHeight: 'auto', editable: false
        });
        $('#s_ngState_assy').combobox('setValue', '');

        $('#s_ngState_mach').combobox({
            data: ngStateData, valueField: 'codeCd', textField: 'codeName',
            width: 120, panelHeight: 'auto', editable: false
        });
        $('#s_ngState_mach').combobox('setValue', '');

        /* 공정 combogrid 초기화 (QCT05A D0A 패턴) */
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
            url: consts.url.QCT02A_PROC
        });

        /* 공정 찾기 돋보기 버튼 바인딩 (QCT05A D0A 패턴) */
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

        /* 탭 전환 이벤트 */
        $('#main-tabs').tabs({
            onSelect: function(title, index) {
                if (index === 0) {
                    currentTab = 'assy';
                } else {
                    currentTab = 'mach';
                }
            }
        });

        /* 버튼 바인딩 */
        $('#search-button').bind('click', doSearch);
        $('#d0a-close-button').bind('click', function() {
            $('#d0a-popup').dialog('close');
        });
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
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'NG_ID',
        loadMsg: '조회 중...',
        columns: [columns],
        onLoadSuccess: function(data) {
            /* 로딩 완료 */
        },
        onClickCell: function(index, field, value) {
            if (field === 'IMG_OPEN') {
                var row = $('#' + gridId).datagrid('getRows')[index];
                if (row && parseInt(row.IMG_CNT) > 0) {
                    doOpenD0a(row);
                }
            }
        }
    });

    /* noStyle 적용 (컬럼 width:100% 강제 확장 방지) */
    $('#' + gridId).datagrid('getPanel').find('.datagrid-view').addClass('noStyle');
}

/**
 * 조립 탭 그리드 컬럼 (NG_ID 표시, ORDER_NO_LINE, MODEL_CODE 포함)
 */
function getAssyColumns() {
    return [
        {field: 'NG_ID', title: '부적합/결품ID', width: 90, halign: 'center', align: 'center'},
        {field: 'PROD_TYPE', title: '구분', width: 40, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('S907', v); }},
        {field: 'NG_STATE', title: '상태', width: 40, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('Q003', v); }},
        {field: 'QMS_SEND_DATE', title: '전송일자', width: 70, halign: 'center', align: 'center',
            formatter: formatDate},
        {field: 'STATUS_CD', title: '상태(QMS)', width: 60, halign: 'center', align: 'left'},
        {field: 'SAP_WO_NO', title: '작업오더', width: 80, halign: 'center', align: 'center'},
        {field: 'NG_CLASS', title: '발생분류', width: 55, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('Q007', v); }},
        {field: 'NG_DATE', title: '발생일', width: 70, halign: 'center', align: 'center',
            formatter: formatDateStr},
        {field: 'EMP_CODE', title: '등록자코드', width: 70, halign: 'center', align: 'center'},
        {field: 'EMP_NAME', title: '등록자', width: 60, halign: 'center', align: 'center'},
        {field: 'ORDER_NO_LINE', title: '기계번호/판매오더', width: 110, halign: 'center', align: 'center'},
        {field: 'PROC_CODE', title: '공정', width: 55, halign: 'center', align: 'center'},
        {field: 'MODEL_CODE', title: '모델코드', width: 75, halign: 'center', align: 'center'},
        {field: 'PART_CODE', title: '자재번호', width: 90, halign: 'center', align: 'center'},
        {field: 'PART_NAME', title: '자재내역', width: 120, halign: 'center', align: 'left'},
        {field: 'VEN_CODE', title: '고객코드', width: 70, halign: 'center', align: 'center'},
        {field: 'VEN_NAME', title: '고객명', width: 100, halign: 'center', align: 'left'},
        {field: 'NG_PART_CODE', title: '부적합 자재번호', width: 90, halign: 'center', align: 'left'},
        {field: 'IDLE_NAME', title: '비가동명', width: 80, halign: 'center', align: 'left'},
        {field: 'MASTER_CAUSE', title: '불량유형', width: 55, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('Q002', v); }},
        {field: 'DETAIL_CAUSE', title: '불량유형 상세', width: 70, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('Q001', v); }},
        {field: 'NG_CONTENTS', title: '불량현상', width: 130, halign: 'center', align: 'left'},
        {field: 'IDLE_TIME', title: '비가동 시간(분)', width: 80, halign: 'center', align: 'right'},
        {field: 'IMG_CNT', title: '사진', width: 35, halign: 'center', align: 'center'},
        {field: 'IMG_OPEN', title: '사진보기', width: 55, halign: 'center', align: 'center',
            formatter: formatImgButton},
        {field: 'SCND_CHRGR_DEPT_NM', title: '품질 담당자 부서', width: 95, halign: 'center', align: 'left'},
        {field: 'SCND_CHRGR_NM', title: '품질담당자명', width: 75, halign: 'center', align: 'left'},
        {field: 'FRST_IMPT_CD', title: '귀책구분', width: 55, halign: 'center', align: 'left'},
        {field: 'MANAGT_CD', title: '현품처리 구분', width: 70, halign: 'center', align: 'left'},
        {field: 'MTRIL_NOC', title: '원인자재', width: 70, halign: 'center', align: 'left'},
        {field: 'FRST_BADN_TYPE_CD1', title: '불량유형1', width: 60, halign: 'center', align: 'left'},
        {field: 'FRST_BADN_TYPE_CD2', title: '불량유형2', width: 60, halign: 'center', align: 'left'},
        {field: 'CAUSE_ANAY_CN', title: '분석 내용', width: 130, halign: 'center', align: 'left'},
        {field: 'IMPT_ACC_NM', title: '처리결과-등록자', width: 80, halign: 'center', align: 'left'},
        {field: 'IMPT_COMPT_DATE', title: '처리결과-완료일', width: 85, halign: 'center', align: 'center'},
        {field: 'IMPT_MANAGT_CN', title: '처리결과-조치내역', width: 140, halign: 'center', align: 'left'},
        {field: 'CAUSES', title: '처리결과-발생원인', width: 140, halign: 'center', align: 'left'},
        {field: 'RELAPSE_PREVENTION', title: '처리결과-재발방지책', width: 140, halign: 'center', align: 'left'}
    ];
}

/**
 * 가공 탭 그리드 컬럼 (NG_ID 숨김, MODEL 사용)
 */
function getMachColumns() {
    return [
        {field: 'NG_STATE', title: '상태', width: 40, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('Q003', v); }},
        {field: 'QMS_SEND_DATE', title: '전송일자', width: 70, halign: 'center', align: 'center',
            formatter: formatDate},
        {field: 'STATUS_CD', title: '상태(QMS)', width: 60, halign: 'center', align: 'left'},
        {field: 'SAP_WO_NO', title: '작업오더', width: 80, halign: 'center', align: 'center'},
        {field: 'NG_CLASS', title: '발생분류', width: 55, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('Q007', v); }},
        {field: 'NG_DATE', title: '발생일', width: 70, halign: 'center', align: 'center',
            formatter: formatDateStr},
        {field: 'EMP_CODE', title: '등록자코드', width: 70, halign: 'center', align: 'center'},
        {field: 'EMP_NAME', title: '등록자', width: 60, halign: 'center', align: 'center'},
        {field: 'PROC_CODE', title: '공정', width: 55, halign: 'center', align: 'center'},
        {field: 'MODEL', title: '모델코드', width: 75, halign: 'center', align: 'center'},
        {field: 'PART_CODE', title: '자재번호', width: 90, halign: 'center', align: 'center'},
        {field: 'PART_NAME', title: '자재내역', width: 120, halign: 'center', align: 'left'},
        {field: 'VEN_CODE', title: '고객코드', width: 70, halign: 'center', align: 'center'},
        {field: 'VEN_NAME', title: '고객명', width: 100, halign: 'center', align: 'left'},
        {field: 'NG_PART_CODE', title: '부적합 자재번호', width: 90, halign: 'center', align: 'left'},
        {field: 'MASTER_CAUSE', title: '불량유형', width: 55, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('Q002', v); }},
        {field: 'DETAIL_CAUSE', title: '불량유형 상세', width: 70, halign: 'center', align: 'center',
            formatter: function(v) { return formatCode('Q001', v); }},
        {field: 'NG_CONTENTS', title: '불량현상', width: 130, halign: 'center', align: 'left'},
        {field: 'IMG_CNT', title: '사진', width: 35, halign: 'center', align: 'center'},
        {field: 'IMG_OPEN', title: '사진보기', width: 55, halign: 'center', align: 'center',
            formatter: formatImgButton},
        {field: 'SCND_CHRGR_DEPT_NM', title: '품질 담당자 부서', width: 95, halign: 'center', align: 'left'},
        {field: 'SCND_CHRGR_NM', title: '품질담당자명', width: 75, halign: 'center', align: 'left'},
        {field: 'FRST_IMPT_CD', title: '귀책구분', width: 55, halign: 'center', align: 'left'},
        {field: 'MANAGT_CD', title: '현품처리 구분', width: 70, halign: 'center', align: 'left'},
        {field: 'MTRIL_NOC', title: '원인자재', width: 70, halign: 'center', align: 'left'},
        {field: 'FRST_BADN_TYPE_CD1', title: '불량유형1', width: 60, halign: 'center', align: 'left'},
        {field: 'FRST_BADN_TYPE_CD2', title: '불량유형2', width: 60, halign: 'center', align: 'left'},
        {field: 'CAUSE_ANAY_CN', title: '분석 내용', width: 130, halign: 'center', align: 'left'},
        {field: 'IMPT_ACC_NM', title: '처리결과-등록자', width: 80, halign: 'center', align: 'left'},
        {field: 'IMPT_COMPT_DATE', title: '처리결과-완료일', width: 85, halign: 'center', align: 'center'},
        {field: 'IMPT_MANAGT_CN', title: '처리결과-조치내역', width: 140, halign: 'center', align: 'left'},
        {field: 'CAUSES', title: '처리결과-발생원인', width: 140, halign: 'center', align: 'left'},
        {field: 'RELAPSE_PREVENTION', title: '처리결과-재발방지책', width: 140, halign: 'center', align: 'left'}
    ];
}

/* ========================================================================
 * 페이지 초기화
 * ======================================================================== */
$(function() {
    // 500 에러 시 raw 메시지 대신 일반 메시지 표시
    $.ajaxSetup({ statusCode: { 500: function() {
        $.messager.alert('Error', '오류가 발생했습니다.', 'error');
    }}});
    consts.init();
});

$(window).load(function() {
    hideLoadingBar();

    /* 검색 조건 Enter 키 바인딩 (combogrid 내부 text input) */
    var $assyText = $('#s_procCode_assy').next('.combo').find('input.combo-text');
    if ($assyText.length) {
        $assyText.bind('keydown', function(e) { if (e.keyCode == 13) doSearch(); });
    }
    var $machText = $('#s_procCode_mach').next('.combo').find('input.combo-text');
    if ($machText.length) {
        $machText.bind('keydown', function(e) { if (e.keyCode == 13) doSearch(); });
    }

    GridHeaderMenu('#grid-assy', { exportFileName: '부적합결품현황_조립' });
    GridHeaderMenu('#grid-mach', { exportFileName: '부적합결품현황_가공' });
    enableGridSortReset('#grid-assy');
    enableGridSortReset('#grid-mach');

    /* 기본 날짜 설정 (7일 전 ~ 오늘) */
    initDefaultDate();
});

/* ========================================================================
 * 유틸 함수
 * ======================================================================== */

/**
 * 기본 날짜 설정 (7일 전 ~ 오늘)
 */
function initDefaultDate() {
    var today = new Date();
    var weekAgo = new Date();
    weekAgo.setDate(today.getDate() - 7);

    var todayStr = formatDateToStr(today);
    var weekAgoStr = formatDateToStr(weekAgo);

    $('#s_sNgDate_assy').datebox('setValue', weekAgoStr);
    $('#s_eNgDate_assy').datebox('setValue', todayStr);
    $('#s_sNgDate_mach').datebox('setValue', weekAgoStr);
    $('#s_eNgDate_mach').datebox('setValue', todayStr);
}

/**
 * Date 객체를 yyyy-MM-dd 문자열로 변환
 */
function formatDateToStr(d) {
    var yyyy = d.getFullYear();
    var mm = ('0' + (d.getMonth() + 1)).slice(-2);
    var dd = ('0' + d.getDate()).slice(-2);
    return yyyy + '-' + mm + '-' + dd;
}

/**
 * 코드 값 → 코드명 변환
 */
function formatCode(codeGrup, value) {
    if (!value) return '';
    if (codeDataMap[codeGrup]) {
        for (var i = 0; i < codeDataMap[codeGrup].length; i++) {
            if (codeDataMap[codeGrup][i].codeCd === value) {
                return codeDataMap[codeGrup][i].codeName;
            }
        }
    }
    return value;
}

/**
 * datetime 포맷 (yyyy-MM-dd)
 */
function formatDate(value) {
    if (!value) return '';
    if (typeof value === 'string' && value.length >= 10) {
        return value.substring(0, 10);
    }
    return value;
}

/**
 * yyyyMMdd 문자열을 yyyy-MM-dd로 변환
 */
function formatDateStr(value) {
    if (!value) return '';
    if (typeof value === 'string' && value.length === 8) {
        return value.substring(0, 4) + '-' + value.substring(4, 6) + '-' + value.substring(6, 8);
    }
    return value;
}

/**
 * 사진보기 버튼 포맷터
 */
function formatImgButton(value, row, index) {
    var cnt = parseInt(row.IMG_CNT);
    if (cnt > 0) {
        return '<a href="javascript:void(0)" class="grid-btn grid-btn-blue"'
             + ' style="width:auto; padding:0 4px; font-size:11px;" title="사진 보기">사진보기</a>';
    }
    return '<span class="grid-btn grid-btn-off"'
         + ' style="width:auto; padding:0 4px; font-size:11px;" title="사진 없음">없음</span>';
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
    var sDate = $('#s_sNgDate_assy').datebox('getValue');
    var eDate = $('#s_eNgDate_assy').datebox('getValue');

    var params = {
        plants: '3603',
        procCode: $('#s_procCode_assy').combogrid('getValue'),
        ngState: $('#s_ngState_assy').combobox('getValue'),
        sNgDate: sDate ? sDate.replace(/-/g, '') : '',
        eNgDate: eDate ? eDate.replace(/-/g, '') : ''
    };

    var opts = $('#grid-assy').datagrid('options');
    opts.url = consts.url.QCT02A_SER;
    $('#grid-assy').datagrid('load', params);
}

/**
 * 가공 탭 조회
 */
function doSearchMach() {
    var sDate = $('#s_sNgDate_mach').datebox('getValue');
    var eDate = $('#s_eNgDate_mach').datebox('getValue');

    var params = {
        plants: '3605',
        procCode: $('#s_procCode_mach').combogrid('getValue'),
        ngState: $('#s_ngState_mach').combobox('getValue'),
        sNgDate: sDate ? sDate.replace(/-/g, '') : '',
        eNgDate: eDate ? eDate.replace(/-/g, '') : ''
    };

    var opts = $('#grid-mach').datagrid('options');
    opts.url = consts.url.QCT02A_SER;
    $('#grid-mach').datagrid('load', params);
}

/* ========================================================================
 * D0A 사진보기 팝업
 * ======================================================================== */

/**
 * D0A 팝업 초기화 (onLoad 콜백)
 * href 콘텐츠 로드 완료 후 호출됨
 */
function initD0aPopup() {
    if (d0aInited) return;
    d0aInited = true;

    /* 이미지 컨텍스트 메뉴 초기화 (readonly 모드: 복사, 저장만 활성) */
    _d0aImgMenu = new ImgContextMenu({
        menuId: 'd0a-img-context-menu',
        mode: 'readonly',
        getImageBase64: function(cb) {
            _getD0aImgBase64(_d0aImgTarget, cb);
        },
        setImageData: function() { /* readonly — 미사용 */ },
        getFileName: function() {
            var imgNo = _d0aImgTarget ? _d0aImgTarget.attr('id').replace('d0a-img', '') : '1';
            return 'QCT02A_IMG_' + imgNo + '.png';
        }
    });

    /* 이미지 요소에 contextmenu 이벤트 바인딩 */
    for (var i = 1; i <= 4; i++) {
        (function(idx) {
            $('#d0a-img' + idx).off('contextmenu').on('contextmenu', function(e) {
                e.preventDefault();
                _d0aImgTarget = $(this);
                var hasImg = (_d0aImgTarget.css('display') !== 'none' && _d0aImgTarget.attr('src'));
                _d0aImgMenu.show(e, !!hasImg);
            });
        })(i);
    }

    /* 첫 로드 시 pending 이미지 로드 실행 */
    if (d0aPendingRow) {
        _loadD0aImages(d0aPendingRow);
        d0aPendingRow = null;
    }
}

/**
 * D0A 이미지의 base64 데이터 추출 (img src → XHR → base64)
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
 * D0A 이미지 로드 (내부 함수)
 */
function _loadD0aImages(row) {
    /* 이미지 초기화 */
    for (var i = 1; i <= 4; i++) {
        $('#d0a-img' + i).hide().attr('src', '');
        $('#d0a-img' + i + '-empty').show();
    }
    /* 이미지 로드 */
    var imgCnt = parseInt(row.IMG_CNT);
    for (var j = 1; j <= imgCnt && j <= 4; j++) {
        loadD0aImage(j, row.PLT_CODE, row.NG_ID);
    }
}

/**
 * D0A 팝업 열기
 */
function doOpenD0a(row) {
    /* 팝업 열기 */
    $('#d0a-popup').dialog('open').dialog('center');

    if (d0aInited) {
        /* href 이미 로드됨 → 바로 이미지 로드 */
        _loadD0aImages(row);
    } else {
        /* 첫 로드 → initD0aPopup에서 실행하도록 예약 */
        d0aPendingRow = row;
    }
}

/**
 * D0A 이미지 로드
 */
function loadD0aImage(imgNo, pltCode, ngId) {
    var imgUrl = consts.url.QCT02A_IMG
        + '?gsPltCode=' + encodeURIComponent(pltCode)
        + '&ngId=' + encodeURIComponent(ngId)
        + '&imgNo=' + imgNo;

    var imgEl = $('#d0a-img' + imgNo);
    var emptyEl = $('#d0a-img' + imgNo + '-empty');

    imgEl.off('load error');
    imgEl.on('load', function() {
        $(this).show();
        emptyEl.hide();
    });
    imgEl.on('error', function() {
        $(this).hide();
        emptyEl.show();
    });
    imgEl.attr('src', imgUrl);
}
