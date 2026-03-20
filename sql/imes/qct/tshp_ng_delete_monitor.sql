-- ============================================================
-- TSHP_NG 데이터 삭제 감시 (DELETE 추적용)
-- 작성자: 송우석
-- 작성일: 2026-03-20
-- ============================================================
--
-- [배경]
-- TSHP_NG 테이블에 AS-IS 데이터를 DBeaver 데이터 내보내기로
-- 로컬 DB에 2회 투입했으나, 투입 후 데이터가 사라지는 현상 발생.
-- 웹 화면(Tomcat)에서 데이터 확인까지 했으므로 COMMIT은 완료된 상태.
-- 그러나 이후 COUNT(*) = 0, DATA_FREE = 3GB (삭제/롤백 흔적).
--
-- [조사 결과]
-- 1. TSHP_NG에 대한 트리거: 없음
-- 2. TSHP_NG를 DELETE/TRUNCATE하는 프로시저: 없음
-- 3. TSHP_NG를 참조하는 이벤트 직접 삭제: 없음
-- 4. sp_imes_qms_insp_if (10분마다 실행): UPDATE만 수행 (IF_FLAG 변경)
-- 5. GLOBAL autocommit=1 (정상), SESSION autocommit=0 (클라이언트가 끔)
-- 6. innodb_buffer_pool_size=128MB (3GB LONGBLOB 테이블에 부족)
-- 7. 로컬 DB에 4개 호스트 접속 중:
--    - DESKTOP-0N7K2NH (로컬), DESKTOP-84H2ERV, DESKTOP-2J6R413, 172.30.1.33 (개발서버)
--
-- [결론]
-- 커밋된 데이터가 사라졌으므로, 외부 세션에서 DELETE한 것으로 추정.
-- 아래 트리거로 DELETE 발생 시 범인(호스트/사용자/시각/대상행)을 기록한다.
--
-- ============================================================


-- ============================================================
-- 1. 감시 로그 테이블 생성
-- ============================================================
CREATE TABLE IF NOT EXISTS TSHP_NG_DELETE_LOG (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    DELETED_PLT_CODE VARCHAR(3)   COMMENT '삭제된 행의 PLT_CODE',
    DELETED_NG_ID   VARCHAR(20)  COMMENT '삭제된 행의 NG_ID',
    DELETED_BY      VARCHAR(100) COMMENT '삭제 실행 사용자 (USER@HOST)',
    DELETED_AT      DATETIME DEFAULT NOW() COMMENT '삭제 시각'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='TSHP_NG DELETE 감시 로그 (임시)';


-- ============================================================
-- 2. DELETE 감시 트리거 생성
-- ============================================================
DELIMITER //
DROP TRIGGER IF EXISTS trg_tshp_ng_delete_log//
CREATE TRIGGER trg_tshp_ng_delete_log
BEFORE DELETE ON TSHP_NG
FOR EACH ROW
BEGIN
    INSERT INTO TSHP_NG_DELETE_LOG (DELETED_PLT_CODE, DELETED_NG_ID, DELETED_BY)
    VALUES (OLD.PLT_CODE, OLD.NG_ID, CURRENT_USER());
END//
DELIMITER ;


-- ============================================================
-- 3. 사용법
-- ============================================================
-- (1) 위 SQL을 DBeaver에서 실행 (테이블 + 트리거 생성)
-- (2) TSHP_NG에 데이터 다시 투입
-- (3) 데이터가 사라지면 아래 조회:
--
--     SELECT * FROM TSHP_NG_DELETE_LOG ORDER BY DELETED_AT DESC;
--
--     → DELETED_BY 컬럼에서 어떤 사용자/호스트가 삭제했는지 확인
--     → DELETED_AT 컬럼에서 삭제 시각 확인
--     → DELETED_NG_ID로 어떤 행이 삭제되었는지 확인


-- ============================================================
-- 4. 정리 (감시 완료 후 실행)
-- ============================================================
-- DROP TRIGGER IF EXISTS trg_tshp_ng_delete_log;
-- DROP TABLE IF EXISTS TSHP_NG_DELETE_LOG;
