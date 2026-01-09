/**
 * 게시판 스크립트
 */

//=============================================================================
//다이얼로그게시판의 등록,상세팝업 관련
var jsystemboard = {
	/**
	 * 페이지상수객체
	 *
	 * <<사용함수>>
	 * getTitle()
	 * getParams()
	 * setInsert()
	 * setUpdate()
	 * doResult()
	 */
	consts:     false,
	upload:     false,  //파일업로드 컨트롤
	editor:     false,  //웹에디터 컨트롤
	form:       false,  //편집폼 객체
	formdialog: false,  //편집폼 다이얼로그 컨트롤
	viewdialog: false,  //상세폼 다이얼로그 컨트롤
	url:        false,
	buttons: {
		prefix: "dialog-button-",
		form:   "dialog-button-form",
		view:   "dialog-button-view"
	},
	//사용가능기능 설정
	usable: {
		save:   $("#INS").val() == "false" ? true : false, //저장기능 사용여부
		update: $("#UPD").val() == "false" ? true : false, //수정기능 사용여부
		remove: $("#DEL").val() == "false" ? true : false, //삭제기능 사용여부
		reply:  $("#AUP").val() == "false" ? true : false  //답변기능 사용여부
	},
	init: function(args) {
		
		this.consts = args;
		this.url    = args.url;

		if (args.usable)
			$.extend(this.usable, args.usable);

		var title   = this.consts.getTitle();
		var btnnone = this.buttons.prefix;
		var btnform = this.buttons.form;
		var btnview = this.buttons.view;

		var buttons = {
			form: [],
			view: []
		};

		//저장기능 사용가능일 경우
		if (this.usable.save) {
			buttons.form.push({
		    	id:      btnform+msg.MSG0123,
		    	group:   btnform,
		    	text:    '저장',
		    	/*iconCls: 'icon-ok',*/
		    	disabled: true,
		    	handler: this.doSave,
		    	addClass:'easyui-linkbutton',
		    	data_popup:'POP_BTN_999'
			});
		}
		//수정기능 사용가능일 경우
		if (this.usable.update && !(args.buttonStts)) {
			buttons.view.push({
		    	id:      btnview+msg.MSG0087,
		    	group:   btnview,
		    	text:    '수정',
		    	/*iconCls: 'icon-edit',*/
		    	disabled: true,
		    	handler: this.doUpdate,
		    	data_popup:'POP_BTN_998'
			});
		}
		//답변기능 사용가능일 경우
		if (this.usable.reply) {
			buttons.view.push({
		    	id:      btnview+msg.MSG0088,
		    	group:   btnview,
		    	text:    '답변',
		    	/*iconCls: 'icon-remove',*/
		    	disabled: false,
		    	handler: this.doReply,
		    	data_popup:'POP_BTN_997'
			});
		}
		//삭제기능 사용가능일 경우
		if (this.usable.remove && !(args.buttonStts)) {
			buttons.view.push({
		    	id:      btnview+msg.MSG0134,
		    	group:   btnview,
		    	text:    '삭제',
		    	/*iconCls: 'icon-remove',*/
		    	disabled: true,
		    	handler: this.doRemove,
		    	data_popup:'POP_BTN_996'
			});
		}

		//취소버튼
		buttons.form.push({
	    	id:      btnnone+msg.MSG0129,
	    	group:   btnform,
	    	text:    '취소',
	    	/*iconCls: 'icon-cancel',*/
	    	handler: this.doClose,
	    	data_popup:'POP_BTN_995'
		});
		buttons.view.push({
	    	id:      btnnone+msg.MSG0129,
	    	group:   btnview,
	    	text:    '취소',
	    	/*iconCls: 'icon-cancel',*/
	    	handler: this.doClose,
	    	data_popup:'POP_BTN_994'
		});

		//편집팝업
		this.formdialog = new jdialog({
			key: "#regist-dialog",
			title: title,
			dialogOptions: {
				href:    this.url.form,
				top:     10,
				//2016/12/21 김영진 -- 게시판 팝업 사이즈 조절
				//width:   1024,
				//height:  700,
				width:   800,
				height:  620,
			    buttons: buttons.form
			}
		});
		//상세팝업
		this.viewdialog = new jdialog({
			key: "#select-dialog",
			title: title,
			dialogOptions: {
				href:    this.url.view,
				top:     10,
				//2016/12/21 김영진 -- 게시판 팝업 사이즈 조절
				//width:   1024,
				//height:  700,
				width:   800,
				height:  600,
			    buttons: buttons.view
			}
		});
	},
	//상세조회
	select: function(url, params, callback) {
		//수정일 경우 상세조회
		jlogic.select({
			url: url,
			data: params,
			success: function(data) {

	        	if (!data ||
	        		!data.rows) {
	        		$.messager.alert(msg.MSG0121,msg.MSG0031,msg.MSG0121);
	        		return;
	        	}

	        	//콜백함수 호출
	        	callback(data.rows);
			}
		});
	},
	//웹에디터 초기화
	initEditor: function(args) {
		//console.log(args);
		//[WSC2.0] [2015.04 LSH] 웹에디터 설정 추가
		//editorLayer: "editor-area" => 웹에디터 레이어 ID
		//editorBox:   "r_bordText"  => 웹에디터 텍스트박스 ID
		//editorForm:  "regist-form" => 웹에디터 폼 ID
		return new jeditor(args);
	},
	//업로드컨트롤 초기화
	initUpload: function(args, data) {

		var config = {};
		$.extend(config, args);

		config.params = {
			atchGrup: data.bordGrup,
			atchNo:   data.bordNo
		};
		return jupload.init(config);
	},
	//편집팝업에서 호출
	initForm: function(args) {

		var jobj   = this;
		var params = this.consts.getParams();

		//등록폼객체
		this.form = $(args.formKey);
		//업로드용 컨트롤 초기화
		this.upload = this.initUpload(args, params);

		//수정인 경우 상세조회
		if (jstatus.isUpdate(params)) {
			this.select(this.url.select, params, function(data) {
				//수정상태 정의
				jstatus.update(data);
				//폼데이터 로드
				jobj.form.form('load', data);
				//웹에디터객체
				jobj.editor = jobj.initEditor(args);

				//웹에디터 값처리 (SCEDITOR 적용시 사용)
				jobj.setEditorText(data);

				//편집가능인 경우 버튼활성처리
				if (data.editable)
					jobj.formdialog.enable(jobj.buttons.form);
			});
		}
		//등록인 경우 버튼활성처리
		else {
			//웹에디터객체
			this.editor = this.initEditor(args);

			jobj.formdialog.enable(jobj.buttons.form);
		}

		//Form Hidden Value 정의
		args.setHiddenValues(params);

		//기타 이벤트 정의
		if (args.bindEvent)
			args.bindEvent(params);
	},
	//상세팝업에서 호출
	initView: function(args) {

		var jobj   = this;
		var params = this.consts.getParams();
		//jcommon.printobject(params);
		//조회상태값 정의
		jstatus.read(params);
		//등록폼객체
		this.form = $(args.formKey);

		//상세조회
		this.select(this.url.select, params, function(data) {
			//레이어데이터 로드
			jcommon.toHtml(data, "v_");
			//업로드파일 조회용 컨트롤 초기화
			jobj.initUpload(args, data);
			//편집가능인 경우 버튼활성처리 및 비활성화 추가 20170906 박민혁
			if (data.editable)
				jobj.viewdialog.enable(jobj.buttons.view);
			else jobj.viewdialog.disable(jobj.buttons.view);
		});

		//Form Hidden Value 정의
		args.setHiddenValues(params);

		//기타 이벤트 정의
		if (args.bindEvent)
			args.bindEvent(params);
	},
	//폼데이터 객체에 첨부파일 목록 추가(JSON)
	addJsonFiles: function(data) {
		//첨부파일목록
		var files = this.upload.getFiles();
		data['files'] = $.toJSON(files);
	},
	//폼데이터 객체에 웹에디터 컨텐츠 추가
	addEditorText: function(data) {
		data['bordText'] = this.editor.get();
	},
	//수정폼에서 웹에디터 컨텐츠 바인딩
	setEditorText: function(data) {
		this.editor.set(data['bordText']);
	},
	//컨텐츠 바이트 체크
	checkEditorText: function(data) {
		var s = data['bordText'];
		return jutils.checkMaxBytes(s, 4000);
	},
	//팝업오픈
	open: function(status, title) {
		switch(status) {
		//등록팝업
		case jstatus.INSERT:
			this.consts.setInsert();
			this.formdialog.open(title ? title : tit.TITLE0037);
			break;
		//답변팝업
		case jstatus.REPLY:
			//답변상태 처리
			this.consts.setReply();
			//상세폼 닫기
			this.viewdialog.close();
			this.formdialog.open(title ? title : tit.TITLE0005);
			break;
		//수정팝업
		case jstatus.UPDATE:
			//상세폼 닫기
			this.viewdialog.close();
			//수정상태 처리
			this.consts.setUpdate();
			//수정폼 열기
			this.formdialog.open(title ? title : tit.TITLE0038);
			break;
		//상세팝업
		case jstatus.READ:
			this.consts.setUpdate();
			this.viewdialog.open(title ? title : tit.TITLE0038);
			break;
		}
	},
	//[버튼클릭 핸들러]팝업닫기
	doClose: function() {
		var jobj = jsystemboard;
		var opts = $(this).linkbutton('options');
		if (opts.group == jobj.buttons.form) {
			jobj.consts.setInsert();
			jobj.formdialog.close();
		}
		else
			jobj.viewdialog.close();
	},
	//[버튼클릭 핸들러]Save 클릭시 저장처리
	doSave: function() {

		var jobj = jsystemboard;

		if (!jobj.form.form('validate'))
			return;

		//폼데이터
		var data = jobj.form.serializeObject();
		//20161026 김원국 추가 도움말관리시 같은 메뉴 저장여부 체크
		var cnt = 0;
		if(data.bordGrup == 'B10' && data.oper == 'I'){
		    $.ajax({
		        url: getUrl('/common/board/help/insertchk.json'),
		        dataType: 'json',
		        async: false,
		        type: 'post',
		        data: data,
		        success: function(data){
		        	cnt = data.rows[0].CNT;
		        },
		        error: function(){
		        }
		    });
		}
    	if(cnt > 0){
			$.messager.alert(msg.MSG0121,msg.MSG0121);
			return;
    	}



		//폼데이터 객체에 첨부파일 목록 추가(JSON)
		jobj.addJsonFiles(data);
		//폼데이터 객체에 웹에디터 컨텐츠 추가
		jobj.addEditorText(data);

		//2016/11/16 김영진 수정 -- 메일 작성일때와 일반 게시판 사용일때 구분
		if((data.bordGrup == 'B09' || data.bordGrup == 'B12') && data.oper == 'I'){
			if (!jobj.checkEditorText(data))
				return;
			jlogic.save({
				url: jobj.url.save,
				data: data,
				success: function(res) {
					jobj.consts.doResult(res, jobj.doCloseAll);
				}
			});
		}else if(data.bordGrup == 'B09' && data.oper == 'U'){
			$.ajax({
                url: getUrl('/common/mail/delete.json'),
                dataType: 'json',
                async: false,
                type: 'post',
                data: data,
                success: function(res){
                	data.oper = 'I';
                	jlogic.save({
        				url: jobj.url.save,
        				data: data,
        				success: function(res) {
        					jobj.consts.doResult(res, jobj.doCloseAll);
        				}
        			});
                },
                error: function(){
                	//console.log("e");
                }
            });
		}else{
			if (!jobj.checkEditorText(data))
				return;
			jlogic.save({
				url: jobj.url.save,
				data: data,
				success: function(res) {
					jobj.consts.doResult(res, jobj.doCloseAll);
				},
				message: msg.MSG0118
			});
		}
	},
	//[버튼클릭 핸들러]Delete 클릭시 삭제처리
	doRemove: function() {

		var jobj = jsystemboard;

		//폼데이터
		var data = jobj.form.serializeObject();

		jlogic.remove({
			url: jobj.url.remove,
			data: data,
			success: function(res) {
				jobj.consts.doResult(res, jobj.doCloseAll);
			},
			message: msg.MSG0123
		});
	},
	//[버튼클릭 핸들러]Update 클릭시 수정폼 오픈
	doUpdate: function() {
		var jobj = jsystemboard;
		jobj.open(jstatus.UPDATE);
	},
	//[버튼클릭 핸들러]답변 클릭시 등록폼 오픈
	doReply: function() {
		var jobj = jsystemboard;
		jobj.open(jstatus.REPLY);
	},
	//모든팝업 닫기
	doCloseAll: function() {
		var jobj = jsystemboard;
		jobj.formdialog.close();
		jobj.viewdialog.close();
	}
};


