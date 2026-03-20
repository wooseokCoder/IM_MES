# STD48A 비가동 유형관리 — 상세 개발 명세서

> **작성자**: 송우석
> **작성일**: 2026-02-04
> **화면 ID**: STD48A
> **예상 공수**: 18 MH (AI 협업 기준)
> **비고**: AS-IS 분석 문서 미존재, STD49A(정례비가동관리) 참조하여 추정

---

## 1. 개요

### 1.1 기능 설명

비가동 유형관리(STD48A)는 생산 현장에서 발생하는 비가동 사유 코드를 등록·수정·삭제하는 기능이다.
등록된 비가동 코드는 STD49A(정례비가동관리), POP 계열 화면(실적 비가동 등록) 등에서 참조된다.

- **공장 구분**: 조립(3603), 가공(3605) 탭별 분리 관리
- **코드 체계**: SCODE(내부 PK), IDLE_CODE(외부 표시용), SAP_CODE(SAP 연동용)

### 1.2 AS-IS → TO-BE 매핑

| 구분              | AS-IS (C# WinForms)                          | TO-BE (Java Web)                              |
|-------------------|----------------------------------------------|-----------------------------------------------|
| 메인 화면         | `STD48A_M0A.cs` (추정)                       | `std48a.jsp` + `std48a.js`                    |
| 편집 팝업         | `STD48A_D0A.cs` (추정)                       | `std48a_d0a.jsp` + `std48a_d0a.js`            |
| 비즈니스 로직     | `CUBIZ_BR/BSTD/STD48A.cs` (추정)             | `Std48aServiceImpl.java`                      |
| 데이터 액세스     | `CUBIZ_DA/DSTD/TSTD_IDLECODE*.cs`            | `Std48aDaoImpl.java` + `Std48a.xml`           |

### 1.3 핵심 테이블

| 테이블명      | 용도                     | PK                    |
|---------------|--------------------------|-----------------------|
| TSTD_IDLECODE | 비가동 사유 코드 마스터  | PLT_CODE + SCODE      |
| TSTD_ORG      | 조직 마스터 (참조)       | PLT_CODE + ORG_CODE   |

### 1.4 선행 개발 화면

이 화면에서 등록된 비가동 코드는 다음 화면에서 참조된다:
- **STD49A**: 정례비가동관리 (비가동명 드롭다운)
- **POP 계열**: 실적 비가동 등록 화면

---

## 2. 파일 구조

```
src/main/java/com/wsc/std/std48a/
├── Std48aController.java
├── Std48aService.java
├── Std48aServiceImpl.java
├── Std48aDao.java
└── Std48aDaoImpl.java

src/main/resources/mappers/com/wsc/std/std48a/
└── Std48a.xml

src/main/webapp/WEB-INF/views/std/std48a/
├── std48a.jsp
└── std48a_d0a.jsp

src/main/webapp/resources/js/std/std48a/
├── std48a.js
└── std48a_d0a.js
```

---

## 3. 데이터베이스 설계

### 3.1 TSTD_IDLECODE 컬럼 상세

| 컬럼명          | 데이터타입    | PK  | NULL | 기본값    | 설명                              |
|-----------------|---------------|-----|------|-----------|-----------------------------------|
| PLT_CODE        | VARCHAR(10)   | PK  | N    |           | 공장코드                          |
| SCODE           | VARCHAR(20)   | PK  | N    | 자동채번  | 비가동사유 순번코드 (내부 PK)     |
| PLANTS          | VARCHAR(10)   |     | N    |           | 공장구분 (3603=조립, 3605=가공)   |
| IDLE_CODE       | VARCHAR(20)   |     | N    |           | 비가동코드 (외부 표시용)          |
| SAP_CODE        | VARCHAR(20)   |     | Y    |           | SAP 연동 코드                     |
| IDLE_NAME       | VARCHAR(100)  |     | N    |           | 비가동명                          |
| MG_TYPE1        | VARCHAR(20)   |     | Y    |           | 관리유형1                         |
| MG_TYPE2        | VARCHAR(20)   |     | Y    |           | 관리유형2                         |
| MG_ORG          | VARCHAR(20)   |     | Y    |           | 관리조직코드 (FK → TSTD_ORG)      |
| IDLE_SEQ        | INT           |     | Y    |           | 정렬순서                          |
| ALARM_TYPE      | VARCHAR(10)   |     | Y    |           | 알람유형                          |
| SCOMMENT        | VARCHAR(500)  |     | Y    |           | 비고                              |
| USE_FLAG        | VARCHAR(1)    |     | N    | '1'       | 사용여부 (0=미사용, 1=사용)       |
| IS_NG           | VARCHAR(1)    |     | Y    | '0'       | 불량 관련 여부                    |
| IS_MCT_SCOMMENT | VARCHAR(1)    |     | Y    | '0'       | MCT 코멘트 사용 여부              |
| IS_SAP          | VARCHAR(1)    |     | Y    | '0'       | SAP 연동 여부                     |
| IS_RPT          | VARCHAR(1)    |     | Y    | '0'       | 리포트 포함 여부                  |
| REG_DATE        | DATETIME      |     | N    | NOW()     | 등록일시                          |
| REG_EMP         | VARCHAR(20)   |     | N    |           | 등록자                            |
| MDFY_DATE       | DATETIME      |     | Y    |           | 수정일시                          |
| MDFY_EMP        | VARCHAR(20)   |     | Y    |           | 수정자                            |
| DEL_DATE        | DATETIME      |     | Y    |           | 삭제일시                          |
| DEL_EMP         | VARCHAR(20)   |     | Y    |           | 삭제자                            |
| DATA_FLAG       | TINYINT       |     | N    | 0         | 데이터상태 (0=활성, 2=삭제)       |

### 3.2 SCODE 자동채번 규칙

```
형식: IDC + YYYYMMDD + 일련번호(3자리)
예시: IDC20260204001, IDC20260204002, ...
```

---

## 4. Java 클래스 설계

### 4.1 Controller

```java
package com.wsc.std.std48a;

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
 * 비가동 유형관리 컨트롤러
 * @author 송우석
 */
@Controller
@RequestMapping("/std/std48a")
public class Std48aController extends BaseController {

    @Autowired
    private Std48aService std48aService;

    /**
     * 메인 화면
     */
    @RequestMapping("/std48a.do")
    public String view(HttpServletRequest request, Model model) {
        return "std/std48a/std48a";
    }

    /**
     * 비가동 유형 편집 팝업
     */
    @RequestMapping("/std48a_d0a.do")
    public String popupD0a(HttpServletRequest request, Model model) {
        return "std/std48a/std48a_d0a";
    }

    /**
     * 비가동 코드 목록 조회
     */
    @RequestMapping("/selectList.do")
    @ResponseBody
    public Map<String, Object> selectList(@RequestBody Map<String, Object> param) {
        return std48aService.selectList(param);
    }

    /**
     * 비가동 코드 상세 조회
     */
    @RequestMapping("/selectDetail.do")
    @ResponseBody
    public Map<String, Object> selectDetail(@RequestBody Map<String, Object> param) {
        return std48aService.selectDetail(param);
    }

    /**
     * 비가동 코드 저장 (등록/수정)
     */
    @RequestMapping("/save.do")
    @ResponseBody
    public Map<String, Object> save(@RequestBody Map<String, Object> param) {
        return std48aService.save(param);
    }

    /**
     * 비가동 코드 삭제 (논리삭제)
     */
    @RequestMapping("/delete.do")
    @ResponseBody
    public Map<String, Object> delete(@RequestBody Map<String, Object> param) {
        return std48aService.delete(param);
    }

    /**
     * 비가동 코드 일괄 삭제
     */
    @RequestMapping("/deleteList.do")
    @ResponseBody
    public Map<String, Object> deleteList(@RequestBody Map<String, Object> param) {
        return std48aService.deleteList(param);
    }

    /**
     * 사용여부 일괄 변경
     */
    @RequestMapping("/updateUseFlag.do")
    @ResponseBody
    public Map<String, Object> updateUseFlag(@RequestBody Map<String, Object> param) {
        return std48aService.updateUseFlag(param);
    }

    /**
     * 조직 목록 조회 (드롭다운용)
     */
    @RequestMapping("/selectOrgList.do")
    @ResponseBody
    public Map<String, Object> selectOrgList(@RequestBody Map<String, Object> param) {
        return std48aService.selectOrgList(param);
    }
}
```

### 4.2 Service Interface

```java
package com.wsc.std.std48a;

import java.util.Map;

/**
 * 비가동 유형관리 서비스 인터페이스
 * @author 송우석
 */
public interface Std48aService {

    /**
     * 비가동 코드 목록 조회
     */
    Map<String, Object> selectList(Map<String, Object> param);

    /**
     * 비가동 코드 상세 조회
     */
    Map<String, Object> selectDetail(Map<String, Object> param);

    /**
     * 비가동 코드 저장 (UPSERT)
     */
    Map<String, Object> save(Map<String, Object> param);

    /**
     * 비가동 코드 삭제 (논리삭제)
     */
    Map<String, Object> delete(Map<String, Object> param);

    /**
     * 비가동 코드 일괄 삭제
     */
    Map<String, Object> deleteList(Map<String, Object> param);

    /**
     * 사용여부 일괄 변경
     */
    Map<String, Object> updateUseFlag(Map<String, Object> param);

    /**
     * 조직 목록 조회 (드롭다운용)
     */
    Map<String, Object> selectOrgList(Map<String, Object> param);
}
```

### 4.3 Service Implementation

```java
package com.wsc.std.std48a;

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
 * 비가동 유형관리 서비스 구현
 * @author 송우석
 */
@Service
public class Std48aServiceImpl extends BaseService implements Std48aService {

    @Autowired
    private Std48aDao std48aDao;

    @Override
    public Map<String, Object> selectList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = std48aDao.selectList(param);
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
            Map<String, Object> data = std48aDao.selectDetail(param);
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
            String scode = (String) param.get("scode");
            String overwrite = (String) param.get("OVERWRITE");

            // IDLE_CODE 중복 체크
            Map<String, Object> dupCheck = std48aDao.selectByIdleCode(param);
            if (dupCheck != null) {
                String existingScode = (String) dupCheck.get("scode");
                if (!existingScode.equals(scode)) {
                    result.put("success", false);
                    result.put("errorCode", "100003");
                    result.put("message", "동일한 비가동코드가 이미 존재합니다.");
                    return result;
                }
            }

            // 기존 데이터 확인
            Map<String, Object> existing = std48aDao.selectDetail(param);

            if (existing != null) {
                if ("1".equals(overwrite)) {
                    std48aDao.update(param);
                    result.put("success", true);
                    result.put("message", "수정되었습니다.");
                } else {
                    Integer dataFlag = (Integer) existing.get("dataFlag");
                    if (dataFlag != null && dataFlag == 2) {
                        result.put("success", false);
                        result.put("errorCode", "100002");
                        result.put("message", "동일 데이터가 이력이 존재합니다. 덮어쓰시겠습니까?");
                        result.put("existingData", existing);
                    } else {
                        result.put("success", false);
                        result.put("errorCode", "100001");
                        result.put("message", "동일 데이터가 존재합니다. 덮어쓰시겠습니까?");
                    }
                }
            } else {
                // 신규 등록
                if (scode == null || scode.isEmpty()) {
                    String newScode = generateScode(param);
                    param.put("scode", newScode);
                }
                std48aDao.insert(param);
                result.put("success", true);
                result.put("message", "저장되었습니다.");
                result.put("scode", param.get("scode"));
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
            int cnt = std48aDao.delete(param);
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
                item.put("delEmp", param.get("delEmp"));
                cnt += std48aDao.delete(item);
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
    @Transactional
    public Map<String, Object> updateUseFlag(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("list");
            int cnt = 0;
            for (Map<String, Object> item : list) {
                item.put("useFlag", param.get("useFlag"));
                item.put("mdfyEmp", param.get("mdfyEmp"));
                cnt += std48aDao.updateUseFlag(item);
            }
            result.put("success", true);
            result.put("message", cnt + "건이 변경되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> selectOrgList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = std48aDao.selectOrgList(param);
            result.put("success", true);
            result.put("data", list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * SCODE 자동채번
     * 형식: IDC + YYYYMMDD + 일련번호(3자리)
     */
    private String generateScode(Map<String, Object> param) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(new Date());
        String prefix = "IDC" + dateStr;

        param.put("PREFIX", prefix);
        String lastNo = std48aDao.selectLastScode(param);

        int seq = 1;
        if (lastNo != null && lastNo.startsWith(prefix)) {
            String seqStr = lastNo.substring(prefix.length());
            seq = Integer.parseInt(seqStr) + 1;
        }

        return prefix + String.format("%03d", seq);
    }
}
```

### 4.4 DAO Interface

```java
package com.wsc.std.std48a;

import java.util.List;
import java.util.Map;

/**
 * 비가동 유형관리 DAO 인터페이스
 * @author 송우석
 */
public interface Std48aDao {

    List<Map<String, Object>> selectList(Map<String, Object> param);

    Map<String, Object> selectDetail(Map<String, Object> param);

    Map<String, Object> selectByIdleCode(Map<String, Object> param);

    int insert(Map<String, Object> param);

    int update(Map<String, Object> param);

    int delete(Map<String, Object> param);

    int updateUseFlag(Map<String, Object> param);

    String selectLastScode(Map<String, Object> param);

    List<Map<String, Object>> selectOrgList(Map<String, Object> param);
}
```

### 4.5 DAO Implementation

```java
package com.wsc.std.std48a;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.wsc.framework.base.BaseDao;

/**
 * 비가동 유형관리 DAO 구현
 * @author 송우석
 */
@Repository
public class Std48aDaoImpl extends BaseDao implements Std48aDao {

    private static final String NAMESPACE = "com.wsc.std.std48a.Std48aDao";

    @Override
    public List<Map<String, Object>> selectList(Map<String, Object> param) {
        return getSqlSession().selectList(NAMESPACE + ".selectList", param);
    }

    @Override
    public Map<String, Object> selectDetail(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectDetail", param);
    }

    @Override
    public Map<String, Object> selectByIdleCode(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectByIdleCode", param);
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
    public int updateUseFlag(Map<String, Object> param) {
        return getSqlSession().update(NAMESPACE + ".updateUseFlag", param);
    }

    @Override
    public String selectLastScode(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectLastScode", param);
    }

    @Override
    public List<Map<String, Object>> selectOrgList(Map<String, Object> param) {
        return getSqlSession().selectList(NAMESPACE + ".selectOrgList", param);
    }
}
```

---

## 5. MyBatis Mapper XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--
    비가동 유형관리 Mapper
    @author 송우석
-->
<mapper namespace="com.wsc.std.std48a.Std48aDao">

    <!-- 비가동 코드 목록 조회 -->
    <select id="selectList" parameterType="map" resultType="map">
        SELECT A.PLT_CODE       AS pltCode
             , A.SCODE          AS scode
             , A.PLANTS         AS plants
             , A.IDLE_CODE      AS idleCode
             , A.SAP_CODE       AS sapCode
             , A.IDLE_NAME      AS idleName
             , A.MG_TYPE1       AS mgType1
             , A.MG_TYPE2       AS mgType2
             , A.MG_ORG         AS mgOrg
             , B.ORG_NAME       AS mgOrgName
             , A.IDLE_SEQ       AS idleSeq
             , A.ALARM_TYPE     AS alarmType
             , A.SCOMMENT       AS scomment
             , A.USE_FLAG       AS useFlag
             , A.IS_NG          AS isNg
             , A.IS_MCT_SCOMMENT AS isMctScomment
             , A.IS_SAP         AS isSap
             , A.IS_RPT         AS isRpt
             , A.REG_DATE       AS regDate
             , A.REG_EMP        AS regEmp
             , A.MDFY_DATE      AS mdfyDate
             , A.MDFY_EMP       AS mdfyEmp
             , A.DATA_FLAG      AS dataFlag
          FROM TSTD_IDLECODE A
          LEFT JOIN TSTD_ORG B ON A.PLT_CODE = B.PLT_CODE AND A.MG_ORG = B.ORG_CODE
         WHERE A.PLT_CODE = #{pltCode}
           AND A.DATA_FLAG = 0
        <if test="plants != null and plants != ''">
           AND A.PLANTS = #{plants}
        </if>
        <if test="idleCodeLike != null and idleCodeLike != ''">
           AND A.IDLE_CODE LIKE CONCAT('%', #{idleCodeLike}, '%')
        </if>
        <if test="idleNameLike != null and idleNameLike != ''">
           AND A.IDLE_NAME LIKE CONCAT('%', #{idleNameLike}, '%')
        </if>
        <if test="useFlag != null and useFlag != ''">
           AND A.USE_FLAG = #{useFlag}
        </if>
         ORDER BY A.IDLE_SEQ, A.SCODE
    </select>

    <!-- 비가동 코드 상세 조회 -->
    <select id="selectDetail" parameterType="map" resultType="map">
        SELECT A.PLT_CODE       AS pltCode
             , A.SCODE          AS scode
             , A.PLANTS         AS plants
             , A.IDLE_CODE      AS idleCode
             , A.SAP_CODE       AS sapCode
             , A.IDLE_NAME      AS idleName
             , A.MG_TYPE1       AS mgType1
             , A.MG_TYPE2       AS mgType2
             , A.MG_ORG         AS mgOrg
             , A.IDLE_SEQ       AS idleSeq
             , A.ALARM_TYPE     AS alarmType
             , A.SCOMMENT       AS scomment
             , A.USE_FLAG       AS useFlag
             , A.IS_NG          AS isNg
             , A.IS_MCT_SCOMMENT AS isMctScomment
             , A.IS_SAP         AS isSap
             , A.IS_RPT         AS isRpt
             , A.REG_DATE       AS regDate
             , A.REG_EMP        AS regEmp
             , A.MDFY_DATE      AS mdfyDate
             , A.MDFY_EMP       AS mdfyEmp
             , A.DEL_DATE       AS delDate
             , A.DEL_EMP        AS delEmp
             , A.DATA_FLAG      AS dataFlag
          FROM TSTD_IDLECODE A
         WHERE A.PLT_CODE = #{pltCode}
           AND A.SCODE = #{scode}
    </select>

    <!-- IDLE_CODE로 조회 (중복 체크용) -->
    <select id="selectByIdleCode" parameterType="map" resultType="map">
        SELECT SCODE AS scode
             , PLANTS AS plants
          FROM TSTD_IDLECODE
         WHERE PLT_CODE = #{pltCode}
           AND PLANTS = #{plants}
           AND IDLE_CODE = #{idleCode}
           AND DATA_FLAG = 0
    </select>

    <!-- 비가동 코드 등록 -->
    <insert id="insert" parameterType="map">
        INSERT INTO TSTD_IDLECODE (
            PLT_CODE, SCODE, PLANTS, IDLE_CODE, SAP_CODE
          , IDLE_NAME, MG_TYPE1, MG_TYPE2, MG_ORG, IDLE_SEQ
          , ALARM_TYPE, SCOMMENT, USE_FLAG
          , IS_NG, IS_MCT_SCOMMENT, IS_SAP, IS_RPT
          , REG_DATE, REG_EMP, DATA_FLAG
        ) VALUES (
            #{pltCode}, #{scode}, #{plants}, #{idleCode}, #{sapCode}
          , #{idleName}, #{mgType1}, #{mgType2}, #{mgOrg}, #{idleSeq}
          , #{alarmType}, #{scomment}, IFNULL(#{useFlag}, '1')
          , IFNULL(#{isNg}, '0'), IFNULL(#{isMctScomment}, '0')
          , IFNULL(#{isSap}, '0'), IFNULL(#{isRpt}, '0')
          , NOW(), #{regEmp}, 0
        )
    </insert>

    <!-- 비가동 코드 수정 -->
    <update id="update" parameterType="map">
        UPDATE TSTD_IDLECODE
           SET IDLE_CODE      = #{idleCode}
             , SAP_CODE       = #{sapCode}
             , IDLE_NAME      = #{idleName}
             , MG_TYPE1       = #{mgType1}
             , MG_TYPE2       = #{mgType2}
             , MG_ORG         = #{mgOrg}
             , IDLE_SEQ       = #{idleSeq}
             , ALARM_TYPE     = #{alarmType}
             , SCOMMENT       = #{scomment}
             , USE_FLAG       = #{useFlag}
             , IS_NG          = #{isNg}
             , IS_MCT_SCOMMENT = #{isMctScomment}
             , IS_SAP         = #{isSap}
             , IS_RPT         = #{isRpt}
             , MDFY_DATE      = NOW()
             , MDFY_EMP       = #{mdfyEmp}
             , DATA_FLAG      = 0
             , DEL_DATE       = NULL
             , DEL_EMP        = NULL
         WHERE PLT_CODE = #{pltCode}
           AND SCODE = #{scode}
    </update>

    <!-- 비가동 코드 삭제 (논리삭제) -->
    <update id="delete" parameterType="map">
        UPDATE TSTD_IDLECODE
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND SCODE = #{scode}
    </update>

    <!-- 사용여부 변경 -->
    <update id="updateUseFlag" parameterType="map">
        UPDATE TSTD_IDLECODE
           SET USE_FLAG  = #{useFlag}
             , MDFY_DATE = NOW()
             , MDFY_EMP  = #{mdfyEmp}
         WHERE PLT_CODE = #{pltCode}
           AND SCODE = #{scode}
    </update>

    <!-- 마지막 SCODE 조회 (자동채번용) -->
    <select id="selectLastScode" parameterType="map" resultType="string">
        SELECT MAX(SCODE)
          FROM TSTD_IDLECODE
         WHERE PLT_CODE = #{pltCode}
           AND SCODE LIKE CONCAT(#{PREFIX}, '%')
    </select>

    <!-- 조직 목록 조회 -->
    <select id="selectOrgList" parameterType="map" resultType="map">
        SELECT ORG_CODE AS orgCode
             , ORG_NAME AS orgName
          FROM TSTD_ORG
         WHERE PLT_CODE = #{pltCode}
           AND DATA_FLAG = 0
         ORDER BY ORG_SEQ, ORG_CODE
    </select>

</mapper>
```

---

## 6. 화면 설계

### 6.1 메인 화면 레이아웃 (std48a.jsp)

```
┌─────────────────────────────────────────────────────────────────────────┐
│ [도구모음] 조회 | 도움말                                                 │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌──────────┬──────────┐                                                 │
│ │   조립    │   가공    │  ← TabControl (ASSY:3603 / MC:3605)           │
│ ├──────────┴──────────┤                                                 │
│ │ ┌─ 검색조건 ──────────────────────────────────────────────────────┐ │
│ │ │ 비가동코드: [________] 비가동명: [________] 사용여부: [▼] [조회]│ │
│ │ └───────────────────────────────────────────────────────────────────┘ │
│ ├───────────────────────────────────────────────────────────────────────┤
│ │ ┌─ 비가동 유형 목록 ──────────────────────────────────────────────┐ │
│ │ │┌──┬──────┬────────┬──────┬──────┬──────┬────┬────┬──────────────┐│ │
│ │ ││선│비가동│비가동명│SAP   │관리  │관리  │순번│사용│비고          ││ │
│ │ ││택│코드  │        │코드  │유형1 │조직  │    │여부│              ││ │
│ │ │├──┼──────┼────────┼──────┼──────┼──────┼────┼────┼──────────────┤│ │
│ │ ││□ │A01   │점심시간│S01   │정례  │생산팀│1   │사용│              ││ │
│ │ ││□ │A02   │휴식    │S02   │정례  │생산팀│2   │사용│              ││ │
│ │ ││□ │B01   │설비고장│S10   │비정상│설비팀│10  │사용│              ││ │
│ │ │└──┴──────┴────────┴──────┴──────┴──────┴────┴────┴──────────────┘│ │
│ │ │ [우클릭: 새로만들기 / 열기 / 삭제 / 사용처리 / 미사용처리]       │ │
│ │ └───────────────────────────────────────────────────────────────────┘ │
│ └───────────────────────────────────────────────────────────────────────┘
└─────────────────────────────────────────────────────────────────────────┘
```

### 6.2 편집 팝업 레이아웃 (std48a_d0a.jsp)

```
┌──────────────────────────────────────────────────────────┐
│ 비가동 유형 편집기                                  [X]  │
├──────────────────────────────────────────────────────────┤
│                                                          │
│   비가동코드    [__________________] (필수)             │
│                                                          │
│   비가동명      [__________________] (필수)             │
│                                                          │
│   SAP 코드      [__________________]                    │
│                                                          │
│   관리유형1     [__________________]                    │
│                                                          │
│   관리유형2     [__________________]                    │
│                                                          │
│   관리조직      [▼ 드롭다운_______]                     │
│                                                          │
│   순번          [______] (숫자)                         │
│                                                          │
│   알람유형      [__________________]                    │
│                                                          │
│   비고          ┌─────────────────────────────────┐     │
│                 │ (멀티라인)                      │     │
│                 └─────────────────────────────────┘     │
│                                                          │
│   ┌─ 옵션 ─────────────────────────────────────────┐    │
│   │ □ 사용  □ 불량관련  □ MCT코멘트  □ SAP연동  □ 리포트│   │
│   └──────────────────────────────────────────────────┘   │
│                                                          │
├──────────────────────────────────────────────────────────┤
│ NEW모드:  [저장] [초기화]                                │
│ OPEN모드: [저장 후 닫기] [삭제]                          │
└──────────────────────────────────────────────────────────┘
```

---

## 7. JavaScript 구현

### 7.1 메인 화면 (std48a.js)

```javascript
/**
 * 비가동 유형관리 메인 화면
 * @author 송우석
 */
var Std48a = (function() {
    'use strict';

    var gridAssy;       // 조립 그리드
    var gridMc;         // 가공 그리드
    var currentTab = 'ASSY';    // 현재 탭 (ASSY or MC)
    var contextMenu;

    // 공장구분 코드
    var PLANTS = {
        ASSY: '3603',
        MC: '3605'
    };

    /**
     * 초기화
     */
    function init() {
        initTabs();
        initGrids();
        initContextMenu();
        bindEvents();
    }

    /**
     * 탭 초기화
     */
    function initTabs() {
        $('#tabs').tabs({
            onSelect: function(title, index) {
                currentTab = (index === 0) ? 'ASSY' : 'MC';
                search();
            }
        });
    }

    /**
     * 그리드 초기화
     */
    function initGrids() {
        var columns = [[
            { field: 'ck', checkbox: true },
            { field: 'idleCode', title: '비가동코드', width: 80, halign: 'center', align: 'center' },
            { field: 'idleName', title: '비가동명', width: 120, halign: 'center', align: 'left' },
            { field: 'sapCode', title: 'SAP코드', width: 80, halign: 'center', align: 'center' },
            { field: 'mgType1', title: '관리유형1', width: 80, halign: 'center', align: 'center' },
            { field: 'mgOrgName', title: '관리조직', width: 100, halign: 'center', align: 'left' },
            { field: 'idleSeq', title: '순번', width: 50, halign: 'center', align: 'center' },
            { field: 'useFlag', title: '사용여부', width: 60, halign: 'center', align: 'center',
                formatter: function(val) { return val === '1' ? '사용' : '미사용'; }
            },
            { field: 'scomment', title: '비고', width: 150, halign: 'center', align: 'left' }
        ]];

        var gridOptions = {
            method: 'post',
            fit: true,
            fitColumns: true,
            striped: true,
            singleSelect: false,
            checkOnSelect: true,
            selectOnCheck: true,
            idField: 'scode',
            columns: columns,
            onDblClickRow: function(index, row) {
                openEditPopup(row);
            },
            onRowContextMenu: function(e, index, row) {
                e.preventDefault();
                $(this).datagrid('selectRow', index);
                contextMenu.menu('show', { left: e.pageX, top: e.pageY });
            }
        };

        gridAssy = $('#gridAssy').datagrid(gridOptions);
        gridMc = $('#gridMc').datagrid(gridOptions);
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
                        var row = getCurrentGrid().datagrid('getSelected');
                        if (row) openEditPopup(row);
                        break;
                    case 'delete':
                        deleteSelected();
                        break;
                    case 'use':
                        updateUseFlag('1');
                        break;
                    case 'unuse':
                        updateUseFlag('0');
                        break;
                }
            }
        });
    }

    /**
     * 이벤트 바인딩
     */
    function bindEvents() {
        $('#btnSearch').on('click', search);
        $('#idleCodeLike, #idleNameLike').on('keypress', function(e) {
            if (e.which === 13) search();
        });
    }

    /**
     * 현재 그리드 반환
     */
    function getCurrentGrid() {
        return currentTab === 'ASSY' ? gridAssy : gridMc;
    }

    /**
     * 조회
     */
    function search() {
        var params = {
            pltCode: COMMON.pltCode,
            plants: PLANTS[currentTab],
            idleCodeLike: $('#idleCodeLike').val(),
            idleNameLike: $('#idleNameLike').val(),
            useFlag: $('#useFlag').combobox('getValue')
        };
        getCurrentGrid().datagrid('load', params);
    }

    /**
     * 등록 팝업 열기
     */
    function openAddPopup() {
        Std48aD0a.open('NEW', { plants: PLANTS[currentTab] }, function() {
            search();
        });
    }

    /**
     * 수정 팝업 열기
     */
    function openEditPopup(row) {
        Std48aD0a.open('OPEN', row, function() {
            search();
        });
    }

    /**
     * 선택 항목 삭제
     */
    function deleteSelected() {
        var rows = getCurrentGrid().datagrid('getChecked');
        if (rows.length === 0) {
            COMMON.alert('삭제할 항목을 선택하세요.');
            return;
        }

        COMMON.confirm('선택한 ' + rows.length + '건을 삭제하시겠습니까?', function(r) {
            if (r) {
                var list = [];
                $.each(rows, function(i, row) {
                    list.push({ pltCode: row.pltCode, scode: row.scode });
                });

                COMMON.ajax({
                    url: CTX_PATH + '/std/std48a/deleteList.do',
                    data: { list: list, delEmp: COMMON.userId },
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

    /**
     * 사용여부 일괄 변경
     */
    function updateUseFlag(flag) {
        var rows = getCurrentGrid().datagrid('getChecked');
        if (rows.length === 0) {
            COMMON.alert('변경할 항목을 선택하세요.');
            return;
        }

        var msg = flag === '1' ? '사용 처리' : '미사용 처리';
        COMMON.confirm('선택한 ' + rows.length + '건을 ' + msg + '하시겠습니까?', function(r) {
            if (r) {
                var list = [];
                $.each(rows, function(i, row) {
                    list.push({ pltCode: row.pltCode, scode: row.scode });
                });

                COMMON.ajax({
                    url: CTX_PATH + '/std/std48a/updateUseFlag.do',
                    data: { list: list, useFlag: flag, mdfyEmp: COMMON.userId },
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
    Std48a.init();
});
```

### 7.2 편집 팝업 (std48a_d0a.js)

```javascript
/**
 * 비가동 유형 편집기 팝업
 * @author 송우석
 */
var Std48aD0a = (function() {
    'use strict';

    var dialog;
    var mode;
    var callback;
    var currentData;

    /**
     * 팝업 열기
     */
    function open(openMode, data, cb) {
        mode = openMode;
        callback = cb;
        currentData = data;

        dialog = $('#d0aDialog').dialog({
            title: '비가동 유형 편집기',
            width: 500,
            height: 550,
            modal: true,
            closed: false,
            onOpen: function() {
                loadOrgList();
                updateButtonVisibility();

                if (mode === 'NEW') {
                    clear();
                    $('#plants').val(data.plants);
                } else if (mode === 'OPEN') {
                    loadData(data);
                }
            },
            onClose: function() {
                clear();
            }
        });
    }

    /**
     * 조직 목록 로드
     */
    function loadOrgList() {
        COMMON.ajax({
            url: CTX_PATH + '/std/std48a/selectOrgList.do',
            data: { pltCode: COMMON.pltCode },
            success: function(result) {
                if (result.success) {
                    $('#mgOrg').combobox('loadData', result.data);
                }
            }
        });
    }

    /**
     * 버튼 표시 상태
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
        $('#scode').val(data.scode);
        $('#plants').val(data.plants);
        $('#idleCode').textbox('setValue', data.idleCode);
        $('#idleName').textbox('setValue', data.idleName);
        $('#sapCode').textbox('setValue', data.sapCode);
        $('#mgType1').textbox('setValue', data.mgType1);
        $('#mgType2').textbox('setValue', data.mgType2);
        $('#mgOrg').combobox('setValue', data.mgOrg);
        $('#idleSeq').numberbox('setValue', data.idleSeq);
        $('#alarmType').textbox('setValue', data.alarmType);
        $('#scomment').textbox('setValue', data.scomment);

        $('#useFlag').prop('checked', data.useFlag === '1');
        $('#isNg').prop('checked', data.isNg === '1');
        $('#isMctScomment').prop('checked', data.isMctScomment === '1');
        $('#isSap').prop('checked', data.isSap === '1');
        $('#isRpt').prop('checked', data.isRpt === '1');
    }

    /**
     * 초기화
     */
    function clear() {
        $('#scode').val('');
        $('#idleCode').textbox('setValue', '');
        $('#idleName').textbox('setValue', '');
        $('#sapCode').textbox('setValue', '');
        $('#mgType1').textbox('setValue', '');
        $('#mgType2').textbox('setValue', '');
        $('#mgOrg').combobox('setValue', '');
        $('#idleSeq').numberbox('setValue', '');
        $('#alarmType').textbox('setValue', '');
        $('#scomment').textbox('setValue', '');

        $('#useFlag').prop('checked', true);
        $('#isNg').prop('checked', false);
        $('#isMctScomment').prop('checked', false);
        $('#isSap').prop('checked', false);
        $('#isRpt').prop('checked', false);
    }

    /**
     * 저장
     */
    function save(closeAfter) {
        if (!validate()) return;

        var data = {
            pltCode: COMMON.pltCode,
            scode: $('#scode').val(),
            plants: $('#plants').val(),
            idleCode: $('#idleCode').textbox('getValue'),
            idleName: $('#idleName').textbox('getValue'),
            sapCode: $('#sapCode').textbox('getValue'),
            mgType1: $('#mgType1').textbox('getValue'),
            mgType2: $('#mgType2').textbox('getValue'),
            mgOrg: $('#mgOrg').combobox('getValue'),
            idleSeq: $('#idleSeq').numberbox('getValue'),
            alarmType: $('#alarmType').textbox('getValue'),
            scomment: $('#scomment').textbox('getValue'),
            useFlag: $('#useFlag').is(':checked') ? '1' : '0',
            isNg: $('#isNg').is(':checked') ? '1' : '0',
            isMctScomment: $('#isMctScomment').is(':checked') ? '1' : '0',
            isSap: $('#isSap').is(':checked') ? '1' : '0',
            isRpt: $('#isRpt').is(':checked') ? '1' : '0',
            regEmp: COMMON.userId,
            mdfyEmp: COMMON.userId
        };

        doSave(data, closeAfter, false);
    }

    /**
     * 저장 실행
     */
    function doSave(data, closeAfter, overwrite) {
        if (overwrite) data.OVERWRITE = '1';

        COMMON.ajax({
            url: CTX_PATH + '/std/std48a/save.do',
            data: data,
            success: function(result) {
                if (result.success) {
                    COMMON.alert(result.message);
                    if (callback) callback();
                    if (closeAfter) {
                        dialog.dialog('close');
                    } else if (mode === 'NEW') {
                        clear();
                        $('#plants').val(currentData.plants);
                    }
                } else {
                    if (result.errorCode === '100001' || result.errorCode === '100002') {
                        COMMON.confirm(result.message, function(r) {
                            if (r) doSave(data, closeAfter, true);
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
        if (!$('#idleCode').textbox('getValue')) {
            COMMON.alert('비가동코드를 입력하세요.');
            return false;
        }
        if (!$('#idleName').textbox('getValue')) {
            COMMON.alert('비가동명을 입력하세요.');
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
                    url: CTX_PATH + '/std/std48a/delete.do',
                    data: {
                        pltCode: COMMON.pltCode,
                        scode: $('#scode').val(),
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

    // 이벤트 바인딩
    $(function() {
        $('#btnSave').on('click', function() { save(false); });
        $('#btnSaveClose').on('click', function() { save(true); });
        $('#btnPopupDelete').on('click', deleteItem);
        $('#btnClear').on('click', clear);
    });

    return {
        open: open
    };

})();
```

---

## 8. 테이블 DDL

```sql
-- 비가동 사유 코드 마스터
CREATE TABLE IF NOT EXISTS TSTD_IDLECODE (
    PLT_CODE        VARCHAR(10)   NOT NULL COMMENT '공장코드',
    SCODE           VARCHAR(20)   NOT NULL COMMENT '비가동사유 순번코드 (PK)',
    PLANTS          VARCHAR(10)   NOT NULL COMMENT '공장구분 (3603=조립, 3605=가공)',
    IDLE_CODE       VARCHAR(20)   NOT NULL COMMENT '비가동코드 (외부 표시용)',
    SAP_CODE        VARCHAR(20)   NULL     COMMENT 'SAP 연동 코드',
    IDLE_NAME       VARCHAR(100)  NOT NULL COMMENT '비가동명',
    MG_TYPE1        VARCHAR(20)   NULL     COMMENT '관리유형1',
    MG_TYPE2        VARCHAR(20)   NULL     COMMENT '관리유형2',
    MG_ORG          VARCHAR(20)   NULL     COMMENT '관리조직코드',
    IDLE_SEQ        INT           NULL     COMMENT '정렬순서',
    ALARM_TYPE      VARCHAR(10)   NULL     COMMENT '알람유형',
    SCOMMENT        VARCHAR(500)  NULL     COMMENT '비고',
    USE_FLAG        VARCHAR(1)    DEFAULT '1' COMMENT '사용여부 (0=미사용, 1=사용)',
    IS_NG           VARCHAR(1)    DEFAULT '0' COMMENT '불량 관련 여부',
    IS_MCT_SCOMMENT VARCHAR(1)    DEFAULT '0' COMMENT 'MCT 코멘트 사용 여부',
    IS_SAP          VARCHAR(1)    DEFAULT '0' COMMENT 'SAP 연동 여부',
    IS_RPT          VARCHAR(1)    DEFAULT '0' COMMENT '리포트 포함 여부',
    REG_DATE        DATETIME      NULL     COMMENT '등록일시',
    REG_EMP         VARCHAR(20)   NULL     COMMENT '등록자',
    MDFY_DATE       DATETIME      NULL     COMMENT '수정일시',
    MDFY_EMP        VARCHAR(20)   NULL     COMMENT '수정자',
    DEL_DATE        DATETIME      NULL     COMMENT '삭제일시',
    DEL_EMP         VARCHAR(20)   NULL     COMMENT '삭제자',
    DATA_FLAG       TINYINT       DEFAULT 0 COMMENT '데이터상태 (0=활성, 2=삭제)',
    PRIMARY KEY (PLT_CODE, SCODE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='비가동 사유 코드 마스터';

-- 인덱스
CREATE INDEX IDX_TSTD_IDLECODE_01 ON TSTD_IDLECODE (PLT_CODE, PLANTS, DATA_FLAG);
CREATE INDEX IDX_TSTD_IDLECODE_02 ON TSTD_IDLECODE (PLT_CODE, IDLE_CODE);
CREATE UNIQUE INDEX UDX_TSTD_IDLECODE_01 ON TSTD_IDLECODE (PLT_CODE, PLANTS, IDLE_CODE, DATA_FLAG);
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
| 프론트 | 메인 JSP (탭 포함) 구현          | [ ]  |
| 프론트 | 팝업 JSP 구현                   | [ ]  |
| 프론트 | 메인 JS (탭 전환 로직) 구현      | [ ]  |
| 프론트 | 팝업 JS 구현                    | [ ]  |
| 테스트 | 조립 탭 조회 테스트             | [ ]  |
| 테스트 | 가공 탭 조회 테스트             | [ ]  |
| 테스트 | 등록/수정/삭제 테스트           | [ ]  |
| 테스트 | 사용여부 일괄변경 테스트        | [ ]  |
| 테스트 | IDLE_CODE 중복 체크 테스트      | [ ]  |

### 9.2 테스트 케이스

| TC ID    | 테스트 항목               | 예상 결과                          |
|----------|--------------------------|-----------------------------------|
| TC-001   | 조립 탭 목록 조회         | PLANTS=3603 데이터만 표시          |
| TC-002   | 가공 탭 목록 조회         | PLANTS=3605 데이터만 표시          |
| TC-003   | 비가동코드로 검색         | 해당 코드 포함 항목만 표시         |
| TC-004   | 비가동명으로 검색         | 해당 명칭 포함 항목만 표시         |
| TC-005   | 사용여부 필터             | 선택한 사용여부 항목만 표시        |
| TC-006   | 신규 등록                 | SCODE 자동채번, 정상 저장          |
| TC-007   | 수정 (OPEN 모드)          | 기존 데이터 수정 완료              |
| TC-008   | 동일 IDLE_CODE 등록 시도  | 100003 에러 표시                  |
| TC-009   | 선택 항목 삭제            | DATA_FLAG=2로 논리삭제            |
| TC-010   | 사용 처리 일괄변경        | USE_FLAG=1로 변경                 |
| TC-011   | 미사용 처리 일괄변경      | USE_FLAG=0으로 변경               |

---

## 10. 참고 사항

### 10.1 연관 화면

| 화면 ID | 화면명           | 참조 관계                            |
|---------|-----------------|--------------------------------------|
| STD49A  | 정례비가동관리   | 비가동명 드롭다운으로 TSTD_IDLECODE 참조 |
| POP계열 | 실적 비가동 등록 | 비가동 사유 선택 시 참조             |

### 10.2 의존성

- **STD48A** → **STD49A**: STD48A에서 등록된 비가동 코드를 STD49A에서 참조
- 따라서 **STD48A가 STD49A보다 먼저 개발되어야 함**

### 10.3 공장구분 코드

| 코드  | 명칭   | 설명         |
|-------|--------|--------------|
| 3603  | 조립   | 조립 공장    |
| 3605  | 가공   | 가공 공장    |
