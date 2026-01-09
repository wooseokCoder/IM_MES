/**
' * 시스템관리 공통업무 스크립트
 */
//시스템영역 그리드 공통설정
var jsystemgrid = function(args) {

	var options = {
		url:         false, //필수
		key:         false, //필수
		sform:       false, //필수 TODO 김원국 수정
		title:       false, //필수
		idTitle:     false, //필수
		idField:     false, //필수
		idInput:     false, //필수
		nameField:   false, //필수
		pageSize:    false, //필수
		iconCls:     'icon-search',
		pagination:   true,
		rownumbers:   true,
		singleSelect: true,
		grid:  false //그리드 객체
	};
	$.extend(true, options, args);

	//TODO 김원국 추가
	options.grid  = $(options.key);
	options.sform = $(options.sform);
	this.grid  = options.grid;
	this.sform = options.sform;


	if ($(options.key).length == 0)
		return null;

	$(options.key).datagrid(options);

	this.getRow = function() {
		var g = $(options.key);
		return g.datagrid('getSelected');
	};

	this.getId = function() {
		var row = this.getRow();

		if (row == null)
			return null;

		return row[options.idField];
	};

	this.reload = function() {
		$(options.key).datagrid('reload');
	};

	this.bindInput = function() {
		var id = this.getId();
		$("#"+options.idInput).val("");

		if (id != null)
			$("#"+options.idInput).val(id);
	};
	//BBUG.KWK 20150728 Reload시 값 바인딩 풀기
	this.unbindInput = function() {
		$("#"+options.idInput).val("");
	};

	this.appendRow = function() {
		var row = this.getRow();

		if (row  == null) {
			$.messager.show({title: msg.MSG0087, msg: options.title+"에서 추가할 "+options.idTitle+"을 선택하세요."});
			return null;
		}
		return row;
	};

	this.getText = function(row, color) {
		return options.idTitle
		     + ":<font color="+color+"><b>["
		     + row[options.idField]
		     + ":"
		     + row[options.nameField]
		     + "]</b></font>";
	};

	this.getObject = function(row) {

		var obj = {};
		obj[options.idField]   = row[options.idField];
		obj[options.nameField] = row[options.nameField];

		return obj;
	};

	this.equals = function(row, obj) {
		if (row[options.idField] == obj[options.idField])
			return true;

		return false;
	};

	//TODO 김원국 수정
	this.search = function() {
		var data = this.getSearchData();
		options.grid.datagrid('load',data);

        //g.datagrid('reload');
	};

	//TODO 김원국 수정
	this.getSearchData = function() {
		var f = options.sform;
		return f.serializeObject();
	};

	return this;
};

