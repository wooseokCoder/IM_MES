-- ============================================================
-- Program3 Stored Procedures
-- Source: Program3.xml (com.wsc.common.user3.Program3)
-- Generated: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. Program Management (SYS_PROG)
-- ============================================================

-- ------------------------------------------------------------
-- [search] Program List Search with Pagination
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_search//
CREATE PROCEDURE sp_program3_search(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_progName VARCHAR(200),
    IN p_progType VARCHAR(10),
    IN p_sysLoc VARCHAR(200),
    IN p_useFlag VARCHAR(1),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1),
    IN p_sortStr VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- Session variables for pagination
    SET @rownum := 0;
    SET @sql := CONCAT('
        SELECT *
        FROM (
            SELECT X.*
            FROM (
                SELECT Z1.*, @rownum := @rownum+1 as RNUM
                FROM (
                    SELECT
                        A.SYS_ID        AS "sysId",
                        A.PROG_ID       AS "progId",
                        A.TRAN_A        AS "tranA",
                        A.TRAN_C        AS "tranC",
                        A.TRAN_R        AS "tranR",
                        A.TRAN_U        AS "tranU",
                        A.TRAN_D        AS "tranD",
                        A.TRAN_P        AS "tranP",
                        A.TRAN_S        AS "tranS",
                        A.TRAN_1        AS "tran1",
                        A.TRAN_2        AS "tran2",
                        A.TRAN_3        AS "tran3",
                        A.TRAN_4        AS "tran4",
                        A.TRAN_5        AS "tran5",
                        A.REGI_ID       AS "regiId",
                        DATE_FORMAT(A.REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS "regiDate",
                        A.CHNG_ID       AS "chngId",
                        DATE_FORMAT(A.CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS "chngDate",
                        A.PROG_NAME     AS "progName",
                        A.PROG_TYPE     AS "progType",
                        A.SYS_LOC       AS "sysLoc",
                        A.USE_FLAG      AS "useFlag",
                        A.PROG_ID       AS "progId2"
                    FROM SYS_PROG A
                    WHERE A.SYS_ID = ?');

    -- Dynamic WHERE conditions
    IF p_progId IS NOT NULL AND p_progId != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.PROG_ID LIKE CONCAT(''%'', ?, ''%'')');
    END IF;
    IF p_progName IS NOT NULL AND p_progName != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.PROG_NAME LIKE CONCAT(''%'', ?, ''%'')');
    END IF;
    IF p_progType IS NOT NULL AND p_progType != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.PROG_TYPE = ?');
    END IF;
    IF p_sysLoc IS NOT NULL AND p_sysLoc != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.SYS_LOC = ?');
    END IF;
    IF p_useFlag IS NOT NULL AND p_useFlag != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.USE_FLAG = ?');
    END IF;
    IF p_tranA IS NOT NULL AND p_tranA != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_A = ?');
    END IF;
    IF p_tranC IS NOT NULL AND p_tranC != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_C = ?');
    END IF;
    IF p_tranR IS NOT NULL AND p_tranR != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_R = ?');
    END IF;
    IF p_tranU IS NOT NULL AND p_tranU != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_U = ?');
    END IF;
    IF p_tranD IS NOT NULL AND p_tranD != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_D = ?');
    END IF;
    IF p_tranP IS NOT NULL AND p_tranP != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_P = ?');
    END IF;
    IF p_tranS IS NOT NULL AND p_tranS != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_S = ?');
    END IF;
    IF p_tran1 IS NOT NULL AND p_tran1 != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_1 = ?');
    END IF;
    IF p_tran2 IS NOT NULL AND p_tran2 != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_2 = ?');
    END IF;
    IF p_tran3 IS NOT NULL AND p_tran3 != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_3 = ?');
    END IF;
    IF p_tran4 IS NOT NULL AND p_tran4 != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_4 = ?');
    END IF;
    IF p_tran5 IS NOT NULL AND p_tran5 != '' THEN
        SET @sql := CONCAT(@sql, ' AND A.TRAN_5 = ?');
    END IF;

    -- ORDER BY clause
    SET @sql := CONCAT(@sql, ' ORDER BY ');
    IF p_sortStr IS NOT NULL AND p_sortStr != '' THEN
        SET @sql := CONCAT(@sql, p_sortStr);
    ELSE
        SET @sql := CONCAT(@sql, 'A.REGI_DATE DESC, A.CHNG_DATE DESC');
    END IF;

    -- Close pagination wrapper
    SET @sql := CONCAT(@sql, '
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE RNUM < ?
        ) X
        WHERE RNUM >= ?');

    -- Build parameter binding
    SET @p_sysId := p_sysId;
    SET @p_progId := p_progId;
    SET @p_progName := p_progName;
    SET @p_progType := p_progType;
    SET @p_sysLoc := p_sysLoc;
    SET @p_useFlag := p_useFlag;
    SET @p_tranA := p_tranA;
    SET @p_tranC := p_tranC;
    SET @p_tranR := p_tranR;
    SET @p_tranU := p_tranU;
    SET @p_tranD := p_tranD;
    SET @p_tranP := p_tranP;
    SET @p_tranS := p_tranS;
    SET @p_tran1 := p_tran1;
    SET @p_tran2 := p_tran2;
    SET @p_tran3 := p_tran3;
    SET @p_tran4 := p_tran4;
    SET @p_tran5 := p_tran5;
    SET @p_end := p_end;
    SET @p_start := p_start;

    PREPARE stmt FROM @sql;

    -- Execute with appropriate number of parameters based on conditions
    -- Simplified: use direct query instead of dynamic SQL for actual implementation
    SELECT *
    FROM (
        SELECT X.*
        FROM (
            SELECT Z1.*, @rownum := @rownum+1 as RNUM
            FROM (
                SELECT
                    A.SYS_ID        AS `sysId`,
                    A.PROG_ID       AS `progId`,
                    A.TRAN_A        AS `tranA`,
                    A.TRAN_C        AS `tranC`,
                    A.TRAN_R        AS `tranR`,
                    A.TRAN_U        AS `tranU`,
                    A.TRAN_D        AS `tranD`,
                    A.TRAN_P        AS `tranP`,
                    A.TRAN_S        AS `tranS`,
                    A.TRAN_1        AS `tran1`,
                    A.TRAN_2        AS `tran2`,
                    A.TRAN_3        AS `tran3`,
                    A.TRAN_4        AS `tran4`,
                    A.TRAN_5        AS `tran5`,
                    A.REGI_ID       AS `regiId`,
                    DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS `regiDate`,
                    A.CHNG_ID       AS `chngId`,
                    DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS `chngDate`,
                    A.PROG_NAME     AS `progName`,
                    A.PROG_TYPE     AS `progType`,
                    A.SYS_LOC       AS `sysLoc`,
                    A.USE_FLAG      AS `useFlag`,
                    A.PROG_ID       AS `progId2`,
                    CASE WHEN p_start IS NULL OR p_end IS NULL THEN 0 ELSE NULL END AS `RNUM_PLACEHOLDER`
                FROM SYS_PROG A
                WHERE A.SYS_ID = p_sysId
                  AND (p_progId IS NULL OR p_progId = '' OR A.PROG_ID LIKE CONCAT('%', p_progId, '%'))
                  AND (p_progName IS NULL OR p_progName = '' OR A.PROG_NAME LIKE CONCAT('%', p_progName, '%'))
                  AND (p_progType IS NULL OR p_progType = '' OR A.PROG_TYPE = p_progType)
                  AND (p_sysLoc IS NULL OR p_sysLoc = '' OR A.SYS_LOC = p_sysLoc)
                  AND (p_useFlag IS NULL OR p_useFlag = '' OR A.USE_FLAG = p_useFlag)
                  AND (p_tranA IS NULL OR p_tranA = '' OR A.TRAN_A = p_tranA)
                  AND (p_tranC IS NULL OR p_tranC = '' OR A.TRAN_C = p_tranC)
                  AND (p_tranR IS NULL OR p_tranR = '' OR A.TRAN_R = p_tranR)
                  AND (p_tranU IS NULL OR p_tranU = '' OR A.TRAN_U = p_tranU)
                  AND (p_tranD IS NULL OR p_tranD = '' OR A.TRAN_D = p_tranD)
                  AND (p_tranP IS NULL OR p_tranP = '' OR A.TRAN_P = p_tranP)
                  AND (p_tranS IS NULL OR p_tranS = '' OR A.TRAN_S = p_tranS)
                  AND (p_tran1 IS NULL OR p_tran1 = '' OR A.TRAN_1 = p_tran1)
                  AND (p_tran2 IS NULL OR p_tran2 = '' OR A.TRAN_2 = p_tran2)
                  AND (p_tran3 IS NULL OR p_tran3 = '' OR A.TRAN_3 = p_tran3)
                  AND (p_tran4 IS NULL OR p_tran4 = '' OR A.TRAN_4 = p_tran4)
                  AND (p_tran5 IS NULL OR p_tran5 = '' OR A.TRAN_5 = p_tran5)
                ORDER BY
                    CASE WHEN p_sortStr IS NULL OR p_sortStr = '' THEN A.REGI_DATE END DESC,
                    CASE WHEN p_sortStr IS NULL OR p_sortStr = '' THEN A.CHNG_DATE END DESC
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE p_end IS NULL OR RNUM < p_end
    ) X
    WHERE p_start IS NULL OR RNUM >= p_start;

END//

-- ------------------------------------------------------------
-- [searchCount] Program Count
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_search_count//
CREATE PROCEDURE sp_program3_search_count(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_progName VARCHAR(200),
    IN p_progType VARCHAR(10),
    IN p_sysLoc VARCHAR(200),
    IN p_useFlag VARCHAR(1),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_PROG A
    WHERE A.SYS_ID = p_sysId
      AND (p_progId IS NULL OR p_progId = '' OR A.PROG_ID LIKE CONCAT('%', p_progId, '%'))
      AND (p_progName IS NULL OR p_progName = '' OR A.PROG_NAME LIKE CONCAT('%', p_progName, '%'))
      AND (p_progType IS NULL OR p_progType = '' OR A.PROG_TYPE = p_progType)
      AND (p_sysLoc IS NULL OR p_sysLoc = '' OR A.SYS_LOC = p_sysLoc)
      AND (p_useFlag IS NULL OR p_useFlag = '' OR A.USE_FLAG = p_useFlag)
      AND (p_tranA IS NULL OR p_tranA = '' OR A.TRAN_A = p_tranA)
      AND (p_tranC IS NULL OR p_tranC = '' OR A.TRAN_C = p_tranC)
      AND (p_tranR IS NULL OR p_tranR = '' OR A.TRAN_R = p_tranR)
      AND (p_tranU IS NULL OR p_tranU = '' OR A.TRAN_U = p_tranU)
      AND (p_tranD IS NULL OR p_tranD = '' OR A.TRAN_D = p_tranD)
      AND (p_tranP IS NULL OR p_tranP = '' OR A.TRAN_P = p_tranP)
      AND (p_tranS IS NULL OR p_tranS = '' OR A.TRAN_S = p_tranS)
      AND (p_tran1 IS NULL OR p_tran1 = '' OR A.TRAN_1 = p_tran1)
      AND (p_tran2 IS NULL OR p_tran2 = '' OR A.TRAN_2 = p_tran2)
      AND (p_tran3 IS NULL OR p_tran3 = '' OR A.TRAN_3 = p_tran3)
      AND (p_tran4 IS NULL OR p_tran4 = '' OR A.TRAN_4 = p_tran4)
      AND (p_tran5 IS NULL OR p_tran5 = '' OR A.TRAN_5 = p_tran5);
END//

-- ------------------------------------------------------------
-- [select] Program Detail Select
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_select//
CREATE PROCEDURE sp_program3_select(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100)
)
BEGIN
    SELECT
        A.SYS_ID        AS `sysId`,
        A.PROG_ID       AS `progId`,
        A.TRAN_A        AS `tranA`,
        A.TRAN_C        AS `tranC`,
        A.TRAN_R        AS `tranR`,
        A.TRAN_U        AS `tranU`,
        A.TRAN_D        AS `tranD`,
        A.TRAN_P        AS `tranP`,
        A.TRAN_S        AS `tranS`,
        A.TRAN_1        AS `tran1`,
        A.TRAN_2        AS `tran2`,
        A.TRAN_3        AS `tran3`,
        A.TRAN_4        AS `tran4`,
        A.TRAN_5        AS `tran5`,
        A.REGI_ID       AS `regiId`,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS `regiDate`,
        A.CHNG_ID       AS `chngId`,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS `chngDate`,
        A.PROG_NAME     AS `progName`,
        A.PROG_TYPE     AS `progType`,
        A.SYS_LOC       AS `sysLoc`,
        A.USE_FLAG      AS `useFlag`,
        A.PROG_ID       AS `progId2`
    FROM SYS_PROG A
    WHERE A.SYS_ID = p_sysId
      AND A.PROG_ID = p_progId;
END//

-- ------------------------------------------------------------
-- [insert] Program Insert
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_insert//
CREATE PROCEDURE sp_program3_insert(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_progName VARCHAR(200),
    IN p_progType VARCHAR(10),
    IN p_sysLoc VARCHAR(200),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_PROG (
        SYS_ID,
        PROG_ID,
        PROG_NAME,
        USE_FLAG,
        PROG_TYPE,
        SYS_LOC,
        TRAN_A,
        TRAN_C,
        TRAN_R,
        TRAN_U,
        TRAN_D,
        TRAN_P,
        TRAN_S,
        TRAN_1,
        TRAN_2,
        TRAN_3,
        TRAN_4,
        TRAN_5,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_sysId,
        p_progId,
        p_progName,
        'Y',
        CASE WHEN p_progType IS NOT NULL AND p_progType != '' THEN p_progType ELSE NULL END,
        CASE WHEN p_sysLoc IS NOT NULL AND p_sysLoc != '' THEN p_sysLoc ELSE NULL END,
        CASE WHEN p_tranA IS NOT NULL AND p_tranA != '' THEN p_tranA ELSE NULL END,
        CASE WHEN p_tranC IS NOT NULL AND p_tranC != '' THEN p_tranC ELSE NULL END,
        CASE WHEN p_tranR IS NOT NULL AND p_tranR != '' THEN p_tranR ELSE NULL END,
        CASE WHEN p_tranU IS NOT NULL AND p_tranU != '' THEN p_tranU ELSE NULL END,
        CASE WHEN p_tranD IS NOT NULL AND p_tranD != '' THEN p_tranD ELSE NULL END,
        CASE WHEN p_tranP IS NOT NULL AND p_tranP != '' THEN p_tranP ELSE NULL END,
        CASE WHEN p_tranS IS NOT NULL AND p_tranS != '' THEN p_tranS ELSE NULL END,
        CASE WHEN p_tran1 IS NOT NULL AND p_tran1 != '' THEN p_tran1 ELSE NULL END,
        CASE WHEN p_tran2 IS NOT NULL AND p_tran2 != '' THEN p_tran2 ELSE NULL END,
        CASE WHEN p_tran3 IS NOT NULL AND p_tran3 != '' THEN p_tran3 ELSE NULL END,
        CASE WHEN p_tran4 IS NOT NULL AND p_tran4 != '' THEN p_tran4 ELSE NULL END,
        CASE WHEN p_tran5 IS NOT NULL AND p_tran5 != '' THEN p_tran5 ELSE NULL END,
        p_gsUserId,
        NOW(),
        p_gsUserId,
        NOW()
    );
END//

-- ------------------------------------------------------------
-- [update] Program Update
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_update//
CREATE PROCEDURE sp_program3_update(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_progName VARCHAR(200),
    IN p_progType VARCHAR(10),
    IN p_sysLoc VARCHAR(200),
    IN p_useFlag VARCHAR(1),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    UPDATE SYS_PROG
    SET CHNG_ID = p_gsUserId,
        CHNG_DATE = NOW(),
        PROG_NAME = CASE WHEN p_progName IS NOT NULL AND p_progName != '' THEN p_progName ELSE PROG_NAME END,
        PROG_TYPE = CASE WHEN p_progType IS NOT NULL AND p_progType != '' THEN p_progType ELSE PROG_TYPE END,
        SYS_LOC = CASE WHEN p_sysLoc IS NOT NULL AND p_sysLoc != '' THEN p_sysLoc ELSE SYS_LOC END,
        USE_FLAG = CASE WHEN p_useFlag IS NOT NULL AND p_useFlag != '' THEN p_useFlag ELSE USE_FLAG END,
        TRAN_A = CASE WHEN p_tranA IS NOT NULL AND p_tranA != '' THEN p_tranA ELSE TRAN_A END,
        TRAN_C = CASE WHEN p_tranC IS NOT NULL AND p_tranC != '' THEN p_tranC ELSE TRAN_C END,
        TRAN_R = CASE WHEN p_tranR IS NOT NULL AND p_tranR != '' THEN p_tranR ELSE TRAN_R END,
        TRAN_U = CASE WHEN p_tranU IS NOT NULL AND p_tranU != '' THEN p_tranU ELSE TRAN_U END,
        TRAN_D = CASE WHEN p_tranD IS NOT NULL AND p_tranD != '' THEN p_tranD ELSE TRAN_D END,
        TRAN_P = CASE WHEN p_tranP IS NOT NULL AND p_tranP != '' THEN p_tranP ELSE TRAN_P END,
        TRAN_S = CASE WHEN p_tranS IS NOT NULL AND p_tranS != '' THEN p_tranS ELSE TRAN_S END,
        TRAN_1 = CASE WHEN p_tran1 IS NOT NULL AND p_tran1 != '' THEN p_tran1 ELSE TRAN_1 END,
        TRAN_2 = CASE WHEN p_tran2 IS NOT NULL AND p_tran2 != '' THEN p_tran2 ELSE TRAN_2 END,
        TRAN_3 = CASE WHEN p_tran3 IS NOT NULL AND p_tran3 != '' THEN p_tran3 ELSE TRAN_3 END,
        TRAN_4 = CASE WHEN p_tran4 IS NOT NULL AND p_tran4 != '' THEN p_tran4 ELSE TRAN_4 END,
        TRAN_5 = CASE WHEN p_tran5 IS NOT NULL AND p_tran5 != '' THEN p_tran5 ELSE TRAN_5 END
    WHERE SYS_ID = p_sysId
      AND PROG_ID = p_progId;
END//

-- ------------------------------------------------------------
-- [delete] Program Delete
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_delete//
CREATE PROCEDURE sp_program3_delete(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100)
)
BEGIN
    DELETE FROM SYS_PROG
    WHERE SYS_ID = p_sysId
      AND PROG_ID = p_progId;
END//

-- ============================================================
-- 2. Group Program Management (SYS_GPGM)
-- ============================================================

-- ------------------------------------------------------------
-- [searchGroupProgram] Group Program List Search with Pagination
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_search_group_program//
CREATE PROCEDURE sp_program3_search_group_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_groupId VARCHAR(50),
    IN p_sortStr VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;

    SELECT *
    FROM (
        SELECT X.*
        FROM (
            SELECT Z1.*, @rownum := @rownum+1 as RNUM
            FROM (
                SELECT
                    A.SYS_ID        AS `sysId`,
                    A.PROG_ID       AS `progId`,
                    A.TRAN_A        AS `tranA`,
                    A.TRAN_C        AS `tranC`,
                    A.TRAN_R        AS `tranR`,
                    A.TRAN_U        AS `tranU`,
                    A.TRAN_D        AS `tranD`,
                    A.TRAN_P        AS `tranP`,
                    A.TRAN_S        AS `tranS`,
                    A.TRAN_1        AS `tran1`,
                    A.TRAN_2        AS `tran2`,
                    A.TRAN_3        AS `tran3`,
                    A.TRAN_4        AS `tran4`,
                    A.TRAN_5        AS `tran5`,
                    A.REGI_ID       AS `regiId`,
                    DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS `regiDate`,
                    A.CHNG_ID       AS `chngId`,
                    DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS `chngDate`,
                    A.GROUP_ID      AS `groupId`,
                    (SELECT GROUP_NAME FROM SYS_GRUP WHERE SYS_ID = A.SYS_ID AND GROUP_ID = A.GROUP_ID) AS `groupName`,
                    (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS `progName`,
                    A.PROG_ID       AS `progId2`
                FROM SYS_GPGM A
                WHERE A.SYS_ID = p_sysId
                  AND (p_progId IS NULL OR p_progId = '' OR A.PROG_ID = p_progId)
                  AND (p_groupId IS NULL OR p_groupId = '' OR A.GROUP_ID = p_groupId)
                ORDER BY
                    CASE WHEN p_sortStr IS NULL OR p_sortStr = '' THEN A.REGI_DATE END DESC,
                    CASE WHEN p_sortStr IS NULL OR p_sortStr = '' THEN A.CHNG_DATE END DESC
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE p_end IS NULL OR RNUM < p_end
    ) X
    WHERE p_start IS NULL OR RNUM >= p_start;
END//

-- ------------------------------------------------------------
-- [searchGroupProgramCount] Group Program Count
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_search_group_program_count//
CREATE PROCEDURE sp_program3_search_group_program_count(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_groupId VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_GPGM A
    WHERE A.SYS_ID = p_sysId
      AND (p_progId IS NULL OR p_progId = '' OR A.PROG_ID = p_progId)
      AND (p_groupId IS NULL OR p_groupId = '' OR A.GROUP_ID = p_groupId);
END//

-- ------------------------------------------------------------
-- [selectGroupProgram] Group Program Detail Select
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_select_group_program//
CREATE PROCEDURE sp_program3_select_group_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_groupId VARCHAR(50),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1)
)
BEGIN
    SELECT
        A.SYS_ID        AS `sysId`,
        A.PROG_ID       AS `progId`,
        A.TRAN_A        AS `tranA`,
        A.TRAN_C        AS `tranC`,
        A.TRAN_R        AS `tranR`,
        A.TRAN_U        AS `tranU`,
        A.TRAN_D        AS `tranD`,
        A.TRAN_P        AS `tranP`,
        A.TRAN_S        AS `tranS`,
        A.TRAN_1        AS `tran1`,
        A.TRAN_2        AS `tran2`,
        A.TRAN_3        AS `tran3`,
        A.TRAN_4        AS `tran4`,
        A.TRAN_5        AS `tran5`,
        A.REGI_ID       AS `regiId`,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS `regiDate`,
        A.CHNG_ID       AS `chngId`,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS `chngDate`,
        A.GROUP_ID      AS `groupId`,
        (SELECT GROUP_NAME FROM SYS_GRUP WHERE SYS_ID = A.SYS_ID AND GROUP_ID = A.GROUP_ID) AS `groupName`,
        (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS `progName`,
        A.PROG_ID       AS `progId2`
    FROM SYS_GPGM A
    WHERE SYS_ID = p_sysId
      AND PROG_ID = p_progId
      AND GROUP_ID = p_groupId
      AND (p_tranA IS NULL OR p_tranA = '' OR TRAN_A = p_tranA)
      AND (p_tranC IS NULL OR p_tranC = '' OR TRAN_C = p_tranC)
      AND (p_tranR IS NULL OR p_tranR = '' OR TRAN_R = p_tranR)
      AND (p_tranU IS NULL OR p_tranU = '' OR TRAN_U = p_tranU)
      AND (p_tranD IS NULL OR p_tranD = '' OR TRAN_D = p_tranD)
      AND (p_tranP IS NULL OR p_tranP = '' OR TRAN_P = p_tranP)
      AND (p_tranS IS NULL OR p_tranS = '' OR TRAN_S = p_tranS)
      AND (p_tran1 IS NULL OR p_tran1 = '' OR TRAN_1 = p_tran1)
      AND (p_tran2 IS NULL OR p_tran2 = '' OR TRAN_2 = p_tran2)
      AND (p_tran3 IS NULL OR p_tran3 = '' OR TRAN_3 = p_tran3)
      AND (p_tran4 IS NULL OR p_tran4 = '' OR TRAN_4 = p_tran4)
      AND (p_tran5 IS NULL OR p_tran5 = '' OR TRAN_5 = p_tran5);
END//

-- ------------------------------------------------------------
-- [insertGroupProgram] Group Program Insert
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_insert_group_program//
CREATE PROCEDURE sp_program3_insert_group_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_groupId VARCHAR(50),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_GPGM (
        GROUP_ID,
        SYS_ID,
        PROG_ID,
        TRAN_A,
        TRAN_C,
        TRAN_R,
        TRAN_U,
        TRAN_D,
        TRAN_P,
        TRAN_S,
        TRAN_1,
        TRAN_2,
        TRAN_3,
        TRAN_4,
        TRAN_5,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_groupId,
        p_sysId,
        p_progId,
        CASE WHEN p_tranA IS NOT NULL AND p_tranA != '' THEN p_tranA ELSE NULL END,
        CASE WHEN p_tranC IS NOT NULL AND p_tranC != '' THEN p_tranC ELSE NULL END,
        CASE WHEN p_tranR IS NOT NULL AND p_tranR != '' THEN p_tranR ELSE NULL END,
        CASE WHEN p_tranU IS NOT NULL AND p_tranU != '' THEN p_tranU ELSE NULL END,
        CASE WHEN p_tranD IS NOT NULL AND p_tranD != '' THEN p_tranD ELSE NULL END,
        CASE WHEN p_tranP IS NOT NULL AND p_tranP != '' THEN p_tranP ELSE NULL END,
        CASE WHEN p_tranS IS NOT NULL AND p_tranS != '' THEN p_tranS ELSE NULL END,
        CASE WHEN p_tran1 IS NOT NULL AND p_tran1 != '' THEN p_tran1 ELSE NULL END,
        CASE WHEN p_tran2 IS NOT NULL AND p_tran2 != '' THEN p_tran2 ELSE NULL END,
        CASE WHEN p_tran3 IS NOT NULL AND p_tran3 != '' THEN p_tran3 ELSE NULL END,
        CASE WHEN p_tran4 IS NOT NULL AND p_tran4 != '' THEN p_tran4 ELSE NULL END,
        CASE WHEN p_tran5 IS NOT NULL AND p_tran5 != '' THEN p_tran5 ELSE NULL END,
        p_gsUserId,
        NOW(),
        p_gsUserId,
        NOW()
    );
END//

-- ------------------------------------------------------------
-- [updateGroupProgram] Group Program Update
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_update_group_program//
CREATE PROCEDURE sp_program3_update_group_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_groupId VARCHAR(50),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    UPDATE SYS_GPGM
    SET CHNG_ID = p_gsUserId,
        CHNG_DATE = NOW(),
        TRAN_A = CASE WHEN p_tranA IS NOT NULL AND p_tranA != '' THEN p_tranA ELSE TRAN_A END,
        TRAN_C = CASE WHEN p_tranC IS NOT NULL AND p_tranC != '' THEN p_tranC ELSE TRAN_C END,
        TRAN_R = CASE WHEN p_tranR IS NOT NULL AND p_tranR != '' THEN p_tranR ELSE TRAN_R END,
        TRAN_U = CASE WHEN p_tranU IS NOT NULL AND p_tranU != '' THEN p_tranU ELSE TRAN_U END,
        TRAN_D = CASE WHEN p_tranD IS NOT NULL AND p_tranD != '' THEN p_tranD ELSE TRAN_D END,
        TRAN_P = CASE WHEN p_tranP IS NOT NULL AND p_tranP != '' THEN p_tranP ELSE TRAN_P END,
        TRAN_S = CASE WHEN p_tranS IS NOT NULL AND p_tranS != '' THEN p_tranS ELSE TRAN_S END,
        TRAN_1 = CASE WHEN p_tran1 IS NOT NULL AND p_tran1 != '' THEN p_tran1 ELSE TRAN_1 END,
        TRAN_2 = CASE WHEN p_tran2 IS NOT NULL AND p_tran2 != '' THEN p_tran2 ELSE TRAN_2 END,
        TRAN_3 = CASE WHEN p_tran3 IS NOT NULL AND p_tran3 != '' THEN p_tran3 ELSE TRAN_3 END,
        TRAN_4 = CASE WHEN p_tran4 IS NOT NULL AND p_tran4 != '' THEN p_tran4 ELSE TRAN_4 END,
        TRAN_5 = CASE WHEN p_tran5 IS NOT NULL AND p_tran5 != '' THEN p_tran5 ELSE TRAN_5 END
    WHERE SYS_ID = p_sysId
      AND PROG_ID = p_progId
      AND GROUP_ID = p_groupId;
END//

-- ------------------------------------------------------------
-- [deleteGroupProgram] Group Program Delete
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_delete_group_program//
CREATE PROCEDURE sp_program3_delete_group_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_groupId VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_GPGM
    WHERE SYS_ID = p_sysId
      AND PROG_ID = p_progId
      AND GROUP_ID = p_groupId;
END//

-- ============================================================
-- 3. User Program Management (SYS_UPGM)
-- ============================================================

-- ------------------------------------------------------------
-- [searchUserProgram] User Program List Search with Pagination
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_search_user_program//
CREATE PROCEDURE sp_program3_search_user_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_userId VARCHAR(50),
    IN p_sortStr VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;

    SELECT *
    FROM (
        SELECT X.*
        FROM (
            SELECT Z1.*, @rownum := @rownum+1 as RNUM
            FROM (
                SELECT
                    A.SYS_ID        AS `sysId`,
                    A.PROG_ID       AS `progId`,
                    A.TRAN_A        AS `tranA`,
                    A.TRAN_C        AS `tranC`,
                    A.TRAN_R        AS `tranR`,
                    A.TRAN_U        AS `tranU`,
                    A.TRAN_D        AS `tranD`,
                    A.TRAN_P        AS `tranP`,
                    A.TRAN_S        AS `tranS`,
                    A.TRAN_1        AS `tran1`,
                    A.TRAN_2        AS `tran2`,
                    A.TRAN_3        AS `tran3`,
                    A.TRAN_4        AS `tran4`,
                    A.TRAN_5        AS `tran5`,
                    A.REGI_ID       AS `regiId`,
                    DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS `regiDate`,
                    A.CHNG_ID       AS `chngId`,
                    DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS `chngDate`,
                    A.USER_ID       AS `userId`,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID) AS `userName`,
                    (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS `progName`,
                    A.PROG_ID       AS `progId2`
                FROM SYS_UPGM A
                WHERE A.SYS_ID = p_sysId
                  AND (p_progId IS NULL OR p_progId = '' OR A.PROG_ID = p_progId)
                  AND (p_userId IS NULL OR p_userId = '' OR A.USER_ID = p_userId)
                ORDER BY
                    CASE WHEN p_sortStr IS NULL OR p_sortStr = '' THEN A.REGI_DATE END DESC,
                    CASE WHEN p_sortStr IS NULL OR p_sortStr = '' THEN A.CHNG_DATE END DESC
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE p_end IS NULL OR RNUM < p_end
    ) X
    WHERE p_start IS NULL OR RNUM >= p_start;
END//

-- ------------------------------------------------------------
-- [searchUserProgramCount] User Program Count
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_search_user_program_count//
CREATE PROCEDURE sp_program3_search_user_program_count(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_userId VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_UPGM A
    WHERE A.SYS_ID = p_sysId
      AND (p_progId IS NULL OR p_progId = '' OR A.PROG_ID = p_progId)
      AND (p_userId IS NULL OR p_userId = '' OR A.USER_ID = p_userId);
END//

-- ------------------------------------------------------------
-- [selectUserProgram] User Program Detail Select
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_select_user_program//
CREATE PROCEDURE sp_program3_select_user_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_userId VARCHAR(50),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1)
)
BEGIN
    SELECT
        A.SYS_ID        AS `sysId`,
        A.PROG_ID       AS `progId`,
        A.TRAN_A        AS `tranA`,
        A.TRAN_C        AS `tranC`,
        A.TRAN_R        AS `tranR`,
        A.TRAN_U        AS `tranU`,
        A.TRAN_D        AS `tranD`,
        A.TRAN_P        AS `tranP`,
        A.TRAN_S        AS `tranS`,
        A.TRAN_1        AS `tran1`,
        A.TRAN_2        AS `tran2`,
        A.TRAN_3        AS `tran3`,
        A.TRAN_4        AS `tran4`,
        A.TRAN_5        AS `tran5`,
        A.REGI_ID       AS `regiId`,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS `regiDate`,
        A.CHNG_ID       AS `chngId`,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS `chngDate`,
        A.USER_ID       AS `userId`,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID) AS `userName`,
        (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS `progName`,
        A.PROG_ID       AS `progId2`
    FROM SYS_UPGM A
    WHERE SYS_ID = p_sysId
      AND PROG_ID = p_progId
      AND USER_ID = p_userId
      AND (p_tranA IS NULL OR p_tranA = '' OR TRAN_A = p_tranA)
      AND (p_tranC IS NULL OR p_tranC = '' OR TRAN_C = p_tranC)
      AND (p_tranR IS NULL OR p_tranR = '' OR TRAN_R = p_tranR)
      AND (p_tranU IS NULL OR p_tranU = '' OR TRAN_U = p_tranU)
      AND (p_tranD IS NULL OR p_tranD = '' OR TRAN_D = p_tranD)
      AND (p_tranP IS NULL OR p_tranP = '' OR TRAN_P = p_tranP)
      AND (p_tranS IS NULL OR p_tranS = '' OR TRAN_S = p_tranS)
      AND (p_tran1 IS NULL OR p_tran1 = '' OR TRAN_1 = p_tran1)
      AND (p_tran2 IS NULL OR p_tran2 = '' OR TRAN_2 = p_tran2)
      AND (p_tran3 IS NULL OR p_tran3 = '' OR TRAN_3 = p_tran3)
      AND (p_tran4 IS NULL OR p_tran4 = '' OR TRAN_4 = p_tran4)
      AND (p_tran5 IS NULL OR p_tran5 = '' OR TRAN_5 = p_tran5);
END//

-- ------------------------------------------------------------
-- [insertUserProgram] User Program Insert
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_insert_user_program//
CREATE PROCEDURE sp_program3_insert_user_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_userId VARCHAR(50),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_UPGM (
        USER_ID,
        SYS_ID,
        PROG_ID,
        TRAN_A,
        TRAN_C,
        TRAN_R,
        TRAN_U,
        TRAN_D,
        TRAN_P,
        TRAN_S,
        TRAN_1,
        TRAN_2,
        TRAN_3,
        TRAN_4,
        TRAN_5,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_userId,
        p_sysId,
        p_progId,
        CASE WHEN p_tranA IS NOT NULL AND p_tranA != '' THEN p_tranA ELSE NULL END,
        CASE WHEN p_tranC IS NOT NULL AND p_tranC != '' THEN p_tranC ELSE NULL END,
        CASE WHEN p_tranR IS NOT NULL AND p_tranR != '' THEN p_tranR ELSE NULL END,
        CASE WHEN p_tranU IS NOT NULL AND p_tranU != '' THEN p_tranU ELSE NULL END,
        CASE WHEN p_tranD IS NOT NULL AND p_tranD != '' THEN p_tranD ELSE NULL END,
        CASE WHEN p_tranP IS NOT NULL AND p_tranP != '' THEN p_tranP ELSE NULL END,
        CASE WHEN p_tranS IS NOT NULL AND p_tranS != '' THEN p_tranS ELSE NULL END,
        CASE WHEN p_tran1 IS NOT NULL AND p_tran1 != '' THEN p_tran1 ELSE NULL END,
        CASE WHEN p_tran2 IS NOT NULL AND p_tran2 != '' THEN p_tran2 ELSE NULL END,
        CASE WHEN p_tran3 IS NOT NULL AND p_tran3 != '' THEN p_tran3 ELSE NULL END,
        CASE WHEN p_tran4 IS NOT NULL AND p_tran4 != '' THEN p_tran4 ELSE NULL END,
        CASE WHEN p_tran5 IS NOT NULL AND p_tran5 != '' THEN p_tran5 ELSE NULL END,
        p_gsUserId,
        NOW(),
        p_gsUserId,
        NOW()
    );
END//

-- ------------------------------------------------------------
-- [updateUserProgram] User Program Update
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_update_user_program//
CREATE PROCEDURE sp_program3_update_user_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_userId VARCHAR(50),
    IN p_tranA VARCHAR(1),
    IN p_tranC VARCHAR(1),
    IN p_tranR VARCHAR(1),
    IN p_tranU VARCHAR(1),
    IN p_tranD VARCHAR(1),
    IN p_tranP VARCHAR(1),
    IN p_tranS VARCHAR(1),
    IN p_tran1 VARCHAR(1),
    IN p_tran2 VARCHAR(1),
    IN p_tran3 VARCHAR(1),
    IN p_tran4 VARCHAR(1),
    IN p_tran5 VARCHAR(1),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    UPDATE SYS_UPGM
    SET CHNG_ID = p_gsUserId,
        CHNG_DATE = NOW(),
        TRAN_A = CASE WHEN p_tranA IS NOT NULL AND p_tranA != '' THEN p_tranA ELSE TRAN_A END,
        TRAN_C = CASE WHEN p_tranC IS NOT NULL AND p_tranC != '' THEN p_tranC ELSE TRAN_C END,
        TRAN_R = CASE WHEN p_tranR IS NOT NULL AND p_tranR != '' THEN p_tranR ELSE TRAN_R END,
        TRAN_U = CASE WHEN p_tranU IS NOT NULL AND p_tranU != '' THEN p_tranU ELSE TRAN_U END,
        TRAN_D = CASE WHEN p_tranD IS NOT NULL AND p_tranD != '' THEN p_tranD ELSE TRAN_D END,
        TRAN_P = CASE WHEN p_tranP IS NOT NULL AND p_tranP != '' THEN p_tranP ELSE TRAN_P END,
        TRAN_S = CASE WHEN p_tranS IS NOT NULL AND p_tranS != '' THEN p_tranS ELSE TRAN_S END,
        TRAN_1 = CASE WHEN p_tran1 IS NOT NULL AND p_tran1 != '' THEN p_tran1 ELSE TRAN_1 END,
        TRAN_2 = CASE WHEN p_tran2 IS NOT NULL AND p_tran2 != '' THEN p_tran2 ELSE TRAN_2 END,
        TRAN_3 = CASE WHEN p_tran3 IS NOT NULL AND p_tran3 != '' THEN p_tran3 ELSE TRAN_3 END,
        TRAN_4 = CASE WHEN p_tran4 IS NOT NULL AND p_tran4 != '' THEN p_tran4 ELSE TRAN_4 END,
        TRAN_5 = CASE WHEN p_tran5 IS NOT NULL AND p_tran5 != '' THEN p_tran5 ELSE TRAN_5 END
    WHERE SYS_ID = p_sysId
      AND PROG_ID = p_progId
      AND USER_ID = p_userId;
END//

-- ------------------------------------------------------------
-- [deleteUserProgram] User Program Delete
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_delete_user_program//
CREATE PROCEDURE sp_program3_delete_user_program(
    IN p_sysId VARCHAR(20),
    IN p_progId VARCHAR(100),
    IN p_userId VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_UPGM
    WHERE SYS_ID = p_sysId
      AND PROG_ID = p_progId
      AND USER_ID = p_userId;
END//

-- ============================================================
-- 4. Security (Program Authorization View Query)
-- ============================================================

-- ------------------------------------------------------------
-- [selectSecurity] Program Security/Authorization Select
-- Based on V_SYS_AUTH view logic with priority: USER > GROUP > DEFAULT
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_program3_select_security//
CREATE PROCEDURE sp_program3_select_security(
    IN p_sysId VARCHAR(20),
    IN p_uri VARCHAR(200),
    IN p_userId VARCHAR(50)
)
BEGIN
    SET @vjob := '';
    SET @rownum := 0;

    SELECT
        A.SYS_ID   AS `sysId`,
        A.PROG_ID  AS `progId`,
        A.TRAN_A   AS `tranA`,
        A.TRAN_C   AS `tranC`,
        A.TRAN_R   AS `tranR`,
        A.TRAN_U   AS `tranU`,
        A.TRAN_D   AS `tranD`,
        A.TRAN_P   AS `tranP`,
        A.TRAN_S   AS `tranS`,
        A.TRAN_1   AS `tran1`,
        A.TRAN_2   AS `tran2`,
        A.TRAN_3   AS `tran3`,
        A.TRAN_4   AS `tran4`,
        A.TRAN_5   AS `tran5`,
        (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS `progName`,
        (SELECT MENU_KEY FROM SYS_MENU WHERE SYS_ID = A.SYS_ID AND MENU_URL = A.PROG_ID LIMIT 0, 1) AS `menuKey`
    FROM (
        SELECT x.sys_id, x.user_id,
               CASE x.auth_type
                    WHEN '10.USER'  THEN 'USER'
                    WHEN '20.GROUP' THEN 'GROUP'
                    ELSE 'DEFAULT'
               END AS auth_type,
               x.prog_id, x.tran_a, x.tran_c, x.tran_r, x.tran_u, x.tran_d,
               x.tran_p, x.tran_s, x.tran_1, x.tran_2, x.tran_3, x.tran_4,
               x.tran_5
        FROM (
            SELECT a.*
            FROM (
                SELECT (CASE @vjob WHEN a.prog_id THEN @rownum:=@rownum+1 ELSE @rownum:=1 END) auth_seq,
                       (@vjob:=a.prog_id) vjob,
                       a.*
                FROM (
                    -- USER authority (10.USER)
                    SELECT a.sys_id  AS sys_id,
                           a.user_id AS user_id,
                           '10.USER' AS auth_type,
                           a.prog_id AS prog_id,
                           a.tran_a  AS tran_a,
                           a.tran_c  AS tran_c,
                           a.tran_r  AS tran_r,
                           a.tran_u  AS tran_u,
                           a.tran_d  AS tran_d,
                           a.tran_p  AS tran_p,
                           a.tran_s  AS tran_s,
                           a.tran_1  AS tran_1,
                           a.tran_2  AS tran_2,
                           a.tran_3  AS tran_3,
                           a.tran_4  AS tran_4,
                           a.tran_5  AS tran_5
                    FROM sys_upgm a
                    WHERE a.sys_id = p_sysId
                      AND a.user_id = p_userId

                    UNION

                    -- GROUP authority (20.GROUP)
                    SELECT a.sys_id      AS sys_id,
                           b.user_id     AS user_id,
                           '20.GROUP'    AS auth_type,
                           a.prog_id     AS prog_id,
                           MAX(a.tran_a) AS tran_a,
                           MAX(a.tran_c) AS tran_c,
                           MAX(a.tran_r) AS tran_r,
                           MAX(a.tran_u) AS tran_u,
                           MAX(a.tran_d) AS tran_d,
                           MAX(a.tran_p) AS tran_p,
                           MAX(a.tran_s) AS tran_s,
                           MAX(a.tran_1) AS tran_1,
                           MAX(a.tran_2) AS tran_2,
                           MAX(a.tran_3) AS tran_3,
                           MAX(a.tran_4) AS tran_4,
                           MAX(a.tran_5) AS tran_5
                    FROM sys_gpgm a
                    JOIN sys_ugrp b ON a.sys_id = b.sys_id AND a.group_id = b.group_id
                    WHERE b.sys_id = p_sysId
                      AND b.user_id = p_userId
                    GROUP BY a.sys_id, b.user_id, a.prog_id

                    UNION

                    -- DEFAULT authority (30.DEFAULT)
                    SELECT a.sys_id  AS sys_id,
                           b.user_id AS user_id,
                           '30.DEFAULT' AS auth_type,
                           a.prog_id AS prog_id,
                           '0'       AS tran_a,
                           '0'       AS tran_c,
                           '0'       AS tran_r,
                           '0'       AS tran_u,
                           '0'       AS tran_d,
                           '0'       AS tran_p,
                           '0'       AS tran_s,
                           '0'       AS tran_1,
                           '0'       AS tran_2,
                           '0'       AS tran_3,
                           '0'       AS tran_4,
                           '0'       AS tran_5
                    FROM sys_prog a
                    JOIN sys_user b ON a.sys_id = b.sys_id
                    WHERE b.sys_id = p_sysId
                      AND b.user_id = p_userId
                ) a, (SELECT @vjob:='', @rownum:=0 FROM DUAL) b
                ORDER BY a.sys_id, a.user_id, a.prog_id, a.auth_type
            ) a
            WHERE a.auth_seq = 1
        ) x
    ) A
    WHERE A.SYS_ID = p_sysId
      AND A.PROG_ID = p_uri
      AND A.USER_ID = p_userId
      AND A.USER_ID = '3';
END//

DELIMITER ;

-- ============================================================
-- End of Program3 Stored Procedures
-- ============================================================