//=============================================================================
//다이얼로그게시판(전자메일) 수신자설정 관련
var jsystemaddress = {
	title:   "수신자설정",
	params:   false,
	callback: false, //수신자선택시 호춣함수
	dialog:   false, //수신자설정 dialog 객체
	accord:   false, //선택주소록 accordion 객체
	grids:    [],    //그리드 배열(0:전체사용자,1:개인주소록,2:그룹주소록)
	tgrid:    false, //수신자 그리드 객체
	grows:    false, //그룹주소록의 선택그룹에 속한 사용자목록
	trows:    false, //현재 선택된 수신자목록
	index:    false, //현재 활성화된 accordion panel index
	//고정값
	constants: {
		USERS_TYPE: 'U',
		GROUP_TYPE: 'G'
	},
	url: {
		target: getUrl("/common/board/email/target.do"),
		all:    getUrl("/common/user/user/search.json"),
		user:   getUrl("/common/board/address/search.json"),
		group:  getUrl("/common/board/address/search.json"),
		item:   getUrl("/common/board/address/searchItem.json"),
		save:   getUrl("/common/board/address/save.json"),
		remove: getUrl("/common/board/address/delete.json"),
	},
	//수신자설정팝업 객체 생성
	init: function(params, callback) {

		this.params = params;
		this.callback = callback;

		var url     = this.url.target;
		var btn     = "dialog-button-target";
		var buttons = [{
	    	id:      btn+msg.MSG0123,
	    	group:   btn,
	    	text:    '확인',
	    	iconCls: 'icon-ok',
	    	handler: this.doConfirm
	    },{
	    	id:      btn+msg.MSG0129,
	    	group:   btn,
	    	text:    '취소',
	    	iconCls: 'icon-cancel',
	    	handler: this.doClose
		}];

		this.dialog = new jdialog({
			key:   "#address-dialog",
			title: this.title,
			dialogOptions: {
				href:    url,
				top:     20,
				width:   850,
				height:  600,
			    buttons: buttons
			}
		});

		//수신자설정버튼 클릭시 수신자설정팝업 오픈
		$("#address-button").unbind("click").bind("click", this.doOpen);
	},
	//수신자설정팝업에서 호출
	create: function(args) {

		//수신자등록 버튼이벤트 설정
		if (args.appendBtn)
			args.appendBtn.linkbutton({iconCls:'icon-arrow1', onClick: this.doAppend});
		//수신자삭제 버튼이벤트 설정
		if (args.removeBtn)
			args.removeBtn.linkbutton({iconCls:'icon-arrow2', onClick: this.doRemove});

		//ACCORDION 설정
		this.accord = $("#address-accordion");

		//그리드설정
		this.grids = [$("#address-all-grid" ), //전체사용자 목록
		              $("#address-user-grid"), //개인주소록 목록
		              $("#address-grup-grid")];//그룹주소록 목록
		//수신자 목록
		this.tgrid = $("#target-grid");

		var config = {
			iconCls:    'icon-search',
			title:      null,
			url:        null,
			border:     false,
			fit:        true,
			rownumbers: true,
			showHeader: true,
			showFooter: true,
			selectOnCheck: true,
			checkOnSelect: true
		};

		var params    = this.params;
		var constants = this.constants;

		this.grids[0].datagrid($.extend({}, config, {
			url: this.url.all,
			queryParams: {},
			columns:[[
			    {field:'check',   align:'center',checkbox:true},
			    {field:'userId',  align:'center',width:100, sortable:true,title:'사용자ID'},
			    {field:'userName',align:'left'  ,width:100, sortable:true,title:'사용자명'},
			    {field:'deptName',align:'left'  ,width:100, sortable:true,title:'부서명'}
			]],
			toolbar:[{text:'개인주소록추가',iconCls:'icon-user' ,handler:this.doAppendUsers},
			         {text:'그룹주소록추가',iconCls:'icon-group',handler:this.doAppendGroup}]
		}));
		this.grids[1].datagrid($.extend({}, config, {
			url: this.url.user,
			queryParams: {
				bordGrup: params.bordGrup,
				addrType: constants.USERS_TYPE
			},
			columns:[[
			    {field:'check',      align:'center',checkbox:true},
			    {field:'tgtUserId',  align:'center',width: 80, sortable:true,title:'사용자ID'},
			    {field:'tgtUserName',align:'left'  ,width: 80, sortable:true,title:'사용자명'},
			    {field:'tgtVndrName',align:'left'  ,width:100, sortable:true,title:'부서명'}
			]],
			toolbar:[{text:'삭제',iconCls:'icon-clear',handler:this.doRemoveUsers}]
		}));
		this.grids[2].datagrid($.extend({}, config, {
			url: this.url.group,
			singleSelect: true,
			queryParams: {
				bordGrup: params.bordGrup,
				addrType: constants.GROUP_TYPE
			},
			columns:[[
			    {field:'check',      align:'center',checkbox:true},
			    {field:'tgtGrupId',  align:'center',width: 80, sortable:true,title:'그룹ID'},
			    {field:'tgtGrupName',align:'left'  ,width:160, sortable:true,title:'그룹명'}
			]],
			toolbar:[{text:'삭제',iconCls:'icon-clear',handler:this.doRemoveGroup}],
			view: detailview,
			detailFormatter:function(index,row){
				return '<div style="padding:2px"><table class="ddv"></table></div>';
			},
			onSelect: function(index, row) {
				$(this).datagrid('expandRow',index);

				var dgrid  = $(this).datagrid('getRowDetail',index).find('table.ddv');
				jsystemaddress.grows = dgrid.datagrid('getRows');
			},
			onExpandRow: function(index,row){
				var jobj  = jsystemaddress;
				var ggrid = jobj.grids[2];
				var dgrid = $(this).datagrid('getRowDetail',index).find('table.ddv');
				dgrid.datagrid({
					url: jobj.url.item,
					queryParams: {
						sysId:     row.sysId,
						bordGrup:  row.bordGrup,
						tgtGrupId: row.tgtGrupId
					},
					fitColumns:   true,
					rownumbers:   true,
					height:      'auto',
					columns:[[
					    {field:'tgtUserId',  align:'center',width: 80, sortable:true,title:'사용자ID'},
					    {field:'tgtUserName',align:'left'  ,width: 80, sortable:true,title:'사용자명'},
					    {field:'tgtVndrName',align:'left'  ,width:100, sortable:true,title:'부서명'}
					]],
					onResize:function(){
						ggrid.datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess:function(){
						jobj.grows = $(this).datagrid('getRows');

						setTimeout(function(){
							ggrid.datagrid('fixDetailRowHeight',index);
						},0);
					}
				});
				ggrid.datagrid('fixDetailRowHeight',index);
			}
		}));


		this.tgrid.datagrid($.extend({}, config, {
			title: tit.TITLE0034,
			border: true,
			columns:[[
			    {field:'tgtUserId',  align:'center',width: 80, sortable:true,title:'사용자ID'},
			    {field:'tgtUserName',align:'left'  ,width: 80, sortable:true,title:'사용자명'},
			    {field:'tgtVndrName',align:'left'  ,width:100, sortable:true,title:'부서명'}
			]]
		}));

		//기존에 선택된 수신자목록이 있으면 해당 목록을 LOAD한다.
		if (this.trows) {
			this.tgrid.datagrid('loadData', this.trows);
		}
	},
	//전체사용자 그리드 반환
	getAllGrid: function() {
		return this.grids[0];
	},
	//개인주소록 그리드 반환
	getUsersGrid: function() {
		return this.grids[1];
	},
	//그룹주소록 그리드 반환
	getGroupGrid: function() {
		return this.grids[2];
	},
	//전체사용자 패널 활성화
	activateAll: function() {
		this.accord.accordion('select', 0);
	},
	//개인주소록 패널 활성화
	activateUsers: function() {
		this.accord.accordion('select', 1);
	},
	//그룹주소록 패널 활성화
	activateGroup: function() {
		this.accord.accordion('select', 2);
	},
	//선택된 accordion 패널에 속한 그리드의 선택된 ROWS 를 가져오기
	getRows: function() {

		this.index = -1;
		var panel = this.accord.accordion('getSelected');
		if (panel) {
			this.index = this.accord.accordion('getPanelIndex', panel);

			//그룹주소록인 경우 서브그리드 목록 반환
			if (this.index == 2)
				return this.grows;

			return this.grids[this.index].datagrid('getSelections');
		}
		return null;
	},
	//그룹주소록의 선택된 그룹 ROW 반환
	getGroupRow: function() {
		return this.getGroupGrid().datagrid('getSelected')
	},
	//수신자목록의 ROWS 반환
	getTargetRows: function() {
		return this.tgrid.datagrid('getRows');
	},
	//주소록 저장데이터 가져오기
	getData: function(type, status) {
		var params = this.params;
		var rows = this.getRows();
		return {
			oper:     status,
			addrType: type,
			bordGrup: params.bordGrup,
			count:    rows.length,
			models:   $.toJSON(rows)
		};
	},
	//수신자설정 버튼클릭시 이벤트처리
	doOpen: function() {
		var jobj = jsystemaddress;
		jobj.dialog.open();
	},
	//수신자설정 취소버튼 클릭시 이벤트처리
	doClose: function() {
		var jobj = jsystemaddress;
		jobj.dialog.close();
	},
	//수신자설정 확인버튼 클릭시 이벤트처리
	doConfirm: function() {
		var jobj = jsystemaddress;
		var rows = jobj.getTargetRows();
		var data = {
			text:  [],
			value: []
		};

		if (rows == null ||
			rows.length == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0023,msg.MSG0121);
			return;
		}

		$.each(rows, function(i,r) {

			var s = (r.tgtVndrName ? r.tgtVndrName + ' - ' : '')
			      +  r.tgtUserName + '['
			      +  r.tgtUserId   + ']';

			data.value.push(r.tgtUserId);
			data.text.push(s);
		});
		jobj.trows = rows;
		jobj.callback(data);
		jobj.doClose();
	},
	//수신자 추가버튼 클릭시 이벤트 처리
	doAppend: function() {
		var jobj  = jsystemaddress;
		var grid  = jobj.tgrid;
		var rows  = jobj.getRows();
		var index = jobj.index;
		var crows = grid.datagrid('getRows');

		$.each(rows, function(i,r) {
			//전체사용자인 경우
			if (index == 0) {
				r['tgtUserId']   = r['userId'];
				r['tgtUserName'] = r['userName'];
				r['tgtVndrName'] = r['deptName'];
				r['tgtVndrCode'] = r['deptCode'];
			}

			//이미 등록된 사용자가 있는지 확인
			for (var i=0; i<crows.length; i++) {
				if (crows[i].tgtUserId == r.tgtUserId)
					return;
			}
			grid.datagrid('appendRow', r);
		});
	},
	//수신자 삭제버튼 클릭시 이벤트 처리
	doRemove: function() {
		var jobj = jsystemaddress;
		var grid = jobj.tgrid;
		var rows = grid.datagrid('getSelections');

		$.each(rows, function(i,r) {
			var i = grid.datagrid('getRowIndex', r);
			grid.datagrid('deleteRow', i);
		});
	},
	//개인주소록 저장후 결과처리
	doUsersResult: function(res) {
		var jobj = jsystemaddress;
		jlogic.result(res, function() {
			//개인주소록 RELOAD
			jobj.getUsersGrid().datagrid('reload');
			//전체사용자 선택해제
			jobj.getAllGrid().datagrid('clearSelections');
			//개인주소록 활성화
			jobj.activateUsers();
		});
	},
	//그룹주소록 저장후 결과처리
	doGroupResult: function(res) {
		var jobj = jsystemaddress;
		jlogic.result(res, function() {
			//그룹주소록 RELOAD
			jobj.getGroupGrid().datagrid('reload');
			//전체사용자 선택해제
			jobj.getAllGrid().datagrid('clearSelections');
			//그룹주소록 활성화
			jobj.activateGroup();
		});
	},
	//개인주소록 추가버튼 클릭시 이벤트처리
	doAppendUsers: function() {

		var jobj = jsystemaddress;
		var data = jobj.getData(jobj.constants.USERS_TYPE, jstatus.INSERT);

		if (data.count == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0047,msg.MSG0121);
			return;
		}
		jlogic.save({
			data:    data,
			url:     jobj.url.save,
			success: jobj.doUsersResult,
			message: data.count+msg.MSG0135
		});
	},
	//그룹주소록 추가버튼 클릭시 이벤트처리
	doAppendGroup: function() {

		var jobj = jsystemaddress;
		var data = jobj.getData(jobj.constants.GROUP_TYPE, jstatus.INSERT);

		if (data.count == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0114,msg.MSG0121);
			return;
		}
		$.messager.prompt('그룹주소록 추가', '그룹명을 입력하세요.', function(r){
			if (r) {
				data['tgtGrupName'] = r;
				jlogic.save({
					data: data,
					url: jobj.url.save,
					success: jobj.doGroupResult
				});
			}
		});
	},
	//개인주소록 삭제버튼 클릭시 이벤트처리
	doRemoveUsers: function() {

		var jobj = jsystemaddress;
		var data = jobj.getData(jobj.constants.USERS_TYPE, jstatus.DELETE);

		if (data.count == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0075,msg.MSG0121);
			return;
		}
		jlogic.save({
			data:    data,
			url:     jobj.url.remove,
			success: jobj.doUsersResult,
			message: data.count+msg.MSG0115
		});
	},
	//그룹주소록 삭제버튼 클릭시 이벤트처리
	doRemoveGroup: function() {

		var jobj = jsystemaddress;
		var data = jobj.getData(jobj.constants.GROUP_TYPE, jstatus.DELETE);
		var grow = jobj.getGroupRow();

		if (grow == null) {
			$.messager.alert(msg.MSG0121,msg.MSG0110,msg.MSG0121);
			return;
		}
		$.extend(data, grow);

		jlogic.save({
			data: data,
			url: jobj.url.remove,
			success: jobj.doGroupResult,
			message: data.tgtGrupName+msg.MSG0136
		});
	}
};

