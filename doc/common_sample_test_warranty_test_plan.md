# common/sample, test, warranty 테스트 계획서

## 개요
이 문서는 `common/sample`, `common/test`, `common/warranty` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**:
- `src/main/resources/mappers/com/wsc/common/sample/Autologintest.xml`
- `src/main/resources/mappers/com/wsc/common/sample/LocManager.xml`
- `src/main/resources/mappers/com/wsc/common/sample/Sampleboard.xml`
- `src/main/resources/mappers/com/wsc/common/sample/Wsdltest.xml`
- `src/main/resources/mappers/com/wsc/common/test/Test.xml`
- `src/main/resources/mappers/com/wsc/common/test/TestBoard.xml`
- `src/main/resources/mappers/com/wsc/common/warranty/Warranty.xml`

---

# Sample 모듈 (샘플/테스트 기능)

## 1. 자동 로그인 테스트 (Autologintest)

### 화면 URL
- 테스트 전용 (웹 화면 없음)

### 화면 기능
자동 로그인 테스트를 위한 토큰 생성 및 메뉴 조회

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /createTokenForTest.do | createTokenForTest | SP_CREATE_TOKEN | 테스트용 토큰 생성 |
| /getMenuKeyByUrl.do | getMenuKeyByUrl | 인라인 SQL | URL로 메뉴 키 조회 |

### 테스트 항목
- [ ] 테스트용 토큰 생성
  - [ ] 사용자별 토큰 생성
  - [ ] SSO URL 정보 포함
- [ ] 메뉴 키 조회
  - [ ] URL 경로로 메뉴 키 조회

---

## 2. 위치 관리 (LocManager)

### 화면 URL
- `/common/sample/locmanager/list.do`
- `/common/sample/locmanager/form.do`

### JS 파일
- `resources/js/common/sample/locmanager.js`

### 화면 기능
창고 위치 정보 관리 (위도/경도, 서명 이미지 포함)

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 위치 목록 그리드 | 등록된 위치 목록 |
| 검색 필터 | 창고, 사용여부, 위치번호 검색 |
| 등록/수정 폼 | 위치 정보 입력 |
| 지도 영역 | 위도/경도 표시 |
| 서명 영역 | 서명 이미지 등록 |

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_search_loc_mast | 위치 목록 조회 (페이징) |
| /searchCount.do | searchCount | sp_search_count_loc_mast | 위치 목록 카운트 |
| /select.do | select | sp_select_loc_mast | 위치 단건 조회 |
| /insert.do | insert | sp_insert_loc_mast | 위치 등록 |
| /update.do | update | sp_update_loc_mast | 위치 수정 |
| /delete.do | delete | sp_delete_loc_mast | 위치 삭제 |
| /checkSign.do | checkSign | sp_check_sign_loc_mast | 서명 확인 |

### 테스트 항목
- [ ] 위치 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 창고(wareHous) 필터링
  - [ ] 사용여부(useFlag) 필터링
  - [ ] 위치번호(locNo) 검색
- [ ] 위치 등록
  - [ ] 위치번호 입력
  - [ ] 창고 선택
  - [ ] 위도/경도 입력 (latitude, longitude)
  - [ ] 서명 이미지 등록 (signImg)
  - [ ] 사용여부 설정
- [ ] 위치 수정
- [ ] 위치 삭제
- [ ] 서명 확인
  - [ ] 창고별 저장된 서명 조회

---

## 3. 샘플 게시판 (Sampleboard)

### 화면 URL
- `/common/sample/sampleboard/list.do`
- `/common/sample/sampleboard/form.do`

### JS 파일
- `resources/js/common/sample/sampleboard.js`

### 화면 기능
샘플 게시판 CRUD 및 엑셀 업로드 기능

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 게시판 목록 그리드 | 게시글 목록 (트리 구조) |
| 검색 필터 | 제목, 내용, 작성자 검색 |
| 등록/수정 폼 | 게시글 작성 |
| 첨부파일 영역 | 파일 첨부 |
| 엑셀 업로드 | 대량 데이터 업로드 |

### 호출 API

#### 게시판 기본 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 게시글 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 게시글 카운트 |
| /select.do | select | 인라인 SQL | 게시글 단건 조회 |
| /insert.do | insert | 인라인 SQL | 게시글 등록 |
| /update.do | update | 인라인 SQL | 게시글 수정 |
| /delete.do | delete | 인라인 SQL | 게시글 삭제 |

#### 리스트 재정렬
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /getListReorder.do | getListReorder | sp_sampleboard_list_reorder | 리스트 재정렬 |
| /getListReorderDefault.do | getListReorderDefault | sp_sampleboard_list_reorder_default | 기본 재정렬 |
| /getListReorderList.do | getListReorderList | sp_sampleboard_list_reorder_list | 재정렬 목록 |

#### 엑셀 업로드
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /excelUpload.do | excelUpload | sp_sampleboard_excel_upload | 엑셀 업로드 검증 |
| /excelUpdate.do | excelUpdate | sp_sampleboard_excel_update | 엑셀 업로드 저장 |

### 테스트 항목
- [ ] 게시글 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 트리 구조 표시 (계층형 게시판)
  - [ ] 제목 검색 (searchKey = S01)
  - [ ] 내용 검색 (searchKey = S02)
  - [ ] 작성자 검색 (searchKey = S03)
  - [ ] 사용여부 필터링
