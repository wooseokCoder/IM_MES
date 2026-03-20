-- ============================================================
-- Board.xml (대시보드/기타) -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- 파일 3/3: 대시보드, 인덱스, 기타 조회
-- ============================================================

DELIMITER //

-- ============================================================
-- 3. 대시보드/인덱스 관련
-- ============================================================

-- [sp_board_alter_top] 알림 상단 조회
DROP PROCEDURE IF EXISTS sp_board_alter_top//
CREATE PROCEDURE sp_board_alter_top(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT A.SYS_ID, A.BORD_GRUP, A.BORD_NO, A.BORD_TITLE, A.BORD_SEQ,
           DATE_FORMAT(A.REGI_DATE,'%Y.%m.%d') AS REGI_DATE
    FROM (
        SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE, BORD_SEQ, REGI_DATE
        FROM SYS_BORD
        WHERE SYS_ID = p_sys_id AND BORD_GRUP = 'B08' AND BORD_SEQ != 999999999
        ORDER BY BORD_SEQ ASC
    ) A
    LIMIT 0, 3;
END//

-- [sp_board_alter_bottom] 알림 하단 조회
DROP PROCEDURE IF EXISTS sp_board_alter_bottom//
CREATE PROCEDURE sp_board_alter_bottom(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT A.SYS_ID, A.BORD_GRUP, A.BORD_NO, A.BORD_TITLE, A.BORD_SEQ,
           DATE_FORMAT(A.REGI_DATE,'%Y.%m.%d') AS REGI_DATE
    FROM (
        SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE, BORD_SEQ, REGI_DATE
        FROM SYS_BORD
        WHERE SYS_ID = p_sys_id AND BORD_GRUP = 'B08' AND BORD_SEQ != 999999999
          AND NOT EXISTS (
              SELECT A.SYS_ID, A.BORD_GRUP, A.BORD_NO, A.BORD_TITLE, A.BORD_SEQ, A.REGI_DATE
              FROM (
                  SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE, BORD_SEQ, REGI_DATE
                  FROM SYS_BORD
                  WHERE SYS_ID = p_sys_id AND BORD_GRUP = 'B08' AND BORD_SEQ != 999999999
                  ORDER BY BORD_SEQ ASC
              ) A
              LIMIT 0, 3
          )
        UNION ALL
        SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE, BORD_SEQ, REGI_DATE
        FROM SYS_BORD
        WHERE SYS_ID = p_sys_id AND BORD_GRUP = 'B08' AND BORD_SEQ = 999999999
    ) A
    ORDER BY BORD_SEQ ASC, REGI_DATE DESC;
END//

-- [sp_board_reference_top] 참고자료 상단 조회
DROP PROCEDURE IF EXISTS sp_board_reference_top//
CREATE PROCEDURE sp_board_reference_top(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT A.SYS_ID, A.BORD_GRUP, A.BORD_NO, A.BORD_TITLE, A.BORD_SEQ,
           DATE_FORMAT(A.REGI_DATE,'%Y.%m.%d') AS REGI_DATE
    FROM (
        SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE, BORD_SEQ, REGI_DATE
        FROM SYS_BORD
        WHERE SYS_ID = p_sys_id AND BORD_GRUP = 'B03' AND BORD_SEQ != 999999999
        ORDER BY BORD_SEQ ASC
    ) A
    LIMIT 0, 3;
END//

-- [sp_board_reference_bottom] 참고자료 하단 조회
DROP PROCEDURE IF EXISTS sp_board_reference_bottom//
CREATE PROCEDURE sp_board_reference_bottom(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT A.SYS_ID, A.BORD_GRUP, A.BORD_NO, A.BORD_TITLE, A.BORD_SEQ,
           DATE_FORMAT(A.REGI_DATE,'%Y.%m.%d') AS REGI_DATE
    FROM (
        SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE, BORD_SEQ, REGI_DATE
        FROM SYS_BORD
        WHERE SYS_ID = p_sys_id AND BORD_GRUP = 'B03' AND BORD_SEQ != 999999999
          AND NOT EXISTS (
              SELECT A.SYS_ID, A.BORD_GRUP, A.BORD_NO, A.BORD_TITLE, A.BORD_SEQ, A.REGI_DATE
              FROM (
                  SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE, BORD_SEQ, REGI_DATE
                  FROM SYS_BORD
                  WHERE SYS_ID = p_sys_id AND BORD_GRUP = 'B03' AND BORD_SEQ != 999999999
                  ORDER BY BORD_SEQ ASC
              ) A
              LIMIT 0, 3
          )
        UNION ALL
        SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE, BORD_SEQ, REGI_DATE
        FROM SYS_BORD
        WHERE SYS_ID = p_sys_id AND BORD_GRUP = 'B03' AND BORD_SEQ = 999999999
    ) A
    ORDER BY BORD_SEQ ASC, REGI_DATE DESC;
END//

-- [sp_board_notice_top] 공지사항 상단 조회
DROP PROCEDURE IF EXISTS sp_board_notice_top//
CREATE PROCEDURE sp_board_notice_top(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT A.SYS_ID, A.BORD_GRUP, A.BORD_NO, A.BORD_TITLE, A.BORD_SEQ,
           DATE_FORMAT(A.REGI_DATE,'%Y.%m.%d') AS REGI_DATE
    FROM (
        SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE, BORD_SEQ, REGI_DATE
        FROM SYS_BORD
        WHERE SYS_ID = p_sys_id AND BORD_GRUP = 'B01' AND BORD_SEQ != 999999999
          AND BORD_END > DATE_FORMAT(CURDATE(), '%Y-%m-%d')
        ORDER BY BORD_SEQ ASC
    ) A
    LIMIT 0, 3;
END//

-- [sp_board_search_bord_detail] 게시판 상세 조회
DROP PROCEDURE IF EXISTS sp_board_search_bord_detail//
CREATE PROCEDURE sp_board_search_bord_detail(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(20)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.BORD_NO       AS bordNo,
        A.BORD_GRUP     AS bordGrup,
        A.BORD_TITLE    AS bordTitle,
        (SELECT MENU_DESC FROM SYS_MENU WHERE SYS_ID = p_sys_id AND MENU_KEY = A.BORD_TITLE) AS bordTitle2,
        A.BORD_TYPE     AS bordType,
        A.BORD_BGN      AS bordBgn,
        A.BORD_END      AS bordEnd,
        A.READ_CNT      AS readCnt,
        A.BORD_SEQ      AS bordSeq,
        A.BORD_PNO      AS bordPno,
        A.OPEN_TYPE     AS openType,
        A.USE_FLAG      AS useFlag,
        A.REGI_ID       AS regiId,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID       AS chngId,
        DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
        A.BORD_TEXT     AS bordText,
        'HELPVIEW'      AS gubun
    FROM SYS_BORD A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND A.BORD_TYPE = 'ALL'
      AND A.BORD_NO = p_bord_no;
END//

-- [sp_board_search_bord_index_b17] B17 게시판 인덱스 조회
DROP PROCEDURE IF EXISTS sp_board_search_bord_index_b17//
CREATE PROCEDURE sp_board_search_bord_index_b17()
BEGIN
    SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE,
           CONVERT(BORD_TEXT USING utf8) AS BORD_CONTENT,
           DATE_FORMAT(REGI_DATE, '%b %d. %Y') AS REGI_DATE
    FROM SYS_BORD
    WHERE BORD_GRUP = 'B17'
    ORDER BY BORD_SEQ ASC, BORD_NO DESC
    LIMIT 0, 10;
END//

-- [sp_board_search_bord_index_b19] B19 게시판 인덱스 조회
DROP PROCEDURE IF EXISTS sp_board_search_bord_index_b19//
CREATE PROCEDURE sp_board_search_bord_index_b19()
BEGIN
    SELECT SYS_ID, BORD_GRUP, BORD_NO, BORD_TITLE,
           CONVERT(BORD_TEXT USING utf8) AS BORD_CONTENT,
           DATE_FORMAT(REGI_DATE, '%b %d. %Y') AS REGI_DATE
    FROM SYS_BORD
    WHERE BORD_GRUP = 'B18'
    ORDER BY BORD_SEQ ASC, BORD_NO DESC
    LIMIT 0, 10;
END//

-- [sp_board_search_bord_img] 게시판 이미지 조회
DROP PROCEDURE IF EXISTS sp_board_search_bord_img//
CREATE PROCEDURE sp_board_search_bord_img(
    IN p_atch_grup VARCHAR(20),
    IN p_atch_no VARCHAR(20),
    IN p_file_image_path VARCHAR(500)
)
BEGIN
    SELECT FILE_NAME, SAVE_NAME, FILE_PATH, FILE_TYPE, FILE_SIZE,
           CONCAT(p_file_image_path, FILE_PATH, '/', SAVE_NAME) AS FULL_PATH
    FROM SYS_FILE
    WHERE ATCH_GRUP = p_atch_grup AND ATCH_NO = p_atch_no
    ORDER BY CASE WHEN THUMB_NAIL = 'Y' THEN 1 ELSE 2 END, FILE_NO;
END//

-- ============================================================
-- 4. 매뉴얼/기타 조회
-- ============================================================

-- [sp_board_get_manual_series] 매뉴얼 시리즈 목록
DROP PROCEDURE IF EXISTS sp_board_get_manual_series//
CREATE PROCEDURE sp_board_get_manual_series(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    SELECT A.*
    FROM (
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

-- [sp_board_get_manual_model] 매뉴얼 모델 목록
DROP PROCEDURE IF EXISTS sp_board_get_manual_model//
CREATE PROCEDURE sp_board_get_manual_model(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    SELECT A.*
    FROM (
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

-- [sp_board_get_regi_user_id] 등록자 ID 조회
DROP PROCEDURE IF EXISTS sp_board_get_regi_user_id//
CREATE PROCEDURE sp_board_get_regi_user_id(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(20)
)
BEGIN
    SELECT REGI_ID
    FROM SYS_BORD
    WHERE SYS_ID = p_sys_id AND BORD_GRUP = p_bord_grup AND BORD_NO = p_bord_no;
END//

-- [sp_board_dealer_check] 딜러 존재 여부 확인
DROP PROCEDURE IF EXISTS sp_board_dealer_check//
CREATE PROCEDURE sp_board_dealer_check(
    IN p_sys_id VARCHAR(20),
    IN p_dealer_list TEXT
)
BEGIN
    SELECT COUNT(*) AS CNT
    FROM DEAL_MAST
    WHERE SYS_ID = p_sys_id
      AND FIND_IN_SET(DEAL_CODE, p_dealer_list);
END//

-- [sp_board_edit_check] 수정 권한 체크
DROP PROCEDURE IF EXISTS sp_board_edit_check//
CREATE PROCEDURE sp_board_edit_check(
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    SELECT fn_get_board_editYN(p_gs_user_id) AS editYn;
END//

DELIMITER ;
