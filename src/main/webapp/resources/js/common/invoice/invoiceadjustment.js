/**
 *  제목		: [기본정보관리]-[상품관리]를 처리하는 스크립트
 *  작성자	: 김연주
 *  날짜		: 2017-04-03
 */
var consts = {
	sysId : gconsts.SYS_ID, // 시스템ID (common.jsp)
	title : gconsts.TITLE, // 화면제목 (common.jsp)
	pageSize : gconsts.PAGE_SIZE, // 출력수 (common.jsp)
	easygrid : false, // 기본컨트롤
	combo : {
		itemGrup : new jcombobox({
			params : {
				codeGrup : 'ITEM_GRUP'
			}
		}),
		seriType : new jcombobox({
			params : {
				codeGrup : 'SERI_TYPE'
			}
		})
	},
	url : {
		search : getUrl("/common/invoice/invoiceadjustment/search.json"),
		excel :  getUrl("/common/invoice/invoiceadjustment/download.do"),
		save :   getUrl("/common/invoice/invoiceadjustment/save.json"),
		remove:  getUrl("/common/invoice/invoiceadjustment/delete.json")
	},
	init : function() {
		// 콤보로딩
		this.combo.itemGrup.load();
		this.combo.seriType.load();

		// 기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url : this.url,
			url: {
				search:  null,
				excel :  getUrl("/common/invoice/invoiceadjustment/download.do"),
				save :   getUrl("/common/invoice/invoiceadjustment/save.json"),
				remove:  getUrl("/common/invoice/invoiceadjustment/delete.json")
			},

			// title: this.title, //20160921 김원국
			gridKey : "#search-grid",
			sformKey : "#search-form"
		});

		// 그리드 생성
		this.easygrid.init({
			fit : true,
			singleSelect : true,
			//pageSize : this.pageSize,
			pageSize : 1000,
			idField: 'sapCode',
			onResize : doResize_Single, 
			idField: 'ordrNo', // 각 row를 고유하게 식별할 수 있는 필드 지정
		    singleSelect: false,           // 다중 선택 가능
		    checkOnSelect: true,           // 선택하면 체크되도록
		    selectOnCheck: true,           // 체크하면 선택되도록
			toolbar:  "#search-toolbar",
			// 그리드 편집이벤트 바인딩
			/*onClickRow : this.easygrid.clickRowEdit,
			onBeginEdit : doBeginEdit, //필수
			OnBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
	 		*/
			onCheck: doCheckRow, 
			onCheckAll: doCheckAll, 
			onUncheck: doUnCheckRow, 
			onUncheckAll: doUnCheckAll, 
			onClickCell: function(index, field, value) {
				if (field == 'invNoSap') {
					$("#viewReportUrl").val($("#reportUrl").val()+"/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lsdp&reportUnit=/reports/lsdp/Invoice&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$&p_inv_no="+value);

					//id와 pw를 감추기위해 두번call
					//로그인용
					window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/dummy&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$','pdfReport2', 'toolbar=no, width=800, height=700, top=100, left=500, directories=no, status=no, scrollorbars=yes, resizable=no');
					setTimeout(function (){
						//pdf출력용 
						window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/Invoice&decorate=no&output=pdf&p_inv_no='+value,'pdfReport2', '');
					},3000);
					
				} else if (field == 'ordrNo') {
					var ORDR_NO = value;
					$("#viewReportUrl").val($("#reportUrl").val()+"/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lsdp&reportUnit=/reports/lsdp/Sales_Order_Report&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$&p_ordr_no="+ORDR_NO);
				/*	 var myForm = document.ReportViewForm;
					 var url = "http://dealerportal.lstractorusa.com/lsdp/ReportView.do";
					 window.open("" ,"ReportViewForm", 
					       "toolbar=no, width=800, height=700, top=100, left=500, directories=no, status=no, scrollorbars=yes, resizable=no"); 
					 myForm.action =url; 
					 myForm.method="post";
					 myForm.target="ReportViewForm";
					 myForm.viewReportUrl = 'test';
				     myForm.submit();*/
					
					//id와 pw를 감추기위해 두번call
					//로그인용
					window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/dummy&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$','pdfReport', 'toolbar=no, width=800, height=700, top=100, left=500, directories=no, status=no, scrollorbars=yes, resizable=no');
					setTimeout(function (){
						//pdf출력용 
						window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/Sales_Order_Report&decorate=no&output=pdf&p_ordr_no='+ORDR_NO,'pdfReport', '');
					},3000);
					
				} else if (field == 'bolNo') {
					var BOL_NO = value;
					
					$("#viewReportUrl").val($("#reportUrl").val()+"/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lsdp&reportUnit=/reports/lsdp/Bol_Print&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$&p_bol_no="+BOL_NO);
				/*	 var myForm = document.ReportViewForm;
					 var url = "http://dealerportal.lstractorusa.com/lsdp/ReportView.do";
					 window.open("" ,"ReportViewForm", 
					       "toolbar=no, width=800, height=700, top=100, left=500, directories=no, status=no, scrollorbars=yes, resizable=no"); 
					 myForm.action =url; 
					 myForm.method="post";
					 myForm.target="ReportViewForm";
					 myForm.viewReportUrl = 'test';
				    myForm.submit();*/
					
					//id와 pw를 감추기위해 두번call
					//로그인용
					window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/dummy&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$','pdfReport', 'toolbar=no, width=800, height=700, top=100, left=500, directories=no, status=no, scrollorbars=yes, resizable=no');
					setTimeout(function (){
						//pdf출력용 
						window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/Bol_Print&decorate=no&output=pdf&p_bol_no='+BOL_NO,'pdfReport', '');
					},3000);
					
				} else if (field == 'invNoWgos') {
					$("#viewReportUrl").val($("#reportUrl").val()+"/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lsdp&reportUnit=/reports/lsdp/Invoice&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$&p_inv_no="+value);

					//id와 pw를 감추기위해 두번call
					//로그인용
					window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/dummy&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$','pdfReport', 'toolbar=no, width=800, height=700, top=100, left=500, directories=no, status=no, scrollorbars=yes, resizable=no');
					setTimeout(function (){
						//pdf출력용 
						window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/Invoice&decorate=no&output=pdf&p_inv_no='+value,'pdfReport', '');
					},3000);
					
				}
			},
			//그리드 더블클릭시 이벤트 바인딩
			onDblClickRow:function(index, row) {
				if (!row) return;
			  	$.ajax({
			  		url: getUrl('/common/invoice/invoiceadjustment/selectInfo.json'),
			  		dataType: 'json',
			  		async: false,
			  		type: 'post',
			  		data: {ordrNo:row.ordrNo
			  			  ,ordrSeq:row.ordrSeq
			  			  ,ordrStat:row.ordrStat},
			  		success: function(data){
			  			if(data.rows.length > 0) {
			          		$("#r_ordrNo").textbox("setValue",data.rows[0].ordrNo);
			          		//$("#r_ordrSeq").textbox("setValue",data.rows[0].ordrSeq);
			          		//$("#r_itemType").textbox("setValue",data.rows[0].itemType);
			          		$("#r_itemCode").textbox("setValue",data.rows[0].itemCode);
			          		$("#r_itemName").textbox("setValue",data.rows[0].itemName);
			          		$("#r_shipSeriNo").textbox("setValue",data.rows[0].shipSeriNo);
			          		$("#r_vinNo").textbox("setValue",data.rows[0].vinNo);
			          		$("#r_shipLoc").textbox("setValue",data.rows[0].shipLoc);
			          		$("#r_dealCode").textbox("setValue",data.rows[0].dealCode);
			          		$("#r_dealName").textbox("setValue",data.rows[0].dealName);
			          		$("#r_ordrNoSap").textbox("setValue",data.rows[0].ordrNoSap);
			          		$("#r_deliNoSap").textbox("setValue",data.rows[0].deliNoSap);
			          		//$("#r_bolNo").textbox("setValue",data.rows[0].bolNo);
			          		//$("#r_bolStat").textbox("setValue",data.rows[0].bolStat);
			          		$("#r_actShipDate").textbox("setValue",data.rows[0].actShipDate);
			          		$("#r_shipPostDate").textbox("setValue",data.rows[0].shipPostDate);
			          		$("#r_invNoWgos").textbox("setValue",data.rows[0].invNoWgos);
			          		//$("#r_billDateSap").textbox("setValue",data.rows[0].billDateSap);
			          		$("#r_soNoSap").textbox("setValue",data.rows[0].soNoSap);
			          		$("#r_invWhSap").textbox("setValue",data.rows[0].invWhSap);
			          		$("#r_invNoSap").textbox("setValue",data.rows[0].invNoSap);
			          		$("#r_ordrStat").val("setValue",data.rows[0].ordrStat);
			          		
			          		$("#r_ordrNo").textbox({readonly:true});
			          		//$("#r_ordrSeq").textbox({readonly:true});
			          		//$("#r_itemType").textbox({readonly:true});
			          		$("#r_itemCode").textbox({readonly:true});
			          		$("#r_itemName").textbox({readonly:true});
			          		$("#r_shipSeriNo").textbox({readonly:true});
			          		$("#r_vinNo").textbox({readonly:true});
			          		$("#r_shipLoc").textbox({readonly:true});
			          		$("#r_dealCode").textbox({readonly:true});
			          		$("#r_dealName").textbox({readonly:true});
			          		//$("#r_bolNo").textbox({readonly:true});
			          		//$("#r_bolStat").textbox({readonly:true});
			          		$("#r_actShipDate").textbox({readonly:true});
			          		$("#r_shipPostDate").textbox({readonly:true});
			          		//$("#r_billDateSap").textbox({readonly:true});
			          		$("#r_soNoSap").textbox({readonly:true});
			          		$("#r_invWhSap").textbox({readonly:true});
			          		$("#r_invNoSap").textbox({readonly:true});
			          		
			          		
			          		$("#regist-dialog").dialog('center');
			          		$("#regist-dialog").dialog('open');
			          	}
			  			else {
			  				$.messager.alert(msg.MSG0121,msg.MSG0029,msg.MSG0121);
			  			}
			  			
			  		},
			  		error: function(){
			  		}
			  	});
			},
			//그리드 동적콤보를 위한 이벤트바인딩
			onLoadSuccess : function() {
				
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
				doLangSettingTable();
			}
		});

		// 등록폼 초기화
		doClear();
	}
};

