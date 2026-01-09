/**
 * 인덱스를 처리하는 스크립트이다.
 */

var consts = {};
//그리드 설정
var jgrid  = {};

var consts2 = {};
//그리드 설정
var jgrid2  = {};
$(function() {

	//상단메뉴 로딩
	//alert("111");
	jwidget.menu.load();
	
	//alert("222");
	//핫메뉴 로딩
	jwidget.hotmenu.load();
	
	//alert("333");
	//팝업 로딩
	jwidget.popup.load();
	//alert("444");
/*	using("../../js/module/jboard.js", function() {

	});*/
	using("../../js/module/jupload.js", function() {
		using("../../js/module/jeditor.js", function() {
			using("../../js/module/jboard.js", function() {
				consts.init();
				//consts2.init();
				
				//LSDP에서 이동하믄 화면이 지정되경우 index->지정화면 으로 이동
				var pdiMenu = getCookie("im_mesMenu");
				if( pdiMenu != "" ){
					deleteCookie("im_mesMenu");
					jmenus.go(pdiMenu);
					return;
				}
			});
		});
	});

	//doBord();
	//doLangSettingPage();
});

//화면컨트롤
consts = {
	sysId:    false, //시스템ID
	title:    false, //제목
	rows:     false, //출력수
	page:     false, //페이지
	bordGrup: false, //게시판그룹
	bordType: false, //게시판게시타입
	formKey: "hidden-form",
	url: {
		search: getUrl("/common/board/notice/search.json"),
		excel:  getUrl("/common/board/notice/download.do"),
		select: getUrl("/common/board/notice/select.json"),
		remove: getUrl("/common/board/notice/delete.json"),
		form:   getUrl("/common/board/notice/form.do"),
		view:   getUrl("/common/board/notice/view.do")
	},
	params: {
		oper: jstatus.INSERT,
		sysId:    null,
		bordGrup: null,
		bordType: null,
		bordNo:   null
	},
	init: function() {
		//그리드 초기화
		jgrid.init(this);

		//게시판 초기화
		jboard.init({
			consts: this,
			url:    this.url,
			params: this.params,
			title:  this.title,
			//등록폼 KEY (#포함)
			formKey: "#"+this.formKey
		});
	},
	setParams: function(args) {
		for(var p in args) {
			this.params[p] = args[p];
		}
	},
	doResult: function(res, callback) {
		jgrid.result(res, callback);
	},
	//검색데이터 설정하기
	setSearchObject: function() {
		//검색데이터 가져오기
		var data = jgrid.getSearchObject();
		//히든폼 가져오기
		var form = jboard.form;
		//히든폼에 검색데이터 셋팅하기
		form.toForm(data);
	},
	//상세조회 페이지로 이동
	doSelect: function(row) {
		this.setSearchObject();
		jboard.doSelect(row);
	}
};

//그리드 설정
jgrid = {
	grid: false,
	//args.params   필수
	//args.title    필수
	//args.rows     필수
	//args.doSelect 필수
	init: function(args) {

		var cols = [{field:'bordTitle',halign:'center',align:'left',  width:370, title:'제목',     sortable:true},
		            {field:'regiDate', halign:'center',align:'center',width:100, title:'등록일자', sortable:true},
		            {field:'bordNo',   halign:'center',align:'center',width:100, title:'번호',     sortable:true}
        ];

		//그리드 컨트롤 초기화
		this.grid = new jeasygrid({
			url:      args.url,
			title:    args.title,
			gridKey:  "#search-grid",
			sformKey: "#search-form",
			gridOptions: {
				pageSize:     args.rows,
				pageNumber:   args.page,
				queryParams:  $.extend({}, args.params),
				columns:      [cols],
				idField:      'bordNo',
				fit:          true,
				singleSelect: true,
				showHeader:   false,
				rownumbers:   false,
				pagination:   false,
				//그리드 행더블클릭시 상세조회팝업 오픈
				onDblClickRow:function(index, row) {
					args.doSelect(row);
				}
			}
		});
	},
	get: function() {
		return this.grid.grid;
	},
	getSearchObject: function() {
		return this.grid.getSearchObject();
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

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);

		consts.setParams({
			sysId:    consts.sysId,
			bordGrup: consts.bordGrup,
			bordType: consts.bordType
		});
	}
}


