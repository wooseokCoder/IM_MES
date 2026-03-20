-- ============================================================
-- 파일명: sp_imes_attach_file_procedures.sql
-- 테이블: TSYS_FILELIST_MASTER
-- 설명: acAttachFileControl - 파일 첨부/다운로드/삭제 프로시저
-- 원본: ProActive acAttachFileControl.cs
-- 작성일: 2026-03-09
-- ============================================================
-- 실행 순서:
--   1) ALTER TABLE 구문으로 TSYS_FILELIST_MASTER에 컬럼 추가
--   2) 프로시저 생성
-- ============================================================

-- ============================================================
-- 0. TSYS_FILELIST_MASTER 테이블 컬럼 추가 (없으면 추가)
-- ============================================================

-- 공개 형태 (PUBLIC / PRIVATE)
ALTER TABLE TSYS_FILELIST_MASTER
    ADD COLUMN IF NOT EXISTS ACC_LEVEL VARCHAR(10) NOT NULL DEFAULT 'PUBLIC' COMMENT '공개형태' AFTER FILE_NAME;

-- 표시 순서
ALTER TABLE TSYS_FILELIST_MASTER
    ADD COLUMN IF NOT EXISTS FILE_SEQ INT NOT NULL DEFAULT 0 COMMENT '파일 순서' AFTER FILE_SIZE;

-- 삭제자 / 삭제일시
ALTER TABLE TSYS_FILELIST_MASTER
    ADD COLUMN IF NOT EXISTS DEL_EMP  VARCHAR(20)  NULL COMMENT '삭제자' AFTER MDFY_DATE;

ALTER TABLE TSYS_FILELIST_MASTER
    ADD COLUMN IF NOT EXISTS DEL_DATE DATETIME     NULL COMMENT '삭제일시' AFTER DEL_EMP;

-- ============================================================
-- 프로시저 구분선
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_attach_file_ser
-- 설명: 특정 LINK_KEY 에 연결된 파일 목록 조회
--       DATA_FLAG = 0 (활성 파일만)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_attach_file_ser//

CREATE PROCEDURE sp_imes_attach_file_ser(
    IN p_PLT_CODE    VARCHAR(3),
    IN p_UPLOAD_MENU VARCHAR(20),
    IN p_LINK_KEY    VARCHAR(200),
    IN p_DATA_FLAG   TINYINT
)
BEGIN
    SELECT
        F.FILE_ID                                              AS FILE_ID,
        F.FILE_SEQ                                             AS FILE_SEQ,
        F.ACC_LEVEL                                            AS ACC_LEVEL,
        F.FILE_NAME                                            AS FILE_NAME,
        F.FILE_SIZE                                            AS FILE_SIZE,
        F.LINK_KEY                                             AS LINK_KEY,
        F.UPLOAD_MENU                                          AS UPLOAD_MENU,
        F.REG_EMP                                              AS REG_EMP,
        IFNULL(U.USER_NAME, F.REG_EMP)                        AS REG_EMP_NAME,
        DATE_FORMAT(F.REG_DATE, '%Y-%m-%d %H:%i:%s')          AS REG_DATE
    FROM   TSYS_FILELIST_MASTER F
    LEFT JOIN SYS_USER U
           ON F.PLT_CODE = U.PLT_CODE
          AND F.REG_EMP  = U.USER_ID
    WHERE  F.PLT_CODE    = p_PLT_CODE
      AND  F.UPLOAD_MENU = p_UPLOAD_MENU
      AND  F.LINK_KEY    = p_LINK_KEY
      AND  F.DATA_FLAG   = p_DATA_FLAG
    ORDER BY F.FILE_SEQ ASC, F.REG_DATE ASC;
END//

-- ============================================================
-- sp_imes_attach_file_del_history_ser
-- 설명: 특정 LINK_KEY 의 삭제이력 조회
--       DATA_FLAG = 2 (삭제된 파일)
--       원본: TSYS_FILELIST_MASTER_QUERY3 → WHERE DATA_FLAG = 2
--             ATTACH_FILE_MASTER_SER → RSLTDT2 (FileDelHistoryGridView)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_attach_file_del_history_ser//

