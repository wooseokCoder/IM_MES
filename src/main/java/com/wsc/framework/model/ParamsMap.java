/*
 * @(#)Params.java 1.0 2014/07/25
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.model;

import org.springframework.web.multipart.MultipartFile;

import com.wsc.framework.base.BaseMap;

/**
 * 파라메터 모델 클래스이다.
 *
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class ParamsMap extends BaseMap {
    /**
     * 시리얼 버전 아이디
     */
    private static final long serialVersionUID = 1L;

    /**
     * 디폴트 페이지 번호
     */
    public static final int DEFAULT_PAGE = 1;

    /**
     * 디폴트 페이지 크기
     */
    public static final int DEFAULT_ROWS = 50;

    /**
     * 브라우저
     */
    public static final String BROWSER = "browser";

    public static final String SYS_ID = "sysId";

    public static final String MODELS = "models";

    public static final String MODEL_LIST = "modelList";

    /**
     * 시스템 아이디
     */
    public static final String GS_SYS_ID = "gsSysId";

    /**
     * 사용자 아이디
     */
    public static final String GS_USER_ID = "gsUserId";

    /**
     * 사용자 이름
     */
    public static final String GS_USER_NAME = "gsUserName";

    /**
     * 사용자그룹 아이디
     */
    public static final String GS_GROUPS = "gsGroups";

    /**
     * 사용자 최상위메뉴 구분
     */
    public static final String GS_MENU_SET = "gsMenuSet";

    /**
     * 사용자 메뉴그룹
     */
    public static final String GS_MENU_TYPE = "gsMenuType";

    /**
     * 사용자 모바일 구분
     */
    public static final String GS_MOBILE_TYPE = "gsMobileType";

    /**
     * 관리자 여부
     */
    public static final String GS_ADMIN = "gsAdmin";

    /**
     * 정렬 정보
     */
    public static final String SORT = "sort";

    /**
     * 정렬 정보
     */
    public static final String ORDER = "order";

    /**
     * 정렬 컬럼
     */
    public static final String GS_SORTS = "gsSorts";

    /**
     * 파일 일련번호
     */
    public static final String FILE_NO = "file_no";

    /**
     * 파일 경로
     */
    public static final String FILE_PATH = "file_path";

    /**
     * 파일 이름
     */
    public static final String FILE_NAME = "file_name";

    /**
     * 파일 크기
     */
    public static final String FILE_SIZE = "file_size";

    /**
     * 파일 코드
     */
    public static final String FILE_CODE = "file_code";

    /**
     * 문서 코드
     */
    public static final String DOCU_CODE = "docu_code";

    /**
     * 문서 일련번호
     */
    public static final String DOCU_NO = "docu_no";

    /**
     * 언어 셋팅
     */
    public static final String GS_LANG = "gsLang";

    /**
     * 내수 외수
     */
    public static final String GS_USER_TYPE = "gsUserType";
    
    /**
     * 업무담당
     */
    public static final String GS_ORG_AUTH_CODE = "gsOrgAuthCode";
    
    /**
     * 데이터 권한
     */
    public static final String GS_SPC_AUTH_CODE = "gsSpcAuthCode";
    /*
     * 인덱스 페이지 유저 타입
     * */
    public static final String GS_DASH_TYPE = "gsDashType";
    

    /**
     * 값을 추가한다.
     *
     * @param key 키
     * @param value 값
     * @return 기존 값
     */
    public Object add(Object key, Object value) {
        if (value instanceof Object[]) {
            Object[] values = (Object[]) value;

            if (values.length == 1) {
                return put(key, values[0]);
            }
        }

        return put(key, value);
    }

    /**
     * 브라우저를 반환한다.
     *
     * @return 브라우저
     */
    public String getBrowser() {
        return getString(BROWSER);
    }

    /**
     * 언어 코드 반환.
     *
     * @return 사용자 아이디
     */
    public String getLang() {
        return getString(GS_LANG);
    }

    /**
     * 사용자 아이디를 반환한다.
     *
     * @return 사용자 아이디
     */
    public String getUserId() {
        return getString(GS_USER_ID);
    }
    /**
     * 사용자 최상위메뉴 구분을 반환한다.
     *
     * @return 메뉴그룹
     */
    public String getMenuSet() {
        return getString(GS_MENU_SET);
    }
    /**
     * 사용자 메뉴그룹을 반환한다.
     *
     * @return 메뉴그룹
     */
    public String getMenuType() {
        return getString(GS_MENU_TYPE);
    }
    /**
     * 사용자 모바일구분을 반환한다.
     *
     * @return 모바일구분
     */
    public String getMobileType() {
        return getString(GS_MOBILE_TYPE);
    }
    /**
     * 사용자 이름을 반환한다.
     *
     * @return 사용자 이름
     */
    public String getUserName() {
        return getString(GS_USER_NAME);
    }


    /**
     * 역할 아이디를 반환한다.
     *
     * @return 역할 아이디
     */
    public String[] getGroups() {
        return getStringArray(GS_GROUPS);
    }

    /**
     * 페이지 번호를 반환한다.
     *
     * @return 페이지 번호
     */
    public int getPage() {
        return getInt(PagingMap.PAGE, DEFAULT_PAGE);
    }

    /**
     * 페이지 크기를 반환한다.
     *
     * @return 페이지 크기
     */
    public int getRows() {
        return getInt(PagingMap.ROWS, DEFAULT_ROWS);
    }

    /**
     * 파일을 반환한다.
     *
     * @param key 키
     * @return 파일
     */
    public MultipartFile getFile(String key) {
        return (MultipartFile) get(key);
    }

    /**
     * 파일 배열을 반환한다.
     *
     * @param key 키
     * @return 파일 배열
     */
    public MultipartFile[] getFileArray(String key) {
        Object value = get(key);

        if (value instanceof MultipartFile[]) {
            return (MultipartFile[]) value;
        }

        if (value instanceof MultipartFile) {
            return new MultipartFile[] { (MultipartFile) value };
        }

        return new MultipartFile[0];
    }
}