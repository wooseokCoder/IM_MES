-- ============================================================
-- Board.xml (게시판 CRUD) -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- 파일 1/3: CRUD 기본 기능
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 게시글 관리 (SYS_BORD) - CRUD
-- ============================================================

-- [sp_board_search] 게시글 목록 조회 (페이징 및 동적 검색)
DROP PROCEDURE IF EXISTS sp_board_search//
CREATE PROCEDURE sp_board_search(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_regi_id VARCHAR(50),
    IN p_bord_title VARCHAR(200),
    IN p_bord_text TEXT,
    IN p_bord_type VARCHAR(20),
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
    -- 정렬 조건 설정 (gsSorts -> p_sort_clause)
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
                        IF(IFNULL(CONCAT(',',A.DATA_SER5),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER5),'') = '','',CONCAT(',',A.DATA_SER5))
                    ) AS dataSerT,
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
                        IF(IFNULL(CONCAT(',',A.DATA_MD10),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD10),'') = '','',CONCAT(',',A.DATA_MD10))
                    ) AS dataMdT,
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
                         ELSE CONCAT('Specific dealer :  ',(SELECT GROUP_CONCAT(TGT_USER_ID) FROM SYS_BORD_TGT WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_NO = A.BORD_NO))
                    END AS target,
                    CASE WHEN A.BORD_TYPE = 'ALL' THEN ''
                         WHEN A.BORD_TYPE = 'DLR' THEN ''
                         ELSE (SELECT GROUP_CONCAT(TGT_USER_ID) FROM SYS_BORD_TGT WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_NO = A.BORD_NO)
                    END AS targetValue,
                    (SELECT FILE_NAME FROM SYS_FILE WHERE SYS_ID = A.SYS_ID AND ATCH_NO = A.BORD_NO AND ATCH_GRUP = A.BORD_GRUP AND THUMB_NAIL = 'Y' LIMIT 1) AS thumbNail,
                    A.LANGUAGE
                FROM SYS_BORD A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND A.BORD_GRUP = '", p_bord_grup, "'
                  AND A.USE_FLAG = 'Y'
                  -- B28 특수 조건
                  AND (CASE WHEN '", p_bord_grup, "' = 'B28' THEN A.DATA_GRP2 = 'Service Bulletin' ELSE 1=1 END)
                  -- 기본 조건들
                  AND (CASE WHEN '", IFNULL(p_regi_id,''), "' != '' THEN A.REGI_ID = '", IFNULL(p_regi_id,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_title,''), "' != '' THEN A.BORD_TITLE LIKE '%", IFNULL(p_bord_title,''), "%' COLLATE utf8mb4_unicode_ci ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_text,''), "' != '' THEN A.BORD_TEXT LIKE '%", IFNULL(p_bord_text,''), "%' COLLATE utf8mb4_unicode_ci ELSE 1=1 END)
                  AND (CASE WHEN '", p_bord_grup, "' != 'B06' AND '", IFNULL(p_bord_type,''), "' != '' THEN A.BORD_TYPE = '", IFNULL(p_bord_type,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_bgn,''), "' != '' THEN A.BORD_BGN = '", IFNULL(p_bord_bgn,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_end,''), "' != '' THEN A.BORD_END = '", IFNULL(p_bord_end,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_open_type,''), "' != '' THEN A.OPEN_TYPE = '", IFNULL(p_open_type,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_search_grp1,''), "' != '' THEN A.DATA_GRP1 = '", IFNULL(p_search_grp1,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_search_grp2,''), "' != '' THEN A.DATA_GRP2 = '", IFNULL(p_search_grp2,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_search_grp3,''), "' != '' THEN (A.DATA_SER1 = '", IFNULL(p_search_grp3,''), "' OR A.DATA_SER2 = '", IFNULL(p_search_grp3,''), "' OR A.DATA_SER3 = '", IFNULL(p_search_grp3,''), "' OR A.DATA_SER4 = '", IFNULL(p_search_grp3,''), "' OR A.DATA_SER5 = '", IFNULL(p_search_grp3,''), "') ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_search_grp4,''), "' != '' THEN (A.DATA_MD01 = '", IFNULL(p_search_grp4,''), "' OR A.DATA_MD02 = '", IFNULL(p_search_grp4,''), "' OR A.DATA_MD03 = '", IFNULL(p_search_grp4,''), "' OR A.DATA_MD04 = '", IFNULL(p_search_grp4,''), "' OR A.DATA_MD05 = '", IFNULL(p_search_grp4,''), "' OR A.DATA_MD06 = '", IFNULL(p_search_grp4,''), "' OR A.DATA_MD07 = '", IFNULL(p_search_grp4,''), "' OR A.DATA_MD08 = '", IFNULL(p_search_grp4,''), "' OR A.DATA_MD09 = '", IFNULL(p_search_grp4,''), "' OR A.DATA_MD10 = '", IFNULL(p_search_grp4,''), "') ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_language,''), "' != '' THEN A.LANGUAGE = '", IFNULL(p_language,''), "' ELSE 1=1 END)
                  -- 검색조건 (searchKey, searchText)
                  AND (CASE
                        WHEN '", IFNULL(p_search_key,''), "' = 'S01' AND '", IFNULL(p_search_text,''), "' != '' THEN A.BORD_TITLE LIKE '%", IFNULL(p_search_text,''), "%' COLLATE utf8mb4_unicode_ci
                        WHEN '", IFNULL(p_search_key,''), "' = 'S02' AND '", IFNULL(p_search_text,''), "' != '' THEN A.BORD_TEXT LIKE '%", IFNULL(p_search_text,''), "%' COLLATE utf8mb4_unicode_ci
                        WHEN '", IFNULL(p_search_key,''), "' = 'S03' AND '", IFNULL(p_search_text,''), "' != '' THEN EXISTS (SELECT 1 FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID AND USER_NAME LIKE '%", IFNULL(p_search_text,''), "%' COLLATE utf8mb4_unicode_ci)
                        WHEN '", IFNULL(p_search_key,''), "' = 'S04' AND '", IFNULL(p_search_text,''), "' != '' THEN A.SEAR_IDX LIKE '%", IFNULL(p_search_text,''), "%' COLLATE utf8mb4_unicode_ci
                        WHEN '", IFNULL(p_search_key,''), "' = 'S06' AND '", IFNULL(p_search_text,''), "' != '' THEN
                            (LOWER(A.BORD_TITLE) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(CONVERT(A.BORD_TEXT USING utf8mb4)) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.SEAR_IDX) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_SER1) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_SER2) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_SER3) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_SER4) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_SER5) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD01) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD02) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD03) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD04) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD05) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD06) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD07) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD08) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD09) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci
                             OR LOWER(A.DATA_MD10) LIKE LOWER('%", IFNULL(p_search_text,''), "%') COLLATE utf8mb4_unicode_ci)
                        ELSE 1=1 END)
                  -- 날짜 검색 (S05)
                  AND (CASE WHEN '", IFNULL(p_search_key,''), "' = 'S05' AND '", IFNULL(p_date1,''), "' != '' AND '", IFNULL(p_date2,''), "' != '' THEN A.REGI_DATE BETWEEN FN_CONV_DATE('", IFNULL(p_date1,''), "') AND FN_CONV_DATE('", IFNULL(p_date2,''), "') ELSE 1=1 END)
                  -- 부모 게시글 조건 (트리 구조)
                  AND (CASE WHEN '", IFNULL(p_bord_pno,''), "' != '' THEN A.BORD_PNO = '", IFNULL(p_bord_pno,''), "' ELSE (A.BORD_PNO IS NULL OR A.BORD_PNO = '') END)
                  -- 답변게시판(B04) 특수 조건
                  AND (CASE WHEN '", p_bord_grup, "' = 'B04' THEN
                            (A.USE_FLAG = 'Y' OR (A.USE_FLAG = 'N' AND (SELECT COUNT(*) FROM SYS_BORD WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = 'Y') > 0))
                            ELSE 1=1 END)
                  -- 오늘 기준 조건
                  AND (CASE WHEN '", IFNULL(p_today_yn,''), "' = 'Y' THEN DATE_FORMAT(NOW(),'%Y-%m-%d') BETWEEN A.BORD_BGN AND A.BORD_END ELSE 1=1 END)
                  -- 대시보드 더이상 안보기 조건
                  AND (CASE WHEN '", IFNULL(p_not_any_more,''), "' = 'Y' THEN
                        (SELECT CASE
                            WHEN A.BORD_NO <> 'B000000000' AND A.BORD_TYPE = 'ALL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", IFNULL(p_gs_user_id,''), "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0 THEN 'Y'
                            WHEN A.BORD_NO = 'B000000000' AND A.BORD_TYPE = 'ALL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", IFNULL(p_gs_user_id,''), "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0
                                 AND (SELECT COUNT(D.DEAL_CODE) FROM DEAL_MAST D WHERE D.DEAL_CODE = '", IFNULL(p_gs_user_id,''), "' AND D.BLOCK_IDX = 'Y') = 1 THEN 'Y'
                            WHEN A.BORD_TYPE = 'DLR' AND '", IFNULL(p_gs_org_auth_code,''), "' = 'DEAL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", IFNULL(p_gs_user_id,''), "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0
                                 AND (SELECT COUNT(D.DEAL_CODE) FROM DEAL_MAST D WHERE D.DEAL_CODE = '", IFNULL(p_gs_user_id,''), "' AND D.BLOCK_IDX = 'Y') = 1 THEN 'Y'
                            WHEN A.BORD_TYPE = 'LSA' AND '", IFNULL(p_gs_org_auth_code,''), "' != 'DEAL' AND COUNT(CASE WHEN X.TGT_USER_ID = '", IFNULL(p_gs_user_id,''), "' AND X.READ_DATE IS NOT NULL THEN 1 END) = 0 THEN 'Y'
                            WHEN A.BORD_TYPE = 'USR' AND COUNT(CASE WHEN X.TGT_USER_ID = '", IFNULL(p_gs_user_id,''), "' AND X.READ_DATE IS NULL THEN 1 END) > 0 THEN 'Y'
                        END FROM SYS_BORD_TGT X WHERE A.SYS_ID = X.SYS_ID AND X.BORD_GRUP = '", p_bord_grup, "' AND A.BORD_GRUP = X.BORD_GRUP AND A.BORD_NO = X.BORD_NO) = 'Y'
                        ELSE 1=1 END)
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

