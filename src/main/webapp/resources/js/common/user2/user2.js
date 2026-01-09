/**
 * 사용자관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 팝업 상세조회
 * 폼 팝업 등록,수정,삭제
 */

var jcomboBm  = {};
jcomboBm.load = function(args, flg) {
	var flag   = (flg ? flg : 1);
	var items  = [];
	var params = {};

	/*if (typeof args == 'string') {
		params.codeGrup = args;
	}
	else {
		params = args;
	}
*/
    $.ajax({
        url: getUrl('/common/user2/user2/selectUserBm.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: params,
        success: function(data){

        	if (!data)
        		return;
        	if (!data.rows)
        		return;

            items = $.map(data.rows, function(item) {

            	if (flag == 9)
            		return item;

            	var obj = {value:'', text:''};

            	switch(flag) {
            		case 1: obj = {value: item.codeCd,   text: item.codeName}; break;
            		/*case 2: obj = {value: item.codeCd,   text: item.codeName+ '['+item.codeCd+']'};   break;
            		case 3: obj = {value: item.codeCd,   text: item.codeCd};   break;
            		case 4: obj = {value: item.codeName, text: item.codeName}; break;*/
            	}
            	return obj;
            });
        },
        error: function(){
        }
    });
    return items;
};

jcomboboxBm = function(args) {

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

		config.data = jcomboBm.load(
			config.params,
			config.type
		);
	};

	if (config.autoload)
		this.load();

	return objects;
};

var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	admin:    gconsts.ADMIN,     //관리자  (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	domain:   false,   //사용자로그인용 도메인
	easygrid: false,   //기본컨트롤
	dialog:   false,   //팝업다이얼로그 컨트롤
/*	cellEdit: true,
	viewrecords: true,
	forceFit : true,*/
	url: {
		search: getUrl("/common/user2/user2/search.json"),
		excel:  getUrl("/common/user2/user2/download2.do"),
		remove: getUrl("/common/user2/user2/delete.json"),
		save:   getUrl("/common/user2/user2/save.json"),
		secure: getUrl("/common/user2/user2/secure.json"),
		login:  getUrl("/security_check.do")
	},

	combo: {
		spcAuthCode: new jcombobox({params:{codeGrup: 'SP_AUTH'}}),
		incomeDept: new jcombobox({params:{codeGrup: 'DEPT_CODE'}}),
		menuType: new jcombobox({params:{codeGrup: 'MENU_GB'}}),
		dashType: new jcombobox({params:{codeGrup: 'DASH_TYPE'}}),
		mobileType: new jcombobox({params:{codeGrup: 'MOBILE_TYPE'}}),
		userType: new jcombobox({params:{codeGrup: 'USER_TYPE'}}),
		saleGrup: new jcombobox({params:{codeGrup: 'SALE_GRUP'}}),
		shipLoc: new jcombobox({params:{codeGrup: 'SHIP_LOC'}}),
		orgAuthCode: new jcombobox({params:{codeGrup: 'ORG_AUTH'}}),
		regnGb: new jcombobox({params:{codeGrup: 'REGN_GB'}}),
		userBm: new jcomboboxBm({params:{'': ''}})
	},


