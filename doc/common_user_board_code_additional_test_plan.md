# common/user, board, code 추가 XML 테스트 계획서

## 개요
이 문서는 `common/user`, `common/board`, `common/code` 폴더의 추가 XML 파일에 대한 테스트 계획서입니다.
기존 테스트 계획서(common_user_test_plan.md, common_board_test_plan.md, common_code_test_plan.md)에 포함되지 않은 추가 XML 파일들입니다.

**작성일**: 2025-01-15

---

# User 추가 모듈

## 1. 배치 작업 수정 (BatchWorkRevise)

### XML 파일
- `src/main/resources/mappers/com/wsc/common/user/BatchWorkRevise.xml`

### 화면 URL
- `/common/user/batchworkrevise/list.do`
- `/common/user/batchworkrevise/form.do`

### 화면 기능
시스템 배치 작업 관리 (SYS_JOB_MAST)

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 작업 목록 그리드 | 배치 작업 목록 |
| 검색 필터 | 작업ID, 작업그룹, 작업주기 검색 |
| 등록/수정 폼 | 배치 작업 정보 입력 |

### 호출 API
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 배치 작업 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 배치 작업 카운트 |
| /insert.do | BatchWorkReviseinsertJob | 인라인 SQL | 배치 작업 등록 |
| /update.do | BatchWorkReviseupdateJob | 인라인 SQL | 배치 작업 수정 |

### 테스트 항목
- [ ] 배치 작업 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 작업ID(jobId) 검색
  - [ ] 작업그룹(jobGrup) 필터링
  - [ ] 작업주기(jobTerm) 필터링
- [ ] 배치 작업 등록
  - [ ] 작업ID 자동 생성 (SYS-JOB-XXXX)
  - [ ] 작업그룹 선택
  - [ ] 작업유형(jobType) 설정
  - [ ] 작업주기(jobTerm) 설정
  - [ ] 실행시간(jobTime) 설정
  - [ ] 실행명령(jobCmd) 입력
  - [ ] 오류처리(errProc) 설정
  - [ ] 담당자(jobMng) 지정
- [ ] 배치 작업 수정

---

## 2. 이메일 설정 (EmailInsert)

### XML 파일
- `src/main/resources/mappers/com/wsc/common/user/EmailInsert.xml`

### 화면 URL
- `/common/user/email/setting.do`

### 화면 기능
사용자 SMTP 이메일 설정

### 호출 API
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /update.do | EmailInsert | 인라인 SQL | 이메일 설정 저장 |
| /select.do | gsSmtpMail | 인라인 SQL | SMTP 메일 조회 |

### 테스트 항목
- [ ] 이메일 설정 저장
  - [ ] SMTP 메일 주소 저장 (SMTP_MAIL)
  - [ ] SMTP 비밀번호 저장 (SMTP_PW)
- [ ] SMTP 메일 조회
  - [ ] 도메인 제외한 사용자명만 반환

---

## 3. 엑셀 정보 관리 (ExcelInfo)

### XML 파일
- `src/main/resources/mappers/com/wsc/common/user/ExcelInfo.xml`

### 화면 URL
- `/common/user/excelinfo/list.do`
- `/common/user/excelinfo/form.do`

### 화면 기능
엑셀 다운로드 컬럼 설정 관리

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 엑셀 정보 목록 그리드 | 컬럼 설정 목록 |
| 엑셀 그룹 선택 | 파일명별 그룹 선택 |
| 등록/수정 폼 | 컬럼 정보 입력 |

### 호출 API
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /getSelectExcelGroup.do | getSelectExcelGroup | 인라인 SQL | 엑셀 그룹 목록 조회 |
| /search.do | search | 인라인 SQL | 엑셀 정보 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 엑셀 정보 카운트 |
| /select.do | select | 인라인 SQL | 엑셀 정보 단건 조회 |
| /insert.do | insert | 인라인 SQL | 엑셀 정보 등록 |
| /update.do | update | 인라인 SQL | 엑셀 정보 수정 |
| /delete.do | delete | 인라인 SQL | 엑셀 정보 삭제 |

### 테스트 항목
- [ ] 엑셀 그룹 조회
  - [ ] 파일명별 그룹 목록 표시
- [ ] 엑셀 정보 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 파일명(s_fileNm) 필터링
- [ ] 엑셀 정보 등록
  - [ ] 순번 자동 생성 (MAX + 1)
  - [ ] 파일명(fileNm) 입력
  - [ ] 뷰 순서(viewNo) 설정
  - [ ] 컬럼 레벨(colLvl) 설정
  - [ ] 컬럼 값(colVal) 입력
  - [ ] 스타일/정렬(align) 설정
- [ ] 엑셀 정보 수정/삭제

---

## 4. 개인 엑셀 정보 (PersonalExcelInfo)

### XML 파일
- `src/main/resources/mappers/com/wsc/common/user/PersonalExcelInfo.xml`

