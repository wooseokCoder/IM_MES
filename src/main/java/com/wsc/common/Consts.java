package com.wsc.common;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.wsc.framework.utils.BaseUtils;

@Component 
public class Consts {
	
	//받은메일함 화면타입
	public static final String EMAIL_RECEIVE_TYPE = "R";
	//보낸메일함 화면타입
	public static final String EMAIL_DISPATCH_TYPE = "S";
	
	//개인주소록 타입
	public static final String ADDRESS_USERS_TYPE = "U";
	//그룹주소록 타입
	public static final String ADDRESS_GROUP_TYPE = "G";
	
	public static boolean isAddressUsersType(String type) {
		return ADDRESS_USERS_TYPE.equals(type);
	}
	public static boolean isAddressGroupType(String type) {
		return ADDRESS_GROUP_TYPE.equals(type);
	}
	
	//삭제시 비활성상태로 변경할 게시판의 타입
	public static final String[] BOARD_DISABLE_GROUPS = {"B04","B07"}; //답변게시판,전자메일
	
	public static boolean isDiableBoard(String bordGrup) {
		return BaseUtils.exist(BOARD_DISABLE_GROUPS, bordGrup);
	}
	
	//파일업로드 임시경로
	public static String UPLOAD_TEMP_DIR;
	//파일업로드 실제경로
	public static String UPLOAD_REAL_DIR;
	//보드 이미지 저장 경로
	public static String UPLOAD_IMAGE_DIR;
	
	@Value("#{app['file.upload.temp']}")
	public void setUploadTempDir(String dir) {
		Consts.UPLOAD_TEMP_DIR = dir;
	}
	@Value("#{app['file.upload.real']}")
	public void setUploadRealDir(String dir) {
		Consts.UPLOAD_REAL_DIR = dir;
	}
	@Value("#{app['file.upload.image']}")
	public void setUploadImageDir(String dir) {
		Consts.UPLOAD_IMAGE_DIR = dir;
	}
	//[일정관리] 전체공유 코드
	public static final String SHARE_ALL_CODE = "ALL";
	//[일정관리] 전체공유 명칭
	public static final String SHARE_ALL_NAME = "SHARE_ALL";
	//[일정관리] 전체공유 타입
	public static final String SHARE_ALL_TYPE = "A";
	//[일정관리] 개별공유 타입
	public static final String SHARE_USR_TYPE = "U";
	
	//엑셀로더 양식종류코드의 EXTCHAR01 조건값
	public static final String LOADER_CODE = "EXCLFORM";
	//공통코드 최상위값
	public static final String ROOT_CODE = "0";
	
	//엑셀로더 셀타입
	public static final String LOADER_CELL_BLANK   = "CELL_TYPE_BLANK";
	public static final String LOADER_CELL_FORMULA = "CELL_TYPE_FORMULA";
	public static final String LOADER_CELL_NUMERIC = "CELL_TYPE_NUMERIC";
	public static final String LOADER_CELL_STRING  = "CELL_TYPE_STRING";
	public static final String LOADER_CELL_ERROR   = "CELL_TYPE_ERROR";
	public static final String LOADER_CELL_DEFAULT = "CELL_TYPE_DEFAULT";
	
	//엑셀셀 기본타입
	public static final String LOADER_STRING = "S"; //문자
	public static final String LOADER_NUMBER = "N"; //숫자
	
	//엑셀로더 셀타입에 따른 기본타입(문자,숫자) 반환
	public static String getLoaderItemType(String cellType) {
		if (LOADER_CELL_FORMULA.equals(cellType))
			return LOADER_NUMBER;
		if (LOADER_CELL_NUMERIC.equals(cellType))
			return LOADER_NUMBER;
		return LOADER_STRING;
	}
	
	//팝업의 오픈타입에 해당하는 코드그룹
	public static final String OPEN_TYPE_CODE = "OPEN_TYPE";
}
