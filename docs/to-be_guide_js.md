# TO-BE JavaScript 가이드

> **Golden Sample**: `std45a.js`
> **작성자**: 송우석

---

## 1. 표준 구조

```javascript
/**
 * ============================================================================
 * 화면명: {SCREEN_ID} - {화면명}
 * ============================================================================
 * 설명: {기능 설명}
 * 원본: ProActive {SCREEN_ID}_M0A.cs, {SCREEN_ID}_D0A.cs
 * 작성일: {YYYY-MM-DD}
 * ============================================================================
 */

// 전역 변수
var changedRows = [];
var codeDataMap = {};

var consts = {
    url: {
        {SCREEN_ID}_SER: getUrl('/imes/{module}/{screenId}/{SCREEN_ID}_SER.json'),
        {SCREEN_ID}_INS: getUrl('/imes/{module}/{screenId}/{SCREEN_ID}_INS.json'),
        {SCREEN_ID}_UPD: getUrl('/imes/{module}/{screenId}/{SCREEN_ID}_UPD.json'),
        {SCREEN_ID}_DEL: getUrl('/imes/{module}/{screenId}/{SCREEN_ID}_DEL.json'),
        CODE_LIST: getUrl('/common/code/code.json')
    }
};
```

---

## 2. 초기화 순서 (MANDATORY)

```javascript
// 1단계: DOM Ready — 컴포넌트 구조 생성
$(function() {
    initGrid();
    initDialog();
});

// 2단계: Window Load — 데이터 로드 및 이벤트 바인딩
$(window).load(function() {
    setTimeout(function() {
        hideLoadingBar();
        bindButtonEvents();
        initComboboxData(function() {
            doSearch();
        });
    }, 100);
});
```

순서: `$(fn)` → initGrid/initDialog → `$(window).load` → hideLoadingBar → bindButtonEvents → initComboboxData → doSearch

---

## 3. 그리드 초기화

```javascript
function initGrid() {
    var frozenColumns = [[ /* 고정 컬럼 */ ]];
    var columns = [[ /* 일반 컬럼 */ ]];

    // 탭별 조건부 컬럼 추가
    if (typeof PAGE_SHOW_EXTRA !== 'undefined' && PAGE_SHOW_EXTRA) {
        columns[0].push({ field: 'extraCol', title: '추가컬럼', width: 120 });
    }

    $('#search-grid').datagrid({
        url: consts.url.{SCREEN_ID}_SER,
        method: 'post',
        fit: true,
        fitColumns: false,
        striped: true,
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        nowrap: true,
        idField: 'scode',
        toolbar: '#search-toolbar',
        frozenColumns: frozenColumns,
        columns: columns,
        onLoadSuccess: function(data) { changedRows = []; },
        onDblClickRow: function(index, row) { doOpenEdit(row); },
        onBeforeEdit: function(index, row) { row._original = $.extend({}, row); },
        onAfterEdit: function(index, row, changes) {
            if (Object.keys(changes).length > 0) markRowChanged(row);
        }
    });
}
```

---

## 4. 버튼 이벤트 바인딩

```javascript
function bindButtonEvents() {
    $('#search-button').bind('click', doSearch);
    $('#new-button').bind('click', doOpenNew);
    $('#save-button').bind('click', doSaveGrid);
    $('#delete-button').bind('click', doDelete);
    $('#dialog-save-button').bind('click', doSaveDialog);
    $('#dialog-cancel-button').bind('click', function() {
        $('#edit-dialog').dialog('close');
    });

    // Enter 키 검색
    $('#s_searchField').textbox('textbox').bind('keydown', function(e) {
        if (e.keyCode == 13) {
            $('#s_searchField').textbox('setValue', $(this).val());
            doSearch();
        }
    });
}
```

---

## 5. CRUD 함수

### 5.1 조회

```javascript
function doSearch() {
    var params = {
        plants: PAGE_PLANTS,
        searchLike: $('#s_searchField').textbox('getValue')
    };
    $('#search-grid').datagrid('load', params);
}
```

### 5.2 다이얼로그 (신규/수정)

