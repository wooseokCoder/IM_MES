/*
 * @(#)business.js 1.0 2014/08/10
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */

/**
 * 기본 CRUD 컨트롤을 처리하는 스크립트.
 *
 * @author C-NODE
 * @version 1.0 2014/08/10
 */

var jconsts = {};

//===========================================================================//
// 공통 로직함수
//===========================================================================//
var jlogic = {
	//args.url
	//args.data
	//args.oper
	//args.message
	save: function(args) {

		var cfg = {
			type: "post",
			dataType: "json"
		};

		$.extend(cfg, args);

		var fnSave = function() {
			if (cfg.data &&
				cfg.oper) {
				jstatus.set(cfg.data, cfg.oper);
			}
			$.ajax(cfg);
		}

		if (cfg.message) {
			$.messager.confirm(msg.MSG0123, cfg.message, function(r) {
				if (!r)
					return;

				fnSave();
			});
		}
		else {
			fnSave();
		}
	},
	remove: function(args) {
		$.extend(args, {oper: jstatus.DELETE});
		this.save(args);
	},
	select: function(args) {

		var cfg = {
			type: "post",
			dataType: "json"
		};

		$.extend(cfg, args);

		$.ajax(cfg);
	},
	excel: function(args) {
		excel();
		//엑셀 다운로드
		function excel(){
		    setCookie("fileDownload","false"); //호출
			checkDownloadCheck();
			//  프로그래스바 ON 
			args.form.attr({action:args.url}).submit();
			}

		function setCookie(c_name,value){
		    var exdate=new Date();
		    var c_value=escape(value);
		    document.cookie=c_name + "=" + c_value + "; path=/";
			}
		function checkDownloadCheck(){
			if (document.cookie.indexOf("fileDownload=true") != -1) {
			    var date = new Date(1000);
			    document.cookie = "fileDownload=; expires=" + date.toUTCString() + "; path=/";
			    //프로그래스바 OFF 
			    $('#progress-popup').dialog('close');
			    return;
			   }
			   setTimeout(checkDownloadCheck , 100);
			}
		
	},
	excelPost : function(args){
		excel();
		//엑셀 다운로드
		function excel(){
		    setCookie("fileDownload","false"); //호출
			checkDownloadCheck();

		    var xhr = new XMLHttpRequest();
		    xhr.onreadystatechange = function(){
		        if (this.readyState == 4 && this.status == 200){
		            var filename = "";
		            var disposition = xhr.getResponseHeader('Content-Disposition');
		            if (disposition && disposition.indexOf('attachment') !== -1) {
		                var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
		                var matches = filenameRegex.exec(disposition);
		                if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
		            }
		         
		            //this.response is what you're looking for
		            console.log(this.response, typeof this.response);
		            var a = document.createElement("a");
		            var url = URL.createObjectURL(this.response)
		            a.href = url;
		            a.download = filename;
		            document.body.appendChild(a);
		            a.click();
		            window.URL.revokeObjectURL(url);
		       }
		   }
		   //xhr.open('POST', consts.url.excel);
		   console.log(args.url);
		   xhr.open('POST', args.url);
		   xhr.responseType = 'blob'; 
		   xhr.send(JSON.stringify(args.data));
		}

		function setCookie(c_name,value){
		    var exdate=new Date();
		    var c_value=escape(value);
		    document.cookie=c_name + "=" + c_value + "; path=/";
			}
		function checkDownloadCheck(){
			if (document.cookie.indexOf("fileDownload=true") != -1) {
			    var date = new Date(1000);
			    document.cookie = "fileDownload=; expires=" + date.toUTCString() + "; path=/";
			    //프로그래스바 OFF 
			    $('#progress-popup').dialog('close');
			    return;
			   }
			   setTimeout(checkDownloadCheck , 100);
			}
		
	},
	report: function(args) {

		var params = jutils.toQueryString(args.params);
		var url    = args.url+params;

		window.open(url, "wscreportwin", "width=1024,height=768,scrollbars=yes,status=yes,menubar=yes,toolbar=yes");
	},
	//결과처리
	result: function(response, callback) {
		var res = response;
		if (typeof res == 'string') {
			res = jutils.escapeJson(res);
		}
		//jcommon.printobject(obj);
		if (res.success) {

			// show message
			$.messager.show({
				title: msg.MSG0122,
				msg: msg.MSG0122
			});

			if (callback && $.isFunction(callback)) {
				callback(res);
			}
		}
		else {
			// show error message
			//$.messager.alert('Error',res.error,'Error',function(r){doSearch()});//TODO 20160928 김원국 추가
			$.messager.show({
				title: 'Error',
				msg: res.error
			});

			if (callback && $.isFunction(callback)) {
				callback(res);
			}
		}
	}
};

//===========================================================================//
// 그리드 항목 공통 포맷함수 모음
//===========================================================================//
//포맷함수 모음
var jformat = {
	//권한여부 포맷처리
	tran: function(val, row) {
		if (val=='1')
			return '허용';
		else if (val=='0')
			return '거부';

		return val;
	},
	//YES,NO 포맷처리
	yesno: function(val, row) {
		if (val=='Y')
			return '예';
		return '아니오';
	},
	//활성여부 포맷처리
	enable: function(val, row) {
		if (val=='Y')
			return '활성';

		return '비활성';
	},
	//숫자포맷처리
	number: function(val, row) {
		return jutils.formatMoney(val);
	},
	//2016/09/26 김영진 추가 사용유무 포맷처리
	useflag: function(val, row){
		if(val=='Y')
			return '사용중';
		return '중지';
	},
	act: function(val, row) {
		if (val=='Y')
			return 'O';
		else if (val=='N')
			return 'X';

		return val;
	},
	//2016/12/22 김영진 -- 첨부파일 포맷처리
	filecnt: function(val, row){
		var cnt = val*1;
		if(val > 0){
			var strCnt = "<i class='fa fa-file-o'></i>";
			return strCnt;
		}
		return '';
	},
	
	invprint: function(val, row){
		var cnt = val*1;
		if(val > 0){
			var strCnt = "<i class='fa fa-print fa-2x'></i>";
			return strCnt;
		}
		return '';
	}
};

//[WSC2.0] [2015.04.13 LSH] IE8에서 날짜선택오류 수정
$.fn.datebox.defaults.formatter = function(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return (m<10?('0'+m):m)+'.'+(d<10?('0'+d):d)+'.'+y;
};
$.fn.datebox.defaults.parser = function(s){
   if (!s) return new Date();
   var ss = s.split('.');
   var m = parseInt(ss[0],10);
   var d = parseInt(ss[1],10);
   var y = parseInt(ss[2],10);
   if (!isNaN(m) && !isNaN(d) && !isNaN(y)){
      return new Date(y,m-1,d);
   } else {
      return new Date();
   }
};
//[WSC2.0] [2015.04.28 LSH] 날짜 Validation 추가
$.extend($.fn.validatebox.defaults.rules, {
	validDate: {
		validator: function(value){
			var date = $.fn.datebox.defaults.parser(value);
			var s = $.fn.datebox.defaults.formatter(date);
			return s==value;
		},
		message: 'Please enter a valid date.'
	}
});

//[WSC2.0] [2017.03.23 김연주] 날짜 Validation 추가
$.extend($.fn.validatebox.defaults.rules, {
	validDate: {
		validator: function(value){
			var date = $.fn.datebox.defaults.parser(value);
			var s = $.fn.datebox.defaults.formatter(date);
			return s==value;
		},
		message: 'Please enter a valid date.'
	}
});

