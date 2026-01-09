/**
 * 게시판관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 팝업 상세조회
 * 폼 팝업 등록,수정,삭제
 */

//화면 컨트롤 객체
var consts = {};
//그리드 설정
var jgrid  = {};

$(function() {

	using("../../js/module/jupload.js", function() {
		using("../../js/module/jeditor.js", function() {
			using("../../js/module/jboard.js", function() {
				consts.init();
			});
		});
	});

	$('#zoom-dialog').dialog({
//	    title: tit.TITLE0029,
	    iconCls: 'icon-search',
	    top:     10,
	    bottom:  10,
	    width: 624,
	    height: 390,
	    closed: true,
	    modal: true,
	    panel: true,
	    resizable: true
	});

});

$(window).load(function() {

	setTimeout(function (){

		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click",  doExcel);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

	}, 100);

	doLangSettingTable();

});

//그리드 설정
jgrid = {
	grid: false,
	//args.params   필수
	//args.title    필수
	//args.pageSize 필수
	//args.doSelect 필수
	init: function(args) {
		var cols = [{field:'check',    halign:'center',align:'center',checkbox:true},
		            {field:'bordNo', id:"bordNo",   halign:'center',align:'center',width:100, title:'번호', sortable:true,data_item:'GRD_001'},
		            {field:'bordTitle',halign:'center',align:'left',  width:400, title:'제목', sortable:true,data_item:'GRD_002', formatter:jformat.replycnt},
		            //2016/12/22 김영진 -- 파일 첨부 여부
		            {field:'fileCnt',  halign:'center',align:'center',width:40, title:'첨부', data_item:'GRD_009', formatter:jformat.filecnt},
		            //{field:'bordBgn',  align:'center',width: 120, title:'시작일'},
		            //{field:'bordEnd',  align:'center',width: 120, title:'종료일'},
		            {field:'readCnt',  halign:'center',align:'center', width: 60, title:'조회수',sortable:true, data_item:'GRD_003'},
		            {field:'replyCnt',  halign:'center',align:'center', width: 60, title:'답글수',sortable:true, data_item:'GRD_004'},
		            {field:'regiName', halign:'center',align:'center',width: 80, title:'등록자',sortable:true, data_item:'GRD_005'},
		            {field:'regiDate', halign:'center',align:'center',width:130, title:'등록일자',sortable:true, data_item:'GRD_006'},
		            {field:'chngName', halign:'center',align:'center',width: 80, title:'수정자',sortable:true, data_item:'GRD_007'},
		            {field:'chngDate', halign:'center',align:'center',width:130, title:'수정일자',sortable:true, data_item:'GRD_008'}];

		//그리드 컨트롤 초기화
		this.grid = new jeasygrid({
			url:      args.url,
			//title:    args.title,
			gridKey:  "#search-grid",
			sformKey: "#search-form",
			gridOptions: {
				pageSize:     args.pageSize,
				queryParams:  $.extend({}, args.params),
				columns:      [cols],
				toolbar:      "#search-toolbar",
				onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
				idField:      'bordNo',
				fit:          true,
				selectOnCheck:true,
				checkOnSelect: false,//TODO 김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
				onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
				onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
				onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
				onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트
				onSelect: doSelectRow, //2016/09/19 김영진 수정 --행 클릭 이벤트
				//그리드 행더블클릭시 상세조회팝업 오픈
				onDblClickRow:function(index, row) {
					args.doSelect(row);
				},
				onClickCell: doClickCell,  //그리드 셀클릭시 이벤트 바인딩
				onLoadSuccess:function(){

					/*//Enter 검색을 위한 추가
					$(".easyui-textbox").each(function(index, item){
						var itemid = $("#"+item.id);
						itemid.textbox('textbox').bind('keyup', function(e){
							itemid.textbox('setValue', $(this).val());
						});
					});*/
					//doLangSetting();
					//doLangSettingTable();
				}
			}
		});
	},
	search: function() {
		this.grid.search();
	},
	download: function() {
		this.grid.download();
	},
	remove: function() {
		this.grid.removeAll();
	},
	result: function(res, callback) {
		this.grid.reload();
		if (callback)
			callback();
	}
};

