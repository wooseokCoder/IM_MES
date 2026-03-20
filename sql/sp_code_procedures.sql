-- ============================================================
-- Code.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- 수정일: 2026-02-06 - CODE_CD = '0' 조회 조건 수정 (CODE_GRUP = '0'일 때만 제외)
-- 대상 테이블: SYS_CODE, SYS_CODE_HIST, SYS_CODE_TERM, CUST_MAST
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. sp_code_search: 코드 목록 조회 (페이징)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search//

CREATE PROCEDURE sp_code_search(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(50),
    IN p_code_cd VARCHAR(50),
    IN p_code_desc VARCHAR(200),
    IN p_sort_seq VARCHAR(20),
    IN p_use_flag VARCHAR(10),
    IN p_ext_chr01 VARCHAR(100),
    IN p_ext_chr02 VARCHAR(100),
    IN p_ext_chr03 VARCHAR(100),
    IN p_ext_chr04 VARCHAR(100),
    IN p_ext_chr05 VARCHAR(100),
    IN p_ext_chr06 VARCHAR(100),
    IN p_ext_chr07 VARCHAR(100),
    IN p_ext_chr08 VARCHAR(100),
    IN p_ext_chr09 VARCHAR(100),
    IN p_ext_chr10 VARCHAR(100),
    IN p_ext_num01 VARCHAR(50),
    IN p_ext_num02 VARCHAR(50),
    IN p_ext_num03 VARCHAR(50),
    IN p_ext_num04 VARCHAR(50),
    IN p_ext_num05 VARCHAR(50),
    IN p_gs_lang VARCHAR(10),
    IN p_start VARCHAR(20),
    IN p_end VARCHAR(20),
    IN p_sort_str VARCHAR(500)
)
BEGIN
    SET @rownum := 0;

    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
            FROM (
                SELECT
                    SYS_ID AS sysId,
                    CODE_GRUP AS codeGrup,
                    CASE WHEN CODE_GRUP = '0' THEN CODE_NAME
                         ELSE (SELECT DISTINCT B.CODE_NAME FROM SYS_CODE B WHERE B.SYS_ID = 'WSC' AND B.CODE_CD = A.CODE_GRUP GROUP BY B.CODE_CD)
                    END AS codeGrup2,
                    CODE_CD AS codeCd,
                    (CASE WHEN p_gs_lang = 'ko' THEN CODE_NAME
                          WHEN p_gs_lang = 'en' THEN IFNULL(CODE_NAME_EN, CODE_NAME)
                          WHEN p_gs_lang = 'vi' THEN IFNULL(CODE_NAME_VI, CODE_NAME)
                          WHEN p_gs_lang = 'etc' THEN IFNULL(CODE_NAME_ETC, CODE_NAME)
                          ELSE CODE_NAME END) AS codeName,
                    CODE_NAME AS codeNameKr,
                    CODE_NAME_EN AS codeNameEn,
                    CODE_DESC AS codeDesc,
                    SORT_SEQ AS sortSeq,
                    USE_FLAG AS useFlag,
                    EXT_CHR01 AS extChr01,
                    EXT_CHR02 AS extChr02,
                    EXT_CHR03 AS extChr03,
                    EXT_CHR04 AS extChr04,
                    EXT_CHR05 AS extChr05,
                    EXT_CHR06 AS extChr06,
                    EXT_CHR07 AS extChr07,
                    EXT_CHR08 AS extChr08,
                    EXT_CHR09 AS extChr09,
                    EXT_CHR10 AS extChr10,
                    EXT_NUM01 AS extNum01,
                    EXT_NUM02 AS extNum02,
                    EXT_NUM03 AS extNum03,
                    EXT_NUM04 AS extNum04,
                    EXT_NUM05 AS extNum05,
                    EXT_TEXT AS extText,
                    REGI_ID AS regiId,
                    DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
                    CHNG_ID AS chngId,
                    DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate
                FROM SYS_CODE A
                WHERE SYS_ID = p_sys_id
                  AND (
                      (p_code_grup IS NOT NULL AND p_code_grup != '' AND
                       CODE_GRUP = CASE WHEN p_code_grup = 'ALL' THEN CODE_GRUP ELSE p_code_grup END
                       AND (CODE_GRUP != '0' OR CODE_CD != '0'))  -- CODE_GRUP = '0'일 때만 CODE_CD = '0' 제외
                      OR
                      ((p_code_grup IS NULL OR p_code_grup = '') AND CODE_GRUP = '0' AND CODE_CD != '0')
                  )
                  AND (p_code_cd IS NULL OR p_code_cd = '' OR CODE_CD LIKE CONCAT('%', p_code_cd, '%'))
                  AND (p_code_desc IS NULL OR p_code_desc = '' OR
                       CODE_NAME LIKE CONCAT('%', p_code_desc, '%') OR
                       CODE_DESC LIKE CONCAT('%', p_code_desc, '%') OR
                       EXT_TEXT LIKE CONCAT('%', p_code_desc, '%'))
                  AND (p_sort_seq IS NULL OR SORT_SEQ = p_sort_seq)
                  AND (p_use_flag IS NULL OR p_use_flag = '' OR
                       USE_FLAG = CASE WHEN p_use_flag = 'ALL' THEN USE_FLAG ELSE p_use_flag END)
                  AND (p_ext_chr01 IS NULL OR p_ext_chr01 = '' OR EXT_CHR01 = p_ext_chr01)
                  AND (p_ext_chr02 IS NULL OR p_ext_chr02 = '' OR EXT_CHR02 = p_ext_chr02)
                  AND (p_ext_chr03 IS NULL OR p_ext_chr03 = '' OR EXT_CHR03 = p_ext_chr03)
                  AND (p_ext_chr04 IS NULL OR p_ext_chr04 = '' OR EXT_CHR04 = p_ext_chr04)
                  AND (p_ext_chr05 IS NULL OR p_ext_chr05 = '' OR EXT_CHR05 = p_ext_chr05)
                  AND (p_ext_chr06 IS NULL OR p_ext_chr06 = '' OR EXT_CHR06 = p_ext_chr06)
                  AND (p_ext_chr07 IS NULL OR p_ext_chr07 = '' OR EXT_CHR07 = p_ext_chr07)
                  AND (p_ext_chr08 IS NULL OR p_ext_chr08 = '' OR EXT_CHR08 = p_ext_chr08)
                  AND (p_ext_chr09 IS NULL OR p_ext_chr09 = '' OR EXT_CHR09 = p_ext_chr09)
                  AND (p_ext_chr10 IS NULL OR p_ext_chr10 = '' OR EXT_CHR10 = p_ext_chr10)
                  AND (p_ext_num01 IS NULL OR EXT_NUM01 = p_ext_num01)
                  AND (p_ext_num02 IS NULL OR EXT_NUM02 = p_ext_num02)
                  AND (p_ext_num03 IS NULL OR EXT_NUM03 = p_ext_num03)
                  AND (p_ext_num04 IS NULL OR EXT_NUM04 = p_ext_num04)
                  AND (p_ext_num05 IS NULL OR EXT_NUM05 = p_ext_num05)
                ORDER BY SORT_SEQ
            ) Z1
        ) X
        WHERE (p_end IS NULL OR RNUM < p_end)
    ) X
    WHERE (p_start IS NULL OR RNUM >= p_start);
