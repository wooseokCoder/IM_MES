-- ============================================================
-- TSYS_SERIAL 테이블 및 시리얼 채번 공통 프로시저
-- 생성일: 2026-02-05
-- 원본: ProActive UTIL.cs - SetSerialNo, UTILITY_GET_SERIALNO
-- ============================================================
-- TSYS_SERIAL: 각종 코드/번호의 시퀀스 관리 테이블
-- - PLT_CODE: 공장코드
-- - SR_CODE: 시리얼 타입 (예: S=SCODE, O=주문번호 등)
-- - SR_KEY: 시리얼 키 (보통 날짜 YYMMDD)
-- - SR_NO: 현재 순번
-- ============================================================

-- ============================================================
-- 2. sp_imes_utility_get_serialno: 시리얼 번호 채번
-- 원본: UTIL.SetSerialNo() + UTILITY_GET_SERIALNO()
-- 용도: 공통 시리얼 번호 생성 (S260205-0001 형식)
--
-- 파라미터:
--   p_plt_code: 공장코드
--   p_sr_code: 시리얼 타입 (예: S, O, M 등)
--   p_sr_key: 시리얼 키 (보통 YYMMDD, 직접 지정 가능)
--   p_sep: 순번 자릿수 (기본 4)
--
-- 반환: sr_code + sr_key + '-' + 순번
--   예: S260205-0001
-- ============================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_imes_utility_get_serialno//

CREATE PROCEDURE sp_imes_utility_get_serialno(
    IN p_plt_code VARCHAR(10),
    IN p_sr_code VARCHAR(20),
    IN p_sr_key VARCHAR(20),
    IN p_sep INT
)
BEGIN
    DECLARE v_sr_no INT DEFAULT 0;
    DECLARE v_exists INT DEFAULT 0;
    DECLARE v_result VARCHAR(50);

    -- 기본값 설정
    IF p_sep IS NULL OR p_sep < 1 THEN
        SET p_sep = 4;
    END IF;

    -- sr_key가 NULL이면 현재 날짜 YYMMDD 사용
    IF p_sr_key IS NULL OR p_sr_key = '' THEN
        SET p_sr_key = DATE_FORMAT(NOW(), '%y%m%d');
    END IF;

    -- 기존 레코드 존재 여부 확인
    SELECT COUNT(*), IFNULL(MAX(SR_NO), 0)
    INTO v_exists, v_sr_no
    FROM TSYS_SERIAL
    WHERE PLT_CODE = p_plt_code
      AND SR_CODE = p_sr_code
      AND SR_KEY = p_sr_key;

    -- 순번 증가
    SET v_sr_no = v_sr_no + 1;

    IF v_exists > 0 THEN
        -- 기존 레코드가 있으면 UPDATE
        UPDATE TSYS_SERIAL
        SET SR_NO = v_sr_no
        WHERE PLT_CODE = p_plt_code
          AND SR_CODE = p_sr_code
          AND SR_KEY = p_sr_key;
    ELSE
        -- 없으면 INSERT
        INSERT INTO TSYS_SERIAL (PLT_CODE, SR_CODE, SR_KEY, SR_NO)
        VALUES (p_plt_code, p_sr_code, p_sr_key, v_sr_no);
    END IF;

    -- 결과 생성: sr_code + sr_key + '-' + 순번(sep 자리)
    -- 예: S + 260205 + - + 0001 = S260205-0001
    SET v_result = CONCAT(p_sr_code, p_sr_key, '-', LPAD(v_sr_no, p_sep, '0'));

    SELECT v_result AS serialNo;
END//

-- ============================================================
-- 3. sp_imes_utility_get_serialno_yymmdd: 날짜 기반 시리얼 채번
-- 원본: UTIL.UTILITY_GET_SERIALNO(plt_code, sr_code, bizExecute)
-- 용도: 현재 날짜(YYMMDD) 기준 시리얼 생성
--
-- 사용 예: CALL sp_imes_utility_get_serialno_yymmdd('1000', 'S')
-- 반환: S260205-0001
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_utility_get_serialno_yymmdd//

CREATE PROCEDURE sp_imes_utility_get_serialno_yymmdd(
    IN p_plt_code VARCHAR(10),
    IN p_sr_code VARCHAR(20)
)
BEGIN
    DECLARE v_sr_key VARCHAR(20);

    -- 현재 날짜 YYMMDD
    SET v_sr_key = DATE_FORMAT(NOW(), '%y%m%d');

    -- 공통 시리얼 채번 호출 (4자리)
    CALL sp_imes_utility_get_serialno(p_plt_code, p_sr_code, v_sr_key, 4);
END//

DELIMITER ;

-- ============================================================
-- 실행 안내
-- ============================================================
-- 1. 먼저 이 스크립트 실행 (테이블 + 프로시저 생성)
-- 2. 테스트: CALL sp_imes_utility_get_serialno_yymmdd('1000', 'S');
--    결과: S260205-0001, S260205-0002, ...
-- ============================================================
