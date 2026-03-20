-- ============================================================
-- Return.xml -> 프로시저 전환 스크립트 (Part 1)
-- namespace: com.wsc.common.rt.Return
-- 내용: search, select 관련 프로시저
-- 생성일: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. [search] ORDR_MAST 목록 조회 (페이징 + 동적 검색 + 동적 정렬)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_search//
CREATE PROCEDURE sp_return_search(
    IN p_sys_id VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_ro_type VARCHAR(10),
    IN p_select_date VARCHAR(10),
    IN p_ordr_date_fr VARCHAR(20),
    IN p_ordr_date_to VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_ordr_no_sap VARCHAR(50),
    IN p_deal_code VARCHAR(20),
    IN p_ship_seri_no VARCHAR(50),
    IN p_stat_key VARCHAR(100),
    IN p_ship_loc VARCHAR(20),
    IN p_char_bm VARCHAR(50),
    IN p_main_key VARCHAR(50),
    IN p_type_ordr VARCHAR(20),
    IN p_type_ordr_op VARCHAR(10),
    IN p_item_modl VARCHAR(50),
    IN p_ch_yn VARCHAR(10),
    IN p_ref_no VARCHAR(50),
    IN p_sort_value VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum = 0;

    SET @v_sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT OM.SYS_ID AS sysId
                          ,OM.ORDR_TYPE AS retnType
                          ,OM.ORDR_NO AS ordrNo
                          ,OM.DEAL_CODE AS dealCode
                          ,OM.DEAL_NAME AS dealName
                          ,OM.ORDR_NO_SAP AS ordrNoSap
                          ,(SELECT DMSB1.CHAR_BM FROM DEAL_MAST DMSB1
                            WHERE DMSB1.SYS_ID = OM.SYS_ID AND DMSB1.DEAL_CODE = OM.DEAL_CODE LIMIT 0,1) AS charBm
                          ,OI.SHIP_SERI_NO AS seriNo
                          ,OM.INV_FILE_INFO AS invNo
                          ,OM.ORDR_ABBR AS ordrAbbr
                          ,OM.ORDR_STAT AS ordrStat
                          ,fn_get_code_name(''RETN_STAT'', OM.ORDR_STAT, ''en'') AS ordrStatName
                          ,CASE WHEN fn_get_trac_desc2(OI.ITEM_CODE, OM.ORDR_NO) != '''' THEN fn_get_trac_desc2(OI.ITEM_CODE, OM.ORDR_NO)
                                WHEN fn_get_atta_desc2(OI.ITEM_CODE, OM.ORDR_NO) != '''' THEN fn_get_atta_desc2(OI.ITEM_CODE, OM.ORDR_NO)
                                ELSE fn_get_adp_desc2(OI.ITEM_CODE, OM.ORDR_NO) END AS itemName
                          ,(SELECT CODE_DESC FROM SYS_CODE WHERE SYS_ID = OM.SYS_ID AND CODE_GRUP = ''WARE_HOUS'' AND CODE_CD = OM.SHIP_LOC) AS shipLoc
                          ,DATE_FORMAT(OM.ORDR_DATE, ''%m.%d.%Y'') AS createDate
                          ,(SELECT APPR_USER FROM SYS_FLOW WHERE SYS_ID = ''', p_sys_id, ''' AND FLOW_NO = OM.ORDR_NO ORDER BY FLOW_SEQ DESC LIMIT 1) AS lastUser
                          ,(SELECT DATE_FORMAT(APPR_DATE, ''%m.%d.%Y'') FROM SYS_FLOW WHERE SYS_ID = ''', p_sys_id, ''' AND FLOW_NO = OM.ORDR_NO ORDER BY FLOW_SEQ DESC LIMIT 1) AS lastDate
                          ,RM.RETN_REF_NO AS refNo
                          ,DATEDIFF(OM.ORDR_DATE, OM.ORDR_CLS_DATE) AS diffDate
                          ,(SELECT DEAL_CODE FROM ORDR_MAST WHERE SYS_ID = ''', p_sys_id, ''' AND USE_IDX = ''Y'' AND ORDR_TYPE = ''TR'' AND ORDR_NO = CONCAT(''TR'',SUBSTR(OM.ORDR_NO,3)) LIMIT 1) AS toDealCode
                          ,(SELECT DEAL_NAME FROM ORDR_MAST WHERE SYS_ID = ''', p_sys_id, ''' AND USE_IDX = ''Y'' AND ORDR_TYPE = ''TR'' AND ORDR_NO = CONCAT(''TR'',SUBSTR(OM.ORDR_NO,3)) LIMIT 1) AS toDealName
                          ,CASE WHEN RM.RETN_TYPE = ''RO'' THEN fn_get_code_name(''RETN_RESN'', RM.RETN_TYPE_RS, ''', IFNULL(p_gs_lang, 'en'), ''')
                                WHEN RM.RETN_TYPE IN (''TR'', ''TO'') THEN fn_get_code_name(''TRAN_RESN'', RM.RETN_TYPE_RS, ''', IFNULL(p_gs_lang, 'en'), ''')
                                ELSE '''' END AS retnTypeRsLbl
                          ,RM.RETN_LOC AS retnLoc
                          ,(CASE RM.RETN_LOC_TYPE
                                WHEN ''D'' THEN CONCAT(RM.RETN_LOC, '' - '', fn_get_deal_name(RM.RETN_LOC))
                                WHEN ''W'' THEN (SELECT CODE_DESC FROM SYS_CODE WHERE SYS_ID = RM.SYS_ID AND CODE_GRUP = ''WARE_HOUS'' AND CODE_CD = RM.RETN_LOC)
                                ELSE '''' END) AS retnLocLbl
                      FROM ORDR_MAST OM
                      LEFT OUTER JOIN ORDR_ITEM OI
                        ON OM.SYS_ID = OI.SYS_ID AND OM.ORDR_TYPE = OI.ORDR_TYPE AND OM.ORDR_NO = OI.ORDR_NO AND OI.USE_IDX = ''Y''
                      LEFT OUTER JOIN RETN_MAST RM
                        ON OM.SYS_ID = RM.SYS_ID AND OM.ORDR_NO = RM.RETN_NO
                     WHERE OM.SYS_ID = ''', p_sys_id, '''
                       AND OM.USE_IDX = ''Y''
                       AND CASE WHEN ''', IFNULL(p_ro_type, ''), ''' = ''TR'' THEN OM.ORDR_TYPE IN (''TO'',''TR'')
                                ELSE OM.ORDR_TYPE = ''', IFNULL(p_ro_type, ''), ''' END');

    -- 날짜 조건
    IF p_ordr_date_fr IS NOT NULL AND p_ordr_date_fr != '' THEN
        SET @v_sql = CONCAT(@v_sql, '
                       AND CASE WHEN ''', IFNULL(p_select_date, ''), ''' = ''100'' THEN OM.ORDR_DATE >= FN_CONV_DATE(''', p_ordr_date_fr, ''')
                                WHEN ''', IFNULL(p_select_date, ''), ''' = ''200'' THEN DATE_FORMAT(OM.ORDR_REG_DATE, ''%Y-%m-%d'') >= FN_CONV_DATE(''', p_ordr_date_fr, ''')
                                WHEN ''', IFNULL(p_select_date, ''), ''' = ''300'' THEN DATE_FORMAT(OM.ORDR_REV_DATE, ''%Y-%m-%d'') >= FN_CONV_DATE(''', p_ordr_date_fr, ''')
                                WHEN ''', IFNULL(p_select_date, ''), ''' = ''400'' THEN DATE_FORMAT(OM.ORDR_CFM_DATE, ''%Y-%m-%d'') >= FN_CONV_DATE(''', p_ordr_date_fr, ''')
                                ELSE DATE_FORMAT(OM.ORDR_CLOSE_DATE, ''%Y-%m-%d'') >= FN_CONV_DATE(''', p_ordr_date_fr, ''') END');
    END IF;

    IF p_ordr_date_to IS NOT NULL AND p_ordr_date_to != '' THEN
        SET @v_sql = CONCAT(@v_sql, '
                       AND CASE WHEN ''', IFNULL(p_select_date, ''), ''' = ''100'' THEN OM.ORDR_DATE <= FN_CONV_DATE(''', p_ordr_date_to, ''')
                                WHEN ''', IFNULL(p_select_date, ''), ''' = ''200'' THEN DATE_FORMAT(OM.ORDR_REG_DATE, ''%Y-%m-%d'') <= FN_CONV_DATE(''', p_ordr_date_to, ''')
                                WHEN ''', IFNULL(p_select_date, ''), ''' = ''300'' THEN DATE_FORMAT(OM.ORDR_REV_DATE, ''%Y-%m-%d'') <= FN_CONV_DATE(''', p_ordr_date_to, ''')
                                WHEN ''', IFNULL(p_select_date, ''), ''' = ''400'' THEN DATE_FORMAT(OM.ORDR_CFM_DATE, ''%Y-%m-%d'') <= FN_CONV_DATE(''', p_ordr_date_to, ''')
                                ELSE DATE_FORMAT(OM.ORDR_CLOSE_DATE, ''%Y-%m-%d'') <= FN_CONV_DATE(''', p_ordr_date_to, ''') END');
    END IF;

    -- ORDR_NO 조건
    SET @v_sql = CONCAT(@v_sql, '
                       AND OM.ORDR_NO LIKE CONCAT(''', IFNULL(p_ordr_no, ''), ''', ''%'')
                       AND IFNULL(OM.ORDR_NO_SAP, '''') LIKE CONCAT(''', IFNULL(p_ordr_no_sap, ''), ''', ''%'')');

    -- DEAL_CODE 조건
    IF p_deal_code IS NOT NULL AND p_deal_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND OM.DEAL_CODE = ''', p_deal_code, '''');
    END IF;

    -- SHIP_SERI_NO 조건
    IF p_ship_seri_no IS NOT NULL AND p_ship_seri_no != '' THEN
        SET @v_sql = CONCAT(@v_sql, '
                       AND OM.ORDR_NO IN (SELECT ORDR_NO FROM ORDR_ITEM WHERE IFNULL(SHIP_SERI_NO, '''') LIKE CONCAT(''%'', ''', p_ship_seri_no, ''', ''%''))');
    END IF;

    -- STAT_KEY 조건
    IF p_stat_key IS NOT NULL AND p_stat_key != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND OM.ORDR_STAT REGEXP ''', p_stat_key, '''');
    END IF;

    -- SHIP_LOC 조건
    IF p_ship_loc IS NOT NULL AND p_ship_loc != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND IFNULL(OM.SHIP_LOC, '''') = ''', p_ship_loc, '''');
    END IF;

    -- CHAR_BM 조건
    IF p_char_bm IS NOT NULL AND p_char_bm != '' THEN
        SET @v_sql = CONCAT(@v_sql, '
                       AND OM.REGI_ID = (SELECT SU.USER_ID FROM SYS_USER SU WHERE SU.USER_ID = ''', p_char_bm, ''')');
    END IF;

    -- ITEM_MODL 조건
    IF p_item_modl IS NOT NULL AND p_item_modl != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND OI.ITEM_MODL LIKE CONCAT(''%'', ''', p_item_modl, ''', ''%'')');
    END IF;

    -- CH_YN 조건
    IF p_ch_yn = 'Y' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND (SELECT COUNT(1) FROM RETN_CHEK_MAST WHERE RETN_NO = OM.ORDR_NO) = 1');
    ELSEIF p_ch_yn = 'N' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND (SELECT COUNT(1) FROM RETN_CHEK_MAST WHERE RETN_NO = OM.ORDR_NO) = 0');
    END IF;

    -- REF_NO 조건
    IF p_ref_no IS NOT NULL AND p_ref_no != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND RM.RETN_SO_NO LIKE CONCAT(''%'', ''', p_ref_no, ''', ''%'')');
    END IF;

    -- 정렬
    IF p_sort_value IS NOT NULL AND p_sort_value != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY ', p_sort_value);
    ELSE
        SET @v_sql = CONCAT(@v_sql, ' ORDER BY OM.ORDR_NO DESC');
    END IF;

    -- 페이징
    IF p_start IS NOT NULL AND p_end IS NOT NULL THEN
        SET @v_sql = CONCAT(@v_sql, '
                ) Z1, (SELECT @rownum:=0) Z2
            ) X WHERE RNUM < ', p_end, '
        ) X WHERE RNUM >= ', p_start);
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
-- 2. [searchCount] ORDR_MAST 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_search_count//
CREATE PROCEDURE sp_return_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_ro_type VARCHAR(10),
    IN p_select_date VARCHAR(10),
    IN p_ordr_date_fr VARCHAR(20),
    IN p_ordr_date_to VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_ordr_no_sap VARCHAR(50),
    IN p_deal_code VARCHAR(20),
    IN p_ship_seri_no VARCHAR(50),
    IN p_stat_key VARCHAR(100),
    IN p_ship_loc VARCHAR(20),
    IN p_char_bm VARCHAR(50),
    IN p_item_modl VARCHAR(50),
    IN p_ch_yn VARCHAR(10),
    IN p_ref_no VARCHAR(50)
)
BEGIN
    SET @v_sql = CONCAT('
        SELECT COUNT(1) AS cnt
          FROM ORDR_MAST OM
          LEFT OUTER JOIN ORDR_ITEM OI
            ON OM.SYS_ID = OI.SYS_ID AND OM.ORDR_TYPE = OI.ORDR_TYPE AND OM.ORDR_NO = OI.ORDR_NO AND OI.USE_IDX = ''Y''
          LEFT OUTER JOIN RETN_MAST RM
            ON OM.SYS_ID = RM.SYS_ID AND OM.ORDR_NO = RM.RETN_NO
         WHERE OM.SYS_ID = ''', p_sys_id, '''
           AND OM.USE_IDX = ''Y''
           AND CASE WHEN ''', IFNULL(p_ro_type, ''), ''' = ''TR'' THEN OM.ORDR_TYPE IN (''TO'',''TR'')
                    ELSE OM.ORDR_TYPE = ''', IFNULL(p_ro_type, ''), ''' END');

    IF p_ordr_date_fr IS NOT NULL AND p_ordr_date_fr != '' THEN
        SET @v_sql = CONCAT(@v_sql, '
           AND CASE WHEN ''', IFNULL(p_select_date, ''), ''' = ''100'' THEN OM.ORDR_DATE >= FN_CONV_DATE(''', p_ordr_date_fr, ''')
                    WHEN ''', IFNULL(p_select_date, ''), ''' = ''200'' THEN DATE_FORMAT(OM.ORDR_REG_DATE, ''%Y-%m-%d'') >= FN_CONV_DATE(''', p_ordr_date_fr, ''')
                    WHEN ''', IFNULL(p_select_date, ''), ''' = ''300'' THEN DATE_FORMAT(OM.ORDR_REV_DATE, ''%Y-%m-%d'') >= FN_CONV_DATE(''', p_ordr_date_fr, ''')
                    WHEN ''', IFNULL(p_select_date, ''), ''' = ''400'' THEN DATE_FORMAT(OM.ORDR_CFM_DATE, ''%Y-%m-%d'') >= FN_CONV_DATE(''', p_ordr_date_fr, ''')
                    ELSE DATE_FORMAT(OM.ORDR_CLOSE_DATE, ''%Y-%m-%d'') >= FN_CONV_DATE(''', p_ordr_date_fr, ''') END');
    END IF;

    IF p_ordr_date_to IS NOT NULL AND p_ordr_date_to != '' THEN
        SET @v_sql = CONCAT(@v_sql, '
           AND CASE WHEN ''', IFNULL(p_select_date, ''), ''' = ''100'' THEN OM.ORDR_DATE <= FN_CONV_DATE(''', p_ordr_date_to, ''')
                    WHEN ''', IFNULL(p_select_date, ''), ''' = ''200'' THEN DATE_FORMAT(OM.ORDR_REG_DATE, ''%Y-%m-%d'') <= FN_CONV_DATE(''', p_ordr_date_to, ''')
                    WHEN ''', IFNULL(p_select_date, ''), ''' = ''300'' THEN DATE_FORMAT(OM.ORDR_REV_DATE, ''%Y-%m-%d'') <= FN_CONV_DATE(''', p_ordr_date_to, ''')
                    WHEN ''', IFNULL(p_select_date, ''), ''' = ''400'' THEN DATE_FORMAT(OM.ORDR_CFM_DATE, ''%Y-%m-%d'') <= FN_CONV_DATE(''', p_ordr_date_to, ''')
                    ELSE DATE_FORMAT(OM.ORDR_CLOSE_DATE, ''%Y-%m-%d'') <= FN_CONV_DATE(''', p_ordr_date_to, ''') END');
    END IF;

    SET @v_sql = CONCAT(@v_sql, '
           AND OM.ORDR_NO LIKE CONCAT(''', IFNULL(p_ordr_no, ''), ''', ''%'')
           AND IFNULL(OM.ORDR_NO_SAP, '''') LIKE CONCAT(''', IFNULL(p_ordr_no_sap, ''), ''', ''%'')');

    IF p_deal_code IS NOT NULL AND p_deal_code != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND OM.DEAL_CODE = ''', p_deal_code, '''');
    END IF;

    IF p_ship_seri_no IS NOT NULL AND p_ship_seri_no != '' THEN
        SET @v_sql = CONCAT(@v_sql, '
           AND OM.ORDR_NO IN (SELECT ORDR_NO FROM ORDR_ITEM WHERE IFNULL(SHIP_SERI_NO, '''') LIKE CONCAT(''%'', ''', p_ship_seri_no, ''', ''%''))');
    END IF;

    IF p_stat_key IS NOT NULL AND p_stat_key != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND OM.ORDR_STAT REGEXP ''', p_stat_key, '''');
    END IF;

    IF p_ship_loc IS NOT NULL AND p_ship_loc != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND IFNULL(OM.SHIP_LOC, '''') = ''', p_ship_loc, '''');
    END IF;

    IF p_char_bm IS NOT NULL AND p_char_bm != '' THEN
        SET @v_sql = CONCAT(@v_sql, '
           AND OM.REGI_ID = (SELECT SU.USER_ID FROM SYS_USER SU WHERE SU.USER_ID = ''', p_char_bm, ''')');
    END IF;

    IF p_item_modl IS NOT NULL AND p_item_modl != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND OI.ITEM_MODL LIKE CONCAT(''%'', ''', p_item_modl, ''', ''%'')');
    END IF;

    IF p_ch_yn = 'Y' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND (SELECT COUNT(1) FROM RETN_CHEK_MAST WHERE RETN_NO = OM.ORDR_NO) = 1');
    ELSEIF p_ch_yn = 'N' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND (SELECT COUNT(1) FROM RETN_CHEK_MAST WHERE RETN_NO = OM.ORDR_NO) = 0');
    END IF;

    IF p_ref_no IS NOT NULL AND p_ref_no != '' THEN
        SET @v_sql = CONCAT(@v_sql, ' AND RM.RETN_SO_NO LIKE CONCAT(''%'', ''', p_ref_no, ''', ''%'')');
    END IF;

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 3. [select] 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_select//
CREATE PROCEDURE sp_return_select(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT OM.ORDR_NO AS ordrNo
          ,ORDR_STAT AS ordrStat
          ,fn_get_code_name('RETN_STAT', ORDR_STAT, 'en') AS ordrStatName
          ,RM.RETN_DO_NO AS retnDoNo
          ,RM.RETN_SO_NO AS retnSoNo
          ,RM.RETN_REF_NO AS reference
          ,DATE_FORMAT(OM.ORDR_DATE, '%m.%d.%Y') AS ordrDate
          ,OM.REGI_ID AS writer
          ,OM.DEAL_CODE AS fromDealCode
          ,OM.DEAL_NAME AS dealName
          ,CONCAT(OM.DEAL_CODE, ' ', OM.DEAL_NAME) AS fromDealer
          ,OM.SHIP_TO_CITY AS fromDealerAddr
          ,OM.PAY_METH AS payMeth
          ,fn_get_code_name('PAYM_METH', OM.PAY_METH, p_gs_lang) AS payMethLbl
          ,OM.CUST_PO_NO AS custPoNo
          ,OM.INV_FILE_INFO AS item_invNo
          ,DATE_FORMAT(OM.ORDR_CLS_DATE, '%m.%d.%Y') AS item_invDate
          ,FORMAT(OM.GROS_AMT, 0) AS item_invAmt
          ,RM.TO_DEAL_CODE AS toDealCode
          ,RM.TO_DEAL_NAME AS toDealName
          ,CONCAT(RM.TO_DEAL_CODE, ' ', RM.TO_DEAL_NAME) AS toDealer
          ,RM.TO_DEAL_CITY AS toDealerAddr
          ,DATE_FORMAT(RM.RETL_DATE, '%m.%d.%Y') AS retlDate
          ,DATE_FORMAT(RM.TRSF_DATE, '%m.%d.%Y') AS trsfDate
          ,APPRL_YN
          ,CASE WHEN APPRL_YN = 'Y' THEN 'Yes'
                WHEN APPRL_YN = 'N' THEN 'Not yet'
                ELSE '' END AS APPRL_YN_LBL
          ,RM.RETN_TYPE_RD AS retnTypeRd
          ,fn_get_code_name('RETURN_TYPE', RM.RETN_TYPE_RD, p_gs_lang) AS retnTypeLbl
          ,RM.RETN_TYPE_RS AS retnTypeRs
          ,CASE WHEN RM.RETN_TYPE = 'RO' THEN fn_get_code_name('RETN_RESN', RM.RETN_TYPE_RS, p_gs_lang)
                WHEN RM.RETN_TYPE IN ('TR', 'TO') THEN fn_get_code_name('TRAN_RESN', RM.RETN_TYPE_RS, p_gs_lang)
                ELSE '' END AS retnTypeRsLbl
          ,RM.CHK_WELL_FARGO AS chk_wf
          ,RM.CHK_DEAL AS chk_deal
          ,RM.CHK_LS AS chk_ls
          ,RM.RETN_LOC AS retnLoc
          ,RM.RETN_LOC_TYPE AS retnLocType
          ,RM.RETN_LOC_ADDR AS retnLocAddr
          ,RM.RETN_LOC_ZIP AS retnLocZip
          ,RM.RETN_LOC_CITY AS retnLocCity
          ,RM.RETN_LOC_REGN AS retnLocRegn
          ,RM.RETN_LOC_CNTY AS retnLocCnty
          ,DATE_FORMAT(RM.EST_RETN_DATE, '%m.%d.%Y') AS estRetnDate
          ,RM.RETN_RESN AS retnResn
          ,REPLACE(RM.RETN_RESN, '\n', '&lt;br&gt;') AS retnResnLbl
          ,RM.TRSF_RESN_RD AS trsfResnRd
          ,REPLACE(RM.TRSF_RESN, '\n', '&lt;br&gt;') AS trsfResnLbl
          ,RM.TRSF_RESN AS trsfResn
          ,RM.SWAP_YN AS swapYn
          ,RM.TRANS_YN AS transYn
          ,RM.GRAD_YN AS gradYn
          ,RM.INST_DESC AS instDesc
          ,REPLACE(RM.INST_DESC, '\n', '&lt;br&gt;') AS instDescLbl
          ,RCM.INSP_TOT_GRAD
          ,RCM.INSP_GRAD_A
          ,RCM.INSP_GRAD_B
          ,RCM.INSP_GRAD_C
          ,RCM.APPR_REQR
          ,RCM.APPR_MNGR
          ,RM.FFR_NO AS ffrNo
          ,'RT' AS bordGrup
          ,OM.ORDR_NO AS bordNo
          ,RM.REMK AS remk
      FROM ORDR_MAST OM
           LEFT OUTER JOIN RETN_CHEK_MAST RCM ON OM.ORDR_NO = RCM.RETN_NO
          ,RETN_MAST RM
     WHERE OM.SYS_ID = p_sys_id
       AND OM.ORDR_NO = p_ordr_no
       AND OM.ORDR_NO = RM.RETN_NO;
END//

-- ============================================================
-- 4. [selectItem] 아이템 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_select_item//
CREATE PROCEDURE sp_return_select_item(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    SELECT OI.ITEM_MODL AS itemModl
          ,OI.ITEM_TYPE AS itemType
          ,OI.ITEM_CODE AS itemCode
          ,OI.ITEM_NAME AS itemName
          ,OI.ITEM_MODL AS ITEMMODL1
          ,OI.ITEM_TYPE AS ITEMTYPE1
          ,OI.ITEM_CODE AS ITEMCODE1
          ,OI.ITEM_NAME AS ITEMNAME1
          ,OI.SHIP_SERI_NO AS seriNo
          ,fn_get_vin_no(OI.SHIP_SERI_NO) AS vinNo
          ,RI.USE_HOUR AS useHour
          ,RI.CRED_AMT AS credAmt
          ,RI.RE_BILL_PRCE AS reBillPrce
          ,RI.TERM_GE_LST AS termGeLst
          ,RI.FLOR_PERD AS florPerd
          ,RI.RETL_INTV AS retlIntv
          ,RI.ACC_COMT AS accComt
          ,RI.NOT_ACC_COMT AS notAccComt
          ,OM.INV_FILE_INFO AS item_invNo
          ,IFNULL(DATE_FORMAT(OM.ORDR_CLS_DATE, '%m.%d.%Y'), '') AS item_invDate
          ,FORMAT(OI.ITEM_AMT, 0) AS item_invAmt
      FROM ORDR_MAST OM
          ,ORDR_ITEM OI
          ,RETN_ITEM RI
     WHERE OM.SYS_ID = p_sys_id
       AND OM.SYS_ID = OI.SYS_ID
       AND OM.ORDR_NO = p_ordr_no
       AND OM.ORDR_NO = OI.ORDR_NO
       AND OI.ORDR_NO = RI.RETN_NO
       AND OI.ORDR_SEQ = RI.RETN_SEQ;
END//

-- ============================================================
-- 5. [selectTransItem] Trans 아이템 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_select_trans_item//
CREATE PROCEDURE sp_return_select_trans_item(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    SELECT ITEM_MODL AS itemModl
          ,SHIP_SERI_NO AS seriNo
          ,ITEM_QTY AS qty
          ,HOUR AS hours
          ,BEF_INFO AS bfeInfo
          ,AFT_INFO AS aftInfo
          ,FORMAT(ITEM_AMT, 0) AS reBillPrce
          ,SYS_REMK AS remark
      FROM RETN_TRANS_ITEM
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 6. [selectSwapItem] Swap 아이템 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_select_swap_item//
CREATE PROCEDURE sp_return_select_swap_item(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    SELECT ITEM_MODL AS itemModl
          ,SHIP_SERI_NO AS seriNo
          ,ITEM_QTY AS qty
          ,OLD_SERI_NO AS oldSeri
          ,NEW_SERI_NO AS newSeri
          ,SYS_REMK AS remark
      FROM RETN_SWAP_ITEM
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 7. [getRetnOrdrNo] 주문번호 생성
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_retn_ordr_no//
CREATE PROCEDURE sp_return_get_retn_ordr_no(
    IN p_ro_type VARCHAR(10)
)
BEGIN
    SELECT FN_GET_ORDR_NO(p_ro_type) AS ordrNo;
END//

-- ============================================================
-- 8. [searchAddr] 주소 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_search_addr//
CREATE PROCEDURE sp_return_search_addr(
    IN p_deal_code VARCHAR(20)
)
BEGIN
    SELECT DM.DEAL_CODE
          ,DM.DEAL_NAME AS SHIP_TO_NAME
          ,DM.SALE_GRUP
          ,DM.WARE_HOUS
          ,DM.E_MAIL AS SHIP_TO_EMAIL
          ,DM.TEL_NO AS SHIP_TO_TEL
          ,DM.TEL_EXT AS SHIP_TO_TEL_EXT
          ,DM.MOB_NO AS SHIP_TO_MOB
          ,DM.FAX_NO AS SHIP_TO_FAX
          ,DM.TRANS_ZONE AS SHIP_TO_STATE
          ,DM.ADDR_STR AS SHIP_TO_ADDRESS1
          ,DM.ADDR_BOX AS SHIP_TO_POBOX
          ,DM.ADDR_REGN AS SHIP_TO_LZONE
          ,DM.ADDR_CITY AS SHIP_TO_CITY
          ,DM.ADDR_CNTY AS SHIP_TO_COUNTRY
          ,DM.PAY_TYPE
          ,DM.POST_CODE AS SHIP_TO_ZIP
          ,IFNULL(DM.SHIP_TO, DM.DEAL_CODE) AS SHIP_TO
      FROM DEAL_MAST DM
     WHERE DM.DEAL_CODE = p_deal_code;
END//

-- ============================================================
-- 9. [searchOrder] 주문 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_search_order//
CREATE PROCEDURE sp_return_search_order(
    IN p_sys_id VARCHAR(20),
    IN p_ref_no VARCHAR(50)
)
BEGIN
    SELECT OM.ORDR_NO AS retnDoNo
          ,OM.ORDR_NO_SAP AS retnSoNo
          ,CASE WHEN OM.ORDR_NO = p_ref_no THEN OM.ORDR_NO
                WHEN OM.ORDR_NO_SAP = p_ref_no THEN OM.ORDR_NO_SAP
                ELSE OM.ORDR_NO_SAP END AS refNo
          ,OM.DEAL_CODE
          ,FORMAT(OI.ITEM_AMT, 0) AS GROS_AMT
          ,OM.SHIP_TO_CITY
          ,OM.INV_FILE_INFO
          ,DATE_FORMAT(OM.ORDR_CLS_DATE, '%m.%d.%Y') AS ORDR_CLS_DATE
          ,OM.CUST_PO_NO
          ,OM.PAY_METH
          ,DATE_FORMAT(OM.EST_RETN_DATE, '%m.%d.%Y') AS EST_RETN_DATE
          ,OM.RETN_LOC
          ,OM.RETN_LOC_TYPE
          ,OI.ITEM_MODL
          ,OI.ITEM_TYPE
          ,OI.SHIP_SERI_NO
          ,fn_get_vin_no(OI.SHIP_SERI_NO) AS VIN_NO
          ,OI.ITEM_CODE
          ,OI.ITEM_NAME
      FROM ORDR_MAST OM
          ,ORDR_ITEM OI
     WHERE OM.SYS_ID = OI.SYS_ID
       AND OM.ORDR_TYPE = OI.ORDR_TYPE
       AND OM.ORDR_NO = OI.ORDR_NO
       AND OI.ITEM_TYPE <> 'DISC'
       AND OI.ITEM_TYPE NOT LIKE '%OP%'
       AND OM.ORDR_TYPE NOT IN ('RO', 'TO', 'TR', 'ER')
       AND (OM.ORDR_NO = p_ref_no
        OR ORDR_NO_SAP = p_ref_no
        OR OM.ORDR_NO = (SELECT ORDR_NO FROM ORDR_ITEM WHERE SHIP_SERI_NO = p_ref_no AND ORDR_TYPE NOT IN ('RO','TO','TR','ER') ORDER BY SUBSTRING(ORDR_NO,3) DESC LIMIT 1));
END//

-- ============================================================
-- 10. [searchOrderHist] 주문 이력 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_search_order_hist//
CREATE PROCEDURE sp_return_search_order_hist(
    IN p_sys_id VARCHAR(20),
    IN p_ref_no VARCHAR(50)
)
BEGIN
    SELECT '' AS retnDoNo
          ,MH.SALE_NO AS retnSoNo
          ,MH.SALE_NO AS refNo
          ,MH.DEAL_CODE
          ,0 AS GROS_AMT
          ,'' AS SHIP_TO_CITY
          ,'' AS INV_FILE_INFO
          ,DATE_FORMAT(MH.GI_ENTRY_DATE, '%m.%d.%Y') AS ORDR_CLS_DATE
          ,'' AS CUST_PO_NO
          ,'' AS PAY_METH
          ,MH.ITEM_MODL
          ,MH.ITEM_TYPE
          ,MH.SERI_NO AS SHIP_SERI_NO
          ,MH.ITEM_CODE
          ,MH.ITEM_NAME
      FROM MI_HIST MH
     WHERE MH.SYS_ID = p_sys_id
       AND (MH.SALE_NO = p_ref_no
        OR MH.SALE_NO = (SELECT SALE_NO FROM MI_HIST WHERE SERI_NO = p_ref_no ORDER BY GI_ENTRY_DATE DESC LIMIT 1));
END//

-- ============================================================
-- 11. [searchOrderSeriNo] 시리얼번호로 주문 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_search_order_seri_no//
CREATE PROCEDURE sp_return_search_order_seri_no(
    IN p_sys_id VARCHAR(20),
    IN p_ref_no VARCHAR(50)
)
BEGIN
    SELECT OM.ORDR_NO AS retnDoNo
          ,OM.ORDR_NO_SAP AS retnSoNo
          ,OM.DEAL_CODE
          ,FORMAT(OI.ITEM_AMT, 0) AS GROS_AMT
          ,OM.SHIP_TO_CITY
          ,OM.INV_FILE_INFO
          ,DATE_FORMAT(OM.ORDR_CLS_DATE, '%m.%d.%Y') AS ORDR_CLS_DATE
          ,OM.CUST_PO_NO
          ,OM.PAY_METH
          ,OI.ITEM_MODL
          ,OI.ITEM_TYPE
          ,OI.SHIP_SERI_NO
          ,fn_get_vin_no(OI.SHIP_SERI_NO) AS VIN_NO
          ,OI.ITEM_CODE
          ,OI.ITEM_NAME
      FROM ORDR_MAST OM
          ,ORDR_ITEM OI
     WHERE OM.SYS_ID = OI.SYS_ID
       AND OM.ORDR_TYPE = OI.ORDR_TYPE
       AND OM.ORDR_NO = OI.ORDR_NO
       AND OI.ITEM_TYPE <> 'DISC'
       AND OI.ITEM_TYPE NOT LIKE '%OP%'
       AND OM.ORDR_TYPE NOT IN ('RO', 'TO', 'TR', 'ER')
       AND OI.SHIP_SERI_NO = p_ref_no;
END//

-- ============================================================
-- 12. [searchOrderSeriNoHist] 시리얼번호로 이력 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_search_order_seri_no_hist//
CREATE PROCEDURE sp_return_search_order_seri_no_hist(
    IN p_sys_id VARCHAR(20),
    IN p_ref_no VARCHAR(50)
)
BEGIN
    SELECT '' AS retnDoNo
          ,MH.SALE_NO AS retnSoNo
          ,MH.DEAL_CODE
          ,0 AS GROS_AMT
          ,'' AS SHIP_TO_CITY
          ,'' AS INV_FILE_INFO
          ,DATE_FORMAT(MH.GI_ENTRY_DATE, '%m.%d.%Y') AS ORDR_CLS_DATE
          ,'' AS CUST_PO_NO
          ,'' AS PAY_METH
          ,MH.ITEM_MODL
          ,MH.ITEM_TYPE
          ,MH.SERI_NO AS SHIP_SERI_NO
          ,MH.ITEM_CODE
          ,MH.ITEM_NAME
      FROM MI_HIST MH
     WHERE MH.SYS_ID = p_sys_id
       AND MH.SERI_NO = p_ref_no;
END//

-- ============================================================
-- 13. [getWFInfo] 워크플로우 정보 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_wf_info//
CREATE PROCEDURE sp_return_get_wf_info(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    SELECT FLOW_SEQ
          ,APPR_AUTH_CODE
          ,fn_get_code_name('RETN_STAT', FLOW_STAT, 'en') AS FLOW_STAT
          ,APPR_USER
          ,DATE_FORMAT(APPR_DATE, '%m.%d.%Y') AS APPR_DATE
          ,APPR_YN
          ,APPR_COMT
      FROM SYS_FLOW
     WHERE SYS_ID = p_sys_id
       AND FLOW_NO = p_ordr_no
     ORDER BY FLOW_SEQ;
END//

-- ============================================================
-- 14. [getOderInfo] 주문 정보 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_oder_info//
CREATE PROCEDURE sp_return_get_oder_info(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    SELECT ordrNo
          ,ordrType
          ,ordrStat
          ,ORG_AUTH_CODE
          ,createUser
          ,nowUser
          ,CASE WHEN ordrStat IN ('100','200','250') AND ORG_AUTH_CODE = 'BM' THEN 'Y'
                WHEN ordrStat IN ('200','350') AND ORG_AUTH_CODE = 'SALES' THEN 'Y'
                WHEN ordrStat IN ('300') AND ORG_AUTH_CODE = 'SALES' THEN 'Y'
                ELSE 'N' END AS edit_YN
      FROM (
          SELECT OM.ORDR_NO AS ordrNo
                ,OM.ORDR_TYPE AS ordrType
                ,ORDR_STAT AS ordrStat
                ,CASE WHEN (SELECT CODE_CD FROM SYS_CODE WHERE SYS_ID = p_sys_id AND CODE_GRUP = 'RETN_MAIL' AND CODE_NAME = p_gs_user_id) = 'SALES' THEN 'SALES'
                      ELSE (SELECT ORG_AUTH_CODE FROM SYS_USER WHERE USER_ID = p_gs_user_id) END AS ORG_AUTH_CODE
                ,ORDR_CRET_USER AS createUser
                ,p_gs_user_id AS nowUser
            FROM ORDR_MAST OM
           WHERE OM.SYS_ID = p_sys_id
             AND OM.ORDR_NO = p_ordr_no
      ) aa;
END//

DELIMITER ;
