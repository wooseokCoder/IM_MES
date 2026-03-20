# common/report 테스트 계획서

## 개요
이 문서는 `common/report` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**:
- `src/main/resources/mappers/com/wsc/common/report/DataManagement.xml`
- `src/main/resources/mappers/com/wsc/common/report/DataSearch.xml`

---

## 1. 데이터 운영 관리 (DataManagement)

### 화면 URL
- `/common/report/datamanagement/list.do`
- `/common/report/datamanagement/form.do`

### JS 파일
- `resources/js/common/report/datamanagement.js`

### 화면 기능
데이터 운영 작업(Job) 정의 및 파라미터 관리 기능

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 작업 목록 그리드 | 데이터 운영 작업 목록 |
| 검색 필터 | 작업번호, 작업설명 검색 |
| 작업 등록 폼 | 작업 정보 및 SQL 정의 |
| 파라미터 관리 | 작업 파라미터 설정 |
| 권한 설정 | 사용자/그룹 권한 설정 |

### 호출 API

#### 작업 기본 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 작업 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 작업 목록 카운트 |
| /select.do | select | 인라인 SQL | 작업 단건 조회 |
| /searchAll.do | searchAll | 인라인 SQL | 전체 작업 조회 |
| /getjobNo.do | getjobNo | 인라인 SQL | 작업번호 생성 |
| /insert.do | DataManagementinsert | 인라인 SQL | 작업 등록 |
| /update.do | DataManagementupdate | 인라인 SQL | 작업 수정 |
| /updateSql.do | updateSql | 인라인 SQL | SQL 수정 |
| /delete.do | DataManagementdelete | 인라인 SQL | 작업 삭제 |

#### 작업 파라미터 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /searchDetl.do | searchDetl | 인라인 SQL | 파라미터 목록 조회 |
| /searchDetlCount.do | searchDetlCount | 인라인 SQL | 파라미터 카운트 |
| /insertDetl.do | DataManagementinsertDetl | 인라인 SQL | 파라미터 등록 |
| /updateDetl.do | DataManagementupdateDetl | 인라인 SQL | 파라미터 수정 |
| /deleteDetl.do | DataManagementdeleteDetl | 인라인 SQL | 파라미터 삭제 |

#### 권한 조회
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /userType.do | userType | 인라인 SQL | 사용자 유형 목록 |
| /userTypeTarget.do | userTypeTarget | 인라인 SQL | 대상 사용자 유형 |
| /groupList.do | groupList | 인라인 SQL | 그룹 목록 |
| /groupTarget.do | groupTarget | 인라인 SQL | 대상 그룹 |
| /userIdList.do | userIdList | 인라인 SQL | 사용자 ID 목록 |
| /userIdTarget.do | userIdTarget | 인라인 SQL | 대상 사용자 ID |

### 테스트 항목

#### 작업 관리
- [ ] 작업 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 검색 필터 동작 (작업번호, 작업설명)
- [ ] 작업 등록
  - [ ] 필수 필드 검증 (작업번호)
  - [ ] 작업 유형 설정 (jobType1, jobType2)
  - [ ] 권한 유형 설정 (authType)
  - [ ] SQL 저장 (jobSql)
- [ ] 작업 수정
  - [ ] 작업 정보 변경
  - [ ] SQL 변경
- [ ] 작업 삭제

#### 파라미터 관리
- [ ] 파라미터 목록 조회
- [ ] 파라미터 등록
  - [ ] 파라미터 코드 설정
  - [ ] 파라미터 유형 설정
  - [ ] 파라미터 순서 설정
  - [ ] 기본값 설정
- [ ] 파라미터 수정
- [ ] 파라미터 삭제

#### 권한 설정
- [ ] 그룹 권한 설정
- [ ] 사용자 권한 설정
- [ ] 사용자 유형별 권한 설정

---

## 2. 데이터 검색 (DataSearch)

### 화면 URL
- `/common/report/datasearch/list.do`
- `/common/report/datasearch/form.do`