//사용자,화면,그룹의 그리드 설정
var jsystem = {
	ggrid: false,
	ugrid: false,
	pgrid: false,
	gkey:  "#group-grid",
	ukey:  "#user-grid",
	pkey:  "#prog-grid",
	uform:  "#user-form",
	gform:  "#group-form",
	pform:  "#prog-form",
	//type = "UG": User  & Group
	//type = "GP": Group & Program
	//type = "UP": User  & Program
	type:  "GP",
	init: function(type, pageSize) {

		this.type = type;

		this.ggrid = new jsystemgrid({
			url:     getUrl("/common/user/group/search.json"),
			key:     this.gkey,
			sform:    this.gform,
			toolbar:  "#group-toolbar",
			fit:     true,
			//title:   "그룹목록",
			idTitle: "그룹",
			idField: "groupId",
			nameField: "groupName",
			idInput: "s_groupId",
			pageSize: pageSize,
			//BBUG.KWK : 20150728 수정 row클릭시 검색 될수 있도록 수정
			onClickRow:   function(index, row){
				doSearch();
			},
			onLoadSuccess: function() {
				$(this).datagrid('clearSelections');
				//alert(this.gkey);
//				//chang
//				$(jsystem.gkey).datagrid('getPanel').panel('panel').attr('tabindex',1).bind('keydown',function(e){
//					//alert(jsystem.gkey);
//				var selectedrow = $(jsystem.gkey).datagrid('getSelected');
//				var rowIndex = $(jsystem.gkey).datagrid("getRowIndex", selectedrow);
//				var rowMaxlength = $(jsystem.gkey).datagrid('getRows');
//					if(event.keyCode == 38){
//						if(!(rowIndex == 0)){
//							$(jsystem.gkey).datagrid('selectRow',rowIndex - 1);
//						}
//					}else if(event.keyCode == 40){
//						if(!(rowIndex == rowMaxlength.length - 1)){
//							$(jsystem.gkey).datagrid('selectRow',rowIndex + 1);
//						}
//					}
//				});	//end keydown
			}
		});

		this.ugrid = new jsystemgrid({
			url:     getUrl("/common/user/user/search.json"),
			key:     this.ukey,
			sform:    this.uform,
			toolbar:  "#user-toolbar",
			fit:     true,
			//title:   "사용자목록",
			idTitle: "사용자",
			idField: "userId",
			nameField: "userName",
			idInput: "s_userId",
			pageSize: pageSize,
			//BBUG.KWK : 20150728 수정 row클릭시 검색 될수 있도록 수정
			onClickRow:   function(index, row){
				doSearch();
			},
			onLoadSuccess: function() {
				$(this).datagrid('clearSelections');
//				//chang
//				$(jsystem.ukey).datagrid('getPanel').panel('panel').attr('tabindex',1).bind('keydown',function(e){
//							//alert(jsystem.gkey);
//						var selectedrow = $(jsystem.ukey).datagrid('getSelected');
//						var rowIndex = $(jsystem.ukey).datagrid("getRowIndex", selectedrow);
//						var rowMaxlength = $(jsystem.ukey).datagrid('getRows');
//							if(event.keyCode == 38){
//								if(!(rowIndex == 0)){
//									$(jsystem.ukey).datagrid('selectRow',rowIndex - 1);
//								}
//							}else if(event.keyCode == 40){
//								if(!(rowIndex == rowMaxlength.length - 1)){
//									$(jsystem.ukey).datagrid('selectRow',rowIndex + 1);
//								}
//							}
//				});	//end keydown
			}
		});

		this.pgrid = new jsystemgrid({
			url:     getUrl("/common/user/program/search.json"),
			key:     this.pkey,
			sform:    this.pform,
			toolbar:  "#prog-toolbar",
			fit:     true,
			idTitle: "화면",
			//title:   "화면목록",
			idField: "progId",
			nameField: "progName",
			idInput: "s_progId",
			pageSize: pageSize,
			//BBUG.KWK : 20150729 수정 row클릭시 검색 될수 있도록 수정
			onClickRow:   function(index, row){
				doSearch();
			},
			onLoadSuccess: function() {
				$(this).datagrid('clearSelections');
//				//chang
//				$(jsystem.pkey).datagrid('getPanel').panel('panel').attr('tabindex',1).bind('keydown',function(e){
//					//alert(jsystem.pkey);
//				var selectedrow = $(jsystem.pkey).datagrid('getSelected');
//				var rowIndex = $(jsystem.pkey).datagrid("getRowIndex", selectedrow);
//				var rowMaxlength = $(jsystem.pkey).datagrid('getRows');
//					if(event.keyCode == 38){
//						if(!(rowIndex == 0)){
//							$(jsystem.pkey).datagrid('selectRow',rowIndex - 1);
//						}
//					}else if(event.keyCode == 40){
//						if(!(rowIndex == rowMaxlength.length - 1)){
//							$(jsystem.pkey).datagrid('selectRow',rowIndex + 1);
//						}
//					}
//				});	//end keydown
			}
		});

	},
	grids: function() {
		var arr = [];
		if (this.type == "UG") {
			arr.push(this.ugrid);
			arr.push(this.ggrid);
		}
		else if (this.type == "UP") {
			arr.push(this.ugrid);
			arr.push(this.pgrid);
		}else if(this.type == "UU"){
			arr.push(this.ugrid);
		}else if(this.type == "GG"){
			arr.push(this.ggrid);
		}
		else {//this.type == "GP"
			arr.push(this.ggrid);
			arr.push(this.pgrid);
		}
		return arr;
	},
	append: function(rows) {

		var arr = this.grids();

		$.each(arr, function(i,g) {
			g.bindInput();
		});

		var row1 = arr[0].appendRow();
		var row2 = arr[1].appendRow();

		if (row1 == null ||
			row2 == null)
			return null;

		var obj = {};
		$.extend(obj, arr[0].getObject(row1));
		$.extend(obj, arr[1].getObject(row2));

		var text = arr[0].getText(row1, "red") + ","
		         + arr[1].getText(row2, "green");

		if (rows && rows.length > 0) {
			for (var i=0; i<rows.length; i++) {
				var r = rows[i];

				if (arr[0].equals(r, obj) &&
					arr[1].equals(r, obj)) {
					$.messager.show({title: msg.MSG0087, msg: text + " 은 이미 추가되어 있습니다."});
					return null;
				}
			}
		}
		return obj;
	},
	appendSingle: function(rows) {

		var arr = this.grids();

		$.each(arr, function(i,g) {
			g.bindInput();
		});

		var row1 = arr[0].appendRow();

		if (row1 == null)
			return null;

		var obj = {};
		$.extend(obj, arr[0].getObject(row1));

		var text = arr[0].getText(row1, "red");

		/*if (rows && rows.length > 0) {
			for (var i=0; i<rows.length; i++) {
				var r = rows[i];
				console.log(r);
				console.log(obj);
				if (arr[0].equals(r, obj)) {
					$.messager.show({title: msg.MSG0087, msg: text + " 은 이미 추가되어 있습니다."});
					return null;
				}
			}
		}*/
		return obj;
	},
	bind: function() {

		var arr = this.grids();
		$.each(arr, function(i,g) {
			g.bindInput();
		});
	},
	//BBUG.KWK  reload시 값 해제
	unbind: function() {

		var arr = this.grids();

		$.each(arr, function(i,g) {
			g.unbindInput();
		});
	},
	reload: function() {

		var arr = this.grids();

		$.each(arr, function(i,g) {
			g.reload();
		});
	}

};