//===========================================================================//
// 등록,수정,삭제 상태값
//===========================================================================//
var jstatus = {
	INSERT: 'I',    //등록 상태값
	UPDATE: 'U',    //수정 상태값
	DELETE: 'D',    //삭제 상태값
	READ:   'R',    //조회 상태값
	REPLY:  'A',    //답변 상태값
	DONE:   'X',    //비활성 상태값
	STATUS: 'oper', //상태 필드명
	//-----------------------------------------//
	//폼객체에 상태값 바인딩
	setForm: function(form, status) {

		var oper = form.find('[name="'+this.STATUS+'"]');

		if (jutils.empty(oper))
			return;

		if (jutils.empty(status)) {
			oper.val(this.INSERT);
			return;
		}
		oper.val(status);
	},
	//-----------------------------------------//
	//일반객체에 상태값 바인딩
	setObject: function(data, status) {
		if (jutils.empty(data))
			return;

		if (jutils.empty(status)) {
			data[this.STATUS] = this.INSERT;
			return;
		}
		data[this.STATUS] = status;
	},
	//-----------------------------------------//
	//입력받은 상태값 바인딩
	set: function(data, status) {
		if (data instanceof jQuery)
			this.setForm(data, status);
		else
			this.setObject(data, status);
	},
	//-----------------------------------------//
	//등록상태값 바인딩
	insert: function(data) {
		if (data instanceof jQuery)
			this.setForm(data);
		else
			this.setObject(data);
	},
	//-----------------------------------------//
	//수정상태값 바인딩
	update: function(data) {
		if (data instanceof jQuery)
			this.setForm(data, this.UPDATE);
		else
			this.setObject(data, this.UPDATE);
	},
	//-----------------------------------------//
	//삭제상태값 바인딩
	remove: function(data) {
		if (data instanceof jQuery)
			this.setForm(data, this.DELETE);
		else
			this.setObject(data, this.DELETE);
	},
	//-----------------------------------------//
	//조회상태값 바인딩
	read: function(data) {
		if (data instanceof jQuery)
			this.setForm(data, this.READ);
		else
			this.setObject(data, this.READ);
	},
	//-----------------------------------------//
	//비활성상태값 바인딩
	done: function(data) {
		if (data instanceof jQuery)
			this.setForm(data, this.DONE);
		else
			this.setObject(data, this.DONE);
	},
	//-----------------------------------------//
	//상태 확인
	equals: function(data, status) {
		var s = '';

		if (data instanceof jQuery)
			s = data.find('[name="'+this.STATUS+'"]').val();
		else
			s = data[this.STATUS];

		return (s == status);
	},
	//-----------------------------------------//
	//등록상태인지 확인
	isInsert: function(data) {
		return this.equals(data, this.INSERT);
	},
	//-----------------------------------------//
	//수정상태인지 확인
	isUpdate: function(data) {
		return this.equals(data, this.UPDATE);
	},
	//-----------------------------------------//
	//삭제상태인지 확인
	isRemove: function(data) {
		return this.equals(data, this.DELETE);
	}
};

