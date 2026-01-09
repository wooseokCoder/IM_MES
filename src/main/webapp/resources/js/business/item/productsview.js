/**
 *  제목		: [기본정보관리]-[상품관리]를 처리하는 스크립트
 *  작성자	: 김연주
 *  날짜		: 2017-04-03
 */
var consts = {
	sysId : gconsts.SYS_ID, // 시스템ID (common.jsp)
	title : gconsts.TITLE, // 화면제목 (common.jsp)
	pageSize : gconsts.PAGE_SIZE, // 출력수 (common.jsp)
	easygrid : false, // 기본컨트롤
	combo : {
		stocLoc : new jcombobox({
			params : {
				codeGrup : 'STRG_TYPE'
			}
		}),
		goodsGP : new jcombobox({
			params : {
				codeGrup : 'ADM_IDX'
			}
		}),
		itemType1 : new jcombobox({
			params : {
				codeGrup : 'ITEM_TYPE1'
			}
		}),
		itemType2 : new jcombobox({
			params : {
				codeGrup : 'ITEM_TYPE2'
			}
		}),
		AS_GP : new jcombobox({
			params : {
				codeGrup : 'AS_GP'
			}
		})
	},
	url : {
		select: getUrl("/business/item/productsview/select.json"),
		search : getUrl("/business/item/productsview/search.json"),
		excel : getUrl("/business/item/productsview/download.do"),
		remove : getUrl("/business/item/productsview/delete.json"),
		save : getUrl("/business/item/productsview/save.json"),
	},
	init : function() {
		// 콤보로딩
		this.combo.stocLoc.load();
		this.combo.goodsGP.load();
		this.combo.itemType1.load();
		this.combo.itemType2.load();
		this.combo.AS_GP.load();

		// 기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url : this.url,
			url: {
				search: null,
				select: getUrl("/business/item/productsview/select.json"),
				excel : getUrl("/business/item/productsview/download.do"),
				remove : getUrl("/business/item/productsview/delete.json"),
				save : getUrl("/business/item/productsview/save.json")
			},

			// title: this.title, //20160921 김원국
			gridKey : "#search-grid",
			sformKey : "#search-form"
		});

		// 그리드 생성
		this.easygrid.init({
			fit : true,
			singleSelect : true,
			pageSize : this.pageSize,
			//toolbar : "#search-toolbar",
			idField: 'itemCode',
			onResize : doResize_Single, 
			singleSelect : true,
			//행선택시 상세조회 이벤트 바인딩
			//onSelect : this.easygrid.select,
			// 그리드 편집이벤트 바인딩
			onClickRow : doClickRow,
			onBeginEdit : doBeginEdit, //필수
			OnBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			//그리드 동적콤보를 위한 이벤트바인딩
			//onEndEdit   : doEndEdit,
			onSelect: this.easygrid.select,
			onLoadSuccess : function() {
				// Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item) {
					var itemid = $("#" + item.id);
					itemid.textbox('textbox').bind('keyup', function(e) {
						itemid.textbox('setValue', $(this).val());
					});
				});



				
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');

				
			}
		});

		// 등록폼 초기화
		doClear();
	}
};

/**
 * 상품 조회 처리 스크립트
 */
