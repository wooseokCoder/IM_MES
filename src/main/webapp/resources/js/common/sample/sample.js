/**
 * 
 */
var consts = {
	index: 1, //추가용 INDEX
	url: {
		search: getUrl("/common/code/search.json"),
		excel:  getUrl("/common/code/download.do"),
		report: getUrl("/common/report/code."),
		select: getUrl("/common/code/select.json"),
		remove: getUrl("/common/code/delete.json"),
		save:   getUrl("/common/code/save.json")
	}
};

$(function() {

	$("#focus1-button").bind("click", doFocus);
	$("#focus2-button").bind("click", doFocus);
	$("#add-button").bind("click", doInsert);
});

function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//텍스트박스 및 날짜박스의 FOCUS 처리방법
function doFocus() {
	if (this.id == 'focus1-button')
		$('#r_tbox1').textbox('textbox').focus();
	else
		$('#r_dbox1').datebox('textbox').focus();
}

function doInsert() {

	consts.index++;
	
	var n = consts.index;
	var t = $("#input-layer");
	
	t.append('<br/><br/>');
	t.append('<span>일반'+n+':</span><input name="tbox" id="r_tbox'+n+'" /> ');
	t.append('<span>날짜'+n+':</span><input name="dbox" id="r_dbox'+n+'" /> ');
	t.append('<span>콤보'+n+':</span><input name="cbox" id="r_cbox'+n+'" /> ');
	
	t.find('#r_tbox'+n).textbox({width:120,required:true});
	t.find('#r_dbox'+n).datebox({width:120,required:true});
	t.find('#r_cbox'+n).attr('codeGrup', '0');
	t.find('#r_cbox'+n).combobox({width:120,mode:'remote',loader:jcombo.loader});
}

/*
	var table = $("table.select-table");
	var $tr = $(table).find('tr:first').clone();
	
	$tr.find('input').attr('id', function(){

		var parts = this.id.match(/(\D+)(\d+)$/);
		if (parts == null)
			return 0;
		return parts[1] + ++parts[2];
	});
	$(table).append($tr);
	return true;
*/
