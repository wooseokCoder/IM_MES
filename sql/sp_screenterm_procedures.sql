-- ============================================================
-- Screenterm.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- 수정일: 2026-01-14 (XML 매퍼와 호출 규격 통일)
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 화면 용어 목록 조회 (페이징)
-- sp_screenterm_search
-- ============================================================
DROP PROCEDURE IF EXISTS sp_screenterm_search//

CREATE PROCEDURE sp_screenterm_search(
    IN p_sys_id VARCHAR(20),
    IN p_item_grp_key VARCHAR(100),
    IN p_use_flag VARCHAR(10),
    IN p_item_id VARCHAR(50),
    IN p_item_nm VARCHAR(200),
    IN p_sort_str VARCHAR(500),
    IN p_start VARCHAR(20),
    IN p_end VARCHAR(20)
)
BEGIN
    SET @rownum := 0;

    -- 동적 정렬 처리
    SET @v_order_by = IFNULL(NULLIF(p_sort_str, ''), 'REGI_DATE');

    SET @sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
                FROM (
                    SELECT
                        SYS_ID AS sysId,
                        ITEM_GRP AS itemGrp,
                        ITEM_ID AS itemId,
                        ITEM_NM AS itemNm,
                        ITEM_NM_KOR AS itemNmKor,
                        ITEM_NM_ENG AS itemNmEng,
                        ITEM_NM_PORT AS itemNmPort,
                        ITEM_NM_VIET AS itemNmViet,
                        ITEM_NM_ETC AS itemNmEtc,
                        ITEM_DESC AS itemDesc,
                        ITEM_TYPE AS itemType,
                        ITEM_LEN AS itemLen,
                        ITEM_SCALE AS itemScale,
                        ITEM_ATR1 AS itemAtr1,
                        ITEM_ATR2 AS itemAtr2,
                        ITEM_ATR3 AS itemAtr3,
                        ITEM_REMK AS itemRemk,
                        USE_FLAG AS useFlag,
                        REGI_ID AS regiId,
                        DATE_FORMAT(REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate,
                        CHNG_ID AS chngId,
                        DATE_FORMAT(CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate
                    FROM SYS_DIC A
                    WHERE SYS_ID = ''', p_sys_id, '''');

    -- 조건절 추가
    IF p_item_grp_key IS NOT NULL AND p_item_grp_key != '' THEN
        IF p_item_grp_key = 'ALL' THEN
            SET @sql = CONCAT(@sql, '');
        ELSE
            SET @sql = CONCAT(@sql, ' AND ITEM_GRP = ''', p_item_grp_key, '''');
        END IF;
    END IF;

    IF p_use_flag IS NOT NULL AND p_use_flag != '' AND p_use_flag != 'ALL' THEN
        SET @sql = CONCAT(@sql, ' AND USE_FLAG = ''', p_use_flag, '''');
    END IF;

    IF p_item_id IS NOT NULL AND p_item_id != '' THEN
        SET @sql = CONCAT(@sql, ' AND ITEM_ID LIKE ''%', p_item_id, '%''');
    END IF;

    IF p_item_nm IS NOT NULL AND p_item_nm != '' THEN
        SET @sql = CONCAT(@sql, ' AND ITEM_NM LIKE ''%', p_item_nm, '%''');
    END IF;

    SET @sql = CONCAT(@sql, ' ORDER BY ', @v_order_by);
    SET @sql = CONCAT(@sql, ') Z1, (SELECT @rownum:=0) Z2) X');

    -- 페이징 처리
    IF p_end IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' WHERE RNUM < ', p_end);
    END IF;

    SET @sql = CONCAT(@sql, ') X');

    IF p_start IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' WHERE RNUM >= ', p_start);
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 2. 화면 용어 목록 카운트
-- sp_screenterm_search_count
-- ============================================================
DROP PROCEDURE IF EXISTS sp_screenterm_search_count//

CREATE PROCEDURE sp_screenterm_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_item_grp_key VARCHAR(100),
    IN p_use_flag VARCHAR(10),
    IN p_item_id VARCHAR(50),
    IN p_item_nm VARCHAR(200)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_DIC A
    WHERE SYS_ID = p_sys_id
      AND (p_item_grp_key IS NULL OR p_item_grp_key = '' OR
           ITEM_GRP = CASE WHEN p_item_grp_key = 'ALL' THEN ITEM_GRP ELSE p_item_grp_key END)
      AND (p_use_flag IS NULL OR p_use_flag = '' OR
           USE_FLAG = CASE WHEN p_use_flag = 'ALL' THEN USE_FLAG ELSE p_use_flag END)
      AND (p_item_id IS NULL OR p_item_id = '' OR ITEM_ID LIKE CONCAT('%', p_item_id, '%'))
      AND (p_item_nm IS NULL OR p_item_nm = '' OR ITEM_NM LIKE CONCAT('%', p_item_nm, '%'));
END//

-- ============================================================
-- 3. 화면 용어 단건 조회
-- sp_screenterm_select
-- ============================================================
DROP PROCEDURE IF EXISTS sp_screenterm_select//

CREATE PROCEDURE sp_screenterm_select(
    IN p_sys_id VARCHAR(20),
    IN p_item_grp VARCHAR(100),
    IN p_item_id VARCHAR(50)
)
BEGIN
    SELECT
        SYS_ID AS sysId,
        ITEM_GRP AS itemGrp,
        ITEM_ID AS itemId,
        ITEM_NM AS itemNm,
        ITEM_NM_KOR AS itemNmKor,
        ITEM_NM_ENG AS itemNmEng,
        ITEM_NM_PORT AS itemNmPort,
        ITEM_NM_VIET AS itemNmViet,
        ITEM_NM_ETC AS itemNmEtc,
        ITEM_DESC AS itemDesc,
        ITEM_TYPE AS itemType,
        ITEM_LEN AS itemLen,
        ITEM_SCALE AS itemScale,
        ITEM_ATR1 AS itemAtr1,
        ITEM_ATR2 AS itemAtr2,
        ITEM_ATR3 AS itemAtr3,
        ITEM_REMK AS itemRemk,
        USE_FLAG AS useFlag,
        REGI_ID AS regiId,
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        CHNG_ID AS chngId,
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate
    FROM SYS_DIC A
    WHERE SYS_ID = p_sys_id
      AND ITEM_GRP = (CASE WHEN p_item_grp = 'N0001' THEN p_item_grp
                           WHEN p_item_grp = 'N0002' THEN p_item_grp
                           ELSE (SELECT MENU_URL FROM SYS_MENU WHERE SYS_ID = p_sys_id AND MENU_KEY = p_item_grp) END)
      AND ITEM_ID = p_item_id;
END//

-- ============================================================
-- 4. 화면 용어 등록
-- sp_screenterm_insert
-- ============================================================
DROP PROCEDURE IF EXISTS sp_screenterm_insert//

CREATE PROCEDURE sp_screenterm_insert(
    IN p_sys_id VARCHAR(20),
    IN p_item_grp VARCHAR(100),
    IN p_item_id VARCHAR(50),
    IN p_item_nm VARCHAR(200),
    IN p_item_nm_kor VARCHAR(200),
    IN p_item_nm_eng VARCHAR(200),
    IN p_item_nm_port VARCHAR(200),
    IN p_item_nm_viet VARCHAR(200),
    IN p_item_nm_etc VARCHAR(200),
    IN p_item_desc VARCHAR(500),
    IN p_item_type VARCHAR(20),
    IN p_item_len VARCHAR(20),
    IN p_item_scale VARCHAR(20),
    IN p_item_atr1 VARCHAR(100),
    IN p_item_atr2 VARCHAR(100),
    IN p_item_atr3 VARCHAR(100),
    IN p_item_remk VARCHAR(500),
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_item_grp VARCHAR(100);

    -- ITEM_GRP 값 결정 (N0001, N0002는 그대로, 그 외는 MENU_URL 조회)
    SET v_item_grp = CASE WHEN p_item_grp = 'N0001' THEN p_item_grp
                          WHEN p_item_grp = 'N0002' THEN p_item_grp
                          ELSE IFNULL((SELECT MENU_URL FROM SYS_MENU WHERE SYS_ID = p_sys_id AND MENU_KEY = p_item_grp), p_item_grp)
                     END;

    INSERT INTO SYS_DIC (
        SYS_ID, ITEM_GRP, ITEM_ID, ITEM_NM,
        ITEM_NM_KOR, ITEM_NM_ENG, ITEM_NM_PORT, ITEM_NM_VIET, ITEM_NM_ETC,
        ITEM_DESC, ITEM_TYPE, ITEM_LEN, ITEM_SCALE,
        ITEM_ATR1, ITEM_ATR2, ITEM_ATR3, ITEM_REMK,
        USE_FLAG, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sys_id, v_item_grp, p_item_id, p_item_nm,
        p_item_nm_kor, p_item_nm_eng, p_item_nm_port, p_item_nm_viet, p_item_nm_etc,
        p_item_desc, p_item_type, p_item_len, p_item_scale,
        p_item_atr1, p_item_atr2, p_item_atr3, p_item_remk,
        p_use_flag, p_gs_user_id, NOW(), p_gs_user_id, NOW()
    );
END//

-- ============================================================
-- 5. 화면 용어 수정
-- sp_screenterm_update
-- ============================================================
DROP PROCEDURE IF EXISTS sp_screenterm_update//

CREATE PROCEDURE sp_screenterm_update(
    IN p_sys_id VARCHAR(20),
    IN p_item_grp VARCHAR(100),
    IN p_item_id VARCHAR(50),
    IN p_item_nm VARCHAR(200),
    IN p_item_nm_kor VARCHAR(200),
    IN p_item_nm_eng VARCHAR(200),
    IN p_item_nm_port VARCHAR(200),
    IN p_item_nm_viet VARCHAR(200),
    IN p_item_nm_etc VARCHAR(200),
    IN p_item_desc VARCHAR(500),
    IN p_use_flag VARCHAR(1),
    IN p_item_type VARCHAR(20),
    IN p_item_len VARCHAR(20),
    IN p_item_atr1 VARCHAR(100),
    IN p_item_atr2 VARCHAR(100),
    IN p_item_atr3 VARCHAR(100),
    IN p_item_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_DIC
    SET CHNG_DATE = NOW(),
        CHNG_ID = p_gs_user_id,
        ITEM_NM = IFNULL(NULLIF(p_item_nm, ''), ITEM_NM),
        ITEM_NM_KOR = IFNULL(NULLIF(p_item_nm_kor, ''), ITEM_NM_KOR),
        ITEM_NM_ENG = IFNULL(NULLIF(p_item_nm_eng, ''), ITEM_NM_ENG),
        ITEM_NM_PORT = IFNULL(NULLIF(p_item_nm_port, ''), ITEM_NM_PORT),
        ITEM_NM_VIET = IFNULL(NULLIF(p_item_nm_viet, ''), ITEM_NM_VIET),
        ITEM_NM_ETC = IFNULL(NULLIF(p_item_nm_etc, ''), ITEM_NM_ETC),
        ITEM_DESC = IFNULL(NULLIF(p_item_desc, ''), ITEM_DESC),
        USE_FLAG = IFNULL(NULLIF(p_use_flag, ''), USE_FLAG),
        ITEM_TYPE = IFNULL(NULLIF(p_item_type, ''), ITEM_TYPE),
        ITEM_LEN = IFNULL(p_item_len, ITEM_LEN),
        ITEM_ATR1 = IFNULL(NULLIF(p_item_atr1, ''), ITEM_ATR1),
        ITEM_ATR2 = IFNULL(NULLIF(p_item_atr2, ''), ITEM_ATR2),
        ITEM_ATR3 = IFNULL(NULLIF(p_item_atr3, ''), ITEM_ATR3),
        ITEM_REMK = IFNULL(NULLIF(p_item_remk, ''), ITEM_REMK)
    WHERE SYS_ID = p_sys_id
      AND ITEM_GRP = p_item_grp
      AND ITEM_ID = p_item_id;
END//

-- ============================================================
-- 6. 화면 용어 삭제
-- sp_screenterm_delete
-- ============================================================
DROP PROCEDURE IF EXISTS sp_screenterm_delete//

CREATE PROCEDURE sp_screenterm_delete(
    IN p_sys_id VARCHAR(20),
    IN p_item_grp VARCHAR(100),
    IN p_item_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_DIC
    WHERE SYS_ID = p_sys_id
      AND ITEM_GRP = p_item_grp
      AND ITEM_ID = p_item_id;
END//

-- ============================================================
-- 7. 프로그램 키 목록 조회
-- sp_screenterm_prog_key_list
-- ============================================================
DROP PROCEDURE IF EXISTS sp_screenterm_prog_key_list//

CREATE PROCEDURE sp_screenterm_prog_key_list(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT A.*
    FROM (
        SELECT A.PROG_ID,
               A.PROG_NAME,
               B.MENU_KEY
        FROM SYS_PROG A, SYS_MENU B
        WHERE A.SYS_ID = p_sys_id
          AND A.SYS_ID = B.SYS_ID
          AND A.PROG_ID = B.MENU_URL
          AND A.USE_FLAG = 'Y'
        UNION ALL
        SELECT 'N0001' AS PROG_ID,
               'E-help메뉴얼' AS PROG_NAME,
               'N0001' AS MENU_KEY
        UNION ALL
        SELECT 'N0002' AS PROG_ID,
               'E-help사용자메모' AS PROG_NAME,
               'N0002' AS MENU_KEY
    ) A
    ORDER BY A.PROG_NAME ASC;
END//

-- ============================================================
-- 8. 언어별 명칭 조회
-- sp_screenterm_lang_nm
-- ============================================================
DROP PROCEDURE IF EXISTS sp_screenterm_lang_nm//

CREATE PROCEDURE sp_screenterm_lang_nm(
    IN p_sys_id VARCHAR(20),
    IN p_item_key VARCHAR(100),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT SYS_ID AS sysId,
           ITEM_GRP AS itemGrp,
           ITEM_ID AS itemId,
           ITEM_NM,
           ITEM_NM_KOR AS itemNmKor,
           ITEM_NM_ENG AS itemNmEng,
           ITEM_NM_PORT AS itemNmPort,
           ITEM_NM_VIET AS itemNmViet,
           ITEM_NM_ETC AS itemNmEtc,
           (CASE WHEN p_gs_lang = 'ko' THEN IFNULL(ITEM_NM_KOR, ITEM_NM)
                 WHEN p_gs_lang = 'en' THEN IFNULL(ITEM_NM_ENG, ITEM_NM)
                 WHEN p_gs_lang = 'pt' THEN IFNULL(ITEM_NM_PORT, ITEM_NM)
                 WHEN p_gs_lang = 'vi' THEN IFNULL(ITEM_NM_VIET, ITEM_NM)
                 WHEN p_gs_lang = 'etc' THEN IFNULL(ITEM_NM_ETC, ITEM_NM)
                 ELSE ITEM_NM END) AS itemNm
    FROM SYS_DIC
    WHERE SYS_ID = p_sys_id
      AND ITEM_GRP = (CASE WHEN p_item_key = 'N0001' THEN p_item_key
                           WHEN p_item_key = 'N0002' THEN p_item_key
                           ELSE (SELECT MENU_URL FROM SYS_MENU WHERE SYS_ID = p_sys_id AND MENU_KEY = p_item_key) END);
END//

DELIMITER ;
