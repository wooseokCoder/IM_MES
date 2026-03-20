/**
 * ============================================================================
 * 화면: ORD18A_D0A - 오더 완료일 수정 팝업
 * ============================================================================
 * 원본: ProActive ORD18A_D0A.cs
 * 작성일: 2026-03-06
 *
 * 기능:
 *   - ACT_START_TIME, ACT_END_TIME 수정
 *   - 시간 유효성 검증 (시작 > 종료 불가)
 *   - 저장 시 ORD18A_UPD 호출
 * ============================================================================
 */

var consts = {
    url: {
        ORD18A_UPD: getUrl('/imes/ord/ord18a/ORD18A_UPD.json')
    },

    /** 부모에서 전달받은 WO_NO */
    woNo: '',

    init: function() {
        // URL 파라미터 파싱
        var params = getUrlParams();
        this.woNo = params.woNo || '';

        // 버튼 이벤트
        $('#save-button').bind('click', doSave);
    }
};

$(function() {
    consts.init();
});

$(window).load(function() {
    // URL 파라미터에서 초기값 설정
    var params = getUrlParams();

    if (params.actStartTime) {
        $('#f_actStartTime').datetimebox('setValue', formatDateTimeForBox(params.actStartTime));
    }
    if (params.actEndTime) {
        $('#f_actEndTime').datetimebox('setValue', formatDateTimeForBox(params.actEndTime));
    }

    hideLoadingBar();
});

// ============================================================================
// 저장
// ============================================================================

function doSave() {
    var startTime = $('#f_actStartTime').datetimebox('getValue');
    var endTime = $('#f_actEndTime').datetimebox('getValue');

    if (!startTime || !endTime) {
        $.messager.alert('알림', '시작시간과 종료시간을 입력하세요.');
        return;
    }

    // 시간 유효성 검증 (AS-IS: 시작 > 종료 불가)
    if (startTime > endTime) {
        $.messager.alert('알림', '시간설정이 잘못되었습니다.');
        return;
    }

    $.ajax({
        url: consts.url.ORD18A_UPD,
        type: 'POST',
        data: {
            woNo: consts.woNo,
            actStartTime: startTime,
            actEndTime: endTime
        },
        dataType: 'json',
        success: function(result) {
            if (result.success != false) {
                $.messager.alert('알림', '저장되었습니다.', 'info', function() {
                    window.close();
                });
            } else {
                $.messager.alert('오류', result.message || '저장 실패', 'error');
            }
        },
        error: function() {
            $.messager.alert('오류', '저장 중 오류가 발생했습니다.', 'error');
        }
    });
}

// ============================================================================
// 유틸리티
// ============================================================================

/**
 * URL 파라미터 파싱
 */
function getUrlParams() {
    var params = {};
    var search = window.location.search.substring(1);
    if (search) {
        var pairs = search.split('&');
        for (var i = 0; i < pairs.length; i++) {
            var pair = pairs[i].split('=');
            params[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1] || '');
        }
    }
    return params;
}

/**
 * yyyyMMddHHmmss 또는 datetime → yyyy-MM-dd HH:mm:ss (datetimebox 값 형식)
 */
function formatDateTimeForBox(value) {
    if (!value) return '';
    var s = String(value).replace(/[-:T ]/g, '');
    if (s.length < 8) return value;
    var result = s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6, 8);
    if (s.length >= 14) {
        result += ' ' + s.substring(8, 10) + ':' + s.substring(10, 12) + ':' + s.substring(12, 14);
    } else if (s.length >= 12) {
        result += ' ' + s.substring(8, 10) + ':' + s.substring(10, 12) + ':00';
    } else if (s.length >= 10) {
        result += ' ' + s.substring(8, 10) + ':00:00';
    } else {
        result += ' 00:00:00';
    }
    return result;
}

function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}
