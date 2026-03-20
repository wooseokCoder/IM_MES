# ORD02A 메일그룹관리 — 상세 개발 명세서

> **작성자**: 송우석
> **작성일**: 2026-02-04
> **화면 ID**: ORD02A
> **예상 공수**: 24 MH (AI 협업 기준)

---

## 1. 개요

### 1.1 기능 설명

메일그룹관리(ORD02A)는 수신자 그룹을 생성하고, 그룹별 사원(멤버)을 등록·관리하는 기능이다.

- **좌측 패널**: 메일 그룹 마스터 관리 (그룹명, 사용여부)
- **우측 패널**: 선택된 그룹의 멤버(사원) 관리
- **엑셀 업로드**: 팝업을 통한 멤버 일괄 등록

### 1.2 AS-IS → TO-BE 매핑

| 구분              | AS-IS (C# WinForms)                          | TO-BE (Java Web)                              |
|-------------------|----------------------------------------------|-----------------------------------------------|
| 메인 화면         | `ORD02A_M0A.cs`                              | `ord02a.jsp` + `ord02a.js`                    |
| 엑셀 업로드 팝업  | `ORD02A_D0A.cs`                              | `ord02a_d0a.jsp` + `ord02a_d0a.js`            |
| 비즈니스 로직     | `CUBIZ_BR/BORD/ORD02A.cs`                    | `Ord02aServiceImpl.java`                      |
| 데이터 액세스     | `CUBIZ_DA/DORD/TORD_EMAIL_GROUP*.cs`         | `Ord02aDaoImpl.java` + `Ord02a.xml`           |

### 1.3 핵심 테이블

| 테이블명             | 용도                | PK                           |
|----------------------|---------------------|------------------------------|
| TORD_EMAIL_GROUP     | 메일그룹 마스터     | PLT_CODE + MCODE             |
| TORD_EMAIL_GROUP_EMP | 메일그룹 멤버       | PLT_CODE + MCODE + EMP_CODE  |
| TSTD_EMPLOYEE        | 사원 마스터 (참조)  | PLT_CODE + EMP_CODE          |
| TSTD_ORG             | 부서 마스터 (참조)  | PLT_CODE + ORG_CODE          |

### 1.4 참조하는 화면

| 화면 ID | 화면명         | 참조 내용                    |
|---------|----------------|------------------------------|
| ORD03A  | 월별생산계획   | 그룹 목록 + 멤버 조회 (메일 발송) |
| ORD08A  | 메일 관련      | 멤버 목록 조회 (수신자 조회) |
| ORD29A  | 메일 발송 관련 | 그룹+멤버 조회 및 메일 수신자 구성 |

---

## 2. 파일 구조

```
src/main/java/com/wsc/ord/ord02a/
├── Ord02aController.java
├── Ord02aService.java
├── Ord02aServiceImpl.java
├── Ord02aDao.java
└── Ord02aDaoImpl.java

src/main/resources/mappers/com/wsc/ord/ord02a/
└── Ord02a.xml

src/main/webapp/WEB-INF/views/ord/ord02a/
├── ord02a.jsp
└── ord02a_d0a.jsp

src/main/webapp/resources/js/ord/ord02a/
├── ord02a.js
└── ord02a_d0a.js
```

---

## 3. Java 클래스 설계

### 3.1 Controller

```java
package com.wsc.ord.ord02a;

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
 * 메일그룹관리 컨트롤러
 * @author 송우석
 */
@Controller
@RequestMapping("/ord/ord02a")
public class Ord02aController extends BaseController {

    @Autowired
    private Ord02aService ord02aService;

    /**
     * 메인 화면
     */
    @RequestMapping("/ord02a.do")
    public String view(HttpServletRequest request, Model model) {
        return "ord/ord02a/ord02a";
    }

    /**
     * 엑셀 업로드 팝업
     */
    @RequestMapping("/ord02a_d0a.do")
    public String popupD0a(HttpServletRequest request, Model model) {
        return "ord/ord02a/ord02a_d0a";
    }

    /**
     * 그룹 목록 조회
     */
    @RequestMapping("/selectGroupList.do")
    @ResponseBody
    public Map<String, Object> selectGroupList(@RequestBody Map<String, Object> param) {
        return ord02aService.selectGroupList(param);
    }

    /**
     * 그룹별 멤버 목록 조회
     */
    @RequestMapping("/selectMemberList.do")
    @ResponseBody
    public Map<String, Object> selectMemberList(@RequestBody Map<String, Object> param) {
        return ord02aService.selectMemberList(param);
    }

    /**
     * 그룹 저장 (등록/수정)
     */
    @RequestMapping("/saveGroup.do")
    @ResponseBody
    public Map<String, Object> saveGroup(@RequestBody Map<String, Object> param) {
        return ord02aService.saveGroup(param);
    }

    /**
     * 그룹 일괄 저장
     */
    @RequestMapping("/saveGroupList.do")
    @ResponseBody
    public Map<String, Object> saveGroupList(@RequestBody Map<String, Object> param) {
        return ord02aService.saveGroupList(param);
    }

    /**
     * 멤버 저장 (등록/수정)
     */
    @RequestMapping("/saveMember.do")
    @ResponseBody
    public Map<String, Object> saveMember(@RequestBody Map<String, Object> param) {
        return ord02aService.saveMember(param);
    }

    /**
     * 멤버 일괄 저장
     */
    @RequestMapping("/saveMemberList.do")
    @ResponseBody
    public Map<String, Object> saveMemberList(@RequestBody Map<String, Object> param) {
        return ord02aService.saveMemberList(param);
    }

    /**
     * 그룹 삭제 (논리삭제)
     */
    @RequestMapping("/deleteGroup.do")
    @ResponseBody
    public Map<String, Object> deleteGroup(@RequestBody Map<String, Object> param) {
        return ord02aService.deleteGroup(param);
    }

    /**
     * 그룹 일괄 삭제
     */
    @RequestMapping("/deleteGroupList.do")
    @ResponseBody
    public Map<String, Object> deleteGroupList(@RequestBody Map<String, Object> param) {
        return ord02aService.deleteGroupList(param);
    }

    /**
     * 멤버 삭제 (논리삭제)
     */
    @RequestMapping("/deleteMember.do")
    @ResponseBody
    public Map<String, Object> deleteMember(@RequestBody Map<String, Object> param) {
        return ord02aService.deleteMember(param);
    }

    /**
     * 멤버 일괄 삭제
     */
    @RequestMapping("/deleteMemberList.do")
    @ResponseBody
    public Map<String, Object> deleteMemberList(@RequestBody Map<String, Object> param) {
        return ord02aService.deleteMemberList(param);
    }

    /**
     * 엑셀 일괄 등록
     */
    @RequestMapping("/importExcel.do")
    @ResponseBody
    public Map<String, Object> importExcel(@RequestBody Map<String, Object> param) {
        return ord02aService.importExcel(param);
    }

    /**
     * 사원 검색 (팝업용)
     */
    @RequestMapping("/selectEmployeeList.do")
    @ResponseBody
    public Map<String, Object> selectEmployeeList(@RequestBody Map<String, Object> param) {
        return ord02aService.selectEmployeeList(param);
    }
}
```

### 3.2 Service Interface

```java
package com.wsc.ord.ord02a;

import java.util.Map;

/**
 * 메일그룹관리 서비스 인터페이스
 * @author 송우석
 */
public interface Ord02aService {

    Map<String, Object> selectGroupList(Map<String, Object> param);
    Map<String, Object> selectMemberList(Map<String, Object> param);
    Map<String, Object> saveGroup(Map<String, Object> param);
    Map<String, Object> saveGroupList(Map<String, Object> param);
    Map<String, Object> saveMember(Map<String, Object> param);
    Map<String, Object> saveMemberList(Map<String, Object> param);
    Map<String, Object> deleteGroup(Map<String, Object> param);
    Map<String, Object> deleteGroupList(Map<String, Object> param);
    Map<String, Object> deleteMember(Map<String, Object> param);
    Map<String, Object> deleteMemberList(Map<String, Object> param);
    Map<String, Object> importExcel(Map<String, Object> param);
    Map<String, Object> selectEmployeeList(Map<String, Object> param);
}
```

### 3.3 Service Implementation

```java
package com.wsc.ord.ord02a;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.framework.base.BaseService;

/**
 * 메일그룹관리 서비스 구현
 * @author 송우석
 */
@Service
public class Ord02aServiceImpl extends BaseService implements Ord02aService {

    @Autowired
    private Ord02aDao ord02aDao;

    @Override
    public Map<String, Object> selectGroupList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = ord02aDao.selectGroupList(param);
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
    public Map<String, Object> selectMemberList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = ord02aDao.selectMemberList(param);
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
    @Transactional
    public Map<String, Object> saveGroup(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            String mcode = (String) param.get("mcode");

            if (mcode == null || mcode.isEmpty()) {
                // 신규 등록 - 자동채번
                String newMcode = generateMcode(param);
                param.put("mcode", newMcode);
                ord02aDao.insertGroup(param);
                result.put("mcode", newMcode);
            } else {
                // 기존 데이터 확인
                Map<String, Object> existing = ord02aDao.selectGroup(param);
                if (existing != null) {
                    ord02aDao.updateGroup(param);
                } else {
                    ord02aDao.insertGroup(param);
                }
            }
            result.put("success", true);
            result.put("message", "저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> saveGroupList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("list");
            int cnt = 0;

            for (Map<String, Object> item : list) {
                item.put("pltCode", param.get("pltCode"));
                item.put("regEmp", param.get("regEmp"));
                item.put("mdfyEmp", param.get("mdfyEmp"));

                String mcode = (String) item.get("mcode");
                if (mcode == null || mcode.isEmpty()) {
                    String newMcode = generateMcode(item);
                    item.put("mcode", newMcode);
                    ord02aDao.insertGroup(item);
                } else {
                    Map<String, Object> existing = ord02aDao.selectGroup(item);
                    if (existing != null) {
                        ord02aDao.updateGroup(item);
                    } else {
                        ord02aDao.insertGroup(item);
                    }
                }
                cnt++;
            }

            result.put("success", true);
            result.put("message", cnt + "건이 저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> saveMember(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> existing = ord02aDao.selectMember(param);
            if (existing != null) {
                ord02aDao.updateMember(param);
            } else {
                ord02aDao.insertMember(param);
            }
            result.put("success", true);
            result.put("message", "저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> saveMemberList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("list");
            String mcode = (String) param.get("mcode");
            int cnt = 0;

            for (Map<String, Object> item : list) {
                item.put("pltCode", param.get("pltCode"));
                item.put("mcode", mcode);
                item.put("regEmp", param.get("regEmp"));
                item.put("mdfyEmp", param.get("mdfyEmp"));

                Map<String, Object> existing = ord02aDao.selectMember(item);
                if (existing != null) {
                    ord02aDao.updateMember(item);
                } else {
                    ord02aDao.insertMember(item);
                }
                cnt++;
            }

            result.put("success", true);
            result.put("message", cnt + "건이 저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> deleteGroup(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 그룹 삭제 시 멤버도 함께 삭제
            ord02aDao.deleteMemberByGroup(param);
            int cnt = ord02aDao.deleteGroup(param);
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
    public Map<String, Object> deleteGroupList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("list");
            int cnt = 0;
            for (Map<String, Object> item : list) {
                item.put("delEmp", param.get("delEmp"));
                ord02aDao.deleteMemberByGroup(item);
                cnt += ord02aDao.deleteGroup(item);
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
    public Map<String, Object> deleteMember(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = ord02aDao.deleteMember(param);
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
    public Map<String, Object> deleteMemberList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("list");
            int cnt = 0;
            for (Map<String, Object> item : list) {
                item.put("delEmp", param.get("delEmp"));
                cnt += ord02aDao.deleteMember(item);
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
    public Map<String, Object> importExcel(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("list");
            int successCnt = 0;
            int errorCnt = 0;
            StringBuilder errorMsg = new StringBuilder();

            for (Map<String, Object> item : list) {
                item.put("pltCode", param.get("pltCode"));
                item.put("regEmp", param.get("regEmp"));
                item.put("mdfyEmp", param.get("mdfyEmp"));

                String groupName = (String) item.get("groupName");
                String empCode = (String) item.get("empCode");

                // 그룹 조회
                Map<String, Object> groupParam = new HashMap<>();
                groupParam.put("pltCode", param.get("pltCode"));
                groupParam.put("groupName", groupName);
                groupParam.put("groupType", "A");
                Map<String, Object> group = ord02aDao.selectGroupByName(groupParam);

                if (group == null) {
                    errorCnt++;
                    errorMsg.append("[").append(groupName).append("] 그룹을 찾을 수 없습니다.\n");
                    continue;
                }

                // 사원 확인
                Map<String, Object> empParam = new HashMap<>();
                empParam.put("pltCode", param.get("pltCode"));
                empParam.put("empCode", empCode);
                Map<String, Object> emp = ord02aDao.selectEmployee(empParam);

                if (emp == null) {
                    errorCnt++;
                    errorMsg.append("[").append(empCode).append("] 사원을 찾을 수 없습니다.\n");
                    continue;
                }

                // 멤버 저장
                item.put("mcode", group.get("mcode"));
                item.put("empName", emp.get("empName"));

                Map<String, Object> existing = ord02aDao.selectMember(item);
                if (existing != null) {
                    ord02aDao.updateMember(item);
                } else {
                    ord02aDao.insertMember(item);
                }
                successCnt++;
            }

            result.put("success", true);
            result.put("successCount", successCnt);
            result.put("errorCount", errorCnt);
            result.put("message", "성공: " + successCnt + "건, 실패: " + errorCnt + "건");
            if (errorMsg.length() > 0) {
                result.put("errorDetail", errorMsg.toString());
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> selectEmployeeList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = ord02aDao.selectEmployeeList(param);
            result.put("success", true);
            result.put("data", list);
            result.put("total", list.size());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * MCODE 자동채번
     * 형식: EG + 일련번호(4자리)
     */
    private String generateMcode(Map<String, Object> param) {
        String lastMcode = ord02aDao.selectLastMcode(param);
        int seq = 1;
        if (lastMcode != null && lastMcode.startsWith("EG")) {
            String seqStr = lastMcode.substring(2);
            seq = Integer.parseInt(seqStr) + 1;
        }
        return "EG" + String.format("%04d", seq);
    }
}
```

### 3.4 DAO Interface

```java
package com.wsc.ord.ord02a;

import java.util.List;
import java.util.Map;

/**
 * 메일그룹관리 DAO 인터페이스
 * @author 송우석
 */
public interface Ord02aDao {

    // 그룹 관련
    List<Map<String, Object>> selectGroupList(Map<String, Object> param);
    Map<String, Object> selectGroup(Map<String, Object> param);
    Map<String, Object> selectGroupByName(Map<String, Object> param);
    int insertGroup(Map<String, Object> param);
    int updateGroup(Map<String, Object> param);
    int deleteGroup(Map<String, Object> param);
    String selectLastMcode(Map<String, Object> param);

    // 멤버 관련
    List<Map<String, Object>> selectMemberList(Map<String, Object> param);
    Map<String, Object> selectMember(Map<String, Object> param);
    int insertMember(Map<String, Object> param);
    int updateMember(Map<String, Object> param);
    int deleteMember(Map<String, Object> param);
    int deleteMemberByGroup(Map<String, Object> param);

    // 사원 관련
    List<Map<String, Object>> selectEmployeeList(Map<String, Object> param);
    Map<String, Object> selectEmployee(Map<String, Object> param);
}
```

### 3.5 DAO Implementation

```java
package com.wsc.ord.ord02a;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.wsc.framework.base.BaseDao;

/**
 * 메일그룹관리 DAO 구현
 * @author 송우석
 */
@Repository
public class Ord02aDaoImpl extends BaseDao implements Ord02aDao {

    private static final String NAMESPACE = "com.wsc.ord.ord02a.Ord02aDao";

    @Override
    public List<Map<String, Object>> selectGroupList(Map<String, Object> param) {
        return getSqlSession().selectList(NAMESPACE + ".selectGroupList", param);
    }

    @Override
    public Map<String, Object> selectGroup(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectGroup", param);
    }

    @Override
    public Map<String, Object> selectGroupByName(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectGroupByName", param);
    }

    @Override
    public int insertGroup(Map<String, Object> param) {
        return getSqlSession().insert(NAMESPACE + ".insertGroup", param);
    }

    @Override
    public int updateGroup(Map<String, Object> param) {
        return getSqlSession().update(NAMESPACE + ".updateGroup", param);
    }

    @Override
    public int deleteGroup(Map<String, Object> param) {
        return getSqlSession().update(NAMESPACE + ".deleteGroup", param);
    }

    @Override
    public String selectLastMcode(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectLastMcode", param);
    }

    @Override
    public List<Map<String, Object>> selectMemberList(Map<String, Object> param) {
        return getSqlSession().selectList(NAMESPACE + ".selectMemberList", param);
    }

    @Override
    public Map<String, Object> selectMember(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectMember", param);
    }

    @Override
    public int insertMember(Map<String, Object> param) {
        return getSqlSession().insert(NAMESPACE + ".insertMember", param);
    }

    @Override
    public int updateMember(Map<String, Object> param) {
        return getSqlSession().update(NAMESPACE + ".updateMember", param);
    }

    @Override
    public int deleteMember(Map<String, Object> param) {
        return getSqlSession().update(NAMESPACE + ".deleteMember", param);
    }

    @Override
    public int deleteMemberByGroup(Map<String, Object> param) {
        return getSqlSession().update(NAMESPACE + ".deleteMemberByGroup", param);
    }

    @Override
    public List<Map<String, Object>> selectEmployeeList(Map<String, Object> param) {
        return getSqlSession().selectList(NAMESPACE + ".selectEmployeeList", param);
    }

    @Override
    public Map<String, Object> selectEmployee(Map<String, Object> param) {
        return getSqlSession().selectOne(NAMESPACE + ".selectEmployee", param);
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
    메일그룹관리 Mapper
    @author 송우석
-->
<mapper namespace="com.wsc.ord.ord02a.Ord02aDao">

    <!-- 그룹 목록 조회 -->
    <select id="selectGroupList" parameterType="map" resultType="map">
        SELECT A.PLT_CODE   AS pltCode
             , A.MCODE      AS mcode
             , A.GROUP_TYPE AS groupType
             , A.GROUP_NAME AS groupName
             , A.USE_FLAG   AS useFlag
             , A.SCOMMENT   AS scomment
             , A.REG_DATE   AS regDate
             , A.REG_EMP    AS regEmp
             , A.MDFY_DATE  AS mdfyDate
             , A.MDFY_EMP   AS mdfyEmp
          FROM TORD_EMAIL_GROUP A
         WHERE A.PLT_CODE = #{pltCode}
           AND A.DATA_FLAG = 0
        <if test="groupType != null and groupType != ''">
           AND A.GROUP_TYPE = #{groupType}
        </if>
        <if test="groupLike != null and groupLike != ''">
           AND A.GROUP_NAME LIKE CONCAT('%', #{groupLike}, '%')
        </if>
         ORDER BY A.MCODE
    </select>

    <!-- 그룹 단건 조회 -->
    <select id="selectGroup" parameterType="map" resultType="map">
        SELECT PLT_CODE   AS pltCode
             , MCODE      AS mcode
             , GROUP_TYPE AS groupType
             , GROUP_NAME AS groupName
             , USE_FLAG   AS useFlag
             , DATA_FLAG  AS dataFlag
          FROM TORD_EMAIL_GROUP
         WHERE PLT_CODE = #{pltCode}
           AND MCODE = #{mcode}
    </select>

    <!-- 그룹명으로 조회 -->
    <select id="selectGroupByName" parameterType="map" resultType="map">
        SELECT MCODE AS mcode
             , GROUP_NAME AS groupName
          FROM TORD_EMAIL_GROUP
         WHERE PLT_CODE = #{pltCode}
           AND GROUP_NAME = #{groupName}
           AND GROUP_TYPE = #{groupType}
           AND DATA_FLAG = 0
    </select>

    <!-- 그룹 등록 -->
    <insert id="insertGroup" parameterType="map">
        INSERT INTO TORD_EMAIL_GROUP (
            PLT_CODE, MCODE, GROUP_TYPE, GROUP_NAME
          , USE_FLAG, SCOMMENT, REG_DATE, REG_EMP, DATA_FLAG
        ) VALUES (
            #{pltCode}, #{mcode}, IFNULL(#{groupType}, 'A'), #{groupName}
          , IFNULL(#{useFlag}, '1'), #{scomment}, NOW(), #{regEmp}, 0
        )
    </insert>

    <!-- 그룹 수정 -->
    <update id="updateGroup" parameterType="map">
        UPDATE TORD_EMAIL_GROUP
           SET GROUP_NAME = #{groupName}
             , USE_FLAG   = #{useFlag}
             , SCOMMENT   = #{scomment}
             , MDFY_DATE  = NOW()
             , MDFY_EMP   = #{mdfyEmp}
             , DATA_FLAG  = 0
             , DEL_DATE   = NULL
             , DEL_EMP    = NULL
         WHERE PLT_CODE = #{pltCode}
           AND MCODE = #{mcode}
    </update>

    <!-- 그룹 삭제 (논리삭제) -->
    <update id="deleteGroup" parameterType="map">
        UPDATE TORD_EMAIL_GROUP
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND MCODE = #{mcode}
    </update>

    <!-- 마지막 MCODE 조회 -->
    <select id="selectLastMcode" parameterType="map" resultType="string">
        SELECT MAX(MCODE)
          FROM TORD_EMAIL_GROUP
         WHERE PLT_CODE = #{pltCode}
           AND MCODE LIKE 'EG%'
    </select>

    <!-- 멤버 목록 조회 -->
    <select id="selectMemberList" parameterType="map" resultType="map">
        SELECT A.PLT_CODE AS pltCode
             , A.MCODE    AS mcode
             , A.EMP_CODE AS empCode
             , A.EMP_NAME AS empName
             , A.EMAIL    AS email
             , E.EMP_NAME AS empNameRef
             , O.ORG_NAME AS orgName
             , A.REG_DATE AS regDate
             , A.REG_EMP  AS regEmp
             , A.MDFY_DATE AS mdfyDate
             , A.MDFY_EMP AS mdfyEmp
          FROM TORD_EMAIL_GROUP_EMP A
          LEFT JOIN TSTD_EMPLOYEE E ON A.PLT_CODE = E.PLT_CODE AND A.EMP_CODE = E.EMP_CODE
          LEFT JOIN TSTD_ORG O ON E.PLT_CODE = O.PLT_CODE AND E.ORG_CODE = O.ORG_CODE
         WHERE A.PLT_CODE = #{pltCode}
           AND A.MCODE = #{mcode}
           AND A.DATA_FLAG = 0
         ORDER BY A.EMP_CODE
    </select>

    <!-- 멤버 단건 조회 -->
    <select id="selectMember" parameterType="map" resultType="map">
        SELECT PLT_CODE  AS pltCode
             , MCODE     AS mcode
             , EMP_CODE  AS empCode
             , DATA_FLAG AS dataFlag
          FROM TORD_EMAIL_GROUP_EMP
         WHERE PLT_CODE = #{pltCode}
           AND MCODE = #{mcode}
           AND EMP_CODE = #{empCode}
    </select>

    <!-- 멤버 등록 -->
    <insert id="insertMember" parameterType="map">
        INSERT INTO TORD_EMAIL_GROUP_EMP (
            PLT_CODE, MCODE, EMP_CODE, EMP_NAME
          , EMAIL, REG_DATE, REG_EMP, DATA_FLAG
        ) VALUES (
            #{pltCode}, #{mcode}, #{empCode}, #{empName}
          , #{email}, NOW(), #{regEmp}, 0
        )
    </insert>

    <!-- 멤버 수정 -->
    <update id="updateMember" parameterType="map">
        UPDATE TORD_EMAIL_GROUP_EMP
           SET EMP_NAME  = #{empName}
             , EMAIL     = #{email}
             , MDFY_DATE = NOW()
             , MDFY_EMP  = #{mdfyEmp}
             , DATA_FLAG = 0
             , DEL_DATE  = NULL
             , DEL_EMP   = NULL
         WHERE PLT_CODE = #{pltCode}
           AND MCODE = #{mcode}
           AND EMP_CODE = #{empCode}
    </update>

    <!-- 멤버 삭제 (논리삭제) -->
    <update id="deleteMember" parameterType="map">
        UPDATE TORD_EMAIL_GROUP_EMP
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND MCODE = #{mcode}
           AND EMP_CODE = #{empCode}
    </update>

    <!-- 그룹의 전체 멤버 삭제 -->
    <update id="deleteMemberByGroup" parameterType="map">
        UPDATE TORD_EMAIL_GROUP_EMP
           SET DEL_DATE  = NOW()
             , DEL_EMP   = #{delEmp}
             , DATA_FLAG = 2
         WHERE PLT_CODE = #{pltCode}
           AND MCODE = #{mcode}
           AND DATA_FLAG = 0
    </update>

    <!-- 사원 목록 조회 -->
    <select id="selectEmployeeList" parameterType="map" resultType="map">
        SELECT E.PLT_CODE AS pltCode
             , E.EMP_CODE AS empCode
             , E.EMP_NAME AS empName
             , E.EMAIL    AS email
             , E.ORG_CODE AS orgCode
             , O.ORG_NAME AS orgName
          FROM TSTD_EMPLOYEE E
          LEFT JOIN TSTD_ORG O ON E.PLT_CODE = O.PLT_CODE AND E.ORG_CODE = O.ORG_CODE
         WHERE E.PLT_CODE = #{pltCode}
           AND E.DATA_FLAG = 0
           AND (E.FIRE_FLAG IS NULL OR E.FIRE_FLAG != '1')
        <if test="empLike != null and empLike != ''">
           AND (E.EMP_CODE LIKE CONCAT('%', #{empLike}, '%')
                OR E.EMP_NAME LIKE CONCAT('%', #{empLike}, '%'))
        </if>
        <if test="orgCode != null and orgCode != ''">
           AND E.ORG_CODE = #{orgCode}
        </if>
         ORDER BY E.EMP_SEQ, E.EMP_CODE
    </select>

    <!-- 사원 단건 조회 -->
    <select id="selectEmployee" parameterType="map" resultType="map">
        SELECT EMP_CODE AS empCode
             , EMP_NAME AS empName
             , EMAIL    AS email
          FROM TSTD_EMPLOYEE
         WHERE PLT_CODE = #{pltCode}
           AND EMP_CODE = #{empCode}
           AND DATA_FLAG = 0
    </select>

</mapper>
```

---

## 5. 화면 설계

### 5.1 메인 화면 레이아웃 (ord02a.jsp)

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│ [도구모음] 조회 | 도움말                                                             │
├───────────────────────────────────┬─────────────────────────────────────────────────┤
│ ┌─ 수신자 그룹 ─────────────────┐ │ ┌─ 그룹별 세부 내역 ─────────────────────────┐ │
│ │ [추가] [저장]                  │ │ │ [엑셀업로드] [사원추가] [저장]             │ │
│ │┌────┬──────────┬──────┬──────┐│ │ │┌────┬──────┬──────┬──────┬─────────────────┐│ │
│ ││선택│그룹명    │생성일│사용  ││ │ ││선택│사원코드│사원명│부서명│이메일          ││ │
│ │├────┼──────────┼──────┼──────┤│ │ │├────┼──────┼──────┼──────┼─────────────────┤│ │
│ ││ □  │생산관리팀│25-02-04│사용 ││ │ ││ □  │E001  │김철수│생산1팀│kim@company.com ││ │
│ ││ ○  │품질관리팀│25-02-03│사용 ││ │ ││ □  │E002  │이영희│생산1팀│lee@company.com ││ │
│ ││ □  │설비관리팀│25-02-02│사용 ││ │ ││ □  │E003  │박민수│생산2팀│park@company.com││ │
│ │├────┼──────────┼──────┼──────┤│ │ │├────┼──────┼──────┼──────┼─────────────────┤│ │
│ ││    │          │      │      ││ │ ││...                                        ││ │
│ │└────┴──────────┴──────┴──────┘│ │ │└────┴──────┴──────┴──────┴─────────────────┘│ │
│ │ [우클릭: 삭제]                 │ │ │ [우클릭: 삭제]                              │ │
│ └────────────────────────────────┘ │ └──────────────────────────────────────────────┘ │
└───────────────────────────────────┴─────────────────────────────────────────────────┘
```

### 5.2 엑셀 업로드 팝업 레이아웃 (ord02a_d0a.jsp)

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│ 엑셀 업로드                                                                    [X]  │
├─────────────────────────────────────────────────────────────────────────────────────┤
│ [파일 열기] [반영]                                                                   │
├─────────────────────────┬───────────────────────────────────────────────────────────┤
│ ┌─ Excel 열 설정 ────┐  │ ┌─ 미리보기 ─────────────────────────────────────────────┐ │
│ │ 시작행:   [  2   ]  │  │ │┌────┬────┬────────┬──────┬──────┬─────────────────────┐│ │
│ │ 그룹명:   [  A   ]  │  │ ││선택│덮어│그룹명  │사원명│사원코드│이메일             ││ │
│ │ 사원명:   [  B   ]  │  │ │├────┼────┼────────┼──────┼──────┼─────────────────────┤│ │
│ │ 사원코드: [  C   ]  │  │ ││ □  │ □  │생산관리팀│김철수│E001  │kim@company.com   ││ │
│ │ 이메일:   [  D   ]  │  │ ││ □  │ □  │생산관리팀│이영희│E002  │lee@company.com   ││ │
│ │                     │  │ ││ □  │ □  │품질관리팀│박민수│E003  │park@company.com  ││ │
│ │                     │  │ │└────┴────┴────────┴──────┴──────┴─────────────────────┘│ │
│ └─────────────────────┘  │ └──────────────────────────────────────────────────────────┘ │
└─────────────────────────┴───────────────────────────────────────────────────────────┘
```

---

## 6. 테이블 DDL

```sql
-- 메일그룹 마스터
CREATE TABLE IF NOT EXISTS TORD_EMAIL_GROUP (
    PLT_CODE   VARCHAR(10)  NOT NULL COMMENT '공장코드',
    MCODE      VARCHAR(20)  NOT NULL COMMENT '그룹코드',
    GROUP_TYPE VARCHAR(10)  DEFAULT 'A' COMMENT '그룹타입 (A=자동메일그룹)',
    GROUP_NAME VARCHAR(100) NULL     COMMENT '그룹명',
    USE_FLAG   VARCHAR(1)   DEFAULT '1' COMMENT '사용여부 (0=미사용, 1=사용)',
    SCOMMENT   VARCHAR(500) NULL     COMMENT '비고',
    REG_DATE   DATETIME     NULL     COMMENT '등록일시',
    REG_EMP    VARCHAR(20)  NULL     COMMENT '등록자',
    MDFY_DATE  DATETIME     NULL     COMMENT '수정일시',
    MDFY_EMP   VARCHAR(20)  NULL     COMMENT '수정자',
    DEL_DATE   DATETIME     NULL     COMMENT '삭제일시',
    DEL_EMP    VARCHAR(20)  NULL     COMMENT '삭제자',
    DEL_REASON VARCHAR(500) NULL     COMMENT '삭제사유',
    DATA_FLAG  TINYINT      DEFAULT 0 COMMENT '데이터상태 (0=정상, 2=삭제)',
    PRIMARY KEY (PLT_CODE, MCODE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메일그룹 마스터';

-- 메일그룹 멤버
CREATE TABLE IF NOT EXISTS TORD_EMAIL_GROUP_EMP (
    PLT_CODE   VARCHAR(10)  NOT NULL COMMENT '공장코드',
    MCODE      VARCHAR(20)  NOT NULL COMMENT '그룹코드',
    EMP_CODE   VARCHAR(20)  NOT NULL COMMENT '사원코드',
    EMP_NAME   VARCHAR(50)  NULL     COMMENT '사원명',
    EMAIL      VARCHAR(100) NULL     COMMENT '이메일',
    REG_DATE   DATETIME     NULL     COMMENT '등록일시',
    REG_EMP    VARCHAR(20)  NULL     COMMENT '등록자',
    MDFY_DATE  DATETIME     NULL     COMMENT '수정일시',
    MDFY_EMP   VARCHAR(20)  NULL     COMMENT '수정자',
    DEL_DATE   DATETIME     NULL     COMMENT '삭제일시',
    DEL_EMP    VARCHAR(20)  NULL     COMMENT '삭제자',
    DEL_REASON VARCHAR(500) NULL     COMMENT '삭제사유',
    DATA_FLAG  TINYINT      DEFAULT 0 COMMENT '데이터상태 (0=정상, 2=삭제)',
    PRIMARY KEY (PLT_CODE, MCODE, EMP_CODE),
    CONSTRAINT FK_EMAIL_GROUP_EMP_GROUP FOREIGN KEY (PLT_CODE, MCODE)
        REFERENCES TORD_EMAIL_GROUP (PLT_CODE, MCODE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메일그룹 멤버';

-- 인덱스
CREATE INDEX IDX_TORD_EMAIL_GROUP_01 ON TORD_EMAIL_GROUP (PLT_CODE, GROUP_TYPE, DATA_FLAG);
CREATE INDEX IDX_TORD_EMAIL_GROUP_EMP_01 ON TORD_EMAIL_GROUP_EMP (PLT_CODE, EMP_CODE);
```

---

## 7. 체크리스트

### 7.1 개발 체크리스트

| 단계   | 항목                             | 상태 |
|--------|----------------------------------|------|
| 설계   | DB 테이블 생성                   | [ ]  |
| 설계   | 패키지/클래스 구조 생성           | [ ]  |
| 백엔드 | Controller 구현                  | [ ]  |
| 백엔드 | Service/DAO 구현                 | [ ]  |
| 백엔드 | MyBatis Mapper 구현              | [ ]  |
| 프론트 | 메인 JSP (좌우 분할) 구현         | [ ]  |
| 프론트 | 엑셀 업로드 팝업 JSP 구현         | [ ]  |
| 프론트 | 메인 JS (그룹/멤버 CRUD) 구현    | [ ]  |
| 프론트 | 엑셀 업로드 팝업 JS 구현         | [ ]  |
| 프론트 | 사원 검색 팝업 연동              | [ ]  |
| 테스트 | 그룹 CRUD 테스트                 | [ ]  |
| 테스트 | 멤버 CRUD 테스트                 | [ ]  |
| 테스트 | 엑셀 업로드 테스트               | [ ]  |

### 7.2 테스트 케이스

| TC ID    | 테스트 항목              | 예상 결과                          |
|----------|--------------------------|-----------------------------------|
| TC-001   | 그룹 목록 조회           | 전체 그룹 표시                    |
| TC-002   | 그룹 추가 및 저장        | MCODE 자동채번, 정상 저장         |
| TC-003   | 그룹 수정                | 그룹명, 사용여부 수정             |
| TC-004   | 그룹 삭제                | 논리삭제 + 멤버 연동 삭제         |
| TC-005   | 그룹 선택 시 멤버 조회   | 해당 그룹 멤버만 표시             |
| TC-006   | 사원 추가 팝업           | 사원 검색 후 멤버 추가            |
| TC-007   | 멤버 이메일 수정         | 직접 입력 후 저장                 |
| TC-008   | 멤버 삭제                | 선택 멤버 논리삭제                |
| TC-009   | 엑셀 업로드 - 정상       | 미리보기 후 반영                  |
| TC-010   | 엑셀 업로드 - 그룹 미존재 | 에러 메시지 표시                  |
| TC-011   | 엑셀 업로드 - 사원 미존재 | 에러 메시지 표시                  |

---

## 8. 참고 사항

### 8.1 MCODE 채번 규칙

```
형식: EG + 일련번호(4자리)
예시: EG0001, EG0002, ...
```

### 8.2 에러 처리

| 상황                    | 에러 메시지                          |
|-------------------------|-------------------------------------|
| 그룹 미존재 (엑셀)      | "[그룹명]의 그룹을 찾을 수 없습니다." |
| 사원 미존재 (엑셀)      | "[사원코드]의 사원을 찾을 수 없습니다." |

### 8.3 엑셀 업로드 형식

| 열   | 내용     |
|------|----------|
| A    | 그룹명   |
| B    | 사원명   |
| C    | 사원코드 |
| D    | 이메일   |