//===========================================================================//
//그리드 검색 및 폼패널 CRUD 처리
//===========================================================================//
jeasygrid = function (args) {

	var control = this;

	//컨트롤 사용항목
	var options = {
		title:    false, //화면제목
		gridKey:  "#search-grid",
		formKey:  "#regist-form",
		sformKey: "#search-form",
		popupKey: "#regist-dialog",
		spanPrefix: 'r_',
		grid:  false, //그리드 객체
		form:  false, //등록폼 객체
		sform: false, //검색폼 객체
		popup: false, //팝업패널 객체
		index: undefined, //그리드 편집시 선택INDEX
		gridOptions: {
			url: null,
			title: null,
			iconCls: null,
			rownumbers: true,
			pagination: true,
			fitColumn: true,
			showHeader: true,
			showFooter: true,
			multiSort: true,
			remoteSort: false,
			onBeforeLoad: function(param) {
				//alert('before');
				//jcommon.printobject(param);
			}
		},
		url: {
			search: false, //검색처리 URL
			excel:  false, //엑셀다운 URL
			select: false, //상세조회 URL
			remove: false, //삭제처리 URL
			save:   false  //저장처리 URL
		},
		fn: {
			//저장,삭제 후 결과처리 함수
			result: false
		}
	};

	if (args)
		$.extend(true, options, args);

	options.grid  = $(options.gridKey);
	options.form  = $(options.formKey);
	options.sform = $(options.sformKey);
	options.popup = $(options.popupKey);

	this.grid  = options.grid;
	this.form  = options.form;
	this.sform = options.sform;
	this.popup = options.popup;

	//-----------------------------------------//
	//그리드 생성
	this.init = function(gridOptions) {

		// BBUG.ADD : grid odd/even Color
		/*
		alert('1234567');
		$('#search-grid').datagrid({
			rowStyler:function(index,row){
				if (index % 2 == 1){
					return 'background-color:#fafafa;';
				}
			}
		});  */

		// BBUG.ADD : striped: true  - for grid odd/even Color
		var opts = {url: options.url.search, striped: true};

		if (options.noneTitle) {

		}
		else {
			if (options.title) {
				//opts.title   = options.title + ' 검색';
				//opts.iconCls = 'icon-search';
				opts.title   = options.title;
			}
		}
		$.extend(options.gridOptions, opts);

		if (gridOptions)
			$.extend(options.gridOptions, gridOptions);

		options.grid.datagrid(options.gridOptions);

//		//chang
//		options.grid.datagrid('getPanel').panel('panel').attr('tabindex',1).bind('keydown',function(e){
//
//		var selectedrow = options.grid.datagrid('getSelected');
//		var rowIndex = options.grid.datagrid("getRowIndex", selectedrow);
//		var rowMaxlength = options.grid.datagrid('getRows');
//		if(event.keyCode == 38){
//			if(!(rowIndex == 0)){
//				options.grid.datagrid('selectRow',rowIndex - 1);
//			}
//		}else if(event.keyCode == 40){
//			if(!(rowIndex == rowMaxlength.length - 1)){
//				options.grid.datagrid('selectRow',rowIndex + 1);
//			}
//		}
//		});	//end keydown

	};

	//그리드 옵션이 있을 경우 그리드 생성
	if (args.gridOptions) {
		control.init(args.gridOptions);
	}

	//그리드 검색폼 데이터 반환
	this.getSearchData = function() {
		var f = options.sform;
		return f.serializeObject();
	};

	//그리드 등록폼 데이터 반환
	this.getRegistData = function() {
		var f = options.form;
		return f.serializeObject();
	};

	//-----------------------------------------//
	//그리드 검색폼 검색
	/*this.search = function() {
		var data = this.getSearchData();
		options.grid.datagrid('load',data);

        //g.datagrid('reload');
	};*/

	//그리드 검색폼 검색
	this.search = function(url, param) {
		// 검색URL이 입력되었을경우 URL 맵핑
		if (url) {
			options.gridOptions.url = url;
			options.grid.datagrid('options').url = url;
		}
		// 검색조건 데이터 가져오기
		var data = this.getSearchData();

		// 특정조건이 있을경우 검색조건과 병합처리
		if (param)
			$.extend(data, param);

		options.grid.datagrid('load',data);
		
		// 검색 후 행 선택 초기화 20191016 박민혁
		options.index = undefined;
        
		//g.datagrid('reload');
	};

	//-----------------------------------------//
	//그리드 엑셀다운로드
	this.download = function() {
		jlogic.excel({
			url: options.url.excel,
			form: options.sform
		});
	};
	//그리드 엑셀다운로드2
	this.download2 = function() {
		jlogic.excel({
			url: options.url.excel2,
			form: options.sform
		});
	};
	this.download3 = function() {
		jlogic.excel({
			url: options.url.excel3,
			form: options.sform
		});
	};
	this.download4 = function() {
		jlogic.excel({
			url: options.url.excel4,
			form: options.sform
		});
	};
	this.downloadPost = function() {
		jlogic.excelPost({
			url: options.url.excelPost,
			form: options.sform,
			data: this.getSearchData()
		});
	};
	//-----------------------------------------//
	//그리드 데이터 로드
	this.loadData = function(rows) {
		options.grid.datagrid('loadData',rows);
	};

	//-----------------------------------------//
	//그리드 데이터 초기화
	this.resetData = function() {
		options.grid.datagrid('loadData', {"total":0,"rows":[]});
	};

	//-----------------------------------------//
	//그리드 상세조회
	this.select = function(index, row) {

		control.clear();

		var f   = options.form;
		var url = options.url.select;
		var pre = options.spanPrefix;

		jlogic.select({
			url: url,
			data: row,
			success: function(data) {

	        	if (!data ||
	        		!data.rows) {
	        		$.messager.alert(msg.MSG0121,msg.MSG0031,msg.MSG0121);
	        		return;
	        	}

	        	//폼데이터 로드
	        	f.form('load', data.rows);
	        	//레이어에 데이터 로드
	        	jcommon.toHtml(data.rows, pre);

	        	//수정상태 정의
	        	jstatus.update(f);
			}
		});
	};

	//-----------------------------------------//
	//그리드 리로드
	this.reload = function() {
		options.grid.datagrid('reload');
		options.grid.datagrid('clearSelections');
	};

	//-----------------------------------------//
	//그리드 검색폼 초기화
	this.reset = function() {
		options.sform.form('clear');
	};

	//-----------------------------------------//
	//그리드 행삭제
	this.removeRow = function() {

		var data = control.getSearchData();
		var row  = options.grid.datagrid('getSelected');

		if (!row) {
			$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
			return;
		}

		$.messager.confirm(msg.MSG0123,msg.MSG0123, function(r) {
			if (!r)
				return;

	    	//삭제상태
			jstatus.remove(row);

			$.extend(data,row);

	        $.post(
	        	options.url.remove,
	        	data,
	        	function(data) {
	        		control.result(data);
	        	},
	        	'json'
	        );
		});
	};

	//-----------------------------------------//
	//그리드 다중행 삭제 처리
	this.removeAll = function() {

		var data = control.getSearchData();
		var rows = options.grid.datagrid('getSelections');

		if (!rows || rows.length == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
			return;
		}
		//삭제처리
		$.messager.confirm(msg.MSG0123,msg.MSG0123, function(r) {
			if (!r)
				return;

			$.each(rows, function(i,row) {
		    	//삭제상태
				jstatus.remove(row);
			});

			var url = options.url.remove;

			data['models'] = $.toJSON(rows);
			jstatus.remove(data);

			var fn = function(data) {
				control.result(data);
			};
	        $.post(url,data,fn,'json');
		});
	};

	//-----------------------------------------//
	//2016/10/07 김영진 --그리드 다중행 삭제 처리(체크된 행만)
	this.removeCheckAll = function() {

		var data = control.getSearchData();
		var rows = options.grid.datagrid('getChecked');

		if (!rows || rows.length == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
			return;
		}
		//삭제처리
		$.messager.confirm(msg.MSG0123,msg.MSG0123, function(r) {
			if (!r)
				return;

			$.each(rows, function(i,row) {
		    	//삭제상태
				jstatus.remove(row);
			});

			var url = options.url.remove;

			data['models'] = $.toJSON(rows);
			jstatus.remove(data);

			var fn = function(data) {
				control.result(data);
			};
	        $.post(url,data,fn,'json');
		});
	};

	// TODO
	//-----------------------------------------//
	//2018/06/21 송준기 --그리드 다중행 삭제 처리(체크된 행만)
	this.removeCheckAllEdit = function() {

		var rows = options.grid.datagrid('getChecked');

		if (!rows || rows.length == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
			return;
		}

		$.each(rows, function(i,row) {
	    	//삭제상태
			jstatus.remove(row);
		});

		for(var j=0;j<rows.length;j++){
		   var index = options.grid.datagrid('getRowIndex', rows[j]);
		   options.grid.datagrid('cancelEdit', index).datagrid('deleteRow' , index);
		}

		options.index = undefined;

		control.endEditCustom();

	};

	//-----------------------------------------//
	//등록폼 초기화
	this.clear = function() {
		//등록폼 클리어
		options.form.form('clear');
		//레이어 초기화
    	jcommon.clear(options.spanPrefix);
		//등록상태
		jstatus.insert(options.form);
	};

	//-----------------------------------------//
	//수정폼 데이터바인딩
	this.update = function(data) {
    	//폼데이터 로드
		options.form.form('load',data);
		//레이어 데이터 로드
		jcommon.toHtml(data, options.spanPrefix);
		//수정상태
		jstatus.update(options.form);
	};

	//-----------------------------------------//
	//등록폼 저장
	this.save = function(callback) {

		var f = options.form;

		if (!f.form('validate'))
			return;

		//폼데이터
		var data = f.serializeObject();

		jlogic.save({
			url: options.url.save,
			data: data,
			success: (callback ? callback : control.result)
		});
		/*
		options.form.form('submit',{
	       url: options.url.save,
	       onSubmit: function() {
	    	   return $(this).form('validate');
	       },
	       success:(callback ? callback : control.result)
	    });
	    */
	};

	//-----------------------------------------//
	//등록폼 삭제
	this.remove = function() {

		if (!jstatus.isUpdate(options.form)) {
			$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
			return;
		}

		$.messager.confirm(msg.MSG0123,msg.MSG0123, function(r) {
			if (!r)
				return;

			//삭제상태
			jstatus.remove(options.form);

			//폼데이터
			var data = options.form.serializeObject();

			jlogic.save({
				url: options.url.remove,
				data: data,
				success: control.result
			});

			/*
			options.form.form('submit',{
		       url: options.url.remove,
		       success: control.result
		    });
		    */
		});
	};

	//-----------------------------------------//
	//저장처리 후 결과처리
	this.result = function(response, callback) {

		jlogic.result(response, function(res) {
			if (callback && $.isFunction(callback)) {
				callback(res);
			}
			else {
				control.clear();
				control.reload();
				control.acceptEdit();

				var resultFn = options.fn.result;
				if (resultFn && $.isFunction(resultFn))
					resultFn();
			}
		});
	};

	//-----------------------------------------//
	//현재 그리드 데이터목록 반환
	this.getRows = function() {
		return options.grid.datagrid('getRows');
	};

	/*
	 * DATE : 20150810
	 * KWK
	 * 현재 선택된 데이터 그리드 INDEX 반환
	 */
	this.rowIndex = function() {

//		//chang
//		var datagrid_id = '#search-grid' ;
//
//		$(datagrid_id).datagrid('getPanel').panel('panel').attr('tabindex',1).bind('keydown',function(e){
//
//		var selectedrow = $(datagrid_id).datagrid('getSelected');
//		var rowIndex = $(datagrid_id).datagrid("getRowIndex", selectedrow);
//		var rowMaxlength = $(datagrid_id).datagrid('getRows');
//		if(event.keyCode == 38){
//			if(!(rowIndex == 0)){
//				$(datagrid_id).datagrid('selectRow',rowIndex - 1);
//			}
//		}else if(event.keyCode == 40){
//			if(!(rowIndex == rowMaxlength.length - 1)){
//				$(datagrid_id).datagrid('selectRow',rowIndex + 1);
//			}
//		}
//		});	//end keydown
	};

	//-----------------------------------------//
	//[편집형]그리드 변경된 ROW 배열 반환
	this.getEditChanges = function() {
		return options.grid.datagrid('getChanges');
	};

	//-----------------------------------------//
	//[편집형]그리드 현재 편집행 INDEX 반환
	this.getEditIndex = function() {
		return options.index;
	};

	//-----------------------------------------//
	//[편집형]그리드 편집 종료 처리
	this.endEdit = function() {
	    if (options.index == undefined)
	    	return true;

	    if (options.grid.datagrid('validateRow', options.index)) {
	    	options.grid.datagrid('endEdit', options.index);
	    	options.index = undefined;
	        return true;
	    }
	    else
	    	return false;
	};

	//[편집형]그리드 편집 종료 처리
	/**
	 * 20160922 김원국
	 * 값 입력 바인딩 처리 무조건 바인딩할수있도록 수정
	 */
	this.endEditCustom = function() {
	    if (options.index == undefined)
	    	return true;
	    //강제적으로 변경
	    for(var i=0; i<options.grid.datagrid('getRows').length; i++){
	    	options.grid.datagrid('endEdit', i);
	    }

	    if (options.grid.datagrid('validateRow', options.index)) {
	    	options.grid.datagrid('endEdit', options.index);
	    	options.index = undefined;
	        return true;
	    }
	    else
	    	return false;
	};

	//-----------------------------------------//
	//[편집형]그리드 행 변경시 상태값을 '수정'으로 바인딩
	this.afterEdit = function(index, row, changes) {
		if ($.isEmptyObject(changes) == false &&
			jutils.empty(row.oper))
			jstatus.update(row);
	};
    
	/**
    * idField가 배열 또는 string으로 넘어올때 처리를 위한 beforeEditFields 적용
    * 2019/11/15 c-node
    */
   //ID FIELD 에디터 배열 정의
   options.originEditor = {};

   //[편집형]그리드 ID FIELD의 경우 등록시에만 입력되도록 처리
   this.beforeEditFields = function(index, row) {
      var idf = options.grid.datagrid('options')['idField'];

      if(typeof idf == 'object'){
         for(var i = 0; i < idf.length; i++){

            if (idf[i] == null)
               continue;

            var opt = options.grid.datagrid('getColumnOption', idf[i]);

            if (opt && opt.editor && options.originEditor[idf[i]] == undefined) {
               options.originEditor[idf[i]] = opt.editor;
            }

            //수정상태인 경우
            if (!jstatus.isInsert(row)) {
               opt.editor = false;
               continue;
            }
            //ID FIELD 에디터가 없는경우 SKIP
            if (options.originEditor[idf[i]] == undefined)
               continue;

            var editor = options.originEditor[idf[i]];

            //[2015.05.22 수정]
            if (typeof editor == 'string') {
               opt.editor = {type: editor};
            }
            else {
               opt.editor = $.extend(true, {}, editor);
            }
            if (opt.editor.options == undefined || opt.editor.options == false)
               opt.editor.options = {};
            opt.editor.options.required = true;
         }
      }else{

         if (idf == null)
            return true;

         var opt = options.grid.datagrid('getColumnOption', idf);

         if (opt && opt.editor && options.originEditor[idf] == undefined) {
            options.originEditor[idf] = opt.editor;
         }

         //수정상태인 경우
         if (!jstatus.isInsert(row)) {
            opt.editor = false;
            return true;
         }
         //ID FIELD 에디터가 없는경우 SKIP
         if (options.originEditor[idf] == undefined)
            return true;

         var editor = options.idfEditor;

         //[2015.05.22 수정]
         if (typeof editor == 'string') {
            opt.editor = {type: editor};
         }
         else {
            opt.editor = $.extend(true, {}, editor);
         }
         if (opt.editor.options == undefined || opt.editor.options == false)
            opt.editor.options = {};

         opt.editor.options.required = true;
      }

      return true;
   };
	
	
	
	//-----------------------------------------//
	//[2015.06.05 버그수정] 수정행 클릭후 추가할시에 에디터 오류 수정
	//ID FIELD 에디터 정의
	options.idfEditor = false;

	//[편집형]그리드 ID FIELD의 경우 등록시에만 입력되도록 처리
	this.beforeEdit = function(index, row) {

		var idf = options.grid.datagrid('options')['idField'];

		if (idf == null)
			return true;

		var opt = options.grid.datagrid('getColumnOption', idf);

		if (opt &&
			opt.editor &&
			options.idfEditor == false) {
			options.idfEditor = $.extend(true, {}, opt.editor);
		}

		//수정상태인 경우
		if (!jstatus.isInsert(row)) {
			opt.editor = false;
			return true;
		}
		//ID FIELD 에디터가 없는경우 SKIP
		if (options.idfEditor == false)
			return true;

		var editor = options.idfEditor;

		//[2015.05.22 수정]
		if (typeof editor == 'string') {
			opt.editor = {type: editor};
		}
		else {
			opt.editor = $.extend(true, {}, editor);
		}
		if (opt.editor.options == false)
			opt.editor.options = {};

		opt.editor.options.required = true;
		return true;
		//jcommon.printobject(opt.editor);
		//opt.editor = {type:'validatebox',options:{required:true}};
	};

	//-----------------------------------------//
	//[2015.06.05 버그수정] 수정행 클릭후 추가할시에 에디터 오류 수정
	//ID FIELD 에디터 정의
	/**
	 *  추가 idField2 20170322 박민혁
	 */
	options.idfEditor2 = false;

	//[편집형]그리드 ID FIELD의 경우 등록시에만 입력되도록 처리
	this.beforeEditTwofield = function(index, row) {

		var idf = options.grid.datagrid('options')['idField'];
		var idf2 = options.grid.datagrid('options')['idField2'];

		if (idf == null && idf2 == null)
			return true;

		var opt = options.grid.datagrid('getColumnOption', idf);
		var opt2 = options.grid.datagrid('getColumnOption', idf2);

		if (opt &&
			opt.editor &&
			options.idfEditor2 == false) {
			options.idfEditor2 = $.extend(true, {}, opt.editor);
		}

		if (opt2 &&
			opt2.editor &&
			options.idfEditor2 == false) {
			options.idfEditor2 = $.extend(true, {}, opt2.editor);
		}

		//수정상태인 경우
		if (!jstatus.isInsert(row)) {
			opt.editor = false;
			opt2.editor = false;
			return true;
		}
		//ID FIELD 에디터가 없는경우 SKIP
		if (options.idfEditor2 == false)
			return true;

		var editor = options.idfEditor2;

		//[2015.05.22 수정]
		if (typeof editor == 'string') {
			opt.editor = {type: editor};
			opt2.editor = {type: editor};
		}
		else {
			opt.editor = $.extend(true, {}, editor);
			opt2.editor = $.extend(true, {}, editor);
		}
		if (opt.editor.options == false)
			opt.editor.options = {};

		if (opt2.editor.options == false)
			opt2.editor.options = {};

		opt.editor.options.required = true;
		opt2.editor.options.required = true;

		return true;
	};

	//ID FIELD 에디터 정의
	/**
	 *  추가 idField11 생산계획/일별용 20170322 박민혁
	 */
	options.idfEditor11 = false;	//콤보박스
	options.idfEditor12 = false;	//텍스트
	options.idfEditor14 = false;	//날짜박스

	//[편집형]그리드 ID FIELD의 경우 등록시에만 입력되도록 처리
	this.beforeEditPlandayfield = function(index, row) {

		var idf = options.grid.datagrid('options')['idField'];
		var idf2 = options.grid.datagrid('options')['idField2'];
		var idf7 = options.grid.datagrid('options')['idField7'];
		var idf11 = options.grid.datagrid('options')['idField11'];
		var idf12 = options.grid.datagrid('options')['idField12'];

		if (idf == null && idf2 == null && idf7 == null && idf11 == null && idf12 == null)
			return true;

		var opt = options.grid.datagrid('getColumnOption', idf);
		var opt2 = options.grid.datagrid('getColumnOption', idf2);
		var opt7 = options.grid.datagrid('getColumnOption', idf7);
		var opt11 = options.grid.datagrid('getColumnOption', idf11);
		var opt12 = options.grid.datagrid('getColumnOption', idf12);

		if (opt &&
			opt.editor &&
			options.idfEditor11 == false) {
			options.idfEditor11 = $.extend(true, {}, opt.editor);
		}
		if (opt2 &&
			opt2.editor &&
			options.idfEditor12 == false) {
			options.idfEditor12 = $.extend(true, {}, opt2.editor);
		}
		if (opt7 &&
			opt7.editor &&
			options.idfEditor12 == false) {
			options.idfEditor12 = $.extend(true, {}, opt7.editor);
		}
		if (opt11 &&
			opt11.editor &&
			options.idfEditor12 == false) {
			options.idfEditor12 = $.extend(true, {}, opt11.editor);
		}
		if (opt12 &&
			opt12.editor &&
			options.idfEditor14 == false) {
			options.idfEditor14 = $.extend(true, {}, opt12.editor);
		}

		//수정상태인 경우
		if (!jstatus.isInsert(row)) {
			opt.editor = false;
			opt2.editor = false;
			opt7.editor = false;
			opt11.editor = false;
			opt12.editor = false;
			return true;
		}
		//ID FIELD 에디터가 없는경우 SKIP
		if (options.idfEditor11 == false && options.idfEditor12 == false)
			return true;

		var editor = options.idfEditor11;
		var editor2 = options.idfEditor12;
		var editor4 = options.idfEditor14;

		//[2015.05.22 수정]
		if (typeof editor == 'string') {
			opt.editor = {type: editor};
			opt2.editor = {type: editor2};
			opt7.editor = {type: editor2};
			opt11.editor = {type: editor2};
			opt12.editor = {type: editor4};
		}
		else {
			opt.editor = $.extend(true, {}, editor);
			opt2.editor = $.extend(true, {}, editor2);
			opt7.editor = $.extend(true, {}, editor2);
			opt11.editor = $.extend(true, {}, editor2);
			opt12.editor = $.extend(true, {}, editor4);
		}
		if (opt.editor.options == false)
			opt.editor.options = {};
		if (opt2.editor.options == false)
			opt2.editor.options = {};
		if (opt7.editor.options == false)
			opt7.editor.options = {};
		if (opt11.editor.options == false)
			opt11.editor.options = {};
		if (opt12.editor.options == false)
			opt12.editor.options = {};

		opt.editor.options.required = true;
		opt2.editor.options.required = true;
		opt7.editor.options.required = false;
		opt11.editor.options.required = false;
		opt12.editor.options.required = true;

		return true;
	};
	
	//ID FIELD 에디터 정의
	/**
	 *  추가 idField11 생산실적/공정 20180625 박민혁
	 */
	options.idfEditor21 = false;	//텍스트
	options.idfEditor22 = false;	//숫자박스
	options.idfEditor23 = false;	//날짜박스
	options.idfEditor24 = false;	//콤보박스

	//[편집형]그리드 ID FIELD의 경우 등록시에만 입력되도록 처리
	this.beforeEditProdProcfield = function(index, row) {

		var idf = options.grid.datagrid('options')['idField'];
		var idf2 = options.grid.datagrid('options')['idField2'];
		var idf3 = options.grid.datagrid('options')['idField3'];
		var idf4 = options.grid.datagrid('options')['idField4'];

		if (idf == null && idf2 == null && idf3 == null && idf4 == null)
			return true;

		var opt = options.grid.datagrid('getColumnOption', idf);
		var opt2 = options.grid.datagrid('getColumnOption', idf2);
		var opt3 = options.grid.datagrid('getColumnOption', idf3);
		var opt4 = options.grid.datagrid('getColumnOption', idf4);

		if (opt &&
			opt.editor &&
			options.idfEditor21 == false) {
			options.idfEditor21 = $.extend(true, {}, opt.editor);
		}
		if (opt2 &&
			opt2.editor &&
			options.idfEditor22 == false) {
			options.idfEditor22 = $.extend(true, {}, opt2.editor);
		}
		if (opt3 &&
			opt3.editor &&
			options.idfEditor23 == false) {
			options.idfEditor23 = $.extend(true, {}, opt3.editor);
		}
		if (opt4 &&
			opt4.editor &&
			options.idfEditor24 == false) {
			options.idfEditor24 = $.extend(true, {}, opt4.editor);
		}

		//수정상태인 경우
		if (!jstatus.isInsert(row)) {
			opt.editor = false;
			opt2.editor = false;
			opt3.editor = false;
			opt4.editor = false;
			return true;
		}
		//ID FIELD 에디터가 없는경우 SKIP
		if (options.idfEditor21 == false && options.idfEditor22 == false)
			return true;

		var editor = options.idfEditor21;
		var editor2 = options.idfEditor22;
		var editor3 = options.idfEditor23;
		var editor4 = options.idfEditor24;

		//[2015.05.22 수정]
		if (typeof editor == 'string') {
			opt.editor = {type: editor};
			opt2.editor = {type: editor2};
			opt3.editor = {type: editor3};
			opt4.editor = {type: editor4};
		}
		else {
			opt.editor = $.extend(true, {}, editor);
			opt2.editor = $.extend(true, {}, editor2);
			opt3.editor = $.extend(true, {}, editor3);
			opt4.editor = $.extend(true, {}, editor4);
		}
		if (opt.editor.options == false)
			opt.editor.options = {};
		if (opt2.editor.options == false)
			opt2.editor.options = {};
		if (opt3.editor.options == false)
			opt3.editor.options = {};
		if (opt4.editor.options == false)
			opt4.editor.options = {};

		opt.editor.options.required = true;
		opt2.editor.options.required = false;
		//opt3.editor.options.required = false;

		return true;
	};

	//-----------------------------------------//
	//[편집형]그리드 행클릭시 편집 활성 처리
	this.clickRowEdit = function(idx) {
	    if (options.index == idx)
	    	return;

	    if (control.endEdit()) {
	    	options.grid.datagrid('selectRow', idx)
		  	            .datagrid('beginEdit', idx);
	    	options.index = idx;
	    }
	    else {
	    	options.grid.datagrid('selectRow', options.index);
	    }
	};
	this.clickcheckEdit = function(idx, row) {
		var rows = $('#search-create-grid').datagrid('getRows');
		for(i=0;i<rows.length;i++){
			options.grid.datagrid('endEdit', i);
		}
		
		var checkOption = "OP";
		var checkOption2 = "ADP";
		if(options.grid.datagrid('getRows')[idx]["ITEM_TYPE"].indexOf(checkOption) != -1 || options.grid.datagrid('getRows')[idx]["ITEM_TYPE"].indexOf(checkOption2) != -1){
			options.grid.datagrid('selectRow', idx).datagrid('endEdit', idx);
		}
		else{
			options.grid.datagrid('selectRow', idx)
	            	    .datagrid('beginEdit', idx).focus();
		}
	};

	//-----------------------------------------//
	//[편집형]그리드 행클릭시 편집 활성 처리
	/**
	 * 20160922 김원국
	 * 수정시에도 다른 Row를 클릭하여도 변경할수 있도록 추가
	 */
	this.clickRowEditCustom = function(idx) {

	    if (control.endEdit()) {
	    	options.grid.datagrid('selectRow', idx)
		  	            .datagrid('beginEdit', idx);
	    	options.index = idx;
	    }
	    else {
	    	options.grid.datagrid('selectRow', options.index);
	    }
	};

	this.clickRowEditCustom2 = function(idx) {

    	options.grid.datagrid('selectRow', idx)
                    .datagrid('beginEdit', idx);
        options.index = idx;
	};
	
	//-----------------------------------------//
	//[편집형]그리드 변경된 행 적용완료 처리
	this.acceptEdit = function() {

		if (control.endEdit() == false)
			return;

		options.grid.datagrid('acceptChanges');
	};

	//-----------------------------------------//
	//[편집형]그리드 행 변경 취소 처리
	this.rejectEdit = function() {
		options.grid.datagrid('rejectChanges');
		options.index = undefined;
	};

	//-----------------------------------------//
	//[편집형]그리드 행 추가 처리
	this.appendEdit = function(param) {

		if (control.endEdit() == false)
			return;

		var row = {};
		if(param != null){
			$.extend(row,param);
		}

		jstatus.insert(row);

		options.grid.datagrid('appendRow', row);
		options.index = options.grid.datagrid('getRows').length-1;
		options.grid.datagrid('selectRow', options.index)
		            .datagrid('beginEdit', options.index);
	};

	//-----------------------------------------//
	//[편집형]그리드 행 추가 처리
	/**
	 * 20160922 김원국
	 * 추가를 여러개 추가할수 있도록 추가
	 */
	this.appendEditCustom = function() {

		var row = {};
		jstatus.insert(row);

		options.grid.datagrid('appendRow', row);
		options.index = options.grid.datagrid('getRows').length-1;
		options.grid.datagrid('selectRow', options.index)
		            .datagrid('beginEdit', options.index);
	};

	//-----------------------------------------//
	//[편집형]그리드 행 추가 처리
	//(ROW 파라메터를 받아서 처리한다.)
	this.appendRow = function(row) {

		if (control.endEdit() == false)
			return;

		jstatus.insert(row);

		options.grid.datagrid('appendRow', row);
		options.index = options.grid.datagrid('getRows').length-1;
		options.grid.datagrid('selectRow', options.index)
		            .datagrid('beginEdit', options.index);
	};


	//-----------------------------------------//
	//[편집형]그리드 행 삭제 처리
	this.removeEdit = function() {

		if (options.index == undefined) {
			$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
	    	return;
		}

		var row = options.grid.datagrid('getSelected');

		if (!row) {
			$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
			return;
		}

		jstatus.remove(row);

		options.grid.datagrid('cancelEdit', options.index)
	                .datagrid('deleteRow' , options.index);
		options.index = undefined;

	};

	//-----------------------------------------//
	//[편집형]그리드 행 삭제 처리
	/**
	 * 20160922 김원국
	 * 삭제시 바인딩으로 처리할수 잇도록 수정
	 */
	this.removeEditCustom = function() {

		if (options.index == undefined) {
			$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
	    	return;
		}

		var row = options.grid.datagrid('getSelected');

		if (!row) {
			$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
			return;
		}

		jstatus.remove(row);

		options.grid.datagrid('cancelEdit', options.index)
	                .datagrid('deleteRow' , options.index);
		options.index = undefined;

		control.endEditCustom();

	};

	//-----------------------------------------//
	//[편집형]그리드 다중 편집 행 저장 처리
	this.saveEdit = function() {

		control.endEdit();

		var rows = control.getEditChanges();
		//jcommon.printobject(rows);

		if (rows == null ||
			rows.length == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0023,msg.MSG0121);
			return;
		}

		var data = {models: $.toJSON(rows)};

		jlogic.save({
			url: options.url.save,
			data: data,
			success: control.result
		});
	};

	//-----------------------------------------//
	//[편집형]그리드 다중 편집 행 저장 처리
	/**
	 * 20160922 김원국
	 * 저장하기전 로직 추가
	 */
	this.saveEditCustom = function() {

		control.endEditCustom();

		var rows = control.getEditChanges();
		//jcommon.printobject(rows);

		if (rows == null ||
			rows.length == 0) {
			$.messager.alert(msg.MSG0121,msg.MSG0023,msg.MSG0121);
			return;
		}

		if(!control.endEdit()){
			$.messager.alert(msg.MSG0121,msg.MSG0038,msg.MSG0121);
			return;
		}

		var data = {models: $.toJSON(rows)};

		jlogic.save({
			url: options.url.save,
			data: data,
			success: control.result
		});
	};

	//-----------------------------------------//
	//[편집형]그리드 에디터 변경
	this.changeEditor = function(field, editor) {

		control.endEdit();

		var g = options.grid;

		// now change the editor type
		var opts = g.datagrid('getColumnOption', field);
		opts.editor = editor;
	};

	this.changeTitle = function(title) {

		var g = options.grid;
		var p = g.datagrid('getPanel');    // get the panel
		p.panel('setTitle', title);        // change the panel title
	};

	//-----------------------------------------//
	//검색값 오브젝트 반환
	this.getSearchObject = function() {

		var o = control.getSearchData();
		var g = options.grid;

		o['rows'] = g.datagrid('options')['pageSize'  ];
		o['page'] = g.datagrid('options')['pageNumber'];
		return o;
	};

	return control;
};

