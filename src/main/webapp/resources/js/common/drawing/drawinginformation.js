var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search:  getUrl("/common/drawing/drawinginformation/search.json"),
		report:  getUrl("/common/report/code."),
	},
	init: function() {
		
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url: {
				search:  null,
				report:  getUrl("/common/report/code.")
			},
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			// idField: 'LIST_NO',
			pagination: true,
			rownumbers:	  false,
			singleSelect: true,
			selectOnCheck:false,			
		    checkOnSelect: false,//TODO 김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
            onExpandRow: function(index,row){
            },
            onDblClickRow: function(index, row) { //그리드 더블클릭시 이벤트 바인딩
				doDblClickRow(index, row);
	         },
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			onBeginEdit: doBeginEdit,
			onLoadSuccess:function(data){
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			},
			onClickCell: function(index, field, value) {
				var row = $("#search-grid").datagrid('getRows');
				if(field == 'drawView'){
					doOpenDrawview(row[index]);
				}
			},
		});
		doSearch();
	}
};

$(function() {
	$('#regist-dialog').dialog({
		title: '▣  Drawing Information',
	    top:    10,
	    width: 1200,
	    height: 680,
	    closed: true,
	    modal: true,
	    resizable: false
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
	setTimeout(function (){
		
		consts.init();

		//Enter 검색을 위한 추가
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					//doSearch();
				}
			});
		});
		
		$(".easyui-datebox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.datebox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					//doSearch();
				}
			});
		});
		
		$(".easyui-combobox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.combobox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					//doSearch();
				}
			});
		});

		$(".wui-dialog").show();
		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		
		// 버튼 클릭 시 추가화면 이동
		$("#add-draw-button").bind("click", doAddDraw);
		
		//닫기버튼 클릭시 이벤트 바인딩
		$("#close-button").bind("click", doClose);
		
		$("#remove-button").bind("click", doRemove);
		
		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			$(".easyui-textbox").each(function(index, item){
				var itemid = $("#"+item.id);
				itemid.textbox('textbox').bind('keyup', function(e){
					itemid.textbox('setValue', $(this).val());
				});
			});
			if(events.keyCode == 13){
				// doSearch();
			}
		});
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

//검색 처리
function doSearch() {
	var rows;
	if($('#'+this.id).hasClass('l-btn-disabled')){
      return false;
	}
	consts.easygrid.search(consts.url.search);
}

function doClose() {
	$("#regist-dialog").dialog('close');
}

// 작성 화면 이동
function doAddDraw(){
	location.href=getUrl("/common/drawing/drawinginformationdetail.do");
}

function doDblClickRow(index, row){
	location.href=getUrl("/common/drawing/drawinginformationdetail.do?listNo="+row.listNo);
}

function doRemove(){
	var selectRow = $("#search-grid").datagrid('getSelected');
	if (selectRow === undefined || selectRow === null) {
		$.messager.alert('Warning','Please select a row.','warning');
		return false;
	}
	var listNo = selectRow.listNo;
	$.ajax({
		url: getUrl("/common/drawing/drawinginformation/delete.json"),
        dataType: "json",
        type: 'post',
        data: {listNo: listNo},
        success: function(result) {
        	$.messager.show({
				title: 'Information',
				msg: 'Delete completed.'
			});
        },
        error:  function(result) {
        }
	});
	doSearch();
}

//닫기처리
function doClose() {
	$('#regist-dialog').dialog('close');
}

function cellStyler (value,row,index){
	if(row.result == "error") return 'color: #c7cfd7; cursor: pointer; font-size:1.5em;';
	else return 'color: #001eaf; cursor: pointer; font-size:1.5em;';
}

//셀 스타일 부여
function cellStyler2 (value,row,index){
	return 'text-decoration: underline; color: #642EFE; cursor: pointer; ';
}

//체크박스(use-flag)
function formatCheck(value,row,index){
	var d;
	if(value == '1' || value == 'Y' ) d = '<input type="checkbox" checked/>';
	else d = '<input type="checkbox" />';
	return d;
}

