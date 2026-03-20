-- ============================================================
-- Return.xml -> 프로시저 전환 스크립트 (Part 2)
-- namespace: com.wsc.common.rt.Return
-- 내용: INSERT, UPDATE, DELETE 관련 프로시저
-- 생성일: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- 15. [ordrMastInsert] ORDR_MAST 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_ordr_mast_insert//
CREATE PROCEDURE sp_return_ordr_mast_insert(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_from_deal_code VARCHAR(20),
    IN p_from_ship_to VARCHAR(50),
    IN p_from_ship_to_name VARCHAR(100),
    IN p_from_ship_to_address1 VARCHAR(200),
    IN p_from_ship_to_pobox VARCHAR(50),
    IN p_from_ship_to_city VARCHAR(100),
    IN p_from_ship_to_zip VARCHAR(20),
    IN p_from_ship_to_country VARCHAR(50),
    IN p_from_ship_to_lzone VARCHAR(50),
    IN p_from_ship_to_state VARCHAR(50),
    IN p_from_ship_to_tel VARCHAR(50),
    IN p_from_ship_to_telext VARCHAR(20),
    IN p_from_ship_to_mob VARCHAR(50),
    IN p_from_ship_to_fax VARCHAR(50),
    IN p_from_ship_to_email VARCHAR(100),
    IN p_cust_po_no VARCHAR(50),
    IN p_pay_meth VARCHAR(20),
    IN p_inv_file_info VARCHAR(200),
    IN p_ordr_cls_date VARCHAR(20),
    IN p_ro_type VARCHAR(10),
    IN p_eo_sts VARCHAR(20),
    IN p_est_retn_date VARCHAR(20),
    IN p_retn_loc VARCHAR(50),
    IN p_retn_loc_type VARCHAR(10),
    IN p_retn_do_no VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO ORDR_MAST (
        SYS_ID, ORDR_TYPE, ORDR_NO, ORDR_DATE, ORDR_STAT, ORDR_NO_SAP,
        DEAL_CODE, DEAL_NAME, SHIP_TO, SHIP_TO_NAME,
        SHIP_TO_ADDRESS1, SHIP_TO_POBOX, SHIP_TO_CITY, SHIP_TO_ZIP,
        SHIP_TO_COUNTRY, SHIP_TO_LZONE, SHIP_TO_STATE,
        SHIP_TO_TEL, SHIP_TO_TEL_EXT, SHIP_TO_MOB, SHIP_TO_FAX, SHIP_TO_EMAIL,
        CUST_PO_NO, PAY_METH, ORDR_CRET_USER, USE_IDX, INV_FILE_INFO,
        ORDR_CLS_DATE, EO_STS, EST_RETN_DATE, RETN_LOC, RETN_LOC_TYPE,
        PREV_ORDR_NO, ORDR_REG_DATE, ORDR_REV_DATE, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id,
        SUBSTR(p_ordr_no, 1, 2),
        p_ordr_no,
        DATE_FORMAT(NOW(), '%Y-%m-%d'),
        '100',
        NULL,
        p_from_deal_code,
        (SELECT DEAL_NAME FROM DEAL_MAST WHERE SYS_ID = p_sys_id AND DEAL_CODE = p_from_deal_code),
        p_from_ship_to,
        p_from_ship_to_name,
        p_from_ship_to_address1,
        p_from_ship_to_pobox,
        p_from_ship_to_city,
        p_from_ship_to_zip,
        p_from_ship_to_country,
        p_from_ship_to_lzone,
        p_from_ship_to_state,
        p_from_ship_to_tel,
        p_from_ship_to_telext,
        p_from_ship_to_mob,
        p_from_ship_to_fax,
        p_from_ship_to_email,
        p_cust_po_no,
        p_pay_meth,
        p_gs_user_id,
        'Y',
        p_inv_file_info,
        CASE WHEN p_ordr_cls_date IS NOT NULL AND p_ordr_cls_date != '' THEN FN_CONV_DATE(p_ordr_cls_date) ELSE NULL END,
        CASE WHEN p_ro_type = 'ER' THEN p_eo_sts ELSE NULL END,
        CASE WHEN p_ro_type = 'ER' THEN FN_CONV_DATE(p_est_retn_date) ELSE NULL END,
        CASE WHEN p_ro_type = 'ER' THEN p_retn_loc ELSE NULL END,
        CASE WHEN p_ro_type = 'ER' THEN p_retn_loc_type ELSE NULL END,
        p_retn_do_no,
        fn_get_regdate(p_sys_id, p_gs_user_id),
        fn_get_revdate(p_sys_id, p_gs_user_id),
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 16. [retnMastInsert] RETN_MAST 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_retn_mast_insert//
CREATE PROCEDURE sp_return_retn_mast_insert(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_ro_type VARCHAR(10),
    IN p_trsf_resn_rd VARCHAR(20),
    IN p_retn_do_no VARCHAR(50),
    IN p_retn_so_no VARCHAR(50),
    IN p_reference VARCHAR(100),
    IN p_retn_loc VARCHAR(50),
    IN p_retn_loc_type VARCHAR(10),
    IN p_retn_loc_addr VARCHAR(200),
    IN p_retn_loc_zip VARCHAR(20),
    IN p_retn_loc_city VARCHAR(100),
    IN p_retn_loc_lzone VARCHAR(50),
    IN p_retn_loc_cnty VARCHAR(50),
    IN p_est_retn_date VARCHAR(20),
    IN p_to_deal_code VARCHAR(20),
    IN p_to_ship_to_name VARCHAR(100),
    IN p_to_ship_to_address1 VARCHAR(200),
    IN p_to_ship_to_pobox VARCHAR(50),
    IN p_to_ship_to_zip VARCHAR(20),
    IN p_to_ship_to_country VARCHAR(50),
    IN p_to_ship_to_city VARCHAR(100),
    IN p_to_ship_to_lzone VARCHAR(50),
    IN p_to_ship_to_state VARCHAR(50),
    IN p_to_ship_to_tel VARCHAR(50),
    IN p_to_ship_to_telext VARCHAR(20),
    IN p_to_ship_to_mob VARCHAR(50),
    IN p_to_ship_to_fax VARCHAR(50),
    IN p_to_ship_to_email VARCHAR(100),
    IN p_retl_date VARCHAR(20),
    IN p_trsf_date VARCHAR(20),
    IN p_rd_dealer_appr VARCHAR(10),
    IN p_chk_wf VARCHAR(10),
    IN p_chk_deal VARCHAR(10),
    IN p_chk_ls VARCHAR(10),
    IN p_retn_resn VARCHAR(1000),
    IN p_trsf_resn VARCHAR(1000),
    IN p_ffr_no VARCHAR(50),
    IN p_swap_yn VARCHAR(10),
    IN p_trans_yn VARCHAR(10),
    IN p_grad_yn VARCHAR(10),
    IN p_inst_desc VARCHAR(1000),
    IN p_remk VARCHAR(1000),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO RETN_MAST (
        SYS_ID, RETN_TYPE, RETN_NO, RETN_DATE,
        RETN_TYPE_RD, RETN_TYPE_RS, RETN_DO_NO, RETN_SO_NO, RETN_REF_NO,
        RETN_LOC, RETN_LOC_TYPE, RETN_LOC_ADDR, RETN_LOC_ZIP, RETN_LOC_CITY, RETN_LOC_REGN, RETN_LOC_CNTY,
        EST_RETN_DATE,
        TO_DEAL_CODE, TO_DEAL_NAME, TO_DEAL_ADDRESS1, TO_DEAL_POBOX, TO_DEAL_ZIP, TO_DEAL_COUNTRY,
        TO_DEAL_CITY, TO_DEAL_LZONE, TO_DEAL_STATE, TO_DEAL_TEL, TO_DEAL_TEL_EXT, TO_DEAL_MOB, TO_DEAL_FAX, TO_DEAL_EMAIL,
        RETL_DATE, TRSF_DATE,
        APPRL_YN, CHK_WELL_FARGO, CHK_DEAL, CHK_LS,
        RETN_RESN, TRSF_RESN_RD, TRSF_RESN, FFR_NO,
        SWAP_YN, TRANS_YN, GRAD_YN, INST_DESC, REMK,
        USE_IDX, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id,
        SUBSTR(p_ordr_no, 1, 2),
        p_ordr_no,
        DATE_FORMAT(NOW(), '%Y-%m-%d'),
        p_ro_type,
        p_trsf_resn_rd,
        p_retn_do_no,
        p_retn_so_no,
        p_reference,
        p_retn_loc,
        p_retn_loc_type,
        p_retn_loc_addr,
        p_retn_loc_zip,
        p_retn_loc_city,
        p_retn_loc_lzone,
        p_retn_loc_cnty,
        FN_CONV_DATE(p_est_retn_date),
        p_to_deal_code,
        p_to_ship_to_name,
        p_to_ship_to_address1,
        p_to_ship_to_pobox,
        p_to_ship_to_zip,
        p_to_ship_to_country,
        p_to_ship_to_city,
        p_to_ship_to_lzone,
        p_to_ship_to_state,
        p_to_ship_to_tel,
        p_to_ship_to_telext,
        p_to_ship_to_mob,
        p_to_ship_to_fax,
        p_to_ship_to_email,
        CASE WHEN p_retl_date IS NOT NULL AND p_retl_date != '' THEN FN_CONV_DATE(fn_null_date_fr(p_retl_date)) ELSE NULL END,
        CASE WHEN p_trsf_date IS NOT NULL AND p_trsf_date != '' THEN FN_CONV_DATE(fn_null_date_fr(p_trsf_date)) ELSE NULL END,
        p_rd_dealer_appr,
        p_chk_wf,
        p_chk_deal,
        p_chk_ls,
        p_retn_resn,
        p_trsf_resn_rd,
        p_trsf_resn,
        p_ffr_no,
        p_swap_yn,
        p_trans_yn,
        p_grad_yn,
        p_inst_desc,
        p_remk,
        'Y',
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 17. [ordrItemInsert] ORDR_ITEM 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_ordr_item_insert//
CREATE PROCEDURE sp_return_ordr_item_insert(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_item_type VARCHAR(20),
    IN p_item_modl VARCHAR(50),
    IN p_item_code VARCHAR(50),
    IN p_item_name VARCHAR(200),
    IN p_seri_no VARCHAR(50),
    IN p_vin_no VARCHAR(50),
    IN p_gros_amt VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO ORDR_ITEM (
        SYS_ID, ORDR_TYPE, ORDR_NO, ORDR_SEQ,
        ITEM_TYPE, ITEM_MODL, ITEM_CODE, ITEM_NAME,
        SHIP_SERI_NO, VIN_NO, ITEM_QTY, ITEM_AMT, ITEM_PRCE,
        USE_IDX, UNUSE_DATE, SYS_REMK, REGI_DATE, REGI_ID
    ) VALUES (
        p_sys_id,
        SUBSTR(p_ordr_no, 1, 2),
        p_ordr_no,
        (SELECT IFNULL(MAX(OI.ORDR_SEQ), 0) + 10 FROM ORDR_ITEM OI WHERE ORDR_NO = p_ordr_no),
        p_item_type,
        p_item_modl,
        p_item_code,
        p_item_name,
        p_seri_no,
        p_vin_no,
        1,
        CASE WHEN p_gros_amt IS NOT NULL AND p_gros_amt != '' THEN REPLACE(p_gros_amt, ',', '') ELSE NULL END,
        CASE WHEN p_gros_amt IS NOT NULL AND p_gros_amt != '' THEN REPLACE(p_gros_amt, ',', '') ELSE NULL END,
        'Y',
        NULL,
        NULL,
        NOW(),
        p_gs_user_id
    );
END//

-- ============================================================
-- 18. [retnItemInsert] RETN_ITEM 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_retn_item_insert//
CREATE PROCEDURE sp_return_retn_item_insert(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_use_hour VARCHAR(20),
    IN p_cred_amt VARCHAR(50),
    IN p_re_bill_prce VARCHAR(50),
    IN p_term_ge_lst VARCHAR(50),
    IN p_flor_perd VARCHAR(50),
    IN p_retl_intv VARCHAR(50),
    IN p_acc_comt VARCHAR(500),
    IN p_not_acc_comt VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO RETN_ITEM (
        SYS_ID, RETN_TYPE, RETN_NO, RETN_SEQ,
        USE_HOUR, CRED_AMT, RE_BILL_PRCE,
        TERM_GE_LST, FLOR_PERD, RETL_INTV,
        ACC_COMT, NOT_ACC_COMT,
        USE_IDX, REGI_DATE, REGI_ID
    ) VALUES (
        p_sys_id,
        SUBSTR(p_ordr_no, 1, 2),
        p_ordr_no,
        (SELECT IFNULL(MAX(OI.RETN_SEQ), 0) + 10 FROM RETN_ITEM OI WHERE RETN_NO = p_ordr_no),
        p_use_hour,
        CASE WHEN p_cred_amt IS NOT NULL AND p_cred_amt != '' THEN p_cred_amt ELSE NULL END,
        CASE WHEN p_re_bill_prce IS NOT NULL AND p_re_bill_prce != '' THEN p_re_bill_prce ELSE NULL END,
        p_term_ge_lst,
        p_flor_perd,
        p_retl_intv,
        p_acc_comt,
        p_not_acc_comt,
        'Y',
        NOW(),
        p_gs_user_id
    );
END//

-- ============================================================
-- 19. [retnTransInsert] RETN_TRANS_ITEM 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_retn_trans_insert//
CREATE PROCEDURE sp_return_retn_trans_insert(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_item_modl VARCHAR(50),
    IN p_ship_seri_no VARCHAR(50),
    IN p_item_qty INT,
    IN p_hour VARCHAR(20),
    IN p_bef_info VARCHAR(200),
    IN p_aft_info VARCHAR(200),
    IN p_item_amt VARCHAR(50),
    IN p_sys_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO RETN_TRANS_ITEM (
        SYS_ID, RETN_NO, RETN_SEQ, ITEM_MODL, SHIP_SERI_NO,
        ITEM_QTY, HOUR, BEF_INFO, AFT_INFO, ITEM_AMT, SYS_REMK,
        USE_IDX, REGI_DATE, REGI_ID
    ) VALUES (
        p_sys_id,
        p_ordr_no,
        (SELECT IFNULL(MAX(OI.RETN_SEQ), 0) + 10 FROM RETN_TRANS_ITEM OI WHERE RETN_NO = p_ordr_no),
        p_item_modl,
        p_ship_seri_no,
        CASE WHEN p_item_qty IS NOT NULL THEN p_item_qty ELSE NULL END,
        CASE WHEN p_hour IS NOT NULL AND p_hour != '' THEN p_hour ELSE NULL END,
        p_bef_info,
        p_aft_info,
        CASE WHEN p_item_amt IS NOT NULL AND p_item_amt != '' THEN REPLACE(p_item_amt, ',', '') ELSE NULL END,
        p_sys_remk,
        'Y',
        NOW(),
        p_gs_user_id
    );
END//

-- ============================================================
-- 20. [retnSwapInsert] RETN_SWAP_ITEM 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_retn_swap_insert//
CREATE PROCEDURE sp_return_retn_swap_insert(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_item_modl VARCHAR(50),
    IN p_ship_seri_no VARCHAR(50),
    IN p_item_qty INT,
    IN p_old_seri_no VARCHAR(50),
    IN p_new_seri_no VARCHAR(50),
    IN p_sys_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO RETN_SWAP_ITEM (
        SYS_ID, RETN_NO, RETN_SEQ, ITEM_MODL, SHIP_SERI_NO,
        ITEM_QTY, OLD_SERI_NO, NEW_SERI_NO, SYS_REMK,
        USE_IDX, REGI_DATE, REGI_ID
    ) VALUES (
        p_sys_id,
        p_ordr_no,
        (SELECT IFNULL(MAX(OI.RETN_SEQ), 0) + 10 FROM RETN_SWAP_ITEM OI WHERE RETN_NO = p_ordr_no),
        p_item_modl,
        p_ship_seri_no,
        CASE WHEN p_item_qty IS NOT NULL THEN p_item_qty ELSE NULL END,
        p_old_seri_no,
        p_new_seri_no,
        p_sys_remk,
        'Y',
        NOW(),
        p_gs_user_id
    );
END//

-- ============================================================
-- 21. [ordrItemDelete] ORDR_ITEM 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_ordr_item_delete//
CREATE PROCEDURE sp_return_ordr_item_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM ORDR_ITEM
     WHERE SYS_ID = p_sys_id
       AND ORDR_TYPE = SUBSTR(p_ordr_no, 1, 2)
       AND ORDR_NO = p_ordr_no;
END//

-- ============================================================
-- 22. [retnItemDelete] RETN_ITEM 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_retn_item_delete//
CREATE PROCEDURE sp_return_retn_item_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_ITEM
     WHERE SYS_ID = p_sys_id
       AND RETN_TYPE = SUBSTR(p_ordr_no, 1, 2)
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 23. [ordrMastDelete] ORDR_MAST 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_ordr_mast_delete//
CREATE PROCEDURE sp_return_ordr_mast_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM ORDR_MAST
     WHERE SYS_ID = p_sys_id
       AND ORDR_TYPE = SUBSTR(p_ordr_no, 1, 2)
       AND ORDR_NO = p_ordr_no;
END//

-- ============================================================
-- 24. [retnMastDelete] RETN_MAST 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_retn_mast_delete//
CREATE PROCEDURE sp_return_retn_mast_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_MAST
     WHERE SYS_ID = p_sys_id
       AND RETN_TYPE = SUBSTR(p_ordr_no, 1, 2)
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 25. [retnSwapDelete] RETN_SWAP_ITEM 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_retn_swap_delete//
CREATE PROCEDURE sp_return_retn_swap_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_SWAP_ITEM
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 26. [retnTransDelete] RETN_TRANS_ITEM 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_retn_trans_delete//
CREATE PROCEDURE sp_return_retn_trans_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_TRANS_ITEM
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 27. [ordrInfoUpdate] ORDR_MAST 정보 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_ordr_info_update//
CREATE PROCEDURE sp_return_ordr_info_update(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50),
    IN p_from_deal_code VARCHAR(20),
    IN p_from_ship_to VARCHAR(50),
    IN p_from_ship_to_name VARCHAR(100),
    IN p_from_ship_to_address1 VARCHAR(200),
    IN p_from_ship_to_pobox VARCHAR(50),
    IN p_from_ship_to_city VARCHAR(100),
    IN p_from_ship_to_zip VARCHAR(20),
    IN p_from_ship_to_country VARCHAR(50),
    IN p_from_ship_to_lzone VARCHAR(50),
    IN p_from_ship_to_state VARCHAR(50),
    IN p_from_ship_to_tel VARCHAR(50),
    IN p_from_ship_to_telext VARCHAR(20),
    IN p_from_ship_to_mob VARCHAR(50),
    IN p_from_ship_to_fax VARCHAR(50),
    IN p_from_ship_to_email VARCHAR(100),
    IN p_cust_po_no VARCHAR(50),
    IN p_pay_meth VARCHAR(20),
    IN p_inv_file_info VARCHAR(200),
    IN p_ordr_cls_date VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE ORDR_MAST
       SET DEAL_CODE = p_from_deal_code
          ,DEAL_NAME = p_from_ship_to_name
          ,SHIP_TO = p_from_ship_to
          ,SHIP_LOC = NULL
          ,SHIP_TO_NAME = p_from_ship_to_name
          ,SHIP_TO_ADDRESS1 = p_from_ship_to_address1
          ,SHIP_TO_POBOX = p_from_ship_to_pobox
          ,SHIP_TO_CITY = p_from_ship_to_city
          ,SHIP_TO_ZIP = p_from_ship_to_zip
          ,SHIP_TO_COUNTRY = p_from_ship_to_country
          ,SHIP_TO_LZONE = p_from_ship_to_lzone
          ,SHIP_TO_STATE = p_from_ship_to_state
          ,SHIP_TO_TEL = p_from_ship_to_tel
          ,SHIP_TO_TEL_EXT = p_from_ship_to_telext
          ,SHIP_TO_MOB = p_from_ship_to_mob
          ,SHIP_TO_FAX = p_from_ship_to_fax
          ,SHIP_TO_EMAIL = p_from_ship_to_email
          ,CUST_PO_NO = p_cust_po_no
          ,PAY_METH = p_pay_meth
          ,ORDR_ABBR = fn_get_ordr_abbr(p_ordr_no)
          ,INV_FILE_INFO = p_inv_file_info
          ,ORDR_CLS_DATE = CASE WHEN p_ordr_cls_date IS NOT NULL AND p_ordr_cls_date != '' THEN FN_CONV_DATE(fn_null_date_fr(p_ordr_cls_date)) ELSE ORDR_CLS_DATE END
          ,CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
     WHERE ORDR_NO = p_ordr_no;
END//

-- ============================================================
-- 28. [retnMastUpdate] RETN_MAST 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_retn_mast_update//
CREATE PROCEDURE sp_return_retn_mast_update(
    IN p_ordr_no VARCHAR(50),
    IN p_retn_do_no VARCHAR(50),
    IN p_retn_so_no VARCHAR(50),
    IN p_reference VARCHAR(100),
    IN p_to_deal_code VARCHAR(20),
    IN p_to_ship_to_name VARCHAR(100),
    IN p_to_ship_to_address1 VARCHAR(200),
    IN p_to_ship_to_pobox VARCHAR(50),
    IN p_to_ship_to_zip VARCHAR(20),
    IN p_to_ship_to_country VARCHAR(50),
    IN p_to_ship_to_city VARCHAR(100),
    IN p_to_ship_to_lzone VARCHAR(50),
    IN p_to_ship_to_state VARCHAR(50),
    IN p_to_ship_to_tel VARCHAR(50),
    IN p_to_ship_to_telext VARCHAR(20),
    IN p_to_ship_to_mob VARCHAR(50),
    IN p_to_ship_to_fax VARCHAR(50),
    IN p_to_ship_to_email VARCHAR(100),
    IN p_retl_date VARCHAR(20),
    IN p_trsf_date VARCHAR(20),
    IN p_rd_dealer_appr VARCHAR(10),
    IN p_chk_wf VARCHAR(10),
    IN p_chk_deal VARCHAR(10),
    IN p_chk_ls VARCHAR(10),
    IN p_retn_resn VARCHAR(1000),
    IN p_trsf_resn_rd VARCHAR(20),
    IN p_trsf_resn VARCHAR(1000),
    IN p_swap_yn VARCHAR(10),
    IN p_trans_yn VARCHAR(10),
    IN p_grad_yn VARCHAR(10),
    IN p_ffr_no VARCHAR(50),
    IN p_inst_desc VARCHAR(1000),
    IN p_remk VARCHAR(1000),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE RETN_MAST
       SET RETN_DO_NO = p_retn_do_no
          ,RETN_SO_NO = p_retn_so_no
          ,RETN_REF_NO = p_reference
          ,TO_DEAL_CODE = p_to_deal_code
          ,TO_DEAL_NAME = p_to_ship_to_name
          ,TO_DEAL_ADDRESS1 = p_to_ship_to_address1
          ,TO_DEAL_POBOX = p_to_ship_to_pobox
          ,TO_DEAL_ZIP = p_to_ship_to_zip
          ,TO_DEAL_COUNTRY = p_to_ship_to_country
          ,TO_DEAL_CITY = p_to_ship_to_city
          ,TO_DEAL_LZONE = p_to_ship_to_lzone
          ,TO_DEAL_STATE = p_to_ship_to_state
          ,TO_DEAL_TEL = p_to_ship_to_tel
          ,TO_DEAL_TEL_EXT = p_to_ship_to_telext
          ,TO_DEAL_MOB = p_to_ship_to_mob
          ,TO_DEAL_FAX = p_to_ship_to_fax
          ,TO_DEAL_EMAIL = p_to_ship_to_email
          ,RETL_DATE = CASE WHEN p_retl_date IS NOT NULL AND p_retl_date != '' THEN FN_CONV_DATE(fn_null_date_fr(p_retl_date)) ELSE RETL_DATE END
          ,TRSF_DATE = CASE WHEN p_trsf_date IS NOT NULL AND p_trsf_date != '' THEN FN_CONV_DATE(fn_null_date_fr(p_trsf_date)) ELSE TRSF_DATE END
          ,APPRL_YN = p_rd_dealer_appr
          ,CHK_WELL_FARGO = p_chk_wf
          ,CHK_DEAL = p_chk_deal
          ,CHK_LS = p_chk_ls
          ,RETN_RESN = p_retn_resn
          ,TRSF_RESN_RD = p_trsf_resn_rd
          ,TRSF_RESN = p_trsf_resn
          ,SWAP_YN = p_swap_yn
          ,TRANS_YN = p_trans_yn
          ,GRAD_YN = p_grad_yn
          ,FFR_NO = p_ffr_no
          ,INST_DESC = p_inst_desc
          ,REMK = p_remk
          ,CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
     WHERE RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 29. [ordrMastUpdateOrg] ORDR_MAST 원본 기반 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_ordr_mast_update_org//
CREATE PROCEDURE sp_return_ordr_mast_update_org(
    IN p_ordr_no VARCHAR(50),
    IN p_retn_do_no VARCHAR(50)
)
BEGIN
    UPDATE ORDR_MAST A, ORDR_MAST B
       SET A.GROS_AMT = (SELECT SUM(OI.ITEM_AMT) FROM ORDR_ITEM OI WHERE ORDR_NO = p_ordr_no)
          ,A.ORDR_AMT = (SELECT SUM(OI.ITEM_AMT) FROM ORDR_ITEM OI WHERE ORDR_NO = p_ordr_no)
          ,A.DISC_AMT = 0
          ,A.PAY_CURR = B.PAY_CURR
          ,A.PAY_TO = B.PAY_TO
          ,A.SALE_GRUP = B.SALE_GRUP
          ,A.SHIP_LOC = B.SHIP_LOC
          ,A.NATN_CODE = B.NATN_CODE
          ,A.AREA_CODE = B.AREA_CODE
          ,A.PLANT_PICKUP = B.PLANT_PICKUP
          ,A.LS_SHIP_YN = B.LS_SHIP_YN
          ,A.RETAIL_YN = B.RETAIL_YN
          ,A.LTL_YN = B.LTL_YN
          ,A.FULL_LOAD = B.FULL_LOAD
          ,A.DROP_SHIP = B.DROP_SHIP
          ,A.DEAL_CRET_IDX = B.DEAL_CRET_IDX
          ,A.CONF_MAIL_IDX = B.CONF_MAIL_IDX
          ,A.DELI_ADDR = B.DELI_ADDR
          ,A.ORDR_ABBR = fn_get_ordr_abbr(p_ordr_no)
     WHERE A.ORDR_NO = p_ordr_no
       AND B.ORDR_NO = p_retn_do_no;
END//

-- ============================================================
-- 30. [ordrMastUpdateOrgHist] ORDR_MAST 이력 기반 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_ordr_mast_update_org_hist//
CREATE PROCEDURE sp_return_ordr_mast_update_org_hist(
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    UPDATE ORDR_MAST A
       SET A.ORDR_ABBR = fn_get_ordr_abbr(p_ordr_no)
          ,A.GROS_AMT = (SELECT SUM(OI.ITEM_AMT) FROM ORDR_ITEM OI WHERE ORDR_NO = p_ordr_no)
          ,A.ORDR_AMT = (SELECT SUM(OI.ITEM_AMT) FROM ORDR_ITEM OI WHERE ORDR_NO = p_ordr_no)
          ,A.DISC_AMT = 0
     WHERE A.ORDR_NO = p_ordr_no;
END//

-- ============================================================
-- 31. [ordrMastUpdateNotOrg] ORDR_MAST 원본 없이 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_ordr_mast_update_not_org//
CREATE PROCEDURE sp_return_ordr_mast_update_not_org(
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    UPDATE ORDR_MAST
       SET ORDR_AMT = NULL
          ,DISC_AMT = NULL
          ,PAY_CURR = NULL
          ,PAY_TO = NULL
          ,SALE_GRUP = NULL
          ,SHIP_LOC = NULL
          ,NATN_CODE = NULL
          ,AREA_CODE = NULL
          ,PLANT_PICKUP = NULL
          ,LS_SHIP_YN = NULL
          ,RETAIL_YN = NULL
          ,LTL_YN = NULL
          ,FULL_LOAD = NULL
          ,DROP_SHIP = NULL
          ,DEAL_CRET_IDX = NULL
          ,CONF_MAIL_IDX = NULL
          ,DELI_ADDR = NULL
     WHERE ORDR_NO = p_ordr_no;
END//

DELIMITER ;