/*	combo: {
		userType : new jcomboboxBm({params:{'': ''}}),
		spcAuthCode: new jcomboboxBm({
			params : {
				codeGrup : 'PRICE_AUTH'
			}
		})
	},*/
	init: function() {
		this.combo.menuType.load();
		this.combo.dashType.load();
		this.combo.mobileType.load();
		this.combo.userType.load();
		this.combo.spcAuthCode.load();
		this.combo.incomeDept.load();
		this.combo.saleGrup.load();
		this.combo.shipLoc.load();
		this.combo.orgAuthCode.load();
		this.combo.regnGb.load();
		this.combo.userBm.load();

		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search: null,
				excel:  getUrl("/common/user2/user2/download2.do"),
				remove: getUrl("/common/user2/user2/delete.json"),
				save:   getUrl("/common/user2/user2/save.json"),
				secure: getUrl("/common/user2/user2/secure.json"),
				login:  getUrl("/security_check.do")
			},
			//title:    this.title, //20160921 김원국
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'userId',
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			singleSelect: true,
			fitColumns:false,
			//striped: true,
			checkOnSelect: true,//TODO 김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
			onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			//onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
			//onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
			//onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
			//onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트
			//onSelect: doSelectRow, //2016/09/19 김영진 수정 --행 클릭 이벤트
			onDblClickRow: doDblClickRow, //그리드 더블클릭시 이벤트 바인딩
			//onClickCell:   doClickButton,  //그리드 셀클릭시 이벤트 바인딩
			onLoadSuccess:function(){
				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('uncheckAll');
				$("#search-grid").datagrid('clearChecked');
				doLangSettingTable();
			}
		});
		
		$("#r_userId").textbox({
			onChange:function(newValue,oldValue){
				$("#r_idLspo").textbox("setValue",newValue);
        		$("#r_idLws").textbox("setValue","ls"+newValue);
        		$("#r_idMts").textbox("setValue","lsta"+newValue);
        		$("#r_idAcb").textbox("setValue",newValue);
			}
		});
		
		//Responsible BM을 선택할시  Sales Group과 Shipping W/H에 값 추가
        $("#r_respBm").combobox({
			onChange:function(newValue,oldValue){
              var deal_id = newValue;
                 if(deal_id != ''){ 
                    $.ajax({
                      url: getUrl('/common/user2/user2/selectAuto.json'),
                      dataType: 'json',
                      async: false,
                      type: 'post',
                      data: {deal_id:deal_id},
                      success: function(data){
                		  $("#r_saleGrup").combobox("setValue",data.rows[0].SALE_GRUP);
                		  $("#r_wareHous").combobox("setValue",data.rows[0].SHIP_LOC);
                		  
                      },
                      error: function(){
                      }
                    });
                 }
			 } 
        });
		//등록폼 초기화
		doClear();
	}
};

//매출 등록 그리드 단가 팝업
var menu_popup = {
	sysId : gconsts.SYS_ID, //시스템ID (common.jsp)
	title : gconsts.TITLE, //화면제목 (common.jsp)
	pageSize : gconsts.PAGE_SIZE, //출력수  (common.jsp)
	easygrid : false, //기본컨트롤
	url : {
		search : getUrl("/common/user2/user2/searchType.json"),
	},
	init : function() {
		
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url : this.url,
			url: {search: null},
			gridKey : "#search-menu-grid",
			sformKey : "#search-menu-form",
		});

		//그리드 생성
		this.easygrid.init({
			fit : true,
			pagination : false,
			pageSize : this.pageSize,
			toolbar : "#search-menu-toolbar",
			//idField : 'detailCode',
			onResize : doResize_Single,
			selectOnCheck:true,
			checkOnSelect: false,//김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
			/*onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
			onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
			onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
			onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트*/
			//onClickRow:   this.easygrid.clickRowEdit,
			//onBeforeEdit: this.easygrid.beforeEdit,
			//onAfterEdit : this.easygrid.afterEdit,
			onLoadSuccess : function(data) {
				console.log(data);
				//오픈시 스크롤 내림 차단
				$("#search-menu-dialog").dialog('open');
				//Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item) {
					var itemid = $("#" + item.id);
					itemid.textbox('textbox').bind('keyup', function(e) {
						itemid.textbox('setValue', $(this).val());
					});
				});
				
				
//				var selectedRow = $('#search-grid').datagrid('getSelected');
//				var menuType = $("#testmenuType").val(selectedRow.spcAuthCode);
//				var test = menuType[0].value
//				for (var i = 0; i < data.rows.length; i++) {
//					
//				$(":checkbox[name=ck]").each(function(index, item) {
//				    var trMenuType = $(item).closest("tr").find("[field=menuType]").text();
//				    
//				    
//				    if (test.indexOf(trMenuType) > -1) {
//				        $(item).prop("checked", true);
//				    }else{
//				    	 $(item).prop("checked", false);
//				    }
//				});
//			}
//				for (var i = 0; i < data.rows.length; i++) {
//				    var menuType = data.rows[i].menuType;
//				    $(":checkbox[name=ck]").each(function(index, item) {
//				        var trMenuType = $(item).closest("tr").find("[field=menuType]").text();
//				        if (menuType.indexOf(trMenuType) !== -1) {
//				            $(item).prop("checked", true);
//				        } else {
//				            $(item).prop("checked", false);
//				        }
//				    });
//				}
				
				
		  }
		});
	}
};