```javascript
function doOpenNew() {
    clearDialogFields();
    $('#edit-dialog').dialog('setTitle', '{항목} 등록');
    $('#edit-dialog').dialog('open');
}

function doOpenEdit(row) {
    clearDialogFields();
    loadDialogFields(row);
    $('#edit-dialog').dialog('setTitle', '{항목} 수정');
    $('#edit-dialog').dialog('open');
}
```

### 5.3 다이얼로그 저장 (INS/UPSERT)

```javascript
function doSaveDialog() {
    if (!validateDialogFields()) return;
    var params = getDialogParams();

    $.ajax({
        url: consts.url.{SCREEN_ID}_INS,
        type: 'POST',
        data: params,
        success: function(result) {
            if (result.success) {
                $.messager.alert(getTitle('INFO'), result.message || getMessage('SAVED'), 'info');
                $('#edit-dialog').dialog('close');
                doSearch();
            } else {
                $.messager.alert(getTitle('ERROR'), result.message, 'error');
            }
        },
        error: function() {
            $.messager.alert(getTitle('ERROR'), '저장 중 오류가 발생했습니다.', 'error');
        }
    });
}
```

### 5.4 그리드 일괄 저장 (UPD)

```javascript
function doSaveGrid() {
    // 편집 중인 행 종료
    var grid = $('#search-grid');
    var editingIndex = grid.datagrid('options').editIndex;
    if (editingIndex !== undefined) grid.datagrid('endEdit', editingIndex);

    // 변경 행 수집
    var changes = grid.datagrid('getChanges');
    if (changes.length === 0 && changedRows.length === 0) {
        $.messager.alert(getTitle('INFO'), getMessage('NO_CHANGED'), 'info');
        return;
    }

    // 중복 제거 후 전송
    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_SAVE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.{SCREEN_ID}_UPD,
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({rows: rows}),
                success: function(result) {
                    if (result.success) {
                        changedRows = [];
                        doSearch();
                    }
                }
            });
        }
    });
}
```

### 5.5 삭제 (DEL)

```javascript
function doDelete() {
    var row = $('#search-grid').datagrid('getSelected');
    if (!row) {
        $.messager.alert(getTitle('WARNING'), getMessage('SELECT_DELETE'), 'warning');
        return;
    }

    $.messager.confirm(getTitle('CONFIRM'), getMessage('CONFIRM_DELETE'), function(r) {
        if (r) {
            $.ajax({
                url: consts.url.{SCREEN_ID}_DEL,
                type: 'POST',
                data: {scode: row.scode},
                success: function(result) {
                    if (result.success) doSearch();
                }
            });
        }
    });
}
```

---

## 6. 다이얼로그 4종 함수

| 함수                     | 용도                               |
|--------------------------|------------------------------------|
| `clearDialogFields()`   | 모든 필드 초기화 (신규 시)          |
| `loadDialogFields(row)` | 행 데이터로 필드 설정 (수정 시)     |
| `validateDialogFields()`| 필수값 검증, 실패 시 false 반환     |
| `getDialogParams()`     | 필드값을 객체로 수집, AJAX data로 사용 |

체크박스 값 규칙: `$('#f_isNg').is(':checked') ? '1' : '0'` (AS-IS DevExpress 패턴)

---

## 7. 포맷터 함수

```javascript
// 체크박스 포맷터
function formatCheck(value, row, index) {
    return (value == '1' || value == 'Y')
        ? '<input type="checkbox" checked/>'
        : '<input type="checkbox" />';
}

// 코드값 → 코드명 포맷터
function formatCode(codeGrup, value) {
    if (!value) return '';
    if (codeDataMap[codeGrup]) {
        for (var i = 0; i < codeDataMap[codeGrup].length; i++) {
            if (codeDataMap[codeGrup][i].codeCd === value)
                return codeDataMap[codeGrup][i].codeName;
        }
    }
    return value;
}
```

---

## 8. 코드 데이터 로드 (캐시)