var itemSelect = new Array();
var consts_item = {
	sysId : gconsts.SYS_ID, // 시스템ID (common.jsp)
	title : gconsts.TITLE, // 화면제목 (common.jsp)
	pageSize : gconsts.PAGE_SIZE, // 출력수 (common.jsp)
	easygrid : false, // 기본컨트롤
	url : {
		search : getUrl("/business/item/productsview/searchitem.json")
	},
	init : function() {

		// 기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url :{search:null },
			// title: this.title, //20160921 김원국
			gridKey : "#search-item-grid",
			sformKey : "#search-item-form"
		});

		// 그리드 생성
		this.easygrid.init({
			fit : true,
			pageSize : this.pageSize,
			toolbar : "#search-item-toolbar",
			idField : 'itemCode',
			onResize : doResize_Single,
			singleSelect : true,
			// onClickRow: doClickRow,
			// 그리드 편집이벤트 바인딩
			onClickRow : this.easygrid.clickRowEdit,
			onBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			onBeginEdit : doBeginEdit,
			onDblClickRow : function(index, row) {

				$('#searchitemName').textbox('setValue', row.itemName);

				$('#searchitemSpec').textbox('setValue', row.itemSpec);

				$("#item-search-dialog").dialog('close');

			},
			onLoadSuccess : function() {
				// Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item) {
					var itemid = $("#" + item.id);
					itemid.textbox('textbox').bind('keyup', function(e) {
						itemid.textbox('setValue', $(this).val());
					});
				});

				
				$("#search-item-grid").datagrid('unselectAll');
				$("#search-item-grid").datagrid('clearSelections');
				
			}
		});
	}
};

$(function() {

	consts.init();

	$('#item-search-dialog').dialog({
		title : tit.TITLE0005,// 샘플게시판 등록
		iconCls : 'icon-search',
		top : 10,
		// width: 580,
		width : 600,
		height : 463,
		closed : true,
		modal : true,
		resizable : true
	});

	$('#pdf-dialog').dialog({
	    title: tit.TITLE0029,
	    iconCls: 'icon-search',
	    top:     10,
	    bottom:  10,
	    width: 1024,
	    height: 730,
	    closed: true,
	    modal: true,
	    panel: true,
	    resizable: true
	});

	$('#print-dialog').dialog({
	    title: tit.TITLE0005,
	    iconCls: 'icon-search',
	    top:     10,
	    bottom:  10,
	    width: 220,
	    height: 212,
	    //기존 3개 일 경우 212
	    closed: true,
	    modal: true,
	    panel: true,
	    resizable: true
	});

	$('#progress-popup').dialog({
	       title: tit.TITLE0009,
	       top:     100,
	       width: 200,
	       height: 200,
	       closed: true,
	       modal: true,
	       resizable: false
	   });

});

$(window).load(function() {

	consts_item.init(); // 상품조회

	setTimeout(function (){

		$(".wui-dialog").show();

		$("#account-layout").fadeIn(300);

		// 검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		// 추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		// 삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		// 저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
		// 엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);

		// 정렬버튼
		$("#sort-button").bind("click", doSortPopup);
		// 정렬기능 기본 셋팅
		var sortContentParame = [ {
			"sortText" : "품번",
			"sortValue" : "ITEM_CODE"
		}, {
			"sortText" : "품명",
			"sortValue" : "ITEM_NAME"
		} ];
		jSortInit(sortContentParame);
		if ($("#sortValue").val() != "") {
			//doSearch();
		}

		// 상품팝업
		$("#search-item-button").bind("click", doOpenItem);
		// 상품조회
		$("#search-item-pop-button").bind('click', doSearchItem2);
		// 상품조회
		$("#search-item-form").bind('keydown', function(events) {
			if (events.keyCode == 13) {
				doSearchItem();
			}
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

		$("#searchitemType1").combobox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
				doSearch();
		    }
		});

		$("#searchitemType2").combobox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
				doSearch();
		    }
		});

		$(".easyui-textbox").each(function(index, item) {
			var itemid = $("#" + item.id);
			itemid.textbox('textbox').bind('keyup', function(e) {
				itemid.textbox('setValue', $(this).val());
			});
		});

	}, 100);
	
	doLangSettingTable();
	
	
});

// 화면 상수값 초기화
function doInit(args) {

	if (args) {
		$.extend(consts, args);
	}
}
// 에디트 시작
function doBeginEdit(rowIndex, rowData) {
	var editors = $('#search-grid').datagrid('getEditors', rowIndex);
}
// 검색 처리
function doSearch() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	doClear();
	consts.easygrid.search(consts.url.search);
}