//매출 등록 그리드 단가 팝업
var menu_appl_list_popup = {
	sysId : gconsts.SYS_ID, //시스템ID (common.jsp)
	title : gconsts.TITLE, //화면제목 (common.jsp)
	pageSize : gconsts.PAGE_SIZE, //출력수  (common.jsp)
	easygrid : false, //기본컨트롤
	url : {
		search : getUrl("/common/user2/user2/searchApplList.json"),
	},
	init : function() {
		
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url : this.url,
			url: {search: null},
			gridKey : "#search-menu-appl-list-grid",
			sformKey : "#search-menu-appl-list-form",
		});

		//그리드 생성
		this.easygrid.init({
			fit : true,
			pagination : false,
			pageSize : this.pageSize,
			toolbar : "#search-menu-appl-list-toolbar",
			//idField : 'detailCode',
			onResize : doResize_Single,
			selectOnCheck:true,
			checkOnSelect: false,//김원국 수정 true일떄는 로우 클릭시에도 체크박스 체크 false일떄는 무조건 체크 박스 체크시에만 작동
			/*onCheck: doCheckRow, //2016/09/19 김영진 수정 --체크박스 클릭 이벤트
			onCheckAll: doCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 선택 이벤트
			onUncheck: doUnCheckRow, //2016/09/19 김영진 수정 --체크박스 해제 이벤트
			onUncheckAll: doUnCheckAll, //2016/09/19 김영진 수정 --체크박스 전체 해제 이벤트*/
			//onClickRow:   this.easygrid.clickRowEdit,
			//onBeforeEdit: this.easygrid.beforeEdit,
			//onAfterEdit : this.easygrid.afterEdit,
			onLoadSuccess : function(data) {
				console.log(data);
				//오픈시 스크롤 내림 차단
//				$("#search-menu-appl-list-dialog").dialog('open');
				//Enter 검색을 위한 추가
				var selectedRow = $('#search-grid').datagrid('getSelected');
				var applListValue = selectedRow.applList;
				if (applListValue) {
			       var applListToCheck = applListValue.split(',');
			       var gridData = $("#search-menu-appl-list-grid").datagrid('getRows');
			        for (var i = 0; i < gridData.length; i++) {
			            if (applListToCheck.includes(gridData[i]['EXT_CHR10'])) {
			                $("#search-menu-appl-list-grid").datagrid('checkRow', i);
			            }
			        }
				 }
				
				$(".easyui-textbox").each(function(index, item) {
					var itemid = $("#" + item.id);
					itemid.textbox('textbox').bind('keyup', function(e) {
						itemid.textbox('setValue', $(this).val());
					});
				});
		  }
		});
	}
};

$(function() {

	consts.init();
	menu_popup.init();
	menu_appl_list_popup.init();

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
	    //title: tit.TITLE0029,//샘플게시판 등록
		title: tit.TITLE0028,
	    iconCls: 'icon-search',
	    top:    10,
	    width: 810,
	    height: 1000,
	    closed: true,
	    modal: true,
	    resizable: true
	});
	
	
//	$('#search-menu-dialog').dialog({
//	    //title: tit.TITLE0029,//샘플게시판 등록
//		title: 'Dealer Information',
//	    iconCls: 'icon-search',
//	    top:    10,
//	    width: 810,
//	    height: 870,
//	    closed: true,
//	    modal: true,
//	    resizable: true
//	});	

});

