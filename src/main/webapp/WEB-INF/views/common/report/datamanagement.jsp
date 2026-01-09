<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)user.jsp 1.0 2014/08/12                                            --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 데이터관리 화면이다.                                                      		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/report/datamanagement.js?v=0519C" />"></script>
<script type="text/javascript">
doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
</script>
<script>

$(function(){

	$("#append-button").click(function(){
		if(window.innerWidth<1400){

			//alert("call");
			$(".window #regist-popup").css("height",390);
			$(".window-shadow").css("height",390);
			$("#regist-form fieldset").css("height",345);
			$("#regist-form fieldset").css("overflow-y","scroll");
			$("#regist-form fieldset").css("overflow-x","hidden");
			$(".window").addClass("forcedLeft");
			$(".window-shadow").addClass("forcedLeft");
			$("#regist-popup .div-line-new-sub").css("border-top","1px solid #ccc")
		}
	});

});

</script>
</head>
<!-- 다음 우편번호 검색 팝업 -->

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:9021;-webkit-overflow-scrolling:touch;">
	<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:9020" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>

<script>
    // 우편번호 찾기 화면을 넣을 element
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_layer.style.display = 'none';
    }

    function execDaumPostCode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('r_addNo').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('r_address').value = fullAddr;

                document.getElementById('r_address').focus();
                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%'
        }).embed(element_layer);

        // iframe을 넣은 element를 보이게 한다.
        element_layer.style.display = 'block';

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();
    }


    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition(){
        var width = 300; //우편번호 서비스가 들어갈 element의 width
        var height = 460; //우편번호 서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid #000';


        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }

</script>

<style>
#account-layout{min-width:970px !important;}
.forcedLeft{left:2px !important;top:2px !important;}
.popuptitle{
    font-size: 14px;
    font-weight: bold;
    /* color: #654b24; */
    /* color: #fff; */
    height: 30px;
    line-height: 30px;
}
#report-button-pdf .l-btn-text{
	width: 100px;
}
.search-label-h {width:10%;}
</style>
<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">

	<!-- 북쪽 영역: 툴바 + 그리드 + SQL -->
	<div data-options="region:'north',border:false" style="height:60%;">
		
		<!-- 툴바 -->
		<div id="search-toolbar" class="wui-toolbar">
			<form id="search-form">
				<!-- <fieldset class="div-line-new" style="padding-left:20px;"> -->
				<fieldset class="Remake-div-line-new" >
			        <table cellpadding="5" class="search-table tableSearch-c wd-100" >
			        	<tr class="topnav_sty">
		            		<td colspan="10" >
		            			<div>
			            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
			            			<div>
									<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}">Search</a>
									<input type="hidden" id="hdfIndex" value="-1" />
									<input type="hidden" id="hdfChk" value="" />
									<input type="hidden" name="parentRowIndex" id="parentRowIndex" value="" />
		                        </div>
	                        </div>
		            		</td>
		            	</tr>
		            	
			            <tr>
							<th class="h table-Search-h-right search-label-h" data-item="LAB_001"><span>Job No</span></th>
							<td class="d"><input class="easyui-textbox" name="searchJobNo" id="searchJobNo" style="width:150px;height:30px;" /></td>
							<th class="h table-Search-h-right search-label-h" data-item="LAB_002"><span>Description</span></th>
							<td class="d"><input class="easyui-textbox" name="searchDesc" id="searchDesc" style="width:150px;height:30px;" /></td>
			            </tr>
			        </table>
		   </fieldset>

				<!-- <div class="div-line-new"></div>  -->
			    <fieldset class="div-line-new-sub grd-div-btn">
			        <table cellpadding="5" class="search-table tableEtc-c wd-100" >
			            <tr>
							<td class="h">
								<div class="dis_flex_gap4" >
									<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:false">Add</a>
									<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_002" data-options="disabled:false">Save</a>
									<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}">Del</a>
								    <a href="javascript:void(0)" class="easyui-linkbutton c4" id="excel-button" data-item="BTN_004">
								    	Excel Download&nbsp;
								    	<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/excel_download.png" />
								    </a>
									<a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_005">Clear</a>
									<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-sql-button" data-item="BTN_002" data-options="disabled:false">Save</a>
								</div>
							</td>
			            </tr>
			        </table>
			        <!--  <div class="div-line"></div> -->
				</fieldset>
			</form>
		</div>

		<div style="display: flex; width: 100%; height: calc(100% - 150px); box-sizing: border-box; padding: 10px 10px 0 10px;">
			<!-- 좌측 그리드 -->
			<div style="flex: 1; padding-right: 10px;">
				<table id="search-grid">
					<thead>
						<tr>
							<th data-options="field:'ck', checkbox:true"></th>
							<th data-options="field:'jobNo', width:120, halign:'center', align:'center', data_item:'GRD_001'">Job No</th>
							<th data-options="field:'jobType1', width:120, halign:'center', align:'center', editor:{type:'textbox'}, data_item:'GRD_002', sortable:true">Type1</th>
							<th data-options="field:'jobType2', width:120, halign:'center', align:'center', editor:{type:'textbox'}, data_item:'GRD_003', sortable:true">Type2</th>
							<th data-options="field:'jobDesc', width:150, halign:'center', align:'center', editor:{type:'textbox'}, data_item:'GRD_001'">Description</th>
							<th data-options="field:'authType', width:120, halign:'center', align:'left', editor:consts.combo.userType.editor(),formatter:consts.combo.userType.formatter(), data_item:'GRD_005', sortable:true">Auth Type</th>
							<th data-options="field:'authGroups', width:120, halign:'center', align:'left', editor:{type:'popupbox',options:{editable:true,onOpen:doOpenPopupGroup}}, data_item:'GRD_006', sortable:true">Auth Group</th>
							<th data-options="field:'authUsers', width:120, halign:'center', align:'left', editor:{type:'popupbox',options:{editable:true,onOpen:doOpenPopupUserId}}, data_item:'GRD_007', sortable:true">User</th>
							<th data-options="field:'authFunc', width:120, halign:'center', align:'left', editor:consts.combo.permissionControl.editor(),formatter:consts.combo.permissionControl.formatter(), data_item:'GRD_008', sortable:true">Auth Func.</th>
							<th data-options="field:'useYn', width:100, halign:'center', align:'center', editor:consts.combo.useYn.editor(),formatter:consts.combo.useYn.formatter(), data_item:'GRD_009', sortable:true">Use(Y/N)</th>
							<th data-options="field:'remk', width:300, halign:'center', align:'left', editor:{type:'textbox'}, data_item:'GRD_010', sortable:true">Remark</th>
						</tr>
					</thead>
				</table>
			</div>

			<!-- 우측 영역 -->
			<div style="flex: 1; display: flex; flex-direction: column; min-width: 600px;">
				<div style="flex: 1; display: flex; flex-direction: column;">
					<table class="popup-bottom-areaTable" style="flex: 1;">
						<tr style="height: 100%;">
							<th style="width:5%;"><span data-item="LAB_128">SQL</span></th>
							<td style="height: 100%;">
								<textarea name="cSql" id="cSql" style="height: 100%; width: 100%; resize: none; border: 0;"></textarea>
							</td>
						</tr>
					</table>
				</div>
		