- [ ] 게시글 등록
  - [ ] 게시글 번호 자동 생성
  - [ ] 제목, 내용 입력
  - [ ] 첨부파일 등록
- [ ] 게시글 수정
- [ ] 게시글 삭제
- [ ] 리스트 재정렬
  - [ ] 사용자별 정렬 설정
  - [ ] 기본 정렬 복원
- [ ] 엑셀 업로드
  - [ ] 업로드 데이터 검증
  - [ ] 검증 후 저장

---

## 4. WSDL 테스트 (Wsdltest)

### 화면 URL
- 테스트 전용

### 화면 기능
WSDL 웹 서비스 테스트 (쿼리 없음)

### 테스트 항목
- [ ] 웹 서비스 연동 테스트 (별도 구현 필요)

---

# Test 모듈 (테스트 기능)

## 5. 메뉴 테스트 (Test)

### 화면 URL
- `/common/test/list.do`
- `/common/test/form.do`

### JS 파일
- `resources/js/common/test/test.js`

### 화면 기능
시스템 메뉴 CRUD 테스트

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 메뉴 목록 그리드 | 메뉴 목록 |
| 검색 필터 | 메뉴 키, 메뉴명 검색 |
| 등록/수정 폼 | 메뉴 정보 입력 |

### 호출 API
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 메뉴 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 메뉴 카운트 |
| /insert.do | insert | 인라인 SQL | 메뉴 등록 |
| /update.do | update | 인라인 SQL | 메뉴 수정 |
| /delete.do | delete | 인라인 SQL | 메뉴 삭제 |

### 테스트 항목
- [ ] 메뉴 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 메뉴 키(menuKey) 검색
  - [ ] 메뉴명(menuDesc) 검색
- [ ] 메뉴 등록
  - [ ] 메뉴 키, 메뉴명 입력
  - [ ] 메뉴 URL 입력
  - [ ] 부모 키, 레벨, 순서 설정
- [ ] 메뉴 수정
- [ ] 메뉴 삭제

---

## 6. 테스트 게시판 (TestBoard)

### 화면 URL
- `/common/test/testboard/list.do`
- `/common/test/testboard/form.do`

### JS 파일
- `resources/js/common/test/testboard.js`

### 화면 기능
테스트 게시판 CRUD

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 게시글 목록 그리드 | 게시글 목록 |
| 검색 필터 | 제목, 내용, 통합 검색 |
| 등록/수정 폼 | 게시글 작성 |

### 호출 API
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 게시글 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 게시글 카운트 |
| /select.do | select | 인라인 SQL | 게시글 상세 조회 |
| /insert.do | insert | 인라인 SQL | 게시글 등록 |
| /update.do | update | 인라인 SQL | 게시글 수정 |
| /delete.do | delete | 인라인 SQL | 게시글 삭제 |
| /updateReadCnt.do | updateReadCnt | 인라인 SQL | 조회수 증가 |

### 테스트 항목
- [ ] 게시글 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 정렬 기능 (동적 정렬)
  - [ ] 게시글 번호(boardNo) 검색
  - [ ] 제목(boardTitle) 검색
  - [ ] 내용(boardContent) 검색
  - [ ] 통합 검색 (searchText)
  - [ ] 사용여부(useFlag) 필터링
- [ ] 게시글 상세 조회
  - [ ] 조회수 증가 확인
- [ ] 게시글 등록
  - [ ] 게시글 번호 자동 생성 (MAX + 1)
  - [ ] 제목, 내용 입력
- [ ] 게시글 수정
  - [ ] 제목, 내용 변경
  - [ ] 수정자, 수정일 기록
- [ ] 게시글 삭제

---

# Warranty 모듈 (보증)

## 7. 보증 관리 (Warranty)

### 화면 URL
- `/common/warranty/list.do`

### 화면 기능
보증 관리 (쿼리 미구현)

### 테스트 항목
- [ ] 보증 관련 기능 (별도 구현 필요)

---

## API 파라미터 상세

### LocManager search (위치 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| wareHous | VARCHAR | N | 창고 코드 |
| useFlag | VARCHAR | N | 사용 여부 |
| locNo | VARCHAR | N | 위치 번호 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

### Sampleboard search (샘플 게시판 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| useFlag | VARCHAR | N | 사용 여부 |
| regiId | VARCHAR | N | 등록자 ID |
| bordTitle | VARCHAR | N | 게시글 제목 |
| bordText | VARCHAR | N | 게시글 내용 |
| bordType | VARCHAR | N | 게시글 유형 |
| searchKey | VARCHAR | N | 검색 키 (S01:제목, S02:내용, S03:작성자) |
| searchText | VARCHAR | N | 검색 텍스트 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

### TestBoard search (테스트 게시판 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| boardNo | VARCHAR | N | 게시글 번호 |
| boardTitle | VARCHAR | N | 게시글 제목 |
| boardContent | VARCHAR | N | 게시글 내용 |
| searchText | VARCHAR | N | 통합 검색 텍스트 |
| useFlag | VARCHAR | N | 사용 여부 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

### LocManager insert (위치 등록)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| locNo | VARCHAR | Y | 위치 번호 |
| wareHous | VARCHAR | Y | 창고 코드 |
| latitude | VARCHAR | N | 위도 |
| longitude | VARCHAR | N | 경도 |
| signImg | VARCHAR | N | 서명 이미지 |
| useFlag | VARCHAR | N | 사용 여부 |
| gsUserId | VARCHAR | Y | 사용자 ID |
