-- ============================================================
-- NavHelp.xml -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- 네비게이션 도움말 관련 프로시저
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 게시글 관리 (SYS_BORD) - NavHelp용
-- ============================================================

-- [sp_navhelp_search] 게시글 목록 조회 (페이징 및 동적 검색)
DROP PROCEDURE IF EXISTS sp_navhelp_search//
CREATE PROCEDURE sp_navhelp_search(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_regi_id VARCHAR(50),
    IN p_bord_title VARCHAR(200) CHARACTER SET utf8,
    IN p_bord_text TEXT CHARACTER SET utf8,
    IN p_bord_type VARCHAR(10),
    IN p_bord_bgn VARCHAR(20),
    IN p_bord_end VARCHAR(20),
    IN p_open_type VARCHAR(10),
    IN p_search_grp1 VARCHAR(50),
    IN p_search_grp2 VARCHAR(50),
    IN p_search_grp3 VARCHAR(50),
    IN p_search_grp4 VARCHAR(50),
    IN p_language VARCHAR(10),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200),
    IN p_date1 VARCHAR(20),
    IN p_date2 VARCHAR(20),
    IN p_bord_pno VARCHAR(20),
    IN p_today_yn VARCHAR(1),
    IN p_not_any_more VARCHAR(1),
    IN p_gs_user_id VARCHAR(50),
    IN p_gs_org_auth_code VARCHAR(20),
    IN p_sort_clause VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- 정렬 조건 설정
    SET @sort_order = IF(p_sort_clause IS NOT NULL AND p_sort_clause != '', p_sort_clause, 'A.BORD_SEQ ASC, A.REGI_DATE DESC');

    SET @rownum := 0;

    -- 동적 SQL 구성
    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID        AS sysId,
                    A.BORD_NO       AS BORDNO1,
                    A.BORD_NO       AS bordNo,
                    A.BORD_GRUP     AS bordGrup,
                    A.BORD_TITLE    AS BORDTITLE1,
                    A.BORD_TITLE    AS bordTitle,
                    A.BORD_TYPE     AS bordType,
                    FN_CONV_DATE1(A.BORD_BGN) AS bordBgn,
                    FN_CONV_DATE1(A.BORD_END) AS bordEnd,
                    A.READ_CNT      AS readCnt,
                    A.BORD_SEQ      AS bordSeq,
                    A.BORD_PNO      AS bordPno,
                    A.OPEN_TYPE     AS openType,
                    A.OPEN_CLS      AS openCls,
                    A.USE_FLAG      AS useFlag,
                    A.DATA_GRP1     AS dataGrp1,
                    A.DATA_GRP2     AS dataGrp2,
                    A.DATA_GRP3     AS dataGrp3,
                    A.DATA_GRP4     AS dataGrp4,
                    A.DATA_SER1     AS dataSer1,
                    A.DATA_SER2     AS dataSer2,
                    A.DATA_SER3     AS dataSer3,
                    A.DATA_SER4     AS dataSer4,
                    A.DATA_SER5     AS dataSer5,
                    CONCAT(IFNULL(A.DATA_SER1,''),
                        IF(IFNULL(CONCAT(',',A.DATA_SER2),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER2),'') = '','',CONCAT(',',A.DATA_SER2)),
                        IF(IFNULL(CONCAT(',',A.DATA_SER3),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER3),'') = '','',CONCAT(',',A.DATA_SER3)),
                        IF(IFNULL(CONCAT(',',A.DATA_SER4),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER4),'') = '','',CONCAT(',',A.DATA_SER4)),
                        IF(IFNULL(CONCAT(',',A.DATA_SER5),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER5),'') = '','',CONCAT(',',A.DATA_SER5))) AS dataSerT,
                    A.DATA_MD01     AS dataMd01,
                    A.DATA_MD02     AS dataMd02,
                    A.DATA_MD03     AS dataMd03,
                    A.DATA_MD04     AS dataMd04,
                    A.DATA_MD05     AS dataMd05,
                    A.DATA_MD06     AS dataMd06,
                    A.DATA_MD07     AS dataMd07,
                    A.DATA_MD08     AS dataMd08,
                    A.DATA_MD09     AS dataMd09,
                    A.DATA_MD10     AS dataMd10,
                    CONCAT(IFNULL(A.DATA_MD01,''),
                        IF(IFNULL(CONCAT(',',A.DATA_MD02),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD02),'') = '','',CONCAT(',',A.DATA_MD02)),
                        IF(IFNULL(CONCAT(',',A.DATA_MD03),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD03),'') = '','',CONCAT(',',A.DATA_MD03)),
                        IF(IFNULL(CONCAT(',',A.DATA_MD04),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD04),'') = '','',CONCAT(',',A.DATA_MD04)),
                        IF(IFNULL(CONCAT(',',A.DATA_MD05),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD05),'') = '','',CONCAT(',',A.DATA_MD05)),
                        IF(IFNULL(CONCAT(',',A.DATA_MD06),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD06),'') = '','',CONCAT(',',A.DATA_MD06)),
                        IF(IFNULL(CONCAT(',',A.DATA_MD07),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD07),'') = '','',CONCAT(',',A.DATA_MD07)),
                        IF(IFNULL(CONCAT(',',A.DATA_MD08),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD08),'') = '','',CONCAT(',',A.DATA_MD08)),
                        IF(IFNULL(CONCAT(',',A.DATA_MD09),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD09),'') = '','',CONCAT(',',A.DATA_MD09)),
                        IF(IFNULL(CONCAT(',',A.DATA_MD10),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD10),'') = '','',CONCAT(',',A.DATA_MD10))) AS dataMdT,
                    A.SEAR_IDX      AS searIdx,
                    A.REGI_ID       AS regiId,
                    DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
                    A.CHNG_ID       AS chngId,
                    DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
                    A.BORD_NO       AS id,
                    A.BORD_PNO      AS parentId,
                    CASE WHEN (SELECT COUNT(*) FROM SYS_BORD WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP) = 0
                         THEN 'open' ELSE 'closed' END AS state,
                    (SELECT COUNT(ATCH_NO) FROM SYS_FILE WHERE SYS_ID = A.SYS_ID AND ATCH_NO = A.BORD_NO AND ATCH_GRUP = A.BORD_GRUP) AS fileCnt,
                    (SELECT COUNT(BORD_PNO) FROM SYS_BORD WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_PNO = A.BORD_NO) AS replyCnt,
                    CASE WHEN A.BORD_TYPE = 'ALL' THEN 'All user'
                         WHEN A.BORD_TYPE = 'DLR' THEN 'All dealer'
                         ELSE CONCAT('Specific dealer :  ',(SELECT GROUP_CONCAT(TGT_USER_ID) FROM SYS_BORD_TGT WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_NO = A.BORD_NO)) END AS target,
                    CASE WHEN A.BORD_TYPE = 'ALL' THEN ''
                         WHEN A.BORD_TYPE = 'DLR' THEN ''
                         ELSE (SELECT GROUP_CONCAT(TGT_USER_ID) FROM SYS_BORD_TGT WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_NO = A.BORD_NO) END AS targetValue,
                    (SELECT FILE_NAME FROM SYS_FILE WHERE SYS_ID = A.SYS_ID AND ATCH_NO = A.BORD_NO AND ATCH_GRUP = A.BORD_GRUP AND THUMB_NAIL = 'Y' LIMIT 1) AS thumbNail,
                    A.LANGUAGE
                FROM SYS_BORD A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND A.BORD_GRUP = '", p_bord_grup, "'
                  AND A.USE_FLAG = 'Y'
                  ");

    -- B28 게시판 특별 조건
    IF p_bord_grup = 'B28' THEN
        SET @sql = CONCAT(@sql, " AND A.DATA_GRP2 = 'Service Bulletin' ");
    END IF;

    -- 검색 조건들
    IF p_regi_id IS NOT NULL AND p_regi_id != '' THEN
        SET @sql = CONCAT(@sql, " AND A.REGI_ID = '", p_regi_id, "' ");
    END IF;

    IF p_bord_title IS NOT NULL AND p_bord_title != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TITLE LIKE '%", p_bord_title, "%' ");
    END IF;

    IF p_bord_text IS NOT NULL AND p_bord_text != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TEXT LIKE '%", p_bord_text, "%' ");
    END IF;

    IF p_bord_grup != 'B06' AND p_bord_type IS NOT NULL AND p_bord_type != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TYPE = '", p_bord_type, "' ");
    END IF;

    IF p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_BGN = '", p_bord_bgn, "' ");
    END IF;

    IF p_bord_end IS NOT NULL AND p_bord_end != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_END = '", p_bord_end, "' ");
    END IF;

    IF p_open_type IS NOT NULL AND p_open_type != '' THEN
        SET @sql = CONCAT(@sql, " AND A.OPEN_TYPE = '", p_open_type, "' ");
    END IF;

    IF p_search_grp1 IS NOT NULL AND p_search_grp1 != '' THEN
        SET @sql = CONCAT(@sql, " AND A.DATA_GRP1 = '", p_search_grp1, "' ");
    END IF;

    IF p_search_grp2 IS NOT NULL AND p_search_grp2 != '' THEN
        SET @sql = CONCAT(@sql, " AND A.DATA_GRP2 = '", p_search_grp2, "' ");
    END IF;

    IF p_search_grp3 IS NOT NULL AND p_search_grp3 != '' THEN
        SET @sql = CONCAT(@sql, " AND (A.DATA_SER1 = '", p_search_grp3, "' OR A.DATA_SER2 = '", p_search_grp3, "' OR A.DATA_SER3 = '", p_search_grp3, "' OR A.DATA_SER4 = '", p_search_grp3, "' OR A.DATA_SER5 = '", p_search_grp3, "') ");
    END IF;

    IF p_search_grp4 IS NOT NULL AND p_search_grp4 != '' THEN
        SET @sql = CONCAT(@sql, " AND (A.DATA_MD01 = '", p_search_grp4, "' OR A.DATA_MD02 = '", p_search_grp4, "' OR A.DATA_MD03 = '", p_search_grp4, "' OR A.DATA_MD04 = '", p_search_grp4, "' OR A.DATA_MD05 = '", p_search_grp4, "' OR A.DATA_MD06 = '", p_search_grp4, "' OR A.DATA_MD07 = '", p_search_grp4, "' OR A.DATA_MD08 = '", p_search_grp4, "' OR A.DATA_MD09 = '", p_search_grp4, "' OR A.DATA_MD10 = '", p_search_grp4, "') ");
    END IF;

    IF p_language IS NOT NULL AND p_language != '' THEN
        SET @sql = CONCAT(@sql, " AND A.LANGUAGE = '", p_language, "' ");
    END IF;

    -- 검색 키/텍스트 조건
    IF p_search_key IS NOT NULL AND p_search_key != '' AND p_search_text IS NOT NULL AND p_search_text != '' THEN
        IF p_search_key = 'S01' THEN
            SET @sql = CONCAT(@sql, " AND A.BORD_TITLE LIKE '%", p_search_text, "%' ");
        ELSEIF p_search_key = 'S02' THEN
            SET @sql = CONCAT(@sql, " AND A.BORD_TEXT LIKE '%", p_search_text, "%' ");
        ELSEIF p_search_key = 'S03' THEN
            SET @sql = CONCAT(@sql, " AND EXISTS (SELECT 1 FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID AND USER_NAME LIKE '%", p_search_text, "%') ");
        ELSEIF p_search_key = 'S04' THEN
            SET @sql = CONCAT(@sql, " AND A.SEAR_IDX LIKE '%", p_search_text, "%' ");
        ELSEIF p_search_key = 'S06' THEN
            SET @sql = CONCAT(@sql, " AND (LOWER(A.BORD_TITLE) LIKE LOWER('%", p_search_text, "%') OR LOWER(CONVERT(A.BORD_TEXT USING utf8mb4)) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.SEAR_IDX) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER1) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER2) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER3) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER4) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER5) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD01) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD02) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD03) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD04) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD05) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD06) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD07) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD08) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD09) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD10) LIKE LOWER('%", p_search_text, "%')) ");
        END IF;
    END IF;

    -- 날짜 범위 조건
    IF p_search_key = 'S05' AND p_date1 IS NOT NULL AND p_date1 != '' AND p_date2 IS NOT NULL AND p_date2 != '' THEN
        SET @sql = CONCAT(@sql, " AND A.REGI_DATE BETWEEN FN_CONV_DATE('", p_date1, "') AND FN_CONV_DATE('", p_date2, "') ");
    END IF;

    -- bordPno 조건
    IF p_bord_pno IS NOT NULL AND p_bord_pno != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_PNO = '", p_bord_pno, "' ");
    ELSE
        SET @sql = CONCAT(@sql, " AND A.BORD_PNO IS NULL ");
    END IF;

    -- B04 게시판 삭제글 조건
    IF p_bord_grup = 'B04' THEN
        SET @sql = CONCAT(@sql, " AND ((A.USE_FLAG = 'Y') OR (A.USE_FLAG = 'N' AND (SELECT COUNT(*) FROM SYS_BORD WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = 'Y') > 0)) ");
    END IF;

    -- todayYn 조건
    IF p_today_yn = 'Y' THEN
        SET @sql = CONCAT(@sql, " AND DATE_FORMAT(NOW(),'%Y-%m-%d') BETWEEN A.BORD_BGN AND A.BORD_END ");
    END IF;

    -- notAnyMore 조건
    IF p_not_any_more = 'Y' THEN
        SET @sql = CONCAT(@sql, " AND (SELECT CASE
            WHEN A.BORD_NO <> 'B000000000' AND A.BORD_TYPE = 'ALL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0 THEN 'Y'
            WHEN A.BORD_NO = 'B000000000' AND A.BORD_TYPE = 'ALL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0
                 AND (SELECT COUNT(D.DEAL_CODE) FROM DEAL_MAST D WHERE D.DEAL_CODE = '", p_gs_user_id, "' AND D.BLOCK_IDX = 'Y') = 1 THEN 'Y'
            WHEN A.BORD_TYPE = 'DLR' AND '", p_gs_org_auth_code, "' = 'DEAL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0
                 AND (SELECT COUNT(D.DEAL_CODE) FROM DEAL_MAST D WHERE D.DEAL_CODE = '", p_gs_user_id, "' AND D.BLOCK_IDX = 'Y') = 1 THEN 'Y'
            WHEN A.BORD_TYPE = 'LSA' AND '", p_gs_org_auth_code, "' != 'DEAL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0 THEN 'Y'
            WHEN A.BORD_TYPE = 'USR' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NULL THEN 1 END) > 0 THEN 'Y' END
            FROM SYS_BORD_TGT X WHERE A.SYS_ID = X.SYS_ID AND X.BORD_GRUP = '", p_bord_grup, "' AND A.BORD_GRUP = X.BORD_GRUP AND A.BORD_NO = X.BORD_NO) = 'Y' ");
    END IF;

    -- 정렬 및 페이징
    SET @sql = CONCAT(@sql, " ORDER BY ", @sort_order, "
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 999999999), " ELSE 1=1 END)
    ) X
    WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)");

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//


