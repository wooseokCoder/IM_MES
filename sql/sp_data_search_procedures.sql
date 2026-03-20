-- ============================================================
-- DataSearch.xml -> 프로시저 전환 스크립트
-- namespace: com.wsc.common.report.DataSearch
-- 생성일: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. [search] DATA_OPER_MAST 목록 조회 (페이징 + 동적 검색 + 동적 정렬)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_search//
CREATE PROCEDURE sp_data_search_search(
    IN p_sys_id VARCHAR(20),
    IN p_search_empl_name VARCHAR(100),
    IN p_comp_code VARCHAR(20),
    IN p_search_job_no VARCHAR(20),
    IN p_dept_code VARCHAR(20),
    IN p_dept_name VARCHAR(100),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_empl_tel VARCHAR(50),
    IN p_empl_hp VARCHAR(50),
    IN p_empl_mail VARCHAR(100),
    IN p_empl_remk VARCHAR(500),
    IN p_exit_yn VARCHAR(10),
    IN p_gs_lang VARCHAR(10),
    IN p_sort_str VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum = 0;

    SET @v_sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT SYS_ID AS sysId
                          ,CASE COMP_CODE WHEN ''A'' THEN '''' WHEN ''01'' THEN ''국내사업부'' WHEN ''02'' THEN ''중국사업부''
                           ELSE COMP_CODE END AS compCode
                          ,JOB_NO AS jobNo
                          ,EMPL_NAME AS emplName
                          ,EMPL_NAME_ENG AS emplNameEng
                          ,EMPL_NAME_HAN AS emplNameHan
                          ,SOCI_SECU_NO AS sociSecuNo
                          ,BIRTH_DAY AS birthDay
                          ,SOL_LUN_CAL AS solLunCal
                          ,GENDER AS gender
                          ,JOIN_DAY AS joinDay
                          ,DEPT_CODE AS deptCode
                          ,fn_get_code_name(''DEPT_CODE'', DEPT_CODE, ''', IFNULL(p_gs_lang, 'en'), ''') AS deptName
                          ,UPPR_DEPT_CODE AS upprDeptCode
                          ,fn_get_code_name(''PST_TYPE'', POSITION, ''', IFNULL(p_gs_lang, 'en'), ''') AS position
                          ,BUSI_CHARGE AS busiCharge
                          ,ADDRESS AS address
                          ,ADD_NO AS addNo
                          ,BON_ADDRESS AS bonAddress
                          ,BON_ADD_NO AS bonAddNo
                          ,EMPL_TEL AS emplTel
                          ,EMPL_HP AS emplHp
                          ,EMPL_MAIL AS emplMail
                          ,BLOOD_TYPE AS bloodType
                          ,HEIGTH AS heigth
                          ,SIGHT AS sight
                          ,HOBBY AS hobby
                          ,RELIGION AS religion
                          ,MEDICAL_HISTORY AS medicalHistory
                          ,WEIGTH AS weigth
                          ,GARDEN AS garden
                          ,ESTATE AS estate
                          ,DWELLING AS dwelling
                          ,SITE AS site
                          ,PHOTO AS photo
                          ,EMPL_REMK AS emplRemk
                          ,CASE EXIT_YN WHEN ''A'' THEN '''' WHEN ''Y'' THEN ''재직중'' WHEN ''N'' THEN ''퇴사''
                           ELSE EXIT_YN END AS exitYn
                          ,EXIT_DATE AS exitDate
                          ,REGI_ID AS regiId
                          ,DATE_FORMAT(REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate
                          ,CHNG_ID AS chngId
                          ,DATE_FORMAT(CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate
                      FROM DATA_OPER_MAST A
                     WHERE SYS_ID = ''', p_sys_id, '''');

    -- 동적 검색 조건
    IF p_search_empl_name IS NOT NULL AND p_search_empl_name != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_NAME LIKE ''%', p_search_empl_name, '%''');
    END IF;
    IF p_comp_code IS NOT NULL AND p_comp_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND COMP_CODE = ''', p_comp_code, '''');
    END IF;
    IF p_search_job_no IS NOT NULL AND p_search_job_no != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND JOB_NO = ''', p_search_job_no, '''');
    END IF;
    IF p_dept_code IS NOT NULL AND p_dept_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND DEPT_CODE = ''', p_dept_code, '''');
    END IF;
    IF p_dept_name IS NOT NULL AND p_dept_name != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND DEPT_NAME = ''', p_dept_name, '''');
    END IF;
    IF p_uppr_dept_code IS NOT NULL AND p_uppr_dept_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND UPPR_DEPT_CODE = ''', p_uppr_dept_code, '''');
    END IF;
    IF p_empl_tel IS NOT NULL AND p_empl_tel != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_TEL = ''', p_empl_tel, '''');
    END IF;
    IF p_empl_hp IS NOT NULL AND p_empl_hp != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_HP = ''', p_empl_hp, '''');
    END IF;
    IF p_empl_mail IS NOT NULL AND p_empl_mail != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_MAIL = ''', p_empl_mail, '''');
    END IF;
    IF p_empl_remk IS NOT NULL AND p_empl_remk != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_REMK = ''', p_empl_remk, '''');
    END IF;
    IF p_exit_yn IS NOT NULL AND p_exit_yn != '' THEN
        IF p_exit_yn = 'ALL' THEN
            SET @v_sql = @v_sql; -- 조건 없음
        ELSE
            SET @v_sql = CONCAT(@v_sql, ' AND EXIT_YN = ''', p_exit_yn, '''');
        END IF;
    END IF;

    -- 동적 정렬
    IF p_sort_str IS NOT NULL AND p_sort_str != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY ', p_sort_str);
    ELSE
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY A.REGI_DATE DESC, A.CHNG_DATE DESC');
    END IF;

    -- 페이징 처리
    IF p_start IS NOT NULL AND p_end IS NOT NULL THEN
        SET @v_sql = CONCAT(@v_sql, '
                    ) Z1, (SELECT @rownum:=0) Z2
                ) X
                WHERE RNUM < ', p_end, '
            ) X
            WHERE RNUM >= ', p_start);
    ELSE
        SET @v_sql = CONCAT(@v_sql, '
                    ) Z1, (SELECT @rownum:=0) Z2
                ) X
            ) X');
    END IF;

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 2. [searchCount] DATA_OPER_MAST 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_search_count//
CREATE PROCEDURE sp_data_search_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_search_empl_name VARCHAR(100),
    IN p_comp_code VARCHAR(20),
    IN p_search_job_no VARCHAR(20),
    IN p_dept_code VARCHAR(20),
    IN p_dept_name VARCHAR(100),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_empl_tel VARCHAR(50),
    IN p_empl_hp VARCHAR(50),
    IN p_empl_mail VARCHAR(100),
    IN p_empl_remk VARCHAR(500),
    IN p_exit_yn VARCHAR(10)
)
BEGIN
    SET @v_sql = CONCAT('
        SELECT COUNT(1) AS cnt
          FROM DATA_OPER_MAST A
         WHERE SYS_ID = ''', p_sys_id, '''');

    IF p_search_empl_name IS NOT NULL AND p_search_empl_name != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_NAME LIKE ''%', p_search_empl_name, '%''');
    END IF;
    IF p_comp_code IS NOT NULL AND p_comp_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND COMP_CODE = ''', p_comp_code, '''');
    END IF;
    IF p_search_job_no IS NOT NULL AND p_search_job_no != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND JOB_NO = ''', p_search_job_no, '''');
    END IF;
    IF p_dept_code IS NOT NULL AND p_dept_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND DEPT_CODE = ''', p_dept_code, '''');
    END IF;
    IF p_dept_name IS NOT NULL AND p_dept_name != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND DEPT_NAME = ''', p_dept_name, '''');
    END IF;
    IF p_uppr_dept_code IS NOT NULL AND p_uppr_dept_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND UPPR_DEPT_CODE = ''', p_uppr_dept_code, '''');
    END IF;
    IF p_empl_tel IS NOT NULL AND p_empl_tel != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_TEL = ''', p_empl_tel, '''');
    END IF;
    IF p_empl_hp IS NOT NULL AND p_empl_hp != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_HP = ''', p_empl_hp, '''');
    END IF;
    IF p_empl_mail IS NOT NULL AND p_empl_mail != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_MAIL = ''', p_empl_mail, '''');
    END IF;
    IF p_empl_remk IS NOT NULL AND p_empl_remk != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_REMK = ''', p_empl_remk, '''');
    END IF;
    IF p_exit_yn IS NOT NULL AND p_exit_yn != '' AND p_exit_yn != 'ALL' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EXIT_YN = ''', p_exit_yn, '''');
    END IF;

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 3. [searchSub] DATA_OPER_DETL 서브 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_sub//
CREATE PROCEDURE sp_data_search_sub(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(20)
)
BEGIN
    SELECT PARAMETER_CODE AS parameterCode
          ,PARAMETER_TYPE AS parameterType
          ,PARAMETER_NAME AS parameterName
          ,PARAMETER_DESC AS parameterDesc
          ,PARAMETER_INIT_VAL AS parameterInitVal
      FROM DATA_OPER_DETL A
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no
     ORDER BY PARAMETER_SEQ;
END//

-- ============================================================
-- 4. [searchSubCount] DATA_OPER_DETL 서브 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_sub_count//
CREATE PROCEDURE sp_data_search_sub_count(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(20)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM DATA_OPER_DETL A
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 5. [searchAll] DATA_OPER_MAST 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_select//
CREATE PROCEDURE sp_data_search_select(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(20),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT SYS_ID AS sysId
          ,CASE COMP_CODE WHEN 'A' THEN '' WHEN '01' THEN '국내사업부' WHEN '02' THEN '중국사업부'
           ELSE COMP_CODE END AS compCode
          ,JOB_NO AS jobNo
          ,EMPL_NAME AS emplName
          ,EMPL_NAME_ENG AS emplNameEng
          ,EMPL_NAME_HAN AS emplNameHan
          ,SOCI_SECU_NO AS sociSecuNo
          ,BIRTH_DAY AS birthDay
          ,SOL_LUN_CAL AS solLunCal
          ,GENDER AS gender
          ,JOIN_DAY AS joinDay
          ,DEPT_CODE AS deptCode
          ,fn_get_code_name('DEPT_CODE', DEPT_CODE, IFNULL(p_gs_lang, 'en')) AS deptName
          ,UPPR_DEPT_CODE AS upprDeptCode
          ,fn_get_code_name('PST_TYPE', POSITION, IFNULL(p_gs_lang, 'en')) AS position
          ,BUSI_CHARGE AS busiCharge
          ,ADDRESS AS address
          ,ADD_NO AS addNo
          ,BON_ADDRESS AS bonAddress
          ,BON_ADD_NO AS bonAddNo
          ,EMPL_TEL AS emplTel
          ,EMPL_HP AS emplHp
          ,EMPL_MAIL AS emplMail
          ,BLOOD_TYPE AS bloodType
          ,HEIGTH AS heigth
          ,SIGHT AS sight
          ,HOBBY AS hobby
          ,RELIGION AS religion
          ,MEDICAL_HISTORY AS medicalHistory
          ,WEIGTH AS weigth
          ,GARDEN AS garden
          ,ESTATE AS estate
          ,DWELLING AS dwelling
          ,SITE AS site
          ,PHOTO AS photo
          ,EMPL_REMK AS emplRemk
          ,CASE EXIT_YN WHEN 'A' THEN '' WHEN 'Y' THEN '재직중' WHEN 'N' THEN '퇴사'
           ELSE EXIT_YN END AS exitYn
          ,EXIT_DATE AS exitDate
          ,REGI_ID AS regiId
          ,DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate
          ,CHNG_ID AS chngId
          ,DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate
      FROM DATA_OPER_MAST A
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 6. [getjobNo] JOB_NO 생성
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_get_job_no//
CREATE PROCEDURE sp_data_search_get_job_no(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT CONCAT('E', LPAD(CAST(IFNULL(SUBSTR(MAX(JOB_NO), 2, 5), '0') AS UNSIGNED) + 1, 5, '0')) AS jobNo
      FROM DATA_OPER_MAST
     WHERE SYS_ID = p_sys_id;
END//

-- ============================================================
-- 7. [insert] DATA_OPER_MAST 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_insert//
CREATE PROCEDURE sp_data_search_insert(
    IN p_sys_id VARCHAR(20),
    IN p_empl_name VARCHAR(100),
    IN p_empl_name_eng VARCHAR(100),
    IN p_empl_name_han VARCHAR(100),
    IN p_soci_secu_no VARCHAR(20),
    IN p_birth_day VARCHAR(10),
    IN p_sol_lun_cal VARCHAR(10),
    IN p_gender VARCHAR(10),
    IN p_join_day VARCHAR(10),
    IN p_dept_code VARCHAR(20),
    IN p_dept_name VARCHAR(100),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_position VARCHAR(50),
    IN p_busi_charge VARCHAR(100),
    IN p_address VARCHAR(500),
    IN p_add_no VARCHAR(20),
    IN p_bon_address VARCHAR(500),
    IN p_bon_add_no VARCHAR(20),
    IN p_empl_tel VARCHAR(50),
    IN p_empl_hp VARCHAR(50),
    IN p_empl_mail VARCHAR(100),
    IN p_blood_type VARCHAR(10),
    IN p_heigth VARCHAR(10),
    IN p_sight VARCHAR(20),
    IN p_hobby VARCHAR(200),
    IN p_religion VARCHAR(50),
    IN p_medical_history VARCHAR(500),
    IN p_weigth VARCHAR(10),
    IN p_garden VARCHAR(100),
    IN p_estate VARCHAR(100),
    IN p_dwelling VARCHAR(100),
    IN p_site VARCHAR(200),
    IN p_photo VARCHAR(200),
    IN p_empl_remk VARCHAR(500),
    IN p_exit_yn VARCHAR(10),
    IN p_exit_date VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_job_no VARCHAR(20);

    -- JOB_NO 생성
    SELECT CONCAT('E', LPAD(CAST(IFNULL(SUBSTR(MAX(JOB_NO), 2, 5), '0') AS UNSIGNED) + 1, 5, '0'))
      INTO v_job_no
      FROM DATA_OPER_MAST
     WHERE SYS_ID = p_sys_id;

    INSERT INTO DATA_OPER_MAST (
        SYS_ID, COMP_CODE, JOB_NO, EMPL_NAME, EMPL_NAME_ENG, EMPL_NAME_HAN,
        SOCI_SECU_NO, BIRTH_DAY, SOL_LUN_CAL, GENDER, JOIN_DAY,
        DEPT_CODE, DEPT_NAME, UPPR_DEPT_CODE, POSITION, BUSI_CHARGE,
        ADDRESS, ADD_NO, BON_ADDRESS, BON_ADD_NO,
        EMPL_TEL, EMPL_HP, EMPL_MAIL, BLOOD_TYPE, HEIGTH, SIGHT,
        HOBBY, RELIGION, MEDICAL_HISTORY, WEIGTH,
        GARDEN, ESTATE, DWELLING, SITE, PHOTO, EMPL_REMK,
        EXIT_YN, EXIT_DATE, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id, '01', v_job_no,
        NULLIF(p_empl_name, ''), NULLIF(p_empl_name_eng, ''), NULLIF(p_empl_name_han, ''),
        NULLIF(p_soci_secu_no, ''), NULLIF(p_birth_day, ''), NULLIF(p_sol_lun_cal, ''),
        NULLIF(p_gender, ''), NULLIF(p_join_day, ''),
        NULLIF(p_dept_code, ''), NULLIF(p_dept_name, ''), NULLIF(p_uppr_dept_code, ''),
        NULLIF(p_position, ''), NULLIF(p_busi_charge, ''),
        NULLIF(p_address, ''), NULLIF(p_add_no, ''), NULLIF(p_bon_address, ''), NULLIF(p_bon_add_no, ''),
        NULLIF(p_empl_tel, ''), NULLIF(p_empl_hp, ''), NULLIF(p_empl_mail, ''),
        NULLIF(p_blood_type, ''), NULLIF(p_heigth, ''), NULLIF(p_sight, ''),
        NULLIF(p_hobby, ''), NULLIF(p_religion, ''), NULLIF(p_medical_history, ''), NULLIF(p_weigth, ''),
        NULLIF(p_garden, ''), NULLIF(p_estate, ''), NULLIF(p_dwelling, ''),
        NULLIF(p_site, ''), NULLIF(p_photo, ''), NULLIF(p_empl_remk, ''),
        IFNULL(NULLIF(p_exit_yn, ''), 'Y'), NULLIF(p_exit_date, ''),
        p_gs_user_id, NOW()
    );
END//

-- ============================================================
-- 8. [update] DATA_OPER_MAST 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_update//
CREATE PROCEDURE sp_data_search_update(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(20),
    IN p_empl_name VARCHAR(100),
    IN p_empl_name_eng VARCHAR(100),
    IN p_empl_name_han VARCHAR(100),
    IN p_soci_secu_no VARCHAR(20),
    IN p_birth_day VARCHAR(10),
    IN p_sol_lun_cal VARCHAR(10),
    IN p_gender VARCHAR(10),
    IN p_join_day VARCHAR(10),
    IN p_dept_code VARCHAR(20),
    IN p_dept_name VARCHAR(100),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_position VARCHAR(50),
    IN p_busi_charge VARCHAR(100),
    IN p_address VARCHAR(500),
    IN p_add_no VARCHAR(20),
    IN p_bon_address VARCHAR(500),
    IN p_bon_add_no VARCHAR(20),
    IN p_empl_tel VARCHAR(50),
    IN p_empl_hp VARCHAR(50),
    IN p_empl_mail VARCHAR(100),
    IN p_blood_type VARCHAR(10),
    IN p_heigth VARCHAR(10),
    IN p_sight VARCHAR(20),
    IN p_hobby VARCHAR(200),
    IN p_religion VARCHAR(50),
    IN p_medical_history VARCHAR(500),
    IN p_weigth VARCHAR(10),
    IN p_garden VARCHAR(100),
    IN p_estate VARCHAR(100),
    IN p_dwelling VARCHAR(100),
    IN p_site VARCHAR(200),
    IN p_photo VARCHAR(200),
    IN p_empl_remk VARCHAR(500),
    IN p_exit_yn VARCHAR(10),
    IN p_exit_date VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE DATA_OPER_MAST
       SET CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
          ,EMPL_NAME = IFNULL(NULLIF(p_empl_name, ''), EMPL_NAME)
          ,EMPL_NAME_ENG = IFNULL(NULLIF(p_empl_name_eng, ''), EMPL_NAME_ENG)
          ,EMPL_NAME_HAN = IFNULL(NULLIF(p_empl_name_han, ''), EMPL_NAME_HAN)
          ,SOCI_SECU_NO = IFNULL(NULLIF(p_soci_secu_no, ''), SOCI_SECU_NO)
          ,BIRTH_DAY = IFNULL(NULLIF(p_birth_day, ''), BIRTH_DAY)
          ,SOL_LUN_CAL = IFNULL(NULLIF(p_sol_lun_cal, ''), SOL_LUN_CAL)
          ,GENDER = IFNULL(NULLIF(p_gender, ''), GENDER)
          ,JOIN_DAY = IFNULL(NULLIF(p_join_day, ''), JOIN_DAY)
          ,DEPT_CODE = IFNULL(NULLIF(p_dept_code, ''), DEPT_CODE)
          ,DEPT_NAME = IFNULL(NULLIF(p_dept_name, ''), DEPT_NAME)
          ,UPPR_DEPT_CODE = IFNULL(NULLIF(p_uppr_dept_code, ''), UPPR_DEPT_CODE)
          ,POSITION = IFNULL(NULLIF(p_position, ''), POSITION)
          ,BUSI_CHARGE = IFNULL(NULLIF(p_busi_charge, ''), BUSI_CHARGE)
          ,ADDRESS = IFNULL(NULLIF(p_address, ''), ADDRESS)
          ,ADD_NO = IFNULL(NULLIF(p_add_no, ''), ADD_NO)
          ,BON_ADDRESS = IFNULL(NULLIF(p_bon_address, ''), BON_ADDRESS)
          ,BON_ADD_NO = IFNULL(NULLIF(p_bon_add_no, ''), BON_ADD_NO)
          ,EMPL_TEL = IFNULL(NULLIF(p_empl_tel, ''), EMPL_TEL)
          ,EMPL_HP = IFNULL(NULLIF(p_empl_hp, ''), EMPL_HP)
          ,EMPL_MAIL = IFNULL(NULLIF(p_empl_mail, ''), EMPL_MAIL)
          ,BLOOD_TYPE = IFNULL(NULLIF(p_blood_type, ''), BLOOD_TYPE)
          ,HEIGTH = IFNULL(NULLIF(p_heigth, ''), HEIGTH)
          ,SIGHT = IFNULL(NULLIF(p_sight, ''), SIGHT)
          ,HOBBY = IFNULL(NULLIF(p_hobby, ''), HOBBY)
          ,RELIGION = IFNULL(NULLIF(p_religion, ''), RELIGION)
          ,MEDICAL_HISTORY = IFNULL(NULLIF(p_medical_history, ''), MEDICAL_HISTORY)
          ,WEIGTH = IFNULL(NULLIF(p_weigth, ''), WEIGTH)
          ,GARDEN = IFNULL(NULLIF(p_garden, ''), GARDEN)
          ,ESTATE = IFNULL(NULLIF(p_estate, ''), ESTATE)
          ,DWELLING = IFNULL(NULLIF(p_dwelling, ''), DWELLING)
          ,SITE = IFNULL(NULLIF(p_site, ''), SITE)
          ,PHOTO = IFNULL(NULLIF(p_photo, ''), PHOTO)
          ,EMPL_REMK = IFNULL(NULLIF(p_empl_remk, ''), EMPL_REMK)
          ,EXIT_YN = IFNULL(NULLIF(p_exit_yn, ''), EXIT_YN)
          ,EXIT_DATE = IFNULL(NULLIF(p_exit_date, ''), EXIT_DATE)
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 9. [delete] DATA_OPER_MAST 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_delete//
CREATE PROCEDURE sp_data_search_delete(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(20)
)
BEGIN
    DELETE FROM DATA_OPER_MAST
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 10. [DataSearchgetFieldTitle] 필드 타이틀 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_get_field_title//
CREATE PROCEDURE sp_data_search_get_field_title(
    IN p_sys_id VARCHAR(20),
    IN p_search_empl_name VARCHAR(100),
    IN p_comp_code VARCHAR(20),
    IN p_search_job_no VARCHAR(20),
    IN p_dept_code VARCHAR(20),
    IN p_dept_name VARCHAR(100),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_empl_tel VARCHAR(50),
    IN p_empl_hp VARCHAR(50),
    IN p_empl_mail VARCHAR(100),
    IN p_empl_remk VARCHAR(500),
    IN p_exit_yn VARCHAR(10),
    IN p_gs_lang VARCHAR(10),
    IN p_sort_str VARCHAR(500)
)
BEGIN
    SET @v_sql = CONCAT('
        SELECT SYS_ID AS sysId
              ,CASE COMP_CODE WHEN ''A'' THEN '''' WHEN ''01'' THEN ''국내사업부'' WHEN ''02'' THEN ''중국사업부''
               ELSE COMP_CODE END AS compCode
              ,JOB_NO AS jobNo
              ,EMPL_NAME AS emplName
              ,EMPL_NAME_ENG AS emplNameEng
              ,EMPL_NAME_HAN AS emplNameHan
              ,SOCI_SECU_NO AS sociSecuNo
              ,BIRTH_DAY AS birthDay
              ,SOL_LUN_CAL AS solLunCal
              ,GENDER AS gender
              ,JOIN_DAY AS joinDay
              ,DEPT_CODE AS deptCode
              ,fn_get_code_name(''DEPT_CODE'', DEPT_CODE, ''', IFNULL(p_gs_lang, 'en'), ''') AS deptName
              ,UPPR_DEPT_CODE AS upprDeptCode
              ,fn_get_code_name(''PST_TYPE'', POSITION, ''', IFNULL(p_gs_lang, 'en'), ''') AS position
              ,BUSI_CHARGE AS busiCharge
              ,ADDRESS AS address
              ,ADD_NO AS addNo
              ,BON_ADDRESS AS bonAddress
              ,BON_ADD_NO AS bonAddNo
              ,EMPL_TEL AS emplTel
              ,EMPL_HP AS emplHp
              ,EMPL_MAIL AS emplMail
              ,BLOOD_TYPE AS bloodType
              ,HEIGTH AS heigth
              ,SIGHT AS sight
              ,HOBBY AS hobby
              ,RELIGION AS religion
              ,MEDICAL_HISTORY AS medicalHistory
              ,WEIGTH AS weigth
              ,GARDEN AS garden
              ,ESTATE AS estate
              ,DWELLING AS dwelling
              ,SITE AS site
              ,PHOTO AS photo
              ,EMPL_REMK AS emplRemk
              ,CASE EXIT_YN WHEN ''A'' THEN '''' WHEN ''Y'' THEN ''재직중'' WHEN ''N'' THEN ''퇴사''
               ELSE EXIT_YN END AS exitYn
              ,EXIT_DATE AS exitDate
              ,REGI_ID AS regiId
              ,DATE_FORMAT(REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate
              ,CHNG_ID AS chngId
              ,DATE_FORMAT(CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate
          FROM DATA_OPER_MAST A
         WHERE SYS_ID = ''', p_sys_id, '''');

    -- 동적 검색 조건 (whereClause와 동일)
    IF p_search_empl_name IS NOT NULL AND p_search_empl_name != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_NAME LIKE ''%', p_search_empl_name, '%''');
    END IF;
    IF p_comp_code IS NOT NULL AND p_comp_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND COMP_CODE = ''', p_comp_code, '''');
    END IF;
    IF p_search_job_no IS NOT NULL AND p_search_job_no != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND JOB_NO = ''', p_search_job_no, '''');
    END IF;
    IF p_dept_code IS NOT NULL AND p_dept_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND DEPT_CODE = ''', p_dept_code, '''');
    END IF;
    IF p_dept_name IS NOT NULL AND p_dept_name != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND DEPT_NAME = ''', p_dept_name, '''');
    END IF;
    IF p_uppr_dept_code IS NOT NULL AND p_uppr_dept_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND UPPR_DEPT_CODE = ''', p_uppr_dept_code, '''');
    END IF;
    IF p_empl_tel IS NOT NULL AND p_empl_tel != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_TEL = ''', p_empl_tel, '''');
    END IF;
    IF p_empl_hp IS NOT NULL AND p_empl_hp != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_HP = ''', p_empl_hp, '''');
    END IF;
    IF p_empl_mail IS NOT NULL AND p_empl_mail != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_MAIL = ''', p_empl_mail, '''');
    END IF;
    IF p_empl_remk IS NOT NULL AND p_empl_remk != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EMPL_REMK = ''', p_empl_remk, '''');
    END IF;
    IF p_exit_yn IS NOT NULL AND p_exit_yn != '' AND p_exit_yn != 'ALL' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND EXIT_YN = ''', p_exit_yn, '''');
    END IF;

    -- 동적 정렬
    IF p_sort_str IS NOT NULL AND p_sort_str != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY ', p_sort_str);
    ELSE
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY A.REGI_DATE DESC, A.CHNG_DATE DESC');
    END IF;

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 11. [getSqlData] SQL 데이터 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_get_sql_data//
CREATE PROCEDURE sp_data_search_get_sql_data(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(20)
)
BEGIN
    SELECT JOB_SQL AS jobSql
      FROM DATA_OPER_MAST A
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no;
END//

-- ============================================================
-- 12. [getSqlParameter] SQL 파라미터 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_get_sql_parameter//
CREATE PROCEDURE sp_data_search_get_sql_parameter(
    IN p_sys_id VARCHAR(20),
    IN p_job_no VARCHAR(20)
)
BEGIN
    SELECT PARAMETER_CODE AS parameterCode
          ,PARAMETER_TYPE AS parameterType
          ,PARAMETER_NAME AS parameterName
          ,PARAMETER_INIT_VAL AS parameterInitVal
      FROM DATA_OPER_DETL A
     WHERE SYS_ID = p_sys_id
       AND JOB_NO = p_job_no
     ORDER BY PARAMETER_SEQ;
END//

-- ============================================================
-- 13. [getGroupId] 그룹 ID 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_get_group_id//
CREATE PROCEDURE sp_data_search_get_group_id(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    SELECT GROUP_ID AS groupId
      FROM SYS_UGRP
     WHERE SYS_ID = p_sys_id
       AND USER_ID = p_user_id;
END//

-- ============================================================
-- 14. [searchJobType] Job 타입 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_data_search_job_type//
CREATE PROCEDURE sp_data_search_job_type(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT JOB_NO AS jobNo
          ,CONCAT(JOB_TYPE1, ' > ', JOB_TYPE2, ' > ', JOB_DESC) AS jobType
      FROM DATA_OPER_MAST
     WHERE SYS_ID = p_sys_id;
END//

DELIMITER ;
