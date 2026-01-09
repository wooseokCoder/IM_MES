/**
 * 사이트맵을 처리하는 스크립트이다.
 */
$(function() {
	//상단메뉴 로딩
	jwidget.menu.load(consts);
});

var consts = {
	callback: function() {
		jwidget.sitemap.load("#sitemap-panel");
	}
};

function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}