-- [sp_navhelp_search_count] 게시글 카운트
DROP PROCEDURE IF EXISTS sp_navhelp_search_count//
CREATE PROCEDURE sp_navhelp_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_regi_id VARCHAR(50),
    IN p_bord_title VARCHAR(200) CHARACTER SET utf8,
    IN p_bord_text TEXT CHARACTER SET utf8,
    IN p_bord_type VARCHAR(10),
    IN p_bord_bgn VARCHAR(20),
    IN p_bord_end VARCHAR(20),
    IN p_open_type VARCHAR(10),
    IN p_search_grp1 VARCHAR(50),
    IN p_search_grp2 VARCHAR(50),
    IN p_search_grp3 VARCHAR(50),
    IN p_search_grp4 VARCHAR(50),
    IN p_language VARCHAR(10),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200),
    IN p_date1 VARCHAR(20),
    IN p_date2 VARCHAR(20),
    IN p_bord_pno VARCHAR(20),
    IN p_today_yn VARCHAR(1),
    IN p_not_any_more VARCHAR(1),
    IN p_gs_user_id VARCHAR(50),
    IN p_gs_org_auth_code VARCHAR(20)
)
BEGIN
    -- 동적 SQL 구성
    SET @sql = CONCAT("
        SELECT COUNT(1) AS cnt
        FROM SYS_BORD A
        WHERE A.SYS_ID = '", p_sys_id, "'
          AND A.BORD_GRUP = '", p_bord_grup, "'
          AND A.USE_FLAG = 'Y'
    ");

    -- B28 게시판 특별 조건
    IF p_bord_grup = 'B28' THEN
        SET @sql = CONCAT(@sql, " AND A.DATA_GRP2 = 'Service Bulletin' ");
    END IF;

    -- 검색 조건들
    IF p_regi_id IS NOT NULL AND p_regi_id != '' THEN
        SET @sql = CONCAT(@sql, " AND A.REGI_ID = '", p_regi_id, "' ");
    END IF;

    IF p_bord_title IS NOT NULL AND p_bord_title != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TITLE LIKE '%", p_bord_title, "%' ");
    END IF;

    IF p_bord_text IS NOT NULL AND p_bord_text != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TEXT LIKE '%", p_bord_text, "%' ");
    END IF;

    IF p_bord_grup != 'B06' AND p_bord_type IS NOT NULL AND p_bord_type != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TYPE = '", p_bord_type, "' ");
    END IF;

    IF p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_BGN = '", p_bord_bgn, "' ");
    END IF;

    IF p_bord_end IS NOT NULL AND p_bord_end != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_END = '", p_bord_end, "' ");
    END IF;

    IF p_open_type IS NOT NULL AND p_open_type != '' THEN
        SET @sql = CONCAT(@sql, " AND A.OPEN_TYPE = '", p_open_type, "' ");
    END IF;

    IF p_search_grp1 IS NOT NULL AND p_search_grp1 != '' THEN
        SET @sql = CONCAT(@sql, " AND A.DATA_GRP1 = '", p_search_grp1, "' ");
    END IF;

    IF p_search_grp2 IS NOT NULL AND p_search_grp2 != '' THEN
        SET @sql = CONCAT(@sql, " AND A.DATA_GRP2 = '", p_search_grp2, "' ");
    END IF;

    IF p_search_grp3 IS NOT NULL AND p_search_grp3 != '' THEN
        SET @sql = CONCAT(@sql, " AND (A.DATA_SER1 = '", p_search_grp3, "' OR A.DATA_SER2 = '", p_search_grp3, "' OR A.DATA_SER3 = '", p_search_grp3, "' OR A.DATA_SER4 = '", p_search_grp3, "' OR A.DATA_SER5 = '", p_search_grp3, "') ");
    END IF;

    IF p_search_grp4 IS NOT NULL AND p_search_grp4 != '' THEN
        SET @sql = CONCAT(@sql, " AND (A.DATA_MD01 = '", p_search_grp4, "' OR A.DATA_MD02 = '", p_search_grp4, "' OR A.DATA_MD03 = '", p_search_grp4, "' OR A.DATA_MD04 = '", p_search_grp4, "' OR A.DATA_MD05 = '", p_search_grp4, "' OR A.DATA_MD06 = '", p_search_grp4, "' OR A.DATA_MD07 = '", p_search_grp4, "' OR A.DATA_MD08 = '", p_search_grp4, "' OR A.DATA_MD09 = '", p_search_grp4, "' OR A.DATA_MD10 = '", p_search_grp4, "') ");
    END IF;

    IF p_language IS NOT NULL AND p_language != '' THEN
        SET @sql = CONCAT(@sql, " AND A.LANGUAGE = '", p_language, "' ");
    END IF;

    -- 검색 키/텍스트 조건
    IF p_search_key IS NOT NULL AND p_search_key != '' AND p_search_text IS NOT NULL AND p_search_text != '' THEN
        IF p_search_key = 'S01' THEN
            SET @sql = CONCAT(@sql, " AND A.BORD_TITLE LIKE '%", p_search_text, "%' ");
        ELSEIF p_search_key = 'S02' THEN
            SET @sql = CONCAT(@sql, " AND A.BORD_TEXT LIKE '%", p_search_text, "%' ");
        ELSEIF p_search_key = 'S03' THEN
            SET @sql = CONCAT(@sql, " AND EXISTS (SELECT 1 FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID AND USER_NAME LIKE '%", p_search_text, "%') ");
        ELSEIF p_search_key = 'S04' THEN
            SET @sql = CONCAT(@sql, " AND A.SEAR_IDX LIKE '%", p_search_text, "%' ");
        ELSEIF p_search_key = 'S06' THEN
            SET @sql = CONCAT(@sql, " AND (LOWER(A.BORD_TITLE) LIKE LOWER('%", p_search_text, "%') OR LOWER(CONVERT(A.BORD_TEXT USING utf8mb4)) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.SEAR_IDX) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER1) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER2) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER3) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER4) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_SER5) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD01) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD02) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD03) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD04) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD05) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD06) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD07) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD08) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD09) LIKE LOWER('%", p_search_text, "%') OR LOWER(A.DATA_MD10) LIKE LOWER('%", p_search_text, "%')) ");
        END IF;
    END IF;

    -- 날짜 범위 조건
    IF p_search_key = 'S05' AND p_date1 IS NOT NULL AND p_date1 != '' AND p_date2 IS NOT NULL AND p_date2 != '' THEN
        SET @sql = CONCAT(@sql, " AND A.REGI_DATE BETWEEN FN_CONV_DATE('", p_date1, "') AND FN_CONV_DATE('", p_date2, "') ");
    END IF;

    -- bordPno 조건
    IF p_bord_pno IS NOT NULL AND p_bord_pno != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_PNO = '", p_bord_pno, "' ");
    ELSE
        SET @sql = CONCAT(@sql, " AND A.BORD_PNO IS NULL ");
    END IF;

    -- B04 게시판 삭제글 조건
    IF p_bord_grup = 'B04' THEN
        SET @sql = CONCAT(@sql, " AND ((A.USE_FLAG = 'Y') OR (A.USE_FLAG = 'N' AND (SELECT COUNT(*) FROM SYS_BORD WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = 'Y') > 0)) ");
    END IF;

    -- todayYn 조건
    IF p_today_yn = 'Y' THEN
        SET @sql = CONCAT(@sql, " AND DATE_FORMAT(NOW(),'%Y-%m-%d') BETWEEN A.BORD_BGN AND A.BORD_END ");
    END IF;

    -- notAnyMore 조건
    IF p_not_any_more = 'Y' THEN
        SET @sql = CONCAT(@sql, " AND (SELECT CASE
            WHEN A.BORD_NO <> 'B000000000' AND A.BORD_TYPE = 'ALL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0 THEN 'Y'
            WHEN A.BORD_NO = 'B000000000' AND A.BORD_TYPE = 'ALL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0
                 AND (SELECT COUNT(D.DEAL_CODE) FROM DEAL_MAST D WHERE D.DEAL_CODE = '", p_gs_user_id, "' AND D.BLOCK_IDX = 'Y') = 1 THEN 'Y'
            WHEN A.BORD_TYPE = 'DLR' AND '", p_gs_org_auth_code, "' = 'DEAL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0
                 AND (SELECT COUNT(D.DEAL_CODE) FROM DEAL_MAST D WHERE D.DEAL_CODE = '", p_gs_user_id, "' AND D.BLOCK_IDX = 'Y') = 1 THEN 'Y'
            WHEN A.BORD_TYPE = 'LSA' AND '", p_gs_org_auth_code, "' != 'DEAL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0 THEN 'Y'
            WHEN A.BORD_TYPE = 'USR' AND COUNT(CASE WHEN X.TGT_USER_ID = '", p_gs_user_id, "' AND X.READ_DATE IS NULL THEN 1 END) > 0 THEN 'Y' END
            FROM SYS_BORD_TGT X WHERE A.SYS_ID = X.SYS_ID AND X.BORD_GRUP = '", p_bord_grup, "' AND A.BORD_GRUP = X.BORD_GRUP AND A.BORD_NO = X.BORD_NO) = 'Y' ");
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//


-- [sp_navhelp_select] 게시글 상세 조회
DROP PROCEDURE IF EXISTS sp_navhelp_select//
CREATE PROCEDURE sp_navhelp_select(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.BORD_NO       AS BORDNO1,
        A.BORD_NO       AS bordNo,
        A.BORD_GRUP     AS bordGrup,
        A.BORD_TITLE    AS BORDTITLE1,
        A.BORD_TITLE    AS bordTitle,
        A.BORD_TYPE     AS bordType,
        FN_CONV_DATE1(A.BORD_BGN) AS bordBgn,
        FN_CONV_DATE1(A.BORD_END) AS bordEnd,
        A.READ_CNT      AS readCnt,
        A.BORD_SEQ      AS bordSeq,
        A.BORD_PNO      AS bordPno,
        A.OPEN_TYPE     AS openType,
        A.OPEN_CLS      AS openCls,
        A.USE_FLAG      AS useFlag,
        A.DATA_GRP1     AS dataGrp1,
        A.DATA_GRP2     AS dataGrp2,
        A.DATA_GRP3     AS dataGrp3,
        A.DATA_GRP4     AS dataGrp4,
        A.DATA_SER1     AS dataSer1,
        A.DATA_SER2     AS dataSer2,
        A.DATA_SER3     AS dataSer3,
        A.DATA_SER4     AS dataSer4,
        A.DATA_SER5     AS dataSer5,
        CONCAT(IFNULL(A.DATA_SER1,''),
            IF(IFNULL(CONCAT(',',A.DATA_SER2),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER2),'') = '','',CONCAT(',',A.DATA_SER2)),
            IF(IFNULL(CONCAT(',',A.DATA_SER3),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER3),'') = '','',CONCAT(',',A.DATA_SER3)),
            IF(IFNULL(CONCAT(',',A.DATA_SER4),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER4),'') = '','',CONCAT(',',A.DATA_SER4)),
            IF(IFNULL(CONCAT(',',A.DATA_SER5),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER5),'') = '','',CONCAT(',',A.DATA_SER5))) AS dataSerT,
        A.DATA_MD01     AS dataMd01,
        A.DATA_MD02     AS dataMd02,
        A.DATA_MD03     AS dataMd03,
        A.DATA_MD04     AS dataMd04,
        A.DATA_MD05     AS dataMd05,
        A.DATA_MD06     AS dataMd06,
        A.DATA_MD07     AS dataMd07,
        A.DATA_MD08     AS dataMd08,
        A.DATA_MD09     AS dataMd09,
        A.DATA_MD10     AS dataMd10,
        CONCAT(IFNULL(A.DATA_MD01,''),
            IF(IFNULL(CONCAT(',',A.DATA_MD02),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD02),'') = '','',CONCAT(',',A.DATA_MD02)),
            IF(IFNULL(CONCAT(',',A.DATA_MD03),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD03),'') = '','',CONCAT(',',A.DATA_MD03)),
            IF(IFNULL(CONCAT(',',A.DATA_MD04),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD04),'') = '','',CONCAT(',',A.DATA_MD04)),
            IF(IFNULL(CONCAT(',',A.DATA_MD05),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD05),'') = '','',CONCAT(',',A.DATA_MD05)),
            IF(IFNULL(CONCAT(',',A.DATA_MD06),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD06),'') = '','',CONCAT(',',A.DATA_MD06)),
            IF(IFNULL(CONCAT(',',A.DATA_MD07),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD07),'') = '','',CONCAT(',',A.DATA_MD07)),
            IF(IFNULL(CONCAT(',',A.DATA_MD08),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD08),'') = '','',CONCAT(',',A.DATA_MD08)),
            IF(IFNULL(CONCAT(',',A.DATA_MD09),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD09),'') = '','',CONCAT(',',A.DATA_MD09)),
            IF(IFNULL(CONCAT(',',A.DATA_MD10),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD10),'') = '','',CONCAT(',',A.DATA_MD10))) AS dataMdT,
        A.SEAR_IDX      AS searIdx,
        A.REGI_ID       AS regiId,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID       AS chngId,
        DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
        A.BORD_NO       AS id,
        A.BORD_PNO      AS parentId,
        CASE WHEN (SELECT COUNT(*) FROM SYS_BORD WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP) = 0
             THEN 'open' ELSE 'closed' END AS state,
        (SELECT COUNT(ATCH_NO) FROM SYS_FILE WHERE SYS_ID = A.SYS_ID AND ATCH_NO = A.BORD_NO AND ATCH_GRUP = A.BORD_GRUP) AS fileCnt,
        (SELECT COUNT(BORD_PNO) FROM SYS_BORD WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_PNO = A.BORD_NO) AS replyCnt,
        CASE WHEN A.BORD_TYPE = 'ALL' THEN 'All user'
             WHEN A.BORD_TYPE = 'DLR' THEN 'All dealer'
             ELSE CONCAT('Specific dealer :  ',(SELECT GROUP_CONCAT(TGT_USER_ID) FROM SYS_BORD_TGT WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_NO = A.BORD_NO)) END AS target,
        CASE WHEN A.BORD_TYPE = 'ALL' THEN ''
             WHEN A.BORD_TYPE = 'DLR' THEN ''
             ELSE (SELECT GROUP_CONCAT(TGT_USER_ID) FROM SYS_BORD_TGT WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_NO = A.BORD_NO) END AS targetValue,
        (SELECT FILE_NAME FROM SYS_FILE WHERE SYS_ID = A.SYS_ID AND ATCH_NO = A.BORD_NO AND ATCH_GRUP = A.BORD_GRUP AND THUMB_NAIL = 'Y' LIMIT 1) AS thumbNail,
        A.LANGUAGE,
        A.BORD_TEXT     AS bordText
    FROM SYS_BORD A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_NO = p_bord_no
      AND A.BORD_GRUP = p_bord_grup;
