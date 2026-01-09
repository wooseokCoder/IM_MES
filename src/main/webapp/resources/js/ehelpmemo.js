$(function() {
		$("#ehelp-save-button").bind("click", doEHelpSave);
		$("#ehelp-delete-button").bind("click", doEHelpRemove);
		 doMemoInit();
		 jQuery.fn.serializeObject = function() {
			  var obj = null;
			  try {
			    if ( this[0].tagName && this[0].tagName.toUpperCase() == "FORM" ) {
			      var arr = this.serializeArray();
			      if ( arr ) {
			        obj = {};
			        jQuery.each(arr, function() {
			          obj[this.name] = this.value;
			        });
			      }//if ( arr ) {
			 		}
			  }
			  catch(e) {alert(e.message);}
			  finally  {}

			  return obj;
			};

 });

function doMemoInit(){
	doLangSettingPopEHelpTable();
	setConfigEdit();
	var emenukey = $("#h_eHelpMenuKey").val();
    $.ajax({
        url: getUrl('/getHelpMemoList.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {emenukey:emenukey},
        success: function(data){
        	var config = {};
    		$.extend(config, {editorBox: "r_bordText",
				  editorForm: "regist-form",
				  editorLayer: "editor-area",
				  fileName: "files",
				  formKey: "#regist-form",
				  layoutKey: "regist-fileupload",
				  loaderKey: "uploader",
				  mode: "regist"});
        	if(data.rows.length > 0){
        		$("#h_atchNo").val(data.rows[0].bordNo);
            	$("#h_atchGrup").val(data.rows[0].bordGrup);
            	$("#r_bordNo").val(data.rows[0].bordNo);
            	config.params = {
        				atchGrup: data.rows[0].bordGrup,
        				atchNo:   data.rows[0].bordNo
        		};
            	Editor.modify({"content": data.rows[0].bordText});
            	$("#r_oper").val("U");
            	$('#ehelp-delete-button').linkbutton({disabled:false});
        	}else{
            	config.params = {
        				atchGrup: 'B11'
        		};
            	$("#r_oper").val("I");
            	$('#ehelp-delete-button').linkbutton({disabled:true});
        	}
    			juploadMemo.init(config);


        },
        error: function(){
        }
    });
	doLangSettingPopEHelpTable();
}

function doEHelpSave(){
	var objtest = juploadMemo.getFiles();
	//폼데이터
	var data = $("#tx_editor_form").serializeObject();

	//폼데이터 객체에 첨부파일 목록 추가(JSON)
	data['files'] = $.toJSON(objtest);
	//폼데이터 객체에 웹에디터 컨텐츠 추가
	data['bordText'] = Editor.getContent();

    var validator = new Trex.Validator();
    var content = Editor.getContent();
    if (!validator.exists(content)) {
    	$.messager.alert('Warning',msg.MSG0038,'warning');
        return false;
    }

	jlogic.save({
		url: getUrl("/saveMemo.json"),
		data: data,
		success: function(res) {
			doMemoInit();
		},
		message: "Are you sure you want to save it?"
	});

}

function doEHelpRemove(){
	var objtest = juploadMemo.getFiles();
	//폼데이터
	var data = $("#tx_editor_form").serializeObject();

	//폼데이터 객체에 첨부파일 목록 추가(JSON)
	data['files'] = $.toJSON(objtest);
	//폼데이터 객체에 웹에디터 컨텐츠 추가
	data['bordText'] = Editor.getContent();

	data['oper'] = "D";

	jlogic.save({
		url: getUrl("/deleteMemo.json"),
		data: data,
		success: function(res) {
			doMemoInit();
		},
		message: "Are you sure you want to save it?"
	});

}

function setConfigEdit(){
     var config = {
             txHost: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) http://xxx.xxx.com */
             txPath: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) /xxx/xxx/ */
             txService: 'sample', /* 수정필요없음. */
             txProject: 'sample', /* 수정필요없음. 프로젝트가 여러개일 경우만 수정한다. */
             initializedId: "", /* 대부분의 경우에 빈문자열 */
             wrapper:    "tx_trex_container", /* 에디터를 둘러싸고 있는 레이어 이름(에디터 컨테이너) */
             form:       'tx_editor_form'+"", /* 등록하기 위한 Form 이름 */
             //2016/10/31김영진 -- 해당 경로는 잘못된 경로
            txIconPath:  getUrl("/resources/jquery/daumeditor-7.5.9/images/icon/editor/"), /*에디터에 사용되는 이미지 디렉터리, 필요에 따라 수정한다. */
             txDecoPath:  getUrl("/resources/jquery/daumeditor-7.5.9/images/deco/contents/"), /*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
             //txIconPath:  context + "/resources/jquery/daumeditor-7.5.9/images/icon/editor/", /*에디터에 사용되는 이미지 디렉터리, 필요에 따라 수정한다. */
             //txDecoPath:  context + "/resources/jquery/daumeditor-7.5.9/images/deco/contents/", /*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
             canvas: {
                 exitEditor:{
                     /*
                     desc:'빠져 나오시려면 shift+b를 누르세요.',
                     hotKey: {
                         shiftKey:true,
                         keyCode:66
                     },
                     nextElement: document.getElementsByTagName('button')[0]
                     */
                 },
                 initHeight:382,
                 styles: {
                     color: "#123456", /* 기본 글자색 */
                     fontFamily: "굴림", /* 기본 글자체 */
                     fontSize: "10pt", /* 기본 글자크기 */
                     backgroundColor: "#fff", /*기본 배경색 */
                     lineHeight: "1.5", /*기본 줄간격 */
                     padding: "8px" /* 위지윅 영역의 여백 */

                 },
                 showGuideArea: false
             },
             events: {
                 preventUnload: false
             },
             sidebar: {
                 attachbox: {
                     show: true,
                     confirmForDeleteAll: true
                 }
             },
             size: {
                 //contentWidth: 700 /* 지정된 본문영역의 넓이가 있을 경우에 설정 */
            	/* contentHeight:200*/
             }
         };

     EditorJSLoader.ready(function(Editor) {
         editor = new Editor(config);
     });
 }

