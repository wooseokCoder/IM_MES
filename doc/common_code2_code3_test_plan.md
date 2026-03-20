# common/code2, code3 테스트 계획서

## 개요
이 문서는 `common/code2`, `common/code3` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**:
- `src/main/resources/mappers/com/wsc/common/code2/Code2.xml`
- `src/main/resources/mappers/com/wsc/common/code3/Code3.xml`

---

# Code2 모듈 (확장 필드 지원 코드 관리)

## 1. 공통코드 관리 (Code2)

### 화면 URL
- `/common/code2/list.do`
- `/common/code2/form.do`

### JS 파일
- `resources/js/common/code2/code2.js`

### 화면 기능
확장 필드(extChr01~10, extNum01~05, extText)를 지원하는 공통코드 관리

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 코드 목록 그리드 | 코드 목록 표시 |
| 검색 필터 | 코드그룹, 코드, 코드명, 사용여부 검색 |
| 등록/수정 폼 | 코드 정보 입력 (확장 필드 포함) |
| 삭제 버튼 | 코드 삭제 |

### 호출 API

#### 코드 기본 관리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_code2_search | 코드 목록 조회 (페이징) |
| /searchCount.do | searchCount | sp_code2_search_count | 코드 목록 카운트 |
| /select.do | select | sp_code2_select | 코드 단건 조회 |
| /insert.do | insert | sp_code2_insert | 코드 등록 |
| /update.do | update | sp_code2_update | 코드 수정 |
| /delete.do | delete | sp_code2_delete | 코드 삭제 |
| /searchAll.do | searchAll | sp_code2_search_all | 전체 코드 조회 |
| /deleteAll.do | deleteAll | sp_code2_delete_all | 코드 그룹 전체 삭제 |
| /insertHist.do | insertHist | sp_code2_insert_hist | 코드 변경 이력 등록 |

### 테스트 항목
- [ ] 코드 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 검색 필터 동작 (코드그룹, 코드, 코드명)
  - [ ] 확장 필드 검색 (extChr01~10, extNum01~05)
  - [ ] 정렬 기능 확인
- [ ] 코드 등록
  - [ ] 필수 필드 검증 (코드그룹, 코드)
  - [ ] 중복 코드 체크
  - [ ] 확장 문자 필드 입력 (extChr01~10)
  - [ ] 확장 숫자 필드 입력 (extNum01~05)
  - [ ] 확장 텍스트 필드 입력 (extText)
- [ ] 코드 수정
  - [ ] 코드 정보 변경
  - [ ] 확장 필드 변경
  - [ ] 사용 여부 변경
- [ ] 코드 삭제
  - [ ] 단일 코드 삭제
  - [ ] 코드 그룹 전체 삭제
- [ ] 코드 변경 이력
  - [ ] 이력 등록 확인

---

## 2. 공통코드 기간 관리 (Code2 Term)

### 화면 URL
- `/common/code2/termlist.do`
- `/common/code2/termform.do`

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /searchTerm.do | searchTerm | sp_code2_search_term | 코드 기간 목록 조회 |
| /searchTermCount.do | searchTermCount | sp_code2_search_term_count | 코드 기간 목록 카운트 |
| /selectTerm.do | selectTerm | sp_code2_select_term | 코드 기간 단건 조회 |
| /insertTerm.do | insertTerm | sp_code2_insert_term | 코드 기간 등록 |
| /deleteTerm.do | deleteTerm | sp_code2_delete_term | 코드 기간 삭제 |

### 테스트 항목
- [ ] 코드 기간 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 기간(codeDate) 필터링
- [ ] 코드 기간 등록
  - [ ] 기간 설정
  - [ ] 확장 필드 포함 등록
- [ ] 코드 기간 삭제

---

# Code3 모듈 (다국어 지원 코드 관리)

## 3. 공통코드 관리 (Code3 - 다국어)

### 화면 URL
- `/common/code3/list.do`
- `/common/code3/form.do`

### JS 파일
- `resources/js/common/code3/code3.js`

### 화면 기능
다국어(gsLang)를 지원하는 공통코드 관리

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 코드 목록 그리드 | 코드 목록 표시 (다국어 코드명) |
| 언어 선택 | 표시 언어 선택 |
| 검색 필터 | 코드그룹, 코드, 코드설명, 사용여부 검색 |
| 등록/수정 폼 | 코드 정보 입력 (한국어/영어 코드명) |

