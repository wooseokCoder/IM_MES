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
				//저장버튼 클릭시 이벤트 바인딩
				$("#save-button").bind("click",   doSave);
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
		oper:     jstatus.INSERT,
		sysId:    null,
		title:    null,
		bordNo:   null,
		bordGrup: null,
		bordType: null
	},
	form: false,
	combo: {
		data: [],
		get: function(key) {
			for (var i=0; i<this.data.length; i++) {
				if (this.data[i].codeCd == key)
					return this.data[i];
			}
			return null;
		},
		//팝업타입의 콤보표시함수
		fn: function(item) {
			consts.combo.data.push(item);

			return {
				value: item.codeCd,
				text:  item.codeName + ' '
				    + '[ width: ' +item.extNum01 + 'px'
				    + ', height: ' +item.extNum02 + 'px'
				    + ', X coordinate: '+item.extNum03 + 'px'
				    + ', Y coordinate: '+item.extNum04 + 'px'
				    + ']'
			};
		}
	},
	init: function() {

		//팝업의 오픈타입 콤보 설정
		$("#r_openType").combobox({
			mode:'remote',
			params:{codeGrup:'OPEN_TYPE'},
			//width:100%,
			editable:false,
			required:true,
			loader:jcombo.loader,
			fn: consts.combo.fn
		});

		var rform = "regist-form";
		var sform = "hidden-form";
		var panel = "regist-panel";

		this.form = ("#"+rform);

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
			}
		});
		
		setTimeout(function (){
			var openClsChk = $("#r_openCls").val();
			$("#r_justOne").val(openClsChk);
			if(openClsChk == "Y") $("#r_justOne").prop("checked",true);
			else $("#r_justOne").prop("checked",false);
			
			$(":checkbox[name=typeKey]").each(function(index,item){
				if($("#r_bordType").val() == $(item).val()){
					$(item).prop("checked", true);
				}
			});

		}, 1000);
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

//팝업창 미리보기
function doPreview() {
	var data = jboard.getFormData();

	if (data == null)
		return;

	var type = data.openType;
	var code = consts.combo.get(type);

	if (code == null)
		return;

	jwidget.popup.open({
		preview:   true,
		enable:    true,
		useFlag:   "Y",
		bordNo:    "",
		bordTitle: data.bordTitle,
		bordText:  data.bordText,
		width:  code.extNum01,
		height: code.extNum02,
		pointX: code.extNum03,
		pointY: code.extNum04
	});
}

function doSave() {
	
	if ($(":checkbox[name='typeKey']:checked").length == 0){ 
		$.messager.alert('Warning',"Please select a Display to",'warning');
	    return false; 
	} 
	$(":checkbox[name='typeKey']:checked").each(function(){
		if($(this).val() == "USR"){
			if($("#r_targetValue").textbox("getValue") == ""){
				$.messager.alert('Warning',"Please enter Specific dealer",'warning');
				return false;
			}else{
				//존재체크
				var cnt = $("#r_targetValue").textbox("getValue");
				var cntSize = cnt.split(",").length;
				var chekcCnt;
				
				$.ajax({
				      url: getUrl('/common/board/popup/dealerCheck.json'),
				      dataType: 'json',
				      async: false,
				      type: 'post',
				      data: {
				    	  dealerList : $("#r_targetValue").textbox("getValue"),
				      },
				      success: function(data){
				    	  chekcCnt = data.rows;
				      },
				      error: function(){
				    	  chekcCnt = "0";
				      }
				  });
				
				if (chekcCnt != cntSize){
					$.messager.alert('Warning',"Please check the Specific dealer",'warning');
					return false;
				}
			}
		}
			
		jboard.doSave();
	});
	

}


function doJustOne() {
	$("#r_justOne").is(":checked")? $("#r_justOne").val("Y"):$("#r_justOne").val("N");
}

function doDialogClose(dealerList) {
	$("#dealer-popup").dialog('close');
	$("#r_targetValue").textbox('setValue', dealerList);
	$(":checkbox[name=typeKey]").each(function(index,item){
		if("USR" == $(item).val()){
			$(item).prop("checked", true);
		}else{
			$(item).prop("checked", false);
		}
	});
}

function doTargetChange(obj){
	$(":checkbox[name=typeKey]").each(function(index,item){
		if(obj.value != $(item).val()){
			$(item).prop("checked", false);
		}
	});

}
function getTarger(){
	return $("#r_targetValue").textbox('getValue');
}