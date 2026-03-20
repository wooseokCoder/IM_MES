-- ============================================================
-- Address.xml -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- 주소록 관리 (SYS_BORD_ADDR, SYS_BORD_GRUP, SYS_BORD_ITEM)
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 주소록 관리 (SYS_BORD_ADDR)
-- ============================================================

-- [sp_address_search] 주소록 목록 조회 (페이징, 동적 정렬)
DROP PROCEDURE IF EXISTS sp_address_search//
CREATE PROCEDURE sp_address_search(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50),
    IN p_tgt_user_name VARCHAR(100),
    IN p_tgt_user_rmk VARCHAR(200),
    IN p_tgt_vndr_code VARCHAR(20),
    IN p_tgt_vndr_name VARCHAR(100),
    IN p_sort_clause VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @sort_order = IF(p_sort_clause IS NOT NULL AND p_sort_clause != '', p_sort_clause, 'A.REGI_DATE DESC, A.CHNG_DATE DESC');
    SET @rownum := 0;

    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID        AS sysId,
                    A.BORD_GRUP     AS bordGrup,
                    A.USER_ID       AS userId,
                    A.REGI_ID       AS regiId,
                    DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
                    A.CHNG_ID       AS chngId,
                    DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
                    A.TGT_USER_ID   AS tgtUserId,
                    A.TGT_USER_NAME AS tgtUserName,
                    A.TGT_USER_RMK  AS tgtUserRmk,
                    A.TGT_VNDR_CODE AS tgtVndrCode,
                    A.TGT_VNDR_NAME AS tgtVndrName
                FROM SYS_BORD_ADDR A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND A.BORD_GRUP = '", p_bord_grup, "'
                  AND A.USER_ID = '", p_user_id, "'
                  AND (CASE WHEN '", IFNULL(p_tgt_user_id,''), "' != '' THEN A.TGT_USER_ID = '", IFNULL(p_tgt_user_id,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_tgt_user_name,''), "' != '' THEN A.TGT_USER_NAME = '", IFNULL(p_tgt_user_name,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_tgt_user_rmk,''), "' != '' THEN A.TGT_USER_RMK = '", IFNULL(p_tgt_user_rmk,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_tgt_vndr_code,''), "' != '' THEN A.TGT_VNDR_CODE = '", IFNULL(p_tgt_vndr_code,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_tgt_vndr_name,''), "' != '' THEN A.TGT_VNDR_NAME = '", IFNULL(p_tgt_vndr_name,''), "' ELSE 1=1 END)
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

-- [sp_address_search_count] 주소록 카운트
DROP PROCEDURE IF EXISTS sp_address_search_count//
CREATE PROCEDURE sp_address_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50),
    IN p_tgt_user_name VARCHAR(100),
    IN p_tgt_user_rmk VARCHAR(200),
    IN p_tgt_vndr_code VARCHAR(20),
    IN p_tgt_vndr_name VARCHAR(100)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_BORD_ADDR A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND A.USER_ID = p_user_id
      AND (CASE WHEN p_tgt_user_id IS NOT NULL AND p_tgt_user_id != '' THEN A.TGT_USER_ID = p_tgt_user_id ELSE 1=1 END)
      AND (CASE WHEN p_tgt_user_name IS NOT NULL AND p_tgt_user_name != '' THEN A.TGT_USER_NAME = p_tgt_user_name ELSE 1=1 END)
      AND (CASE WHEN p_tgt_user_rmk IS NOT NULL AND p_tgt_user_rmk != '' THEN A.TGT_USER_RMK = p_tgt_user_rmk ELSE 1=1 END)
      AND (CASE WHEN p_tgt_vndr_code IS NOT NULL AND p_tgt_vndr_code != '' THEN A.TGT_VNDR_CODE = p_tgt_vndr_code ELSE 1=1 END)
      AND (CASE WHEN p_tgt_vndr_name IS NOT NULL AND p_tgt_vndr_name != '' THEN A.TGT_VNDR_NAME = p_tgt_vndr_name ELSE 1=1 END);
END//