$(window).load(function() {
	
	setTimeout(function (){
		
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keydown',function(events){
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
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		//추가버튼(팝업) 클릭시 이벤트 바인딩
		$("#dealAppend-button").bind("click", doDealAppend);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button").bind("click", doReload);

		//userId-list-button 이벤트 바인딩
		$("#userId-list-button").bind("click", multiListPop.openPoListPop);
		$("#poList-button1").bind("click", multiListPop.saveListPop);
		$("#poList-button2").bind("click", multiListPop.deletePoListPop);
		$("#poList-button3").bind("click", multiListPop.closePoListPop);

		
		//딜러등록 저장
		$("#save-create-button").bind('click',doSaveCreate);
		//딜러등록 닫기버튼 클릭시 이벤트바인딩
		$("#close-create-button").bind("click", doCloseCreat);

		//Enter 검색을 위한 추가
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keyup', function(e){
				itemid.textbox('setValue', $(this).val());
			});
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

	}, 100);

	doLangSettingTable();

});

//화면 상수값 초기화
function doInit(args) {
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('uncheckAll');
	$('#hdfIndex').val("-1");
	$('#hdfChk').val("");
	if (args) {
		$.extend(consts, args);
	}
}

//검색 처리
function doSearch() {
	//consts.easygrid.search();

	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.search(consts.url.search);

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
function doClear() {
	consts.easygrid.clear();
}
//삭제 처리
function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.removeEdit();
}
//저장 처리
function doSave() {
	if(doubleSubmitCheck()){
		if($('#'+this.id).hasClass('l-btn-disabled')){
		      return false;
		   }	
	//20230배정현 전화번호 - 처리 수정
	//선택한 테이블 행 가져오는 기능
	var selectedRow = $('#search-grid').datagrid('getSelected'); 
	var rowIndex = selectedRow ? $('#search-grid').datagrid('getRowIndex', selectedRow) : -1;
	
	if(rowIndex >= 0){
		//rowIndex행의 편집을 종료
		$('#search-grid').datagrid('endEdit', rowIndex);
		
		//rowIndex행의 값들을 updatedRow에 담는 기능
		var rows = $('#search-grid').datagrid('getRows') || [];
		var updatedRow = rows[rowIndex];
		
		if(updatedRow){
			var telNo = updatedRow.userTel;
			var email = updatedRow.userMail;
			console.log("TelNo= " + telNo);
			console.log("Email= " + email);
			$('#search-grid').datagrid('beginEdit', rowIndex);
				
			if(telNo != "" && telNo != undefined){
				if(!Utils.isStick(telNo)){
					$.messager.alert(msg.MSG0121,msg.MSG0049,msg.MSG0121);
					return true;
				}
			}
			
			if(email != "" && email != undefined){
				if(!Utils.isEmail(email)){
					$.messager.alert(msg.MSG0121,msg.MSG0043,msg.MSG0121);
					return true;
				}
			}
		}else{
			$('#search-grid').datagrid('beginEdit', rowIndex);
		}
	}
	
	
		consts.easygrid.saveEditCustom();
	}

}
//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	consts.easygrid.appendEdit();

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


//등록 그리드 단가 팝업
function doOpenPopup( callback ) {
	var selectedRow = $('#search-grid').datagrid('getSelected');
	$("#smenuType").val(selectedRow.spcAuthCode);

	menu_popup.easygrid.search(menu_popup.url.search);

	var elm = $("#search-menu-dialog");

	// HTML 상에 해당 DOM 객체가 없을경우 경고메세지 처리
	if (elm.length == 0) {
       $.messager.alert(msg.MSG0121,msg.MSG0116,msg.MSG0121);
       return false;
	}

	// 팝업을 오픈한다.
	elm.dialog({
	    title: 'Spc Auth',
	    width:  300,
	    height: 400,
	    closed: false,
	    cache:  true,
	    modal:  true,
	    buttons:[{
	    	text:'Ok',
			handler:function() {
				// 팝업내 선택그리드 가져오기
				
				var selectGrid = $("#search-menu-grid").datagrid('getChecked');
//		        var selectedRow = $('#search-grid').datagrid('getSelected');
//		        var menuType = $("#testmenuType").val(selectedRow.spcAuthCode)
		        
				var selVal = [];

		        
				for(var j = 0; j < selectGrid.length; j++){
					selVal.push(selectGrid[j]['menuType']);
					
					//debugger;
				}
				// 선택값셋팅 콜백함수 호출
				callback({
					value: selVal
//					spcAuthCode: selectedRow.spcAuthCode 
				});

				// 팝업닫기
				elm.dialog('close');
				return true;
			}
		},{
			text:'Cancel',
			handler:function(){
				// 팝업닫기
				elm.dialog('close');
			}
		}]
	});
};

