/**
 * PDI UPDATE를 처리하는 스크립트이다.
 *
 * 그리드 검색 및 페이징
 * 폼 패널 상세조회
 * 폼 패널 등록,수정,삭제
 */


var constsPdi = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
	easygrid: false
};

//화면 상수값 초기화
function doInitPdi(args) {
	if (args) {
		$.extend(constsPdi, args);
	}
}

function doPdiUpdate(ordr_no, assy_no, type, val, val2, val3, val4, val5, val6, val7, val8, val9, val10, val11, val12) {
	
    if(assy_no === undefined || assy_no == ''){
    	assy_no = '';
    }
    if(val === undefined  || val == '')  val = ''; 
    if(val2 === undefined || val2 == '') val2 = ''; 
    if(val3 === undefined || val3 == '') val3 = ''; 
    if(val4 === undefined || val4 == '') val4 = ''; 
    if(val5 === undefined || val5 == '') val5 = ''; 
    if(val6 === undefined || val6 == '') val6 = ''; 
    if(val7 === undefined || val7 == '') val7 = ''; 
    if(val8 === undefined || val8 == '') val8 = ''; 
    if(val9 === undefined || val9 == '') val9 = ''; 
    if(val10 === undefined || val10 == '') val10 = ''; 
    if(val11 === undefined || val11 == '') val11 = '';
    if(val12 === undefined || val12 == '') val12 = ''; 
    
    var userId = $("#gsUserId").val();
    console.log('call userId: '+userId+' ordr_no: ' + ordr_no + ' assy_no: ' + assy_no 
    		+ ' type: ' + type+' val: ' + val +' val2: ' + val2 +' val3: ' + val3 +' val4: ' + val4+' val5: ' + val5
            + ' val6: ' + val6 +' val7: ' + val7 +' val8: ' + val8 +' val9: ' + val9+' val10: ' + val10+' val11: ' + val11+' val12: ' + val12);

	$.ajax({
		url: getUrl("/common/ftk/apiCall.json"),
	    dataType: 'json',
	    async: false,
	    type: 'post',
	    data: {userId  : userId,
	    	   ordr_no : ordr_no,
	    	   assy_no : assy_no,
	    	   type    : type,
	    	   val     : val,
	    	   val2    : val2,
	    	   val3    : val3,
	    	   val4    : val4,
	    	   val5    : val5,
	    	   val6    : val6,
	    	   val7    : val7,
	    	   val8    : val8,
	    	   val9    : val9,
	    	   val10   : val10,
	    	   val11   : val11,
	    	   val12   : val12
	    },
	    success: function(data){
	    	if(data.rows == undefined || data.rows.indexOf("SUCCESS") == -1){
	    		//$.messager.alert('Error','WGBC SYSTEM Update Fail!!','warning');
	    	}
	    },
	    error: function(){
	    },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
        }
	});
}

function doPdiSelect(ordr_no, api_key, type, val, val2, val3, val4, val5, val6, val7, val8, val9, val10, val11, val12) {
	
    if(api_key === undefined || api_key == ''){
    	return;
    }
    if(val === undefined  || val == '')  val = ''; 
    if(val2 === undefined || val2 == '') val2 = ''; 
    if(val3 === undefined || val3 == '') val3 = ''; 
    if(val4 === undefined || val4 == '') val4 = ''; 
    if(val5 === undefined || val5 == '') val5 = ''; 
    if(val6 === undefined || val6 == '') val6 = ''; 
    if(val7 === undefined || val7 == '') val7 = ''; 
    if(val8 === undefined || val8 == '') val8 = ''; 
    if(val9 === undefined || val9 == '') val9 = ''; 
    if(val10 === undefined || val10 == '') val10 = ''; 
    if(val11 === undefined || val11 == '') val11 = '';
    if(val12 === undefined || val12 == '') val12 = '';
    
    var userId = $("#gsUserId").val();
    /*console.log('call userId: '+userId+' ordr_no: ' + ordr_no + ' api_key: ' + api_key 
    		+ ' type: ' + type+' val: ' + val +' val2: ' + val2 +' val3: ' + val3 +' val4: ' + val4+' val5: ' + val5
            + ' val6: ' + val6 +' val7: ' + val7 +' val8: ' + val8 +' val9: ' + val9+' val10: ' + val10+' val11: ' + val11);*/
    var apiData;
	$.ajax({
		url: getUrl("/common/ftk/apiKeyCall.json"),
	    dataType: 'json',
	    async: false,
	    type: 'post',
	    data: {userId  : userId,
	    	   ordr_no : ordr_no,
	    	   api_key : api_key,
	    	   type    : type,
	    	   val     : val,
	    	   val2    : val2,
	    	   val3    : val3,
	    	   val4    : val4,
	    	   val5    : val5,
	    	   val6    : val6,
	    	   val7    : val7,
	    	   val8    : val8,
	    	   val9    : val9,
	    	   val10   : val10,
	    	   val11   : val11,
	    	   val12   : val12
	    },
	    success: function(data){
	    	apiData = data;
	    },
	    error: function(){
	    },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
        }
	});
	return apiData;
}

