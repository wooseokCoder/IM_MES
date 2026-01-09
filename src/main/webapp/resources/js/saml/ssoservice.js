
var consts = {
	sysId:    gconsts.SYS_ID,    
	title:    gconsts.TITLE,     
	pageSize: gconsts.PAGE_SIZE, 
	easygrid: false, //기본컨트롤
	url: {
		//save:   getUrl("/common/code/save.json")
	},
	init: function() {
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			singleSelect: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			pagination: true,
			idField:  'ORDR_NO',
			rownumbers:	  false,
			onResize: doResize_Single, //2016/09/23 김영진 수정 --화면 사이즈 고정 이벤트
			onLoadSuccess:function(data){
				console.log(data);
				doLangSettingTable();
			}
		});
		doClear();
		// First time using function
		doLink();
	}
};

$(function() {

	consts.init();
	
	
//	$('#remote-dialog').dialog({
//		title: "SproutLoud Alert",
//	    top:     10,
//	    width: 500,
//	    height: 250,
//	    closed: true,
//	    modal: true,
//	    resizable: true
//	});
//	
//	$('#remote-dialog2').dialog({
//		title: "SproutLoud Alert",
//	    top:     10,
//	    width: 500,
//	    height: 250,
//	    closed: true,
//	    modal: true,
//	    resizable: true
//	});
});

$(window).load(function() {
	
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
		
		$(".wui-dialog").show();
		
		$('#remote-back-button').bind("click", doRemoteClose);

		
	}, 100);

	doLangSettingTable();


});


function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}


function doClear() {
}
function doRemoteClose(){
	 history.back();
//	$("#remote-dialog2").dialog('center');
//    $("#remote-dialog2").dialog('open');
}