//등록 그리드 단가 팝업
function doOpenListPopup( callback ) {
	var selectedRow = $('#search-grid').datagrid('getSelected');
	$("#smenuType").val(selectedRow.spcAuthCode);

	menu_appl_list_popup.easygrid.search(menu_appl_list_popup.url.search);

	var elm = $("#search-menu-appl-list-dialog");

	// HTML 상에 해당 DOM 객체가 없을경우 경고메세지 처리
	if (elm.length == 0) {
       $.messager.alert(msg.MSG0121,msg.MSG0116,msg.MSG0121);
       return false;
	}

	// 팝업을 오픈한다.
	elm.dialog({
	    title: 'Application List',
	    width:  400,
	    height: 400,
	    closed: false,
	    cache:  true,
	    modal:  true,
	    buttons:[{
	    	text:'Ok',
			handler:function() {
				// 팝업내 선택그리드 가져오기
				
				var selectGrid = $("#search-menu-appl-list-grid").datagrid('getChecked');
//		        var selectedRow = $('#search-grid').datagrid('getSelected');
//		        var menuType = $("#testmenuType").val(selectedRow.spcAuthCode)
		        
				var selVal = [];

		        
				for(var j = 0; j < selectGrid.length; j++){
					selVal.push(selectGrid[j]['EXT_CHR10']);
					
					//debugger;
				}
				// 선택값셋팅 콜백함수 호출
				callback({
					value: selVal
//					spcAuthCode: selectedRow.spcAuthCode 
				});

				// 팝업닫기
				elm.dialog('close');
				return true;
			}
		},{
			text:'Cancel',
			handler:function(){
				// 팝업닫기
				elm.dialog('close');
			}
		}]
	});
};



//추가 처리
function doDealAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	doCloseCreat();
	$("#r_oper").val("I");
	$("#r_userId").textbox({readonly:false});
	// $("#regist-dialog").dialog('center');  // center 호출 제거
	$("#regist-dialog").dialog('open');
}

//초기화
function doReload(){

	$("#s_userType").combobox('setValue','');
	$("#s_useFlag").combobox('setValue','ALL');
	$("#s_userId").textbox('setValue','');
	$("#s_userName").textbox('setValue','');
	$("#s_poNo").val('');
	$('#h_userIdList').val('');
	$('#userId-list-button').css('background-color', 'white');

}

//[자동로그인] 그리드의 로그인버튼 클릭시 이벤트 처리
function doClickButton(index, field, value) {

	if (consts.admin == 'N')
		return;

	if (field != 'userLogin')
		return;

	var rows = $(this).datagrid('getRows');
	var row  = rows[index];
	var msg  = '[아이디   :'
		     + '<font color="green"><b>'  + row.userId   + '</b></font>,'
	         + ' 사용자명 :'
	         + '<font color="orange"><b>' + row.userName + '</b></font>]'
	         + ' 로 자동 로그인하시겠습니까?';
	var win  = 'userwin';

	$.messager.confirm(msg.MSG0123, msg, function(r) {

		if (!r)
			return;

		//새탭열기
		window.open('', win);

		var f = $("#login-form");
		f.form('clear');

		//보안키 생성 및 결과가져오기
		jlogic.select({
			url: consts.url.secure,
			data: {userId: row.userId},
			success: function(res) {
				//새탭으로 로그인 처리
				doAutoLogin(f, win, res.rows);
			}
		});

	});
}

