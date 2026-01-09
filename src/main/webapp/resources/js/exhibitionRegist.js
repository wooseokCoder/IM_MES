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

$(window).load(function() {
	 doDateCheck();
	 getCouponInfo();
	 notAutoComplete();
//	 getStates();
//	 $("#save-button").bind("click", doSaveInfo);
	 $("#save-button").bind("click", doMailCheck);
	 $("#save-button2").bind("click", doMailCheck);
	 $("#save-button3").bind("click", doMailCheck);
	 $("#popup-button").bind("click", doClose);
	 $("#popup-button2").bind("click", doCheck);
	 
	 
});


$(function() {
	consts.init();
	// 메일 버튼에 클릭 이벤트를 바인딩한다.
    $("#submit-button").bind("click", function(event) {
        // 메일을 처리한다.
        doChangePassword();
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
	
}

function doChangePassword() {
	if ($("#username").val().isBlank()) {
        alert("Please enter your ID.");
        $("#username").focus();
        return false;
    }
    if ($("#email").val().isBlank()) {
        alert("Please enter your E-Mail.");
        $("#email").focus();
        return false;
    }
    
    $.ajax({
        url: getUrl('/common/password/emailCheck.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {sysId:'IMMES'
        	 , userId:$("#username").val()
        	 , email:$("#email").val()
        	 , mail_to:$("#email").val()
        	 , mail_cc:''
        	 , bordTitle:'Alerts - Your password has been changed.'
        	 , bordText:''},
        success: function(data){
        	if(data.rows != null){
        		$.messager.show({
          			title: 'Information',
          			msg: "Your password has been sent."
          		});
        		location.href=getUrl("/login.do");
        	}
        	else $.messager.alert('Warning',"Please check your ID or E-mail.",'Warning');
        },
        error: function(){
        }
    });
}


function getCouponInfo() {
	var code = $("#h_exhbnCode").val();
	$.ajax({
        url: getUrl('/getCouponInfo.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {code:code},
        success: function(data){
        	var rows = data.rows;
        	$("#coupon_code").text(rows.exhbnCode);
        	$("#coupon_date").text(rows.exhbnEndDate);
        },
        error: function(){
        }
    });
}

function doMailCheck() {
//	focusColrum();
	var code    = $("#h_exhbnCode").val();
	var email   = $("#email").val();
	
	$.ajax({
        url: getUrl('/getMailCheck.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {code  : code,
     	       email : email,
     	},
        success: function(data){
        	var rows = data.rows;
        	console.log(rows);
        	if(rows.result == 'N'){
        		text = "The coupon was issue for this e-mail";
        		doCheckOpen(text);
        		return;
        	}else{
        		doSaveInfo();
        	}
//        	
        },
        error: function(){
        }
	});
}

function doSaveInfo() {
	var code    = $("#h_exhbnCode").val();
	var name1   = $("#firstName").val();
	var name2   = $("#lastName").val();
	var phone   = $("#phone").val();
	var country = $("#country").val();
	var address = $("#addr").val();
	var city    = $("#city").val();
	var state  = $("#state").val();
	var zipCode = $("#zipCode").val();
	var email   = $("#email").val();
	var text;
	
	$("#h_exhbnCode").val(code);
	$("#firstName").val(name1);
	$("#lastName").val(name2);
	$("#phone").val(phone);
	$("#country").val(country);
	$("#addr").val(address);
	$("#city").val(city);
	$("#state").val(state);
	$("#zipCode").val(zipCode);
	$("#email").val(email);
	
	if(name1 == '' || name1.length < 1){
		text = "Please complete to insert the data";
		doCheckOpen(text);
		return;
	}

	if(name2 == '' || name2.length < 1){
		text = "Please complete to insert the data";
		doCheckOpen(text);
		return;
	}

	if(phone == '' || phone.length != 10){
		text = "Please insert correct telephone number";
		doCheckOpen(text);
		return;
	}

	if(country == ''){
		text = "Please complete to insert the data";
		doCheckOpen(text);
		return;
	}

	if(address == '' || address.length < 1){
		text = "Please complete to insert the data";
		doCheckOpen(text);
		return;
	}

	if(city == '' || city.length < 1){
		text = "Please complete to insert the data";
		doCheckOpen(text);
		return;
	}

	if(state == '' || state.length < 1){
		text = "Please complete to insert the data";
		doCheckOpen(text);
		return;
	}

	if(zipCode == '' || zipCode.length > 5){
		text = "Please insert correct zip code";
		doCheckOpen(text);
		return;
	}
	
	var check1 = email.split('@');
	if(check1.length != 2){
		text = "Please enter your email correctly.";
		doCheckOpen(text);
		return;
	}
	var check2 = check1[1].split('.');
	if(check2.length != 2 || check1[1].length == 0){
		text = "Please enter your email correctly.";
		doCheckOpen(text);
		return;
	}
	if(check2[1].length == 0){
		text = "Please enter your email correctly.";
		doCheckOpen(text);
		return;
	}
	
	$.ajax({
        url: getUrl('/getCouponCnt.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {code:code},
        success: function(data){
        	var rows = data.rows;
//        	console.log(rows);
//        	console.log(rows.couponYn);
        	if(rows.couponYn == 'Y'){
        		$('#background').css("display", "none");
        		$.ajax({
        	        url: getUrl('/saveCustInfo.json'),
        	        dataType: 'json',
        	        async: true,
        	        type: 'post',
        	        data: {code      :code,
        	        	   fristName :name1,
        	        	   lastName  :name2,
        	        	   phone     :phone,
        	        	   country   :country,
        	        	   addr      :address,
        	        	   city      :city,
        	        	   states    :state,
        	        	   zipCode   :zipCode,
        	        	   email     :email,
        	        },
        	        success: function(data){
        	        	var rows = data.rows;
        	        	console.log(data);
        	        	console.log(rows);
        	        	$('.popup_text').html("Thank you for your information.<br>We will send you the coupon to your mail");
                		$('#background').css("display", "inline-block");
                		$('.popup_box').css("display", "inline-block");
        	        },
        	        error: function(){
        	        }
        	    });
        	}else{
        		$('.popup_text').html("Our coupon was sold out,<br>Please contact LS Tractor Marketing team");				
        		$('#background').css("display", "inline-block");
        		$('.popup_box').css("display", "inline-block");
        	}
        },
        error: function(){
        }
	});
}


// 쿠폰 갯수 체크
function getCouponCnt() {
	var code = $("#h_exhbnCode").val();
//	console.log(code);
	$.ajax({
        url: getUrl('/getCouponCnt.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {code:code},
        success: function(data){
        	var rows = data.rows;
//        	console.log(rows);
//        	console.log(rows.couponYn);
        	if(rows.couponYn == 'Y'){
        		$('#background').css("display", "none");
        	}else{
        		$('#background').css("display", "inline-block");
        		$('.popup_box').css("display", "inline-block");
        	}
        },
        error: function(){
        }
    });
}

function doDateCheck(){
	var code = $("#h_exhbnCode").val();
	$.ajax({
        url: getUrl('/getCouponInfo.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {code:code},
        success: function(data){
        	var rows = data.rows;
        	//현재 날짜
        	var todayK = new Date();
        	todayK.getTime();
        	var todayA = new Date(todayK.getTime() - (840 * 60 * 1000));
        	var year = todayA.getFullYear();
        	var month = ('0' + (todayA.getMonth() + 1)).slice(-2);
        	var day = ('0' + todayA.getDate()).slice(-2);
        	var dateString = year + '-' + month  + '-' + day;
        	console.log(dateString);
        	console.log(todayK);
        	console.log(todayA);
        	console.log(rows.exhbnEndDate);
        	
        	if(rows.exhbnEndDate < dateString){
        		text = "Coupon expiration date has expired";
        		doCheckOpen(text);
        		$(".popup_btn_box").hide();
        	}else{
        		$('#background').css("display", "none");
        		getCouponCnt();
        	}
        },
        error: function(){
        }
    });
}

function doClose() {
	console.log("close");
//	var customWindow = window.open('', '_blank', '');
//    customWindow.close();
	window.open('','_self').close(); 
//	window.close();
}

function doCheckOpen(text) {
	$('#background').css("display", "inline-block");
	$('.popup_box').css("display", "inline-block");
	$('.popup_text').html(text);
	$('#popup-button').css("display", "none");
	$('#popup-button2').css("display", "inline-block");
}
function doCheck() {
	$('.popup_text').html("Our coupon was sold out,<br>Please contact LS Tractor Marketing team");
	$('#popup-button').css("display", "inline-block");
	$('#popup-button2').css("display", "none");
	$('#background').css("display", "none");
}

var state;
var country2 = '';
function getStates() {
	country2 = $("#country").val();
	$.ajax({
        url: getUrl('/getStates.json'),
        dataType: 'json',
        async: true,
        type: 'post',
        data: {
        	COUNTRY : country2
        },
        success: function(data){
        	var rows = data.rows;
//        	console.log(rows);
        	state = rows;
        	
        	var toOptionList = "<select  class='input_css' name='state' ID='state'>";
        	toOptionList += "<option value=''>Select</option>"
    		for(var i=0; i<state.length; i++){
    			toOptionList += "<option value='" + rows[i].codeCd + "'>" + rows[i].codeCd + "</option>"
    		}
        	
			$("#state").html(toOptionList);
			
        },
        error: function(){
        }
    });
	
}

function notAutoComplete() {
	$("#state").attr("autocomplete", "off");
}

function focusColrum() {
	$("#firstName").focus();
	$("#lastName").focus();
	$("#phone").focus();
	$("#country").focus();
	$("#addr").focus();
	$("#city").focus();
	$("#state").focus();
	$("#zipCode").focus();
	$("#email").focus();
	$("#email").blur();
}
