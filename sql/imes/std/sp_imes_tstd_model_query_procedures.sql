-- ============================================================
-- 파일명: sp_imes_tstd_model_query_procedures.sql
-- 테이블: TSTD_MODEL
-- 설명: 모델군 관리 조회 프로시저
-- 작성자: 송우석
-- 작성일: 2026-02-20
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_model_query1
-- 설명: 모델군 목록 조회 (DATA_TYPE, P_SCODE 조건)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_query1//

CREATE PROCEDURE sp_imes_tstd_model_query1(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_DATA_TYPE       VARCHAR(3),
    IN p_P_SCODE         VARCHAR(20),
    IN p_DATA_FLAG       TINYINT
)
BEGIN
    SELECT
        M.PLT_CODE       AS pltCode,
        M.SCODE           AS scode,
        M.P_SCODE         AS pScode,
        M.PROD_TYPE       AS prodType,
        M.DATA_TYPE       AS dataType,
        M.MODEL_TYPE      AS modelType,
        M.MODEL_SERISE    AS modelSerise,
        M.MODEL_NO        AS modelNo,
        M.MODEL_NO        AS model,
        M.MODEL_CODE      AS modelCode,
        M.USE_FLAG        AS useFlag,
        M.REG_EMP         AS regEmp,
        DATE_FORMAT(M.REG_DATE, '%Y-%m-%d %H:%i:%s')  AS regDate,
        M.DATA_FLAG       AS dataFlag,
        M.MDFY_EMP        AS mdfyEmp,
        DATE_FORMAT(M.MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate
    FROM TSTD_MODEL M
    WHERE M.PLT_CODE = p_PLT_CODE
      AND M.DATA_FLAG = p_DATA_FLAG
      AND (p_DATA_TYPE IS NULL OR p_DATA_TYPE = '' OR M.DATA_TYPE = p_DATA_TYPE)
      AND (p_P_SCODE IS NULL OR p_P_SCODE = '' OR M.P_SCODE = p_P_SCODE);
END//

-- ============================================================
-- sp_imes_tstd_model_query2
-- 설명: 트리1(2단계) - 모델번호 노드 조회 (STD47A 트리 데이터)
-- 원본: C# TSTD_MODEL_QUERY.TSTD_MODEL_QUERY2
-- 구조: P_CODE = MODEL_TYPE-MODEL_SERISE, CODE = MODEL_NO
--       → 트리0(루트) 아래에 붙는 MODEL_NO 레벨 노드
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_query2//

CREATE PROCEDURE sp_imes_tstd_model_query2(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_PLANTS         VARCHAR(10),
    IN p_MODEL_LIKE     VARCHAR(100),
    IN p_DATA_FLAG      TINYINT
)
BEGIN
    SELECT DISTINCT
        CONCAT(M.MODEL_TYPE, '-', M.MODEL_SERISE)       AS P_CODE,
        M.MODEL_NO                                       AS CODE,
        M.MODEL_NO                                       AS CODE_NAME,
        2                                                AS LEVEL,
        M.MODEL_TYPE                                     AS MODEL_TYPE,
        M.MODEL_SERISE                                   AS MODEL_SERISE,
        M.MODEL_NO                                       AS MODEL_NO,
        -- jQuery/CSS 셀렉터 안전 ID: EasyUI treegrid idField 전용 (특수문자 → 언더스코어)
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            CONCAT(M.MODEL_TYPE, '-', M.MODEL_SERISE),
            ' ','_'),'.','_'),'(','_'),')','_'),'/','_'),',','_'),':','_'),';','_')
                                                         AS SAFE_P_CODE,
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            M.MODEL_NO,
            ' ','_'),'.','_'),'(','_'),')','_'),'/','_'),',','_'),':','_'),';','_')
                                                         AS SAFE_CODE
    FROM TSTD_MODEL M
    WHERE M.PLT_CODE = p_PLT_CODE
      AND M.DATA_FLAG = p_DATA_FLAG
      AND M.MODEL_NO IS NOT NULL
      AND (p_MODEL_LIKE IS NULL OR p_MODEL_LIKE = '' OR
           M.MODEL_NO LIKE CONCAT('%', p_MODEL_LIKE, '%'))
    GROUP BY
        CONCAT(M.MODEL_TYPE, '-', M.MODEL_SERISE),
        M.MODEL_NO,
        M.MODEL_TYPE,
        M.MODEL_SERISE
    ORDER BY
        P_CODE,
        CODE_NAME;
