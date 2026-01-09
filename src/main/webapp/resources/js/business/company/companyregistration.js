/**
 * 회사정보관리를 처리하는 스크립트이다.
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
		search: getUrl("/business/company/registration/search.json"),
		save:   getUrl("/business/company/registration/save.json")
	},
	init: function() {
		//등록폼 초기화
		doClear();
	}
};

$(function() {

	consts.init();
	doSearch();
	//검색버튼 클릭시 이벤트 바인딩
	$("#search-button").bind("click", doSearch);
	//저장버튼 클릭시 이벤트 바인딩
	$("#save-button").bind("click", doSave);
	
	doLangSettingTable();

});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
	
}

//초기화 처리
function doClear() {
	;
}

//검색처리
function doSearch(){
	var searchParams = new FormData();
	searchParams.append("searchCompCode"  , "0");
	
	var compCode = "";
	var compName = "";
	var compNameEN="";
	var compNameHAN="";
	var compNameALT="";
	var bizNo    = "";
	var ownName  = "";
	var bizClss  = "";
	var bizType  = "";
	var addrZip  = "";
	var addrMain = "";
	var compTel1 = "";
	var compFax  = "";
	var compHome = "";
	var setDate  = "";
	var ficsYear = "";
	var ficsJock = "";
	var settMnth = "";
	var taxRate  = "";
	var cashAcct = "";
	var compMark = "";
	var compSeal = "";
	var bottLogo = ""
	
	$.ajax({
        url: getUrl('/business/company/registration/search.json'),
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
        		compCode = item.compCode;
        		compName = item.compName;
        		compNameEN = item.compNameEN;
        		compNameHAN = item.compNameHAN;
        		compNameALT = item.compNameALT;
        		bizNo    = item.bizNo;
        		ownName  = item.ownName;
        		bizClss  = item.bizClss;
        		bizType  = item.bizType;
        		addrZip  = item.addrZip;
        		addrMain = item.addrMain;
        		compTel1 = item.compTel1;
        		compFax  = item.compFax;
        		compHome = item.compHome;
        		setDate  = item.setDate;
        		ficsYear = item.ficsYear;
        		ficsJock = item.ficsJock;
        		settMnth = item.settMnth;
        		taxRate  = item.taxRate;
        		cashAcct = item.cashAcct;
        		compMark = item.compMark;
        		compSeal = item.compSeal;
        		bottLogo = item.bottLogo;
            });

        	$('#r_compCode').val(compCode);
        	$('#r_compName').val(compName);
        	$('#r_compNameEN').val(compNameEN);
        	$('#r_compNameHAN').val(compNameHAN);
        	$('#r_compNameALT').val(compNameALT);
        	$('#r_bizNo'   ).val(bizNo);
        	$('#r_ownName' ).val(ownName);
        	$('#r_bizClss' ).val(bizClss);
        	$('#r_bizType' ).val(bizType);
        	$('#r_addrZip' ).val(addrZip);
        	$('#r_addrMain').val(addrMain);
        	$('#r_compTel1').val(compTel1);
        	$('#r_compFax' ).val(compFax);
        	$('#r_compHome').val(compHome);        	
        	$('#r_setDate' ).val(setDate);
        	$('#r_ficsYear').val(ficsYear);
        	$('#r_ficsJock').val(ficsJock);
        	$('#r_settMnth').val(settMnth);
        	$('#r_taxRate' ).val(taxRate);
        	$('#r_cashAcct').val(cashAcct);
        	/*$('#r_compMark').val(compMark);
        	$('#r_compSeal').val(compSeal);
        	$('#r_bottLogo').val(bottLogo);*/
        	$('#r_imgCompMark').attr("src", compMark);
        	$('#r_imgCompSeal').attr("src", compSeal);
        	$('#r_imgBottLogo').attr("src", bottLogo);
        	
        	//getUrl(
        },
        error: function(){
        }
    });
}

//저장 처리
function doSave() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	
	var compCode   = "";
	compCode = $('#r_compCode').val();
	var saveParams = new FormData();

	saveParams.append("compCode", compCode);
	saveParams.append("compName", $('#r_compName').val());
	saveParams.append("compNameEN", $('#r_compNameEN').val());
	saveParams.append("compNameHAN", $('#r_compNameHAN').val());
	saveParams.append("compNameALT", $('#r_compNameALT').val());
	saveParams.append("bizNo"   , $('#r_bizNo'   ).val());
	saveParams.append("ownName" , $('#r_ownName' ).val());
	saveParams.append("bizClss" , $('#r_bizClss' ).val());
	saveParams.append("bizType" , $('#r_bizType' ).val());
	saveParams.append("addrZip" , $('#r_addrZip' ).val());
	saveParams.append("addrMain", $('#r_addrMain').val());
	saveParams.append("compTel1", $('#r_compTel1').val());
	saveParams.append("compFax" , $('#r_compFax' ).val());
	saveParams.append("compHome", $('#r_compHome').val());	
	saveParams.append("setDate" , $('#r_setDate' ).val());
	saveParams.append("ficsYear", $('#r_ficsYear').val());
	saveParams.append("ficsJock", $('#r_ficsJock').val());
	saveParams.append("settMnth", $('#r_settMnth').val());
	saveParams.append("taxRate" , $('#r_taxRate' ).val());
	saveParams.append("cashAcct", $('#r_cashAcct').val());
	/*saveParams.append("compMark", $('#r_compMark').val());
	saveParams.append("compSeal", $('#r_compSeal').val());
	saveParams.append("bottLogo", $('#r_bottLogo').val());*/
	saveParams.append("compMark", "/company/"+compCode+"_mark");
	saveParams.append("compSeal", "/company/"+compCode+"_seal");
	saveParams.append("bottLogo", "/company/"+compCode+"_logo");

	if(compCode == "" || compCode == null){
		saveParams.append("oper", "I");
		
		$.ajax({
	        url: getUrl('/business/company/registration/save.json'),
	        dataType: 'json',
	        async: false,
			processData: false,
	        contentType: false,
	        type: 'post',
	        data: saveParams,
	        success: function(data){
	        	$.messager.alert('Information',msg.MSG0106,'info');
	        },
	        error: function(){
	        }
	    });
	}else{
		saveParams.append("oper", "U");
		
		$.ajax({
	        url: getUrl('/business/company/registration/save.json'),
	        dataType: 'json',
	        async: false,
			processData: false,
	        contentType: false,
	        type: 'post',
	        data: saveParams,
	        success: function(data){
/*	        	$.messager.alert('Information',msg.MSG0106,function(){
	        		location.reload();
	        	});*/
	        	
	        	$.messager.alert('Information',msg.MSG0106,function(event){
	        	    if (event){
	        	    	location.reload();
	        	    }
	        	});
	        },
	        error: function(){

	        }
	    });
	}
}

function doImgClick(fileId){
	$('#'+fileId).click();
}

function readURL(input, fileId){
	if(input.files && input.files[0]){
		var reader = new FileReader();
		reader.onload = function(e){
			$('#'+fileId).attr("src", e.target.result);
		}
		reader.readAsDataURL(input.files[0]);
		
		$('.'+fileId).hide();
		$('#'+fileId).fadeIn(300);
		
	}
}

$(document).ready(function(){
	
	$("#compMark").change(function(){
		readURL(this, "imgCompMark");
	});
	
	$("#compSeal").change(function(){
		readURL(this, "imgCompSeal");
	});
	
	$("#bottLogo").change(function(){
		readURL(this, "imgBottLogo");
	});
});