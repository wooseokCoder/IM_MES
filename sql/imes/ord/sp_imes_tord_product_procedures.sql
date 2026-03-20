-- ============================================================
-- TORD_PRODUCT 프로시저
-- 생성일: 2026-02-24
-- 대상 테이블: TORD_PRODUCT
-- 원본: ProActive TORD_PRODUCT.cs
-- ============================================================
-- 명명 규칙: sp_imes_tord_product_[액션]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tord_product_upd3: 제품 상태(PROD_STATE) 업데이트
-- 원본: TORD_PRODUCT.TORD_PRODUCT_UPD3()
-- 용도: 확정 시 PROD_STATE='PG', 확정취소 시 PROD_STATE='WK'
-- 사용화면: ORD06A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_product_upd3//

CREATE PROCEDURE sp_imes_tord_product_upd3(
    IN p_plt_code    VARCHAR(3),
    IN p_prod_code   VARCHAR(50),
    IN p_prod_state  VARCHAR(5),
    IN p_mdfy_emp    VARCHAR(20)
)
BEGIN
    UPDATE TORD_PRODUCT
       SET PROD_STATE = p_prod_state,
           MDFY_DATE  = NOW(),
           MDFY_EMP   = p_mdfy_emp
     WHERE PLT_CODE  = p_plt_code
       AND PROD_CODE = p_prod_code;
END//

DELIMITER ;
