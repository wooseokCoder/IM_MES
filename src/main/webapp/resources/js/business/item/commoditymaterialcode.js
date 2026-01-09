/**
 *
 *//**
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
		search: getUrl("/business/item/commoditymaterialcode/search.json"),
		excel:  getUrl("/business/item/commoditymaterialcode/download.do"),
		select: getUrl("/business/item/commoditymaterialcode/select.json"),
		remove: getUrl("/business/item/commoditymaterialcode/delete.json"),
		save:   getUrl("/business/item/commoditymaterialcode/save.json")
	},
	init: function() {

		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url:      this.url,
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			formKey:  "#regist-form",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			singleSelect: true,
			pageSize: this.pageSize,
			//toolbar:  "#search-toolbar",
			//행선택시 상세조회 이벤트 바인딩
			onSelect: this.easygrid.select,
			onClickRow: doClickRow,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			//onEndEdit: doEndEdit,
			onLoadSuccess:function(){
				//Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item){
					var itemid = $("#"+item.id);
					itemid.textbox('textbox').bind('keyup', function(e){
						itemid.textbox('setValue', $(this).val());
					});
				});
				//doLangSettingTable();

				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			}
		});

		//등록폼 초기화
		doClear();
	}
};

$(function() {

	consts.init();

	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	//엑셀버튼 클릭시 이벤트 바인딩
	$("#excel-button").bind("click", doExcel);
	//리포트버튼 클릭시 이벤트 바인딩
	//$("#report-button-pdf").bind("click", doReport);
	//$("#report-button-xls").bind("click", doReport);
	//$("#report-button-htm").bind("click", doReport);

	//추가버튼 클릭시 이벤트 바인딩
	$("#append-button").bind("click", doAppend);
	//삭제버튼 클릭시 이벤트 바인딩
	$("#remove-button").bind("click", doRemove);
	//초기화버튼 클릭시 이벤트 바인딩
	//$("#clear-button").bind("click", doClear);
	//저장버튼 클릭시 이벤트 바인딩
	$("#save-button").bind("click", doSave);
	//목록열기 버튼 클릭시 이벤트 바인딩
	$('#open-button').bind("click", doOpenTable);
	//목록닫기 버튼 클릭시 이벤트 바인딩
	$('#close-button').bind("click", doCloseTable);
	$('#open-button').css("display", "none");
	//동일품번 전체복사 버튼 클릭시 이벤트 바인딩
	$('#copy-button').bind("click", doCopyItem);

	//2017/01/10 김영진 매입단가,판매단가 계산
	$("#v_purcPrceRate").bind('keydown',function(events){
		if(events.keyCode == 13){
			updateRate();
		}
	});
	$("#v_salePrceRate").bind('keydown',function(events){
		if(events.keyCode == 13){
			updateRate();
		}
	});

	//Enter 검색을 위한 추가
	$("#r_searchText").bind('keydown',function(events){

		if(events.keyCode == 13){
			doSearch();
		}
	});
});

//화면 상수값 초기화
function doInit(args) {

	if (args) {
		$.extend(consts, args);
	}
}

//검색 처리
function doSearch() {
	doClear();
	$('#v_purcPrce').val("");
	$('#v_salePrce').val("");
	consts.easygrid.search();
}
//엑셀 다운로드
function doExcel() {
	consts.easygrid.download();
}
//초기화 처리
function doClear() {
	consts.easygrid.clear();
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('clearSelections');
	$('#r_updateFlag').val("N");
	$('#v_purcPrceRate').val("");
	$('#v_salePrceRate').val("");
}
//삭제 처리
function doRemove() {
	consts.easygrid.remove();
}
//추가 처리
function doAppend() {
	doClear();
	$('#r_itemCode').val("I");
}
//저장 처리
function doSave() {
	var itemCode = $('#r_itemCode').val();
	if(itemCode == "" || itemCode == null){
		$('#r_itemCode').val("I");
	}

	/* 값 구하는 식
	   select 15000+((-30/100)*15000) from dual;

	   select ((12000/15000)*100)-100 from dual;
	 * */
	/*var basePrce = $('#r_basePrce').val();
	if(basePrce != "" && basePrce != null){
		basePrce = basePrce.replace(/,/g, "");
		basePrce *= 1;

	}else{
		basePrce = 0;
	}
	$('#r_basePrce').val(basePrce);

	var stocAmdRate = $('#r_stocAdmRate').val();
	var saftQty     = $('#r_saftQty').val();
	var onHandQty   = $('#r_onHandQty').val();
	var carryQty    = $('#r_carryQty').val();
	var purcPrce    = $('#r_purcPrce').val();
	var salePrce    = $('#r_salePrce').val();

	if(purcPrce != "" && purcPrce != null){
		purcPrce = purcPrce.replace(/,/g, "");
		purcPrce *= 1;
		$('#r_purcPrce').val(purcPrce);
	}

	if(salePrce != "" && salePrce != null){
		salePrce = salePrce.replace(/,/g, "");
		salePrce *= 1;
		$('#r_salePrce').val(salePrce);
	}

	if(stocAmdRate != "" && stocAmdRate != null){
		stocAmdRate = stocAmdRate.replace(/,/g, "");
		stocAmdRate *= 1;
		$('#r_stocAmdRate').val(stocAmdRate);
	}

	if(saftQty != "" && saftQty != null){
		saftQty = saftQty.replace(/,/g, "");
		saftQty *= 1;
		$('#r_saftQty').val(saftQty);
	}

	if(onHandQty != "" && onHandQty != null){
		onHandQty = onHandQty.replace(/,/g, "");
		onHandQty *= 1;
		$('#r_onHandQty').val(onHandQty);
	}

	if(carryQty != "" && carryQty != null){
		carryQty = carryQty.replace(/,/g, "");
		carryQty *= 1;
		$('#r_carryQty').val(carryQty);
	}*/
	var selectRow = $('#search-grid').datagrid('getSelected');
	if(selectRow != null && selectRow != "" && selectRow.length != 0){
		$('#search-grid').datagrid('endEdit', selectRow.rnum-1);
	}
	var gridUpdate = $('#search-grid').datagrid('getChanges');
	var tableUpdate = $('#r_updateFlag').val();

	$('#v_purcPrceRate').val("");
	$('#v_salePrceRate').val("");

	//console.log(gridUpdate);

	if(gridUpdate != null && gridUpdate.length != 0){
		consts.easygrid.saveEdit();
	}else if(tableUpdate == "Y"){
		consts.easygrid.save();
	}else{
		$.messager.alert(msg.MSG0121,msg.MSG0023,msg.MSG0121);
	}
}