// 추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	doClear();
	//consts.easygrid.appendEdit();
}
// 삭제 처리
function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	consts.easygrid.remove();
}
// 저장 처리
function doSave1() {

	var itemSpec = $('#r_itemSpec').val();
	if (itemSpec == "" || itemSpec == null) {
		$.messager.alert(msg.MSG0121,msg.MSG0005,msg.MSG0121);
		return;
	}
	var stocLoc = $("#r_stocLoc").combobox('getValue', '');

	if (stocLoc == "" || stocLoc == null) {
		$.messager.alert(msg.MSG0121,msg.MSG0102,msg.MSG0121);
		return;
	}

	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }


/*	var itemCode = $('#r_itemCode').val();
	if (itemCode == "" || itemCode == null) {
		$('#r_itemCode').val("I");
	}

	var selectRow = $('#search-grid').datagrid('getSelected');
	if (selectRow != null && selectRow != "" && selectRow.length != 0) {
		$('#search-grid').datagrid('endEdit', selectRow.rnum - 1);
	}

	var gridUpdate = $('#search-grid').datagrid('getChanges');
	console.log(gridUpdate);
*/

	consts.easygrid.save(); // consts.easygrid.save() -> consts.easygrid.saveEditCustom() 변경 김원국

	//consts.easygrid.saveEditCustom();
}


//규격 저장
function doSave(){

	var itemSpec = $('#r_itemSpec').val();
	if (itemSpec == "" || itemSpec == null) {
		$.messager.alert(msg.MSG0121,msg.MSG0005,msg.MSG0121);
		return;
	}
	var stocLoc = $("#r_stocLoc").combobox('getValue', '');

	if (stocLoc == "" || stocLoc == null) {
		$.messager.alert(msg.MSG0121,msg.MSG0102,msg.MSG0121);
		return;
	}
  $.ajax({
      url: getUrl('/business/item/productsview/saveItem.json'),
      dataType: 'json',
      async: false,
      type: 'post',
      data: {
    	  itemCode:$("#r_itemCode").val()
    	 ,itemName:$("#r_itemName").val()
    	 ,itemNameAlt:$("#r_itemNameAlt").val()
    	 ,itemSpec:$("#r_itemSpec").val()
    	 ,itemUnit:$("#r_itemUnit").val()
    	 ,itemUnitQty:$("#r_itemUnitQty").val()
    	 ,purcPrce:$("#r_purcPrce").val()
    	 ,salePrce:$("#r_salePrce").val()
    	 ,itemType1:$("#r_itemType1").combobox("getValue")
    	 ,itemType2:$("#r_itemType2").combobox("getValue")
    	 ,modelNo:$("#r_modelNo").val()
    	 ,modelName:$("#r_modelName").val()
    	 ,saftQty:$("#r_saftQty").val()
    	 ,onHandQty:$("#r_onHandQty").val()
    	 ,handQty:$("#r_handQty").val()
    	 ,stocLoc:$("#r_stocLoc").combobox("getValue")
    	 ,goodsGP:$("#r_goodsGP").combobox("getValue")
    	,itemRemk:$("#r_itemRemk").val()

      },
      success: function(data){
      	$.messager.show({
  			title: 'Information',
  			msg: "Save is complete."
  		});
      	//doPriceSearch();
      },
      error: function(){
      	$.messager.show({
  			title: 'Information',
  			msg: "This is registered data."
  		});
      }
  });


}

//TODO 엑셀 다운로드
function doExcel() {

	var rows = 0;

	$.ajax({
	      url: getUrl('/business/item/productsview/searchCount.json'),
	      dataType: 'json',
	      async: false,
	      type: 'post',
	      data: {searchitemName:$("#searchitemName").textbox("getValue")
	      	 	   ,searchitemSpec:$("#searchitemSpec").textbox("getValue")
	      	 	   ,searchitemType1:$("#searchitemType1").combobox("getValue")
	      	 	   ,searchitemType2:$("#searchitemType2").combobox("getValue")
	      	 },
	      success: function(data){
	    	  rows = data.rows;
	      },
	      error: function(){
	      }
	  });

	var msg  = ''
	     + '검색된 데이터가 많아서 엑셀기능 사용시<br>'
         + '작업시간이 오래 걸릴 수 있으며,<br>'
         + '시스템 성능을 저하시킬 수 있습니다.<br><br>'
		 + '&emsp;&emsp;&emsp;&nbsp; 계속해서 작업을 진행하시겠습니까?';

		if(rows >= 1000) {
			$.messager.confirm('알림', msg, function(r) {

				if (!r)
					return;

				doExcelEvent();

			});
		} else {

			doExcelEvent();

		}

}