END//


-- [sp_navhelp_insert] 게시글 등록
DROP PROCEDURE IF EXISTS sp_navhelp_insert//
CREATE PROCEDURE sp_navhelp_insert(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_title VARCHAR(200) CHARACTER SET utf8,
    IN p_bord_type VARCHAR(10),
    IN p_bord_bgn VARCHAR(20),
    IN p_bord_end VARCHAR(20),
    IN p_bord_pno VARCHAR(20),
    IN p_open_type VARCHAR(10),
    IN p_bord_text TEXT CHARACTER SET utf8,
    IN p_data_grp1 VARCHAR(50),
    IN p_data_grp2 VARCHAR(50),
    IN p_data_grp3 VARCHAR(50),
    IN p_data_grp4 VARCHAR(50),
    IN p_data_ser1 VARCHAR(50),
    IN p_data_ser2 VARCHAR(50),
    IN p_data_ser3 VARCHAR(50),
    IN p_data_ser4 VARCHAR(50),
    IN p_data_ser5 VARCHAR(50),
    IN p_data_md01 VARCHAR(50),
    IN p_data_md02 VARCHAR(50),
    IN p_data_md03 VARCHAR(50),
    IN p_data_md04 VARCHAR(50),
    IN p_data_md05 VARCHAR(50),
    IN p_data_md06 VARCHAR(50),
    IN p_data_md07 VARCHAR(50),
    IN p_data_md08 VARCHAR(50),
    IN p_data_md09 VARCHAR(50),
    IN p_data_md10 VARCHAR(50),
    IN p_sear_idx VARCHAR(500),
    IN p_just_one VARCHAR(10),
    IN p_language VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_BORD (
        SYS_ID, BORD_NO, BORD_GRUP, BORD_TITLE, READ_CNT, BORD_SEQ, USE_FLAG,
        REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE,
        BORD_TYPE, BORD_BGN, BORD_END, BORD_PNO, OPEN_TYPE, BORD_TEXT,
        DATA_GRP1, DATA_GRP2, DATA_GRP3, DATA_GRP4,
        DATA_SER1, DATA_SER2, DATA_SER3, DATA_SER4, DATA_SER5,
        DATA_MD01, DATA_MD02, DATA_MD03, DATA_MD04, DATA_MD05,
        DATA_MD06, DATA_MD07, DATA_MD08, DATA_MD09, DATA_MD10,
        SEAR_IDX, OPEN_CLS, LANGUAGE
    )
    VALUES (
        p_sys_id, p_bord_no, p_bord_grup, TRIM(p_bord_title), 0, 999999999, 'Y',
        p_gs_user_id, NOW(), p_gs_user_id, NOW(),
        NULLIF(p_bord_type, ''),
        CASE WHEN p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN FN_CONV_DATE(p_bord_bgn) ELSE NULL END,
        CASE WHEN p_bord_end IS NOT NULL AND p_bord_end != '' THEN FN_CONV_DATE(p_bord_end) ELSE NULL END,
        NULLIF(p_bord_pno, ''), NULLIF(p_open_type, ''), NULLIF(p_bord_text, ''),
        NULLIF(p_data_grp1, ''), NULLIF(p_data_grp2, ''), NULLIF(p_data_grp3, ''), NULLIF(p_data_grp4, ''),
        NULLIF(p_data_ser1, ''), NULLIF(p_data_ser2, ''), NULLIF(p_data_ser3, ''), NULLIF(p_data_ser4, ''), NULLIF(p_data_ser5, ''),
        NULLIF(p_data_md01, ''), NULLIF(p_data_md02, ''), NULLIF(p_data_md03, ''), NULLIF(p_data_md04, ''), NULLIF(p_data_md05, ''),
        NULLIF(p_data_md06, ''), NULLIF(p_data_md07, ''), NULLIF(p_data_md08, ''), NULLIF(p_data_md09, ''), NULLIF(p_data_md10, ''),
        NULLIF(p_sear_idx, ''), NULLIF(p_just_one, ''), NULLIF(p_language, '')
    );
END//


-- [sp_navhelp_update] 게시글 수정
DROP PROCEDURE IF EXISTS sp_navhelp_update//
CREATE PROCEDURE sp_navhelp_update(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_title VARCHAR(200) CHARACTER SET utf8,
    IN p_bord_text TEXT CHARACTER SET utf8,
    IN p_bord_type VARCHAR(10),
    IN p_bord_bgn VARCHAR(20),
    IN p_bord_end VARCHAR(20),
    IN p_read_cnt INT,
    IN p_bord_seq INT,
    IN p_use_flag VARCHAR(1),
    IN p_open_type VARCHAR(10),
    IN p_data_grp1 VARCHAR(50),
    IN p_data_grp2 VARCHAR(50),
    IN p_data_grp3 VARCHAR(50),
    IN p_data_grp4 VARCHAR(50),
    IN p_data_ser1 VARCHAR(50),
    IN p_data_ser2 VARCHAR(50),
    IN p_data_ser3 VARCHAR(50),
    IN p_data_ser4 VARCHAR(50),
    IN p_data_ser5 VARCHAR(50),
    IN p_data_md01 VARCHAR(50),
    IN p_data_md02 VARCHAR(50),
    IN p_data_md03 VARCHAR(50),
    IN p_data_md04 VARCHAR(50),
    IN p_data_md05 VARCHAR(50),
    IN p_data_md06 VARCHAR(50),
    IN p_data_md07 VARCHAR(50),
    IN p_data_md08 VARCHAR(50),
    IN p_data_md09 VARCHAR(50),
    IN p_data_md10 VARCHAR(50),
    IN p_sear_idx VARCHAR(500),
    IN p_just_one VARCHAR(10),
    IN p_language VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        BORD_TITLE = CASE WHEN p_bord_title IS NOT NULL AND p_bord_title != '' THEN TRIM(p_bord_title) ELSE BORD_TITLE END,
        BORD_TEXT = CASE WHEN p_bord_text IS NOT NULL AND p_bord_text != '' THEN p_bord_text ELSE BORD_TEXT END,
        BORD_TYPE = CASE WHEN p_bord_type IS NOT NULL AND p_bord_type != '' THEN p_bord_type ELSE BORD_TYPE END,
        BORD_BGN = CASE WHEN p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN FN_CONV_DATE(p_bord_bgn) ELSE BORD_BGN END,
        BORD_END = CASE WHEN p_bord_end IS NOT NULL AND p_bord_end != '' THEN FN_CONV_DATE(p_bord_end) ELSE BORD_END END,
        READ_CNT = CASE WHEN p_read_cnt IS NOT NULL THEN p_read_cnt ELSE READ_CNT END,
        BORD_SEQ = CASE WHEN p_bord_seq IS NOT NULL THEN p_bord_seq ELSE BORD_SEQ END,
        USE_FLAG = CASE WHEN p_use_flag IS NOT NULL AND p_use_flag != '' THEN p_use_flag ELSE USE_FLAG END,
        OPEN_TYPE = CASE WHEN p_open_type IS NOT NULL AND p_open_type != '' THEN p_open_type ELSE OPEN_TYPE END,
        DATA_GRP1 = IFNULL(p_data_grp1, ''),
        DATA_GRP2 = IFNULL(p_data_grp2, ''),
        DATA_GRP3 = IFNULL(p_data_grp3, ''),
        DATA_GRP4 = IFNULL(p_data_grp4, ''),
        DATA_SER1 = IFNULL(p_data_ser1, ''),
        DATA_SER2 = IFNULL(p_data_ser2, ''),
        DATA_SER3 = IFNULL(p_data_ser3, ''),
        DATA_SER4 = IFNULL(p_data_ser4, ''),
        DATA_SER5 = IFNULL(p_data_ser5, ''),
        DATA_MD01 = IFNULL(p_data_md01, ''),
        DATA_MD02 = IFNULL(p_data_md02, ''),
        DATA_MD03 = IFNULL(p_data_md03, ''),
        DATA_MD04 = IFNULL(p_data_md04, ''),
        DATA_MD05 = IFNULL(p_data_md05, ''),
        DATA_MD06 = IFNULL(p_data_md06, ''),
        DATA_MD07 = IFNULL(p_data_md07, ''),
        DATA_MD08 = IFNULL(p_data_md08, ''),
        DATA_MD09 = IFNULL(p_data_md09, ''),
        DATA_MD10 = IFNULL(p_data_md10, ''),
        SEAR_IDX = IFNULL(p_sear_idx, ''),
        LANGUAGE = IFNULL(p_language, ''),
        OPEN_CLS = CASE WHEN p_just_one IS NOT NULL AND p_just_one != '' THEN p_just_one ELSE OPEN_CLS END
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//


-- [sp_navhelp_delete] 게시글 물리 삭제
DROP PROCEDURE IF EXISTS sp_navhelp_delete//
CREATE PROCEDURE sp_navhelp_delete(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_BORD
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//


-- [sp_navhelp_update_read_cnt] 조회수 증가
DROP PROCEDURE IF EXISTS sp_navhelp_update_read_cnt//
CREATE PROCEDURE sp_navhelp_update_read_cnt(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    UPDATE SYS_BORD
    SET READ_CNT = READ_CNT + 1
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//


-- [sp_navhelp_update_disable] 게시글 사용안함 처리
DROP PROCEDURE IF EXISTS sp_navhelp_update_disable//
CREATE PROCEDURE sp_navhelp_update_disable(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD
    SET CHNG_ID = p_gs_user_id, CHNG_DATE = NOW(), USE_FLAG = 'N'
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//


-- ============================================================
-- 2. 대상자 관리 (SYS_BORD_TGT) - NavHelp용
-- ============================================================

-- [sp_navhelp_search_target] 대상자 목록 조회
DROP PROCEDURE IF EXISTS sp_navhelp_search_target//
CREATE PROCEDURE sp_navhelp_search_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_use_flag VARCHAR(1),
    IN p_bord_no VARCHAR(500),
    IN p_vndr_code VARCHAR(20),
    IN p_vndr_name VARCHAR(100),
    IN p_save_idx INT,
    IN p_page_type VARCHAR(1),
    IN p_gs_user_id VARCHAR(50),
    IN p_sort_clause VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @sort_order = IF(p_sort_clause IS NOT NULL AND p_sort_clause != '', p_sort_clause, 'B.BORD_SEQ ASC, A.REGI_DATE DESC');
    SET @rownum := 0;

    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID        AS sysId,
                    A.BORD_NO       AS bordNo,
                    A.BORD_GRUP     AS bordGrup,
                    A.TGT_USER_ID   AS tgtUserId,
                    A.VNDR_CODE     AS vndrCode,
                    A.VNDR_NAME     AS vndrName,
                    A.SAVE_IDX      AS saveIdx,
                    DATE_FORMAT(A.READ_DATE,'%Y-%m-%d %H:%i:%s') AS readDate,
                    A.USE_FLAG      AS useFlag,
                    A.REGI_ID       AS regiId,
                    DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
                    A.CHNG_ID       AS chngId,
                    DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
                    B.BORD_TITLE    AS bordTitle,
                    B.BORD_TYPE     AS bordType,
                    B.BORD_BGN      AS bordBgn,
                    B.BORD_END      AS bordEnd,
                    B.READ_CNT      AS readCnt,
                    B.BORD_SEQ      AS bordSeq,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.TGT_USER_ID) AS tgtName
                FROM SYS_BORD_TGT A
                INNER JOIN SYS_BORD B ON B.SYS_ID = A.SYS_ID AND B.BORD_NO = A.BORD_NO AND B.BORD_GRUP = A.BORD_GRUP
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND A.BORD_GRUP = '", p_bord_grup, "'
                  AND (CASE WHEN '", IFNULL(p_use_flag,''), "' != '' THEN A.USE_FLAG = '", IFNULL(p_use_flag,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_no,''), "' != '' THEN A.BORD_NO = '", IFNULL(p_bord_no,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_vndr_code,''), "' != '' THEN A.VNDR_CODE = '", IFNULL(p_vndr_code,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_vndr_name,''), "' != '' THEN A.VNDR_NAME = '", IFNULL(p_vndr_name,''), "' ELSE 1=1 END)
                  AND (CASE WHEN ", IFNULL(p_save_idx, 'NULL'), " IS NOT NULL THEN A.SAVE_IDX = ", IFNULL(p_save_idx, 0), " ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_page_type,''), "' = 'R' THEN A.TGT_USER_ID = '", IFNULL(p_gs_user_id,''), "'
                            WHEN '", IFNULL(p_page_type,''), "' = 'S' THEN A.REGI_ID = '", IFNULL(p_gs_user_id,''), "' ELSE 1=1 END)
                ORDER BY ", @sort_order, "
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 999999999), " ELSE 1=1 END)
    ) X
    WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)");

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//


