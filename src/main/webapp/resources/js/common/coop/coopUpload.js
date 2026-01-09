
var jupload_plugin = "uploader-3.1";
using("../" + jupload_plugin + "/css/uploadfile.css");

var jupload = {
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
			//title: tit.TITLE0035,
			//영문임시
			title: 'Attached file',
			url: obj.url.search,
			queryParams: obj.params,
			singleSelect:true,
			height: 182,
			width:'100%',//추가
			rownumbers: true,
			//fitColumns: true,
			//border:false,
			columns:[[
			    {field:'fileName',width:'50%',halign:'center',align:'left'  ,title:'File name',data_popup:'POP_GRD_999',
				    styler: function(value,row,index) {
				    	if(row.saveName.indexOf(".pdf") > 0){
				    		return 'text-decoration: underline; color: #642EFE; cursor: pointer;';
						}
			    	}
			    },
			    {field:'fileSize',width:'15%',halign:'center',align:'center' ,title:'File size',data_popup:'POP_GRD_998',
			    	formatter: function(value,row,index) {
			    		return jutils.formatFileSize(value);
			    	}
			    },
			    {field:'fileType',width:'15%',halign:'center',align:'center',title:'File type',data_popup:'POP_GRD_997'},
			    {field:'fileDown',width:'15%',halign:'center',align:'center',title:'Download',data_popup:'POP_GRD_996',
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
				}else if(field == 'fileName'){
					var rows = $(this).datagrid('getRows');
					var row  = rows[index];
					var url = 'http://dealerportal.lstractorusa.com/lsdp_data/upload/real'+row.filePath+'/'+row.saveName;
					if(row.saveName.indexOf(".pdf") > 0){
						window.open("pdf").location.href = url;
					}

				}

			}
			,onLoadSuccess:function(){
				doLangSettingPopTable();
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
	    	fileView: true,
	    	//showStatusAfterSuccess: true,
            statusBarWidth: '100%',
            dragdropWidth: '100%',
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
	        fileViewCallback:function(files, pbar) {
	        	var f = files[0];
	        	//obj.download(f.index);
				var url = 'http://dealerportal.lstractorusa.com/lsdp_data/upload/real'+f.filePath+'/'+f.saveName;
				 window.open(url,"fileView","width=700, height=700, menubar=no");
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