### 호출 API

#### 코드 기본 관리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_code3_search | 코드 목록 조회 (페이징) |
| /searchCount.do | searchCount | sp_code3_search_count | 코드 목록 카운트 |
| /select.do | select | sp_code3_select | 코드 단건 조회 |
| /insert.do | insert | sp_code3_insert | 코드 등록 |
| /update.do | update | sp_code3_update | 코드 수정 |
| /delete.do | delete | sp_code3_delete | 코드 삭제 |
| /searchAll.do | searchAll | sp_code3_search_all | 전체 코드 조회 |
| /deleteAll.do | deleteAll | sp_code3_delete_all | 코드 그룹 전체 삭제 |
| /insertHist.do | insertHist | sp_code3_insert_hist | 코드 변경 이력 등록 |

### 테스트 항목
- [ ] 코드 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 언어별 코드명 표시 확인 (gsLang 파라미터)
  - [ ] 검색 필터 동작
- [ ] 코드 등록
  - [ ] 필수 필드 검증
  - [ ] 한국어 코드명 입력 (codeNameKr)
  - [ ] 영어 코드명 입력 (codeNameEn)
  - [ ] 확장 필드 입력
- [ ] 코드 수정
  - [ ] 다국어 코드명 변경
- [ ] 코드 삭제

---

## 4. 공통코드 기간 관리 (Code3 Term)

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /searchTerm.do | searchTerm | sp_code3_search_term | 코드 기간 목록 조회 |
| /searchTermCount.do | searchTermCount | sp_code3_search_term_count | 코드 기간 목록 카운트 |
| /selectTerm.do | selectTerm | sp_code3_select_term | 코드 기간 단건 조회 |
| /insertTerm.do | insertTerm | sp_code3_insert_term | 코드 기간 등록 |
| /deleteTerm.do | deleteTerm | sp_code3_delete_term | 코드 기간 삭제 |

### 테스트 항목
- [ ] 코드 기간 목록 조회
  - [ ] 다국어 지원 확인
  - [ ] 기간 필터링
- [ ] 코드 기간 등록
- [ ] 코드 기간 삭제

---

## 5. 특수 코드 조회

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /searchCodeAs.do | searchCodeAs | sp_code3_search_code_as | AS 코드 조회 |
| /searchCustProd.do | searchCustProd | sp_code3_search_cust_prod | 고객 제품 조회 |
| /searchAllProd.do | searchAllProd | sp_code3_search_all_prod | 전체 제품 조회 |
| /searchOutsCustStrg.do | searchOutsCustStrg | sp_code3_search_outs_cust_strg | 외주 고객 창고 조회 |

### 테스트 항목
- [ ] AS 코드 조회
- [ ] 고객 제품 조회
- [ ] 전체 제품 조회
- [ ] 외주 고객 창고 조회

---

## API 파라미터 상세

### Code2 search (코드 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| codeGrup | VARCHAR | N | 코드 그룹 |
| codeCd | VARCHAR | N | 코드 |
| codeName | VARCHAR | N | 코드명 |
| codeNameEn | VARCHAR | N | 영문 코드명 |
| codeDesc | VARCHAR | N | 코드 설명 |
| useFlag | VARCHAR | N | 사용 여부 |
| extChr01~10 | VARCHAR | N | 확장 문자 필드 |
| extNum01~05 | VARCHAR | N | 확장 숫자 필드 |
| extText | VARCHAR | N | 확장 텍스트 필드 |
| sortSeq | VARCHAR | N | 정렬 순서 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |
| sortStr | VARCHAR | N | 정렬 문자열 |

### Code3 insert (코드 등록 - 다국어)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| codeCd | VARCHAR | Y | 코드 |
| codeGrup | VARCHAR | Y | 코드 그룹 |
| codeNameKr | VARCHAR | N | 한국어 코드명 |
| codeNameEn | VARCHAR | N | 영어 코드명 |
| codeDesc | VARCHAR | N | 코드 설명 |
| sortSeq | VARCHAR | N | 정렬 순서 |
| useFlag | VARCHAR | N | 사용 여부 |
| extChr01~10 | VARCHAR | N | 확장 문자 필드 |
| extNum01~05 | VARCHAR | N | 확장 숫자 필드 |
| extText | LONGVARCHAR | N | 확장 텍스트 필드 |
| gsUserId | VARCHAR | Y | 사용자 ID |