-- [sp_navhelp_search_target_count] 대상자 목록 카운트
DROP PROCEDURE IF EXISTS sp_navhelp_search_target_count//
CREATE PROCEDURE sp_navhelp_search_target_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_use_flag VARCHAR(1),
    IN p_bord_no VARCHAR(500),
    IN p_vndr_code VARCHAR(20),
    IN p_vndr_name VARCHAR(100),
    IN p_save_idx INT,
    IN p_page_type VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_BORD_TGT A
    INNER JOIN SYS_BORD B ON B.SYS_ID = A.SYS_ID AND B.BORD_NO = A.BORD_NO AND B.BORD_GRUP = A.BORD_GRUP
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND (CASE WHEN p_use_flag IS NOT NULL AND p_use_flag != '' THEN A.USE_FLAG = p_use_flag ELSE 1=1 END)
      AND (CASE WHEN p_bord_no IS NOT NULL AND p_bord_no != '' THEN A.BORD_NO = p_bord_no ELSE 1=1 END)
      AND (CASE WHEN p_vndr_code IS NOT NULL AND p_vndr_code != '' THEN A.VNDR_CODE = p_vndr_code ELSE 1=1 END)
      AND (CASE WHEN p_vndr_name IS NOT NULL AND p_vndr_name != '' THEN A.VNDR_NAME = p_vndr_name ELSE 1=1 END)
      AND (CASE WHEN p_save_idx IS NOT NULL THEN A.SAVE_IDX = p_save_idx ELSE 1=1 END)
      AND (CASE WHEN p_page_type = 'R' THEN A.TGT_USER_ID = p_gs_user_id
                WHEN p_page_type = 'S' THEN A.REGI_ID = p_gs_user_id ELSE 1=1 END);