function doExcelEvent(){
	$('#progress-popup').dialog('open');

	consts.easygrid.download();

	$(document).ready(function() {
		$(window).blur(function() {
			$('#progress-popup').dialog('close');
		});
	});
}

// 초기화 처리
function doClear() {
	consts.easygrid.clear();
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('clearSelections');
}
function doReload(){
		$("#searchitemName").textbox('setValue','');
		$("#searchitemSpec").textbox('setValue','');
		$("#searchimodelName").textbox('setValue','');
		$("#searchitemCode").textbox('setValue','');
		$("#searchitemType1").combobox('setValue','');
		$("#searchitemType2").combobox('setValue','');
}

function doEnterKey() {

}


//행클릭이벤트
function doClickRow(index, row){
	//
	consts.easygrid.clickRowEdit(index);
}


function doTypeChange(){
	var itemType = $('#s_itemType2');
	var itemName = "";

	var searchParams = new FormData();
	searchParams.append("itemType2"  , itemType);

	$.ajax({
      url: getUrl('/business/prod/statusofproductionmaterialsforproduction/getitemname.json'),
      dataType: 'json',
      async: false,
		processData: false,
      contentType: false,
      type: 'post',
      data: searchParams,
      success: function(data){
      	if(!data)
      		return;
      	if(!data.rows)
      		return;
      	items = $.map(data.rows, function(item) {
      		itemName += "<option value=\""+ item.itemName +"\">"+ item.itemName + "</option>"
      	});

      	$('#s_itemName').html(itemName);
      },
      error: function(){
      }
  });
}

// 상품 팝업
function doOpenItem() {
	/*
	 * var custCode = $("#searchcustCode").val(); var isCode = false;
	 * if($("#searchcustCode").textbox("getValue") != "" &&
	 * $("#searchcustCode").textbox("getValue") != undefined){ isCode = true; }
	 * if(!isCode){ $.messager.alert(msg.MSG0121,msg.MSG0121,msg.MSG0121); return; }
	 */

	$("#pItemName").textbox("setValue", "");
	$("#pItemSearchType").val("0");

	itemSelect = [];
	//doSearchItem();
	$("#item-search-dialog").dialog('center');
	$("#item-search-dialog").dialog('open');
}
// 상품조회
function doSearchItem() {
	$("#pItemSearchType").val("0");
	$(".easyui-textbox").each(function(index, item){
		var itemid = $("#"+item.id);
		//console.log(itemid);
		itemid.textbox('textbox').bind('keyup', function(e){
			if (e.which === 13 ) {
				itemid.textbox('setValue', $(this).val());
				consts_item.easygrid.search(consts_item.url.search);

			}
		});
	});

}

function doSearchItem2() {
	$("#pItemSearchType").val("0");
	consts_item.easygrid.search(consts_item.url.search);

}

// 상품조회후 더블클릭
function doItemApplyDb() {
	var row = $('#search-item-grid').datagrid('getSelected');
	var param = {
		custCode : $("#price_custCode").val(),
		custName : $("#price_custName").val(),
		itemCode : row.itemCode,
		itemName : row.itemName,
		itemSpec : row.itemSpec,
		itemUnit : row.itemUnit,
		salePrce : row.salePrce,
		useIdx : "Y"
	};
	consts2.easygrid.appendEdit(param);
}

