$(function() {
	fileuploadForm.init();
	doHeplSearch();
 });

function doHeplSearch(){
	var emenukey = $("#h_eHelpMenuKey").val();
    $.ajax({
        url: getUrl('/common/board/help/getHelpList.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {emenukey:emenukey},
        success: function(data){
        	if(data.rows.length > 0){
            	$("#v_bordTitle").html(data.rows[0].bordTitle2);
            	$("#v_regiName").html(data.rows[0].regiName);
            	$("#v_readCnt").html(data.rows[0].readCnt);
            	$("#v_regiDate").html(data.rows[0].regiDate);
            	$("#v_chngDate").html(data.rows[0].chngDate);
            	$("#v_bordText").html(data.rows[0].bordText);
            	$("#h_atchNo").val(data.rows[0].bordNo);
            	$("#h_atchGrup").val(data.rows[0].bordGrup);
        	}
        	fileuploadForm.easygrid.search();
        },
        error: function(){
        }
    });
}

var fileuploadForm = {
		sysId:    gconsts.SYS_ID,    //시스템ID (common.jsp)
		//title:    gconsts.TITLE,     //화면제목 (common.jsp)
		pageSize: gconsts.PAGE_SIZE, //출력수 (common.jsp)
		easygrid: false, //기본컨트롤
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
		init: function() {

			//기본 컨트롤 컴포넌트 초기화
			this.easygrid = new jeasygrid({
				url:      this.url,
				//title:    this.title, //20160921 김원국
				gridKey:  "#select-fileupload",
				//formKey:  "#regist-form",
				sformKey: "#search-file-form"
			});
			//그리드 생성
			this.easygrid.init({
				fit: true,
				singleSelect: true,
				pageSize: this.pageSize,
				idField:  'codeCd',
				pagination:   false,
				//행선택시 상세조회 이벤트 바인딩
				//onSelect: this.easygrid.select,
				singleSelect: true,
				onClickCell: function(index, field, value) {
					if (field == 'fileDown') {
						var rows = $(this).datagrid('getRows');
						var row  = rows[index];

						if (row.exist != true) {
							$.messager.alert("Error", msg.MSG0113, 'error');
							return;
						}
						//obj.download(row.index);   //파일 다운
						var url = fileuploadForm.url.download+"?index="+row.index;
						window.location.href = url;
					}

				},
				onLoadSuccess:function(){

					doLangSettingPopEHelpTable();
				}

			});

		}
	};