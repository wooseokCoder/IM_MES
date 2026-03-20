-- ============================================================
-- Exhibition Stored Procedures
-- 파일: sp_exhibition_procedures.sql
-- 설명: Exhibition 관련 프로시저 (search, searchCount, select, delete, getSelectCodeExhbn, getSelectCodeSortExhbn, searchCodeExhbn)
-- 생성일: 2026-01-14
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. sp_exhibition_search
-- 설명: 전시회 목록 조회 (페이징 포함)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_exhibition_search//

CREATE PROCEDURE sp_exhibition_search(
    IN p_sys_id VARCHAR(20),
    IN p_exhbn_code VARCHAR(50),
    IN p_exhbn_year VARCHAR(10),
    IN p_exhbn_active VARCHAR(1),
    IN p_start VARCHAR(20),
    IN p_end VARCHAR(20)
)
BEGIN
    SET @rownum := 0;

    IF p_start IS NOT NULL AND p_end IS NOT NULL THEN
        SELECT *
          FROM (
                SELECT X.*
                  FROM (
                        SELECT Z1.*, @rownum := @rownum+1 as RNUM
                          FROM (
                                SELECT SYS_ID            AS "sysId"
                                     , SEQ               AS "seq"
                                     , EXHBN_CODE        AS "exhbnCode"
                                     , EXHBN_YEAR        AS "exhbnYear"
                                     , EXHBN_NAME        AS "exhbnName"
                                     , DATE_FORMAT(EXHBN_BGN_DATE,'%m.%d.%Y') AS "exhbnBgnDate"
                                     , DATE_FORMAT(EXHBN_END_DATE,'%m.%d.%Y') AS "exhbnEndDate"
                                     , EXHBN_LOC         AS "exhbnLoc"
                                     , MAX_NUM           AS "maxNum"
                                     , COUPON_YN         AS "useFlag"
                                     , ACTIVE_YN         AS "activeYn"
                                     , FILE_NAME         AS "fileName"
                                     , USE_YN            AS "useYn"
                                     , REGI_ID           AS "regiId"
                                     , DATE_FORMAT(REGI_DATE,'%Y-%m-%d %H:%i:%s') AS "regiDate"
                                     , CHNG_ID           AS "chngId"
                                     , DATE_FORMAT(CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS "chngDate"
                                     , 0 AS "rnum"
                                  FROM EXHBN_MAST A
                                 WHERE SYS_ID = p_sys_id
                                   AND USE_YN = 'Y'
                                   AND (p_exhbn_code IS NULL OR p_exhbn_code = '' OR EXHBN_CODE LIKE CONCAT('%', p_exhbn_code, '%'))
                                   AND (p_exhbn_year IS NULL OR p_exhbn_year = '' OR EXHBN_YEAR = p_exhbn_year)
                                   AND (p_exhbn_active IS NULL OR p_exhbn_active = '' OR ACTIVE_YN = p_exhbn_active)
                                 ORDER BY SEQ
                               ) Z1
                       ) X
                 WHERE RNUM < p_end
               ) X
         WHERE RNUM >= p_start;
    ELSE
        SELECT SYS_ID            AS "sysId"
             , SEQ               AS "seq"
             , EXHBN_CODE        AS "exhbnCode"
             , EXHBN_YEAR        AS "exhbnYear"
             , EXHBN_NAME        AS "exhbnName"
             , DATE_FORMAT(EXHBN_BGN_DATE,'%m.%d.%Y') AS "exhbnBgnDate"
             , DATE_FORMAT(EXHBN_END_DATE,'%m.%d.%Y') AS "exhbnEndDate"
             , EXHBN_LOC         AS "exhbnLoc"
             , MAX_NUM           AS "maxNum"
             , COUPON_YN         AS "useFlag"
             , ACTIVE_YN         AS "activeYn"
             , FILE_NAME         AS "fileName"
             , USE_YN            AS "useYn"
             , REGI_ID           AS "regiId"
             , DATE_FORMAT(REGI_DATE,'%Y-%m-%d %H:%i:%s') AS "regiDate"
             , CHNG_ID           AS "chngId"
             , DATE_FORMAT(CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS "chngDate"
             , 0 AS "rnum"
          FROM EXHBN_MAST A
         WHERE SYS_ID = p_sys_id
           AND USE_YN = 'Y'
           AND (p_exhbn_code IS NULL OR p_exhbn_code = '' OR EXHBN_CODE LIKE CONCAT('%', p_exhbn_code, '%'))
           AND (p_exhbn_year IS NULL OR p_exhbn_year = '' OR EXHBN_YEAR = p_exhbn_year)
           AND (p_exhbn_active IS NULL OR p_exhbn_active = '' OR ACTIVE_YN = p_exhbn_active)
         ORDER BY SEQ;
    END IF;
END//

-- ============================================================
-- 2. sp_exhibition_search_count
-- 설명: 전시회 목록 건수 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_exhibition_search_count//

CREATE PROCEDURE sp_exhibition_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_exhbn_code VARCHAR(50),
    IN p_exhbn_year VARCHAR(10),
    IN p_exhbn_active VARCHAR(1)
)
BEGIN
    SELECT COUNT(1)
      FROM EXHBN_MAST
     WHERE SYS_ID = p_sys_id
       AND USE_YN = 'Y'
       AND (p_exhbn_code IS NULL OR p_exhbn_code = '' OR EXHBN_CODE LIKE CONCAT('%', p_exhbn_code, '%'))
       AND (p_exhbn_year IS NULL OR p_exhbn_year = '' OR EXHBN_YEAR = p_exhbn_year)
       AND (p_exhbn_active IS NULL OR p_exhbn_active = '' OR ACTIVE_YN = p_exhbn_active);
END//

-- ============================================================
-- 3. sp_exhibition_select
-- 설명: 전시회 상세 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_exhibition_select//

CREATE PROCEDURE sp_exhibition_select(
    IN p_sys_id VARCHAR(20),
    IN p_exhbn_code VARCHAR(50),
    IN p_exhbn_year VARCHAR(10),
    IN p_exhbn_active VARCHAR(1)
)
BEGIN
    SELECT SYS_ID            AS "sysId"
         , SEQ               AS "seq"
         , EXHBN_CODE        AS "exhbnCode"
         , EXHBN_YEAR        AS "exhbnYear"
         , EXHBN_NAME        AS "exhbnName"
         , DATE_FORMAT(EXHBN_BGN_DATE,'%m.%d.%Y') AS "exhbnBgnDate"
         , DATE_FORMAT(EXHBN_END_DATE,'%m.%d.%Y') AS "exhbnEndDate"
         , EXHBN_LOC         AS "exhbnLoc"
         , MAX_NUM           AS "maxNum"
         , COUPON_YN         AS "useFlag"
         , ACTIVE_YN         AS "activeYn"
         , FILE_NAME         AS "fileName"
         , USE_YN            AS "useYn"
         , REGI_ID           AS "regiId"
         , DATE_FORMAT(REGI_DATE,'%Y-%m-%d %H:%i:%s') AS "regiDate"
         , CHNG_ID           AS "chngId"
         , DATE_FORMAT(CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS "chngDate"
      FROM EXHBN_MAST
     WHERE SYS_ID = p_sys_id
       AND USE_YN = 'Y'
       AND (p_exhbn_code IS NULL OR p_exhbn_code = '' OR EXHBN_CODE = p_exhbn_code)
       AND (p_exhbn_year IS NULL OR p_exhbn_year = '' OR EXHBN_YEAR = p_exhbn_year)
       AND (p_exhbn_active IS NULL OR p_exhbn_active = '' OR ACTIVE_YN = p_exhbn_active)
     ORDER BY SEQ;
END//

-- ============================================================
-- 4. sp_exhibition_delete
-- 설명: 전시회 삭제 (논리적 삭제 - USE_YN을 'N'으로 변경)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_exhibition_delete//

CREATE PROCEDURE sp_exhibition_delete(
    IN p_sys_id VARCHAR(20),
    IN p_exhbn_code VARCHAR(50),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE EXHBN_MAST
       SET USE_YN = 'N'
         , EXHBN_CODE = CONCAT('DEL-', p_exhbn_code)
         , CHNG_ID = p_user_id
         , CHNG_DATE = NOW()
     WHERE SYS_ID = p_sys_id
       AND EXHBN_CODE = p_exhbn_code
       AND USE_YN = 'Y';
END//

-- ============================================================
-- 5. sp_exhibition_get_select_code
-- 설명: 전시회 선택 코드 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_exhibition_get_select_code//

CREATE PROCEDURE sp_exhibition_get_select_code(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT CODE_CD AS "codeCd"
         , CODE_NAME AS "codeName"
      FROM SYS_CODE
     WHERE CODE_GRUP = '0'
       AND SYS_ID = p_sys_id
       AND CODE_CD != '0'
       AND USE_FLAG = 'Y'
     ORDER BY SORT_SEQ;
END//

-- ============================================================
-- 6. sp_exhibition_get_select_code_sort
-- 설명: 전시회 정렬 코드 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_exhibition_get_select_code_sort//

CREATE PROCEDURE sp_exhibition_get_select_code_sort()
BEGIN
    SELECT CODE_CD AS "codeCd"
         , CODE_NAME AS "codeName"
      FROM SYS_CODE
     WHERE CODE_GRUP = 'CODE_SORT'
       AND USE_FLAG = 'Y'
     ORDER BY CODE_NAME ASC;
END//

-- ============================================================
-- 7. sp_exhibition_search_code
-- 설명: 전시회 코드 검색 (다국어 지원)
-- 주의: codeGrup은 동적 IN 절을 위해 문자열로 전달됨 (예: "'CODE1','CODE2'")
-- ============================================================
DROP PROCEDURE IF EXISTS sp_exhibition_search_code//

CREATE PROCEDURE sp_exhibition_search_code(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(500),
    IN p_lang VARCHAR(10)
)
BEGIN
    SET @sql = CONCAT('
        SELECT CODE_GRUP
             , CODE_CD
             , CASE WHEN ''', IFNULL(p_lang, ''), ''' = ''ko'' THEN CODE_NAME
                    WHEN ''', IFNULL(p_lang, ''), ''' = ''en'' THEN CODE_NAME_EN
                    WHEN ''', IFNULL(p_lang, ''), ''' = ''vi'' THEN CODE_NAME_VI
                    ELSE CODE_NAME
               END AS CODE_NAME
             , EXT_CHR01
             , SORT_SEQ
             , CODE_DESC
          FROM SYS_CODE
         WHERE SYS_ID = ''', p_sys_id, '''
           AND CODE_GRUP IN(', p_code_grup, ')
           AND USE_FLAG = ''Y''
         ORDER BY SORT_SEQ
    ');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//


DELIMITER ;
