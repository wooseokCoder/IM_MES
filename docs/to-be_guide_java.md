# TO-BE Java 가이드 (Controller / Service)

> **Golden Sample**: `Std45aController.java`, `Std45aService.java`
> **작성자**: 송우석

---

## 1. Controller 패턴

### 1.1 표준 구조

```java
/*
 * ============================================================================
 * 화면명: {SCREEN_ID} - {화면명}
 * ============================================================================
 * 설명: {기능 설명}
 * 원본: ProActive {SCREEN_ID}.cs, {SCREEN_ID}_M0A.cs, {SCREEN_ID}_D0A.cs
 * 작성일: {YYYY-MM-DD}
 * ============================================================================
 */
package com.wsc.imes.{module};

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * {화면명} 컨트롤러
 *
 * @author 송우석
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/{module}")
public class {ScreenId}Controller extends BaseController {

    @Autowired
    private {ScreenId}Service service;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Override
    protected BaseService getService() {
        return this.service;
    }

    @Override
    protected SessionComponent getSessionComponent() {
        return this.sessionProvider.get();
    }

    // ========================================================================
    // 화면 열기
    // ========================================================================

    @RequestMapping(value = "/{screenId}.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/{module}/{screenId}";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    @RequestMapping(value = "/{screenId}/{SCREEN_ID}_SER.json")
    public String ser(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.{screenId}Ser(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 저장
    // ========================================================================

    @RequestMapping(value = "/{screenId}/{SCREEN_ID}_INS.json")
    public String ins(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.{screenId}Ins(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 수정
    // ========================================================================

    @RequestMapping(value = "/{screenId}/{SCREEN_ID}_UPD.json")
    public String upd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        Object result = service.{screenId}Upd(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // 삭제
    // ========================================================================

    @RequestMapping(value = "/{screenId}/{SCREEN_ID}_DEL.json")
    public String del(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        Object result = service.{screenId}Del(params);
        addObject(model, result);
        return "jsonView";
    }
}
```

### 1.2 Controller 규칙

| 규칙                          | 설명                                                     |
|-------------------------------|----------------------------------------------------------|
| `@RequestMapping` 기본 경로   | `/imes/{module}` (모듈 단위)                              |
| 화면 오픈 URL                 | `/{screenId}.do` 또는 `/{screenId}_{suffix}.do`           |
| API URL                      | `/{screenId}/{SCREEN_ID}_{ACTION}.json`                   |
| 단건 파라미터                 | `getParams(request)` — form-data                         |
| JSON 바디 파라미터            | `getParams(request, true)` — JSON body (다건 rows 등)    |
| 응답                          | `addObject(model, result)` + `return "jsonView"`         |
| 화면 초기화                   | `super.open(request, model)` — 권한 변수 자동 설정       |

### 1.3 URL 매핑 규칙

```
화면 오픈:  /imes/{module}/{screenId}.do
           /imes/{module}/{screenId}_{suffix}.do  (탭 분리 화면)

API 호출:  /imes/{module}/{screenId}/{SCREEN_ID}_SER.json   (조회)
           /imes/{module}/{screenId}/{SCREEN_ID}_INS.json   (등록)
           /imes/{module}/{screenId}/{SCREEN_ID}_UPD.json   (수정)
           /imes/{module}/{screenId}/{SCREEN_ID}_DEL.json   (삭제)
```

### 1.4 탭 분리 시 Controller 패턴

```java
// 탭1: 조립
@RequestMapping(value = "/ord45a_assy.do")
public String openAssy(HttpServletRequest request, Model model) {
    super.open(request, model);
    model.addAttribute("plants", "3603");
    model.addAttribute("plantsName", "조립");
    return "imes/ord/ord45a_assy";
}

// 탭2: 가공
@RequestMapping(value = "/ord45a_mach.do")
public String openMach(HttpServletRequest request, Model model) {
    super.open(request, model);
    model.addAttribute("plants", "3605");
    model.addAttribute("plantsName", "가공");
    return "imes/ord/ord45a_mach";
}

// API는 탭과 무관하게 공유 (plants 파라미터로 구분)
```

---

## 2. Service 패턴

### 2.1 표준 구조

```java
/*
 * ============================================================================
 * 화면명: {SCREEN_ID} - {화면명}
 * ============================================================================
 * 설명: {기능 설명}
 * 원본: ProActive {SCREEN_ID}.cs, {TABLE_NAME}.cs, {TABLE_NAME}_QUERY.cs
 * 작성일: {YYYY-MM-DD}
 * ============================================================================
 */
package com.wsc.imes.{module};

import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.model.ResultMap;
import com.wsc.imes.common.UtilityService;

/**
 * {화면명} 서비스
 *
 * 메서드명 규칙: AS-IS camelCase 변환
 * - {SCREEN_ID}_SER → {screenId}Ser
 * - {SCREEN_ID}_INS → {screenId}Ins
 *
 * @author 송우석
 * @version 1.0
 */
@Service
public class {ScreenId}Service extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger({ScreenId}Service.class);

    // Namespace 상수 (테이블 기반 매퍼)
    private static final String NS_{TABLE} = "com.wsc.imes.{module}.{TABLE_NAME}";
    private static final String NS_{TABLE}_QUERY = "com.wsc.imes.{module}.{TABLE_NAME}_QUERY";

    @Autowired private CommonDao dao;
    @Autowired private MessageSource messageSource;
    @Autowired private Provider<SessionComponent> sessionProvider;
    @Autowired private UtilityService utilityService;

    @Override
    protected BaseDao getDao() { return this.dao; }
    @Override
    protected MessageSource getMessageSource() { return this.messageSource; }
    @Override
    protected SessionComponent getSessionComponent() { return this.sessionProvider.get(); }

    // 조회
    public Object {screenId}Ser(ParamsMap params) {
        return searchByMapper(NS_{TABLE}_QUERY, "{TABLE_NAME}_QUERY1", params);
    }

    // 등록 (UPSERT)
    @Transactional
    public Object {screenId}Ins(ParamsMap params) { /* ... */ }

    // 수정 (그리드 일괄)
    @Transactional
    public ResultMap {screenId}Upd(ParamsMap params) { /* ... */ }

    // 삭제 (논리삭제)
    @Transactional
    public ResultMap {screenId}Del(ParamsMap params) { /* ... */ }
}
```

