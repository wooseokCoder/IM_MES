# TO-BE JSP 가이드

> **Golden Sample**: `std45a_assy.jsp`, `std45a_mach.jsp`
> **작성자**: 송우석

---

## 1. 표준 구조

```jsp
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#){screenId}.jsp 1.0 {YYYY/MM/DD}                                   --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2026 WSC, INC.                                           --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- 화면별 변수 (필요시) -->
<script type="text/javascript">
    var PAGE_PLANTS = '${plants}';
    var PAGE_PLANTS_NAME = '${plantsName}';
</script>

<script type="text/javascript"
    src="<c:url value="/resources/js/imes/{module}/{screenId}.js?v=YYMMDDX" />"></script>

</head>

<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 로딩바 -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- 메인 레이아웃 -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

    <table id="search-grid"></table>

    <div id="search-toolbar" class="wui-toolbar">
        <form id="search-form">
            <!-- 검색 영역 -->
            <fieldset class="Remake-div-line-new">
                <table cellpadding="7" class="search-table tableSearch-c wd-100">
                    <colgroup>
                        <col width="13%"><col width="20%"><col width="*">
                    </colgroup>
                    <tr class="topnav_sty">
                        <td colspan="4">
                            <div>
                                <%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
                                <div>
                                    <a href="javascript:void(0)" id="search-button"
                                        class="easyui-linkbutton cgray" data-item="BTN_000"
                                        data-options="disabled:${RET}">조회</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th class="h table-Search-h"><span>라벨</span></th>
                        <td class="d">
                            <input id="s_field" class="easyui-textbox" data-options="width:220"/>
                        </td>
                        <td class="b w-a" colspan="2"></td>
                    </tr>
                </table>
            </fieldset>

            <!-- 버튼 영역 -->
            <fieldset class="div-line-new-sub grd-div-btn">
                <table cellpadding="7" class="search-table tableEtc-c wd-100">
                    <tr><td class="h">
                        <div class="dis_flex_gap4">
                            <a href="javascript:void(0)" class="easyui-linkbutton c6"
                                id="new-button" data-options="disabled:${INS}">신규</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6"
                                id="save-button" data-options="disabled:${UPD}">저장</a>
                            <a href="javascript:void(0)" class="easyui-linkbutton c6"
                                id="delete-button" data-options="disabled:${DEL}">삭제</a>
                        </div>
                    </td></tr>
                </table>
            </fieldset>
        </form>
    </div>

    <div data-options="region:'north', border:true" id="search-grid-panel"></div>
</div>

<!-- 편집 다이얼로그 -->
<div id="edit-dialog" class="easyui-dialog"
    style="width:500px;height:auto;padding:10px 20px"
    data-options="closed:true, modal:true, buttons:'#edit-dialog-buttons'">
    <form id="edit-form" method="post">
        <input type="hidden" id="f_scode" name="scode"/>
        <fieldset class="div-line-new-sub">
            <table class="popup-search-table">
                <!-- 폼 필드 -->
            </table>
        </fieldset>
    </form>
</div>
<div id="edit-dialog-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-save-button">저장</a>
    <a href="javascript:void(0)" class="easyui-linkbutton c6" id="dialog-cancel-button">취소</a>
</div>

<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
</html>
```

---

## 2. 필수 Include 파일

| Include                    | 위치     | 누락 시 영향              |
|----------------------------|----------|---------------------------|
| `common.jsp`               | `<head>` | 모든 UI 컴포넌트 동작 불가 |
| `body.head.jsp`            | body 시작 | 레이아웃 깨짐             |
| `topnav.jsp`               | body 상단 | 상단 네비게이션 누락       |
| `topnav2.jsp`              | 검색 영역 | 화면 제목/경로 누락        |
| `body.foot.jsp`            | body 끝   | 렌더링 오류               |

---

## 3. ID/Name 규칙

| 용도             | 접두사/ID             | 예시                         |
|------------------|-----------------------|------------------------------|
| 검색 필드        | `s_`                  | `s_idleLike`, `s_plants`     |
| 폼 필드          | `f_`                  | `f_scode`, `f_idleCode`      |
| 그리드           | `search-grid`         |                              |
| 검색 툴바        | `search-toolbar`      |                              |
| 검색 폼          | `search-form`         |                              |
| 편집 폼          | `edit-form`           |                              |
| 편집 다이얼로그  | `edit-dialog`         |                              |
| 조회 버튼        | `search-button`       |                              |
| 신규 버튼        | `new-button`          |                              |
| 저장 버튼        | `save-button`         |                              |
| 삭제 버튼        | `delete-button`       |                              |

---

## 4. JSP 규칙

| 규칙                       | 설명                                                   |
|----------------------------|--------------------------------------------------------|
| 권한 버튼 제어             | `data-options="disabled:${RET}"` / `${INS}` / `${UPD}` / `${DEL}` |
| 인라인 이벤트 금지         | `onclick` 사용 불가, JS에서 `bind()` 사용               |
| 다이얼로그                 | `closed:true, modal:true` 필수                          |
| JS 버전 관리               | `?v=YYMMDDX` 쿼리스트링 (캐시 무효화)                   |
| 서버 변수 전달             | `<script>var PAGE_XXX = '${xxx}';</script>`              |
| 인코딩                     | UTF-8 필수                                              |
| 파일명                     | 소문자만: `{screenId}_{suffix}.jsp`                      |

---

## 5. 탭 분리 JSP 패턴

각 탭을 독립 JSP 파일로 분리하되, 동일한 공유 JS를 로드한다.
차이점은 `PAGE_*` 변수로 제어한다.

```jsp
<%-- std45a_assy.jsp (조립) --%>
<script type="text/javascript">
    var PAGE_PLANTS = '${plants}';          // '3603'
    var PAGE_PLANTS_NAME = '${plantsName}'; // '조립'
    var PAGE_SHOW_MCT_SCOMMENT = false;     // 가공 전용 미표시
</script>
<script src="<c:url value="/resources/js/imes/std/std45a.js" />"></script>
```

```jsp
<%-- std45a_mach.jsp (가공) --%>
<script type="text/javascript">
    var PAGE_PLANTS = '${plants}';          // '3605'
    var PAGE_PLANTS_NAME = '${plantsName}'; // '가공'
    var PAGE_SHOW_MCT_SCOMMENT = true;      // 가공 전용 표시
</script>
<script src="<c:url value="/resources/js/imes/std/std45a.js" />"></script>
```

탭별 JSP에서만 다른 부분(추가 필드 등)은 각 JSP에 직접 작성한다.

---

## 6. 검색 영역 CSS 클래스

| 영역     | 클래스                          | 용도             |
|----------|---------------------------------|------------------|
| 검색     | `Remake-div-line-new`           | 검색 조건 영역   |
| 버튼     | `div-line-new-sub grd-div-btn`  | 버튼 영역        |
| 버튼 묶음 | `dis_flex_gap4`                | 버튼 간격 flex   |
| 테이블   | `search-table tableSearch-c wd-100` | 검색 테이블  |
| 팝업 테이블 | `popup-search-table`         | 다이얼로그 테이블 |
