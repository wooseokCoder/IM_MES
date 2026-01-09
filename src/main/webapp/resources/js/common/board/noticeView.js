/**
 * 공지사항 등록,수정을 처리하는 스크립트이다.
 */

//화면 컨트롤 객체
var consts = {};

$(function() {

	using("../../js/module/jupload.js", function() {
		using("../../js/module/jeditor.js", function() {
			using("../../js/module/jboard.js", function() {
				consts.init();

				//목록버튼 클릭시 이벤트 바인딩
				$("#list-button").bind("click",   jboard.doList);
				//수정버튼 클릭시 이벤트 바인딩
				$("#update-button").bind("click", jboard.doUpdate);
				//삭제버튼 클릭시 이벤트 바인딩
				$("#remove-button").bind("click", jboard.doRemove);

				doLangSettingTable();

			});
		});
	});
});

//화면컨트롤
consts = {
	title: false,      //제목
	url: {
		list:   getUrl("/common/board/notice/notice.do"),
		select: getUrl("/common/board/notice/select.json"),
		remove: getUrl("/common/board/notice/delete.json"),
		save:   getUrl("/common/board/notice/save.json"),
		form:   getUrl("/common/board/notice/form.do"),
		view:   getUrl("/common/board/notice/view.do")
	},
	params: {
		oper:     jstatus.READ,
		sysId:    null,
		title:    null,
		bordNo:   null,
		bordGrup: null,
		bordType: null
	},
	init: function() {

		var rform = "select-form";
		var sform = "hidden-form";

		jboard.initView({
			consts: this,
			url:    this.url,
			params: this.params,
			title:  this.title,
			//편집 모드
			mode: "select",
			//목록폼 KEY
			listKey: "#"+sform,
			//등록폼 KEY (#포함)
			formKey: "#"+rform,
			//첨부파일 레이어 KEY
			layoutKey: "select-fileupload",
			//첨부파일 그리드 KEY
			gridKey: "files-grid",
			//Form Hidden Value 정의
			setHiddenValues: function(params) {
				$("#v_sysId"   ).val (params.sysId);
				$("#v_oper"    ).val (params.oper);
				$("#v_bordNo"  ).val (params.bordNo);
				$("#v_bordGrup").val (params.bordGrup);
				$("#v_bordType").val (params.bordType);
			}
		});
	},
	//저장,삭제 후 이동처리
	doResult: function(res, callback) {
		jboard.doList();
	}
};

//화면 상수값 초기화
function doInit(args) {
	if (args)
		$.extend(consts.params, args);
	if (args.title)
		consts.title = args.title;
}
