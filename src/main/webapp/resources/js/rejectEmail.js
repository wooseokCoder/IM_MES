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

	consts.init();
    $("#submit-button").bind("click", function(event) {
        doReject();
    });
    
    $("#cancle-button").bind("click", function(event) {
    	window.close();
    });
    
    
	doLangSettingPage();

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

function doReject() {
	
	if($("#Reason").val() != ''){
	    $.ajax({
	        url: getUrl('/common/password/RejectCheck.json'),
	        dataType: 'json',
	        async: true,
	        type: 'post',
	        data: {
			sysId : 'IMMES',
	        	bolNo :$("#bolNo").val(),
	        	Reason:$("#Reason").val()
	        },
	        success: function(data){
		      window.close();
	        },
	        error: function(){
	        }
	    });
	    
	    $.ajax({
	        url: getUrl('/common/password/RejectMail.json'),
	        dataType: 'json',
	        async: true,
	        type: 'post',
	        data: {
			sysId     : 'IMMES',
	        	userId    :$("#userId").val(),
	        	ftokenNo  :$("#ftokenNo").val(),
	        	Cmail     :$("#Cmail").val(),
	        	passTitle :$("#passTitle").val(),
	        	gpNo      :$("#gpNo").val(),
	        	bolNo     :$("#bolNo").val(),
	        	PassDate  :$("#PassDate").val(),
	        	PassTime  :$("#PassTime").val(),
	        	GateToUse :$("#GateToUse").val(),
	        	Reason    :$("#Reason").val()
	        },
	        success: function(data){
		      window.close();
	        },
	        error: function(){
	        }
	    });
	}else{
		if($("#gsLang").val() == "en"){
			$.messager.alert('Warning',"Please enter Reason.",'Warning');
			return false;
		}else if($("#gsLang").val() == "pt"){
			$.messager.alert('Warning',"Por favor insira o motivo.",'Warning');
			return false;
		}
		
	}
}