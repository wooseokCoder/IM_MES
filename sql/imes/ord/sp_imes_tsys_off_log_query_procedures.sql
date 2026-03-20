-- ============================================================
-- 프로시저명: sp_imes_tsys_off_log_query1
-- 설명: 퇴근 로그 조회 (TSYS_OFF_LOG)
--       ORD15A 실적/비가동 현황에서 퇴근 행 추가용
-- 작성자: 송우석
-- 작성일: 2026-03-16
-- ============================================================
DELIMITER //
DROP PROCEDURE IF EXISTS sp_imes_tsys_off_log_query1//
CREATE PROCEDURE sp_imes_tsys_off_log_query1(
    IN p_plt_code   VARCHAR(3),
    IN p_s_date     VARCHAR(8),
    IN p_e_date     VARCHAR(8)
)
BEGIN
    SELECT
        PLT_CODE    AS pltCode,
        OFF_DATE    AS offDate,
        EMP_CODE    AS empCode,
        DATE_FORMAT(MAX(REG_DATE), '%Y-%m-%d %H:%i:%s') AS regDate
    FROM TSYS_OFF_LOG
    WHERE PLT_CODE = p_plt_code
      AND OFF_DATE BETWEEN p_s_date AND p_e_date
    GROUP BY PLT_CODE, OFF_DATE, EMP_CODE;
END//
DELIMITER ;