### 2.2 Service 규칙

| 규칙                     | 설명                                                          |
|--------------------------|---------------------------------------------------------------|
| 상속                     | `extends BaseService` (필수)                                  |
| DAO 주입                 | `@Autowired private CommonDao dao` (공용 DAO, 별도 DAO 없음)  |
| Namespace 상수           | `private static final String NS_XXX = "com.wsc.imes.{module}.{TABLE_NAME}"` |
| 데이터 접근              | `searchByMapper` / `selectByMapper` / `insertByMapper` / `updateByMapper` |
| 메서드명                 | AS-IS camelCase 변환: `STD45A_SER` → `std45aSer`              |
| 트랜잭션                 | `@Transactional` — 쓰기 메서드(INS/UPD/DEL)에 적용            |
| 반환 (조회)              | `Object` — searchByMapper 결과                                |
| 반환 (쓰기)              | `ResultMap` — `success(msg)` / `failure(msg)`                 |
| 반환 (UPSERT)            | `Object` — 저장 후 SER 재조회 반환                             |
| 채번                     | `utilityService.getSerialNo(gsPltCode, "S")`                  |

### 2.3 BaseService 핵심 메서드

| 메서드               | 시그니처                                              | 용도            |
|----------------------|-------------------------------------------------------|-----------------|
| `searchByMapper()`   | `(String ns, String id, Object params) → List`        | 목록 조회       |
| `selectByMapper()`   | `(String ns, String id, Object params) → Object`      | 단건 조회       |
| `insertByMapper()`   | `(String ns, String id, Object params) → int`         | 등록            |
| `updateByMapper()`   | `(String ns, String id, Object params) → int`         | 수정            |
| `deleteByMapper()`   | `(String ns, String id, Object params) → int`         | 삭제            |
| `success()`          | `(String message) → ResultMap`                        | 성공 ResultMap  |
| `failure()`          | `(String message) → ResultMap`                        | 실패 ResultMap  |

### 2.4 UPSERT 패턴

```java
private void processUpsert(ParamsMap params) {
    String scode = params.getString("scode");

    if (scode != null && !scode.isEmpty()) {
        RecordMap existing = (RecordMap) selectByMapper(NS, "TABLE_SER", params);
        if (existing != null && !existing.isEmpty()) {
            updateByMapper(NS, "TABLE_UPD", params);
            return;
        }
    }

    String newScode = utilityService.getSerialNo(params.getString("gsPltCode"), "S");
    params.put("scode", newScode);
    insertByMapper(NS, "TABLE_INS", params);
}
```

### 2.5 다건 처리 패턴

```java
@SuppressWarnings("unchecked")
@Transactional
public ResultMap xxxUpd(ParamsMap params) {
    List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
    if (rows == null || rows.isEmpty()) return failure("저장할 데이터가 없습니다.");

    int count = 0;
    for (Map<String, Object> row : rows) {
        ParamsMap rowParams = new ParamsMap();
        rowParams.putAll(row);
        rowParams.put("gsPltCode", params.get("gsPltCode"));
        rowParams.put("gsUserId", params.get("gsUserId"));
        updateByMapper(NS, "TABLE_UPD2", rowParams);
        count++;
    }
    return success(count + "건이 저장되었습니다.");
}
```

---

## 3. 프레임워크 데이터 모델

### ParamsMap 자동 주입 세션 값

| 키             | 설명             | 용도                     |
|----------------|------------------|--------------------------|
| `gsSysId`      | 시스템 ID        | 시스템 구분              |
| `gsUserId`     | 사용자 ID        | 등록자/수정자            |
| `gsUserName`   | 사용자 이름      | 표시용                   |
| `gsLang`       | 언어 코드        | 다국어 처리              |
| `gsPltCode`    | 플랜트 코드      | 사업장 구분 (MES 필수)   |
| `gsOrgCode`    | 조직 코드        | 부서 구분                |
| `gsGrupId`     | 그룹 ID          | 권한 그룹                |

### ResultMap JSON 응답

```json
{ "success": true, "message": "저장되었습니다." }
{ "success": false, "message": "저장 실패: 중복된 코드입니다." }
```

### RecordMap 사용법

```java
RecordMap record = (RecordMap) selectByMapper(NS, "TABLE_SER", params);
String value = record.getString("columnName");
int count = record.getInt("rowCount");
```