//[자동로그인] 새탭에서 자동로그인 실행
function doAutoLogin(f, tabwin, data) {
	$("#j_system").val (data.sysId);
	$("#j_userid").val (data.userId);
	$("#j_secure").val (data.secureKey);

	var url = "http://"
		    + consts.domain
		    + consts.url.login;

	f.attr('target', tabwin);
	f.attr('action', url);
	f.submit();
}

//사용자유형값 포맷처리 (코드대신 명칭표시)
jformat.userType = function(val, row) {
	//사용자 유형칼럼의 콤보텍스트 표시
	if (jutils.empty(row.userTypeDesc))
		return val;
	return row.userTypeDesc;
};

//Country
function doCntyChange(newValue,oldValue){
	$.ajax({
        url: getUrl('/common/user2/user2/selectCodeName.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {codeGrup:'CNTY_CODE',
        	   codeCd  :newValue},
        success: function(data){
        	if(data.rows.length > 0) {
        		$("#r_addrCnty2").textbox("setValue",data.rows[0].codeNm);
        	}
        	else $("#r_addrCnty2").textbox("setValue","");
        },
        error: function(){
        }
    });
}

//Region
function doAreaChange(newValue,oldValue){
	$.ajax({
        url: getUrl('/common/user2/user2/selectCodeName.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {codeGrup:'AREA_CODE',
        	   codeCd  :newValue},
        success: function(data){
        	if(data.rows.length > 0) {
        		$("#r_addrRegn2").textbox("setValue",data.rows[0].codeNm);
        	}
        	else $("#r_addrRegn2").textbox("setValue","");
        },
        error: function(){
        }
    });
}

//Transportation zone
function doTransChange(newValue,oldValue){
	$.ajax({
        url: getUrl('/common/user2/user2/selectCodeName.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {codeGrup:'TRANS_ZONE',
        	   codeCd  :newValue},
        success: function(data){
        	if(data.rows.length > 0) {
        		$("#r_transZone2").textbox("setValue",data.rows[0].codeNm);
        	}
        	else $("#r_transZone2").textbox("setValue","");
        },
        error: function(){
        }
    });
}

//Terms of payment
function doPaymChange(newValue,oldValue){
	$.ajax({
        url: getUrl('/common/user2/user2/selectCodeName.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {codeGrup:'PAYM_METH',
        	   codeCd  :newValue},
        success: function(data){
        	if(data.rows.length > 0) {
        		$("#r_payType2").textbox("setValue",data.rows[0].codeNm);
        	}
        	else $("#r_payType2").textbox("setValue","");
        },
        error: function(){
        }
    });
}