-- [sp_address_select] 주소록 단건 조회
DROP PROCEDURE IF EXISTS sp_address_select//
CREATE PROCEDURE sp_address_select(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.BORD_GRUP     AS bordGrup,
        A.USER_ID       AS userId,
        A.REGI_ID       AS regiId,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID       AS chngId,
        DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
        A.TGT_USER_ID   AS tgtUserId,
        A.TGT_USER_NAME AS tgtUserName,
        A.TGT_USER_RMK  AS tgtUserRmk,
        A.TGT_VNDR_CODE AS tgtVndrCode,
        A.TGT_VNDR_NAME AS tgtVndrName
    FROM SYS_BORD_ADDR A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND A.USER_ID = p_user_id
      AND A.TGT_USER_ID = p_tgt_user_id;
END//

-- [sp_address_insert] 주소록 등록
DROP PROCEDURE IF EXISTS sp_address_insert//
CREATE PROCEDURE sp_address_insert(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50),
    IN p_tgt_user_name VARCHAR(100),
    IN p_tgt_user_rmk VARCHAR(200),
    IN p_tgt_vndr_code VARCHAR(20),
    IN p_tgt_vndr_name VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_BORD_ADDR (
        SYS_ID, BORD_GRUP, USER_ID, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE,
        TGT_USER_ID, TGT_USER_NAME, TGT_USER_RMK, TGT_VNDR_CODE, TGT_VNDR_NAME
    ) VALUES (
        p_sys_id, p_bord_grup, p_user_id, p_gs_user_id, NOW(), p_gs_user_id, NOW(),
        p_tgt_user_id, p_tgt_user_name, p_tgt_user_rmk, p_tgt_vndr_code, p_tgt_vndr_name
    );
END//

-- [sp_address_update] 주소록 수정
DROP PROCEDURE IF EXISTS sp_address_update//
CREATE PROCEDURE sp_address_update(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50),
    IN p_tgt_user_name VARCHAR(100),
    IN p_tgt_user_rmk VARCHAR(200),
    IN p_tgt_vndr_code VARCHAR(20),
    IN p_tgt_vndr_name VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_ADDR
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        TGT_USER_NAME = IFNULL(p_tgt_user_name, TGT_USER_NAME),
        TGT_USER_RMK = IFNULL(p_tgt_user_rmk, TGT_USER_RMK),
        TGT_VNDR_CODE = IFNULL(p_tgt_vndr_code, TGT_VNDR_CODE),
        TGT_VNDR_NAME = IFNULL(p_tgt_vndr_name, TGT_VNDR_NAME)
    WHERE SYS_ID = p_sys_id
      AND BORD_GRUP = p_bord_grup
      AND USER_ID = p_user_id
      AND TGT_USER_ID = p_tgt_user_id;
END//

-- [sp_address_delete] 주소록 삭제
DROP PROCEDURE IF EXISTS sp_address_delete//
CREATE PROCEDURE sp_address_delete(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_BORD_ADDR
    WHERE SYS_ID = p_sys_id
      AND BORD_GRUP = p_bord_grup
      AND USER_ID = p_user_id
      AND TGT_USER_ID = p_tgt_user_id;
END//

-- ============================================================
-- 2. 그룹 관리 (SYS_BORD_GRUP)
-- ============================================================

-- [sp_address_search_group] 그룹 목록 조회 (페이징, 동적 정렬)
DROP PROCEDURE IF EXISTS sp_address_search_group//
CREATE PROCEDURE sp_address_search_group(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_tgt_grup_id VARCHAR(20),
    IN p_tgt_grup_name VARCHAR(100),
    IN p_sort_clause VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @sort_order = IF(p_sort_clause IS NOT NULL AND p_sort_clause != '', p_sort_clause, 'A.REGI_DATE DESC, A.CHNG_DATE DESC');
    SET @rownum := 0;

    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID        AS sysId,
                    A.BORD_GRUP     AS bordGrup,
                    A.USER_ID       AS userId,
                    A.REGI_ID       AS regiId,
                    DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
                    A.CHNG_ID       AS chngId,
                    DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
                    A.TGT_GRUP_ID   AS tgtGrupId,
                    A.TGT_GRUP_NAME AS tgtGrupName,
                    A.TGT_GRUP_RMK  AS tgtGrupRmk
                FROM SYS_BORD_GRUP A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND A.BORD_GRUP = '", p_bord_grup, "'
                  AND A.USER_ID = '", p_user_id, "'
                  AND (CASE WHEN '", IFNULL(p_tgt_grup_id,''), "' != '' THEN A.TGT_GRUP_ID = '", IFNULL(p_tgt_grup_id,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_tgt_grup_name,''), "' != '' THEN A.TGT_GRUP_NAME = '", IFNULL(p_tgt_grup_name,''), "' ELSE 1=1 END)
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

-- [sp_address_search_group_count] 그룹 카운트
DROP PROCEDURE IF EXISTS sp_address_search_group_count//
CREATE PROCEDURE sp_address_search_group_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_tgt_grup_id VARCHAR(20),
    IN p_tgt_grup_name VARCHAR(100)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_BORD_GRUP A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND A.USER_ID = p_user_id
      AND (CASE WHEN p_tgt_grup_id IS NOT NULL AND p_tgt_grup_id != '' THEN A.TGT_GRUP_ID = p_tgt_grup_id ELSE 1=1 END)
      AND (CASE WHEN p_tgt_grup_name IS NOT NULL AND p_tgt_grup_name != '' THEN A.TGT_GRUP_NAME = p_tgt_grup_name ELSE 1=1 END);
END//

-- [sp_address_select_group] 그룹 단건 조회
DROP PROCEDURE IF EXISTS sp_address_select_group//
CREATE PROCEDURE sp_address_select_group(
    IN p_sys_id VARCHAR(20),
    IN p_tgt_grup_id VARCHAR(20)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.BORD_GRUP     AS bordGrup,
        A.USER_ID       AS userId,
        A.REGI_ID       AS regiId,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID       AS chngId,
        DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
        A.TGT_GRUP_ID   AS tgtGrupId,
        A.TGT_GRUP_NAME AS tgtGrupName,
        A.TGT_GRUP_RMK  AS tgtGrupRmk
    FROM SYS_BORD_GRUP A
    WHERE A.SYS_ID = p_sys_id
      AND A.TGT_GRUP_ID = p_tgt_grup_id;
END//

-- [sp_address_insert_group] 그룹 등록 (PK 자동 생성 후 반환)
DROP PROCEDURE IF EXISTS sp_address_insert_group//
CREATE PROCEDURE sp_address_insert_group(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_tgt_grup_name VARCHAR(100),
    IN p_tgt_grup_rmk VARCHAR(200),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_tgt_grup_id VARCHAR(20);

    -- 자동 PK 생성: G000000001 형식
    SELECT CONCAT('G', LPAD(CAST(IFNULL(SUBSTR(MAX(TGT_GRUP_ID),2,9),'0') AS UNSIGNED)+1, 9, '0'))
      INTO v_tgt_grup_id
      FROM SYS_BORD_GRUP;

    INSERT INTO SYS_BORD_GRUP (
        SYS_ID, BORD_GRUP, USER_ID, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE,
        TGT_GRUP_ID, TGT_GRUP_NAME, TGT_GRUP_RMK
    ) VALUES (
        p_sys_id, p_bord_grup, p_user_id, p_gs_user_id, NOW(), p_gs_user_id, NOW(),
        v_tgt_grup_id, p_tgt_grup_name, p_tgt_grup_rmk
    );

    -- 생성된 그룹 ID 반환
    SELECT v_tgt_grup_id AS tgtGrupId;
END//

-- [sp_address_update_group] 그룹 수정
DROP PROCEDURE IF EXISTS sp_address_update_group//
CREATE PROCEDURE sp_address_update_group(
    IN p_sys_id VARCHAR(20),
    IN p_tgt_grup_id VARCHAR(20),
    IN p_tgt_grup_name VARCHAR(100),
    IN p_tgt_grup_rmk VARCHAR(200),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_GRUP
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        TGT_GRUP_NAME = IFNULL(p_tgt_grup_name, TGT_GRUP_NAME),
        TGT_GRUP_RMK = IFNULL(p_tgt_grup_rmk, TGT_GRUP_RMK)
    WHERE SYS_ID = p_sys_id
      AND TGT_GRUP_ID = p_tgt_grup_id;
END//

-- [sp_address_delete_group] 그룹 삭제
DROP PROCEDURE IF EXISTS sp_address_delete_group//
CREATE PROCEDURE sp_address_delete_group(
    IN p_sys_id VARCHAR(20),
    IN p_tgt_grup_id VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_BORD_GRUP
    WHERE SYS_ID = p_sys_id
      AND TGT_GRUP_ID = p_tgt_grup_id;
END//

-- ============================================================
-- 3. 그룹 아이템 관리 (SYS_BORD_ITEM)
-- ============================================================

-- [sp_address_search_group_item] 그룹 아이템 목록 조회 (페이징, 동적 정렬)
DROP PROCEDURE IF EXISTS sp_address_search_group_item//
CREATE PROCEDURE sp_address_search_group_item(
    IN p_sys_id VARCHAR(20),
    IN p_tgt_grup_id VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_sort_clause VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @sort_order = IF(p_sort_clause IS NOT NULL AND p_sort_clause != '', p_sort_clause, 'A.REGI_DATE DESC, A.CHNG_DATE DESC');
    SET @rownum := 0;

    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID        AS sysId,
                    A.REGI_ID       AS regiId,
                    DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
                    A.CHNG_ID       AS chngId,
                    DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
                    A.TGT_GRUP_ID   AS tgtGrupId,
                    A.TGT_USER_ID   AS tgtUserId,
                    A.TGT_USER_NAME AS tgtUserName,
                    A.TGT_VNDR_CODE AS tgtVndrCode,
                    A.TGT_VNDR_NAME AS tgtVndrName
                FROM SYS_BORD_ITEM A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND (CASE WHEN '", IFNULL(p_tgt_grup_id,''), "' != '' THEN A.TGT_GRUP_ID = '", IFNULL(p_tgt_grup_id,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_tgt_user_id,''), "' != '' THEN A.TGT_USER_ID = '", IFNULL(p_tgt_user_id,''), "' ELSE 1=1 END)
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

-- [sp_address_search_group_item_count] 그룹 아이템 카운트
DROP PROCEDURE IF EXISTS sp_address_search_group_item_count//
CREATE PROCEDURE sp_address_search_group_item_count(
    IN p_sys_id VARCHAR(20),
    IN p_tgt_grup_id VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_BORD_ITEM A
    WHERE A.SYS_ID = p_sys_id
      AND (CASE WHEN p_tgt_grup_id IS NOT NULL AND p_tgt_grup_id != '' THEN A.TGT_GRUP_ID = p_tgt_grup_id ELSE 1=1 END)
      AND (CASE WHEN p_tgt_user_id IS NOT NULL AND p_tgt_user_id != '' THEN A.TGT_USER_ID = p_tgt_user_id ELSE 1=1 END);
END//

-- [sp_address_select_group_item] 그룹 아이템 단건 조회
DROP PROCEDURE IF EXISTS sp_address_select_group_item//
CREATE PROCEDURE sp_address_select_group_item(
    IN p_sys_id VARCHAR(20),
    IN p_tgt_grup_id VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.REGI_ID       AS regiId,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID       AS chngId,
        DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
        A.TGT_GRUP_ID   AS tgtGrupId,
        A.TGT_USER_ID   AS tgtUserId,
        A.TGT_USER_NAME AS tgtUserName,
        A.TGT_VNDR_CODE AS tgtVndrCode,
        A.TGT_VNDR_NAME AS tgtVndrName
    FROM SYS_BORD_ITEM A
    WHERE A.SYS_ID = p_sys_id
      AND A.TGT_GRUP_ID = p_tgt_grup_id
      AND A.TGT_USER_ID = p_tgt_user_id;
END//

-- [sp_address_insert_group_item] 그룹 아이템 등록
DROP PROCEDURE IF EXISTS sp_address_insert_group_item//
CREATE PROCEDURE sp_address_insert_group_item(
    IN p_sys_id VARCHAR(20),
    IN p_tgt_grup_id VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_tgt_user_name VARCHAR(100),
    IN p_tgt_vndr_code VARCHAR(20),
    IN p_tgt_vndr_name VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_BORD_ITEM (
        SYS_ID, TGT_GRUP_ID, TGT_USER_ID, TGT_USER_NAME, TGT_VNDR_CODE, TGT_VNDR_NAME,
        REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sys_id, p_tgt_grup_id, p_tgt_user_id, p_tgt_user_name, p_tgt_vndr_code, p_tgt_vndr_name,
        p_gs_user_id, NOW(), p_gs_user_id, NOW()
    );
END//

-- [sp_address_update_group_item] 그룹 아이템 수정
DROP PROCEDURE IF EXISTS sp_address_update_group_item//
CREATE PROCEDURE sp_address_update_group_item(
    IN p_sys_id VARCHAR(20),
    IN p_tgt_grup_id VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_tgt_user_name VARCHAR(100),
    IN p_tgt_vndr_code VARCHAR(20),
    IN p_tgt_vndr_name VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_ITEM
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        TGT_USER_NAME = IFNULL(p_tgt_user_name, TGT_USER_NAME),
        TGT_VNDR_CODE = IFNULL(p_tgt_vndr_code, TGT_VNDR_CODE),
        TGT_VNDR_NAME = IFNULL(p_tgt_vndr_name, TGT_VNDR_NAME)
    WHERE SYS_ID = p_sys_id
      AND TGT_GRUP_ID = p_tgt_grup_id
      AND TGT_USER_ID = p_tgt_user_id;
END//

-- [sp_address_delete_group_item_all] 그룹 아이템 전체 삭제
DROP PROCEDURE IF EXISTS sp_address_delete_group_item_all//
CREATE PROCEDURE sp_address_delete_group_item_all(
    IN p_sys_id VARCHAR(20),
    IN p_tgt_grup_id VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_BORD_ITEM
    WHERE SYS_ID = p_sys_id
      AND TGT_GRUP_ID = p_tgt_grup_id;
END//

DELIMITER ;
