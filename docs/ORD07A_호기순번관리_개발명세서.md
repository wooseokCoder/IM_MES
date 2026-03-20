# 호기순번관리 (ORD07A) 상세 개발 명세서

> **작성자**: 송우석
> **작성일**: 2026-02-04
> **화면 ID**: ORD07A
> **예상 공수**: 9 Man-Hours (AI 협업 기준)

---

## 1. 개요

### 1.1 화면 정보

| 항목           | 내용                                              |
|----------------|---------------------------------------------------|
| 화면 ID        | ORD07A                                            |
| 화면명         | 호기순번관리                                      |
| 모듈           | ORD (수주/생산계획)                               |
| 기술 복잡도    | Low                                               |
| 주요 기능      | 호기순번(SR_NO) 조회/수정 (등록/삭제 없음)        |

### 1.2 AS-IS 소스 참조

| 구분           | 파일 경로                                          |
|----------------|----------------------------------------------------|
| 메인 화면      | `C:\proActive\DecompiledSrc\ORD\ORD\ORD07A_M0A.cs` |
| 팝업           | `C:\proActive\DecompiledSrc\ORD\ORD\ORD07A_D0A.cs` |
| 비즈니스 로직  | `C:\proActive\DecompiledSrc\CUBIZ_BR\BORD\ORD07A.cs` |
| 데이터 접근    | `C:\proActive\DecompiledSrc\CUBIZ_DA\DSYS\TSYS_SERIAL.cs` |

---

## 2. 데이터베이스 설계

### 2.1 핵심 테이블

#### TSYS_SERIAL (시리얼번호 마스터)

| 컬럼명       | 데이터 타입  | PK | NULL | 설명                                |
|--------------|-------------|:--:|:----:|-------------------------------------|
| PLT_CODE     | VARCHAR(10) | O  | N    | 공장코드                            |
| SR_CODE      | VARCHAR(20) | O  | N    | 시리얼코드 (형)                     |
| SR_KEY       | VARCHAR(10) | O  | N    | 시리얼키 (기도/연도)                |
| SR_NO        | VARCHAR(20) |    | Y    | 시리얼번호 (순번) - **수정 대상**   |
| IS_HOGI      | VARCHAR(1)  |    | Y    | 호기여부 ('1'=호기)                 |

### 2.2 참조 테이블

#### TORD_PRODUCT (생산제품 마스터)

- `PROD_HOGI` 컬럼에서 호기순번 참조
- 17개 이상의 화면에서 PROD_HOGI 사용

---

## 3. 파일 구조

### 3.1 TO-BE 파일 목록

```
src/main/java/com/wsc/ord/ord07a/
├── Ord07aController.java
├── Ord07aService.java
├── Ord07aServiceImpl.java
├── Ord07aDao.java
└── Ord07aDaoImpl.java

src/main/resources/mappers/com/wsc/ord/ord07a/
└── Ord07a.xml

src/main/webapp/WEB-INF/views/ord/ord07a/
├── ord07a.jsp
└── ord07a_d0a.jsp

src/main/webapp/resources/js/ord/ord07a/
├── ord07a.js
└── ord07a_d0a.js
```

### 3.2 URL 매핑

| URL                          | 메서드 | 설명              |
|------------------------------|--------|-------------------|
| /ord/ord07a/ord07a.do        | GET    | 메인 화면         |
| /ord/ord07a/ord07a_d0a.do    | GET    | 수정 팝업         |
| /ord/ord07a/selectList.do    | POST   | 목록 조회         |
| /ord/ord07a/update.do        | POST   | 순번 수정         |

---

## 4. Java 클래스 설계

### 4.1 Controller

```java
/**
 * 호기순번관리 컨트롤러
 * @author 송우석
 */
@Controller
@RequestMapping("/ord/ord07a")
public class Ord07aController extends BaseController {

    @Autowired
    private Ord07aService ord07aService;

    /**
     * 메인 화면
     */
    @RequestMapping("/ord07a.do")
    public String view(HttpServletRequest request, Model model) {
        return "ord/ord07a/ord07a";
    }

    /**
     * 수정 팝업
     */
    @RequestMapping("/ord07a_d0a.do")
    public String popup(HttpServletRequest request, Model model) {
        return "ord/ord07a/ord07a_d0a";
    }

    /**
     * 호기순번 목록 조회
     */
    @RequestMapping("/selectList.do")
    @ResponseBody
    public Map<String, Object> selectList(@RequestBody Map<String, Object> param) {
        return ord07aService.selectList(param);
    }

    /**
     * 호기순번 수정
     */
    @RequestMapping("/update.do")
    @ResponseBody
    public Map<String, Object> update(@RequestBody Map<String, Object> param) {
        return ord07aService.update(param);
    }
}
```

### 4.2 Service Interface

