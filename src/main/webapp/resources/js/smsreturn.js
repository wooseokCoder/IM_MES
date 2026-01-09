var consts = {
	message: null,
	login: "sms-area"
};
function doInit(args) {
	$.extend(consts, args);

}


function doChngText(value) {
	var sms_contents = "";
	if(value == "00") $("#sms_contents").html("");
	else if(value == "01") {
		sms_contents = "고객님 AS가 접수되었습니다. 접수번호는 "+$("#shetNo").val()+"입니다.[인천측기]";
		$("#sms_contents").html(sms_contents);
	}
	else if(value == "02") {
		sms_contents = "고객님 AS 물건이 입고되었습니다.[인천측기]";
		$("#sms_contents").html(sms_contents);
	}
	else if(value == "03") {
		sms_contents = "고객님 AS 수리가 완료되었습니다.[인천측기]";
		$("#sms_contents").html(sms_contents);
	}
	else if(value == "04") {
		sms_contents = "고객님 입금 주실 계좌번호입니다.[인천측기]";
		$("#sms_contents").html(sms_contents);
	}
}


//문자 발송
function onPopUpSms() {
	var sms_return_value = $("#sms_return_value").val();
	$("#receive_number").val($("#tel").val());
	$('#smsType').combobox('loadData', [{value:"00",text:"-"},{value:"01",text:"접수등록문자"},{value:"02",text:"입고완료문자"},{value:"03",text:"수리완료문자"},{value:"04",text:"계좌번호문자"}]);
	$("#smsType").combobox('setValue', '00');

	if($("#receive_number").val()==="null"){
		$("#receive_number").val("");
	}
	if(sms_return_value =="1"){
		$.messager.alert(msg.MSG0121,msg.MSG0051,msg.MSG0121);
		return false;
		//window.close();
	}
	if(sms_return_value !="" && sms_return_value !="1" && sms_return_value !="null" ){
		$.messager.alert(msg.MSG0121,msg.MSG0111,msg.MSG0121);
		return false;
		//window.close();
	}
}


$(function() {

	var msg = consts.message;
	var url = window.location;

});