END//

-- ============================================================
-- sp_imes_tstd_model_query2_1
-- 설명: 트리0(루트) - 구분/시리즈 루트 노드 조회 (STD47A 트리 데이터)
-- 원본: C# TSTD_MODEL_QUERY.TSTD_MODEL_QUERY2_1
-- 구조: P_CODE = '' (빈값, 루트), CODE = MODEL_TYPE-MODEL_SERISE
--       CODE_NAME = MODEL_TYPE + ' ' + MODEL_SERISE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_query2_1//

CREATE PROCEDURE sp_imes_tstd_model_query2_1(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_PLANTS         VARCHAR(10),
    IN p_MODEL_LIKE     VARCHAR(100),
    IN p_DATA_FLAG      TINYINT
)
BEGIN
    SELECT DISTINCT
        ''                                                          AS P_CODE,
        CONCAT(M.MODEL_TYPE, '-', M.MODEL_SERISE)                  AS CODE,
        CONCAT(M.MODEL_TYPE, ' ', M.MODEL_SERISE)                  AS CODE_NAME,
        1                                                           AS LEVEL,
        M.MODEL_TYPE                                                AS MODEL_TYPE,
        M.MODEL_SERISE                                              AS MODEL_SERISE,
        -- jQuery/CSS 셀렉터 안전 ID: EasyUI treegrid idField 전용 (특수문자 → 언더스코어)
        ''                                                          AS SAFE_P_CODE,
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            CONCAT(M.MODEL_TYPE, '-', M.MODEL_SERISE),
            ' ','_'),'.','_'),'(','_'),')','_'),'/','_'),',','_'),':','_'),';','_')
                                                                    AS SAFE_CODE
    FROM TSTD_MODEL M
    WHERE M.PLT_CODE = p_PLT_CODE
      AND M.DATA_FLAG = p_DATA_FLAG
      AND M.MODEL_NO IS NOT NULL
      AND (p_MODEL_LIKE IS NULL OR p_MODEL_LIKE = '' OR
           M.MODEL_NO LIKE CONCAT('%', p_MODEL_LIKE, '%'))
    GROUP BY
        CONCAT(M.MODEL_TYPE, '-', M.MODEL_SERISE),
        CONCAT(M.MODEL_TYPE, ' ', M.MODEL_SERISE),
        M.MODEL_TYPE,
        M.MODEL_SERISE
    ORDER BY
        CODE_NAME;
END//

-- ============================================================
-- sp_imes_tstd_model_query2_2
-- 설명: 트리2(3단계) - 조립 공정그룹 노드 조회 (STD47A 트리 데이터)
-- 원본: C# TSTD_MODEL_QUERY.TSTD_MODEL_QUERY2_2
-- 구조: P_CODE = MODEL_NO, CODE = MODEL_NO-PRG_CODE
--       → 모델번호 아래에 붙는 공정그룹 레벨 노드
--       TSTD_PROCGRP 테이블 조인 (UP_CLASS = 'ASSY')
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_query2_2//

