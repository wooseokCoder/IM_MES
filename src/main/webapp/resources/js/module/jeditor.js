var jeditor_root   = context + "/resources/jquery/";
var jeditor_plugin = false;
var jeditor_consts = "DM"; //CK:CKEDITOR, SC:SCEDITOR, DM: DAUMEDITOR
var jeditor_file1  = false;
var jeditor_file2  = false;
var jeditor        = false;
var jdaumeditor    = false;

if (jeditor_consts == "CK") {
	jeditor_plugin = "ckeditor-4.4.7";
	jeditor_file1  = "../" + jeditor_plugin + "/ckeditor.js";
	jeditor_file2  = "../" + jeditor_plugin + "/adapters/jquery.js";
	//using("../" + jeditor_plugin + "/ckeditor.js");
	//using("../" + jeditor_plugin + "/adapters/jquery.js");
}
else if (jeditor_consts == "SC") {
	jeditor_plugin = "sceditor-1.4.5";
	jeditor_file1  = "../" + jeditor_plugin + "/development/themes/default.css";
	jeditor_file2  = "../" + jeditor_plugin + "/development/jquery.sceditor.bbcode.js";
	//using("../" + jeditor_plugin + "/minified/themes/default.min.css");
	//using("../" + jeditor_plugin + "/minified/jquery.sceditor.bbcode.min.js");
}
else if (jeditor_consts == "DM") {
	jeditor_plugin = "daumeditor-7.5.9";
	jeditor_file1  = "../" + jeditor_plugin + "/css/editor.css";
	jeditor_file2  = "../" + jeditor_plugin + "/js/editor_loader.js";
	//using("../" + jeditor_plugin + "/css/editor.css");
	//using("../" + jeditor_plugin + "/js/editor_loader.js"); /*?environment=development*/
	//using("http://google-code-prettify.googlecode.com/svn/trunk/src/prettify.js");
}
else if (jeditor_consts == "SN") {
	jeditor_plugin = "summernote-master";
	jeditor_file1  = "../" + jeditor_plugin + "/dist/summernote.css";
	jeditor_file2  = "../" + jeditor_plugin + "/dist/summernote.js";
}

using(jeditor_file1, function() {
	using(jeditor_file2, function() {
		
		jeditor = function(args) {

			//[WSC2.0] [2015.04 LSH] 웹에디터 설정 추가
			//editorLayer: "editor-area" => 웹에디터 레이어 ID
			//editorBox:   "r_bordText"  => 웹에디터 텍스트박스 ID
			//editorForm:  "regist-form" => 웹에디터 폼 ID
		
			var layer  = args.editorLayer;
			var boxId  = args.editorBox;
			var formId = args.editorForm;
			
			var editor = false;
			var get    = function() { return false; };
			var set    = function(contents) {};
			
			if (jeditor_consts == "CK") {
				CKEDITOR.disableAutoInline = true;
				
				editor = CKEDITOR.replace( boxId );
				//editor = $("#"+boxId).ckeditor();
				
				get = function() {
					return editor.getData();
				};
				set = function(contents) {
					//editor.setData(contents);
				};
			}
			else if (jeditor_consts == "SC") {
				$("#"+boxId).sceditor({
					plugins:       "bbcode",
					height:        340,
					emoticonsRoot: jeditor_root + jeditor_plugin + "/",
					style:         jeditor_root + jeditor_plugin + "/minified/jquery.sceditor.default.min.css"
				});
				editor = $("#"+boxId).sceditor('instance');
				
				get = function() {
					var contents = editor.val();
					return editor.fromBBCode(contents, true);
				};
				set = function(contents) {
					var bbcode = editor.toBBCode(contents);
					editor.val(bbcode);
				};
			}
			else if (jeditor_consts == "DM") {
		
				//에디터템플릿 로드
				editor = jdaumeditor.load(args);

				var layer  = args.editorLayer;
				var boxId  = args.editorBox;
				var formId = args.editorForm;

				get = function() {
					return Editor.getContent();
				};
				set = function(contents) {
					Editor.modify({"content": contents});
				};
			}
			else if (jeditor_consts == "SN") {
				editor = $("#"+boxId).summernote({
					height: 225
				});
				
				get = function() {
					return $("#"+boxId).summernote('code');
				};
				set = function(contents) {
					$("#"+boxId).summernote('code', contents);
				};
			}
			this.get = get;
			this.set = set;
			
			return this;
		};
		
		//DAUMEDITOR
		jdaumeditor = {
			root: jeditor_root+ jeditor_plugin,
			editor: false,
			//다음에디터 탬플릿 로드
			load: function(args) {
				$.ajax({
			        type:"POST", 
			        async: false,
			        url: jdaumeditor.root+"/editor_template.html",
			        success: function(data) {
			        	
			        	jdaumeditor.init(data, args.editorLayer, args.editorForm);
			        },
			        error: function(request, status, error) {
						alert("에러");
					}
				});
				return jdaumeditor.editor;
			},
			//다음에디터 초기화
			init: function(data, editorLayer, editorForm) {
				
				//링크정보 변경
				var d = data.replace(/{rootPath}/gi, jdaumeditor.root);
				
		    	$("#"+editorLayer).html(d);
				//에디터 설정정보 가져오기
				var config = jdaumeditor.getConfig({form: editorForm});
				
				try {
					EditorJSLoader.ready(function(Editor) {
						jdaumeditor.editor = new Editor(config);
						//2016/12/21 김영진 -- 수정 팝업창 화면 크기 조절
						//Editor.getCanvas().setCanvasSize({height:360});
						//Editor.getCanvas().setCanvasSize({height:260});
					});
				} catch(e) {}
			},
			//다음에디터 설정정보 가져오기
			getConfig: function(args) {
				
				var config = {
					txHost: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) http://xxx.xxx.com */
					txPath: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) /xxx/xxx/ */
					txService: 'sample', /* 수정필요없음. */
					txProject: 'sample', /* 수정필요없음. 프로젝트가 여러개일 경우만 수정한다. */
					initializedId: "", /* 대부분의 경우에 빈문자열 */
					wrapper:    "tx_trex_container", /* 에디터를 둘러싸고 있는 레이어 이름(에디터 컨테이너) */
					form:       'tx_editor_form'+"", /* 등록하기 위한 Form 이름 */
					txIconPath: jdaumeditor.root + "/images/icon/editor/", /*에디터에 사용되는 이미지 디렉터리, 필요에 따라 수정한다. */
					txDecoPath: jdaumeditor.root + "/images/deco/contents/", /*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
					canvas: {
			            
						minHeight:100,
						maxHeight:500,
						initHeight:225,
						autoSize:true,
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
			            
						styles: {
							color: "#123456", /* 기본 글자색 */
							fontFamily: "굴림", /* 기본 글자체 */
							fontSize: "10pt", /* 기본 글자크기 */
							backgroundColor: "#fff", /*기본 배경색 */
							lineHeight: "1.5", /*기본 줄간격 */
							padding: "8px", /* 위지윅 영역의 여백 */
							boxSizing: "border-box",
							height: "100vh"
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
					}
				};
				
				if (args)
					$.extend(config, args);		
				
				return config;
			}
		};
	});
});
