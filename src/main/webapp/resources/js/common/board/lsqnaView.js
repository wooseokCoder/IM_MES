/**
 * LS Q&A 등록,수정을 처리하는 스크립트이다.
 */

//화면 컨트롤 객체
var consts = {};

$(function() {

	using("../../js/module/jupload.js", function() {
		using("../../js/module/jeditor.js", function() {
			using("../../js/module/jboard.js", function() {
				consts.init();
			});
		});
	});
});


$(window).load(function() {

	setTimeout(function (){
		
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keydown',function(events){
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

		$("#account-layout").fadeIn(300);

		//검색버튼 클릭시 이벤트 바인딩
//		$("#search-button").bind("click", doSearch);
//		//엑셀버튼 클릭시 이벤트 바인딩
//		$("#excel-button").bind("click", doExcel);
//		//삭제버튼 클릭시 이벤트 바인딩
//		$("#remove-button").bind("click", doRemove);
//		//추가버튼 클릭시 이벤트 바인딩
//		$("#append-button").bind("click", doAppend);
//		//저장버튼 클릭시 이벤트 바인딩
//		$("#save-button"  ).bind("click", doSave);
//		//초기화버튼 클릭시 이벤트바인딩
//		$("#dreload-button"  ).bind("click", doReload);

		//Enter 검색을 위한 추가
		$(".easyui-textbox").each(function(index, item){
			var itemid = $("#"+item.id);
			itemid.textbox('textbox').bind('keyup', function(e){
				itemid.textbox('setValue', $(this).val());
			});
		});

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

	doLangSettingTable();

});

$(window).load(function() {

	setTimeout(function (){

		//목록버튼 클릭시 이벤트 바인딩
		$("#list-button").bind("click",   jboard.doList);
		//수정버튼 클릭시 이벤트 바인딩
		//$("#update-button").bind("click", jboard.doUpdate);
		//if($("#hUserId").val() == $("#v_regiId").text()) $("#update-button").bind("click", doUpdate);
		if($("#hUserId").val() == $("#cUserId").val()) $("#update-button").bind("click", doUpdate);
		else $('#update-button').linkbutton("disable"); 
		//삭제버튼 클릭시 이벤트 바인딩
		//$("#remove-button").bind("click", jboard.doRemove);
		//if($("#hUserId").val() == $("#v_regiId").text()) $("#remove-button").bind("click", doRemove);
		if($("#hUserId").val() == $("#cUserId").val()) $("#remove-button").bind("click", doRemove);
		else $('#remove-button').linkbutton("disable"); 
		//답변버튼 클릭시 이벤트 바인딩
		$("#reply-button").bind("click", jboard.doReply);

		var replyArea = "";
		var regiId = "";
		
		$.ajax({
	        url: getUrl("/common/board/qna/reply.json"),
	        type: "POST",
	        dataType: "json",
	        data: { bordPno: $("#v_bordNo").val() },
	        success: function( data ) {
	        	if(!data || !data.rows){
	        		replyArea = "No reply."
	        	}else{
		        	$.map( data.rows, function( v, i ) {
		        		if($("#hUserId").val() == v.regiId) {
			        		replyArea += "<div class=\"reply-head\">"
			        				  	+ "<div class=\"reply-title\">Reply." + (i+1) + "</div>"
			        				  	+ "<span>"
			        				  	+ "<span class=\"reply-update\"><a href=\"javascript:doReplyModify('" + v.bordNo + "')\" class=\"easyui-linkbutton c6 l-btn l-btn-small replyBtn\" >Modify</a></span>" 
		        				 		+ "&nbsp;&nbsp;&nbsp;&nbsp;"
		        				 		+ "<span class=\"reply-update\"><a href=\"javascript:doReplyRemove('" + v.bordNo + "')\" class=\"easyui-linkbutton c6 l-btn l-btn-small replyBtn\" >Delete</a></span>"
		        				 		+ "</span>"
			        				  + "</div>"
			        					+ "<div class=\"reply-header\">"
			        				 		+ "<span class=\"reply-user\">" + v.regiName + "</span> | "
			        				 		+ "<span class=\"reply-date\">" + v.regiDate + "</span>" 
			        				 	+ "</div>"
			        				    + "<div class=\"reply-text\""
			        				    	+ "<div class=\"reply-text\">" + v.bordText + "</div>"
			        				    + "</div>"
		        		} else {
		        			replyArea += "<div class=\"reply-head\">"
			        				  	+ "<div class=\"reply-title\">Reply" + (i+1) + "</div>"
			        				  + "</div>"
		        						+ "<div class=\"reply-header\">"
			        				 		+ "<span class=\"reply-user\">" + v.regiName + "</span> | "
			        				 		+ "<span class=\"reply-date\">" + v.regiDate + "</span>" 
			        				 		+ "&nbsp;&nbsp;&nbsp;&nbsp;"
			        				 	+ "</div>"
			        				    + "<div class=\"reply-text\""
			        				    	+ "<div class=\"reply-text\">" + v.bordText + "</div>"
			        				    + "</div>"
		        		}
	  	            });
	        	}
	        	
	        	$('.reply-list').html(replyArea);
	        },
	        error: function (error) {
	           alert(error);
	        }
		});
		
		//$('#update-button').linkbutton("disable");
		
		doLangSettingTable();

	}, 500);

});

//화면컨트롤
consts = {
	title: false,      //제목
	url: {
		list:   getUrl("/common/board/lsqna/lsqna.do"),
		select: getUrl("/common/board/lsqna/select.json"),
		remove: getUrl("/common/board/lsqna/delete.json"),
		save:   getUrl("/common/board/lsqna/save.json"),
		form:   getUrl("/common/board/lsqna/form.do"),
		view:   getUrl("/common/board/lsqna/view.do"),
		reply:  getUrl("/common/board/lsqna/reply.json")
	},
	params: {
		oper:     jstatus.READ,
		sysId:    null,
		title:    null,
		bordNo:   null,
		bordGrup: null,
		bordType: null
	},
	init: function() {

		var rform = "select-form";
		var sform = "hidden-form";

		jboard.initView({
			consts: this,
			url:    this.url,
			params: this.params,
			title:  this.title,
			//편집 모드
			mode: "select",
			//목록폼 KEY
			listKey: "#"+sform,
			//등록폼 KEY (#포함)
			formKey: "#"+rform,
			//첨부파일 레이어 KEY
			layoutKey: "select-fileupload",
			//첨부파일 그리드 KEY
			gridKey: "files-grid",
			//Form Hidden Value 정의
			setHiddenValues: function(params) {
				$("#v_sysId"   ).val (params.sysId);
				$("#v_oper"    ).val (params.oper);
				$("#v_bordNo"  ).val (params.bordNo);
				$("#v_bordGrup").val (params.bordGrup);
				$("#v_bordType").val (params.bordType);
			}
		});
	},
	//저장,삭제 후 이동처리
	doResult: function(res, callback) {
		jboard.doList();
	}
};

//화면 상수값 초기화
function doInit(args) {
	if (args)
		$.extend(consts.params, args);
	if (args.title)
		consts.title = args.title;
}

function doReplyView(bordNo){
	$.ajax({
        url: getUrl("/common/board/qna/replyView.json"),
        type: "POST",
        dataType: "json",
        data: { bordNo: bordNo },
        success: function( data ) {
        	consts.viewData = data.rows[0];
    		$.extend(consts.params, data.rows[0]);
    		jboard.doSelect(data.rows[0]);
        },
        error: function (error) {
           alert(error);
        }
	});
}

function doReplyModify(bordNo){
	$.ajax({
        url: getUrl("/common/board/qna/replyView.json"),
        type: "POST",
        dataType: "json",
        data: { bordNo: bordNo },
        success: function( data ) {
        	consts.viewData = data.rows[0];
    		$.extend(consts.params, data.rows[0]);
    		$("#h_bordNo").val (bordNo);
    		jboard.doUpdate();
        },
        error: function (error) {
           alert(error);
        }
	});
}

function doReplyRemove(bordNo){
	$.messager.confirm(msg.MSG0123,msg.MSG0123, function(r) {
		if (!r){return;}

		$.ajax({
	        url: getUrl("/common/board/qna/replyView.json"),
	        type: "POST",
	        dataType: "json",
	        data: { bordNo: bordNo },
	        success: function( data ) {
	        	consts.viewData = data.rows[0];
	    		$.extend(consts.params, data.rows[0]);
	    		$("#v_oper").val (jstatus.DELETE);
	    		$("#v_bordNo").val (bordNo);
	    		jboard.doRemove();
	        },
	        error: function (error) {
	           alert(error);
	        }
		});
	});
}

function doUpdate() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	jboard.doUpdate();
}

function doRemove() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	jboard.doRemove();
}