//파일 모듈을 따로 모듈 뺴는것
var juploadMemo = {
	url: {
		//첨부파일 검색 URL
		search: getUrl("/common/file/search.json"),
		//첨부파일 업로드 URL (임시저장)
		upload: getUrl("/common/file/upload.json"),
		//첨부파일 삭제 URL (임시저장파일 삭제)
		remove: getUrl("/common/file/remove.json"),
		//첨부파일 처리세션 종료
		complete: getUrl("/common/file/complete.json"),
		//첨부파일 다운로드 URL
		download: getUrl("/common/file/download.do")
	},
	//파일 검색조건
	params: {
		atchGrup: null,
		atchNo: null
	},
	mode      : "regist",         //업로드: "regist", 검색: "select"
	layoutKey : "fileupload",     //파일업로드영역 ID (필수)
	fileName  : "file",           //파일박스 NAME
	grid      : false,            //파일그리드객체
	gridKey   : "uploaded-files", //파일그리드 ID (필수)
	loader    : false,            //파일박스객체
	loaderKey : "uploadfile",     //파일업로드박스 ID
	loaderText: "Add Files",      //파일업로드버튼 명칭
	files     : [],               //보유한 파일데이터

	//저장대상파일목록 반환
	getFiles: function() {
		//alert('files length='+this.files.length);
		return this.files;
	},
	//기존파일 로딩
	loadFiles: function(loader) {

		var obj = this;

		obj.files = [];

    	$.ajax({
	    	cache: false,
		    url: this.url.search,
	    	dataType: "json",
	    	data: this.params,
		    success: function(data) {
		    	$.each(data.rows, function(i,d) {

		    		//조회상태 처리
		    		jstatus.read(d);

		    		loader.createProgress(d);
		    		obj.files.push(d);
		    	});
	        }
		});
	},

	//등록한파일 추가
	appendFiles: function(data) {
		var p = this;
		$.each(data, function(i,d) {
			//jcommon.printobject(d);
			jstatus.insert(d);
			p.files.push(d);
		});
	},
	//기존파일에서 삭제
	removeFiles: function(data) {

		//등록인 경우 파일만 삭제
		if (jstatus.isInsert(data)) {
			//물리적 임시파일 삭제
			$.ajax({
				url:  this.url.remove,
				data: {index: data.index}
			});

			for (var i=0; i<this.files.length; i++) {

				if (jstatus.isInsert(this.files[i]) == false)
					continue;

				if (this.files[i].saveName != data.saveName)
					continue;

				this.files.slice(i,1);
				break;
			}
		}
		//그외의 경우 나중에 처리
		else {
			for (var i=0; i<this.files.length; i++) {

				if (jstatus.isInsert(this.files[i]))
					continue;
				if (jstatus.isRemove(this.files[i]))
					continue;
				if (this.files[i].saveName != data.saveName)
					continue;

				//삭제상태 처리
				jstatus.remove(this.files[i]);
				break;
			}
		}
	},

	//파일업로드 관련 HTML 생성
	init: function(args) {
		if (args) {
			$.extend(this, args);
		}

		//검색인 경우
		if (this.mode == "select") {
			//파일그리드 생성
			this.grid = this.createGrid();
		}
		//등록인 경우
		else {
			//파일업로더 생성
			this.loader = this.createLoader();
		}
		//$("#startUpload").click(function()
		//{
		//			uploadObj.startUpload();
		//});
		return this;
	},
	//파일그리드 객체 생성
	/**
	 * BBUG.KWK
	 * 첨부파일 각가 컬럼명 크기 변경
	 */
	createGrid: function() {

		var obj = this;

		$("#"+obj.layoutKey).html(
			'<table id="'+obj.gridKey +'"></table>'
		);

		return $("#"+obj.gridKey).datagrid({
			title: "첨부파일",
			url: obj.url.search,
			queryParams: obj.params,
			singleSelect:true,
			height: 100,
			width:'100%',//추가
			rownumbers: true,
			//fitColumns: true,
			//border:false,
			columns:[[
			    {field:'fileName',width:'50%',align:'left'  ,title:'파일명',data_popup:'POP_GRD_999'},
			    {field:'fileSize',width:'15%',align:'right' ,title:'파일크기',data_popup:'POP_GRD_998',
			    	formatter: function(value,row,index) {
			    		return jutils.formatFileSize(value);
			    	}
			    },
			    {field:'fileType',width:'15%',align:'center',title:'파일타입',data_popup:'POP_GRD_997'},
			    {field:'fileDown',width: '15%',align:'center',title:'다운로드',data_popup:'POP_GRD_996',
			    	styler: function(value,row,index) {
		    			return {class:'icon-saveblack'};
			    	}
			    }
			]],
			onClickCell: function(index, field, value) {
				if (field == 'fileDown') {
					var rows = $(this).datagrid('getRows');
					var row  = rows[index];

					if (row.exist != true) {
						$.messager.alert("Error", msg.MSG0113, 'error');
						return;
					}
					obj.download(row.index);   //파일 다운
				}

			}
		});
	},
	//업로드파일 다운로드
	download: function(index) {
		var url = this.url.download+"?index="+index;
		window.location.href = url;
	},
	//파일업로드 객체 설정
	createLoader: function() {
		var obj = this;
		$("#"+obj.layoutKey).html(
			'<div id="'+obj.loaderKey +'">'+obj.loaderText+'</div>'
		);

	    return $("#"+obj.loaderKey).uploadFile({
	    	url:        obj.url.upload,
	    	fileName:   obj.fileName,
	    	formData:   obj.params,
	    	returnType: "json",
	    	multiple:   true,
	    	dragDrop:   true,
	    	//autoSubmit: true,
			showDelete: true,
	    	showCancel: true,
	    	showAbort:  false,
	    	showDone:   false,
	    	showProgress: true,
	    	//showStatusAfterSuccess: true,
            statusBarWidth: '95%',
            dragdropWidth: '95%',
	    	dragDropStr: "<span><b data-popup='POP_TXT_999'>Drag and drop files here.</b></span>",
	    	abortStr :   "Abort",
	    	cancelStr:   "Cancel",
	    	//doneStr  :   "Done",

	    	onSelect:function(files) {
	    	    //alert(files[0].name);
	    	    return true; //to allow file submission.
	    	},
	    	onSubmit:function(files) {
	    		//files : List of files to be uploaded
	    		//return false; to stop upload
	    	},
	    	onSuccess:function(files,data,xhr) {
	    		//files: list of files
	    		//data: response from server
	    		//xhr : jquer xhr object
	    		obj.appendFiles(data);
	    	},
	    	afterUploadAll:function() {
	    	},
	    	onError: function(files,status,errMsg) {
	    		alert('ERROR='+errMsg);
	    		//files: list of files
	    		//status: error status
	    		//errMsg: error message
	    	},
	        onLoad:function(o) {
	        	obj.loadFiles(o);
	        },
	        showDownload: true,
	        downloadCallback:function(files, pbar) {
	        	var f = files[0];
	        	obj.download(f.index);
	        },
	    	//파일업로드시 추가되는 데이터
	    	//maxFileSize:1024*100,
			//maxFileCount:10,
	    	//dynamicFormData: function() {
	    	//	var data ={ location:"INDIA"}
	    	//	return data;
	    	//},
	    	//multiDragErrorStr: "Drag & Drop 시 다중 파일은 허용되지 않습니다.",
	    	//extErrorStr:       "허용되지 않는 파일입니다. 확장자:",
	    	//sizeErrorStr:      "허용되는 최대 크기를 초과하였습니다. 최대크기:",
	    	//uploadErrorStr:    "업로드가 허용되지 않습니다.",
	    	//삭제버튼 클릭시 실행하는 함수
	    	deleteCallback: function (files, pbar) {

	    		$.each(files, function(i, f) {
	    			obj.removeFiles(f);
	    		});
	    		//pbar.statusbar.hide(); //You choice.
	    	}
	    });
	},
	//그리드 리셋
	//상위 문서 저장,삭제,리셋시 수행되는 함수
	clear: function() {
		var obj = this;
		$.ajax({
			url: obj.url.complete,
			success: function() {
				obj.search({});
			}
		});
	}
};