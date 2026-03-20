# STD52A 설비점검항목관리 — 상세 개발 명세서

> **작성자**: 송우석
> **작성일**: 2026-02-04
> **화면 ID**: STD52A
> **예상 공수**: 16 MH (AI 협업 기준)

---

## 1. 개요

### 1.1 기능 설명

설비점검항목관리(STD52A)는 설비 일상점검에 사용되는 표준 점검항목을 등록·수정·삭제하는 기능이다.
등록된 점검항목은 POP30B(설비일상점검 등록), POP42A(설비일상점검 이력조회) 등 생산 현장 화면에서
점검 수행 시 템플릿으로 활용된다.

### 1.2 AS-IS → TO-BE 매핑

| 구분              | AS-IS (C# WinForms)                          | TO-BE (Java Web)                              |
|-------------------|----------------------------------------------|-----------------------------------------------|
| 메인 화면         | `STD52A_M0A.cs`                              | `std52a.jsp` + `std52a.js`                    |
| 편집 팝업         | `STD52A_D0A.cs`                              | `std52a_d0a.jsp` + `std52a_d0a.js`            |
| 비즈니스 로직     | `CUBIZ_BR/BSTD/STD52A.cs`                    | `Std52aServiceImpl.java`                      |
| 데이터 액세스     | `CUBIZ_DA/DSTD/TSTD_MC_DAILY_CHECK*.cs`      | `Std52aDaoImpl.java` + `Std52a.xml`           |

### 1.3 핵심 테이블

| 테이블명                 | 용도                     | PK                     |
|--------------------------|--------------------------|------------------------|
| TSTD_MC_DAILY_CHECK      | 점검항목 마스터          | PLT_CODE + SMDC_NO     |
| TPOP_MC_DAILY_CHECK_RESULT | 점검결과 (참조용)       | PLT_CODE + MDCR_NO     |
| LSE_MACHINE              | 설비 마스터 (참조용)     | PLT_CODE + MC_CODE     |

---

## 2. 파일 구조

```
src/main/java/com/wsc/std/std52a/
├── Std52aController.java
├── Std52aService.java
├── Std52aServiceImpl.java
├── Std52aDao.java
└── Std52aDaoImpl.java

src/main/resources/mappers/com/wsc/std/std52a/
└── Std52a.xml

src/main/webapp/WEB-INF/views/std/std52a/
├── std52a.jsp
└── std52a_d0a.jsp

src/main/webapp/resources/js/std/std52a/
├── std52a.js
└── std52a_d0a.js
```

---

## 3. Java 클래스 설계

### 3.1 Controller

```java
package com.wsc.std.std52a;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.wsc.framework.base.BaseController;

/**
 * 설비점검항목관리 컨트롤러
 * @author 송우석
 */
@Controller
@RequestMapping("/std/std52a")
public class Std52aController extends BaseController {

    @Autowired
    private Std52aService std52aService;

    /**
     * 메인 화면
     */
    @RequestMapping("/std52a.do")
    public String view(HttpServletRequest request, Model model) {
        return "std/std52a/std52a";
    }

    /**
     * 점검항목 편집기 팝업
     */
    @RequestMapping("/std52a_d0a.do")
    public String popupD0a(HttpServletRequest request, Model model) {
        return "std/std52a/std52a_d0a";
    }

    /**
     * 점검항목 목록 조회
     */
    @RequestMapping("/selectList.do")
    @ResponseBody
    public Map<String, Object> selectList(@RequestBody Map<String, Object> param) {
        return std52aService.selectList(param);
    }

    /**
     * 점검항목 상세 조회
     */
    @RequestMapping("/selectDetail.do")
    @ResponseBody
    public Map<String, Object> selectDetail(@RequestBody Map<String, Object> param) {
        return std52aService.selectDetail(param);
    }

    /**
     * 점검항목 저장 (등록/수정)
     */
    @RequestMapping("/save.do")
    @ResponseBody
    public Map<String, Object> save(@RequestBody Map<String, Object> param) {
        return std52aService.save(param);
    }

    /**
     * 점검항목 삭제 (논리삭제)
     */
    @RequestMapping("/delete.do")
    @ResponseBody
    public Map<String, Object> delete(@RequestBody Map<String, Object> param) {
        return std52aService.delete(param);
    }

    /**
     * 점검항목 일괄 삭제
     */
    @RequestMapping("/deleteList.do")
    @ResponseBody
    public Map<String, Object> deleteList(@RequestBody Map<String, Object> param) {
        return std52aService.deleteList(param);
    }

    /**
     * SMDC_NO 자동채번
     */
    @RequestMapping("/getNewSmdcNo.do")
    @ResponseBody
    public Map<String, Object> getNewSmdcNo(@RequestBody Map<String, Object> param) {
        return std52aService.getNewSmdcNo(param);
    }
}
```

### 3.2 Service Interface

```java
package com.wsc.std.std52a;

import java.util.Map;

/**
 * 설비점검항목관리 서비스 인터페이스
 * @author 송우석
 */
public interface Std52aService {

    /**
     * 점검항목 목록 조회
     * @param param 검색 조건 (PLT_CODE, TYPE_LIKE, CONTENTS_LIKE)
     * @return 점검항목 목록
     */
    Map<String, Object> selectList(Map<String, Object> param);

    /**
     * 점검항목 상세 조회
     * @param param 조회 조건 (PLT_CODE, SMDC_NO)
     * @return 점검항목 상세 정보
     */
    Map<String, Object> selectDetail(Map<String, Object> param);

    /**
     * 점검항목 저장 (UPSERT)
     * @param param 저장 데이터
     * @return 처리 결과
     */
    Map<String, Object> save(Map<String, Object> param);

    /**
     * 점검항목 삭제 (논리삭제)
     * @param param 삭제 대상 (PLT_CODE, SMDC_NO)
     * @return 처리 결과
     */
    Map<String, Object> delete(Map<String, Object> param);

    /**
     * 점검항목 일괄 삭제
     * @param param 삭제 대상 목록
     * @return 처리 결과
     */
    Map<String, Object> deleteList(Map<String, Object> param);

    /**
     * SMDC_NO 자동채번
     * @param param PLT_CODE
     * @return 새 SMDC_NO
     */
    Map<String, Object> getNewSmdcNo(Map<String, Object> param);
}
```

### 3.3 Service Implementation

```java
package com.wsc.std.std52a;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.framework.base.BaseService;

/**
 * 설비점검항목관리 서비스 구현
 * @author 송우석
 */
@Service
public class Std52aServiceImpl extends BaseService implements Std52aService {

    @Autowired
    private Std52aDao std52aDao;

    @Override
    public Map<String, Object> selectList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = std52aDao.selectList(param);
            result.put("success", true);
            result.put("data", list);
            result.put("total", list.size());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> selectDetail(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> data = std52aDao.selectDetail(param);
            result.put("success", true);
            result.put("data", data);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> save(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            String smdcNo = (String) param.get("SMDC_NO");
            String overwrite = (String) param.get("OVERWRITE");

            // 기존 데이터 확인
            Map<String, Object> existing = std52aDao.selectDetail(param);

            if (existing != null) {
                // 기존 데이터 존재
                if ("1".equals(overwrite)) {
                    // 덮어쓰기 모드 - UPDATE
                    std52aDao.update(param);
                    result.put("success", true);
                    result.put("message", "수정되었습니다.");
                } else {
                    // 중복 오류 반환
                    Integer dataFlag = (Integer) existing.get("DATA_FLAG");
                    if (dataFlag != null && dataFlag == 2) {
                        // 삭제된 데이터 존재
                        result.put("success", false);
                        result.put("errorCode", "100002");
                        result.put("message", "동일 데이터가 이력이 존재합니다. 덮어쓰시겠습니까?");
                        result.put("existingData", existing);
                    } else {
                        // 활성 데이터 존재
                        result.put("success", false);
                        result.put("errorCode", "100001");
                        result.put("message", "동일 데이터가 존재합니다. 덮어쓰시겠습니까?");
                    }
                }
            } else {
                // 신규 등록
                if (smdcNo == null || smdcNo.isEmpty()) {
                    // 자동채번
                    String newSmdcNo = generateSmdcNo(param);
                    param.put("SMDC_NO", newSmdcNo);
                }
                std52aDao.insert(param);
                result.put("success", true);
                result.put("message", "저장되었습니다.");
                result.put("SMDC_NO", param.get("SMDC_NO"));
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> delete(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = std52aDao.delete(param);
            result.put("success", true);
            result.put("message", cnt + "건이 삭제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> deleteList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("list");
            int cnt = 0;
            for (Map<String, Object> item : list) {
                item.put("DEL_EMP", param.get("DEL_EMP"));
                cnt += std52aDao.delete(item);
            }
            result.put("success", true);
            result.put("message", cnt + "건이 삭제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> getNewSmdcNo(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            String newSmdcNo = generateSmdcNo(param);
            result.put("success", true);
            result.put("SMDC_NO", newSmdcNo);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * SMDC_NO 자동채번
     * 형식: SMDC + YYMMDD + 일련번호(3자리)
     * 예: SMDC250204001
     */
    private String generateSmdcNo(Map<String, Object> param) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
        String dateStr = sdf.format(new Date());
        String prefix = "SMDC" + dateStr;

        // 오늘 날짜의 마지막 일련번호 조회
        param.put("PREFIX", prefix);
        String lastNo = std52aDao.selectLastSmdcNo(param);

        int seq = 1;
        if (lastNo != null && lastNo.startsWith(prefix)) {
            String seqStr = lastNo.substring(prefix.length());
            seq = Integer.parseInt(seqStr) + 1;
        }

        return prefix + String.format("%03d", seq);
    }
}
```

### 3.4 DAO Interface

```java
package com.wsc.std.std52a;

import java.util.List;
import java.util.Map;

/**
 * 설비점검항목관리 DAO 인터페이스
 * @author 송우석
 */
public interface Std52aDao {

    List<Map<String, Object>> selectList(Map<String, Object> param);

    Map<String, Object> selectDetail(Map<String, Object> param);

    int insert(Map<String, Object> param);

    int update(Map<String, Object> param);

    int delete(Map<String, Object> param);

    String selectLastSmdcNo(Map<String, Object> param);
}
```

### 3.5 DAO Implementation

```java
package com.wsc.std.std52a;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.wsc.framework.base.BaseDao;

/**
 * 설비점검항목관리 DAO 구현
 * @author 송우석
 */
@Repository
public class Std52aDaoImpl extends BaseDao implements Std52aDao {

    private static final String NAMESPACE = "com.wsc.std.std52a.Std52aDao";

    @Override
    public List<Map<String, Object>> selectList(Map<String, Object> param) {
        return getSqlSession().selectList(NAMESPACE + ".selectList", param);
    }

    @Override
    public Map<String, Object> selectDetail(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectDetail", param);
    }

    @Override
    public int insert(Map<String, Object> param) {
        return getSqlSession().insert(NAMESPACE + ".insert", param);
    }

    @Override
    public int update(Map<String, Object> param) {
        return getSqlSession().update(NAMESPACE + ".update", param);
    }

    @Override
    public int delete(Map<String, Object> param) {
        return getSqlSession().update(NAMESPACE + ".delete", param);
    }

    @Override
    public String selectLastSmdcNo(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectLastSmdcNo", param);
    }
}
```

---

## 4. MyBatis Mapper XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--
    설비점검항목관리 Mapper
    @author 송우석
-->
<mapper namespace="com.wsc.std.std52a.Std52aDao">

    <!-- 점검항목 목록 조회 -->
    <select id="selectList" parameterType="map" resultType="map">
        SELECT A.PLT_CODE       AS pltCode
             , A.SMDC_NO        AS smdcNo
             , A.SMDC_TYPE      AS smdcType
             , A.SMDC_NUM       AS smdcNum
             , A.SMDC_CONTENTS  AS smdcContents
             , A.SMDC_CHECK     AS smdcCheck
             , A.SMDC_MEANS     AS smdcMeans
             , A.SMDC_SEQ       AS smdcSeq
             , A.REG_DATE       AS regDate
             , A.REG_EMP        AS regEmp
             , B.EMP_NAME       AS regEmpName
             , A.MDFY_DATE      AS mdfyDate
             , A.MDFY_EMP       AS mdfyEmp
             , C.EMP_NAME       AS mdfyEmpName
             , A.DATA_FLAG      AS dataFlag
          FROM TSTD_MC_DAILY_CHECK A
          LEFT JOIN TB_USER B ON A.REG_EMP = B.USER_ID
          LEFT JOIN TB_USER C ON A.MDFY_EMP = C.USER_ID
         WHERE A.PLT_CODE = #{pltCode}
           AND A.DATA_FLAG = 0
        <if test="typeLike != null and typeLike != ''">
           AND A.SMDC_TYPE LIKE CONCAT('%', #{typeLike}, '%')
        </if>
        <if test="contentsLike != null and contentsLike != ''">
           AND A.SMDC_CONTENTS LIKE CONCAT('%', #{contentsLike}, '%')
        </if>
         ORDER BY A.SMDC_SEQ, A.SMDC_NO
    </select>

    <!-- 점검항목 상세 조회 -->
    <select id="selectDetail" parameterType="map" resultType="map">
        SELECT A.PLT_CODE       AS pltCode
             , A.SMDC_NO        AS smdcNo
             , A.SMDC_TYPE      AS smdcType
             , A.SMDC_NUM       AS smdcNum
             , A.SMDC_CONTENTS  AS smdcContents
             , A.SMDC_CHECK     AS smdcCheck
             , A.SMDC_MEANS     AS smdcMeans
             , A.SMDC_SEQ       AS smdcSeq
             , A.REG_DATE       AS regDate
             , A.REG_EMP        AS regEmp
             , A.MDFY_DATE      AS mdfyDate
             , A.MDFY_EMP       AS mdfyEmp
             , A.DEL_DATE       AS delDate
             , A.DEL_EMP        AS delEmp
             , A.DATA_FLAG      AS dataFlag
          FROM TSTD_MC_DAILY_CHECK A
         WHERE A.PLT_CODE = #{pltCode}
           AND A.SMDC_NO = #{smdcNo}
    </select>

    <!-- 점검항목 등록 -->
    <insert id="insert" parameterType="map">
        INSERT INTO TSTD_MC_DAILY_CHECK (
            PLT_CODE
          , SMDC_NO
          , SMDC_TYPE
          , SMDC_NUM
          , SMDC_CONTENTS
          , SMDC_CHECK
          , SMDC_MEANS
          , SMDC_SEQ
          , REG_DATE
          , REG_EMP
          , DATA_FLAG
        ) VALUES (
            #{pltCode}
          , #{smdcNo}
          , #{smdcType}
          , #{smdcNum}
          , #{smdcContents}
          , #{smdcCheck}
          , #{smdcMeans}
          , #{smdcSeq}
          , NOW()
          , #{regEmp}
          , 0
        )
    </insert>

    <!-- 점검항목 수정 -->
    <update id="update" parameterType="map">
        UPDATE TSTD_MC_DAILY_CHECK
           SET SMDC_TYPE     = #{smdcType}
             , SMDC_NUM      = #{smdcNum}
             , SMDC_CONTENTS = #{smdcContents}
             , SMDC_CHECK    = #{smdcCheck}
             , SMDC_MEANS    = #{smdcMeans}
             , SMDC_SEQ      = #{smdcSeq}
             , MDFY_DATE     = NOW()
             , MDFY_EMP      = #{mdfyEmp}
             , DATA_FLAG     = 0
             , DEL_DATE      = NULL
             , DEL_EMP       = NULL
         WHERE PLT_CODE = #{pltCode}
           AND SMDC_NO = #{smdcNo}
    </update>

    <!-- 점검항목 삭제 (논리삭제) -->
    <update id="delete" parameterType="map">
        UPDATE TSTD_MC_DAILY_CHECK
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND SMDC_NO = #{smdcNo}
    </update>

    <!-- 마지막 SMDC_NO 조회 (자동채번용) -->
    <select id="selectLastSmdcNo" parameterType="map" resultType="string">
        SELECT MAX(SMDC_NO)
          FROM TSTD_MC_DAILY_CHECK
         WHERE PLT_CODE = #{pltCode}
           AND SMDC_NO LIKE CONCAT(#{prefix}, '%')
    </select>

</mapper>
```

---

## 5. 화면 설계

### 5.1 메인 화면 레이아웃 (std52a.jsp)

```
┌─────────────────────────────────────────────────────────────────────────┐
│ [도구모음] 조회 | 도움말                                                 │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─ 검색조건 ──────────────────────────────────────────────────────────┐ │
│ │ 구분: [____________] 점검항목: [____________] [조회]                │ │
│ └───────────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─ 점검항목 목록 ────────────────────────────────────────────────────┐ │
│ │┌────┬─────────────┬──────┬──────┬──────────┬──────────┬──────┬────┐│ │
│ ││선택│점검항목ID   │구분  │점검번호│점검항목  │점검내용  │점검방법│순번││ │
│ │├────┼─────────────┼──────┼──────┼──────────┼──────────┼──────┼────┤│ │
│ ││ □  │SMDC250204001│유압  │001   │오일레벨  │게이지확인│육안  │1   ││ │
│ ││ □  │SMDC250204002│전기  │001   │전선상태  │피복손상  │육안  │2   ││ │
│ ││ □  │SMDC250204003│기계  │001   │베어링    │소음확인  │청진  │3   ││ │
│ │├────┼─────────────┼──────┼──────┼──────────┼──────────┼──────┼────┤│ │
│ ││...                                                              ││ │
│ │└────┴─────────────┴──────┴──────┴──────────┴──────────┴──────┴────┘│ │
│ │ [우클릭 메뉴: 점검항목 등록 / 점검항목 수정 / 삭제]                 │ │
│ └───────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘
```

### 5.2 편집 팝업 레이아웃 (std52a_d0a.jsp)

```
┌─────────────────────────────────────────────────────────┐
│ 점검항목 편집기                                    [X]  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   점검항목ID  [SMDC250204001        ] (읽기전용)       │
│                                                         │
│   구분        [__________________  ]                   │
│                                                         │
│   번호        [__________________  ]                   │
│                                                         │
│   점검항목    ┌───────────────────────────────────┐    │
│               │                                   │    │
│               │ (멀티라인 입력)                   │    │
│               └───────────────────────────────────┘    │
│                                                         │
│   점검내용    ┌───────────────────────────────────┐    │
│               │                                   │    │
│               │ (멀티라인 입력)                   │    │
│               └───────────────────────────────────┘    │
│                                                         │
│   점검방법    [__________________  ]                   │
│                                                         │
│   순번        [______] (숫자만)                        │
│                                                         │
├─────────────────────────────────────────────────────────┤
│ NEW모드:  [저장] [초기화] [창고정]                      │
│ OPEN모드: [저장 후 닫기] [삭제] [창고정]               │
└─────────────────────────────────────────────────────────┘
```

---

## 6. JavaScript 구현

### 6.1 메인 화면 (std52a.js)

```javascript
/**
 * 설비점검항목관리 메인 화면
 * @author 송우석
 */
var Std52a = (function() {
    'use strict';

    var grid;           // 점검항목 그리드
    var contextMenu;    // 우클릭 메뉴

    /**
     * 초기화
     */
    function init() {
        initGrid();
        initContextMenu();
        bindEvents();
    }

    /**
     * 그리드 초기화
     */
    function initGrid() {
        grid = $('#grid').datagrid({
            url: CTX_PATH + '/std/std52a/selectList.do',
            method: 'post',
            fit: true,
            fitColumns: true,
            striped: true,
            singleSelect: false,
            checkOnSelect: true,
            selectOnCheck: true,
            idField: 'smdcNo',
            columns: [[
                { field: 'ck', checkbox: true },
                { field: 'smdcNo', title: '점검항목ID', width: 120, halign: 'center', align: 'center' },
                { field: 'smdcType', title: '구분', width: 80, halign: 'center', align: 'center' },
                { field: 'smdcNum', title: '점검번호', width: 80, halign: 'center', align: 'center' },
                { field: 'smdcContents', title: '점검항목', width: 150, halign: 'center', align: 'left' },
                { field: 'smdcCheck', title: '점검내용', width: 150, halign: 'center', align: 'left' },
                { field: 'smdcMeans', title: '점검방법', width: 100, halign: 'center', align: 'center' },
                { field: 'smdcSeq', title: '순번', width: 60, halign: 'center', align: 'center' }
            ]],
            onDblClickRow: function(index, row) {
                openEditPopup(row);
            },
            onRowContextMenu: function(e, index, row) {
                e.preventDefault();
                $(this).datagrid('selectRow', index);
                contextMenu.menu('show', { left: e.pageX, top: e.pageY });
            }
        });
    }

    /**
     * 컨텍스트 메뉴 초기화
     */
    function initContextMenu() {
        contextMenu = $('#contextMenu').menu({
            onClick: function(item) {
                switch(item.name) {
                    case 'add':
                        openAddPopup();
                        break;
                    case 'edit':
                        var row = grid.datagrid('getSelected');
                        if (row) openEditPopup(row);
                        break;
                    case 'delete':
                        deleteSelected();
                        break;
                }
            }
        });
    }

    /**
     * 이벤트 바인딩
     */
    function bindEvents() {
        // 조회 버튼
        $('#btnSearch').on('click', function() {
            search();
        });

        // 검색조건 엔터키
        $('#typeLike, #contentsLike').on('keypress', function(e) {
            if (e.which === 13) {
                search();
            }
        });

        // 도구모음 버튼
        $('#btnAdd').on('click', openAddPopup);
        $('#btnDelete').on('click', deleteSelected);
    }

    /**
     * 조회
     */
    function search() {
        var params = {
            pltCode: COMMON.pltCode,
            typeLike: $('#typeLike').val(),
            contentsLike: $('#contentsLike').val()
        };
        grid.datagrid('load', params);
    }

    /**
     * 등록 팝업 열기
     */
    function openAddPopup() {
        Std52aD0a.open('NEW', null, function() {
            search();
        });
    }

    /**
     * 수정 팝업 열기
     */
    function openEditPopup(row) {
        Std52aD0a.open('OPEN', row, function() {
            search();
        });
    }

    /**
     * 선택 항목 삭제
     */
    function deleteSelected() {
        var rows = grid.datagrid('getChecked');
        if (rows.length === 0) {
            COMMON.alert('삭제할 항목을 선택하세요.');
            return;
        }

        COMMON.confirm('선택한 ' + rows.length + '건을 삭제하시겠습니까?', function(r) {
            if (r) {
                var list = [];
                $.each(rows, function(i, row) {
                    list.push({
                        pltCode: row.pltCode,
                        smdcNo: row.smdcNo
                    });
                });

                COMMON.ajax({
                    url: CTX_PATH + '/std/std52a/deleteList.do',
                    data: {
                        list: list,
                        delEmp: COMMON.userId
                    },
                    success: function(result) {
                        if (result.success) {
                            COMMON.alert(result.message);
                            search();
                        } else {
                            COMMON.alert(result.message);
                        }
                    }
                });
            }
        });
    }

    return {
        init: init,
        search: search
    };

})();

$(function() {
    Std52a.init();
});
```

### 6.2 편집 팝업 (std52a_d0a.js)

```javascript
/**
 * 설비점검항목 편집기 팝업
 * @author 송우석
 */
var Std52aD0a = (function() {
    'use strict';

    var dialog;
    var mode;       // 'NEW' or 'OPEN'
    var callback;
    var isPinned = false;

    /**
     * 팝업 열기
     * @param openMode 'NEW' or 'OPEN'
     * @param data 수정 시 기존 데이터
     * @param cb 저장 후 콜백
     */
    function open(openMode, data, cb) {
        mode = openMode;
        callback = cb;

        dialog = $('#d0aDialog').dialog({
            title: '점검항목 편집기',
            width: 500,
            height: 450,
            modal: true,
            closed: false,
            onClose: function() {
                clear();
            }
        });

        updateButtonVisibility();

        if (mode === 'NEW') {
            clear();
            // 신규 채번
            getNewSmdcNo();
        } else if (mode === 'OPEN' && data) {
            loadData(data);
        }
    }

    /**
     * 버튼 표시 상태 갱신
     */
    function updateButtonVisibility() {
        if (mode === 'NEW') {
            $('#btnSave').show();
            $('#btnSaveClose').hide();
            $('#btnPopupDelete').hide();
            $('#btnClear').show();
        } else {
            $('#btnSave').hide();
            $('#btnSaveClose').show();
            $('#btnPopupDelete').show();
            $('#btnClear').hide();
        }
    }

    /**
     * 데이터 로드
     */
    function loadData(data) {
        $('#smdcNo').val(data.smdcNo);
        $('#smdcType').val(data.smdcType);
        $('#smdcNum').val(data.smdcNum);
        $('#smdcContents').val(data.smdcContents);
        $('#smdcCheck').val(data.smdcCheck);
        $('#smdcMeans').val(data.smdcMeans);
        $('#smdcSeq').val(data.smdcSeq);

        $('#smdcNo').textbox('readonly', true);
    }

    /**
     * 초기화
     */
    function clear() {
        $('#smdcNo').textbox('setValue', '');
        $('#smdcType').textbox('setValue', '');
        $('#smdcNum').textbox('setValue', '');
        $('#smdcContents').textbox('setValue', '');
        $('#smdcCheck').textbox('setValue', '');
        $('#smdcMeans').textbox('setValue', '');
        $('#smdcSeq').numberbox('setValue', '');

        if (mode === 'NEW') {
            $('#smdcNo').textbox('readonly', true);
            getNewSmdcNo();
        }
    }

    /**
     * 신규 SMDC_NO 채번
     */
    function getNewSmdcNo() {
        COMMON.ajax({
            url: CTX_PATH + '/std/std52a/getNewSmdcNo.do',
            data: { pltCode: COMMON.pltCode },
            success: function(result) {
                if (result.success) {
                    $('#smdcNo').textbox('setValue', result.SMDC_NO);
                }
            }
        });
    }

    /**
     * 저장
     */
    function save(closeAfter) {
        // 유효성 검사
        if (!validate()) return;

        var data = {
            pltCode: COMMON.pltCode,
            smdcNo: $('#smdcNo').textbox('getValue'),
            smdcType: $('#smdcType').textbox('getValue'),
            smdcNum: $('#smdcNum').textbox('getValue'),
            smdcContents: $('#smdcContents').textbox('getValue'),
            smdcCheck: $('#smdcCheck').textbox('getValue'),
            smdcMeans: $('#smdcMeans').textbox('getValue'),
            smdcSeq: $('#smdcSeq').numberbox('getValue'),
            regEmp: COMMON.userId,
            mdfyEmp: COMMON.userId
        };

        doSave(data, closeAfter, false);
    }

    /**
     * 저장 실행
     */
    function doSave(data, closeAfter, overwrite) {
        if (overwrite) {
            data.OVERWRITE = '1';
        }

        COMMON.ajax({
            url: CTX_PATH + '/std/std52a/save.do',
            data: data,
            success: function(result) {
                if (result.success) {
                    COMMON.alert(result.message);
                    if (callback) callback();

                    if (closeAfter && !isPinned) {
                        dialog.dialog('close');
                    } else if (mode === 'NEW') {
                        clear();
                    }
                } else {
                    // 중복 처리
                    if (result.errorCode === '100001' || result.errorCode === '100002') {
                        COMMON.confirm(result.message, function(r) {
                            if (r) {
                                doSave(data, closeAfter, true);
                            }
                        });
                    } else {
                        COMMON.alert(result.message);
                    }
                }
            }
        });
    }

    /**
     * 유효성 검사
     */
    function validate() {
        if (!$('#smdcType').textbox('getValue')) {
            COMMON.alert('구분을 입력하세요.');
            $('#smdcType').textbox('textbox').focus();
            return false;
        }
        if (!$('#smdcContents').textbox('getValue')) {
            COMMON.alert('점검항목을 입력하세요.');
            $('#smdcContents').textbox('textbox').focus();
            return false;
        }
        return true;
    }

    /**
     * 삭제
     */
    function deleteItem() {
        COMMON.confirm('삭제하시겠습니까?', function(r) {
            if (r) {
                COMMON.ajax({
                    url: CTX_PATH + '/std/std52a/delete.do',
                    data: {
                        pltCode: COMMON.pltCode,
                        smdcNo: $('#smdcNo').textbox('getValue'),
                        delEmp: COMMON.userId
                    },
                    success: function(result) {
                        if (result.success) {
                            COMMON.alert(result.message);
                            if (callback) callback();
                            dialog.dialog('close');
                        } else {
                            COMMON.alert(result.message);
                        }
                    }
                });
            }
        });
    }

    /**
     * 창 고정 토글
     */
    function togglePin() {
        isPinned = !isPinned;
        $('#btnPin').linkbutton({
            iconCls: isPinned ? 'icon-pin-on' : 'icon-pin-off'
        });
    }

    // 이벤트 바인딩
    $(function() {
        $('#btnSave').on('click', function() { save(false); });
        $('#btnSaveClose').on('click', function() { save(true); });
        $('#btnPopupDelete').on('click', deleteItem);
        $('#btnClear').on('click', clear);
        $('#btnPin').on('click', togglePin);
    });

    return {
        open: open
    };

})();
```

---

## 7. JSP 구현

### 7.1 메인 화면 (std52a.jsp)

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>설비점검항목관리</title>
    <%@ include file="/WEB-INF/views/include/common.jsp"%>
</head>
<body class="easyui-layout">

    <!-- 검색조건 -->
    <div data-options="region:'north', border:false" style="height:60px; padding:10px;">
        <form id="searchForm">
            <table>
                <tr>
                    <td>구분:</td>
                    <td><input id="typeLike" class="easyui-textbox" style="width:150px;"></td>
                    <td style="padding-left:20px;">점검항목:</td>
                    <td><input id="contentsLike" class="easyui-textbox" style="width:150px;"></td>
                    <td style="padding-left:20px;">
                        <a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search">조회</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <!-- 그리드 -->
    <div data-options="region:'center', border:false" style="padding:5px;">
        <table id="grid"></table>
    </div>

    <!-- 컨텍스트 메뉴 -->
    <div id="contextMenu" class="easyui-menu" style="width:150px;">
        <div name="add" iconCls="icon-add">점검항목 등록</div>
        <div name="edit" iconCls="icon-edit">점검항목 수정</div>
        <div class="menu-sep"></div>
        <div name="delete" iconCls="icon-remove">삭제</div>
    </div>

    <!-- 편집 팝업 -->
    <%@ include file="/WEB-INF/views/std/std52a/std52a_d0a.jsp"%>

    <script src="<c:url value='/resources/js/std/std52a/std52a.js'/>"></script>
</body>
</html>
```

### 7.2 편집 팝업 (std52a_d0a.jsp)

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 점검항목 편집기 팝업 -->
<div id="d0aDialog" class="easyui-dialog" style="width:500px; height:450px; padding:10px;"
     data-options="closed:true, modal:true">

    <form id="d0aForm">
        <table style="width:100%;">
            <tr>
                <td style="width:100px; text-align:right; padding:5px;">점검항목ID:</td>
                <td>
                    <input id="smdcNo" class="easyui-textbox" style="width:100%;"
                           data-options="readonly:true">
                </td>
            </tr>
            <tr>
                <td style="text-align:right; padding:5px;">구분:</td>
                <td>
                    <input id="smdcType" class="easyui-textbox" style="width:100%;">
                </td>
            </tr>
            <tr>
                <td style="text-align:right; padding:5px;">번호:</td>
                <td>
                    <input id="smdcNum" class="easyui-textbox" style="width:100%;">
                </td>
            </tr>
            <tr>
                <td style="text-align:right; padding:5px; vertical-align:top;">점검항목:</td>
                <td>
                    <input id="smdcContents" class="easyui-textbox" style="width:100%; height:60px;"
                           data-options="multiline:true">
                </td>
            </tr>
            <tr>
                <td style="text-align:right; padding:5px; vertical-align:top;">점검내용:</td>
                <td>
                    <input id="smdcCheck" class="easyui-textbox" style="width:100%; height:60px;"
                           data-options="multiline:true">
                </td>
            </tr>
            <tr>
                <td style="text-align:right; padding:5px;">점검방법:</td>
                <td>
                    <input id="smdcMeans" class="easyui-textbox" style="width:100%;">
                </td>
            </tr>
            <tr>
                <td style="text-align:right; padding:5px;">순번:</td>
                <td>
                    <input id="smdcSeq" class="easyui-numberbox" style="width:100px;"
                           data-options="min:0, precision:0">
                </td>
            </tr>
        </table>
    </form>

    <div style="text-align:center; padding-top:20px;">
        <a id="btnSave" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save">저장</a>
        <a id="btnSaveClose" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save">저장 후 닫기</a>
        <a id="btnPopupDelete" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove">삭제</a>
        <a id="btnClear" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload">초기화</a>
        <a id="btnPin" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-pin-off">창 고정</a>
    </div>
</div>

<script src="<c:url value='/resources/js/std/std52a/std52a_d0a.js'/>"></script>
```

---

## 8. 테이블 DDL

```sql
-- 설비 일상점검 항목 마스터
CREATE TABLE IF NOT EXISTS TSTD_MC_DAILY_CHECK (
    PLT_CODE      VARCHAR(10)   NOT NULL COMMENT '공장코드',
    SMDC_NO       VARCHAR(20)   NOT NULL COMMENT '점검항목ID',
    SMDC_TYPE     VARCHAR(50)   NULL     COMMENT '구분',
    SMDC_NUM      VARCHAR(20)   NULL     COMMENT '점검번호',
    SMDC_CONTENTS TEXT          NULL     COMMENT '점검항목',
    SMDC_CHECK    TEXT          NULL     COMMENT '점검내용',
    SMDC_MEANS    VARCHAR(100)  NULL     COMMENT '점검방법',
    SMDC_SEQ      INT           NULL     COMMENT '순번',
    REG_DATE      DATETIME      NULL     COMMENT '등록일시',
    REG_EMP       VARCHAR(20)   NULL     COMMENT '등록자',
    MDFY_DATE     DATETIME      NULL     COMMENT '수정일시',
    MDFY_EMP      VARCHAR(20)   NULL     COMMENT '수정자',
    DEL_DATE      DATETIME      NULL     COMMENT '삭제일시',
    DEL_EMP       VARCHAR(20)   NULL     COMMENT '삭제자',
    DATA_FLAG     TINYINT       DEFAULT 0 COMMENT '데이터상태 (0:정상, 2:삭제)',
    PRIMARY KEY (PLT_CODE, SMDC_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='설비 일상점검 항목 마스터';

-- 인덱스
CREATE INDEX IDX_TSTD_MC_DAILY_CHECK_01 ON TSTD_MC_DAILY_CHECK (PLT_CODE, SMDC_TYPE);
CREATE INDEX IDX_TSTD_MC_DAILY_CHECK_02 ON TSTD_MC_DAILY_CHECK (PLT_CODE, DATA_FLAG, SMDC_SEQ);
```

---

## 9. 체크리스트

### 9.1 개발 체크리스트

| 단계   | 항목                            | 상태 |
|--------|--------------------------------|------|
| 설계   | DB 테이블 생성                  | [ ]  |
| 설계   | 패키지/클래스 구조 생성          | [ ]  |
| 백엔드 | Controller 구현                 | [ ]  |
| 백엔드 | Service/DAO 구현                | [ ]  |
| 백엔드 | MyBatis Mapper 구현             | [ ]  |
| 프론트 | 메인 JSP 구현                   | [ ]  |
| 프론트 | 팝업 JSP 구현                   | [ ]  |
| 프론트 | 메인 JS 구현                    | [ ]  |
| 프론트 | 팝업 JS 구현                    | [ ]  |
| 테스트 | 조회 기능 테스트                | [ ]  |
| 테스트 | 등록 기능 테스트                | [ ]  |
| 테스트 | 수정 기능 테스트                | [ ]  |
| 테스트 | 삭제 기능 테스트                | [ ]  |
| 테스트 | 중복 체크 테스트                | [ ]  |

### 9.2 테스트 케이스

| TC ID    | 테스트 항목             | 예상 결과                          |
|----------|------------------------|-----------------------------------|
| TC-001   | 전체 목록 조회          | 모든 점검항목 표시 (DATA_FLAG=0)   |
| TC-002   | 구분으로 LIKE 검색      | 해당 구분 포함 항목만 표시         |
| TC-003   | 점검항목으로 LIKE 검색  | 해당 점검항목 포함 항목만 표시     |
| TC-004   | 신규 등록               | SMDC_NO 자동채번, 정상 저장        |
| TC-005   | 수정 (OPEN 모드)        | 기존 데이터 수정 완료              |
| TC-006   | 중복 등록 시도          | 100001 에러, 덮어쓰기 확인         |
| TC-007   | 삭제된 항목 재등록      | 100002 에러, 복원 확인            |
| TC-008   | 단건 삭제               | DATA_FLAG=2로 논리삭제            |
| TC-009   | 다건 선택 삭제          | 선택된 모든 항목 논리삭제          |
| TC-010   | 더블클릭 수정 팝업      | OPEN 모드로 팝업 열림             |

---

## 10. 참고 사항

### 10.1 연관 화면

| 화면 ID | 화면명              | 참조 관계                                |
|---------|---------------------|------------------------------------------|
| POP30B  | 설비일상점검 등록   | 점검항목 템플릿 로드하여 점검 수행        |
| POP42A  | 설비일상점검 이력   | 점검결과 이력 조회                       |

### 10.2 데이터 흐름

```
STD52A (점검항목 정의)
    │
    │  SMDC 컬럼 → MDCR 컬럼 매핑 복사
    ▼
POP30B (점검 수행)
    │  + MDCR_RESULT, MDCR_DATE, MDCR_MC_CODE 입력
    ▼
TPOP_MC_DAILY_CHECK_RESULT (결과 저장)
    │
    ▼
POP42A (이력 조회)
```

### 10.3 AS-IS 특이사항

- 점검항목/점검내용 필드는 Memo 타입(멀티라인)으로 줄바꿈 허용
- SMDC_NO 자동채번 형식: `SMDC` + `YYMMDD` + 일련번호 3자리
- 논리삭제 시 DEL_DATE, DEL_EMP 기록
- 중복 처리 시 삭제 이력 존재 여부에 따라 다른 메시지 표시 (100001 vs 100002)
