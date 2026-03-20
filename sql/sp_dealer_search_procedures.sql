-- ============================================================
-- DealerSearch.xml -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- 딜러 검색 (DEAL_MAST) 관련
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 딜러 검색 (DEAL_MAST)
-- ============================================================

-- [sp_dealer_search] 딜러 목록 조회 (페이징 포함)
DROP PROCEDURE IF EXISTS sp_dealer_search//
CREATE PROCEDURE sp_dealer_search(
    IN p_sys_id VARCHAR(20),
    IN p_deal_code VARCHAR(50),
    IN p_char_bm VARCHAR(50),
    IN p_addr_cnty VARCHAR(50),
    IN p_serv_mgr VARCHAR(50),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;

    -- 동적 SQL 구성 (페이징 및 동적 조건)
    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.DEAL_STAT       AS DEAL_STAT,
                    A.END_DATE        AS END_DATE,
                    A.DEAL_CODE       AS DEAL_CODE,
                    A.SHIP_TO         AS SHIP_TO,
                    A.DEAL_NAME       AS DEAL_NAME,
                    A.ADDR_STR        AS ADDR_STR,
                    A.REPR_PERS       AS REPR_PERS,
                    A.ADDR_CITY       AS ADDR_CITY,
                    A.ADDR_REGN       AS ADDR_REGN,
                    A.POST_CODE       AS POST_CODE,
                    A.TEL_NO          AS TEL_NO,
                    A.FAX_NO          AS FAX_NO,
                    A.E_MAIL          AS E_MAIL,
                    A.CHAR_BM         AS CHAR_BM,
                    A.SERV_MGR        AS SERV_MGR,
                    A.SALE_GRUP       AS SALE_GRUP,
                    A.LS_SIGN         AS LS_SIGN,
                    A.LAB_RATE        AS LAB_RATE,
                    A.SIGN_FORM       AS SIGN_FORM,
                    A.CONT_MAIL_DATE  AS CONT_MAIL_DATE,
                    A.COOP_AD_AGR     AS COOP_AD_AGR,
                    A.CRE_DATE        AS CRE_DATE,
                    A.BRND_SOLD       AS BRND_SOLD,
                    A.CHNG_DATE       AS CHNG_DATE,
                    A.GE_CDF_NO       AS GE_CDF_NO,
                    A.WGO_IDX         AS WGO_IDX,
                    A.E_MAIL_RECV     AS E_MAIL_RECV
                FROM DEAL_MAST A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND (CASE WHEN '", IFNULL(p_deal_code,''), "' != '' THEN A.DEAL_CODE LIKE CONCAT('%', '", IFNULL(p_deal_code,''), "', '%') ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_char_bm,''), "' != '' THEN A.CHAR_BM = '", IFNULL(p_char_bm,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_addr_cnty,''), "' != '' THEN A.ADDR_CNTY = '", IFNULL(p_addr_cnty,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_serv_mgr,''), "' != '' THEN A.SERV_MGR = '", IFNULL(p_serv_mgr,''), "' ELSE 1=1 END)
                ORDER BY A.DEAL_CODE ASC
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 0), " ELSE 1=1 END)
    ) X
    WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)");

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//


-- [sp_dealer_search_count] 딜러 목록 카운트
DROP PROCEDURE IF EXISTS sp_dealer_search_count//
CREATE PROCEDURE sp_dealer_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_deal_code VARCHAR(50),
    IN p_char_bm VARCHAR(50),
    IN p_addr_cnty VARCHAR(50),
    IN p_serv_mgr VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM DEAL_MAST A
    WHERE A.SYS_ID = p_sys_id
      AND (CASE WHEN p_deal_code IS NOT NULL AND p_deal_code != '' THEN A.DEAL_CODE LIKE CONCAT('%', p_deal_code, '%') ELSE 1=1 END)
      AND (CASE WHEN p_char_bm IS NOT NULL AND p_char_bm != '' THEN A.CHAR_BM = p_char_bm ELSE 1=1 END)
      AND (CASE WHEN p_addr_cnty IS NOT NULL AND p_addr_cnty != '' THEN A.ADDR_CNTY = p_addr_cnty ELSE 1=1 END)
      AND (CASE WHEN p_serv_mgr IS NOT NULL AND p_serv_mgr != '' THEN A.SERV_MGR = p_serv_mgr ELSE 1=1 END);
END//

DELIMITER ;