```javascript
function initComboboxData(callback) {
    var codeGroups = ['S901', 'S902', 'S900', 'W004'];
    var loadedCount = 0;

    function onCodeLoaded() {
        loadedCount++;
        if (loadedCount >= codeGroups.length && callback) callback();
    }

    codeGroups.forEach(function(group) {
        loadCodeData(group, function(data) {
            // 다이얼로그 콤보박스 설정
            // 그리드 에디터 데이터 설정
            onCodeLoaded();
        });
    });
}

function loadCodeData(codeGrup, callback) {
    if (codeDataMap[codeGrup]) { if (callback) callback(codeDataMap[codeGrup]); return; }

    $.ajax({
        url: consts.url.CODE_LIST,
        type: 'POST',
        data: { codeGrup: codeGrup },
        dataType: 'json',
        success: function(response) {
            var data = response.rows || response || [];
            codeDataMap[codeGrup] = data;
            if (callback) callback(data);
        },
        error: function() { if (callback) callback([]); }
    });
}
```

---

## 9. 다국어 메시지 함수

```javascript
function getTitle(key) {
    if (typeof tit !== 'undefined') {
        switch (key) {
            case 'ALERT': return tit.TITLE0001 || '알림';
            case 'INFO': return msg.MSG0052 || '정보';
            case 'WARNING': return msg.MSG0051 || '경고';
            case 'ERROR': return msg.MSG0068 || '오류';
            case 'CONFIRM': return msg.MSG0053 || '확인';
        }
    }
    var defaults = {ALERT:'알림', INFO:'정보', WARNING:'경고', ERROR:'오류', CONFIRM:'확인'};
    return defaults[key] || key;
}

function getMessage(key) {
    if (typeof msg !== 'undefined') {
        switch (key) {
            case 'SAVED': return msg.MSG0021 || '저장되었습니다.';
            case 'DELETED': return msg.MSG0054 || '삭제되었습니다.';
            case 'NO_CHANGED': return msg.MSG0022 || '변경된 데이터가 없습니다.';
            case 'SELECT_DELETE': return msg.MSG0016 || '삭제할 항목을 선택하세요.';
            case 'CONFIRM_SAVE': return msg.MSG0036 || '저장하시겠습니까?';
            case 'CONFIRM_DELETE': return msg.MSG0030 || '삭제하시겠습니까?';
        }
    }
    var defaults = {
        SAVED:'저장되었습니다.', DELETED:'삭제되었습니다.',
        NO_CHANGED:'변경된 데이터가 없습니다.', SELECT_DELETE:'삭제할 항목을 선택하세요.',
        CONFIRM_SAVE:'저장하시겠습니까?', CONFIRM_DELETE:'삭제하시겠습니까?'
    };
    return defaults[key] || key;
}
```

---

## 10. 유틸리티

```javascript
function hideLoadingBar() {
    $('#loadingProgressBar').hide();
    $('#account-layout').show();
}

function markRowChanged(row) {
    if (!row.scode) return;
    for (var i = 0; i < changedRows.length; i++) {
        if (changedRows[i].scode === row.scode) { changedRows[i] = row; return; }
    }
    changedRows.push(row);
}
```

---

## 11. JS 규칙 요약

| 규칙                        | 설명                                                      |
|-----------------------------|-----------------------------------------------------------|
| URL 상수                    | `consts.url.{METHOD}` = `getUrl(...)` 사용                |
| 초기화 순서                 | 섹션 2 필수 준수                                          |
| 이벤트 바인딩               | `$('#id').bind('click', fn)` — 인라인 이벤트 금지          |
| 코드 데이터                 | `codeDataMap` 캐시 + `loadCodeData()` 함수                 |
| 포맷터                      | `formatCheck()` — 체크박스, `formatCode()` — 코드명        |
| 다이얼로그                  | clear → load → validate → getParams 4종 함수 세트          |
| AJAX 단건                   | `type: 'POST'`, `data: params`                            |
| AJAX 다건                   | `contentType: 'application/json'`, `JSON.stringify({rows})` |
| 삭제 전 확인                | `$.messager.confirm(...)` 필수                             |
| 파일명                      | 소문자만: `{screenId}.js`                                  |
| 탭 분기                     | `PAGE_*` 전역 변수로 조건 분기                             |