//===========================================================================//
//다이얼로그 CRUD 처리
//===========================================================================//
jdialog = function (args) {

	var object = this;

	var options = {
		title:  false,
		dialog: false, // 다이얼로그 객체
		grid:   false, // 그리드 객체(jeasygrid)
		key:    false  // "#regist-dialog"
	};

	//옵션정보가 있는 경우에만 다이얼로그 생성
	if (args.dialogOptions) {
		options.dialogOptions = {
			href:      false,
			width:     800,
			height:    600,
		    modal:     true,
			cache:     false,
			closed:    true,
		    closable:  true,
		    resizable: true,
		    //collapsible: true,
		    //minimizable: true,
		    //maximizable: true,
			iconCls: false,
			buttons: []
		};
		$.extend(true, options, args);
		options.dialog = $(options.key);
		options.dialog.dialog(options.dialogOptions);
	}
	else {
		$.extend(true, options, args);
		options.dialog = $(options.key);
	}

	//다이얼로그 오픈
	this.open = function(args) {

		if (args) {
			if (typeof args == 'string') {
				var t = options.title + (args ? ' '+ args : '');
				options.dialog.dialog('setTitle', t);
			}
			else {
				if (args.title) {
					options.dialog.dialog('setTitle', args.title);
				}
				if (args.left && args.top) {
					options.dialog.dialog('move', args);
				}
			}
		}
		options.dialog.dialog('center');

		options.dialog.dialog('open');
	};

	//다이얼로그 닫기
	this.close = function() {
		options.dialog.dialog('close');
	};

	//버튼 제어
	this.enable = function(prefix) {
		$('a[id^="'+prefix+'"]').each(function() {
			$(this).linkbutton('enable');
		});
	};
	this.disable = function(prefix) {
		$('a[id^="'+prefix+'"]').each(function() {
			$(this).linkbutton('disable');
		});
		//답글 버튼 활성화 20170906 박민혁
		$('a[id=dialog-button-viewReply]').each(function() {
			$(this).linkbutton('enable');
		});
	};

	//-----------------------------------------//
	//수정폼 다이얼로그 오픈
	this.update = function(row) {
		if (options.grid) {
			options.grid.clear();
		}

		this.open('Edit');

		if (options.grid) {
			options.grid.update(row);
		}
	};

	//-----------------------------------------//
	//추가폼 다이얼로그 오픈
	this.append = function() {
		this.open(tit.TITLE0037);
		if (options.grid) {
			options.grid.clear();
		}
	};
	//-----------------------------------------//
	//다이얼로그 저장처리
	this.save = function(args) {



		var g = options.grid;
		var p = this;

		if (!g)
			return;

		g.save(function(res) {
			p.close();
			g.result(res);
			if (args &&
				args.callback)
				args.callback();
		});
	};
	//-----------------------------------------//

	return object;
};



