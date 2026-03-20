-- ============================================================
-- ExcelInfo Stored Procedures
-- 생성일: 2026-01-15
-- 설명: SYS_EXCEL_INFO 테이블 관련 프로시저
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. sp_excelinfo_get_select_excel_group
-- 설명: 엑셀 그룹 목록 조회 (DISTINCT FILE_NM)
-- ============================================================
-- AS-IS:
--     SELECT DISTINCT FILE_NM AS fileNm
--       FROM SYS_EXCEL_INFO
--      WHERE SYS_ID = #{sysId}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_excelinfo_get_select_excel_group//
CREATE PROCEDURE sp_excelinfo_get_select_excel_group(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT DISTINCT FILE_NM AS fileNm
      FROM SYS_EXCEL_INFO
     WHERE SYS_ID = p_sys_id;
END//

-- ============================================================
-- 2. sp_excelinfo_search
-- 설명: 엑셀 정보 목록 조회 (페이징 포함)
-- ============================================================
-- AS-IS:
--     SELECT X.*
--       FROM (
--             SELECT Z1.*, @rownum := @rownum+1 as RNUM
--               FROM (
--                     SELECT A.SYS_ID AS "sysId"
--                           ,A.FILE_NM AS "fileNm"
--                           ,A.SEQ AS "seq"
--                           ,A.VIEW_NO AS "viewNo"
--                           ,A.COL_LVL AS "colLvl"
--                           ,A.COL_VAL AS "colVal"
--                           ,A.STYLE AS "align"
--                       FROM SYS_EXCEL_INFO A
--                      WHERE SYS_ID = #{sysId}
--                        AND FILE_NM = #{s_fileNm} (optional)
--                      ORDER BY gsSorts or default
--                    ) Z1, (SELECT @rownum:=0) Z2
--            ) X
--      WHERE RNUM < #{end}
--        AND RNUM >= #{start}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_excelinfo_search//
CREATE PROCEDURE sp_excelinfo_search(
    IN p_sys_id   VARCHAR(20),
    IN p_file_nm  VARCHAR(200),
    IN p_start    INT,
    IN p_end      INT,
    IN p_sort_str TEXT
)
BEGIN
    -- 정렬 조건 설정 (gsSorts -> p_sort_str)
    SET @sort_order = IF(p_sort_str IS NOT NULL AND p_sort_str != '', p_sort_str, 'A.FILE_NM DESC, CAST(A.VIEW_NO AS UNSIGNED)');

    SET @rownum := 0;

    -- 동적 SQL 구성
    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT A.SYS_ID   AS sysId
                      ,A.FILE_NM  AS fileNm
                      ,A.SEQ      AS seq
                      ,A.VIEW_NO  AS viewNo
                      ,A.COL_LVL  AS colLvl
                      ,A.COL_VAL  AS colVal
                      ,A.STYLE    AS align
                  FROM SYS_EXCEL_INFO A
                 WHERE A.SYS_ID = '", p_sys_id, "'
                   AND (CASE WHEN '", IFNULL(p_file_nm,''), "' != '' THEN A.FILE_NM = '", IFNULL(p_file_nm,''), "' ELSE 1=1 END)
                 ORDER BY ", @sort_order, "
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 0), " ELSE 1=1 END)
    ) X
    WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)");

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 3. sp_excelinfo_search_count
-- 설명: 엑셀 정보 건수 조회
-- ============================================================
-- AS-IS:
--     SELECT COUNT(1)
--       FROM SYS_EXCEL_INFO A
--      WHERE SYS_ID = #{sysId}
--        AND FILE_NM = #{s_fileNm} (optional)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_excelinfo_search_count//
CREATE PROCEDURE sp_excelinfo_search_count(
    IN p_sys_id  VARCHAR(20),
    IN p_file_nm VARCHAR(200)
)
BEGIN
    IF p_file_nm IS NOT NULL AND p_file_nm != '' THEN
        SELECT COUNT(1) AS cnt
          FROM SYS_EXCEL_INFO A
         WHERE A.SYS_ID = p_sys_id
           AND A.FILE_NM = p_file_nm;
    ELSE
        SELECT COUNT(1) AS cnt
          FROM SYS_EXCEL_INFO A
         WHERE A.SYS_ID = p_sys_id;
    END IF;
END//

-- ============================================================
-- 4. sp_excelinfo_select
-- 설명: 엑셀 정보 상세 조회
-- ============================================================
-- AS-IS:
--     SELECT A.SYS_ID AS "sysId"
--           ,A.FILE_NM AS "fileNm"
--           ,A.SEQ AS "seq"
--           ,A.VIEW_NO AS "viewNo"
--           ,A.COL_LVL AS "colLvl"
--           ,A.COL_VAL AS "colVal"
--           ,A.STYLE AS "align"
--       FROM SYS_EXCEL_INFO A
--      WHERE SYS_ID = #{sysId}
--        AND FILE_NM = #{fileNm}
--        AND SEQ = #{seq}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_excelinfo_select//
CREATE PROCEDURE sp_excelinfo_select(
    IN p_sys_id  VARCHAR(20),
    IN p_file_nm VARCHAR(200),
    IN p_seq     INT
)
BEGIN
    SELECT A.SYS_ID   AS sysId
          ,A.FILE_NM  AS fileNm
          ,A.SEQ      AS seq
          ,A.VIEW_NO  AS viewNo
          ,A.COL_LVL  AS colLvl
          ,A.COL_VAL  AS colVal
          ,A.STYLE    AS align
      FROM SYS_EXCEL_INFO A
     WHERE A.SYS_ID  = p_sys_id
       AND A.FILE_NM = p_file_nm
       AND A.SEQ     = p_seq;