```java
/**
 * 호기순번관리 서비스 인터페이스
 * @author 송우석
 */
public interface Ord07aService {

    /**
     * 호기순번 목록 조회
     * @param param PLT_CODE, MODEL_LIKE
     * @return 호기순번 목록
     */
    Map<String, Object> selectList(Map<String, Object> param);

    /**
     * 호기순번 수정
     * @param param PLT_CODE, SR_CODE, SR_KEY, SR_NO
     * @return 수정 결과
     */
    Map<String, Object> update(Map<String, Object> param);
}
```

### 4.3 Service Implementation

```java
/**
 * 호기순번관리 서비스 구현체
 * @author 송우석
 */
@Service
public class Ord07aServiceImpl extends BaseService implements Ord07aService {

    @Autowired
    private Ord07aDao ord07aDao;

    @Override
    public Map<String, Object> selectList(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();

        // IS_HOGI = '1' 고정 설정
        param.put("IS_HOGI", "1");

        List<Map<String, Object>> list = ord07aDao.selectList(param);
        result.put("rows", list);
        result.put("total", list.size());

        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> update(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();

        int cnt = ord07aDao.update(param);
        result.put("success", cnt > 0);
        result.put("message", cnt > 0 ? "수정되었습니다." : "수정에 실패했습니다.");

        return result;
    }
}
```

### 4.4 DAO Interface

```java
/**
 * 호기순번관리 DAO 인터페이스
 * @author 송우석
 */
public interface Ord07aDao {

    /**
     * 호기순번 목록 조회
     */
    List<Map<String, Object>> selectList(Map<String, Object> param);

    /**
     * 호기순번 수정
     */
    int update(Map<String, Object> param);
}
```

### 4.5 DAO Implementation

```java
/**
 * 호기순번관리 DAO 구현체
 * @author 송우석
 */
@Repository
public class Ord07aDaoImpl extends BaseDao implements Ord07aDao {

    @Override
    public List<Map<String, Object>> selectList(Map<String, Object> param) {
        return getSqlSession().selectList("Ord07aDao.selectList", param);
    }

    @Override
    public int update(Map<String, Object> param) {
        return getSqlSession().update("Ord07aDao.update", param);
    }
}
```

---

## 5. MyBatis Mapper

