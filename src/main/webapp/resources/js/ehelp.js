


$(function() {
	
	$.ajax({
        type:"POST", 
        url: getUrl("/resources/jquery/daumeditor-7.5.9/editor_template2.html"),
        success: function(data){
        	$("#editorTd").html(data);
        	setConfigEdit();
        }, 
        error : function(request, status, error) {
			alert("에러");
		}
	});
});

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
			txDecoPath: getUrl("/resources/jquery/daumeditor-7.5.9/images/deco/contents/"), /*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
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
			}
		};
	
	EditorJSLoader.ready(function(Editor) {
		editor = new Editor(config);
	});
}