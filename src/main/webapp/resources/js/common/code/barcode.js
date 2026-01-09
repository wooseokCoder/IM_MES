var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		//save:   getUrl("/common/code/save.json")
	},
	init: function() {
		//등록폼 초기화
		doClear();
	}
};

$(function() {

	consts.init();

});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//초기화 처리
function doClear() {
	;
}



