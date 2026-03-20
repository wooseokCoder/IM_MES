# TO-BE MyBatis Mapper XML 가이드

> **Golden Sample**: `TSTD_IDLECODE.xml`, `TSTD_IDLECODE_QUERY.xml`
> **작성자**: 송우석

---

## 1. 파일 분리 규칙

> 하나의 테이블에 대해 **CRUD 매퍼**와 **QUERY 매퍼**를 분리한다.

| 파일명                     | Namespace                                   | 용도                    |
|----------------------------|---------------------------------------------|-------------------------|
| `{TABLE_NAME}.xml`         | `com.wsc.imes.{module}.{TABLE_NAME}`        | CRUD (SER/INS/UPD/UDE)  |
| `{TABLE_NAME}_QUERY.xml`   | `com.wsc.imes.{module}.{TABLE_NAME}_QUERY`  | 조회 전용 (JOIN 쿼리)   |

---

## 2. CRUD 매퍼 템플릿

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!--
============================================================================
파일명: {TABLE_NAME}.xml
설명: {테이블 설명} CRUD 매퍼 ({TABLE_NAME} 테이블)
원본: ProActive {TABLE_NAME}.cs
작성자: 송우석
작성일: {YYYY-MM-DD}
============================================================================
-->
<mapper namespace="com.wsc.imes.{module}.{TABLE_NAME}">

    <!-- 단건 조회 (SCODE) -->
    <select id="{TABLE_NAME}_SER" statementType="CALLABLE" parameterType="params" resultType="record">
        {CALL sp_imes_{table_name}_ser(
            #{gsPltCode, mode=IN, jdbcType=VARCHAR},
            #{scode, mode=IN, jdbcType=VARCHAR}
        )}
    </select>

    <!-- 등록 -->
    <insert id="{TABLE_NAME}_INS" statementType="CALLABLE" parameterType="params">
        {CALL sp_imes_{table_name}_ins(
            #{gsPltCode, mode=IN, jdbcType=VARCHAR},
            #{scode, mode=IN, jdbcType=VARCHAR},
            <!-- ... 컬럼 파라미터 ... -->
            #{gsUserId, mode=IN, jdbcType=VARCHAR}
        )}
    </insert>

    <!-- 수정 (전체 필드) -->
    <update id="{TABLE_NAME}_UPD" statementType="CALLABLE" parameterType="params">
        {CALL sp_imes_{table_name}_upd(
            #{gsPltCode, mode=IN, jdbcType=VARCHAR},
            #{scode, mode=IN, jdbcType=VARCHAR},
            <!-- ... 컬럼 파라미터 ... -->
            #{gsUserId, mode=IN, jdbcType=VARCHAR}
        )}
    </update>

    <!-- 수정 (일부 필드 - 그리드 일괄) -->
    <update id="{TABLE_NAME}_UPD2" statementType="CALLABLE" parameterType="params">
        {CALL sp_imes_{table_name}_upd2(
            #{gsPltCode, mode=IN, jdbcType=VARCHAR},
            #{scode, mode=IN, jdbcType=VARCHAR},
            <!-- ... 일부 컬럼 ... -->
            #{gsUserId, mode=IN, jdbcType=VARCHAR}
        )}
    </update>

    <!-- 삭제 (논리삭제: DATA_FLAG=2) -->
    <update id="{TABLE_NAME}_UDE" statementType="CALLABLE" parameterType="params">
        {CALL sp_imes_{table_name}_ude(
            #{gsPltCode, mode=IN, jdbcType=VARCHAR},
            #{scode, mode=IN, jdbcType=VARCHAR},
            #{gsUserId, mode=IN, jdbcType=VARCHAR}
        )}
    </update>