END//

-- ============================================================
-- 2. sp_code_search_count: 코드 목록 건수 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search_count//

CREATE PROCEDURE sp_code_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(50),
    IN p_code_cd VARCHAR(50),
    IN p_code_desc VARCHAR(200),
    IN p_sort_seq VARCHAR(20),
    IN p_use_flag VARCHAR(10),
    IN p_ext_chr01 VARCHAR(100),
    IN p_ext_chr02 VARCHAR(100),
    IN p_ext_chr03 VARCHAR(100),
    IN p_ext_chr04 VARCHAR(100),
    IN p_ext_chr05 VARCHAR(100),
    IN p_ext_chr06 VARCHAR(100),
    IN p_ext_chr07 VARCHAR(100),
    IN p_ext_chr08 VARCHAR(100),
    IN p_ext_chr09 VARCHAR(100),
    IN p_ext_chr10 VARCHAR(100),
    IN p_ext_num01 VARCHAR(50),
    IN p_ext_num02 VARCHAR(50),
    IN p_ext_num03 VARCHAR(50),
    IN p_ext_num04 VARCHAR(50),
    IN p_ext_num05 VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_CODE A
    WHERE SYS_ID = p_sys_id
      AND (
          (p_code_grup IS NOT NULL AND p_code_grup != '' AND
           CODE_GRUP = CASE WHEN p_code_grup = 'ALL' THEN CODE_GRUP ELSE p_code_grup END
           AND (CODE_GRUP != '0' OR CODE_CD != '0'))  -- CODE_GRUP = '0'일 때만 CODE_CD = '0' 제외
          OR
          ((p_code_grup IS NULL OR p_code_grup = '') AND CODE_GRUP = '0' AND CODE_CD != '0')
      )
      AND (p_code_cd IS NULL OR p_code_cd = '' OR CODE_CD LIKE CONCAT('%', p_code_cd, '%'))
      AND (p_code_desc IS NULL OR p_code_desc = '' OR
           CODE_NAME LIKE CONCAT('%', p_code_desc, '%') OR
           CODE_DESC LIKE CONCAT('%', p_code_desc, '%') OR
           EXT_TEXT LIKE CONCAT('%', p_code_desc, '%'))
      AND (p_sort_seq IS NULL OR SORT_SEQ = p_sort_seq)
      AND (p_use_flag IS NULL OR p_use_flag = '' OR
           USE_FLAG = CASE WHEN p_use_flag = 'ALL' THEN USE_FLAG ELSE p_use_flag END)
      AND (p_ext_chr01 IS NULL OR p_ext_chr01 = '' OR EXT_CHR01 = p_ext_chr01)
      AND (p_ext_chr02 IS NULL OR p_ext_chr02 = '' OR EXT_CHR02 = p_ext_chr02)
      AND (p_ext_chr03 IS NULL OR p_ext_chr03 = '' OR EXT_CHR03 = p_ext_chr03)
      AND (p_ext_chr04 IS NULL OR p_ext_chr04 = '' OR EXT_CHR04 = p_ext_chr04)
      AND (p_ext_chr05 IS NULL OR p_ext_chr05 = '' OR EXT_CHR05 = p_ext_chr05)
      AND (p_ext_chr06 IS NULL OR p_ext_chr06 = '' OR EXT_CHR06 = p_ext_chr06)
      AND (p_ext_chr07 IS NULL OR p_ext_chr07 = '' OR EXT_CHR07 = p_ext_chr07)
      AND (p_ext_chr08 IS NULL OR p_ext_chr08 = '' OR EXT_CHR08 = p_ext_chr08)
      AND (p_ext_chr09 IS NULL OR p_ext_chr09 = '' OR EXT_CHR09 = p_ext_chr09)
      AND (p_ext_chr10 IS NULL OR p_ext_chr10 = '' OR EXT_CHR10 = p_ext_chr10)
      AND (p_ext_num01 IS NULL OR EXT_NUM01 = p_ext_num01)
      AND (p_ext_num02 IS NULL OR EXT_NUM02 = p_ext_num02)
      AND (p_ext_num03 IS NULL OR EXT_NUM03 = p_ext_num03)
      AND (p_ext_num04 IS NULL OR EXT_NUM04 = p_ext_num04)
      AND (p_ext_num05 IS NULL OR EXT_NUM05 = p_ext_num05);
END//

-- ============================================================
-- 3. sp_code_select: 코드 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_select//