END//


-- [sp_navhelp_select_target] 대상자 단건 조회
DROP PROCEDURE IF EXISTS sp_navhelp_select_target//
CREATE PROCEDURE sp_navhelp_select_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_use_flag VARCHAR(1)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.BORD_NO       AS bordNo,
        A.BORD_GRUP     AS bordGrup,
        A.TGT_USER_ID   AS tgtUserId,
        A.VNDR_CODE     AS vndrCode,
        A.VNDR_NAME     AS vndrName,
        A.SAVE_IDX      AS saveIdx,
        DATE_FORMAT(A.READ_DATE,'%Y-%m-%d %H:%i:%s') AS readDate,
        A.USE_FLAG      AS useFlag,
        A.REGI_ID       AS regiId,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID       AS chngId,
        DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
        B.BORD_TITLE    AS bordTitle,
        B.BORD_TYPE     AS bordType,
        B.BORD_BGN      AS bordBgn,
        B.BORD_END      AS bordEnd,
        B.READ_CNT      AS readCnt,
        B.BORD_SEQ      AS bordSeq,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.TGT_USER_ID) AS tgtName,
        B.BORD_TEXT     AS bordText
    FROM SYS_BORD_TGT A
    INNER JOIN SYS_BORD B ON B.SYS_ID = A.SYS_ID AND B.BORD_NO = A.BORD_NO AND B.BORD_GRUP = A.BORD_GRUP
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_NO = p_bord_no
      AND A.BORD_GRUP = p_bord_grup
      AND A.TGT_USER_ID = p_tgt_user_id
      AND (CASE WHEN p_use_flag IS NOT NULL THEN A.USE_FLAG = p_use_flag ELSE 1=1 END);