</mapper>
```

---

## 3. QUERY 매퍼 템플릿

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!--
============================================================================
파일명: {TABLE_NAME}_QUERY.xml
설명: {테이블 설명} 조회 매퍼 ({TABLE_NAME} 테이블)
원본: ProActive {TABLE_NAME}_QUERY.cs
작성자: 송우석
작성일: {YYYY-MM-DD}
============================================================================
-->
<mapper namespace="com.wsc.imes.{module}.{TABLE_NAME}_QUERY">

    <!-- 목록 조회 (메인 그리드) -->
    <select id="{TABLE_NAME}_QUERY1" statementType="CALLABLE" parameterType="params" resultType="record">
        {CALL sp_imes_{table_name}_query1(
            #{gsPltCode, mode=IN, jdbcType=VARCHAR},
            #{plants, mode=IN, jdbcType=VARCHAR},
            #{searchLike, mode=IN, jdbcType=VARCHAR},
            #{dataFlag, mode=IN, jdbcType=INTEGER}
        )}
    </select>

</mapper>
```

---

## 4. 명명 규칙

| 항목              | 규칙                                                          | 예시                              |
|-------------------|---------------------------------------------------------------|-----------------------------------|
| Namespace         | `com.wsc.imes.{module}.{TABLE_NAME}`                          | `com.wsc.imes.std.TSTD_IDLECODE`  |
| Statement ID      | `{TABLE_NAME}_{ACTION}` (AS-IS 원본 유지)                     | `TSTD_IDLECODE_SER`               |
| statementType     | 항상 `CALLABLE`                                               |                                   |
| parameterType     | `params` (ParamsMap 별칭)                                      |                                   |
| resultType        | `record` (RecordMap 별칭)                                      |                                   |
| 프로시저 이름     | `sp_imes_{table_name}_{action}`                                | `sp_imes_tstd_idlecode_ser`       |
| 파라미터 형식     | `#{name, mode=IN, jdbcType=TYPE}`                              |                                   |

---

## 5. 프로시저 ID 체계

| 접미사     | 용도                    | 예시                          |
|------------|-------------------------|-------------------------------|
| `_SER`     | 단건 조회 (PK)          | `TSTD_IDLECODE_SER`          |
| `_SER2`    | 조건부 조회 (콤보용 등) | `TSTD_IDLECODE_SER2`         |
| `_SER3`    | 대체 키 조회            | `TSTD_IDLECODE_SER3`         |
| `_INS`     | 등록                    | `TSTD_IDLECODE_INS`          |
| `_UPD`     | 수정 (전체 필드)        | `TSTD_IDLECODE_UPD`          |
| `_UPD2`    | 수정 (일부 필드)        | `TSTD_IDLECODE_UPD2`         |
| `_UDE`     | 삭제 (논리삭제)         | `TSTD_IDLECODE_UDE`          |
| `_QUERY1`  | 목록 조회 (JOIN)        | `TSTD_IDLECODE_QUERY1`       |

---

## 6. jdbcType 매핑

| Java 타입      | jdbcType       |
|----------------|----------------|
| String         | VARCHAR        |
| Integer, int   | INTEGER        |
| Long, long     | BIGINT         |
| Double, double | DOUBLE         |
| BigDecimal     | DECIMAL        |
| Date           | DATE           |
| Timestamp      | TIMESTAMP      |

---

## 7. WEB-INF/classes 동기화 규칙

> 매퍼 XML은 반드시 **두 곳에 동일하게** 배치한다.

```
src/main/resources/mappers/com/wsc/imes/{module}/{TABLE_NAME}.xml          ← 원본
src/main/webapp/WEB-INF/classes/mappers/com/wsc/imes/{module}/{TABLE_NAME}.xml  ← 복사본
```

---

## 8. 금지 사항

| 금지 항목              | 사유                          |
|------------------------|-------------------------------|
| 인라인 SQL 직접 작성   | 프로시저로 작성 필수          |
| 기존 별칭 변경         | 프론트엔드 연동 깨짐          |
| SELECT *               | 명시적 컬럼 나열 필수         |
| namespace 불일치       | DAO 매핑 오류 발생            |