//업로드 팝업 그리드
var consts2= {
	sysId : gconsts.SYS_ID, // 시스템ID (common.jsp)
	title : gconsts.TITLE, // 화면제목 (common.jsp)
	pageSize : gconsts.PAGE_SIZE, // 출력수 (common.jsp)
	easygrid : false, // 기본컨트롤
	url : {
		upload:  getUrl("/common/invoice/invoiceadjustment/upload.json"),
		save :   getUrl("/common/invoice/invoiceadjustment/excelsave.json")
	},
	init : function() {

		// 기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url :{ upload: getUrl("/common/invoice/invoiceadjustment/upload.json"),
				   save :  getUrl("/common/invoice/invoiceadjustment/save.json")
				 },
			// title: this.title, //20160921 김원국
			gridKey : "#search-grid2",
			sformKey : "#search-form2"
		});

		// 그리드 생성
		this.easygrid.init({
			fit : true,
			singleSelect : true,
			pageSize : this.pageSize,
			idField: 'sapCode',
			onResize : doResize_Single, 
			singleSelect : true,
			// 그리드 편집이벤트 바인딩
			onClickRow : this.easygrid.clickRowEdit,
			onBeginEdit : doBeginEdit, //필수
			OnBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
			onLoadSuccess : function() {
				
			$("#search-grid2").datagrid('unselectAll');
			$("#search-grid2").datagrid('clearSelections');

				
			}
		});
		// 등록폼 초기화
		doClear();
		},
		save: function() {
			//편집종료
			this.easygrid.endEdit();

			var rows = this.easygrid.getRows();

			if (rows == null ||
				rows.length == 0) {
				$.messager.alert(msg.MSG0121,msg.MSG0023,msg.MSG0121);
				return;
			}
			
			var data = {models: $.toJSON(rows)};
			
			
			
			for(var i=0; i<rows.length; i++){
    			if(rows[i].result != msg.MSG0119){
    				$.messager.alert((i+1)+'TH',msg.MSG0121);
	    			return 0;
    			}
    		}

			jlogic.save({
				url: this.url.save,
				data: data,
				message: msg.MSG0118,
				success: function(response) {
					jlogic.result(response, function(res) {
						doClear();
					});
				}
			});
		},
		upload: function() {
		
		    //폼전송
		    $('#search-form2').ajaxForm({
		    	url: this.url.upload,
		    	//보내기전 validation check가 필요할경우
		    	beforeSubmit: function () {
		    		if ($("#s_excelFile").val() == '') {
		    			$.messager.alert(msg.MSG0121,msg.MSG0019,msg.MSG0121);
		    			return false;
		    		}
		    		return true;
		    	},
		    	//submit이후의 처리
		    	success: function(data) {
		    		
		    		
		    		
		    		for(var i=0; i<=data.rows.length; i++){
		    			for(k in data.rows[i]){
		    				if(data.rows[i].sapCode == null){
		    					data.rows[i]["result"] = "SAP Code : " + msg.MSG0119;
		    				}
		    				else if(data.rows[i].description == null){
		    					data.rows[i]["result"] = "Description : " + msg.MSG0119;
		    				}
		    				else if(data.rows[i].group == null){
		    					data.rows[i]["result"] = "Group : " + msg.MSG0119;
		    				}
		    				else if(isNaN(Number(data.rows[i].itemPrice))){
		    					data.rows[i]["result"] = "Price : " + msg.MSG0119;
		    				}
		    				else if(isDatetime(data.rows[i].applyStartDate) == false){
		    					data.rows[i]["result"] = "startDate : " + msg.MSG0119;
		    				}
		    				else if(isDatetime(data.rows[i].applyEndDate) == false){
		    					data.rows[i]["result"] = "endDate : " + msg.MSG0119;
		    				}
		    				else{
		    					data.rows[i]["result"] = msg.MSG0119;
		    				}
		    			}
		    		}
		    		
		    	if(data.rows == 'error'){
		    			$.messager.alert(msg.MSG0121,msg.MSG0039,msg.MSG0121);
		    		}else{
		    			consts2.easygrid.loadData(data);
		    		}
		    	},
		        //ajax error
		        error: function() {
		        	alert(msg.MSG0130);
		        }
		    }).submit();
		}
};