CREATE PROCEDURE sp_imes_attach_file_del_history_ser(
    IN p_PLT_CODE    VARCHAR(3),
    IN p_UPLOAD_MENU VARCHAR(20),
    IN p_LINK_KEY    VARCHAR(200)
)
BEGIN
    SELECT
        F.FILE_ID                                              AS FILE_ID,
        F.FILE_NAME                                            AS FILE_NAME,
        F.FILE_SIZE                                            AS FILE_SIZE,
        DATE_FORMAT(F.DEL_DATE, '%Y-%m-%d %H:%i:%s')          AS DEL_DATE,
        F.DEL_EMP                                              AS DEL_EMP,
        IFNULL(U.USER_NAME, F.DEL_EMP)                        AS DEL_EMP_NAME,
        DATE_FORMAT(F.REG_DATE, '%Y-%m-%d %H:%i:%s')          AS REG_DATE,
        F.UPLOAD_MENU                                          AS UPLOAD_MENU
    FROM   TSYS_FILELIST_MASTER F
    LEFT JOIN SYS_USER U
           ON F.PLT_CODE = U.PLT_CODE
          AND F.DEL_EMP  = U.USER_ID
    WHERE  F.PLT_CODE    = p_PLT_CODE
      AND  F.UPLOAD_MENU = p_UPLOAD_MENU
      AND  F.LINK_KEY    = p_LINK_KEY
      AND  F.DATA_FLAG   = 2
    ORDER BY F.DEL_DATE DESC;
END//

-- ============================================================
-- sp_imes_attach_file_ins
-- 설명: 파일 메타정보 INSERT
--       FILE_ID 채번 규칙: FL + yyMMdd + - + #### (4자리 일련번호)
--       예) FL260310-0001, FL260310-0002 ...
--       OUT p_FILE_ID: 채번된 FILE_ID 반환
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_attach_file_ins//

CREATE PROCEDURE sp_imes_attach_file_ins(
    IN  p_PLT_CODE    VARCHAR(3),
    IN  p_UPLOAD_MENU VARCHAR(20),
    IN  p_LINK_KEY    VARCHAR(200),
    IN  p_FILE_NAME   VARCHAR(500),
    IN  p_FILE_SIZE   BIGINT,
    IN  p_FILE_SEQ    INT,
    IN  p_ACC_LEVEL   VARCHAR(10),
    IN  p_REG_EMP     VARCHAR(20),
    IN  p_DATA_FLAG   TINYINT,
    OUT p_FILE_ID     VARCHAR(20)
)
BEGIN
    DECLARE v_date_prefix VARCHAR(9);   -- 'FL260310'
    DECLARE v_seq_no      INT;
    DECLARE v_file_id     VARCHAR(20);

    -- 오늘 날짜 기반 접두어: FL + yyMMdd (예: FL260310)
    SET v_date_prefix = CONCAT('FL', DATE_FORMAT(NOW(), '%y%m%d'));

    -- 동일 PLT_CODE + 오늘 날짜 접두어에서 현재 최대 일련번호 조회 후 +1
    -- FILE_ID 구조: FL(2) + yyMMdd(6) + -(1) + ####(4) = 13자
    -- SUBSTRING(FILE_ID, 10) → 9번째 문자('-') 다음부터 = 4자리 일련번호
    SELECT IFNULL(MAX(CAST(SUBSTRING(FILE_ID, 10) AS UNSIGNED)), 0) + 1
      INTO v_seq_no
      FROM TSYS_FILELIST_MASTER
     WHERE PLT_CODE = p_PLT_CODE
       AND FILE_ID LIKE CONCAT(v_date_prefix, '-%');

    -- FILE_ID 조합: FL260310-0001 형식
    SET v_file_id = CONCAT(v_date_prefix, '-', LPAD(v_seq_no, 4, '0'));

    INSERT INTO TSYS_FILELIST_MASTER (
        PLT_CODE,
        FILE_ID,
        UPLOAD_MENU,
        LINK_KEY,
        FILE_NAME,
        FILE_SIZE,
        FILE_SEQ,
        ACC_LEVEL,
        REG_EMP,
        REG_DATE,
        DATA_FLAG
    ) VALUES (
        p_PLT_CODE,
        v_file_id,
        p_UPLOAD_MENU,
        p_LINK_KEY,
        p_FILE_NAME,
        p_FILE_SIZE,
        p_FILE_SEQ,
        p_ACC_LEVEL,
        p_REG_EMP,
        NOW(),
        p_DATA_FLAG
    );

    SET p_FILE_ID = v_file_id;
