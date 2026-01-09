/**
 * Sample board management script.
 * 
 * Grid search and paging
 * Form popup detail view
 * Form popup register, update, delete
 */
var consts = {
	sysId:    gconsts.SYS_ID,    //System ID (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //Page size (common.jsp)
	easygrid: false,   //Base control
	dialog:   false,   //Popup dialog control
	url: {
		search: getUrl("/common/sample/sampleboard/search.json"),
		remove: getUrl("/common/sample/sampleboard/delete.json"),
		save: getUrl("/common/sample/sampleboard/save.json"),
		excel: getUrl("/common/sample/sampleboard/download.do"),
		excel2: getUrl("/common/sample/sampleboard/download2.do"),
		excel3: getUrl("/common/sample/sampleboard/download3.do")
	},
	init: function() {
		//Initialize base control components
		this.easygrid = new jeasygrid({
			url:      this.url,
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form",
		});
	
		//Create grid
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			pagination: true,
			idField:  'bordNo',
			rownumbers:	  false,
			singleSelect: true,
			selectOnCheck:false,			
		    checkOnSelect: false,
			//Grid edit event binding
			onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : function(index, row, changes) {
				// Add bordGrup, sysId values to edited row
				if(!row.bordGrup) {
					row.bordGrup = $("#s_bordGrup").val();
				}
				if(!row.sysId) {
					row.sysId = $("#s_sysId").val();
				}
				// Call default afterEdit
				if(this.easygrid && this.easygrid.afterEdit) {
					this.easygrid.afterEdit(index, row, changes);
				}
			}.bind(this),
			onLoadSuccess:function(){
				$("#search-grid").datagrid('uncheckAll');
				$("#search-grid").datagrid('clearChecked');
				
				//Set multi dialog button background color
				if($('#h_multiList').val() == ''){
					$('#multi-list-button').css('background-color', 'white');
				} else {
					$('#multi-list-button').css('background-color', '#9e9c9c');
				}
			}
		});
		
		//Initialize registration form
		doClear();
		
		//Display layout
		$("#account-layout").fadeIn(300);
		$("#loadingProgressBar").hide();
	}
};

