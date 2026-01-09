/**
 *
 * 거래처관리를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 패널 상세조회
 * 폼 패널 등록,수정,삭제
 */
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: getUrl("/business/company/accountmanagement/search.json"),
		excel:  getUrl("/business/company/accountmanagement/download.do"),
		select: getUrl("/business/company/accountmanagement/select.json"),
		remove: getUrl("/business/company/accountmanagement/delete.json"),
		save:   getUrl("/business/company/accountmanagement/save.json")
	},
	combo:{
		custType: new jcombobox({params:{codeGrup: 'CUST_TYPE'}})
	},
	init: function() {
		this.combo.custType.load();
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url:	{
				search: null,
				excel:  getUrl("/business/company/accountmanagement/download.do"),
				select: getUrl("/business/company/accountmanagement/select.json"),
				remove: getUrl("/business/company/accountmanagement/delete.json"),
				save:   getUrl("/business/company/accountmanagement/save.json")}
		,
		
		//title:    this.title,
		gridKey:  "#search-grid",		
		sformKey: "#search-form",
		formKey:  "#regist-form"
				
		});


		//그리드 생성
		this.easygrid.init({
			fit: true,
			singleSelect: true,
			pageSize: this.pageSize,
			//toolbar:  "#search-toolbar",
			//행선택시 상세조회 이벤트 바인딩
			//onBeforeSelect:checkYn,
			idField: 'custCode',
			onSelect:this.easygrid.select,	
			onClickRow: doClickRow,
			onBeginEdit : doBeginEdit, //필수
			OnBeforeEdit : this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit,
				
			
			/*onSelect: doSelectRow,*/
			/*onDblClickRow:function(index, row) {
					
					(row.tempRele=='Y' ? ("#s_tempRele").attr("checked", true) : $("#s_tempRele").attr("checked", false));
					(row.stopTrad=='Y' ? $("#s_stopTrad").attr("checked", true) : $("#s_stopTrad").attr("checked", false));

			},*/
			onLoadSuccess:function(){
				//Enter 검색을 위한 추가
				$(".easyui-textbox").each(function(index, item){
					var itemid = $("#"+item.id);
					itemid.textbox('textbox').bind('keyup', function(e){
						itemid.textbox('setValue', $(this).val());
					});
				});

				//
				

				//2016/10/07 김영진 --검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			}
		});

		$("#s_searchCustType").combobox({
			  onChange:function(newValue,oldValue){
				  doSearch();
			    }
		    });

		
	}
};

$(function() {

	consts.init();

	$('#progress-popup').dialog({
	       title: tit.TITLE0009,
	       top:     100,
	       width: 200,
	       height: 200,
	       closed: true,
	       modal: true,
	       resizable: false
	   });

});

