# STD23A/B 휴일관리 — 상세 개발 명세서

> **작성자**: 송우석
> **작성일**: 2026-02-04
> **화면 ID**: STD23A (메인), STD23B (변형)
> **예상 공수**: 35 MH (AI 협업 기준)
> **복잡도**: 상 (캘린더 컴포넌트, CAPA 연동, 2개 화면)

---

## 1. 개요

### 1.1 기능 설명

휴일관리(STD23A/B)는 공장별 휴일을 등록·관리하고, 휴일에 따른 설비 CAPA를 자동으로 0으로 설정하는 기능이다.

- **STD23A**: 휴일 + 설비별 CAPA 통합 관리 (캘린더 + CAPA 그리드)
- **STD23B**: 휴일 목록만 관리 (캘린더 + 휴일 그리드)
- **공통**: 캘린더 우클릭으로 휴일 설정/해제

### 1.2 핵심 특징

| 특징              | 설명                                          |
|-------------------|-----------------------------------------------|
| 물리 삭제         | LSE_HOLIDAY는 DATA_FLAG 없이 물리 DELETE 사용 |
| 휴일-CAPA 연동    | 휴일 등록 시 해당 일자 모든 설비 CAPA=0 처리  |
| 요일별 자동 산정  | 설비 근무시간 기준 요일별 CAPA 자동 계산      |

### 1.3 AS-IS → TO-BE 매핑

