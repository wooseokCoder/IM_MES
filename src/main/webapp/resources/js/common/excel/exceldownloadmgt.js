/**
 *  제목		: [유틸리티]-[전화번호부]를 처리하는 스크립트
 *  작성자	: 김연주
 *  날짜		: 2017-03-14
 */



//초기 선언해 주는 부분
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search:  getUrl("/common/excel/exceldownloadmgt/search.json"),
		excel:   getUrl("/common/excel/exceldownloadmgt/download.do"),
		report:  getUrl("/common/excel/report/code."),
		save:    getUrl("/common/excel/exceldownloadmgt/save.json")
	},
	init: function() {
		
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search:  null,
				excel:   getUrl("/common/excel/exceldownloadmgt/download.do"),
				report:  getUrl("/common/excel/report/code."),
				save:    getUrl("/common/excel/exceldownloadmgt/save.json")
			},
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField: 'codeCd',
			pagination: true,
			rownumbers:	  false,
			singleSelect: true,
			selectOnCheck:false,			
		    checkOnSelect: false,//TODO 김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
            onExpandRow: function(index,row){
            },
			onLoadSuccess:function(data){
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
				doLangSettingTable();
			},
			onClickCell: function(index, field, value) {
				if(field == 'codeIcon'){
					if(value != '' && value != null){
						var row = $("#search-grid").datagrid('getRows');
						doOpenUpLoad(row[index]);
					}
				}
					if (field == 'fileName' && $(this).datagrid('getRows')[index].fileName !== '-') {
						var rows = $(this).datagrid('getRows');
						var row  = rows[index];
						console.log(row);
						var fileName  = row.fileName;
						var path  = row.filePath;
						var hostname = $(location).attr('hostname');
						if(hostname == "52.40.215.183" || hostname == "localhost") {
							var url = 'http://52.40.215.183:8080'+path;
						} else {
							var url = 'https://dealerportal.lstractorusa.com'+path;
						}
						window.open("xlsx").location.href = url;
					}
			},
		});
//		//등록폼 초기화
//		doClear();
	}
};

$(function() {
	$('#progress-popup').dialog({
       title: tit.TITLE0009,
       top:     100,
       width: 200,
       height: 200,
       closed: true,
       modal: true,
       resizable: false
    });
	
	$('#regist-dialog').dialog({
		title: tit.TITLE0041,
	    top:     10,
	    width: 350,
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
					doSearch();
				}
			});
		});
		
		$(".easyui-datebox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.datebox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					doSearch();
				}
			});
		});
		
		$(".easyui-combobox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.combobox('textbox').bind('keydown',function(events){
				if(events.keyCode == 13){
					doSearch();
				}
			});
		});

		$(".wui-dialog").show();
		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		
		//추가버튼 클릭시 이벤트 바인딩
//		$("#append-button").bind("click", doAppend2);
		
		//클리어버튼 클릭시 이벤트 바인딩
		$("#clear-button").bind("click", doClear2);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
		
		//엑셀저장
		$("#save-button2").bind("click", doSave2);
		//업로드닫기
		$("#cl-btn").bind("click", doClose);
		
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
		
//		doSearch();
		doLangSettingTable();
		
		// 날짜 필드 초기값 설정 (어제~오늘)
		var today = new Date();
		var yesterday = new Date();
		yesterday.setDate(today.getDate() - 1);
		
		// mm.dd.yyyy 형식으로 포맷팅
		var todayStr = String((today.getMonth() + 1)).padStart(2, '0') + '.' + 
					   String(today.getDate()).padStart(2, '0') + '.' + 
					   today.getFullYear();
		var yesterdayStr = String((yesterday.getMonth() + 1)).padStart(2, '0') + '.' + 
						   String(yesterday.getDate()).padStart(2, '0') + '.' + 
						   yesterday.getFullYear();
		
		// 날짜 필드에 초기값 설정
		$('#rqstDateFr').datebox('setValue', yesterdayStr);
		$('#rqstDateTo').datebox('setValue', todayStr);
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
	//consts.easygrid.search();
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.search(consts.url.search);
}

function cellStyler (value,row,index){
	if(row.result == "error") return 'color: #c7cfd7; cursor: pointer; font-size:1.5em;';
	else return 'color: #001eaf; cursor: pointer; font-size:1.5em;';
}