### 화면 URL
- `/common/user/personalexcelinfo/list.do`
- `/common/user/personalexcelinfo/form.do`

### 화면 기능
사용자별 개인화된 엑셀 다운로드 컬럼 설정

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /getSelectPersonalExcelGroup.do | getSelectPersonalExcelGroup | sp_get_select_personal_excel_group | 개인 엑셀 그룹 조회 |
| /search.do | search | sp_search_personal_excel_info | 개인 엑셀 정보 조회 (페이징) |
| /searchCount.do | searchCount | sp_search_personal_excel_info_count | 개인 엑셀 정보 카운트 |
| /select.do | select | sp_select_personal_excel_info | 개인 엑셀 정보 단건 조회 |
| /insert.do | insert | sp_insert_personal_excel_info | 개인 엑셀 정보 등록 |
| /update.do | update | sp_update_personal_excel_info | 개인 엑셀 정보 수정 |
| /delete.do | delete | sp_delete_personal_excel_info | 개인 엑셀 정보 삭제 |

### 테스트 항목
- [ ] 개인 엑셀 그룹 조회
- [ ] 개인 엑셀 정보 목록 조회
  - [ ] 화면ID(windId) 필터링
- [ ] 개인 엑셀 정보 등록
  - [ ] 화면ID, 컬럼ID 설정
  - [ ] 뷰 순서, 유형 설정
  - [ ] 엑셀 컬럼ID(exceColId) 매핑
  - [ ] 스타일, 다운로드 여부 설정
  - [ ] 병합 코드(mergCode) 설정
- [ ] 개인 엑셀 정보 수정/삭제

---

## 5. SAP 인터페이스 (SapInterface)

### XML 파일
- `src/main/resources/mappers/com/wsc/common/user/SapInterface.xml`

### 화면 기능
SAP 시스템 연동 (쿼리 미구현)

### 테스트 항목
- [ ] SAP 연동 기능 (별도 구현 필요)

---

## 6. 사용자 로그 목록 (UserLogList)

### XML 파일
- `src/main/resources/mappers/com/wsc/common/user/UserLogList.xml`

### 화면 URL
- `/common/user/userloglist/list.do`

### 화면 기능
사용자 접속 로그 상세 조회

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 로그 목록 그리드 | 접속 로그 상세 목록 |
| 검색 필터 | 사용자ID, 프로그램, 기간, 사용자유형 검색 |
| 사용자 유형 필터 | LSTA/Dealer 구분 |

### 호출 API
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 로그 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 로그 카운트 |
| /insert.do | insert | sp_insert_sys_ulog | 로그 등록 |
| /delete.do | delete | 인라인 SQL | 로그 삭제 |
| /getUserType1.do | getUserType1 | 인라인 SQL | 사용자 유형 조회 |

### 테스트 항목
- [ ] 로그 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 사용자ID 검색 (부분 일치)
  - [ ] 프로그램ID 검색
  - [ ] 기간 검색 (accTimeBgn ~ accTimeEnd)
  - [ ] 사용자유형 필터 (LSTA, DEALER)
  - [ ] 기본값: 당일 로그만 조회
- [ ] 로그 등록
- [ ] 로그 삭제
- [ ] 사용자 유형 조회

---

# Board 추가 모듈

## 7. LSTA 사용자 검색 (LSTASearch)

### XML 파일
- `src/main/resources/mappers/com/wsc/common/board/LSTASearch.xml`

### 화면 URL
- `/common/board/lstasearch/popup.do`

### 화면 기능
LSTA 사용자 검색 팝업

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_get_lsta_user_search | LSTA 사용자 검색 |
| /searchCount.do | searchCount | sp_get_lsta_user_search_count | LSTA 사용자 카운트 |
| /selectLstaList.do | selectLstaList | sp_get_lsta_user_search_list | LSTA 사용자 전체 목록 |

### 테스트 항목
- [ ] LSTA 사용자 검색
  - [ ] 사용자ID(s_userId) 검색
- [ ] LSTA 사용자 전체 목록 조회

---

## 8. 마이뷰 검색 (MyViewSearch)

### XML 파일
- `src/main/resources/mappers/com/wsc/common/board/MyViewSearch.xml`

### 화면 URL
- `/common/board/myview/list.do`
- `/common/board/myview/form.do`