$(function() {
	consts.init();
	
	//Bind search button click event
	$("#search-button").bind("click", doSearch);
	$("#dreload-button").bind("click", doClear);
	//Bind excel button click event
	$("#excel-button").bind("click", doExcel);
	$("#excel-button2").bind("click", doExcel2);
	$("#upload-excel-button").bind("click", doUploadExcel);
	//Bind delete button click event
	$("#remove-button").bind("click", doRemove);
	//Bind save button click event
	$("#save-button").bind("click", doSave);
	//Bind add button
	$("#append-button").bind("click", doAppend);
	//Bind update button
	$("#update-button").bind('click',doUpdate);
	//Bind upload button
	$("#append-upload-button").bind("click", doAppendUpload);
	$("#upload-button").bind("click", doUpload);
	$("#save-upload-button").bind("click", doSaveUpload);
	$("#cl-upload-btn").bind("click", doCloseUpload);
	
		// My View iframe src 설정 (한 번만)
		document.getElementById('myView-iframe').src = getUrl("/common/board/myViewSearch/myViewSelect.do");
	
	var suppressEvents = false;

	if($("#optionStat").length > 0 && $("#optionStatList").length > 0) {
		var optionStatListVal = $("#optionStatList").val();
		if(!optionStatListVal || optionStatListVal.trim() === '') {
			optionStatListVal = '[{"value":"OPT1","text":"Option1"},{"value":"OPT2","text":"Option2"},{"value":"OPT3","text":"Option3"}]';
			$("#optionStatList").val(optionStatListVal);
		}
		
		var optionData;
		try {
			optionData = JSON.parse(optionStatListVal);
		} catch(e) {
			optionData = [{"value":"OPT1","text":"Option1"},{"value":"OPT2","text":"Option2"},{"value":"OPT3","text":"Option3"}];
		}
		
		if(!optionData || optionData.length === 0) {
			optionData = [{"value":"OPT1","text":"Option1"},{"value":"OPT2","text":"Option2"},{"value":"OPT3","text":"Option3"}];
		}
		
		$('#optionStat').combogrid({
		    idField: 'value',
		    textField: 'text',
		    multiple: true,
		    fitColumns: true,
		    
		    columns: [[
		        {field: 'ck', checkbox: true},
		        {field: 'text', title: 'All'}
		    ]],
		    data: optionData,
		    onCheck: function() {
		        if (!suppressEvents) {
		            updateOptionStatText();
		        }
		    },
		    onUncheck: function() {
		        if (!suppressEvents) {
		            updateOptionStatText();
		        }
		    }
		});
		
		// Set panel width to match input field width
		setTimeout(function() {
			var inputWidth = $('#optionStat').combogrid('textbox').parent().outerWidth();
			if(inputWidth && inputWidth > 0) {
				$('#optionStat').combogrid({
					panelWidth: inputWidth
				});
			}
		}, 100);

		function updateOptionStatText() {
		    var selectedRows = $('#optionStat').combogrid('grid').datagrid('getChecked');
		    var selectedValues = [];
		    var selectedTexts = [];

		    for (var i = 0; i < selectedRows.length; i++) {
		        selectedValues.push(selectedRows[i].value);
		        selectedTexts.push(selectedRows[i].text);
		    }

		    suppressEvents = true;
		    $('#optionStat').combogrid('setValues', selectedValues);
		    suppressEvents = false;

		    $('#optionStat').combogrid('setText', selectedTexts.join(','));
		    $('#h_optionStat').val(selectedValues.join(','));
		}

	}
	
	//Bind multi dialog button (using multiListPop from lsCommon.js)
	$("#multi-list-button").bind("click", multiListPop.openMultiListPop);
	$("#multiList-button1").bind("click", multiListPop.saveListPop);
	$("#multiList-button2").bind("click", multiListPop.deleteMultiListPop);
	$("#multiList-button3").bind("click", multiListPop.closeMultiListPop);
	
	//멀티 다이얼로그 초기화
	$("#s_multiNo").val('');
	$('#h_multiList').val('');
	$('#multi-list-button').css('background-color', 'white');
	
	//멀티 다이얼로그 초기 스타일 설정
	$("#multi-serach-pop").css({
		"display": "none",
		"position": "absolute",
		"background": "#ffffff",
		"border": "1px solid #808080",
		"padding": "5px",
		"z-index": "9999"
	});
	
	//Enter 검색을 위한 추가
	$("#search-form").bind('keydown',function(events){
		if(events.keyCode == 13){
			doSearch();
		}
	});
	$('#regist-dialog').dialog({
	    title: jprops.sampleboard.sampleboardwrite,//샘플게시판 등록
	    iconCls: 'icon-search',
	    top:     10,
	    //2016/12/21 김영진 -- 게시판 팝업 사이즈 조절
	    //width: 1024,
	    //height: 700,
	    width: 800,
	    height: 620,
	    closed: true,
	    modal: true,
	    resizable: true
	});
	
	$('#select-dialog').dialog({
	    title: jprops.sampleboard.sampleboarddetail,//샘플게시판 상세
	    iconCls: 'icon-search',
	    top:     10,
	    //2016/12/21 김영진 -- 게시판 팝업 사이즈 조절
	    //width: 1024,
	    //height: 700,
	    width: 800,
	    height: 620,
	    closed: true,
	    modal: true,
	    resizable: true
	});
	
    fileuploadForm.init();
	
	//업로드 팝업 그리드 초기화
	consts2.init();
	
	$('#regist-upload-dialog').dialog({
		title: tit.TITLE0042,
	    top:     0,
	    width: 800,
	    height: 520,
	    closed: true,
	    modal: true,
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
	
	$('#progress-popup2').dialog({
	       title: tit.TITLE0009,
	       top:     100,
	       width: 200,
	       height: 200,
	       closed: true,
	       modal: true,
	       resizable: false,
	       closable: false
	});
	
	$('#search-upload-grid').datagrid({
		rowStyler:function(index,row){
			if(row.result != msg.MSG0119){
				return 'background-color:#EB4747; color:#ffffff';
			}
		}
	});
	
	$(".wui-dialog").show();
});

var fileuploadForm = {
		sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
		//title:    gconsts.TITLE,     //화면제목 (common.jsp)
		pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
		easygrid: false, //기본컨트롤
		url: {
			//첨부파일 검색 URL
			search: getUrl("/common/file/search.json"),
			//첨부파일 업로드 URL (임시저장)
			upload: getUrl("/common/file/upload.json"),
			//첨부파일 삭제 URL (임시저장파일 삭제)
			remove: getUrl("/common/file/remove.json"),
			//첨부파일 처리세션 종료
			complete: getUrl("/common/file/complete.json"),
			//첨부파일 다운로드 URL
			download: getUrl("/common/file/download.do")
		},
		init: function() {
			
			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				url:      this.url,
				//title:    this.title, //20160921 김원국
				gridKey:  "#select-fileupload",
				//formKey:  "#regist-form",
				sformKey: "#regist-form"
			});
			//그리드 생성
			this.easygrid.init({
				fit: true,
				singleSelect: true,
				pageSize: this.pageSize,
				idField:  'codeCd',
				
				//행선택시 상세조회 이벤트 바인딩
				//onSelect: this.easygrid.select,
				singleSelect: true,
				onClickCell: function(index, field, value) {
					if (field == 'fileDown') {
						var rows = $(this).datagrid('getRows');
						var row  = rows[index];
						
						if (row.exist != true) {
							$.messager.alert("Error", jprops.sampleboard.fileexist, 'error');//해당 파일이 존재하지 않습니다.
							return;
						}
						//obj.download(row.index);   //파일 다운
						var url = fileuploadForm.url.download+"?index="+row.index;
						window.location.href = url;
					} 
					    
				}
				
			});

		}
	};


