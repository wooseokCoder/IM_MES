# common/user2, user3 테스트 계획서

## 개요
이 문서는 `common/user2`, `common/user3` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**:
- `src/main/resources/mappers/com/wsc/common/user2/User2.xml`
- `src/main/resources/mappers/com/wsc/common/user2/Group2.xml`
- `src/main/resources/mappers/com/wsc/common/user2/Program2.xml`
- `src/main/resources/mappers/com/wsc/common/user3/Group3.xml`
- `src/main/resources/mappers/com/wsc/common/user3/Program3.xml`

---

# User2 모듈 (딜러 통합 사용자 관리)

## 1. 사용자 관리 (User2)

### 화면 URL
- `/common/user2/list.do`
- `/common/user2/form.do`

### JS 파일
- `resources/js/common/user2/user2.js`

### 화면 기능
딜러 정보와 연동된 사용자 관리 기능

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 사용자 목록 그리드 | 사용자 목록 표시 |
| 검색 필터 | 사용자ID, 사용자명, 사용자유형, 메뉴유형 검색 |
| 등록/수정 폼 | 사용자 정보 입력 |
| 딜러 정보 영역 | 연동된 딜러 정보 표시 |
| 비밀번호 변경 | 비밀번호 변경 기능 |

### 호출 API

#### 사용자 기본 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 사용자 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 사용자 목록 카운트 |
| /select.do | select | 인라인 SQL | 사용자 단건 조회 |
| /insert.do | insert | 인라인 SQL | 사용자 등록 |
| /update.do | update | 인라인 SQL | 사용자 수정 |
| /delete.do | delete | 인라인 SQL | 사용자 삭제 |

#### 비밀번호 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /checkPassword.do | checkPassword | 인라인 SQL | 비밀번호 확인 |
| /updatePassword.do | updatePassword | 인라인 SQL | 비밀번호 변경 |
| /updateFailure.do | updateFailure | 인라인 SQL | 로그인 실패 카운트 증가 |
| /updateSuccess.do | updateSuccess | 인라인 SQL | 로그인 성공 처리 |

#### 딜러 연동 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /selectDealerInfo.do | selectDealerInfo | 인라인 SQL | 딜러 정보 조회 |
| /saveDealer.do | saveDealer | 인라인 SQL | 딜러 정보 저장 |
| /saveDealerUser.do | saveDealerUser | 인라인 SQL | 딜러 사용자 저장 |
| /updateDealer.do | updateDealer | 인라인 SQL | 딜러 정보 수정 |
| /updateDealerUser.do | updateDealerUser | 인라인 SQL | 딜러 사용자 수정 |
| /selectDealerCdf.do | selectDealerCdf | 인라인 SQL | 딜러 CDF 번호 조회 |

#### 코드/목록 조회
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /selectUserType.do | selectUserType | 인라인 SQL | 사용자 유형 조회 |
| /selectUserBm.do | selectUserBm | sp_get_service_user_list | BM 사용자 목록 조회 |
| /selectCodeName.do | selectCodeName | 인라인 SQL | 코드명 조회 |
| /selectBmList.do | selectBmList | 인라인 SQL | BM 목록 조회 |
| /selectHeadDealList.do | selectHeadDealList | 인라인 SQL | 본사 딜러 목록 조회 |
| /searchType.do | searchType | 인라인 SQL | 유형 검색 |
| /searchApplList.do | searchApplList | sp_get_search_appl_list_code | 애플리케이션 목록 검색 |

### 테스트 항목
- [ ] 사용자 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 검색 필터 동작 (사용자ID, 사용자명, 사용자유형)
  - [ ] 다국어 지원 확인 (gsLang)
- [ ] 사용자 등록
  - [ ] 필수 필드 검증
  - [ ] 비밀번호 암호화 저장 (AES_ENCRYPT)
  - [ ] 딜러 정보 연동 저장
  - [ ] 메일 플래그 설정 (createMailFlag, reviewMailFlag 등)
- [ ] 사용자 수정
  - [ ] 사용자 정보 변경
  - [ ] 딜러 동기화 (fn_dealer_sync)
  - [ ] 로그인 실패 카운트 초기화
- [ ] 비밀번호 관리
  - [ ] 비밀번호 확인
  - [ ] 비밀번호 변경
- [ ] 딜러 연동
  - [ ] 딜러 정보 조회
  - [ ] 딜러 정보 저장/수정

---

## 2. 그룹 관리 (Group2)

### 화면 URL
- `/common/user2/group/list.do`
- `/common/user2/group/form.do`

### 호출 API

#### 그룹 기본 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 그룹 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 그룹 목록 카운트 |
| /select.do | select | 인라인 SQL | 그룹 단건 조회 |
| /insert.do | insert | 인라인 SQL | 그룹 등록 |
| /update.do | update | 인라인 SQL | 그룹 수정 |
| /delete.do | delete | 인라인 SQL | 그룹 삭제 |

#### 사용자-그룹 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /searchUserGroup.do | searchUserGroup | 인라인 SQL | 사용자-그룹 목록 조회 |
| /searchUserGroupCount.do | searchUserGroupCount | 인라인 SQL | 사용자-그룹 카운트 |
| /selectUserGroup.do | selectUserGroup | 인라인 SQL | 사용자-그룹 단건 조회 |
| /insertUserGroup.do | insertUserGroup | 인라인 SQL | 사용자-그룹 등록 |
| /updateUserGroup.do | updateUserGroup | 인라인 SQL | 사용자-그룹 수정 |
| /deleteUserGroup.do | deleteUserGroup | 인라인 SQL | 사용자-그룹 삭제 |

