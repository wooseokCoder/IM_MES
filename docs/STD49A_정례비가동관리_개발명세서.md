# STD49A 정례비가동관리 — 상세 개발 명세서

> **작성자**: 송우석
> **작성일**: 2026-02-04
> **화면 ID**: STD49A
> **예상 공수**: 22 MH (AI 협업 기준)

---

## 1. 개요

### 1.1 기능 설명

정례비가동관리(STD49A)는 공장에서 정기적으로 반복되는 비가동 시간(점심, 휴식 등)의 스케줄을 등록·수정·삭제하는 기능이다.

- **공장 구분**: 조립(3603), 가공(3605) 탭별 분리 관리
- **시간 중복 체크**: 동일 공장 내 비가동 시간 중복 방지
- **시간 형식**: DB 저장은 `HHmm`(4자리), 화면 표시는 `HH:mm`

### 1.2 AS-IS → TO-BE 매핑

| 구분              | AS-IS (C# WinForms)                          | TO-BE (Java Web)                              |
|-------------------|----------------------------------------------|-----------------------------------------------|
| 메인 화면         | `STD49A_M0A.cs`                              | `std49a.jsp` + `std49a.js`                    |
| 편집 팝업         | `STD49A_D0A.cs`                              | `std49a_d0a.jsp` + `std49a_d0a.js`            |
| 비즈니스 로직     | `CUBIZ_BR/BSTD/STD49A.cs`                    | `Std49aServiceImpl.java`                      |
| 데이터 액세스     | `CUBIZ_DA/DSTD/TSTD_IDLETIME*.cs`            | `Std49aDaoImpl.java` + `Std49a.xml`           |

### 1.3 핵심 테이블

| 테이블명       | 용도                     | PK                     |
|----------------|--------------------------|------------------------|
| TSTD_IDLETIME  | 정례 비가동 스케줄 마스터 | PLT_CODE + IDLE_NO     |
| TSTD_IDLECODE  | 비가동 사유 코드 (참조)  | PLT_CODE + SCODE       |

### 1.4 선행 개발 화면

- **STD48A (비가동 유형관리)**: 비가동명 드롭다운 데이터 제공

---

## 2. 파일 구조

```
src/main/java/com/wsc/std/std49a/
├── Std49aController.java
├── Std49aService.java
├── Std49aServiceImpl.java
├── Std49aDao.java
└── Std49aDaoImpl.java

src/main/resources/mappers/com/wsc/std/std49a/
└── Std49a.xml

src/main/webapp/WEB-INF/views/std/std49a/
├── std49a.jsp
└── std49a_d0a.jsp

src/main/webapp/resources/js/std/std49a/
├── std49a.js
└── std49a_d0a.js
```

---

## 3. 데이터베이스 설계

### 3.1 TSTD_IDLETIME 컬럼 상세

| 컬럼명          | 데이터타입    | PK  | NULL | 기본값    | 설명                                  |
|-----------------|---------------|-----|------|-----------|---------------------------------------|
| PLT_CODE        | VARCHAR(10)   | PK  | N    |           | 공장코드                              |
| IDLE_NO         | VARCHAR(20)   | PK  | N    | 자동채번  | 비가동번호 (접두어 'IDT')             |
| SCODE           | VARCHAR(20)   |     | N    |           | 비가동사유코드 (FK → TSTD_IDLECODE)   |
| IDLE_START_TIME | VARCHAR(4)    |     | N    |           | 비가동 시작시간 (HHmm, 예: "1200")   |
| IDLE_END_TIME   | VARCHAR(4)    |     | N    |           | 비가동 종료시간 (HHmm, 예: "1300")   |
| SCOMMENT        | VARCHAR(500)  |     | Y    |           | 비고                                  |
| REG_DATE        | DATETIME      |     | N    | NOW()     | 등록일시                              |
| REG_EMP         | VARCHAR(20)   |     | N    |           | 등록자                                |
| MDFY_DATE       | DATETIME      |     | Y    |           | 수정일시                              |
| MDFY_EMP        | VARCHAR(20)   |     | Y    |           | 수정자                                |
| DEL_DATE        | DATETIME      |     | Y    |           | 삭제일시                              |
| DEL_EMP         | VARCHAR(20)   |     | Y    |           | 삭제자                                |
| DATA_FLAG       | TINYINT       |     | N    | 0         | 데이터상태 (0=활성, 2=삭제)           |

### 3.2 IDLE_NO 자동채번 규칙

```
형식: IDT + YYYYMMDD + 일련번호(3자리)
예시: IDT20260204001, IDT20260204002, ...
```

### 3.3 시간 저장 형식

| 구분      | 형식    | 예시     |
|-----------|---------|----------|
| DB 저장   | HHmm    | "1200"   |
| 화면 표시 | HH:mm   | "12:00"  |

**변환 규칙**:
```javascript
// 화면 → DB
"12:00" → "1200" (콜론 제거)

// DB → 화면
"1200" → "12:00" (substring(0,2) + ":" + substring(2,4))
```

---

## 4. Java 클래스 설계

### 4.1 Controller

```java
package com.wsc.std.std49a;

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
 * 정례비가동관리 컨트롤러
 * @author 송우석
 */
@Controller
@RequestMapping("/std/std49a")
public class Std49aController extends BaseController {

    @Autowired
    private Std49aService std49aService;

    /**
     * 메인 화면
     */
    @RequestMapping("/std49a.do")
    public String view(HttpServletRequest request, Model model) {
        return "std/std49a/std49a";
    }

    /**
     * 비가동 관리 편집기 팝업
     */
    @RequestMapping("/std49a_d0a.do")
    public String popupD0a(HttpServletRequest request, Model model) {
        return "std/std49a/std49a_d0a";
    }

    /**
     * 정례비가동 목록 조회
     */
    @RequestMapping("/selectList.do")
    @ResponseBody
    public Map<String, Object> selectList(@RequestBody Map<String, Object> param) {
        return std49aService.selectList(param);
    }

    /**
     * 정례비가동 상세 조회
     */
    @RequestMapping("/selectDetail.do")
    @ResponseBody
    public Map<String, Object> selectDetail(@RequestBody Map<String, Object> param) {
        return std49aService.selectDetail(param);
    }

    /**
     * 정례비가동 저장 (등록/수정)
     */
    @RequestMapping("/save.do")
    @ResponseBody
    public Map<String, Object> save(@RequestBody Map<String, Object> param) {
        return std49aService.save(param);
    }

    /**
     * 정례비가동 삭제 (논리삭제)
     */
    @RequestMapping("/delete.do")
    @ResponseBody
    public Map<String, Object> delete(@RequestBody Map<String, Object> param) {
        return std49aService.delete(param);
    }

    /**
     * 비가동 코드 목록 조회 (드롭다운용)
     */
    @RequestMapping("/selectIdleCodeList.do")
    @ResponseBody
    public Map<String, Object> selectIdleCodeList(@RequestBody Map<String, Object> param) {
        return std49aService.selectIdleCodeList(param);
    }
}
```

### 4.2 Service Interface

```java
package com.wsc.std.std49a;

import java.util.Map;

/**
 * 정례비가동관리 서비스 인터페이스
 * @author 송우석
 */
public interface Std49aService {

    /**
     * 정례비가동 목록 조회
     */
    Map<String, Object> selectList(Map<String, Object> param);

    /**
     * 정례비가동 상세 조회
     */
    Map<String, Object> selectDetail(Map<String, Object> param);

    /**
     * 정례비가동 저장 (UPSERT)
     */
    Map<String, Object> save(Map<String, Object> param);

    /**
     * 정례비가동 삭제 (논리삭제)
     */
    Map<String, Object> delete(Map<String, Object> param);

    /**
     * 비가동 코드 목록 조회 (드롭다운용)
     */
    Map<String, Object> selectIdleCodeList(Map<String, Object> param);
}
```

### 4.3 Service Implementation

```java
package com.wsc.std.std49a;

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
 * 정례비가동관리 서비스 구현
 * @author 송우석
 */
@Service
public class Std49aServiceImpl extends BaseService implements Std49aService {

    @Autowired
    private Std49aDao std49aDao;

    @Override
    public Map<String, Object> selectList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = std49aDao.selectList(param);

            // 시간 형식 변환 (HHmm → HH:mm)
            for (Map<String, Object> row : list) {
                row.put("idleStartTimeDisplay", formatTime((String) row.get("idleStartTime")));
                row.put("idleEndTimeDisplay", formatTime((String) row.get("idleEndTime")));
            }

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
            Map<String, Object> data = std49aDao.selectDetail(param);
            if (data != null) {
                data.put("idleStartTimeDisplay", formatTime((String) data.get("idleStartTime")));
                data.put("idleEndTimeDisplay", formatTime((String) data.get("idleEndTime")));
            }
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
            String idleNo = (String) param.get("idleNo");
            String overwrite = (String) param.get("OVERWRITE");

            // 시간 형식 변환 (HH:mm → HHmm)
            String startTime = parseTime((String) param.get("idleStartTime"));
            String endTime = parseTime((String) param.get("idleEndTime"));
            param.put("idleStartTime", startTime);
            param.put("idleEndTime", endTime);

            // 시간 유효성 검사
            if (!isValidTimeRange(startTime, endTime)) {
                result.put("success", false);
                result.put("errorCode", "100010");
                result.put("message", "종료시간은 시작시간보다 커야 합니다.");
                return result;
            }

            // 시간 중복 체크
            param.put("notIdleNo", idleNo);  // 자기 자신 제외
            List<Map<String, Object>> overlaps = std49aDao.selectOverlapList(param);
            if (overlaps != null && !overlaps.isEmpty()) {
                for (Map<String, Object> overlap : overlaps) {
                    if (isTimeOverlap(startTime, endTime,
                            (String) overlap.get("idleStartTime"),
                            (String) overlap.get("idleEndTime"))) {
                        result.put("success", false);
                        result.put("errorCode", "100009");
                        result.put("message", "기존 등록된 비가동 시간과 겹칩니다.");
                        return result;
                    }
                }
            }

            // 기존 데이터 확인
            Map<String, Object> existing = null;
            if (idleNo != null && !idleNo.isEmpty()) {
                existing = std49aDao.selectDetail(param);
            }

            if (existing != null) {
                if ("1".equals(overwrite)) {
                    std49aDao.update(param);
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
                String newIdleNo = generateIdleNo(param);
                param.put("idleNo", newIdleNo);
                std49aDao.insert(param);
                result.put("success", true);
                result.put("message", "저장되었습니다.");
                result.put("idleNo", newIdleNo);
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
            int cnt = std49aDao.delete(param);
            result.put("success", true);
            result.put("message", cnt + "건이 삭제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> selectIdleCodeList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = std49aDao.selectIdleCodeList(param);
            result.put("success", true);
            result.put("data", list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * IDLE_NO 자동채번
     * 형식: IDT + YYYYMMDD + 일련번호(3자리)
     */
    private String generateIdleNo(Map<String, Object> param) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(new Date());
        String prefix = "IDT" + dateStr;

        param.put("PREFIX", prefix);
        String lastNo = std49aDao.selectLastIdleNo(param);

        int seq = 1;
        if (lastNo != null && lastNo.startsWith(prefix)) {
            String seqStr = lastNo.substring(prefix.length());
            seq = Integer.parseInt(seqStr) + 1;
        }

        return prefix + String.format("%03d", seq);
    }

    /**
     * 시간 형식 변환 (HHmm → HH:mm)
     */
    private String formatTime(String time) {
        if (time == null || time.length() < 4) return time;
        return time.substring(0, 2) + ":" + time.substring(2, 4);
    }

    /**
     * 시간 형식 변환 (HH:mm → HHmm)
     */
    private String parseTime(String time) {
        if (time == null) return null;
        return time.replace(":", "");
    }

    /**
     * 시간 범위 유효성 검사 (시작 < 종료)
     */
    private boolean isValidTimeRange(String start, String end) {
        if (start == null || end == null) return false;
        int startInt = Integer.parseInt(start);
        int endInt = Integer.parseInt(end);
        return startInt < endInt;
    }

    /**
     * 시간 중복 체크
     * 4가지 조건:
     * 1. 기존시작 < 신규시작 < 기존종료
     * 2. 기존시작 < 신규종료 < 기존종료
     * 3. 신규시작 < 기존종료 < 신규종료
     * 4. 신규시작 == 기존시작 AND 신규종료 == 기존종료
     */
    private boolean isTimeOverlap(String newStart, String newEnd, String existStart, String existEnd) {
        int ns = Integer.parseInt(newStart);
        int ne = Integer.parseInt(newEnd);
        int es = Integer.parseInt(existStart);
        int ee = Integer.parseInt(existEnd);

        // 조건 1: 기존시작 < 신규시작 < 기존종료
        if (es < ns && ns < ee) return true;
        // 조건 2: 기존시작 < 신규종료 < 기존종료
        if (es < ne && ne < ee) return true;
        // 조건 3: 신규시작 < 기존종료 < 신규종료
        if (ns < ee && ee < ne) return true;
        // 조건 4: 완전 일치
        if (ns == es && ne == ee) return true;
        // 조건 5: 신규가 기존을 완전히 포함
        if (ns <= es && ne >= ee) return true;

        return false;
    }
}
```

### 4.4 DAO Interface

```java
package com.wsc.std.std49a;

import java.util.List;
import java.util.Map;

/**
 * 정례비가동관리 DAO 인터페이스
 * @author 송우석
 */
public interface Std49aDao {

    List<Map<String, Object>> selectList(Map<String, Object> param);

    Map<String, Object> selectDetail(Map<String, Object> param);

    List<Map<String, Object>> selectOverlapList(Map<String, Object> param);

    int insert(Map<String, Object> param);

    int update(Map<String, Object> param);

    int delete(Map<String, Object> param);

    String selectLastIdleNo(Map<String, Object> param);

    List<Map<String, Object>> selectIdleCodeList(Map<String, Object> param);
}
```

### 4.5 DAO Implementation

```java
package com.wsc.std.std49a;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.wsc.framework.base.BaseDao;

/**
 * 정례비가동관리 DAO 구현
 * @author 송우석
 */
@Repository
public class Std49aDaoImpl extends BaseDao implements Std49aDao {

    private static final String NAMESPACE = "com.wsc.std.std49a.Std49aDao";

    @Override
    public List<Map<String, Object>> selectList(Map<String, Object> param) {
        return getSqlSession().selectList(NAMESPACE + ".selectList", param);
    }

    @Override
    public Map<String, Object> selectDetail(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectDetail", param);
    }

    @Override
    public List<Map<String, Object>> selectOverlapList(Map<String, Object> param) {
        return getSqlSession().selectList(NAMESPACE + ".selectOverlapList", param);
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
    public String selectLastIdleNo(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectLastIdleNo", param);
    }

    @Override
    public List<Map<String, Object>> selectIdleCodeList(Map<String, Object> param) {
        return getSqlSession().selectList(NAMESPACE + ".selectIdleCodeList", param);
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
    정례비가동관리 Mapper
    @author 송우석
-->
<mapper namespace="com.wsc.std.std49a.Std49aDao">

    <!-- 정례비가동 목록 조회 -->
    <select id="selectList" parameterType="map" resultType="map">
        SELECT A.PLT_CODE        AS pltCode
             , A.IDLE_NO         AS idleNo
             , A.SCODE           AS scode
             , B.IDLE_CODE       AS idleCode
             , B.IDLE_NAME       AS idleName
             , B.PLANTS          AS plants
             , B.SAP_CODE        AS sapCode
             , A.IDLE_START_TIME AS idleStartTime
             , A.IDLE_END_TIME   AS idleEndTime
             , A.SCOMMENT        AS scomment
             , A.REG_DATE        AS regDate
             , A.REG_EMP         AS regEmp
             , A.MDFY_DATE       AS mdfyDate
             , A.MDFY_EMP        AS mdfyEmp
             , A.DATA_FLAG       AS dataFlag
          FROM TSTD_IDLETIME A
          JOIN TSTD_IDLECODE B ON A.PLT_CODE = B.PLT_CODE AND A.SCODE = B.SCODE
         WHERE A.PLT_CODE = #{pltCode}
           AND A.DATA_FLAG = 0
           AND B.DATA_FLAG = 0
        <if test="plants != null and plants != ''">
           AND B.PLANTS = #{plants}
        </if>
        <if test="scode != null and scode != ''">
           AND A.SCODE = #{scode}
        </if>
        <if test="idleLike != null and idleLike != ''">
           AND (B.IDLE_CODE LIKE CONCAT('%', #{idleLike}, '%')
                OR B.IDLE_NAME LIKE CONCAT('%', #{idleLike}, '%'))
        </if>
         ORDER BY A.IDLE_START_TIME, B.IDLE_SEQ
    </select>

    <!-- 정례비가동 상세 조회 -->
    <select id="selectDetail" parameterType="map" resultType="map">
        SELECT A.PLT_CODE        AS pltCode
             , A.IDLE_NO         AS idleNo
             , A.SCODE           AS scode
             , B.IDLE_NAME       AS idleName
             , B.PLANTS          AS plants
             , A.IDLE_START_TIME AS idleStartTime
             , A.IDLE_END_TIME   AS idleEndTime
             , A.SCOMMENT        AS scomment
             , A.REG_DATE        AS regDate
             , A.REG_EMP         AS regEmp
             , A.MDFY_DATE       AS mdfyDate
             , A.MDFY_EMP        AS mdfyEmp
             , A.DEL_DATE        AS delDate
             , A.DEL_EMP         AS delEmp
             , A.DATA_FLAG       AS dataFlag
          FROM TSTD_IDLETIME A
          LEFT JOIN TSTD_IDLECODE B ON A.PLT_CODE = B.PLT_CODE AND A.SCODE = B.SCODE
         WHERE A.PLT_CODE = #{pltCode}
           AND A.IDLE_NO = #{idleNo}
    </select>

    <!-- 시간 중복 체크용 목록 조회 -->
    <select id="selectOverlapList" parameterType="map" resultType="map">
        SELECT A.IDLE_NO         AS idleNo
             , A.SCODE           AS scode
             , A.IDLE_START_TIME AS idleStartTime
             , A.IDLE_END_TIME   AS idleEndTime
          FROM TSTD_IDLETIME A
          JOIN TSTD_IDLECODE B ON A.PLT_CODE = B.PLT_CODE AND A.SCODE = B.SCODE
         WHERE A.PLT_CODE = #{pltCode}
           AND B.PLANTS = #{plants}
           AND A.DATA_FLAG = 0
        <if test="notIdleNo != null and notIdleNo != ''">
           AND A.IDLE_NO != #{notIdleNo}
        </if>
    </select>

    <!-- 정례비가동 등록 -->
    <insert id="insert" parameterType="map">
        INSERT INTO TSTD_IDLETIME (
            PLT_CODE
          , IDLE_NO
          , SCODE
          , IDLE_START_TIME
          , IDLE_END_TIME
          , SCOMMENT
          , REG_DATE
          , REG_EMP
          , DATA_FLAG
        ) VALUES (
            #{pltCode}
          , #{idleNo}
          , #{scode}
          , #{idleStartTime}
          , #{idleEndTime}
          , #{scomment}
          , NOW()
          , #{regEmp}
          , 0
        )
    </insert>

    <!-- 정례비가동 수정 -->
    <update id="update" parameterType="map">
        UPDATE TSTD_IDLETIME
           SET SCODE           = #{scode}
             , IDLE_START_TIME = #{idleStartTime}
             , IDLE_END_TIME   = #{idleEndTime}
             , SCOMMENT        = #{scomment}
             , MDFY_DATE       = NOW()
             , MDFY_EMP        = #{mdfyEmp}
             , DATA_FLAG       = 0
             , DEL_DATE        = NULL
             , DEL_EMP         = NULL
         WHERE PLT_CODE = #{pltCode}
           AND IDLE_NO = #{idleNo}
    </update>

    <!-- 정례비가동 삭제 (논리삭제) -->
    <update id="delete" parameterType="map">
        UPDATE TSTD_IDLETIME
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND IDLE_NO = #{idleNo}
    </update>

    <!-- 마지막 IDLE_NO 조회 (자동채번용) -->
    <select id="selectLastIdleNo" parameterType="map" resultType="string">
        SELECT MAX(IDLE_NO)
          FROM TSTD_IDLETIME
         WHERE PLT_CODE = #{pltCode}
           AND IDLE_NO LIKE CONCAT(#{PREFIX}, '%')
    </select>

    <!-- 비가동 코드 목록 조회 (드롭다운용) -->
    <select id="selectIdleCodeList" parameterType="map" resultType="map">
        SELECT SCODE     AS scode
             , IDLE_CODE AS idleCode
             , IDLE_NAME AS idleName
             , PLANTS    AS plants
          FROM TSTD_IDLECODE
         WHERE PLT_CODE = #{pltCode}
           AND PLANTS = #{plants}
           AND USE_FLAG = '1'
           AND DATA_FLAG = 0
         ORDER BY IDLE_SEQ, SCODE
    </select>

</mapper>
```

---

## 6. 화면 설계

### 6.1 메인 화면 레이아웃 (std49a.jsp)

```
┌─────────────────────────────────────────────────────────────────────────┐
│ [도구모음] 조회 | 도움말                                                 │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌──────────┬──────────┐                                                 │
│ │   조립    │   가공    │  ← TabControl (ASSY:3603 / MC:3605)           │
│ ├──────────┴──────────┤                                                 │
│ │ ┌─ 검색조건 ────────────────────────────────────────────────────────┐ │
│ │ │ 비가동명: [____________] [조회]                                   │ │
│ │ └───────────────────────────────────────────────────────────────────┘ │
│ ├───────────────────────────────────────────────────────────────────────┤
│ │ ┌─ 정례 비가동 목록 ──────────────────────────────────────────────┐ │
│ │ │┌──────────┬────────────────┬────────────────┬─────────────────────┐│ │
│ │ ││비가동명  │비가동 시작시간 │비가동 종료시간 │비고                 ││ │
│ │ │├──────────┼────────────────┼────────────────┼─────────────────────┤│ │
│ │ ││점심시간  │    12:00       │    13:00       │                     ││ │
│ │ ││오전휴식  │    10:00       │    10:15       │                     ││ │
│ │ ││오후휴식  │    15:00       │    15:15       │                     ││ │
│ │ │└──────────┴────────────────┴────────────────┴─────────────────────┘│ │
│ │ │ [우클릭: 새로만들기 / 열기 / 삭제]                                 │ │
│ │ │ [더블클릭: 수정 팝업 열기]                                         │ │
│ │ └───────────────────────────────────────────────────────────────────┘ │
│ └───────────────────────────────────────────────────────────────────────┘
└─────────────────────────────────────────────────────────────────────────┘
```

### 6.2 편집 팝업 레이아웃 (std49a_d0a.jsp)

```
┌─────────────────────────────────────────────────────────┐
│ 비가동 관리 편집기                                 [X]  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   비가동     [▼ 점심시간________________] (필수)       │
│              (드롭다운 - 비가동 코드 목록)              │
│                                                         │
│   시작 시간  [__:__  ] (필수, HH:mm 형식)              │
│                                                         │
│   종료 시간  [__:__  ] (필수, HH:mm 형식)              │
│                                                         │
│   비고       ┌─────────────────────────────────┐       │
│              │                                 │       │
│              │ (멀티라인)                      │       │
│              │                                 │       │
│              └─────────────────────────────────┘       │
│                                                         │
├─────────────────────────────────────────────────────────┤
│ NEW모드:  [초기화] [저장]                               │
│ OPEN모드: [저장 후 닫기] [삭제]                         │
└─────────────────────────────────────────────────────────┘
```

---

## 7. JavaScript 구현

### 7.1 메인 화면 (std49a.js)

```javascript
/**
 * 정례비가동관리 메인 화면
 * @author 송우석
 */
var Std49a = (function() {
    'use strict';

    var gridAssy;
    var gridMc;
    var currentTab = 'ASSY';
    var contextMenu;

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
            { field: 'idleName', title: '비가동명', width: 120, halign: 'center', align: 'center' },
            { field: 'idleStartTimeDisplay', title: '비가동 시작시간', width: 120, halign: 'center', align: 'center' },
            { field: 'idleEndTimeDisplay', title: '비가동 종료시간', width: 120, halign: 'center', align: 'center' },
            { field: 'scomment', title: '비고', width: 200, halign: 'center', align: 'left' },
            { field: 'idleNo', hidden: true }
        ]];

        var gridOptions = {
            method: 'post',
            fit: true,
            fitColumns: true,
            striped: true,
            singleSelect: true,
            idField: 'idleNo',
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
                }
            }
        });
    }

    /**
     * 이벤트 바인딩
     */
    function bindEvents() {
        $('#btnSearch').on('click', search);
        $('#idleLike').on('keypress', function(e) {
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
            idleLike: $('#idleLike').val()
        };
        getCurrentGrid().datagrid('load', params);
    }

    /**
     * 등록 팝업 열기
     */
    function openAddPopup() {
        Std49aD0a.open('NEW', { plants: PLANTS[currentTab] }, function() {
            search();
        });
    }

    /**
     * 수정 팝업 열기
     */
    function openEditPopup(row) {
        Std49aD0a.open('OPEN', row, function() {
            search();
        });
    }

    /**
     * 선택 항목 삭제
     */
    function deleteSelected() {
        var row = getCurrentGrid().datagrid('getSelected');
        if (!row) {
            COMMON.alert('삭제할 항목을 선택하세요.');
            return;
        }

        COMMON.confirm('삭제하시겠습니까?', function(r) {
            if (r) {
                COMMON.ajax({
                    url: CTX_PATH + '/std/std49a/delete.do',
                    data: {
                        pltCode: row.pltCode,
                        idleNo: row.idleNo,
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
    Std49a.init();
});
```

### 7.2 편집 팝업 (std49a_d0a.js)

```javascript
/**
 * 비가동 관리 편집기 팝업
 * @author 송우석
 */
var Std49aD0a = (function() {
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
            title: '비가동 관리 편집기',
            width: 450,
            height: 350,
            modal: true,
            closed: false,
            onOpen: function() {
                loadIdleCodeList(data.plants);
                updateButtonVisibility();

                if (mode === 'NEW') {
                    clear();
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
     * 비가동 코드 목록 로드
     */
    function loadIdleCodeList(plants) {
        COMMON.ajax({
            url: CTX_PATH + '/std/std49a/selectIdleCodeList.do',
            data: { pltCode: COMMON.pltCode, plants: plants },
            success: function(result) {
                if (result.success) {
                    $('#scode').combobox('loadData', result.data);
                }
            }
        });
    }

    /**
     * 버튼 표시 상태
     */
    function updateButtonVisibility() {
        if (mode === 'NEW') {
            $('#btnClear').show();
            $('#btnSave').show();
            $('#btnSaveClose').hide();
            $('#btnPopupDelete').hide();
        } else {
            $('#btnClear').hide();
            $('#btnSave').hide();
            $('#btnSaveClose').show();
            $('#btnPopupDelete').show();
        }
    }

    /**
     * 데이터 로드
     */
    function loadData(data) {
        $('#idleNo').val(data.idleNo);
        $('#plants').val(data.plants);
        $('#scode').combobox('setValue', data.scode);
        $('#idleStartTime').timespinner('setValue', data.idleStartTimeDisplay);
        $('#idleEndTime').timespinner('setValue', data.idleEndTimeDisplay);
        $('#scomment').textbox('setValue', data.scomment);
    }

    /**
     * 초기화
     */
    function clear() {
        $('#idleNo').val('');
        $('#scode').combobox('setValue', '');
        $('#idleStartTime').timespinner('setValue', '');
        $('#idleEndTime').timespinner('setValue', '');
        $('#scomment').textbox('setValue', '');
    }

    /**
     * 저장
     */
    function save(closeAfter) {
        if (!validate()) return;

        var data = {
            pltCode: COMMON.pltCode,
            idleNo: $('#idleNo').val(),
            plants: currentData.plants,
            scode: $('#scode').combobox('getValue'),
            idleStartTime: $('#idleStartTime').timespinner('getValue'),
            idleEndTime: $('#idleEndTime').timespinner('getValue'),
            scomment: $('#scomment').textbox('getValue'),
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
            url: CTX_PATH + '/std/std49a/save.do',
            data: data,
            success: function(result) {
                if (result.success) {
                    COMMON.alert(result.message);
                    if (callback) callback();
                    if (closeAfter) {
                        dialog.dialog('close');
                    } else if (mode === 'NEW') {
                        clear();
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
        if (!$('#scode').combobox('getValue')) {
            COMMON.alert('비가동을 선택하세요.');
            return false;
        }

        var startTime = $('#idleStartTime').timespinner('getValue');
        var endTime = $('#idleEndTime').timespinner('getValue');

        if (!startTime || !isValidTimeFormat(startTime)) {
            COMMON.alert('시작 시간을 올바른 형식(HH:mm)으로 입력하세요.');
            return false;
        }
        if (!endTime || !isValidTimeFormat(endTime)) {
            COMMON.alert('종료 시간을 올바른 형식(HH:mm)으로 입력하세요.');
            return false;
        }

        // 시작시간 < 종료시간 체크
        var start = parseInt(startTime.replace(':', ''));
        var end = parseInt(endTime.replace(':', ''));
        if (start >= end) {
            COMMON.alert('종료 시간은 시작 시간보다 커야 합니다.');
            return false;
        }

        return true;
    }

    /**
     * 시간 형식 유효성 검사
     */
    function isValidTimeFormat(time) {
        var regex = /^([01]?\d|2[0-3]):([0-5]\d)$/;
        return regex.test(time);
    }

    /**
     * 삭제
     */
    function deleteItem() {
        COMMON.confirm('삭제하시겠습니까?', function(r) {
            if (r) {
                COMMON.ajax({
                    url: CTX_PATH + '/std/std49a/delete.do',
                    data: {
                        pltCode: COMMON.pltCode,
                        idleNo: $('#idleNo').val(),
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
        $('#btnClear').on('click', clear);
        $('#btnSave').on('click', function() { save(false); });
        $('#btnSaveClose').on('click', function() { save(true); });
        $('#btnPopupDelete').on('click', deleteItem);
    });

    return {
        open: open
    };

})();
```

---

## 8. 테이블 DDL

```sql
-- 정례 비가동 시간 스케줄
CREATE TABLE IF NOT EXISTS TSTD_IDLETIME (
    PLT_CODE        VARCHAR(10)  NOT NULL COMMENT '공장코드',
    IDLE_NO         VARCHAR(20)  NOT NULL COMMENT '비가동번호 (PK)',
    SCODE           VARCHAR(20)  NOT NULL COMMENT '비가동사유코드 (FK)',
    IDLE_START_TIME VARCHAR(4)   NOT NULL COMMENT '비가동 시작시간 (HHmm)',
    IDLE_END_TIME   VARCHAR(4)   NOT NULL COMMENT '비가동 종료시간 (HHmm)',
    SCOMMENT        VARCHAR(500) NULL     COMMENT '비고',
    REG_DATE        DATETIME     NULL     COMMENT '등록일시',
    REG_EMP         VARCHAR(20)  NULL     COMMENT '등록자',
    MDFY_DATE       DATETIME     NULL     COMMENT '수정일시',
    MDFY_EMP        VARCHAR(20)  NULL     COMMENT '수정자',
    DEL_DATE        DATETIME     NULL     COMMENT '삭제일시',
    DEL_EMP         VARCHAR(20)  NULL     COMMENT '삭제자',
    DATA_FLAG       TINYINT      DEFAULT 0 COMMENT '데이터상태 (0=활성, 2=삭제)',
    PRIMARY KEY (PLT_CODE, IDLE_NO),
    CONSTRAINT FK_IDLETIME_IDLECODE FOREIGN KEY (PLT_CODE, SCODE)
        REFERENCES TSTD_IDLECODE (PLT_CODE, SCODE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='정례 비가동 시간 스케줄';

-- 인덱스
CREATE INDEX IDX_TSTD_IDLETIME_01 ON TSTD_IDLETIME (PLT_CODE, SCODE, DATA_FLAG);
CREATE INDEX IDX_TSTD_IDLETIME_02 ON TSTD_IDLETIME (PLT_CODE, IDLE_START_TIME);
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
| 백엔드 | 시간 중복 체크 로직 구현         | [ ]  |
| 백엔드 | MyBatis Mapper 구현             | [ ]  |
| 프론트 | 메인 JSP (탭 포함) 구현          | [ ]  |
| 프론트 | 팝업 JSP 구현                   | [ ]  |
| 프론트 | 메인 JS (탭 전환 로직) 구현      | [ ]  |
| 프론트 | 팝업 JS (시간 입력/검증) 구현    | [ ]  |
| 테스트 | 조립 탭 조회 테스트             | [ ]  |
| 테스트 | 가공 탭 조회 테스트             | [ ]  |
| 테스트 | 등록/수정/삭제 테스트           | [ ]  |
| 테스트 | 시간 중복 체크 테스트           | [ ]  |
| 테스트 | 시간 형식 유효성 테스트         | [ ]  |

### 9.2 테스트 케이스

| TC ID    | 테스트 항목                | 예상 결과                          |
|----------|---------------------------|-----------------------------------|
| TC-001   | 조립 탭 목록 조회          | PLANTS=3603 데이터만 표시          |
| TC-002   | 가공 탭 목록 조회          | PLANTS=3605 데이터만 표시          |
| TC-003   | 비가동명 검색              | 해당 명칭 포함 항목만 표시         |
| TC-004   | 신규 등록                  | IDLE_NO 자동채번, 정상 저장        |
| TC-005   | 수정                       | 기존 데이터 수정 완료              |
| TC-006   | 삭제                       | DATA_FLAG=2로 논리삭제            |
| TC-007   | 종료시간 < 시작시간 입력   | 100010 에러 표시                  |
| TC-008   | 시간 중복 (완전 일치)      | 100009 에러 표시                  |
| TC-009   | 시간 중복 (부분 겹침)      | 100009 에러 표시                  |
| TC-010   | 시간 형식 오류             | 유효성 검사 실패 메시지           |

---

## 10. 참고 사항

### 10.1 시간 중복 체크 조건

```
조건 1: 기존시작 < 신규시작 < 기존종료
조건 2: 기존시작 < 신규종료 < 기존종료
조건 3: 신규시작 < 기존종료 < 신규종료
조건 4: 신규시작 == 기존시작 AND 신규종료 == 기존종료
조건 5: 신규가 기존을 완전히 포함 (신규시작 <= 기존시작 AND 신규종료 >= 기존종료)
```

### 10.2 에러 코드

| 에러코드 | 메시지                                | 처리 방법               |
|----------|--------------------------------------|-------------------------|
| 100001   | 동일 데이터가 존재합니다              | Yes → OVERWRITE=1 재시도 |
| 100002   | 동일 데이터가 이력이 존재합니다       | Yes → OVERWRITE=1 재시도 |
| 100009   | 기존 등록된 비가동 시간과 겹칩니다    | 확인 후 시간 수정       |
| 100010   | 종료시간은 시작시간보다 커야 합니다   | 시간 재입력             |

### 10.3 의존성

- **STD48A (비가동 유형관리)** → **STD49A (정례비가동관리)**
- STD49A는 STD48A에서 등록된 비가동 코드를 드롭다운으로 참조
