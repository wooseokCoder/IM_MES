# common/user 화면별 테스트 계획서

> 작성일: 2026-01-15 (갱신)
> 대상 모듈: src/main/resources/mappers/com/wsc/common/user/

---

## 목차

### 사용자 관리
1. [사용자 관리 (user.jsp)](#1-사용자-관리-userjsp)
2. [그룹 관리 (group.jsp)](#2-그룹-관리-groupjsp)
3. [사용자-그룹 매핑 (usergroup.jsp)](#3-사용자-그룹-매핑-usergroupjsp)

### 프로그램/권한 관리
4. [화면(프로그램) 관리 (program.jsp)](#4-화면프로그램-관리-programjsp)
5. [그룹-화면 권한 (groupprogram.jsp)](#5-그룹-화면-권한-groupprogramjsp)
6. [사용자-화면 권한 (userprogram.jsp)](#6-사용자-화면-권한-userprogramjsp)
7. [사용자-화면 현황 조회 (userprogramlist.jsp)](#7-사용자-화면-현황-조회-userprogramlistjsp)
8. [프로그램별 사용자 현황 (programlistuser.jsp)](#8-프로그램별-사용자-현황-programlistuserjsp)

### 메뉴 관리
9. [메뉴 관리 (menu.jsp)](#9-메뉴-관리-menujsp)
10. [자주사용 메뉴 (hotmenu)](#10-자주사용-메뉴-hotmenu)

### 비밀번호/인증 관리
11. [비밀번호 초기화 - 관리자용 (password.jsp)](#11-비밀번호-초기화---관리자용-passwordjsp)
12. [비밀번호 변경 - 사용자용 (userpassword.jsp)](#12-비밀번호-변경---사용자용-userpasswordjsp)
13. [사용자 보안키 관리 (usersecure)](#13-사용자-보안키-관리-usersecure)

### 로그 관리
14. [사용자 로그 조회 (userlog.jsp)](#14-사용자-로그-조회-userlogjsp)
15. [사용자 로그 목록 (userloglist.jsp)](#15-사용자-로그-목록-userloglistjsp)

### 배치/작업 관리
16. [배치 작업 관리 (batchwork.jsp)](#16-배치-작업-관리-batchworkjsp)
17. [배치 작업 수정 (batchworkrevise.jsp)](#17-배치-작업-수정-batchworkrevisejsp)
18. [배치 실행 상태 (batchstatus.jsp)](#18-배치-실행-상태-batchstatusjsp)
19. [작업 이력 조회 (jobhist.jsp)](#19-작업-이력-조회-jobhistjsp)

### 기타 설정
20. [이메일 설정 (emailinsert.jsp)](#20-이메일-설정-emailinsertjsp)
21. [엑셀 정보 관리 (excelinfo.jsp)](#21-엑셀-정보-관리-excelinfojsp)
22. [개인 엑셀 정보 관리 (personalexcelinfo.jsp)](#22-개인-엑셀-정보-관리-personalexcelinfojsp)

### 부록
- [프로시저 사용 현황 요약](#프로시저-사용-현황-요약)
- [권한 칼럼 설명](#권한-칼럼-설명)
- [테스트 체크리스트](#테스트-체크리스트)

---

## 1. 사용자 관리 (user.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `User.xml` |
| 네임스페이스 | `com.wsc.common.user.User` |
| 화면 URL | `/common/user/user.do` |
| JS 파일 | `/resources/js/common/user/user.js` |
| 화면 기능 | 시스템 사용자 정보 CRUD 관리 |

### UI 구성요소
- 검색 폼: 유형, 부서, 사용여부, 조직권한, 특수권한 콤보박스
- 그리드: 사용자ID, 사용자명, 유형, 회사, 부서, 전화번호, 이메일 등
- 팝업 다이얼로그: 상세정보 등록/수정 폼

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/user/search.json` | search | `sp_user_search` |
| 목록 카운트 | - | searchCount | `sp_user_search_count` |
| 상세 조회 | `/common/user/user/select.json` | select | `sp_user_select` |
| 등록 | `/common/user/user/save.json` | insert | `sp_user_insert` |
| 수정 | `/common/user/user/save.json` | update | `sp_user_update` |
| 삭제 | `/common/user/user/delete.json` | delete | `sp_user_delete` |
| 비밀번호 확인 | - | checkPassword | `sp_user_check_password` |
| 90일 체크 | - | check90days | `sp_user_check_90days` |
| 비밀번호 변경 | - | updatePassword | `sp_user_update_password` |
| 로그인 실패 | - | updateFailure | `sp_user_update_failure` |
| 로그인 성공 | - | updateSuccess | `sp_user_update_success` |
| 사용자 타입 | - | getUserType | `sp_user_get_type` |
| 사용자 그룹 | - | getUserGroup | `sp_user_get_group` |
| Bank User 체크 | - | checkBankUser | `sp_get_check_bank_user` |
| ROOT 메뉴 체크 | - | checkRootMenu | `sp_get_check_root_menu` |
| 이메일 수신거부 | - | unsubscribeMail | `SP_SET_UNSUBSCRIBE_MAIL` |

### 프로시저 파라미터 - sp_user_search
```
sysId, userId, userName, userType, orgAuthCode, spcAuthCode,
comCode, comName, emplNo, deptCode, deptName, upprDeptCode,
userTel, userHp, userMail, userRemk, useFlag, start, end, sortStr
```

### 테스트 항목
- [ ] 검색 조건별 조회 (유형, 부서, 사용여부, 조직권한, 특수권한)
- [ ] 페이징 동작 확인
- [ ] 정렬 기능 확인
- [ ] 신규 사용자 등록
- [ ] 기존 사용자 정보 수정
- [ ] 사용자 삭제
- [ ] 비밀번호 확인 기능
- [ ] 90일 비밀번호 만료 체크
- [ ] 엑셀 다운로드

---

## 2. 그룹 관리 (group.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Group.xml` |
| 네임스페이스 | `com.wsc.common.user.Group` |
| 화면 URL | `/common/user/group.do` |
| JS 파일 | `/resources/js/common/user/group.js` |
| 화면 기능 | 사용자 그룹(권한 그룹) CRUD 관리 |

### UI 구성요소
- 검색 폼: Group ID, Group Name 텍스트박스
- 그리드(인라인 편집): Group ID, Group Name, 사용유무, 등록자/수정자 정보

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/group/search.json` | search | `sp_group_search` |
| 목록 카운트 | - | searchCount | `sp_group_search_count` |
| 상세 조회 | - | select | `sp_group_select` |
| 등록 | `/common/user/group/save.json` | insert | `sp_group_insert` |
| 수정 | `/common/user/group/save.json` | update | `sp_group_update` |
| 삭제 | `/common/user/group/save.json` | delete | `sp_group_delete` |
| 사용자 목록 | - | selectUserList | `sp_group_select_user_list` |
| 그룹 목록 | - | selectGroupList | `sp_group_select_list` |
| 프로그램 목록 | - | selectUserProgList | `sp_search_Program_List_Combo` |

### 프로시저 파라미터 - sp_group_search
```
sysId, groupId, groupName, start, end, sortStr
```

### 프로시저 파라미터 - sp_group_insert
```
sysId, groupId, groupName, useFlag, gsUserId
```

### 테스트 항목
- [ ] 그룹 목록 조회
- [ ] 신규 그룹 추가 (인라인)
- [ ] 그룹 정보 수정 (인라인)
- [ ] 그룹 삭제
- [ ] 그룹 목록 콤보 조회
- [ ] 엑셀 다운로드

---

## 3. 사용자-그룹 매핑 (usergroup.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Group.xml` |
| 네임스페이스 | `com.wsc.common.user.Group` |
| 화면 URL | `/common/user/usergroup.do` |
| JS 파일 | `/resources/js/common/user/usergroup.js` |
| 화면 기능 | 사용자에게 그룹 할당/해제 관리 |

### UI 구성요소
- 검색 폼: User ID 콤보박스, Group ID 콤보박스
- 그리드(인라인 편집): User ID, User Name, Group ID, Group Name(콤보)

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/usergroup/search.json` | searchUserGroup | `sp_usergroup_search` |
| 목록 카운트 | - | searchUserGroupCount | `sp_usergroup_search_count` |
| 상세 조회 | - | selectUserGroup | `sp_usergroup_select` |
| 등록 | `/common/user/usergroup/save.json` | insertUserGroup | `sp_usergroup_insert` |
| 수정 | `/common/user/usergroup/save.json` | updateUserGroup | `sp_usergroup_update` |
| 삭제 | `/common/user/usergroup/save.json` | deleteUserGroup | `sp_usergroup_delete` |

### 프로시저 파라미터 - sp_usergroup_search
```
sysId, userId, groupId, start, end, sortStr
```

### 프로시저 파라미터 - sp_usergroup_update
```
sysId, userId, groupId, groupId2, gsUserId
```
> groupId2: 변경될 새 그룹 ID

### 테스트 항목
- [ ] 사용자별 그룹 조회
- [ ] 사용자에 그룹 할당 (콤보 선택)
- [ ] 그룹 변경 (groupId2 사용)
- [ ] 그룹 매핑 해제
- [ ] 엑셀 다운로드

---

## 4. 화면(프로그램) 관리 (program.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Program.xml` |
| 네임스페이스 | `com.wsc.common.user.Program` |
| 화면 URL | `/common/user/program.do` |
| JS 파일 | `/resources/js/common/user/program.js` |
| 화면 기능 | 시스템 화면/프로그램 정보 관리 |

### UI 구성요소
- 검색 폼: Prog ID, Prog Name, Prog Type, Sys Loc 텍스트박스
- 그리드(인라인 편집): Prog ID, Prog Name, 권한칼럼(TRAN_A/C/R/U/D/P/S/1~5)

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/program/search.json` | search | `sp_program_search` |
| 목록 카운트 | - | searchCount | `sp_program_search_count` |
| 상세 조회 | - | select | `sp_program_select` |
| 등록 | `/common/user/program/save.json` | insert | `sp_program_insert` |
| 수정 | `/common/user/program/save.json` | update | `sp_program_update` |
| 삭제 | `/common/user/program/save.json` | delete | `sp_program_delete` |
| 프로그램 목록 | - | selectProgList | `sp_program_select_list` |
| 권한 조회 | - | selectSecurity | `sp_program_select_security` |
| 프로그램 권한 | - | programAuth | `sp_program_auth` |
| 게시판 여부 | - | selectBoardYN | `sp_program_select_board_yn` |

### 프로시저 파라미터 - sp_program_search
```
sysId, progId, progName, progType, sysLoc, useFlag,
tranA, tranC, tranR, tranU, tranD, tranP, tranS,
tran1, tran2, tran3, tran4, tran5, sortStr, start, end
```

### 프로시저 파라미터 - sp_program_insert
```
sysId, progId, progName, progType, sysLoc, pattern,
tranA, tranC, tranR, tranU, tranD, tranP, tranS,
tran1, tran2, tran3, tran4, tran5, gsUserId
```

### 테스트 항목
- [ ] 프로그램 목록 조회
- [ ] 조건별 검색 (ID, Name, Type, Location)
- [ ] 신규 프로그램 추가
- [ ] 프로그램 정보 수정
- [ ] 프로그램 삭제
- [ ] 권한 칼럼 체크박스 동작
- [ ] 프로그램 권한 조회

---

## 5. 그룹-화면 권한 (groupprogram.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Program.xml` |
| 네임스페이스 | `com.wsc.common.user.Program` |
| 화면 URL | `/common/user/groupprogram.do` |
| JS 파일 | `/resources/js/common/user/groupprogram.js` |
| 화면 기능 | 그룹별 화면 접근 권한 설정 |

### UI 구성요소
- 검색 폼: Group ID 콤보박스, Prog ID 텍스트박스
- 그리드(인라인 편집): Group ID, Prog ID, Prog Name(콤보), 권한칼럼

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/groupprogram/search.json` | searchGroupProgram | `sp_groupprogram_search` |
| 목록 카운트 | - | searchGroupProgramCount | `sp_groupprogram_search_count` |
| 상세 조회 | - | selectGroupProgram | `sp_groupprogram_select` |
| 등록 | `/common/user/groupprogram/save.json` | insertGroupProgram | `sp_groupprogram_insert` |
| 수정 | `/common/user/groupprogram/save.json` | updateGroupProgram | `sp_groupprogram_update` |
| 삭제 | `/common/user/groupprogram/save.json` | deleteGroupProgram | `sp_groupprogram_delete` |

### 프로시저 파라미터 - sp_groupprogram_search
```
sysId, progId, groupId, sortStr, start, end
```

### 프로시저 파라미터 - sp_groupprogram_insert/update
```
sysId, progId, groupId, tranA, tranC, tranR, tranU, tranD, tranP, tranS,
tran1, tran2, tran3, tran4, tran5, gsUserId
```

### 테스트 항목
- [ ] 그룹별 권한 조회
- [ ] 그룹에 프로그램 권한 추가
- [ ] 권한 체크박스 수정
- [ ] 권한 삭제
- [ ] 엑셀 다운로드

---

## 6. 사용자-화면 권한 (userprogram.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Program.xml` |
| 네임스페이스 | `com.wsc.common.user.Program` |
| 화면 URL | `/common/user/userprogram.do` |
| JS 파일 | `/resources/js/common/user/userprogram.js` |
| 화면 기능 | 사용자별 화면 접근 권한 설정 |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/userprogram/search.json` | searchUserProgram | `sp_userprogram_search` |
| 목록 카운트 | - | searchUserProgramCount | `sp_userprogram_search_count` |
| 상세 조회 | - | selectUserProgram | `sp_userprogram_select` |
| 등록 | `/common/user/userprogram/save.json` | insertUserProgram | `sp_userprogram_insert` |
| 수정 | `/common/user/userprogram/save.json` | updateUserProgram | `sp_userprogram_update` |
| 삭제 | `/common/user/userprogram/save.json` | deleteUserProgram | `sp_userprogram_delete` |

### 프로시저 파라미터 - sp_userprogram_search
```
sysId, progId, userId, sortStr, start, end
```

### 테스트 항목
- [ ] 사용자별 권한 조회
- [ ] 사용자에 프로그램 권한 추가
- [ ] 권한 수정/삭제
- [ ] 엑셀 다운로드

---

## 7. 사용자-화면 현황 조회 (userprogramlist.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Program.xml` |
| 네임스페이스 | `com.wsc.common.user.Program` |
| 화면 URL | `/common/user/userprogramlist.do` |
| JS 파일 | `/resources/js/common/user/userprogramlist.js` |
| 화면 기능 | 특정 사용자의 화면별 권한 현황 조회 |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/userprogramlist/search.json` | searchUserProgramList | `sp_search_User_Program_List` |
| 목록 카운트 | - | searchUserProgramListCount | `sp_search_User_Program_List_Count` |

### 프로시저 파라미터
```
sysId, userId, progId, data1, start, end
```

### 테스트 항목
- [ ] 사용자별 권한 현황 조회
- [ ] 페이징 동작
- [ ] 엑셀 다운로드

---

## 8. 프로그램별 사용자 현황 (programlistuser.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Program.xml` |
| 네임스페이스 | `com.wsc.common.user.Program` |
| 화면 URL | `/common/user/programlistuser.do` |
| JS 파일 | `/resources/js/common/user/programlistuser.js` |
| 화면 기능 | 특정 화면의 사용자별 권한 현황 조회 |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/programlistuser/search.json` | searchProgramListUser | `sp_search_Program_List_User` |
| 목록 카운트 | - | searchProgramListUserCount | `sp_search_Program_List_User_Count` |

### 프로시저 파라미터
```
sysId, progId, data1, start, end
```

### 테스트 항목
- [ ] 프로그램별 사용자 권한 조회
- [ ] 페이징 동작
- [ ] 엑셀 다운로드

---

## 9. 메뉴 관리 (menu.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Menu.xml` |
| 네임스페이스 | `com.wsc.common.user.Menu` |
| 화면 URL | `/common/user/menu.do` |
| JS 파일 | `/resources/js/common/user/menu.js` |
| 화면 기능 | 시스템 메뉴 구조 관리 |

### UI 구성요소
- 검색 폼: Menu Key, Level, Desc, URL, Parent Key, Type, Action, Enable, SFDC 등
- 그리드(인라인 편집): Menu ID, Menu Desc(다국어 KR/EN/PORT/VIET/ETC), URL, Level, Seq, Type 등

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/menu/search.json` | search | `SP_SEARCH_MENU` |
| 목록 카운트 | - | searchCount | `SP_SEARCH_COUNT_MENU` |
| 상세 조회 | `/common/user/menu/select.json` | select | `SP_SELECT_MENU` |
| 등록 | `/common/user/menu/save.json` | insert | `SP_INSERT_MENU` |
| 수정 | `/common/user/menu/save.json` | update | `SP_UPDATE_MENU` |
| 삭제 | `/common/user/menu/save.json` | delete | `SP_DELETE_MENU` |
| 권한 메뉴 조회 | - | searchAuthorized | `SP_SEARCH_AUTHORIZED_MENU` |
| 메뉴 타입 조회 | - | searchType | `SP_SEARCH_TYPE_MENU` |

### 프로시저 파라미터 - SP_SEARCH_MENU
```
sysId, menuKey, menuLevel, menuDesc, menuDir, menuUrl, parentKey,
parentType, childYn, procType, actionYn, iconCls, menuSeq, sepaText,
useFlag, enableYn, sfdcYn, gsLang, start, end, sortClause
```

### 프로시저 파라미터 - SP_INSERT_MENU
```
sysId, menuKey, menuLevel, menuDescKr, menuDescEn, menuDescPort,
menuDescViet, menuDescEtc, menuDir, mobileType, menuUrl, parentKey,
parentType, childYn, procType, actionYn, iconCls, menuSeq, sepaText,
enableYn, sfdcYn, gsUserId
```

### 테스트 항목
- [ ] 메뉴 목록 조회
- [ ] 조건별 검색 (Level, URL, Type 등)
- [ ] 신규 메뉴 추가
- [ ] 메뉴 정보 수정 (다국어)
- [ ] 메뉴 삭제
- [ ] 권한 있는 메뉴 조회
- [ ] 메뉴 타입 팝업

---

## 10. 자주사용 메뉴 (hotmenu)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Menu.xml` |
| 네임스페이스 | `com.wsc.common.user.Menu` |
| 화면 URL | `/common/user/hotmenu.do` |
| 화면 기능 | 사용자별 즐겨찾기 메뉴 관리 |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/hotmenu/search.json` | searchHot | `SP_SEARCH_HOT_MENU` |
| 목록 카운트 | - | searchHotCount | `SP_SEARCH_HOT_COUNT_MENU` |
| 상세 조회 | - | selectHot | `SP_SELECT_HOT_MENU` |
| 등록 | `/common/user/hotmenu/save.json` | insertHot | `SP_INSERT_HOT_MENU` |
| 수정 | `/common/user/hotmenu/save.json` | updateHot | `SP_UPDATE_HOT_MENU` |
| 삭제 | `/common/user/hotmenu/delete.json` | deleteHot | `SP_DELETE_HOT_MENU` |

### 프로시저 파라미터 - SP_SEARCH_HOT_MENU
```
sysId, userId, gsUserId, gsLang, gsMobileType, gsMenuType
```

### 프로시저 파라미터 - SP_UPDATE_HOT_MENU
```
sysId, userId, menuKey, sortSeq, gsUserId
```

### 테스트 항목
- [ ] 자주사용 메뉴 조회
- [ ] 메뉴 즐겨찾기 추가
- [ ] 메뉴 순서 변경 (sortSeq)
- [ ] 즐겨찾기 삭제

---

## 11. 비밀번호 초기화 - 관리자용 (password.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Password.xml` |
| 네임스페이스 | `com.wsc.common.user.Password` |
| 화면 URL | `/common/password/password.do` |
| JS 파일 | `/resources/js/common/user/password.js` |
| 화면 기능 | 관리자가 사용자 비밀번호 초기화 |

### UI 구성요소
- 폼: User ID, New Password, Confirm Password
- 비밀번호 정책 안내 표시

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 비밀번호 저장 | `/common/password/save.json` | updateUserPw | `sp_password_update_user_pw` |
| 이메일 확인 | - | emailCheck | `sp_password_email_check` |
| 사용자 문자 확인 | - | chkUserChar | `sp_password_chk_user_char` |

### 프로시저 파라미터 - sp_password_update_user_pw
```
sysId, userId, newPw
```

### 프로시저 파라미터 - sp_password_email_check
```
sysId, userId, email
```

### 테스트 항목
- [ ] 사용자 ID 입력
- [ ] 새 비밀번호 입력
- [ ] 비밀번호 정책 검증 (대/소문자, 숫자, 특수문자)
- [ ] 비밀번호 확인 일치 검증
- [ ] 이메일 확인 후 비밀번호 발송
- [ ] 저장 성공/실패

---

## 12. 비밀번호 변경 - 사용자용 (userpassword.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `Password.xml` |
| 네임스페이스 | `com.wsc.common.user.Password` |
| 화면 URL | `/common/password/userpassword.do` |
| JS 파일 | `/resources/js/common/user/userpassword.js` |
| 화면 기능 | 로그인 사용자 본인 비밀번호 변경 |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 기존 비밀번호 확인 | `/common/password/userPwChk.json` | chkUserPw | `sp_password_chk_user_pw` |
| 기존 비밀번호 확인2 | - | chkUserPw2 | `sp_password_chk_user_pw2` |
| 비밀번호 저장 | `/common/password/saveUserPw.json` | updateUserPw-user | `sp_password_update_user_pw_user` |
| 로그인 실패 처리 | - | updateLoginNG | `sp_password_update_login_ng` |
| 로그인 성공 처리 | - | updateLoginOK | `sp_password_update_login_ok` |
| 로그인 상태 확인 | - | checkLoginSts | `sp_password_check_login_sts` |

### 프로시저 파라미터 - sp_password_chk_user_pw
```
sysId, gsUserId, oldPw
```

### 프로시저 파라미터 - sp_password_update_user_pw_user
```
sysId, gsUserId, newPw
```

### 테스트 항목
- [ ] 기존 비밀번호 확인
- [ ] 새 비밀번호 정책 검증
- [ ] 비밀번호 변경 저장
- [ ] 로그인 상태 확인

---

## 13. 사용자 보안키 관리 (usersecure)

| 항목 | 내용 |
|------|------|
| XML 파일 | `UserSecure.xml` |
| 네임스페이스 | `com.wsc.common.user.UserSecure` |
| 화면 기능 | 자동로그인 보안키 관리 |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | - | search | `sp_usersecure_search` |
| 목록 카운트 | - | searchCount | `sp_usersecure_search_count` |
| 상세 조회 | - | select | `sp_usersecure_select` |
| 등록 | - | insert | `sp_usersecure_insert` |
| 수정 | - | update | `sp_usersecure_update` |
| 삭제 | - | delete | `sp_usersecure_delete` |

### 프로시저 파라미터 - sp_usersecure_search
```
sysId, userId, secureKey, sortStr, start, end
```

### 프로시저 파라미터 - sp_usersecure_insert
```
sysId, userId, secureKey, gsUserId
```

### 테스트 항목
- [ ] 보안키 목록 조회
- [ ] 보안키 유효성 확인 (1일 이내, 미사용)
- [ ] 보안키 등록
- [ ] 로그인 시 보안키 갱신
- [ ] 보안키 삭제

---

## 14. 사용자 로그 조회 (userlog.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `UserLog.xml` |
| 네임스페이스 | `com.wsc.common.user.UserLog` |
| 화면 URL | `/common/user/userlog.do` |
| JS 파일 | `/resources/js/common/user/userlog.js` |
| 화면 기능 | 사용자 접속 로그 조회 |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/userlog/search.json` | search | `sp_userlog_search` |
| 목록 카운트 | - | searchCount | `sp_userlog_search_count` |
| 등록 | - | insert | `sp_insert_sys_ulog` |
| 삭제 | - | delete | `sp_userlog_delete` |

### 프로시저 파라미터 - sp_userlog_search
```
sysId, userId, progId, loginDate, clientIp, clientName, clientAgent,
sortStr, start, end
```

### 프로시저 파라미터 - sp_insert_sys_ulog
```
sysId, userId, progId, loginDate, clientIp, clientName, clientAgent, logRemk
```

### 테스트 항목
- [ ] 사용자별 로그 조회
- [ ] 기간별 로그 조회
- [ ] 페이징 동작
- [ ] 로그 삭제

---

## 15. 사용자 로그 목록 (userloglist.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `UserLogList.xml` |
| 네임스페이스 | `com.wsc.common.user.UserLogList` |
| 화면 URL | `/common/user/userloglist.do` |
| JS 파일 | `/resources/js/common/user/userloglist.js` |
| 화면 기능 | 사용자 로그 확장 조회 (사용자 타입 필터 포함) |

### UI 구성요소
- 검색 폼: 기간(시작~종료), User ID, User Type, Prog ID, Client IP
- 그리드(읽기 전용): System, User ID, User Name, Access Time, Client IP, Prog ID, Web Browser

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/userloglist/search.json` | search | `sp_userloglist_search` |
| 목록 카운트 | - | searchCount | `sp_userloglist_search_count` |
| 등록 | - | insert | `sp_insert_sys_ulog` |
| 삭제 | - | delete | `sp_userloglist_delete` |
| 사용자 타입 조회 | - | getUserType1 | `sp_userloglist_get_user_type1` |

### 프로시저 파라미터 - sp_userloglist_search
```
sysId, userId, loginDate, clientIp, clientName, clientAgent, progId,
userType, accTimeBgn, accTimeEnd, sortStr, start, end
```

### 테스트 항목
- [ ] 기간별 로그 조회 (accTimeBgn, accTimeEnd)
- [ ] 사용자 타입별 필터
- [ ] 사용자별/프로그램별 조회
- [ ] 페이징 동작
- [ ] 엑셀 다운로드

---

## 16. 배치 작업 관리 (batchwork.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `BatchWork.xml` |
| 네임스페이스 | `com.wsc.common.user.BatchWork` |
| 화면 URL | `/common/user/batchwork.do` |
| JS 파일 | `/resources/js/common/user/batchwork.js` |
| 화면 기능 | 배치 작업 등록/관리 |

### UI 구성요소
- 검색 폼: 작업구분(jobGrup), 작업주기(jobTerm) 콤보박스
- 그리드(인라인 편집): 작업ID, 작업구분, 작업유형, 작업주기, 작업시간, 작업명령, 담당자, 사용여부

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/batchwork/search.json` | search | `sp_batchwork_search` |
| 목록 카운트 | - | searchCount | `sp_batchwork_search_count` |
| 상세 조회 | - | select | `sp_batchwork_select` |
| 등록 | `/common/user/batchwork/save.json` | insert | `sp_batchwork_insert` |
| 수정 | `/common/user/batchwork/save.json` | update | `sp_batchwork_update` |

### 프로시저 파라미터 - sp_batchwork_search
```
sysId, jobGrup, jobTerm, sortStr, start, end
```

### 프로시저 파라미터 - sp_batchwork_insert
```
sysId, jobGrup, jobType, jobTerm, jobTime, jobCmd, jobDesc,
errProc, jobMng, useFlag, jobRemk, gsUserId, jobId(OUT)
```
> insert는 jobId를 OUT 파라미터로 반환

### 프로시저 파라미터 - sp_batchwork_update
```
sysId, jobId, newJobId, jobGrup, jobType, jobTerm, jobTime, jobCmd,
jobDesc, errProc, jobMng, useFlag, jobRemk, regiId, regiDate, gsUserId
```

### 테스트 항목
- [ ] 배치 작업 목록 조회
- [ ] 작업구분/주기별 필터
- [ ] 신규 작업 추가 (ID 자동생성)
- [ ] 작업 정보 수정
- [ ] 작업 활성화/비활성화 (사용여부)
- [ ] 엑셀 다운로드

---

## 17. 배치 작업 수정 (batchworkrevise.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `BatchWorkRevise.xml` |
| 네임스페이스 | `com.wsc.common.user.BatchWorkRevise` |
| 화면 URL | `/common/user/batchworkrevise.do` |
| JS 파일 | `/resources/js/common/user/batchworkrevise.js` |
| 화면 기능 | 배치 작업 수정 (별도 화면) |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/batchworkrevise/search.json` | search | `sp_batchworkrevise_search` |
| 목록 카운트 | - | searchCount | `sp_batchworkrevise_search_count` |
| 등록 | `/common/user/batchworkrevise/save.json` | BatchWorkReviseinsertJob | `sp_batchworkrevise_insert` |
| 수정 | `/common/user/batchworkrevise/save.json` | BatchWorkReviseupdateJob | `sp_batchworkrevise_update` |

### 프로시저 파라미터 - sp_batchworkrevise_search
```
sysId, jobId, jobGrup, jobTerm, sortStr, start, end
```

### 프로시저 파라미터 - sp_batchworkrevise_update
```
sysId, jobId, jobIdNew, jobGrup, jobType, jobTerm, jobTime, jobCmd,
jobDesc, errProc, jobMng, useFlag, jobRemk, gsUserId
```

### 테스트 항목
- [ ] 배치 작업 목록 조회
- [ ] Job ID별 검색
- [ ] 신규 작업 등록
- [ ] 작업 정보 수정 (ID 변경 가능)

---

## 18. 배치 실행 상태 (batchstatus.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `BatchStatus.xml` |
| 네임스페이스 | `com.wsc.common.user.BatchStatus` |
| 화면 URL | `/common/user/batchstatus.do` |
| JS 파일 | `/resources/js/common/user/batchstatus.js` |
| 화면 기능 | 배치 작업 실행 상태/이력 조회 |

### UI 구성요소
- 검색 폼: 작업 ID 콤보박스, 성공/실패 콤보박스, 실행기간(시작~종료)
- 그리드(읽기 전용): 작업ID, 작업설명, 작업주기, 시작/종료일시, 작업결과, 결과설명

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/user/batchstatus/search.json` | search | `sp_batchstatus_search` |
| 목록 카운트 | - | searchCount | `sp_batchstatus_search_count` |
| Job ID 목록 | - | getSelectJobId | `sp_batchstatus_get_select_job_id` |

### 프로시저 파라미터 - sp_batchstatus_search
```
sysId, jobId, succFail, accTimeBgn, accTimeEnd, sortStr, start, end
```

### 테스트 항목
- [ ] 기간별 실행 상태 조회
- [ ] 작업ID별 조회
- [ ] 성공/실패 필터 조회
- [ ] Job ID 콤보 목록 조회
- [ ] 엑셀 다운로드

---

## 19. 작업 이력 조회 (jobhist.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `JobHist.xml` |
| 네임스페이스 | `com.wsc.common.user.JobHist` |
| 화면 URL | `/common/jobhist/jobhist.do` |
| JS 파일 | `/resources/js/common/user/jobhist.js` |
| 화면 기능 | 배치 작업 상세 이력 조회 |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 목록 조회 | `/common/jobhist/jobhist/search.json` | search | `sp_jobhist_search` |
| 목록 카운트 | - | searchCount | `sp_jobhist_search_count` |
| 등록 | - | insert | `sp_jobhist_insert` |
| 삭제 | - | delete | `sp_jobhist_delete` |
| Job ID 목록 | `/common/jobhist/jobhist/selectJobIdList.json` | selectJobIdList | `sp_jobhist_select_job_id_list` |
| Job 결과 목록 | - | selectJobRsltList | `sp_jobhist_select_job_rslt_list` |
| 그룹별 이력 | - | searchJobHistGroup | `sp_jobhist_search_group` |

### 프로시저 파라미터 - sp_jobhist_search
```
sysId, jobId, jobDesc, jobRslt, bgnDate, endDate, rsltDesc, jobFile,
accTimeBgn, accTimeEnd, start, end, sortStr
```

### 프로시저 파라미터 - sp_jobhist_insert
```
sysId, jobId, regiId, chngId, jobFile, jobRslt
```

### 테스트 항목
- [ ] 기간별 작업 이력 조회
- [ ] Job ID별 필터
- [ ] 결과 상태별 필터
- [ ] 그룹별 이력 조회
- [ ] 엑셀 다운로드

---

## 20. 이메일 설정 (emailinsert.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `EmailInsert.xml` |
| 네임스페이스 | `com.wsc.common.user.EmailInsert` |
| 화면 URL | `/common/emailinsert/emailinsert.do` |
| JS 파일 | `/resources/js/common/user/emailinsert.js` |
| 화면 기능 | 사용자 SMTP 이메일 계정 설정 |

### UI 구성요소
- 폼: User ID(읽기전용), User Email(SMTP_MAIL), Email Password(SMTP_PW)
- 안내 문구: SMTP 설정 필요 설명

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 이메일 조회 | - | gsSmtpMail | `sp_emailinsert_get_smtp_mail` |
| 저장 | `/common/emailinsert/save.json` | EmailInsert | `sp_emailinsert_update` |

### 프로시저 파라미터 - sp_emailinsert_update
```
sysId, gsUserId, SMTP_MAIL, SMTP_PW
```

### 테스트 항목
- [ ] 현재 SMTP 이메일 조회
- [ ] 이메일 ID 입력
- [ ] 이메일 비밀번호 입력
- [ ] 저장 성공/실패

---

## 21. 엑셀 정보 관리 (excelinfo.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `ExcelInfo.xml` |
| 네임스페이스 | `com.wsc.common.user.ExcelInfo` |
| 화면 URL | `/common/user/excelinfo.do` |
| JS 파일 | `/resources/js/common/user/excelinfo.js` |
| 화면 기능 | 엑셀 다운로드 설정 정보 관리 |

### UI 구성요소
- 검색 폼: FILE_NM 콤보박스
- 그리드(인라인 편집): FILE Name, VIEW NO, COL Label, COL Value, ALIGN(STYLE)

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 그룹 목록 | - | getSelectExcelGroup | `sp_excelinfo_get_select_excel_group` |
| 목록 조회 | `/common/user/excelinfo/search.json` | search | `sp_excelinfo_search` |
| 목록 카운트 | - | searchCount | `sp_excelinfo_search_count` |
| 상세 조회 | `/common/user/excelinfo/select.json` | select | `sp_excelinfo_select` |
| 등록 | `/common/user/excelinfo/save.json` | insert | `sp_excelinfo_insert` |
| 수정 | `/common/user/excelinfo/save.json` | update | `sp_excelinfo_update` |
| 삭제 | `/common/user/excelinfo/delete.json` | delete | `sp_excelinfo_delete` |

### 프로시저 파라미터 - sp_excelinfo_search
```
sysId, s_fileNm, start, end, sortStr
```

### 프로시저 파라미터 - sp_excelinfo_insert
```
sysId, fileNm, viewNo, colLvl, colVal, align, gsUserId
```

### 프로시저 파라미터 - sp_excelinfo_update
```
sysId, fileNm, seq, viewNo, colLvl, colVal, align, gsUserId
```

### 테스트 항목
- [ ] 파일명별 엑셀 설정 조회
- [ ] 엑셀 그룹(파일) 목록 조회
- [ ] 신규 설정 추가
- [ ] 설정 수정
- [ ] 설정 삭제

---

## 22. 개인 엑셀 정보 관리 (personalexcelinfo.jsp)

| 항목 | 내용 |
|------|------|
| XML 파일 | `PersonalExcelInfo.xml` |
| 네임스페이스 | `com.wsc.common.user.PersonalExcelInfo` |
| 화면 URL | `/common/user/personalexcelinfo.do` |
| JS 파일 | `/resources/js/common/user/personalexcelinfo.js` |
| 화면 기능 | 사용자별 개인 엑셀 설정 관리 |

### 호출 API

| 기능 | API URL | XML 쿼리 ID | 프로시저명 |
|------|---------|------------|-----------|
| 그룹 목록 | - | getSelectPersonalExcelGroup | `sp_get_select_personal_excel_group` |
| 목록 조회 | `/common/user/personalexcelinfo/search.json` | search | `sp_search_personal_excel_info` |
| 목록 카운트 | - | searchCount | `sp_search_personal_excel_info_count` |
| 상세 조회 | - | select | `sp_select_personal_excel_info` |
| 등록 | `/common/user/personalexcelinfo/save.json` | insert | `sp_insert_personal_excel_info` |
| 수정 | `/common/user/personalexcelinfo/save.json` | update | `sp_update_personal_excel_info` |
| 삭제 | `/common/user/personalexcelinfo/delete.json` | delete | `sp_delete_personal_excel_info` |

### 프로시저 파라미터 - sp_search_personal_excel_info
```
sysId, start, end, s_windId
```

### 프로시저 파라미터 - sp_insert_personal_excel_info
```
sysId, windId, viewSeq, viewType, colId, colDesc, exceColId, style,
excelDown, mergCode, useYn, useRemk, gsUserId
```

### 테스트 항목
- [ ] 화면별 개인 엑셀 설정 조회
- [ ] 신규 설정 추가
- [ ] 설정 수정 (컬럼 순서, 스타일 등)
- [ ] 설정 삭제

---

## 프로시저 사용 현황 요약

| XML 파일 | 쿼리 수 | 프로시저 사용 | 비고 |
|----------|--------|--------------|------|
| User.xml | 20 | O | 모든 쿼리 프로시저 사용 |
| Group.xml | 15 | O | 모든 쿼리 프로시저 사용 |
| Program.xml | 30 | O | 대부분 프로시저, 일부 CALL 직접호출 |
| Menu.xml | 16 | O | 모든 쿼리 프로시저 사용 |
| Password.xml | 9 | O | 모든 쿼리 프로시저 사용 |
| UserSecure.xml | 6 | O | 모든 쿼리 프로시저 사용 |
| UserLog.xml | 4 | O | 모든 쿼리 프로시저 사용 |
| UserLogList.xml | 5 | O | insert만 CALL 직접호출 |
| BatchWork.xml | 5 | O | 모든 쿼리 프로시저 사용 |
| BatchWorkRevise.xml | 4 | O | 모든 쿼리 프로시저 사용 |
| BatchStatus.xml | 3 | O | 모든 쿼리 프로시저 사용 |
| JobHist.xml | 7 | O | 모든 쿼리 프로시저 사용 |
| EmailInsert.xml | 2 | O | 모든 쿼리 프로시저 사용 |
| ExcelInfo.xml | 7 | O | 모든 쿼리 프로시저 사용 |
| PersonalExcelInfo.xml | 7 | △ | CALL 직접호출 (statementType 미지정) |

---

## 권한 칼럼 설명

| 권한 코드 | 컬럼명 | 의미 | 설명 |
|----------|-------|------|------|
| A | TRAN_A | 기본조회 | 화면 기본 접근/조회 권한 |
| C | TRAN_C | 등록 | 데이터 신규 등록(Create) 권한 |
| R | TRAN_R | 조회 | 상세 조회(Read) 권한 |
| U | TRAN_U | 수정 | 데이터 수정(Update) 권한 |
| D | TRAN_D | 삭제 | 데이터 삭제(Delete) 권한 |
| P | TRAN_P | 인쇄 | 인쇄/출력(Print) 권한 |
| S | TRAN_S | 특수 | 특수 기능(Special) 권한 |
| 1 | TRAN_1 | 추가권한1 | 업무별 맞춤 권한 |
| 2 | TRAN_2 | 추가권한2 | 업무별 맞춤 권한 |
| 3 | TRAN_3 | 추가권한3 | 업무별 맞춤 권한 |
| 4 | TRAN_4 | 추가권한4 | 업무별 맞춤 권한 |
| 5 | TRAN_5 | 추가권한5 | 업무별 맞춤 권한 |

---

## 테스트 체크리스트

### 1단계: 기본 관리 화면
- [ ] `/common/user/user.do` - 사용자 관리 CRUD
- [ ] `/common/user/group.do` - 그룹 관리 CRUD
- [ ] `/common/user/program.do` - 프로그램 관리 CRUD
- [ ] `/common/user/menu.do` - 메뉴 관리 CRUD

### 2단계: 권한 매핑 화면
- [ ] `/common/user/usergroup.do` - 사용자-그룹 매핑
- [ ] `/common/user/groupprogram.do` - 그룹-프로그램 권한
- [ ] `/common/user/userprogram.do` - 사용자-프로그램 권한

### 3단계: 조회 전용 화면
- [ ] `/common/user/userprogramlist.do` - 사용자-화면 현황 조회
- [ ] `/common/user/programlistuser.do` - 프로그램-사용자 현황 조회
- [ ] `/common/user/userlog.do` - 사용자 로그 조회
- [ ] `/common/user/userloglist.do` - 사용자 로그 목록 조회

### 4단계: 비밀번호/인증 관리
- [ ] `/common/password/password.do` - 비밀번호 초기화 (관리자)
- [ ] `/common/password/userpassword.do` - 비밀번호 변경 (사용자)
- [ ] 자동로그인 보안키 동작 확인

### 5단계: 배치/작업 관리
- [ ] `/common/user/batchwork.do` - 배치 작업 관리
- [ ] `/common/user/batchworkrevise.do` - 배치 작업 수정
- [ ] `/common/user/batchstatus.do` - 배치 실행 상태
- [ ] `/common/jobhist/jobhist.do` - 작업 이력 조회

### 6단계: 기타 설정
- [ ] `/common/emailinsert/emailinsert.do` - 이메일 설정
- [ ] `/common/user/excelinfo.do` - 엑셀 설정
- [ ] `/common/user/personalexcelinfo.do` - 개인 엑셀 설정
- [ ] 자주사용 메뉴 동작 확인

---

## 공통 API 패턴

모든 화면은 다음의 표준 API 패턴을 따릅니다:

| 작업 | API URL 패턴 | HTTP Method |
|------|-------------|-------------|
| 검색 | `/common/user/{기능}/search.json` | POST |
| 조회 | `/common/user/{기능}/select.json` | POST |
| 저장 | `/common/user/{기능}/save.json` | POST |
| 삭제 | `/common/user/{기능}/delete.json` | POST |
| 엑셀 | `/common/user/{기능}/download.do` | GET |
| 목록 | `/common/user/{기능}/select{기능}List.json` | POST |

---

## 기타 프로시저 (User.xml)

User.xml에 포함된 전시회 관련 프로시저:

| 기능 | XML 쿼리 ID | 프로시저명 |
|------|------------|-----------|
| 전시회 이미지 조회 | getExhbnImg | `sp_get_exhbn_image` |
| 전시회 상태 조회 | getExhbnStates | `sp_get_exhbn_States` |
| 전시회 상태 조회2 | getExhbnStates2 | `sp_get_exhbn_States2` |
| 쿠폰 정보 조회 | getCouponInfo | `sp_get_exhbn_coupon_info` |
| 메일 체크 | getMailCheck | `sp_get_exhbn_mail_check` |
| 고객 정보 저장 | saveCustInfo | `sp_save_exhbn_cust_info` |
| 쿠폰 카운트 | getCouponCnt | `sp_get_exhbn_coupon_cnt` |
| 기존 ID 조회 | getSelectOldId | `SP_GET_SELECT_OLD_ID` |

---

## 기타 프로시저 (Program.xml)

Program.xml에 포함된 추가 프로시저:

| 기능 | XML 쿼리 ID | 프로시저명 |
|------|------------|-----------|
| 윈도우 메시지 | getWindowMsg | `SP_GET_WINDOW_MSG` |
| PayPal 여부 | getPaypalYn | `sp_get_paypal_yn` |
| 프로모션 이름 | getPromoName | `sp_select_promo_name` |

---

## 기타 프로시저 (Password.xml)

Password.xml에 포함된 추가 프로시저:

| 기능 | XML 쿼리 ID | 프로시저명 |
|------|------------|-----------|
| 게이트패스 거부 | RejectCheck | `sp_update_gate_pass_reject` |