//orderprogress bol shipping 공통
//pdi랑 상관없음

//////////////start///////////////////////
function openPoList(){

	$("#poNoList-dialog").dialog('center');
	$("#poNoList-dialog").dialog('open');
}

function deletePoList(){
	$("#s_poNo").val('');
	$('#h_poList').val('');
	
	$('#list-button').css('background-color', 'white');
	$('#poNoList-dialog').dialog('close');
}

function savePoList(){
	var poText = $("#s_poNo").val();
	/*var poText1 = poText.replace(/\s/gi, "");     // 위와 같이 모든 공백을 제거
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
	var poText2 = poText1.replace(regExp, "");
	var regExp = /^[A-Z]{2}\d{10}$/;*/
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
	var poText1 = poText.replace(regExp, "");
	var poText2 = poText1.replace(/\s/gi, ",");     // 모든 공백을 , 치환
	var regExp = /^[A-Z]{2}\d{10}$/;
	var regExp2 = /^[A-Z]{2}\d{10}[A-Z]{1}$/;
	
	var ngFlg = true;
	var ponoList;
	/*
	for(var i=0; i<poText2.length; i+=12){
		var pono = poText2.substr(i,12);
		if(regExp.test(pono)){
			if (ponoList == null){
				ponoList = pono;
			} else {
				ponoList = ponoList + "," + pono;
			}
		} else{
			ngFlg = false;
		}
    }
	*/
	var _ponoList = poText2.split(',');
	for(var i=0; i<_ponoList.length; i++){
		var pono = _ponoList[i];
		if(pono.length == 12) {
			if(regExp.test(pono)){
				if (ponoList == null){
					ponoList = pono;
				} else {
					ponoList = ponoList + "," + pono;
				}
			} else{
				ngFlg = false;
			}
		} else if(pono.length == 0) {
			
		} else {
			if(regExp2.test(pono)){
				if (ponoList == null){
					ponoList = pono;
				} else {
					ponoList = ponoList + "," + pono;
				}
			} else{
				ngFlg = false;
			}
		}
    }
	
	if(ngFlg == false || ponoList === undefined){
		$('#h_poList').val('');
		alert('The wrong number was entered!!');
		$('#list-button').css('background-color', 'white');
	}else{
		$('#h_poList').val(ponoList);
		$('#list-button').css('background-color', '#9e9c9c');
		$('#poNoList-dialog').dialog('close');
	}

}

function openSapList(){
    $("#sapNoList-dialog").dialog('center');
	$("#sapNoList-dialog").dialog('open');
}

function deleteSapList(){
	$("#s_sapNo").val('');
	$('#h_sapList').val('');
	
	$('#sap-list-button').css('background-color', 'white');
	$('#sapNoList-dialog').dialog('close');
}

function saveSapList(){
	
	var poText = $("#s_sapNo").val();
	var poText1 = poText.replace(/\s/gi, "");     // 위와 같이 모든 공백을 제거
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
	var poText2 = poText1.replace(regExp, "")
	var regExp = /^\d{10}$/;
	
	var ngFlg = true;
	var sapnoList;
	
	for(var i=0; i<poText2.length; i+=10){
		var pono = poText2.substr(i,10);
		if(regExp.test(pono)){
			if (sapnoList == null){
				sapnoList = pono;
			} else {
				sapnoList = sapnoList + "," + pono;
			}
		} else{
			ngFlg = false;
		}
    }

	if(ngFlg == false || sapnoList === undefined){
		$('#h_sapList').val('');
		alert('The wrong number was entered!!');
		$('#sap-list-button').css('background-color', 'white');
	}else{
		$('#h_sapList').val(sapnoList);
		$('#sap-list-button').css('background-color', '#9e9c9c');
		$('#sapNoList-dialog').dialog('close');
	}

}

