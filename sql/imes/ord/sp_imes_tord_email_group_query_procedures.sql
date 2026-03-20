-- ============================================================================
-- TORD_EMAIL_GROUP QUERY 프로시저 (1개)
-- 이메일 수신자그룹 목록 조회
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-10
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tord_email_group_query1
-- 수신자그룹 목록 조회 (좌측 그리드)
-- 조건: GROUP_TYPE, DATA_FLAG 필터
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_query1//

CREATE PROCEDURE sp_imes_tord_email_group_query1(
    IN p_plt_code    VARCHAR(3),
    IN p_data_flag   INT,
    IN p_group_type  VARCHAR(5),
    IN p_mcode       VARCHAR(20),
    IN p_group_like  VARCHAR(50)
)
BEGIN
    SELECT
        A.PLT_CODE        AS pltCode,
        A.MCODE           AS mcode,
        A.GROUP_NAME      AS groupName,
        A.GROUP_TYPE      AS groupType,
        A.USE_FLAG        AS useFlag,
        A.SCOMMENT        AS scomment,
        DATE_FORMAT(A.REG_DATE, '%Y-%m-%d %H:%i:%s')  AS regDate,
        A.REG_EMP         AS regEmp,
        DATE_FORMAT(A.MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        A.MDFY_EMP        AS mdfyEmp
    FROM TORD_EMAIL_GROUP A
    WHERE A.PLT_CODE = p_plt_code
      AND (p_data_flag IS NULL OR A.DATA_FLAG = p_data_flag)
      AND (p_group_type IS NULL OR p_group_type = '' OR A.GROUP_TYPE = p_group_type)
      AND (p_mcode IS NULL OR p_mcode = '' OR A.MCODE = p_mcode)
      AND (p_group_like IS NULL OR p_group_like = '' OR A.GROUP_NAME LIKE CONCAT('%', p_group_like, '%'))
    ORDER BY A.MCODE;
END//

DELIMITER ;
