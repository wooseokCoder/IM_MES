-- ============================================================
-- BankSearch.xml (딜러 검색) -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- ============================================================

DELIMITER //

-- ============================================================
-- 딜러 검색 (DEAL_MAST)
-- ============================================================

-- [sp_bank_search_search] 딜러 목록 조회 (페이징)
DROP PROCEDURE IF EXISTS sp_bank_search_search//
CREATE PROCEDURE sp_bank_search_search(
    IN p_sys_id VARCHAR(20),
    IN p_deal_code VARCHAR(50),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;

    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.DEAL_STAT    AS dealStat,
                    A.END_DATE     AS endDate,
                    A.DEAL_CODE    AS dealCode,
                    A.SHIP_TO      AS shipTo,
                    A.DEAL_NAME    AS dealName,
                    A.ADDR_STR     AS addrStr,
                    A.REPR_PERS    AS reprPers,
                    A.ADDR_CITY    AS addrCity,
                    A.ADDR_REGN    AS addrRegn,
                    A.POST_CODE    AS postCode,
                    A.TEL_NO       AS telNo,
                    A.FAX_NO       AS faxNo,
                    A.E_MAIL       AS eMail,
                    A.CHAR_BM      AS charBm,
                    A.SERV_MGR     AS servMgr,
                    A.SALE_GRUP    AS saleGrup,
                    A.LS_SIGN      AS lsSign,
                    A.LAB_RATE     AS labRate,
                    A.SIGN_FORM    AS signForm,
                    A.CONT_MAIL_DATE AS contMailDate,
                    A.COOP_AD_AGR  AS coopAdAgr,
                    A.CRE_DATE     AS creDate,
                    A.BRND_SOLD    AS brndSold,
                    A.CHNG_DATE    AS chngDate,
                    A.GE_CDF_NO    AS geCdfNo,
                    A.WGO_IDX      AS wgoIdx,
                    A.E_MAIL_RECV  AS eMailRecv
                FROM DEAL_MAST A
                WHERE A.SYS_ID = p_sys_id
                  AND (CASE WHEN p_deal_code IS NOT NULL AND p_deal_code != ''
                            THEN (A.DEAL_CODE LIKE CONCAT('%', p_deal_code, '%')
                               OR A.DEAL_NAME LIKE CONCAT('%', p_deal_code, '%'))
                            ELSE 1=1 END)
                ORDER BY A.DEAL_CODE ASC
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE (CASE WHEN p_end IS NOT NULL THEN RNUM < p_end ELSE 1=1 END)
    ) X
    WHERE (CASE WHEN p_start IS NOT NULL THEN RNUM >= p_start ELSE 1=1 END);
END//

-- [sp_bank_search_search_count] 딜러 카운트
DROP PROCEDURE IF EXISTS sp_bank_search_search_count//
CREATE PROCEDURE sp_bank_search_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_deal_code VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM DEAL_MAST A
    WHERE A.SYS_ID = p_sys_id
      AND (CASE WHEN p_deal_code IS NOT NULL AND p_deal_code != ''
                THEN (A.DEAL_CODE LIKE CONCAT('%', p_deal_code, '%')
                   OR A.DEAL_NAME LIKE CONCAT('%', p_deal_code, '%'))
                ELSE 1=1 END);
END//

DELIMITER ;