//===========================================================================//
//트리그리드 검색 및 폼패널 CRUD 처리
//===========================================================================//
jeasytree = function (args) {

	var control = this;

	//컨트롤 사용항목
	var options = {
		title:    false, //화면제목
		gridKey:  "#search-grid",
		sformKey: "#search-form",
		spanPrefix: 'r_',
		grid:  false, //그리드 객체
		form:  false, //등록폼 객체
		sform: false, //검색폼 객체
		gridOptions: {
			url: null,
			title: null,
			iconCls:'icon-search',
			rownumbers: true,
			pagination: true,
			fitColumn: true,
			showHeader: true,
			showFooter: true,
			multiSort: true,
			lines: true,
			onBeforeLoad: function(param) {
			}
		},
		url: {
			search: false, //검색처리 URL
			excel:  false, //엑셀다운 URL
			select: false, //상세조회 URL
			remove: false, //삭제처리 URL
			save:   false  //저장처리 URL
		},
		fn: {
			//저장,삭제 후 결과처리 함수
			result: false
		}
	};

	if (args)
		$.extend(true, options, args);

	options.grid  = $(options.gridKey);
	options.form  = $(options.formKey);
	options.sform = $(options.sformKey);

	this.grid  = options.grid;
	this.form  = options.form;
	this.sform = options.sform;

	//-----------------------------------------//
	//그리드 생성
	this.init = function(gridOptions) {

		// BBUG.ADD : striped: true  - for grid odd/even Color
		$.extend(options.gridOptions, {
			title: options.title + ' 검색',
			url: options.url.search, striped: true
		});
		if (gridOptions)
			$.extend(options.gridOptions, gridOptions);

		options.grid.treegrid(options.gridOptions);
	};

	//그리드 옵션이 있을 경우 그리드 생성
	if (args.gridOptions) {
		control.init(args.gridOptions);
	}

	//그리드 검색폼 데이터 반환
	this.getSearchData = function() {
		var f = options.sform;
		return f.serializeObject();
	};

	//-----------------------------------------//
	//그리드 검색폼 검색
	this.search = function() {
		var data = this.getSearchData();
		options.grid.treegrid('load',data);
	};

	//-----------------------------------------//
	//그리드 엑셀다운로드
	this.download = function() {
		jlogic.excel({
			url: options.url.excel,
			form: options.sform
		});
	};

	//-----------------------------------------//
	//그리드 전체펼치기
	this.expandAll = function() {
		options.grid.treegrid('expandAll');
	};

	//-----------------------------------------//
	//그리드 전체접기
	this.collapseAll = function() {
		options.grid.treegrid('collapseAll');
	};

	//-----------------------------------------//
	//그리드 상세조회
	this.select = function(index, row) {
		control.clear();

		var f   = options.form;
		var url = options.url.select;
		var pre = options.spanPrefix;

		jlogic.select({
			url: url,
			data: row,
			success: function(data) {

	        	if (!data ||
	        		!data.rows) {
	        		$.messager.alert(msg.MSG0121,msg.MSG0031,msg.MSG0121);
	        		return;
	        	}

	        	//폼데이터 로드
	        	f.form('load', data.rows);
	        	//레이어에 데이터 로드
	        	jcommon.toHtml(data.rows, pre);

	        	//수정상태 정의
	        	jstatus.update(f);
			}
		});
	};

	//-----------------------------------------//
	//그리드 리로드
	this.reload = function() {
		options.grid.treegrid('reload');
		options.grid.treegrid('clearSelections');
	};

	//-----------------------------------------//
	//그리드 검색폼 초기화
	this.reset = function() {
		options.sform.form('clear');
	};

	return control;
};