//그리드 설정
jgrid2 = {
	grid: false,
	//args.params   필수
	//args.title    필수
	//args.pageSize 필수
	//args.doSelect 필수
	init: function(args) {

		var cols = [{field:'bordTitle',halign:'center',align:'left',  width:370, title:'제목',    sortable:true},
		            {field:'regiDate', halign:'center',align:'center',width:100, title:'등록일자'},
		            {field:'regiName', halign:'center',align:'center',width: 80, title:'등록자'},
		            {field:'readCnt',  halign:'center',align:'right', width: 80, title:'조회수'},
		            {field:'bordNo',   halign:'center',align:'center',width:100, title:'번호', sortable:true}
		            ];

		//그리드 컨트롤 초기화
		this.grid = new jeasygrid({
			url:      args.url,
			title:    args.title,
			gridKey:  "#search-grid2",
			sformKey: "#search-form2",
			gridOptions: {
				pageSize:     args.pageSize,
				queryParams:  $.extend({}, args.params),
				columns:      [cols],
				idField:      'bordNo',
				fit:          true,
				singleSelect: true,
				showHeader:   false,
				rownumbers:   false,
				pagination:   false,
				//그리드 행더블클릭시 상세조회팝업 오픈
				onDblClickRow:function(index, row) {
					args.doSelect(row);
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
consts2 = {
	sysId: false,    //시스템ID
	title: false,    //제목
	pageSize: false, //출력수
	bordGrup: false, //게시판그룹
	bordType: false, //게시판게시타입
	buttonStts: true,//메인화면에서 안보이게 하기
	url: {
		search: getUrl("/common/board/search.json"),
		excel:  getUrl("/common/board/download.do"),
		select: getUrl("/common/board/select.json"),
		remove: getUrl("/common/board/delete.json"),
		save:   getUrl("/common/board/save.json"),
		form:   getUrl("/common/board/form.do"),
		view:   getUrl("/common/board/view.do")
	},
	params: {
		oper: jstatus.INSERT,
		sysId:    null,
		bordGrup: null,
		bordType: null,
		bordNo:   null
	},
	init: function() {
		//그리드 초기화
		jgrid2.init(this);
		//팝업폼 초기화
		jsystemboard.init(this);

	},
	//등록상태로 변경(params 변경)
	setInsert: function() {
		this.params.oper  = jstatus.INSERT;
		this.params.bordNo = null;
	},
	//수정상태로 변경(params 변경)
	setUpdate: function() {

		this.params.oper  = jstatus.UPDATE;
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
		jgrid2.result(res, callback);
	},
	doSelect: function(row) {
		$.extend(this.params, row);
		jsystemboard.open(jstatus.READ);
	}
};

//화면 상수값 초기화
function doInit2(args) {
	if (args) {
		$.extend(consts2, args);

		consts2.setParams({
			sysId:    consts2.sysId,
			bordGrup: consts2.bordGrup,
			bordType: consts2.bordType
		});
	}
}

function doBord(){
	fileuploadForm.init();
	/* 알림방 상위 3개 */
    $.ajax({
        url: getUrl('/common/board/alterTop.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        success: function(data){

        	if(data.rows[0] === undefined){
        		return ""
        	}

        	var altertopContent = "";
        	for(var i=0; i < 3; i++){
        		if(data.rows[i]){
        			altertopContent +="<li>";
        			altertopContent +="<a href=\"javascript:doBordDetail('"+data.rows[i].BORD_GRUP+"','"+data.rows[i].BORD_NO+"')\">"+data.rows[i].BORD_TITLE+"</a><span class='tripledots'></span>";
        			altertopContent +="</li>";
        		}else{
        			altertopContent +="<li></li>";
        		}
        	}
        	$("#altertop").html(altertopContent);
        },
        error: function(){
        	//console.log("Error!!");
        }
    });
	/* 알림방 그외 것들 */
    $.ajax({
        url: getUrl('/common/board/alterBottom.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        success: function(data){

        	if(data.rows[0] === undefined){
        		return ""
        	}



        	var alterBottomContent = "";
        	for(var i=0; i < data.rows.length; i++){
        		alterBottomContent +="<li>";
        		alterBottomContent +="<a href=\"javascript:doBordDetail('"+data.rows[i].BORD_GRUP+"','"+data.rows[i].BORD_NO+"')\">"+data.rows[i].BORD_TITLE+" <span class=\"bord-list-right\">"+data.rows[i].REGI_DATE+"</span></a>";
        		alterBottomContent +="</li>";
        	}
        	$("#alterbottom").html(alterBottomContent);
        },
        error: function(){
        	//console.log("Error!!");
        }
    });
	/* 자료실 상위 3개 */
    $.ajax({
        url: getUrl('/common/board/referemceTop.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        success: function(data){

        	if(data.rows[0] === undefined){
        		return ""
        	}

        	var referemcetopContent = "";
        	for(var i=0; i < 3; i++){
        		if(data.rows[i]){
        			referemcetopContent +="<li>";
        			referemcetopContent +="<a href=\"javascript:doBordDetail('"+data.rows[i].BORD_GRUP+"','"+data.rows[i].BORD_NO+"')\">"+data.rows[i].BORD_TITLE+"</a><span class='tripledots'></span>";
        			referemcetopContent +="</li>";
        		}else{
        			referemcetopContent +="<li></li>";
        		}
        	}
        	$("#referemcetop").html(referemcetopContent);
        },
        error: function(){
        	//console.log("Error!!");
        }
    });
	/*알림방 그외 것들*/
    $.ajax({
        url: getUrl('/common/board/referemceBottom.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        success: function(data){

        	if(data.rows[0] === undefined){
        		return ""
        	}

        	var referemceBottomContent = "";
        	for(var i=0; i < data.rows.length; i++){
        		referemceBottomContent +="<li>";
        		referemceBottomContent +="<a href=\"javascript:doBordDetail('"+data.rows[i].BORD_GRUP+"','"+data.rows[i].BORD_NO+"')\">"+data.rows[i].BORD_TITLE+" <span class=\"bord-list-right\">"+data.rows[i].REGI_DATE+"</span></a>";
        		referemceBottomContent +="</li>";
        	}
        	$("#referemcebottom").html(referemceBottomContent);
        },
        error: function(){
        	//console.log("Error!!");
        }
    });

    var noticeNo = ""
    /* 공지사항 상위 3개 */
    $.ajax({
        url: getUrl('/common/board/noticeTop.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        success: function(data){
        	var noticeopContent = "";


        	if(data.rows[0] === undefined){
        		return ""
        	}

        	noticeNo = data.rows[0].BORD_NO;




        	for(var i=0; i < 3; i++){
        		if(data.rows[i]){


        			var bordTitle = data.rows[i].BORD_TITLE;

        			noticeopContent +="<li>";
        			noticeopContent +="<a href=\"javascript:void(0);\" onclick=\"doNoticeDetail('"+data.rows[i].BORD_GRUP+"','"+data.rows[i].BORD_NO+"');\">"+data.rows[i].BORD_TITLE+"</a><span class='tripledots'></span>";
        			noticeopContent +="</li>";
        		}else{
        			noticeopContent +="<li></li>";
        		}
        	}
        	$("#noticetop").html(noticeopContent);
        },
        error: function(){
        }
    });

    /*공지사항 상세 */
    $.ajax({
        url: getUrl('/common/board/searchBordDetail.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {bordGrup:'B01'
        	 , bordNo:noticeNo},
        success: function(data){
        	if(data.rows.length > 0){
            	$("#n_bordText").html(data.rows[0].bordText);
        	}
        },
        error: function(){
        	//console.log("Error!!");
        }
    });


    if(window.innerWidth<900){

    	$('#bord-popup-dialog').dialog({
    	    title: tit.TITLE0036,
    	    iconCls: 'icon-search',
    	    width: 355,
    	    height: 700,
    	    closed: true,
    	    modal: true,
    	    panel: true,
    	    resizable: true
    	});

    }
    else if(window.innerWidth>=900){
    	/* 팝업창 초기화 */

    	$('#bord-popup-dialog').dialog({
    	    title: tit.TITLE0036,
    	    iconCls: 'icon-search',
    	    width: 800,
    	    height: 700,
    	    closed: true,
    	    modal: true,
    	    panel: true,
    	    resizable: true
    	});
    }


}

function doBordDetail(grup, no){

	$("#h_atchNo").val(no);
	$("#h_atchGrup").val(grup);

	if($("#h_atchGrup").val() == 'B08'){
    	$('#bord-popup-dialog').dialog({
    	    title: tit.TITLE0036
    	});
	}else{
    	$('#bord-popup-dialog').dialog({
    	    title: tit.TITLE0036
    	});
	}

	$("#bord-popup-dialog").dialog('open');
	//console.log($("#h_atchGrup").val());
	//console.log($("#h_atchNo").val());

    $.ajax({
        url: getUrl('/common/board/searchBordDetail.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {bordGrup:$("#h_atchGrup").val()
        	 , bordNo:$("#h_atchNo").val()},
        success: function(data){
        	if(data.rows.length > 0){
            	$("#v_bordTitle").html(data.rows[0].bordTitle);
            	$("#v_regiName").html(data.rows[0].regiName);
            	$("#v_readCnt").html(data.rows[0].readCnt);
            	$("#v_regiDate").html(data.rows[0].regiDate);
            	$("#v_chngDate").html(data.rows[0].chngDate);
            	$("#v_bordText").html(data.rows[0].bordText);
            	$("#h_atchNo").val(data.rows[0].bordNo);
            	$("#h_atchGrup").val(data.rows[0].bordGrup);

            	fileuploadForm.easygrid.search();
        	}
        },
        error: function(){
        	//console.log("Error!!");
        }
    });
}

function doNoticeDetail(grup, no){

	$("#h_atchNo").val(no);
	$("#h_atchGrup").val(grup);

    $.ajax({
        url: getUrl('/common/board/searchBordDetail.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {bordGrup:$("#h_atchGrup").val()
        	 , bordNo:$("#h_atchNo").val()},
        success: function(data){
        	if(data.rows.length > 0){
        		$("#n_bordText").html(data.rows[0].bordText);
        	}
        },
        error: function(){
        }
    });
}

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
				sformKey: "#bord-search-form"
			});
			//그리드 생성
			this.easygrid.init({
				fit: true,
				singleSelect: true,
				pageSize: this.pageSize,
				idField:  'codeCd',
				pagination:   false,
				//행선택시 상세조회 이벤트 바인딩
				//onSelect: this.easygrid.select,
				singleSelect: true,
				onClickCell: function(index, field, value) {
					if (field == 'fileDown') {
						var rows = $(this).datagrid('getRows');
						var row  = rows[index];

						if (row.exist != true) {
							$.messager.alert("Error", msg.MSG0113, 'error');
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

$(window).load(function() {
	
	setTimeout(function (){
		$(".wui-dialog").show();

		$("#account-layout").fadeIn(300);
		
		//$("#info_click").bind("click", infoClick);
		
		//if($("#hOrgAuthCode").val() =="DEAL"){
		//	CoOpList()
		//}
	}, 100);
	//AgingTractorStatCount();
	/*
	if($('#userDashType').val() == 'DT05'||$('#userDashType').val() == 'DT04'){
		tractorStatCount2();
		AgingTractorStatCountDt04();
	}
	
	if($('#hOrgAuthCode').val() == 'DEAL') {
		ReadyToShipList();
	}
	*/
	//doLangSettingPage();
});

function infoClick() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	location.href="/wsc/common/board/saleinfo/saleinfo.do";
}

function doMemuGo(key){
	jmenus.go(key);
	/*if($("#hOrgAuthCode").val() == 'DEAL'){
		doCheckDealStatus(key)
	}
	else{
		jmenus.go(key);
	}*/
}

function doCheckDealStatus(key){
	var dealCode = $("#user_id").val();
	
	if(!Utils.isNull(dealCode)){
		$.ajax({
	        url: getUrl("/order/ordering/ordercreate/getDealerStatus.json"),
	        dataType: "text",
	        type: 'post',
	        data: {dealCode : dealCode},
	        success: function(result) {
	        	var obj = JSON.parse(result);
	        	rows = obj.rows[0];
	        },
	        error:  function(result) {
	        },
	        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
	        	if(!Utils.isNull(rows)){
	        		if(rows.DEAL_STAT == "Block"){
		        		alert(msg.MSG0139);
		        	}else if($("#hOrgAuthCode").val() == 'DEAL' && rows.WGO_IDX == "N"){
		        		alert(msg.MSG0139);
		        	}
	        		else{
	        			jmenus.go(key);
	        		}
	        		
	        	}else{
	        		jmenus.go(key);
	        	}
	        }
	     });
	}
}

function doOrderStatus() {
	if($("#s_userType").val() == "C") jmenus.go('LS154');
	else jmenus.go('LS157');
}

/**
 * UI 컴포넌트를 지원하는 스크립트이다.
 *
 * @author C-NODE
 * @version 1.0 2014/08/01
 */
// 게시물 이동
var jmenus2 = {
	//========================================================//
	// 메뉴목록 및 상위메뉴맵
	//--------------------------------------------------------//
	MENUS  : false, //메뉴목록
	MMAP   : {},    //메뉴맵
	TMAP   : {},    //최상위메뉴맵
	_find: function(key, map) {
		if (!map)
			return false;
		for (var p in map) {
			if (p == key)
				return map[p];
		}
		return false;
	},
	get: function() {
		return this.MENUS;
	},
	//특정메뉴KEY의 최상위메뉴 찾기
	getMap: function(key) {
		return this._find(key, this.TMAP);
	},
	//특정메뉴KEY의 메뉴 찾기
	getMenu: function(key) {
		return this._find(key, this.MMAP);
	},
	init: function(menus) {
    	this.MENUS = menus;
    	this.TMAP  = {};
    	this.MMAP  = {};
    	//메뉴맵 생성
    	this.build(this.MENUS);
	},
	build: function(menus, root) {
		if (!menus ||
			 menus.length == 0)
			return;
		var m = this;
		$.each(menus, function(i,c) {
			if (!root ||
				 c.menuLevel == 1)
				root = c;
			m.TMAP[c.menuKey] = root;
			m.MMAP[c.menuKey] = c;
			if (c.subs)
				m.build(c.subs, root);
		});
	},
	//========================================================//
	// 메뉴링크 열기(탭열기)
	//--------------------------------------------------------//
	go: function(key, param) {
			
			var tabYn = gconsts.TAB_PANEL;
			var obj   = jmenus.getMenu(key);
			var url   = obj.menuUrl;
			var desc  = obj.menuDesc;
			var pDesc = obj.parentDesc;
			var type  = obj.procType;
			var flag  = "link"; //tab, link
	
			if (url == "#")
				return;
	
			//탭패널 사용가능이고 탭방식인 경우
			if (tabYn == 'Y' &&
				type  == 'T')
				flag  = "tab";
	
			//링크방식인 경우
			if (flag == "link") {
				jmenus.submit({
					key: key,
					url: url,
					desc: desc,
					pDesc:pDesc,
					link: getUrl(url)
				});;
				//return 'jmenus.move(\''+ menu.menuUrl+ '\');';
				return;
			}
	
			//탭이 없는 경우
			if (jwidget.tabs.exist() == false) {
				jmenus.submit({
					key: key,
					url: "/common/board/saleprog/view.do?bordNo=" + param,
					desc: desc,
					pDesc:pDesc,
					link: getUrl(jwidget.tabs.consts.URL)
				});
			    return;
			}
			//탭이 있는 경우 탭생성
			jwidget.tabs.create({
				menuKey:  key,
				menuUrl:  url,
				menuDesc: desc,
				parentDesc:pDesc
			});
		},
		go2: function(key, param) {
			
			var tabYn = gconsts.TAB_PANEL;
			var obj   = jmenus.getMenu(key);
			var url   = obj.menuUrl;
			var desc  = obj.menuDesc;
			var pDesc = obj.parentDesc;
			var type  = obj.procType;
			var flag  = "link"; //tab, link
	
			if (url == "#")
				return;
	
			//탭패널 사용가능이고 탭방식인 경우
			if (tabYn == 'Y' &&
				type  == 'T')
				flag  = "tab";
	
			//링크방식인 경우
			if (flag == "link") {
				jmenus.submit({
					key: key,
					url: url,
					desc: desc,
					pDesc:pDesc,
					link: getUrl(url)
				});;
				//return 'jmenus.move(\''+ menu.menuUrl+ '\');';
				return;
			}
	
			//탭이 없는 경우
			if (jwidget.tabs.exist() == false) {
				jmenus.submit({
					key: key,
					url: "/common/board/lsnews/view.do?bordNo=" + param,
					desc: desc,
					pDesc:pDesc,
					link: getUrl(jwidget.tabs.consts.URL)
				});
			    return;
			}
			//탭이 있는 경우 탭생성
			jwidget.tabs.create({
				menuKey:  key,
				menuUrl:  url,
				menuDesc: desc,
				parentDesc:pDesc
			});
		},
	//========================================================//
	// 메뉴링크 열기(페이지이동)
	//--------------------------------------------------------//
	move: function( url ) {
		if (url == "#")
			return;
		top.location.href = getUrl(url);
	},
	//========================================================//
	// 메뉴링크 폼이동(페이지이동)
	//--------------------------------------------------------//
	
	
	submit: function( obj ) {
		//console.log(obj.pDesc );
		var form = $("#menu-form");
		form.find("[name=menuKey]" ).val( obj.key  );
		form.find("[name=menuUrl]" ).val( obj.url  );
		form.find("[name=menuDesc]").val( obj.desc );
		form.find("[name=parentDesc]").val( obj.pDesc );
	    form.attr("action", obj.link );
	    form.attr("target", "_self");
	    form.submit();
	},

	//========================================================//
	// 메뉴링크 스크립트
	//--------------------------------------------------------//
	getLink: function(menu) {
		return "jmenus.go('"+menu.menuKey+"');";
	}
	//========================================================//
};

// Dash보드 게시글 클릭시 해당 게시판으로 이동
function changeBoard(bordNo){
	var bNo = bordNo;
	jmenus2.go('LS352', bNo);
	/*location.href=getUrl("/common/board/saleinfo/view.do?bordNo="+$("#bordNo").val()+"");*/
}
function changeBoard2(bordNo){
	var bNo = bordNo;
	jmenus2.go2('LS351', bNo);
	/*location.href=getUrl("/common/board/saleinfo/view.do?bordNo="+$("#bordNo").val()+"");*/
}

function getSoapCount(){
	
	var rowsSc;
    var rowsBm;
	var soapC = $("#soapCount");
	var order = 0;
	var ship  = 0;
	var comp  = 0;
	
	//console.log($("#user_id").val());
	//console.log($("#user_gd").val());
	
	var userGd = $("#user_gd").val(); //유저 분류
	
	if($("#user_gd").val() =="DEAL"){
		var userId = $("#user_id").val(); //유저 ID
	}
	else{
		var userId = " ";
	}
	
	
	var date = new Date(); 
	
	var year = new String(date.getFullYear()-1); //2018 
	var year2 = new String(date.getFullYear()); //2019 
	
	var month  = new String(date.getMonth()-3); //01 (5월기준)
	var month2 = new String(date.getMonth()+1); //05  
	
	var day = new String(date.getDate()-30); 
	var day2 = new String(date.getDate()); 

	//var stDate = year + (month[1] ? month : '0'+month[0]) + (day[1] ? day : '0'+day[0]);
	var stDate = year + '0101';
	var edDate = year2 + (month2[1] ? month2 : '0'+month2[0]) + (day2[1] ? day2 : '0'+day2[0]);
	
	//console.log("FromDate",stDate);
	//console.log("ToDate",edDate);
	
	$.ajax({//configuration/configurating/selectCharBm.json
		url: getUrl("/common/user/soapCount.json"),
        dataType: "text",
        type: 'post',
        data: { 
        		userId : userId,
        		stDate : stDate,
        		edDate : edDate
        		},
        success: function(result) {
        	var obj = JSON.parse(result);
        	rowsSc = obj.rows;
        	
        	//테스트용 ajax
        	/*$.ajax({
        		url: getUrl("/configuration/configurating/selectCharBmC.json"),
                dataType: "text",
                type: 'post',
                data: { 
                		},
                success: function(result) {
                	var obj = JSON.parse(result);
                	rowsSc = obj.rows;
                	console.log(rowsSc);
                },
                error:  function(result) {
                },
                complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
                	
                }
             });*/
        	
        },
        error:  function(result) {
        },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
        	
        	if($("#user_gd").val() =="BM"){
        		
        		var userIdBm = $("#user_id").val(); //유저 ID
        		
        		$.ajax({
            		url: getUrl("/configuration/configurating/selectCharBm.json"),
                    dataType: "text",
                    type: 'post',
                    data: { 
                    		userIdBm : userIdBm
                    		},
                    success: function(result) {
                    	var obj = JSON.parse(result);
                    	rowsBm = obj.rows;
                    },
                    error:  function(result) {
                    },
                    complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
                    	
                    	for(i=0; i<rowsBm.length; i++){
                    		for(j=0; j<rowsSc.length; j++){
                    			if(rowsBm[i].DEAL_CODE == rowsSc[j].sitecd && rowsSc[i].status == "1"){
                    				order++;
                    			}
                    			if(rowsBm[i].DEAL_CODE == rowsSc[j].sitecd && rowsSc[i].status == "2"){
                    				ship++;
                    			}
                    			if(rowsBm[i].DEAL_CODE == rowsSc[j].sitecd && rowsSc[i].status == "3"){
                    				comp++;
                    			}
                    		}
                    	}
                    	
                    	var content = "";
            			content += "<div class=\"col-md-12 dash_footer_line\"></div>";
            			content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
                		content += "	<span style=\"font-size: 18px; font-weight: bold;\">· Order";
                		content += "	</span>";
                		content += "	<span class=\"\" style=\"float: right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
                		content += order;
                		content += "	</span>";
                		content += "</div>";
                		
                		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
                		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
                		content += "	<span style=\"font-size: 18px; font-weight: bold;\">· Ship to Ready";
                		content += "	</span>";
                		content += "	<span class=\"\" style=\"float: right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
                		content += ship;
                		content += "	</span>";
                		content += "</div>";
                		
                		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
                		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
                		content += "	<span style=\"font-size: 18px; font-weight: bold;\">· Complete";
                		content += "	</span>";
                		content += "	<span class=\"\" style=\"float: right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
                		content += comp;
                		content += "	</span>";
                		content += "</div>";
                		
                		
                		soapC.append(content); 
                    }
                    
                 });
        	}
        	else{
        		for(i=0; i<rowsSc.length; i++){
    				if(rowsSc[i].status == "1"){
    					order++;
    				}
    				if(rowsSc[i].status == "2"){
    					ship++;
    				}
            		if(rowsSc[i].status == "3"){
            			comp++;
            		}
            	}
        		var content = "";
    			content += "<div class=\"col-md-12 dash_footer_line\"></div>";
    			content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"font-size: 18px; font-weight: bold;\">· Order";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\"float: right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += order;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"font-size: 18px; font-weight: bold;\">· Ship to Ready";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\"float: right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += ship;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"font-size: 18px; font-weight: bold;\">· Complete";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\"float: right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += comp;
        		content += "	</span>";
        		content += "</div>";
        		
        		
        		soapC.append(content); 
        	}
        	
        	
        }
     });
}

//연도별 금액가져오기
/*function CoOpList(){
	var rows;
	$.ajax({
        url: getUrl("/configuration/configurating/cooplist/getYearCoOpList.json"),
        dataType: "text",
        type: 'post',
        data: {},
        success: function(result) {
        	var obj = JSON.parse(result);
        	rows = obj.rows;
        	if(rows.length > 0){
            	$("#BUDG_AMT").text(rows[0].BUDG_AMT);
            	$("#EXECUTED").text(rows[0].EXECUTED);
            	$("#REMAINED").text(rows[0].REMAINED);
        	} else{
            	$("#BUDG_AMT").text('0');
            	$("#EXECUTED").text('0');
            	$("#REMAINED").text('0');
        	}
        },
        error:  function(result) {
        },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수

        }
     });
}
*/



function tractorStatCount2(){
	var rowsTc;
	var bordTc2 = $("#bordTc2");
	var bordAgTc = $("#bordAgTcDt05");
	var ordrAbbr = $("#ordrAbbr").combobox('getValue');
	bordTc2.empty();
	bordAgTc.empty();
	
	$.ajax({
        url: getUrl("/common/board/searchbordtc.json"),
        dataType: "text",
        type: 'post',
        data: { 
        	},
        success: function(result) {
        	var obj = JSON.parse(result);
        	rowsTc = obj.rows;
        	
        },
        error:  function(result) {
        },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수 
        	/* console.log(rowsTc);
        	console.log(rowsTc[0].v_cnt_100); */
        	if(ordrAbbr == 'tr'){
            	var content = "";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;\">";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "Tractor";
        		content += "	</span>";
        		content += "</div>";
    	
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Ordered";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_200;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
    			content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Reviewed";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_300;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Confirmed";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_400;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· RTS";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_500;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Shipped";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_550;
        		content += "	</span>";
        		content += "</div>";
        		
    			bordTc2.append(content); 
        	}
        	else{
            	var content = "";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;\">";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\" font-size: 18px; font-weight: bold; \">";
        		content += "Others"
        		content += "	</span>";
        		content += "</div>";
    	
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Ordered";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\" font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_200;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
    			content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Reviewed";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\" font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_300;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Confirmed";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\" font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_400;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· RTS";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\" font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_500;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Shipped";
        		content += "	</span>";
        		content += "	<span class=\"\" style=\" font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_550;
        		content += "	</span>";
        		content += "</div>";
        		
    			bordTc2.append(content); 
        	}

        }
        
     });
	
	$.ajax({
        url: getUrl("/common/board/searchbordagtc04.json"),
        dataType: "text",
        type: 'post',
        data: { 
        	},
        success: function(result) {
        	var obj = JSON.parse(result);
        	rowsTc = obj.rows;
        	
        },
        error:  function(result) {
        },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수 
        	/* console.log(rowsTc);
        	console.log(rowsTc[0].v_cnt_100); */
        	if(ordrAbbr == 'tr'){
	        	var content = "";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "~30Days";
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "~60Days"
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "~90Days";
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "90Days~"
        		content += "	</span>";
        		content += "</div>";
    	
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_200;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_200;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_200;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_200;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
    			content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_300;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_300;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_300;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_300;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_400;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_400;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_400;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_400;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_500;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_500;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_500;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_500;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_550;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_550;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_550;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_550;
        		content += "	</span>";
        		content += "</div>";
        		
    			bordAgTc.append(content); 
        	}
        	else{
	        	var content = "";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "~30Days";
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "~60Days"
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "~90Days";
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "90Days~"
        		content += "	</span>";
        		content += "</div>";
    	
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_200;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d60_cnt_200;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d90_cnt_200;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d95_cnt_200;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
    			content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_300;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d60_cnt_300;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d90_cnt_300;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d95_cnt_300;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_400;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d60_cnt_400;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d90_cnt_400;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d95_cnt_400;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_500;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d60_cnt_500;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d90_cnt_500;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d95_cnt_500;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"\">";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_cnt_550;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d60_cnt_550;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d90_cnt_550;
        		content += "	</span>";
        		content += "	<span class=\"dt05\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_o_d95_cnt_550;
        		content += "	</span>";
        		content += "</div>";
        		
    			bordAgTc.append(content); 
        		
        	}

        			
        }
        
     });
}



function AgingTractorStatCount(){
	var rowsTc;
	var bordAgTc = $("#bordAgTc");
	
	$.ajax({
        url: getUrl("/common/board/searchbordagtc.json"),
        dataType: "text",
        type: 'post',
        data: { 
        	},
        success: function(result) {
        	var obj = JSON.parse(result);
        	rowsTc = obj.rows;
        	
        },
        error:  function(result) {
        },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수 
        	/* console.log(rowsTc);
        	console.log(rowsTc[0].v_cnt_100); */
        	var content = "";
	        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
	        		content += "	<span style=\"width: 200px; display: inline-block;\">";
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"font-size: 18px; font-weight: bold; \">";
	        		content += "Tractor";
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; \">";
	        		content += "Others"
	        		content += "	</span>";
	        		content += "</div>";
        	
	        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
	        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
	        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· ~30 Days";
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_cnt_200;
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_o_cnt_200;
	        		content += "	</span>";
	        		content += "</div>";
	        		
	        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        			content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
	        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· ~90 Days";
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_cnt_300;
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_o_cnt_300;
	        		content += "	</span>";
	        		content += "</div>";
	        		
	        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
	        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
	        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· ~180 Days";
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_cnt_400;
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_o_cnt_400;
	        		content += "	</span>";
	        		content += "</div>";
	        		
	        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
	        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
	        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· ~360 Days";
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_cnt_500;
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_o_cnt_500;
	        		content += "	</span>";
	        		content += "</div>";
	        		
	        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
	        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
	        		content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· 360~ Days";
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_cnt_550;
	        		content += "	</span>";
	        		content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
	        		content += rowsTc[0].v_o_cnt_550;
	        		content += "	</span>";
	        		content += "</div>";
	        		
        			bordAgTc.append(content); 
        	}
        
     });
}

function AgingTractorStatCountDt04(){
	var rowsTc;
	var bordAgTc = $("#bordAgTcDt04");
	var ordrAbbr = $("#ordrAbbr").combobox('getValue');
	bordAgTc.empty();
	
	$.ajax({
        url: getUrl("/common/board/searchbordagtc04.json"),
        dataType: "text",
        type: 'post',
        data: { 
        	},
        success: function(result) {
        	var obj = JSON.parse(result);
        	rowsTc = obj.rows;
        	
        },
        error:  function(result) {
        },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수 
        	/* console.log(rowsTc);
        	console.log(rowsTc[0].v_cnt_100); */
        	if(ordrAbbr == 'tr'){
	        	var content = "";

				content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 listHDiv \">";
				content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
				content += "	</div>";
				content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += "~30D";
        		content += "	</div>";
				content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += "~60D"
        		content += "	</div>";
				content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += "~90D";
        		content += "	</div>";
				content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += "90D~"
        		content += "	</div>";
				content += "</div>";
    	
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >Orderd";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_cnt_200;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d60_cnt_200;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d90_cnt_200;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d95_cnt_200;
        		content += "	</div>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >Reviewd";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_cnt_300;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d60_cnt_300;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d90_cnt_300;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d95_cnt_300;
        		content += "	</div>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >Confirmed";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_cnt_400;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d60_cnt_400;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d90_cnt_400;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d95_cnt_400;
        		content += "	</div>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >RTS";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_cnt_500;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d60_cnt_500;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d90_cnt_500;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d95_cnt_500;
        		content += "	</div>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >Shipped";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_cnt_550;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d60_cnt_550;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d90_cnt_550;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_d95_cnt_550;
        		content += "	</div>";
        		content += "</div>";
				
				
				
				
        		/*content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"min-width: 412px;\">";
        		content += "	<span style=\"width: 95px; display: inline-block;\">";
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "~30D";
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "~60D"
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "~90D";
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; \">";
        		content += "90D~"
        		content += "	</span>";
        		content += "</div>";
    	
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"min-width: 412px;\">";
        		content += "	<span style=\"width: 95px; display: inline-block;font-size: 18px; font-weight: bold;\">· Orderd";
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_200;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_200;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_200;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_200;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
    			content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"min-width: 412px;\">";
        		content += "	<span style=\"width: 95px; display: inline-block;font-size: 18px; font-weight: bold;\">· Reviewd";
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_300;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_300;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_300;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_300;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"min-width: 412px;\">";
        		content += "	<span style=\"width: 95px; display: inline-block;font-size: 18px; font-weight: bold;\">· Confirmed";
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_400;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_400;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_400;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_400;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"min-width: 412px;\">";
        		content += "	<span style=\"width: 95px; display: inline-block;font-size: 18px; font-weight: bold;\">· RTS";
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_500;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_500;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_500;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_500;
        		content += "	</span>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"min-width: 412px;\">";
        		content += "	<span style=\"width: 95px; display: inline-block;font-size: 18px; font-weight: bold;\">· Shipped";
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_cnt_550;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d60_cnt_550;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d90_cnt_550;
        		content += "	</span>";
        		content += "	<span class=\"dt04\" style=\"font-size: 18px; font-weight: bold; color: #ff0000;\">";
        		content += rowsTc[0].v_d95_cnt_550;
        		content += "	</span>";
        		content += "</div>";*/
        		
    			bordAgTc.append(content); 
        	}
        	else{
        		
	        	var content = "";
	        	content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 listHDiv \">";
	        	content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
				content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += "~30D";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += "~60D"
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += "~90D";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += "90D~"
        		content += "	</div>";
        		content += "</div>";
    	
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >Orderd";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_cnt_200;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d60_cnt_200;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d90_cnt_200;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d95_cnt_200;
        		content += "	</div>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >Reviewd";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_cnt_300;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d60_cnt_300;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d90_cnt_300;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d95_cnt_300;
        		content += "	</div>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >Confirmed";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_cnt_400;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d60_cnt_400;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d90_cnt_400;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d95_cnt_400;
        		content += "	</div>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >RTS";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_cnt_500;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d60_cnt_500;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d90_cnt_500;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d95_cnt_500;
        		content += "	</div>";
        		content += "</div>";
        		
        		content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
        		content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4 wd-20per\" >Shipped";
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_cnt_550;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d60_cnt_550;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d90_cnt_550;
        		content += "	</div>";
        		content += "	<div class=\"col-md-4 col-sm-4 col-xs-4 wd-20per\" >";
        		content += rowsTc[0].v_o_d95_cnt_550;
        		content += "	</div>";
        		content += "</div>";
        		
    			bordAgTc.append(content); 
        		
        	}

        			
        }
        
     });
}

function ReadyToShipList(){
	var data;
	var bordRts = $("#bordShip04");
	bordRts.empty();
	
	// 출하 대기 리스트 가져오기
	$.ajax({
        url: getUrl("/common/board/searchBordRts04.json"),
        dataType: "text",
        type: 'post',
        data: { 
        	},
        success: function(result) {
        	var obj = JSON.parse(result);
        	data = obj.rows;
        	
        	var content = "";
        	
        	if (data.length > 0) {
        		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"min-width: 412px;\">";
	    		content += "	<span class=\"rts04_1\" style=\"font-size: 18px; font-weight: bold; \">";
	    		content += "PO No.";
	    		content += "	</span>";
	    		content += "	<span class=\"rts04_2\" style=\"font-size: 18px; font-weight: bold; \">";
	    		content += "Ship Date"
	    		content += "	</span>";
	    		content += "	<span class=\"rts04_3\" style=\"font-size: 18px; font-weight: bold; \">";
	    		content += "Main Item"
	    		content += "	</span>";
	    		content += "</div>";
	    		
	    		for (var i=0; i<data.length; i++) {
	        		content += "<div class=\"col-md-12 dash_footer_line\"></div>";
		    		content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"min-width: 412px;\">";
		    		content += "	<span class=\"rts04_1\" style=\"font-size: 15px; font-weight: bold; \">";
		    		content += data[i].ORDR_NO;
		    		content += "	</span>";
		    		content += "	<span class=\"rts04_2\" style=\"font-size: 15px; font-weight: bold; \">";
		    		
		    		if (data[i].SHIP_DATE != undefined) {
		    			content += data[i].SHIP_DATE;
		    		}
		    		
		    		content += "	</span>";
		    		content += "	<span class=\"rts04_4 ellipsis\" style=\"font-size: 14px; font-weight: bold; \">";
		    		content += data[i].ITEM_NAME;
		    		content += "	</span>";
		    		content += "</div>";
	        	}
	    		
        	} else {
        		
        		//content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"min-width: 412px;\">";
				content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \" style=\"margin: 0 auto; width: 100%; height: 100%; font-size: 14px; color: gray; display: flex; justify-content: center; align-items: center; text-align: center; font-weight: 400;\">";
	    		content += "<span class=\"rts04_no\">No Data.</span>";
	    		content += "</div>";
	    		
	    		$("#bordShip04").attr("overflow-y","hidden");
	    		$("#bordShip04").attr("overflow-x","hidden");
        	}
    		
    		bordRts.append(content);
        	
        },
        error:  function(result) {
        },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수 
        	/* console.log(rowsTc);
        	console.log(rowsTc[0].v_cnt_100); */
        	
        }
        
     });
}

//ndm order popup
function ndmOrderPop(userId) {
	/*
	var _width = '1300';
	var _height = '750'; 

    // 팝업을 가운데 위치시키기 위해 아래와 같이 값 구하기
    var _left = Math.ceil(( window.screen.width - _width )/2);
    var _top = Math.ceil(( window.screen.height - _height )/2); 

	let hostIndex = location.href.indexOf( location.host ) + location.host.length;
	let contextPath = location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );

	var pop = window.open(contextPath+'/ndmorder/ndmorder/ndmordermain.do?userId='+userId, 'ndmorder_'+userId,'width='+ _width +',height='+ _height +',left=' + _left + ',top='+ _top);
	*/
	window.open(context+'/ndm', '_blank' );
}
