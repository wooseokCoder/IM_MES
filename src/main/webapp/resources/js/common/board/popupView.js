/**
 * 팝업관리 스크립트이다.
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
				//미리보기버튼 클릭시 이벤트 바인딩
				$("#preview-button").bind("click", doPreview);

				doLangSettingTable();

			});
		});
	});
});

//화면컨트롤
consts = {
	title: false,      //제목
	url: {
		list:   getUrl("/common/board/popup/popup.do"),
		select: getUrl("/common/board/popup/select.json"),
		remove: getUrl("/common/board/popup/delete.json"),
		save:   getUrl("/common/board/popup/save.json"),
		form:   getUrl("/common/board/popup/form.do"),
		view:   getUrl("/common/board/popup/view.do")
	},
	params: {
		oper:     jstatus.READ,
		sysId:    null,
		title:    null,
		bordNo:   null,
		bordGrup: null,
		bordType: null,
		openCls:  null
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

//팝업창 미리보기
function doPreview() {
	//상세조회 데이터 가져오기
	var data = jboard.getViewData();

	if (data == null)
		return;

	jwidget.popup.open({
		preview:   true,
		enable:    true,
		useFlag:   "Y",
		bordNo:    "",
		bordTitle: data.bordTitle,
		bordText:  data.bordText,
		width:     data.width,
		height:    data.height,
		pointX:    data.pointX,
		pointY:    data.pointY
	});
}

//화면 상수값 초기화
function doInit(args) {
	if (args)
		$.extend(consts.params, args);
	if (args.title)
		consts.title = args.title;
}
