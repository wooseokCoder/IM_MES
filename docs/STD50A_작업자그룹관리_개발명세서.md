# STD50A 작업자 그룹 관리 — 상세 개발 명세서

> **작성자**: 송우석
> **작성일**: 2026-02-04
> **화면 ID**: STD50A
> **예상 공수**: 26 MH (AI 협업 기준)
> **복잡도**: 중상 (3개 테이블, 4개 그리드 팝업)

---

## 1. 개요

### 1.1 기능 설명

작업자 그룹 관리(STD50A)는 작업자 그룹을 생성하고, 그룹별로 작업자와 작업장(설비)을 배정하는 기능이다.

- **그룹 마스터**: 그룹 기본정보 (그룹명, 비고)
- **그룹별 작업자**: 그룹에 소속된 작업자 목록
- **그룹별 작업장**: 그룹에서 활동 가능한 작업장 목록

### 1.2 AS-IS → TO-BE 매핑

| 구분              | AS-IS (C# WinForms)                          | TO-BE (Java Web)                              |
|-------------------|----------------------------------------------|-----------------------------------------------|
| 메인 화면         | `STD50A_M0A.cs`                              | `std50a.jsp` + `std50a.js`                    |
| 편집 팝업         | `STD50A_D0A.cs`                              | `std50a_d0a.jsp` + `std50a_d0a.js`            |
| 비즈니스 로직     | `CUBIZ_BR/BSTD/STD50A.cs`                    | `Std50aServiceImpl.java`                      |
| 데이터 액세스     | `CUBIZ_DA/DSTD/TSTD_WORKGROUP*.cs`           | `Std50aDaoImpl.java` + `Std50a.xml`           |

### 1.3 핵심 테이블

| 테이블명            | 용도                | PK                            |
|---------------------|---------------------|-------------------------------|
| TSTD_WORKGROUP      | 그룹 마스터         | PLT_CODE + GROUP_NO           |
| TSTD_WORKGROUP_EMP  | 그룹별 작업자       | PLT_CODE + GROUP_NO + EMP_CODE |
| TSTD_WORKGROUP_MC   | 그룹별 작업장       | PLT_CODE + GROUP_NO + MC_CODE  |
| TSTD_EMPLOYEE       | 작업자 마스터 (참조) | PLT_CODE + EMP_CODE           |
| LSE_MACHINE         | 작업장 마스터 (참조) | PLT_CODE + MC_CODE            |

---

## 2. 파일 구조

```
src/main/java/com/wsc/std/std50a/
├── Std50aController.java
├── Std50aService.java
├── Std50aServiceImpl.java
├── Std50aDao.java
└── Std50aDaoImpl.java

src/main/resources/mappers/com/wsc/std/std50a/
└── Std50a.xml

src/main/webapp/WEB-INF/views/std/std50a/
├── std50a.jsp
└── std50a_d0a.jsp

src/main/webapp/resources/js/std/std50a/
├── std50a.js
└── std50a_d0a.js
```

---

## 3. Java 클래스 설계

### 3.1 Controller

```java
package com.wsc.std.std50a;

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
 * 작업자 그룹 관리 컨트롤러
 * @author 송우석
 */
@Controller
@RequestMapping("/std/std50a")
public class Std50aController extends BaseController {

    @Autowired
    private Std50aService std50aService;

    /**
     * 메인 화면
     */
    @RequestMapping("/std50a.do")
    public String view(HttpServletRequest request, Model model) {
        return "std/std50a/std50a";
    }

    /**
     * 편집기 팝업
     */
    @RequestMapping("/std50a_d0a.do")
    public String popupD0a(HttpServletRequest request, Model model) {
        return "std/std50a/std50a_d0a";
    }

    /**
     * 그룹 목록 조회
     */
    @RequestMapping("/selectGroupList.do")
    @ResponseBody
    public Map<String, Object> selectGroupList(@RequestBody Map<String, Object> param) {
        return std50aService.selectGroupList(param);
    }

    /**
     * 그룹 상세 조회 (작업자 + 작업장)
     */
    @RequestMapping("/selectGroupDetail.do")
    @ResponseBody
    public Map<String, Object> selectGroupDetail(@RequestBody Map<String, Object> param) {
        return std50aService.selectGroupDetail(param);
    }

    /**
     * 전체 후보 목록 조회 (작업자 + 작업장)
     */
    @RequestMapping("/selectCandidateList.do")
    @ResponseBody
    public Map<String, Object> selectCandidateList(@RequestBody Map<String, Object> param) {
        return std50aService.selectCandidateList(param);
    }

    /**
     * 그룹 저장 (그룹 + 작업자 + 작업장 일괄)
     */
    @RequestMapping("/save.do")
    @ResponseBody
    public Map<String, Object> save(@RequestBody Map<String, Object> param) {
        return std50aService.save(param);
    }

    /**
     * 그룹 삭제 (연쇄 삭제)
     */
    @RequestMapping("/delete.do")
    @ResponseBody
    public Map<String, Object> delete(@RequestBody Map<String, Object> param) {
        return std50aService.delete(param);
    }
}
```

### 3.2 Service Interface

```java
package com.wsc.std.std50a;

import java.util.Map;

/**
 * 작업자 그룹 관리 서비스 인터페이스
 * @author 송우석
 */
public interface Std50aService {

    Map<String, Object> selectGroupList(Map<String, Object> param);
    Map<String, Object> selectGroupDetail(Map<String, Object> param);
    Map<String, Object> selectCandidateList(Map<String, Object> param);
    Map<String, Object> save(Map<String, Object> param);
    Map<String, Object> delete(Map<String, Object> param);
}
```

### 3.3 Service Implementation

```java
package com.wsc.std.std50a;

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
 * 작업자 그룹 관리 서비스 구현
 * @author 송우석
 */
@Service
public class Std50aServiceImpl extends BaseService implements Std50aService {

    @Autowired
    private Std50aDao std50aDao;

    @Override
    public Map<String, Object> selectGroupList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = std50aDao.selectGroupList(param);
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
    public Map<String, Object> selectGroupDetail(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 그룹 기본정보
            Map<String, Object> group = std50aDao.selectGroup(param);

            // 소속 작업자 목록
            List<Map<String, Object>> empList = std50aDao.selectGroupEmpList(param);

            // 소속 작업장 목록
            List<Map<String, Object>> mcList = std50aDao.selectGroupMcList(param);

            result.put("success", true);
            result.put("group", group);
            result.put("empList", empList);
            result.put("mcList", mcList);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> selectCandidateList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 전체 작업자 후보
            List<Map<String, Object>> empList = std50aDao.selectEmployeeList(param);

            // 전체 작업장 후보
            List<Map<String, Object>> mcList = std50aDao.selectMachineList(param);

            result.put("success", true);
            result.put("empList", empList);
            result.put("mcList", mcList);
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
            String groupNo = (String) param.get("groupNo");
            String overwrite = (String) param.get("OVERWRITE");

            // 1. 그룹 마스터 처리
            if (groupNo == null || groupNo.isEmpty()) {
                // 신규 등록
                String newGroupNo = generateGroupNo(param);
                param.put("groupNo", newGroupNo);
                std50aDao.insertGroup(param);
                groupNo = newGroupNo;
            } else {
                // 기존 확인
                Map<String, Object> existing = std50aDao.selectGroup(param);
                if (existing != null) {
                    if ("1".equals(overwrite)) {
                        std50aDao.updateGroup(param);
                    } else {
                        Integer dataFlag = (Integer) existing.get("dataFlag");
                        if (dataFlag != null && dataFlag == 2) {
                            result.put("success", false);
                            result.put("errorCode", "100002");
                            result.put("message", "동일 데이터가 이력이 존재합니다.");
                            return result;
                        } else {
                            result.put("success", false);
                            result.put("errorCode", "100001");
                            result.put("message", "동일 데이터가 존재합니다.");
                            return result;
                        }
                    }
                } else {
                    std50aDao.insertGroup(param);
                }
            }

            // 2. 작업자 삭제 처리
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> empDelList = (List<Map<String, Object>>) param.get("empDelList");
            if (empDelList != null) {
                for (Map<String, Object> item : empDelList) {
                    item.put("pltCode", param.get("pltCode"));
                    item.put("groupNo", groupNo);
                    item.put("delEmp", param.get("regEmp"));
                    std50aDao.deleteGroupEmp(item);
                }
            }

            // 3. 작업자 추가/수정 처리
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> empInsList = (List<Map<String, Object>>) param.get("empInsList");
            if (empInsList != null) {
                int seq = 1;
                for (Map<String, Object> item : empInsList) {
                    item.put("pltCode", param.get("pltCode"));
                    item.put("groupNo", groupNo);
                    item.put("empSeq", seq++);
                    item.put("regEmp", param.get("regEmp"));
                    item.put("mdfyEmp", param.get("regEmp"));

                    Map<String, Object> existing = std50aDao.selectGroupEmp(item);
                    if (existing != null) {
                        std50aDao.updateGroupEmp(item);
                    } else {
                        std50aDao.insertGroupEmp(item);
                    }
                }
            }

            // 4. 작업장 삭제 처리
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> mcDelList = (List<Map<String, Object>>) param.get("mcDelList");
            if (mcDelList != null) {
                for (Map<String, Object> item : mcDelList) {
                    item.put("pltCode", param.get("pltCode"));
                    item.put("groupNo", groupNo);
                    item.put("delEmp", param.get("regEmp"));
                    std50aDao.deleteGroupMc(item);
                }
            }

            // 5. 작업장 추가/수정 처리
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> mcInsList = (List<Map<String, Object>>) param.get("mcInsList");
            if (mcInsList != null) {
                int seq = 1;
                for (Map<String, Object> item : mcInsList) {
                    item.put("pltCode", param.get("pltCode"));
                    item.put("groupNo", groupNo);
                    item.put("mcSeq", seq++);
                    item.put("regEmp", param.get("regEmp"));
                    item.put("mdfyEmp", param.get("regEmp"));

                    Map<String, Object> existing = std50aDao.selectGroupMc(item);
                    if (existing != null) {
                        std50aDao.updateGroupMc(item);
                    } else {
                        std50aDao.insertGroupMc(item);
                    }
                }
            }

            // 6. 그룹의 COUNT 업데이트
            updateGroupCounts(param.get("pltCode").toString(), groupNo);

            result.put("success", true);
            result.put("message", "저장되었습니다.");
            result.put("groupNo", groupNo);
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
            // 연쇄 삭제: 작업자 → 작업장 → 그룹
            std50aDao.deleteGroupEmpByGroup(param);
            std50aDao.deleteGroupMcByGroup(param);
            int cnt = std50aDao.deleteGroup(param);

            result.put("success", true);
            result.put("message", cnt + "건이 삭제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * GROUP_NO 자동채번
     * 형식: GRP + YYYYMMDD + 일련번호(3자리)
     */
    private String generateGroupNo(Map<String, Object> param) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(new Date());
        String prefix = "GRP" + dateStr;

        param.put("PREFIX", prefix);
        String lastNo = std50aDao.selectLastGroupNo(param);

        int seq = 1;
        if (lastNo != null && lastNo.startsWith(prefix)) {
            String seqStr = lastNo.substring(prefix.length());
            seq = Integer.parseInt(seqStr) + 1;
        }

        return prefix + String.format("%03d", seq);
    }

    /**
     * 그룹의 EMP_COUNT, MC_COUNT 업데이트
     */
    private void updateGroupCounts(String pltCode, String groupNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("pltCode", pltCode);
        param.put("groupNo", groupNo);

        int empCount = std50aDao.countGroupEmp(param);
        int mcCount = std50aDao.countGroupMc(param);

        param.put("empCount", empCount);
        param.put("mcCount", mcCount);
        std50aDao.updateGroupCounts(param);
    }
}
```

### 3.4 DAO Interface

```java
package com.wsc.std.std50a;

import java.util.List;
import java.util.Map;

/**
 * 작업자 그룹 관리 DAO 인터페이스
 * @author 송우석
 */
public interface Std50aDao {

    // 그룹 관련
    List<Map<String, Object>> selectGroupList(Map<String, Object> param);
    Map<String, Object> selectGroup(Map<String, Object> param);
    int insertGroup(Map<String, Object> param);
    int updateGroup(Map<String, Object> param);
    int deleteGroup(Map<String, Object> param);
    String selectLastGroupNo(Map<String, Object> param);
    int updateGroupCounts(Map<String, Object> param);

    // 작업자 관련
    List<Map<String, Object>> selectGroupEmpList(Map<String, Object> param);
    Map<String, Object> selectGroupEmp(Map<String, Object> param);
    int insertGroupEmp(Map<String, Object> param);
    int updateGroupEmp(Map<String, Object> param);
    int deleteGroupEmp(Map<String, Object> param);
    int deleteGroupEmpByGroup(Map<String, Object> param);
    int countGroupEmp(Map<String, Object> param);

    // 작업장 관련
    List<Map<String, Object>> selectGroupMcList(Map<String, Object> param);
    Map<String, Object> selectGroupMc(Map<String, Object> param);
    int insertGroupMc(Map<String, Object> param);
    int updateGroupMc(Map<String, Object> param);
    int deleteGroupMc(Map<String, Object> param);
    int deleteGroupMcByGroup(Map<String, Object> param);
    int countGroupMc(Map<String, Object> param);

    // 후보 목록
    List<Map<String, Object>> selectEmployeeList(Map<String, Object> param);
    List<Map<String, Object>> selectMachineList(Map<String, Object> param);
}
```

---

## 4. MyBatis Mapper XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--
    작업자 그룹 관리 Mapper
    @author 송우석
-->
<mapper namespace="com.wsc.std.std50a.Std50aDao">

    <!-- 그룹 목록 조회 -->
    <select id="selectGroupList" parameterType="map" resultType="map">
        SELECT PLT_CODE   AS pltCode
             , GROUP_NO   AS groupNo
             , GROUP_NAME AS groupName
             , EMP_COUNT  AS empCount
             , MC_COUNT   AS mcCount
             , SCOMMENT   AS scomment
          FROM TSTD_WORKGROUP
         WHERE PLT_CODE = #{pltCode}
           AND DATA_FLAG = 0
        <if test="groupLike != null and groupLike != ''">
           AND GROUP_NAME LIKE CONCAT('%', #{groupLike}, '%')
        </if>
         ORDER BY GROUP_NO
    </select>

    <!-- 그룹 단건 조회 -->
    <select id="selectGroup" parameterType="map" resultType="map">
        SELECT PLT_CODE   AS pltCode
             , GROUP_NO   AS groupNo
             , GROUP_NAME AS groupName
             , EMP_COUNT  AS empCount
             , MC_COUNT   AS mcCount
             , SCOMMENT   AS scomment
             , DATA_FLAG  AS dataFlag
          FROM TSTD_WORKGROUP
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
    </select>

    <!-- 그룹 등록 -->
    <insert id="insertGroup" parameterType="map">
        INSERT INTO TSTD_WORKGROUP (
            PLT_CODE, GROUP_NO, GROUP_NAME
          , EMP_COUNT, MC_COUNT, SCOMMENT
          , REG_DATE, REG_EMP, DATA_FLAG
        ) VALUES (
            #{pltCode}, #{groupNo}, #{groupName}
          , 0, 0, #{scomment}
          , NOW(), #{regEmp}, 0
        )
    </insert>

    <!-- 그룹 수정 -->
    <update id="updateGroup" parameterType="map">
        UPDATE TSTD_WORKGROUP
           SET GROUP_NAME = #{groupName}
             , SCOMMENT   = #{scomment}
             , MDFY_DATE  = NOW()
             , MDFY_EMP   = #{mdfyEmp}
             , DATA_FLAG  = 0
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
    </update>

    <!-- 그룹 삭제 -->
    <update id="deleteGroup" parameterType="map">
        UPDATE TSTD_WORKGROUP
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
    </update>

    <!-- 마지막 GROUP_NO -->
    <select id="selectLastGroupNo" parameterType="map" resultType="string">
        SELECT MAX(GROUP_NO)
          FROM TSTD_WORKGROUP
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO LIKE CONCAT(#{PREFIX}, '%')
    </select>

    <!-- 그룹 COUNT 업데이트 -->
    <update id="updateGroupCounts" parameterType="map">
        UPDATE TSTD_WORKGROUP
           SET EMP_COUNT = #{empCount}
             , MC_COUNT  = #{mcCount}
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
    </update>

    <!-- 그룹별 작업자 목록 -->
    <select id="selectGroupEmpList" parameterType="map" resultType="map">
        SELECT WE.PLT_CODE AS pltCode
             , WE.GROUP_NO AS groupNo
             , WE.EMP_CODE AS empCode
             , E.EMP_NAME  AS empName
             , WE.EMP_SEQ  AS empSeq
          FROM TSTD_WORKGROUP_EMP WE
          LEFT JOIN TSTD_EMPLOYEE E ON WE.PLT_CODE = E.PLT_CODE AND WE.EMP_CODE = E.EMP_CODE
         WHERE WE.PLT_CODE = #{pltCode}
           AND WE.GROUP_NO = #{groupNo}
           AND WE.DATA_FLAG = 0
         ORDER BY WE.EMP_SEQ, WE.EMP_CODE
    </select>

    <!-- 작업자 단건 조회 -->
    <select id="selectGroupEmp" parameterType="map" resultType="map">
        SELECT PLT_CODE  AS pltCode
             , GROUP_NO  AS groupNo
             , EMP_CODE  AS empCode
             , DATA_FLAG AS dataFlag
          FROM TSTD_WORKGROUP_EMP
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND EMP_CODE = #{empCode}
    </select>

    <!-- 작업자 등록 -->
    <insert id="insertGroupEmp" parameterType="map">
        INSERT INTO TSTD_WORKGROUP_EMP (
            PLT_CODE, GROUP_NO, EMP_CODE, EMP_SEQ
          , REG_DATE, REG_EMP, DATA_FLAG
        ) VALUES (
            #{pltCode}, #{groupNo}, #{empCode}, #{empSeq}
          , NOW(), #{regEmp}, 0
        )
    </insert>

    <!-- 작업자 수정 -->
    <update id="updateGroupEmp" parameterType="map">
        UPDATE TSTD_WORKGROUP_EMP
           SET EMP_SEQ   = #{empSeq}
             , MDFY_DATE = NOW()
             , MDFY_EMP  = #{mdfyEmp}
             , DATA_FLAG = 0
             , DEL_DATE  = NULL
             , DEL_EMP   = NULL
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND EMP_CODE = #{empCode}
    </update>

    <!-- 작업자 삭제 -->
    <update id="deleteGroupEmp" parameterType="map">
        UPDATE TSTD_WORKGROUP_EMP
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND EMP_CODE = #{empCode}
    </update>

    <!-- 그룹 전체 작업자 삭제 -->
    <update id="deleteGroupEmpByGroup" parameterType="map">
        UPDATE TSTD_WORKGROUP_EMP
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND DATA_FLAG = 0
    </update>

    <!-- 작업자 수 카운트 -->
    <select id="countGroupEmp" parameterType="map" resultType="int">
        SELECT COUNT(*)
          FROM TSTD_WORKGROUP_EMP
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND DATA_FLAG = 0
    </select>

    <!-- 그룹별 작업장 목록 -->
    <select id="selectGroupMcList" parameterType="map" resultType="map">
        SELECT WM.PLT_CODE  AS pltCode
             , WM.GROUP_NO  AS groupNo
             , WM.MC_CODE   AS mcCode
             , M.MC_NAME    AS mcName
             , M.PROC_CODE  AS procCode
             , M.SCOMMENT   AS scomment
             , WM.MC_SEQ    AS mcSeq
          FROM TSTD_WORKGROUP_MC WM
          LEFT JOIN LSE_MACHINE M ON WM.PLT_CODE = M.PLT_CODE AND WM.MC_CODE = M.MC_CODE
         WHERE WM.PLT_CODE = #{pltCode}
           AND WM.GROUP_NO = #{groupNo}
           AND WM.DATA_FLAG = 0
         ORDER BY WM.MC_SEQ, WM.MC_CODE
    </select>

    <!-- 작업장 단건 조회 -->
    <select id="selectGroupMc" parameterType="map" resultType="map">
        SELECT PLT_CODE  AS pltCode
             , GROUP_NO  AS groupNo
             , MC_CODE   AS mcCode
             , DATA_FLAG AS dataFlag
          FROM TSTD_WORKGROUP_MC
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND MC_CODE = #{mcCode}
    </select>

    <!-- 작업장 등록 -->
    <insert id="insertGroupMc" parameterType="map">
        INSERT INTO TSTD_WORKGROUP_MC (
            PLT_CODE, GROUP_NO, MC_CODE, MC_SEQ
          , REG_DATE, REG_EMP, DATA_FLAG
        ) VALUES (
            #{pltCode}, #{groupNo}, #{mcCode}, #{mcSeq}
          , NOW(), #{regEmp}, 0
        )
    </insert>

    <!-- 작업장 수정 -->
    <update id="updateGroupMc" parameterType="map">
        UPDATE TSTD_WORKGROUP_MC
           SET MC_SEQ    = #{mcSeq}
             , MDFY_DATE = NOW()
             , MDFY_EMP  = #{mdfyEmp}
             , DATA_FLAG = 0
             , DEL_DATE  = NULL
             , DEL_EMP   = NULL
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND MC_CODE = #{mcCode}
    </update>

    <!-- 작업장 삭제 -->
    <update id="deleteGroupMc" parameterType="map">
        UPDATE TSTD_WORKGROUP_MC
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND MC_CODE = #{mcCode}
    </update>

    <!-- 그룹 전체 작업장 삭제 -->
    <update id="deleteGroupMcByGroup" parameterType="map">
        UPDATE TSTD_WORKGROUP_MC
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND DATA_FLAG = 0
    </update>

    <!-- 작업장 수 카운트 -->
    <select id="countGroupMc" parameterType="map" resultType="int">
        SELECT COUNT(*)
          FROM TSTD_WORKGROUP_MC
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NO = #{groupNo}
           AND DATA_FLAG = 0
    </select>

    <!-- 전체 작업자 후보 -->
    <select id="selectEmployeeList" parameterType="map" resultType="map">
        SELECT EMP_CODE AS empCode
             , EMP_NAME AS empName
          FROM TSTD_EMPLOYEE
         WHERE PLT_CODE = #{pltCode}
           AND DATA_FLAG = 0
           AND (FIRE_FLAG IS NULL OR FIRE_FLAG != '1')
         ORDER BY EMP_SEQ, EMP_CODE
    </select>

    <!-- 전체 작업장 후보 -->
    <select id="selectMachineList" parameterType="map" resultType="map">
        SELECT MC_CODE   AS mcCode
             , MC_NAME   AS mcName
             , PROC_CODE AS procCode
             , SCOMMENT  AS scomment
          FROM LSE_MACHINE
         WHERE PLT_CODE = #{pltCode}
           AND DATA_FLAG = 0
         ORDER BY MC_CODE
    </select>

</mapper>
```

---

## 5. 화면 설계

### 5.1 메인 화면 레이아웃 (std50a.jsp)

```
┌─────────────────────────────────────────────────────────────────────────┐
│ [도구모음] 조회 | 도움말                                                 │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─ 검색조건 ──────────────────────────────────────────────────────────┐ │
│ │ 작업자 그룹명: [____________] [조회]                                │ │
│ └───────────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─ 그룹 목록 ────────────────────────────────────────────────────────┐ │
│ │┌──────────────┬──────────────┬──────────┬───────────────────────────┐│ │
│ ││작업자 그룹명 │활동 작업장 수│작업자 수 │비고                       ││ │
│ │├──────────────┼──────────────┼──────────┼───────────────────────────┤│ │
│ ││조립1팀       │5             │10        │                           ││ │
│ ││조립2팀       │3             │8         │                           ││ │
│ │└──────────────┴──────────────┴──────────┴───────────────────────────┘│ │
│ │ [우클릭: 새로만들기 / 열기 / 삭제] [더블클릭: 수정 팝업]             │ │
│ └───────────────────────────────────────────────────────────────────────┘ │
├───────────────────────────────┬─────────────────────────────────────────┤
│ ┌─ 작업장 ──────────────────┐ │ ┌─ 작업자 ────────────────────────────┐ │
│ │┌────────┬────────┬────────┐│ │ │┌────────────┬───────────────────────┐│ │
│ ││작업장코드│작업장명│공정코드││ │ ││작업자코드  │작업자명               ││ │
│ │├────────┼────────┼────────┤│ │ │├────────────┼───────────────────────┤│ │
│ ││M001    │조립1호기│ASSY   ││ │ ││E001        │김철수                  ││ │
│ ││M002    │조립2호기│ASSY   ││ │ ││E002        │이영희                  ││ │
│ │└────────┴────────┴────────┘│ │ │└────────────┴───────────────────────┘│ │
│ └────────────────────────────┘ │ └──────────────────────────────────────┘ │
└───────────────────────────────┴─────────────────────────────────────────┘
```

### 5.2 편집 팝업 레이아웃 (std50a_d0a.jsp)

```
┌───────────────────────────────────────────────────────────────────────────────────┐
│ 작업자 그룹 편집기                                                          [X]  │
├───────────────────────────────────────────────────────────────────────────────────┤
│ 작업자 그룹명: [_______________] 작업장수: [__] 작업자수: [__]                    │
│ 비고:         [_____________________________________________________________]    │
├───────────────────────────────────────────────────────────────────────────────────┤
│ ┌─ 작업장 ──────────────────────────────────────────────────────────────────────┐ │
│ │ ┌── 소속 작업장 ────────────────┐ ┌── 전체 작업장 ────────────────────────┐  │ │
│ │ │ MC_CODE | MC_NAME | PROC_CODE │ │ MC_CODE | MC_NAME | PROC_CODE        │  │ │
│ │ │ (우클릭: 삭제)                │ │ (우클릭: 추가)                       │  │ │
│ │ │                               │ │                                      │  │ │
│ │ └───────────────────────────────┘ └────────────────────────────────────────┘  │ │
│ └────────────────────────────────────────────────────────────────────────────────┘ │
│ ┌─ 작업자 ──────────────────────────────────────────────────────────────────────┐ │
│ │ ┌── 소속 작업자 ────────────────┐ ┌── 전체 작업자 ────────────────────────┐  │ │
│ │ │ EMP_CODE | EMP_NAME           │ │ EMP_CODE | EMP_NAME                   │  │ │
│ │ │ (우클릭: 삭제)                │ │ (우클릭: 추가)                       │  │ │
│ │ │                               │ │                                      │  │ │
│ │ └───────────────────────────────┘ └────────────────────────────────────────┘  │ │
│ └────────────────────────────────────────────────────────────────────────────────┘ │
├───────────────────────────────────────────────────────────────────────────────────┤
│ NEW모드:  [초기화] [저장]                                                         │
│ OPEN모드: [저장 후 닫기] [삭제]                                                   │
└───────────────────────────────────────────────────────────────────────────────────┘
```

---

## 6. 테이블 DDL

```sql
-- 작업자 그룹 마스터
CREATE TABLE IF NOT EXISTS TSTD_WORKGROUP (
    PLT_CODE   VARCHAR(10)  NOT NULL COMMENT '공장코드',
    GROUP_NO   VARCHAR(20)  NOT NULL COMMENT '그룹번호',
    GROUP_NAME VARCHAR(100) NOT NULL COMMENT '그룹명',
    EMP_COUNT  INT          DEFAULT 0 COMMENT '작업자 수',
    MC_COUNT   INT          DEFAULT 0 COMMENT '작업장 수',
    SCOMMENT   VARCHAR(500) NULL     COMMENT '비고',
    REG_DATE   DATETIME     NULL     COMMENT '등록일시',
    REG_EMP    VARCHAR(20)  NULL     COMMENT '등록자',
    MDFY_DATE  DATETIME     NULL     COMMENT '수정일시',
    MDFY_EMP   VARCHAR(20)  NULL     COMMENT '수정자',
    DEL_DATE   DATETIME     NULL     COMMENT '삭제일시',
    DEL_EMP    VARCHAR(20)  NULL     COMMENT '삭제자',
    DATA_FLAG  TINYINT      DEFAULT 0 COMMENT '데이터상태 (0=정상, 2=삭제)',
    PRIMARY KEY (PLT_CODE, GROUP_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='작업자 그룹 마스터';

-- 그룹별 작업자
CREATE TABLE IF NOT EXISTS TSTD_WORKGROUP_EMP (
    PLT_CODE  VARCHAR(10) NOT NULL COMMENT '공장코드',
    GROUP_NO  VARCHAR(20) NOT NULL COMMENT '그룹번호',
    EMP_CODE  VARCHAR(20) NOT NULL COMMENT '사원코드',
    EMP_SEQ   INT         NULL     COMMENT '정렬순서',
    REG_DATE  DATETIME    NULL     COMMENT '등록일시',
    REG_EMP   VARCHAR(20) NULL     COMMENT '등록자',
    MDFY_DATE DATETIME    NULL     COMMENT '수정일시',
    MDFY_EMP  VARCHAR(20) NULL     COMMENT '수정자',
    DEL_DATE  DATETIME    NULL     COMMENT '삭제일시',
    DEL_EMP   VARCHAR(20) NULL     COMMENT '삭제자',
    DATA_FLAG TINYINT     DEFAULT 0 COMMENT '데이터상태 (0=정상, 2=삭제)',
    PRIMARY KEY (PLT_CODE, GROUP_NO, EMP_CODE),
    CONSTRAINT FK_WORKGROUP_EMP_GROUP FOREIGN KEY (PLT_CODE, GROUP_NO)
        REFERENCES TSTD_WORKGROUP (PLT_CODE, GROUP_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='그룹별 작업자';

-- 그룹별 작업장
CREATE TABLE IF NOT EXISTS TSTD_WORKGROUP_MC (
    PLT_CODE  VARCHAR(10) NOT NULL COMMENT '공장코드',
    GROUP_NO  VARCHAR(20) NOT NULL COMMENT '그룹번호',
    MC_CODE   VARCHAR(20) NOT NULL COMMENT '작업장코드',
    MC_SEQ    INT         NULL     COMMENT '정렬순서',
    REG_DATE  DATETIME    NULL     COMMENT '등록일시',
    REG_EMP   VARCHAR(20) NULL     COMMENT '등록자',
    MDFY_DATE DATETIME    NULL     COMMENT '수정일시',
    MDFY_EMP  VARCHAR(20) NULL     COMMENT '수정자',
    DEL_DATE  DATETIME    NULL     COMMENT '삭제일시',
    DEL_EMP   VARCHAR(20) NULL     COMMENT '삭제자',
    DATA_FLAG TINYINT     DEFAULT 0 COMMENT '데이터상태 (0=정상, 2=삭제)',
    PRIMARY KEY (PLT_CODE, GROUP_NO, MC_CODE),
    CONSTRAINT FK_WORKGROUP_MC_GROUP FOREIGN KEY (PLT_CODE, GROUP_NO)
        REFERENCES TSTD_WORKGROUP (PLT_CODE, GROUP_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='그룹별 작업장';
```

---

## 7. 체크리스트

| 단계   | 항목                                | 상태 |
|--------|-------------------------------------|------|
| 설계   | 3개 테이블 생성                     | [ ]  |
| 백엔드 | Controller/Service/DAO 구현         | [ ]  |
| 백엔드 | 연쇄 삭제 로직 구현                  | [ ]  |
| 백엔드 | COUNT 자동 업데이트 구현             | [ ]  |
| 프론트 | 메인 화면 (3단 분할) 구현            | [ ]  |
| 프론트 | 팝업 (4개 그리드) 구현               | [ ]  |
| 프론트 | 좌우 그리드 간 추가/삭제 로직 구현   | [ ]  |
| 테스트 | 그룹 CRUD 테스트                    | [ ]  |
| 테스트 | 작업자/작업장 추가/삭제 테스트       | [ ]  |
| 테스트 | 연쇄 삭제 테스트                    | [ ]  |
