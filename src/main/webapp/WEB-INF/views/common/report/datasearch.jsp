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
<%-- 데이터조회 화면이다.                                                      		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/include/xlsx.core.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/include/Blob.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/include/FileSaver.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/include/tableexport.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/common/report/datasearch.js" />"></script>
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



	$("#excel-button111").click(function(){

		$(".button-default").remove();

		$("#account-layout > div.panel.datagrid.easyui-fluid > div > div.datagrid-view > div.datagrid-view2").tableExport({
	        formats: ['xlsx'],
	        filename:"DataSearch"
	    });

		$(".button-default").hide();

		$("#account-layout > div.panel.datagrid.easyui-fluid > div > div.datagrid-view > div.datagrid-view2 > div.datagrid-header").css("margin-top", "-16px");

		$(".button-default").click();
	})

});

</script>
<style>
#excel-button111, #excel-button111 .l-btn-text { width: 130px;}
</style>
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
<table id="search-grid">
	<thead>
		<tr>
			<th data-options="field:'data1',	width:100, halign:'center', align:'center',   data_item:'GRD_001', sortable:true">Data1</th>
			<th data-options="field:'data2',	width:100, halign:'center', align:'center',   data_item:'GRD_002', sortable:true">Data2</th>
			<th data-options="field:'data3',	width:100, halign:'center', align:'center',   data_item:'GRD_003', sortable:true">Data3</th>
			<th data-options="field:'data4',	width:100, halign:'center', align:'center',   data_item:'GRD_004', sortable:true">Data4</th>
			<th data-options="field:'data5',	width:100, halign:'center', align:'center',   data_item:'GRD_005', sortable:true">Data5</th>
			<th data-options="field:'data6',	width:100, halign:'center', align:'center',   data_item:'GRD_006', sortable:true">Data6</th>
			<th data-options="field:'data7',	width:100, halign:'center', align:'center',   data_item:'GRD_007', sortable:true">Data7</th>
			<th data-options="field:'data8',	width:100, halign:'center', align:'center',   data_item:'GRD_008', sortable:true">Data8</th>
			<th data-options="field:'data9',	width:100, halign:'center', align:'center',   data_item:'GRD_009', sortable:true">Data9</th>
			<th data-options="field:'data10',	width:100, halign:'center', align:'center',   data_item:'GRD_010', sortable:true">Data10</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">

