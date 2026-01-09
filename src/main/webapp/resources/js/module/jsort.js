/**
 * 정렬관리 모듈
 */
var sortContent = new Object();
function jSortInit(sortContentParame){
	sortContent = sortContentParame;
	$('#sort-dialog').dialog({
	    title: 'Sort',
	    iconCls: 'icon-search',
	    width: 500,
	    height: 337,
	    closed: true,
	    modal: true,
	    resizable: true
	});
	//console.log(getCookie($("#text_menuKey").val()));
	sortSetting();
}
//정렬버튼 팝업
function doSortPopup(){
	var s = $("#sort-dialog");
	for(var i=0; i < sortContent.length; i++){
		$("#aLeft"+i).removeClass("backColor");
	}
	$("#sort-order .sortul li a").each(function (index) {
		$(this).removeClass("backColor");
	});
	s.dialog('center');
	s.dialog('open');
}
//정렬 기본셋팅
function sortSetting(){
	var sl = $("#sort-div");
	var content = "<ul class=\"sortul\">";
	for(var i=0; i < sortContent.length; i++){
		content += "<li class=\"sortli\"><a href=\"javascript:doBackChange('aLeft"+i+"')\" id=\"aLeft"+i+"\" data-value=\""+sortContent[i].sortValue+"\">"+sortContent[i].sortText+"</a></li>";
		//s.append("<input onclick=\"javascript:sortValueSetting()\"  type=\"checkbox\" name=\"chk_sort\" id=\"chk_sort"+i+"\" value=\""+sortContent[i].sortValue+"\"><label for=\"chk_sort"+i+"\" >"+sortContent[i].sortText+"<label>");

		/*s.append("<div style=\"width:50%; display: inline-block; text-align:right;\"><input onclick=\"javascript:sortValueSetting()\"  type=\"checkbox\" name=\"chk_sort\" id=\"chk_sort"+i+"\" value=\""+sortContent[i].sortValue+"\"><label for=\"chk_sort"+i+"\" >"+sortContent[i].sortText+"<label><input name=\"cbox\" id=\"r_box"+i+"\"/></div>");
		s.find('#r_box'+i).combobox({width:120,mode:'remote',onChange:sortValueSetting,valueField: 'value', textField: 'label',data: [{label: '오름차순',value: 'ASC'},{label: '내림차순',value: 'DESC'}]});
		$('#r_box'+i).combobox('setValue', 'ASC');*/
	}
	content += "</ul>";
	sl.append(content);

	$("input:checkbox[id='moveChk']").prop("checked",Boolean(getCookie($("#text_menuKey").val()+"C")));
	doInitSortSetting();

}

function doInitSortSetting(){
	var status = new Array();
	if(getCookie($("#text_menuKey").val()) != ""){
		var cookieNumber = eval(getCookie($("#text_menuKey").val()));
		for(var i=0; i < cookieNumber.length; i++){
			//console.log(cookieNumber[i].no);
			doBackChange("aLeft"+cookieNumber[i].no);
			status.push({no:cookieNumber[i].no,st:cookieNumber[i].st});
		}
	}
	doMove('right');
	//console.log(status);
	for(var i=0; i < status.length; i++){
		$('#r_box'+status[i].no).combobox('setValue', status[i].st);
	}
}

//색깔변경
function doBackChange(Obj){
	if($("#"+Obj).hasClass("backColor")){
		$("#"+Obj).removeClass("backColor");
	}else{
		$("#"+Obj).addClass("backColor");
	}
}
//이동
function doMove(dir){
	var sr = $("#sort-order .sortul");
	if(dir == 'right'){
		$(".sortul li a").each(function (index) {
			if($("#aRight"+index).length == 0){
				if($(this).hasClass("backColor")){
					sr.append("<li class=\"sortli\"><a style=\"width:84px; display:inline-block\" href=\"javascript:doBackChange('aRight"+index+"')\" id=\"aRight"+index+"\" data-value=\""+$(this).data("value")+"\">"+$(this).text()+"</a><input name=\"cbox\" id=\"r_box"+index+"\"/></li>");
					sr.find('#r_box'+index).combobox({width:120,mode:'remote',onChange:sortValueSetting,valueField: 'value', textField: 'label',data: [{label: 'ASC',value: 'ASC'},{label: 'DESC',value: 'DESC'}]});
					$('#r_box'+index).combobox('setValue', 'ASC');
				}
			}
		});
	}else{
		$("#sort-order .sortul li a").each(function (index) {
			if($(this).hasClass("backColor")){
				var thisId = $(this).prop("id");
				$("#"+thisId).parent().remove();
			}
		});
	}
	setSortCookie();
	sortValueSetting();
}
function sortValueSetting(){
	var sortValue="";
	var cnt  = 0;
	$("#sort-order .sortul li a").each(function (index) {
		if($(this).data("value") != undefined && $(this).prop("id") != ""){
			var thisId = $(this).prop("id");
			var strNumber = thisId.substring(6,thisId.length);
			if(cnt == 0){
				sortValue = $(this).data("value")+" "+$("#r_box"+strNumber).combobox('getValue');
			}else{
				sortValue += ", "+$(this).data("value")+" "+$("#r_box"+strNumber).combobox('getValue');
			}
			cnt++;
		}
	});
	/*$("input:checkbox[name='chk_sort']").each(function (index) {
		if($(this).is(":checked") == true){
			if(cnt == 0){
				sortValue = $(this).val()+" "+$("#r_box"+index).combobox('getValue');
			}else{
				sortValue += ", "+$(this).val()+" "+$("#r_box"+index).combobox('getValue');
			}
			cnt++;
		}
	});*/
	$("#sortValue").val(sortValue);
	setSortCookie();
}

function setSortCookie(){
	if($("input:checkbox[id='moveChk']").is(":checked")){
		var status = "[";
		var cnt = 0;
		$("#sort-order .sortul li a").each(function (index) {
			var thisId = $(this).prop("id");
			var idNumber = thisId.substring(6,thisId.length);
			if(thisId.indexOf("aRight") > -1){
				if( cnt == 0 ){
					status += '{"no":"'+idNumber+'","st":"'+$("#r_box"+idNumber).combobox('getValue')+'"}';
				}else{
					status += ',{"no":"'+idNumber+'","st":"'+$("#r_box"+idNumber).combobox('getValue')+'"}';
				}
				cnt++;
				//status.push({no:thisId.substring(6,thisId.length)});
			}
		});
		status += "]";

		setCookie($("#text_menuKey").val(), status, 1); //화면 키, 저장될 정렬, 일자
		setCookie($("#text_menuKey").val()+"C", true, 1); //화면 키, 저장될 정렬, 일자
	}else{
		deleteCookie($("#text_menuKey").val());
		deleteCookie($("#text_menuKey").val()+"C");
	}
}

function doSortCookie(){
	setSortCookie();
}