### 5.1 Ord07a.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="Ord07aDao">

    <!-- 호기순번 목록 조회 -->
    <select id="selectList" parameterType="map" resultType="map">
        SELECT
            PLT_CODE   AS pltCode,
            SR_CODE    AS srCode,
            SR_KEY     AS srKey,
            SR_NO      AS srNo
        FROM TSYS_SERIAL
        WHERE PLT_CODE = #{pltCode}
          AND IS_HOGI = #{IS_HOGI}
        <if test="modelLike != null and modelLike != ''">
          AND SR_CODE LIKE CONCAT('%', #{modelLike}, '%')
        </if>
        ORDER BY SR_KEY DESC, SR_CODE
    </select>

    <!-- 호기순번 수정 -->
    <update id="update" parameterType="map">
        UPDATE TSYS_SERIAL
        SET SR_NO = #{srNo}
        WHERE PLT_CODE = #{pltCode}
          AND SR_CODE = #{srCode}
          AND SR_KEY = #{srKey}
    </update>

</mapper>
```

---

## 6. 화면 설계

### 6.1 메인 화면 (ord07a.jsp)

```
┌─────────────────────────────────────────────────────────────┐
│ 호기순번관리                                        [조회]  │
├─────────────────────────────────────────────────────────────┤
│ 검색조건                                                    │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ 형: [________________]                                  │ │
│ └─────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ 기도(SR_KEY) │ 형(SR_CODE)    │ 번호(SR_NO)             │ │
│ ├──────────────┼────────────────┼─────────────────────────┤ │
│ │ 2025         │ MT5 51         │ 1234                    │ │
│ │ 2025         │ MT5 55         │ 5678                    │ │ ← 셀 병합
│ │ 2024         │ XR3 30         │ 9999                    │ │
│ └─────────────────────────────────────────────────────────┘ │
│ * 더블클릭 또는 우클릭 → 수정 팝업                          │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 그리드 컬럼

| 필드명   | 표시명 | 정렬   | 너비 | 병합 | 비고            |
|----------|--------|--------|------|------|-----------------|
| srKey    | 기도   | center | 100  | O    | 동일값 셀 병합  |
| srCode   | 형     | center | 150  |      |                 |
| srNo     | 번호   | center | 120  |      |                 |

### 6.3 수정 팝업 (ord07a_d0a.jsp)

```
┌─────────────────────────────────────────┐
│ 호기 순번 수정                    [저장]│
├─────────────────────────────────────────┤
│                                         │
│  기도: [2025        ] (읽기전용)        │
│                                         │
│  형:   [MT5 51      ] (읽기전용)        │
│                                         │
│  번호: [1234        ] (수정 가능)       │
│                                         │
└─────────────────────────────────────────┘
```

---

## 7. JavaScript 설계

### 7.1 메인 JS (ord07a.js)

```javascript
/**
 * 호기순번관리 메인 화면
 * @author 송우석
 */
var Ord07a = {
    grid: null,

    /**
     * 초기화
     */
    init: function() {
        this.initGrid();
        this.bindEvent();
    },

    /**
     * 그리드 초기화
     */
    initGrid: function() {
        $('#grid').datagrid({
            url: CTX_PATH + '/ord/ord07a/selectList.do',
            method: 'post',
            columns: [[
                {field: 'srKey',  title: '기도', width: 100, align: 'center'},
                {field: 'srCode', title: '형',   width: 150, align: 'center'},
                {field: 'srNo',   title: '번호', width: 120, align: 'center'}
            ]],
            singleSelect: true,
            onDblClickRow: function(index, row) {
                Ord07a.openPopup(row);
            }
        });
    },

    /**
     * 이벤트 바인딩
     */
    bindEvent: function() {
        // 조회 버튼
        $('#btnSearch').click(function() {
            Ord07a.search();
        });

        // 검색조건 Enter 키
        $('#modelLike').keypress(function(e) {
            if (e.which === 13) {
                Ord07a.search();
            }
        });
    },

    /**
     * 조회
     */
    search: function() {
        var param = {
            pltCode: SESSION.PLT_CODE,
            modelLike: $('#modelLike').val()
        };
        $('#grid').datagrid('load', param);
    },

    /**
     * 수정 팝업 열기
     */
    openPopup: function(row) {
        $('#popup').dialog({
            title: '호기 순번 수정',
            href: CTX_PATH + '/ord/ord07a/ord07a_d0a.do',
            width: 400,
            height: 200,
            modal: true,
            onLoad: function() {
                Ord07aD0a.init(row);
            }
        });
    },

    /**
     * 그리드 갱신 (팝업에서 호출)
     */
    refresh: function() {
        this.search();
    }
};

$(function() {
    Ord07a.init();
});
```

### 7.2 팝업 JS (ord07a_d0a.js)

```javascript
/**
 * 호기순번 수정 팝업
 * @author 송우석
 */
var Ord07aD0a = {
    rowData: null,

    /**
     * 초기화
     */
    init: function(row) {
        this.rowData = row;
        this.setData(row);
        this.bindEvent();
    },

    /**
     * 데이터 설정
     */
    setData: function(row) {
        $('#srKey').val(row.srKey);
        $('#srCode').val(row.srCode);
        $('#srNo').val(row.srNo);
    },

    /**
     * 이벤트 바인딩
     */
    bindEvent: function() {
        $('#btnSave').click(function() {
            Ord07aD0a.save();
        });
    },

    /**
     * 저장
     */
    save: function() {
        var srNo = $('#srNo').val();
        if (!srNo) {
            $.messager.alert('알림', '번호를 입력하세요.', 'warning');
            return;
        }

        var param = {
            pltCode: SESSION.PLT_CODE,
            srCode: this.rowData.srCode,
            srKey: this.rowData.srKey,
            srNo: srNo
        };

        $.ajax({
            url: CTX_PATH + '/ord/ord07a/update.do',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(param),
            success: function(result) {
                if (result.success) {
                    $.messager.alert('알림', result.message, 'info', function() {
                        $('#popup').dialog('close');
                        Ord07a.refresh();
                    });
                } else {
                    $.messager.alert('오류', result.message, 'error');
                }
            }
        });
    }
};
```

---

## 8. 체크리스트

### 8.1 개발 체크리스트

| 단계 | 항목                           | 완료 |
|------|--------------------------------|------|
| 1    | Java Controller 생성           | [ ]  |
| 2    | Java Service 생성              | [ ]  |
| 3    | Java DAO 생성                  | [ ]  |
| 4    | MyBatis Mapper XML 생성        | [ ]  |
| 5    | 메인 JSP 생성                  | [ ]  |
| 6    | 팝업 JSP 생성                  | [ ]  |
| 7    | 메인 JS 생성                   | [ ]  |
| 8    | 팝업 JS 생성                   | [ ]  |
| 9    | 단위 테스트                    | [ ]  |

### 8.2 테스트 케이스

| TC ID | 테스트 항목                    | 예상 결과                      |
|-------|--------------------------------|--------------------------------|
| TC-01 | 형 검색 후 조회                | 해당 형의 호기순번 목록 표시   |
| TC-02 | 그리드 행 더블클릭             | 수정 팝업 표시                 |
| TC-03 | 번호 수정 후 저장              | DB 업데이트 및 그리드 갱신     |
| TC-04 | 빈 번호로 저장 시도            | 유효성 검증 오류 메시지        |

---

## 9. 변경 이력

| 버전 | 날짜       | 작성자   | 변경 내용      |
|------|------------|----------|----------------|
| 1.0  | 2026-02-04 | 송우석   | 최초 작성      |
