/**
 * 코드관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 패널 상세조회
 * 폼 패널 등록,수정,삭제
 */
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
		doLink('http://lws.lsmtron.com/');
	}
};

$(function() {

	consts.init();
	//저장버튼 클릭시 이벤트 바인딩
	//$("#save-button").bind("click", doSave);
	doLangSettingPage();

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

function doLink(url) {
    var win = window.open(url, '_blank');
    console.log($(window.parent.document.getElementsByClassName('tabs-selected')).children('.tabs-close'));
    $(window.parent.document.getElementsByClassName('tabs-selected')).children('.tabs-close')[0].click();
    win.focus();
}

