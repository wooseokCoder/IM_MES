//초기 선언해 주는 부분
var consts = {
	title: "Drawing Information Detail",      //제목
	url: {
		list:   getUrl("/common/drawing/drawinginformationdetail.do"),
		save:   getUrl("/common/drawing/drawinginformationdetail/save.json")
	},
	params: {
		oper:     jstatus.INSERT,
		sysId:    null,
		title:    null,
		bordNo:   null,
		bordGrup: 'DI'
	},
	init: function() {

		var rform = "regist-form";
		var sform = "hidden-form";
		var panel = "regist-panel";
		jboard.initForm2({
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
			//Form Hidden Value 정의
			setHiddenValues: function(params) {
				$("#r_sysId"   ).val (params.sysId);
				$("#r_oper"    ).val (params.oper);
				$("#r_bordNo"  ).val (params.bordNo);
				$("#r_bordGrup").val (params.bordGrup);
			}
		});
	},
	//저장,삭제 후 이동처리
	doResult: function(res, callback) {
		
	}
};

$(function() {
	using("../../js/module/jupload3.js", function() {
		using("../../js/module/jboard.js", function() {
			consts.init();
		});
	});
});


$(window).load(function() {
	setTimeout(function (){

		$(".wui-dialog").show();
		
		$("#account-layout").fadeIn(300);
		
		$("#item-create").bind("click", btnCreate);
		
		$("#item-save").bind("click", doSubmit);
		
		$("#item-list").bind("click", goToList);
		
		$('#progress-popup').dialog({
		   title: tit.TITLE0009,
		   top:     100,
		   width: 200,
		   height: 200,
		   closed: true,
		   modal: true,
		   resizable: false
		});
		doSelect();
	}, 100);
});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//에디트 시작
function doBeginEdit(rowIndex, rowData){
	var editors = $('#search-grid').datagrid('getEditors', rowIndex);
}

//버튼을 만드는 함수
function btnCreate(){
	// input의 value 값
	var myInput = Number(document.getElementById('myInput').value);
	var items = "";
	var inputs = "";
	var submitForm = document.getElementById('regist-form');
	numBox = new Array(myInput);
	toolArr = new Array(myInput);
	$("#regist-form").find("#r_applId").nextAll().remove();
	for(var i = 0; i < myInput; i++){
		items += "<div class='drawing-items'>";
		items += "	<p style='margin-bottom: 0; font-weight: bold;'>#" + (i + 1) + "</p>";
		items += "	<input type='checkbox' onclick='drawSet(" + i + ")' id='toggle" + i + "' class='powerButton' value='off'/>";
		items += "	<label for='toggle" + i + "' class='toggleSwitch'>";
		items += "		<span class='toggleButton'></span>";
		items += "	</label>";
		items += "</div>";
		items += "<table class='drawing-item drawing-content'>";
		items += "	<colgroup>";
		items += "		<col width='20%' />";
		items += "		<col width='80%' />";
		items += "	</colgroup>"
		items += "	<tr>";
		items += "		<td>Type</td>";
		items += "		<td>";
		items += "			<select id='itemType" + i + "' class='ex-style' data-options=\"height: 30, panelHeight:'auto'\" style='width: 100%;'>";
		items += "				<option value=''> -- choice -- </option>";
		items += "				<option value='Product'>Product</option>";
		items += "				<option value='Assembly'>Assembly</option>";
		items += "			</select>";
		items += "		</td>";
		items += "	</tr>";
		items += "	<tr>";
		items += "		<td>Code</td>";
		items += "		<td>";
		items += "			<input type='text' name='itemCode' id='itemCode" + i + "' class='ex-style' />";
		items += "		</td>";
		items += "	</tr>";
		items += "	<tr>";
		items += "		<td>Name</td>";
		items += "		<td>";
		items += "			<input type='text' name='itemName' id='itemName" + i + "' class='ex-style' />";
		items += "		</td>";
		items += "	</tr>";
		items += "</table>";
		submitForm.innerHTML += "<input type='hidden' name='num'   id='num" + i + "'   value=''/>";
		submitForm.innerHTML += "<input type='hidden' name='boxX'  id='boxX" + i + "'  value=''/>";
		submitForm.innerHTML += "<input type='hidden' name='boxY'  id='boxY" + i + "'  value=''/>";
		submitForm.innerHTML += "<input type='hidden' name='toolX' id='toolX" + i + "' value=''/>";
		submitForm.innerHTML += "<input type='hidden' name='toolY' id='toolY" + i + "' value=''/>";
	}
	//debugger;
	$("#power").html(items);
	$('.toggleSwitch').click(function(){
		$(this).toggleClass("active");
	});
}

function doSubmit(){
	var itemType = [];
    var itemCode = [];
    var itemName = [];
    var itemUse = [];
    
    for(var j = 0; j < numBox.length; j++){
        if(numBox[j] != null){
        	$("#boxX" + j).val(numBox[j].x);
        	$("#boxY" + j).val(numBox[j].y);
        	$("#num" + j).val(numBox[j].num);
        	$("#toolX" + j).val(numBox[j].x + 70);
        	$("#toolY" + j).val(numBox[j].y - 7.5);
        }
        itemType.push($("#itemType" + j).val());
        itemCode.push($("#itemCode" + j).val());
        itemName.push($("#itemName" + j).val());
        itemUse.push($("#toggle" + j).val());
    }
    
	var form1 = $("#regist-form").serializeObject();
	var _files = jupload.files;
	form1.files = JSON.stringify(_files);
	var data1 = {
		listType: $("#listType").val(),
		listCode: $("#codeSearch").val(),
		listName: $("#nameSearch").val()
	}
	var data2 = {
		itemType : itemType,
		itemCode : itemCode,
		itemName : itemName,
		itemUse  : itemUse 
	}
	
	setTimeout(function (){
		$.ajax({
			url: getUrl("/common/drawing/drawinginformationdetail/submit.json"),
	        dataType: "json",
	        type: 'post',
	        data: $.extend({}, form1, data1, data2),
	        success: function(result) {
	        	$.messager.show({
					title: 'Information',
					msg: 'Submit completed.'
				});
	        },
	        error:  function(result) {
	        }
		});
	},100);
}

function goToList(){
	location.href=getUrl("/common/drawing/drawinginformation.do");
}
