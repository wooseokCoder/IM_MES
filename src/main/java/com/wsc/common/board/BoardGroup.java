package com.wsc.common.board;

import com.wsc.common.code.CacheComponent;
import com.wsc.common.model.Code;
import com.wsc.framework.model.ParamsMap;

public enum BoardGroup {

	NOTICE  ("B01", "ALL", "공지사항"),
	GENERAL ("B02", "ALL", "일반게시판"),
	DATA    ("B03", "ALL", "자료실"),
	QNA     ("B04", "ALL", "Q&A"),
	OFFICAL ("B05", "ALL", "공문"),
	POPUP   ("B06", "ALL", "팝업"),
	EMAIL   ("B07", "USR", "전자메일"),
	ALTER   ("B08", "ALL", "알림방"),
	MAIL    ("B09", "ALL", "메일발송"),
	HELP    ("B10", "HEP", "도움말관리"),
	MEMO    ("B11", "HEP", "사용자메모"),
	INTERNAL("B13", "ALL", "공문발송"),
	SAMPLE_BOARD  ("B12", "ALL", "샘플게시판"),
	IMAGE   ("B14", "ALL", "이미지"),
	VIDEO   ("B15", "ALL", "동영상"),
	GUESTBOOK("B16", "ALL", "방명록"),
	LSNEWS	("B17", "ALL", "LS NEWS"),
	SALEPROG("B18", "ALL", "SALE PROGRAM"),
	SALEINFO("B19", "ALL", "SALE INFORMATION"),
	LSDATA  ("B20", "ALL", "MANUAL"),
	MARKETING("B21", "ALL", "MARKETING"),
	USEEQU("B22", "ALL", "USED EQUIPMENT"),
	FORMS("B23", "ALL", "FORMS"),
	SALEBULL("B24", "ALL", "SALE BULLETIN"),
	COOP("COOP", "ALL", "COOP REQUEST"),
	TRAINING("B25", "ALL", "TRAINING"),
	SCHEDULE("B26", "ALL", "SCHEDULE"),
	SVCBULL("B28", "ALL", "SVC BULLETIN"),
	MARKETING_NEWS("B29", "ALL", "MARKETING NEWS"),
	BROCHURES("B30", "ALL", "BROCHURES"),
	PARTSALES("B31", "ALL", "PART SALES"),
	RETN_TRANS("RT", "ALL", "RETN TRANS"),
	DEAL_APPL("DA", "ALL", "DEALER APPLICATION"),
	DRAW_INFO("DI", "ALL", "DRAWING INFORMATION"),
	CHK_LIST("CHK_LIST", "ALL", "CHECK LIST"),
	SAR_FILE("SAR", "ALL", "ASSESSMENT"),
	
	NOTIFICATION("N01", "ALL", "알림"),
	NAV_HELP("H01", "ALL", "매뉴얼");
	
	private String code;
	private String type;
	private String name;

	private BoardGroup(String code, String type, String name) {
		this.code = code;
		this.type = type;
		this.name = name;
	}

	public String getCode() {
		return code;
	}

	public String getType() {
		return type;
	}

	public String getName() {
		return name;
	}

	//게시판 기본셋팅
	public void bindParams(ParamsMap params, CacheComponent cache) {
		if (params.containsKey("bordGrup") == false) {
			params.put("bordGrup", getCode());
			params.put("bordType", getType());
		}
		Code c = cache.getCode(params.getString(ParamsMap.SYS_ID), "BORD_GRUP", params.getString("bordGrup"));

		if (c != null)
			params.put("bordName", c.getCodeName());
	}

}
