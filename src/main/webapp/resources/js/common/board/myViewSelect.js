var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	admin:    gconsts.ADMIN,     //관리자  (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	domain:   false,   //사용자로그인용 도메인
	easygrid: false,   //기본컨트롤
	dialog:   false,   //팝업다이얼로그 컨트롤
	cellEdit: true,
	viewrecords: true,
	forceFit : true,
	url: {
		search: getUrl("/common/board/myViewSearch/search.json")
	},
	init: function() {
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url:      this.url,
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-view-grid",
			sformKey: "#search-view-form"
		});
	
		//그리드 생성
		this.easygrid.init({
			fit: false,
			height:'387px',
			width:'370px',
			//pageSize: this.pageSize,
			pagination: false,
			toolbar:  "#search-view-toolbar",
			idField:  'COL_ID',
			//onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect:  false,
			checkOnSelect: false,
			selectOnCheck: false,
			//onSelect: doSelectRow,
			onClickRow:   doSelectRow,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			//striped: true,
			onLoadSuccess:function(){
				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화 
				$("#search-view-grid").datagrid('uncheckAll');
				$("#search-view-grid").datagrid('clearChecked');
				//loading('end');
			}
		});
		
		//등록폼 초기화
		//doClear();
		
	}
};

var consts2 = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	admin:    gconsts.ADMIN,     //관리자  (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	domain:   false,   //사용자로그인용 도메인
	easygrid: false,   //기본컨트롤
	dialog:   false,   //팝업다이얼로그 컨트롤
	cellEdit: true,
	viewrecords: true,
	forceFit : true,
	url: {
		search: getUrl("/common/board/myViewSearch/search2.json"),
		save  : getUrl("/common/board/myViewSearch/save.json")
	},
	init: function() {
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url:      this.url,
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-view-grid2",
			sformKey: "#search-view-form"
		});
	
		//그리드 생성
		this.easygrid.init({
			fit: false,
			height:'387px',
			width:'370px',
			//pageSize: this.pageSize,
			pagination: false,
			toolbar:  "#search-view-toolbar",
			idField:  'COL_ID',
			//onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			//onSelect: doSelectRow,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			//striped: true,
			singleSelect:  true,
			checkOnSelect: false,
			selectOnCheck: false,
			onClickRow: function(index, row) {
		        /*var selected = $(this).datagrid('getSelections');
		        
		        // 현재 클릭한 row가 selections 배열 안에 있는지 확인
		        var alreadySelected = selected.some(function(item) {
		            return item.COL_ID === row.COL_ID; // row.id 기준
		        });
		        
		        if (alreadySelected) {
		            $(this).datagrid('uncheckRow', index).datagrid('unselectRow', index);
		        } else {
		            $(this).datagrid('checkRow', index).datagrid('selectRow', index);
		        }
		        */
				const thisId = row.COL_ID;

		        // 이전에 클릭했던 row를 다시 클릭한 경우 → 해제
		        if (prevSelectId === thisId) {
		        	$(this).datagrid('uncheckRow', index).datagrid('unselectRow', index);
		            prevSelectId = "";
		        } else {
		        	$(this).datagrid('checkRow', index).datagrid('selectRow', index);
		            prevSelectId = thisId;
		        }
		    },
		    dragSelection: true,
		    onDrop: function(targetRow, sourceRow, point) {
		        var rows = $(this).datagrid('getRows');
		        var group = getGroupedRows(sourceRow, rows); // 정렬 포함된 그룹 반환

		        if (group.length === 0) return;

		        // 기존 그룹 삭제 (뒤에서부터)
		        group.slice().reverse().forEach(r => {
		            var idx = $(this).datagrid('getRowIndex', r);
		            if (idx !== -1) $(this).datagrid('deleteRow', idx);
		        });

		        // 타겟 위치 계산
		        var targetIndex = $(this).datagrid('getRowIndex', targetRow);
		        if (point === 'below') targetIndex++;

		        // 정렬된 그룹 삽입
		        group.forEach((r, i) => {
		            $(this).datagrid('insertRow', {
		                index: targetIndex + i,
		                row: r
		            });
		        });
		        
		    	// 전체 행에 drag 활성화
		    	$(this).datagrid('enableDnd');
		    },
			onLoadSuccess:function(){
				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화 
				$("#search-view-grid2").datagrid('uncheckAll');
				$("#search-view-grid2").datagrid('clearChecked');
				//loading('end');
				
				$(this).datagrid('enableDnd');
			}
		});
		
		//등록폼 초기화
		//doClear();
		
	}
};