function doEndEdit(index, row) {

	for(var i=0; i < row.length; i++ ){
		$('#search-grid').datagrid('endEdit',i);
	}
}

// [2017.04.25.shlee] 1차콤보의 포맷함수 (콤보의 텍스트값이 표시됨)
function doFormatCode1(value,row) {
	return row.itemType1Name;
}

// [2017.04.25.shlee] 2차콤보의 포맷함수 (콤보의 텍스트값이 표시됨)
function doFormatCode2(value,row) {
	return row.itemType2Name;
}

function selectItemType(rec){
	var itemType = $("#searchitemType1").textbox('getValue');
	var itemName = "";
	if(itemType !=""){
			$.ajax({
	        url: getUrl('/business/item/productsview/selectItemTypeCode2.json'),
	        dataType: 'json',
	        async: false,
	        type: 'post',
	        data: {itemType:itemType},
	        success: function(data){
	        	$("#searchitemType2").combobox('setValue', '');
	        	$('#searchitemType2').combobox('loadData', [{value:"",text:"전체"}]);
	        	var combodata = $('#searchitemType2').combobox('getData');
	        	if(data.rows.length != 0){
	        		for(var i=0; i < data.rows.length; i++){
	    				combodata.push({value: data.rows[i].codeCd,text:data.rows[i].codeName});
	    			}
	    			$('#searchitemType2').combobox('loadData', combodata);
	        	}else{
	        		$("#searchitemType2").combobox('setValue', '');
	        	}
	        },
	        error: function(){
	        }
	    });
	}else{
		$("#searchitemType2").textbox('setValue', '');
	}
}

// 상품조회 팝업 1/2차구분
function selectItemTypePop(rec){
	var itemType = $("#searchitemType1_2").textbox('getValue');
	var itemName = "";
	if(itemType !=""){
			$.ajax({
	        url: getUrl('/business/item/productsview/selectItemTypeCode2.json'),
	        dataType: 'json',
	        async: false,
	        type: 'post',
	        data: {itemType:itemType},
	        success: function(data){
	        	$("#searchitemType2_2").combobox('setValue', '');
	        	$('#searchitemType2_2').combobox('loadData', [{value:"",text:"전체"}]);
	        	var combodata = $('#searchitemType2_2').combobox('getData');
	        	if(data.rows.length != 0){
	        		for(var i=0; i < data.rows.length; i++){
	    				combodata.push({value: data.rows[i].codeCd,text:data.rows[i].codeName});
	    			}
	    			$('#searchitemType2_2').combobox('loadData', combodata);
	        	}else{
	        		$("#searchitemType2_2").combobox('setValue', '');
	        	}
	        },
	        error: function(){
	        }
	    });
	}else{
		$("#searchitemType2_2").textbox('setValue', '');
	}
}

function selectItemType2(rec){
	var itemType = $("#r_itemType1").combobox('getValue');
	var itemName = "";
	if(itemType !=""){
			$.ajax({
	        url: getUrl('/business/item/productsview/selectItemTypeCode2.json'),
	        dataType: 'json',
	        async: false,
	        type: 'post',
	        data: {itemType:itemType},
	        success: function(data){
	        	$("#r_itemType2").combobox('setValue', '');
	        	$('#r_itemType2').combobox('loadData', [{value:"",text:"전체"}]);
	        	var combodata = $('#r_itemType2').combobox('getData');
	        	if(data.rows.length != 0){
	        		for(var i=0; i < data.rows.length; i++){
	    				combodata.push({value: data.rows[i].codeCd,text:data.rows[i].codeName});
	    			}
	    			$('#r_itemType2').combobox('loadData', combodata);
	        	}else{
	        		$("#r_itemType2").combobox('setValue', '');
	        	}
	        },
	        error: function(){
	        }
	    });
	}else{
		$("#r_itemType2").combobox('setValue', '');
	}
}
//숫자를 0으로 채우는 함수
function fillzero(obj, len) {
	obj= '000000000000000'+obj;
	return obj.substring(obj.length-len);
}