END//

-- ============================================================
-- sp_imes_attach_file_del
-- 설명: 파일 논리 삭제 (DATA_FLAG = 2, 삭제자/삭제일 기록)
--       원본: TSYS_FILELIST_MASTER_QUERY3 → WHERE DATA_FLAG = 2
--       DATA_FLAG 의미: 0=활성, 2=삭제 (원본 시스템 규칙)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_attach_file_del//

CREATE PROCEDURE sp_imes_attach_file_del(
    IN p_PLT_CODE  VARCHAR(3),
    IN p_FILE_ID   VARCHAR(20),
    IN p_DEL_EMP   VARCHAR(20)
)
BEGIN
    UPDATE TSYS_FILELIST_MASTER
       SET DATA_FLAG = 2,
           DEL_EMP   = p_DEL_EMP,
           DEL_DATE  = NOW()
     WHERE PLT_CODE  = p_PLT_CODE
       AND FILE_ID   = p_FILE_ID;
END//

-- ============================================================
-- sp_imes_attach_file_get_seq
-- 설명: 특정 LINK_KEY 의 다음 FILE_SEQ 를 반환 (MAX+1)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_attach_file_get_seq//

CREATE PROCEDURE sp_imes_attach_file_get_seq(
    IN  p_PLT_CODE    VARCHAR(3),
    IN  p_UPLOAD_MENU VARCHAR(20),
    IN  p_LINK_KEY    VARCHAR(200),
    OUT p_NEXT_SEQ    INT
)
BEGIN
    SELECT IFNULL(MAX(FILE_SEQ), 0) + 1
      INTO p_NEXT_SEQ
      FROM TSYS_FILELIST_MASTER
     WHERE PLT_CODE    = p_PLT_CODE
       AND UPLOAD_MENU = p_UPLOAD_MENU
       AND LINK_KEY    = p_LINK_KEY
       AND DATA_FLAG   = 0;
END//

-- ============================================================
-- sp_imes_attach_file_rename
-- 설명: 파일명 변경 (이름 바꾸기)
--       원본: btnRename_ItemClick → ATTACH_FILE_MASTER_SER4 → inline cell edit
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_attach_file_rename//

CREATE PROCEDURE sp_imes_attach_file_rename(
    IN p_PLT_CODE  VARCHAR(3),
    IN p_FILE_ID   VARCHAR(20),
    IN p_FILE_NAME VARCHAR(500),
    IN p_MDFY_EMP  VARCHAR(20)
)
BEGIN
    UPDATE TSYS_FILELIST_MASTER
       SET FILE_NAME  = p_FILE_NAME,
           MDFY_EMP   = p_MDFY_EMP,
           MDFY_DATE  = NOW()
     WHERE PLT_CODE   = p_PLT_CODE
       AND FILE_ID    = p_FILE_ID
       AND DATA_FLAG  = 0;
END//

-- ============================================================
-- sp_imes_attach_file_acc_level_upd
-- 설명: 공개형태 변경 (PUBLIC / PRIVATE)
--       원본: AccLevelChange_ItemClick → ATTACH_FILE_MASTER_UPD2
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_attach_file_acc_level_upd//

CREATE PROCEDURE sp_imes_attach_file_acc_level_upd(
    IN p_PLT_CODE  VARCHAR(3),
    IN p_FILE_ID   VARCHAR(20),
    IN p_ACC_LEVEL VARCHAR(10),
    IN p_MDFY_EMP  VARCHAR(20)
)
BEGIN
    UPDATE TSYS_FILELIST_MASTER
       SET ACC_LEVEL  = p_ACC_LEVEL,
           MDFY_EMP   = p_MDFY_EMP,
           MDFY_DATE  = NOW()
     WHERE PLT_CODE   = p_PLT_CODE
       AND FILE_ID    = p_FILE_ID
       AND DATA_FLAG  = 0;
END//

DELIMITER ;