CREATE PROCEDURE sp_code_select(
    IN p_sys_id VARCHAR(20),
    IN p_code_cd VARCHAR(50),
    IN p_code_grup VARCHAR(50),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT
        SYS_ID AS sysId,
        CODE_GRUP AS codeGrup,
        CASE WHEN CODE_GRUP = '0' THEN CODE_NAME
             ELSE (SELECT DISTINCT B.CODE_NAME FROM SYS_CODE B WHERE B.SYS_ID = 'WSC' AND B.CODE_CD = A.CODE_GRUP GROUP BY B.CODE_CD)
        END AS codeGrup2,
        CODE_CD AS codeCd,
        (CASE WHEN p_gs_lang = 'ko' THEN CODE_NAME
              WHEN p_gs_lang = 'en' THEN IFNULL(CODE_NAME_EN, CODE_NAME)
              WHEN p_gs_lang = 'vi' THEN IFNULL(CODE_NAME_VI, CODE_NAME)
              WHEN p_gs_lang = 'etc' THEN IFNULL(CODE_NAME_ETC, CODE_NAME)
              ELSE CODE_NAME END) AS codeName,
        CODE_NAME AS codeNameKr,
        CODE_NAME_EN AS codeNameEn,
        CODE_DESC AS codeDesc,
        SORT_SEQ AS sortSeq,
        USE_FLAG AS useFlag,
        EXT_CHR01 AS extChr01,
        EXT_CHR02 AS extChr02,
        EXT_CHR03 AS extChr03,
        EXT_CHR04 AS extChr04,
        EXT_CHR05 AS extChr05,
        EXT_CHR06 AS extChr06,
        EXT_CHR07 AS extChr07,
        EXT_CHR08 AS extChr08,
        EXT_CHR09 AS extChr09,
        EXT_CHR10 AS extChr10,
        EXT_NUM01 AS extNum01,
        EXT_NUM02 AS extNum02,
        EXT_NUM03 AS extNum03,
        EXT_NUM04 AS extNum04,
        EXT_NUM05 AS extNum05,
        EXT_TEXT AS extText,
        REGI_ID AS regiId,
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        CHNG_ID AS chngId,
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate
    FROM SYS_CODE A
    WHERE SYS_ID = p_sys_id
      AND CODE_CD = p_code_cd
      AND CODE_GRUP = p_code_grup
    ORDER BY SORT_SEQ;
END//

-- ============================================================
-- 4. sp_code_insert: 코드 등록
-- NULLIF 패턴: 빈문자열이면 NULL로 변환
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_insert//

CREATE PROCEDURE sp_code_insert(
    IN p_sys_id VARCHAR(20),
    IN p_code_cd VARCHAR(50),
    IN p_code_grup VARCHAR(50),
    IN p_code_name_kr VARCHAR(200),
    IN p_code_name_en VARCHAR(200),
    IN p_code_desc VARCHAR(500),
    IN p_ext_chr01 VARCHAR(100),
    IN p_ext_chr02 VARCHAR(100),
    IN p_ext_chr03 VARCHAR(100),
    IN p_ext_chr04 VARCHAR(100),
    IN p_ext_chr05 VARCHAR(100),
    IN p_ext_chr06 VARCHAR(100),
    IN p_ext_chr07 VARCHAR(100),
    IN p_ext_chr08 VARCHAR(100),
    IN p_ext_chr09 VARCHAR(100),
    IN p_ext_chr10 VARCHAR(100),
    IN p_ext_num01 VARCHAR(50),
    IN p_ext_num02 VARCHAR(50),
    IN p_ext_num03 VARCHAR(50),
    IN p_ext_num04 VARCHAR(50),
    IN p_ext_num05 VARCHAR(50),
    IN p_ext_text TEXT,
    IN p_sort_seq VARCHAR(20),
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_CODE (
        SYS_ID,
        CODE_CD,
        CODE_GRUP,
        CODE_NAME,
        CODE_NAME_EN,
        CODE_DESC,
        SORT_SEQ,
        USE_FLAG,
        EXT_CHR01,
        EXT_CHR02,
        EXT_CHR03,
        EXT_CHR04,
        EXT_CHR05,
        EXT_CHR06,
        EXT_CHR07,
        EXT_CHR08,
        EXT_CHR09,
        EXT_CHR10,
        EXT_NUM01,
        EXT_NUM02,
        EXT_NUM03,
        EXT_NUM04,
        EXT_NUM05,
        EXT_TEXT,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_sys_id,
        p_code_cd,
        IFNULL(NULLIF(p_code_grup, ''), '0'),
        NULLIF(p_code_name_kr, ''),
        NULLIF(p_code_name_en, ''),
        NULLIF(p_code_desc, ''),
        NULLIF(p_sort_seq, ''),
        IFNULL(NULLIF(p_use_flag, ''), 'Y'),
        NULLIF(p_ext_chr01, ''),
        NULLIF(p_ext_chr02, ''),
        NULLIF(p_ext_chr03, ''),
        NULLIF(p_ext_chr04, ''),
        NULLIF(p_ext_chr05, ''),
        NULLIF(p_ext_chr06, ''),
        NULLIF(p_ext_chr07, ''),
        NULLIF(p_ext_chr08, ''),
        NULLIF(p_ext_chr09, ''),
        NULLIF(p_ext_chr10, ''),
        NULLIF(p_ext_num01, ''),
        NULLIF(p_ext_num02, ''),
        NULLIF(p_ext_num03, ''),
        NULLIF(p_ext_num04, ''),
        NULLIF(p_ext_num05, ''),
        NULLIF(p_ext_text, ''),
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 5. sp_code_update: 코드 수정
-- NULLIF 패턴: 빈문자열이면 NULL로 변환
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_update//

CREATE PROCEDURE sp_code_update(
    IN p_sys_id VARCHAR(20),
    IN p_code_cd VARCHAR(50),
    IN p_code_grup VARCHAR(50),
    IN p_code_name_kr VARCHAR(200),
    IN p_code_name_en VARCHAR(200),
    IN p_code_desc VARCHAR(500),
    IN p_ext_chr01 VARCHAR(100),
    IN p_ext_chr02 VARCHAR(100),
    IN p_ext_chr03 VARCHAR(100),
    IN p_ext_chr04 VARCHAR(100),
    IN p_ext_chr05 VARCHAR(100),
    IN p_ext_chr06 VARCHAR(100),
    IN p_ext_chr07 VARCHAR(100),
    IN p_ext_chr08 VARCHAR(100),
    IN p_ext_chr09 VARCHAR(100),
    IN p_ext_chr10 VARCHAR(100),
    IN p_ext_num01 VARCHAR(50),
    IN p_ext_num02 VARCHAR(50),
    IN p_ext_num03 VARCHAR(50),
    IN p_ext_num04 VARCHAR(50),
    IN p_ext_num05 VARCHAR(50),
    IN p_ext_text TEXT,
    IN p_sort_seq VARCHAR(20),
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_CODE
    SET CODE_NAME = NULLIF(p_code_name_kr, ''),
        CODE_NAME_EN = NULLIF(p_code_name_en, ''),
        CODE_DESC = NULLIF(p_code_desc, ''),
        SORT_SEQ = NULLIF(p_sort_seq, ''),
        USE_FLAG = IFNULL(NULLIF(p_use_flag, ''), 'Y'),
        EXT_CHR01 = NULLIF(p_ext_chr01, ''),
        EXT_CHR02 = NULLIF(p_ext_chr02, ''),
        EXT_CHR03 = NULLIF(p_ext_chr03, ''),
        EXT_CHR04 = NULLIF(p_ext_chr04, ''),
        EXT_CHR05 = NULLIF(p_ext_chr05, ''),
        EXT_CHR06 = NULLIF(p_ext_chr06, ''),
        EXT_CHR07 = NULLIF(p_ext_chr07, ''),
        EXT_CHR08 = NULLIF(p_ext_chr08, ''),
        EXT_CHR09 = NULLIF(p_ext_chr09, ''),
        EXT_CHR10 = NULLIF(p_ext_chr10, ''),
        EXT_NUM01 = NULLIF(p_ext_num01, ''),
        EXT_NUM02 = NULLIF(p_ext_num02, ''),
        EXT_NUM03 = NULLIF(p_ext_num03, ''),
        EXT_NUM04 = NULLIF(p_ext_num04, ''),
        EXT_NUM05 = NULLIF(p_ext_num05, ''),
        EXT_TEXT = NULLIF(p_ext_text, ''),
        CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND CODE_CD = p_code_cd
      AND CODE_GRUP = p_code_grup;
END//

-- ============================================================
-- 6. sp_code_delete: 코드 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_delete//

CREATE PROCEDURE sp_code_delete(
    IN p_sys_id VARCHAR(20),
    IN p_code_cd VARCHAR(50),
    IN p_code_grup VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_CODE
    WHERE SYS_ID = p_sys_id
      AND CODE_CD = p_code_cd
      AND CODE_GRUP = p_code_grup;
END//

-- ============================================================
-- 7. sp_code_search_all: 전체 코드 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search_all//

CREATE PROCEDURE sp_code_search_all(
    IN p_sys_id VARCHAR(20),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT
        SYS_ID AS sysId,
        CODE_GRUP AS codeGrup,
        CASE WHEN CODE_GRUP = '0' THEN CODE_NAME
             ELSE (SELECT DISTINCT B.CODE_NAME FROM SYS_CODE B WHERE B.SYS_ID = 'WSC' AND B.CODE_CD = A.CODE_GRUP GROUP BY B.CODE_CD)
        END AS codeGrup2,
        CODE_CD AS codeCd,
        (CASE WHEN p_gs_lang = 'ko' THEN CODE_NAME
              WHEN p_gs_lang = 'en' THEN IFNULL(CODE_NAME_EN, CODE_NAME)
              WHEN p_gs_lang = 'vi' THEN IFNULL(CODE_NAME_VI, CODE_NAME)
              WHEN p_gs_lang = 'etc' THEN IFNULL(CODE_NAME_ETC, CODE_NAME)
              ELSE CODE_NAME END) AS codeName,
        CODE_NAME AS codeNameKr,
        CODE_NAME_EN AS codeNameEn,
        CODE_DESC AS codeDesc,
        SORT_SEQ AS sortSeq,
        USE_FLAG AS useFlag,
        EXT_CHR01 AS extChr01,
        EXT_CHR02 AS extChr02,
        EXT_CHR03 AS extChr03,
        EXT_CHR04 AS extChr04,
        EXT_CHR05 AS extChr05,
        EXT_CHR06 AS extChr06,
        EXT_CHR07 AS extChr07,
        EXT_CHR08 AS extChr08,
        EXT_CHR09 AS extChr09,
        EXT_CHR10 AS extChr10,
        EXT_NUM01 AS extNum01,
        EXT_NUM02 AS extNum02,
        EXT_NUM03 AS extNum03,
        EXT_NUM04 AS extNum04,
        EXT_NUM05 AS extNum05,
        EXT_TEXT AS extText,
        REGI_ID AS regiId,
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        CHNG_ID AS chngId,
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate
    FROM SYS_CODE A
    WHERE SYS_ID = p_sys_id
      AND (CODE_GRUP != '0' OR CODE_CD != '0')  -- CODE_GRUP = '0'일 때만 CODE_CD = '0' 제외
      AND USE_FLAG = 'Y'
    ORDER BY SYS_ID, CODE_GRUP, SORT_SEQ, CODE_CD, CODE_NAME;
END//

-- ============================================================
-- 8. sp_code_delete_all: 코드 그룹 전체 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_delete_all//

CREATE PROCEDURE sp_code_delete_all(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_CODE
    WHERE SYS_ID = p_sys_id
      AND CODE_GRUP = p_code_grup;
END//

-- ============================================================
-- 9. sp_code_insert_hist: 코드 변경 이력 등록
-- NULLIF 패턴: 빈문자열이면 NULL로 변환
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_insert_hist//

CREATE PROCEDURE sp_code_insert_hist(
    IN p_sys_id VARCHAR(20),
    IN p_code_cd VARCHAR(50),
    IN p_code_grup VARCHAR(50),
    IN p_code_name_kr VARCHAR(200),
    IN p_code_name_en VARCHAR(200),
    IN p_code_desc VARCHAR(500),
    IN p_ext_chr01 VARCHAR(100),
    IN p_ext_chr02 VARCHAR(100),
    IN p_ext_chr03 VARCHAR(100),
    IN p_ext_chr04 VARCHAR(100),
    IN p_ext_chr05 VARCHAR(100),
    IN p_ext_chr06 VARCHAR(100),
    IN p_ext_chr07 VARCHAR(100),
    IN p_ext_chr08 VARCHAR(100),
    IN p_ext_chr09 VARCHAR(100),
    IN p_ext_chr10 VARCHAR(100),
    IN p_ext_num01 VARCHAR(50),
    IN p_ext_num02 VARCHAR(50),
    IN p_ext_num03 VARCHAR(50),
    IN p_ext_num04 VARCHAR(50),
    IN p_ext_num05 VARCHAR(50),
    IN p_ext_text TEXT,
    IN p_sort_seq VARCHAR(20),
    IN p_use_flag VARCHAR(1),
    IN p_hist_type VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_CODE_HIST (
        SYS_ID,
        CODE_CD,
        CODE_GRUP,
        CODE_NAME,
        CODE_NAME_EN,
        CODE_DESC,
        SORT_SEQ,
        USE_FLAG,
        EXT_CHR01,
        EXT_CHR02,
        EXT_CHR03,
        EXT_CHR04,
        EXT_CHR05,
        EXT_CHR06,
        EXT_CHR07,
        EXT_CHR08,
        EXT_CHR09,
        EXT_CHR10,
        EXT_NUM01,
        EXT_NUM02,
        EXT_NUM03,
        EXT_NUM04,
        EXT_NUM05,
        EXT_TEXT,
        HIST_TYPE,
        HIST_DATE,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_sys_id,
        p_code_cd,
        IFNULL(NULLIF(p_code_grup, ''), '0'),
        NULLIF(p_code_name_kr, ''),
        NULLIF(p_code_name_en, ''),
        NULLIF(p_code_desc, ''),
        NULLIF(p_sort_seq, ''),
        IFNULL(NULLIF(p_use_flag, ''), 'Y'),
        NULLIF(p_ext_chr01, ''),
        NULLIF(p_ext_chr02, ''),
        NULLIF(p_ext_chr03, ''),
        NULLIF(p_ext_chr04, ''),
        NULLIF(p_ext_chr05, ''),
        NULLIF(p_ext_chr06, ''),
        NULLIF(p_ext_chr07, ''),
        NULLIF(p_ext_chr08, ''),
        NULLIF(p_ext_chr09, ''),
        NULLIF(p_ext_chr10, ''),
        NULLIF(p_ext_num01, ''),
        NULLIF(p_ext_num02, ''),
        NULLIF(p_ext_num03, ''),
        NULLIF(p_ext_num04, ''),
        NULLIF(p_ext_num05, ''),
        NULLIF(p_ext_text, ''),
        p_hist_type,
        NOW(),
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 10. sp_code_search_term: 기간별 코드 목록 조회 (페이징)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search_term//

CREATE PROCEDURE sp_code_search_term(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(50),
    IN p_code_cd VARCHAR(50),
    IN p_code_desc VARCHAR(200),
    IN p_sort_seq VARCHAR(20),
    IN p_use_flag VARCHAR(10),
    IN p_ext_chr01 VARCHAR(100),
    IN p_ext_chr02 VARCHAR(100),
    IN p_ext_chr03 VARCHAR(100),
    IN p_ext_chr04 VARCHAR(100),
    IN p_ext_chr05 VARCHAR(100),
    IN p_ext_chr06 VARCHAR(100),
    IN p_ext_chr07 VARCHAR(100),
    IN p_ext_chr08 VARCHAR(100),
    IN p_ext_chr09 VARCHAR(100),
    IN p_ext_chr10 VARCHAR(100),
    IN p_ext_num01 VARCHAR(50),
    IN p_ext_num02 VARCHAR(50),
    IN p_ext_num03 VARCHAR(50),
    IN p_ext_num04 VARCHAR(50),
    IN p_ext_num05 VARCHAR(50),
    IN p_code_date VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_start VARCHAR(20),
    IN p_end VARCHAR(20),
    IN p_sort_str VARCHAR(500)
)
BEGIN
    SET @rownum := 0;

    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
            FROM (
                SELECT
                    SYS_ID AS sysId,
                    CODE_GRUP AS codeGrup,
                    CASE WHEN CODE_GRUP = '0' THEN CODE_NAME
                         ELSE (SELECT DISTINCT B.CODE_NAME FROM SYS_CODE B WHERE B.SYS_ID = 'WSC' AND B.CODE_CD = A.CODE_GRUP GROUP BY B.CODE_CD)
                    END AS codeGrup2,
                    CODE_CD AS codeCd,
                    (CASE WHEN p_gs_lang = 'ko' THEN CODE_NAME
                          WHEN p_gs_lang = 'en' THEN IFNULL(CODE_NAME_EN, CODE_NAME)
                          WHEN p_gs_lang = 'vi' THEN IFNULL(CODE_NAME_VI, CODE_NAME)
                          WHEN p_gs_lang = 'etc' THEN IFNULL(CODE_NAME_ETC, CODE_NAME)
                          ELSE CODE_NAME END) AS codeName,
                    CODE_NAME AS codeNameKr,
                    CODE_NAME_EN AS codeNameEn,
                    CODE_DESC AS codeDesc,
                    SORT_SEQ AS sortSeq,
                    USE_FLAG AS useFlag,
                    EXT_CHR01 AS extChr01,
                    EXT_CHR02 AS extChr02,
                    EXT_CHR03 AS extChr03,
                    EXT_CHR04 AS extChr04,
                    EXT_CHR05 AS extChr05,
                    EXT_CHR06 AS extChr06,
                    EXT_CHR07 AS extChr07,
                    EXT_CHR08 AS extChr08,
                    EXT_CHR09 AS extChr09,
                    EXT_CHR10 AS extChr10,
                    EXT_NUM01 AS extNum01,
                    EXT_NUM02 AS extNum02,
                    EXT_NUM03 AS extNum03,
                    EXT_NUM04 AS extNum04,
                    EXT_NUM05 AS extNum05,
                    EXT_TEXT AS extText,
                    CODE_DATE AS codeDate,
                    REGI_ID AS regiId,
                    DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
                    CHNG_ID AS chngId,
                    DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate
                FROM SYS_CODE_TERM A
                WHERE SYS_ID = p_sys_id
                  AND (p_code_grup IS NULL OR p_code_grup = '' OR CODE_GRUP = p_code_grup)
                  AND CODE_GRUP != '0'
                  AND USE_FLAG = 'Y'
                  AND (p_code_cd IS NULL OR p_code_cd = '' OR CODE_CD = p_code_cd)
                  AND (p_code_desc IS NULL OR p_code_desc = '' OR
                       CODE_NAME LIKE CONCAT('%', p_code_desc, '%') OR
                       CODE_DESC LIKE CONCAT('%', p_code_desc, '%') OR
                       EXT_TEXT LIKE CONCAT('%', p_code_desc, '%'))
                  AND (p_sort_seq IS NULL OR SORT_SEQ = p_sort_seq)
                  AND (p_use_flag IS NULL OR p_use_flag = '' OR USE_FLAG = p_use_flag)
                  AND (p_ext_chr01 IS NULL OR p_ext_chr01 = '' OR EXT_CHR01 = p_ext_chr01)
                  AND (p_ext_chr02 IS NULL OR p_ext_chr02 = '' OR EXT_CHR02 = p_ext_chr02)
                  AND (p_ext_chr03 IS NULL OR p_ext_chr03 = '' OR EXT_CHR03 = p_ext_chr03)
                  AND (p_ext_chr04 IS NULL OR p_ext_chr04 = '' OR EXT_CHR04 = p_ext_chr04)
                  AND (p_ext_chr05 IS NULL OR p_ext_chr05 = '' OR EXT_CHR05 = p_ext_chr05)
                  AND (p_ext_chr06 IS NULL OR p_ext_chr06 = '' OR EXT_CHR06 = p_ext_chr06)
                  AND (p_ext_chr07 IS NULL OR p_ext_chr07 = '' OR EXT_CHR07 = p_ext_chr07)
                  AND (p_ext_chr08 IS NULL OR p_ext_chr08 = '' OR EXT_CHR08 = p_ext_chr08)
                  AND (p_ext_chr09 IS NULL OR p_ext_chr09 = '' OR EXT_CHR09 = p_ext_chr09)
                  AND (p_ext_chr10 IS NULL OR p_ext_chr10 = '' OR EXT_CHR10 = p_ext_chr10)
                  AND (p_ext_num01 IS NULL OR EXT_NUM01 = p_ext_num01)
                  AND (p_ext_num02 IS NULL OR EXT_NUM02 = p_ext_num02)
                  AND (p_ext_num03 IS NULL OR EXT_NUM03 = p_ext_num03)
                  AND (p_ext_num04 IS NULL OR EXT_NUM04 = p_ext_num04)
                  AND (p_ext_num05 IS NULL OR EXT_NUM05 = p_ext_num05)
                  AND (p_code_date IS NULL OR p_code_date = '' OR CODE_DATE = p_code_date)
                ORDER BY SORT_SEQ
            ) Z1
        ) X
        WHERE (p_end IS NULL OR RNUM < p_end)
    ) X
    WHERE (p_start IS NULL OR RNUM >= p_start);
END//

-- ============================================================
-- 11. sp_code_search_term_count: 기간별 코드 목록 건수 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search_term_count//

CREATE PROCEDURE sp_code_search_term_count(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(50),
    IN p_code_cd VARCHAR(50),
    IN p_code_desc VARCHAR(200),
    IN p_sort_seq VARCHAR(20),
    IN p_use_flag VARCHAR(10),
    IN p_ext_chr01 VARCHAR(100),
    IN p_ext_chr02 VARCHAR(100),
    IN p_ext_chr03 VARCHAR(100),
    IN p_ext_chr04 VARCHAR(100),
    IN p_ext_chr05 VARCHAR(100),
    IN p_ext_chr06 VARCHAR(100),
    IN p_ext_chr07 VARCHAR(100),
    IN p_ext_chr08 VARCHAR(100),
    IN p_ext_chr09 VARCHAR(100),
    IN p_ext_chr10 VARCHAR(100),
    IN p_ext_num01 VARCHAR(50),
    IN p_ext_num02 VARCHAR(50),
    IN p_ext_num03 VARCHAR(50),
    IN p_ext_num04 VARCHAR(50),
    IN p_ext_num05 VARCHAR(50),
    IN p_code_date VARCHAR(20)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_CODE_TERM A
    WHERE SYS_ID = p_sys_id
      AND (p_code_grup IS NULL OR p_code_grup = '' OR CODE_GRUP = p_code_grup)
      AND CODE_GRUP != '0'
      AND USE_FLAG = 'Y'
      AND (p_code_cd IS NULL OR p_code_cd = '' OR CODE_CD = p_code_cd)
      AND (p_code_desc IS NULL OR p_code_desc = '' OR
           CODE_NAME LIKE CONCAT('%', p_code_desc, '%') OR
           CODE_DESC LIKE CONCAT('%', p_code_desc, '%') OR
           EXT_TEXT LIKE CONCAT('%', p_code_desc, '%'))
      AND (p_sort_seq IS NULL OR SORT_SEQ = p_sort_seq)
      AND (p_use_flag IS NULL OR p_use_flag = '' OR USE_FLAG = p_use_flag)
      AND (p_ext_chr01 IS NULL OR p_ext_chr01 = '' OR EXT_CHR01 = p_ext_chr01)
      AND (p_ext_chr02 IS NULL OR p_ext_chr02 = '' OR EXT_CHR02 = p_ext_chr02)
      AND (p_ext_chr03 IS NULL OR p_ext_chr03 = '' OR EXT_CHR03 = p_ext_chr03)
      AND (p_ext_chr04 IS NULL OR p_ext_chr04 = '' OR EXT_CHR04 = p_ext_chr04)
      AND (p_ext_chr05 IS NULL OR p_ext_chr05 = '' OR EXT_CHR05 = p_ext_chr05)
      AND (p_ext_chr06 IS NULL OR p_ext_chr06 = '' OR EXT_CHR06 = p_ext_chr06)
      AND (p_ext_chr07 IS NULL OR p_ext_chr07 = '' OR EXT_CHR07 = p_ext_chr07)
      AND (p_ext_chr08 IS NULL OR p_ext_chr08 = '' OR EXT_CHR08 = p_ext_chr08)
      AND (p_ext_chr09 IS NULL OR p_ext_chr09 = '' OR EXT_CHR09 = p_ext_chr09)
      AND (p_ext_chr10 IS NULL OR p_ext_chr10 = '' OR EXT_CHR10 = p_ext_chr10)
      AND (p_ext_num01 IS NULL OR EXT_NUM01 = p_ext_num01)
      AND (p_ext_num02 IS NULL OR EXT_NUM02 = p_ext_num02)
      AND (p_ext_num03 IS NULL OR EXT_NUM03 = p_ext_num03)
      AND (p_ext_num04 IS NULL OR EXT_NUM04 = p_ext_num04)
      AND (p_ext_num05 IS NULL OR EXT_NUM05 = p_ext_num05)
      AND (p_code_date IS NULL OR p_code_date = '' OR CODE_DATE = p_code_date);
END//

-- ============================================================
-- 12. sp_code_select_term: 기간별 코드 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_select_term//

CREATE PROCEDURE sp_code_select_term(
    IN p_sys_id VARCHAR(20),
    IN p_code_cd VARCHAR(50),
    IN p_code_grup VARCHAR(50),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT
        SYS_ID AS sysId,
        CODE_GRUP AS codeGrup,
        CASE WHEN CODE_GRUP = '0' THEN CODE_NAME
             ELSE (SELECT DISTINCT B.CODE_NAME FROM SYS_CODE B WHERE B.SYS_ID = 'WSC' AND B.CODE_CD = A.CODE_GRUP GROUP BY B.CODE_CD)
        END AS codeGrup2,
        CODE_CD AS codeCd,
        (CASE WHEN p_gs_lang = 'ko' THEN CODE_NAME
              WHEN p_gs_lang = 'en' THEN IFNULL(CODE_NAME_EN, CODE_NAME)
              WHEN p_gs_lang = 'vi' THEN IFNULL(CODE_NAME_VI, CODE_NAME)
              WHEN p_gs_lang = 'etc' THEN IFNULL(CODE_NAME_ETC, CODE_NAME)
              ELSE CODE_NAME END) AS codeName,
        CODE_NAME AS codeNameKr,
        CODE_NAME_EN AS codeNameEn,
        CODE_DESC AS codeDesc,
        SORT_SEQ AS sortSeq,
        USE_FLAG AS useFlag,
        EXT_CHR01 AS extChr01,
        EXT_CHR02 AS extChr02,
        EXT_CHR03 AS extChr03,
        EXT_CHR04 AS extChr04,
        EXT_CHR05 AS extChr05,
        EXT_CHR06 AS extChr06,
        EXT_CHR07 AS extChr07,
        EXT_CHR08 AS extChr08,
        EXT_CHR09 AS extChr09,
        EXT_CHR10 AS extChr10,
        EXT_NUM01 AS extNum01,
        EXT_NUM02 AS extNum02,
        EXT_NUM03 AS extNum03,
        EXT_NUM04 AS extNum04,
        EXT_NUM05 AS extNum05,
        EXT_TEXT AS extText,
        CODE_DATE AS codeDate,
        REGI_ID AS regiId,
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        CHNG_ID AS chngId,
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate
    FROM SYS_CODE_TERM A
    WHERE SYS_ID = p_sys_id
      AND CODE_CD = p_code_cd
      AND CODE_GRUP = p_code_grup;
END//

-- ============================================================
-- 13. sp_code_insert_term: 기간별 코드 등록
-- NULLIF 패턴: 빈문자열이면 NULL로 변환
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_insert_term//

CREATE PROCEDURE sp_code_insert_term(
    IN p_sys_id VARCHAR(20),
    IN p_code_cd VARCHAR(50),
    IN p_code_grup VARCHAR(50),
    IN p_code_name_kr VARCHAR(200),
    IN p_code_name_en VARCHAR(200),
    IN p_code_desc VARCHAR(500),
    IN p_ext_chr01 VARCHAR(100),
    IN p_ext_chr02 VARCHAR(100),
    IN p_ext_chr03 VARCHAR(100),
    IN p_ext_chr04 VARCHAR(100),
    IN p_ext_chr05 VARCHAR(100),
    IN p_ext_chr06 VARCHAR(100),
    IN p_ext_chr07 VARCHAR(100),
    IN p_ext_chr08 VARCHAR(100),
    IN p_ext_chr09 VARCHAR(100),
    IN p_ext_chr10 VARCHAR(100),
    IN p_ext_num01 VARCHAR(50),
    IN p_ext_num02 VARCHAR(50),
    IN p_ext_num03 VARCHAR(50),
    IN p_ext_num04 VARCHAR(50),
    IN p_ext_num05 VARCHAR(50),
    IN p_ext_text TEXT,
    IN p_sort_seq VARCHAR(20),
    IN p_use_flag VARCHAR(1),
    IN p_code_date VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_CODE_TERM (
        SYS_ID,
        CODE_CD,
        CODE_GRUP,
        CODE_NAME,
        CODE_NAME_EN,
        CODE_DESC,
        SORT_SEQ,
        USE_FLAG,
        EXT_CHR01,
        EXT_CHR02,
        EXT_CHR03,
        EXT_CHR04,
        EXT_CHR05,
        EXT_CHR06,
        EXT_CHR07,
        EXT_CHR08,
        EXT_CHR09,
        EXT_CHR10,
        EXT_NUM01,
        EXT_NUM02,
        EXT_NUM03,
        EXT_NUM04,
        EXT_NUM05,
        EXT_TEXT,
        CODE_DATE,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_sys_id,
        p_code_cd,
        IFNULL(NULLIF(p_code_grup, ''), '0'),
        NULLIF(p_code_name_kr, ''),
        NULLIF(p_code_name_en, ''),
        NULLIF(p_code_desc, ''),
        NULLIF(p_sort_seq, ''),
        IFNULL(NULLIF(p_use_flag, ''), 'Y'),
        NULLIF(p_ext_chr01, ''),
        NULLIF(p_ext_chr02, ''),
        NULLIF(p_ext_chr03, ''),
        NULLIF(p_ext_chr04, ''),
        NULLIF(p_ext_chr05, ''),
        NULLIF(p_ext_chr06, ''),
        NULLIF(p_ext_chr07, ''),
        NULLIF(p_ext_chr08, ''),
        NULLIF(p_ext_chr09, ''),
        NULLIF(p_ext_chr10, ''),
        NULLIF(p_ext_num01, ''),
        NULLIF(p_ext_num02, ''),
        NULLIF(p_ext_num03, ''),
        NULLIF(p_ext_num04, ''),
        NULLIF(p_ext_num05, ''),
        NULLIF(p_ext_text, ''),
        NULLIF(p_code_date, ''),
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 14. sp_code_delete_term: 기간별 코드 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_delete_term//

CREATE PROCEDURE sp_code_delete_term(
    IN p_sys_id VARCHAR(20),
    IN p_code_cd VARCHAR(50),
    IN p_code_grup VARCHAR(50),
    IN p_code_date VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_CODE_TERM
    WHERE SYS_ID = p_sys_id
      AND CODE_CD = p_code_cd
      AND CODE_GRUP = p_code_grup
      AND CODE_DATE = p_code_date;
END//

-- ============================================================
-- 15. sp_code_get_select_code: 코드 그룹 선택 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_get_select_code//

CREATE PROCEDURE sp_code_get_select_code(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT CODE_CD AS codeCd,
           CODE_NAME AS codeName
    FROM SYS_CODE
    WHERE CODE_GRUP = '0'
      AND SYS_ID = p_sys_id
      AND CODE_CD != '0'
      AND USE_FLAG = 'Y'
    ORDER BY SORT_SEQ;
END//

-- ============================================================
-- 16. sp_code_get_select_code_sort: 정렬 코드 선택 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_get_select_code_sort//

CREATE PROCEDURE sp_code_get_select_code_sort()
BEGIN
    SELECT CODE_CD AS codeCd,
           CODE_NAME AS codeName
    FROM SYS_CODE
    WHERE CODE_GRUP = 'CODE_SORT'
      AND USE_FLAG = 'Y'
    ORDER BY CODE_NAME ASC;
END//

-- ============================================================
-- 17. sp_code_search_code: 코드 그룹별 코드 조회
-- 주의: codeGrup 파라미터는 IN 절에 사용되므로 동적 SQL 필요
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search_code//

CREATE PROCEDURE sp_code_search_code(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(500),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SET @sql = CONCAT(
        'SELECT CODE_GRUP, ',
        '       CODE_CD, ',
        '       CASE WHEN ''', p_gs_lang, ''' = ''ko'' THEN CODE_NAME ',
        '            WHEN ''', p_gs_lang, ''' = ''en'' THEN CODE_NAME_EN ',
        '            WHEN ''', p_gs_lang, ''' = ''vi'' THEN CODE_NAME_VI ',
        '            ELSE CODE_NAME ',
        '       END AS CODE_NAME, ',
        '       EXT_CHR01, ',
        '       SORT_SEQ, ',
        '       CODE_DESC ',
        'FROM SYS_CODE ',
        'WHERE SYS_ID = ''', p_sys_id, ''' ',
        '  AND CODE_GRUP IN(', p_code_grup, ') ',
        '  AND USE_FLAG = ''Y'' ',
        'ORDER BY SORT_SEQ'
    );

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 18. sp_code_search_code_as: 수입 유형별 코드 조회
-- 주의: codeGrup2 파라미터는 IN 절에 사용되므로 동적 SQL 필요
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search_code_as//

CREATE PROCEDURE sp_code_search_code_as(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup2 VARCHAR(500)
)
BEGIN
    SET @sql = CONCAT(
        'SELECT CONCAT(CODE_GRUP, CODE_DESC) AS CODE_GRUP, ',
        '       CODE_CD, ',
        '       CODE_NAME, ',
        '       EXT_CHR01, ',
        '       SORT_SEQ, ',
        '       CODE_DESC ',
        'FROM SYS_CODE ',
        'WHERE SYS_ID = ''', p_sys_id, ''' ',
        '  AND CODE_GRUP = ''INCOME_TYPE'' ',
        '  AND CODE_DESC IN(', p_code_grup2, ') ',
        '  AND USE_FLAG = ''Y'' ',
        'ORDER BY SORT_SEQ'
    );

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 19. sp_code_search_cust_prod: 고객 제품 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search_cust_prod//

CREATE PROCEDURE sp_code_search_cust_prod()
BEGIN
    SELECT A.CUST_NAME, A.CUST_CODE, 2 AS sortnum
    FROM CUST_MAST A
    WHERE A.SYS_ID = 'WSC' AND USE_IDX = 'Y' AND MAK_CUST = 'Y'
    UNION ALL
    SELECT '공장' AS CUST_NAME, '02' AS CUST_CODE, 1 AS sortnum
    ORDER BY sortnum, CUST_NAME;
END//

-- ============================================================
-- 20. sp_code_search_all_prod: 전체 제품 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search_all_prod//

CREATE PROCEDURE sp_code_search_all_prod()
BEGIN
    SELECT A.CUST_NAME, A.CUST_CODE, 20 AS SORT_SEQ
    FROM CUST_MAST A
    WHERE A.SYS_ID = 'WSC' AND USE_IDX = 'Y' AND MAK_CUST = 'Y'
    UNION ALL
    SELECT CODE_NAME AS CUST_NAME, CODE_CD AS CUST_CODE, SORT_SEQ
    FROM SYS_CODE
    WHERE CODE_GRUP = 'STRG_TYPE' AND USE_FLAG = 'Y'
    ORDER BY SORT_SEQ;
END//

-- ============================================================
-- 21. sp_code_search_outs_cust_strg: 외부 고객 창고 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_search_outs_cust_strg//

CREATE PROCEDURE sp_code_search_outs_cust_strg()
BEGIN
    SELECT CONCAT('[', A.CODE_NAME, '] - ', (SELECT CUST_NAME FROM CUST_MAST WHERE SYS_ID = 'WSC' AND CUST_CODE = B.CUST_CODE)) AS CUST_NAME,
           A.CODE_CD AS CUST_CODE,
           A.SORT_SEQ AS SORT_SEQ
    FROM (SELECT SYS_ID, CODE_NAME, CODE_CD, EXT_CHR02, SORT_SEQ
          FROM SYS_CODE
          WHERE CODE_GRUP = 'STRG_TYPE' AND USE_FLAG = 'Y') A,
         (SELECT SYS_ID, CUST_CODE
          FROM CUST_MAST
          WHERE SYS_ID = 'WSC' AND CUST_TYPE = '09') B
    WHERE A.SYS_ID = B.SYS_ID AND A.EXT_CHR02 = B.CUST_CODE;
END//

-- ============================================================
-- 22. sp_code_update_ext_chr: 확장 문자 필드 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_update_ext_chr//

CREATE PROCEDURE sp_code_update_ext_chr(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(50),
    IN p_code_cd VARCHAR(50),
    IN p_ext_chr01 VARCHAR(100),
    IN p_ext_chr02 VARCHAR(100),
    IN p_ext_chr03 VARCHAR(100),
    IN p_ext_chr04 VARCHAR(100),
    IN p_ext_chr05 VARCHAR(100),
    IN p_ext_chr06 VARCHAR(100),
    IN p_ext_chr07 VARCHAR(100),
    IN p_ext_chr08 VARCHAR(100),
    IN p_ext_chr09 VARCHAR(100),
    IN p_ext_chr10 VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_CODE
    SET EXT_CHR01 = IFNULL(p_ext_chr01, ''),
        EXT_CHR02 = IFNULL(p_ext_chr02, ''),
        EXT_CHR03 = IFNULL(p_ext_chr03, ''),
        EXT_CHR04 = IFNULL(p_ext_chr04, ''),
        EXT_CHR05 = IFNULL(p_ext_chr05, ''),
        EXT_CHR06 = IFNULL(p_ext_chr06, ''),
        EXT_CHR07 = IFNULL(p_ext_chr07, ''),
        EXT_CHR08 = IFNULL(p_ext_chr08, ''),
        EXT_CHR09 = IFNULL(p_ext_chr09, ''),
        EXT_CHR10 = IFNULL(p_ext_chr10, ''),
        CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND CODE_GRUP = p_code_grup
      AND CODE_CD = p_code_cd;
END//

-- ============================================================
-- 23. sp_code_update_ext_num: 확장 숫자 필드 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_code_update_ext_num//

CREATE PROCEDURE sp_code_update_ext_num(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(50),
    IN p_code_cd VARCHAR(50),
    IN p_ext_num01 VARCHAR(50),
    IN p_ext_num02 VARCHAR(50),
    IN p_ext_num03 VARCHAR(50),
    IN p_ext_num04 VARCHAR(50),
    IN p_ext_num05 VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_CODE
    SET EXT_NUM01 = IFNULL(NULLIF(p_ext_num01, ''), 0),
        EXT_NUM02 = IFNULL(NULLIF(p_ext_num02, ''), 0),
        EXT_NUM03 = IFNULL(NULLIF(p_ext_num03, ''), 0),
        EXT_NUM04 = IFNULL(NULLIF(p_ext_num04, ''), 0),
        EXT_NUM05 = IFNULL(NULLIF(p_ext_num05, ''), 0),
        CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND CODE_GRUP = p_code_grup
      AND CODE_CD = p_code_cd;
END//

DELIMITER ;