<!-- 				SQL Save 버튼 영역
				<fieldset class="div-line-new-sub" style="margin-top: 5px;">
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-sql-button" data-item="BTN_002" data-options="disabled:false">Save</a>
				</fieldset> -->
		
			</div>
		</div>
	</div>

	<!-- 서브 그리드 영역 -->
	<div data-options="region:'center',border:false">
		<div id="search-sub-toolbar" class="wui-toolbar" style="width:100%;">
			<form id="search-sub-form" method="post">
				<fieldset class="div-line-new-sub">
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-detl-button" data-item="BTN_002" data-options="disabled:false">Add</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-detl-button" data-item="BTN_002" data-options="disabled:false">Save</a>
					<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-detl-button" data-item="BTN_003" data-options="disabled:${DEL}">Del</a>
				</fieldset>
				<input type="hidden" name="jobNo" id="jobNo" value="" />
			</form>
		</div>

		<table id="search-sub-grid">
			<thead>
				<tr>
					<th data-options="field:'jobNo', halign:'center', align:'center', width:120">Job No</th>
					<th data-options="field:'parameterCode', halign:'center', editor:{type:'textbox'}, align:'center', width:150">Parameter Code</th>
					<th data-options="field:'parameterName', halign:'center', editor:{type:'textbox'}, align:'center', width:150">Parameter Name</th>
					<th data-options="field:'parameterSeq', halign:'center', editor:{type:'textbox'}, align:'center', width:80">Seq</th>
					<th data-options="field:'parameterType', halign:'center', editor:{type:'textbox'}, align:'center', width:120">Type</th>
					<th data-options="field:'parameterLength', halign:'center', editor:{type:'textbox'}, align:'center', width:100">Length</th>
					<th data-options="field:'parameterDesc', halign:'center', editor:{type:'textbox'}, align:'center', width:300">Description</th>
					<th data-options="field:'parameterInitVal', halign:'center', editor:{type:'textbox'}, align:'center', width:250">Initial value</th>
				</tr>
			</thead>
		</table>
	</div>
<!-- [LAYOUT] end -->
</div>