-- [sp_board_search_count] 게시글 카운트
DROP PROCEDURE IF EXISTS sp_board_search_count//
CREATE PROCEDURE sp_board_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_regi_id VARCHAR(50),
    IN p_bord_title VARCHAR(200),
    IN p_bord_text TEXT,
    IN p_bord_type VARCHAR(20),
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
    SELECT COUNT(1) AS cnt
    FROM SYS_BORD A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND A.USE_FLAG = 'Y'
      AND (CASE WHEN p_bord_grup = 'B28' THEN A.DATA_GRP2 = 'Service Bulletin' ELSE 1=1 END)
      AND (CASE WHEN p_regi_id IS NOT NULL AND p_regi_id != '' THEN A.REGI_ID = p_regi_id ELSE 1=1 END)
      AND (CASE WHEN p_bord_title IS NOT NULL AND p_bord_title != '' THEN A.BORD_TITLE LIKE CONCAT('%', p_bord_title COLLATE utf8mb4_unicode_ci, '%') ELSE 1=1 END)
      AND (CASE WHEN p_bord_text IS NOT NULL AND p_bord_text != '' THEN A.BORD_TEXT LIKE CONCAT('%', p_bord_text COLLATE utf8mb4_unicode_ci, '%') ELSE 1=1 END)
      AND (CASE WHEN p_bord_grup != 'B06' AND p_bord_type IS NOT NULL AND p_bord_type != '' THEN A.BORD_TYPE = p_bord_type ELSE 1=1 END)
      AND (CASE WHEN p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN A.BORD_BGN = p_bord_bgn ELSE 1=1 END)
      AND (CASE WHEN p_bord_end IS NOT NULL AND p_bord_end != '' THEN A.BORD_END = p_bord_end ELSE 1=1 END)
      AND (CASE WHEN p_open_type IS NOT NULL AND p_open_type != '' THEN A.OPEN_TYPE = p_open_type ELSE 1=1 END)
      AND (CASE WHEN p_search_grp1 IS NOT NULL AND p_search_grp1 != '' THEN A.DATA_GRP1 = p_search_grp1 ELSE 1=1 END)
      AND (CASE WHEN p_search_grp2 IS NOT NULL AND p_search_grp2 != '' THEN A.DATA_GRP2 = p_search_grp2 ELSE 1=1 END)
      AND (CASE WHEN p_search_grp3 IS NOT NULL AND p_search_grp3 != '' THEN (A.DATA_SER1 = p_search_grp3 OR A.DATA_SER2 = p_search_grp3 OR A.DATA_SER3 = p_search_grp3 OR A.DATA_SER4 = p_search_grp3 OR A.DATA_SER5 = p_search_grp3) ELSE 1=1 END)
      AND (CASE WHEN p_search_grp4 IS NOT NULL AND p_search_grp4 != '' THEN (A.DATA_MD01 = p_search_grp4 OR A.DATA_MD02 = p_search_grp4 OR A.DATA_MD03 = p_search_grp4 OR A.DATA_MD04 = p_search_grp4 OR A.DATA_MD05 = p_search_grp4 OR A.DATA_MD06 = p_search_grp4 OR A.DATA_MD07 = p_search_grp4 OR A.DATA_MD08 = p_search_grp4 OR A.DATA_MD09 = p_search_grp4 OR A.DATA_MD10 = p_search_grp4) ELSE 1=1 END)
      AND (CASE WHEN p_language IS NOT NULL AND p_language != '' THEN A.LANGUAGE = p_language ELSE 1=1 END)
      AND (CASE
            WHEN p_search_key = 'S01' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.BORD_TITLE LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')
            WHEN p_search_key = 'S02' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.BORD_TEXT LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')
            WHEN p_search_key = 'S03' AND p_search_text IS NOT NULL AND p_search_text != '' THEN EXISTS (SELECT 1 FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID AND USER_NAME LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%'))
            WHEN p_search_key = 'S04' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.SEAR_IDX LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')
            WHEN p_search_key = 'S06' AND p_search_text IS NOT NULL AND p_search_text != '' THEN
                (LOWER(A.BORD_TITLE) LIKE LOWER(CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%'))
                 OR LOWER(CONVERT(A.BORD_TEXT USING utf8mb4)) LIKE LOWER(CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%'))
                 OR LOWER(A.SEAR_IDX) LIKE LOWER(CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')))
            ELSE 1=1 END)
      AND (CASE WHEN p_search_key = 'S05' AND p_date1 IS NOT NULL AND p_date2 IS NOT NULL THEN A.REGI_DATE BETWEEN FN_CONV_DATE(p_date1) AND FN_CONV_DATE(p_date2) ELSE 1=1 END)
      AND (CASE WHEN p_bord_pno IS NOT NULL AND p_bord_pno != '' THEN A.BORD_PNO = p_bord_pno ELSE A.BORD_PNO IS NULL END)
      AND (CASE WHEN p_bord_grup = 'B04' THEN (A.USE_FLAG = 'Y' OR (A.USE_FLAG = 'N' AND (SELECT COUNT(*) FROM SYS_BORD WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = 'Y') > 0)) ELSE 1=1 END)
      AND (CASE WHEN p_today_yn = 'Y' THEN DATE_FORMAT(NOW(),'%Y-%m-%d') BETWEEN A.BORD_BGN AND A.BORD_END ELSE 1=1 END)
      AND (CASE WHEN p_not_any_more = 'Y' THEN
            (SELECT CASE
                WHEN A.BORD_NO <> 'B000000000' AND A.BORD_TYPE = 'ALL' AND COUNT(CASE WHEN X.TGT_USER_ID = p_gs_user_id AND X.READ_DATE IS NOT NULL THEN 1 END) = 0 THEN 'Y'
                WHEN A.BORD_NO = 'B000000000' AND A.BORD_TYPE = 'ALL' AND COUNT(CASE WHEN X.TGT_USER_ID = p_gs_user_id AND X.READ_DATE IS NOT NULL THEN 1 END) = 0
                     AND (SELECT COUNT(D.DEAL_CODE) FROM DEAL_MAST D WHERE D.DEAL_CODE = p_gs_user_id AND D.BLOCK_IDX = 'Y') = 1 THEN 'Y'
                WHEN A.BORD_TYPE = 'DLR' AND p_gs_org_auth_code = 'DEAL' AND COUNT(CASE WHEN X.TGT_USER_ID = p_gs_user_id AND X.READ_DATE IS NOT NULL THEN 1 END) = 0
                     AND (SELECT COUNT(D.DEAL_CODE) FROM DEAL_MAST D WHERE D.DEAL_CODE = p_gs_user_id AND D.BLOCK_IDX = 'Y') = 1 THEN 'Y'
                WHEN A.BORD_TYPE = 'LSA' AND p_gs_org_auth_code != 'DEAL' AND COUNT(CASE WHEN X.TGT_USER_ID = p_gs_user_id AND X.READ_DATE IS NOT NULL THEN 1 END) = 0 THEN 'Y'
                WHEN A.BORD_TYPE = 'USR' AND COUNT(CASE WHEN X.TGT_USER_ID = p_gs_user_id AND X.READ_DATE IS NULL THEN 1 END) > 0 THEN 'Y'
            END FROM SYS_BORD_TGT X WHERE A.SYS_ID = X.SYS_ID AND X.BORD_GRUP = p_bord_grup AND A.BORD_GRUP = X.BORD_GRUP AND A.BORD_NO = X.BORD_NO) = 'Y'
            ELSE 1=1 END);
END//

-- [sp_board_select] 게시글 상세 조회
DROP PROCEDURE IF EXISTS sp_board_select//
CREATE PROCEDURE sp_board_select(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
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
            IF(IFNULL(CONCAT(',',A.DATA_SER5),'') = ',' OR IFNULL(CONCAT(',',A.DATA_SER5),'') = '','',CONCAT(',',A.DATA_SER5))
        ) AS dataSerT,
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
            IF(IFNULL(CONCAT(',',A.DATA_MD10),'') = ',' OR IFNULL(CONCAT(',',A.DATA_MD10),'') = '','',CONCAT(',',A.DATA_MD10))
        ) AS dataMdT,
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
             ELSE CONCAT('Specific dealer :  ',(SELECT GROUP_CONCAT(TGT_USER_ID) FROM SYS_BORD_TGT WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_NO = A.BORD_NO))
        END AS target,
        CASE WHEN A.BORD_TYPE = 'ALL' THEN ''
             WHEN A.BORD_TYPE = 'DLR' THEN ''
             ELSE (SELECT GROUP_CONCAT(TGT_USER_ID) FROM SYS_BORD_TGT WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_NO = A.BORD_NO)
        END AS targetValue,
        (SELECT FILE_NAME FROM SYS_FILE WHERE SYS_ID = A.SYS_ID AND ATCH_NO = A.BORD_NO AND ATCH_GRUP = A.BORD_GRUP AND THUMB_NAIL = 'Y' LIMIT 1) AS thumbNail,
        A.LANGUAGE,
        A.BORD_TEXT     AS bordText
    FROM SYS_BORD A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_NO = p_bord_no
      AND A.BORD_GRUP = p_bord_grup;
END//

-- [sp_board_insert] 게시글 등록
DROP PROCEDURE IF EXISTS sp_board_insert//
CREATE PROCEDURE sp_board_insert(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_title VARCHAR(200),
    IN p_bord_type VARCHAR(20),
    IN p_bord_bgn VARCHAR(20),
    IN p_bord_end VARCHAR(20),
    IN p_bord_pno VARCHAR(20),
    IN p_open_type VARCHAR(10),
    IN p_bord_text LONGBLOB,
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
    IN p_sear_idx VARCHAR(200),
    IN p_just_one VARCHAR(1),
    IN p_language VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_new_no VARCHAR(20);

    SELECT CONCAT('B', LPAD(CAST(IFNULL(SUBSTR(MAX(BORD_NO),2,9),'0') AS UNSIGNED)+1, 9, '0')) INTO v_new_no
    FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup;

    INSERT INTO SYS_BORD (
        SYS_ID, BORD_NO, BORD_GRUP, BORD_TITLE, READ_CNT, BORD_SEQ, USE_FLAG, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE,
        BORD_TYPE, BORD_BGN, BORD_END, BORD_PNO, OPEN_TYPE, BORD_TEXT,
        DATA_GRP1, DATA_GRP2, DATA_GRP3, DATA_GRP4,
        DATA_SER1, DATA_SER2, DATA_SER3, DATA_SER4, DATA_SER5,
        DATA_MD01, DATA_MD02, DATA_MD03, DATA_MD04, DATA_MD05, DATA_MD06, DATA_MD07, DATA_MD08, DATA_MD09, DATA_MD10,
        SEAR_IDX, OPEN_CLS, LANGUAGE
    ) VALUES (
        p_sys_id, v_new_no, p_bord_grup, TRIM(p_bord_title), 0, 999999999, 'Y', p_gs_user_id, NOW(), p_gs_user_id, NOW(),
        p_bord_type, FN_CONV_DATE(p_bord_bgn), FN_CONV_DATE(p_bord_end), p_bord_pno, p_open_type, p_bord_text,
        p_data_grp1, p_data_grp2, p_data_grp3, p_data_grp4,
        p_data_ser1, p_data_ser2, p_data_ser3, p_data_ser4, p_data_ser5,
        p_data_md01, p_data_md02, p_data_md03, p_data_md04, p_data_md05, p_data_md06, p_data_md07, p_data_md08, p_data_md09, p_data_md10,
        p_sear_idx, p_just_one, p_language
    );
END//

-- [sp_board_update] 게시글 수정
DROP PROCEDURE IF EXISTS sp_board_update//
CREATE PROCEDURE sp_board_update(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_title VARCHAR(200),
    IN p_bord_text LONGBLOB,
    IN p_bord_type VARCHAR(20),
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
    IN p_sear_idx VARCHAR(200),
    IN p_just_one VARCHAR(1),
    IN p_language VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        BORD_TITLE = IFNULL(TRIM(p_bord_title), BORD_TITLE),
        BORD_TEXT = IFNULL(p_bord_text, BORD_TEXT),
        BORD_TYPE = IFNULL(p_bord_type, BORD_TYPE),
        BORD_BGN = CASE WHEN p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN FN_CONV_DATE(p_bord_bgn) ELSE BORD_BGN END,
        BORD_END = CASE WHEN p_bord_end IS NOT NULL AND p_bord_end != '' THEN FN_CONV_DATE(p_bord_end) ELSE BORD_END END,
        READ_CNT = IFNULL(p_read_cnt, READ_CNT),
        BORD_SEQ = IFNULL(p_bord_seq, BORD_SEQ),
        USE_FLAG = IFNULL(p_use_flag, USE_FLAG),
        OPEN_TYPE = IFNULL(p_open_type, OPEN_TYPE),
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
        OPEN_CLS = IFNULL(p_just_one, OPEN_CLS),
        LANGUAGE = IFNULL(p_language, '')
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//

-- [sp_board_delete] 게시글 물리 삭제
DROP PROCEDURE IF EXISTS sp_board_delete//
CREATE PROCEDURE sp_board_delete(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_BORD WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//

-- [sp_board_update_read_cnt] 조회수 증가
DROP PROCEDURE IF EXISTS sp_board_update_read_cnt//
CREATE PROCEDURE sp_board_update_read_cnt(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    UPDATE SYS_BORD SET READ_CNT = READ_CNT + 1
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//

-- [sp_board_update_disable] 게시글 사용안함 처리
DROP PROCEDURE IF EXISTS sp_board_update_disable//
CREATE PROCEDURE sp_board_update_disable(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD SET USE_FLAG = 'N', CHNG_ID = p_gs_user_id, CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//

DELIMITER ;