function formatAttribute(value,row){
	var returnStr = "<i style='font-size: 1.5em;' class=\"fa fa-file-o\"></i>";
    return returnStr;
}

function dateSorter(a, b) {
	if(a == '-') return 1;
	a = a.split('.');
    b = b.split('.');
    if (a[2] == b[2]){
        if (a[0] == b[0]){
            return (a[1]>b[1]?1:-1);
        } else {
            return (a[0]>b[0]?1:-1);
        }
    } else {
        return (a[2]>b[2]?1:-1);
    }
}

function formatAttribute2(value,row){
	if(value != '' && value != null){
		var returnStr = "<i style='font-size: 1.5em;' class=\"drowpdown-menu-icon fa fa-link\"></i>";
	}else{
		var returnStr = value;
	}
	
    return returnStr;
}

function doOpenDrawview(row) {
	var items = "";
	var tool = "";
	$.ajax({
        url: getUrl("/common/drawing/drawinginformation/getDrawListView.json"),
        dataType: "json",
        type: 'post',
        data: {listNo: row.listNo},
        success: function(data) {
        	$("#viewListType").val(data.rows.listType);
    		$("#viewListCode").val(data.rows.listCode);
    		$("#viewListName").val(data.rows.listName);
            
    		var realUrl = 'http://52.40.215.183:8080/lsdp_data/upload/real/' + data.rows.fileName ;
    		$("#myCanvas").css('background-image', "url(" + realUrl + ")");
        	if(data.rows != null){
        		$.ajax({
                    url: getUrl("/common/drawing/drawinginformation/getDrawItemView.json"),
                    dataType: "json",
                    type: 'post',
                    data: {listNo: row.listNo},
                    success: function(data2) {
                    	$("#myInput").val(data2.rows.length);
                    	for(var i = 0; i < data2.rows.length; i++){
                    		items += "<div class='drawing-items'>";
                    		items += "	<p style='margin-bottom: 0; font-weight: bold;'>#" + (i + 1) + "</p>";
                    		items += "	<input type='checkbox' id='toggle" + i + "' class='powerButton' value='off' disabled/>";
                    		if(data2.rows[i].itemUse == 'on'){
                    			items += "	<label for='toggle" + i + "' class='toggleSwitch active'>";
                    		} else {
                    			items += "	<label for='toggle" + i + "' class='toggleSwitch'>";
                    		}
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
                    		items += "			<input type='text' name='itemType' class='ex-style' value='" + data2.rows[i].itemType + "' disabled>";
                    		items += "		</td>";
                    		items += "	</tr>";
                    		items += "	<tr>";
                    		items += "		<td>Code</td>";
                    		items += "		<td>";
                    		items += "			<input type='text' name='itemCode' class='ex-style' value='" + data2.rows[i].itemCode + "' disabled/>";
                    		items += "		</td>";
                    		items += "	</tr>";
                    		items += "	<tr>";
                    		items += "		<td>Name</td>";
                    		items += "		<td>";
                    		items += "			<input type='text' name='itemName' class='ex-style' value='" + data2.rows[i].itemName + "' disabled/>";
                    		items += "		</td>";
                    		items += "	</tr>";
                    		items += "</table>";
                    		numBox.splice(i, 1, new box(Number(data2.rows[i].boxX), Number(data2.rows[i].boxY), 'black', i + 1, 23));
                            animate();
                            numBox[i].onoff = true;
                            
                            // tooltip
                            tool += "<div style='left: " + data2.rows[i].toolX + "px; top: " + data2.rows[i].toolY + "px;'>";
                            tool += "	<div>" + data2.rows[i].itemName + "</div>";
                            tool += "	<button><i class='fa fa-cart-plus' aria-hidden='true'></i></button>";
                            tool += "</div>";
                    	}
                    	$("#power").html(items);
                    	$("#tooltipWrap").html(tool);
                    	$("#regist-dialog").dialog('center');
                    	$("#regist-dialog").dialog('open');
                    },
                    error:  function(result) {
                    }
                });
        	}
        },
        error:  function(result) {
        }
    });
}