//Submit login_data in form
function doForm(login_data,actionUrl) {
	
	console.log(login_data); 
	var form = document.getElementById("myForm");

    form.target = "_blank";
    form.action = actionUrl;


    var loginDataInput = document.getElementById("login_data");
    loginDataInput.value = login_data;
    console.log(loginDataInput.value); 


    form.submit();
}
function doLink() { 
	
	var jsonData = {
			username:$("#gsClientId").val(),
			password:$("#gsClientSecret").val(),
			tokenUrl:$("#gsTokenUrl").val(),
			assertion:$("#gsAssertion").val(),
			
};
	//ClientId ,ClientSecret
	console.log("Client : "+jsonData)

// Token generation
if($("#gsUserType").val() == 'Master') {
	$.ajax({
	    url:  getUrl("/common/board/sproutloudsso/getSproutloudToken2.json"),// URL of server-side controller
	    type: "POST",
	    dataType: "json",
	    async: false,
	    data: jsonData, 
	    success: function(result) {
	        console.log(result);
	        
	  	  var parsedData = JSON.parse(JSON.stringify(result));
	      var rowsString = parsedData.rows.replace(/\\/g, '');
	      var rows = JSON.parse(rowsString);
	  
	      // Resulting token_type and access_token
	      var token_type = rows.token_type;
	      var access_token = rows.access_token;
	      var tp_contact_id = $("#gsIdSproutLoud").val();
	      
	    //tp_contact_id
	      console.log("tp_contact_id : "+tp_contact_id);
	      
	  	 var jsonData1 = {
	  			token_type:token_type,
	  			access_token:access_token,
	  			tp_contact_id:tp_contact_id,
//	  			type:$("#gsType").val(),
//	  			first_name:$("#gsFirstName").val(),
//	  			last_name:$("#gsLastName").val(),
//	  			address1:$("#gsAddress1").val(),
//	  			city: $("#gsCity").val(),
//	  			region_code: $("#gsRegionCode").val(),
//	  			postal_code: $("#gsPostalCode").val(),
//	  			phone: $("#gsUserHp").val(),
//	  			email: $("#gsUserMail").val(),
//	  			target_url : $("#gsTargetUrl").val(),
	  			masterAccountId : $("#gsMasterAccountId").val(),
	  			masterHandUrl : $("#gsMasterHandUrl").val()
	     };
	      
			$.ajax({
		    url:  getUrl("/common/board/sproutloudsso/getSproutloudMaster2.json"),
		    type: "POST",
		    dataType: "json",
		    async: false,
		    data:jsonData1,
		    success: function(result) {
		        console.log(result);
		        try {
		    	  var parsedData = JSON.parse(JSON.stringify(result));
		          var rowsString = parsedData.rows.replace(/\\/g, '');
		          var rows = JSON.parse(rowsString);
		          
		          
		          var login_data = rows[0]._embedded.login_data;
		      	  var jsonData2 = {
					login_data :login_data
				};
		      	  var actionUrl = $("#gsSsoUrl").val();
		          doForm(login_data,actionUrl);
		        } catch (e) {
		        	$('.changePw-div').css('display', 'block');
		        	$("#alertPop").html($("#gsAlertMessage").val() +"&nbsp;&nbsp;&nbsp;"+ tp_contact_id+ "<br>" + $("#gsAlertMessage2").val());
//		        	$("#remote-dialog").dialog('center');
//			        $("#remote-dialog").dialog('open');
		        }
		    },
		    error: function(xhr, status, error) {
		        console.error(error);
		       
		    }
		});
			
	      
	    },
	    error: function(xhr, status, error) {
	        console.error(error);
	       
	    }
	});
}	
else {
	$.ajax({
	    url:  getUrl("/common/board/sproutloudsso/getSproutloudMeberToken.json"),// URL of server-side controller
	    type: "POST",
	    dataType: "json",
	    async: false,
	    data: jsonData, 
	    success: function(result) {
	        console.log(result);
	        
	  	  var parsedData = JSON.parse(JSON.stringify(result));
	      var rowsString = parsedData.rows.replace(/\\/g, '');
	      var rows = JSON.parse(rowsString);
	  
	      // Resulting token_type and access_token
	      var token_type = rows.token_type;
	      var access_token = rows.access_token;
	      var tp_contact_id = $("#gsIdSproutLoud").val();
	      
	    //tp_contact_id
	      console.log("tp_contact_id : "+tp_contact_id);
	      
	  	 var jsonData1 = {
	  			token_type:token_type,
	  			access_token:access_token,
	  			tp_contact_id:tp_contact_id,
	  			type:$("#gsType").val(),
	  			first_name:$("#gsFirstName").val(),
	  			last_name:$("#gsLastName").val(),
	  			address1:$("#gsAddress1").val(),
	  			city: $("#gsCity").val(),
	  			region_code: $("#gsRegionCode").val(),
	  			postal_code: $("#gsPostalCode").val(),
	  			phone: $("#gsUserHp").val(),
	  			email: $("#gsUserMail").val(),
	  			target_url : $("#gsTargetUrl").val(),
	  			masterAccountId : $("#gsMasterAccountId").val(),
	  			sproutKey : $("#gsSproutKey").val(),
	  			tp_account_id : $("#gsMemberAccountId").val(),
	  			company_name : $("#gsCompanyName").val(),
	  			memberHandUrl : $("#gsMemberHandUrl").val()
	     };
	      
			$.ajax({
		    url:  getUrl("/common/board/sproutloudsso/getSproutloudMember.json"),
		    type: "POST",
		    dataType: "json",
		    async: false,
		    data:jsonData1,
		    success: function(result) {
		        console.log(result);
		        
		    	  var parsedData = JSON.parse(JSON.stringify(result));
		          var rowsString = parsedData.rows.replace(/\\/g, '');
		          var rows = JSON.parse(rowsString);
		          
		          
		          var login_data = rows._embedded.login_data;
		      	  var jsonData2 = {
					login_data :login_data
				};
		      	  var actionUrl = $("#gsSsoUrl").val();
		      	  
		          doForm(login_data,actionUrl);
		
		    },
		    error: function(xhr, status, error) {
		        console.error(error);
		       
		    }
		});
			
	      
	    },
	    error: function(xhr, status, error) {
	        console.error(error);
	       
	    }
	});
}
	
	

	
}
 