jcombobox = function(args) {

	var objects   = this;

	var config = {
		combo:   'combobox',
		type:     1,
		params:   {},
		data:     [],
		autoload: false,
		options:  {}
	};

	if (args)
		$.extend(true, config, args);

	this.editor = function() {
		var ret = {
			type:    config.combo,
			options: config.options
		};
		ret.options['data'] = config.data;

		return ret;
	};
	this.formatter = function() {
		var p = this;
		return function(value) {
			return p.getItem(value);
		};
	};

	this.getData = function() {
		return config.data;
	},
	this.getItem = function(id) {

		var d  = config.data;
		var vf = config.options.valueField || 'value';
		var tf = config.options.textField  || 'text';

		for (var i=0; i<d.length; i++) {
			if (d[i][vf] == id) {
				return d[i][tf];
			}
		}
		return '';
	};
	this.load = function( params ) {

		if (config == false)
			return;

		if (params)
			config.params = params;

		config.data = jcombo.load(
			config.params,
			config.type
		);
	};
	
	if (config.autoload)
		this.load();

	return objects;
};

$.extend($.fn.datagrid.defaults.editors, {

	/**
	 * -------------------------------------------------------------------
	 * 4. [2017.04.25] 그리드 동적 콤보
	 * -------------------------------------------------------------------
	 *    그리드 콤보 필드의 값 변경시 해당되는 로우의 다른 콤보의 값을 변경하는 형태 (ajax 방식)
	 *    2단계 콤보박스를 사용해 1단계 콤보선택시 2단계 콤보의 옵션값이 로딩되는 형태로 구성
	 *    콤보박스의 에디터 타입을 'uxcombobox'로 명시
	 *
	 *    콤보박스 추가옵션설명
	 *        baseParams:  옵션값조회시 기본조건이 될 값을 객체로 정의
	 *        childField:  해당콤보의 값을 조건으로 해야할 하위콤보의 필드명을 정의
	 *        parentField: 해당콤보의 기준값이 되는 상위콤보의 필드명을 정의
	 *        parentKey:   상위콤보의 선택값을 조건으로 맵핑시 사용할 파라메터 키를 정의
	 *
	 *    1) 1단계 콤보박스의 필드옵션
	 *        <th data-options="
	 *        		field:'codeCmb1',
	 *        		width:100,
	 *        		halign:'center',
	 *        		formatter: doFormatCode1,
	 *        		editor:{
	 *        			type:'uxcombobox',
	 *        			options:{
	 *        				baseParams:{
	 *        					sysId:'WSC',
	 *        					codeGrup:'DEPT_CODE',
	 *        					extChr01:'D00000'
	 *        				},
	 *        				childField:'codeCmb2'
	 *        			}
	 *        		}
	 *        ">1차콤보</th>
	 *
	 *    2) 2단계 콤보박스의 필드옵션
	 *        <th data-options="
	 *        		field:'codeCmb2',
	 *        		width:100,
	 *        		halign:'center',
	 *        		formatter: doFormatCode2,
	 *        		editor:{
	 *        			type:'uxcombobox',
	 *        			options:{
	 *        				baseParams:{
	 *        					sysId:'WSC',
	 *        					codeGrup:'DEPT_CODE'
	 *        				},
	 *        				parentKey:'extChr01',
	 *        				parentField:'codeCmb1'
	 *        			}
	 *        		}
	 *        ">1차콤보</th>
	 *
	 * -----------------------------------------------------------------------
	 */
    uxcombobox: {
        init: function(container, options){
        	// 콤보박스객체
            var input = $('<input type="text"/>').appendTo(container);
            // 그리드객체
            var grid  = consts.easygrid.grid;
            // 선택행 INDEX
            var index = parseInt($(container).closest('tr.datagrid-row').attr('datagrid-row-index'));
            // 콤보박스옵션
            var opts = $.extend({
            	// 데이터 로딩타입
            	mode: 'remote',
            	// 로딩 URL
            	url: getUrl('/common/code/code.json'),
            	// VALUE KEY
            	valueField: 'codeCd',
            	// TEXT KEY
            	textField: 'codeName',
            	// 로딩된 데이터의 필터
            	loadFilter: function(data) {
            		return data['rows'];
            	},
            	// 사용자 파라메터 정의
           		onBeforeLoad: function(param){

		            // 콤보의 기본조건 정의
           			if (options.baseParams)
           				$.extend(param, options.baseParams);

           			// 하위콤보인 경우 상위콤보값에 의한 조건정의
           			if (options.parentField &&
           				options.parentKey) {
			        	// 상위콤보값의 조건 KEY
			        	var pkey = options.parentKey;
           				// 상위콤보 에디터
		            	var pbox = grid.datagrid('getEditor', {index:index, field: options.parentField});
		            	// 상위콤보의 선택값을 조건으로 정의
           				param[pkey] = $(pbox.target).combobox('getValue');
           			}
           		},
           		// 선택변경시 하위콤보값 데이터 리로드
           		onChange: function(newValue,oldValue) {
           			// 상위콤보인 경우 하위콤보의 데이터 리로드

		            if (options.childField) {
		            	// 하위콤보 에디터
		            	var cbox = grid.datagrid('getEditor', {index:index, field: options.childField});
		            	// 하위콤보의 선택값 초기화
           				$(cbox.target).combobox('setValue','');
           				// 하위콤보의 옵션데이터 리로드
           				$(cbox.target).combobox('reload');
		            }

		            if(options.codeField){
		            	var nbox = grid.datagrid('getEditor', {index:index, field: options.name});
		            	var cbox = grid.datagrid('getEditor', {index:index, field: options.codeField});
		            	var codeVal = $(nbox.target).combobox('getValue');
		            	var codeVal2 = $(cbox.target).textbox('getValue');

		            	if((codeVal != '' && oldValue != '') || codeVal2 == ''){
		            		$(cbox.target).textbox('setValue',codeVal);
		            	}

		            	if(newValue == ''){
		            		$(cbox.target).textbox('setValue', '');
		            	}

		            }

           		}
           }, options);

           return input.combobox(opts);
       },
       destroy: function(target){
           $(target).combobox('destroy');
       },
       getValue: function(target){
           return $(target).combobox('getValue');
       },
       setValue: function(target, value){
           $(target).combobox('setValue', value);
       },
       resize: function(target, width){
            $(target).combobox('resize', width);
       }
    },

	/**
	 * -------------------------------------------------------------------
	 * 1. [2017.04.18] 그리드팝업필드
	 * -------------------------------------------------------------------
	 *    그리드 필드내에 팝업 버튼을 두어 클릭시 팝업을 호출하고
	 *    값을 호출한 그리드 필드로 리턴 받는 형태의 기능
	 *    적용방법: 화면의 필드옵션값에 "editor:'popupbox'" 명시
	 *             options.valueField
	 *                 임의정의한 옵션으로 선택한 항목의 텍스트와 값이 다 필요한 경우를 위해 정의함.
	 *                 즉, 실제 팝업필드에는 TEXT가 보여지며 valueField 에 해당하는 필드에는 VALUE가 정의된다.
	 *                 만약, VALUE를 숨기고 싶을 경우엔 해당 칼럼옵션에 hidden:true 로 설정후 사용하도록 한다.
	 *                 만약 값만 정의하는 형태가 필요한 경우엔 valueField 옵션을 제외하도록 한다.
	 *             options.onOpen(data)
	 *                 임의정의한 옵션으로 팝업을 오픈하는 callback 함수를 정의한다.
	 *                 doOpenPopup 함수를 이용해 팝업객체를 생성 및 오픈한다.
	 *                 doOpenPopup 함수를 호출할때 선택된 값 셋팅용 callback 함수를 호출한다.
	 * -----------------------------------------------------------------------
	 */
	popupbox: {
	    init: function(container, options){
	        var input    = $('<input type="text"/>').appendTo(container);
	        var tr       = $(container).closest('tr.datagrid-row');
	        var rowIndex = parseInt(tr.attr('datagrid-row-index'));
	        var valueBox = false;
	        if (options.valueField) {
	        	valueBox = consts.easygrid.grid.datagrid('getEditor', {index:rowIndex, field: options.valueField});
	        }
	        var opts = $.extend({
	        	// 편집불가처리
	        	editable: false,
	        	// 팝업아이콘 정의
				icons: [{
					iconCls:'icon-search',
					// 아이콘 클릭시 핸들러 정의
					handler: function(e) {
						// 팝업오픈
						options.onOpen(function(data) {
							// 선택값 필드가 존재하는 경우
							if (valueBox) {
								// 선택값입력박스에 선택항목의 VALUE 셋팅
								$(valueBox.target).textbox('setValue', data.value);
								// 팝업입력박스에 선택항목의 TEXT 셋팅
								$(e.data.target).textbox('setValue', data.text);
							}
							else {
								// 팝업입력박스에 선택항목의 VALUE 셋팅
								$(e.data.target).textbox('setValue', data.value);
							}
						});
					}
				}]
	       }, options);
	       return input.textbox(opts);
	   },
	   destroy: function(target){
	       $(target).textbox('destroy');
	   },
	   getValue: function(target){
	       return $(target).textbox('getValue');
	   },
	   setValue: function(target, value){
	       $(target).textbox('setValue', value);
	   },
	   resize: function(target, width){
	        $(target).textbox('resize', width);
	   }
	}
});


