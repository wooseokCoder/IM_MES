-- ============================================================
-- Loader.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 로더 폼 목록 조회 (페이징)
-- sortStr: 동적 정렬 문자열 (콤마 구분)
-- gsSorts가 있으면 해당 값으로 정렬, 없으면 기본 정렬(EXCL_GRUP, FORM_CODE)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_search//

CREATE PROCEDURE sp_loader_search(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_form_name VARCHAR(100),
    IN p_form_desc VARCHAR(200),
    IN p_title_no VARCHAR(10),
    IN p_start_no VARCHAR(10),
    IN p_pivot_yn VARCHAR(1),
    IN p_use_flag VARCHAR(1),
    IN p_sort_str VARCHAR(500),
    IN p_start VARCHAR(20),
    IN p_end VARCHAR(20)
)
BEGIN
    -- 정렬 조건: sortStr이 있으면 사용, 없으면 기본값
    SET @v_sort = IFNULL(NULLIF(p_sort_str, ''), 'EXCL_GRUP, FORM_CODE');

    SET @v_sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum+1 as RNUM
                FROM (
                    SELECT SYS_ID        AS \"sysId\"
                         , EXCL_GRUP     AS \"exclGrup\"
                         , FORM_CODE     AS \"formCode\"
                         , FORM_NAME     AS \"formName\"
                         , FORM_DESC     AS \"formDesc\"
                         , TITLE_NO      AS \"titleNo\"
                         , START_NO      AS \"startNo\"
                         , PIVOT_YN      AS \"pivotYn\"
                         , USE_FLAG      AS \"useFlag\"
                         , REGI_ID       AS \"regiId\"
                         , DATE_FORMAT(REGI_DATE,''%Y-%m-%d %H:%i:%s'') AS \"regiDate\"
                         , CHNG_ID       AS \"chngId\"
                         , DATE_FORMAT(CHNG_DATE,''%Y-%m-%d %H:%i:%s'') AS \"chngDate\"
                         , 0 AS \"rnum\"
                      FROM SYS_EXCL_FORM A
                     WHERE SYS_ID = ''', p_sys_id, '''
                       AND EXCL_GRUP = ''', p_excl_grup, '''
                       AND (''', IFNULL(p_form_code, ''), ''' = '''' OR FORM_CODE = ''', IFNULL(p_form_code, ''), ''')
                       AND (''', IFNULL(p_form_name, ''), ''' = '''' OR FORM_NAME LIKE CONCAT(''%'',''', IFNULL(p_form_name, ''), ''',''%''))
                       AND (''', IFNULL(p_form_desc, ''), ''' = '''' OR FORM_DESC LIKE CONCAT(''%'',''', IFNULL(p_form_desc, ''), ''',''%''))
                       AND (''', IFNULL(p_title_no, ''), ''' = '''' OR TITLE_NO = ''', IFNULL(p_title_no, ''), ''')
                       AND (''', IFNULL(p_start_no, ''), ''' = '''' OR START_NO = ''', IFNULL(p_start_no, ''), ''')
                       AND (''', IFNULL(p_pivot_yn, ''), ''' = '''' OR PIVOT_YN = ''', IFNULL(p_pivot_yn, ''), ''')
                       AND (''', IFNULL(p_use_flag, ''), ''' = '''' OR USE_FLAG = ''', IFNULL(p_use_flag, ''), ''')
                     ORDER BY ', @v_sort, '
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE (''', IFNULL(p_end, ''), ''' = '''' OR RNUM < ', IFNULL(NULLIF(p_end, ''), '999999'), ')
        ) X
        WHERE (''', IFNULL(p_start, ''), ''' = '''' OR RNUM >= ', IFNULL(NULLIF(p_start, ''), '0'), ')
    ');

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 2. 로더 폼 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_search_count//

CREATE PROCEDURE sp_loader_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_form_name VARCHAR(100),
    IN p_form_desc VARCHAR(200),
    IN p_title_no VARCHAR(10),
    IN p_start_no VARCHAR(10),
    IN p_pivot_yn VARCHAR(1),
    IN p_use_flag VARCHAR(1)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_EXCL_FORM A
    WHERE SYS_ID = p_sys_id
      AND EXCL_GRUP = p_excl_grup
      AND (p_form_code IS NULL OR p_form_code = '' OR FORM_CODE = p_form_code)
      AND (p_form_name IS NULL OR p_form_name = '' OR FORM_NAME LIKE CONCAT('%', p_form_name, '%'))
      AND (p_form_desc IS NULL OR p_form_desc = '' OR FORM_DESC LIKE CONCAT('%', p_form_desc, '%'))
      AND (p_title_no IS NULL OR p_title_no = '' OR TITLE_NO = p_title_no)
      AND (p_start_no IS NULL OR p_start_no = '' OR START_NO = p_start_no)
      AND (p_pivot_yn IS NULL OR p_pivot_yn = '' OR PIVOT_YN = p_pivot_yn)
      AND (p_use_flag IS NULL OR p_use_flag = '' OR USE_FLAG = p_use_flag);
END//

-- ============================================================
-- 3. 로더 폼 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_select//

CREATE PROCEDURE sp_loader_select(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50)
)
BEGIN
    SELECT
        SYS_ID AS "sysId",
        EXCL_GRUP AS "exclGrup",
        FORM_CODE AS "formCode",
        FORM_NAME AS "formName",
        FORM_DESC AS "formDesc",
        TITLE_NO AS "titleNo",
        START_NO AS "startNo",
        PIVOT_YN AS "pivotYn",
        USE_FLAG AS "useFlag",
        REGI_ID AS "regiId",
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS "regiDate",
        CHNG_ID AS "chngId",
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS "chngDate"
    FROM SYS_EXCL_FORM A
    WHERE SYS_ID = p_sys_id
      AND EXCL_GRUP = p_excl_grup
      AND FORM_CODE = p_form_code;
END//

-- ============================================================
-- 4. 로더 폼 등록
-- NULLIF 패턴: 빈문자열이면 NULL로 변환
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_insert//

CREATE PROCEDURE sp_loader_insert(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_form_name VARCHAR(100),
    IN p_form_desc VARCHAR(200),
    IN p_title_no VARCHAR(10),
    IN p_start_no VARCHAR(10),
    IN p_pivot_yn VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_EXCL_FORM (
        SYS_ID, EXCL_GRUP, FORM_CODE, FORM_NAME, USE_FLAG,
        REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE,
        FORM_DESC, TITLE_NO, START_NO, PIVOT_YN
    ) VALUES (
        p_sys_id,
        p_excl_grup,
        p_form_code,
        p_form_name,
        'Y',
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW(),
        NULLIF(p_form_desc, ''),
        NULLIF(p_title_no, ''),
        NULLIF(p_start_no, ''),
        NULLIF(p_pivot_yn, '')
    );
END//

-- ============================================================
-- 5. 로더 폼 수정
-- NULLIF 패턴: 빈문자열이면 NULL로 변환 후 IFNULL로 기존값 유지
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_update//

CREATE PROCEDURE sp_loader_update(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_form_name VARCHAR(100),
    IN p_form_desc VARCHAR(200),
    IN p_title_no VARCHAR(10),
    IN p_start_no VARCHAR(10),
    IN p_pivot_yn VARCHAR(1),
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_EXCL_FORM
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        FORM_NAME = IFNULL(NULLIF(p_form_name, ''), FORM_NAME),
        FORM_DESC = IFNULL(NULLIF(p_form_desc, ''), FORM_DESC),
        TITLE_NO = IFNULL(NULLIF(p_title_no, ''), TITLE_NO),
        START_NO = IFNULL(NULLIF(p_start_no, ''), START_NO),
        PIVOT_YN = IFNULL(NULLIF(p_pivot_yn, ''), PIVOT_YN),
        USE_FLAG = IFNULL(NULLIF(p_use_flag, ''), USE_FLAG)
    WHERE SYS_ID = p_sys_id
      AND EXCL_GRUP = p_excl_grup
      AND FORM_CODE = p_form_code;
END//

-- ============================================================
-- 6. 로더 폼 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_delete//

CREATE PROCEDURE sp_loader_delete(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_EXCL_FORM
    WHERE SYS_ID = p_sys_id
      AND EXCL_GRUP = p_excl_grup
      AND FORM_CODE = p_form_code;
END//

-- ============================================================
-- 7. 로더 아이템 목록 조회 (페이징)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_search_item//

CREATE PROCEDURE sp_loader_search_item(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_item_code VARCHAR(50),
    IN p_item_name VARCHAR(100),
    IN p_item_type VARCHAR(50),
    IN p_item_desc VARCHAR(200),
    IN p_item_def VARCHAR(200),
    IN p_item_seq VARCHAR(10),
    IN p_excl_code VARCHAR(50),
    IN p_use_flag VARCHAR(1),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;

    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
            FROM (
                SELECT
                    A.SYS_ID AS "sysId",
                    A.EXCL_GRUP AS "exclGrup",
                    A.FORM_CODE AS "formCode",
                    A.ITEM_CODE AS "itemCode",
                    A.ITEM_NAME AS "itemName",
                    A.ITEM_TYPE AS "itemType",
                    A.ITEM_DESC AS "itemDesc",
                    A.ITEM_DEF AS "itemDef",
                    A.ITEM_SEQ AS "itemSeq",
                    A.EXCL_CODE AS "exclCode",
                    A.USE_FLAG AS "useFlag",
                    A.REGI_ID AS "regiId",
                    DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS "regiDate",
                    A.CHNG_ID AS "chngId",
                    DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS "chngDate"
                FROM SYS_EXCL_ITEM A
                WHERE A.SYS_ID = p_sys_id
                  AND A.EXCL_GRUP = p_excl_grup
                  AND A.FORM_CODE = p_form_code
                  AND (p_item_code IS NULL OR p_item_code = '' OR A.ITEM_CODE = p_item_code)
                  AND (p_item_name IS NULL OR p_item_name = '' OR A.ITEM_NAME = p_item_name)
                  AND (p_item_type IS NULL OR p_item_type = '' OR A.ITEM_TYPE = p_item_type)
                  AND (p_item_desc IS NULL OR p_item_desc = '' OR A.ITEM_DESC = p_item_desc)
                  AND (p_item_def IS NULL OR p_item_def = '' OR A.ITEM_DEF = p_item_def)
                  AND (p_item_seq IS NULL OR p_item_seq = '' OR A.ITEM_SEQ = p_item_seq)
                  AND (p_excl_code IS NULL OR p_excl_code = '' OR A.EXCL_CODE = p_excl_code)
                  AND (p_use_flag IS NULL OR p_use_flag = '' OR A.USE_FLAG = p_use_flag)
                ORDER BY A.ITEM_SEQ, A.ITEM_CODE
            ) Z1
        ) X
        WHERE (p_end IS NULL OR RNUM < p_end)
    ) X
    WHERE (p_start IS NULL OR RNUM >= p_start);
END//

-- ============================================================
-- 8. 로더 아이템 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_search_item_count//

CREATE PROCEDURE sp_loader_search_item_count(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_item_code VARCHAR(50),
    IN p_item_name VARCHAR(100),
    IN p_item_type VARCHAR(50),
    IN p_item_desc VARCHAR(200),
    IN p_item_def VARCHAR(200),
    IN p_item_seq VARCHAR(10),
    IN p_excl_code VARCHAR(50),
    IN p_use_flag VARCHAR(1)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_EXCL_ITEM A
    WHERE A.SYS_ID = p_sys_id
      AND A.EXCL_GRUP = p_excl_grup
      AND A.FORM_CODE = p_form_code
      AND (p_item_code IS NULL OR p_item_code = '' OR A.ITEM_CODE = p_item_code)
      AND (p_item_name IS NULL OR p_item_name = '' OR A.ITEM_NAME = p_item_name)
      AND (p_item_type IS NULL OR p_item_type = '' OR A.ITEM_TYPE = p_item_type)
      AND (p_item_desc IS NULL OR p_item_desc = '' OR A.ITEM_DESC = p_item_desc)
      AND (p_item_def IS NULL OR p_item_def = '' OR A.ITEM_DEF = p_item_def)
      AND (p_item_seq IS NULL OR p_item_seq = '' OR A.ITEM_SEQ = p_item_seq)
      AND (p_excl_code IS NULL OR p_excl_code = '' OR A.EXCL_CODE = p_excl_code)
      AND (p_use_flag IS NULL OR p_use_flag = '' OR A.USE_FLAG = p_use_flag);
END//

-- ============================================================
-- 9. 로더 아이템 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_select_item//

CREATE PROCEDURE sp_loader_select_item(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_item_code VARCHAR(50)
)
BEGIN
    SELECT
        A.SYS_ID AS "sysId",
        A.EXCL_GRUP AS "exclGrup",
        A.FORM_CODE AS "formCode",
        A.ITEM_CODE AS "itemCode",
        A.ITEM_NAME AS "itemName",
        A.ITEM_TYPE AS "itemType",
        A.ITEM_DESC AS "itemDesc",
        A.ITEM_DEF AS "itemDef",
        A.ITEM_SEQ AS "itemSeq",
        A.EXCL_CODE AS "exclCode",
        A.USE_FLAG AS "useFlag",
        A.REGI_ID AS "regiId",
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS "regiDate",
        A.CHNG_ID AS "chngId",
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS "chngDate"
    FROM SYS_EXCL_ITEM A
    WHERE A.SYS_ID = p_sys_id
      AND A.EXCL_GRUP = p_excl_grup
      AND A.FORM_CODE = p_form_code
      AND A.ITEM_CODE = p_item_code;
END//

-- ============================================================
-- 10. 로더 아이템 등록
-- NULLIF 패턴: 빈문자열이면 NULL로 변환
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_insert_item//

CREATE PROCEDURE sp_loader_insert_item(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_item_code VARCHAR(50),
    IN p_item_name VARCHAR(100),
    IN p_item_type VARCHAR(50),
    IN p_item_desc VARCHAR(200),
    IN p_item_def VARCHAR(200),
    IN p_item_seq VARCHAR(10),
    IN p_excl_code VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_EXCL_ITEM (
        SYS_ID, EXCL_GRUP, FORM_CODE, ITEM_CODE, ITEM_NAME,
        ITEM_TYPE, ITEM_DESC, ITEM_DEF, ITEM_SEQ, EXCL_CODE,
        USE_FLAG, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sys_id,
        p_excl_grup,
        p_form_code,
        p_item_code,
        p_item_name,
        NULLIF(p_item_type, ''),
        NULLIF(p_item_desc, ''),
        NULLIF(p_item_def, ''),
        NULLIF(p_item_seq, ''),
        NULLIF(p_excl_code, ''),
        'Y',
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 11. 로더 아이템 수정
-- NULLIF 패턴: 빈문자열이면 NULL로 변환 후 IFNULL로 기존값 유지
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_update_item//

CREATE PROCEDURE sp_loader_update_item(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_item_code VARCHAR(50),
    IN p_item_name VARCHAR(100),
    IN p_item_type VARCHAR(50),
    IN p_item_desc VARCHAR(200),
    IN p_item_def VARCHAR(200),
    IN p_item_seq VARCHAR(10),
    IN p_excl_code VARCHAR(50),
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_EXCL_ITEM A
    SET A.CHNG_ID = p_gs_user_id,
        A.CHNG_DATE = NOW(),
        A.ITEM_NAME = IFNULL(NULLIF(p_item_name, ''), A.ITEM_NAME),
        A.ITEM_TYPE = IFNULL(NULLIF(p_item_type, ''), A.ITEM_TYPE),
        A.ITEM_DESC = IFNULL(NULLIF(p_item_desc, ''), A.ITEM_DESC),
        A.ITEM_DEF = IFNULL(NULLIF(p_item_def, ''), A.ITEM_DEF),
        A.ITEM_SEQ = IFNULL(NULLIF(p_item_seq, ''), A.ITEM_SEQ),
        A.EXCL_CODE = IFNULL(NULLIF(p_excl_code, ''), A.EXCL_CODE),
        A.USE_FLAG = IFNULL(NULLIF(p_use_flag, ''), A.USE_FLAG)
    WHERE A.SYS_ID = p_sys_id
      AND A.EXCL_GRUP = p_excl_grup
      AND A.FORM_CODE = p_form_code
      AND A.ITEM_CODE = p_item_code;
END//

-- ============================================================
-- 12. 로더 아이템 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_delete_item//

CREATE PROCEDURE sp_loader_delete_item(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50),
    IN p_item_code VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_EXCL_ITEM A
    WHERE A.SYS_ID = p_sys_id
      AND A.EXCL_GRUP = p_excl_grup
      AND A.FORM_CODE = p_form_code
      AND A.ITEM_CODE = p_item_code;
END//

-- ============================================================
-- 13. 로더 아이템 전체 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_delete_item_all//

CREATE PROCEDURE sp_loader_delete_item_all(
    IN p_sys_id VARCHAR(20),
    IN p_excl_grup VARCHAR(50),
    IN p_form_code VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_EXCL_ITEM A
    WHERE A.SYS_ID = p_sys_id
      AND A.EXCL_GRUP = p_excl_grup
      AND A.FORM_CODE = p_form_code;
END//

-- ============================================================
-- 14. 로더 콤보 검색
-- ============================================================
DROP PROCEDURE IF EXISTS sp_loader_search_combo//

CREATE PROCEDURE sp_loader_search_combo(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(50)
)
BEGIN
    SELECT
        SYS_ID AS "sysId",
        FORM_CODE AS "codeCd",
        FORM_NAME AS "codeName"
    FROM SYS_EXCL_FORM A
    WHERE SYS_ID = p_sys_id
      AND EXCL_GRUP = p_code_grup
      AND USE_FLAG = 'Y'
    ORDER BY FORM_NAME;
END//

DELIMITER ;