//=============================================================================
//일반게시판의 등록,상세팝업 관련
var jboard = {
	consts:     false,
	upload:     false,  //파일업로드 컨트롤
	editor:     false,  //웹에디터 컨트롤
	title:      false,  //제목
	panel:      false,  //패널 객체
	form:       false,  //편집폼 객체
	list:       false,  //목록폼 객체
	url:        false,
	viewData:   false,  //상세조회 결과객체
	//목록화면 초기화
	init: function(args) {
		//console.log(args);
		this.consts = args.consts;
		this.title  = args.title;
		this.url    = args.url;

		//폼객체
		this.form = $(args.formKey);
		
		//목록폼객체
		this.list = $(args.listKey);

	},
	//에디터가 없는 경우 
	initForm2: function(args) {
		
		this.consts = args.consts;
		this.title  = args.title;
		this.url    = args.url;

		var jobj   = this;
		var params = args.params;

		//등록폼객체
		this.form = $(args.formKey);
		//목록폼객체
		this.list = $(args.listKey);
		//폼패널객체
		this.panel = $(args.panelKey);

		//업로드 컨트롤 사용시
		if (args.layoutKey) {
			//업로드용 컨트롤 초기화
			this.upload = this.initUpload(args, params);
		}
		
		//수정인 경우 상세조회
		if (jstatus.isUpdate(params)) {

			//폼패널 제목
			this.panel.panel('setTitle', this.title + " " + tit.TITLE0038);

			this.select(this.url.select, params, function(data) {
				//수정상태 정의
				jstatus.update(data);
				//폼데이터 로드
				jobj.form.form('load', data);
				
				//레이어데이터 로드
				jcommon.toHtml(data, "v_");
				//상세조회결과 대입
				jobj.viewData = data;
				
				if (args.localBindEvent)
					args.localBindEvent(data);
				
			});
		}
		//등록인 경우 버튼활성처리
		else {
			//영문임시
			//this.panel.panel('setTitle', this.title + msg.MSG0137);
			if (args.localBindEventInit)
				args.localBindEventInit();

		}
		//Form Hidden Value 정의
		args.setHiddenValues(params);
		
	},
	//상세조회
	select: function(url, params, callback) {
		//수정일 경우 상세조회
		jlogic.select({
			url: url,
			data: params,
			success: function(data) {
	        	if (!data ||
	        		!data.rows) {
	        		$.messager.alert(msg.MSG0121,msg.MSG0031,msg.MSG0121);
	        		return;
	        	}
	        	//콜백함수 호출
	        	callback(data.rows);
			}
		});
	},
	//웹에디터 초기화
	initEditor: function(args) {
		//console.log(args);
		// jeditor가 아직 로드되지 않았을 경우 대기 (최대 5초)
		var maxAttempts = 500;
		var attempts = 0;
		while ((typeof jeditor === 'undefined' || jeditor === false || typeof jeditor !== 'function') && attempts < maxAttempts) {
			attempts++;
			// 동기 대기 (10ms)
			var start = new Date().getTime();
			while (new Date().getTime() - start < 10) {
				// 10ms 대기
			}
		}
		if (typeof jeditor !== 'undefined' && jeditor !== false && typeof jeditor === 'function') {
			return new jeditor(args);
		} else {
			console.error('jeditor is not available after waiting');
			return false;
		}
	},
	//end
	//업로드컨트롤 초기화
	initUpload: function(args, data) {

		return jupload.init({
			//편집모드
			mode:      args.mode,
			//등록폼 KEY (#포함)
			formKey:   args.formKey,
			//첨부파일 레이어 KEY
			layoutKey: args.layoutKey,
			//첨부파일 업로더 KEY
			loaderKey: args.loaderKey,
			//첨부파일 INPUT 명칭
			fileName:  args.fileName,
			//첨부파일 그리드 KEY
			gridKey:   args.gridKey,
			//첨부파일 검색조건
			params: {
				atchGrup: data.bordGrup,
				atchNo:   data.bordNo
			}
		});
	},
	//편집화면 초기화
	initForm: function(args) {

		this.consts = args.consts;
		this.title  = args.title;
		this.url    = args.url;

		var jobj   = this;
		var params = args.params;

		//등록폼객체
		this.form = $(args.formKey);
		//목록폼객체
		this.list = $(args.listKey);
		//폼패널객체
		this.panel = $(args.panelKey);

		//업로드 컨트롤 사용시
		if (args.layoutKey) {
			//업로드용 컨트롤 초기화
			this.upload = this.initUpload(args, params);
		}

		//수정인 경우 상세조회
		if (jstatus.isUpdate(params)) {

			//폼패널 제목
			this.panel.panel('setTitle', this.title + " " + tit.TITLE0038);

			this.select(this.url.select, params, function(data) {
				//수정상태 정의
				jstatus.update(data);
				//폼데이터 로드
				jobj.form.form('load', data);
				//웹에디터객체
				jobj.editor = jobj.initEditor(args);

				//웹에디터 값처리 (SCEDITOR 적용시 사용)
				jobj.setEditorText(data);

				if (args.localBindEvent)
					args.localBindEvent(data);
				
				//TODO 편집가능인 경우 버튼활성처리
				//if (data.editable)
				//	jobj.formdialog.enable(jobj.buttons.form);
				
				//select 후처리 있다면 실행 추가
				if (args.afterSelect)
			        args.afterSelect(data);
			});
		}
		//등록인 경우 버튼활성처리
		else {
			//폼패널 제목
			//this.panel.panel('setTitle', this.title + " " + tit.TITLE0037);
			//영문임시
			this.panel.panel('setTitle', this.title + msg.MSG0137);

			//웹에디터객체
			this.editor = this.initEditor(args);

			//TODO jobj.formdialog.enable(jobj.buttons.form);
		}
		//Form Hidden Value 정의
		args.setHiddenValues(params);

		//기타 이벤트 정의
		if (args.bindEvent)
			args.bindEvent(params);
	},
	//상세화면 초기화
	initView: function(args) {

		this.consts = args.consts;
		this.url    = args.url;

		var jobj   = this;
		var params = args.params;

		//조회상태값 정의
		jstatus.read(params);

		//조회폼객체
		this.form = $(args.formKey);
		//목록폼객체
		this.list = $(args.listKey);

		this.viewData = false;
		//상세조회
		this.select(this.url.select, params, function(data) {
			//레이어데이터 로드
			jcommon.toHtml(data, "v_");
			//상세조회결과 대입
			jobj.viewData = data;
			

			//업로드 컨트롤 사용시
			if (args.layoutKey) {
				//업로드파일 조회용 컨트롤 초기화
				jobj.initUpload(args, data);
			}
			
			if (data.editable != true){
				$('#update-button').css('display', 'none');
				$('#remove-button').css('display', 'none');
			}
			
			//TODO 편집가능인 경우 버튼활성처리
			//if (data.editable)
				//jobj.viewdialog.enable(jobj.buttons.view);
			
			//select 후처리 있다면 실행 추가
			if (args.afterSelect)
		        args.afterSelect(data);
		});

		//Form Hidden Value 정의
		args.setHiddenValues(params);

		//기타 이벤트 정의
		if (args.bindEvent)
			args.bindEvent(params);
	},
	//상세화면 초기화
	//에디터가 없는경우
	initView2: function(args) {

		this.consts = args.consts;
		this.url    = args.url;

		var jobj   = this;
		var params = args.params;

		//조회상태값 정의
		jstatus.read(params);

		//조회폼객체
		this.form = $(args.formKey);
		//목록폼객체
		this.list = $(args.listKey);

		this.viewData = false;
		//상세조회
		this.select(this.url.select, params, function(data) {
			//레이어데이터 로드
			jcommon.toHtml(data, "v_");
			//상세조회결과 대입
			jobj.viewData = data;
			
			//업로드 컨트롤 사용시
			if (args.layoutKey) {
				//업로드파일 조회용 컨트롤 초기화
				jobj.initUpload(args, data);
			}
			
			if (args.localBindEvent)
				args.localBindEvent(data);
			
		});
		
		//Form Hidden Value 정의
		args.setHiddenValues(params);

	},
	//폼데이터 객체에 첨부파일 목록 추가(JSON)
	addJsonFiles: function(data) {

		if (this.upload == false)
			return;
		//첨부파일목록
		var files = this.upload.getFiles();
		
		//comment 추가
		/*var commemtCnt = $("input[name=fileComment]").length; //files.length - 1;
		var _comment = [];
		for (var i=0; i<commemtCnt; i++) {
			_comment.push($("input[name=fileComment]").eq(i).val())
		}
		const comment = _comment.reverse();
		var cnt = 0;
		for (var i=0; i<files.length; i++) {
			if(files[i].oper != 'D') {
				files[i].comment = comment[cnt];
				cnt++;
			}
		}*/
		data['files'] = $.toJSON(files);
	},
	//폼데이터 객체에 웹에디터 컨텐츠 추가
	addEditorText: function(data) {
		data['bordText'] = this.editor.get();
	},
	//수정폼에서 웹에디터 컨텐츠 바인딩
	setEditorText: function(data) {
		this.editor.set(data['bordText']);
	},
	//컨텐츠 바이트 체크
	checkEditorText: function(data) {
		var s = data['bordText'];
		return jutils.checkMaxBytes(s, 4000);
	},
	//조회 데이터 가져오기
	getViewData: function() {
		return this.viewData;
	},
	//저장 데이터 가져오기
	getFormData: function() {

		if (!this.form.form('validate'))
			return null;

		//폼데이터
		var data = this.form.serializeObject();

		//폼데이터 객체에 첨부파일 목록 추가(JSON)
		this.addJsonFiles(data);
		//폼데이터 객체에 웹에디터 컨텐츠 추가
		this.addEditorText(data);

		if (!this.checkEditorText(data))
			return null;

		return data;
	},
	//저장버튼 클릭시 저장처리
	doSave: function() {
		var jobj = jboard;

		var data = jobj.getFormData();

		if (data == null)
			return;
		jlogic.save({
			url: jobj.url.save,
			data: data,
			success: function(res) {
				jobj.consts.doResult(res);
			},
			message: msg.MSG0118
		});
	},
	//파일,에디터없는경우
	doSave2: function() {

		var jobj = jboard;

		//폼데이터
		var data = jobj.form.serializeObject();
		
		if (data == null)
			return;

		jlogic.save({
			url: jobj.url.save,
			data: data,
			success: function(res) {
				jobj.consts.doResult(res);
			},
			message: msg.MSG0118
		});
	},
	//삭제버튼 클릭시 삭제처리
	doRemove: function() {
		var jobj = jboard;
		//폼데이터
		var data = jobj.form.serializeObject();
		jlogic.remove({
			url: jobj.url.remove,
			data: data,
			success: function(res) {
				jobj.consts.doResult(res);
			},
			message: tit.MSG0144
		});
	},
	//목록버튼 클릭시 목록으로 이동
	doList: function() {
		var jobj = jboard;
		var form = jobj.list; //목록폼
	    form.attr("action", jobj.url.list);
	    form.attr("target", "_self");
	    form.submit();
	},
	//수정버튼 클릭시 수정으로 이동
	doUpdate: function() {
		var jobj = jboard;
		var form = jobj.list;
		form.find('[name="oper"]'  ).val (jstatus.UPDATE);
	    form.attr("action", jobj.url.form);
	    form.attr("target", "_self");
	    form.submit();
	},
	//등록버튼 클릭시 등록으로 이동
	doRegist: function() {
		var jobj = jboard;
		var form = jobj.form;
		form.find('[name="oper"]'  ).val (jstatus.INSERT);
		form.find('[name="bordNo"]').val ("");
	    form.attr("action", jobj.url.form);
	    form.attr("target", "_self");
	    form.submit();
	},
	//상세조회시 해당 페이지 이동
	doSelect: function(row) {
		var jobj = jboard;
		var form = jobj.form;
		form.find('[name="oper"]'  ).val (jstatus.READ);
		form.find('[name="bordNo"]').val (row['bordNo']);
	    form.attr("action", jobj.url.view);
	    form.attr("target", "_self");
	    form.submit();
	},
	//답변버튼 클릭시 해당 페이지 이동
	doReply: function(row) {
		var jobj = jboard;
		var form = jobj.form;
		form.find('[name="oper"]'  ).val (jstatus.INSERT);
		form.find('[name="bordNo"]').val ("");
		form.find('[name="bordTitle"]').val ('[Re]'+jobj.viewData.bordTitle);
	    form.attr("action", jobj.url.form);
	    form.attr("target", "_self");
	    form.submit();
	}
};