function doUpdate(){
	$("#select-dialog").dialog('close');
	doAppend("U");
}


function doDetail(row){
	$("#h_atchNo").val(row.bordNo);
	$("#r_bordNo").val(row.bordNo);
	$("#h_atchGrup").val($("#s_bordGrup").val());
	
    $.ajax({
        url: getUrl('/sampleboard/searchSampleBordDetail.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {bordNo:$("#h_atchNo").val()
        	,bordGrup:$("#s_bordGrup").val()
        	,oper:"R"
        	,bordType:"ALL"},
        success: function(data){

        	if(data.rows != undefined){
            	$("#v_bordTitle").html(data.rows.bordTitle);
            	$("#v_regiName").html(data.rows.regiName);
            	$("#v_readCnt").html(data.rows.readCnt);
            	$("#v_regiDate").html(data.rows.regiDate);
            	$("#v_chngDate").html(data.rows.chngDate);
            	$("#v_bordText").html(data.rows.bordText);
            	$("#h_atchNo").val(data.rows.bordNo);
            	$("#h_atchGrup").val(data.rows.bordGrup);
        	}
        	fileuploadForm.easygrid.search();
        },
        error: function(){
        }
    });
    $("#select-dialog").dialog('center');
	$("#select-dialog").dialog('open');
}

//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	consts.easygrid.appendEdit();
}


//Search processing
function doSearch() {
	consts.easygrid.search();
}
//Clear processing
function doClear() {
	consts.easygrid.clear();
	
	//Initialize multi dialog
	$("#s_multiNo").val('');
	$('#h_multiList').val('');
	$('#multi-list-button').css('background-color', 'white');
	
	//Initialize option multi select
	if($("#optionStat").length > 0) {
		try {
			var combogridInstance = $("#optionStat").data('combogrid');
			if(combogridInstance && combogridInstance.options) {
				$("#optionStat").combogrid("setValue", '');
				$("#optionStat").combogrid("clear");
			}
		} catch(e) {
			// Combogrid not initialized yet, ignore
		}
		$('#h_optionStat').val('');
	}
}
//Delete processing
function doRemove() {
	consts.easygrid.removeCheckAll();
}
//Save processing
function doSave() {
	consts.easygrid.saveEdit();
}
//Excel download
function doExcel() {
	$('#progress-popup').dialog('open');
	
	consts.easygrid.download();
	
	$(document).ready(function() {
		$(window).blur(function() {
			$('#progress-popup').dialog('close');
		});
	});
}

//Excel download2 (POI 방식)
function doExcel2() {
	$('#progress-popup').dialog('open');
	
	consts.easygrid.download2();
	
	$(document).ready(function() {
		$(window).blur(function() {
			$('#progress-popup').dialog('close');
		});
	});
}

//Excel Download for Upload (BM)
function doUploadExcel(){
	$('#progress-popup').dialog('open');
	
	var form = $('#search-form');
	var originalAction = form.attr("action");
	form.attr("action", consts.url.excel3);
	form.attr("method", "post");
	form.submit();
	form.attr("action", originalAction);
	
	$(document).ready(function() {
		$(window).blur(function() {
			$('#progress-popup').dialog('close');
		});
	});
}