$(function() {

	jQuery(document).ajaxStart(function(){
		$('#Progress_Loading').show(); //ajax실행시 로딩바를 보여준다.
	})
	jQuery(document).ajaxStop(function(){
		$('#Progress_Loading').hide(); //ajax종료시 로딩바를 숨겨준다.
	});
	
});

$(window).load(function() {
	
	setTimeout(function (){
		
		consts.init();
		consts2.init();
		
		//추가버튼 클릭시 이벤트 바인딩
		//$("#append-button").bind("click", doAppend);
		//삭제버튼 클릭시 이벤트 바인딩
		//$("#remove-button").bind("click", doDelete);
		//저장버튼 클릭시 이벤트 바인딩
		//$("#save-button").bind("click", doSave);
		//확인버튼 클릭시 이벤트 바인딩
		//$("#submit-button").bind("click", doSubmit);
		//검색버튼 클릭시 이벤트 바인딩
		//$("#search-button").bind("click", doSearch);
		
		//수신 추가 이벤트 바인딩
		$("#to_right_arow").bind("click", doToRight);
		//수신 삭제 이벤트 바인딩
		$("#to_left_arow").bind("click", doToLeft);
		
		//My View 설정 화면 닫기버튼 클릭시 이벤트 바인딩
		$("#close-button").bind("click", doMyViewOnlyClose);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSubmit);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#delete-button").bind("click", doDelete);
		
		//생성버튼 클릭시 이벤트 바인딩
//		$("#create-button").bind("click", doCreate);
		//생성 or 수정시 취소버튼 클릭시 이벤트 바인딩
//		$("#cancel-button").bind("click", doCancel);
		
		// 전체선택, 선택해제 버튼
		$("#all-select-button").bind("click", doAllSelect);
		$("#unselect-button").bind("click", doUnselect);
		
	}, 100);
});

$(window).resize(function() {
    $('#search-view-grid').datagrid('resize');
    $('#search-view-grid2').datagrid('resize');
});

//화면 상수값 초기화
function doInit(args) {
	$("#search-view-grid").datagrid('unselectAll');
	$("#search-view-grid").datagrid('uncheckAll');
	$("#search-view-grid2").datagrid('unselectAll');
	$("#search-view-grid2").datagrid('uncheckAll');
	if (args) {
		$.extend(consts, args);
	}
}
//검색버튼 클릭시 그리드 검색
function doSearch() {
	consts.easygrid.search(consts.url.search);
}

function doSearch2() {
	consts2.easygrid.search();
}

//초기화 처리
function doClear() {
	//consts.easygrid.clear();
	$("#oper").val("");
	$("#myViewId").val("");
	$("#rViewName").textbox("setValue",'');
	$("#rViewSeq").textbox("setValue",'');
	$("#rViewDefa").prop("checked", false);
	$("#viewList").combobox("setValue","");
	
	$(".comb").css("display","inline");
	$(".txt").css('display','none');
//	$("#cancel-button").hide();
}

//저장 처리
function doSave() {
	//consts2.easygrid.saveEdit();
	var viewId = $("#myViewId").val();
	
	var jsonData = {
		windId   : $("#windId").val(),
		oper     : $("#oper").val(),
		viewId   : viewId,
	    rows     : $("#search-view-grid2").datagrid('getRows')
	};
	
	$.ajax({
	    url: getUrl("/common/board/myViewSearch/saveMyViewColList.json"),
	    method: 'POST',
	    dataType: 'json',
	    data: JSON.stringify(jsonData),
	    contentType: 'application/json',
	    success: function(res) {
	    	$.messager.show({
				title: 'Information',
				msg: msg.MSG0106
			});
	    	
	    	//setMyViewList(viewId);
	    	//parent.document.getElementById('myViewId').value = viewId;
	    	parent.reorderColumns(viewId);
	    	doMyViewClose();
	    }
	});
}