END//


-- [sp_navhelp_insert_target] 대상자 등록
DROP PROCEDURE IF EXISTS sp_navhelp_insert_target//
CREATE PROCEDURE sp_navhelp_insert_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20),
    IN p_targets TEXT,
    IN p_gs_user_id VARCHAR(50),
    IN p_read_yn VARCHAR(1)
)
BEGIN
    INSERT INTO SYS_BORD_TGT (
        SYS_ID, BORD_NO, BORD_GRUP, TGT_USER_ID, VNDR_CODE, VNDR_NAME, USE_FLAG, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE, READ_DATE
    )
    SELECT p_sys_id, p_bord_no, p_bord_grup, A.USER_ID, A.DEPT_CODE,
           IFNULL(A.DEPT_NAME, (SELECT CODE_NAME FROM SYS_CODE WHERE SYS_ID = A.SYS_ID AND CODE_CD = A.DEPT_CODE AND CODE_GRUP = 'DEPT_CODE')),
           'Y', p_gs_user_id, NOW(), p_gs_user_id, NOW(),
           (CASE WHEN p_read_yn = 'Y' THEN NOW() ELSE NULL END)
    FROM SYS_USER A
    WHERE A.SYS_ID = p_sys_id
      AND ((p_targets IS NULL AND A.USER_ID = p_gs_user_id) OR (p_targets IS NOT NULL AND FIND_IN_SET(A.USER_ID, p_targets)));