var jboard2 = {
		consts:     false,
		upload:     false,  //파일업로드 컨트롤
		editor:     false,  //웹에디터 컨트롤
		title:      false,  //제목
		panel:      false,  //패널 객체
		form:       false,  //편집폼 객체
		list:       false,  //목록폼 객체
		url:        false,
		viewData:   false,  //상세조회 결과객체
		//목록화면 초기화
		init: function(args) {
			//console.log(args);
			this.consts = args.consts;
			this.title  = args.title;
			this.url    = args.url;

			//폼객체
			this.form = $(args.formKey);
			
			//목록폼객체
			this.list = $(args.listKey);

		},
		//에디터가 없는 경우 
		initForm2: function(args) {
			
			this.consts = args.consts;
			this.title  = args.title;
			this.url    = args.url;

			var jobj   = this;
			var params = args.params;

			//등록폼객체
			this.form = $(args.formKey);
			//목록폼객체
			this.list = $(args.listKey);
			//폼패널객체
			this.panel = $(args.panelKey);

			//업로드 컨트롤 사용시
			if (args.layoutKey) {
				//업로드용 컨트롤 초기화
				this.upload = this.initUpload(args, params);
			}
			
			//수정인 경우 상세조회
			if (jstatus.isUpdate(params)) {

				//폼패널 제목
				this.panel.panel('setTitle', this.title + " " + tit.TITLE0038);

				this.select(this.url.select, params, function(data) {
					//수정상태 정의
					jstatus.update(data);
					//폼데이터 로드
					jobj.form.form('load', data);
					
					//레이어데이터 로드
					jcommon.toHtml(data, "v_");
					//상세조회결과 대입
					jobj.viewData = data;
					
					if (args.localBindEvent)
						args.localBindEvent(data);
					
				});
			}
			//등록인 경우 버튼활성처리
			else {
				//영문임시
				//this.panel.panel('setTitle', this.title + msg.MSG0137);
				if (args.localBindEventInit)
					args.localBindEventInit();

			}
			//Form Hidden Value 정의
			args.setHiddenValues(params);
			
		},
		//상세조회
		select: function(url, params, callback) {
			//수정일 경우 상세조회
			jlogic.select({
				url: url,
				data: params,
				success: function(data) {
		        	if (!data ||
		        		!data.rows) {
		        		$.messager.alert(msg.MSG0121,msg.MSG0031,msg.MSG0121);
		        		return;
		        	}
		        	//콜백함수 호출
		        	callback(data.rows);
				}
			});
		},
		//웹에디터 초기화
		initEditor: function(args) {
			//console.log(args);
			return new jeditor(args);
		},
		//업로드컨트롤 초기화
		initUpload: function(args, data) {
			return jupload2.init({
				//편집모드
				mode:      args.mode,
				//등록폼 KEY (#포함)
				formKey:   args.formKey,
				//첨부파일 레이어 KEY
				layoutKey: args.layoutKey,
				//첨부파일 업로더 KEY
				loaderKey: args.loaderKey,
				//첨부파일 INPUT 명칭
				fileName:  args.fileName,
				//첨부파일 그리드 KEY
				gridKey:   args.gridKey,
				//첨부파일 검색조건
				params: {
					atchGrup: data.bordGrup,
					atchNo:   data.bordNo
				}
			});
			
		},
		//편집화면 초기화
		initForm: function(args) {

			this.consts = args.consts;
			this.title  = args.title;
			this.url    = args.url;

			var jobj   = this;
			var params = args.params;

			//등록폼객체
			this.form = $(args.formKey);
			//목록폼객체
			this.list = $(args.listKey);
			//폼패널객체
			this.panel = $(args.panelKey);

			//업로드 컨트롤 사용시
			if (args.layoutKey) {
				//업로드용 컨트롤 초기화
				this.upload = this.initUpload(args, params);
			}

			//수정인 경우 상세조회
			if (jstatus.isUpdate(params)) {

				//폼패널 제목
				this.panel.panel('setTitle', this.title + " " + tit.TITLE0038);

				this.select(this.url.select, params, function(data) {
					//수정상태 정의
					jstatus.update(data);
					//폼데이터 로드
					jobj.form.form('load', data);
					//웹에디터객체
					jobj.editor = jobj.initEditor(args);

					//웹에디터 값처리 (SCEDITOR 적용시 사용)
					jobj.setEditorText(data);

					if (args.localBindEvent)
						args.localBindEvent(data);
					
					//TODO 편집가능인 경우 버튼활성처리
					//if (data.editable)
					//	jobj.formdialog.enable(jobj.buttons.form);
				});
			}
			//등록인 경우 버튼활성처리
			else {
				//폼패널 제목
				//this.panel.panel('setTitle', this.title + " " + tit.TITLE0037);
				//영문임시
				this.panel.panel('setTitle', this.title + msg.MSG0137);

				//웹에디터객체
				this.editor = this.initEditor(args);

				//TODO jobj.formdialog.enable(jobj.buttons.form);
			}
			//Form Hidden Value 정의
			args.setHiddenValues(params);

			//기타 이벤트 정의
			if (args.bindEvent)
				args.bindEvent(params);
		},
		//상세화면 초기화
		initView: function(args) {

			this.consts = args.consts;
			this.url    = args.url;

			var jobj   = this;
			var params = args.params;

			//조회상태값 정의
			jstatus.read(params);

			//조회폼객체
			this.form = $(args.formKey);
			//목록폼객체
			this.list = $(args.listKey);

			this.viewData = false;
			//상세조회
			this.select(this.url.select, params, function(data) {
				//레이어데이터 로드
				jcommon.toHtml(data, "v_");
				//상세조회결과 대입
				jobj.viewData = data;
				

				//업로드 컨트롤 사용시
				if (args.layoutKey) {
					//업로드파일 조회용 컨트롤 초기화
					jobj.initUpload(args, data);
				}
				
				if (data.editable != true){
					$('#update-button').css('display', 'none');
					$('#remove-button').css('display', 'none');
				}
				
				//TODO 편집가능인 경우 버튼활성처리
				//if (data.editable)
					//jobj.viewdialog.enable(jobj.buttons.view);
			});

			//Form Hidden Value 정의
			args.setHiddenValues(params);

			//기타 이벤트 정의
			if (args.bindEvent)
				args.bindEvent(params);
		},
		//상세화면 초기화
		//에디터가 없는경우
		initView2: function(args) {

			this.consts = args.consts;
			this.url    = args.url;

			var jobj   = this;
			var params = args.params;

			//조회상태값 정의
			jstatus.read(params);

			//조회폼객체
			this.form = $(args.formKey);
			//목록폼객체
			this.list = $(args.listKey);

			this.viewData = false;
			//상세조회
			this.select(this.url.select, params, function(data) {
				//레이어데이터 로드
				jcommon.toHtml(data, "v_");
				//상세조회결과 대입
				jobj.viewData = data;
				
				//업로드 컨트롤 사용시
				if (args.layoutKey) {
					//업로드파일 조회용 컨트롤 초기화
					jobj.initUpload(args, data);
				}
				
				if (args.localBindEvent)
					args.localBindEvent(data);
				
			});
			
			//Form Hidden Value 정의
			args.setHiddenValues(params);

		},
		//폼데이터 객체에 첨부파일 목록 추가(JSON)
		addJsonFiles: function(data) {

			if (this.upload == false)
				return;
			//첨부파일목록
			var files = this.upload.getFiles();
			
			//comment 추가
			/*var commemtCnt = $("input[name=fileComment]").length; //files.length - 1;
			var _comment = [];
			for (var i=0; i<commemtCnt; i++) {
				_comment.push($("input[name=fileComment]").eq(i).val())
			}
			const comment = _comment.reverse();
			var cnt = 0;
			for (var i=0; i<files.length; i++) {
				if(files[i].oper != 'D') {
					files[i].comment = comment[cnt];
					cnt++;
				}
			}*/
			data['files'] = $.toJSON(files);
		},
		//폼데이터 객체에 웹에디터 컨텐츠 추가
		addEditorText: function(data) {
			data['bordText'] = this.editor.get();
		},
		//수정폼에서 웹에디터 컨텐츠 바인딩
		setEditorText: function(data) {
			this.editor.set(data['bordText']);
		},
		//컨텐츠 바이트 체크
		checkEditorText: function(data) {
			var s = data['bordText'];
			return jutils.checkMaxBytes(s, 4000);
		},
		//조회 데이터 가져오기
		getViewData: function() {
			return this.viewData;
		},
		//저장 데이터 가져오기
		getFormData: function() {

			if (!this.form.form('validate'))
				return null;

			//폼데이터
			var data = this.form.serializeObject();

			//폼데이터 객체에 첨부파일 목록 추가(JSON)
			this.addJsonFiles(data);
			//폼데이터 객체에 웹에디터 컨텐츠 추가
			this.addEditorText(data);

			if (!this.checkEditorText(data))
				return null;

			return data;
		},
		//저장버튼 클릭시 저장처리
		doSave: function() {
			var jobj = jboard2;

			var data = jobj.getFormData();

			if (data == null)
				return;
			jlogic.save({
				url: jobj.url.save,
				data: data,
				success: function(res) {
					jobj.consts.doResult(res);
				},
				message: msg.MSG0118
			});
		},
		//파일,에디터없는경우
		doSave2: function() {

			var jobj = jboard2;

			//폼데이터
			var data = jobj.form.serializeObject();
			
			if (data == null)
				return;

			jlogic.save({
				url: jobj.url.save,
				data: data,
				success: function(res) {
					jobj.consts.doResult(res);
				},
				message: msg.MSG0118
			});
		},
		//삭제버튼 클릭시 삭제처리
		doRemove: function() {
			var jobj = jboard2;
			//폼데이터
			var data = jobj.form.serializeObject();
			jlogic.remove({
				url: jobj.url.remove,
				data: data,
				success: function(res) {
					jobj.consts.doResult(res);
				},
				message: msg.MSG0084
			});
		},
		//목록버튼 클릭시 목록으로 이동
		doList: function() {
			var jobj = jboard2;
			var form = jobj.list; //목록폼
		    form.attr("action", jobj.url.list);
		    form.attr("target", "_self");
		    form.submit();
		},
		//수정버튼 클릭시 수정으로 이동
		doUpdate: function() {
			var jobj = jboard2;
			var form = jobj.list;
			form.find('[name="oper"]'  ).val (jstatus.UPDATE);
		    form.attr("action", jobj.url.form);
		    form.attr("target", "_self");
		    form.submit();
		},
		//등록버튼 클릭시 등록으로 이동
		doRegist: function() {
			var jobj = jboard2;
			var form = jobj.form;
			form.find('[name="oper"]'  ).val (jstatus.INSERT);
			form.find('[name="bordNo"]').val ("");
		    form.attr("action", jobj.url.form);
		    form.attr("target", "_self");
		    form.submit();
		},
		//상세조회시 해당 페이지 이동
		doSelect: function(row) {
			var jobj = jboard2;
			var form = jobj.form;
			form.find('[name="oper"]'  ).val (jstatus.READ);
			form.find('[name="bordNo"]').val (row['bordNo']);
		    form.attr("action", jobj.url.view);
		    form.attr("target", "_self");
		    form.submit();
		},
		//답변버튼 클릭시 해당 페이지 이동
		doReply: function(row) {
			var jobj = jboard2;
			var form = jobj.form;
			form.find('[name="oper"]'  ).val (jstatus.INSERT);
			form.find('[name="bordNo"]').val ("");
			form.find('[name="bordTitle"]').val ('[Re]'+jobj.viewData.bordTitle);
		    form.attr("action", jobj.url.form);
		    form.attr("target", "_self");
		    form.submit();
		}
	};
