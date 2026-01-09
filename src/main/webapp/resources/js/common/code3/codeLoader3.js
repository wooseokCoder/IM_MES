/**
 * 코드엑셀로더를 처리하는 스크립트이다.
 * 
 * 단일파일 업로드
 * 업로드정보 편집저장
 */
var consts = {
	sysId: gconsts.SYS_ID, //시스템ID (common.jsp)
	title: gconsts.TITLE,  //화면제목 (common.jsp)
	easygrid: false, //기본컨트롤
	url: {
		search: null,
		upload: getUrl("/common/code3/loader/upload.json"),
		remove: getUrl("/common/code3/loader/save.json"),
		save:   getUrl("/common/code3/loader/save.json")
	},
	init: function() {
		
		//기본 컨트롤 컴포넌트 초기화
		this.easygrid = new jeasygrid({
			url:      this.url,
			title:    this.title,
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});
	
		//그리드 생성
		this.easygrid.init({
			fit:           true,
			pagination:   false,
			toolbar:      "#search-toolbar",
			singleSelect:  true,
			//그리드 편집이벤트 바인딩
			onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit 
		});
	},
	save: function() {
		
		//편집종료
		this.easygrid.endEdit();
		
		var rows = this.easygrid.getRows();
		
		if (rows == null ||
			rows.length == 0) {
			$.messager.alert('Warning',msg.MSG0121,'warning');
			return;
		}
		var data = {models: $.toJSON(rows)};
		
		jlogic.save({
			url: this.url.save,
			data: data,
			message: "Are you sure you want to save it?",
			success: function(response) {
				jlogic.result(response, function(res) {
					doClear();
				});
			}
		});
	},
	upload: function() {
		
	    //폼전송
	    $('#search-form').ajaxForm({
	    	url: this.url.upload,
	    	//보내기전 validation check가 필요할경우
	    	beforeSubmit: function () {
	    		if ($("#s_excelFile").val() == '') {
	    			$.messager.alert('Warning',msg.MSG0121,'warning');
	    			return false;
	    		}
	    		return true;
	    	},
	    	//submit이후의 처리
	    	success: function(data) {
	    		consts.easygrid.loadData(data);
	    	},
	        //ajax error
	        error: function() {
	        	alert("에러발생!!");
	        }
	    }).submit();
	}
};

$(function() {

	consts.init();
	
	//업로드버튼 클릭시 이벤트 바인딩
	$("#upload-button").bind("click", doUpload);
	//초기화버튼 클릭시 이벤트 바인딩
	$("#clear-button").bind("click", doClear);

	//저장버튼 클릭시 이벤트 바인딩
	$("#save-button").bind("click", doSave);
	//삭제버튼 클릭시 이벤트 바인딩
	$("#remove-button").bind("click", doRemove);

});

//화면 상수값 초기화
function doInit(args) {
	if (args) {
		$.extend(consts, args);
	}
}
//업로드 처리
function doUpload() {
	consts.upload();
}
//초기화 처리
function doClear() {
	consts.easygrid.reset();
	consts.easygrid.resetData();
}
//삭제 처리
function doRemove() {
	consts.easygrid.removeEdit();
}
//저장 처리
function doSave() {
	consts.save();
}