//일정관리 공유설정 관련
var jsystemshare = {
	title:   "공유설정",
	config: {
		applyBtn: 'share-apply-button',
		clearBtn: 'share-clear-button',
		clear: function() {},
		apply: function() {}
	},
	callback: false, //공유대상 선택시 호출함수
	dialog:   false, //공유대상 설정 dialog 객체
	ugrid:    false, //전체사용자 그리드 객체
	sgrid:    false, //공유대상자 그리드 객체
	srows:    false, //현재 선택된 수신자목록
	url: {
		user: getUrl("/common/user/user/search.json")
	},
	//공유대상 설정팝업 객체 생성
	init: function(config) {

		$.extend(true, this.config, config);

		this.callback = this.config.apply;

		var btn = "dialog-button-share";
		var buttons = [{
	    	id:      btn+msg.MSG0123,
	    	group:   btn,
	    	text:    '확인',
	    	//2016/12/27 김영진 -- 아이콘 삭제    iconCls: 'icon-ok',
	    	handler: this.doConfirm
	    },{
	    	id:      btn+"ConfirmAll",
	    	group:   btn,
	    	text:    '전체공유',
	    	//2016/12/27 김영진 -- 아이콘 삭제    iconCls: 'icon-ok',
	    	handler: this.doConfirmAll
	    },{
	    	id:      btn+msg.MSG0129,
	    	group:   btn,
	    	text:    '취소',
	    	//2016/12/27 김영진 -- 아이콘 삭제    iconCls: 'icon-cancel',
	    	handler: this.doClose
		}];

		this.dialog = new jdialog({
			key:   "#share-dialog",
			dialogOptions: {
				top:     20,
				width:   550,
				height:  400,
				title: this.title,
				iconCls: 'icon-man',
			    buttons: buttons,
			    content: '<div id="share-layout"></div>'
			}
		});


		//레이아웃 설정
		var slayout = $("#share-layout");
		slayout.layout({fit:true});
		slayout.layout('add',{
		    region: 'west',
		    border: false,
		    width:  250,
		    style: {padding:'5px'},
		    content: '<table id="share-user-grid"></table>'
		});
		slayout.layout('add',{
		    region: 'east',
		    border: false,
		    width:  250,
		    style: {padding:'5px'},
		    content: '<table id="share-grid"></table>'
		});
		slayout.layout('add',{
		    region: 'center',
		    border: false,
		    style: {padding:'5px',paddingTop:'100px'},
		    content: '<a href="javascript:void(0)" id="share-append-button"></a>'
		    		+'<br/><br/>'
		    		+'<a href="javascript:void(0)" id="share-remove-button"></a>'
		});

		//공유설정 클릭시 공유대상 설정팝업 오픈
		//2016/12/27 김영진 -- 아이콘 삭제 및 class추가   iconCls:'icon-man',
		$("#"+this.config.applyBtn).linkbutton({onClick: this.doOpen});
		$("#"+this.config.applyBtn).addClass("c6");
		//공유해제 클릭시 공유해제함수 호출
		//2016/12/27 김영진 -- 아이콘 삭제 및 class추가   iconCls:'icon-clear',
		$("#"+this.config.clearBtn).linkbutton({onClick: this.config.clear});
		$("#"+this.config.clearBtn).addClass("c6");
		//등록 버튼이벤트 설정
		//2016/12/27 김영진 -- 버튼 크기 설정
		$("#share-append-button").linkbutton({iconCls:'icon-arrow1', onClick: this.doAppend});
		$("#share-append-button").attr("style", "width:25px");
		//삭제 버튼이벤트 설정
		//2016/12/27 김영진 -- 버튼 크기 설정
		$("#share-remove-button").linkbutton({iconCls:'icon-arrow2', onClick: this.doRemove});
		$("#share-remove-button").attr("style", "width:25px");

		//전체사용자 목록
		this.ugrid = $("#share-user-grid");
		//공유대상자 목록
		this.sgrid = $("#share-grid");

		var config = {
			url:        null,
			fit:        true,
			rownumbers: true,
			showHeader: true,
			showFooter: true,
			selectOnCheck: true,
			checkOnSelect: true
		};

		this.ugrid.datagrid($.extend({}, config, {
			url: this.url.user,
			title: tit.TITLE0009,
			border: true,
			queryParams: {},
			columns:[[
			    {field:'check',   align:'center',checkbox:true},
			    {field:'userId',  align:'left'  ,width: 80, sortable:true,title:'사용자ID'},
			    {field:'userName',align:'left'  ,width:100, sortable:true,title:'사용자명'}
			]]
		}));
		this.sgrid.datagrid($.extend({}, config, {
			title: tit.TITLE0010,
			border: true,
			columns:[[
			    {field:'pubUser', align:'left',width: 80, sortable:true,title:'사용자ID'},
			    {field:'pubName', align:'left',width:100, sortable:true,title:'사용자명'}
			]]
		}));
		//기존에 선택된 공유대상 목록이 있으면 해당 목록을 LOAD한다.
		if (this.srows) {
			this.sgrid.datagrid('loadData', this.srows);
		}
	},
	//공유대상 설정 버튼클릭시 이벤트처리
	doOpen: function() {
		jsystemshare.dialog.open();
	},
	//공유대상 설정 취소버튼 클릭시 이벤트처리
	doClose: function() {
		jsystemshare.dialog.close();
	},
	//공유대상 객체 설정
	getData: function(rows) {
		var data = {
			text:  [],
			value: []
		};
		$.each(rows, function(i,r) {
			var s =  r.pubName + '['
			      +  r.pubUser + ']';

			data.value.push(r.pubUser);
			data.text.push(s);
		});
		return data;
	},

	//공유대상 설정 확인버튼 클릭시 이벤트처리
	doConfirm: function() {
		var jobj = jsystemshare;
		var rows = jobj.sgrid.datagrid('getRows');

		if (rows == null ||
			rows.length == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0023,msg.MSG0121);
			return;
		}
		var data = jobj.getData(rows);
		jobj.srows = rows;
		jobj.callback(data);
		jobj.doClose();
	},
	//전체공유 버튼 클릭시 이벤트처리
	doConfirmAll: function() {
		var jobj = jsystemshare;
		jobj.srows = [];
		jobj.callback('ALL');
		jobj.doClose();
	},
	//공유대상 추가버튼 클릭시 이벤트 처리
	doAppend: function() {
		var jobj  = jsystemshare;
		var grid  = jobj.sgrid;
		var crows = jobj.sgrid.datagrid('getRows');
		var urows = jobj.ugrid.datagrid('getSelections');

		$.each(urows, function(i,r) {

			r['pubUser'] = r['userId'];
			r['pubName'] = r['userName'];

			//이미 등록된 사용자가 있는지 확인
			for (var i=0; i<crows.length; i++) {
				if (crows[i].pubUser == r.pubUser)
					return;
			}
			grid.datagrid('appendRow', r);
		});
	},
	//공유대상 삭제버튼 클릭시 이벤트 처리
	doRemove: function() {
		var grid = jsystemshare.sgrid;
		var rows = grid.datagrid('getSelections');

		$.each(rows, function(i,r) {
			var i = grid.datagrid('getRowIndex', r);
			grid.datagrid('deleteRow', i);
		});
	}
};