### 화면 기능
사용자별 화면 컬럼 뷰 설정 관리

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 마이뷰 목록 | 저장된 뷰 목록 |
| 컬럼 설정 그리드 | 표시할 컬럼 선택/순서 설정 |
| 뷰 저장/삭제 | 뷰 관리 기능 |

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_get_sys_win_col | 시스템 컬럼 조회 |
| /searchCount.do | searchCount | sp_get_sys_win_col_count | 시스템 컬럼 카운트 |
| /search2.do | search2 | sp_get_user_vw_col | 사용자 뷰 컬럼 조회 |
| /search2Count.do | search2Count | sp_get_user_vw_col_count | 사용자 뷰 컬럼 카운트 |
| /getMyViewList.do | getMyViewList | sp_get_my_view_list | 마이뷰 목록 조회 |
| /saveMyViewMast.do | saveMyViewMast | sp_save_my_view_mast | 마이뷰 마스터 저장 |
| /saveMyViewColList.do | saveMyViewColList | sp_save_my_view_col | 마이뷰 컬럼 저장 |
| /deleteMyViewColList.do | deleteMyViewColList | sp_delete_my_view_col | 마이뷰 컬럼 삭제 |
| /getMyViewMastInfo.do | getMyViewMastInfo | sp_get_my_view_mast | 마이뷰 마스터 정보 조회 |
| /deleteMyView.do | deleteMyView | sp_delete_my_view | 마이뷰 삭제 |

### 테스트 항목
- [ ] 시스템 컬럼 조회
  - [ ] 화면ID(windId)별 기본 컬럼 목록
- [ ] 사용자 뷰 컬럼 조회
  - [ ] 화면ID, 뷰ID별 사용자 설정 컬럼
- [ ] 마이뷰 목록 조회
  - [ ] 사용자별 저장된 뷰 목록
- [ ] 마이뷰 저장
  - [ ] 뷰명(viewName), 순서(viewSeq), 기본여부(viewDefa) 설정
  - [ ] 컬럼 목록 저장 (컬럼ID, 설명, 순서, 유형 등)
  - [ ] 엑셀 컬럼ID, 스타일, 다운로드 여부 설정
- [ ] 마이뷰 삭제

---

## 9. Commdmdp

### XML 파일
- `src/main/resources/mappers/com/wsc/common/board/Commdmdp.xml`

### 화면 기능
(쿼리 미구현)

---

# Code 추가 모듈

## 10. 바코드 (Barcode)

### XML 파일
- `src/main/resources/mappers/com/wsc/common/code/Barcode.xml`

### 화면 기능
바코드 관리 (쿼리 미구현)

### 테스트 항목
- [ ] 바코드 기능 (별도 구현 필요)

---

## API 파라미터 상세

### BatchWorkRevise search (배치 작업 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| jobId | VARCHAR | N | 작업 ID |
| jobGrup | VARCHAR | N | 작업 그룹 |
| jobTerm | VARCHAR | N | 작업 주기 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

### ExcelInfo insert (엑셀 정보 등록)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| fileNm | VARCHAR | Y | 파일명 |
| viewNo | VARCHAR | N | 뷰 순서 |
| colLvl | VARCHAR | N | 컬럼 레벨 |
| colVal | VARCHAR | N | 컬럼 값 |
| align | VARCHAR | N | 정렬/스타일 |
| gsUserId | VARCHAR | Y | 사용자 ID |

### UserLogList search (사용자 로그 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| userId | VARCHAR | N | 사용자 ID (부분 일치) |
| progId | VARCHAR | N | 프로그램 ID |
| accTimeBgn | VARCHAR | N | 접속시간 시작 |
| accTimeEnd | VARCHAR | N | 접속시간 종료 |
| userType | VARCHAR | N | 사용자 유형 (LSTA, DEALER) |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

### PersonalExcelInfo insert (개인 엑셀 정보 등록)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| windId | VARCHAR | Y | 화면 ID |
| viewSeq | VARCHAR | N | 뷰 순서 |
| viewType | VARCHAR | N | 뷰 유형 |
| colId | VARCHAR | Y | 컬럼 ID |
| colDesc | VARCHAR | N | 컬럼 설명 |
| exceColId | VARCHAR | N | 엑셀 컬럼 ID |
| style | VARCHAR | N | 스타일 |
| excelDown | VARCHAR | N | 엑셀 다운로드 여부 |
| mergCode | VARCHAR | N | 병합 코드 |
| useYn | VARCHAR | N | 사용 여부 |
| useRemk | VARCHAR | N | 사용 비고 |
| gsUserId | VARCHAR | Y | 사용자 ID |

### MyViewSearch saveMyViewColList (마이뷰 컬럼 저장)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| gsUserId | VARCHAR | Y | 사용자 ID |
| windId | VARCHAR | Y | 화면 ID |
| viewId | VARCHAR | Y | 뷰 ID |
| colId | VARCHAR | Y | 컬럼 ID |
| colDesc | VARCHAR | N | 컬럼 설명 |
| viewSeq | VARCHAR | N | 뷰 순서 |
| viewType | VARCHAR | N | 뷰 유형 |
| exceColId | VARCHAR | N | 엑셀 컬럼 ID |
| style | VARCHAR | N | 스타일 |
| exceDownYn | VARCHAR | N | 엑셀 다운로드 여부 |
| mergCode | VARCHAR | N | 병합 코드 |