$(window).load(function() {

	consts.init();

	setTimeout(function (){

		$(".wui-dialog").show();

		$("#account-layout").fadeIn(300);
		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
		//리포트버튼 클릭시 이벤트 바인딩
		//$("#report-button-pdf").bind("click", doReport);
		//$("#report-button-xls").bind("click", doReport);
		//$("#report-button-htm").bind("click", doReport);

		//추가버튼 클릭시 이벤트 바인딩
		$("#append-button").bind("click", doAppend);
		//삭제버튼 클릭시 이벤트 바인딩
		$("#remove-button").bind("click", doRemove);
		//초기화버튼 클릭시 이벤트 바인딩
		//$("#clear-button").bind("click", doClear);
		//저장버튼 클릭시 이벤트 바인딩
		$("#save-button").bind("click", doSave);
		//초기화버튼 클릭시 이벤트바인딩
		$("#dreload-button"  ).bind("click", doReload);

		//목록열기 버튼 클릭시 이벤트 바인딩
		$('#open-button').bind("click", doOpenTable);
		//목록닫기 버튼 클릭시 이벤트 바인딩
		$('#close-button').bind("click", doCloseTable);
		$('#open-button').css("display", "none");

		doSearch();

		//Enter 검색을 위한 추가
		$("#search-form").bind('keydown',function(events){
			if(events.keyCode == 13){
				doSearch();
			}
		});

		$("#s_searchCustType").combobox('textbox').unbind('keydown').bind('keydown', function(e){
			if (e.which === 13 ) {
				doSearch();
		    }
		});

		 /*
		  *  -- 추가해주는 부분
		  *  $('[placeholder]')
	      .focus(function () {
	          var input = $(this);
	         // console.log(input);
	          if (input.val() === '' || input.val() === input.attr('placeholder' )) {
	        	  //console.log("null");
	        	  input.addClass('placeholder').val('--');
	          }else{
	        	  //console.log("data");
	        	  //input.val('').removeClass('placeholder');
	        	  //input.addClass('placeholder').val(input.attr('placeholder'));
	          }
	      })*/


			/*	//정렬버튼
				$("#sort-button"  ).bind("click", doSortPopup);

				// 정렬기능 기본 셋팅
				var sortContentParame = [{"sortText":"정싱명칭","sortValue":"CUST_NAME"}
			      ,{"sortText":"약싱명칭","sortValue":"CUST_INFO_NAME"}
				  ,{"sortText":"CODE","sortValue":"CUST_CODE"}
				  ,{"sortText":"구분","sortValue":"CUST_TYPE"}
				  ,{"sortText":"대표자명","sortValue":"OWN_NAME"}
				  ];

				jSortInit(sortContentParame);

				if($("#sortValue").val() != ""){
					doSearch();
				}*/
			//등록폼 초기화
			doClear();
	}, 100);
	
	doLangSettingTable();
	
});

//화면 상수값 초기화
function doInit(args) {

	if (args) {
		$.extend(consts, args);
	}
}

//검색 처리
function doSearch() {

	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	doClear();
	
	//consts.easygrid.search();
	consts.easygrid.search(consts.url.search);
}

