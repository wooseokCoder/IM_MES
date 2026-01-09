/**
 * 사용자로그관리 처리하는 스크립트이다.
 *
 */
var consts = {
	sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
	title:    gconsts.TITLE,     //화면제목 (common.jsp)
	pageSize: gconsts.PAGE_SIZE, //출력수  (common.jsp)
	easygrid: false, //기본컨트롤

	url: {
		search: getUrl("/common/user/batchworkrevise/search.json"),
		excel:  getUrl("/common/user/batchworkrevise/download.do")
	}
,
	//초기화 함수(처음 화면 열릴 때)
	init: function() {

		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			//url:      this.url,
			url: {
				search:null,
				excel:  getUrl("/common/user/batchworkrevise/download.do")
			},
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});

		//그리드 생성
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'menuKey',
			onResize: doResize_Single,
			singleSelect: true,
			onLoadSuccess:function(){
				//검색 및 수정,삭제 이벤트 동작 후 그리드 선택행 초기화
				$("#search-grid").datagrid('unselectAll');
				$("#search-grid").datagrid('clearSelections');
			},
			onDblClickRow: doDblClickRow //그리드 더블클릭시 이벤트 바인딩
			
		});
	}
};

$(function() { //함수

	consts.init(); //초기화
	
	$('#progress-popup').dialog({ //액셀 팝업창
	       title: tit.TITLE0009,
	       top:     100,
	       width: 200,
	       height: 200,
	       closed: true,
	       modal: true,
	       resizable: false
	   });
	
	$('#add-popup').dialog({ //추가 팝업창
	       title: '신규(작업)',
	       iconCls: 'icon-search',
	       top:  10,
	       width: 500,
	       height: 370,
	       closed: true,
	       modal: true,
	       resizable: false
	   });
		
});

//해당 페이지의 모든 외부 리소스, 이미지 등이 로드 된 후에 처리가 됨.
$(window).load(function() {

	setTimeout(function (){ //0.1초 후 지연시간 뒤에 실행될 코드 
		
		// 화면 나타내기(0.3초)
		$("#account-layout").fadeIn(300); 
		//검색버튼 클릭시 이벤트 바인딩
		$("#search-button").bind("click", doSearch);		
		//추가 버튼 이벤트 바인딩
		$("#append-add-button").bind("click",doAppendJob);
		//팝업(추가)내 닫기 버튼 이벤트 바인딩
		$("#job-close-button").bind("click",doColseJob);
		//팝업(추가)내 저장 버튼 이벤트 바인딩
		$("#job-save-button").bind("click", function() { doSave('save'); });		
		//수정 버튼 이벤트 바인딩
		$("#append-revise-button").bind("click",doReviseJob);
		//엑셀버튼 클릭시 이벤트 바인딩
		$("#excel-button").bind("click", doExcel);
	
		
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

	doLangSettingTable(); //grid 가 있는 화면
	

});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}

//검색 처리
function doSearch() {
	//consts.easygrid.search();
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   } // 권한 설정
	consts.easygrid.search(consts.url.search);
}

// 추가 처리
function doAppendJob() {

	doClearJob();

	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   } // 권한 설정
	$('#add-popup').dialog('setTitle', '신규(작업)');
	$("#add-popup").dialog('center');
	$("#add-popup").dialog('open');
}

// 추가 팝업창 데이터 입력 전 클린 처리
function doClearJob() {
	
	var mn=$("#minutes").combobox("setValue","*");
	var hu=$("#hour").combobox("setValue","*");
	var dy=$("#day").combobox("setValue","*");
	var mo=$("#month").combobox("setValue","*");
	var we=$("#week").combobox("setValue","*"); // 콤보박스 값  *로 초기화
	
	mn=$("#minutes").combobox("getValue");
	hu=$("#hour").combobox("getValue");
	dy=$("#day").combobox("getValue");
	mo=$("#month").combobox("getValue");
	we=$("#week").combobox("getValue");  //초기화를 *로 했기에 현재값인 * 로 값을 가져온다
	
	var et=mn+(" ")+hu+(" ")+dy+(" ")+mo+(" ")+we;
	
	console.log(et);
		 
	$("#crud").val("i"); //i 는 insert의 약자 , crud는 id
	
	$("#jobId").textbox("setValue","");
	$("#jobGp").combobox("setValue",""); //set : ("공백")값을 넣는다
	$("#jobTm").combobox("setValue","");
	$("#jobType").combobox("setValue","");
	$("#minutes").combobox("setValue","*");
	$("#hour").combobox("setValue","*");
	$("#day").combobox("setValue","*");
	$("#month").combobox("setValue","*");
	$("#week").combobox("setValue","*");
	$("#etc").textbox("setValue",et);
	$("#jobCmd").textbox("setValue","");
	$("#jobDesc").textbox("setValue","");
	$("#errProc").combobox("setValue","");
	$("#useFlag").combobox("setValue","");
	$("#jobMng").textbox("setValue","");
	$("#jobRemk").textbox("setValue","");
	
}

//수정 처리
function doReviseJob() {
	
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   } // 권한 설정
	
	var row  = $('#search-grid').datagrid('getSelected'); //행을 선택
	if(!row){
		$.messager.alert('Warning',msg.MSG0114,'warning');
		return; //행을 선택하지 않으면 경고창 뜸
	}
	
	doRevJob(); //기존값 띄우기

	$('#add-popup').dialog('setTitle', '수정(작업)');
	$("#add-popup").dialog('center');
	$("#add-popup").dialog('open');
}