### JS 파일
- `resources/js/common/report/datasearch.js`

### 화면 기능
데이터 검색 및 조회 기능 (직원 정보 등)

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 검색 필터 | 이름, 회사, 부서 등 검색 |
| 결과 그리드 | 검색 결과 목록 |
| 상세 보기 | 상세 정보 표시 |
| 하위 데이터 | 관련 파라미터 정보 |

### 호출 API

#### 데이터 검색
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 데이터 검색 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 데이터 카운트 |
| /searchAll.do | searchAll | 인라인 SQL | 전체 데이터 조회 |
| /searchSub.do | searchSub | 인라인 SQL | 하위 파라미터 조회 |
| /searchSubCount.do | searchSubCount | 인라인 SQL | 하위 파라미터 카운트 |

#### 데이터 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /insert.do | insert | 인라인 SQL | 데이터 등록 |
| /update.do | update | 인라인 SQL | 데이터 수정 |
| /delete.do | delete | 인라인 SQL | 데이터 삭제 |
| /getjobNo.do | getjobNo | 인라인 SQL | 작업번호 생성 |

#### SQL 및 파라미터 조회
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /getSqlData.do | getSqlData | 인라인 SQL | SQL 데이터 조회 |
| /getSqlParameter.do | getSqlParameter | 인라인 SQL | SQL 파라미터 조회 |
| /getGroupId.do | getGroupId | 인라인 SQL | 그룹 ID 조회 |
| /searchJobType.do | searchJobType | 인라인 SQL | 작업 유형 검색 |
| /getFieldTitle.do | DataSearchgetFieldTitle | 인라인 SQL | 필드 타이틀 조회 |

### 테스트 항목

#### 데이터 검색
- [ ] 검색 조건별 조회
  - [ ] 이름 검색 (searchEmplName)
  - [ ] 회사코드 검색 (compCode)
  - [ ] 부서코드 검색 (deptCode)
  - [ ] 재직 여부 검색 (exitYn)
- [ ] 페이징 동작 확인
- [ ] 다국어 지원 확인 (gsLang)

#### 하위 데이터 조회
- [ ] 파라미터 목록 조회
- [ ] 파라미터 순서별 정렬

#### SQL 실행
- [ ] SQL 데이터 조회
- [ ] 파라미터 바인딩

---

## API 파라미터 상세

### DataManagement search (작업 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| searchJobNo | VARCHAR | N | 작업번호 검색 |
| searchDesc | VARCHAR | N | 작업설명 검색 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

### DataManagement insert (작업 등록)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| jobNo | VARCHAR | Y | 작업번호 (자동생성) |
| jobDesc | VARCHAR | N | 작업설명 |
| jobType1 | VARCHAR | N | 작업유형1 |
| jobType2 | VARCHAR | N | 작업유형2 |
| authType | VARCHAR | N | 권한유형 |
| authGroups | VARCHAR | N | 권한그룹 |
| authUsers | VARCHAR | N | 권한사용자 |
| authFunc | VARCHAR | N | 권한함수 |
| useYn | VARCHAR | N | 사용여부 |
| jobSql | BLOB | N | SQL 쿼리 |
| remk | VARCHAR | N | 비고 |
| gsUserId | VARCHAR | Y | 사용자 ID |

### DataSearch search (데이터 검색)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| searchEmplName | VARCHAR | N | 직원명 검색 |
| compCode | VARCHAR | N | 회사코드 |
| searchjobNo | VARCHAR | N | 작업번호 |
| deptCode | VARCHAR | N | 부서코드 |
| exitYn | VARCHAR | N | 재직여부 |
| gsLang | VARCHAR | N | 언어 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

---

## 테이블 정보

### DATA_OPER_MAST (데이터 운영 마스터)
- 작업 기본 정보 및 SQL 쿼리 저장
- 권한 설정 (그룹/사용자)

### DATA_OPER_DETL (데이터 운영 상세)
- 작업 파라미터 정보
- 파라미터 유형, 순서, 기본값 관리
