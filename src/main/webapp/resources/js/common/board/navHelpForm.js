/**
 * Help 등록,수정을 처리하는 스크립트이다.
 */

//화면 컨트롤 객체
var consts = {};
var editType = "";

$(function() {

	using("../../js/module/jupload.js", function() {
		using("../../js/module/jeditor.js", function() {
			using("../../js/module/jboard.js", function() {

				consts.init();

				//목록버튼 클릭시 이벤트 바인딩
				$("#list-button").bind("click",   jboard.doList);
				//저장버튼 클릭시 이벤트 바인딩
				$("#save-button").bind("click",   doSave);
				//삭제버튼 클릭시 이벤트 바인딩
				$("#remove-button").bind("click", doRemove);
				//닫기버튼 클릭시 이벤트 바인딩
				$("#close-button").bind("click", doClose);
				//상세보기 버튼 클릭시 이벤트 바인딩
				$("#view-button").bind("click", doView);

				doLangSettingTable();
				
				
			});
		});
	});
});

//화면컨트롤
consts = {
	title: "Help",      //제목
	url: {
		list:   getUrl("/common/board/navHelp/navHelp.do"),
		select: getUrl("/common/board/navHelp/select.json"),
		remove: getUrl("/common/board/navHelp/delete.json"),
		save:   getUrl("/common/board/navHelp/save.json"),
		form:   getUrl("/common/board/navHelp/form.do"),
		view:   getUrl("/common/board/navHelp/view.do")
	},
	params: {
		oper:     jstatus.INSERT,
		sysId:    null,
		title:    null,
		bordNo:   null,
		bordGrup: null,
		bordType: null
	},
	init: function() {

		var rform = "regist-form";
		var sform = "hidden-form";
		var panel = "regist-panel";
		jboard.initForm({
			consts: this,
			url:    this.url,
			params: this.params,
			title:  this.title,
			//편집패널 KEY
			panelKey: "#"+panel,
			//목록폼 KEY
			listKey: "#"+sform,
			//편집 모드
			mode: "regist",
			//등록폼 KEY (#포함)
			formKey: "#"+rform,
			//첨부파일 레이어 KEY
			layoutKey: "regist-fileupload",
			//첨부파일 업로더 KEY
			loaderKey: "uploader",
			//첨부파일 INPUT 명칭
			fileName: "files",
			//웹에디터 레이어 ID
			editorLayer: "editor-area",
			//웹에디터 텍스트박스 ID
			editorBox:   "r_bordText",
			//웹에디터 폼 ID
			editorForm: rform,
			//Form Hidden Value 정의
			setHiddenValues: function(params) {
				$("#r_sysId"   ).val (params.sysId);
				$("#r_oper"    ).val (params.oper);
				$("#r_bordNo"  ).val (params.bordNo);
				$("#r_bordGrup").val (params.bordGrup);
				$("#r_bordType").val (params.bordType);
				$("#r_bordTitle").val (params.bordTitle);
			},localBindEvent: function(data){
				//$("#h_thumbnail").val(data.thumbNail);
				//console.log($("#h_thumbnail").val()+'******')
				
				setTimeout(function (){
					/*$(":checkbox[name=thumbnail]").each(function(index,item){
						var target = $(item).closest('div.ajax-file-upload-statusbar').find('div.ajax-file-upload-filename').html().split('. ')[1];
						console.log($("#h_thumbnail").val()+'***loop***'+target)
						if(target == $("#h_thumbnail").val()){
							$(item).prop("checked", true);
						}
					});*/
					doLangSettingTable();
					
				}, 100);
				
			},
			afterSelect : function(data) {
				//타이틀 넣어주기
				if($("#r_bordTitle").val() != '') {
					$("#bordTitleSpan").text($("#r_bordTitle").val());
				}
			}
		});
	},
	//저장,삭제 후 이동처리
	doResult: function(res, callback) {
		//jboard.doList();
		$.messager.alert(msg.MSG0123, res.success, msg.MSG0123, function() {
			if(editType == "D") {
				doClose();
			}
			else {
				//view화면으로 이동
				if($("#r_menuKey").val() != '') {
					window.location.href = context + "/common/board/navHelp/view.do?menuKey=" + $("#r_menuKey").val();
				}
				else {
					window.location.href = context + "/common/board/navHelp/view.do?bordNo=" + $("#r_bordNo").val();
				}
			}
			
		});
	}
};

//화면 상수값 초기화
function doInit(args) {
	if (args)
		$.extend(consts.params, args);
	if (args.title)
		consts.title = args.title;
}

function doSave() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	
	//타이틀 넣어주기
	$("#r_bordTitle").val($("#r_bordTitleTemp").val());
	
	//썸네일 체크
	/*if($('input[name="thumbnail"]:checkbox:checked').length == 0 ){
		$("#h_thumbnail").val('');
		alert(msg.MSG0138);
		return;
	}*/
	editType = "S";
	
	jboard.doSave();
}

function fnChangeTn(obj){
	var oldfileNm = $("#h_thumbnail").val();
	var newItem =  $(obj).closest('div.ajax-file-upload-statusbar').find('div.ajax-file-upload-filename').html();
	var target;
	
	if(obj.checked){
		var fileNm = newItem.split('. ')[1];
		$("#h_thumbnail").val(fileNm);
		
		$(":checkbox[name=thumbnail]").each(function(index,item){
			target = $(item).closest('div.ajax-file-upload-statusbar').find('div.ajax-file-upload-filename').html();
			if(target != newItem){
				$(item).prop("checked", false);
			}
		});
	}else{
		$("#h_thumbnail").val('');
	}
}

function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	editType = "D";
	
	jboard.doRemove();
}

function doClose() {
	window.close();
}

function doView() {
	window.location.href = context + '/common/board/navHelp/view.do?bordNo='+$("#r_bordNo").val();
}