| 구분              | AS-IS (C# WinForms)                          | TO-BE (Java Web)                              |
|-------------------|----------------------------------------------|-----------------------------------------------|
| STD23A 메인       | `STD23A_M0A.cs`                              | `std23a.jsp` + `std23a.js`                    |
| STD23A CAPA 팝업  | `STD23A_D0B.cs`                              | `std23a_d0b.jsp` + `std23a_d0b.js`            |
| STD23A 휴일설정   | `STD23A_D1B.cs`                              | `std23a_d1b.jsp` + `std23a_d1b.js`            |
| STD23B 메인       | `STD23B_M0A.cs`                              | `std23b.jsp` + `std23b.js`                    |
| 비즈니스 로직     | `CUBIZ_BR/BSTD/STD23A.cs`, `STD23B.cs`       | `Std23aServiceImpl.java`                      |

### 1.4 핵심 테이블

| 테이블명           | 용도                | PK                            |
|--------------------|---------------------|-------------------------------|
| LSE_HOLIDAY        | 휴일 마스터         | PLT_CODE + HOLI_DATE          |
| TSTD_MC_DAILYCAPA  | 설비 일별 CAPA      | PLT_CODE + MC_CODE + WORK_DATE |
| LSE_MACHINE        | 설비 마스터 (참조)  | PLT_CODE + MC_CODE            |
| LSE_MC_WORKTIME    | 설비 근무시간 (참조) | PLT_CODE + MC_CODE            |
| LSE_MC_CAPAPLAN    | 설비 CAPA 계획 (참조)| PLT_CODE + MC_CODE + MC_DATE   |

---

## 2. 파일 구조

```
src/main/java/com/wsc/std/std23a/
├── Std23aController.java
├── Std23aService.java
├── Std23aServiceImpl.java
├── Std23aDao.java
└── Std23aDaoImpl.java

src/main/resources/mappers/com/wsc/std/std23a/
└── Std23a.xml

src/main/webapp/WEB-INF/views/std/std23a/
├── std23a.jsp          # 메인 화면 (캘린더 + CAPA 그리드)
├── std23a_d0b.jsp      # CAPA 일괄 생성 팝업
├── std23a_d1b.jsp      # 휴일 설정 팝업
└── std23b.jsp          # 변형 메인 화면 (캘린더 + 휴일 그리드)

src/main/webapp/resources/js/std/std23a/
├── std23a.js
├── std23a_d0b.js
├── std23a_d1b.js
└── std23b.js
```

---

## 3. Java 클래스 설계

### 3.1 Controller

```java
package com.wsc.std.std23a;

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
 * 휴일관리 컨트롤러
 * @author 송우석
 */
@Controller
@RequestMapping("/std/std23a")
public class Std23aController extends BaseController {

    @Autowired
    private Std23aService std23aService;

    // ========== 화면 ==========

    @RequestMapping("/std23a.do")
    public String view(HttpServletRequest request, Model model) {
        return "std/std23a/std23a";
    }

    @RequestMapping("/std23b.do")
    public String viewB(HttpServletRequest request, Model model) {
        return "std/std23a/std23b";
    }

    @RequestMapping("/std23a_d0b.do")
    public String popupD0b(HttpServletRequest request, Model model) {
        return "std/std23a/std23a_d0b";
    }

    @RequestMapping("/std23a_d1b.do")
    public String popupD1b(HttpServletRequest request, Model model) {
        return "std/std23a/std23a_d1b";
    }

    // ========== 조회 ==========

    /**
     * 휴일 목록 조회 (캘린더 표시용)
     */
    @RequestMapping("/selectHolidayList.do")
    @ResponseBody
    public Map<String, Object> selectHolidayList(@RequestBody Map<String, Object> param) {
        return std23aService.selectHolidayList(param);
    }

    /**
     * 설비별 일별 CAPA 조회 (STD23A 그리드)
     */
    @RequestMapping("/selectCapaList.do")
    @ResponseBody
    public Map<String, Object> selectCapaList(@RequestBody Map<String, Object> param) {
        return std23aService.selectCapaList(param);
    }

    /**
     * 관리 대상 설비 목록 조회
     */
    @RequestMapping("/selectMachineList.do")
    @ResponseBody
    public Map<String, Object> selectMachineList(@RequestBody Map<String, Object> param) {
        return std23aService.selectMachineList(param);
    }

    /**
     * 요일별 기본 CAPA 조회
     */
    @RequestMapping("/getWeekdayCapa.do")
    @ResponseBody
    public Map<String, Object> getWeekdayCapa(@RequestBody Map<String, Object> param) {
        return std23aService.getWeekdayCapa(param);
    }

    // ========== 저장 ==========

    /**
     * 휴일 설정
     */
    @RequestMapping("/setHoliday.do")
    @ResponseBody
    public Map<String, Object> setHoliday(@RequestBody Map<String, Object> param) {
        return std23aService.setHoliday(param);
    }

    /**
     * 휴일 해제
     */
    @RequestMapping("/cancelHoliday.do")
    @ResponseBody
    public Map<String, Object> cancelHoliday(@RequestBody Map<String, Object> param) {
        return std23aService.cancelHoliday(param);
    }

    /**
     * CAPA 일괄 생성
     */
    @RequestMapping("/generateCapa.do")
    @ResponseBody
    public Map<String, Object> generateCapa(@RequestBody Map<String, Object> param) {
        return std23aService.generateCapa(param);
    }

    /**
     * CAPA 기본값으로 복원
     */
    @RequestMapping("/restoreCapa.do")
    @ResponseBody
    public Map<String, Object> restoreCapa(@RequestBody Map<String, Object> param) {
        return std23aService.restoreCapa(param);
    }

    /**
     * CAPA 수동 수정
     */
    @RequestMapping("/updateCapa.do")
    @ResponseBody
    public Map<String, Object> updateCapa(@RequestBody Map<String, Object> param) {
        return std23aService.updateCapa(param);
    }
}
```

### 3.2 Service Interface

```java
package com.wsc.std.std23a;

import java.util.Map;

/**
 * 휴일관리 서비스 인터페이스
 * @author 송우석
 */
public interface Std23aService {

    // 조회
    Map<String, Object> selectHolidayList(Map<String, Object> param);
    Map<String, Object> selectCapaList(Map<String, Object> param);
    Map<String, Object> selectMachineList(Map<String, Object> param);
    Map<String, Object> getWeekdayCapa(Map<String, Object> param);

    // 휴일 관리
    Map<String, Object> setHoliday(Map<String, Object> param);
    Map<String, Object> cancelHoliday(Map<String, Object> param);

    // CAPA 관리
    Map<String, Object> generateCapa(Map<String, Object> param);
    Map<String, Object> restoreCapa(Map<String, Object> param);
    Map<String, Object> updateCapa(Map<String, Object> param);
}
```

### 3.3 Service Implementation (핵심 메서드)

```java
package com.wsc.std.std23a;

import java.text.SimpleDateFormat;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.framework.base.BaseService;

/**
 * 휴일관리 서비스 구현
 * @author 송우석
 */
@Service
public class Std23aServiceImpl extends BaseService implements Std23aService {

    @Autowired
    private Std23aDao std23aDao;

    @Override
    public Map<String, Object> selectHolidayList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = std23aDao.selectHolidayList(param);
            result.put("success", true);
            result.put("data", list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> selectCapaList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = std23aDao.selectCapaList(param);
            result.put("success", true);
            result.put("data", list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> selectMachineList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = std23aDao.selectMachineList(param);
            result.put("success", true);
            result.put("data", list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> getWeekdayCapa(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 설비 교대 수 조회
            Map<String, Object> machine = std23aDao.selectMachine(param);

            // 설비 근무시간 조회
            Map<String, Object> worktime = std23aDao.selectMcWorktime(param);

            // 요일에 따른 CAPA 반환
            String weekday = (String) param.get("weekday");
            int capa = getCapaByWeekday(worktime, weekday);

            result.put("success", true);
            result.put("capa", capa);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> setHoliday(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            String holiDate = (String) param.get("holiDate");

            // 1. 기존 휴일 확인
            Map<String, Object> existing = std23aDao.selectHoliday(param);
            if (existing == null) {
                // 2. 휴일 등록
                std23aDao.insertHoliday(param);
            }

            // 3. 해당 날짜 모든 설비 CAPA = 0 처리
            param.put("workDate", holiDate);
            std23aDao.updateCapaToZero(param);

            result.put("success", true);
            result.put("message", "휴일이 설정되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> cancelHoliday(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            String holiDate = (String) param.get("holiDate");

            // 1. 휴일 삭제 (물리 삭제)
            std23aDao.deleteHoliday(param);

            // 2. 해당 날짜 설비별 CAPA 복원
            param.put("workDate", holiDate);
            List<Map<String, Object>> capaList = std23aDao.selectCapaByDate(param);

            for (Map<String, Object> capa : capaList) {
                String mcCode = (String) capa.get("mcCode");

                // 요일 계산
                String weekday = getWeekday(holiDate);

                // 해당 요일 기본 CAPA 조회
                Map<String, Object> capaParam = new HashMap<>();
                capaParam.put("pltCode", param.get("pltCode"));
                capaParam.put("mcCode", mcCode);
                capaParam.put("weekday", weekday);

                Map<String, Object> worktime = std23aDao.selectMcWorktime(capaParam);
                int defaultCapa = getCapaByWeekday(worktime, weekday);

                // CAPA 복원
                capaParam.put("workDate", holiDate);
                capaParam.put("capa", defaultCapa);
                std23aDao.updateCapa(capaParam);
            }

            result.put("success", true);
            result.put("message", "휴일이 해제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> generateCapa(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            String frDate = (String) param.get("frDate");
            String toDate = (String) param.get("toDate");
            boolean checkZero = "1".equals(param.get("checkZero"));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> machineList = (List<Map<String, Object>>) param.get("machineList");

            @SuppressWarnings("unchecked")
            Map<String, Boolean> weekdayFlags = (Map<String, Boolean>) param.get("weekdayFlags");

            // 날짜 범위 생성
            List<String> dates = getDateRange(frDate, toDate);

            int cnt = 0;
            for (String date : dates) {
                String weekday = getWeekday(date);
                boolean applyWeekday = weekdayFlags.getOrDefault(weekday, false);

                for (Map<String, Object> machine : machineList) {
                    String mcCode = (String) machine.get("mcCode");

                    Map<String, Object> capaParam = new HashMap<>();
                    capaParam.put("pltCode", param.get("pltCode"));
                    capaParam.put("mcCode", mcCode);
                    capaParam.put("workDate", date);
                    capaParam.put("regEmp", param.get("regEmp"));

                    Map<String, Object> existing = std23aDao.selectCapa(capaParam);

                    if (applyWeekday) {
                        // 요일별 기본 CAPA 계산
                        capaParam.put("weekday", weekday);
                        Map<String, Object> worktime = std23aDao.selectMcWorktime(capaParam);
                        int capa = getCapaByWeekday(worktime, weekday);
                        capaParam.put("capa", capa);

                        if (existing != null) {
                            if (checkZero) {
                                std23aDao.deleteCapa(capaParam);
                                std23aDao.insertCapa(capaParam);
                            } else {
                                std23aDao.updateCapa(capaParam);
                            }
                        } else {
                            std23aDao.insertCapa(capaParam);
                        }
                    } else if (checkZero) {
                        // 비적용 요일 + 초기화 모드 → CAPA=0
                        capaParam.put("capa", 0);
                        if (existing != null) {
                            std23aDao.deleteCapa(capaParam);
                        }
                        std23aDao.insertCapa(capaParam);
                    }
                    cnt++;
                }
            }

            // 휴일 날짜 CAPA=0 처리
            std23aDao.updateHolidayCapaToZero(param);

            result.put("success", true);
            result.put("message", "CAPA가 생성되었습니다. (" + cnt + "건)");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> restoreCapa(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            String workDate = (String) param.get("workDate");
            String weekday = getWeekday(workDate);

            param.put("weekday", weekday);
            Map<String, Object> worktime = std23aDao.selectMcWorktime(param);
            int capa = getCapaByWeekday(worktime, weekday);

            param.put("capa", capa);
            std23aDao.updateCapa(param);

            // CAPA 계획 삭제 (커스텀 CAPA 초기화)
            std23aDao.deleteCapaPlan(param);

            result.put("success", true);
            result.put("message", "CAPA가 기본값으로 복원되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> updateCapa(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            // CAPA 계획 UPSERT
            Map<String, Object> existing = std23aDao.selectCapaPlan(param);
            if (existing != null) {
                std23aDao.updateCapaPlan(param);
            } else {
                std23aDao.insertCapaPlan(param);
            }

            // 총 CAPA 계산 (교대별 합산)
            int totalCapa = calculateTotalCapa(param);
            param.put("capa", totalCapa);

            // 일별 CAPA 업데이트
            std23aDao.updateCapa(param);

            result.put("success", true);
            result.put("message", "CAPA가 수정되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // ========== Helper Methods ==========

    private int getCapaByWeekday(Map<String, Object> worktime, String weekday) {
        if (worktime == null) return 0;

        String colName;
        switch (weekday.toUpperCase()) {
            case "SUNDAY":    colName = "sunTime"; break;
            case "MONDAY":    colName = "monTime"; break;
            case "TUESDAY":   colName = "tueTime"; break;
            case "WEDNESDAY": colName = "wedTime"; break;
            case "THURSDAY":  colName = "thrTime"; break;
            case "FRIDAY":    colName = "friTime"; break;
            case "SATURDAY":  colName = "satTime"; break;
            default: return 0;
        }

        Object val = worktime.get(colName);
        return val != null ? ((Number) val).intValue() : 0;
    }

    private String getWeekday(String dateStr) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            Date date = sdf.parse(dateStr);
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);

            String[] weekdays = {"", "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"};
            return weekdays[dayOfWeek];
        } catch (Exception e) {
            return "";
        }
    }

    private List<String> getDateRange(String frDate, String toDate) {
        List<String> dates = new ArrayList<>();
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            Calendar start = Calendar.getInstance();
            Calendar end = Calendar.getInstance();
            start.setTime(sdf.parse(frDate));
            end.setTime(sdf.parse(toDate));

            while (!start.after(end)) {
                dates.add(sdf.format(start.getTime()));
                start.add(Calendar.DAY_OF_MONTH, 1);
            }
        } catch (Exception e) {
            // ignore
        }
        return dates;
    }

    private int calculateTotalCapa(Map<String, Object> param) {
        int ft1 = getInt(param, "ft1");
        int ft2 = getInt(param, "ft2");
        int fot = getInt(param, "fot");
        int sd1 = getInt(param, "sd1");
        int sd2 = getInt(param, "sd2");
        int sot = getInt(param, "sot");
        int td1 = getInt(param, "td1");
        int td2 = getInt(param, "td2");
        int tot = getInt(param, "tot");

        return ft1 + ft2 + fot + sd1 + sd2 + sot + td1 + td2 + tot;
    }

    private int getInt(Map<String, Object> map, String key) {
        Object val = map.get(key);
        if (val == null) return 0;
        if (val instanceof Number) return ((Number) val).intValue();
        try {
            return Integer.parseInt(val.toString());
        } catch (Exception e) {
            return 0;
        }
    }
}
```

---

## 4. MyBatis Mapper XML (핵심 쿼리)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--
    휴일관리 Mapper
    @author 송우석
-->
<mapper namespace="com.wsc.std.std23a.Std23aDao">

    <!-- 휴일 목록 조회 -->
    <select id="selectHolidayList" parameterType="map" resultType="map">
        SELECT PLT_CODE  AS pltCode
             , HOLI_DATE AS holiDate
             , HOLI_NAME AS holiName
          FROM LSE_HOLIDAY
         WHERE PLT_CODE = #{pltCode}
        <if test="sHoliDate != null and sHoliDate != ''">
           AND HOLI_DATE &gt;= #{sHoliDate}
        </if>
        <if test="eHoliDate != null and eHoliDate != ''">
           AND HOLI_DATE &lt;= #{eHoliDate}
        </if>
         ORDER BY HOLI_DATE
    </select>

    <!-- 휴일 단건 조회 -->
    <select id="selectHoliday" parameterType="map" resultType="map">
        SELECT PLT_CODE  AS pltCode
             , HOLI_DATE AS holiDate
             , HOLI_NAME AS holiName
          FROM LSE_HOLIDAY
         WHERE PLT_CODE = #{pltCode}
           AND HOLI_DATE = #{holiDate}
    </select>

    <!-- 휴일 등록 -->
    <insert id="insertHoliday" parameterType="map">
        INSERT INTO LSE_HOLIDAY (PLT_CODE, HOLI_DATE, HOLI_NAME)
        VALUES (#{pltCode}, #{holiDate}, #{holiName})
    </insert>

    <!-- 휴일 삭제 (물리 삭제) -->
    <delete id="deleteHoliday" parameterType="map">
        DELETE FROM LSE_HOLIDAY
         WHERE PLT_CODE = #{pltCode}
           AND HOLI_DATE = #{holiDate}
    </delete>

    <!-- 설비별 일별 CAPA 조회 (휴일 조인) -->
    <select id="selectCapaList" parameterType="map" resultType="map">
        SELECT A.PLT_CODE  AS pltCode
             , A.WORK_DATE AS workDate
             , A.MC_CODE   AS mcCode
             , B.MC_NAME   AS mcName
             , A.CAPA      AS capa
             , C.HOLI_NAME AS holiName
             , B.MC_GROUP  AS mcGroup
             , A.SCOMMENT  AS scomment
          FROM TSTD_MC_DAILYCAPA A
          LEFT JOIN LSE_MACHINE B ON A.PLT_CODE = B.PLT_CODE AND A.MC_CODE = B.MC_CODE
          LEFT JOIN LSE_HOLIDAY C ON A.PLT_CODE = C.PLT_CODE AND A.WORK_DATE = C.HOLI_DATE
         WHERE A.PLT_CODE = #{pltCode}
        <if test="date1 != null and date1 != ''">
           AND A.WORK_DATE &gt;= #{date1}
        </if>
        <if test="date2 != null and date2 != ''">
           AND A.WORK_DATE &lt;= #{date2}
        </if>
           AND B.MC_MGT_FLAG = 1
           AND B.DATA_FLAG = 0
         ORDER BY A.PLT_CODE, A.WORK_DATE, B.MC_SEQ, A.MC_CODE
    </select>

    <!-- 관리 대상 설비 목록 -->
    <select id="selectMachineList" parameterType="map" resultType="map">
        SELECT MC_CODE   AS mcCode
             , MC_NAME   AS mcName
             , MC_GROUP  AS mcGroup
          FROM LSE_MACHINE
         WHERE PLT_CODE = #{pltCode}
           AND MC_MGT_FLAG = 1
           AND DATA_FLAG = 0
         ORDER BY MC_SEQ, MC_CODE
    </select>

    <!-- 설비 근무시간 조회 -->
    <select id="selectMcWorktime" parameterType="map" resultType="map">
        SELECT MON_TIME AS monTime
             , TUE_TIME AS tueTime
             , WED_TIME AS wedTime
             , THR_TIME AS thrTime
             , FRI_TIME AS friTime
             , SAT_TIME AS satTime
             , SUN_TIME AS sunTime
          FROM LSE_MC_WORKTIME
         WHERE PLT_CODE = #{pltCode}
           AND MC_CODE = #{mcCode}
    </select>

    <!-- 해당 날짜 CAPA = 0 처리 -->
    <update id="updateCapaToZero" parameterType="map">
        UPDATE TSTD_MC_DAILYCAPA
           SET CAPA = 0
         WHERE PLT_CODE = #{pltCode}
           AND WORK_DATE = #{workDate}
    </update>

    <!-- 휴일 날짜 CAPA = 0 일괄 처리 -->
    <update id="updateHolidayCapaToZero" parameterType="map">
        UPDATE TSTD_MC_DAILYCAPA
           SET CAPA = 0
         WHERE PLT_CODE = #{pltCode}
           AND WORK_DATE IN (
               SELECT HOLI_DATE FROM LSE_HOLIDAY WHERE PLT_CODE = #{pltCode}
           )
    </update>

    <!-- CAPA 등록 -->
    <insert id="insertCapa" parameterType="map">
        INSERT INTO TSTD_MC_DAILYCAPA (PLT_CODE, MC_CODE, WORK_DATE, CAPA, SCOMMENT)
        VALUES (#{pltCode}, #{mcCode}, #{workDate}, #{capa}, #{scomment})
        ON DUPLICATE KEY UPDATE CAPA = #{capa}
    </insert>

    <!-- CAPA 수정 -->
    <update id="updateCapa" parameterType="map">
        UPDATE TSTD_MC_DAILYCAPA
           SET CAPA = #{capa}
             , SCOMMENT = #{scomment}
         WHERE PLT_CODE = #{pltCode}
           AND MC_CODE = #{mcCode}
           AND WORK_DATE = #{workDate}
    </update>

    <!-- CAPA 삭제 -->
    <delete id="deleteCapa" parameterType="map">
        DELETE FROM TSTD_MC_DAILYCAPA
         WHERE PLT_CODE = #{pltCode}
           AND MC_CODE = #{mcCode}
           AND WORK_DATE = #{workDate}
    </delete>

</mapper>
```

---

## 5. 화면 설계

### 5.1 STD23A 메인 화면 (캘린더 + CAPA 그리드)

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│ [도구모음] 조회 | 생성 | 도움말                                                      │
├──────────────────────┬──────────────────────────────────────────────────────────────┤
│ ┌─ 캘린더 ─────────┐ │ ┌─ 설비별 CAPA ──────────────────────────────────────────┐   │
│ │                  │ │ │┌────┬──────┬──────┬──────┬────┬──────────┬──────────┐│   │
│ │  [◀ 2026.02 ▶]  │ │ ││선택│날짜  │설비CD│설비명│CAPA│휴일명    │변경사유  ││   │
│ │  일 월 화 수 목 금 토│ │├────┼──────┼──────┼──────┼────┼──────────┼──────────┤│   │
│ │     1  2  3  4  5  6│ │ ││ □ │0203  │MC001 │조립1 │480 │          │          ││   │
│ │  7  8  9 10 11 12 13│ │ ││ □ │0203  │MC002 │조립2 │480 │          │          ││   │
│ │ 14 15 16 17 18 19 20│ │ ││ □ │0204  │MC001 │조립1 │  0 │설날      │          ││   │
│ │ 21 22 23 24 25 26 27│ │ ││ □ │0204  │MC002 │조립2 │  0 │설날      │          ││   │
│ │ 28                  │ │ │└────┴──────┴──────┴──────┴────┴──────────┴──────────┘│   │
│ │                  │ │ │                                                        │   │
│ │  🔴 = 휴일       │ │ │ [우클릭: CAPA 수정 / 기본값 복원]                       │   │
│ │  [우클릭:        │ │ │ [더블클릭: CAPA 수정 팝업]                              │   │
│ │   휴일설정/해제] │ │ └──────────────────────────────────────────────────────────┘   │
│ └────────────────────┘ │                                                              │
└──────────────────────┴──────────────────────────────────────────────────────────────┘
```

### 5.2 STD23B 메인 화면 (캘린더 + 휴일 그리드)

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│ [도구모음] 조회 | 생성 | 도움말                                                      │
├──────────────────────┬──────────────────────────────────────────────────────────────┤
│ ┌─ 캘린더 ─────────┐ │ ┌─ 휴일 목록 ──────────────────────────────────────────────┐ │
│ │                  │ │ │┌────────────────┬────────────────────────────────────┐│   │
│ │  [◀ 2026.02 ▶]  │ │ ││      날짜      │          휴일명                    ││   │
│ │  ...             │ │ │├────────────────┼────────────────────────────────────┤│   │
│ │                  │ │ ││  2026-01-01   │         신정                       ││   │
│ │                  │ │ ││  2026-02-03   │         설날                       ││   │
│ │                  │ │ ││  2026-02-04   │         설날연휴                   ││   │
│ │                  │ │ ││  2026-02-05   │         설날연휴                   ││   │
│ │                  │ │ │└────────────────┴────────────────────────────────────┘│   │
│ └────────────────────┘ │                                                          │
└──────────────────────┴──────────────────────────────────────────────────────────────┘
```

### 5.3 CAPA 일괄 생성 팝업 (D0B)

```
┌─────────────────────────────────────────────────────────────────┐
│ CAPA 일괄 생성                                             [X]  │
├─────────────────────────────────────────────────────────────────┤
│ [저장]                                                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  시작일: [2026-01-01]     종료일: [2026-12-31]                  │
│                                                                 │
│  ☐ 기존데이터 초기화 후 재설정                                  │
│                                                                 │
│  ┌─ 요일 적용 설정 ────────────────────────────────────────┐   │
│  │  ☑ 월  ☑ 화  ☑ 수  ☑ 목  ☑ 금  ☐ 토  ☐ 일           │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ⚠ 해당 기간 내 등록된 휴일의 CAPA는 0으로 설정됩니다.        │
│                                                                 │
│  ┌─ 대상 설비 ─────────────────────────────────────────────┐   │
│  │ ☑ MC001 | 조립1호기  | 라인A                            │   │
│  │ ☑ MC002 | 조립2호기  | 라인A                            │   │
│  │ ☐ MC003 | 가공1호기  | 라인B                            │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. 테이블 DDL

```sql
-- 휴일 마스터
CREATE TABLE IF NOT EXISTS LSE_HOLIDAY (
    PLT_CODE  VARCHAR(10) NOT NULL COMMENT '공장코드',
    HOLI_DATE VARCHAR(8)  NOT NULL COMMENT '휴일날짜 (YYYYMMDD)',
    HOLI_NAME VARCHAR(50) NULL     COMMENT '휴일명',
    PRIMARY KEY (PLT_CODE, HOLI_DATE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='휴일 마스터';

-- 설비 일별 CAPA
CREATE TABLE IF NOT EXISTS TSTD_MC_DAILYCAPA (
    PLT_CODE  VARCHAR(10)   NOT NULL COMMENT '공장코드',
    MC_CODE   VARCHAR(20)   NOT NULL COMMENT '설비코드',
    WORK_DATE VARCHAR(8)    NOT NULL COMMENT '작업일자 (YYYYMMDD)',
    CAPA      DECIMAL(10,2) NULL     COMMENT '가용시간 (분)',
    SCOMMENT  VARCHAR(200)  NULL     COMMENT 'CAPA 변경사유',
    PRIMARY KEY (PLT_CODE, MC_CODE, WORK_DATE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='설비 일별 CAPA';

-- 인덱스
CREATE INDEX IDX_LSE_HOLIDAY_01 ON LSE_HOLIDAY (PLT_CODE, HOLI_DATE);
CREATE INDEX IDX_TSTD_MC_DAILYCAPA_01 ON TSTD_MC_DAILYCAPA (PLT_CODE, WORK_DATE);
```

---

## 7. 체크리스트

| 단계   | 항목                                  | 상태 |
|--------|---------------------------------------|------|
| 설계   | 테이블 생성                           | [ ]  |
| 백엔드 | Controller/Service/DAO 구현           | [ ]  |
| 백엔드 | 휴일 설정/해제 + CAPA 연동 구현        | [ ]  |
| 백엔드 | CAPA 일괄 생성 구현                   | [ ]  |
| 백엔드 | 요일별 CAPA 자동 산정 구현             | [ ]  |
| 프론트 | STD23A 메인 (캘린더+CAPA 그리드)      | [ ]  |
| 프론트 | STD23B 메인 (캘린더+휴일 그리드)      | [ ]  |
| 프론트 | D0B 팝업 (CAPA 일괄 생성)             | [ ]  |
| 프론트 | D1B 팝업 (휴일 설정)                  | [ ]  |
| 프론트 | 캘린더 컴포넌트 연동                   | [ ]  |
| 테스트 | 휴일 등록/해제 + CAPA=0 테스트        | [ ]  |
| 테스트 | CAPA 일괄 생성 테스트                 | [ ]  |
| 테스트 | CAPA 기본값 복원 테스트               | [ ]  |

---

## 8. 참고 사항

### 8.1 휴일-CAPA 연동 패턴

```
휴일 설정 (setHoliday):
  1. LSE_HOLIDAY에 INSERT
  2. 해당 날짜 모든 설비 TSTD_MC_DAILYCAPA.CAPA = 0

휴일 해제 (cancelHoliday):
  1. LSE_HOLIDAY에서 DELETE
  2. 해당 날짜 설비별 요일 기본 CAPA로 복원
```

### 8.2 요일별 CAPA 산정

- LSE_MC_WORKTIME 테이블의 MON_TIME ~ SUN_TIME 참조
- 해당 설비의 교대 수(MC_SHIFT)에 따라 추가 계산 가능

### 8.3 캘린더 컴포넌트

- jQuery UI Datepicker 또는 EasyUI Calendar 사용 권장
- 휴일 날짜는 다른 색상으로 표시
- 우클릭 컨텍스트 메뉴: "휴일 설정" / "휴일 해제"