//업로드 팝업 그리드
var consts2= {
	sysId : gconsts.SYS_ID,
	title : gconsts.TITLE,
	pageSize : gconsts.PAGE_SIZE,
	easygrid : false,
	url : {
		upload:  getUrl("/common/sample/sampleboard/upload.json"),
		upload2:  getUrl("/common/sample/sampleboard/upload2.json"),
		save :   getUrl("/common/sample/sampleboard/excelsave.json")
	},
	init : function() {
		this.easygrid = new jeasygrid({
			url :{ upload: getUrl("/common/sample/sampleboard/upload.json"),
				   save :  getUrl("/common/sample/sampleboard/save.json")
				 },
			gridKey : "#search-upload-grid",
			sformKey : "#search-upload-form"
		});

		this.easygrid.init({
			fit : true,
			singleSelect : true,
			idField: 'bordNo',
			onClickRow : this.easygrid.clickRowEdit,
			onBeginEdit : function(rowIndex, rowData) {
				var editors = $('#search-upload-grid').datagrid('getEditors', rowIndex);
			},
			OnBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			pagination:false,
			onLoadSuccess : function() {
				$("#search-upload-grid").datagrid('unselectAll');
				$("#search-upload-grid").datagrid('clearSelections');
			}
		});
	},
	save: function() {
		this.easygrid.endEdit();

		var rows = this.easygrid.getRows();

		if (rows == null || rows.length == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0023,msg.MSG0121);
			return;
		}
		
		var data = {models: $.toJSON(rows)};
		
		for(var i=0; i<rows.length; i++){
			if(rows[i].result != msg.MSG0119){
				$.messager.alert(msg.MSG0121,msg.MSG0064);
				$('.messager-window .messager-body').css('text-align', 'center');
				return 0;
			}
		}

		$.messager.confirm(msg.MSG0123, msg.MSG0118, function(r) {
			if (!r) return;
			$('#progress-popup2').dialog('open');
			jlogic.save({
				url: consts2.url.save,
				data: data,
				success: function(response) {
					$('#progress-popup2').dialog('close');
					jlogic.result(response, function(res) {
						doClearUpload();
					});
					doSearch();

				},
				error: function() {
					$('#progress-popup2').dialog('close');
				}
			});

		});
	},
	upload: function() {
		$('#progress-popup2').dialog('open');
		$('#search-upload-form').ajaxForm({
			url: this.url.upload,
			beforeSubmit: function () {
				if ($("#s_excelFile").val() == '') {
					$.messager.alert(msg.MSG0121,msg.MSG0019,msg.MSG0121);
					$('#progress-popup2').dialog('close');
					return false;
				}
				return true;
			},
			success: function(data) {
				var CHECK_MSG = [];
				var totalRows = data.rows.length;
				
				function uploadNextRow(index) {
					if (index >= totalRows) {
						var totalCnt = 0;
						var errorCnt = 0;
						
						for (var i = 0; i < totalRows; i++) {
							data.rows[i].CHECK_MSG = CHECK_MSG[i];
							totalCnt++;
							
							if (data.rows[i].bordNo == null || data.rows[i].CHECK_MSG != msg.MSG0119) {
								data.rows[i]["result"] = "BORD_NO: " + msg.MSG0119;
								errorCnt++;
							} else {
								data.rows[i]["result"] = msg.MSG0119;
							}
						}
						
						$("#totalCnt").html(totalCnt);
						$("#errorCnt").html(errorCnt);
						
						if (data.rows == 'error') {
							$.messager.alert(msg.MSG0121, msg.MSG0039, msg.MSG0121);
						} else {
							consts2.easygrid.loadData(data);
						}
						
						$('#progress-popup2').dialog('close');
						return;
					}
					
					var rowData = data.rows[index];
					$.ajax({
						url: consts2.url.upload2,
						data: {
							bordNo: rowData.bordNo,
							bordTitle: rowData.bordTitle,
							readCnt: rowData.readCnt,
							regiName: rowData.regiName,
							regiDate: rowData.regiDate,
							chngName: rowData.chngName,
							chngDate: rowData.chngDate
						},
						success: function(data) {
							CHECK_MSG.push(data.result[0].v_MSG);
							uploadNextRow(index + 1);
						},
						error: function() {
							$('#progress-popup2').dialog('close');
							alert("ERROR!!");
						}
					});
				}
				
				uploadNextRow(0);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				$('#progress-popup2').dialog('close');
				if (jqXHR.readyState === 0) {
					$.messager.alert(msg.MSG0121,msg.MSG0065);
					$('.messager-window .messager-body').css('text-align', 'center');
				} 
				else {
					alert("ERROR!!");
				}
			}
		}).submit();
	}
};

