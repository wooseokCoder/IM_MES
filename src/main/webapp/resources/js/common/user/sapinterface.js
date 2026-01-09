/**
 * 코드관리를 처리하는 스크립트이다.
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
		//save:   getUrl("/common/code/save.json")
	},
	init: function() {
		//등록폼 초기화
		doClear();
	}
};

$(function() {

//	consts.init();
	//저장버튼 클릭시 이벤트 바인딩
//	$("#save-button").bind("click", doSave);
	$("#inb-send-button").bind("click", doInbSand);
	$("#inb-clear-button").bind("click", doInbClear);
	$("#assy-send-button").bind("click", doAssySand);
	$("#assy-clear-button").bind("click", doAssyClear);
	$("#cnsl-send-button").bind("click", doCnslSand);
	$("#cnsl-clear-button").bind("click", doCnslClear);
	$("#outb-send-button").bind("click", doOutbSand);
	$("#outb-clear-button").bind("click", doOutbClear);
	doLangSettingPage();

});

$(window).load(function() {
	setTimeout(function (){
		$("#account-layout").fadeIn(300);
	}, 100);
});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//초기화 처리
function doInbClear() {
	$("#iShipLoc").val('');
	$("#iVendCode").val('');
	$("#iItemCode").val('');
	$("#iSapPoNo").val('');
	$("#iSapPoItem").val('');
	$("#iSeriNo").val('');
	$("#iGrDate").val('');
	$("#inbTextArea").val('');
}
function doAssyClear() {
	$("#aShipLoc").val('');
	$("#aOrdrType").val('');
	$("#aItemCode").val('');
	$("#aSeriNo").val('');
	$("#aTracSeriNo").val('');
	$("#aAssyDate").val('');
	$("#aAssyNo").val('');
	$("#aPoNo").val('');
	$("#aAssyLine").val('');
	$("#aAssyRef").val('');
	$("#assyTextArea").val('');
}
function doCnslClear() {
	$("#cShipLoc").val('');
	$("#cCnslType").val('');
	$("#cSapNo").val('');
	$("#cSapSeq").val('');
	$("#cSapDate").val('');
	$("#cnslTextArea").val('');
}
function doOutbClear() {
	$("#oShipLoc").val('');
	$("#oActDate").val('');
	$("#oPostDate").val('');
	$("#oSapPoNo").val('');
	$("#oPoNo").val('');
	$("#oBolNo").val('');
	$("#oAssyNo").val('');
	$("#oItemCode1").val('');
	$("#oSeriNo1").val('');
	$("#oItemCode2").val('');
	$("#oSeriNo2").val('');
	$("#oItemCode3").val('');
	$("#oSeriNo3").val('');
	$("#oItemCode4").val('');
	$("#oSeriNo4").val('');
	$("#oItemCode5").val('');
	$("#oSeriNo5").val('');
	$("#oItemCode6").val('');
	$("#oSeriNo6").val('');
	$("#oItemCode7").val('');
	$("#oSeriNo7").val('');
	$("#oItemCode8").val('');
	$("#oSeriNo8").val('');
	$("#oItemCode9").val('');
	$("#oSeriNo9").val('');
	$("#oItemCode10").val('');
	$("#oSeriNo10").val('');
	$("#outbTextArea").val('');
}

//Inb Test
function doInbSand() {
//  필수값
//	SHIP_LOC	  M
//	VEND_CODE	  M
//	ITEM_CODE	  M
//	SAP_PO_NO
//	SAP_PO_ITEM
//	SHIP_SERI_NO  M
//	GR_DATE	      M
	if($("#iShipLoc").val() == ""){
		$.messager.alert('Warning','Please enter Warehouse.','warning');
		return;
	} else if($("#iVendCode").val() == ""){
		$.messager.alert('Warning','Please enter Vender Code.','warning');
		return;
	} else if($("#iItemCode").val() == ""){
		$.messager.alert('Warning','Please enter Item Code.','warning');
		return;
	} else if($("#iSeriNo").val() == ""){
		$.messager.alert('Warning','Please enter Serial No.','warning');
		return;
	} else if($("#iGrDate").val() == ""){
		$.messager.alert('Warning','Please enter GR Date.','warning');
		return;
	}
	$.ajax({
        url: getUrl('/common/user/sapinterface/inbSand.json'),
        dataType: "json",
        type: 'post',
        async: false,
        data : {
			shipLoc:  $("#iShipLoc").val()
		   ,vendCode: $("#iVendCode").val()
		   ,itemCode: $("#iItemCode").val()
		   ,sapPoNo:  $("#iSapPoNo").val()
		   ,sapPoSeq: $("#iSapPoItem").val()
		   ,seriNo:   $("#iSeriNo").val()
		   ,grDate:   $("#iGrDate").val()
		},
        success: function(data){
        	console.log(data);
        	if(data.rows != undefined) {
        		var resultText = "";
        		resultText += "GR NO SAP : " + data.rows.grNoSap + "\n";
        		resultText += "GR ITEM : " + data.rows.grSeqSap+"\n";
        		resultText += "RESULT : " + data.rows.grReltSap+"\n";
        		resultText += "MESSAGE : " + data.rows.grMeseSap;
        		$("#inbTextArea").val(resultText);
        	} else {
        		$.messager.alert('Information','System error, please contact IT manager!','error');
        	}
        },
        error: function(){
        	$.messager.alert('Information','System error, please contact IT manager!','error');
        }
    });
}

//Assy Test
function doAssySand() {
//  필수값
//	SHIP_LOC	M
//	ORDR_TYPE	M
//	ITEM_CODE	M
//	SHIP_SERI_NO	M
//	TRAC_SERI_NO	M
//	ASSY_DATE	M
//	ASSY_NO	M
//	PO_NO	
//	ASSY_LINE	
//	ASSY_REF	
	if($("#aShipLoc").val() == ""){
		$.messager.alert('Warning','Please enter Warehouse.','warning');
		return;
	} else if($("#aOrdrType").val() == ""){
		$.messager.alert('Warning','Please enter Assembly Type.','warning');
		return;
	} else if($("#aItemCode").val() == ""){
		$.messager.alert('Warning','Please enter Item Code.','warning');
		return;
	} else if($("#aSeriNo").val() == ""){
		$.messager.alert('Warning','Please enter Serial No.','warning');
		return;
	} else if($("#aTracSeriNo").val() == ""){
		$.messager.alert('Warning','Please enter Tractor Serial No.','warning');
		return;
	} else if($("#aAssyDate").val() == ""){
		$.messager.alert('Warning','Please enter Assembly Date.','warning');
		return;
	} else if($("#aAssyNo").val() == ""){
		$.messager.alert('Warning','Please enter Assembly No.','warning');
		return;
	}
	$.ajax({
        url: getUrl('/common/user/sapinterface/assySand.json'),
        dataType: "json",
        type: 'post',
        async: false,
        type: 'post',
        data : {
			shipLoc:    $("#aShipLoc"   ).val()   
		   ,ordrType:   $("#aOrdrType"  ).val()  
		   ,itemCode:   $("#aItemCode"  ).val()     
		   ,seriNo:     $("#aSeriNo"    ).val()
		   ,tracSeriNo: $("#aTracSeriNo").val()  
		   ,assyDate:   $("#aAssyDate"  ).val()    
		   ,assyNo:     $("#aAssyNo"    ).val()      
		   ,poNo:       $("#aPoNo"      ).val()  
		   ,assyLine:   $("#aAssyLine"  ).val()   
		   ,assyRef:    $("#aAssyRef"   ).val() 
		},
        success: function(data){
        	//console.log(data);
        	if(data.rows != undefined) {
        		var resultText = "";
        		resultText += "AO NO SAP : " + data.rows.aoNoSap + "\n";
        		resultText += "AO ITEM : " + data.rows.aoSeqSap+"\n";
        		resultText += "RESULT : " + data.rows.aoReltSap+"\n";
        		resultText += "MESSAGE : " + data.rows.aoMeseSap;
        		$("#assyTextArea").val(resultText);
        	} else {
        		$.messager.alert('Information','System error, please contact IT manager!','error');
        	}
        },
        error: function(){
        	$.messager.alert('Information','System error, please contact IT manager!','error');
        }
    });
}

//Cancel Test
function doCnslSand() {
//  필수값
//	SHIP_LOC	  M
//	DOC_TYPE	  M
//	GR_NO_SAP	  M
//	GR_SEQ        M
//	GR_DATE	      M
	if($("#cShipLoc").val() == ""){
		$.messager.alert('Warning','Please enter Warehouse.','warning');
		return;
	} else if($("#cCnslType").val() == ""){
		$.messager.alert('Warning','Please enter Cancel Type.','warning');
		return;
	} else if($("#cSapNo").val() == ""){
		$.messager.alert('Warning','Please enter SAP No.','warning');
		return;
	} else if($("#cSapSeq").val() == ""){
		$.messager.alert('Warning','Please enter SAP Item.','warning');
		return;
	} else if($("#cSapDate").val() == ""){
		$.messager.alert('Warning','Please enter SAP Date.','warning');
		return;
	}
	$.ajax({
        url: getUrl('/common/user/sapinterface/cnslSand.json'),
        dataType: "json",
        type: 'post',
        async: false,
        data : {
			shipLoc:  $("#cShipLoc").val()
		   ,cnslType: $("#cCnslType").val()
		   ,grNoSap: $("#cSapNo").val()
		   ,grSeqSap:  $("#cSapSeq").val()
		   ,grDate: $("#cSapDate").val()
		},
        success: function(data){
        	//console.log(data);
        	if(data.rows != undefined) {
        		var resultText = "";
        		resultText += "SAP NO : " + data.rows.sapNo + "\n";
        		resultText += "SAP ITEM : " + data.rows.sapSeq+"\n";
        		resultText += "SAP DATE : " + data.rows.sapDate+"\n";
        		resultText += "RESULT : " + data.rows.sapRelt+"\n";
        		resultText += "MESSAGE : " + data.rows.sapMese;
        		$("#cnslTextArea").val(resultText);
        	} else {
        		$.messager.alert('Information','System error, please contact IT manager!','error');
        	}
        },
        error: function(){
        	$.messager.alert('Information','System error, please contact IT manager!','error');
        }
    });
}

//Outb Test
function doOutbSand() {
//  필수값
//	SHIP_LOC	   M
//	ACT_SHIP_DATE  M
//	SHIP_POST_DATE M
//	ORDR_NO_SAP    M
//	ORDR_NO        M
//	ITEM_CODE_01	  
//	SERI_NO_01
//	ITEM_CODE_02	  
//	SERI_NO_02
//	ITEM_CODE_03	  
//	SERI_NO_03
//	ITEM_CODE_04	  
//	SERI_NO_04
//	ITEM_CODE_05	  
//	SERI_NO_05
//	ITEM_CODE_06	  
//	SERI_NO_06
//	ITEM_CODE_07	  
//	SERI_NO_07
//	ITEM_CODE_08	  
//	SERI_NO_08
//	ITEM_CODE_09	  
//	SERI_NO_09
//	ITEM_CODE_10	  
//	SERI_NO_10

	if($("#oShipLoc").val() == ""){
		$.messager.alert('Warning','Please enter Warehouse.','warning');
		return;
	} else if($("#oActDate").val() == ""){
		$.messager.alert('Warning','Please enter Act. Ship Date.','warning');
		return;
	} else if($("#oPostDate").val() == ""){
		$.messager.alert('Warning','Please enter Ship Post Date.','warning');
		return;
	} else if($("#oSapPoNo").val() == ""){
		$.messager.alert('Warning','Please enter SAP PO No.','warning');
		return;
	} else if($("#oPoNo").val() == ""){
		$.messager.alert('Warning','Please enter PO No.','warning');
		return;
	} else if($("#oBolNo").val() == ""){
		$.messager.alert('Warning','Please enter BOL No.','warning');
		return;
	}
	
	$.ajax({
        url: getUrl('/common/user/sapinterface/outbSand.json'),
        dataType: "json",
        type: 'post',
        async: false,
        data : {
			shipLoc:    $("#oShipLoc").val()
		   ,actDate:    $("#oActDate").val()
		   ,postDate:   $("#oPostDate").val()
		   ,sapPoNo:    $("#oSapPoNo").val()
		   ,poNo:       $("#oPoNo").val()
		   ,bolNo:      $("#oBolNo").val()
		   ,assyNo:     $("#oAssyNo").val()
		   ,itemCode01: $("#oItemCode1").val()
		   ,seriNo01:   $("#oSeriNo1").val()
		   ,itemCode02: $("#oItemCode2").val()
		   ,seriNo02:   $("#oSeriNo2").val()
		   ,itemCode03: $("#oItemCode3").val()
		   ,seriNo03:   $("#oSeriNo3").val()
		   ,itemCode04: $("#oItemCode4").val()
		   ,seriNo04:   $("#oSeriNo4").val()
		   ,itemCode05: $("#oItemCode5").val()
		   ,seriNo05:   $("#oSeriNo5").val()
		   ,itemCode06: $("#oItemCode6").val()
		   ,seriNo06:   $("#oSeriNo6").val()
		   ,itemCode07: $("#oItemCode7").val()
		   ,seriNo07:   $("#oSeriNo7").val()
		   ,itemCode08: $("#oItemCode8").val()
		   ,seriNo08:   $("#oSeriNo8").val()
		   ,itemCode09: $("#oItemCode9").val()
		   ,seriNo09:   $("#oSeriNo9").val()
		   ,itemCode10: $("#oItemCode10").val()
		   ,seriNo10:   $("#oSeriNo10").val()
		},
        success: function(data){
        	console.log(data);
        	if(data.rows != undefined) {
        		var resultText = "";
        		resultText += "DELI NO SAP : " + data.rows.deliNoSap + "\n";
        		resultText += "RESULT : " + data.rows.grReltSap+"\n";
        		resultText += "MESSAGE : " + data.rows.grMeseSap;
        		$("#outbTextArea").val(resultText);
        	} else {
        		$.messager.alert('Information','System error, please contact IT manager!','error');
        	}
        },
        error: function(){
        	$.messager.alert('Information','System error, please contact IT manager!','error');
        }
    });
}

//저장 처리
function doSave() {
	var newPw = $('#newPw').val();
	var chkPw = $('#chkPw').val();

	if(newPw == chkPw){
		var saveParams = new FormData();
		saveParams.append("userId", $('#userId').val());
		saveParams.append("newPw", newPw);

		$.ajax({
	        url: getUrl('/common/sapinterface/save.json'),
	        dataType: 'json',
	        async: false,
			processData: false,
	        contentType: false,
	        type: 'post',
	        data: saveParams,
	        success: function(data){
	        	$.messager.alert('Information',msg.MSG0117,'info');
	        },
	        error: function(){
	        }
	    });
	}else{
		$.messager.alert('Warning',msg.MSG0123,'warning');
	}
}