function doEnterKey(){

}
//2017/01/05 김영진 -- 상세정보 접기
function doCloseTable(){
	$("#account-layout").layout('collapse', 'east');
	$('#open-button').css("display", "inline-block");
	$('#close-button').css("display", "none");
}
//2017/01/05 김영진 -- 상세정보 열기
function doOpenTable(){
	$("#account-layout").layout('expand', 'east');
	$('#close-button').css("display", "inline-block");
	$('#open-button').css("display", "none");
}

//숫자체크
function fnNumberCheck(obj)
{
    if (/[^0-9,]/g.test(obj.value))  //숫자
    {
        var text1 = obj.value.substring(0, obj.value.length - 1);
        alert("0-9의 정수만 허용합니다.");
        obj.focus();
        obj.value = text1;
        return false;
    }
    else {
        obj.value = number_format(obj.value);
    }

}

//천자리 콤마 찍기
function number_format(input) {
    input = input.replace(/,/g, "");

    var input = String(input);
    var reg = /(\-?\d+)(\d{3})($|\.\d+)/;
    if (reg.test(input))    //
    {
        return input.replace(reg, function (str, p1, p2, p3) {
            return number_format(p1) + "," + p2 + "" + p3;
        }
    );
    } else {
        return input;
    }
}

//행클릭이벤트
function doClickRow(index, row){
	//
	$('#v_purcPrceRate').val(row.purcPrceRate);
	$('#v_salePrceRate').val(row.salePrceRate);

	consts.easygrid.clickRowEdit(index);
}