END//

-- ============================================================
-- 5. sp_excelinfo_insert
-- 설명: 엑셀 정보 등록 (SEQ 자동 채번)
-- ============================================================
-- AS-IS:
--     <selectKey>
--         SELECT IFNULL(MAX(seq),0) +1 AS "seq"
--           FROM SYS_EXCEL_INFO
--          WHERE SYS_ID = #{sysId}
--            AND FILE_NM = #{fileNm}
--     </selectKey>
--     INSERT INTO SYS_EXCEL_INFO
--          ( SYS_ID, SEQ, FILE_NM, VIEW_NO, COL_LVL, COL_VAL, STYLE,
--            USE_IDX, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE )
--     VALUES
--          ( #{sysId}, #{seq}, #{fileNm}, #{viewNo}, #{colLvl}, #{colVal},
--            #{align}, 'Y', #{gsUserId}, NOW(), #{gsUserId}, NOW() )
-- ============================================================
DROP PROCEDURE IF EXISTS sp_excelinfo_insert//
CREATE PROCEDURE sp_excelinfo_insert(
    IN p_sys_id   VARCHAR(20),
    IN p_file_nm  VARCHAR(200),
    IN p_view_no  VARCHAR(20),
    IN p_col_lvl  VARCHAR(20),
    IN p_col_val  VARCHAR(500),
    IN p_align    VARCHAR(20),
    IN p_user_id  VARCHAR(50)
)
BEGIN
    DECLARE v_seq INT;

    -- SEQ 자동 채번 (기존 selectKey 로직)
    SELECT IFNULL(MAX(SEQ), 0) + 1 INTO v_seq
      FROM SYS_EXCEL_INFO
     WHERE SYS_ID  = p_sys_id
       AND FILE_NM = p_file_nm;

    -- INSERT 실행
    INSERT INTO SYS_EXCEL_INFO
         ( SYS_ID
         , SEQ
         , FILE_NM
         , VIEW_NO
         , COL_LVL
         , COL_VAL
         , STYLE
         , USE_IDX
         , REGI_ID
         , REGI_DATE
         , CHNG_ID
         , CHNG_DATE
         )
    VALUES
         ( p_sys_id
         , v_seq
         , p_file_nm
         , p_view_no
         , p_col_lvl
         , p_col_val
         , p_align
         , 'Y'
         , p_user_id
         , NOW()
         , p_user_id
         , NOW()
         );

    -- 생성된 SEQ 반환
    SELECT v_seq AS seq;
END//

-- ============================================================
-- 6. sp_excelinfo_update
-- 설명: 엑셀 정보 수정
-- ============================================================
-- AS-IS:
--     UPDATE SYS_EXCEL_INFO
--        SET VIEW_NO   = #{viewNo}
--          , COL_LVL   = #{colLvl}
--          , COL_VAL   = #{colVal}
--          , STYLE     = #{align}
--          , CHNG_ID   = #{gsUserId}
--          , CHNG_DATE = NOW()
--      WHERE SYS_ID  = #{sysId}
--        AND FILE_NM = #{fileNm}
--        AND SEQ     = #{seq}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_excelinfo_update//
CREATE PROCEDURE sp_excelinfo_update(
    IN p_sys_id   VARCHAR(20),
    IN p_file_nm  VARCHAR(200),
    IN p_seq      INT,
    IN p_view_no  VARCHAR(20),
    IN p_col_lvl  VARCHAR(20),
    IN p_col_val  VARCHAR(500),
    IN p_align    VARCHAR(20),
    IN p_user_id  VARCHAR(50)
)
BEGIN
    UPDATE SYS_EXCEL_INFO
       SET VIEW_NO   = p_view_no
         , COL_LVL   = p_col_lvl
         , COL_VAL   = p_col_val
         , STYLE     = p_align
         , CHNG_ID   = p_user_id
         , CHNG_DATE = NOW()
     WHERE SYS_ID  = p_sys_id
       AND FILE_NM = p_file_nm
       AND SEQ     = p_seq;

    -- 영향받은 행 수 반환
    SELECT ROW_COUNT() AS affected_rows;
END//

-- ============================================================
-- 7. sp_excelinfo_delete
-- 설명: 엑셀 정보 삭제
-- ============================================================
-- AS-IS:
--     DELETE FROM SYS_EXCEL_INFO
--      WHERE SYS_ID  = #{sysId}
--        AND FILE_NM = #{fileNm}
--        AND SEQ     = #{seq}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_excelinfo_delete//
CREATE PROCEDURE sp_excelinfo_delete(
    IN p_sys_id  VARCHAR(20),
    IN p_file_nm VARCHAR(200),
    IN p_seq     INT
)
BEGIN
    DELETE FROM SYS_EXCEL_INFO
     WHERE SYS_ID  = p_sys_id
       AND FILE_NM = p_file_nm
       AND SEQ     = p_seq;

    -- 영향받은 행 수 반환
    SELECT ROW_COUNT() AS affected_rows;
END//

DELIMITER ;
