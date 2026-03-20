# common/mail 테스트 계획서

## 개요
이 문서는 `common/mail` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**: `src/main/resources/mappers/com/wsc/common/mail/Mail.xml`

---

## 1. 메일 발송/수신 관리

### 화면 URL
- `/common/mail/list.do` (보낸 메일함)
- `/common/mail/inbox.do` (받은 메일함)
- `/common/mail/form.do` (메일 작성)
- `/common/mail/view.do` (메일 상세 조회)

### JS 파일
- `resources/js/common/mail/mail.js`

### 화면 기능
메일 발송, 수신, 조회 및 주소록 관리 기능

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 보낸 메일함 | 발송된 메일 목록 |
| 받은 메일함 | 수신된 메일 목록 |
| 메일 작성 폼 | 메일 제목, 내용, 수신자 입력 |
| 파일 첨부 | 첨부 파일 업로드 |
| 수신자 선택 | 주소록에서 수신자 선택 |
| 검색 필터 | 메일 검색 조건 |

### 호출 API

#### 보낸 메일 관리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_mail_search | 보낸 메일 목록 조회 |
| /searchCount.do | searchCount | sp_mail_search_count | 보낸 메일 카운트 |
| /select.do | select | sp_mail_select | 메일 단건 조회 |
| /mailNo.do | mailNo | sp_mail_no | 메일 번호 생성 |
| /insert.do | insert | 인라인 SQL | 메일 등록 |
| /delete.do | delete | sp_mail_delete | 메일 삭제 |

#### 메일 타겟 관리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /deleteTargetAll.do | deleteTargetAll | sp_mail_delete_target_all | 메일 타겟 전체 삭제 |
| /mailTgtDelete.do | mailTgtDelete | 인라인 SQL | 메일 타겟 삭제 |
| /insertTarget.do | insertTarget | INSERT_TARGET 함수 | 메일 타겟 등록 |
| /selectTarget.do | selectTarget | sp_mail_select_target | 메일 타겟 상세 조회 |

#### 읽음/실패 처리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /updateReadMail.do | updateReadMail | sp_mail_update_read | 읽음 처리 |
| /updateFailMail.do | updateFailMail | sp_mail_update_fail | 실패 처리 |

### 테스트 항목

#### 보낸 메일함 테스트
- [ ] 보낸 메일 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 검색 필터 동작 확인
  - [ ] 정렬 기능 확인
- [ ] 메일 상세 조회
  - [ ] 수신자 목록 표시
  - [ ] 첨부 파일 표시
- [ ] 메일 삭제 기능
  - [ ] 단일 메일 삭제
  - [ ] 삭제 확인 메시지

#### 메일 작성 테스트
- [ ] 메일 등록 기능
  - [ ] 필수 필드 검증 (제목, 수신자)
  - [ ] 내용 입력
  - [ ] 파일 첨부
- [ ] 수신자 선택
  - [ ] 다중 수신자 선택
  - [ ] 주소록에서 수신자 추가

---

## 2. 받은 메일함 관리

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /searchInternalList.do | searchInternalList | sp_mail_search_internal_list | 받은 메일 목록 조회 |
| /searchInternalListCount.do | searchInternalListCount | sp_mail_search_internal_list_count | 받은 메일 카운트 |

### 테스트 항목
- [ ] 받은 메일 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 검색 필터 동작 확인
  - [ ] 읽음/안읽음 표시
- [ ] 메일 읽음 처리
  - [ ] 메일 열람 시 읽음 상태 변경
  - [ ] 읽음 상태 표시 갱신

---

## 3. 주소록 관리

### 화면 URL
- `/common/mail/address.do`

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /searchUserAddress.do | searchUserAddress | sp_mail_search_user_address | 사용자 주소록 조회 |
| /searchUserAddressCount.do | searchUserAddressCount | sp_mail_search_user_address_count | 주소록 카운트 |
| /selectUserAddress.do | selectUserAddress | sp_mail_select_user_address | 주소록 단건 조회 |
| /insertUserAddress.do | insertUserAddress | sp_mail_insert_user_address | 주소록 등록 |
| /updateUserAddress.do | updateUserAddress | sp_mail_update_user_address | 주소록 수정 |
| /deleteUserAddress.do | deleteUserAddress | sp_mail_delete_user_address | 주소록 삭제 |
| /searchUserInternalList.do | searchUserInternalList | sp_mail_search_user_internal_list | 내부 사용자 목록 조회 |

### 테스트 항목
- [ ] 주소록 조회
  - [ ] 페이징 동작
  - [ ] 검색 필터
- [ ] 주소록 등록
  - [ ] 사용자 추가
  - [ ] 중복 체크
- [ ] 주소록 수정
  - [ ] 이름 수정
- [ ] 주소록 삭제
  - [ ] 삭제 확인 메시지

---

## 4. 메일 조회수 관리

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /searchMailViewsList.do | searchMailViewsList | sp_mail_search_views_list | 메일 조회수 목록 |
| /searchMailViewsListCount.do | searchMailViewsListCount | sp_mail_search_views_list_count | 조회수 카운트 |

### 테스트 항목
- [ ] 조회수 목록 조회
  - [ ] 수신자별 조회 여부 표시
  - [ ] 조회 시간 표시

---

## 5. 메일 플래그 확인

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /returnMailYnCheck.do | returnMailYnCheck | sp_mail_return_yn_check | 반송 메일 확인 |
| /confirmMailYnCheck.do | confirmMailYnCheck | sp_mail_confirm_yn_check | 확인 메일 확인 |
| /bolMailYnCheck.do | bolMailYnCheck | sp_mail_bol_yn_check | BOL 메일 확인 |
| /reviewMailYnCheck.do | reviewMailYnCheck | sp_mail_review_yn_check | 리뷰 메일 확인 |
| /monthlyMailYnCheck.do | monthlyMailYnCheck | sp_mail_monthly_yn_check | 월간 메일 확인 |
| /ordrClMailYnCheck.do | ordrClMailYnCheck | sp_mail_ordrcl_yn_check | 주문 마감 메일 확인 |

### 테스트 항목
- [ ] 각 메일 유형별 플래그 확인
  - [ ] 반송 메일 플래그
  - [ ] 확인 메일 플래그
  - [ ] BOL 메일 플래그
  - [ ] 리뷰 메일 플래그
  - [ ] 월간 메일 플래그
  - [ ] 주문 마감 메일 플래그

---

## 6. SMTP 메일 관리

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /selectSmtpMailCheck.do | selectSmtpMailCheck | select_smtp_mail_check | SMTP 메일 확인 |

### 테스트 항목
- [ ] SMTP 설정 확인
- [ ] 외부 메일 발송 테스트