//화면컨트롤
consts = {
	sysId: false,    //시스템ID
	title: false,    //제목
	pageSize: false, //출력수
	bordGrup: false, //게시판그룹
	bordType: false, //게시판게시타입
	viewData: false, //상세조회 데이터
	url: {
		search: getUrl("/common/board/video/search.json"),
		excel:  getUrl("/common/board/video/download.do"),
		select: getUrl("/common/board/video/select.json"),
		remove: getUrl("/common/board/video/delete.json"),
		save:   getUrl("/common/board/video/save.json"),
		form:   getUrl("/common/board/video/form.do"),
		view:   getUrl("/common/board/video/view.do")
	},
	params: {
		oper: jstatus.INSERT,
		sysId:    null,
		bordGrup: null,
		bordType: null,
		bordNo:   null,
		bordPno:  null,
		bordTitle:null
	},
	init: function() {
		//그리드 초기화
		jgrid.init(this);
		//팝업폼 초기화
		jsystemboard.init(this);

	},
	//사용가능기능 설정
	/*usable: {
		save:   true, //저장기능 사용여부
		update: true, //수정기능 사용여부
		remove: true, //삭제기능 사용여부
		reply:  false
	},*/
	//등록상태로 변경(params 변경)
	setInsert: function() {
		this.params.oper  = jstatus.INSERT;
		this.params.bordNo = null;
		this.params.bordTitle = null;
		this.params.bordPno   = null;
	},
	//수정상태로 변경(params 변경)
	setUpdate: function() {
		this.params.oper  = jstatus.UPDATE;
	},
	//답변상태로 변경(params 변경)
	setReply: function() {
		this.params.oper  = jstatus.INSERT;
		this.params.bordNo    = null;
		this.params.bordTitle = '[답변]'
			                  + this.viewData.bordTitle;
		this.params.bordPno   = this.viewData.bordNo;
	},
	setParams: function(args) {
		for(var p in args) {
			this.params[p] = args[p];
		}
	},
	getParams: function() {
		return this.params;
	},
	getTitle: function() {
		return this.title;
	},
	doResult: function(res, callback) {
		jgrid.result(res, callback);
	},
	doSelect: function(row) {
		this.viewData = row;
		$.extend(this.params, row);
		jsystemboard.open(jstatus.READ);
	}
};


//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);

		consts.setParams({
			sysId:    consts.sysId,
			bordGrup: consts.bordGrup,
			bordType: consts.bordType
		});

		this.dialog = new jdialog({
			key: "#views-popup",
			title: "조회자 목록"
		});
	}
}
//검색버튼 클릭시 그리드 검색
function doSearch() {
	//권한관리
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	jgrid.search();
}
//엑셀 다운로드
function doExcel() {
	jgrid.download();
}
//삭제버튼 클릭시 그리드 다중행삭제
function doRemove() {
	//권한관리
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}

	jgrid.remove();
}
//추가버튼 클릭시 등록폼 오픈
function doAppend() {
	//권한관리
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}

	jsystemboard.open(jstatus.INSERT);
}

function JSONtoString(object) {
    var results = [];
    for (var property in object) {
        var value = object[property];
        if (value)
            results.push(property.toString() + ': ' + value);
        }

        return '{' + results.join(', ') + '}';
}