// 일정관리 공유설정 관련
// 업체별
var jsystemsharecust = {
	title:   "공유설정",
	config: {
		applyBtn: 'share-apply-button',
		clearBtn: 'share-clear-button',
		clear: function() {},
		apply: function() {}
	},
	callback: false, //공유대상 선택시 호출함수
	dialog:   false, //공유대상 설정 dialog 객체
	ugrid:    false, //전체사용자 그리드 객체
	sgrid:    false, //공유대상자 그리드 객체
	srows:    false, //현재 선택된 수신자목록
	url: {
		user: getUrl("/business/outs/outsourcingoperationschedule/getOutsourcingCust.json")
	},
	//공유대상 설정팝업 객체 생성
	init: function(config) {

		$.extend(true, this.config, config);

		this.callback = this.config.apply;

		var btn = "dialog-button-share";
		var buttons = [{
	    	id:      btn+msg.MSG0123,
	    	group:   btn,
	    	text:    '확인',
	    	//2016/12/27 김영진 -- 아이콘 삭제    iconCls: 'icon-ok',
	    	handler: this.doConfirm
	    },{
	    	id:      btn+msg.MSG0124,
	    	group:   btn,
	    	text:    '전체공유',
	    	//2016/12/27 김영진 -- 아이콘 삭제    iconCls: 'icon-ok',
	    	handler: this.doConfirmAll
	    },{
	    	id:      btn+msg.MSG0129,
	    	group:   btn,
	    	text:    '취소',
	    	//2016/12/27 김영진 -- 아이콘 삭제    iconCls: 'icon-cancel',
	    	handler: this.doClose
		}];

		this.dialog = new jdialog({
			key:   "#share-dialog",
			dialogOptions: {
				top:     20,
				width:   550,
				height:  400,
				title: this.title,
				iconCls: 'icon-man',
			    buttons: buttons,
			    content: '<div id="share-layout"></div>'
			}
		});


		//레이아웃 설정
		var slayout = $("#share-layout");
		slayout.layout({fit:true});
		slayout.layout('add',{
		    region: 'west',
		    border: false,
		    width:  250,
		    style: {padding:'5px'},
		    content: '<table id="share-user-grid"></table>'
		});
		slayout.layout('add',{
		    region: 'east',
		    border: false,
		    width:  250,
		    style: {padding:'5px'},
		    content: '<table id="share-grid"></table>'
		});
		slayout.layout('add',{
		    region: 'center',
		    border: false,
		    style: {padding:'5px',paddingTop:'100px'},
		    content: '<a href="javascript:void(0)" id="share-append-button"></a>'
		    		+'<br/><br/>'
		    		+'<a href="javascript:void(0)" id="share-remove-button"></a>'
		});

		//공유설정 클릭시 공유대상 설정팝업 오픈
		//2016/12/27 김영진 -- 아이콘 삭제 및 class추가   iconCls:'icon-man',
		$("#"+this.config.applyBtn).linkbutton({onClick: this.doOpen});
		$("#"+this.config.applyBtn).addClass("c6");
		//공유해제 클릭시 공유해제함수 호출
		//2016/12/27 김영진 -- 아이콘 삭제 및 class추가   iconCls:'icon-clear',
		$("#"+this.config.clearBtn).linkbutton({onClick: this.config.clear});
		$("#"+this.config.clearBtn).addClass("c6");
		//등록 버튼이벤트 설정
		//2016/12/27 김영진 -- 버튼 크기 설정
		$("#share-append-button").linkbutton({iconCls:'icon-arrow1', onClick: this.doAppend});
		$("#share-append-button").attr("style", "width:25px");
		//삭제 버튼이벤트 설정
		//2016/12/27 김영진 -- 버튼 크기 설정
		$("#share-remove-button").linkbutton({iconCls:'icon-arrow2', onClick: this.doRemove});
		$("#share-remove-button").attr("style", "width:25px");

		//전체사용자 목록
		this.ugrid = $("#share-user-grid");
		//공유대상자 목록
		this.sgrid = $("#share-grid");

		var config = {
			url:        null,
			fit:        true,
			rownumbers: true,
			showHeader: true,
			showFooter: true,
			selectOnCheck: true,
			checkOnSelect: true
		};

		this.ugrid.datagrid($.extend({}, config, {
			url: this.url.user,
			title: tit.TITLE0032,
			border: true,
			queryParams: {},
			columns:[[
			    {field:'check',   align:'center',checkbox:true},
			    {field:'custCd',  align:'left'  ,width: 80, sortable:true,title:'업체코드'},
			    {field:'custName',align:'left'  ,width:100, sortable:true,title:'업체명'}
			]]
		}));
		this.sgrid.datagrid($.extend({}, config, {
			title: tit.TITLE0033,
			border: true,
			columns:[[
			    {field:'pubUser', align:'left',width: 80, sortable:true,title:'업체코드'},
			    {field:'pubName', align:'left',width:100, sortable:true,title:'업체명'}
			]]
		}));
		//기존에 선택된 공유대상 목록이 있으면 해당 목록을 LOAD한다.
		if (this.srows) {
			this.sgrid.datagrid('loadData', this.srows);
		}
	},
	//공유대상 설정 버튼클릭시 이벤트처리
	doOpen: function() {
		jsystemsharecust.dialog.open();
	},
	//공유대상 설정 취소버튼 클릭시 이벤트처리
	doClose: function() {
		jsystemsharecust.dialog.close();
	},
	//공유대상 객체 설정
	getData: function(rows) {
		var data = {
			text:  [],
			value: []
		};
		$.each(rows, function(i,r) {
			var s =  r.pubName + '['
			      +  r.pubUser + ']';

			data.value.push(r.pubUser);
			data.text.push(s);
		});
		return data;
	},

	//공유대상 설정 확인버튼 클릭시 이벤트처리
	doConfirm: function() {
		var jobj = jsystemsharecust;
		var rows = jobj.sgrid.datagrid('getRows');

		if (rows == null ||
			rows.length == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0023,msg.MSG0121);
			return;
		}
		var data = jobj.getData(rows);
		jobj.srows = rows;
		jobj.callback(data);
		jobj.doClose();
	},
	//전체공유 버튼 클릭시 이벤트처리
	doConfirmAll: function() {
		var jobj = jsystemsharecust;
		jobj.srows = [];
		jobj.callback('ALL');
		jobj.doClose();
	},
	//공유대상 추가버튼 클릭시 이벤트 처리
	doAppend: function() {
		var jobj  = jsystemsharecust;
		var grid  = jobj.sgrid;
		var crows = jobj.sgrid.datagrid('getRows');
		var urows = jobj.ugrid.datagrid('getSelections');

		$.each(urows, function(i,r) {

			r['pubUser'] = r['custCd'];
			r['pubName'] = r['custName'];

			//이미 등록된 사용자가 있는지 확인
			for (var i=0; i<crows.length; i++) {
				if (crows[i].pubUser == r.pubUser)
					return;
			}
			grid.datagrid('appendRow', r);
		});
	},
	//공유대상 삭제버튼 클릭시 이벤트 처리
	doRemove: function() {
		var grid = jsystemsharecust.sgrid;
		var rows = grid.datagrid('getSelections');

		$.each(rows, function(i,r) {
			var i = grid.datagrid('getRowIndex', r);
			grid.datagrid('deleteRow', i);
		});
	}
};