function doSaveCreate() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}

	if($("#r_userId").textbox("getValue") == ""){
		$.messager.alert(msg.MSG0121,msg.MSG0120,msg.MSG0121);
		return;
	}
	if($("#r_userName").textbox("getValue") == ""){
		$.messager.alert(msg.MSG0121,msg.MSG0045,msg.MSG0121);
		return;
	}
	if($("#r_respBm").combobox("getValue") == ""){
		$.messager.alert(msg.MSG0121,msg.MSG0046,msg.MSG0121);
		return;
	}
	if($("#r_wareHous").combobox("getValue") == ""){
		$.messager.alert(msg.MSG0121,msg.MSG0047,msg.MSG0121);
		return;
	}
	/*if($("#r_shipLoc").combobox("getValue") == ""){
		$.messager.alert(msg.MSG0121,msg.MSG0123,msg.MSG0121);
		return;
	}*/
	if($("#r_email").textbox("getValue") == ""){
		$.messager.alert(msg.MSG0121,msg.MSG0111,msg.MSG0121);
		return;
	}
	
	//유효성 검사
	if( (!Utils.isNull($("#r_telNo").textbox("getValue"))) && (isNumCheck2($("#r_telNo").textbox("getValue")) == false) ){
		$.messager.alert(msg.MSG0121,msg.MSG0049,msg.MSG0121);
		return;
	}
	if( (!Utils.isNull($("#r_telNo").textbox("getValue"))) && (isNumCheck3($("#r_telNo").textbox("getValue")) == false) ){
		$.messager.alert(msg.MSG0121,msg.MSG0049,msg.MSG0121);
		return;
	}
	if( (!Utils.isNull($("#r_moNo").textbox("getValue"))) && (isNumCheck2($("#r_moNo").textbox("getValue")) == false) ){
		$.messager.alert(msg.MSG0121,msg.MSG0050,msg.MSG0121);
		return;
	}
	if( (!Utils.isNull($("#r_moNo").textbox("getValue"))) && (isNumCheck3($("#r_moNo").textbox("getValue")) == false) ){
		$.messager.alert(msg.MSG0121,msg.MSG0050,msg.MSG0121);
		return;
	}
	if( !Utils.isNull($("#r_faxNo").textbox("getValue")) && (isNumCheck2($("#r_faxNo").textbox("getValue")) == false ) ){
		$.messager.alert(msg.MSG0121,msg.MSG0051,msg.MSG0121);
		return;
	}
	if( (!Utils.isNull($("#r_faxNo").textbox("getValue"))) && (isNumCheck3($("#r_faxNo").textbox("getValue"))== false)){
		$.messager.alert(msg.MSG0121,msg.MSG0051,msg.MSG0121);
		return;
	}
	if( isNumCheck4($("#r_email").textbox("getValue"))== false){
		$.messager.alert(msg.MSG0121,msg.MSG0043,msg.MSG0121);
		return;
	}
	if( (!Utils.isNull($("#r_emailList").textbox("getValue"))) && (isNumCheck4($("#r_emailList").textbox("getValue"))== false)){
		$.messager.alert(msg.MSG0121,msg.MSG0052,msg.MSG0121);
		return;
	}
	
	var data = $("#search-create-form").serializeObject();
	$.ajax({
		url: getUrl('/common/user2/user2/saveDealer.json'),
		dataType: 'json',
		async: false,
		type: 'post',
		data: data,
		success: function(data){
			$.messager.show({
				title: 'Information',
				msg: msg.MSG0103
			});
		},
		error: function(){
		}
	});

	doCloseCreat();
	doSearch();
}

//그리드 더블클릭시 이벤트 바인딩
function doDblClickRow(idx, row) {
	if (!row) return;
	$.ajax({
		url: getUrl('/common/user2/user2/selectDealerInfo.json'),
		dataType: 'json',
		async: false,
		type: 'post',
		data: {userId:row.userId},
		success: function(data){
			
			if(data.rows.length > 0) {
        		$("#r_payType2").textbox("setValue",data.rows[0].codeNm);
        		$("#r_userId").textbox("setValue",row.userId);
        		$("#r_userName").textbox("setValue",row.userName);
        		$("#r_idLspo").textbox("setValue",row.idLspo);
        		$("#r_idLws").textbox("setValue",row.idLws);
        		$("#r_idMerc").textbox("setValue",row.idMerc);
        		$("#r_idServ").textbox("setValue",row.idServ);
        		$("#r_idWgbc").textbox("setValue",row.idWgbc);
        		$("#r_respBm").combobox("setValue",data.rows[0].respBm);
        		$("#r_headDeal").combobox("setValue",data.rows[0].headDeal);
        		$("#r_wareHous").combobox("setValue",data.rows[0].wareHous);
        		//$("#r_shipLoc").combobox("setValue",data.rows[0].shipLoc);
        		$("#r_saleGrup").combobox("setValue",data.rows[0].saleGrup);
        		$("#r_addrStr").textbox("setValue",data.rows[0].addrStr);
        		$("#r_addrBox").textbox("setValue",data.rows[0].addrBox);
        		$("#r_postCode").textbox("setValue",data.rows[0].postCode);
        		$("#r_addrCity").textbox("setValue",data.rows[0].addrCity);
        		$("#r_addrCnty").combobox("setValue",data.rows[0].addrCnty);
        		$("#r_addrRegn").combobox("setValue",data.rows[0].addrRegn);
        		$("#r_transZone").combobox("setValue",data.rows[0].transZone);
        		$("#r_moNo").textbox("setValue",data.rows[0].moNo);
        		$("#r_telNo").textbox("setValue",data.rows[0].telNo);
        		$("#r_faxNo").textbox("setValue",data.rows[0].faxNo);
        		$("#r_email").textbox("setValue",data.rows[0].email);
        		$("#r_emailList").textbox("setValue",data.rows[0].emailList);
        		$("#r_emailRecv").combobox("setValue",data.rows[0].emailRecv);
        		$("#r_payType").combobox("setValue",data.rows[0].payType);
        		$("#r_currUnit").combobox("setValue",data.rows[0].currUnit);
        		
        		$("#r_oper").val("U");
        		$("#r_userId").textbox({readonly:true});
        		// $("#regist-dialog").dialog('center');  // center 호출 제거
        		$("#regist-dialog").dialog('open');
        	}
			else {
				$.messager.alert(msg.MSG0121,msg.MSG0029,msg.MSG0121);
			}
			
		},
		error: function(){
		}
	});
}