CREATE PROCEDURE sp_imes_tstd_model_query2_2(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_PLANTS         VARCHAR(10),
    IN p_MODEL_LIKE     VARCHAR(100),
    IN p_DATA_FLAG      TINYINT
)
BEGIN
    SELECT DISTINCT
        M.MODEL_NO                                         AS P_CODE,
        CONCAT(M.MODEL_NO, '-', P.PRG_CODE)               AS CODE,
        CONCAT(P.PRG_CODE, '(', P.PRG_NAME, ')')          AS CODE_NAME,
        3                                                  AS LEVEL,
        M.MODEL_TYPE                                       AS MODEL_TYPE,
        M.MODEL_SERISE                                     AS MODEL_SERISE,
        M.MODEL_NO                                         AS MODEL_NO,
        P.PRG_CODE                                         AS PRG_CODE,
        P.PRG_NAME                                         AS PRG_NAME,
        -- jQuery/CSS 셀렉터 안전 ID: EasyUI treegrid idField 전용 (특수문자 → 언더스코어)
        -- SAFE_P_CODE 는 QUERY2 의 SAFE_CODE 와 동일한 방식으로 생성해야 부모-자식 연결 가능
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            M.MODEL_NO,
            ' ','_'),'.','_'),'(','_'),')','_'),'/','_'),',','_'),':','_'),';','_')
                                                           AS SAFE_P_CODE,
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            CONCAT(M.MODEL_NO, '-', P.PRG_CODE),
            ' ','_'),'.','_'),'(','_'),')','_'),'/','_'),',','_'),':','_'),';','_')
                                                           AS SAFE_CODE
    FROM TSTD_MODEL M
    LEFT JOIN TSTD_PROCGRP P
        ON  P.PLT_CODE  = M.PLT_CODE
        AND P.DATA_FLAG = 0
        AND P.UP_CLASS  = 'ASSY'
    WHERE M.PLT_CODE = p_PLT_CODE
      AND M.DATA_FLAG = p_DATA_FLAG
      AND M.MODEL_NO IS NOT NULL
      AND (p_MODEL_LIKE IS NULL OR p_MODEL_LIKE = '' OR
           M.MODEL_NO LIKE CONCAT('%', p_MODEL_LIKE, '%'))
    GROUP BY
        M.MODEL_NO,
        P.PRG_CODE,
        P.PRG_NAME,
        M.MODEL_TYPE,
        M.MODEL_SERISE
    ORDER BY
        M.MODEL_NO,
        P.PRG_CODE,
        P.PRG_NAME;
END//

-- ============================================================
-- sp_imes_tstd_model_query2_2_by_model
-- 설명: 트리2(3단계) - 특정 MODEL_NO의 조립 공정그룹 노드 조회 (Lazy Load)
-- 원본: sp_imes_tstd_model_query2_2 에서 MODEL_NO 파라미터 추가
-- 구조: P_CODE = MODEL_NO, CODE = MODEL_NO-PRG_CODE
--       → 특정 모델번호의 공정그룹만 반환 (초기 로드 부하 제거)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_query2_2_by_model//

CREATE PROCEDURE sp_imes_tstd_model_query2_2_by_model(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_PLANTS         VARCHAR(10),
    IN p_MODEL_NO       VARCHAR(100),
    IN p_DATA_FLAG      TINYINT
)
BEGIN
    SELECT DISTINCT
        M.MODEL_NO                                         AS P_CODE,
        CONCAT(M.MODEL_NO, '-', P.PRG_CODE)               AS CODE,
        CONCAT(P.PRG_CODE, '(', P.PRG_NAME, ')')          AS CODE_NAME,
        3                                                  AS LEVEL,
        M.MODEL_TYPE                                       AS MODEL_TYPE,
        M.MODEL_SERISE                                     AS MODEL_SERISE,
        M.MODEL_NO                                         AS MODEL_NO,
        P.PRG_CODE                                         AS PRG_CODE,
        P.PRG_NAME                                         AS PRG_NAME,
        -- jQuery/CSS 셀렉터 안전 ID: EasyUI treegrid idField 전용 (특수문자 → 언더스코어)
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            M.MODEL_NO,
            ' ','_'),'.','_'),'(','_'),')','_'),'/','_'),',','_'),':','_'),';','_')
                                                           AS SAFE_P_CODE,
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            CONCAT(M.MODEL_NO, '-', P.PRG_CODE),
            ' ','_'),'.','_'),'(','_'),')','_'),'/','_'),',','_'),':','_'),';','_')
                                                           AS SAFE_CODE
    FROM TSTD_MODEL M
    LEFT JOIN TSTD_PROCGRP P
        ON  P.PLT_CODE  = M.PLT_CODE
        AND P.DATA_FLAG = 0
        AND P.UP_CLASS  = 'ASSY'
    WHERE M.PLT_CODE = p_PLT_CODE
      AND M.DATA_FLAG = p_DATA_FLAG
      AND M.MODEL_NO  = p_MODEL_NO
    GROUP BY
        M.MODEL_NO,
        P.PRG_CODE,
        P.PRG_NAME,
        M.MODEL_TYPE,
        M.MODEL_SERISE
    ORDER BY
        P.PRG_CODE,
        P.PRG_NAME;
END//

DELIMITER ;