//삭제 처리
function doDelete() {
	//consts.easygrid.removeEdit();
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	
	if ($("#myViewId").val() == "") {
		$.messager.alert(msg.MSG0121,msg.MSG0090,msg.MSG0121);
		return;
	} else {
		$.messager.confirm(msg.MSG0123, msg.MSG0074, function(r) {
			if (!r) return;
			$.ajax({
				url: getUrl("/common/board/myViewSearch/deleteMyView.json"),
				dataType: 'json',
				async: false,
				type: 'post',
				data: {
					windId   : $("#windId").val(),
					viewId   : $("#myViewId").val(),
					oper     : $("#oper").val()
				},
				success: function(data){
					$.messager.show({
						title: 'Information',
						msg: msg.MSG0124
					});
					
					doClear();
					setMyViewList("");
					
					//parent.document.getElementById('myViewId').value = 'ORG';
					parent.reorderColumns('ORG');
					doMyViewClose();
				},
				error: function(){
					$.messager.alert(msg.MSG0121,msg.MSG0055,msg.MSG0121);
					return;
				}
			});
		});
	}
}

//추가 처리
function doAppend() {
	consts.easygrid.appendEdit();
}

//수신/참조 추가처리
function doSubmit() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	
	var viewDefa = "";
	
	if ($('input[name="rViewDefa"]:checkbox:checked').length == 1) {
		viewDefa = "Y";
	} else {
		viewDefa = "N";
	}
	
	var viewName = $("#rViewName").textbox("getValue");
	
	if (viewName == "") {
		$.messager.alert(msg.MSG0121,msg.MSG0091,msg.MSG0121);
		return;
	} else {
		// columns seq. 정리 
		var rows = $("#search-view-grid2").datagrid('getRows');
		for (var i = 0; i < rows.length; i++) {
		    rows[i].VIEW_SEQ = i + 1;  // seq 필드에 순서 부여
		    $("#search-view-grid2").datagrid('refreshRow', i);  // UI에도 반영
		}
		
		if($("#oper").val() == "I") {
			$("#myViewId").val("");
		}
		
		$.ajax({
			url: getUrl("/common/board/myViewSearch/saveMyViewMast.json"),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {
				windId   : $("#windId").val(),
				viewId   : $("#myViewId").val(),
				viewName : viewName,
				viewSeq  : $("#rViewSeq").textbox("getValue"), 
				viewDefa : viewDefa,
				oper     : $("#oper").val()
			},
			success: function(data){
				var resultMsg = data.rows[0].MSG;
				
				if (resultMsg == "SUCCESS") {
					$("#myViewId").val(data.rows[0].viewId);
					
					doSave();
				} else {
					$.messager.alert(msg.MSG0121,resultMsg,msg.MSG0121);
					return;
				}
				
			},
			error: function(){
			}
		});
		
		$("#search-view-grid").datagrid('unselectAll');
		$("#search-view-grid2").datagrid('unselectAll');
	}
	
}

//수신/참조 행클릭
function doFlag(flag){
	if($(flag).hasClass("selected-row")){
		$(flag).removeClass("selected-row");
	}else{
		$(flag).addClass("selected-row");
	}
}

