-- ============================================================
-- User2.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-15
-- DBeaver 실행: Alt+X -> Statement delimiter를 // 로 설정
-- ============================================================

-- ============================================================
-- 1. sp_user2_search: 사용자 목록 조회 (페이징)
-- AS-IS: search - SELECT with paging, dynamic WHERE, dynamic ORDER BY
-- ============================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_user2_search//

CREATE PROCEDURE sp_user2_search(
    IN p_sys_id VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_user_id VARCHAR(50),
    IN p_user_id_list TEXT,
    IN p_user_name VARCHAR(100),
    IN p_user_type VARCHAR(20),
    IN p_menu_set VARCHAR(20),
    IN p_menu_type VARCHAR(20),
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

    -- Handle userIdList (comma-separated)
    IF p_user_id_list IS NOT NULL AND p_user_id_list != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_ID IN (', p_user_id_list, ')');
    ELSEIF p_user_id IS NOT NULL AND p_user_id != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_ID LIKE ''%', p_user_id, '%''');
    END IF;

    IF p_user_name IS NOT NULL AND p_user_name != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_NAME LIKE ''%', p_user_name, '%''');
    END IF;

    IF p_user_type IS NOT NULL AND p_user_type != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_TYPE = ''', p_user_type, '''');
    END IF;

    IF p_menu_set IS NOT NULL AND p_menu_set != '' THEN
        SET v_where = CONCAT(v_where, ' AND MENU_SET = ''', p_menu_set, '''');
    END IF;

    IF p_menu_type IS NOT NULL AND p_menu_type != '' THEN
        SET v_where = CONCAT(v_where, ' AND MENU_TYPE = ''', p_menu_type, '''');
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
        IF p_use_flag != 'ALL' THEN
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
                            USER_ID AS userId,
                            USER_NAME AS userName,
                            USER_PWD AS userPwd,
                            USER_TYPE AS userType,
                            MENU_TYPE AS menuType,
                            DASH_TYPE AS dashType,
                            MENU_SET AS menuSet,
                            MOBILE_TYPE AS mobileType,
                            ORG_AUTH_CODE AS orgAuthCode,
                            SPC_AUTH_CODE AS spcAuthCode,
                            COM_CODE AS comCode,
                            COM_NAME AS comName,
                            EMPL_NO AS emplNo,
                            DEPT_CODE AS deptCode,
                            IFNULL(DEPT_NAME,
                                fn_get_code_name(''DEPT_CODE'', A.DEPT_CODE, ''', IFNULL(p_gs_lang, 'en'), ''')
                            ) AS deptName,
                            UPPR_DEPT_CODE AS upprDeptCode,
                            USER_TEL AS userTel,
                            USER_HP AS userHp,
                            USER_MAIL AS userMail,
                            SALE_GRUP AS saleGrup,
                            REGN_MAGR AS regnMagr,
                            REGN_GB AS regnGb,
                            APPL_LIST AS applList,
                            SHIP_LOC AS shipLoc,
                            ID_LSPO AS idLspo,
                            ID_LWS AS idLws,
                            ID_MERC AS idMerc,
                            ID_SERV AS idServ,
                            ID_WGBC AS idWgbc,
                            ID_MTS AS idMts,
                            ID_ACB AS idAcb,
                            ID_SPROUTLOUD AS idSproutLoud,
                            ID_SFDC AS idSfdc,
                            CREATE_MAIL_FLAG AS createMailFlag,
                            REVIEW_MAIL_FLAG AS reviewMailFlag,
                            CONF_MAIL_FLAG AS confMailFlag,
                            READY_MAIL_FLAG AS readyMailFlag,
                            SHIP_MAIL_FLAG AS shipMailFlag,
                            COMP_MAIL_FLAG AS compMailFlag,
                            RETURN_MAIL_FLAG AS returnMailFlag,
                            SFDC_FLAG AS sfdcFlag,
                            NOTI_ALLREAD_YN AS notiAllreadYn,
                            SMTP_MAIL AS smtpId,
                            SMTP_PW AS smtpPw,
                            USER_REMK AS userRemk,
                            USE_FLAG AS useFlag,
                            REGI_ID AS regiId,
                            DATE_FORMAT(REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate,
                            CHNG_ID AS chngId,
                            DATE_FORMAT(CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate,
                            DATE_FORMAT(PWD_CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS pwdChngDate,
                            DATE_FORMAT(LAST_LOGIN_DATE, ''%Y-%m-%d %H:%i:%s'') AS lastLoginDate,
                            LOGIN_FAIL_CNT AS loginFailCnt,
                            (SELECT CODE_NAME FROM SYS_CODE
                             WHERE SYS_ID = A.SYS_ID AND CODE_GRUP = ''USER_TYPE'' AND CODE_CD = A.USER_TYPE AND USE_FLAG = ''Y''
                            ) AS userTypeDesc,
                            A.IF_MC_CODE AS ifMcCode,
                            (SELECT MC_NAME FROM LSE_MACHINE WHERE MC_CODE = A.IF_MC_CODE AND DATA_FLAG = 0 LIMIT 1) AS ifMcName
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
                USER_ID AS userId,
                USER_NAME AS userName,
                USER_PWD AS userPwd,
                USER_TYPE AS userType,
                MENU_TYPE AS menuType,
                DASH_TYPE AS dashType,
                MENU_SET AS menuSet,
                MOBILE_TYPE AS mobileType,
                ORG_AUTH_CODE AS orgAuthCode,
                SPC_AUTH_CODE AS spcAuthCode,
                COM_CODE AS comCode,
                COM_NAME AS comName,
                EMPL_NO AS emplNo,
                DEPT_CODE AS deptCode,
                IFNULL(DEPT_NAME,
                    fn_get_code_name(''DEPT_CODE'', A.DEPT_CODE, ''', IFNULL(p_gs_lang, 'en'), ''')
                ) AS deptName,
                UPPR_DEPT_CODE AS upprDeptCode,
                USER_TEL AS userTel,
                USER_HP AS userHp,
                USER_MAIL AS userMail,
                SALE_GRUP AS saleGrup,
                REGN_MAGR AS regnMagr,
                REGN_GB AS regnGb,
                APPL_LIST AS applList,
                SHIP_LOC AS shipLoc,
                ID_LSPO AS idLspo,
                ID_LWS AS idLws,
                ID_MERC AS idMerc,
                ID_SERV AS idServ,
                ID_WGBC AS idWgbc,
                ID_MTS AS idMts,
                ID_ACB AS idAcb,
                ID_SPROUTLOUD AS idSproutLoud,
                ID_SFDC AS idSfdc,
                CREATE_MAIL_FLAG AS createMailFlag,
                REVIEW_MAIL_FLAG AS reviewMailFlag,
                CONF_MAIL_FLAG AS confMailFlag,
                READY_MAIL_FLAG AS readyMailFlag,
                SHIP_MAIL_FLAG AS shipMailFlag,
                COMP_MAIL_FLAG AS compMailFlag,
                RETURN_MAIL_FLAG AS returnMailFlag,
                SFDC_FLAG AS sfdcFlag,
                NOTI_ALLREAD_YN AS notiAllreadYn,
                SMTP_MAIL AS smtpId,
                SMTP_PW AS smtpPw,
                USER_REMK AS userRemk,
                USE_FLAG AS useFlag,
                REGI_ID AS regiId,
                DATE_FORMAT(REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate,
                CHNG_ID AS chngId,
                DATE_FORMAT(CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate,
                DATE_FORMAT(PWD_CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS pwdChngDate,
                DATE_FORMAT(LAST_LOGIN_DATE, ''%Y-%m-%d %H:%i:%s'') AS lastLoginDate,
                LOGIN_FAIL_CNT AS loginFailCnt,
                (SELECT CODE_NAME FROM SYS_CODE
                 WHERE SYS_ID = A.SYS_ID AND CODE_GRUP = ''USER_TYPE'' AND CODE_CD = A.USER_TYPE AND USE_FLAG = ''Y''
                ) AS userTypeDesc,
                A.IF_MC_CODE AS ifMcCode,
                (SELECT MC_NAME FROM LSE_MACHINE WHERE MC_CODE = A.IF_MC_CODE AND DATA_FLAG = 0 LIMIT 1) AS ifMcName
                0 AS RNUM
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
-- 2. sp_user2_search_count: 사용자 목록 카운트
-- AS-IS: searchCount - COUNT query
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_search_count//

CREATE PROCEDURE sp_user2_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_id_list TEXT,
    IN p_user_name VARCHAR(100),
    IN p_user_type VARCHAR(20),
    IN p_menu_set VARCHAR(20),
    IN p_menu_type VARCHAR(20),
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
    DECLARE v_sql TEXT;
    DECLARE v_where TEXT DEFAULT '';

    -- Build WHERE clause (same as search)
    SET v_where = CONCAT('WHERE SYS_ID = ''', p_sys_id, '''');

    IF p_user_id_list IS NOT NULL AND p_user_id_list != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_ID IN (', p_user_id_list, ')');
    ELSEIF p_user_id IS NOT NULL AND p_user_id != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_ID LIKE ''%', p_user_id, '%''');
    END IF;

    IF p_user_name IS NOT NULL AND p_user_name != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_NAME LIKE ''%', p_user_name, '%''');
    END IF;

    IF p_user_type IS NOT NULL AND p_user_type != '' THEN
        SET v_where = CONCAT(v_where, ' AND USER_TYPE = ''', p_user_type, '''');
    END IF;

    IF p_menu_set IS NOT NULL AND p_menu_set != '' THEN
        SET v_where = CONCAT(v_where, ' AND MENU_SET = ''', p_menu_set, '''');
    END IF;

    IF p_menu_type IS NOT NULL AND p_menu_type != '' THEN
        SET v_where = CONCAT(v_where, ' AND MENU_TYPE = ''', p_menu_type, '''');
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
        IF p_use_flag != 'ALL' THEN
            SET v_where = CONCAT(v_where, ' AND USE_FLAG = ''', p_use_flag, '''');
        END IF;
    END IF;

    SET v_sql = CONCAT('SELECT COUNT(1) FROM SYS_USER A ', v_where);

    SET @sql = v_sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 3. sp_user2_select: 사용자 상세 조회
-- AS-IS: select - SELECT single record
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_select//

CREATE PROCEDURE sp_user2_select(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT
        SYS_ID AS sysId,
        USER_ID AS userId,
        USER_NAME AS userName,
        USER_PWD AS userPwd,
        USER_TYPE AS userType,
        MENU_TYPE AS menuType,
        DASH_TYPE AS dashType,
        MENU_SET AS menuSet,
        MOBILE_TYPE AS mobileType,
        ORG_AUTH_CODE AS orgAuthCode,
        SPC_AUTH_CODE AS spcAuthCode,
        COM_CODE AS comCode,
        COM_NAME AS comName,
        EMPL_NO AS emplNo,
        DEPT_CODE AS deptCode,
        IFNULL(DEPT_NAME, fn_get_code_name('DEPT_CODE', A.DEPT_CODE, p_gs_lang)) AS deptName,
        UPPR_DEPT_CODE AS upprDeptCode,
        USER_TEL AS userTel,
        USER_HP AS userHp,
        USER_MAIL AS userMail,
        SALE_GRUP AS saleGrup,
        REGN_MAGR AS regnMagr,
        REGN_GB AS regnGb,
        APPL_LIST AS applList,
        SHIP_LOC AS shipLoc,
        ID_LSPO AS idLspo,
        ID_LWS AS idLws,
        ID_MERC AS idMerc,
        ID_SERV AS idServ,
        ID_WGBC AS idWgbc,
        ID_MTS AS idMts,
        ID_ACB AS idAcb,
        ID_SPROUTLOUD AS idSproutLoud,
        ID_SFDC AS idSfdc,
        CREATE_MAIL_FLAG AS createMailFlag,
        REVIEW_MAIL_FLAG AS reviewMailFlag,
        CONF_MAIL_FLAG AS confMailFlag,
        READY_MAIL_FLAG AS readyMailFlag,
        SHIP_MAIL_FLAG AS shipMailFlag,
        COMP_MAIL_FLAG AS compMailFlag,
        RETURN_MAIL_FLAG AS returnMailFlag,
        SFDC_FLAG AS sfdcFlag,
        NOTI_ALLREAD_YN AS notiAllreadYn,
        SMTP_MAIL AS smtpId,
        SMTP_PW AS smtpPw,
        USER_REMK AS userRemk,
        USE_FLAG AS useFlag,
        REGI_ID AS regiId,
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        CHNG_ID AS chngId,
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
        DATE_FORMAT(PWD_CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS pwdChngDate,
        DATE_FORMAT(LAST_LOGIN_DATE, '%Y-%m-%d %H:%i:%s') AS lastLoginDate,
        LOGIN_FAIL_CNT AS loginFailCnt,
        (SELECT CODE_NAME FROM SYS_CODE
         WHERE SYS_ID = A.SYS_ID AND CODE_GRUP = 'USER_TYPE' AND CODE_CD = A.USER_TYPE AND USE_FLAG = 'Y'
        ) AS userTypeDesc
    FROM SYS_USER A
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 4. sp_user2_insert: 사용자 등록
-- AS-IS: insert - INSERT with optional fields
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_insert//

CREATE PROCEDURE sp_user2_insert(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_name VARCHAR(100),
    IN p_user_type VARCHAR(20),
    IN p_menu_set VARCHAR(20),
    IN p_menu_type VARCHAR(20),
    IN p_mobile_type VARCHAR(20),
    IN p_org_auth_code VARCHAR(20),
    IN p_dash_type VARCHAR(20),
    IN p_spc_auth_code VARCHAR(20),
    IN p_appl_list TEXT,
    IN p_com_code VARCHAR(20),
    IN p_com_name VARCHAR(100),
    IN p_empl_no VARCHAR(50),
    IN p_dept_code VARCHAR(20),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_user_tel VARCHAR(50),
    IN p_user_hp VARCHAR(50),
    IN p_user_mail VARCHAR(100),
    IN p_sale_grup VARCHAR(20),
    IN p_regn_magr VARCHAR(20),
    IN p_regn_gb VARCHAR(20),
    IN p_ship_loc VARCHAR(50),
    IN p_id_lspo VARCHAR(50),
    IN p_id_lws VARCHAR(50),
    IN p_id_merc VARCHAR(50),
    IN p_id_serv VARCHAR(50),
    IN p_id_wgbc VARCHAR(50),
    IN p_id_mts VARCHAR(50),
    IN p_id_acb VARCHAR(50),
    IN p_id_sprout_loud VARCHAR(50),
    IN p_id_sfdc VARCHAR(50),
    IN p_create_mail_flag VARCHAR(10),
    IN p_review_mail_flag VARCHAR(10),
    IN p_conf_mail_flag VARCHAR(10),
    IN p_ready_mail_flag VARCHAR(10),
    IN p_ship_mail_flag VARCHAR(10),
    IN p_comp_mail_flag VARCHAR(10),
    IN p_return_mail_flag VARCHAR(10),
    IN p_sfdc_flag VARCHAR(10),
    IN p_noti_allread_yn VARCHAR(10),
    IN p_smtp_mail VARCHAR(100),
    IN p_smtp_pw VARCHAR(100),
    IN p_user_remk TEXT,
    IN p_if_mc_code VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_dept_name VARCHAR(100);

    -- 부서명 조회 (p_dept_code가 있는 경우)
    IF p_dept_code IS NOT NULL AND p_dept_code != '' THEN
        -- 1. TSTD_ORG에서 먼저 조회 (MES 조직)
        SELECT ORG_NAME INTO v_dept_name
        FROM TSTD_ORG
        WHERE ORG_CODE = p_dept_code
        LIMIT 1;

        -- 2. 없으면 SYS_CODE에서 조회 (기존 딜러포털 호환)
        IF v_dept_name IS NULL THEN
            SELECT CODE_NAME INTO v_dept_name
            FROM SYS_CODE
            WHERE SYS_ID = p_sys_id
              AND CODE_GRUP = 'DEPT_CODE'
              AND USE_FLAG = 'Y'
              AND CODE_CD = p_dept_code
            LIMIT 1;
        END IF;
    END IF;

    INSERT INTO SYS_USER (
        SYS_ID,
        USER_ID,
        USER_NAME,
        USER_PWD,
        USER_TYPE,
        MENU_SET,
        MENU_TYPE,
        MOBILE_TYPE,
        ORG_AUTH_CODE,
        DASH_TYPE,
        SPC_AUTH_CODE,
        APPL_LIST,
        COM_CODE,
        COM_NAME,
        EMPL_NO,
        DEPT_CODE,
        DEPT_NAME,
        ORG_CODE,
        UPPR_DEPT_CODE,
        USER_TEL,
        USER_HP,
        USER_MAIL,
        SALE_GRUP,
        REGN_MAGR,
        REGN_GB,
        SHIP_LOC,
        ID_LSPO,
        ID_LWS,
        ID_MERC,
        ID_SERV,
        ID_WGBC,
        ID_MTS,
        ID_ACB,
        ID_SPROUTLOUD,
        ID_SFDC,
        CREATE_MAIL_FLAG,
        REVIEW_MAIL_FLAG,
        CONF_MAIL_FLAG,
        READY_MAIL_FLAG,
        SHIP_MAIL_FLAG,
        COMP_MAIL_FLAG,
        RETURN_MAIL_FLAG,
        SFDC_FLAG,
        NOTI_ALLREAD_YN,
        SMTP_MAIL,
        SMTP_PW,
        USER_REMK,
        IF_MC_CODE,
        USE_FLAG,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE,
        PWD_CHNG_DATE
    ) VALUES (
        p_sys_id,
        p_user_id,
        p_user_name,
        HEX(AES_ENCRYPT(p_user_id, (SELECT fn_get_init_user_pwd()))),
        p_user_type,
        p_menu_set,
        p_menu_type,
        p_mobile_type,
        CASE WHEN p_org_auth_code IS NOT NULL AND p_org_auth_code != '' THEN p_org_auth_code ELSE NULL END,
        CASE WHEN p_dash_type IS NOT NULL AND p_dash_type != '' THEN p_dash_type ELSE NULL END,
        CASE WHEN p_spc_auth_code IS NOT NULL AND p_spc_auth_code != '' THEN p_spc_auth_code ELSE NULL END,
        CASE WHEN p_appl_list IS NOT NULL AND p_appl_list != '' THEN p_appl_list ELSE NULL END,
        CASE WHEN p_com_code IS NOT NULL AND p_com_code != '' THEN p_com_code ELSE NULL END,
        CASE WHEN p_com_name IS NOT NULL AND p_com_name != '' THEN p_com_name ELSE NULL END,
        CASE WHEN p_empl_no IS NOT NULL AND p_empl_no != '' THEN p_empl_no ELSE NULL END,
        CASE WHEN p_dept_code IS NOT NULL AND p_dept_code != '' THEN p_dept_code ELSE NULL END,
        CASE WHEN p_dept_code IS NOT NULL AND p_dept_code != '' THEN v_dept_name ELSE NULL END,
        CASE WHEN p_dept_code IS NOT NULL AND p_dept_code != '' THEN p_dept_code ELSE NULL END,
        CASE WHEN p_uppr_dept_code IS NOT NULL AND p_uppr_dept_code != '' THEN p_uppr_dept_code ELSE NULL END,
        CASE WHEN p_user_tel IS NOT NULL AND p_user_tel != '' THEN p_user_tel ELSE NULL END,
        CASE WHEN p_user_hp IS NOT NULL AND p_user_hp != '' THEN p_user_hp ELSE NULL END,
        CASE WHEN p_user_mail IS NOT NULL AND p_user_mail != '' THEN p_user_mail ELSE NULL END,
        CASE WHEN p_sale_grup IS NOT NULL AND p_sale_grup != '' THEN p_sale_grup ELSE NULL END,
        CASE WHEN p_regn_magr IS NOT NULL AND p_regn_magr != '' THEN p_regn_magr ELSE NULL END,
        CASE WHEN p_regn_gb IS NOT NULL AND p_regn_gb != '' THEN p_regn_gb ELSE NULL END,
        CASE WHEN p_ship_loc IS NOT NULL AND p_ship_loc != '' THEN p_ship_loc ELSE NULL END,
        CASE WHEN p_id_lspo IS NOT NULL AND p_id_lspo != '' THEN p_id_lspo ELSE NULL END,
        CASE WHEN p_id_lws IS NOT NULL AND p_id_lws != '' THEN p_id_lws ELSE NULL END,
        CASE WHEN p_id_merc IS NOT NULL AND p_id_merc != '' THEN p_id_merc ELSE NULL END,
        CASE WHEN p_id_serv IS NOT NULL AND p_id_serv != '' THEN p_id_serv ELSE NULL END,
        CASE WHEN p_id_wgbc IS NOT NULL AND p_id_wgbc != '' THEN p_id_wgbc ELSE NULL END,
        CASE WHEN p_id_mts IS NOT NULL AND p_id_mts != '' THEN p_id_mts ELSE NULL END,
        CASE WHEN p_id_acb IS NOT NULL AND p_id_acb != '' THEN p_id_acb ELSE NULL END,
        CASE WHEN p_id_sprout_loud IS NOT NULL AND p_id_sprout_loud != '' THEN p_id_sprout_loud ELSE NULL END,
        CASE WHEN p_id_sfdc IS NOT NULL AND p_id_sfdc != '' THEN p_id_sfdc ELSE NULL END,
        CASE WHEN p_create_mail_flag IS NOT NULL AND p_create_mail_flag != '' THEN p_create_mail_flag ELSE NULL END,
        CASE WHEN p_review_mail_flag IS NOT NULL AND p_review_mail_flag != '' THEN p_review_mail_flag ELSE NULL END,
        CASE WHEN p_conf_mail_flag IS NOT NULL AND p_conf_mail_flag != '' THEN p_conf_mail_flag ELSE NULL END,
        CASE WHEN p_ready_mail_flag IS NOT NULL AND p_ready_mail_flag != '' THEN p_ready_mail_flag ELSE NULL END,
        CASE WHEN p_ship_mail_flag IS NOT NULL AND p_ship_mail_flag != '' THEN p_ship_mail_flag ELSE NULL END,
        CASE WHEN p_comp_mail_flag IS NOT NULL AND p_comp_mail_flag != '' THEN p_comp_mail_flag ELSE NULL END,
        CASE WHEN p_return_mail_flag IS NOT NULL AND p_return_mail_flag != '' THEN p_return_mail_flag ELSE NULL END,
        CASE WHEN p_sfdc_flag IS NOT NULL AND p_sfdc_flag != '' THEN p_sfdc_flag ELSE NULL END,
        CASE WHEN p_noti_allread_yn IS NOT NULL AND p_noti_allread_yn != '' THEN p_noti_allread_yn ELSE NULL END,
        p_smtp_mail,
        p_smtp_pw,
        CASE WHEN p_user_remk IS NOT NULL AND p_user_remk != '' THEN p_user_remk ELSE NULL END,
        CASE WHEN p_if_mc_code IS NOT NULL AND p_if_mc_code != '' THEN p_if_mc_code ELSE NULL END,
        'Y',
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW(),
        NOW()
    );
END//

-- ============================================================
-- 5. sp_user2_update: 사용자 수정
-- AS-IS: update - UPDATE with all fields
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_update//

CREATE PROCEDURE sp_user2_update(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_name VARCHAR(100),
    IN p_user_type VARCHAR(20),
    IN p_menu_set VARCHAR(20),
    IN p_menu_type VARCHAR(20),
    IN p_dash_type VARCHAR(20),
    IN p_mobile_type VARCHAR(20),
    IN p_org_auth_code VARCHAR(20),
    IN p_spc_auth_code VARCHAR(20),
    IN p_appl_list TEXT,
    IN p_com_code VARCHAR(20),
    IN p_com_name VARCHAR(100),
    IN p_empl_no VARCHAR(50),
    IN p_dept_code VARCHAR(20),
    IN p_uppr_dept_code VARCHAR(20),
    IN p_user_tel VARCHAR(50),
    IN p_user_hp VARCHAR(50),
    IN p_user_mail VARCHAR(100),
    IN p_sale_grup VARCHAR(20),
    IN p_regn_magr VARCHAR(20),
    IN p_regn_gb VARCHAR(20),
    IN p_ship_loc VARCHAR(50),
    IN p_id_lspo VARCHAR(50),
    IN p_id_lws VARCHAR(50),
    IN p_id_merc VARCHAR(50),
    IN p_id_serv VARCHAR(50),
    IN p_id_wgbc VARCHAR(50),
    IN p_id_mts VARCHAR(50),
    IN p_id_acb VARCHAR(50),
    IN p_id_sprout_loud VARCHAR(50),
    IN p_id_sfdc VARCHAR(50),
    IN p_create_mail_flag VARCHAR(10),
    IN p_review_mail_flag VARCHAR(10),
    IN p_conf_mail_flag VARCHAR(10),
    IN p_ready_mail_flag VARCHAR(10),
    IN p_ship_mail_flag VARCHAR(10),
    IN p_comp_mail_flag VARCHAR(10),
    IN p_return_mail_flag VARCHAR(10),
    IN p_sfdc_flag VARCHAR(10),
    IN p_noti_allread_yn VARCHAR(10),
    IN p_smtp_id VARCHAR(100),
    IN p_smtp_pw VARCHAR(100),
    IN p_user_remk TEXT,
    IN p_if_mc_code VARCHAR(20),
    IN p_use_flag VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_dept_name VARCHAR(100);

    -- 1. TSTD_ORG에서 먼저 조회 (MES 조직)
    SELECT ORG_NAME INTO v_dept_name
    FROM TSTD_ORG
    WHERE ORG_CODE = p_dept_code
    LIMIT 1;

    -- 2. 없으면 SYS_CODE에서 조회 (기존 딜러포털 호환)
    IF v_dept_name IS NULL THEN
        SELECT CODE_NAME INTO v_dept_name
        FROM SYS_CODE
        WHERE SYS_ID = p_sys_id
          AND CODE_GRUP = 'DEPT_CODE'
          AND USE_FLAG = 'Y'
          AND CODE_CD = p_dept_code
        LIMIT 1;
    END IF;

    UPDATE SYS_USER A
    SET
        A.CHNG_ID = p_gs_user_id,
        A.CHNG_DATE = NOW(),
        A.USER_NAME = p_user_name,
        A.USER_TYPE = p_user_type,
        A.MENU_SET = p_menu_set,
        A.MENU_TYPE = p_menu_type,
        A.DASH_TYPE = p_dash_type,
        A.MOBILE_TYPE = p_mobile_type,
        A.ORG_AUTH_CODE = p_org_auth_code,
        A.SPC_AUTH_CODE = p_spc_auth_code,
        A.APPL_LIST = p_appl_list,
        A.COM_CODE = p_com_code,
        A.COM_NAME = p_com_name,
        A.EMPL_NO = p_empl_no,
        A.DEPT_CODE = p_dept_code,
        A.DEPT_NAME = v_dept_name,
        A.ORG_CODE = p_dept_code,
        A.UPPR_DEPT_CODE = p_uppr_dept_code,
        A.USER_TEL = p_user_tel,
        A.USER_HP = p_user_hp,
        A.USER_MAIL = p_user_mail,
        A.SALE_GRUP = p_sale_grup,
        A.REGN_MAGR = IFNULL(p_regn_magr, ''),
        A.REGN_GB = IFNULL(p_regn_gb, ''),
        A.SHIP_LOC = p_ship_loc,
        A.ID_LSPO = p_id_lspo,
        A.ID_LWS = p_id_lws,
        A.ID_MERC = p_id_merc,
        A.ID_SERV = p_id_serv,
        A.ID_WGBC = p_id_wgbc,
        A.ID_MTS = p_id_mts,
        A.ID_ACB = p_id_acb,
        A.ID_SPROUTLOUD = p_id_sprout_loud,
        A.ID_SFDC = p_id_sfdc,
        A.CREATE_MAIL_FLAG = p_create_mail_flag,
        A.REVIEW_MAIL_FLAG = p_review_mail_flag,
        A.CONF_MAIL_FLAG = p_conf_mail_flag,
        A.READY_MAIL_FLAG = p_ready_mail_flag,
        A.SHIP_MAIL_FLAG = p_ship_mail_flag,
        A.COMP_MAIL_FLAG = p_comp_mail_flag,
        A.RETURN_MAIL_FLAG = p_return_mail_flag,
        A.SFDC_FLAG = p_sfdc_flag,
        A.NOTI_ALLREAD_YN = p_noti_allread_yn,
        A.SMTP_MAIL = p_smtp_id,
        A.SMTP_PW = p_smtp_pw,
        A.USER_REMK = p_user_remk,
        A.IF_MC_CODE = p_if_mc_code,
        A.USE_FLAG = fn_dealer_sync(p_use_flag, p_user_type, p_sale_grup, p_ship_loc, p_user_id),
        A.LOGIN_FAIL_CNT = CASE WHEN p_use_flag = 'Y' THEN 0 ELSE LOGIN_FAIL_CNT END
    WHERE A.SYS_ID = p_sys_id
      AND A.USER_ID = p_user_id;
END//

-- ============================================================
-- 6. sp_user2_delete: 사용자 삭제
-- AS-IS: delete - DELETE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_delete//

CREATE PROCEDURE sp_user2_delete(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 7. sp_user2_check_password: 비밀번호 인증 체크
-- AS-IS: checkPassword - SELECT with AES
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_check_password//

CREATE PROCEDURE sp_user2_check_password(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_pwd VARCHAR(200)
)
BEGIN
    SELECT CASE COUNT(1) WHEN 0 THEN 'X' ELSE 'O' END AS result
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND USER_PWD = HEX(AES_ENCRYPT(p_user_id, p_user_pwd));
END//

-- ============================================================
-- 8. sp_user2_update_password: 비밀번호 변경
-- AS-IS: updatePassword - UPDATE password
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_update_password//

CREATE PROCEDURE sp_user2_update_password(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_pwd VARCHAR(200),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_USER
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        USER_PWD = HEX(AES_ENCRYPT(p_user_id, p_user_pwd))
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 9. sp_user2_update_failure: 로그인 실패 카운트 증가
-- AS-IS: updateFailure - UPDATE login_fail_cnt
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_update_failure//

CREATE PROCEDURE sp_user2_update_failure(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_USER
    SET LOGIN_FAIL_CNT = LOGIN_FAIL_CNT + 1
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 10. sp_user2_update_success: 로그인 성공 처리
-- AS-IS: updateSuccess - UPDATE login success
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_update_success//

CREATE PROCEDURE sp_user2_update_success(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_USER
    SET LOGIN_FAIL_CNT = 0,
        LAST_LOGIN_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 11. sp_user2_select_user_type: 사용자 타입 목록 조회
-- AS-IS: selectUserType - SELECT from SYS_CODE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_select_user_type//

CREATE PROCEDURE sp_user2_select_user_type(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT CODE_CD AS codeCd,
           CODE_NAME AS codeNm
    FROM SYS_CODE
    WHERE SYS_ID = p_sys_id
      AND CODE_GRUP = 'USER_TYPE';
END//

-- ============================================================
-- 12. sp_user2_select_code_name: 코드명 조회
-- AS-IS: selectCodeName - SELECT from SYS_CODE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_select_code_name//

CREATE PROCEDURE sp_user2_select_code_name(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(50),
    IN p_code_cd VARCHAR(50)
)
BEGIN
    SELECT CODE_CD AS codeCd,
           CODE_NAME AS codeNm,
           EXT_TEXT AS extText
    FROM SYS_CODE
    WHERE SYS_ID = p_sys_id
      AND CODE_GRUP = p_code_grup
      AND CODE_CD = p_code_cd;
END//

-- ============================================================
-- 13. sp_user2_select_dealer_cdf: 딜러 CDF 조회
-- AS-IS: selectDealerCdf - SELECT from DEAL_MAST
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_select_dealer_cdf//

CREATE PROCEDURE sp_user2_select_dealer_cdf(
    IN p_sys_id VARCHAR(20),
    IN p_deal_code VARCHAR(50)
)
BEGIN
    SELECT LPAD(IFNULL(CASE WHEN GE_CDF_NO = '' THEN 'XXXXXX' ELSE GE_CDF_NO END, 'XXXXXX'), 6, 0) AS GE_CDF_NO
    FROM DEAL_MAST
    WHERE SYS_ID = p_sys_id
      AND DEAL_CODE = p_deal_code;
END//

-- ============================================================
-- 14. sp_user2_select_dealer_info: 딜러 정보 조회
-- AS-IS: selectDealerInfo - SELECT from DEAL_MAST
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_select_dealer_info//

CREATE PROCEDURE sp_user2_select_dealer_info(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    SELECT
        CHAR_BM AS respBm,
        HEAD_DEAL AS headDeal,
        WARE_HOUS AS wareHous,
        SHIP_LOC AS shipLoc,
        SALE_GRUP AS saleGrup,
        ADDR_STR AS addrStr,
        ADDR_BOX AS addrBox,
        POST_CODE AS postCode,
        ADDR_CITY AS addrCity,
        ADDR_CNTY AS addrCnty,
        ADDR_REGN AS addrRegn,
        TRANS_ZONE AS transZone,
        TEL_NO AS telNo,
        FAX_NO AS faxNo,
        MOB_NO AS moNo,
        E_MAIL AS email,
        E_MAIL_LIST AS emailList,
        E_MAIL_RECV AS emailRecv,
        PAY_TYPE AS payType,
        CURR_UNIT AS currUnit
    FROM DEAL_MAST
    WHERE SYS_ID = p_sys_id
      AND DEAL_CODE = p_user_id;
END//

-- ============================================================
-- 15. sp_user2_dashboard_curr_unit: 대시보드 통화단위 조회
-- AS-IS: dashBoardCurrUnit - SELECT from DEAL_MAST
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_dashboard_curr_unit//

CREATE PROCEDURE sp_user2_dashboard_curr_unit(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    SELECT CURR_UNIT AS currUnit
    FROM DEAL_MAST
    WHERE SYS_ID = p_sys_id
      AND DEAL_CODE = p_gs_user_id;
END//

-- ============================================================
-- 16. sp_user2_save_dealer: 딜러 등록
-- AS-IS: saveDealer - INSERT into DEAL_MAST
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_save_dealer//

CREATE PROCEDURE sp_user2_save_dealer(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_name VARCHAR(100),
    IN p_user_type VARCHAR(20),
    IN p_resp_bm VARCHAR(50),
    IN p_head_deal VARCHAR(50),
    IN p_ware_hous VARCHAR(50),
    IN p_ship_loc VARCHAR(50),
    IN p_sale_grup VARCHAR(20),
    IN p_tel_no VARCHAR(50),
    IN p_fax_no VARCHAR(50),
    IN p_mo_no VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_email_list TEXT,
    IN p_email_recv TEXT,
    IN p_pay_type VARCHAR(20),
    IN p_addr_str VARCHAR(200),
    IN p_addr_box VARCHAR(100),
    IN p_addr_city VARCHAR(100),
    IN p_addr_cnty VARCHAR(100),
    IN p_addr_regn VARCHAR(100),
    IN p_trans_zone VARCHAR(50),
    IN p_post_code VARCHAR(20),
    IN p_curr_unit VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO DEAL_MAST (
        SYS_ID,
        DEAL_CODE,
        DEAL_NAME,
        DEAL_TYPE,
        CHAR_BM,
        HEAD_DEAL,
        WARE_HOUS,
        SHIP_LOC,
        SALE_GRUP,
        TEL_NO,
        FAX_NO,
        MOB_NO,
        E_MAIL,
        E_MAIL_LIST,
        E_MAIL_RECV,
        PAY_TYPE,
        ADDR_STR,
        ADDR_BOX,
        ADDR_CITY,
        ADDR_CNTY,
        ADDR_REGN,
        TRANS_ZONE,
        POST_CODE,
        CURR_UNIT,
        CRE_DATE,
        USE_IDX,
        REGI_ID,
        REGI_DATE
    ) VALUES (
        p_sys_id,
        p_user_id,
        p_user_name,
        p_user_type,
        p_resp_bm,
        p_head_deal,
        p_ware_hous,
        p_ship_loc,
        p_sale_grup,
        CASE WHEN p_tel_no IS NOT NULL AND p_tel_no != '' THEN p_tel_no ELSE NULL END,
        CASE WHEN p_fax_no IS NOT NULL AND p_fax_no != '' THEN p_fax_no ELSE NULL END,
        CASE WHEN p_mo_no IS NOT NULL AND p_mo_no != '' THEN p_mo_no ELSE NULL END,
        CASE WHEN p_email IS NOT NULL AND p_email != '' THEN p_email ELSE NULL END,
        CASE WHEN p_email_list IS NOT NULL AND p_email_list != '' THEN p_email_list ELSE NULL END,
        CASE WHEN p_email_recv IS NOT NULL AND p_email_recv != '' THEN p_email_recv ELSE NULL END,
        CASE WHEN p_pay_type IS NOT NULL AND p_pay_type != '' THEN p_pay_type ELSE NULL END,
        CASE WHEN p_addr_str IS NOT NULL AND p_addr_str != '' THEN p_addr_str ELSE NULL END,
        CASE WHEN p_addr_box IS NOT NULL AND p_addr_box != '' THEN p_addr_box ELSE NULL END,
        CASE WHEN p_addr_city IS NOT NULL AND p_addr_city != '' THEN p_addr_city ELSE NULL END,
        CASE WHEN p_addr_cnty IS NOT NULL AND p_addr_cnty != '' THEN p_addr_cnty ELSE NULL END,
        CASE WHEN p_addr_regn IS NOT NULL AND p_addr_regn != '' THEN p_addr_regn ELSE NULL END,
        CASE WHEN p_trans_zone IS NOT NULL AND p_trans_zone != '' THEN p_trans_zone ELSE NULL END,
        CASE WHEN p_post_code IS NOT NULL AND p_post_code != '' THEN p_post_code ELSE NULL END,
        p_curr_unit,
        NOW(),
        'Y',
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 17. sp_user2_save_dealer_user: 딜러 사용자 등록
-- AS-IS: saveDealerUser - INSERT into SYS_USER for dealer
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_save_dealer_user//

CREATE PROCEDURE sp_user2_save_dealer_user(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_name VARCHAR(100),
    IN p_sale_grup VARCHAR(20),
    IN p_ware_hous VARCHAR(50),
    IN p_tel_no VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_email_list TEXT,
    IN p_id_lspo VARCHAR(50),
    IN p_id_lws VARCHAR(50),
    IN p_id_merc VARCHAR(50),
    IN p_id_serv VARCHAR(50),
    IN p_id_wgbc VARCHAR(50),
    IN p_id_mts VARCHAR(50),
    IN p_id_acb VARCHAR(50),
    IN p_id_sprout_loud VARCHAR(50),
    IN p_id_sfdc VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_USER (
        SYS_ID,
        USER_ID,
        USER_NAME,
        USER_PWD,
        USER_TYPE,
        MENU_SET,
        MENU_TYPE,
        SALE_GRUP,
        SHIP_LOC,
        USER_TEL,
        USER_MAIL,
        USER_MAIL_LIST,
        ID_LSPO,
        ID_LWS,
        ID_MERC,
        ID_SERV,
        ID_WGBC,
        ID_MTS,
        ID_ACB,
        ID_SPROUTLOUD,
        ID_SFDC,
        USE_FLAG,
        REGI_ID,
        REGI_DATE,
        PWD_CHNG_DATE
    ) VALUES (
        p_sys_id,
        p_user_id,
        p_user_name,
        HEX(AES_ENCRYPT(p_user_id, (SELECT fn_get_init_user_pwd()))),
        'C',
        'LSTA',
        'A',
        CASE WHEN p_sale_grup IS NOT NULL AND p_sale_grup != '' THEN p_sale_grup ELSE NULL END,
        CASE WHEN p_ware_hous IS NOT NULL AND p_ware_hous != '' THEN p_ware_hous ELSE NULL END,
        CASE WHEN p_tel_no IS NOT NULL AND p_tel_no != '' THEN p_tel_no ELSE NULL END,
        CASE WHEN p_email IS NOT NULL AND p_email != '' THEN p_email ELSE NULL END,
        CASE WHEN p_email_list IS NOT NULL AND p_email_list != '' THEN p_email_list ELSE NULL END,
        CASE WHEN p_id_lspo IS NOT NULL AND p_id_lspo != '' THEN p_id_lspo ELSE NULL END,
        CASE WHEN p_id_lws IS NOT NULL AND p_id_lws != '' THEN p_id_lws ELSE NULL END,
        CASE WHEN p_id_merc IS NOT NULL AND p_id_merc != '' THEN p_id_merc ELSE NULL END,
        CASE WHEN p_id_serv IS NOT NULL AND p_id_serv != '' THEN p_id_serv ELSE NULL END,
        CASE WHEN p_id_wgbc IS NOT NULL AND p_id_wgbc != '' THEN p_id_wgbc ELSE NULL END,
        CASE WHEN p_id_mts IS NOT NULL AND p_id_mts != '' THEN p_id_mts ELSE NULL END,
        CASE WHEN p_id_acb IS NOT NULL AND p_id_acb != '' THEN p_id_acb ELSE NULL END,
        CASE WHEN p_id_sprout_loud IS NOT NULL AND p_id_sprout_loud != '' THEN p_id_sprout_loud ELSE NULL END,
        CASE WHEN p_id_sfdc IS NOT NULL AND p_id_sfdc != '' THEN p_id_sfdc ELSE NULL END,
        'Y',
        p_gs_user_id,
        NOW(),
        NOW()
    );
END//

-- ============================================================
-- 18. sp_user2_update_dealer: 딜러 수정
-- AS-IS: updateDealer - UPDATE DEAL_MAST
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_update_dealer//

CREATE PROCEDURE sp_user2_update_dealer(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_user_name VARCHAR(100),
    IN p_head_deal VARCHAR(50),
    IN p_resp_bm VARCHAR(50),
    IN p_tel_no VARCHAR(50),
    IN p_fax_no VARCHAR(50),
    IN p_mo_no VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_email_list TEXT,
    IN p_email_recv TEXT,
    IN p_pay_type VARCHAR(20),
    IN p_curr_unit VARCHAR(10),
    IN p_addr_str VARCHAR(200),
    IN p_addr_box VARCHAR(100),
    IN p_addr_city VARCHAR(100),
    IN p_addr_cnty VARCHAR(100),
    IN p_addr_regn VARCHAR(100),
    IN p_trans_zone VARCHAR(50),
    IN p_post_code VARCHAR(20),
    IN p_sale_grup VARCHAR(20),
    IN p_ware_hous VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE DEAL_MAST
    SET DEAL_NAME = IFNULL(p_user_name, ''),
        CHAR_BM = IFNULL(p_head_deal, ''),
        HEAD_DEAL = IFNULL(p_resp_bm, ''),
        TEL_NO = IFNULL(p_tel_no, ''),
        FAX_NO = IFNULL(p_fax_no, ''),
        MOB_NO = IFNULL(p_mo_no, ''),
        E_MAIL = IFNULL(p_email, ''),
        E_MAIL_LIST = IFNULL(p_email_list, ''),
        E_MAIL_RECV = IFNULL(p_email_recv, ''),
        PAY_TYPE = IFNULL(p_pay_type, ''),
        CURR_UNIT = IFNULL(p_curr_unit, ''),
        ADDR_STR = IFNULL(p_addr_str, ''),
        ADDR_BOX = IFNULL(p_addr_box, ''),
        ADDR_CITY = IFNULL(p_addr_city, ''),
        ADDR_CNTY = IFNULL(p_addr_cnty, ''),
        ADDR_REGN = IFNULL(p_addr_regn, ''),
        TRANS_ZONE = IFNULL(p_trans_zone, ''),
        POST_CODE = IFNULL(p_post_code, ''),
        SALE_GRUP = IFNULL(p_sale_grup, ''),
        WARE_HOUS = IFNULL(p_ware_hous, ''),
        SHIP_LOC = IFNULL(p_ware_hous, ''),
        CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND DEAL_CODE = p_user_id;
END//

-- ============================================================
-- 19. sp_user2_update_dealer_user: 딜러 사용자 수정
-- AS-IS: updateDealerUser - UPDATE SYS_USER for dealer
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_update_dealer_user//

CREATE PROCEDURE sp_user2_update_dealer_user(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_sale_grup VARCHAR(20),
    IN p_ware_hous VARCHAR(50),
    IN p_tel_no VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_id_lspo VARCHAR(50),
    IN p_id_lws VARCHAR(50),
    IN p_id_merc VARCHAR(50),
    IN p_id_serv VARCHAR(50),
    IN p_id_wgbc VARCHAR(50),
    IN p_id_mts VARCHAR(50),
    IN p_id_acb VARCHAR(50),
    IN p_id_sprout_loud VARCHAR(50),
    IN p_id_sfdc VARCHAR(50),
    IN p_type VARCHAR(20),
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_user_address1 VARCHAR(200),
    IN p_user_city VARCHAR(100),
    IN p_user_regn_code VARCHAR(50),
    IN p_user_post_code VARCHAR(20),
    IN p_tp_account_id VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_USER
    SET SALE_GRUP = IFNULL(p_sale_grup, ''),
        SHIP_LOC = IFNULL(p_ware_hous, ''),
        USER_TEL = IFNULL(p_tel_no, ''),
        USER_MAIL = IFNULL(p_email, ''),
        ID_LSPO = IFNULL(p_id_lspo, ''),
        ID_LWS = IFNULL(p_id_lws, ''),
        ID_MERC = IFNULL(p_id_merc, ''),
        ID_SERV = IFNULL(p_id_serv, ''),
        ID_WGBC = IFNULL(p_id_wgbc, ''),
        ID_MTS = IFNULL(p_id_mts, ''),
        ID_ACB = IFNULL(p_id_acb, ''),
        ID_SPROUTLOUT = IFNULL(p_id_sprout_loud, ''),
        ID_SFDC = IFNULL(p_id_sfdc, ''),
        TYPE = IFNULL(p_type, ''),
        FIRST_NAME = IFNULL(p_first_name, ''),
        LAST_NAME = IFNULL(p_last_name, ''),
        USER_ADDRESS1 = IFNULL(p_user_address1, ''),
        USER_CITY = IFNULL(p_user_city, ''),
        USER_REGN_CODE = IFNULL(p_user_regn_code, ''),
        USER_POST_CODE = IFNULL(p_user_post_code, ''),
        TP_ACCOUNT_ID = IFNULL(p_tp_account_id, ''),
        CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 20. sp_user2_update_dealer_sink: 딜러 동기화 수정
-- AS-IS: updateDealerSink - UPDATE DEAL_MAST for sync
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_update_dealer_sink//

CREATE PROCEDURE sp_user2_update_dealer_sink(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_sale_grup VARCHAR(20),
    IN p_ship_loc VARCHAR(50)
)
BEGIN
    UPDATE DEAL_MAST
    SET SALE_GRUP = IFNULL(p_sale_grup, ''),
        SHIP_LOC = IFNULL(p_ship_loc, ''),
        WARE_HOUS = IFNULL(p_ship_loc, '')
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 21. sp_user2_select_bm_list: BM 목록 조회
-- AS-IS: selectBmList - SELECT from SYS_USER where ORG_AUTH_CODE='BM'
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_select_bm_list//

CREATE PROCEDURE sp_user2_select_bm_list(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT SYS_ID,
           USER_ID,
           USER_NAME
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USE_FLAG = 'Y'
      AND ORG_AUTH_CODE = 'BM'
    ORDER BY USER_NAME;
END//

-- ============================================================
-- 22. sp_user2_select_bm_list1: BM 목록 조회 (특정 사용자 제외)
-- AS-IS: selectBmList1 - SELECT from SYS_USER excluding specific users
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_select_bm_list1//

CREATE PROCEDURE sp_user2_select_bm_list1(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT SYS_ID,
           USER_ID,
           USER_NAME
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USE_FLAG = 'Y'
      AND ORG_AUTH_CODE = 'BM'
      AND USER_ID NOT IN ('devbmrd', 'devbm', 'Ed.Acus', 'jim.startz', 'mindy.hamer', 'Steve.Schulte', 'melissa.steidlmayer', 'Bob.Michael', 'Inside.Sales1', 'Inside.Sales2')
    ORDER BY USER_NAME;
END//

-- ============================================================
-- 23. sp_user2_select_head_deal_list: HEAD DEAL 목록 조회
-- AS-IS: selectHeadDealList - SELECT from SYS_USER where ORG_AUTH_CODE='DEAL'
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_select_head_deal_list//

CREATE PROCEDURE sp_user2_select_head_deal_list(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT SYS_ID,
           USER_ID,
           USER_NAME
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USE_FLAG = 'Y'
      AND ORG_AUTH_CODE = 'DEAL'
    ORDER BY USER_NAME;
END//

-- ============================================================
-- 24. sp_user2_select_auto: 자동 조회 (SALE_GRUP, SHIP_LOC)
-- AS-IS: selectAuto - SELECT from SYS_USER
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_select_auto//

CREATE PROCEDURE sp_user2_select_auto(
    IN p_deal_id VARCHAR(50)
)
BEGIN
    SELECT IFNULL(SALE_GRUP, '') AS SALE_GRUP,
           IFNULL(SHIP_LOC, '') AS SHIP_LOC
    FROM SYS_USER
    WHERE USER_ID = p_deal_id;
END//

-- ============================================================
-- 25. sp_user2_search_type: 사용자 타입 검색
-- AS-IS: searchType - SELECT from SYS_CODE where CODE_GRUP='SP_AUTH'
-- ============================================================
DROP PROCEDURE IF EXISTS sp_user2_search_type//

CREATE PROCEDURE sp_user2_search_type(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT CODE_CD AS menuType,
           CODE_NAME AS menuTypeName
    FROM SYS_CODE
    WHERE SYS_ID = p_sys_id
      AND CODE_GRUP = 'SP_AUTH'
      AND USE_FLAG = 'Y'
    ORDER BY SORT_SEQ;
END//

DELIMITER ;

-- ============================================================
-- END OF sp_user2_procedures.sql
-- ============================================================