// 수정 팝업창에 기존값 띄우기
function doRevJob(row) {
	
	var row = $('#search-grid').datagrid('getSelected'); //행을 선택
	
	var jobTime = row.jobTime; //행에서 jobTime 값을 선택 후 jobTime에 넣어줌
	var jobTimeSplit = jobTime.split(' ');// 스페이스로 구분해서 데이터 자르기
	
	console.log(jobTimeSplit[0]);
	
	var jobTimeDoubleSplit1= jobTimeSplit[0].split(',');
	var jobTimeDoubleSplit2= jobTimeSplit[1].split(',');
	var jobTimeDoubleSplit3= jobTimeSplit[2].split(',');
	var jobTimeDoubleSplit4= jobTimeSplit[3].split(',');
	var jobTimeDoubleSplit5= jobTimeSplit[4].split(',');
	
	
	var minutes = jobTimeDoubleSplit1[0]; // 자른 값 = 배열 원소값
	var hour = jobTimeDoubleSplit2[0];
	var day = jobTimeDoubleSplit3[0];
	var month = jobTimeDoubleSplit4[0];
	var week = jobTimeDoubleSplit5[0];
	
	var crontab=jobTimeSplit[0]+(" ")+
				jobTimeSplit[1]+(" ")+
				jobTimeSplit[2]+(" ")+
				jobTimeSplit[3]+(" ")+
				jobTimeSplit[4]+(" ");
		
	$("#crud").val("u");//u는 update의 약자
	
	$("#jobId").textbox("setValue",row.jobId); //set : 값(row.jobId)을 넣는다
	$("#jobGp").combobox("setValue",row.jobGrup);
	$("#jobTm").combobox("setValue",row.jobTerm);
	$("#jobType").combobox("setValue",row.jobType);
	
	$("#minutes").combobox("setValue",minutes);
	$("#hour").combobox("setValue",hour);
	$("#day").combobox("setValue",day);
	$("#month").combobox("setValue",month);
	$("#week").combobox("setValue",week);
	$("#etc").textbox("setValue",crontab);
	
	$("#jobCmd").textbox("setValue",row.jobCmd);
	$("#jobDesc").textbox("setValue",row.jobDesc);
	$("#errProc").combobox("setValue",row.errProc);
	$("#useFlag").combobox("setValue",row.useFlag);
	$("#jobMng").textbox("setValue",row.jobMng);
	$("#jobRemk").textbox("setValue",row.jobRemk);
	
}

// CRONTAB 표기법 
function doExpressTime(newValue,oldValue)
{
	var min,hou,da,mon,week,cron
	
	min=$("#minutes").combobox("getValue"); //값을 가져온다
	hou=$("#hour").combobox("getValue");
	da=$("#day").combobox("getValue");
	mon=$("#month").combobox("getValue");
	wk=$("#week").combobox("getValue");
	
	cron=min+(" ")+hou+(" ")+da+(" ")+mon+(" ")+wk;
			
	$("#etc").textbox("setValue",cron); //텍스트 박스에 값 넣기
}


// 추가 팝업창 닫기
function doColseJob(state) {

	$("#add-popup").dialog('close');

	//console.log("isChange : " + isChange);
	//console.log("state : " + state);

	
}
//팝업창내 데이터 저장
function doSave() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
	      return false;
	   } //권한 설정
		
	var minutes=$("#minutes").combobox("getValue"); //데이터 선택된 콤보박스에서 값을 가져온다
	var hour=$("#hour").combobox("getValue");
	var day=$("#day").combobox("getValue");
	var month=$("#month").combobox("getValue");
	var week=$("#week").combobox("getValue");
	
	var jobTime=minutes+" "+hour+" "+day+" "+month+" "+week;
	
	$.ajax({ //JavaScript와 XML을 이용한 비동기적 정보 교환 기법
    	url: getUrl('/common/user/batchworkrevise/saveJob.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {crud:$("#crud").val() //insert 인지 update 인지 구분
        	  ,jobId:$("#jobId").textbox("getValue")
        	  ,jobGrup:$("#jobGp").combobox("getValue") // key(이름맘대로): value 형태
        	  ,jobTerm:$("#jobTm").combobox("getValue") //get : 값을 가져온다
        	  ,jobType:$("#jobType").combobox("getValue")
        	  ,jobTime:$("#etc").textbox("getValue")
        	  ,jobCmd:$("#jobCmd").textbox("getValue")
        	  ,jobDesc:$("#jobDesc").textbox("getValue")
        	  ,errProc:$("#errProc").combobox("getValue")
        	  ,useFlag:$("#useFlag").combobox("getValue")
        	  ,jobMng:$("#jobMng").textbox("getValue")
        	  ,jobRemk:$("#jobRemk").textbox("getValue")
        },
        success: function(data){
        	if(event != 'close') {
        		isSave = true;
        		$.messager.show({
        			title: 'Information',
        			msg: msg.MSG0103
        		});
        	}

        },
        error: function(){
        }
    });
	doColseJob();
	doSearch();
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

//그리드 더블클릭시 이벤트 바인딩
function doDblClickRow(idx, row) {
	if (!row)
		return;
	//다이얼로그 수정폼 오픈
	doReviseJob();
}