// 선택된 행 오른쪽 그리드에 추가 
function doToRight(){
    const selected = $('#search-view-grid').datagrid('getSelections');
    if (!selected.length) return;

    const allRows = $('#search-view-grid').datagrid('getRows');
    const grid2Rows = $('#search-view-grid2').datagrid('getRows');
    const groupToMove = [];
    
    selected.forEach(function(row) {
        const group = getGroupedRows(row, allRows); // MERG_CODE 앞 한 글자로 그룹 추출

        group.forEach(function(gRow) {
            const alreadyInList = groupToMove.some(r => r.MERG_CODE === gRow.MERG_CODE);
            const alreadyInTargetGrid = grid2Rows.some(r => r.COL_ID === gRow.COL_ID);

            if (!alreadyInList && !alreadyInTargetGrid) {
                groupToMove.push(gRow);
            }
        });
    });
    
    // 선택된 행이 그룹 외의 독립행일 수도 있으므로 별도 포함
    selected.forEach(function(row) {
        const alreadyInList = groupToMove.some(r => r.COL_ID === row.COL_ID);
        const alreadyInTargetGrid = grid2Rows.some(r => r.COL_ID === row.COL_ID);

        if (!alreadyInList && !alreadyInTargetGrid) {
            groupToMove.push(row);
        }
    });
    
    // 오른쪽에 추가하고 왼쪽에서 삭제
    groupToMove.forEach(function(row) {
        $('#search-view-grid2').datagrid('appendRow', row);

        const index = $('#search-view-grid').datagrid('getRowIndex', row);
        if (index !== -1) {
            $('#search-view-grid').datagrid('deleteRow', index);
        }
    });

    $('#search-view-grid').datagrid('clearSelections');
	
	// 전체 행에 drag 활성화
	$('#search-view-grid2').datagrid('enableDnd');
	
    arr = new Array();
	/*
	for (var i=0; i<arr.length; i++) {
		// data가 존재하는지 확인 후 행 추가 
	    var rows = $("#search-view-grid2").datagrid('getRows');
	    var exists = rows.some(function(row) {
	        return row.COL_ID === arr[i].COL_ID; // ID 기준 중복 검사
	    });

	    if (!exists) {
	        $("#search-view-grid2").datagrid('appendRow', arr[i]);
	        
	        // 왼쪽 system 컬럼 행 숨기기 
	        var sysRows = $("#search-view-grid").datagrid('getRows');
			var sysIndex = sysRows.findIndex(function(row) {
			    return row.COL_ID === arr[i].COL_ID; 
			});
			sysRows[sysIndex].hidden = true;
	        //$("#search-view-grid").datagrid('refreshRow', sysIndex); 
	    } else {
	        console.log('이미 존재하는 데이터입니다. 추가하지 않음');
	    }
	}
	
	arr = new Array();
	$("#search-view-grid").datagrid('unselectAll');
	$("#search-view-grid2").datagrid('unselectAll');
	
	// 전체 행에 drag 활성화
	$('#search-view-grid2').datagrid('enableDnd');
	
	// grid refresh
	var data = $("#search-view-grid").datagrid('getData');
	$("#search-view-grid").datagrid('loadData', data);*/
}

