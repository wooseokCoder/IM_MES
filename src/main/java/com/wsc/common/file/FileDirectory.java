package com.wsc.common.file;

import com.wsc.common.Consts;
import com.wsc.framework.utils.FileUtils;

public enum FileDirectory {

	ROOT         ("",          "ROOT", "기본경로"),
	SAMPLE       ("/sample", "SAMPLE", "샘플경로"),
	BOARD_NOTICE ("/board01",   "B01", "공지사항"),
	BOARD_GENERAL("/board02",   "B02", "일반게시판"),
	BOARD_DATA   ("/board03",   "B03", "자료실"),
	BOARD_QNA    ("/board04",   "B04", "Q&A"),
	BOARD_OFFICAL("/board05",   "B05", "공문"),
	BOARD_POPUP  ("/board06",   "B06", "팝업"),
	BOARD_EMAIL  ("/board07",   "B07", "전자메일"),
	BOARD_ALTER  ("/board08",   "B08", "알림방"),
	BOARD_MAIL   ("/board09",   "B09", "메일발송"),
	BOARD_HELP   ("/board10",   "B10", "도움말관리"),
	BOARD_MEMO   ("/board11",   "B11", "사용자메모"),
	SAMPLE_BOARD ("/board12",   "B12", "샘플게시판"),
	INTERNAL     ("/board13",   "B13", "공문발송"),
	BOARD_IMAGE  ("/board14",   "B14", "이미지"),
	BOARD_VIDEO  ("/board15",   "B15", "동영상"),
	BOARD_GUESTBOOK("/board16", "B16", "방명록"),
	MOLD_REGI    ("/MOLD"	,   "MOLD", "금형등록"),
	BOARD_LSNEWS ("/NEWS"	,   "B17", "LS NEWS"),
	BOARD_SALEPROG("/SALEPROG", "B18", "SALE PROGRAM"),
	BOARD_SALEINFO("/SALEINFO", "B19", "SALE INFORMATION"),
	BOARD_LSDATA ("/MANUAL"	,   "B20", "MANUAL"),
	BOARD_MARKETING ("/MARKETING"	,   "B21", "MARKETING"),
	BOARD_USEEQU ("/USEEQU"	,   "B22", "USEDEQUIPMENT"),
	BOARD_FORMS ("/FORMS"	,   "B23", "FORMS"),
	MONTHLY_STATEMENT ("/MONTHLY"	,   "F01", "MonthlyStatement"),
	BOARD_SALEBULL("/SALEBULL", "B24", "SALE BULLETIN"),
	COOP_REQUEST ("/CoOp"	,   "COOP", "CO-OP REQUEST"),
	BOARD_TRAINING("/TRAINING", "B25", "TRAINING"),
	SCHEDULE ("/SCHEDULE", "B26", "SCHEDULE"),
	CERTIFICATION ("/Certification", "B27", "CERTIFICATION"),
	BOARD_SVCBULL("/SVCBULL", "B28", "SVC BULLETIN"),
	MARKETING_NEWS ("/MarketingNews", "B29", "MARKETING_NEWS"),
	BROCHURES("/BROCHURES", "B30", "BROCHURES"),
	PART_SALES("/PARTSALES", "B31", "PART SALES"),
	RETN_TRANS("/RETN_TRANS", "RT", "RETN TRANS"),
	DAEL_APPL("/DEAL_APPL", "DA", "DEALER APPLICATION"),
	AF("/AF", "AF", "APPLICATION FILE"),
	SF("/SF", "SF", "SIGN FILE"),
	DB("/DB", "DB", "DASHBOARD REG"),
	DI("/DI", "DI", "DRAWING INFO"),
	CHK_LIST("/CHK_LIST", "CHK_LIST", "CHK_LIST"),
	SAR_FILE("/SAR_FILE", "SAR", "ASSESSMENT"),
	OWP("/OWP", "OWP", "OWP FILE"),
	
	BOARD_NAVHELP ("/NAVHELP"	,   "H01", "HELP");
	
    private String code;
	private String name;
	private String path;

	private FileDirectory(String path, String code, String name) {
		this.path = path;
		this.code = code;
		this.name = name;
	}

	public String getCode() {
		return code;
	}
	public String getPath() {
		return path;
	}
	public String getName() {
		return name;
	}
	public String getTempPath() {
		return Consts.UPLOAD_TEMP_DIR;
	}
	public String getRealPath() {
		return FileUtils.mergePath(Consts.UPLOAD_REAL_DIR, path);
	}
	
	public String getImagePath() {
		return FileUtils.mergePath(Consts.UPLOAD_IMAGE_DIR, path);
	}

	public String getRealName(String fileName) {
		return FileUtils.mergePath(getRealPath(), fileName);
	}
	public String getTempName(String fileName) {
		return FileUtils.mergePath(getTempPath(), fileName);
	}
	public String getImageName(String fileName) {
		return FileUtils.mergePath(getImagePath(), fileName);
	}

	public static FileDirectory get(String code) {

		if (code == null)
			return null;

		for (FileDirectory c : values()) {
			if (code.equals(c.getCode()))
				return c;
		}
		return null;
	}
}