//동일품명 전체복사 이벤트
function doCopyItem(){
	var row = $('#search-grid').datagrid('getSelected');
	if(row == null || row == ""){
		$.messager.alert(msg.MSG0121,msg.MSG0047,msg.MSG0121);
		return;
	}
	//

	var msg = "복사할 품명 : <br />"
		    + "<span class='textbox'><input class='textbox-text' name='copyItemName' id='r_copyItemName' value='" + $('#r_itemName').val() + "' style='width:220px;height:22px;margin:0 auto;' /></span>";
	$.messager.confirm('Confirm', msg, function(r) {
		if (!r)
			return;

		var rows = $('#search-grid').datagrid('getRows');
		items = $.map(rows, function(item) {
			if(item.itemName == $('#r_itemName').val()){
				//

				var v_sysId = item.sysId;
				var v_basePrce = item.basePrce;
				var v_carryQty = item.carryQty;
				var v_itemName = $('#r_copyItemName').val();
				var v_itemRemk = item.itemRemk;
				var v_itemSpec = item.itemSpec;
				var v_itemUnit = item.itemUnit;
				var v_itemUnitQty = item.itemUnitQty;
				var v_lastPurcPrce1 = item.lastPurcPrce1;
				var v_lastPurcPrce2 = item.lastPurcPrce2;
				var v_lastPurcPrce3 = item.lastPurcPrce3;
				var v_mngType = item.mngType;
				var v_onHandQty = item.onHandQty;
				var v_purcPrce = item.purcPrce;
				var v_purcPrceRate = item.purcPrceRate;
				var v_ref1Prce = item.ref1Prce;
				var v_ref2Prce = item.ref2Prce;
				var v_ref3Prce = item.ref3Prce;
				var v_regiDate = item.regiDate;
				var v_regiUser = item.regiUser;
				var v_saftQty = item.saftQty;
				var v_salePrce = item.salePrce;
				var v_salePrceRate = item.salePrceRate;
				var v_stocAdmIdx = item.stocAdmIdx;
				var v_stocAdmRate = item.stocAdmRate;
				var v_updtDate = item.updtDate;
				var v_updtUser = item.updtUser;
				var v_useIdx = item.useIdx;

				$('#search-grid').datagrid('appendRow', {
					sysId: v_sysId,
					basePrce: v_basePrce,
					carryQty: v_carryQty,
					itemCode: 'I',
					itemName: v_itemName,
					itemRemk: v_itemRemk,
					itemSpec: v_itemSpec,
					itemUnit: v_itemUnit,
					itemUnitQty: v_itemUnitQty,
					lastPurcPrce1: v_lastPurcPrce1,
					lastPurcPrce2: v_lastPurcPrce2,
					lastPurcPrce3: v_lastPurcPrce3,
					mngType: v_mngType,
					onHandQty: v_onHandQty,
					purcPrce: v_purcPrce,
					purcPrceRate: v_purcPrceRate,
					ref1Prce: v_ref1Prce,
					ref2Prce: v_ref2Prce,
					ref3Prce: v_ref3Prce,
					regiDate: v_regiDate,
					regiUser: v_regiUser,
					saftQty: v_saftQty,
					salePrce: v_salePrce,
					salePrceRate: v_salePrceRate,
					stocAdmIdx: v_stocAdmIdx,
					stocAdmRate: v_stocAdmRate,
					updtDate: v_updtDate,
					updtUser: v_updtUser,
					useIdx: v_useIdx,
					oper: 'I'
				});
			}
		});
	});
}