//선택된 행 삭제 
function doToLeft(){
    const selected = $('#search-view-grid2').datagrid('getSelections');
    if (!selected.length) return;
    
    for (var i=0; i < selected.length; i++) {
		if(selected[i].VIEW_TYPE == 'S') {
			$.messager.alert(msg.MSG0121,msg.MSG0093,msg.MSG0121);
			return;
		}
	}

    const allRows = $('#search-view-grid2').datagrid('getRows');
    const leftRows = $('#search-view-grid').datagrid('getRows');
    const groupToMove = [];
    
    // 선택된 행들에 대해 그룹 추출
    selected.forEach(function(row) {
        const group = getGroupedRows(row, allRows);

        group.forEach(function(gRow) {
            const alreadyInList = groupToMove.some(r => r.MERG_CODE === gRow.MERG_CODE);
            const alreadyInLeftGrid = leftRows.some(r => r.COL_ID === gRow.COL_ID);

            if (!alreadyInList && !alreadyInLeftGrid) {
                groupToMove.push(gRow);
            }
        });
    });
    
    // 선택된 행이 그룹 외의 독립행일 수도 있으므로 별도 포함
    selected.forEach(function(row) {
        const alreadyInList = groupToMove.some(r => r.COL_ID === row.COL_ID);
        const alreadyInLeftGrid = leftRows.some(r => r.COL_ID === row.COL_ID);

        if (!alreadyInList && !alreadyInLeftGrid) {
            groupToMove.push(row);
        }
    });
    
    // 왼쪽에 추가하고 오른쪽에서 삭제
    groupToMove.forEach(function(row) {
        $('#search-view-grid').datagrid('appendRow', row);

        const index = $('#search-view-grid2').datagrid('getRowIndex', row);
        if (index !== -1) {
            $('#search-view-grid2').datagrid('deleteRow', index);
        }
    });

    $('#search-view-grid2').datagrid('clearSelections');
    
/*	var rows = $("#search-view-grid2").datagrid('getSelections');
	for (var i = rows.length - 1; i >= 0; i--) {
		if(rows[i].VIEW_TYPE != 'S') {
			var index = $("#search-view-grid2").datagrid('getRowIndex', rows[i]);
			$("#search-view-grid2").datagrid('deleteRow', index);
			
			// 같이 삭제해야하는 컬럼
			if(rows[i].COL_ID == 'PAY_MENT' || rows[i].COL_ID == 'PAY_MENT_STAT') {
				var keyValue = "";
				
				if(rows[i].COL_ID == 'PAY_MENT') {
					keyValue = 'PAY_MENT_STAT';
				} else if(rows[i].COL_ID == 'PAY_MENT_STAT') {
					keyValue = 'PAY_MENT';
				}
				
				var rows = $('#search-view-grid2').datagrid('getRows');
				
				var index2 = rows.findIndex(function(row) {
				    return row.COL_ID === keyValue; 
				});
				$("#search-view-grid2").datagrid('deleteRow', index2);
			}
			
			// hidden 처리한 row 다시 보이게 
	        var sysRows = $("#search-view-grid").datagrid('getRows');
			var sysIndex = sysRows.findIndex(function(row) {
			    return row.COL_ID === rows[i].COL_ID; 
			});
			sysRows[sysIndex].hidden = false;
	        //$("#search-view-grid").datagrid('refreshRow', sysIndex); 
		} else {
			console.log('필수 컬럼');
		}
	}
	
	// grid refresh
	var data = $("#search-view-grid").datagrid('getData');
	$("#search-view-grid").datagrid('loadData', data);*/
}

// 선택된 행 저장
let arr = new Array();
let prevSelectId = "";

function doSelectRow(rowIndex, rowData){
	if(arr.length == 0){
		arr.push(rowData);
	} else{
		if($.inArray(rowData, arr) != -1){
		    arr.splice(arr.indexOf(rowData),1);
		    $(this).datagrid('uncheckRow', rowIndex).datagrid('unselectRow', rowIndex);
		} else {
			arr.push(rowData);
		}
	}
}

function loading(flag){
}

function setColList(){
	// 부모 창에서 값 가져오기
	var windId   = parent.document.getElementById('windId') ? parent.document.getElementById('windId').value : '';
	var myViewId = parent.document.getElementById('myViewId') ? parent.document.getElementById('myViewId').value : '';
	var oper     = parent.document.getElementById('vOper') ? parent.document.getElementById('vOper').value : '';
	
	// URL 파라미터에서도 확인 (부모 창 값이 없을 경우)
	if (!windId || windId === '') {
		var urlParams = new URLSearchParams(window.location.search);
		windId = urlParams.get('windId') || windId;
		myViewId = urlParams.get('myViewId') || myViewId;
		oper = urlParams.get('oper') || oper;
	}
	
	// 값이 없으면 종료
	if (!windId || windId === '') {
		return;
	}
	
	$("#windId").val(windId);
	$("#myViewId").val(myViewId);
	$("#oper").val(oper);
	
	if (oper == "I") {
		$("#delete-button").hide();
		doCreate();
	} else {
		doCancel();
		setMyViewList(myViewId);
	}
	doSearch();
}

function addColList(row){
	arr.push(row);
	
	doToRight();
}

function doMyViewClose() {
	doClear();
	
	parent.doDialogClose();
}

function doMyViewOnlyClose() {
	doClear();
	
	parent.doDialogOnlyClose();
}

//셀 스타일 부여
function cellStyler(value,row,index){
	// System default - 필수 컬럼일 경우 bold
	if(row.VIEW_TYPE == 'S'){
		return 'font-weight: bold;';
	} else{
		return '';
	}
}

function setMyViewList(val) {
	$.ajax({
		url: getUrl("/common/board/myViewSearch/getMyViewList.json"),
		dataType: 'json',
		async: false,
		type: 'post',
		data: {
			windId : $("#windId").val()
		},
		success: function(data){
			var combodata =[];
			$('#viewList').combobox('loadData', []);
        	
			if (data.rows.length != 0) {
				for (var i=0; i < data.rows.length; i++) {
					combodata.push({value: data.rows[i].viewId,text:data.rows[i].viewDesc});
				}
				$('#viewList').combobox('loadData', combodata);
			}
			
			if (val == "" || val == "ORG") {
				$("#viewList").combobox("setValue","");
//				$("#oper").val("I");
//				doCreate();
			} else {
				$("#viewList").combobox("setValue",val);
				$("#oper").val("U");
//				$("#cancel-button").hide();
				$("#delete-button").show();
			}
			
			doSearch2();
		},
		error: function(){
		}
	});
}

function doChngViewList(val) {
	if(!Utils.isNull(val)){
		$.ajax({
			url: getUrl("/common/board/myViewSearch/getMyViewMastInfo.json"),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {
				windId : $("#windId").val(),
				viewId : val
			},
			success: function(data){
				
				if (data.rows.length != 0) {
					$("#myViewId").val(val);
					$("#oper").val("U");
					$("#delete-button").show();
					
					$("#rViewName").textbox("setValue",data.rows[0].viewDesc);
					$("#rViewSeq").textbox("setValue",data.rows[0].viewSeq);
					
					if (data.rows[0].defa_yn == 'Y') {
						$("#rViewDefa").prop("checked", true);
					} else {
						$("#rViewDefa").prop("checked", false);
					}
					
					doSearch();
					doSearch2();
				}
				
			},
			error: function(){
			}
		});
	}
}

function doCreate() {
	$("#rViewName").textbox("setValue","");
	$("#rViewSeq").textbox("setValue","");
	$("#rViewDefa").prop("checked", false);
	$("#oper").val("I");
	$("#myViewId").val("");
	$("#viewList").combobox("setValue","");
	
	$(".comb").css("display","none");
	$(".txt").css('display','inline');
//	$("#cancel-button").show();
	
	doSearch();
	doSearch2();
	//$('#search-view-grid2').datagrid('loadData', {total: 0, rows: []});
}

function doCancel() {
	$("#rViewName").textbox("setValue","");
	$("#rViewSeq").textbox("setValue","");
	$("#rViewDefa").prop("checked", false);
	$("#oper").val("");
	$("#myViewId").val("");
	$("#viewList").combobox("setValue","");
	
	$(".comb").css("display","inline");
	$(".txt").css('display','none');
//	$("#cancel-button").hide();
}

function getGroupedRows(row, allRows) {
    const groupKey = row.MERG_CODE?.charAt(0); // 그룹 키: 앞 글자
    if (!groupKey) return [];

    // 그룹 키 같은 컬럼
    const grouped = allRows.filter(r => r.MERG_CODE?.charAt(0) === groupKey);

    // 그룹 내 정렬: 숫자 기준
    grouped.sort(function(a, b) {
        const numA = parseInt(a.MERG_CODE.slice(1), 10);
        const numB = parseInt(b.MERG_CODE.slice(1), 10);
        return numA - numB;
    });

    return grouped;
}

function doAllSelect() {
	$('#search-view-grid').datagrid('checkAll').datagrid('selectAll');
	
	arr = [];
	let allRows = $('#search-view-grid').datagrid('getRows');
	arr = arr.concat(allRows);
	//console.log(arr);
}

function doUnselect() {
	$('#search-view-grid').datagrid('clearSelections');
	arr = [];
}