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
				$("#update-button").bind("click", doUpdate);
				//삭제버튼 클릭시 이벤트 바인딩
				$("#remove-button").bind("click", doRemove);

				doLangSettingTable();

			});
		});
	});
});

$(window).load(function() {

	setTimeout(function (){
		
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					doSearch();
				}
			});
		});
		
		$(".easyui-combobox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.combobox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					doSearch();
				}
			});
		});

		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
		//$("#search-button").bind("click", doSearch);
		//엑셀버튼 클릭시 이벤트 바인딩
		//$("#excel-button").bind("click", doExcel);
		//삭제버튼 클릭시 이벤트 바인딩
		//$("#remove-button").bind("click", doRemove);
		//추가버튼 클릭시 이벤트 바인딩
		//$("#append-button").bind("click", doAppend);
		//저장버튼 클릭시 이벤트 바인딩
		//$("#save-button"  ).bind("click", doSave);
		//초기화버튼 클릭시 이벤트바인딩
		//$("#dreload-button"  ).bind("click", doReload);

		//Enter 검색을 위한 추가
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keyup', function(e){
				itemid.textbox('setValue', $(this).val());
			});
		});

		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			$(".easyui-textbox").each(function(index, item){
				var itemid = $("#"+item.id);
				itemid.textbox('textbox').bind('keyup', function(e){
					itemid.textbox('setValue', $(this).val());
				});
			});
			if(events.keyCode == 13){
				doSearch();
			}
		});

	}, 100);

	doLangSettingTable();

});

//화면컨트롤
consts = {
	title: false,      //제목
	url: {
		list:   getUrl("/common/board/partsales/partsales.do"),
		select: getUrl("/common/board/partsales/select.json"),
		remove: getUrl("/common/board/partsales/delete.json"),
		save:   getUrl("/common/board/partsales/save.json"),
		form:   getUrl("/common/board/partsales/form.do"),
		view:   getUrl("/common/board/partsales/view.do")
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

function doUpdate() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	jboard.doUpdate();
}

function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	jboard.doRemove();
}