function formatAttribute(value,row){
	if(value != '' && value != null){
//		var returnStr = "<i style='font-size: 1.5em;' class=\"fa fa-upload\"></i>";
		var returnStr = "<i style='font-size: 1.5em;' class=\"fa fa-cloud-upload\"></i>";
	}else{
		var returnStr = value;
	}
	
    return returnStr;
}

function doOpenUpLoad(index) {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	$("#h_codeCd").val(index.codeCd);
	$("#h_codeGrup").val(index.codeGrup);
	$("#h_atchNo").val(index.atchNo);
	
	$.ajax({
        url: getUrl("/common/excel/exceldownloadmgt/formfile.json"),
        dataType: "text",
        type: 'post',
        data: { 
        	codeCd:  index.codeCd,
        	codeGrup:index.codeGrup
        },
        success: function(result) {
        	if(index.extChr02 == "" && index.extChr02 == undefined){
        		$("#s_excelFile").click();
        	}
        	
        },
        error:  function(result) {
        },
        complete : function () {
        }
    });
	$("#regist-dialog").dialog('center');
	$("#regist-dialog").dialog('open');
	
}


//업로드 저장
function doSave2(){
	if(doubleSubmitCheck()){
		if($('#'+this.id).hasClass('l-btn-disabled')){
		      return false;
		   }
		var f = $("#search-form2");
		var v = $('#s_excelFile').filebox('getValue');

		if (v == "") {
			$.messager.alert(msg.MSG0121,msg.MSG0019,msg.MSG0121);
			return;
		}

	    f.ajaxForm({
	    	url:      getUrl("/common/excel/exceldownloadmgt/upload.do"),
	    	success: function(result) {
	    		doClose()
	    		doSearch();
	    	}
	    }).submit();
	}
}

//닫기처리
function doClose() {
	$('#regist-dialog').dialog('close');
	$('#s_excelFile').filebox('setValue',"");
}


//엑셀 다운로드
function doExcel() {
	   $('#progress-popup').dialog('open');

	   consts.easygrid.download();

	   $(document).ready(function() {
	       $(window).blur(function() {
	          $('#progress-popup').dialog('close');
	       });
	   });
}

//초기화 처리
function doClear2(){
    // userId가 readonly가 아닐 때만 초기화
    if (!$("#userId").textbox('options').readonly) {
        $("#userId").textbox("setValue","");
    }
    
    // 날짜 필드 초기값 설정 (어제~오늘)
    var today = new Date();
    var yesterday = new Date();
    yesterday.setDate(today.getDate() - 1);
    
    // mm.dd.yyyy 형식으로 포맷팅
    var todayStr = String((today.getMonth() + 1)).padStart(2, '0') + '.' + 
                   String(today.getDate()).padStart(2, '0') + '.' + 
                   today.getFullYear();
    var yesterdayStr = String((yesterday.getMonth() + 1)).padStart(2, '0') + '.' + 
                       String(yesterday.getDate()).padStart(2, '0') + '.' + 
                       yesterday.getFullYear();
    
    // 날짜 필드에 초기값 설정
    $('#rqstDateFr').datebox('setValue', yesterdayStr);
    $('#rqstDateTo').datebox('setValue', todayStr);
}

//체크박스(use-flag)
function formatCheck(value,row,index){
	var d;
	if(value == '1' || value == 'Y' ) d = '<input type="checkbox" checked/>';
	else d = '<input type="checkbox" />';
	return d;
}

//추가 처리
//function doAppend2() {
//	if($('#'+this.id).hasClass('l-btn-disabled')){
//		return false;
//	}
//	consts.easygrid.appendEdit();
//}

//저장 처리
function doSave() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.saveEditCustom(); // consts.easygrid.save() -> consts.easygrid.saveEditCustom() 변경 김원국
}

//중복 submit 방지
var doubleSubmitFlag = true;
function doubleSubmitCheck(){
    if(doubleSubmitFlag){
    	doubleSubmitFlag = false;
    	setTimeout(function () {
    		doubleSubmitFlag = true;
        }, 3000)
        return true;
    }else{
        return false;
    }
}


//날짜포맷함수: YYYY/MM/DD
function doFormatDate(dateobject) {
	var date = moment(dateobject);
    return date.format("MM.DD.YYYY");
};

function formatNumberFloat(value,row,index){
	var d = $.number(value,2);
	return d;
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

//셀 스타일 부여
function cellStylerFile(value,row,index){
	return 'text-decoration: underline; color: #642EFE; cursor: pointer;';
}