### 테스트 항목
- [ ] 그룹 CRUD 테스트
- [ ] 사용자-그룹 매핑 테스트

---

## 3. 프로그램 권한 관리 (Program2)

### 화면 URL
- `/common/user2/program/list.do`
- `/common/user2/program/form.do`

### 호출 API

#### 프로그램 기본 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 프로그램 목록 조회 |
| /searchCount.do | searchCount | 인라인 SQL | 프로그램 목록 카운트 |
| /select.do | select | 인라인 SQL | 프로그램 단건 조회 |
| /insert.do | insert | 인라인 SQL | 프로그램 등록 |
| /update.do | update | 인라인 SQL | 프로그램 수정 |
| /delete.do | delete | 인라인 SQL | 프로그램 삭제 |

#### 그룹-프로그램 권한 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /searchGroupProgram.do | searchGroupProgram | 인라인 SQL | 그룹-프로그램 목록 조회 |
| /searchGroupProgramCount.do | searchGroupProgramCount | 인라인 SQL | 그룹-프로그램 카운트 |
| /selectGroupProgram.do | selectGroupProgram | 인라인 SQL | 그룹-프로그램 단건 조회 |
| /insertGroupProgram.do | insertGroupProgram | 인라인 SQL | 그룹-프로그램 권한 등록 |
| /updateGroupProgram.do | updateGroupProgram | 인라인 SQL | 그룹-프로그램 권한 수정 |
| /deleteGroupProgram.do | deleteGroupProgram | 인라인 SQL | 그룹-프로그램 권한 삭제 |

#### 사용자-프로그램 권한 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /searchUserProgram.do | searchUserProgram | 인라인 SQL | 사용자-프로그램 목록 조회 |
| /searchUserProgramCount.do | searchUserProgramCount | 인라인 SQL | 사용자-프로그램 카운트 |
| /selectUserProgram.do | selectUserProgram | 인라인 SQL | 사용자-프로그램 단건 조회 |
| /insertUserProgram.do | insertUserProgram | 인라인 SQL | 사용자-프로그램 권한 등록 |
| /updateUserProgram.do | updateUserProgram | 인라인 SQL | 사용자-프로그램 권한 수정 |
| /deleteUserProgram.do | deleteUserProgram | 인라인 SQL | 사용자-프로그램 권한 삭제 |

#### 권한 조회
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /selectSecurity.do | selectSecurity | 인라인 SQL (VIEW) | 프로그램 권한 정보 조회 |

### 테스트 항목
- [ ] 프로그램 CRUD 테스트
- [ ] 그룹-프로그램 권한 설정 테스트
  - [ ] 트랜잭션 권한 설정 (TRAN_A, C, R, U, D, P, S)
  - [ ] 추가 권한 설정 (TRAN_1~5)
- [ ] 사용자-프로그램 권한 설정 테스트
- [ ] 권한 조회 테스트 (VIEW 사용)

---

# User3 모듈 (확장 그룹/프로그램 관리)

## 4. 그룹 관리 (Group3)

### 화면 URL
- `/common/user3/group/list.do`

### 호출 API
Group2와 동일한 구조 (SYS_GRUP, SYS_UGRP 테이블 사용)

### 테스트 항목
- [ ] 그룹 CRUD 테스트
- [ ] 사용자-그룹 매핑 테스트
- [ ] groupId2 필드 사용 확인

---

## 5. 프로그램 권한 관리 (Program3)

### 화면 URL
- `/common/user3/program/list.do`

### 호출 API
Program2와 동일한 구조 (SYS_PROG, SYS_GPGM, SYS_UPGM 테이블 사용)

### 테스트 항목
- [ ] 프로그램 CRUD 테스트
- [ ] progId2 필드 사용 확인
- [ ] 그룹-프로그램 권한 설정 테스트
- [ ] 사용자-프로그램 권한 설정 테스트

---

## 권한 유형 설명

| 권한 | 설명 |
|------|------|
| TRAN_A | 전체 권한 (All) |
| TRAN_C | 등록 권한 (Create) |
| TRAN_R | 조회 권한 (Read) |
| TRAN_U | 수정 권한 (Update) |
| TRAN_D | 삭제 권한 (Delete) |
| TRAN_P | 인쇄 권한 (Print) |
| TRAN_S | 저장 권한 (Save) |
| TRAN_1~5 | 사용자 정의 권한 |

---

## API 파라미터 상세

### User2 search (사용자 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| userId | VARCHAR | N | 사용자 ID |
| userName | VARCHAR | N | 사용자명 |
| userType | VARCHAR | N | 사용자 유형 |
| menuType | VARCHAR | N | 메뉴 유형 |
| menuSet | VARCHAR | N | 메뉴 세트 |
| comCode | VARCHAR | N | 회사 코드 |
| deptCode | VARCHAR | N | 부서 코드 |
| useFlag | VARCHAR | N | 사용 여부 |
| gsLang | VARCHAR | N | 언어 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |
