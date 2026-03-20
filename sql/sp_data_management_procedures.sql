-- ============================================================
-- DataManagement.xml -> 프로시저 전환 스크립트
-- namespace: com.wsc.common.report.DataManagement
-- 생성일: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. DATA_OPER_MAST 목록 조회 (페이징 포함)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_search//
CREATE PROCEDURE sp_data_management_search(
    IN p_sys_id VARCHAR(20),
    IN p_search_job_no VARCHAR(50),
    IN p_search_desc VARCHAR(200),
    IN p_start INT,
    IN p_end INT,
    IN p_sort_str VARCHAR(500)
)
BEGIN
    SET @rownum = 0;

    SET @v_sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT SYS_ID AS sysId
                          ,JOB_NO AS jobNo
                          ,JOB_DESC AS jobDesc
                          ,JOB_TYPE1 AS jobType1
                          ,JOB_TYPE2 AS jobType2
                          ,AUTH_TYPE AS authType
                          ,AUTH_GROUPS AS authGroups
                          ,AUTH_USERS AS authUsers
                          ,AUTH_FUNC AS authFunc
                          ,USE_YN AS useYn
                          ,JOB_SQL AS jobSql
                          ,REMK AS remk
                      FROM DATA_OPER_MAST A
                     WHERE SYS_ID = ''', p_sys_id, '''');

    IF p_search_job_no IS NOT NULL AND p_search_job_no != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND JOB_NO LIKE ''%', p_search_job_no, '%'' COLLATE utf8mb4_unicode_ci');
    END IF;

    IF p_search_desc IS NOT NULL AND p_search_desc != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND JOB_DESC LIKE ''%', p_search_desc, '%'' COLLATE utf8mb4_unicode_ci');
    END IF;

    -- 동적 정렬 (sortStr)
    IF p_sort_str IS NOT NULL AND p_sort_str != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY ', p_sort_str);
    ELSE
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY A.JOB_NO ASC, A.REGI_DATE DESC, A.CHNG_DATE DESC');
    END IF;

    SET @v_sql = CONCAT(@v_sql, '
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE (', IFNULL(p_end, 'NULL'), ' IS NULL OR RNUM < ', IFNULL(p_end, 999999999), ')
        ) X
        WHERE (', IFNULL(p_start, 'NULL'), ' IS NULL OR RNUM >= ', IFNULL(p_start, 0), ')');

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 2. DATA_OPER_DETL 상세 목록 조회 (페이징 포함)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_search_detl//
CREATE PROCEDURE sp_data_management_search_detl(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(50),
    IN p_start INT,
    IN p_end INT,
    IN p_sort_str VARCHAR(500)
)
BEGIN
    SET @rownum = 0;

    SET @v_sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT SYS_ID AS sysId
                          ,JOB_NO AS jobNo
                          ,PARAMETER_CODE AS parameterCode
                          ,PARAMETER_NAME AS parameterName
                          ,PARAMETER_SEQ AS parameterSeq
                          ,PARAMETER_TYPE AS parameterType
                          ,PARAMETER_LENGTH AS parameterLength
                          ,PARAMETER_DESC AS parameterDesc
                          ,PARAMETER_INIT_VAL AS parameterInitVal
                          ,USE_YN AS useYn
                      FROM DATA_OPER_DETL A
                     WHERE SYS_ID = ''', p_sys_id, '''
                       AND JOB_NO = ''', p_job_no, '''');

    -- 동적 정렬 (sortStr)
    IF p_sort_str IS NOT NULL AND p_sort_str != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY ', p_sort_str);
    ELSE
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY A.JOB_NO, A.PARAMETER_SEQ');
    END IF;

    SET @v_sql = CONCAT(@v_sql, '
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE (', IFNULL(p_end, 'NULL'), ' IS NULL OR RNUM < ', IFNULL(p_end, 999999999), ')
        ) X
        WHERE (', IFNULL(p_start, 'NULL'), ' IS NULL OR RNUM >= ', IFNULL(p_start, 0), ')');

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 3. DATA_OPER_MAST 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_search_count//
CREATE PROCEDURE sp_data_management_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_search_job_no VARCHAR(50),
    IN p_search_desc VARCHAR(200)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM DATA_OPER_MAST A
     WHERE SYS_ID = p_sys_id
       AND (p_search_job_no IS NULL OR p_search_job_no = '' OR JOB_NO LIKE CONCAT('%', p_search_job_no COLLATE utf8mb4_unicode_ci, '%'))
       AND (p_search_desc IS NULL OR p_search_desc = '' OR JOB_DESC LIKE CONCAT('%', p_search_desc COLLATE utf8mb4_unicode_ci, '%'));
END//

-- ============================================================
-- 4. DATA_OPER_DETL 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_search_detl_count//
CREATE PROCEDURE sp_data_management_search_detl_count(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM DATA_OPER_DETL A
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 5. DATA_OPER_MAST 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_select//
CREATE PROCEDURE sp_data_management_select(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(50)
)
BEGIN
    SELECT SYS_ID AS sysId
          ,JOB_NO AS jobNo
          ,JOB_DESC AS jobDesc
          ,JOB_TYPE1 AS jobType1
          ,JOB_TYPE2 AS jobType2
          ,AUTH_TYPE AS authType
          ,AUTH_GROUPS AS authGroups
          ,AUTH_USERS AS authUsers
          ,AUTH_FUNC AS authFunc
          ,USE_YN AS useYn
          ,JOB_SQL AS jobSql
          ,REMK AS remk
      FROM DATA_OPER_MAST A
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 6. JOB 번호 생성
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_get_job_no//
CREATE PROCEDURE sp_data_management_get_job_no(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT CONCAT('J', LPAD(CAST(IFNULL(SUBSTR(MAX(JOB_NO),2,5),'0') AS UNSIGNED)+1, 5, '0')) AS jobNo
      FROM DATA_OPER_MAST
     WHERE SYS_ID = p_sys_id;
END//

-- ============================================================
-- 7. DATA_OPER_MAST 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_insert//
CREATE PROCEDURE sp_data_management_insert(
    IN p_sys_id VARCHAR(20),
    IN p_job_desc VARCHAR(200),
    IN p_job_type1 VARCHAR(50),
    IN p_job_type2 VARCHAR(50),
    IN p_auth_type VARCHAR(20),
    IN p_auth_groups VARCHAR(500),
    IN p_auth_users VARCHAR(500),
    IN p_auth_func VARCHAR(100),
    IN p_use_yn VARCHAR(1),
    IN p_job_sql LONGTEXT,
    IN p_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_job_no VARCHAR(20);

    SELECT CONCAT('J', LPAD(CAST(IFNULL(SUBSTR(MAX(JOB_NO),2,5),'0') AS UNSIGNED)+1, 5, '0'))
      INTO v_job_no
      FROM DATA_OPER_MAST
     WHERE SYS_ID = p_sys_id;

    INSERT INTO DATA_OPER_MAST (
        SYS_ID, JOB_NO, JOB_DESC, JOB_TYPE1, JOB_TYPE2,
        AUTH_TYPE, AUTH_GROUPS, AUTH_USERS, AUTH_FUNC,
        USE_YN, JOB_SQL, REMK, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id, v_job_no,
        NULLIF(p_job_desc, ''), NULLIF(p_job_type1, ''), NULLIF(p_job_type2, ''),
        NULLIF(p_auth_type, ''), NULLIF(p_auth_groups, ''), NULLIF(p_auth_users, ''), NULLIF(p_auth_func, ''),
        NULLIF(p_use_yn, ''), NULLIF(p_job_sql, ''), NULLIF(p_remk, ''),
        p_gs_user_id, NOW()
    );
END//

-- ============================================================
-- 8. DATA_OPER_DETL 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_insert_detl//
CREATE PROCEDURE sp_data_management_insert_detl(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(50),
    IN p_parameter_code VARCHAR(50),
    IN p_parameter_name VARCHAR(100),
    IN p_parameter_seq INT,
    IN p_parameter_type VARCHAR(20),
    IN p_parameter_length INT,
    IN p_parameter_desc VARCHAR(200),
    IN p_parameter_init_val VARCHAR(200),
    IN p_use_yn VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO DATA_OPER_DETL (
        SYS_ID, JOB_NO, PARAMETER_CODE, PARAMETER_NAME, PARAMETER_SEQ,
        PARAMETER_TYPE, PARAMETER_LENGTH, PARAMETER_DESC, PARAMETER_INIT_VAL,
        USE_YN, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id, p_job_no,
        NULLIF(p_parameter_code, ''), NULLIF(p_parameter_name, ''), p_parameter_seq,
        NULLIF(p_parameter_type, ''), p_parameter_length, NULLIF(p_parameter_desc, ''), NULLIF(p_parameter_init_val, ''),
        NULLIF(p_use_yn, ''), p_gs_user_id, NOW()
    );
END//

-- ============================================================
-- 9. DATA_OPER_MAST 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_update//
CREATE PROCEDURE sp_data_management_update(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(50),
    IN p_job_desc VARCHAR(200),
    IN p_job_type1 VARCHAR(50),
    IN p_job_type2 VARCHAR(50),
    IN p_auth_type VARCHAR(20),
    IN p_auth_groups VARCHAR(500),
    IN p_auth_users VARCHAR(500),
    IN p_auth_func VARCHAR(100),
    IN p_use_yn VARCHAR(1),
    IN p_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE DATA_OPER_MAST
       SET CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
          ,JOB_DESC = p_job_desc
          ,JOB_TYPE1 = p_job_type1
          ,JOB_TYPE2 = p_job_type2
          ,AUTH_TYPE = p_auth_type
          ,AUTH_GROUPS = p_auth_groups
          ,AUTH_USERS = p_auth_users
          ,AUTH_FUNC = p_auth_func
          ,USE_YN = p_use_yn
          ,REMK = p_remk
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 10. DATA_OPER_DETL 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_update_detl//
CREATE PROCEDURE sp_data_management_update_detl(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(50),
    IN p_parameter_code VARCHAR(50),
    IN p_parameter_name VARCHAR(100),
    IN p_parameter_seq INT,
    IN p_parameter_type VARCHAR(20),
    IN p_parameter_length INT,
    IN p_parameter_desc VARCHAR(200),
    IN p_parameter_init_val VARCHAR(200),
    IN p_use_yn VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE DATA_OPER_DETL
       SET CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
          ,PARAMETER_NAME = p_parameter_name
          ,PARAMETER_SEQ = p_parameter_seq
          ,PARAMETER_TYPE = p_parameter_type
          ,PARAMETER_LENGTH = p_parameter_length
          ,PARAMETER_DESC = p_parameter_desc
          ,PARAMETER_INIT_VAL = p_parameter_init_val
          ,USE_YN = p_use_yn
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no
       AND PARAMETER_CODE = p_parameter_code;
END//

-- ============================================================
-- 11. JOB_SQL 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_update_sql//
CREATE PROCEDURE sp_data_management_update_sql(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(50),
    IN p_job_sql LONGTEXT
)
BEGIN
    UPDATE DATA_OPER_MAST
       SET JOB_SQL = p_job_sql
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 12. DATA_OPER_MAST 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_delete//
CREATE PROCEDURE sp_data_management_delete(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(50)
)
BEGIN
    DELETE FROM DATA_OPER_MAST
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 13. DATA_OPER_DETL 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_delete_detl//
CREATE PROCEDURE sp_data_management_delete_detl(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(50),
    IN p_parameter_code VARCHAR(50)
)
BEGIN
    DELETE FROM DATA_OPER_DETL
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no
       AND PARAMETER_CODE = p_parameter_code;
END//

-- ============================================================
-- 14. 사용자 타입 목록 조회 (NOT IN 처리) - FIND_IN_SET 사용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_user_type//
CREATE PROCEDURE sp_data_management_user_type(
    IN p_sys_id VARCHAR(20),
    IN p_user_type VARCHAR(500)
)
BEGIN
    -- p_user_type: 콤마로 구분된 값 (예: 'A01','A02' 또는 A01,A02)
    DECLARE v_clean_list VARCHAR(500);
    SET v_clean_list = REPLACE(REPLACE(p_user_type, '''', ''), ' ', '');

    SELECT CODE_CD AS codeCd
          ,CODE_NAME AS codeName
      FROM SYS_CODE
     WHERE SYS_ID = p_sys_id
       AND CODE_GRUP = 'USER_TYPE'
       AND (v_clean_list IS NULL OR v_clean_list = '' OR FIND_IN_SET(CODE_CD, v_clean_list) = 0);
END//

-- ============================================================
-- 15. 사용자 타입 타겟 조회 (IN 처리) - FIND_IN_SET 사용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_user_type_target//
CREATE PROCEDURE sp_data_management_user_type_target(
    IN p_sys_id VARCHAR(20),
    IN p_user_type_target VARCHAR(500)
)
BEGIN
    -- p_user_type_target: 콤마로 구분된 값 (예: 'A01','A02' 또는 A01,A02)
    DECLARE v_clean_list VARCHAR(500);
    SET v_clean_list = REPLACE(REPLACE(p_user_type_target, '''', ''), ' ', '');

    SELECT CODE_CD AS codeCd
          ,CODE_NAME AS codeName
      FROM SYS_CODE
     WHERE SYS_ID = p_sys_id
       AND CODE_GRUP = 'USER_TYPE'
       AND v_clean_list IS NOT NULL AND v_clean_list != ''
       AND FIND_IN_SET(CODE_CD, v_clean_list) > 0;
END//

-- ============================================================
-- 16. 그룹 목록 조회 (NOT IN 처리) - FIND_IN_SET 사용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_group_list//
CREATE PROCEDURE sp_data_management_group_list(
    IN p_sys_id VARCHAR(20),
    IN p_group VARCHAR(500)
)
BEGIN
    -- p_group: 콤마로 구분된 값 (예: 'G01','G02' 또는 G01,G02)
    DECLARE v_clean_list VARCHAR(500);
    SET v_clean_list = REPLACE(REPLACE(p_group, '''', ''), ' ', '');

    SELECT GROUP_ID AS groupId
          ,GROUP_NAME AS groupName
      FROM SYS_GRUP
     WHERE SYS_ID = p_sys_id
       AND (v_clean_list IS NULL OR v_clean_list = '' OR FIND_IN_SET(GROUP_ID, v_clean_list) = 0);
END//

-- ============================================================
-- 17. 그룹 타겟 조회 (IN 처리) - FIND_IN_SET 사용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_group_target//
CREATE PROCEDURE sp_data_management_group_target(
    IN p_sys_id VARCHAR(20),
    IN p_group_target VARCHAR(500)
)
BEGIN
    -- p_group_target: 콤마로 구분된 값 (예: 'G01','G02' 또는 G01,G02)
    DECLARE v_clean_list VARCHAR(500);
    SET v_clean_list = REPLACE(REPLACE(p_group_target, '''', ''), ' ', '');

    SELECT GROUP_ID AS groupId
          ,GROUP_NAME AS groupName
      FROM SYS_GRUP
     WHERE SYS_ID = p_sys_id
       AND v_clean_list IS NOT NULL AND v_clean_list != ''
       AND FIND_IN_SET(GROUP_ID, v_clean_list) > 0;
END//

-- ============================================================
-- 18. 사용자 ID 목록 조회 (NOT IN 처리) - FIND_IN_SET 사용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_user_id_list//
CREATE PROCEDURE sp_data_management_user_id_list(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(500)
)
BEGIN
    -- p_user_id: 콤마로 구분된 값 (예: 'user1','user2' 또는 user1,user2)
    DECLARE v_clean_list VARCHAR(500);
    SET v_clean_list = REPLACE(REPLACE(p_user_id, '''', ''), ' ', '');

    SELECT USER_ID AS userId
          ,USER_NAME AS userName
      FROM SYS_USER
     WHERE SYS_ID = p_sys_id
       AND USE_FLAG = 'Y'
       AND (v_clean_list IS NULL OR v_clean_list = '' OR FIND_IN_SET(USER_ID, v_clean_list) = 0);
END//

-- ============================================================
-- 19. 사용자 ID 타겟 조회 (IN 처리) - FIND_IN_SET 사용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_user_id_target//
CREATE PROCEDURE sp_data_management_user_id_target(
    IN p_sys_id VARCHAR(20),
    IN p_user_id_target VARCHAR(500)
)
BEGIN
    -- p_user_id_target: 콤마로 구분된 값 (예: 'user1','user2' 또는 user1,user2)
    DECLARE v_clean_list VARCHAR(500);
    SET v_clean_list = REPLACE(REPLACE(p_user_id_target, '''', ''), ' ', '');

    SELECT USER_ID AS userId
          ,USER_NAME AS userName
      FROM SYS_USER
     WHERE SYS_ID = p_sys_id
       AND USE_FLAG = 'Y'
       AND v_clean_list IS NOT NULL AND v_clean_list != ''
       AND FIND_IN_SET(USER_ID, v_clean_list) > 0;
END//

-- ============================================================
-- 20. 필드 타이틀 조회 (DataManagementgetFieldTitle)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_management_get_field_title//
CREATE PROCEDURE sp_data_management_get_field_title(
    IN p_sys_id VARCHAR(20),
    IN p_sort_str VARCHAR(500)
)
BEGIN
    SET @v_sql = CONCAT('
        SELECT SYS_ID AS sysId
              ,JOB_NO AS jobNo
              ,JOB_DESC AS jobDesc
              ,JOB_TYPE1 AS jobType1
              ,JOB_TYPE2 AS jobType2
              ,AUTH_TYPE AS authType
              ,AUTH_GROUPS AS authGroups
              ,AUTH_USERS AS authUsers
              ,AUTH_FUNC AS authFunc
              ,USE_YN AS useYn
              ,JOB_SQL AS jobSql
              ,REMK AS remk
          FROM DATA_OPER_MAST A
         WHERE SYS_ID = ''', p_sys_id, '''');

    -- 동적 정렬 (sortStr)
    IF p_sort_str IS NOT NULL AND p_sort_str != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY ', p_sort_str);
    ELSE
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY A.JOB_NO ASC, A.REGI_DATE DESC, A.CHNG_DATE DESC');
    END IF;

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

DELIMITER ;