function doLogiSelect(bol_no, api_key, type, val, val2, val3, val4, val5, val6, val7, val8, val9, val10, val11, val12, val13, val14, val15) {
	
    if(api_key === undefined || api_key == ''){
    	return;
    }
    if(val === undefined  || val == '')  val = ''; 
    if(val2 === undefined || val2 == '') val2 = ''; 
    if(val3 === undefined || val3 == '') val3 = ''; 
    if(val4 === undefined || val4 == '') val4 = ''; 
    if(val5 === undefined || val5 == '') val5 = ''; 
    if(val6 === undefined || val6 == '') val6 = ''; 
    if(val7 === undefined || val7 == '') val7 = ''; 
    if(val8 === undefined || val8 == '') val8 = ''; 
    if(val9 === undefined || val9 == '') val9 = ''; 
    if(val10 === undefined || val10 == '') val10 = ''; 
    if(val11 === undefined || val11 == '') val11 = '';
    if(val12 === undefined || val12 == '') val12 = '';
    if(val13 === undefined || val13 == '') val13 = '';
    if(val14 === undefined || val15 == '') val14 = '';
    if(val15 === undefined || val15 == '') val15 = '';
    
    
    var userId = $("#gsUserId").val();
    /*console.log('call userId: '+userId+' ordr_no: ' + ordr_no + ' api_key: ' + api_key 
    		+ ' type: ' + type+' val: ' + val +' val2: ' + val2 +' val3: ' + val3 +' val4: ' + val4+' val5: ' + val5
            + ' val6: ' + val6 +' val7: ' + val7 +' val8: ' + val8 +' val9: ' + val9+' val10: ' + val10+' val11: ' + val11);*/
    var apiData;
	$.ajax({
		url: getUrl("/common/ftk/apiLogiKeyCall.json"),
	    dataType: 'json',
	    async: false,
	    type: 'post',
	    data: {userId  : userId,
	    	   bol_no  : bol_no,
	    	   api_key : api_key,
	    	   type    : type,
	    	   val     : val,
	    	   val2    : val2,
	    	   val3    : val3,
	    	   val4    : val4,
	    	   val5    : val5,
	    	   val6    : val6,
	    	   val7    : val7,
	    	   val8    : val8,
	    	   val9    : val9,
	    	   val10   : val10,
	    	   val11   : val11,
	    	   val12   : val12,
	    	   val13   : val13,
	    	   val14   : val14,
	    	   val15   : val15
	    },
	    success: function(data){
	    	apiData = data;
	    },
	    error: function(){
	    },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
        }
	});
	return apiData;
}

function doAssySelect(ordr_no, api_key, type, val, val2, val3, val4, val5, val6, val7, val8, val9, val10, val11, val12, val13, val14, val15) {
	
    if(api_key === undefined || api_key == ''){
    	return;
    }
    if(val === undefined  || val == '')  val = ''; 
    if(val2 === undefined || val2 == '') val2 = ''; 
    if(val3 === undefined || val3 == '') val3 = ''; 
    if(val4 === undefined || val4 == '') val4 = ''; 
    if(val5 === undefined || val5 == '') val5 = ''; 
    if(val6 === undefined || val6 == '') val6 = ''; 
    if(val7 === undefined || val7 == '') val7 = ''; 
    if(val8 === undefined || val8 == '') val8 = ''; 
    if(val9 === undefined || val9 == '') val9 = ''; 
    if(val10 === undefined || val10 == '') val10 = ''; 
    if(val11 === undefined || val11 == '') val11 = '';
    if(val12 === undefined || val12 == '') val12 = '';
    if(val13 === undefined || val13 == '') val13 = '';
    if(val14 === undefined || val15 == '') val14 = '';
    if(val15 === undefined || val15 == '') val15 = '';
    
    
    var userId = $("#gsUserId").val();
    /*console.log('call userId: '+userId+' ordr_no: ' + ordr_no + ' api_key: ' + api_key 
    		+ ' type: ' + type+' val: ' + val +' val2: ' + val2 +' val3: ' + val3 +' val4: ' + val4+' val5: ' + val5
            + ' val6: ' + val6 +' val7: ' + val7 +' val8: ' + val8 +' val9: ' + val9+' val10: ' + val10+' val11: ' + val11);*/
    var apiData;
	$.ajax({
		url: getUrl("/common/ftk/apiKeyCall2.json"),
	    dataType: 'json',
	    async: false,
	    type: 'post',
	    data: {userId  : userId,
	           ordr_no : ordr_no,
	    	   api_key : api_key,
	    	   type    : type,
	    	   val     : val,
	    	   val2    : val2,
	    	   val3    : val3,
	    	   val4    : val4,
	    	   val5    : val5,
	    	   val6    : val6,
	    	   val7    : val7,
	    	   val8    : val8,
	    	   val9    : val9,
	    	   val10   : val10,
	    	   val11   : val11,
	    	   val12   : val12,
	    	   val13   : val13,
	    	   val14   : val14,
	    	   val15   : val15
	    },
	    success: function(data){
	    	apiData = data;
	    },
	    error: function(){
	    },
        complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
        }
	});
	return apiData;
}
//////////////end///////////////////////
