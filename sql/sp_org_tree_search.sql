-- ============================================================
-- sp_org_tree_search: 조직 계층형 목록 조회
-- TreeGrid용 데이터 반환 (_parentId 필드 포함)
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS sp_org_tree_search //

CREATE PROCEDURE sp_org_tree_search(
    IN p_sys_id VARCHAR(20),
    IN p_plt_code VARCHAR(3),
    IN p_org_code VARCHAR(20),
    IN p_org_name VARCHAR(100)
)
BEGIN
    SELECT
        O.ORG_CODE AS id,
        O.ORG_CODE AS orgCode,
        O.ORG_NAME AS orgName,
        CASE
            WHEN O.ORG_PARENT IS NULL OR O.ORG_PARENT = '' THEN NULL
            ELSE O.ORG_PARENT
        END AS _parentId,
        O.ORG_PARENT AS orgParent,
        O.PLT_CODE AS pltCode,
        -- 하위 조직 존재 여부 (펼침 아이콘 표시용)
        CASE
            WHEN EXISTS (SELECT 1 FROM TSTD_ORG C WHERE C.ORG_PARENT = O.ORG_CODE AND C.PLT_CODE = O.PLT_CODE)
            THEN 'closed'
            ELSE 'open'
        END AS state
    FROM TSTD_ORG O
    WHERE O.PLT_CODE = IFNULL(p_plt_code, '100')
      AND (O.DATA_FLAG = 0 OR O.DATA_FLAG IS NULL)
      AND (p_org_code IS NULL OR p_org_code = '' OR O.ORG_CODE LIKE CONCAT('%', p_org_code, '%'))
      AND (p_org_name IS NULL OR p_org_name = '' OR O.ORG_NAME LIKE CONCAT('%', p_org_name, '%'))
    ORDER BY O.ORG_PARENT, O.ORG_CODE;
END //

DELIMITER ;