$(function() {

	consts.init();
	consts2.init();
	
	$('#regist-dialog').dialog({
		title: tit.TITLE0039,
	    top:     0,
	    width: 800,
	    height: 560,
	    closed: true,
	    modal: true,
	    resizable: true
	});

	$('#item-search-dialog').dialog({
		title : tit.TITLE0005,// 샘플게시판 등록
		iconCls : 'icon-search',
		top : 10,
		// width: 580,
		width : 600,
		height : 463,
		closed : true,
		modal : true,
		resizable : true
	});

	$('#pdf-dialog').dialog({
	    title: tit.TITLE0029,
	    iconCls: 'icon-search',
	    top:     10,
	    bottom:  10,
	    width: 1024,
	    height: 730,
	    closed: true,
	    modal: true,
	    panel: true,
	    resizable: true
	});

	$('#print-dialog').dialog({
	    title: tit.TITLE0005,
	    iconCls: 'icon-search',
	    top:     10,
	    bottom:  10,
	    width: 220,
	    height: 212,
	    //기존 3개 일 경우 212
	    closed: true,
	    modal: true,
	    panel: true,
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
	doSearch();
});

$(window).load(function() {

	/*consts_item.init(); // 상품조회*/
	setTimeout(function (){
		
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
		
		$('#regist-dialog').window({
		    onClose: function (){
		    	setTimeout('doClear2()', 10);
		    }
		});

		$(".wui-dialog").show();

		$("#account-layout").fadeIn(300);

		// 검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		// 팝업버튼
		$("#append-button").bind("click", doAppend);
		//닫기버튼
		$("#cl-btn").bind("click", doClose);
		
		// 저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave3);
		$("#save-button2").bind("click", doSave2);
		// 엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//초기화버튼 클릭시 이벤트바인딩
		$("#clear-button"  ).bind("click", doReload);
		//업로드버튼 클릭시 이벤트 바인딩
		$("#upload-button").bind("click", doUpload);
		//div 사이즈 조절
		$("#updown-button").bind("click", divUpDown);
		// 정렬버튼
		$("#sort-button").bind("click", doSortPopup);
		// 상태 업데이트 버튼
		$("#update-stat-button").bind("click", doUpdateState);
		// 인보스이 업데이트 버튼
		$("#update-inv-button").bind("click", doUpdateInv);
		// 정렬기능 기본 셋팅
		var sortContentParame = [ {
			"sortText" : "품번",
			"sortValue" : "ITEM_CODE"
		}, {
			"sortText" : "품명",
			"sortValue" : "ITEM_NAME"
		} ];
		jSortInit(sortContentParame);
		if ($("#sortValue").val() != "") {
			//doSearch();
		}

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
	
	
	//Order Staus _ radio 버튼 클릭 이벤트 
	$("input:radio[name=ordrStat]").click(function(){
		if($("input:radio[name=ordrStat]:checked").val()=='600'){
			$("#selectDateForm1").css('display','inline');
			$("#selectDateForm2").css('display','inline');
		} else {
			$("#selectDateForm1").css('display','none');
			$("#selectDateForm2").css('display','none');
		}
	});
	
	doInitDate();
});

function doInitDate() {
	var date = new Date();
	$("#shipDateTo").datebox("setValue",doFormatDate(date));
	date.setDate(date.getDate()-15);
	var date2 = new Date(date.getFullYear() + "-" + addzero(date.getMonth()+1) + "-01");
	
	$("#shipDateFr").datebox("setValue",doFormatDate(date2));
}

// 화면 상수값 초기화
function doInit(args) {

	if (args) {
		$.extend(consts, args);
	}
}
// 에디트 시작
function doBeginEdit(rowIndex, rowData) {
	var editors = $('#search-grid').datagrid('getEditors', rowIndex);
}
// 검색 처리
function doSearch() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	doClear();
	consts.easygrid.search(consts.url.search);
	toggleButtons($('input[name="ordrStat"]:checked').val());
}

// 팝업 생성
function doAppend() {
	doClear2();
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	$("#r_ordrNo").textbox({readonly:false});
	$("#r_oper").val("I");
	$("#regist-dialog").dialog('center');
	$("#regist-dialog").dialog('open');
	//consts.easygrid.appendEdit();
}

//닫기처리 doClose
function doClose() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }
	$('#regist-dialog').dialog('close');

}

//규격 저장
function doSave(){
	if(doubleSubmitCheck()){ 
		if($('#'+this.id).hasClass('l-btn-disabled')){
		      return false;
		   }
		consts.easygrid.saveEditCustom();
	}
}

function doSave2(){
	if(doubleSubmitCheck()){ 
		if($('#'+this.id).hasClass('l-btn-disabled')){
		      return false;
		   }
		consts2.save();
	}
}

//엑셀 다운로드
function doExcel() {
	var rows = 0;
	
	$.ajax({
      url: getUrl('/common/invoice/invoiceadjustment/searchCount.json'),
      dataType: 'json',
      async: false,
      type: 'post',
      data: {	ordrNo:$("#ordrNo").textbox("getValue")
      	 	   ,ordrStat:$('input:radio[name="ordrStat"]:checked').val()
      	 	   ,selectDate:$("#selectDate").combobox("getValue")
      	 	   ,shipDateFr:$("#shipDateFr").textbox("getValue")
      	 	   ,shipDateTo:$("#shipDateTo").textbox("getValue")
      	 },
      success: function(data){
    	  rows = data.rows;
    	  
      },
      error: function(){
      }
	});
	
	var msg1  = ''
		+ msg.MSG0125
        + msg.MSG0125
        + msg.MSG0125
		+ '&emsp;&emsp;&emsp;&nbsp; '+msg.MSG0125;

		if(rows >= 1000) {
			$.messager.confirm(msg.MSG0126, msg1, function(r) {

				if (!r)
					return;

				doExcelEvent();

			});
		} else {

			doExcelEvent();

		}
}

function doExcelEvent(){
	$('#progress-popup').dialog('open');

	consts.easygrid.download();

	$(document).ready(function() {
		$(window).blur(function() {
			$('#progress-popup').dialog('close');
		});
	});
}

// 초기화 처리
function doClear() {
	consts.easygrid.clear();
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('clearSelections');
}

function doClear2() {
	$("#r_ordrNo").textbox('setValue','');
	//$("#r_ordrSeq").textbox('setValue','');
	//$("#r_itemType").textbox('setValue','');
	$("#r_itemCode").textbox('setValue','');
	$("#r_itemName").textbox('setValue','');
	$("#r_shipSeriNo").textbox('setValue','');
	$("#r_vinNo").textbox('setValue','');
	$("#r_shipLoc").textbox("setValue",'');
	$("#r_dealCode").textbox("setValue",'');
	$("#r_dealName").textbox("setValue",'');
	$("#r_ordrNoSap").textbox("setValue",'');
	$("#r_deliNoSap").textbox("setValue",'');
	//$("#r_bolNo").textbox("setValue",'');
	//$("#r_bolStat").textbox("setValue",'');
	$("#r_actShipDate").textbox("setValue",'');
	$("#r_shipPostDate").textbox("setValue",'');
	$("#r_invNoWgos").textbox("setValue",'');
	$("#r_invNoSap").textbox("setValue",'');
	//$("#r_billDateSap").textbox("setValue",'');
	$("#r_soNoSap").textbox("setValue",'');
	$("#r_invWhSap").textbox("setValue",'');
	$("#r_invChgRemk").val('');
	$("#r_ordrStat").val('');
}

function doReload(){
	$("#ordrNo").textbox('setValue','');
	$("#ordrStat_550").prop("checked", true);
	$("#selectDate").combobox('setValue','act');
	$("#selectDateForm1").css('display','none');
	$("#selectDateForm2").css('display','none');
	doInitDate();
}

function doEnterKey() {

}


//행클릭이벤트
function doClickRow(index, row){
	//
	consts.easygrid.clickRowEdit(index);
}



function doEndEdit(index, row) {

	for(var i=0; i < row.length; i++ ){
		$('#search-grid').datagrid('endEdit',i);
	}
}

// [2017.04.25.shlee] 1차콤보의 포맷함수 (콤보의 텍스트값이 표시됨)
function doFormatCode1(value,row) {
	return row.itemType1Name;
}

// [2017.04.25.shlee] 2차콤보의 포맷함수 (콤보의 텍스트값이 표시됨)
function doFormatCode2(value,row) {
	return row.itemType2Name;
}


//숫자를 0으로 채우는 함수
function fillzero(obj, len) {
	obj= '000000000000000'+obj;
	return obj.substring(obj.length-len);
}


function doClickRows(){
	
}

//업로드 처리
function doUpload() {
	consts2.upload();
}

//날짜포맷함수: YYYY/MM/DD
function doFormatDate(dateobject) {
	var date = moment(dateobject);
    return date.format("MM.DD.YYYY");
};

// 날짜파싱함수: YYYY/MM/DD
function doParseDate(datestring) {
	if (!datestring) return new Date();
	   var ss = datestring.split('.');
	   var m = parseInt(ss[0],10);
	   var d = parseInt(ss[1],10);
	   var y = parseInt(ss[2],10);
	   if (!isNaN(m) && !isNaN(d) && !isNaN(y)){
	      return new Date(y,m-1,d);
	   } else {
	      return new Date();
	   }
};

//날짜 정규식 검사
function isDatetime(d)
{
    var re = /^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
    //         yyyy -       MM      -       dd          ( hh     :   mm  :   ss ->  (2[0-3]|[01][0-9]):[0-5][0-9])
    return re.test(d);
}

//ADD 팝업 내용 저장
function doSave3(){
	if(doubleSubmitCheck()){ 
		var ordrNoSap = $('#r_ordrNoSap').val();
		var deliNoSap = $('#r_deliNoSap').val();
		var invNoWgos = $('#r_invNoWgos').val();
		//var applyBeginDate = $('#r_applyBeginDate').datebox("getValue");
		
		if (ordrNoSap == "" || Utils.isNull(ordrNoSap)) {
			$.messager.alert(msg.MSG0121,msg.MSG0010,msg.MSG0121);
			return;
		}
		
		if (deliNoSap == "" || Utils.isNull(deliNoSap)) {
			$.messager.alert(msg.MSG0121,msg.MSG0010,msg.MSG0121);
			return;
		}
		
		/*if (invNoWgos == "" || Utils.isNull(invNoWgos)) {
			$.messager.alert(msg.MSG0121,msg.MSG0121,msg.MSG0121);
			return;
		}*/
		
		  $.ajax({
		      url: getUrl('/common/invoice/invoiceadjustment/saveItem.json'),
		      dataType: 'json',
		      async: false,
		      type: 'post',
		      data: {
		    	  ordrNo:$("#r_ordrNo").val()
	     	 	 ,ordrStat:$("#r_ordrStat").val()
		    	 ,ordrNoSap:$("#r_ordrNoSap").val()
		    	 ,deliNoSap:$("#r_deliNoSap").val()
		    	 ,invNoSap:$("#r_invNoWgos").val()
		    	 ,invChgRemk:$("#r_invChgRemk").val()
		      },
		      success: function(data){
		    	 
		      	$.messager.show({
		  			title: tit.TITLE0040,
		  			msg: msg.MSG0120
		  		});
		      	doSearch();
		      	//doPriceSearch();
		      },
		      error: function(){
		      	$.messager.show({
		  			title: tit.TITLE0040,
		  			msg: msg.MSG0047
		  		});
		      }
		  });
	}

}

function cellStyler (value,row,index){
	return 'text-decoration: underline; color: #642EFE; cursor: pointer;';
}

function cellStyler2 (value,row,index){
	return 'background-color:#f9f9f9';
}

function cellStyler3 (value,row,index){
	return 'text-decoration: underline; color: #642EFE; cursor: pointer; background-color:#f9f9f9';
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

function doFormatString(String){
	var result = String;
	if(result == "Y"){
		var result2 = result.replace("Y", "O");
	}
	else if(result == "N"){
		var result2 = result.replace("N", "X");
	}
	else if(result == "O"){
		var result2 = "O";
	}
	else if(result == "" || result == null || result == undefined || result == "X" ) {
		var result2 = "X";
	}
	return result2;
}


//div 사이즈 조절 펑션
function divUpDown(){
      
      if($('.Remake-div-line-new').css('height') =='81px'){
            $('.Remake-div-line-new').css('height','auto'); 
            $('#arrow-icon').addClass('fa-rotate-180');
            $('#search-grid').datagrid('resize');
      }else{
            $('.Remake-div-line-new').css('height','81px')
            $('#arrow-icon').removeClass('fa-rotate-180');
            $('#search-grid').datagrid('resize')
      }
}

function addzero(n){                        // 한자리가 되는 숫자에 "0"을 넣어주는 함수
    return n < 10 ? "0" + n: n;
}

function doUpdateInv(n){                      
	var rows = $("#search-grid").datagrid('getChecked');
	if (!rows || rows.length === 0) {
		$.messager.alert(msg.MSG0121, msg.MSG0075, msg.MSG0121);
		return;
	}

	// eqChk가 'red'인 항목이 있는지 검사
	var hasRedEqChk = rows.some(function(row) {
		return row.eqChk === 'red';
	});

	function executeAjax() {
		var processedOrdrNo = {};
		
		rows.forEach(function(row) {
			if (!processedOrdrNo[row.ordrNo]) {
				processedOrdrNo[row.ordrNo] = true;

				$.ajax({
					url: getUrl('/common/invoice/invoiceadjustment/updateSapInv.json'),
					dataType: 'json',
					async: true,
					type: 'post',
					data: {	
						ordrNo : row.ordrNo,
						itemCode : row.itemCode,
						shipSeriNo : row.shipSeriNo,
						updateType : "A",
					},
	                success: function(data){
	    		      	$.messager.show({
	    		  			title: tit.TITLE0040,
	    		  			msg: msg.MSG0119
	    		  		});
	                	doSearch();
	                },
	                error: function(){
						$.messager.show({
							title: tit.TITLE0040,
							msg: msg.MSG0119
						});
	                }
				});
			}
		});
	}

	// eqChk == 'red' 있으면 확인창 띄움
	if (hasRedEqChk) {
		$.messager.confirm(msg.MSG0121, msg.MSG0121, function(r) {
			if (r) {
				executeAjax();
			}
		});
	} else {
		executeAjax();
	}
}



function doUpdateState(n){    
	var rows = $("#search-grid").datagrid('getChecked');
	if (!rows || rows.length === 0) {
		$.messager.alert(msg.MSG0121, msg.MSG0075, msg.MSG0121);
		return;
	}

	// eqChk가 'red'인 항목이 있는지 확인
	var hasRedEqChk = rows.some(function(row) {
		return row.eqChk === 'red';
	});

	function executeAjax() {
		var processedOrdrNo = {};

		rows.forEach(function(row) {
			if (!processedOrdrNo[row.ordrNo]) {
				processedOrdrNo[row.ordrNo] = true;

				$.ajax({
					url: getUrl('/common/invoice/invoiceadjustment/updateSapStat.json'),
					dataType: 'json',
					async: true,
					type: 'post',
					data: {    
						ordrNo : row.ordrNo,
						itemCode : row.itemCode,
						shipSeriNo : row.shipSeriNo,
						updateType : "B",
					},
	                success: function(data){
	    		      	$.messager.show({
	    		  			title: tit.TITLE0040,
	    		  			msg: msg.MSG0119
	    		  		});
	                	doSearch();
	                },
	                error: function(){
						$.messager.show({
							title: tit.TITLE0040,
							msg: msg.MSG0119
						});
	                }
				});
			}
		});
	}

	if (hasRedEqChk) {
		$.messager.confirm(msg.MSG0121, msg.MSG0121, function(r) {
			if (r) {
				executeAjax();
			}
		});
	} else {
		executeAjax();
	}
}




function eqChkMarkFormatter(value, row, index) {
    return row.eqChk == 'green' ? '<span style="color:green;font-size:28px;">●</span>' :
           row.eqChk == 'red'   ? '<span style="color:red;font-size:28px;">●</span>' :'';
}

function toggleButtons(value) {
    if (value === '600') {  // Complete 선택됨
        $('#update-stat-button, #update-invc-button').hide();
        $('#update-inv-button, #update-invc-button').hide();
    } else {  // Shipped 선택됨
        $('#update-stat-button, #update-invc-button').show();
        $('#update-inv-button, #update-invc-button').show();
    }
}

var isChecking = false; // 플래그 추가 (무한루프 방지용)

//한 행 체크 시 같은 ordrNo 행 모두 체크
function doCheckRow(index, row) {
 if (isChecking) return;
 isChecking = true;

 var grid = $('#search-grid');
 var rows = grid.datagrid('getRows');
 var ordrNo = row.ordrNo;

 for (var i = 0; i < rows.length; i++) {
     if (rows[i].ordrNo == ordrNo) {
         grid.datagrid('checkRow', i);
     }
 }

 isChecking = false;
}

//한 행 체크 해제 시 같은 ordrNo 행 모두 체크 해제
function doUnCheckRow(index, row) {
 if (isChecking) return;
 isChecking = true;

 var grid = $('#search-grid');
 var rows = grid.datagrid('getRows');
 var ordrNo = row.ordrNo;

 for (var i = 0; i < rows.length; i++) {
     if (rows[i].ordrNo == ordrNo) {
         grid.datagrid('uncheckRow', i);
     }
 }

 isChecking = false;
}

//전체 체크 시 모든 행 체크
function doCheckAll(rows) {
	 if (isChecking) return;
	 isChecking = true;
	
	 var grid = $('#search-grid');
	 grid.datagrid('checkAll');
	
	 isChecking = false;
}

//전체 체크 해제 시 모든 행 체크 해제
function doUnCheckAll(rows) {
	 if (isChecking) return;
	 isChecking = true;
	
	 var grid = $('#search-grid');
	 grid.datagrid('uncheckAll');
	
	 isChecking = false;
}