//[행클릭] 행클릭 이벤트
function doSelectRow(rowIndex, rowData){

	var responsive = "";

	$('#responsive').remove();

	responsive	+= "<ul id=\"responsive\" class=\"gallery\">"
			 		+ "</ul>"

	$('.demo').html(responsive);

	//bordGrup
	//bordNo
	console.log(rowData);
	$.ajax({
        url: getUrl('/common/file/search.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {atchGrup:rowData.bordGrup
        	,atchNo:rowData.bordNo},
        success: function(data){

        	var imageArea = "";

        	$.map( data.rows, function( v, i ) {

        		var getContextPath = context;
            	var imageRealPath = v.physicalRealName;

            	imageRealPath = imageRealPath.substr(imageRealPath.indexOf("resources"));

            	imageRealPath = getContextPath + "/" + imageRealPath;

//	    		imageArea	+= "<li>"
//	    				 		+ "<a href=\"#\"><img src=\"" + imageRealPath + "\" alt=\"" + v.fileName + "\"></a>"
//	    				 		+ "</li>"

	    		imageArea	+= "<video preload=\"metadata\">"
        				 		+ "<source src=\"" + imageRealPath + "\" type=\"video/mp4\">"
        				 		+ "</video>"
            });

        	$('#responsive').html(imageArea);

        	$("#responsive > video").click(function() {
    		    $(this).addClass("on").siblings().removeClass("on");
    		    return false;
    		});

    		$("#responsive > video").dblclick(function() {

        		var url = window.location.href;
    			url = url.substr(0, url.indexOf("/wsc"));
    		    var address = $(this).children("source");
    		    url = url + address.attr("src");
    		    $("#playingVideo").attr("src",url);

        		var playingVideo = "";

        		$('#playingVideo').remove();

        		playingVideo	+= "<video id=\"playingVideo\" width=\"600\" height=\"330\" controls>"
        				 		+ "<source src=\"" + url + "\" type=\"video/mp4\">"
        				 		+ "</video>"

        		$('#zoom_video').html(playingVideo);

    		    $(this).parent().addClass("on").siblings().removeClass("on");
    			$("#zoom-dialog").dialog({title : rowData.bordTitle});
    		    $("#zoom-dialog").dialog('center');
    			$("#zoom-dialog").dialog('open');
    		    return false;
    		});

    		 $('#responsive').lightSlider({
    		        item:12,
    		        loop:false,
    		        slideMove:2,
    		        easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
    		        speed:600
    		    });

        },
        error: function(){
        }
    })

	if($('#hdfChk').val().indexOf(+"**"+rowIndex+", ") == -1){
		if($('#hdfIndex').val() == rowIndex){
		}else{
			if($('#hdfIndex').val() != "-1"){
				$(this).datagrid('unselectRow', $('#hdfIndex').val());
			}
			$('#hdfIndex').val(rowIndex);
		}

	}else{

		$(this).datagrid('unselectRow', $('#hdfIndex').val());
		$('#hdfIndex').val("-1");
	}

}
//체크박스 클릭 이벤트
function doCheckRow(rowIndex, rowData){
	var chkRow = $('#hdfChk').val();
	chkRow += "**" + rowIndex + ", ";
	$('#hdfChk').val(chkRow);
}
//체크박스 해제 이벤트
function doUnCheckRow(rowIndex, rowData){
	$("#search-grid").datagrid('unselectRow', rowIndex);
	var chkRow = $('#hdfChk').val();
	chkRow = chkRow.replace("**" + rowIndex + ", ", "");
	$('#hdfChk').val(chkRow);
	$('#hdfIndex').val("-1");
}
//체크박스 전체 선택 이벤트
function doCheckAll(rowIndex, rowData){
	var rowCnt = $(this).datagrid('getRows').length;
	var rows = "";
	for(var i = 0; i < rowCnt; i++){
		rows += "**" + i + ", ";
	}
	$('#hdfChk').val(rows);
}
//체크박스 전체 해제 이벤트
function doUnCheckAll(rowIndex, rowData){
	$("#search-grid").datagrid('unselectAll');
	$('#hdfChk').val("");
	$('#hdfIndex').val("-1");
}
//2016/12/13 김영진 -- [내부사용자] 조회수 클릭시 이벤트
function doClickCell(index, field, value) {
	if($('#s_userType').val() == "A"){

		if (field != 'readCnt')
			return;

		var rows = $(this).datagrid('getRows');
		var row  = rows[index];

		document.getElementById("views-iframe").src = context + "/common/board/views.do?bordNo="+row.bordNo+"&bordGrup="+$('#s_bordGrup').val()+"&menuKey="+$('#text_menuKey').val();
		$("#views-popup").dialog('open');
	}
}

function doReplyView(bordNo){
	//
	$("#select-dialog").dialog("close");

	$.ajax({
        url: getUrl("/common/board/video/replyView.json"),
        type: "POST",
        dataType: "json",
        data: { bordNo: bordNo },
        success: function( data ) {
        	consts.viewData = data.rows[0];
    		$.extend(consts.params, data.rows[0]);
    		jsystemboard.open(jstatus.READ);
        },
        error: function (error) {
           alert(error);
        }
	});
}