function doCloseCreat() {
	$('#regist-dialog').dialog('close');
	
	$("#r_userId").textbox("setValue","");
	$("#r_userName").textbox("setValue","");
	$("#r_respBm").combobox("setValue","");
	$("#r_headDeal").combobox("setValue","");
	$("#r_wareHous").combobox("setValue","");
	//$("#r_shipLoc").combobox("setValue","");
	$("#r_saleGrup").combobox("setValue","");
	$("#r_addrStr").textbox("setValue","");
	$("#r_addrBox").textbox("setValue","");
	$("#r_postCode").textbox("setValue","");
	$("#r_addrCity").textbox("setValue","");
	$("#r_addrCnty").combobox("setValue","");
	$("#r_addrCnty2").textbox("setValue","");
	$("#r_addrRegn").combobox("setValue","");
	$("#r_addrRegn2").textbox("setValue","");
	$("#r_transZone").combobox("setValue","");
	$("#r_transZone2").textbox("setValue","");
	$("#r_mpNo").textbox("setValue","");
	$("#r_telNo").textbox("setValue","");
	$("#r_faxNo").textbox("setValue","");
	$("#r_email").textbox("setValue","");
	$("#r_emailList").textbox("setValue","");
	$("#r_emailRecv").combobox("setValue","");
	$("#r_payType").combobox("setValue","");
	$("#r_payType2").textbox("setValue","");
	$("#r_currUnit").combobox("setValue","");
	$("#r_idLspo").textbox("setValue","");
	$("#r_idLws").textbox("setValue","");
	$("#r_idMerc").textbox("setValue","");
	$("#r_idServ").textbox("setValue","");
	$("#r_idWgbc").textbox("setValue","");
	$("#r_idMts").textbox("setValue","");
	$("#r_idAcb").textbox("setValue","");
	
}

//fax 번호 체크
function isNumCheck2(d) {
	var re = Utils.isNull(d) ? 31 : d.length;
	if(re <= 30){
		return true;	
	}else{
		return false;
	}
}

//- 들어가는지 체크
function isNumCheck3(d) {
	var re3 = /[-]/gi;
    return re3.test(d);
}
//@  들어가는지 체크
function isNumCheck4(d) {
	var re3 = /[@]/gi;
    return re3.test(d);
}

//체크박스 클릭 이벤트
function doCheckRow(rowIndex, rowData){
	var chkRow = $('#hdfChk').val();
	chkRow += "**" + rowIndex + ", ";
	$('#hdfChk').val(chkRow);
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
//체크박스 해제 이벤트
function doUnCheckRow(rowIndex, rowData){
	$("#search-menu-grid").datagrid('unselectRow', rowIndex);
	var chkRow = $('#hdfChk').val();
	chkRow = chkRow.replace("**" + rowIndex + ", ", "");
	$('#hdfChk').val(chkRow);
	$('#hdfIndex').val("-1");
}
//체크박스 전체 해제 이벤트
function doUnCheckAll(rowIndex, rowData){
	$("#search-menu-grid").datagrid('unselectAll');
	$('#hdfChk').val("");
	$('#hdfIndex').val("-1");
}