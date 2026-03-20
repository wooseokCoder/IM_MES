-- ============================================================
-- Notification.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- 수정일: 2026-01-14 (sp_select_user_noti 추가)
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 사용자 알림 목록 조회 (selectBordList)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_select_user_noti//

CREATE PROCEDURE sp_select_user_noti(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.BORD_GRUP     AS bordGrup,
        A.BORD_NO       AS bordNo,
        A.BORD_TITLE    AS bordTitle,
        A.BORD_TYPE     AS bordType,
        A.BORD_TEXT     AS bordText,
        A.OPEN_CLS      AS openCls,
        A.LINK_URL      AS linkUrl,
        B.TGT_USER_ID   AS tgtUserId,
        B.READ_DATE     AS readDate,
        B.REGI_DATE     AS regiDate,
        DATE_FORMAT(STR_TO_DATE(B.REGI_DATE, '%Y-%m-%d %H:%i:%s'), '%b %e, %Y, %l:%i %p') AS fmtDate
    FROM
        SYS_BORD A
    INNER JOIN SYS_BORD_TGT B
        ON A.SYS_ID = B.SYS_ID
        AND A.BORD_GRUP = B.BORD_GRUP
        AND A.BORD_NO = B.BORD_NO
    WHERE
        A.SYS_ID = p_sys_id
        AND A.BORD_GRUP = p_bord_grup
        AND A.BORD_NO = 'B000000001'
        AND B.READ_DATE IS NULL
        AND B.TGT_USER_ID = p_gs_user_id
        AND STR_TO_DATE(B.REGI_DATE, '%Y-%m-%d %H:%i:%s') >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
    ORDER BY
        B.REGI_DATE DESC;
END//

-- ============================================================
-- 2. 알림 읽음 처리 (updateNotiRead)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_notification_update_read//

CREATE PROCEDURE sp_board_notification_update_read(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT
    SET READ_DATE = DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')
    WHERE SYS_ID = p_sys_id
      AND BORD_GRUP = p_bord_grup
      AND (p_bord_no IS NULL OR p_bord_no = '' OR BORD_NO = p_bord_no)
      AND TGT_USER_ID = p_gs_user_id;
END//

DELIMITER ;
