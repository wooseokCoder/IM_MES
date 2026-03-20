-- ============================================================
-- User.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-15
-- 수정일: 2026-02-03 (MES 통합 컬럼 추가)
-- DBeaver 실행: Alt+X -> Statement delimiter를 // 로 설정
-- ============================================================

-- ============================================================
-- 1. 사용자 목록 조회 (페이징)
-- AS-IS: search - SELECT with paging, dynamic WHERE, dynamic ORDER BY
-- 수정: MES 컬럼 추가 (pltCode, orgCode, position, isSystem, lockYn, lang)
-- ============================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_user_search//

CREATE PROCEDURE sp_user_search(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_name VARCHAR(100),
    IN p_user_type VARCHAR(20),
    IN p_org_auth_code VARCHAR(20),
    IN p_spc_auth_code VARCHAR(20),
    IN p_com_code VARCHAR(20),
    IN p_com_name VARCHAR(100),
    IN p_empl_no VARCHAR(50),
    IN p_dept_code VARCHAR(20),
    IN p_dept_name VARCHAR(100),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_user_tel VARCHAR(50),
    IN p_user_hp VARCHAR(50),
    IN p_user_mail VARCHAR(100),
    IN p_user_remk TEXT,
    IN p_use_flag VARCHAR(10),
    IN p_start INT,
    IN p_end INT,
    IN p_sort_str TEXT
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE v_where TEXT DEFAULT '';
    DECLARE v_order TEXT DEFAULT '';

    -- Build WHERE clause
    SET v_where = CONCAT('WHERE SYS_ID = ''', p_sys_id, '''');

    IF p_user_id IS NOT NULL AND p_user_id != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_ID LIKE ''%', p_user_id, '%''');
    END IF;

    IF p_user_name IS NOT NULL AND p_user_name != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_NAME LIKE ''%', p_user_name, '%''');
    END IF;

    IF p_user_type IS NOT NULL AND p_user_type != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_TYPE = ''', p_user_type, '''');
    END IF;

    IF p_org_auth_code IS NOT NULL AND p_org_auth_code != '' THEN
        SET v_where = CONCAT(v_where, ' AND ORG_AUTH_CODE = ''', p_org_auth_code, '''');
    END IF;

    IF p_spc_auth_code IS NOT NULL AND p_spc_auth_code != '' THEN
        SET v_where = CONCAT(v_where, ' AND SPC_AUTH_CODE = ''', p_spc_auth_code, '''');
    END IF;

    IF p_com_code IS NOT NULL AND p_com_code != '' THEN
        SET v_where = CONCAT(v_where, ' AND COM_CODE = ''', p_com_code, '''');
    END IF;

    IF p_com_name IS NOT NULL AND p_com_name != '' THEN
        SET v_where = CONCAT(v_where, ' AND COM_NAME = ''', p_com_name, '''');
    END IF;

    IF p_empl_no IS NOT NULL AND p_empl_no != '' THEN
        SET v_where = CONCAT(v_where, ' AND EMPL_NO = ''', p_empl_no, '''');
    END IF;

    IF p_dept_code IS NOT NULL AND p_dept_code != '' THEN
        SET v_where = CONCAT(v_where, ' AND DEPT_CODE = ''', p_dept_code, '''');
    END IF;

    IF p_dept_name IS NOT NULL AND p_dept_name != '' THEN
        SET v_where = CONCAT(v_where, ' AND DEPT_NAME = ''', p_dept_name, '''');
    END IF;

    IF p_uppr_dept_code IS NOT NULL AND p_uppr_dept_code != '' THEN
        SET v_where = CONCAT(v_where, ' AND UPPR_DEPT_CODE = ''', p_uppr_dept_code, '''');
    END IF;

    IF p_user_tel IS NOT NULL AND p_user_tel != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_TEL = ''', p_user_tel, '''');
    END IF;

    IF p_user_hp IS NOT NULL AND p_user_hp != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_HP = ''', p_user_hp, '''');
    END IF;

    IF p_user_mail IS NOT NULL AND p_user_mail != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_MAIL = ''', p_user_mail, '''');
    END IF;

    IF p_user_remk IS NOT NULL AND p_user_remk != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_REMK = ''', p_user_remk, '''');
    END IF;

    IF p_use_flag IS NOT NULL AND p_use_flag != '' THEN
        IF p_use_flag = 'ALL' THEN
            SET v_where = v_where;
        ELSE
            SET v_where = CONCAT(v_where, ' AND USE_FLAG = ''', p_use_flag, '''');
        END IF;
    END IF;

    -- Build ORDER BY clause
    IF p_sort_str IS NOT NULL AND p_sort_str != '' THEN
        SET v_order = CONCAT('ORDER BY ', p_sort_str);
    ELSE
        SET v_order = 'ORDER BY A.REGI_DATE DESC, A.CHNG_DATE DESC';
    END IF;

    -- Build and execute dynamic SQL
    SET @rownum := 0;

    IF p_start IS NOT NULL AND p_end IS NOT NULL THEN
        SET v_sql = CONCAT('
            SELECT * FROM (
                SELECT X.* FROM (
                    SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
                    FROM (
                        SELECT
                            SYS_ID AS sysId,
                            IFNULL(PLT_CODE, ''100'') AS pltCode,
                            USER_ID AS userId,
                            USER_NAME AS userName,
                            USER_PWD AS userPwd,
                            USER_TYPE AS userType,
                            MENU_SET AS menuSet,
                            MENU_TYPE AS menuType,
                            MOBILE_TYPE AS mobileType,
                            ORG_AUTH_CODE AS orgAuthCode,
                            SPC_AUTH_CODE AS spcAuthCode,
                            IFNULL(DASH_TYPE, ''DT01'') AS dashType,
                            COM_CODE AS comCode,
                            COM_NAME AS comName,
                            EMPL_NO AS emplNo,
                            DEPT_CODE AS deptCode,
                            IFNULL(DEPT_NAME,
                                (SELECT CODE_NAME FROM SYS_CODE
                                 WHERE SYS_ID = A.SYS_ID AND CODE_CD = A.DEPT_CODE AND CODE_GRUP = ''DEPT_CODE'')
                            ) AS deptName,
                            UPPR_DEPT_CODE AS upprDeptCode,
                            ORG_CODE AS orgCode,
                            POSITION AS position,
                            IFNULL(IS_SYSTEM, 0) AS isSystem,
                            USER_TEL AS userTel,
                            USER_HP AS userHp,
                            USER_MAIL AS userMail,
                            USER_REMK AS userRemk,
                            USE_FLAG AS useFlag,
                            REGI_ID AS regiId,
                            DATE_FORMAT(REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate,
                            CHNG_ID AS chngId,
                            DATE_FORMAT(CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate,
                            DATE_FORMAT(PWD_CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS pwdChngDate,
                            DATE_FORMAT(LAST_LOGIN_DATE, ''%Y-%m-%d %H:%i:%s'') AS lastLoginDate,
                            LOGIN_FAIL_CNT AS loginFailCnt,
                            IFNULL(LOCK_YN, ''N'') AS lockYn,
                            IFNULL(LANG, ''ko'') AS lang,
                            (SELECT CODE_NAME FROM SYS_CODE
                             WHERE SYS_ID = A.SYS_ID AND CODE_GRUP = ''USER_TYPE'' AND CODE_CD = A.USER_TYPE AND USE_FLAG = ''Y''
                            ) AS userTypeDesc,
                            IFNULL(ID_SFDC, '''') AS idSfdc,
                            IFNULL(SFDC_FLAG, '''') AS sfdcFlag,
                            IFNULL(NOTI_ALLREAD_YN, '''') AS notiAllreadYn
                        FROM SYS_USER A
                        ', v_where, '
                        ', v_order, '
                    ) Z1, (SELECT @rownum:=0) Z2
                ) X
                WHERE RNUM < ', p_end, '
            ) X
            WHERE RNUM >= ', p_start
        );
    ELSE
        SET v_sql = CONCAT('
            SELECT
                SYS_ID AS sysId,
                IFNULL(PLT_CODE, ''100'') AS pltCode,
                USER_ID AS userId,
                USER_NAME AS userName,
                USER_PWD AS userPwd,
                USER_TYPE AS userType,
                MENU_SET AS menuSet,
                MENU_TYPE AS menuType,
                MOBILE_TYPE AS mobileType,
                ORG_AUTH_CODE AS orgAuthCode,
                SPC_AUTH_CODE AS spcAuthCode,
                IFNULL(DASH_TYPE, ''DT01'') AS dashType,
                COM_CODE AS comCode,
                COM_NAME AS comName,
                EMPL_NO AS emplNo,
                DEPT_CODE AS deptCode,
                IFNULL(DEPT_NAME,
                    (SELECT CODE_NAME FROM SYS_CODE
                     WHERE SYS_ID = A.SYS_ID AND CODE_CD = A.DEPT_CODE AND CODE_GRUP = ''DEPT_CODE'')
                ) AS deptName,
                UPPR_DEPT_CODE AS upprDeptCode,
                ORG_CODE AS orgCode,
                POSITION AS position,
                IFNULL(IS_SYSTEM, 0) AS isSystem,
                USER_TEL AS userTel,
                USER_HP AS userHp,
                USER_MAIL AS userMail,
                USER_REMK AS userRemk,
                USE_FLAG AS useFlag,
                REGI_ID AS regiId,
                DATE_FORMAT(REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate,
                CHNG_ID AS chngId,
                DATE_FORMAT(CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate,
                DATE_FORMAT(PWD_CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS pwdChngDate,
                DATE_FORMAT(LAST_LOGIN_DATE, ''%Y-%m-%d %H:%i:%s'') AS lastLoginDate,
                LOGIN_FAIL_CNT AS loginFailCnt,
                IFNULL(LOCK_YN, ''N'') AS lockYn,
                IFNULL(LANG, ''ko'') AS lang,
                (SELECT CODE_NAME FROM SYS_CODE
                 WHERE SYS_ID = A.SYS_ID AND CODE_GRUP = ''USER_TYPE'' AND CODE_CD = A.USER_TYPE AND USE_FLAG = ''Y''
                ) AS userTypeDesc,
                IFNULL(ID_SFDC, '''') AS idSfdc,
                IFNULL(SFDC_FLAG, '''') AS sfdcFlag,
                IFNULL(NOTI_ALLREAD_YN, '''') AS notiAllreadYn
            FROM SYS_USER A
            ', v_where, '
            ', v_order
        );
    END IF;

    SET @sql = v_sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//


-- ============================================================
-- 2. 사용자 목록 카운트
-- AS-IS: searchCount - SELECT COUNT with dynamic WHERE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_search_count//

CREATE PROCEDURE sp_user_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_name VARCHAR(100),
    IN p_user_type VARCHAR(20),
    IN p_org_auth_code VARCHAR(20),
    IN p_spc_auth_code VARCHAR(20),
    IN p_com_code VARCHAR(20),
    IN p_com_name VARCHAR(100),
    IN p_empl_no VARCHAR(50),
    IN p_dept_code VARCHAR(20),
    IN p_dept_name VARCHAR(100),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_user_tel VARCHAR(50),
    IN p_user_hp VARCHAR(50),
    IN p_user_mail VARCHAR(100),
    IN p_user_remk TEXT,
    IN p_use_flag VARCHAR(10)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_USER A
    WHERE SYS_ID = p_sys_id
      AND (p_user_id IS NULL OR p_user_id = '' OR USER_ID LIKE CONCAT('%', p_user_id, '%'))
      AND (p_user_name IS NULL OR p_user_name = '' OR USER_NAME LIKE CONCAT('%', p_user_name, '%'))
      AND (p_user_type IS NULL OR p_user_type = '' OR USER_TYPE = p_user_type)
      AND (p_org_auth_code IS NULL OR p_org_auth_code = '' OR ORG_AUTH_CODE = p_org_auth_code)
      AND (p_spc_auth_code IS NULL OR p_spc_auth_code = '' OR SPC_AUTH_CODE = p_spc_auth_code)
      AND (p_com_code IS NULL OR p_com_code = '' OR COM_CODE = p_com_code)
      AND (p_com_name IS NULL OR p_com_name = '' OR COM_NAME = p_com_name)
      AND (p_empl_no IS NULL OR p_empl_no = '' OR EMPL_NO = p_empl_no)
      AND (p_dept_code IS NULL OR p_dept_code = '' OR DEPT_CODE = p_dept_code)
      AND (p_dept_name IS NULL OR p_dept_name = '' OR DEPT_NAME = p_dept_name)
      AND (p_uppr_dept_code IS NULL OR p_uppr_dept_code = '' OR UPPR_DEPT_CODE = p_uppr_dept_code)
      AND (p_user_tel IS NULL OR p_user_tel = '' OR USER_TEL = p_user_tel)
      AND (p_user_hp IS NULL OR p_user_hp = '' OR USER_HP = p_user_hp)
      AND (p_user_mail IS NULL OR p_user_mail = '' OR USER_MAIL = p_user_mail)
      AND (p_user_remk IS NULL OR p_user_remk = '' OR USER_REMK = p_user_remk)
      AND (p_use_flag IS NULL OR p_use_flag = '' OR p_use_flag = 'ALL' OR USE_FLAG = p_use_flag);
END//


-- ============================================================
-- 3. 사용자 단건 조회
-- AS-IS: select - SELECT single row by sysId, userId
-- 수정: MES 컬럼 추가 + sys_ugrp/sys_grup 조인
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_select//

CREATE PROCEDURE sp_user_select(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    SELECT
        A.SYS_ID AS sysId,
        IFNULL(A.PLT_CODE, '100') AS pltCode,
        A.USER_ID AS userId,
        A.USER_NAME AS userName,
        A.USER_PWD AS userPwd,
        A.USER_TYPE AS userType,
        A.MENU_SET AS menuSet,
        A.MENU_TYPE AS menuType,
        A.MOBILE_TYPE AS mobileType,
        A.ORG_AUTH_CODE AS orgAuthCode,
        A.SPC_AUTH_CODE AS spcAuthCode,
        IFNULL(A.DASH_TYPE, 'DT01') AS dashType,
        A.COM_CODE AS comCode,
        A.COM_NAME AS comName,
        A.EMPL_NO AS emplNo,
        A.DEPT_CODE AS deptCode,
        IFNULL(A.DEPT_NAME,
            (SELECT CODE_NAME FROM SYS_CODE
             WHERE SYS_ID = A.SYS_ID AND CODE_CD = A.DEPT_CODE AND CODE_GRUP = 'DEPT_CODE')
        ) AS deptName,
        A.UPPR_DEPT_CODE AS upprDeptCode,
        A.ORG_CODE AS orgCode,
        A.POSITION AS position,
        IFNULL(A.IS_SYSTEM, 0) AS isSystem,
        A.USER_TEL AS userTel,
        A.USER_HP AS userHp,
        A.USER_MAIL AS userMail,
        A.USER_REMK AS userRemk,
        A.USE_FLAG AS useFlag,
        A.REGI_ID AS regiId,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID AS chngId,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
        DATE_FORMAT(A.PWD_CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS pwdChngDate,
        DATE_FORMAT(A.LAST_LOGIN_DATE, '%Y-%m-%d %H:%i:%s') AS lastLoginDate,
        A.LOGIN_FAIL_CNT AS loginFailCnt,
        IFNULL(A.LOCK_YN, 'N') AS lockYn,
        IFNULL(A.LANG, 'ko') AS lang,
        (SELECT CODE_NAME FROM SYS_CODE
         WHERE SYS_ID = A.SYS_ID AND CODE_GRUP = 'USER_TYPE' AND CODE_CD = A.USER_TYPE AND USE_FLAG = 'Y'
        ) AS userTypeDesc,
        IFNULL(A.ID_SFDC, '') AS idSfdc,
        IFNULL(A.SFDC_FLAG, '') AS sfdcFlag,
        IFNULL(A.NOTI_ALLREAD_YN, '') AS notiAllreadYn,
        (SELECT GROUP_ID FROM SYS_UGRP WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID LIMIT 1) AS grupId,
        (SELECT G.GROUP_NAME FROM SYS_UGRP UG
         JOIN SYS_GRUP G ON UG.SYS_ID = G.SYS_ID AND UG.GROUP_ID = G.GROUP_ID
         WHERE UG.SYS_ID = A.SYS_ID AND UG.USER_ID = A.USER_ID LIMIT 1) AS grupNm
    FROM SYS_USER A
    WHERE A.SYS_ID = p_sys_id
      AND A.USER_ID = p_user_id
      AND A.USE_FLAG != 'N';
END//


-- ============================================================
-- 4. 사용자 등록
-- AS-IS: insert - INSERT with optional columns
-- 수정: MES 컬럼 파라미터 추가 (하위 호환성 유지)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_insert//

CREATE PROCEDURE sp_user_insert(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_name VARCHAR(100),
    IN p_user_pwd VARCHAR(200),
    IN p_user_type VARCHAR(20),
    IN p_org_auth_code VARCHAR(20),
    IN p_spc_auth_code VARCHAR(20),
    IN p_com_code VARCHAR(20),
    IN p_com_name VARCHAR(100),
    IN p_empl_no VARCHAR(50),
    IN p_dept_code VARCHAR(20),
    IN p_dept_name VARCHAR(100),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_user_tel VARCHAR(50),
    IN p_user_hp VARCHAR(50),
    IN p_user_mail VARCHAR(100),
    IN p_user_remk TEXT,
    IN p_gs_user_id VARCHAR(50),
    -- MES 추가 파라미터 (선택, 기본값 적용)
    IN p_plt_code VARCHAR(3),
    IN p_org_code VARCHAR(20),
    IN p_position VARCHAR(20),
    IN p_is_system TINYINT,
    IN p_lang VARCHAR(5)
)
BEGIN
    INSERT INTO SYS_USER (
        SYS_ID,
        PLT_CODE,
        USER_ID,
        USER_NAME,
        USER_PWD,
        USER_TYPE,
        ORG_AUTH_CODE,
        SPC_AUTH_CODE,
        COM_CODE,
        COM_NAME,
        EMPL_NO,
        DEPT_CODE,
        DEPT_NAME,
        UPPR_DEPT_CODE,
        ORG_CODE,
        POSITION,
        IS_SYSTEM,
        USER_TEL,
        USER_HP,
        USER_MAIL,
        USER_REMK,
        USE_FLAG,
        LOCK_YN,
        LANG,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE,
        PWD_CHNG_DATE
    ) VALUES (
        p_sys_id,
        IFNULL(NULLIF(p_plt_code, ''), '100'),
        p_user_id,
        p_user_name,
        p_user_pwd,
        p_user_type,
        NULLIF(p_org_auth_code, ''),
        NULLIF(p_spc_auth_code, ''),
        NULLIF(p_com_code, ''),
        NULLIF(p_com_name, ''),
        NULLIF(p_empl_no, ''),
        NULLIF(p_dept_code, ''),
        NULLIF(p_dept_name, ''),
        NULLIF(p_uppr_dept_code, ''),
        NULLIF(p_org_code, ''),
        NULLIF(p_position, ''),
        IFNULL(p_is_system, 0),
        NULLIF(p_user_tel, ''),
        NULLIF(p_user_hp, ''),
        NULLIF(p_user_mail, ''),
        NULLIF(p_user_remk, ''),
        'Y',
        'N',
        IFNULL(NULLIF(p_lang, ''), 'ko'),
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW(),
        NOW()
    );
END//


-- ============================================================
-- 5. 사용자 수정
-- AS-IS: update - UPDATE with optional columns
-- 수정: MES 컬럼 파라미터 추가 (하위 호환성 유지)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_update//

CREATE PROCEDURE sp_user_update(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_name VARCHAR(100),
    IN p_user_type VARCHAR(20),
    IN p_org_auth_code VARCHAR(20),
    IN p_spc_auth_code VARCHAR(20),
    IN p_com_code VARCHAR(20),
    IN p_com_name VARCHAR(100),
    IN p_empl_no VARCHAR(50),
    IN p_dept_code VARCHAR(20),
    IN p_dept_name VARCHAR(100),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_user_tel VARCHAR(50),
    IN p_user_hp VARCHAR(50),
    IN p_user_mail VARCHAR(100),
    IN p_user_remk TEXT,
    IN p_use_flag VARCHAR(10),
    IN p_gs_user_id VARCHAR(50),
    -- MES 추가 파라미터 (선택)
    IN p_plt_code VARCHAR(3),
    IN p_org_code VARCHAR(20),
    IN p_position VARCHAR(20),
    IN p_is_system TINYINT,
    IN p_lang VARCHAR(5)
)
BEGIN
    UPDATE SYS_USER
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        USER_NAME = CASE WHEN p_user_name IS NOT NULL AND p_user_name != '' THEN p_user_name ELSE USER_NAME END,
        USER_TYPE = CASE WHEN p_user_type IS NOT NULL AND p_user_type != '' THEN p_user_type ELSE USER_TYPE END,
        ORG_AUTH_CODE = CASE WHEN p_org_auth_code IS NOT NULL AND p_org_auth_code != '' THEN p_org_auth_code ELSE ORG_AUTH_CODE END,
        SPC_AUTH_CODE = CASE WHEN p_spc_auth_code IS NOT NULL AND p_spc_auth_code != '' THEN p_spc_auth_code ELSE SPC_AUTH_CODE END,
        COM_CODE = CASE WHEN p_com_code IS NOT NULL AND p_com_code != '' THEN p_com_code ELSE COM_CODE END,
        COM_NAME = CASE WHEN p_com_name IS NOT NULL AND p_com_name != '' THEN p_com_name ELSE COM_NAME END,
        EMPL_NO = CASE WHEN p_empl_no IS NOT NULL AND p_empl_no != '' THEN p_empl_no ELSE EMPL_NO END,
        DEPT_CODE = CASE WHEN p_dept_code IS NOT NULL AND p_dept_code != '' THEN p_dept_code ELSE DEPT_CODE END,
        DEPT_NAME = CASE WHEN p_dept_name IS NOT NULL AND p_dept_name != '' THEN p_dept_name ELSE DEPT_NAME END,
        UPPR_DEPT_CODE = CASE WHEN p_uppr_dept_code IS NOT NULL AND p_uppr_dept_code != '' THEN p_uppr_dept_code ELSE UPPR_DEPT_CODE END,
        USER_TEL = CASE WHEN p_user_tel IS NOT NULL AND p_user_tel != '' THEN p_user_tel ELSE USER_TEL END,
        USER_HP = CASE WHEN p_user_hp IS NOT NULL AND p_user_hp != '' THEN p_user_hp ELSE USER_HP END,
        USER_MAIL = CASE WHEN p_user_mail IS NOT NULL AND p_user_mail != '' THEN p_user_mail ELSE USER_MAIL END,
        USER_REMK = CASE WHEN p_user_remk IS NOT NULL AND p_user_remk != '' THEN p_user_remk ELSE USER_REMK END,
        USE_FLAG = CASE WHEN p_use_flag IS NOT NULL AND p_use_flag != '' THEN p_use_flag ELSE USE_FLAG END,
        -- MES 컬럼 업데이트
        PLT_CODE = CASE WHEN p_plt_code IS NOT NULL AND p_plt_code != '' THEN p_plt_code ELSE PLT_CODE END,
        ORG_CODE = CASE WHEN p_org_code IS NOT NULL AND p_org_code != '' THEN p_org_code ELSE ORG_CODE END,
        POSITION = CASE WHEN p_position IS NOT NULL AND p_position != '' THEN p_position ELSE POSITION END,
        IS_SYSTEM = CASE WHEN p_is_system IS NOT NULL THEN p_is_system ELSE IS_SYSTEM END,
        LANG = CASE WHEN p_lang IS NOT NULL AND p_lang != '' THEN p_lang ELSE LANG END
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//


-- ============================================================
-- 6. 사용자 삭제
-- AS-IS: delete - DELETE by sysId, userId
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_delete//

CREATE PROCEDURE sp_user_delete(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//


-- ============================================================
-- 7. 비밀번호 체크
-- AS-IS: checkPassword - SELECT CASE COUNT with password verification
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_check_password//

CREATE PROCEDURE sp_user_check_password(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_pwd VARCHAR(200)
)
BEGIN
    SELECT CASE COUNT(1) WHEN 0 THEN 'X' ELSE 'O' END AS result
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND (USER_PWD = HEX(AES_ENCRYPT(p_user_id, p_user_pwd))
           OR fn_chk_user_pwd(p_user_pwd) = 'Y');
END//


-- ============================================================
-- 8. 90일 비밀번호 만료 체크
-- AS-IS: check90days - SELECT CASE with date comparison
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_check_90days//

CREATE PROCEDURE sp_user_check_90days(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    SELECT CASE
        WHEN DATE_FORMAT(NOW(), '%Y%m%d') > DATE_FORMAT(PWD_CHNG_DATE + INTERVAL 90 DAY, '%Y%m%d')
        THEN 'X'
        ELSE 'O'
    END AS result
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//


-- ============================================================
-- 9. 비밀번호 변경
-- AS-IS: updatePassword - UPDATE password and change date
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_update_password//

CREATE PROCEDURE sp_user_update_password(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_pwd VARCHAR(200),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_USER
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        USER_PWD = HEX(AES_ENCRYPT(p_user_id, p_user_pwd)),
        PWD_CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//


-- ============================================================
-- 10. 로그인 실패 카운트 증가
-- AS-IS: updateFailure - UPDATE LOGIN_FAIL_CNT + 1
-- 수정: 5회 이상 실패 시 LOCK_YN = 'Y' 설정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_update_failure//

CREATE PROCEDURE sp_user_update_failure(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    -- 실패 횟수 증가
    UPDATE SYS_USER
    SET LOGIN_FAIL_CNT = IFNULL(LOGIN_FAIL_CNT, 0) + 1,
        CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id AND USER_ID = p_user_id;

    -- 5회 이상 실패 시 계정 잠금
    UPDATE SYS_USER
    SET LOCK_YN = 'Y'
    WHERE SYS_ID = p_sys_id AND USER_ID = p_user_id
    AND LOGIN_FAIL_CNT >= 5;
END//


-- ============================================================
-- 11. 로그인 성공 처리 (실패 카운트 리셋 & 최종 로그인 일시 업데이트)
-- AS-IS: updateSuccess - UPDATE LOGIN_FAIL_CNT = 0, LAST_LOGIN_DATE = NOW()
-- 수정: LOCK_YN = 'N' 리셋 추가
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_update_success//

CREATE PROCEDURE sp_user_update_success(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_USER
    SET LOGIN_FAIL_CNT = 0,
        LOCK_YN = 'N',
        LAST_LOGIN_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//


-- ============================================================
-- 12. 사용자 타입 조회
-- AS-IS: getUserType - SELECT USER_TYPE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_get_type//

CREATE PROCEDURE sp_user_get_type(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    SELECT USER_TYPE AS userType
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_gs_user_id;
END//


-- ============================================================
-- 13. 사용자 그룹 조회
-- AS-IS: getUserGroup - SELECT GROUP_ID from SYS_UGRP
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user_get_group//

CREATE PROCEDURE sp_user_get_group(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    SELECT GROUP_ID AS grupId
    FROM SYS_UGRP
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_gs_user_id;
END//


DELIMITER ;