<!-- fieldset 변경 20190628 박소현 -->
	<form id="search-form">
		<fieldset class="Remake-div-line-new wd-100">
            <table cellpadding="7" class="search-table tableSearch-c">
            	<!-- topnav2 영역 -->
            	<tr class="topnav_sty">
            		<td colspan="5">
            			<div>
            				<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
            				<div>
								<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}" >Execution</a>
							</div>
            			</div>
            		</td>
            	</tr>
            	
	            <tr>
	            	<th class="h table-Search-h" style="text-align:left;width:0%;"><span></span></th>
					<!-- <th class="h table-Search-h" style="text-align:  left;"><span data-item="LAB_004">- System</span></th> -->
					<th class="h table-Search-h" style="text-align:left;width:23%;height:35px;"><span data-item="LAB_004">- Group</span></th>
					<th class="h table-Search-h" style="text-align:left;width:66%;">
						<span data-item="LAB_005">- Parameter(Binding)</span>
					</th>
					<th class="h table-Search-h" style="width:10%;">
						<span></span>
					</th>
					<th class="h table-Search-h" style="text-align:left;width:20px;"><span></span></th>
	            </tr>
	            <!-- <tr>
	            	<td class="d" style="width:10%">
					</td>
					<td class="d" style="width:10%">
						<select class="easyui-combobox" name="s_SystemType" ID="s_SystemType" style="width:200px" data-options="panelHeight:'auto',onChange: SystemToJobType"/>
							<option value="">Select.</option>
							<option value="IMMES">LSTA</option>
						</select>
					</td>
					<td class="d" style="width:60%;padding-left: 1053px;">
						<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}" >Execution</a>
					</td>
					<td class="d" style="width:50%">
					</td>
	            </tr> -->
	            <!-- <tr>
	            	<th class="h"><span></span></th>
					<th class="h table-Search-h"><span data-item="LAB_004">- Group</span></th>
					<th class="h"><span></span></th>
					<th class="h"><span></span></th>
	            </tr> -->
	            <tr>
	            	<td class="d"></td>
					<td class="d">
						<select class="easyui-datalist" name="s_JobType" ID="s_JobType" style="width:100%; min-width: 200px;" size='10' /></select>
					</td>
					<td class="d">
						<table id="parameter-grid">
							<thead>
								<tr>
									<th data-options="field:'parameterCode',hidden:true">Parameter Name</th>
									<th data-options="field:'parameterName',	width:200, halign:'left', align:'left',   data_item:'GRD_001', sortable:true">Parameter Name</th>
									<th data-options="field:'parameterValue',	width:200, halign:'left', align:'left', editor:{type:'textbox'},   data_item:'GRD_002', sortable:true">value</th>
									<th data-options="field:'parameterDesc',	width:300, halign:'left', align:'left',   data_item:'GRD_003', sortable:true">Parameter Detail</th>
									<th data-options="field:'parameterInitVal',	width:300, halign:'left', align:'left',   data_item:'GRD_004', sortable:true">Initial value</th>
								</tr>
							</thead>
						</table>
					</td>
					<td class="d"></td>
					<td class="d"></td>
	            </tr>
				<input type="hidden" name="sysId" id="sysId" />
				<input type="hidden" name="jobNo" id="jobNo" />
				<c:forEach var="i" begin="0" end="20" step="1">
			  	<input type="hidden" name="data${i}" id="data${i}" />
			    </c:forEach>
					<%-- <td>
					</td>
					<td style="width:100%">
						<table cellpadding="5" class="search-table tableSearch-c" style="width:80%">
				            <tr>
								<th class="h table-Search-h" style="text-align:  left;"><span data-item="LAB_004">- 정보입력(바인딩)</span></th>
				            </tr>
				            <tr>
								<td class="d" style="text-align:  right;">
									<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}" >검색</a>
								</td>
				            </tr>
				        </table>
						<table id="parameter-grid">
								<thead>
									<tr>
										<th data-options="field:'parameterCode',hidden:true">Parameter 명</th>
										<th data-options="field:'parameterName',	width:200, halign:'center', align:'left',   data_item:'GRD_001', sortable:true">Parameter 명</th>
										<th data-options="field:'parameterValue',	width:100, halign:'center', align:'center', editor:{type:'textbox'},   data_item:'GRD_002', sortable:true">value</th>
										<th data-options="field:'parameterDesc',	width:300, halign:'center', align:'left',   data_item:'GRD_003', sortable:true">Parameter 상세</th>
									</tr>
								</thead>
							</table>
					</td> --%>
	        </table>
	      </fieldset>
	        <!-- <div class="div-line"></div> -->
	      <fieldset class="div-line-new-sub">
	        <table cellpadding="5" class="search-table  tableEtc-c" style="width:100%;">
	            <tr>
					<td class="h" style="width:600px">
						<a href="javascript:void(0)" style="margin-left: 10px;" class="easyui-linkbutton c4" id="excel-button111" data-item="BTN_004">
							Excel Download&nbsp;
							<img style="width:16px; height:16px;" src="<%=request.getContextPath() %>/resources/images/excel_download.png" />
						</a>
					</td>
	            </tr>
	        </table>
		</fieldset>
	</form>
	<form id="parameter-form" method="post">
			<fieldset>
				<input type="hidden" name="d_sysId" id="d_sysId" />
				<input type="hidden" name="d_jobNo" id="d_jobNo" />
			</fieldset>
		</form>
</div>


<!-- [LAYOUT] end -->
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