//업로드 팝업 열기
function doAppendUpload() {
	doClearUpload();
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	$("#regist-upload-dialog").dialog('center');
	$("#regist-upload-dialog").dialog('open');
}

//업로드 팝업 닫기
function doCloseUpload() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	$('#regist-upload-dialog').dialog('close');
}

//업로드 팝업 초기화
function doClearUpload() {
	consts2.easygrid.reset();
	consts2.easygrid.resetData();
	$("#errorCnt").html("0");
	$("#totalCnt").html("0");
	$("#s_excelFile").val('');
}

//업로드 처리
function doUpload() {
	consts2.upload();
}

//업로드 저장
function doSaveUpload() {
	consts2.save();
}


//체크박스 변경 함수
function fnChangeCheck(obj){
	var items = "";
	
	if(Utils.isNull($(obj).val())){
		$(":checkbox[name=checkItem]").each(function(index,item){
			if(!Utils.isNull($(item).val())){
				$(item).prop("checked", false);
			}
		});
	}else{
		$(":checkbox[name=checkItem]").each(function(index,item){
			if(Utils.isNull($(item).val())){
				$(item).prop("checked", false);
			}
		});
	}
	
	$('input[name="checkItem"]:checkbox:checked').each(function(){
		items += ($(this).val())+"|";
	});
	
	items = items.substring(0,items.length-1);
	$("#CheckKey").val(items);
}

//My View 초기 로드
$(window).load(function(){
	var windId = $("#windId").val();
	$.ajax({
		url: getUrl("/common/sample/sampleboard/listReorderList.json"),
		dataType: 'json',
		async: false,
		type: 'post',
		data: {sysId: consts.sysId,
			WIND_ID       : windId
				
		},
		success: function(data){
  			var contents = "";
  			var mmm5 = $("#mmm5");
  			if(data.rows && data.rows.length > 0 && data.rows[0].useYn == "Y"){
  				contents += "<a href=\"javascript:reorderColumns('ORG')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"reload-button_org\" data-item=\"BTN_013\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Orginal View</span></span></a>";
  	  			for(var i=0; i < data.rows.length; i++){
  	  				contents += "<a href=\"javascript:reorderColumns('"+data.rows[i].VIEW_ID+"')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"reload-button"+i+"\" data-item=\"BTN_013\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">"+data.rows[i].VIEW_DESC+"</span></span></a>";
  				}
  				contents += "<a href=\"javascript:doOpenMyView('I')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"myView-create-button\" data-item=\"BTN_036\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Create My View</span></span></a>";
  				contents += "<a href=\"javascript:doOpenMyView('U')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"myView-modify-button\" data-item=\"BTN_037\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Modify My View</span></span></a>";
  			}else{
  				contents += "<a href=\"javascript:reorderColumns('ORG')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"reload-button_org\" data-item=\"BTN_013\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Orginal View</span></span></a>";
  				contents += "<a href=\"javascript:doOpenMyView('I')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"myView-create-button\" data-item=\"BTN_036\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Create My View</span></span></a>";
  			}
  			mmm5.append(contents);
		},
		error: function(){
		}
	});
});