<!-- 권한그룹 팝업 -->
<div id="group-dialog" class="wui-dialog"	style="display:none">
	<table style="width:100%">
		<tr>
			<td>
				<div id="group-toolbar" class="wui-toolbar" style="width:220px;">
					<form id="group-form" method="post">
						 <fieldset class="div-line-new-sub">
							   <span class="popuptitle">Auth Group List</span>
						</fieldset>
						<input type="hidden" name="group" id="group" value="" />
					</form>
				</div>
				<div data-options="region:'south',border:false" style="width:220px;height:257px">
					<table id="group-grid">
						<thead>
							<tr>
								<th data-options="field:'ck',checkbox:true,halign:'center',align:'center'"></th>
								<th data-options="field:'groupId',		halign:'center',width:80,data_item:'GRD_024'">Group Code</th>
								<th data-options="field:'groupName',		halign:'center',width:80,data_item:'GRD_024'">Group Name</th>
							</tr>
						</thead>
					</table>
				</div>
			</td>
			<td>
				<a href="javascript:void(0)" id="group_right_arow" style="padding:0 18px 0 18px;">
    				<img src="<c:url value="/resources/images/addr_right-arrow.jpg"/>" style="width:26px;">
    			</a>

    			<a href="javascript:void(0)" id="group_left_arow" style="padding:0 18px 0 18px;">
    				<img src="<c:url value="/resources/images/addr_left-arrow.jpg"/>" style="width:26px;margin-top:15px;">
    			</a>
			</td>
			<td>
				<div id="group-target-toolbar" class="wui-toolbar" style="width:220px;">
					<form id="group-target-form" method="post">
						 <fieldset class="div-line-new-sub">
							   <span class="popuptitle">Auth Group Target List</span>
						</fieldset>
						<input type="hidden" name="jobNo" id="jobNo_target2" value="" />
						<input type="hidden" name="groupTarget" id="groupTarget" value="" />
					</form>
				</div>
				<div data-options="region:'north',border:false" style="width:220px;height:257px">
					<table id="group-target-grid">
						<thead>
							<tr>
								<th data-options="field:'groupId',		halign:'center',width:80,data_item:'GRD_024'">Group Code</th>
								<th data-options="field:'groupName',		halign:'center',width:80,data_item:'GRD_024'">Group Name</th>
							</tr>
						</thead>
					</table>
			    </div>
			</td>
		</tr>
	</table>
</div>

<!-- 사용자 검색 팝업 -->
<div id="user-id-dialog" class="wui-dialog"	 style="display:none">
	<table style="width:100%">
		<tr>
			<td>
				<div id="user-id-toolbar" class="wui-toolbar" style="width:220px;">
					<form id="user-id-form" method="post">
						<fieldset class="div-line-new-sub">
							<span class="popuptitle">User List</span>
						</fieldset>
						<input type="hidden" name="userId" id="userId" value="" />
					</form>
				</div>
				<div data-options="region:'south',border:false" style="width:220px;height:257px">
					<table id="user-id-grid">
						<thead>
							<tr>
								<th data-options="field:'ck',checkbox:true,halign:'center',align:'center'"></th>
								<th data-options="field:'userId',		halign:'center',width:80,data_item:'GRD_024'">User Id</th>
								<th data-options="field:'userName',		halign:'center',width:80,data_item:'GRD_024'">Name</th>
							</tr>
						</thead>
					</table>
				</div>
			</td>
			<td>
				<a href="javascript:void(0)" id="userId_right_arow" style="padding:0 18px 0 18px;">
    				<img src="<c:url value="/resources/images/addr_right-arrow.jpg"/>" style="width:26px;">
    			</a>

    			<a href="javascript:void(0)" id="userId_left_arow" style="padding:0 18px 0 18px;">
    				<img src="<c:url value="/resources/images/addr_left-arrow.jpg"/>" style="width:26px;margin-top:15px;">
    			</a>
			</td>
			<td>
				<div id="user-id-target-toolbar" class="wui-toolbar" style="width:220px;">
					<form id="user-id-target-form" method="post">
						 <fieldset class="div-line-new-sub">
							   <span class="popuptitle">User Target List</span>
						</fieldset>
						<input type="hidden" name="userIdTarget" id="userIdTarget" value="" />
					</form>
				</div>
				<div data-options="region:'north',border:false" style="width:220px;height:257px">
					<table id="user-id-target-grid">
						<thead>
							<tr>
								<th data-options="field:'userId',		halign:'center',width:80,data_item:'GRD_024'">User Id</th>
								<th data-options="field:'userName',		halign:'center',width:80,data_item:'GRD_024'">Name</th>
							</tr>
						</thead>
					</table>
			    </div>
			</td>
		</tr>
	</table>
</div>


<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