//TODO 엑셀 다운로드
function doExcel() {

	var rows = 0;

	$.ajax({
	      url: getUrl('/business/company/accountmanagement/searchCount.json'),
	      dataType: 'json',
	      async: false,
	      type: 'post',
	      data: {searchCustName:$("#searchCustName").textbox("getValue")
	     	 	   ,searchCustCode:$("#searchCustCode").textbox("getValue")
	      	 	   ,searchCustType:$("#s_searchCustType").combobox("getValue")
	      	 	   ,searchOwnName:$("#searchOwnName").textbox("getValue")
	      	 	   ,searchDepositor1:$("#searchDepositor1").textbox("getValue")
	      	 	   ,searchBizNo:$("#searchBizNo").textbox("getValue")
	      	 },
	      success: function(data){
	    	  rows = data.rows;
	      },
	      error: function(){
	      }
	  });

	var msg  = ''
	     + '검색된 데이터가 많아서 엑셀기능 사용시<br>'
         + '작업시간이 오래 걸릴 수 있으며,<br>'
         + '시스템 성능을 저하시킬 수 있습니다.<br><br>'
		 + '&emsp;&emsp;&emsp;&nbsp; 계속해서 작업을 진행하시겠습니까?';

		if(rows >= 1000) {
			$.messager.confirm('알림', msg, function(r) {

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

//초기화 처리
function doClear() {
	consts.easygrid.clear();
	$("#search-grid").datagrid('unselectAll');
	$("#search-grid").datagrid('clearSelections');
	
	
	
	/* $("#stopTrad").prop("checked", false);			
	 $("#misuChkYn").prop("checked", false);
	 $("#mijiChkYn").prop("checked", false);
	 $("#tempRele").prop("checked", false);
	 $("#prePayYn").prop("checked", false);*/
	
	
	SettingTab2Default();
	
}


function SettingTab2Default(){
	 
	 $("#r_compStafName").val('');
	 $("#r_compStafDept").val('');
	 $("#r_compStafTel1").val('');
	 $("#r_compStafHP").val('');
	 $("#r_compMail").val('');	 
	 $("#r_billIssue").combobox('setValue','');	 
	 $("#r_billCloseDt").textbox('setValue','');
	 $("#r_billRemk").val('');
	 $("#r_depositor1").val('');
	 $("#r_depositor2").val('');
	 $("#r_shopAdd").val('');
	 $("#r_shopStafName").val('');
	 $("#r_shopStafTel").val('');
	 $("#r_compGrade").combobox('setValue','');
	 $("#r_taxGp").val('');	 
	 $("#r_taxType").val('');	 
	 $("#r_shopDept").combobox('setValue','');
	 $("#r_taxGp").val('');
	 $("#r_taxType").combobox('setValue','');
	 $("#r_rgpayDate").textbox('setValue','');
	 $("#r_shopDept").combobox('setValue','');	 
	 $("#r_stafName").combobox('setValue','');
	 $("#r_taxbillCls").combobox('setValue','');	 	 
	 $("#r_custRemk").val('');
	 

	 $("input:checkbox[id='11']").prop("checked", false); 	
	 $("input:checkbox[id='12']").prop("checked", false); 	
	 $("input:checkbox[id='13']").prop("checked", false); 	
	 $("input:checkbox[id='14']").prop("checked", false); 	
	 $("input:checkbox[id='15']").prop("checked", false); 
	
}

//삭제 처리
function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	consts.easygrid.remove();
}
//추가 처리
function doAppend() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   }

	doClear();

	/*var searchParams = new FormData();
	var custCode = "";
	$.ajax({
        url: getUrl('/business/company/accountmanagement_sales/getCustCode.json'),
        dataType: 'json',
        async: false,
		processData: false,
        contentType: false,
        type: 'post',
        data: searchParams,
        success: function(data){
        	if(!data)
        		return;
        	if(!data.rows)
        		return;
        	items = $.map(data.rows, function(item) {
        		custCode   = item.custCode;
            });

        	$('#r_custCode').val(custCode);
        },
        error: function(){
        }
    });*/
	$('#r_hdfCustCode').val("C");
}
//저장 처리
function doSave() {
	
	if($("#r_custName").val() == ""){
		$.messager.alert(msg.MSG0121,msg.MSG0109,msg.MSG0121);
		return;
	}

	var custCode = $('#r_hdfCustCode').val();
	if(custCode == "" || custCode == null){
		$('#r_hdfCustCode').val("C");
		custCode='C';
	}
	
	
	//CHECK 된 값 가져오기	
	var custType='';
	var i=0;
	$("input[name='checkCustType']:checked").each(function() {
		
		if(i==0){
			custType = $(this).val();
		}else{
			custType = custType + "/" + $(this).val();
		}		
		i++;
	});
	console.log("final: "+custType);
	$("#r_custType").val(custType);
	
	console.log($("#prePayYn").is(":checked"));
	console.log($("#prePayYn").val())
//	console.log(( $("#prePayYn").val()=='on' ? 'Y' : 'N'));
	 $.ajax({
	      url: getUrl('/business/company/accountmanagement/saveItem.json'),
	      dataType: 'json',
	      async: false,
	      type: 'post',
	      data: {
	    	  /*거래처상세*/
	    	  custInfoName:$("#r_custInfoName").val()
	    	 ,custCode:custCode
	    	 ,custName:$("#r_custName").val()
//	    	 ,regiDate:$("#r_regiDate").val()    	 
	    	 ,bizNo:$("#r_bizNo").val()
	    	 ,taxCls:$("#r_taxCls").combobox("getValue")
	    	 ,bizClss:$("#r_bizClss").val()
	    	 ,bizType:$("#r_bizType").val()
	    	 ,compTel1:$("#r_compTel1").val()
	    	 ,compFax:$("#r_compFax").val()
	    	 ,ownName:$("#r_ownName").val()
	    	 ,ownHP:$("#r_ownHP").val()
	    	 ,ownHome:$("#r_ownHome").val()
	    	 ,addrZip:$("#r_addrZip").val()
	    	 ,addrMain:$("#r_addrMain").val()
	    	 ,custType:$("#r_custType").val()
	    	 ,stopTrad: $("#stopTrad").is(":checked")? 'Y':'N' 
	    	 ,misuChkYn: $("#misuChkYn").is(":checked")? 'Y':'N'
	    	 ,mijiChkYn: $("#mijiChkYn").is(":checked")? 'Y':'N'
	    	 ,tempRele:  $("tempRele").is(":checked")? 'Y':'N'
	    	 ,prePayYn:  $("#prePayYn").is(":checked")? 'Y':'N'
	    	 ,creditAmt:$("#r_creditAmt").val()
	    	 ,payableAmt:$("#r_payableAmt").val()
	    	 ,baseMisuAmt:$("#r_baseMisuAmt").val()
	    	 ,baseMisuDate:$("#r_baseMisuDate").val()
	    	 ,payablemijiAmt:$("#r_payablemijiAmt").val()
	    	 ,baseMijiAmt:$("#r_baseMijiAmt").val()
	    	 ,baseMijiDate:$("#r_baseMijiDate").val()
	    	 ,ubiqCode:$("#r_ubiqCode").val()
	    	 ,rlTm:$("#r_rlTm").val()
	    	 ,dcRate:$("#r_dcRate").val()
	    	 ,cpDcRate:$("#r_cpDcRate").val()	    	
	    	/*계산서*/
	    	,compStafName: $("#r_compStafName").val()
		 	,compStafDept: $("#r_compStafDept").val()
		 	,compStafTel1: $("#r_compStafTel1").val()
		 	,compStafHP: $("#r_compStafHP").val()
		 	,compMail: $("#r_compMail").val()		 	
		 	,billIssue:  $("#r_billIssue").combobox("getValue") 
		 	,billCloseDt: $("#r_billCloseDt").textbox("getValue")
		 	,billRemk: $("#r_billRemk").val()
		 	,depositor1: $("#r_depositor1").val()
		 	,depositor2: $("#r_depositor2").val()
		 	,shopAdd: $("#r_shopAdd").val()
		 	,shopStafName: $("#r_shopStafName").val()
		 	,shopStafTel: $("#r_shopStafTel").val()
		 	,compGrade: $("#r_compGrade").combobox("getValue")
		 	,shopDept: $("#r_shopDept").combobox("getValue")
		 	,taxGp: $("#r_taxGp").val()
		 	,taxType: $("#r_taxType").combobox("getValue")
		 	,rgpayDate: $("#r_rgpayDate").textbox("getValue")
		 	,shopDept: $("#r_shopDept").combobox("getValue")
		 	,stafName: $("#r_stafName").combobox("getValue")
		 	,taxbillCls: $("#r_taxbillCls").combobox("getValue")	 	 
		 	,custRemk: $("#r_custRemk").val()
	      },
	      success: function(data){
	      	$.messager.show({
	  			title: 'Information',
	  			msg: "Save is complete."
	  		});
	      	doSearch();
	      	//doPriceSearch();
	      },
	      error: function(){
	      	$.messager.show({
	  			title: 'Information',
	  			msg: "This is registered data."
	  		});
	      }
	  });
	
	//consts.easygrid.save();
}

function doReload(){
		$("#searchCustName").textbox('setValue','');
		$("#searchCustCode").textbox('setValue','');
		$("#searchOwnName").textbox('setValue','');
		$("#searchDepositor1").textbox('setValue','');
		$("#searchBizNo").textbox('setValue','');
		$("#s_searchCustType").combobox('setValue','ALL');
}


function doEnterKey(){

}

function doCloseTable(){
	$("#account-layout").layout('collapse', 'east');
	$('#close-button').css("display", "none");
	$('#open-button').css("display", "inline-block");
}

function doOpenTable(){
	$("#account-layout").layout('expand', 'east');
	$('#open-button').css("display", "none");
	$('#close-button').css("display", "inline-block");
}

/*function checkYn(){
	console.log($("#r_stopTrad").text());

	if($("#r_stopTrad").text() == '1' || $("#r_stopTrad").text() == 'Y' )
		{
		$(this).attr('checked',true);
		}
	else
		{
		$(this).attr('checked',false);
		}
}*/

//에디트 시작
function doBeginEdit(rowIndex, rowData) {
	var editors = $('#search-grid').datagrid('getEditors', rowIndex);
}

//[행클릭] 행클릭 이벤트
function doClickRow(index, row){	
	consts.easygrid.clickRowEdit(index);
	

	 if(row.custType){
		 var str = row.custType;
		 var res = str.split("/");		 
		 
		 for(var i=0;i<res.length;i++){
			 
			 switch(res[i]){
			 case '11':
				 $("input:checkbox[id='11']").prop("checked", true); 
				 break;
			 case '12':
				 $("input:checkbox[id='12']").prop("checked", true); 
				 break;
			 case '13':
				 $("input:checkbox[id='13']").prop("checked", true); 
				 break;
			 case '14':
				 $("input:checkbox[id='14']").prop("checked", true); 
				 break;
			 case '15':
				 $("input:checkbox[id='15']").prop("checked", true); 
				 break;
			default:
				break;
			 }
		 }
	}
	 
	 
	/*if(row.stopTrad=='Y'){		
		 $("#stopTrad").prop("checked", true);
	}
	if(row.misuChkYn=='Y'){		
		 $("#misuChkYn").prop("checked", true);
	}
	if(row.mijiChkYn=='Y'){		
		 $("#mijiChkYn").prop("checked", true);
	}
	if(row.tempRele=='Y'){		
		 $("#tempRele").prop("checked", true);
	}
	
	if(row.prePayYn=='Y'){		
		 $("#prePayYn").prop("checked", true);
	}*/
	
	SettingTab2(row);
}

function SettingTab2(row){	
	
	 
	 
	 
	 $("#r_compStafName").val(row.compStafName);
	 $("#r_compStafDept").val(row.compStafDept);
	 $("#r_compStafTel1").val(row.compStafTel1);
	 $("#r_compStafHP").val(row.compStafHP);
	 $("#r_compMail").val(row.compMail);
	 
	 $("#r_billIssue").combobox('setValue',row.billIssue);
	 
	 $("#r_billCloseDt").textbox('setValue',row.billCloseDt);
	 $("#r_billRemk").val(row.billRemk);
	 $("#r_depositor1").val(row.depositor1);
	 $("#r_depositor2").val(row.depositor2);
	 $("#r_shopAdd").val(row.shopAdd);
	 $("#r_shopStafName").val(row.shopStafName);
	 $("#r_shopStafTel").val(row.shopStafTel);
	 $("#r_compGrade").combobox('setValue',row.compGrade);
	 $("#r_taxGp").val(row.taxGp);	 
	 $("#r_taxType").val(row.taxType);
	 $("#r_rgpayDate").textbox('setValue',row.rgpayDate);
	 $("#r_shopDept").combobox('setValue',row.shopDept);
	 $("#r_taxGp").val(row.taxGp);
	 $("#r_taxType").combobox('setValue',row.taxType);	 
	 $("#r_shopDept").combobox('setValue',row.shopDept);	 
	 $("#r_stafName").combobox('setValue',row.stafName);
	 $("#r_taxbillCls").combobox('setValue',row.taxbillCls);	 	 
	 $("#r_custRemk").val(row.custRemk);
}

