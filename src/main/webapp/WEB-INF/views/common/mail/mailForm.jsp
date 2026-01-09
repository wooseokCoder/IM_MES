<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@(#)user.jsp 1.0 2014/08/12

COPYRIGHT (C) 2011 C-NODE, INC.
ALL RIGHTS RESERVED.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
사용자관리 화면이다.

@author C-NODE
@version 1.0 2014/08/12
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<form id="regist-form" method="post">

	<fieldset>
		<input type="hidden" name="oper"      id="r_oper"   />
		<input type="hidden" name="sysId"     id="r_sysId"     value="${model.sysId}"   />
		<input type="hidden" name="bordNo"    id="r_bordNo"    value="${model.bordNo}"  />
		<input type="hidden" name="bordGrup"  id="r_bordGrup"  value="${model.bordGrup}"/>
		<input type="hidden" name="bordType"  id="r_bordType"  value="${model.bordType}"/>
		<input type="hidden" name="tgtUserId" id="r_tgtUserId" value="${model.tgtUserId}"/>
		<input type="hidden" name="mailType"  id="r_mailType"/>

		<table class="adjust-select mail-table-add">
			<!--
			<tr>
				<th><span>시작일:</span></th><td><input class="easyui-datebox" name="bordBgn" id="r_bordBgn"/></td>
				<th><span>종료일:</span></th><td><input class="easyui-datebox" name="bordEnd" id="r_bordEnd"/></td>
			</tr>
			-->
			<tr>
            	<th><p class="essential"></p><sapn data-popup="POP_LAB_001">수신</sapn></th>
            	<td>
            		<span class="custom-span" style="width:500px">
            			<input class="custom-textbox" name="mail_to" id="r_mail_to" />
            		</span>
            		<!-- <input type="button" id="button-addr" value="주소록 선택" /> -->
            		<a href="javascript:void(0)" class="easyui-linkbutton c6 l-btn l-btn-small" id="button-addr" data-popup="POP_BTN_001">주소록 선택</a>
            		<c:if test="${groupIdC eq 'DEVADMIN'}">
						<a href="javascript:langTextPopSave();">언어저장</a>
					</c:if>
            	</td>
            </tr>
            <tr>
            	<th style="height:33px;"><p class="essential"></p><sapn data-popup="POP_LAB_002">참조</sapn></th>
            	<td>
            		<span class="custom-span" style="width:500px">
            			<input class="custom-textbox" name="mail_cc" id="r_mail_cc" />
            		</span>
            	</td>
            </tr>
			<tr>
				<th style="height:33px;"><p class="essential"></p><span data-popup="POP_LAB_003" >제목</span></th>
				<td><input class="easyui-textbox" name="bordTitle" id="r_bordTitle" style="width:500px;"/></td>
			</tr>
			<tr>
				<td colspan="2" class="editor-background-color" style="padding:0px !important;">
					<div id="editor-area">
						<textarea name="bordText" id="r_bordText" class="sceditor wui-editor"></textarea>
					</div>
 				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="wui-upload">
						<div id="regist-fileupload" class="fileStyle2"></div>
					</div>
 				</td>
			</tr>
		</table>

	</fieldset>

</form>

<div id="address-popup" class="easyui-dialog" data-options="
	 	width: 750,
	 	height: 500,
	 	closed: true,
	 	title:'주소록 선택',
	 	iconCls:'icon-edit'
	 ">
	 <iframe id="address-iframe" src="" style="width:100%;height:100%;"></iframe>
</div>


<script type="text/javascript">

$(function() {

	jsystemboard.initForm({
		mode: "regist",
		//등록폼 KEY (#포함)
		formKey: "#regist-form",
		//첨부파일 레이어 KEY
		layoutKey: "regist-fileupload",
		//첨부파일 업로더 KEY
		loaderKey: "uploader",
		//첨부파일 INPUT 명칭
		fileName: "files",
		//Form Hidden Value 정의
		setHiddenValues: function(params) {

			$("#r_sysId"    ).val (params.sysId);
			$("#r_oper"     ).val (params.oper);
			$("#r_bordNo"   ).val (params.bordNo);
			$("#r_bordGrup" ).val (params.bordGrup);
			$("#r_bordType" ).val (params.bordType);
			$("#r_tgtUserId").val (params.tgtUserId);
		},
		//[WSC2.0] [2015.04 LSH] 웹에디터 설정 추가
		//웹에디터 레이어 ID
		editorLayer: "editor-area",
		//웹에디터 텍스트박스 ID
		editorBox:   "r_bordText",
		//웹에디터 폼 ID
		editorForm:  "regist-form"
	});

	$('#dialog-button-formSave span span').html("보내기");

	$("#r_mailType").val($("#addrType").val());

	$('#button-addr').bind("click", function(){
		//consts.dialog.open('등록');
		//document.getElementById("address-iframe").src = "/wsc/common/mail/address.do";
		var ifUrl = $("#addrType").val();
		document.getElementById("address-iframe").src = "/wsc/common/mail/" + ifUrl + ".do?menuKey="+$('#text_menuKey').val();
		//console.log(document.getElementById("address-iframe").src);

		$("#address-popup").dialog('open');

		//팝업위치 조정 2018-01-15 박상후
		var popupCustom = $("#address-popup").parent();
		var dynamicHeight = 0;
		var fixedHeight = 0;

		 dynamicWidth = window.innerWidth;
		 dynamicHeight = window.innerHeight;

		 resizeWidth = dynamicWidth/2 - 750/2;
		 resizeHeight = dynamicHeight/2 - 500/2;


			 if(dynamicWidth>800){

				 popupCustom.css("left",resizeWidth);
				 popupCustom.next(".window-shadow").css("left",resizeWidth);

			 }

			 if(dynamicHeight>700){

				 popupCustom.css("top",resizeHeight);
				 popupCustom.next(".window-shadow").css("top",resizeHeight);

			 }



	});

	doLangSettingPopTable();
});
</script>
