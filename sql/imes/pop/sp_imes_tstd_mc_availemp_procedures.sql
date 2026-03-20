-- ============================================================
-- TSTD_MC_AVAILEMP 설비 가용 작업자 조회 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 대상 테이블: TSTD_MC_AVAILEMP
-- 원본: ProActive TPOP_MC_AVAILEMP.cs (AS-IS DA명과 실제 테이블명 상이)
-- 화면: POP30B (단말기 - 가공)
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_mc_availemp_ser2: 설비별 가용 작업자 조회
-- 원본: TPOP_MC_AVAILEMP.TPOP_MC_AVAILEMP_SER2()
-- 실제 테이블: TSTD_MC_AVAILEMP (TO-BE DB)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_availemp_ser2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_mc_availemp_ser2(
    IN p_plt_code  VARCHAR(10),
    IN p_mc_code   VARCHAR(20)
)
BEGIN
    SELECT
        A.PLT_CODE     AS "pltCode"
       ,A.MC_CODE      AS "mcCode"
       ,A.EMP_CODE     AS "empCode"
       ,U.USER_NAME    AS "empName"
    FROM TSTD_MC_AVAILEMP A
    LEFT JOIN sys_user U ON U.SYS_ID = 'IMMES' AND U.PLT_CODE = A.PLT_CODE AND U.USER_ID = A.EMP_CODE
    WHERE A.PLT_CODE  = p_plt_code
      AND A.MC_CODE   = p_mc_code
      AND U.USE_FLAG  = 'Y';
END//

DELIMITER ;