//매입단가&판매단가 변경 이벤트
function updateRate(){
	var rows = $('#search-grid').datagrid('getRows');
	//
	var selectRow = $('#search-grid').datagrid('getSelected');
	if(selectRow){
		$('#search-grid').datagrid('endEdit', selectRow.rnum-1);
	}

	//
	//if($('#search-grid').datagrid('getEditors', selectRow.rnum-1) == null || $('#search-grid').datagrid('getEditors', selectRow.rnum-1) == ""){
		items = $.map(rows, function(item) {
			if(item.itemName == $('#r_itemName').val()){
				//
				var v_purcRate = $('#v_purcPrceRate').val();
				var v_saleRate = $('#v_salePrceRate').val();
				var v_basePrce = item.basePrce;
				var v_purcPrce = 0;
				var v_salePrce = 0;
				var v_row = item.rnum-1;

				/*v_purcRate = v_purcRate.replace(/,/g, "");
				v_purcRate *= 1;
				v_saleRate = v_saleRate.replace(/,/g, "");
				v_saleRate *= 1;
				v_basePrce = v_basePrce.replace(/,/g, "");
				v_basePrce *= 1;*/

				v_purcPrce = v_basePrce + ((v_purcRate / 100) * v_basePrce);
				v_salePrce = v_basePrce + ((v_saleRate / 100) * v_basePrce);

				/*var udpRows = $('#search-grid').datagrid('getRows');
				var udpRow  = udpRows[v_row];
				console.log(udpRow);*/

				//consts.easygrid.beforeEdit(item.rnum-1, udpRow);
				//consts.easygrid.clickRowEdit(item.rnum-1);

				/*$('#search-grid').datagrid('updateRow',{
					index: v_row,
					row:{
						purcPrce: v_purcPrce,
						salePrce: v_salePrce,
						oper: "U"
					}
				});*/
				$('#search-grid').datagrid('beginEdit', v_row);
				//consts.easygrid.index = item.rnum-1;
				//consts.easygrid.afterEdit(item.rnum-1, udpRow, changes);
				//jstatus.update(udpRow)

				//var gridEdit = $('#search-grid').datagrid('getEditors', v_row);
				//console.log(gridEdit);

				var purcPrceEdit = $('#search-grid').datagrid('getEditor', {index:v_row, field:'purcPrce'});
				$(purcPrceEdit.target).textbox("setValue", v_purcPrce);
				var salePrceEdit = $('#search-grid').datagrid('getEditor', {index:v_row, field:'salePrce'});
				$(salePrceEdit.target).textbox("setValue", v_salePrce);
				//console.log(purcPrceEdit);

				$('#search-grid').datagrid('endEdit', v_row);

				/*if(salePrceEdit){
					var e = jQuery.Event("change");
					jQuery(salePrceEdit.target).trigger(e);
				}*/
				//console.log(v_row + "-end");
				/*
				$('#search-grid').datagrid('updateRow',{
					index: item.rnum-1,
					row:{
						purcPrce: v_purcPrce,
						salePrce: v_salePrce
					}
				});*/
				//
			}
	    });
	//}
	//$('#search-grid').datagrid('acceptChanges');

	//console.log($('#search-grid').datagrid('getChanges', 'updated'));

}
function doOnChange(obj){
	var value = obj.value;
	var d = $.number(value);
	$(obj).val(d);
}
function doTableUpdate(){
	//console.log("oldFlag ::" + $('#r_updateFlag').val());
	$('#r_updateFlag').val("Y");
	//console.log("newFlag ::" + $('#r_updateFlag').val());
}
function doOnNumberFocus(obj){
	var value = $(obj).val();
	value = value.replace(/,/g, "");
	$(obj).val(value);
}
function doOnNumberBlur(obj){
	var value = obj.value;
	var d = $.number(value);
	$(obj).val(d);
}
function remarkFormat(value,row,index){
	if(value == null || value == undefined){
		value= "";
		$('#search-grid').datagrid('updateRow',{
			index: index,
			row:{
				itemRemk: value
			}
		});
	}

	return value;
}