END//


-- [sp_navhelp_update_target] 대상자 정보 수정
DROP PROCEDURE IF EXISTS sp_navhelp_update_target//
CREATE PROCEDURE sp_navhelp_update_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_vndr_code VARCHAR(20),
    IN p_vndr_name VARCHAR(100),
    IN p_save_idx INT,
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        VNDR_CODE = IFNULL(p_vndr_code, VNDR_CODE),
        VNDR_NAME = IFNULL(p_vndr_name, VNDR_NAME),
        SAVE_IDX = IFNULL(p_save_idx, SAVE_IDX),
        USE_FLAG = IFNULL(p_use_flag, USE_FLAG)
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup AND TGT_USER_ID = p_tgt_user_id;
END//


-- [sp_navhelp_update_target_disable] 대상자 비활성화 처리
DROP PROCEDURE IF EXISTS sp_navhelp_update_target_disable//
CREATE PROCEDURE sp_navhelp_update_target_disable(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT
    SET CHNG_ID = p_gs_user_id, CHNG_DATE = NOW(), USE_FLAG = 'N'
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup AND TGT_USER_ID = p_tgt_user_id;
END//


-- [sp_navhelp_delete_target_all] 대상자 일괄 삭제
DROP PROCEDURE IF EXISTS sp_navhelp_delete_target_all//
CREATE PROCEDURE sp_navhelp_delete_target_all(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_BORD_TGT WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//


-- [sp_navhelp_update_target_read] 대상자 읽음 처리
DROP PROCEDURE IF EXISTS sp_navhelp_update_target_read//
CREATE PROCEDURE sp_navhelp_update_target_read(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT SET READ_DATE = NOW()
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup AND TGT_USER_ID = p_tgt_user_id;
END//


-- ============================================================
-- 3. 조회자 목록 관련
-- ============================================================

-- [sp_navhelp_search_views_list] 조회자 목록
DROP PROCEDURE IF EXISTS sp_navhelp_search_views_list//
CREATE PROCEDURE sp_navhelp_search_views_list(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(500),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200)
)
BEGIN
    SELECT
        A.TGT_USER_ID AS tgtUserId,
        A.VNDR_CODE   AS vndrCode,
        A.VNDR_NAME   AS vndrName,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS readDate
    FROM SYS_BORD_TGT A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND A.BORD_NO = p_bord_no
      AND (CASE
            WHEN p_search_key = 'S01' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.TGT_USER_ID LIKE CONCAT('%', p_search_text, '%')
            WHEN p_search_key = 'S02' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.VNDR_CODE LIKE CONCAT('%', p_search_text, '%')
            WHEN p_search_key = 'S03' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.VNDR_NAME LIKE CONCAT('%', p_search_text, '%')
            ELSE 1=1 END)
    ORDER BY A.READ_DATE ASC, A.TGT_USER_ID ASC;
END//


-- [sp_navhelp_search_views_list_count] 조회자 목록 카운트
DROP PROCEDURE IF EXISTS sp_navhelp_search_views_list_count//
CREATE PROCEDURE sp_navhelp_search_views_list_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(500)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_BORD_ADDR A
    WHERE A.SYS_ID = p_sys_id AND A.BORD_GRUP = p_bord_grup AND A.BORD_NO = p_bord_no;
END//


-- ============================================================
-- 4. 매뉴얼 관련
-- ============================================================

-- [sp_navhelp_get_manual_series] 매뉴얼 시리즈 목록
DROP PROCEDURE IF EXISTS sp_navhelp_get_manual_series//
CREATE PROCEDURE sp_navhelp_get_manual_series(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    SELECT A.* FROM (
        SELECT DISTINCT(DATA_SER1) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_SER1 IS NOT NULL AND DATA_SER1 != ''
        UNION
        SELECT DISTINCT(DATA_SER2) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_SER2 IS NOT NULL AND DATA_SER2 != ''
        UNION
        SELECT DISTINCT(DATA_SER3) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_SER3 IS NOT NULL AND DATA_SER3 != ''
        UNION
        SELECT DISTINCT(DATA_SER4) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_SER4 IS NOT NULL AND DATA_SER4 != ''
        UNION
        SELECT DISTINCT(DATA_SER5) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_SER5 IS NOT NULL AND DATA_SER5 != ''
        UNION
        SELECT DISTINCT(CODE_CD) FROM SYS_CODE WHERE SYS_ID = p_sys_id AND CODE_GRUP = 'SERI_TYPE' AND CODE_CD IS NOT NULL AND CODE_CD != ''
    ) A
    ORDER BY DATA_SER1 ASC;
END//


-- [sp_navhelp_get_manual_model] 매뉴얼 모델 목록
DROP PROCEDURE IF EXISTS sp_navhelp_get_manual_model//
CREATE PROCEDURE sp_navhelp_get_manual_model(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    SELECT A.* FROM (
        SELECT DISTINCT(DATA_MD01) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD01 IS NOT NULL AND DATA_MD01 != ''
        UNION
        SELECT DISTINCT(DATA_MD02) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD02 IS NOT NULL AND DATA_MD02 != ''
        UNION
        SELECT DISTINCT(DATA_MD03) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD03 IS NOT NULL AND DATA_MD03 != ''
        UNION
        SELECT DISTINCT(DATA_MD04) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD04 IS NOT NULL AND DATA_MD04 != ''
        UNION
        SELECT DISTINCT(DATA_MD05) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD05 IS NOT NULL AND DATA_MD05 != ''
        UNION
        SELECT DISTINCT(DATA_MD06) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD06 IS NOT NULL AND DATA_MD06 != ''
        UNION
        SELECT DISTINCT(DATA_MD07) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD07 IS NOT NULL AND DATA_MD07 != ''
        UNION
        SELECT DISTINCT(DATA_MD08) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD08 IS NOT NULL AND DATA_MD08 != ''
        UNION
        SELECT DISTINCT(DATA_MD09) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD09 IS NOT NULL AND DATA_MD09 != ''
        UNION
        SELECT DISTINCT(DATA_MD10) FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND DATA_MD10 IS NOT NULL AND DATA_MD10 != ''
        UNION
        SELECT DISTINCT(CODE_CD) FROM SYS_CODE WHERE SYS_ID = p_sys_id AND CODE_GRUP = 'MODL_CODE' AND CODE_CD IS NOT NULL AND CODE_CD != ''
    ) A
    ORDER BY DATA_MD01 ASC;
END//


-- ============================================================
-- 5. 기타 유틸리티
-- ============================================================

-- [sp_navhelp_get_regi_user_id] 등록자 ID 조회
DROP PROCEDURE IF EXISTS sp_navhelp_get_regi_user_id//
CREATE PROCEDURE sp_navhelp_get_regi_user_id(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(500)
)
BEGIN
    SELECT REGI_ID
    FROM SYS_BORD
    WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND BORD_NO = p_bord_no;
END//


-- [sp_navhelp_dealer_check] 딜러 존재 여부 확인
DROP PROCEDURE IF EXISTS sp_navhelp_dealer_check//
CREATE PROCEDURE sp_navhelp_dealer_check(
    IN p_sys_id VARCHAR(20),
    IN p_dealer_list TEXT
)
BEGIN
    SELECT COUNT(*) AS CNT
    FROM DEAL_MAST
    WHERE SYS_ID = p_sys_id AND FIND_IN_SET(DEAL_CODE, p_dealer_list);
END//


-- [sp_navhelp_select_by_menu_key] 메뉴 키로 네비게이션 도움말 조회
DROP PROCEDURE IF EXISTS sp_navhelp_select_by_menu_key//
CREATE PROCEDURE sp_navhelp_select_by_menu_key(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_menu_key VARCHAR(50)
)
BEGIN
    SELECT
        B.BORD_NO, B.BORD_TITLE, B.BORD_TEXT, M.MENU_KEY, M.MENU_DESC, M.MENU_URL
    FROM SYS_MENU M
    LEFT JOIN SYS_BORD B
        ON B.SYS_ID = M.SYS_ID
        AND M.SYS_ID = p_sys_id
        AND B.BORD_GRUP = p_bord_grup
        AND B.BORD_NO = M.MENU_URL
    WHERE M.MENU_KEY = p_menu_key
    ORDER BY MENU_SEQ ASC
    LIMIT 1;
END//


DELIMITER ;