//My View 관련 함수들
function setMyViewList() {
	var windId = $("#windId").val();
	$.ajax({
		url: getUrl("/common/sample/sampleboard/listReorderList.json"),
		dataType: 'json',
		async: false,
		type: 'post',
		data: {sysId: consts.sysId,
			WIND_ID       : windId
				
		},
		success: function(data){
			var contents = "";
        	
			// 기존 버튼 삭제
			$("#mmm5 a[id*='reload-button'], #mmm5 #myView-create-button, #mmm5 #myView-modify-button").remove();
			
			// 버튼 생성			
			if(data.rows && data.rows.length > 0 && data.rows[0].useYn == "Y"){
				contents += "<a href=\"javascript:reorderColumns('ORG')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"reload-button_org\" data-item=\"BTN_013\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Orginal View</span></span></a>";
	  			for(var i=0; i < data.rows.length; i++){
	  				contents += "<a href=\"javascript:reorderColumns('"+data.rows[i].VIEW_ID+"')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"reload-button"+i+"\" data-item=\"BTN_013\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">"+data.rows[i].VIEW_DESC+"</span></span></a>";
				}
				contents += "<a href=\"javascript:doOpenMyView('I')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"myView-create-button\" data-item=\"BTN_036\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Create My View</span></span></a>";
				contents += "<a href=\"javascript:doOpenMyView('U')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"myView-modify-button\" data-item=\"BTN_037\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Modify My View</span></span></a>";
			}else{
				contents += "<a href=\"javascript:reorderColumns('ORG')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"reload-button_org\" data-item=\"BTN_013\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Orginal View</span></span></a>";
				contents += "<a href=\"javascript:doOpenMyView('I')\" class=\"easyui-linkbutton c4 l-btn l-btn-small\" id=\"myView-create-button\" data-item=\"BTN_036\" group><span class=\"l-btn-left\"><span class=\"l-btn-text\">Create My View</span></span></a>";
			}
			
			$('#mmm5').append(contents);
		},
		error: function(){
		}
	});
}

function doOpenMyView(type){
//	document.getElementById("myView-iframe").src = "/lsdp/common/board/myViewSearch/myViewSelect.do";
	
	$("#vOper").val(type);
	
	if (type == "I") {
		doOpenMyViewWin();
	} else {
		$.ajax({
			url: getUrl("/common/board/myViewSearch/getMyViewList.json"),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {
				windId : $("#windId").val()
			},
			success: function(data){
				
				if (data.rows.length != 0) {
					doOpenMyViewWin();
				} else {
					if (type == "U") {
						$.messager.alert(msg.MSG0121,msg.MSG0098,msg.MSG0121);
						return;
					}
				}
				
			},
			error: function(){
			}
		});
	}
}

function doOpenMyViewWin(){
	$("#myView-popup").dialog("open");
	
	var iObj = document.getElementById('myView-iframe').contentWindow;
	iObj.setColList();
	var popupCustom = $("#myView-popup").parent();
	var dynamicHeight = 0;
	var fixedHeight = 0;

	 dynamicWidth = window.innerWidth;
	 dynamicHeight = window.innerHeight;

	 resizeWidth = dynamicWidth/2 - 750/2;
	 resizeHeight = dynamicHeight/2 - 500/2;

	 if(dynamicWidth>800){
		 popupCustom.css("left",resizeWidth);
		 popupCustom.next(".window-shadow").css("left",resizeWidth);
	 }

	 if(dynamicHeight>700){
		 popupCustom.css("top",resizeHeight);
		 popupCustom.next(".window-shadow").css("top",resizeHeight);
	 }
}

function reorderColumns(VIEW_ID){
	
	var windId = $("#windId").val();
	$("#myViewId").val(VIEW_ID);
	
	if(VIEW_ID == ''){
		$.messager.alert(msg.MSG0121,msg.MSG0098,msg.MSG0121);
		return;
	}else{
		$.ajax({
			url: getUrl("/common/sample/sampleboard/listReorder.json"),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {sysId: consts.sysId,
				WIND_ID       : windId,
				VIEW_ID       : VIEW_ID
					
			},
			success: function(data){
	  			console.log(data.rows);
	  			var newOrderList = new Array();
	  			if(VIEW_ID == "ORG"){
	  				reorder = "N";
	  			}else{
	  				reorder = "Y";
	  			}
	  			
	  			for(var i=0; i < data.rows.length; i++){
	  				if(data.rows[i].viewSeq == 99){
	  					$("#search-grid").datagrid('hideColumn', data.rows[i].colId);
	  				}else{
	  					$("#search-grid").datagrid('showColumn', data.rows[i].colId);
						newOrderList.push(data.rows[i].colId);
					}
				}
	  			$('#search-grid').datagrid('reorderColumns',newOrderList)
			},
			error: function(){
			}
		});
	}
}

function doDialogClose() {
	$("#myView-popup").dialog('close');
	
	// my view 버튼 리스트 재설정 
	setMyViewList();
}

function doDialogOnlyClose() {
	$("#myView-popup").dialog('close');
}

